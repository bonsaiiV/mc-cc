require "util.turtle"

local is_upper = arg[1] == "upper"
turtle.select(1)

local function selectNextSlot()
    for slot=1, 16, 1 do
        if turtle.getItemCount(slot) > 0 then
            turtle.select(slot)
            return true
        end
    end
    return false
end

local function tryPlaceDown()
    local has_block, data = turtle.inspectDown()
    if has_block and data.name ~= "minecraft:lava" then return true end
    if turtle.getItemCount() == 0 then
        if not selectNextSlot() then
            return false
        end
    end
    turtle.placeDown()
    return true
end
local function tryPlaceUp()
    local has_block, data = turtle.inspectUp()
    if has_block and data.name ~= "minecraft:lava" then return true end
    if turtle.getItemCount() == 0 then
        if not selectNextSlot() then
            return false
        end
    end
    turtle.placeUp()
    return true
end

local tryPlace
if is_upper then
    tryPlace = tryPlaceUp
else
    tryPlace = tryPlaceDown
end

local function tryPlaceLeft()
    turnLeft()
    local has_block, data = turtle.inspect()
    if has_block and data.name ~= "minecraft:lava" then
        turnRight()
        return true
    end
    if turtle.getItemCount() == 0 then
        if not selectNextSlot() then
            turnRight()
            return false
        end
    end
    turtle.place()
    turnRight()
    return true
end

local function tryPlaceRight()
    turnRight()
    local has_block, data = turtle.inspect()
    if has_block and data.name ~= "minecraft:lava" then
        turnLeft()
        return true
    end
    if turtle.getItemCount() == 0 then
        if not selectNextSlot() then
            turnLeft()
            return false
        end
    end
    turtle.place()
    turnLeft()
    return true
end

while true do
    if not forward() then
        back()
        return
    end
    if not tryPlace() then
        break
    end
    if not tryPlaceLeft() then
        break
    end
    if not tryPlaceRight() then
        break
    end
end

back()
back()
