objects = nil
zone = nil
t = {}

function onLoad()
    self.createButton({
        click_function = "fBag", function_owner = self, label = "Выложить\nслучайные\nпредметы",
        position       = {0, 0.15 , 1.5}, width = 1400, height = 600,
        font_size      = 180, color = {0, 0, 0, 0}, font_color     = {1, 1, 1},
    })
end

function fSettings()
    s = self.getGMNotes()
    for k in string.gmatch(s, "([^\n]+)") do
        for name, value in string.gmatch(k, "(.+)=(.+)") do
            t[name] = value
        end
    end
end

function createZone()
    local my_scale = self.getScale()
    local my_position = self.positionToWorld(self.getSnapPoints()[1].position)+vector(0, 0.6, 0)
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

function fBag()
    fSettings()

    createZone()
    Wait.frames(myGetObjects, 2)

    local bag = nil
    Wait.frames(function()
        for _, occupyingObject in ipairs(objects) do
            bag = occupyingObject
            if bag.type == "Bag"  then
                local min = tonumber(t.Min)
                local max = tonumber(t.Max)
        
                if max > #bag.getObjects() then
                    max = #bag.getObjects()
                end
        
                if min > #bag.getObjects() then
                    min = 1
                end
        
                if max > 0 then
                    local token_pos = self.getPosition()
                    local quantity = math.random(min, max)
                    for item = 1, quantity do
                        local new_pos = token_pos + vector(tonumber(t.X), 1*item, tonumber(t.Z))
                        bag.randomize()
                        local a = bag.getObjects()
                        a[1].position = new_pos
                        bag.takeObject(a[1])
                    end
                    bag.destruct()
                end
            end
        end
    end,
    2)
end