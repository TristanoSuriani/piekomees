function _draw()
    local state = game_data.state

    if state.current == state.waiting then
        draw_waiting_screen(backgrounds.waiting)

    elseif state.current == state.in_progress then
        draw_game_in_progress(game_data, backgrounds.in_progress)

    elseif state.current == state.game_over then
        draw_game_over_screen(backgrounds.game_over)

    elseif state.current == state.completed then
        draw_ending_screen(backgrounds.completed)

    elseif state.current == state.life_lost then
        draw_life_lost_screen(backgrounds.life_lost)
    end
end

function draw_game_in_progress(game_data, background)
    local border = game_data.border
    local grid = game_data.grid

    local player = game_data.player
    local score_output = "" .. game_data.score
    if game_data.score > 0 then
        score_output = score_output .. "0"
    end

    cls(background)
    -- draw_debug_grid(grid)
    map(game_data.map.x, game_data.map.y)
    rect(border.x0, border.y0, border.x1, border.y1, border.colour)
    draw_things(game_data.level.blocks)
    draw_things(game_data.level.enemies)
    draw_things(game_data.level.candies)
    local candies = game_data.level.candies
    print ("score: " .. score_output .. ", lives: " .. game_data.lives)
    spr(player.spr, player.x, player.y)
end

function draw_waiting_screen(background)
    cls(background)
    print("waiting", 2, 2)
end

function draw_life_lost_screen(background)
    cls(background)
    print("ouch, that hurts! try again.\n\n\n\n\n\npress x or z to continue", 2, 2)
end

function draw_game_over_screen(background)
    cls(background)
    print("game over", 2, 2)
end

function draw_ending_screen(background)
    cls(background)
    print("completed", 2, 2)
end

function draw_things(things)
    for _, thing in pairs(things) do
        spr(thing.spr, thing.x, thing.y)
    end
end

function draw_debug_grid(grid)
    local colour = 14
    for x = grid.x0, grid.x1, 1 do
        for y = grid.y0, grid.y1, 1 do
            pset(x, y, colour)
        end
    end
end
