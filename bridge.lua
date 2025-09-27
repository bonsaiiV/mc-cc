require "turtle_util"

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
    local has_block, _ = turtle.inspectDown()
    if has_block then return end
    if turtle.getItemCount() == 0 then
        if selectNextSlot() then
            return
        end
    end
    turtle.placeDown()
end

local function tryPlaceLeft()
    turnLeft()
    local has_block, _ = turtle.inspect()
    if has_block then return end
    if turtle.getItemCount() == 0 then
        if selectNextSlot() then
            turnRight()
            return
        end
    end
    turtle.place()
    turnRight()
end

local function tryPlaceRight()
    turnLeft()
    local has_block, _ = turtle.inspect()
    if has_block then return end
    if turtle.getItemCount() == 0 then
        if selectNextSlot() then
            turnLeft()
            return
        end
    end
    turtle.place()
    turnLeft()
end

while true do
    if not forward() then
        back()
        return
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
end

back()
back()
