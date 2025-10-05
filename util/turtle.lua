pos = {0, 0, 0}
facing = 0

function down()
    pos[3] = pos[3] - 1
    turtle.down()
end
function up()
    pos[3] = pos[3] + 1
    turtle.up()
end
digDown = turtle.digDown
function digUp()
    while turtle.digUp() do end
end
function dig()
    while turtle.dig() do end
end
local pos_1_updates = {
    0, 1, 0, -1, 0
}
function forward()
    if turtle.forward() then
        pos[1] = pos[1] + pos_1_updates[facing+2]
        pos[2] = pos[2] + pos_1_updates[facing+1]
        return true
    else
        return false
    end
end
function back()
    if turtle.back() then
        pos[1] = pos[1] - pos_1_updates[facing+2]
        pos[2] = pos[2] - pos_1_updates[facing+1]
        return true
    else
        return false
    end
end
function turnRight()
    if turtle.turnRight() then
        facing = (facing + 1) % 4
        return true
    else
        return false
    end
end
function turnLeft()
    if turtle.turnLeft() then
        facing = (facing + 3) % 4
        return true
    else
        return false
    end
end
function turn_to(target_facing)
    if target_facing > 3 then return false end
    if target_facing == (facing+1)%4 then
        return turnRight()
    else
        while not (facing == target_facing) do
            turnLeft()
        end
    end
end
function digLeft()
    turnLeft()
    dig()
    turnRight()
end
function digRight()
    turnRight()
    dig()
    turnLeft()
end
digs = {
    dig
    ,digDown
    ,digUp
    ,digLeft
    ,digRight
}
function noop(...) end
moves = {
    noop
    ,forward
    ,back
}
function dig_and_move()
    dig()
    forward()
end
function dig_and_move_up()
    dig()
    forward()
end

function move_to(target)
    if target[1] > pos[1] then
        turn_to(0)
    end
    if target[1] < pos[1] then
        turn_to(2)
    end
    while not (target[1] == pos[1]) do
        dig_and_move()
    end

    if target[1] > pos[1] then
        turn_to(1)
    end
    if target[1] < pos[1] then
        turn_to(3)
    end
    while not (target[2] == pos[2]) do
        dig_and_move()
    end

    while not (target[3] == pos[3]) do
        dig_and_move_up()
    end
end
function move_by(target)
    for d=1, 3, 1 do
        target[d] = target[d] + pos[d]
    end
    move_to(target)
end
function move_to_clamped(target, min, max)
    for d=1, 3, 1 do
        if target[d] < min[d] then
            target[d] = min[d]
        end
        if target[d] > max[d] then
            target[d] = max[d]
        end
    end
    move_to(target)
end

function empty_inventory(max_slot)
        for slot=max_slot, 1, -1 do
            turtle.select(slot)
            turtle.drop()
        end
end
function place_and_empty()
    turtle.select(16)
    local item_detail = turtle.getItemDetail()
    if not (item_detail == nil) and (item_detail.name == "minecraft:barrel" or item_detail.name == "minecraft:chest") then
        turtle.place()
        empty_inventory(15)
        turtle.select(1)
    end
end
function forward_and_empty()
    forward()
    turtle.turnLeft()
    turtle.turnLeft()
    place_and_empty()
    turtle.turnLeft()
    turtle.turnLeft()
end
function test_full(test_slot)
    turtle.select(test_slot)
    local ret = not (turtle.getItemDetail() == nil)
    turtle.select(1)
    return ret
end

function quarryStep(dig_sides, move)
    for dig_side in dig_sides.values() do
        dig_side()
    end
    move()
end

function digShaft(len, included_sides)
    while len > 1 do
        quarryStep(included_sides, dig_and_move)
    end
    quarryStep(included_sides, noop)
end

