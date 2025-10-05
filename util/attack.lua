require "turtle"

while true do
    turtle.attack()
    if test_full(16) then
        turtle.turnRight()
        empty_inventory(16)
        turtle.turnLeft()
    end
end
