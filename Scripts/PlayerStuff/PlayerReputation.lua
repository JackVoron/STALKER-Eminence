reputations = {}
font_colors = {{0.4, 0.03, 0.03, 1}, {0, 0, 0, 1}, {0.03, 0.25, 0.03, 1}}
fractions_name = {"Одиночки", "Братство", "Долг", "Воля", "Чистое Небо", "Экологи", "Силы ОДКБ", "Контингент ООН", "Наёмники", "Монолит"}
function onSave()
    saved_data = JSON.encode(reputations)
    return saved_data
end

function onLoad(save_state)
    if save_state ~= '' then
        reputations = JSON.decode(save_state)
    end
    if reputations[1] == nil then
        reputations = {5,5,5,5,5,5,5,5,5,5}
    end
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
        updateDisplay(i)
    end
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
        self.editButton({index = i - 1, font_color = my_font_color, label = "☣"})
    else
        self.editButton({index = i - 1, font_color = my_font_color, label = reputations[i]})
    end
end

function none()
    return
end