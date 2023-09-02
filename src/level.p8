function create_level(grid)
    local cursor = { x_tiles = 0, y_tiles = 0 }
    local enemies = {}
    local blocks = {}

    local dsl = {}

    -- Set Cursor Position
    dsl.set_cursor = function(x_tiles, y_tiles)
        -- Add some basic error handling
        if x_tiles >= 0 and x_tiles <= grid.x_tiles and y_tiles >= 0 and y_tiles <= grid.y_tiles then
            cursor.x_tiles = x_tiles
            cursor.y_tiles = y_tiles
        else
            error("Cursor out of bounds")
        end
        return dsl
    end

    local function place_object(number, object, direction_function)
        for i = 1, number do
            local position = direction_function(cursor.x_tiles, cursor.y_tiles, i)
            table.insert(object == "enemy" and enemies or blocks, position)
        end
    end

    local function place_right(x, y, i) return { x = x + i, y = y } end
    local function place_left(x, y, i) return { x = x - i, y = y } end
    local function place_above(x, y, i) return { x = x, y = y - i } end
    local function place_below(x, y, i) return { x = x, y = y + i } end

    dsl.place = function(number, object, direction)
        local direction_function = ({ right = place_right, left = place_left, above = place_above, below = place_below })[direction]

        if direction_function then
            place_object(number, object, direction_function)
        else
            error("Invalid direction")
        end
        return dsl
    end

    return dsl
end
