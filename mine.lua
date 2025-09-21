local target = tonumber(arg[1])

while(target > 0) do
    turtle.dig()
    turtle.forward()
    turtle.digDown()
    target = target-1
end
