function update_player_position(current_direction)
    local player = game_data.player
    local blocks = game_data.level.blocks
    local old_y = player.y
    local old_x = player.x
    local grid = game_data.grid
    local directions = constants.directions
    local tile_size = constants.tile_size

    if current_direction then
        player.direction = current_direction
    end

    if player.direction == directions.idle then
        return
    end

    if player.direction == directions.up then
        player.y -= player.dy
        if grid.collide_border_top(player) then
            player.y = grid.y0

        elseif is_colliding_with_blocks(player, blocks) then
            player.y = old_y
        end
    end

    if player.direction == directions.down then
        player.y += player.dy
        if grid.collide_border_bottom(player) then
            player.y = grid.y1 - tile_size

        elseif is_colliding_with_blocks(player, blocks) then
            player.y = old_y
        end
    end

    if player.direction == directions.left then
        player.x -= player.dx
        if grid.collide_border_left(player) then
            player.x = grid.x0
         elseif is_colliding_with_blocks(player, blocks) then
            player.x = old_x
        end
    end

    if player.direction == directions.right then
        player.x += player.dx
        if grid.collide_border_right(player) then
            player.x = grid.x1 - tile_size
        elseif is_colliding_with_blocks(player, blocks) then
            player.x = old_x
        end
    end
end

function get_direction()
    local directions = constants.directions
    local controls = constants.controls

    if btnp(controls.up) then
        return directions.up
    elseif btnp(controls.down) then
        return directions.down
    elseif btnp(controls.left) then
        return directions.left
    elseif btnp(controls.right) then
        return directions.right
    end
end

function is_colliding(a, b)
    local tile_size = constants.tile_size

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
    local player_center_x = player.x + 2
    local player_center_y = player.y + 2
    local candy_center_x = candy.x + 2
    local candy_center_y = candy.y + 2

    -- Check collision using a 4x4 bounding box around the center points
    return player_center_x < candy_center_x + 4 and
           player_center_x + 4 > candy_center_x and
           player_center_y < candy_center_y + 4 and
           player_center_y + 4 > candy_center_y
end

