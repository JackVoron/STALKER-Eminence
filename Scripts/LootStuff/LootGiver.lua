zones = {}
objects = {}
fix = {4,3,2,1}


function onLoad(save_state)
    createButtons()
end

function createButtons()
    local snap_points = self.getSnapPoints()
    local sc = self.getScale()
    for i=1,4 do
        local snap_point = snap_points[i]
        local pos = snap_point.position + vector(0, 0.1, 0.75)

        local funcname = "copyToItem" .. i
        local func = function() copyToItem(fix[i]) end
        self.setVar(funcname, func)

        self.createButton({
            click_function = funcname,
            function_owner = self,
            position = pos,
            width = 750,
            height = 200,
            label = "Выдать",
            font_color = {1,1,1},
            color = {0,0,0,0.9}
        })
    end
end

function copyToItem(i)
    createZones()
    Wait.frames(function() myGetObjects(i) end, 2)
    Wait.frames(function()
        local guid = self.getGMNotes()
        local object = getObjectFromGUID(guid)
        local pos = object.positionToWorld(object.getSnapPoints()[1].position)
        for k,v in pairs(objects) do
            v.clone({
                position     = pos,
                snap_to_grid = true,
            })
        end
    end,
    2)
end

function createZones()
    for i = 1,4 do
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

function myGetObjects(i)
    objects = getObjectFromGUID(zones[i]).getObjects()
end