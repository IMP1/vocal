
class Options

    attr_reader :cell_action
    attr_reader :cell_ordering

    def action(&cell_action)
        @cell_action = cell_action
    end

    def ordering(&cell_ordering)
        @cell_ordering = cell_ordering
    end

end

module Vocal

    @@cells = {}
    @@priorities = []
    @@characters = {}
    @@orderings  = {}
    @@actions    = {}

    def self.EMPTY(*characters)
        characters.each do |char|
            @@cells[char] = Cell::Empty
        end
    end

    def self.WALL(*characters)
        characters.each do |char|
            @@cells[char] = Tile::Wall
        end
    end

    def self.TILE(tile_name, *characters, &setup)

        options = Options.new
        setup.call(options)

        tile_class = Class.new(Tile) do

            def self.ordering
                return @@orderings[self]
            end

            def self.characters
                return @@characters[self]
            end

            def self.action
                return @@actions[self]
            end

            def initialize(x, y)
                super(nil, @@characters[self.class].first, [x, y])
            end

            def dynamic?
                return false
            end

        end

        Object.const_set(tile_name.to_s, tile_class)

        characters.each do |char|
            @@cells[char] = tile_class
        end
        @@characters[tile_class] = characters
        @@orderings[tile_class] = options.cell_ordering
        @@actions[tile_class] = options.cell_action
        @@priorities.push(tile_class)
    end

    def self.ENTITY(entity_name, *characters, &action)

        options = Options.new
        setup.call(options)

        entity_class = Class.new(Entity) do

            def initialize(x, y, value=nil)
                super(value, characters.first, [x, y])
            end

            def dynamic?
                return true
            end

            def tick
                action.call(self)
            end

        end
        
        entity.const_set(entity_name.to_s, entity_class)

        characters.each do |char|
            @@cells[char] = entity_class
        end
        @@priorities.push(entity_class)
    end

    def self.PRIORITIES(priority_list)
        @@priorities = priority_list
    end

    def self.cells
        return @@cells
    end

    def self.priorities
        return @@priorities
    end

end
