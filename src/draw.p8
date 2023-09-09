function _draw()
    local state = game_data.state
    local backgrounds = constants.backgrounds

    if state == constants.states.new_game then
        render_new_game_screen()

    elseif state == constants.states.waiting then
        render_waiting_screen()

    elseif state == constants.states.in_progress then
        render_game_in_progress(game_data)

    elseif state == constants.states.game_over then
        render_game_over_screen()

    elseif state == constants.states.new_level then
        render_new_level()

    elseif state == constants.states.completed then
        render_ending_screen()

    elseif state == constants.states.life_lost then
        render_life_lost_screen()

    elseif state == constants.states.level_completed then
        render_level_completed()
    end
end

function render_game_in_progress(game_data)
    local background = constants.backgrounds.in_progress
    local border = game_data.border
    local grid = game_data.grid

    local player = game_data.player
    local score_output = "" .. game_data.score
    if game_data.score > 0 then
        score_output = score_output .. "0"
    end

    cls(background)
    map(constants.map.x, constants.map.y)
    rect(border.x0, border.y0, border.x1, border.y1, border.colour)
    render_things(game_data.level.blocks)
    render_things(game_data.level.enemies)
    render_things(game_data.level.candies)
    local candies = game_data.level.candies
    print ("score: " .. score_output .. ", lives: " .. game_data.lives .. ", level: " .. game_data.level_number)
    spr(player.spr, player.x, player.y)
end

function render_waiting_screen()
    local background = constants.backgrounds.waiting
    cls(background)
    print("waiting", 2, 2)
end

function render_life_lost_screen()
    local background = constants.backgrounds.life_lost
    cls(background)
    print("ouch, that hurts! try again.\n\n\n\n\n\npress x or z to continue", 2, 2)
end

function render_new_game_screen()
    local background = constants.backgrounds.new_game
    cls(background)
    print("Welcome!\n\n\n\n\n\npress x or z to continue", 2, 2)
end

function render_game_over_screen()
    local background = constants.backgrounds.game_over
    cls(background)
    print("game over", 2, 2)
end

function render_ending_screen()
    local background = constants.backgrounds.ending_screen
    cls(background)
    print("completed", 2, 2)
end

function render_new_level()
    local background = constants.backgrounds.new_level
    cls(background)
    print("new level", 2, 2)
end

function render_level_completed()
    local background = constants.backgrounds.level_completed
    cls(background)
    print("level completed", 2, 2)
end

function render_things(things)
    for _, thing in pairs(things) do
        spr(thing.spr, thing.x, thing.y)
    end
end