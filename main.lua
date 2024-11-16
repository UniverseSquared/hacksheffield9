local player_x = 300
local player_y = 300

function love.load()
    player_image = love.graphics.newImage("assets/main_character.png")
end

function love.update(dt)
    if love.keyboard.isDown("up") then
        player_y = player_y - 100 * dt
    end

    if love.keyboard.isDown("down") then
        player_y = player_y + 100 * dt
    end

    if love.keyboard.isDown("left") then
        player_x = player_x - 100 * dt
    end

    if love.keyboard.isDown("right") then
        player_x = player_x + 100 * dt
    end
end

function love.draw()
    love.graphics.setColor(0.929, 0.266, 0.498)
    love.graphics.draw(player_image, player_x, player_y, 0, 0.15, 0.15)
end
