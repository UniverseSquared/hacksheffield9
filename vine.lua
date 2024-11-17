local Object = require("Classic")
local util = require("util")
local Vine = Object:extend()

function Vine:new(from, to)
    self.from = from
    self.to = to
    self.angle = util.angle_between(from[1], from[2], to[1], to[2])
    self.length = math.sqrt(math.pow(to[1] - from[1], 2) + math.pow(to[2] - from[2], 2))
end

local function collision_points_for_vine(vine)
    local angle_of_line = vine.angle - math.pi

    local width_of_vine = vine_image:getWidth() * 0.1
    local half_width = width_of_vine / 2

    -- to
    local collision_point1 = {
        x = vine.to[1] + half_width * math.cos(angle_of_line),
        y = vine.to[2] + half_width * math.sin(angle_of_line)
    }

    local collision_point2 = {
        x = vine.to[1] - half_width * math.cos(angle_of_line),
        y = vine.to[2] - half_width * math.sin(angle_of_line)
    }

    -- from
    local collision_point3 = {
        x = vine.from[1] + half_width * math.cos(angle_of_line),
        y = vine.from[2] + half_width * math.sin(angle_of_line)
    }

    local collision_point4 = {
        x = vine.from[1] - half_width * math.cos(angle_of_line),
        y = vine.from[2] - half_width * math.sin(angle_of_line)
    }

    return { collision_point1, collision_point2, collision_point3, collision_point4 }
end

-- Determines if the point (x, y) intersects with the vine
function Vine:test_collision(x, y)
    local bounding_box = collision_points_for_vine(self)
    for i = 1, #bounding_box do
        local bx = bounding_box[i].x
        local by = bounding_box[i].y
        local rotated_x, rotated_y = unpack(util.rotate(0, 0, bx, by, -self.angle))
        bounding_box[i] = { x = rotated_x, y = rotated_y }
    end

    local rx, ry = unpack(util.rotate(0, 0, x, y, -self.angle))
    return util.aabb(bounding_box[3].x, bounding_box[3].y, bounding_box[2].x, bounding_box[2].y, rx, ry)
end

return Vine
