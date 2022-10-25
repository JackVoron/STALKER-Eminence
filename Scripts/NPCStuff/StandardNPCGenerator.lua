
zones = {}
current_fraction = 1
objects = nil

fractions = {
    "https://cdn.discordapp.com/attachments/993099091674398741/1003314828158439504/ef924dd3a2d389a5.png?size=4096",
    "https://cdn.discordapp.com/attachments/993099091674398741/1003314830201065553/7cddd4ff3249f811.png?size=4096",
    "https://cdn.discordapp.com/attachments/993099091674398741/1003314828946964550/1fe240d4300c1c37.png?size=4096",
    "https://cdn.discordapp.com/attachments/993099091674398741/1003314831086067793/149b1d0dca9c4656.png?size=4096",
    "https://cdn.discordapp.com/attachments/993099091674398741/1003314827629961387/97f8e62a96897d0d.png?size=4096",
    "https://cdn.discordapp.com/attachments/993099091674398741/1003314829781643365/faa0bd64608786ce.png?size=4096",
    "https://cdn.discordapp.com/attachments/993099091674398741/1003314831555825734/8b738c385304b67c.png?size=4096",
    "https://cdn.discordapp.com/attachments/993099091674398741/1003314828577886218/d0411ab4332c6845.png?size=4096",
    "https://cdn.discordapp.com/attachments/993099091674398741/1003314829429325834/7bb1768012bb786b.png?size=4096",
    "https://cdn.discordapp.com/attachments/993099091674398741/1003314830599540746/cfd0ecca665c4f22.png?size=4096",
}

fractions_name = {
    "Бандиты", "Одиночки", "Долг", "Свобода", "Чистое Небо", "Наёмники", "Учёные", "Военные", "Монолит", "ООН"
}

function onSave()
    data_to_save = {current_fraction}
    saved_data = JSON.encode(data_to_save)
    return saved_data
end

function onLoad(save_state)
    if save_state ~= '' then
        loaded_data = JSON.decode(save_state)
        current_fraction = loaded_data[1]
        if current_fraction == nil then
            current_fraction = 1
        end
    else
        printToAll("Сохранённые данные не найдены")
    end
    createButtons()
end

function createButtons()
    self.createButton({
        click_function = "mainClick",
        function_owner = self,
        position       = {3.8, 0.8, -3.8},
        width          = 3250,
        height         = 3250,
        color          = {0,0,0,0},
        tooltip        = "Создать NPC",
    })
end

function mainClick(obj, color, alt_click)
    if alt_click == true then
        changeFraction()
    else
        generateNPC()
    end
end

function changeFraction()
    if current_fraction == 10 then
        current_fraction = 0
    end
    current_fraction = current_fraction + 1
    for _, obj in pairs(self.removeAttachments()) do
        obj.setCustomObject({image = fractions[current_fraction]})
        self.addAttachment(obj)
    end
end

function generateNPC()
    createZones()
    Wait.frames(function()
        myGetObjects(1)
        local name_generator = getObjectFromGUID(self.getGMNotes())
        local NPC = objects[1]
        local pos = NPC.getPosition()
        NPC = NPC.clone({
            position     = self.positionToWorld({-3.8, 0.5, -3.8}),
            snap_to_grid = true,
        })
        local name = name_generator.call("generateName", {current_fraction})
        NPC.setName(name)
        NPC.setDescription(fractions_name[current_fraction])
        myGetObjects(3)
        local stats_bag = objects[1]
        local stats_list = stats_bag.getObjects()
        local stats = stats_bag.takeObject({index = math.random(#stats_list) - 1})
        local armor = NPC.getGMNotes()
        NPC.setGMNotes(stats.getGMNotes() .. armor .. "\n" .. stats.getDescription())
        stats_bag.putObject(stats)
        myGetObjects(2)
        local weapon_bag = objects[1]
        local weapons = weapon_bag.getObjects()
        local weapon_orig = weapon_bag.takeObject({index = math.random(#weapons) - 1})
        local weapon = weapon_orig.clone({position = NPC.positionToWorld({0,0,-0.5})})
        weapon_bag.putObject(weapon_orig)
        weapon.setRotation(NPC.getRotation() + vector(0, 180, 0))
        Wait.frames(function()
            local NPC_y = NPC.getPosition()[2]
            local weapon_pos = weapon.getPosition()
            weapon_pos[2] = NPC_y
            weapon.setPosition(weapon_pos)
                Wait.frames(function()
                    NPC.jointTo(weapon,{type = "Fixed",})
                end, 25)
            end, 5)
    end,2)   
end

function createZones()
    for i = 1, 3 do
        local my_scale = self.getScale()
        my_scale[1] = my_scale[1]*9
        my_scale[2] = 1
        my_scale[3] = my_scale[3]*9
        local my_position = self.positionToWorld(self.getSnapPoints()[i].position)+vector(0, 0.65, 0)
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

function myGetObjects(i)
    objects = getObjectFromGUID(zones[i]).getObjects()
end