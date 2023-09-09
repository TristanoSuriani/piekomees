function init_levels_arrays()
    local p = -1

    local level01 = {{ 3, p, 1 }}
    local level02 = {{ 2, p, 1 }}

    local test_level1 = {
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3 },
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1 },
        { 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1 },
        { 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1 },
        { 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 2, 1, 1, 1, 1, 1, p, 1, 1, 1, 1, 1, 1 },
    }

    local test_level2 = {
        { 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, p },
        { 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1 },
        { 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2 },
    }

    local level1 = {
        { 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3 },
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1 },
        { 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1 },
        { 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1 },
        { 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 2, 1, 1, 1, 1, 1, p, 1, 1, 1, 1, 1, 1 },
        { 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1 },
        { 1, 1, 1, 1, 2, 2, 2, 2, 2, 1, 1, 2, 1, 1 },
        { 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 2, 1, 1 },
        { 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 1 },
        { 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3 }
    }

    local level2 = {
       { 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, p },
       { 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
       { 1, 2, 3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1 },
       { 1, 2, 1, 1, 2, 2, 2, 2, 1, 1, 1, 2, 1, 1 },
       { 1, 2, 3, 1, 1, 3, 3, 2, 3, 4, 1, 2, 1, 1 },
       { 1, 2, 1, 1, 1, 1, 1, 2, 1, 3, 1, 1, 1, 1 },
       { 1, 2, 3, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1 },

   }

    return {
        level01,
        level02
    }
end

function create_level_from_level_array(level_array)
    local n = #level_array
    local first_column = level_array[1]
    local m = #first_column
    local screen_properties = constants.screen_properties
    local tile_size = constants.tile_size
    local grid = create_grid(screen_properties.x_offset, screen_properties.y_offset, tile_size, m, n)
    local grid_elements = constants.grid_elements
    local candies = {}
    local blocks = {}
    local enemies = {}
    local player = {}

    for i = 1, n, 1 do
        for j = 1, m, 1 do
            local cell = level_array[i][j]
            local x = screen_properties.x_offset + (j - 1) * tile_size
            local y = screen_properties.y_offset + (i - 1) * tile_size

            if cell == grid_elements.candy then
                candies[#candies + 1] = {
                    x = x,
                    y = y,
                    spr = 3
                }
            elseif cell == grid_elements.block then
                blocks[#blocks + 1] = {
                    x = x,
                    y = y,
                    spr = 4
                }
            elseif cell == grid_elements.enemy then
                enemies[#enemies + 1] = {
                    x = x,
                    y = y,
                    spr = 2
                }
            elseif cell == grid_elements.player then
                player = reset_player(x, y)
            end
        end
    end

    assert(player.x, "player is not set in level")

    return {
            blocks = blocks,
            candies = candies,
            player = player,
            enemies = enemies,
            grid = grid,
            initial_player_position = {
                x = player.x,
                y = player.y
            }
        }
end

function reset_player(x, y)
    return {
        spr = 1,
        x = x,
        y = y,
        dx = 2,
        dy = 2,
        powerup = {},
        direction = constants.directions.idle,
    }
end

function create_grid(x_offset, y_offset, tile_size, x_tiles, y_tiles)
    local tile_size = constants.tile_size
    local grid = {
        x_tiles = x_tiles,
        y_tiles = y_tiles,
        tile_size = tile_size,
        x0 = x_offset,
        x1 = x_offset + (x_tiles * tile_size),
        y0 = y_offset,
        y1 = y_offset + (tile_size * y_tiles)
    }

    grid.border = {
        x0 = grid.x0 - 1,
        x1 = grid.x1,
        y0 = grid.y0 - 1,
        y1 = grid.y1,
        colour = 10
    }

    grid.collide_border_top = function(thing)
        return thing.y <= grid.y0
    end

    grid.collide_border_bottom = function(thing)
        return thing.y >= grid.y1 - constants.tile_size
    end

    grid.collide_border_left = function(thing)
        return thing.x <= grid.x0
    end

    grid.collide_border_right = function(thing)
        return thing.x >= grid.x1 - constants.tile_size
    end

    return grid
end