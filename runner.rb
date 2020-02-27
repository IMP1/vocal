module Vocal; class Runner

    def initialize(initial_world, world_name, args=nil, options=nil)
        @world = initial_world.split("\n").map.with_index do |row, j|
            row.split("").map.with_index do |char, i|
                new_cell(char, i, j)
            end
        end
        @options = options || {}
        @delay = @options[:delay] || 0.1
        @tracing = @options[:trace] || false
        @output_target = @options[:output] || $stdout
        @frames_directory = @options[:frames] || nil
        @current_frame = 0

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
                sleep(@delay)
            rescue SignalException
                break
            end
        end
        finish
    end

    def setup
    end

    def draw
        unless @tracing
            system("clear") || system("cls")
        end
        if @frames_directory
            File.open(File.join(@frames_directory, "frame_#{@current_frame}.vocal"), 'w') do |f|
                draw_world(f)
            end
            @current_frame += 1
        else
            draw_world(@output_target)
            @output_target.flush
        end
    end

    def draw_world(target)
        @world.each do |row|
            target.puts row.map { |cell| cell.glpyh }.join("")
        end
        target.puts "\n"
    end

    def finish
        unless @output.empty?
            @output_target.puts "\n"
            @output.each do |output|
                @output_target.print(output)
            end
            @output_target.print "\n"
        end
        unless @debug.empty?
            @output_target.puts "\n"
            @output_target.puts @debug.join("\n")
        end
        @output_target.flush
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
            changes = false
            cells = all_cells.select { |cell| cell.is_a?(cell_class) }
            if cell_class.ordering
                cells = cells.sort_by(&cell_class.ordering)
            end
            if cell_class.action
                cells.each do |cell|
                    changes ||= self.instance_exec(cell, &cell_class.action)
                end
            end
            draw if (changes and @tracing)
            any_changes ||= changes
        end
        #---
        # Gravity
        #---
        all_cells.select { |cell| cell.dynamic? }
                 .sort_by { |cell| -cell.position[1] }
                 .each do |entity|
            x, y = *entity.position
            below = get_cell(x, y + 1)
            if below.empty? and not entity.moved
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
            value.moved = true
            return true
        elsif (get_cell(*target).is_a?(RampRight) and dx > 0) or 
              (get_cell(*target).is_a?(RampLeft) and dx < 0)
            if get_cell(x + dx, y - 1).empty?
                set_cell(x + dx, y - 1, value)
                clear_cell(x, y)
                value.moved = true
                return true
            end
        end
        return false
    end

end; end