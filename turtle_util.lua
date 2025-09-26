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
