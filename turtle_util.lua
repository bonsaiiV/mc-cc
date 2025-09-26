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
    pos[1] = pos[1] + pos_1_updates[facing+2]
    pos[2] = pos[2] + pos_1_updates[facing+1]
    turtle.forward()
end
function back()
    pos[1] = pos[1] - pos_1_updates[facing+2]
    pos[2] = pos[2] - pos_1_updates[facing+1]
    turtle.back()
end
function turnRight()
    facing = (facing + 1) % 4
    turtle.turnRight()
end
function turnLeft()
    facing = (facing + 3) % 4
    turtle.turnLeft()
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
function empty_inventory(max_slot)
        for slot=1, 1, max_slot do
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
        turtle.select(16)
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
function test_full()
    turtle.select(14)
    return not (turtle.getItemDetail() == nil)
end
