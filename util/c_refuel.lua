local moveBackSlot = 0
for slot=1, 16, 1 do
    local slotinfo = turtle.getItemDetail(slot)
    if slotinfo == nil then goto continue end
    if slotinfo.name == "minecraft:bucket" then
        turtle.select(slot)
        if not (turtle.getItemCount() == 1) then
            for mty_slot=1, 16, 1 do
                local mty_slotinfo = turtle.getItemDetail(mty_slot)
                if mty_slotinfo == nil then
                    moveBackSlot = slot
                    turtle.transferTo(mty_slot, 1)
                    turtle.select(mty_slot)
                    goto refuel
                end
            end
        end
        goto refuel
    end
    ::continue::
end
goto exit

::refuel::
while turtle.getFuelLevel() < 19000 do
    local has_block, block_info = turtle.inspect()
    if not has_block then break end
    if (block_info.name == "minecraft.lava_cauldron") then
        turtle.place()
        turtle.refuel()
    end
    turtle.turnRight()
    if turtle.detect() then
        goto exit
    end
    turtle.forward()
    turtle.turnLeft()
end
::exit::

if not (moveBackSlot == 0) then
    turtle.transferTo(moveBackSlot)
end
turtle.select(1)
