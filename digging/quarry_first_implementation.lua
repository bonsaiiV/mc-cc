local target = {tonumber(arg[1]), tonumber(arg[2]), tonumber(arg[3])}
local pos = {0, 0, 0}

local function safe_up()
    local hasBlock, _ = turtle.inspectUp()
    while hasBlock do
        turtle.digUp()
        hasBlock, _ = turtle.inspectUp()
    end
    turtle.up()
end
local function safe_fwd()
    local hasBlock, _ = turtle.inspectUp()
    while hasBlock do
        turtle.digUp()
        hasBlock, _ = turtle.inspectUp()
    end
    turtle.up()
end
local down = turtle.down
local up = safe_up
local digDown = turtle.digDown
local digUp = turtle.digUp
local forward = safe_fwd
local dig = turtle.dig
local turnRight = turtle.turnRight
local turnLeft = turtle.turnLeft

local fuelPerPillar = (target[3]+1) * 2
local fuelPerSlice = fuelPerPillar * math.ceil(target[1] / 4) * 2
local requiredFuel = fuelPerSlice * math.ceil(target[2]/2)
local startFuel = turtle.getFuelLevel()
if (requiredFuel > startFuel) then
    print("not enough fuel")
    print("required fuel:", requiredFuel)
    print("available fuel", startFuel)
end

if (target[3] < 0) then
    target[3] = target[3] * (-1)
    up = turtle.down
    down = safe_up
    digUp = turtle.digDown
    digDown = turtle.digUp
end
if (target[2] < 0) then
    target[2] = target[2] * (-1)
    turnLeft = turtle.turnRight
    turnRight = turtle.turnLeft
else
end
local function quarryPillars()
    dig()
    while (pos[3]+1 < target[3]) do
        digDown()
        down()
        dig()
        pos[3] = pos[3]+1
    end
    forward()
    dig()
    forward()
    dig()
    while (pos[3] > 0) do
        digUp()
        up()
        dig()
        pos[3] = pos[3]-1
    end
    forward()
end

local function quarrySlice()
    quarryPillars()
    pos[1] = pos[1]+4
    while (pos[1] < target[1]) do
        dig()
        forward()
        pos[1] = pos[1]+4
        quarryPillars()
    end
    turnRight()
    dig()
    forward()
    turnRight()
    quarryPillars()
    pos[1] = pos[1]-4
    while (pos[1] > 0) do
        dig()
        forward()
        pos[1] = pos[1]-4
        quarryPillars()
    end
end
local function quarryAll()
    quarrySlice()
    pos[2] = pos[2] + 2
    while(pos[2] < target[2]) do
        turnLeft()
        dig()
        forward()
        turnLeft()
        quarrySlice()
        pos[2] = pos[2] + 2
    end
    pos[2] = pos[2] - 1
    turnRight()
    while(pos[2] > 0) do
        forward()
        pos[2] = pos[2]-1
    end
end
quarryAll()
print("actual fuel use:", startFuel-turtle.getFuelLevel())
