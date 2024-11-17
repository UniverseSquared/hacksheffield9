local Object = require("Classic")

Bullet = Object:extend()

function Bullet:new(player_x, player_y, mx, my)
    self.image = love.graphics.newImage("assets/bullet.png")
    self.width = self.image:getWidth() * 0.1
    self.height = self.image:getHeight() * 0.1

    self.x = player_x
    self.y = player_y

    self.angle = math.atan2(my - self.y, mx - self.x)

    self.speed = 500

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Bullet:check_collision(obj)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y
    local obj_bottom = obj.y + obj.height

    return self_right > obj_left
    and self_left < obj_right
    and self_bottom > obj_top
    and self_top < obj_bottom 
    
end

function Bullet:update(dt)
    -- goes to x,y of mousepress
    local angle = self.angle

    local cos = math.cos(angle)
    local sin = math.sin(angle)

    self.x = self.x + self.speed * cos * dt
    self.y = self.y + self.speed * sin * dt
end

function Bullet:draw()
    love.graphics.draw(self.image, self.x, self.y, self.angle + math.rad(90), 0.3, 0.3)
end


return Bullet