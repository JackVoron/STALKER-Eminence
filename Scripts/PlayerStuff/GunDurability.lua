durability = nil
is_jam = nil
max_durability = nil
step = nil

jam_color = {1, 0.29803921568, 0.29803921568}
light_color = {0.74,0.71,0.42,0.7}

function onSave()
    saved_data = JSON.encode({durability, is_jam})
    return saved_data
end

function onLoad(save_state)
    durability = 0
    is_jam = false
    if save_state ~= '' then
        loaded_data = JSON.decode(save_state)
        durability = loaded_data[1]
        is_jam = loaded_data[2]
    end
    createButtons()
end

function createButtons()
    Settings()
    self.createButton({
        click_function = "changeDurability",
        function_owner = self,
        label          = durability,
        position       = {0,0.075,0},
        width          = 0,
        height         = 0,
        scale          = {2,1,2},
        font_size      = 500,
        font_color     = {0,0,0},
    })

    self.createButton({
        click_function = "changeDurability",
        function_owner = self,
        label          = "",
        position       = {0,0.075,0},
        width          = 1800,
        height         = 1800,
        color          = {0,0,0,0},
    })

    self.createButton({
        click_function = "changeDurability",
        function_owner = self,
        label          = max_durability,
        position       = {1,0,2.325},
        width          = 0,
        height         = 0,
        font_size      = 400,
        font_color     = light_color,
    })
end

function changeDurability(obj, color, alt_click)
    Settings()
    if(is_jam == true) then
        is_jam = false
        self.setColorTint({1,1,1})
        return updateDisplay()
    end

    if (alt_click == false) then
        is_jam = true
        self.setColorTint(jam_color)
        if durability - step > 0 then
            durability = durability - step
        else
            durability = 0
        end
        return updateDisplay()
    end

    if durability + step < max_durability then
        durability = durability + step
    else
        durability = max_durability
    end
    return updateDisplay()
end

function updateDisplay()
    self.editButton({index = 0, label = durability})
    self.editButton({index = 2, label = max_durability})
end

function Settings()
    local temp = self.getGMNotes()
    local settings = {}
    for k in string.gmatch(temp, "([^\n]+)") do
        for name, value in string.gmatch(k, "(.+)%s+=%s+(.+)") do
            settings[name] = value
        end
    end

    max_durability = tonumber(settings.max_durability)
    step = tonumber(settings.step)

    if settings.max_durability == nil or settings.max_durability == "" then
        max_durability = 100
    end
    if settings.step == nil or settings.step == "" then
        step = 10
    end
end