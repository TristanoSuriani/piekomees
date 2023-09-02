function create_grid(x_offset, y_offset, tile_size, x_tiles, y_tiles)
    local grid = {
        x_tiles = x_tiles,
        y_tiles = y_tiles,
        tile_size = tile_size,
        x0 = x_offset,
        x1 = x_offset + (x_tiles * tile_size),
        y0 = y_offset,
        y1 = y_offset + (tile_size * y_tiles)
    }

    grid.border = {
        x0 = grid.x0 - 1,
        x1 = grid.x1,
        y0 = grid.y0 - 1,
        y1 = grid.y1,
        colour = 10
    }

    grid.get_cell_coordinates = function(x, y)
        return {
            x = x_offset + tile_size * x,
            y = y_offset + tile_size * y,
        }
    end

    grid.collide_border_top = function(thing)
        return thing.y <= grid.y0
    end

    grid.collide_border_bottom = function(thing)
        return thing.y >= grid.y1 - tile_size
    end

    grid.collide_border_left = function(thing)
        return thing.x <= grid.x0
    end

    grid.collide_border_right = function(thing)
        return thing.x >= grid.x1 - tile_size
    end

    return grid
end