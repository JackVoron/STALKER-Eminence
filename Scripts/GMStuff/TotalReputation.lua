reputations = {}
font_colors = {{0.4, 0.03, 0.03, 1}, {0, 0, 0, 1}, {0.03, 0.25, 0.03, 1}}
fractions_name = {"Одиночки", "Братство", "Долг", "Воля", "Чистое Небо", "Экологи", "Силы ОДКБ", "Контингент ООН", "Наёмники", "Монолит"}


function onLoad(save_state)
    createButtons()
end

function createButtons()
    -- Отображающие
    for i=1,10 do
        my_pos = {2.35, 0.6, -7.415 + ((i-1)*1.6615)}
        self.createButton({
            click_function = "none",
            function_owner = self,
            rotation       = {0, 0, 0},
            position       = my_pos,
            scale          = {4.75,1,1.2},
            width          = 0,
            height         = 0,
            font_size      = 400,
        })
    end
    
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
    Wait.frames(updateReputation, 60)
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
        self.editButton({index = i - 1, font_color = my_font_color, label = "☣"})
    else
        self.editButton({index = i - 1, font_color = my_font_color, label = reputations[i]})
    end
end

function none()
    return
end

function round(n) 
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n) 
end