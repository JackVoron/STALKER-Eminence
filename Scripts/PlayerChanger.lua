script = [[
    function onLoad()
        saved = self.memo
        memory = JSON.decode(saved)
        self.addContextMenuItem("Выложить", unpackPlayer)
    end
    function unpackPlayer()
        local changer_pos = self.getPosition()
        for guid, obj_params in pairs(memory) do
            local new_pos = obj_params.pos
            new_pos[1] = new_pos[1] + changer_pos[1]
            new_pos[3] = new_pos[3] + changer_pos[3]
            local obj = self.takeObject({
                position          = new_pos,
                callback_function = function(obj)
                     obj.setLock(obj_params.lock)
                     obj.setRotation(obj_params.rot)
                    end,
                guid              = guid,
            })
            Wait.frames(function()
                obj.setPosition(new_pos)
            end, 30)
        end
        self.destruct()
    end
]]

function onLoad(save_state)
    self.addContextMenuItem("Сложить", packPlayer)
end

function packPlayer()
    memory = {}

    bag = spawnObject({
        type              = "Bag",
        position          = self.getPosition() + vector(0,4,0),
        snap_to_grid      = true,
    })
    local zone = getObjectFromGUID(self.getGMNotes())
    new_pos =  zone.getPosition()
    new_pos[2] = self.getPosition()[2]

    zone.setPosition(new_pos)
    Wait.frames(function()
        bag.setLock(true)
        for _, object in pairs(zone.getObjects()) do
            if object.hasTag("player_changer") == false then
                if object.hasTag("player_figurine") then
                    local my_color = object.getColorTint()
                    bag.setName("[" .. my_color:toHex(false) .. "]" .. "[b]" .. object.getName())
                    bag.setColorTint(my_color)
                end
                local obj_pos = object.getPosition()
                local changer_pos = self.getPosition()
                memory[object.getGUID()] = {pos = {obj_pos[1] - changer_pos[1], obj_pos[2], obj_pos[3] - changer_pos[3]}, lock = object.getLock(), rot = object.getRotation()}
                bag.putObject(object)
            end
        end
        bag.setLock(false)
        bag.setLuaScript(script)
        bag.memo = JSON.encode(memory)
        bag.reload()
        zone.setPosition(new_pos - vector(0,15,0)) 
    end, 5)
end