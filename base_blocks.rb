require_relative 'cells'
require_relative 'vocal'

Vocal.EMPTY ' '

Vocal.WALL '.'

Vocal.TILE :ActiveInput, '£', 'Ϟ' do |options|
    options.action do |cell|
        any_changes = false
        x, y = *cell.position
        origin = [x, y - 1]
        target = [x, y + 1]
        if get_cell(*target).empty? and get_cell(*origin).dynamic?
            $stdout.puts("Enter Input: ")
            $stdout.print(">>> ")
            $stdout.flush
            value = eval($stdin.gets.chomp)
            unless value.nil?
                add_value(*target, value)
                any_changes = true
            end
        end
        any_changes
    end
end

Vocal.TILE :ArgInput, '$', 'α' do |options|
    options.action do |cell|
        any_changes = false
        x, y = *cell.position
        target = [x, y + 1]
        if get_cell(*target).empty?
            value = get_arg_input
            unless value.nil?
                add_value(*target, value)
                any_changes = true
            end
        end
        any_changes
    end
end

Vocal.TILE :Scanner, '*' do |options|
    options.action do |cell|
        any_changes = false
        x, y = *cell.position
        target = [x, y + 1]
        value = get_cell(*target)
        if value.is_a?(Value)
            add_output(value.value)
        end
        any_changes
    end
end 

Vocal.TILE :Discarder, 'Z', 'Ω' do |options|
    options.action do |cell|
        any_changes = false
        x, y = *cell.position
        (-1..1).map { |j| j + y }.each do |j|
            (-1..1).map { |i| i + x }.each do |i|
                next if j == y and i == x
                cell = get_cell(i, j)
                if cell.is_a?(Value)
                    clear_cell(i, j)
                    any_changes = true
                end
            end
        end
        any_changes
    end
end

Vocal.TILE :Adder, '+', '∑' do |options|
    options.action do |cell|
        any_changes = false
        x, y = *cell.position
        target = [x + 1, y + 1]
        origin_a = [x - 1, y + 1]
        origin_b = [x, y + 1]
        if get_cell(*target).empty?
            input_1 = get_cell(*origin_a)
            input_2 = get_cell(*origin_b)
            if input_1.is_a?(Value) and input_2.is_a?(Value) and 
            not input_1.moved and not input_2.moved
                result = input_1.value + input_2.value
                add_value(*target, result)
                clear_cell(*origin_a)
                clear_cell(*origin_b)
                any_changes = true
            end
        end
        any_changes
    end
    options.ordering do |cell|
        -cell.position[0]
    end
end

Vocal.TILE :Subtracter, '-', '∂' do |options|
    options.action do |cell|
        any_changes = false
        x, y = *cell.position
        target = [x + 1, y + 1]
        origin_a = [x - 1, y + 1]
        origin_b = [x, y + 1]
        if get_cell(*target).empty?
            input_1 = get_cell(*origin_a)
            input_2 = get_cell(*origin_b)
            if input_1.is_a?(Value) and input_2.is_a?(Value) and 
            not input_1.moved and not input_2.moved
                result = input_1.value - input_2.value
                add_value(*target, result)
                clear_cell(*origin_a)
                clear_cell(*origin_b)
                any_changes = true
            end
        end
        any_changes
    end
    options.ordering do |cell|
        -cell.position[0]
    end
end


Vocal.TILE :BeltRight, '>', '»' do |options|
    options.action do |cell|
        any_changes = false
        x, y = *cell.position
        cargo = get_cell(x, y - 1)
        if cargo.is_a?(Value)# and not cargo.moved
            if move_cell_horizontal(x, y - 1, 1)
                any_changes = true
            end
        end
        any_changes
    end
    options.ordering do |cell|
        -cell.position[0]
    end
end

Vocal.TILE :BeltLeft, '<', '«' do |options|
    options.action do |cell|
        any_changes = false
        x, y = *cell.position
        cargo = get_cell(x, y - 1)
        if cargo.is_a?(Value)# and not cargo.moved
            if move_cell_horizontal(x, y - 1, -1)
                any_changes = true
            end
        end
        any_changes
    end
    options.ordering do |cell|
        cell.position[0]
    end
end

Vocal.TILE :RampRight, '/', 'л' do |options|
    options.action do |cell|
        any_changes = false
        x, y = *cell.position
        entity = get_cell(x, y - 1)
        below = get_cell(x - 1, y)
        if entity.dynamic? and below.empty? and not entity.moved
            set_cell(x - 1, y, entity)
            clear_cell(x, y - 1)
            any_changes = true
            entity.moved = true
        end
        any_changes
    end
    options.ordering do |cell|
        -cell.position[1]
    end
end

Vocal.TILE :RampLeft, '\\', 'ι' do |options|
    options.action do |cell|
        any_changes = false
        x, y = *cell.position
        entity = get_cell(x, y - 1)
        below = get_cell(x + 1, y)
        if entity.dynamic? and below.empty? and not entity.moved
            set_cell(x + 1, y, entity)
            clear_cell(x, y - 1)
            any_changes = true
            entity.moved = true
        end
        any_changes
    end
    options.ordering do |cell|
        -cell.position[1]
    end
end

Vocal.TILE :Counter, '@', '©' do |options|
    options.action do |cell|
        any_changes = false
        x, y = *cell.position
        target = [x, y + 1]
        value = get_cell(*target)
        if value.is_a?(Value) and value.value > 0
            value.value -= 1
            if value.value == 0
                clear_cell(*target)
            end
            any_changes = true
        end            
        any_changes
    end
end

Vocal.TILE :Gate, ':', '⁞' do |options|
end

Vocal.TILE :GateControl, 'Y', 'Џ' do |options|
    options.action do |cell|
        any_changes = false
        x, y = *cell.position
        reference = get_cell(x, y - 1)
        gate = get_cell(x, y + 1)
        target = get_cell(x - 1, y + 1)
        if (target.is_a?(Value) and target.value == reference.value)
            if gate.is_a?(Tile)
                clear_cell(*gate.position)
                any_changes = true
            end
        elsif gate.empty?
            entity = Gate.new(x, y + 1)
            set_cell(x, y + 1, entity)
            any_changes = true
        end
        any_changes
    end
end