require "util/turtle"

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
    if not tryPlaceDown() then
        break
    end
    if not tryPlaceLeft() then
        break
    end
    if not tryPlaceRight() then
        break
    end
    if not up() then
        break
    end
    if not tryPlaceUp() then
        break
    end
    if not tryPlaceLeft() then
        break
    end
    if not tryPlaceRight() then
        break
    end
    if not forward() then
        break
    end
    if not tryPlaceUp() then
        break
    end
    if not tryPlaceLeft() then
        break
    end
    if not tryPlaceRight() then
        break
    end
    if not down() then
        break
    end
    if not tryPlaceDown() then
        break
    end
    if not tryPlaceLeft() then
        break
    end
    if not tryPlaceRight() then
        break
    end
    if not forward() then
        break
    end
end

back()
back()
