function _update()
    local states = constants.states
    local state = game_data.state
    local controls = constants.controls
    local levels_arrays = constants.levels_arrays

    local state_machine = constants.state_machine
    local transitions = state_machine.transitions[state]
    local handler = state_machine.handlers[state]

    if handler then
        handler()
    end

    local msg = "no transition for state " .. state
    assert(transitions, msg)

    for i = 1, #transitions, 1 do
        local transition = transitions[i]
        if transition.trigger(game_data) then
            if transition.hook then
                transition.hook()
            end
            game_data.state = transition.next_state
        end
    end
end

function init_state_machine(states, events)
    local state_machine = {}
    state_machine.handlers = {}
    state_machine.transitions = {}

    state_machine.transitions[states.new_game] = {
       {
           trigger = is_key_z_or_z_pressed,
           next_state = states.new_level
       }
    }

    state_machine.transitions[states.waiting] = {
        {
            trigger = is_key_z_or_z_pressed,
            next_state = states.new_level
        }
    }

    state_machine.transitions[states.new_level] = {
        {
            trigger = is_key_z_or_z_pressed,
            next_state = states.in_progress
        }
    }

    state_machine.handlers[states.in_progress] = update_game_in_progress

    state_machine.transitions[states.in_progress] = {
        {
            trigger = all_candies_collected,
            next_state = states.level_completed
        },
        {
            trigger = collision_with_enemy,
            next_state = states.life_lost,
            hook = in_progress_to_life_lost_hook
        },
    }

    state_machine.transitions[states.level_completed] = {
        {
            trigger = all_levels_completed,
            next_state = states.completed,
        },
        {
            trigger = is_key_z_or_z_pressed,
            next_state = states.new_level,
            hook = level_completed_to_new_level_hook
        }
    }

    state_machine.transitions[states.completed] = {
        {
            trigger = is_key_z_or_z_pressed,
            next_state = states.new_game,
            hook = completed_to_new_game_hook
        }
    }

    state_machine.transitions[states.game_over] = {
        {
            trigger = is_key_z_or_z_pressed,
            next_state = states.new_game,
            hook = game_over_to_new_game_hook
        }
    }

    state_machine.transitions[states.life_lost] = {
        {
            trigger = all_lives_lost,
            next_state = states.game_over
        },
        {
            trigger = is_key_z_or_z_pressed,
            next_state = states.in_progress
        }
    }

    return state_machine
end

function is_key_z_or_z_pressed()
    local controls = constants.controls
    return btnp(controls.z) or btnp(controls.x)
end

function all_levels_completed()
    return game_data.level_number == #constants.levels_arrays
end

function all_lives_lost()
    return game_data.lives == 0
end

function all_candies_collected()
    local candies = game_data.level.candies
    return #candies == 0
end

function collision_with_enemy()
    return is_colliding_with_enemies(game_data.player, game_data.level.enemies)
end

function update_game_in_progress()
    local player = game_data.player
    local level = game_data.level
    local blocks = game_data.level.blocks
    local candies = game_data.level.candies
    local current_direction = get_direction()

    update_player_position(current_direction)
    collect_candy_if_possible()
end

function level_completed_to_new_level_hook()
    reset_game_data(game_data.level_number + 1, constants.states.level_completed, game_data.score, game_data.lives + 2)
end

function completed_to_new_game_hook()
    reset_game_data(1, constants.states.new_game, 0, constants.lives)
end

function game_over_to_new_game_hook()
    reset_game_data(1, constants.states.new_game, 0, constants.lives)
end

function in_progress_to_life_lost_hook()
    publish_event({
        type = constants.events.player_collided_with_enemy,
    })
end

function collect_candy_if_possible()
    local player = game_data.player
    local level = game_data.level
    local candies = game_data.level.candies

    for i, candy in ipairs(candies) do

        if is_colliding_with_candy(player, candy) then
            publish_event({
                type = constants.events.player_collided_with_candy,
                data = {
                    collected_index = i
                }
            })
            return
        end
    end
end