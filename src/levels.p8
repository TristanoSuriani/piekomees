function reset_player(grid)
    local player_state = {
        dead = 0,
        alive = 1,
    }

    player_state.current = player_state.alive
    return {
        spr = 1,
        x = (grid.x0 + grid.x1) / 2,
        y = (grid.y0 + grid.y1) / 2 - 4,
        dx = 2,
        dy = 2,
        powerup = init_powerup(),
        direction = direction.idle,
        state = player_state
    }
end

function init_powerup()
    return {
        none = 0
    }
end

function create_level(blocks, player, enemies, grid)
    return {
        blocks = blocks,
        candies = create_candies(blocks, player, enemies, grid),
        player = player,
        enemies = enemies
    }
end

function create_enemies(grid)
    return {
        create_enemy(grid.x0, grid.y0),
        create_enemy(grid.x0, grid.y1 - tile_size),
        create_enemy(grid.x1 - tile_size, grid.y0),
        create_enemy(grid.x1 - tile_size, grid.y1 - tile_size)
    }
end

function create_enemy(x, y)
    return {
        spr = 2,
        x = x,
        y = y,
        dx = 0.2,
        dy = 0.2,
        direction = direction.idle
    }
end

function create_blocks_level_1()
    local blocks = {}
    blocks = add_column_of_blocks(blocks, 16, 40, 7)
    blocks = add_row_of_blocks(blocks, 40, 32, 8)
    blocks = add_column_of_blocks(blocks, 96, 32, 4)
    blocks = add_column_of_blocks(blocks, 96, 80, 4)
    blocks = add_column_of_blocks(blocks, 16, 32, 8)
    blocks = add_row_of_blocks(blocks, 72, 104, 3)
    blocks = add_column_of_blocks(blocks, 72, 88, 3)
    blocks = add_row_of_blocks(blocks, 40, 88, 4)
    blocks = add_column_of_blocks(blocks, 40, 88, 3)
    return blocks
end

function create_candies(blocks, player, enemies, grid)
    local candies = {}
    local i = 0
    for x = grid.x0, grid.x1 - 1, tile_size do
        for y = grid.y0, grid.y1 - tile_size, tile_size do
            if not is_tile_occupied(blocks, player, enemies, x, y) then
                i += 1
                candies[i] = {
                    x = x,
                    y = y,
                    spr = 3
                }
            end
        end
    end
    return candies
end

function add_column_of_blocks(blocks, x, y, length)
    local nOfBlocks = #blocks
    for i = 1, length - 1, 1 do
        blocks[nOfBlocks + i] = {
            x = x,
            y = y + tile_size * (i - 1),
            spr = 4
        }
    end
    return blocks
end

function add_row_of_blocks(blocks, x, y, length)
    local nOfBlocks = #blocks
    for i = 1, length, 1 do
        blocks[nOfBlocks + i] = {
            x = x + tile_size * (i - 1),
            y = y,
            spr = 4
        }
    end
    return blocks
end

function is_tile_occupied(blocks, player, enemies, x, y)
    local width, height = 4, 4 -- Assuming the width and height of each sprite

    local function collides(a, b)
        return a.x < b.x + width and
               a.x + width > b.x and
               a.y < b.y + height and
               a.y + height > b.y
    end

    local candy = { x = x, y = y }

    -- Check Blocks
    for i, block in pairs(blocks) do
        if collides(block, candy) then
            return true
        end
    end

    -- Check Player
    if collides(player, candy) then
        return true
    end

    -- Check Enemies
    for i, enemy in pairs(enemies) do
        if collides(enemy, candy) then
            return true
        end
    end

    return false
end
