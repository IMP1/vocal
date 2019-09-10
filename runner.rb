module Vocal; class Runner

    def initialize(initial_world, world_name, args=nil, options=nil)
        @world = initial_world.strip.split("\n").map.with_index do |row, j|
            row.split("").map.with_index do |char, i|
                new_cell(char, i, j)
            end
        end
        @options = options || {}
        @delay = @options[:delay] || 0.1
        @tracing = @options[:trace] || false

        @name = world_name
        @input = [*args]
        @output = []
        @debug = []

        validate_world
    end

    def validate_world
    end

    def run
        setup
        draw
        loop do
            begin
                changes = tick
                break if not changes
                draw
                sleep(@delay)
            rescue SignalException
                break
            end
        end
        draw
        finish
    end

    def setup
    end

    def draw
        unless @tracing
            system("clear") || system("cls")
        end
        $stdout.puts "\n"
        @world.each do |row|
            $stdout.puts row.map { |cell| cell.glpyh }.join("")
        end
        $stdout.flush
    end

    def finish
        unless @output.empty?
            $stdout.puts "\n"
            @output.each do |output|
                $stdout.print(output)
            end
            $stdout.print "\n"
        end
        unless @debug.empty?
            $stdout.puts "\n"
            $stdout.puts @debug.join("\n")
        end
        $stdout.flush
    end

    def tick
        any_changes = false
        all_cells = @world.flatten

        # Reset
        all_cells.each do |cell|
            cell.moved = false
        end

        # Run
        Vocal.priorities.each do |cell_class|
            cells = all_cells.select { |cell| cell.is_a?(cell_class) }
            if cell_class.ordering
                cells = cells.sort_by(&cell_class.ordering)
            end
            if cell_class.action
                cells.each do |cell|
                    changes = self.instance_exec(cell, &cell_class.action)
                    any_changes ||= changes
                end
            end
        end
        #---
        # Gravity
        #---
        all_cells.select { |cell| cell.dynamic? }
                 .sort_by { |cell| -cell.position[1] }
                 .each do |entity|
            x, y = *entity.position
            below = get_cell(x, y + 1)
            if below.empty?
                set_cell(x, y + 1, entity)
                clear_cell(x, y)
                any_changes = true
                entity.moved = true
            end
        end
        return any_changes
    end

    def get_arg_input
        return @input.shift
    end

    def new_cell(char, i, j)
        if /[\da-fA-F]/ === char
            return Value.new(char.to_i(16), char, [i, j])
        else
            cell_class = Vocal.cells[char] || Tile::Wall
            return cell_class.new(i, j)
        end
    end

    def get_cell(x, y)
        return Tile::Wall.new(x, y) if y < 0 or y >= @world.size
        return Tile::Wall.new(x, y) if x < 0 or x >= @world[y].size
        return @world[y][x]
    end

    def set_cell(x, y, cell)
        return if y < 0 or y >= @world.size
        return if x < 0 or x >= @world[y].size
        @world[y][x] = cell
        cell.update_position(x, y)
        cell.moved = true
    end

    def clear_cell(x, y)
        set_cell(x, y, Cell::Empty.new(x, y))
    end

    def add_value(x, y, value)
        glpyh = Value.get_glyph(value)
        cell = Value.new(value, glpyh, [x, y])
        set_cell(x, y, cell)
        cell.moved = true
    end

    def add_output(value)
        @output.push(value)
    end

    def log(message)
        @debug.push(message)
    end

    def move_cell_horizontal(x, y, dx)
        value = get_cell(x, y)
        return false if value.empty?
        target = [x + dx, y]
        if get_cell(*target).empty?
            set_cell(*target, value)
            clear_cell(x, y)
            return true
        # TODO: add pushing up ramps
        # elsif (get_cell(*target).type == :ramp_right and dx > 0) or 
              # (get_cell(*target).type == :ramp_left and dx < 0)
            # if get_cell(x + dx, y - 1).empty?
                # set_cell(x + dx, y - 1, value)
                # clear_cell(x, y)
                # return true
            # end
        end
        return false
    end

end; end