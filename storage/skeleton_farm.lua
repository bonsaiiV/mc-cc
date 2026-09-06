local peripherals = {
    ["inv_default"] = {
        ["type"] = "minecraft:barrel",
    },
    ["inv_farm_output_direct"] =  {
        ["type"] = "minecraft:barrel",
    },
    ["inv_farm_output_network"] =  {
        ["type"] = "minecraft:barrel",
    },
    ["inv_furnace_fuel"] =  {
        ["type"] = "minecraft:barrel",
    },
    ["inv_furnace_input"] =  {
        ["type"] = "minecraft:barrel",
    },
    ["inv_furnace_output"] =  {
        ["type"] = "minecraft:barrel",
    },
    ["inv_oven"] =  {
        ["type"] = "minecraft:furnace",
    },
    ["inv_popped_shulker_barrel"] =  {
        ["type"] = "minecraft:barrel",
    },
    ["inv_shulker_barrel"] =  {
        ["type"] = "minecraft:barrel",
    },
    ["inv_shulker_dispenser"] =  {
        ["type"] = "minecraft:dispenser",
    },
    ["inv_shulker"] =  {
        ["type"] = "minecraft:barrel",
    },
    ["inv_trash"] =  {
        ["type"] = "minecraft:barrel",
    },
    ["rr_shulker_1"] =  {
        ["type"] = "redstone_relay",
    },
    ["rr_shulker_2"] =  {
        ["type"] = "redstone_relay",
    },
}


local shulker_slots = {
    ["minecraft:bone"] = 1,
    ["minecraft:arrow"] = 2,
}

local function pop_shulker(slot)
    peripherals.rr_shulker_1.ref.setOutput("front", true) -- extend piston
    peripherals.rr_shulker_2.ref.setOutput("front", false) -- collect shulker with hopper
    peripherals.rr_shulker_1.ref.setOutput("front", false) -- retract piston
    os.sleep(0.1)
    peripherals.rr_shulker_2.ref.setOutput("front", true) -- block hopper again
    peripherals.inv_popped_shulker_barrel.pushItems(peripheral.getName(peripherals.inv_shulker_barrel), slot)
end

local function place_shulker(slot)
    peripherals.inv_shulker_dispenser.pullItems(peripheral.getName(peripherals.inv_shulker_barrel), slot)
    os.sleep(0.1)
    peripherals.rr_shulker_1.ref.setOutput("bottom", true) -- power dispenser
    peripherals.rr_shulker_1.ref.setOutput("bottom", false) -- depower dispenser again
end

local function pull_to_shulker(slot)
    peripherals.inv_shulker.pullItems(peripheral.getName(peripherals.inv_farm_output_direct), slot)
end

local function move_to_shulker_if_full(slot_info, slot)
    if slot_info.count == 64 then
        place_shulker(shulker_slots[slot_info.name])
        pull_to_shulker(slot)
        pop_shulker()
    end
end

local function move_to_inv(inv, slot)
    inv.pullItems(peripheral.getName(peripherals.inv_farm_output_network), slot)
end

local function move_to_furnace_fuel(_, slot)
    move_to_inv(peripherals.inv_furnace_fuel, slot)
end
local function move_to_furnace_input(_, slot)
    move_to_inv(peripherals.inv_furnace_input, slot)
end
local function delete_item(_, slot)
    move_to_inv(peripherals.inv_trash, slot)
end
local function move_to_default(_, slot)
    move_to_inv(peripherals.inv_default, slot)
end

local function manage_furnace()
    -- TODO
end

local item_handlers = {
    ["minecraft:bone"] = move_to_shulker_if_full,
    ["minecraft:arrow"] = move_to_shulker_if_full,
    ["minecraft:rotten_flesh"] = move_to_shulker_if_full,
    ["minecraft:string"] = move_to_shulker_if_full,
    ["minecraft:spider_eye"] = move_to_shulker_if_full,
    ["minecraft:gunpowder"] = move_to_shulker_if_full,
    ["minecraft:slime"] = move_to_shulker_if_full,

    ["minecraft:bow"] = move_to_furnace_fuel,

    ["minecraft:golden_helmet"] = move_to_furnace_input,
    ["minecraft:golden_chestplate"] = move_to_furnace_input,
    ["minecraft:golden_leggings"] = move_to_furnace_input,
    ["minecraft:golden_boots"] = move_to_furnace_input,

    ["minecraft:iron_helmet"] = move_to_furnace_input,
    ["minecraft:iron_chestplate"] = move_to_furnace_input,
    ["minecraft:iron_leggings"] = move_to_furnace_input,
    ["minecraft:iron_boots"] = move_to_furnace_input,

    ["minecraft:chainmail_helmet"] = move_to_furnace_input,
    ["minecraft:chainmail_chestplate"] = move_to_furnace_input,
    ["minecraft:chainmail_leggings"] = move_to_furnace_input,
    ["minecraft:chainmail_boots"] = move_to_furnace_input,

    ["minecraft:leather_helmet"] = delete_item,
    ["minecraft:leather_chestplate"] = delete_item,
    ["minecraft:leather_leggings"] = delete_item,
    ["minecraft:leather_boots"] = delete_item,

    ["minecraft:copper_helmet"] = move_to_furnace_input,
    ["minecraft:copper_chestplate"] = move_to_furnace_input,
    ["minecraft:copper_leggings"] = move_to_furnace_input,
    ["minecraft:copper_boots"] = move_to_furnace_input,

    ["minecraft:diamond_helmet"] = delete_item,
    ["minecraft:diamond_chestplate"] = delete_item,
    ["minecraft:diamond_leggings"] = delete_item,
    ["minecraft:diamond_boots"] = delete_item,
}

local function main_loop()
    local sleep_duration = 10 -- sleep duration in seconds
    local seconds_max = 600  -- max interval
    local furnace_interval = 60 -- time in seconds
    local counter = 0
    while true do
        for slot in 16, 1, -1 do
            local slot_info = peripherals.inv_farm_output_direct.getItemDetail(slot)
            if not slot_info then
                goto continue
            end
            local handler = item_handlers[slot_info.name]
            if handler then
                handler(slot_info, slot)
            else
                move_to_default(slot_info, slot)
            end
            ::continue::
        end

        if counter % (furnace_interval / sleep_duration) then
            manage_furnace()
        end

        if counter == seconds_max / sleep_duration then
            counter = 1
        else
            counter = counter + 1
        end
        os.sleep(sleep_duration)
    end
end

-- from here on only setup

local function get_available_peripherals(type)
    local ret = {}
    for _, name in ipairs(peripheral.getNames()) do
        if peripheral.hasType(name, type) then
            table.insert(ret, name)
        end
    end
    return ret
end

local config_file = "skeleton_farm.config"

local function discover_network()
    for line in io.lines(config_file) do
        local t = {}
        for k, v in string.gmatch(line, "([^=]+)") do
            t[k] = v
        end
        local p = peripheral[t[1]]
        if p then
            p.name = t[2]
        end
    end
    local config_changed = 0
    for identifier, p in pairs(peripherals) do
        if p.name then
            p.ref = peripheral.wrap(p.name)
        end
        if not p.ref then
            while 1 do
                local possible_names = get_available_peripherals(p.type)
                print("peripheral \"" .. identifier .. "\" not configured/found")
                for i, name in ipairs(possible_names) do
                    print(i .. ": " .. name)
                end
                print("please enter index of peripheral (or x to exit):")
                io.input(io.stdin)
                local line = read()
                if line == "x" then
                    os.exit()
                end
                local i = tonumber(line)
                if i then
                    p.ref = peripheral.wrap(possible_names[i])
                end
                if p.ref then
                    config_changed = 1
                    break
                end
            end
        end
    end
    if config_changed then
        io.output(io.open(config_file, "w"))
        for identifier, p in pairs(peripherals) do
            write(identifier .. "=" .. p.name)
        end
    end
end

local function init_storage()
    peripherals.rr_shulker_2.setOutput("front", true)
    discover_network()

    local full_slots = 0
    local shulker = peripheral.wrap("left")
    if shulker then
        for _, slot_info in pairs(peripheral.call("left", "list")) do
            if slot_info.count == 64 then
                full_slots = full_slots + 1
            end
        end
    end

end

return {
    autostart_entry = function()
        init_storage()
        main_loop()
    end,
}
