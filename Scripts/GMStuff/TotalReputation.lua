reputations = {}
font_colors = {"#660808", "#000000", "#084008"}
fractions_name = {"Одиночки", "Братство", "Долг", "Воля", "Чистое Небо", "Экологи", "Силы ОДКБ", "Контингент ООН", "Наёмники", "Монолит"}


function onLoad(save_state)
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
    -- Отображающие
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
    
    self.createButton({
        click_function = "updateReputation",
        function_owner = self,
        position       = {0, 0.6, 0},
        scale          = {4.75,1,1.2},
        width          = 1800,
        height         = 6700,
        color          = {0.1, 0.1, 0.1, 0.01},
        hover_color    = {0.1, 0.1, 0.1, 0.01},
    })
    Wait.frames(updateReputation, 5)
end

function updateReputation()
    reputations = {0,0,0,0,0,0,0,0,0,0}
    player_count = 0
    for _, obj in pairs(getAllObjects()) do
        if obj.hasTag("player_reputation") == true then
            player_reputation = obj.getTable("reputations")
            player_count = player_count + 1
            for i=1,10 do
                reputations[i] = reputations[i] + player_reputation[i]
            end
        end
    end
    if player_count == 0 then
        player_count = 1
    end

    for i=1,10 do
        reputations[i] = reputations[i]/player_count
        reputations[i] = round(reputations[i])
        updateDisplay(i)
    end
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
        self.UI.setAttribute(tostring(i), "text", "Ø")
        self.UI.setAttribute(tostring(i), "color", my_font_color)
    else
        self.UI.setAttribute(tostring(i), "text", tostring(reputations[i]))
        self.UI.setAttribute(tostring(i), "color", my_font_color)
    end
end


function round(n) 
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n) 
end