local target = tonumber(arg[1])
local dist = 0

while(target > dist) do
    turtle.dig()
    turtle.forward()
    turtle.digDown()
    dist = dist+1
end
while (dist > 0) do
    turtle.back()
    dist = dist-1
end
