require "util.turtle"
local startFuel = turtle.getFuelLevel()
local turn_direction_right = true

local function quarryShaft(target)
    local included_sides = {}
    if target[3] > 0 then
        if pos[3]+1 < target[3] then
            table.insert(included_sides, digUp)
        end
        if pos[3] > 0 then
            table.insert(included_sides, digDown)
        end
    else
        if pos[3]-1 > target[3] then
            table.insert(included_sides, digDown)
        end
        if pos[3] > 0 then
            table.insert(included_sides, digUp)
        end
    end
    if turn_direction_right then
        if pos[1] == 0 then
            if ((pos[2] == 1) or (pos[2]-2 == target[2])) then
                table.insert(included_sides, digLeft)
            end
            if not (pos[2]+1 == target[2]) or ((target[2] < 0) and not (pos[2] == 0)) then
                table.insert(included_sides, digRight)
            end
        else
            if ((pos[2] == -1) or (pos[2]+2 == target[2])) then
                table.insert(included_sides, digLeft)
            end
            if not (pos[2]-1 == target[2]) or ((target[2] > 0) and not (pos[2] == 0)) then
                table.insert(included_sides, digRight)
            end
        end
    else
        if (not pos[1] == 0) then
            if ((pos[2] == 1) or (pos[2]-2 == target[2])) then
                table.insert(included_sides, digRight)
            end
            if not (pos[2]+1 == target[2]) or ((target[2] < 0) and not (pos[2] == 0)) then
                table.insert(included_sides, digLeft)
            end
        else
            if ((pos[2] == -1) or (pos[2]+2 == target[2])) then
                table.insert(included_sides, digRight)
            end
            if not (pos[2]-1 == target[2]) or ((target[2] > 0) and not (pos[2] == 0)) then
                table.insert(included_sides, digLeft)
            end
        end
    end
    digShaft(target[1], included_sides)
end

local function layerDone(is_increasing, p, t)
    if is_increasing then
        return math.abs(p-t) <= 2
    else
        return math.abs(p) <= 1
    end
end
local function quarryLayer(target)
    local is_increasing = false
    if pos[2] == 0 or math.abs(pos[2]) == 1 then
        is_increasing = true
    end
    while true do
        quarryShaft(target)
        if layerDone(is_increasing, pos[2], target[2]) then
            break
        end
        if turn_direction_right then
            turnRight()
        else
            turnLeft()
        end
        if test_full(13) then
            forward_and_empty()
        else
            forward()
        end
        dig()
        forward()
        if turn_direction_right then
            turnRight()
        else
            turnLeft()
        end
        turn_direction_right = not turn_direction_right
    end
end

local function quarryAll(target)
    local row_start_offset = false
    local row_end_offset = false
    if target[2] % 2 == 0 then
        row_end_offset = true
    end
    while target[3]-pos[3] > 1 do
        if row_start_offset then
            if turn_direction_right then
                turnRight()
                dig()
                forward()
                turnLeft()
            else
                turnLeft()
                dig()
                forward()
                turnRight()
            end
        end
        quarryLayer(target)
        if turn_direction_right then
            turnRight()
        else
            turnLeft()
        end
        if row_end_offset then
            forward()
        end
        if turn_direction_right then
            turnRight()
        else
            turnLeft()
        end

        local tmp = not row_start_offset
        row_start_offset = not row_end_offset
        row_end_offset = tmp

        if target[3] > 0 then
            digUp()
            up()
            if target[3]-pos[3] > 1 then
                digUp()
                up()
            end
        else
            digDown()
            down()
            if target[3]-pos[3] > 1 then
                digDown()
                down()
            end
        end
    end
    quarryLayer(target)
end
quarryAll({tonumber(arg[1]), tonumber(arg[2]), tonumber(arg[3])})
print("actual fuel use:", startFuel-turtle.getFuelLevel())
