require "turtle"

local has, data = turtle.inspect()
if has and ((data.name == "minecraft:barrel") or (data.name == "minecraft:chest")) then
    turtle.turnLeft()
end

while true do
    turtle.attack()
    if test_full(16) then
        turtle.turnRight()
        empty_inventory(16)
        turtle.turnLeft()
    end
end
