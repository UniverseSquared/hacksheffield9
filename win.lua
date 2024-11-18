local win = {}

function win.update(dt)
end

function win.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("yes", 5, 5)
end

return win
