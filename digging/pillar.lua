require "util.turtle"

if (arg[1] == "deepslate") then
    local has_block, data = turtle.inspectDown()
    while (not has_block or not data.name == "minecraft:deepslate") do
        digDown()
        down()
        has_block, data = turtle.inspectDown()
    end
else
    local target = (-1) * tonumber(arg[1])
    while pos[3] < target do
        turtle.digDown()
        turtle.down()
    end
end

while not (pos[3] == 0) do
        turtle.digUp()
        turtle.up()
end
