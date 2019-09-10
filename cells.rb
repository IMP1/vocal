class Cell

    attr_reader :glpyh
    attr_reader :value
    attr_reader :position

    attr_accessor :moved

    def initialize(value, glpyh, position)
        @value = value
        @glpyh = glpyh
        @position = position
        @moved = false
    end

    def dynamic?
        return self.is_a?(Entity)
    end

    def empty?
        return self.is_a?(Empty)
    end

    def copy
        return self.class.new(@value, @glpyh, @position)
    end

    def update_position(x, y)
        @position = [x, y]
    end

    class Empty < Cell
        def initialize(x, y)
            super(nil, " ", [x, y])
        end
    end

    # Available characters on a Windows console.
    # https://www.fileformat.info/info/unicode/font/consolas/grid.htm

end

class Tile < Cell

    class Wall < Tile
        def initialize(x, y)
            super(nil, ".", [x, y])
        end
    end

end

class Entity < Cell

end

class Value < Entity

    VALUE_GLPYHS = {
        0 => "0",
        1 => "1",
        2 => "2",
        3 => "3",
        4 => "4",
        5 => "5",
        6 => "6",
        7 => "7",
        8 => "8",
        9 => "9",
        10 => "A",
        11 => "B",
        12 => "C",
        13 => "D",
        14 => "E",
        15 => "F",
    }

    def self.get_glyph(value)
        if value.is_a?(Numeric)
            if Value::VALUE_GLPYHS.has_key?(value)
                return Value::VALUE_GLPYHS[value]
            else
                return "N"
            end
        elsif value.is_a?(String)
            return "\""
        else
            return "#"
        end
    end

    def value=(new_value)
        @value = new_value
        if new_value.is_a?(Numeric)
            @glpyh = Value.get_glyph(new_value)
        end
    end

end

=begin


    def self.parse_tile(char, x, y)
        case char
        when "$", "α"
            return Tile.new(:passive_input, nil, char, [x, y])
        when "£", "Ϟ"
            return Tile.new(:active_input, nil, char, [x, y])
        when "*"
            return Tile.new(:scanner, nil, char, [x, y])
        when "Z", "Ω"
            return Tile.new(:furnace, nil, char, [x, y])
        when ">", "»"
            return Tile.new(:belt_right, nil, char, [x, y])
        when "<", "«"
            return Tile.new(:belt_left, nil, char, [x, y])
        when "i", "¡"
            return Tile.new(:copy_up, nil, char, [x, y])
        when "!"
            return Tile.new(:copy_down, nil, char, [x, y])
        when "?", "®" # Change for "№" ?
            return Tile.new(:random, nil, char, [x, y])
        when "&", "↔"
            return Tile.new(:turning_point, nil, char, [x, y])
        when "["
            return Entity.new(:bulldozer_right, nil, char, [x, y])
        when "]"
            return Entity.new(:bulldozer_left, nil, char, [x, y])
        when "/"
            return Tile.new(:ramp_right, nil, char, [x, y])
        when "\\"
            return Tile.new(:ramp_left, nil, char, [x, y])
        when "+", "∑"
            return Tile.new(:adder, nil, char, [x, y])
        when "-", "∂"
            return Tile.new(:subtracter, nil, char, [x, y])
        when "%", "∆"
            return Tile.new(:sorter, nil, char, [x, y])
        when "#", "╫"
            return Tile.new(:door, nil, char, [x, y])
        when "~", "─"
            return Tile.new(:barrier, nil, char, [x, y])
        when "@", "©"
            return Tile.new(:counter, nil, char, [x, y])
        when "M"
            return Tile.new(:swinch_up, nil, char, [x, y])
        when "W"
            return Tile.new(:swinch_down, nil, char, [x, y])
        when "^", "˄" # TODO: unimplemented
            return Tile.new(:pipe_up, nil, char, [x, y])
        when "V", "˅" # TODO: unimplemented
            return Tile.new(:pipe_down, nil, char, [x, y])
        when ":", "⁞" # TODO: unimplemented
            return Tile.new(:bulldozer_up, nil, char, [x, y])

        when "X", "¤"
            return Tile.new(:converter, nil, char, [x, y])

        when /\d/
            return Value.new(:data, char.to_i, char, [x, y])
        when 'A'..'F'
            return Value.new(:data, char.to_i(16), char, [x, y])
        when " "
            return empty(x, y)
        else
            return wall(x, y)
        end
    end


=end