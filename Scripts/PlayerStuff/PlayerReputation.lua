reputations = {}
font_colors = {{0.55, 0.05, 0.05, 1}, {0.77, 0.77, 0.5, 0.73}, {0.05, 0.35, 0.05, 1}}

function onSave()
    saved_data = JSON.encode(reputations)
    return saved_data
end

function onLoad(save_state)
    if save_state ~= '' then
        reputations = JSON.decode(save_state)
    else
        reputations = {5,5,5,5,5,5,5,5,5,5}
    end
    createButtons()
end

function createButtons()
    -- Отображающие
    for i=1,5 do
        my_pos = {-1.4, 0.65, -7.45 + ((i-1)*3.2)}
        self.createButton({
            click_function = "none",
            function_owner = self,
            rotation       = {-10, 0, 0},
            position       = my_pos,
            scale          = {4.75,1,2},
            width          = 0,
            height         = 0,
            font_size      = 200,
        })
    end

    for i=6,10 do
        my_pos = {6.4, 0.65, -7.45 + ((i-6)*3.2)}
        self.createButton({
            click_function = "none",
            function_owner = self,
            rotation       = {-10, 0, 0},
            position       = my_pos,
            scale          = {4.75,1,2},
            width          = 0,
            height         = 0,
            font_size      = 200,
        })
    end

    -- для кликов
    for i=1,5 do
        my_pos = {-3.9, 0.65, -6.4 + ((i-1)*3.2)}
        func = function(obj, color, alt_click) changeReputation(color, alt_click, i) end
        func_name = "changeReputation" .. i
        self.setVar(func_name, func)
        self.createButton({
            click_function = func_name,
            function_owner = self,
            position       = my_pos,
            scale          = {4.75,1,2},
            width          = 700,
            height         = 700,
            color          = {0.1, 0.1, 0.1, 0.01},
            hover_color    = {0.1, 0.1, 0.1, 0.01},
        })
        updateDisplay(i)
    end
    for i=6,10 do
        my_pos = {3.9, 0.65, -6.4 + ((i-6)*3.2)}
        func = function(obj, color, alt_click) changeReputation(color, alt_click, i) end
        func_name = "changeReputation" .. i
        self.setVar(func_name, func)
        self.createButton({
            click_function = func_name,
            function_owner = self,
            position       = my_pos,
            scale          = {4.75,1,2},
            width          = 700,
            height         = 700,
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
    self.editButton({index = i - 1, font_color = my_font_color, label = reputations[i]})
end

function none()
    return
end