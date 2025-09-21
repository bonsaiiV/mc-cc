local depth = 0


if (arg[1] == "deepslate") then
    local has_block, data = turtle.inspectDown()
    while (not has_block or not data.name == "minecraft:deepslate") do
        turtle.digDown()
        turtle.down()
        depth = depth+1
        has_block, data = turtle.inspectDown()
    end
else
    local target = tonumber(arg[1])
    while (depth < target) do
        turtle.digDown()
        turtle.down()
        depth = depth+1
    end
end

while (depth > 0) do
        turtle.digUp()
        turtle.up()
        depth = depth-1
end
