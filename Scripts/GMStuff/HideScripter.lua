script_main = [[
    isHide = 0

function onSave()
    saved_date = JSON.encode(isHide)
    return saved_data
end

function onLoad(saved_data)
    isHide = JSON.decode(saved_data)
    if isHide == 1 then
        setHide()
        setHide()
    end
    self.addContextMenuItem("Спрятать/Показать", setHide)
end

function setHide(player_color)
    if player_color ~= "Black" and player_color ~= nil then
        return
    end
    
    if isHide ~= 1 then
        self.setInvisibleTo({"White", "Brown", "Red", "Orange", "Yellow", "Green", "Teal", "Blue", "Purple", "Pink", "Grey"})
        self.highlightOn({0.5,0.5,0.5})
        for _, joint_obj in pairs(self.getJoints()) do
            obj = getObjectFromGUID(joint_obj.joint_object_guid)
            obj.setInvisibleTo({"White", "Brown", "Red", "Orange", "Yellow", "Green", "Teal", "Blue", "Purple", "Pink", "Grey"})
            obj.highlightOn({0.5,0.5,0.5})
        end
        isHide = 1
    else
        self.setInvisibleTo()
        self.highlightOff()
        for _, joint_obj in pairs(self.getJoints()) do
            obj = getObjectFromGUID(joint_obj.joint_object_guid)
            obj.setInvisibleTo()
            obj.highlightOff()
        end
        isHide = 0
    end
end
]]

script_jointed = [[
    function onLoad()
        self.addContextMenuItem("Спрятать/Показать", setHide)
    end
    
    function setHide(player_color)
        if player_color ~= "Black" then
            return
        end
        if getObjectFromGUID(GUID) then
            obj = getObjectFromGUID(GUID)
            obj.call("setHide")
        end
    end
]]

function onLoad(save_state)
    createButtons()
end

function createButtons()
    local my_scale = self.getScale()
    my_scale[1] = my_scale[1]*25
    my_scale[2] = 0.45
    my_scale[3] = my_scale[3]*25
    self.createButton({
        click_function = "setScript",
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

function setScript()
    createZone()
    Wait.frames(myGetObjects, 2)
    Wait.frames(function()
        local t = {}
        local main = {}
        for _, obj in pairs(objects) do
            if obj ~= self then
                local guid = obj.getGUID()
                main[guid] = true
                for _, jointed in pairs(obj.getJoints()) do
                    t[jointed.joint_object_guid] = guid
                end     
                obj.setLuaScript(script_main)
            end
        end

        for joinGUID, mainGUID in pairs(t) do
            local obj = getObjectFromGUID(joinGUID)
            obj.setLuaScript("GUID = " .. "'" .. mainGUID .. "'" .. "\n" .. script_jointed)
            main[joinGUID] = false
        end

        for _, obj in pairs(objects) do
            obj.reload()
        end

        for joinGUID, mainGUID in pairs(t) do
            local obj = getObjectFromGUID(joinGUID)
            getObjectFromGUID(mainGUID).jointTo(obj,{type = "Fixed",})
        end

        for guid, isMain in pairs(main) do
            if isMain == true then            
                local obj = getObjectFromGUID(guid)
                print(obj)
                Wait.frames(function() obj.call("setHide") end, 1)
            end
        end
    end,
    2)
end
