anomalies_info = {
    {
        name = "Трамплин",
        color = "968F7C",
        font_color = "281102",
        field_image = "http://cloud-3.steamusercontent.com/ugc/1878591893800912499/ACE9CE23DABB89A8C4C789CE9D081D11437E48C9/"
    },
    {
        name = "Воронка",
        color = "968F7C",
        font_color = "281102",
        field_image = "http://cloud-3.steamusercontent.com/ugc/1878591893800909974/EA1C8957709348B47CBB22C57F9147C005DF210C/"
    },
    {
        name = "Карусель",
        color = "968F7C",
        font_color = "281102",
        field_image = "http://cloud-3.steamusercontent.com/ugc/1878591893800908818/0B0E23A8ABE39A3EB55F17D4735FC4E43B5D148A/"
    },
    {
        name = "Электра",
        color = "4C6C82",
        font_color = "C1A829",
        field_image = "http://cloud-3.steamusercontent.com/ugc/1878591893800913791/F8F447491E7150EF610CF16FA7F6EDC5A9A4A415/"
    },
    {
        name = "Жарка",
        color = "B3523E",
        font_color = "C1A829",
        field_image = "http://cloud-3.steamusercontent.com/ugc/1878591893800909397/9CE297A2ACECB251EF1C79C29A208B1A0EA4F4B0/"
    },
    {
        name = "Химическая угроза",
        color = "5A8B49",
        font_color = "C1A829",
        field_image = "http://cloud-3.steamusercontent.com/ugc/1878591893800913128/2035EDC3C71A6FEEDF7D1DE50D9B00E3B7A827C5/"
    },
    {
        name = "Радиационная угроза",
        color = "81771E",
        font_color = "281102",
        field_image = "http://cloud-3.steamusercontent.com/ugc/1878591893800911928/C69FE5821526582A9D228267ED7305E35F136F43/"
    },
}

fields_chance_by_level = {
    {
        50, --anomaly
        30, --radiation
    },
    {
        60, --anomaly
        30, --radiation
    },
    {
        60, --anomaly
        40, --radiation
    }
}

fields_damage_by_level = {
    { 3, 4, 4, 5, 5, 5, 6, 6, 7 },
    { 5, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 10 },
    { 7, 8, 8, 9, 9, 10, 10, 10, 11, 11, 12 }
}

symbols = {"I", "II","III"}


empty_field_image = "http://cloud-3.steamusercontent.com/ugc/1878591893800911370/98EF29212F3D4F7AF5F8A4181E3A91A223C89A22/"
unknown_field_image = "http://cloud-3.steamusercontent.com/ugc/1878591893800906313/4A4934250831BD138CE73EEEEF93178B9EB73750/"
loot_field_image = "http://cloud-3.steamusercontent.com/ugc/1878591893800910831/664E36CA72D3211EF23D15E8C12DE4DA86902FB5/" 
artifact_field_image = "http://cloud-3.steamusercontent.com/ugc/1878591893800753770/D3012AF8FB1F8984056F1C1AC6D03777E30816CE/"

counter = 0
current_anomaly_level = 1
current_anomaly_type = nil
artifact_quantity = nil
loot_quantity = nil
zone_guid = nil
objects = nil

field_script_start = [[
    function onLoad()
        self.createButton({
            click_function = "deleteAnomaly",
            function_owner = self,
            label          = ]]
            
field_script_end = [[
        ,
                position       = {0,-0.1,0},
                rotation       = {-165,180,0},
                width          = 0,
                height         = 0,
                font_size      = 650,
                color          = {0,0,0},
            })
        end
    ]]
function onLoad(save_state)
    createButtons()
    self.addContextMenuItem("Обнулить счётчик", function() counter = 0 
                                                self.editButton({index = 13, label = "[b]" .. counter}) 
                                                end)
end

function createButtons()
    for i = 1,7 do
        local funcname = "chooseAnomaly" .. i
        local func = function(obj, player_color, alt_click) chooseAnomaly(obj, player_color, alt_click, i) end
        self.setVar(funcname, func)
        self.createButton({
            click_function = funcname,
            function_owner = self,
            position       = {-7.2,0.6,-5.253 + 1.751 * (i - 1)},
            width          = 880,
            height         = 880,
            color          = {0,0,0,0},
            hover_color    = {0,0,0,0},
            tooltip        = "[b][".. anomalies_info[i].color .."]" .. anomalies_info[i].name,
        })      
    end

    self.createButton({
        click_function = "createAnomaly",
        function_owner = self,
        position       = {0,0.6,-7.7},
        width          = 2300,
        height         = 400,
        color          = {0,0,0,0},  
    })

    self.createButton({
        click_function = "deleteAnomaly",
        function_owner = self,
        position       = {0,0.6,-6.725},
        width          = 2300,
        height         = 400,
        color          = {0,0,0,0},  
    })

    self.createButton({
        click_function = "UseGMZone",
        function_owner = self,
        position       = {5.25,0.6,-7.2},
        width          = 880,
        height         = 880,
        color          = {0,0,0,0},
        tooltip        = "[b][968F7C]Создать/удалить прячущую зону"  
    })

    self.createButton({
        click_function = "changeLevel",
        function_owner = self,
        position       = {-7.2,0.6,-7.2},
        width          = 880,
        height         = 880,
        color          = {0,0,0,0},
        hover_color    = {0,0,0,0},
        tooltip        = "[b][968F7C]Сменить уровень аномалии",
    })

    self.createButton({
        click_function = "changeLevel",
        function_owner = self,
        label          = "[b]" .. symbols[1],
        position       = {-7.2,0.6,-7.1},
        width          = 0,
        height         = 0,
        font_size      = 650,
        font_color     = {0.74,0.71,0.42,0.32}, 
    })

    self.createButton({
        click_function = "changeCounter",
        function_owner = self,
        position       = {7.2,0.6,-7.2},
        width          = 880,
        height         = 880,
        color          = {0,0,0,0},
        hover_color    = {0,0,0,0},
    })

    self.createButton({
        click_function = "changeCounter",
        function_owner = self,
        label          = "[b]" .. 0,
        position       = {7.2,0.6,-7.155},
        width          = 0,
        height         = 0,
        font_size      = 560,
        font_color     = {0.74,0.71,0.42,0.32}, 
    })
    
end

function chooseAnomaly(obj, player_color, alt_click, i)
    if Player[player_color].admin == false then
        return
    end
    for i = 1,7 do
        self.editButton({index = i-1, color = {0,0,0,0}, hover_color = {0,0,0,0}})
    end
    self.editButton({index = i-1, color = {0,0,0,0.85}, hover_color = {0,0,0,0.85}})

    current_anomaly_type = i
end

function createAnomaly(obj, player_color, alt_click)
    if Player[player_color].admin == false then
        return
    end
    
    if current_anomaly_type == nil then
        broadcastToColor("[b][968F7C]Тип аномалии не выбран", player_color)
        return
    end

    artifact_quantity = math.random(0,3)
    loot_quantity = math.random(2,6)

    local my_rotation = self.getRotation()
    local snap_points = self.getSnapPoints()
    shuffleTable(snap_points)
    for i, snap_point in pairs(snap_points) do

        local image
        local script = ""

        if i <= artifact_quantity then
            image = artifact_field_image  
        elseif i <= loot_quantity + artifact_quantity then
            image = loot_field_image 
        elseif i <= 50 then
            image = empty_field_image     
        else
            rand = math.random(100)
            local chances = fields_chance_by_level[current_anomaly_level]
            local anomaly = anomalies_info[current_anomaly_type]
            local damage = fields_damage_by_level[current_anomaly_level]
            if rand <= chances[1] then
                image = anomaly.field_image
                script = field_script_start .. "'[" .. anomaly.font_color .. "]" .. randomFromTable(damage)  .. "[-]'" .. field_script_end
            elseif rand <= chances[1] + chances[2] then
                image = anomalies_info[7].field_image
                script = field_script_start .. "'[" .. anomalies_info[7].font_color .. "]" .. math.floor(randomFromTable(damage)/2) .. "[-]'" .. field_script_end
            else
                image = empty_field_image           
            end
        end 

        local my_position = self.positionToWorld(snap_point.position)
        local obj = spawnObject({type = "Custom_Tile", position = my_position, scale = {0.675, 1.00, 0.675}, 
        rotation = my_rotation})
        setField(obj, image, script)
    end
end

function deleteAnomaly()
    createZone()
    Wait.frames(myGetObjects, 2)
    Wait.frames(function()
        for _, obj in pairs(objects) do
            if obj.hasTag("anomaly_field") == true then      
                obj.destruct()
            end
        end
    end,
    2)
end

function setField(obj, f_image, script)
    obj.setCustomObject({
        image = unknown_field_image,
        image_bottom = f_image,
        thickness = 0.1,
    })
    obj.setLock(false)
    obj.setColorTint({0,0,0})
    obj.setLuaScript(script)
    obj.addTag("anomaly_field")
    obj.reload()
end


function changeLevel(obj, player_color, alt_click)
    if Player[player_color].admin == false then
        return
    end
    if alt_click == false then
        if current_anomaly_level < 3 then
            current_anomaly_level = current_anomaly_level + 1
        else
            current_anomaly_level = 1
        end
    else
        if current_anomaly_level > 1 then
            current_anomaly_level = current_anomaly_level - 1
        else
            current_anomaly_level = 3
        end
    end
    self.editButton({index = 11, label = "[b]" .. symbols[current_anomaly_level]})
end

function changeCounter(obj, player_color, alt_click)
    if Player[player_color].admin == false then
        return
    end
    if alt_click == false then
        if counter < 99 then
            counter = counter + 1
        end
    else
        if counter > -99 then
            counter = counter - 1
        end
    end
    self.editButton({index = 13, label = "[b]" .. counter})
end
function UseGMZone(obj, player_color, alt_click)
    if player_color ~= "Black" then
        return
    end
    if zone_guid == nil then
        local my_scale = self.getScale()*29
        local my_pos = self.getPosition()
        local my_rot = self.getRotation()
        local zone = spawnObjectData({
            data = { Name = "FogOfWarTrigger",
            Transform = {
                posX = my_pos[1],
                posY = my_pos[2] + 1,
                posZ = my_pos[3],
                rotX = my_rot[1],
                rotY = my_rot[2],
                rotZ = my_rot[3],
                scaleX = my_scale[1],
                scaleY = 4,
                scaleZ = my_scale[3]
            },
            Value = 0,
            ColorDiffuse = { r = 0.25, g = 0.25, b = 0.25, a = 0.25 },
            LayoutGroupSortIndex = 0,
            Locked = true,
            Grid = true,
            Snap = true,
            IgnoreFoW = false,
            MeasureMovement = false,
            DragSelectable = true,
            Tooltip = true,
            Sticky = true,
            Autoraise = true,
            GridProjection = false,
            HideWhenFaceDown = false,
            Hands = false,
            FogColor = "Black",
            FogSeethrough = true,
            FogReverseHiding = false,
            FogHidePointers	= true,
        }})
        zone_guid = zone.getGUID()
    else
        if getObjectFromGUID(zone_guid) then
            getObjectFromGUID(zone_guid).destruct()
            zone_guid = nil
        end
    end
end

function Settings()
    local temp = self.getGMNotes()
    local settings = {}
    for k in string.gmatch(temp, "([^\n]+)") do
        for name, value in string.gmatch(k, "(.+)%s+=%s+(.+)") do
            settings[name] = value
        end
    end
end

function shuffleTable(table)
    for i = 1, #table do
        local j = math.random(#table)
        table[i], table[j] = table[j], table[i]
    end
end

function randomFromTable(table)
    return table[math.random(#table)]
end

function createZone()
    local my_scale = self.getScale()
    my_scale[1] = my_scale[1]*25
    my_scale[2] = 1
    my_scale[3] = my_scale[3]*25
    local my_position = self.getPosition()+vector(0, 0.9, 0)
    spawnObject({type = "ScriptingTrigger", position = my_position, scale = my_scale, rotation = self.getRotation(), callback_function = function(obj) setZone(obj) end})
end

function setZone(obj)
    zone = obj.getGUID()
    Wait.frames(function()
        obj.destruct()
        end,
        3000)
end


function myGetObjects()
    objects = getObjectFromGUID(zone).getObjects()
end
