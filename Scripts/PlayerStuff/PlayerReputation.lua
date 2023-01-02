reputations = {}
font_colors = {"#660808", "#000000", "#084008"}
fractions_name = {"Одиночки", "Братство", "Долг", "Воля", "Чистое Небо", "Экологи", "Силы ОДКБ", "Контингент ООН", "Наёмники", "Монолит"}
function onSave()
    saved_data = JSON.encode(reputations)
    return saved_data
end

function onLoad(save_state)
    self.UI.setCustomAssets({
        {
            type = 1,
            name = "cifont",
            url = "http://cloud-3.steamusercontent.com/ugc/1986680868878944084/44125D7412F853AA4ED4A3701035C20D4FE14E90/",
        }
    })

    if save_state ~= '' then
        reputations = JSON.decode(save_state)
    end
    if reputations[1] == nil then
        reputations = {5,5,5,5,5,5,5,5,5,5}
    end
    createButtons()
end

function createButtons()
    result_xml = ""
    -- Отображающие
    for i=1,10 do
        z = -745 + (i-1) * 166
        xml = [[
        <Text
            id="]] .. i .. [["
            height="300"
            width="500"
            color="#000000"
            fontSize="105"
            font="cifont/cifont"
            rotation="180 180 0"
            horizontalOverflow="overflow"
            verticalOverflow="overflow"
            position="-245 ]] .. z ..[[ -60"
            text="error"
            scale = "4 1 1"
        />
        ]]
        result_xml = result_xml .. xml .. "\n" 
    end
    self.UI.setXml(result_xml)
    -- для кликов
    for i=1,10 do
        my_pos = {0, 0.65, -7.5 + ((i-1)*1.665)}
        func = function(obj, color, alt_click) changeReputation(color, alt_click, i) end
        func_name = "changeReputation" .. i
        self.setVar(func_name, func)
        self.createButton({
            click_function = func_name,
            function_owner = self,
            position       = my_pos,
            scale          = {4.75,1,1.2},
            width          = 1100,
            height         = 600,
            tooltip        = "[9B9891][b][i]" .. fractions_name[i],
            color          = {0.1, 0.1, 0.1, 0.01},
            hover_color    = {0.1, 0.1, 0.1, 0.01},
        })
    end
    Wait.frames(function()
        for i= 1,10 do
            updateDisplay(i)
        end
    end,5)
    
end

function changeReputation(player_color, alt_click, i)
    if Player[player_color].admin == false then
        return
    end
    if alt_click == false then
        reputations[i] = reputations[i] + 1
        if reputations[i] > 10 then
            reputations[i] = 10
        end
    else
        reputations[i] = reputations[i] - 1
        if reputations[i] < 0 then
            reputations[i] = 0
        end
    end
    updateDisplay(i)
end

function updateDisplay(i)
    local my_font_color
    if reputations[i] < 3 then
        my_font_color = font_colors[1]
    elseif reputations[i] < 8 then
        my_font_color = font_colors[2]
    else
        my_font_color = font_colors[3]
    end
    if reputations[i] == 0 then
        self.UI.setAttribute(tostring(i), "text", "ø")
        self.UI.setAttribute(tostring(i), "color", my_font_color)
    else
        self.UI.setAttribute(tostring(i), "text", tostring(reputations[i]))
        self.UI.setAttribute(tostring(i), "color", my_font_color)
    end
end