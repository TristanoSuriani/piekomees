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
        in_progress = 0,
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

    screen_properties = {
        x_offset = 8,
        y_offset = 16
    }

    grid_elements = {
        player = -1,
        nothing = 0,
        candy = 1,
        block = 2,
        enemy = 3
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

    local levels_arrays = init_levels_arrays()
    local level = create_level_from_level_array(levels_arrays[1])
    local map = {
        x = 0,
        y = 0
    }

    game_data = {
        background = background,
        title = title,
        state = state,
        powerup = powerup,
        player = level.player,
        initial_player_position = level.initial_player_position,
        grid = level.grid,
        border = level.grid.border,
        level = level,
        score = 0,
        lives = 3,
        map = map
    }
end
