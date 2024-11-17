--! file: enemy.lua

local Object = require("Classic")
Enemy = Object:extend()


-- What this object does as of now:
-- Moves towards the player (needs the player's width and height and x and y coordinate)
-- Once reaches within player box, starts decelerating and accelerates in the opposite direction
-- Once reaches player box, causes damage

function Enemy:new(player_x, player_y)
    self.image = love.graphics.newImage("assets/dawson.png")

    -- makes sure gets a starting x and y coordinate within the window

    self.x = love.math.random(love.graphics.getWidth())
    self.y = love.math.random(love.graphics.getHeight())

    self.speed = 80

    -- image width and height
    self.width = self.image:getWidth() * 0.1
    self.height = self.image:getHeight() * 0.1
    self.angle = math.atan2(player_y - self.y, player_x - self.x)
end

function Enemy:update_coords(dt, player_x, player_y)
    local angle = math.atan2(player_y - self.y, player_x - self.x)

    -- get x and y coordinates based on sin cos
    local cos = math.cos(angle)
    local sin = math.sin(angle)

    -- enemy towards player
    self.x = self.x + self.speed * cos * dt
    self.y = self.y + self.speed * sin * dt
end

function Enemy:check_collision(entity)
    -- entity will be the other entity with which we check if there is collision
    return self.x + self.width > entity.x
    and self.x < entity.x + entity.width
    and self.y + self.height > entity.y
    and self.y < entity.y + entity.height
end

function Enemy:update(dt, entity)
    self:update_coords(dt, entity.x, entity.y)

    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    if self.x < 0 then
        self.x = 0
    elseif self.x + self.width > window_width then
        self.x = window_width - self.width
    elseif self.y < 0 then
        self.y = 0
    elseif self.y + self.height > window_height then
        self.y = window_height - self.height
    end
end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, 0.1, 0.1)
end

return Enemy
