local util = {}

-- Generate `n` random points within the dimensions of the game window
function util.generate_random_points(n)
    local screen_width = love.graphics.getWidth()
    local screen_height = love.graphics.getHeight()

    local points = {}
    for index = 1, n do
        local x = love.math.random(screen_width)
        local y = love.math.random(screen_height)
        table.insert(points, { x, y })
    end

    return points
end

-- Rotate a point (px, py) about an origin (ox, oy) counterclockwise by `angle` radians
function util.rotate(ox, oy, px, py, angle)
    local x = ox + math.cos(angle) * (px - ox) - math.sin(angle) * (py - oy)
    local y = oy + math.sin(angle) * (px - ox) + math.cos(angle) * (py - oy)
    return { x, y }
end

-- Determines the angle between two points (x1, y1) and (x2, y2)
function util.angle_between(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.atan2(dy, dx) - math.pi / 2
end

-- Test for intersection of a point (px, py) with the axis-aligned bounding box defined by the vertices
-- (x1, y1) and (x2, y2)
function util.aabb(x1, y1, x2, y2, px, py)
    return px >= x1 and px <= x2 and py >= y1 and py <= y2
end

-- Determines if the point (point_x, point_y) intersects with the circle defined by the centre point
-- (centre_x, centre_y) and the radius
function util.point_intersects_circle(point_x, point_y, centre_x, centre_y, radius)
    local square_distance = math.pow(centre_x - point_x, 2) + math.pow(centre_y - point_y, 2)
    return square_distance <= math.pow(radius, 2)
end

return util
