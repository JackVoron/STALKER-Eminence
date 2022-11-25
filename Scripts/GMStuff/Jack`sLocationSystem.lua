isSpawned = nil

script = [[
function onLoad()
    saved = self.memo
    loaded = JSON.decode(saved)
    memory = loaded
    self.addContextMenuItem("Создать локацию", unpackLocation)
    self.addContextMenuItem("Обновить лвокацию", updateLocation)
end

function unpackLocation(player_color)
    if not getObjectFromGUID(self.getGMNotes()) then
        return
    end
    local JLS_controller = getObjectFromGUID(self.getGMNotes())
    if JLS_controller.call("isSpawnedCall") == true then
        broadcastToColor("[b][968F7C]Локация уже создана[/b][-]", player_color)
        return
    end

    bag_clone = self.clone()
    JLS_controller.call("setSpawned")
    for guid, obj_params in pairs(memory) do
        local pos = obj_params.pos
        local obj = bag_clone.takeObject({
            position          = obj_params.pos,
            callback_function = function(obj)
                    obj.setLock(obj_params.lock)
                    obj.setRotation(obj_params.rot)
                end,
            guid              = guid,
        })
        Wait.frames(function()
            obj.setPosition(obj_params.pos)
        end, 30)
    end

    bag_clone.destruct()
end

function updateLocation(player_color)
    if not getObjectFromGUID(self.getGMNotes()) then
        return
    end
    local JLS_controller = getObjectFromGUID(self.getGMNotes())
    if JLS_controller.call("isSpawnedCall") == false then
        broadcastToColor("[b][968F7C]Локация не создана[/b][-]", player_color)
        return
    end
    t = {self.getGUID()}
    JLS_controller.call("updateBag", t)
end
]]    

function onSave()
    saved_data = JSON.encode(isSpawned)
end

function onLoad(save_state)
    isSpawned = JSON.decode(save_state)
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
        click_function = "updateBags",
        function_owner = self,
        position       = {2.1,0.05,0},
        width          = 950,
        height         = 950,
        color          = {0,0,0,0},
        tooltip        = "Привязать мешки с локациями к плашке",
    })
end

function saveLocation(obj, player_color, alt_click, guid)
    if player_color ~= "Black" then
        return
    end

    local zone
    if not getObjectFromGUID(self.getGMNotes()) then
        return
    end
    zone = getObjectFromGUID(self.getGMNotes())
    local bag
    if guid == nil then    
        bag = spawnObject({
            type              = "Bag",
            position          = self.getPosition() + vector(0, 0.2, 0),
            scale             = {0.7,0.7,0.7},
            snap_to_grid      = true,
        })
    else
        bag = getObjectFromGUID(guid)
        bag.reset()
    end
    bag.setLock(true)

    memory = {}
    for _, object in pairs(zone.getObjects()) do
        if object.hasTag("JLS_Table") == false then
            memory[object.getGUID()] = {pos = object.getPosition(), lock = object.getLock(), rot = object.getRotation()}
            bag.putObject(object)
        end
    end
    bag.setLock(false)
    bag.setLuaScript(script)
    bag.memo = JSON.encode(memory)
    bag.setGMNotes(self.getGUID())
    bag.addTag("JLS_Bag")
    bag.reload()
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

function updateBags(obj, player_color)
    if player_color ~= "Black" then
        return
    end
    local guid = self.getGUID()
    for _, obj in pairs(getAllObjects()) do
        if obj.hasTag("JLS_Bag") then
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

function setSpawned()
    isSpawned = true
end

function updateBag(t)
    saveLocation(self, "Black", false, t[1])
end