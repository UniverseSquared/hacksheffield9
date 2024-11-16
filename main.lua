local screen_width = 800
local screen_height = 600

local player_x = screen_width / 2
local player_y = screen_height / 2

local player_scale = 0.1

local vines = {} -- { from = {x, y}, to = {x, y} }
local vine_point_radius = 10

local function generate_random_points(n)
    local points = {}
    for index = 1, n do
        local x = love.math.random(screen_width)
        local y = love.math.random(screen_height)
        table.insert(points, { x, y })
    end

    local centre_x = screen_width / 2 - vine_point_radius / 2
    local centre_y = screen_height / 2 - vine_point_radius / 2
    table.insert(points, { centre_x, centre_y })

    return points
end

function love.load()
    player_image = love.graphics.newImage("assets/main_character.png")
    player_image_width = player_image:getWidth() * player_scale
    player_image_height = player_image:getHeight() * player_scale

    vine_image = love.graphics.newImage("assets/vine1.png")

    vine_points = generate_random_points(50)
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    if love.keyboard.isDown("w") then
        player_y = player_y - 100 * dt
    end

    if love.keyboard.isDown("s") then
        player_y = player_y + 100 * dt
    end

    if love.keyboard.isDown("a") then
        player_x = player_x - 100 * dt
    end

    if love.keyboard.isDown("d") then
        player_x = player_x + 100 * dt
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    for _, point in pairs(vine_points) do
        local point_x, point_y = unpack(point)
        local square_distance = math.pow(x - point_x, 2) + math.pow(y - point_y, 2)

        if square_distance <= math.pow(vine_point_radius, 2) then
            local from = { player_x, player_y }
            local to = { point_x, point_y }

            local dx = point_x - player_x
            local dy = point_y - player_y
            local angle = math.atan2(dy, dx) - math.pi / 2

            local length = math.sqrt(math.pow(to[1] - from[1], 2) + math.pow(to[2] - from[2], 2))

            table.insert(vines, { from = from, to = to, angle = angle, length = length })

            break
        end
    end
end

function love.draw()
    love.graphics.setColor(0.278, 0.439, 0.211)
    for _, point in pairs(vine_points) do
        love.graphics.circle("fill", point[1], point[2], vine_point_radius)
    end

    love.graphics.setColor(1, 1, 1)
    for _, vine in pairs(vines) do
        local image_height = vine_image:getHeight()
        local sf = (1 / image_height) * vine.length

        love.graphics.draw(
            vine_image,
            vine.from[1],
            vine.from[2],
            vine.angle,
            0.1,
            sf,
            image_height / 4,
            0
        )
    end

    local render_x = player_x - player_image_width / 2
    local render_y = player_y - player_image_height / 2

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(player_image, render_x, render_y, 0, player_scale, player_scale)
end
