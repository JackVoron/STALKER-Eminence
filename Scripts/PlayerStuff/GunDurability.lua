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
    self.UI.setCustomAssets({
        {
            type = 1,
            name = "cifont",
            url = "http://cloud-3.steamusercontent.com/ugc/1986680868878944084/44125D7412F853AA4ED4A3701035C20D4FE14E90/",
        }
    })
    createButtons()
end

function createButtons()
    Settings()
    self.createButton({
        click_function = "changeDurability",
        function_owner = self,
        label          = "",
        position       = {0,0.075,0},
        width          = 1800,
        height         = 1800,
        color          = {0,0,0,0},
    })

    self.UI.setXml(
        [[
        <Text
            id="display"
            height="300"
            width="300"
            color="#000000"
            fontSize="240"
            font="cifont/cifont"
            rotation="180 180 0"
            alignment="MiddleCenter"
            horizontalOverflow="overflow"
            verticalOverflow="overflow"
            position="0 0 -10"
            text="error"
        />
        <Text
            id="displayMax"
            height="300"
            width="300"
            color="#bdb56b"
            fontSize="85"
            font="cifont/cifont"
            rotation="180 180 0"
            horizontalOverflow="overflow"
            verticalOverflow="overflow"
            position="-95 230 0"
            text="error"
        />
    ]])
    Wait.frames(updateDisplay, 5)
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
    self.UI.setAttribute("display", "text", tostring(durability))
    self.UI.setAttribute("displayMax", "text", tostring(max_durability))
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