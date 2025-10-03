require "turtle"

while true do
    turtle.attack()
    if test_full() then
        turtle.turnRight()
        for slot=1, 16, 1 do
            turtle.select(slot)
            turtle.drop()
        end
        turtle.turnLeft()
    end
end
