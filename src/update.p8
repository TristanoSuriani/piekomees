function _update()
    local state = game_data.state
    if game_data.player.state.current == game_data.player.state.dead then
        reset_game_data()
        game_data.state.current = state.game_over
        return
    end

    if state.current == state.in_progress then
        update_game_in_progress(game_data)
        if is_level_completed(game_data) then
            reset_game_data()
            game_data.state.current = state.completed
        end

    elseif state.current == state.game_over or state.current == state.completed then
        if btnp(controls.z) or btnp(controls.x) then
            game_data.state.current = state.waiting
        end
    else
        if btnp(controls.z) or btnp(controls.x) then
            game_data.state.current = state.in_progress
        end
    end
end


function update_game_in_progress(game_data)
    local player = game_data.player
    local level = game_data.level
    local blocks = game_data.level.blocks
    local candies = game_data.level.candies
    local current_direction = get_direction()

    update_player_position(game_data, player, current_direction)

    for i, candy in ipairs(candies) do
        if is_colliding_with_candy(player, candy) then
            level.candies = collect_candy(candies, i)
            game_data.score += 1
            break
        end
    end

    if is_colliding_with_enemies(player, game_data.level.enemies) then
        game_data.lives -= 1
        game_data.state.current = game_data.state.life_lost
        game_data.player = reset_player(game_data.grid)
    end

    if game_data.lives == 0 then
        game_data.player.state.current = game_data.player.state.dead
    end
end

function update_player_position(game_data, player, current_direction)
    local blocks = game_data.level.blocks
    local old_y = player.y
    local old_x = player.x
    local grid = game_data.grid

    if current_direction then
        player.direction = current_direction
    end

    if player.direction == direction.idle then
        return
    end

    if player.direction == direction.up then
        player.y -= player.dy
        if grid.collide_border_top(player) then
            player.y = grid.y0

        elseif is_colliding_with_blocks(player, blocks) then
            player.y = old_y
        end
    end

    if player.direction == direction.down then
        player.y += player.dy
        if grid.collide_border_bottom(player) then
            player.y = grid.y1 - tile_size

        elseif is_colliding_with_blocks(player, blocks) then
            player.y = old_y
        end
    end

    if player.direction == direction.left then
        player.x -= player.dx
        if grid.collide_border_left(player) then
            player.x = grid.x0
         elseif is_colliding_with_blocks(player, blocks) then
            player.x = old_x
        end
    end

    if player.direction == direction.right then
        player.x += player.dx
        if grid.collide_border_right(player) then
            player.x = grid.x1 - tile_size
        elseif is_colliding_with_blocks(player, blocks) then
            player.x = old_x
        end
    end
end

function get_direction()
    if btnp(controls.up) then
        return direction.up
    elseif btnp(controls.down) then
        return direction.down
    elseif btnp(controls.left) then
        return direction.left
    elseif btnp(controls.right) then
        return direction.right
    end
end

function collect_candy(candies, collectedIndex)
    local newCandies = {}
    local j = 1
    for i, candy in ipairs(candies) do
        if i ~= collectedIndex then
            newCandies[j] = candy
            j += 1
        end
    end
    return newCandies
end

function is_colliding(a, b)
    return a.x < b.x + tile_size and
           a.x + tile_size > b.x and
           a.y < b.y + tile_size and
           a.y + tile_size > b.y
end

function is_colliding_with_blocks(thing, blocks)
    for _, block in pairs(blocks) do
        if is_colliding(thing, block) then
            return true
        end
    end
    return false
end

function is_colliding_with_enemies(thing, enemies)
    for _, enemy in pairs(enemies) do
        if is_colliding(thing, enemy) then
            return true
        end
    end
    return false
end

function is_colliding_with_candy(player, candy)
    -- Calculate the center points of the player and candy
    local playerCenterX = player.x + 2
    local playerCenterY = player.y + 2
    local candyCenterX = candy.x + 2
    local candyCenterY = candy.y + 2

    -- Check collision using a 4x4 bounding box around the center points
    return playerCenterX < candyCenterX + 4 and
           playerCenterX + 4 > candyCenterX and
           playerCenterY < candyCenterY + 4 and
           playerCenterY + 4 > candyCenterY
end

function is_level_completed(game_data)
    local candies = game_data.level.candies
    return #candies == 0
end

