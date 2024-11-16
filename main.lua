local screen_width = 640
local screen_height = 480

local player_x = 300
local player_y = 300

local vines = {} -- { from = {x, y}, to = {x, y} }
local vine_point_radius = 10

local function generate_random_points(n)
    local points = {}
    for index = 1, n do
        local x = love.math.random(screen_width)
        local y = love.math.random(screen_height)
        table.insert(points, { x, y })
    end

    return points
end

function love.load()
    player_image = love.graphics.newImage("assets/main_character.png")
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

            table.insert(vines, { from = from, to = to })
            print("did the thing")

            break
        end
    end
end

function love.draw()
    love.graphics.setColor(0.278, 0.439, 0.211)
    for _, point in pairs(vine_points) do
        love.graphics.circle("fill", point[1], point[2], vine_point_radius)
    end

    love.graphics.setColor(0.929, 0.266, 0.498)
    love.graphics.draw(player_image, player_x, player_y, 0, 0.1, 0.1)
end
