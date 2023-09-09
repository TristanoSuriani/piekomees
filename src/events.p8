function init_events_handlers(events)
    local events_handlers = {}
    events_handlers[events.player_collided_with_candy] = handle_player_collided_with_candy
    return events_handlers
end

function publish_event(event)
    local events_handlers = constants.events_handlers
    local event_handler = events_handlers[event.type]
    assert(event_handler, "no event handler for event " .. event.type)
    event_handler(event)
end

function handle_player_collided_with_candy(event)
    local collected_index = event.collected_index
    local level = game_data.level

    level.candies = collect_candy(candies, collected_index)
    game_data.score += 1
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