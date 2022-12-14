isSpawned = nil

script = [[
function onLoad()
    self.addContextMenuItem("Создать локацию", createLocation)
    self.addContextMenuItem("Обновить локацию", updateLocation)
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
    for str in string.gmatch(self.memo, "([^".. "!!><!!" .."]+)") do
        log(str)
        spawnObjectJSON({json = str})
    end
 
end

function updateLocation(player_color)
    if player_color ~= "Black" then
        return
    end

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
    zone = getObjectFromGUID(self.getGMNotes())

    memory = {}
    for _, object in pairs(zone.getObjects()) do
        if object.hasTag("JLS_Table") == false then
            table.insert(memory, object.getJSON())
            object.destruct()
        end
    end

    self.memo = JSON.encode(memory)
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
    for _, object in pairs(zone.getObjects()) do
        if object.hasTag("JLS_Table") == false then
            temp = string.gsub(object.getJSON(), '"Nickname": ".-"', '"Nickname": ""')
            temp = string.gsub(object.getJSON(), '"Description": ".-"', '"Description": ""')
            memory = memory .. object.getJSON() .. "!!><!!"
            object.destruct()
        end
    end
    location_mark.memo = memory
    location_mark.reload()
    location_mark.setLock(false)
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

    for _, object in pairs(zone.getObjects()) do
        if object.hasTag("JLS_Table") == false then
            object.destruct()
        end
    end
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