require "util/turtle"

local function leftCorner()
    turtle.turnLeft()
    turtle.forward()
end
local function rightCorner()
    turtle.turnRight()
    turtle.forward()
end

local control_blocks = {}
control_blocks["minecraft:red_concrete"] = leftCorner
control_blocks["minecraft:blue_concrete"] = rightCorner

local crops = {}
crops["minecraft:netherwart"] = {max_age = 3, seed_name = "minecraft:netherwart"}

local mineable_blocks = {"minecraft:dripstone"}

local function step()
    local has_block_down, data_down = turtle.inspectDown()
    local has_block_fw, data_fw = turtle.inspect()
    if has_block_down then
        local c_fun = control_blocks[data_down.name]
        if c_fun then
            c_fun()
            return
        end

        crop = crops[data_down.name]
        if crop then
            if data_down.state.age == crop.max_age then
                turtle.digDown()
                if turtle.getItemDetails().name == crop.seed_name then
                    turtle.place()
                else
                    if find_in_inventory(crop.seed_name) then
                        turtle.place()
                    end
                end
            end
        else
            for _, name in pairs(mineable_blocks) do
                if name == data_down.name then
                    turtle.digDown()
                    break
                end
            end
        end
    end
    if has_block_fw then
        for _, name in pairs(mineable_blocks) do
            if name == data_fw.name then
                turtle.dig()
                goto dug
            end
        end
        turtle.turnLeft()
        ::dug::
    end
    forward()
end

while true do
    step()
end
