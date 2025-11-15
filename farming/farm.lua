require "util/turtle"

local function leftCorner()
    turtle.turnLeft()
    turtle.forward()
end
local function rightCorner()
    turtle.turnRight()
    turtle.forward()
end

local function wait_for_regrow()
    os.sleep(300)
end

local function c_refuel()
        local has_block, data = turtle.inspect()
            if (has_block and data.name == "minecraft:lava_cauldron") then
            turtle.place()
            turtle.refuel()
        end
end

local function refuel()
    turtle.forward()
    local has_block, data
    if turtle.getFuelLevel() > 19000 then
        goto refuel_end
    end
    if find_in_inventory("minecraft:lava_bucket") then
        turtle.refuel()
        goto refuel_end
    end

    has_block, data = turtle.inspectDown()
    if not has_block then goto  refuel_end end
    find_in_inventory("minecraft:bucket")
    if data.name == "minecraft:red_concrete" then
        turtle.turnLeft()
        c_refuel()
        turtle.turnRight()
    elseif data.name == "minecraft:blue_concrete" then
        turtle.turnRight()
        c_refuel()
        turtle.turnLeft()
    end
    ::refuel_end::
    turtle.select(1)
end

local control_blocks = {}
control_blocks["minecraft:red_concrete"] = turtle.turnLeft
control_blocks["minecraft:blue_concrete"] = turtle.turnRight
control_blocks["minecraft:black_concrete"] = wait_for_regrow
control_blocks["minecraft:yellow_concrete"] = refuel

local crops = {}
crops["minecraft:nether_wart"] = {max_age = 3, seed_name = "minecraft:nether_wart"}

local mineable_blocks = {"minecraft:pointed_dripstone"}

local function step()
    local has_block_down, data_down = turtle.inspectDown()
    if has_block_down then
        local c_fun = control_blocks[data_down.name]
        if c_fun then
            c_fun()
        end

        crop = crops[data_down.name]
        if crop then
            if data_down.state.age == crop.max_age then
                turtle.digDown()
                if turtle.getItemDetail().name == crop.seed_name then
                    turtle.placeDown()
                else
                    if find_in_inventory(crop.seed_name) then
                        turtle.placeDown()
                    end
                    turtle.select(1)
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
    local has_block_fw, data_fw = turtle.inspect()
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
