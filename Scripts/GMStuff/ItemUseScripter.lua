objects = nil
script_main = [[
count = nil

function onSave()
    saved_data = JSON.encode({count})
    return saved_data
end

function onLoad(loaded_data)
    if loaded_data ~= "" then
        count = JSON.decode(loaded_data)[1]
    end
    if self.getGMNotes() == "" then
        self.setGMNotes(1)
    end
    if count == nil then
        if tonumber(self.getGMNotes()) then
            count = tonumber(self.getGMNotes())
        else
            count = 1
            self.setGMNotes(1)
        end
    end
    createButtons()
end

function createButtons()
    self.createButton({
        click_function = 'Reload', function_owner = self, label = count,
        position = {1.3 , 0.06 , -1.26}, scale = {2, 2, 2}, width = 180, height = 180, font_size = 110, color = {0,0,0,0.9}, font_color = {1,1,1,1}
    })
    self.createButton({
        click_function = 'Use', function_owner = self, label = 'Использовать',
        position = {0, 0.06, 1.246}, scale = {2, 2, 2}, width = 800, height = 200, font_size = 100, color = {0,0,0,0.9}, font_color = {1,1,1,1}
    })
end

function Use(obj, player_color)
    if count > 1 then
        printToAll(Player[player_color].steam_name .. ': - [FFFF96]Использовал[-] - ' .. self.getName())
        count = count - 1
        self.editButton({index=0, label=count})
    elseif count == 1 then
        count = 0
        self.editButton({index=0, label=count})
        printToAll(Player[player_color].steam_name .. ': - [FFFF96]Использовал[-] - ' .. self.getName())
        printToAll(Player[player_color].steam_name .. ': ' .. self.getName() .. ' -[1E90FF] более невозможно использовать[-]')
]]

scripts = {[[        
    self.destruct()
]],
[[
else
    printToAll(Player[player_color].steam_name .. ': ' .. self.getName() .. ' -[1E90FF] невозможно использовать[-]')
]],
[[  
    state_guid = self.getStates()[1].guid
    spawn_data = getObjectFromGUID(state_guid).getData()
    self.setState(2)
    self.destruct()
    spawn_data["States"][1] = nil
    spawnObjectData({data = spawn_data})
    getObjectFromGUID(state_guid).destruct()
]]
}

script_end = [[
    end
end
function Reload(obj, player_color)
    if Player[player_color].admin then
        count = tonumber(self.getGMNotes())
        self.editButton({index=0, label=count})
    end
end
]]

function onLoad(save_state)
    createButtons()
end

function createButtons()
    for i=1,3 do
        local funcname = "setFunction" .. i
        local func = function() setFunction(i) end
        self.setVar(funcname, func)
        self.createButton({
            click_function = funcname,
            function_owner = self,
            position       = {-5.35 + (i - 1)*5.3,0.585,5.3},
            width          = 2200,
            height         = 2200,
            color          = {0,0,0,0},
        })
    end
end

function createZone()
    local my_scale = self.getScale()
    my_scale[1] = my_scale[1]*25
    my_scale[2] = 0.45
    my_scale[3] = my_scale[3]*25
    local my_position = self.getPosition()+vector(0, 0.22, 0)
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

function setFunction(i)
    createZone()
    Wait.frames(myGetObjects, 2)
    Wait.frames(function()
        for _, obj in pairs(objects) do
            if obj ~= self then      
                obj.setLuaScript(script_main .. scripts[i] .. script_end)
                obj.reload()
            end
        end
    end,
    2)
end