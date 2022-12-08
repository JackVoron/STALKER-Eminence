function onSave()
    local data_to_save = {count}
    saved_data = JSON.encode(data_to_save)
    return saved_data
end

light_mode = false
promote = false
max_condition = nil
min_condition = nil
offsetZ = nil
offsetX = nil
step = nil

function onLoad(saved_data)
    self.UI.setCustomAssets({
        {
            type = 1,
            name = "cifont",
            url = "http://cloud-3.steamusercontent.com/ugc/1986680868878944084/44125D7412F853AA4ED4A3701035C20D4FE14E90/",
        }
    })
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

    self.UI.setXml(
        [[<Text
            id="display"
            height="300"
            width="300"
            color="#F00000"
            fontSize="250"
            font="cifont/cifont"
            alignment="MiddleCenter"
            rotation="180 180 0"
            horizontalOverflow="overflow"
            onClick="changePoint"
            textColor="#dbdbdb"
            text="error"
        />]]
    )

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
    Wait.frames(updateDisplay, 5)
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
    offsetZ = tonumber(settings.offsetZ)
    offsetX = tonumber(settings.offsetX)
    step = tonumber(settings.step)

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
    if settings.offsetZ == nil or settings.offsetZ == "" then
        offsetZ = 0
    end
    if settings.offsetX == nil or settings.offsetX == "" then
        offsetX = 0
    end
    if settings.step == nil or settings.step == "" then
        step = 1
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
        if count + step <= max_condition then
            count = count + step
        end
    else
        if count - step >= min_condition then
            count = count - step
        end
    end
    updateDisplay()
end

function updateDisplay()
    Settings()
    local my_color = nil
    if light_mode == true then
        my_color = "#bdb56b"
    else
        my_color = "#000000"
    end
    self.UI.setAttribute("display", "position", offsetX .. " " .. offsetZ .. " -50")
    self.UI.setAttribute("display", "text", tostring(count))
    self.UI.setAttribute("display", "color", my_color)
end