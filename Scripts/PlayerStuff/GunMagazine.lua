transparent_color = {1,1,1,0}
bullets = {}
zones = {}
objects = nil


main_buttons_params = {
    {
        click_func = "changeState", func_owner = self, label = "I",
        pos = {-1.585,0.15,-0.825}, w = 600, h = 600, fs = 550,
        color = transparent_color,
    },
    {
        click_func = "Shoot", func_owner = self, label = "",
        pos = {1.585,0.15,-0.825}, w = 600, h = 600, fs = 550,
        color = transparent_color,
    },
    {
        click_func = "Unload", func_owner = self, label = "",
        pos = {-1.815,0.15,0.65}, w = 400, h = 770, fs = 550,
        color = transparent_color,
    },
    {
        click_func = "Reload", func_owner = self, label = "",
        pos = {1.815,0.15,0.65}, w = 400, h = 770, fs = 550,
        color = transparent_color,
    },
}

stacks_params ={
    {
        {
            click_func = "none", func_owner = self, label = "",
            pos = {-0.675,0.15,0.8625}, w = 180, h = 80, fs = 10,
        },
        {
            click_func = "none", func_owner = self, label = "",
            pos = {-0.675,0.15,1.09}, w = 180, h = 80, fs = 10,
        },
        {
            click_func = "none", func_owner = self, label = "",
            pos = {-0.675,0.15,1.325}, w = 180, h = 80, fs = 10,
        },
        {
            click_func = "none", func_owner = self, label = "",
            pos = {-1.235,0.15,1.325}, w = 80, h = 80, fs = 10,
        },
        {
            click_func = "none", func_owner = self, label = "",
            pos = {-1.005,0.15,1.325}, w = 80, h = 80, fs = 10,
        },
    },
    {
        {
            click_func = "none", func_owner = self, label = "",
            pos = {0.225,0.15,0.8625}, w = 180, h = 80, fs = 10,
        },
        {
            click_func = "none", func_owner = self, label = "",
            pos = {0.225,0.15,1.09}, w = 180, h = 80, fs = 10,
        },
        {
            click_func = "none", func_owner = self, label = "",
            pos = {0.225,0.15,1.325}, w = 180, h = 80, fs = 10,
        },
        {
            click_func = "none", func_owner = self, label = "",
            pos = {-0.33,0.15,1.325}, w = 80, h = 80, fs = 10,
        },
        {
            click_func = "none", func_owner = self, label = "",
            pos = {-0.095,0.15,1.325}, w = 80, h = 80, fs = 10,
        },
    },
    {
        {
            click_func = "none", func_owner = self, label = "",
            pos = {1.155,0.15,0.8625}, w = 180, h = 80, fs = 10,
        },
        {
            click_func = "none", func_owner = self, label = "",
            pos = {1.155,0.15,1.09}, w = 180, h = 80, fs = 10,
        },
        {
            click_func = "none", func_owner = self, label = "",
            pos = {1.155,0.15,1.325}, w = 180, h = 80, fs = 10,
        },
        {
            click_func = "none", func_owner = self, label = "",
            pos = {0.585,0.15,1.325}, w = 80, h = 80, fs = 10,
        },
        {
            click_func = "none", func_owner = self, label = "",
            pos = {0.82,0.15,1.325}, w = 80, h = 80, fs = 10,
        },
    }
}

function none()
    printToAll("Если это сообщение напечаталось, то на кнопку загрузилась неправильная функция")
end

function onSave()
    self.UI.setCustomAssets({
        {
            type = 1,
            name = "cifont",
            url = "http://cloud-3.steamusercontent.com/ugc/1986680868878944084/44125D7412F853AA4ED4A3701035C20D4FE14E90/",
        }
    })
    data_to_save = {bullets}
    saved_data = JSON.encode(data_to_save)
    return saved_data
end

function onLoad(save_state)
    if save_state ~= '' then
        loaded_data = JSON.decode(save_state)
        bullets = loaded_data[1]
    else
        printToAll("Сохранённые данные не найдены")
        bullets = {
            type0 = 0, -- magazine
            type1 = 0,
            type2 = 0,
            type3 = 0,
            current_state = 1
        }
    end
    createButtons()
end

function createButtons()
    result_xml = [[<Text
    id="0"
    height="300"
    width="300"
    color="#bdb56b"
    fontSize="210"
    font="cifont/cifont"
    rotation="180 180 0"
    horizontalOverflow="overflow"
    verticalOverflow="overflow"
    position="0 -85 -12"
    text="error"
    scale = "0.5 0.5 0.5"
/>
]]
    for i=1,3 do
        x = 90-(i-1)*91
        xml = [[
        <Text
            id="]] .. i .. [["
            height="300"
            width="300"
            color="#000000"
            fontSize="100"
            font="cifont/cifont"
            rotation="180 180 0"
            horizontalOverflow="overflow"
            verticalOverflow="overflow"
            position="]] .. x .. [[ 30 -12"
            text="error"
            scale = "0.5 0.5 0.5"
        />
        ]]
        result_xml = result_xml .. xml .. "\n" 
    end
    self.UI.setXml(result_xml)

    for i, data in pairs(main_buttons_params) do
        self.createButton({click_function = data.click_func, function_owner = data.func_owner, label = data.label,
        position = data.pos, width = data.w, height = data.h, font_size = data.fs, color = transparent_color})
    end

    for i, stack in pairs(stacks_params) do
        for j, data in pairs(stack) do
            local funcname = "changeBulletQuantity" .. i .. j
            local func
            if j == 1 then
                func = function(obj, color) changeBulletsQuantity(i, j, color) end
            elseif j == 2 then
                func = function(obj, color) changeBulletsQuantity(i, 5, color) end
            elseif j == 3 then
                func = function(obj, color) changeBulletsQuantity(i, 20, color) end
            elseif j == 4 then
                func = function(obj, color) changeBulletsQuantity(i, "C", color) end
            elseif j == 5 then
                func = function(obj, color) changeBulletsQuantity(i, -1, color) end
            end
            self.setVar(funcname, func)
            self.createButton({click_function = funcname, function_owner = data.func_owner, label = data.label,
            position = data.pos, width = data.w, height = data.h, font_size = data.fs, color = transparent_color})
        end
    end
    
    Wait.frames(updateDisplays, 5)
end

function changeBulletsQuantity(type, quantity, color)
    if quantity == "C" then
        if Player[color].admin then
            bullets["type" .. type] = 0
        end
    else
        bullets["type" .. type] = bullets["type" .. type] + quantity
        if bullets["type" .. type] < 0 then
            bullets["type" .. type] = 0
        end
    end
    updateDisplays()
end

function changeState()
    createZones()
    if bullets.type0 == 0 then
        if bullets.current_state < 3 then
            bullets.current_state = bullets.current_state + 1
        else
            bullets.current_state = 1
        end
        Wait.frames(function() myGetObjects(bullets.current_state) end, 2)
        Wait.frames(function()
            local flag = true
            for _, obj in pairs(objects) do
                flag = false
                local params = obj.getCustomObject()
                local child = self.removeAttachments()
                local obj_color = obj.getColorTint()
                for __, icon in pairs(child) do
                    icon.setCustomObject({image = params.image})
                    icon.setColorTint(obj_color)
                    self.addAttachment(icon)
                end
            end
            if flag == true then
                local child = self.removeAttachments()
                for __, icon in pairs(child) do
                    icon.setCustomObject({image = "http://cloud-3.steamusercontent.com/ugc/1858313783657192257/FFF59914C69B0187188D27968996A0CD4FC15D5E/"})
                    icon.setColorTint({1,1,1})
                    self.addAttachment(icon)
                end
            end
        end,
        2)
    else
        printToAll("Невозможно переключить тип боеприпасов т.к. в магазине находятся патроны")
    end
end

function myGetObjects(i)
    objects = getObjectFromGUID(zones[i]).getObjects()
end

function Unload()
    local temp_bullets = bullets.type0
    bullets.type0 = 0
    changeBulletsQuantity(bullets.current_state, temp_bullets)
end

function Reload()
    local t = getSettings()
    local bullets_to_load = t.max_bullets - bullets.type0
    if bullets_to_load <= bullets["type" .. bullets.current_state] then
        bullets.type0 = t.max_bullets
        bullets["type" .. bullets.current_state] = bullets["type" .. bullets.current_state] - bullets_to_load
    else
        bullets.type0 = bullets.type0 + bullets["type" .. bullets.current_state]
        bullets["type" .. bullets.current_state] = 0
    end
    updateDisplays()
end

function Shoot()
    local t = getSettings()
    if bullets.type0 >= t.bullets_to_shoot then
        bullets.type0 = bullets.type0 - t.bullets_to_shoot
    else
        printToAll("Не хватает патронов")
    end
    updateDisplays()
end

function updateDisplays()
    for i=0,3 do
        local new_lable
        if bullets["type" .. i] > 999 then
            local y = bullets["type" .. i] / 1000
            new_lable = y - y % 1 .. "к "
        else
            new_lable = bullets["type" .. i]
        end
        
        self.UI.setAttribute(tostring(i), "text", new_lable)
    end
end

function getSettings()
    local t = {}
    for k in string.gmatch(self.getGMNotes(), "([^\n]+)") do
        for name, value in string.gmatch(k, "(.+)%s+=%s+(.+)") do
            t[name] = tonumber(value)
        end
    end
    return t
end

function createZones()
    for i = 1, 3 do
        local my_scale = self.getScale()
        my_scale[1] = my_scale[1]*0.4
        my_scale[2] = 0.2
        my_scale[3] = my_scale[3]*0.4
        local my_position = self.positionToWorld(self.getSnapPoints()[i].position)+vector(0, 0.15, 0)
        spawnObject({type = "ScriptingTrigger", position = my_position, scale = my_scale, rotation = self.getRotation(), callback_function = function(obj) setZone(obj, i) end})
    end
end

function setZone(obj, i)
    zones[i] = obj.getGUID()
    Wait.frames(function()
        obj.destruct()
        end,
        3)
end