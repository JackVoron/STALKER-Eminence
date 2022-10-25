zone = nil
car = nil
flag = nil
attributes = {0, 0, 0, 0} -- durability, armor, engine, damage
objects = nil

status = {"http://cloud-3.steamusercontent.com/ugc/1906728766870659940/D42C59CF28EBBF7CB7C533B0A80EA9EF2589FFBD/",
          "http://cloud-3.steamusercontent.com/ugc/1906728766870652420/3E2CD714CD2F7C4214DFE6254D40C0588447ECC9/"}
displays = {{
    position = {2.8, 0.6, -2.7},
    font_size = 1000
}, {
    position = {-4.35, 0.6, -7.25},
    font_size = 600
}, {
    position = {1.1, 0.6, -7.25},
    font_size = 600
}, {
    position = {6.8, 0.6, -7.25},
    font_size = 600
}}

plus_buttons = {{
    position = {-1.75, 0.6, -2.1},
    height = 400,
    width = 550
}, {
    position = {-6.15, 0.6, -7.05},
    height = 300,
    width = 400
}, {
    position = {-0.45, 0.6, -7.05},
    height = 300,
    width = 400
}, {
    position = {5, 0.6, -7.05},
    height = 300,
    width = 400
}}

minus_buttons = {{
    position = {-3.25, 0.6, -2.1},
    height = 400,
    width = 550
}, {
    position = {-7.175, 0.6, -7.05},
    height = 300,
    width = 400
}, {
    position = {-1.5, 0.6, -7.05},
    height = 300,
    width = 400
}, {
    position = {3.95, 0.6, -7.05},
    height = 300,
    width = 400
}}

wheels = {true, true, true, true}

wheels_buttons = {{
    position = {-6.5, 0.6, 1.9},
    height = 1500,
    width = 1500
}, {
    position = {-6.5, 0.6, -2},
    height = 1500,
    width = 1500
}, {
    position = {6.5, 0.6, 1.9},
    height = 1500,
    width = 1500
}, {
    position = {6.5, 0.6, -2},
    height = 1500,
    width = 1500
}}

function onSave()
    data_to_save = {car, flag, attributes, wheels}
    saved_data = JSON.encode(data_to_save)
    return saved_data
end

function onLoad(save_state)
    if save_state ~= nil then
        loaded_data = JSON.decode(save_state)
        car = loaded_data[1]
        flag = loaded_data[2]
        attributes = loaded_data[3]
        wheels = loaded_data[4]
    end

    self.addContextMenuItem("Запомнить машину", rememberCar)
    createButtons()
    if getObjectFromGUID(car) then
        getObjectFromGUID(car).reload()
    end
end

function createButtons()
    self.createButton({
        click_function = "light",
        function_owner = self,
        position = {0, 0.6, 6},
        width = 3200,
        height = 1850,
        font_size = 1000,
        color = {1, 1, 1, 0}
    })

    for i = 1, 4 do
        self.createButton({
            click_function = "rememberCar",
            function_owner = self,
            label = attributes[i],
            position = displays[i].position,
            width = 0,
            height = 0,
            font_size = displays[i].font_size,
            font_color = {0, 0, 0, 0.95}
        })
    end

    for i = 1, 4 do
        local funcname = "plusAttribute" .. i
        local func = function()
            changeAttribute(i, false)
        end
        self.setVar(funcname, func)
        self.createButton({
            click_function = funcname,
            function_owner = self,
            position = plus_buttons[i].position,
            width = plus_buttons[i].width,
            height = plus_buttons[i].height,
            color = {0, 0, 0, 0}
        })
        local funcname = "minusAttribute" .. i
        local func = function()
            changeAttribute(i, true)
        end
        self.setVar(funcname, func)

        self.createButton({
            click_function = funcname,
            function_owner = self,
            position = minus_buttons[i].position,
            width = minus_buttons[i].width,
            height = minus_buttons[i].height,
            color = {0, 0, 0, 0}
        })
    end

    for i = 1, 4 do
        local funcname = "changeWheelStatus" .. i
        local func = function()
            changeWheelStatus(i)
        end
        self.setVar(funcname, func)
        self.createButton({
            click_function = funcname,
            function_owner = self,
            position = wheels_buttons[i].position,
            width = wheels_buttons[i].width,
            height = wheels_buttons[i].height,
            color = {0,0,0,0},
        })
    end
    for i = 1, 4 do
        local funcname = "changeWheelStatus" .. i
        local func = function()
            changeWheelStatus(i)
        end

        if wheels[i] == true then
            my_label = ""
        else
            my_label = "X"
        end

        self.setVar(funcname, func)
        pos = wheels_buttons[i].position
        pos[3] = pos[3] + 0.3
        self.createButton({
            click_function = funcname,
            function_owner = self,
            position = pos,
            width = 0,
            height = 0,
            label = my_label,
            font_size = 1000,
            color = {0,0,0,0.995}
        })
    end
end

function changeWheelStatus(i)
    if wheels[i] == true then
        wheels[i] = false
        self.editButton({
            index = 16 + i,
            label = "X"
        })
    else
        wheels[i] = true
        self.editButton({
            index = 16 + i,
            label = ""
        })
    end
end

function changeAttribute(i, negative)
    if negative == true then
        if attributes[i] > 0 then
            attributes[i] = attributes[i] - 1
        end
    else
        if attributes[i] < 100 then
            attributes[i] = attributes[i] + 1
        end
    end
    self.editButton({
        index = i,
        label = attributes[i]
    })
end

function light()
    if getObjectFromGUID(car) then
        local children = self.removeAttachments()
        local icon = nil
        for _, v in pairs(children) do
            icon = v
        end
        if flag == true then

            local car_obj = getObjectFromGUID(car)
            local lights = car_obj.removeAttachments()
            local lock = car_obj.getLock()
            car_obj.setLock(true)

            for _, light in pairs(lights) do
                light.AssetBundle.playLoopingEffect(0)
                car_obj.addAttachment(light)
            end

            car_obj.setLock(lock)
            car_obj.reload()
            icon.setCustomObject({
                diffuse = status[1]
            })
            flag = false
        else

            local car_obj = getObjectFromGUID(car)
            local lights = car_obj.removeAttachments()
            local lock = car_obj.getLock()
            car_obj.setLock(true)

            for _, light in pairs(lights) do
                light.AssetBundle.playLoopingEffect(3)
                car_obj.addAttachment(light)
            end
            icon.setCustomObject({
                diffuse = status[2]
            })
            car_obj.setLock(lock)
            car_obj.reload()
            flag = true
        end
        self.addAttachment(icon)
    end
end

function rememberCar()
    createZone()
    Wait.frames(myGetObjects,2)
    Wait.frames(function()
            for _, v in pairs(objects) do
                car = v.getGUID()
            end   
    end, 
    2)
end

function myGetObjects()
    objects = getObjectFromGUID(zone).getObjects()
end

function createZone()
    local my_scale = self.getScale()
    my_scale[1] = my_scale[1]*0.8
    my_scale[2] = 0.2
    my_scale[3] = my_scale[3]*0.8
    local my_position = self.positionToWorld(self.getSnapPoints()[1].position) + vector(0, 1, 0)
    zone = spawnObject({type = "ScriptingTrigger", position = my_position, scale = my_scale, rotation = self.getRotation(), callback_function = function(obj) setZone(obj) end}).getGUID()
end

function setZone(obj)
    Wait.frames(function()
        obj.destruct()
        end,
        3)
end