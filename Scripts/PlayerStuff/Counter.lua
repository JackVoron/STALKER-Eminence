function onSave()
    local data_to_save = {count}
    saved_data = JSON.encode(data_to_save)
    return saved_data
end

light_mode = false
promote = false
max_condition = nil
min_condition = nil
offset = nil

function onLoad(saved_data)
    if saved_data ~= '' then
        local loaded_data = JSON.decode(saved_data)
        count = loaded_data[1]
    else
        count = 0
    end
    createButtons()
end

function createButtons()
    Settings()
    self.createButton({
        click_function = "updateDisplay",
        function_owner = self, 
        label          = "",
        scale          = {3, 0, 3},
        position       = {offset, 0.05, 0},
        width          = 0, 
        height         = 0,
        font_size      = 4000, 
        font_color     = {0,0,0,1}
    })
    local funcname = "addValue"
    local func = function(obj,player_color,alt_click) changeValue(obj,player_color,false) end
    self.setVar(funcname, func)
    self.createButton({
        click_function = funcname,
        function_owner = self, 
        label          = "+",
        position       = {2.5, 0.05, 0.0},
        width          = 650, 
        height         = 900, 
        font_size      = 3000, 
        color          = {0,0,0,0.95},
        font_color     = {0.74,0.71,0.42,0.9}
    })
    local funcname = "minusValue"
    local func = function(obj,player_color,alt_click) changeValue(obj,player_color,true) end
    self.setVar(funcname, func)
    self.createButton({
        click_function = funcname,
        function_owner = self, 
        label          = "-",
        position       = {-2.5, 0.05, 0.0},
        width          = 650, 
        height         = 900, 
        font_size      = 3000, 
        color          = {0,0,0,0.95},
        font_color     = {0.74,0.71,0.42,0.9}
    })
    updateDisplay()
end


function Settings()
    local temp = self.getGMNotes()
    local settings = {}
    for k in string.gmatch(temp, "([^\n]+)") do
        for name, value in string.gmatch(k, "(.+)%s+=%s+(.+)") do
            settings[name] = value
        end
    end

    max_condition = tonumber(settings.max_condition)
    min_condition = tonumber(settings.min_condition)
    offset = tonumber(settings.offset)

    if settings.promote == "true" or settings.promote == "True"  then
        promote = true
    else
        promote = false
    end
    if settings.light_mode == "true" or settings.light_mode == "True"  then
        light_mode = true
    else
        light_mode = false
    end
    if settings.max_condition == nil or settings.max_condition == "" then
        max_condition = 3
    end
    if settings.min_condition == nil or settings.min_condition == "" then
        min_condition = 0
    end
    if settings.offset == nil or settings.offset == "" then
        offset = 0
    end
end

function changeValue(obj,player_color,alt_click)
    Settings()
    if promote == true then
        if Player[player_color].admin == false then
            return
        end
    end
    if alt_click == false then
        if count < max_condition then
            count = count + 1
        end
    else
        if count > min_condition then
            count = count - 1
        end
    end
    updateDisplay()
end

function updateDisplay()
    Settings()
    local my_color = nil
    if light_mode == true then
        my_color = {0.74,0.71,0.42,0.9}
    else
        my_color = {0,0,0,1}
    end
    self.editButton({index = 0, label = count, font_color = my_color, position = {offset, 0.05, 0} })
end