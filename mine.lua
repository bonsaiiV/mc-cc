local target = tonumber(arg[1])
local dist = 0

while(target > dist) do
    local has_block, data = turtle.inspect()
    if has_block then
        if (data.name == "minecraft:lava") then
            break
        end
        print(data.name)
    end
    turtle.dig()
    turtle.forward()
    turtle.digUp()
    dist = dist+1
end
while (dist > 0) do
    turtle.back()
    dist = dist-1
end
