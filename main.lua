local Enemy = require("enemy")
local Vine = require("vine")
local util = require("util")
local Bullet = require("bullet")

local screen_width = 800
local screen_height = 600

local player = {}

local player_scale = 0.1

local bullets = {}
local enemies = {}

local vines = {}
local vine_point_radius = 10

local collectibles = {}
local collector_arms = {}
local arm_retraction_animation_speed = 4

local collection_radius = 200
local vine_point_discovery_radius = 200

local function discover_nearby_vine_points()
    for _, point in pairs(vine_points) do
        local square_distance = math.pow(player.x - point.x, 2) + math.pow(player.y - point.y, 2)
        if square_distance <= math.pow(vine_point_discovery_radius, 2) then
            point.discovered = true
        end
    end
end

local function generate_vine_points(n)
    local vine_points = util.generate_random_points(n - 1)

    for i, point in pairs(vine_points) do
        vine_points[i] = { x = point[1], y = point[2], discovered = false }
    end

    -- Ensure that the player always spawns on top of a vine point
    local centre_x = screen_width / 2 - vine_point_radius / 2
    local centre_y = screen_height / 2 - vine_point_radius / 2
    table.insert(vine_points, { x = centre_x, y = centre_y, discovered = true })

    return vine_points
end

function love.load()
    player_image = love.graphics.newImage("assets/main_character.png")

    local player_image_width = player_image:getWidth() * player_scale
    local player_image_height = player_image:getHeight() * player_scale

    vine_image = love.graphics.newImage("assets/vine1.png")

    player.x = screen_width / 2
    player.y = screen_height / 2
    player.width = player_image_width
    player.height = player_image_height
    player.hp = 100
    player.collected = 0
    player.seeds = 4

    vine_points = generate_vine_points(50)
    discover_nearby_vine_points()

    collectibles = util.generate_random_points(10)

    timer = love.timer.getTime()
    enemy_timer = love.timer.getTime()
end

local function handle_player_movement(dt)
    local new_player_x = player.x
    local new_player_y = player.y

    if love.keyboard.isDown("w") then
        new_player_y = new_player_y - 100 * dt
    end

    if love.keyboard.isDown("s") then
        new_player_y = new_player_y + 100 * dt
    end

    if love.keyboard.isDown("a") then
        new_player_x = new_player_x - 100 * dt
    end

    if love.keyboard.isDown("d") then
        new_player_x = new_player_x + 100 * dt
    end

    local function destination_valid(x, y)
        for _, vine in pairs(vines) do
            if vine:test_collision(x, y) then
                return true
            end
        end

        return false
    end

    if destination_valid(new_player_x, new_player_y) then
        player.x = new_player_x
        player.y = new_player_y

        discover_nearby_vine_points()
    end
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    handle_player_movement(dt)

    local completed = {}
    local removed_collectibles = {}

    for index, arm in pairs(collector_arms) do
        arm.animation_length_modifier =
            arm.animation_length_modifier - 0.1 * dt * arm_retraction_animation_speed

        if arm.animation_length_modifier <= 0.001 then
            table.insert(completed, 1, index)
            table.insert(removed_collectibles, arm.collectible_index)
        end
    end

    for _, index in pairs(completed) do
        table.remove(collector_arms, index)
    end

    -- FIXME: instead of just removing the collectibles, we should animate them with the arm
    for _, index in pairs(removed_collectibles) do
        table.remove(collectibles, index)
        player.collected = player.collected + 1
    end

    local etd = love.timer.getTime() - enemy_timer

    if etd >= 7 then
        enemy_timer = love.timer.getTime()
        table.insert(enemies, Enemy(player.x, player.y))
    end
    
    for _, enemy in pairs(enemies) do
        enemy:update(dt, player)
    end

    for i, v in ipairs(bullets) do
        v:update(dt)

        for i, enemy in pairs(enemies) do
            if v:check_collision(enemy) then
                enemy.hp = enemy.hp - 15

                if enemy.hp <= 0 then
                    table.remove(enemies, i)
                    player.seeds = player.seeds + 1
                end
            
                table.remove(bullets, i)
            end
        end
    end
end

local function vine_point_clicked(point_x, point_y)
    if not util.point_intersects_circle(point_x, point_y, player.x, player.y, collection_radius) then
        return
    end

    if player.seeds < 2 then
        return
    else
        player.seeds = player.seeds - 2
    end
    
    local from = { player.x, player.y }
    local to = { point_x, point_y }
    table.insert(vines, Vine(from, to))
end

local function collectible_clicked(collectible_index, collectible)
    local cx = collectible[1]
    local cy = collectible[2]

    if not util.point_intersects_circle(cx, cy, player.x, player.y, collection_radius) then
        return
    end

    local to = { cx, cy }
    local angle = util.angle_between(player.x, player.y, to[1], to[2])

    table.insert(
        collector_arms,
        {
            to = to,
            collectible_index = collectible_index,
            angle = angle,
            animation_length_modifier = 1,
        }
    )
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 2 then
        local td = love.timer.getTime() - timer

        if td >= 1 then
            timer = love.timer.getTime()
            table.insert(bullets, Bullet(player.x, player.y, x, y))
        end
        return
    end
        for _, vine in pairs(vines) do
        if vine:test_collision(x, y) then
            print("you clicked a vine")
        end
    end

    for _, point in pairs(vine_points) do
        if util.point_intersects_circle(point.x, point.y, x, y, vine_point_radius) then
            vine_point_clicked(point.x, point.y)
            break
        end
    end

    for index, collectible in pairs(collectibles) do
        local point_x, point_y = unpack(collectible)

        if util.point_intersects_circle(point_x, point_y, x, y, vine_point_radius) then
            collectible_clicked(index, collectible)
            break
        end
    end
end

function love.draw()
    love.graphics.setColor(0.278, 0.439, 0.211)
    for _, point in pairs(vine_points) do
        if point.discovered then
            love.graphics.circle("fill", point.x, point.y, vine_point_radius)
        end
    end

    love.graphics.setColor(0.929, 0.701, 0.211)
    for _, point in pairs(collectibles) do
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

    for _, arm in pairs(collector_arms) do
        local angle = util.angle_between(player.x, player.y, arm.to[1], arm.to[2])

        local length = math.sqrt(
            math.pow(arm.to[1] - player.x, 2) + math.pow(arm.to[2] - player.y, 2)
        )

        length = length * arm.animation_length_modifier

        local image_height = vine_image:getHeight()
        local sf = (1 / image_height) * length

        love.graphics.draw(
            vine_image,
            player.x,
            player.y,
            angle,
            0.1,
            sf,
            image_height / 4,
            0
        )
    end

    local render_x = player.x - player.width / 2
    local render_y = player.y - player.height / 2

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(player_image, render_x, render_y, 0, player_scale, player_scale)

    for _, enemy in pairs(enemies) do
        enemy:draw()
    end

    for _,v in ipairs(bullets) do
        v:draw()
    end

    love.graphics.print("HP: " ..player.hp.. " / Collectibles: " ..player.collected.. "/ Seeds: " ..player.seeds, 20, 20)
end
