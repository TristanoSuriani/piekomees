function init_events_handlers(events)
    local events_handlers = {}
    events_handlers[events.player_collided_with_candy] = handle_player_collided_with_candy
    events_handlers[events.player_lost_a_life] = handle_player_lost_a_life
    events_handlers[events.level_completed] = handle_level_completed
    return events_handlers
end

function publish_event(event)
    local events_handlers = constants.events_handlers
    local event_handler = events_handlers[event.type]
    assert(event_handler, "no event handler for event " .. event.type)
    event_handler(event)
end

function handle_player_collided_with_candy(event)
    local collected_index = event.data.collected_index
    local level = game_data.level
    level.candies = collect_candy(level.candies, collected_index)
    if game_data.score %4 == 0 then
        sfx(constants.sounds.eating)
    end
    game_data.score += 1
    game_data.health += 16
end

function handle_player_lost_a_life(event)
    sfx(constants.sounds.hurt)
    game_data.lives -= 1
    game_data.player = reset_player(game_data.initial_player_position.x, game_data.initial_player_position.y)
    game_data.health = constants.initial_health
end

function handle_level_completed(event)
    sfx(constants.sounds.won)
end

function collect_candy(candies, collected_index)
    local newCandies = {}
    local j = 1
    for i, candy in ipairs(candies) do
        if i ~= collected_index then
            newCandies[j] = candy
            j += 1
        end
    end
    return newCandies
end