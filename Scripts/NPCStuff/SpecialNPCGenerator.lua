zones = {}
objects = nil
function onLoad(save_state)
    createButtons()

end

function createButtons()
    self.createButton({
        click_function = "generateNPC",
        function_owner = self,
        position       = {3.8, 0.8, -3.8},
        width          = 3250,
        height         = 3250,
        color          = {0,0,0,0},
        tooltip        = "Создать NPC",
    })
end

function generateNPC()
    createZones()
    Wait.frames(function()
        local name_generator = getObjectFromGUID(self.getGMNotes())
        myGetObjects(1)
        local NPC = objects[1]
        local pos = NPC.getPosition()
        NPC = NPC.clone({
            position     = self.positionToWorld({-3.8, 0.5, -3.8}),
            snap_to_grid = true,
        })

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
        weapon_orig.destruct()
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
    end, 2)
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