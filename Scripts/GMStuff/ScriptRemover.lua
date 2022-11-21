function onLoad(save_state)
    createButtons()
end

function createButtons()
    local my_scale = self.getScale()
    my_scale[1] = my_scale[1]*25
    my_scale[2] = 0.45
    my_scale[3] = my_scale[3]*25
    self.createButton({
        click_function = "removeScript",
        function_owner = self,
        position       = {0,0.585,0},
        width          = 8000,
        height         = 8000,
        color          = {0,0,0,0},
    })
end

function createZone()
    local my_scale = self.getScale()
    my_scale[1] = my_scale[1]*25
    my_scale[2] = 0.45
    my_scale[3] = my_scale[3]*25
    local my_position = self.getPosition()+vector(0, 0.22, 0)
    spawnObject({type = "ScriptingTrigger", position = my_position, scale = my_scale, rotation = self.getRotation(), callback_function = function(obj) setZone(obj) end})
end

function setZone(obj)
    zone = obj.getGUID()
    Wait.frames(function()
        obj.destruct()
        end,
        3)
end


function myGetObjects()
    objects = getObjectFromGUID(zone).getObjects()
end

function removeScript()
    if player_color ~= "Black" then
        return
    end
    
    createZone()
    Wait.frames(myGetObjects, 2)
    Wait.frames(function()
        for _, obj in pairs(objects) do
            if obj ~= self then      
                obj.setLuaScript("")
                obj.reload()
            end
        end
    end,
    2)
end