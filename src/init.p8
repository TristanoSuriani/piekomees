function _init()
    local controls = {
        up = 2,
        down = 3,
        left = 0,
        right = 1,
        z = 4,
        x = 5,
    }

    local tile_size = 8

    local backgrounds = {
        waiting = 5,
        in_progress = 0,
        game_over = 8,
        ending_screen = 2,
        life_lost = 1,
        new_level = 3,
        new_game = 6,
        level_completed = 7,
    }

    local directions = {
        up = 0,
        down = 1,
        left = 2,
        right = 3
    }

    local screen_properties = {
        x_offset = 8,
        y_offset = 16
    }

    local grid_elements = {
        player = -1,
        nothing = 0,
        candy = 1,
        block = 2,
        enemy = 3
    }

    local map = {
        x = 0,
        y = 0
    }

    local states = {
        waiting = "waiting",
        in_progress = "in_progress",
        game_over = "game_over",
        completed = "completed",
        life_lost = "life_lost",
        new_level = "new_level",
        new_game = "new_game",
        level_completed = "level_completed",
    }

    local events = {
        player_collided_with_candy = 1,
        player_collided_with_enemy = 2,
    }

    local state_machine = init_state_machine(states)
    local events_handlers = init_events_handlers(events)

    constants = {
        controls = controls,
        tile_size = tile_size,
        backgrounds = backgrounds,
        directions = directions,
        screen_properties = screen_properties,
        grid_elements = grid_elements,
        levels_arrays = init_levels_arrays(),
        states = states,
        state = states.new_game,
        events = events,
        map = map,
        state_machine = state_machine,
        events_handlers = events_handlers,
        text_colour = 10,
        lives = 10,
    }

    reset_game_data(1, constants.states.new_game, 0, constants.lives)
end

function reset_game_data(level_number, state, score, lives)
    local levels_arrays = init_levels_arrays()
    local level_array = constants.levels_arrays[level_number]
    local msg = "level_array is not set for level " .. level_number
    assert(level_array, msg)
    local level = create_level_from_level_array(level_array)

    game_data = {
        background = background,
        title = title,
        state = state,
        powerup = powerup,
        player = level.player,
        initial_player_position = level.initial_player_position,
        grid = level.grid,
        border = level.grid.border,
        level_number = level_number,
        score = score,
        lives = lives,
        level = level
    }
end
