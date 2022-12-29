isSpawned = nil
script = [[
function onLoad()
    self.addContextMenuItem("Создать локацию", createLocation)
    self.addContextMenuItem("Обновить локацию", confirmUpdate)
end

function createLocation(player_color)
    if player_color ~= "Black" then
        return
    end
    if not getObjectFromGUID(self.getGMNotes()) then
        return
    end
    local JSL_controller = getObjectFromGUID(self.getGMNotes())
    if JSL_controller.call("isSpawnedCall") == true then
        broadcastToColor("[b][968F7C]Локация уже создана[/b][-]", player_color)
        return
    end
    local objects = {}

    for str in string.gmatch(self.script_state, "([^¶]+)") do
        table.insert(objects, str)
    end

    for str in string.gmatch(objects[1], "([^‼]+)") do
        spawnObjectJSON({json = str})
    end
    data_objects = JSON.decode(objects[2])
    if #data_objects >= 1 then
        for i = 1, #data_objects do
            spawnObjectData({data = data_objects[i]})
        end
    end
    JSL_controller.call("setSpawnedTrue")
end

function confirmUpdate(player_color)
    if player_color ~= "Black" then
        return
    end
    Player[player_color].showConfirmDialog('Вы уверены, что вы хотите обновить локацию "' .. self.getName() .. '"?' , updateLocation)
end

function updateLocation(player_color)
    if not getObjectFromGUID(self.getGMNotes()) then
        return
    end

    local JSL_controller = getObjectFromGUID(self.getGMNotes())
    if JSL_controller.call("isSpawnedCall") == false then
        broadcastToColor("[b][968F7C]Локация не создана[/b][-]", player_color)
        return
    end

    local zone
    if not getObjectFromGUID(JSL_controller.getGMNotes()) then
        return
    end
    zone = getObjectFromGUID(JSL_controller.getGMNotes())
    new_pos = zone.getPosition()
    new_pos[2] = JSL_controller.getPosition()[2]
    zone.setPosition(new_pos)
    
    memory = ""
    special_data = {}
    Wait.frames(function()
        for _, object in pairs(zone.getObjects()) do
            if object.hasTag("JLS_Table") == false then
                temp = object.getJSON()
                if temp:find("[омС]") ~= nil then
                    table.insert(special_data, object.getData())
                else           
                    memory = memory .. temp .. "‼"
                end
                object.destruct()
            end
        end
        special_data = json.serialize(special_data)
        self.script_state = memory .. "¶" .. special_data
        JSL_controller.call("setSpawnedFalse")
        zone.setPosition(new_pos - vector(0,60,0)) 
    end, 5)
end
]]    

function onSave()
    saved_data = JSON.encode({isSpawned})
    return saved_data
end

function onLoad(save_state)
    isSpawned = JSON.decode(save_state)[1]
    if isSpawned == nil then
        isSpawned = false
    end
    createButtons()
end

function createButtons()
    self.createButton({
        click_function = "saveLocation",
        function_owner = self,
        position       = {-2.1,0.05,0},
        width          = 950,
        height         = 950,
        color          = {0,0,0,0},
        tooltip        = "Сохранить локацию",
    })
    self.createButton({
        click_function = "deleteLocation",
        function_owner = self,
        position       = {0,0.05,0},
        width          = 950,
        height         = 950,
        color          = {0,0,0,0},
        tooltip        = "Удалить локацию",
    })
    self.createButton({
        click_function = "updateMarks",
        function_owner = self,
        position       = {2.1,0.05,0},
        width          = 950,
        height         = 950,
        color          = {0,0,0,0},
        tooltip        = "Привязать метки с локациями к плашке",
    })
end

function saveLocation(obj, player_color, alt_click)
    if player_color ~= "Black" then
        return
    end

    local zone
    if not getObjectFromGUID(self.getGMNotes()) then
        return
    end
    zone = getObjectFromGUID(self.getGMNotes())
    new_pos =  zone.getPosition()
    new_pos[2] = self.getPosition()[2]
    zone.setPosition(new_pos)

    local location_mark
    if guid == nil then    
        location_mark = spawnObject({
            type              = "Custom_Model",
            position          = self.getPosition() + vector(0, 0.2, 0),
            scale             = {0.92,0.92,0.92},
        })
    else
        location_mark = getObjectFromGUID(guid)
    end

    location_mark.setCustomObject({
        mesh = "http://cloud-3.steamusercontent.com/ugc/1922503068746795255/717388AF271FB873419AD708F4A848538E0D68B8/",
        diffuse = "http://cloud-3.steamusercontent.com/ugc/1922503068746795324/E952E1E0EC86271F3C344EBCBC1FFDA148EBDA76/",
        material = 3,
        cast_shadows = false
    })
    location_mark.setLuaScript(script)
    location_mark.setGMNotes(self.getGUID())
    location_mark.addTag("JLS_Mark")

    memory = ""
    special_data = {}
    Wait.frames(function()
        for _, object in pairs(zone.getObjects()) do
            if object.hasTag("JLS_Table") == false then
                temp = object.getJSON()
                if temp:find("[омС]") ~= nil then
                    table.insert(special_data, object.getData())
                else           
                    memory = memory .. temp .. "‼"
                end
                object.destruct()
            end
        end
        special_data = json.serialize(special_data)
        location_mark.script_state = memory .. "¶" .. special_data
        location_mark.reload()
        location_mark.setLock(false)
        
        zone.setPosition(new_pos - vector(0,60,0)) 
    end, 5)
    isSpawned = false
end

function deleteLocation(obj, player_color)
    if player_color ~= "Black" then
        return
    end

    local zone
    if not getObjectFromGUID(self.getGMNotes())then
        return
    end
    zone = getObjectFromGUID(self.getGMNotes())
    new_pos =  zone.getPosition()
    new_pos[2] = self.getPosition()[2]
    zone.setPosition(new_pos)
    Wait.frames(function()
        for _, object in pairs(zone.getObjects()) do
            if object.hasTag("JLS_Table") == false then
                object.destruct()
            end
        end
        zone.setPosition(new_pos - vector(0,60,0)) 
    end, 5)
    isSpawned = false
end

function updateMarks(obj, player_color)
    if player_color ~= "Black" then
        return
    end
    local guid = self.getGUID()
    for _, obj in pairs(getAllObjects()) do
        if obj.hasTag("JLS_Mark") then
            obj.setGMNotes(guid)
        end
    end
end

function isSpawnedCall()
    if isSpawned then
        return true
    else
        return false
    end
end

function setSpawnedTrue()
    isSpawned = true
end

function setSpawnedFalse()
    isSpawned = false
end