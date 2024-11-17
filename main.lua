local states = {
    title_screen = require("title_screen"),
    game = require("game"),
    win = require("win")
}

local current_state

function switch_state(new_state)
    current_state = new_state

    if states[new_state].load then
        states[new_state].load()
    end
end

switch_state("game")

function love.update(dt)
    if states[current_state].update then
        states[current_state].update(dt)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if states[current_state].mousepressed then
        states[current_state].mousepressed(x, y, button, istouch, presses)
    end
end

function love.draw()
    if states[current_state].draw then
        states[current_state].draw()
    end
end
