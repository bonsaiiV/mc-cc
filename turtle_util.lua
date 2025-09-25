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
    while turtle.digUp() do
    end
end

forward = turtle.forward
back = turtle.back
dig = turtle.dig
turnRight = turtle.turnRight
turnLeft = turtle.turnLeft
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
