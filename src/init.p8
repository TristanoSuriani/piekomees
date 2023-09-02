function _init()
    controls = {
        up = 2,
        down = 3,
        left = 0,
        right = 1,
        z = 4,
        x = 5,
    }

    tile_size = 8

    backgrounds = {
        waiting = 5,
        in_progress = 3,
        game_over = 8,
        completed = 2,
        life_lost = 1
    }

    direction = {
        up = 0,
        down = 1,
        left = 2,
        right = 3
    }

    reset_game_data()
end

function reset_game_data()
    local title = "lasciate ogni speranza \nvoi che entrate"

    local state = {
        waiting = 0,
        in_progress = 1,
        game_over = 2,
        completed = 3,
        life_lost = 4
    }

    state.current = state.waiting

    local grid = create_grid(8, 16, 8, 14, 13)
    local player = reset_player(grid)

    local border = grid.border
    -- local blocks = create_blocks_level_1()
    local blocks = {}
    local level = create_level(blocks, player, create_enemies(grid), grid)

    local map = {
        x = 0,
        y = 0
    }

    game_data = {
        background = background,
        title = title,
        state = state,
        powerup = powerup,
        player = player,
        grid = grid,
        border = border,
        level = level,
        score = 0,
        lives = 3,
        map = map
    }
end
