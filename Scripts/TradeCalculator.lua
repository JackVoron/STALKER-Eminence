confirm_buttons = {
    {
        position       = {-1.25,0.12,0},
    },
    {
        position       = {2.5,0.12,0},
    }
}

prices_inputs = {
    {
        position       = {-2.9,0.12,0,04},
    },
    {
        position       = {4.2,0.12,0,04},
    }
}

phrases = {
    "Ты врёшь! Не может быть!",
    "Ты бы ещё консервных банок насобирал!",
    "Нафига ты эту дрянь тягаешь?!",
    "Братан, ты не врубаешься? Мне нужен реальный товар!",
    "Ну проветришься заходи!",
    "Ну чё стоишь? Подходи, я не кусаюсь."
}
selling_rep = {-20,-10,0,5,10,15,20,25,30,30}
buying_rep = {-40,-20,0,10,20,30,40,50,60,70}
symbols = {"☣", "Ⅱ","Ⅲ","Ⅳ","Ⅴ","Ⅵ","Ⅶ","Ⅷ","Ⅸ","♕"}
function onLoad(save_state)
    createButtonsAndInputs()
end

reputation = 3

selling_price = nil
buying_price = nil
result_price = 0

function createButtonsAndInputs()
    for i = 1, 2 do
        local funcname = "confirm" .. i
        local func = function() confirm(i) end
        self.setVar(funcname, func)
        self.createButton({
            click_function = funcname,
            function_owner = self,
            position       = confirm_buttons[i].position,
            width          = 350,
            height         = 550,
            color          = {0,0,0,0},
            tooltip        = "Подтвердить",
        })
    end

    for i = 1,2 do
        local funcname = "setPrice" .. i
        local func = function(obj, player_clicker_color, input_value) setPrice(i, input_value) end
        self.setVar(funcname, func)
        self.createInput({
            input_function = funcname,
            function_owner = self,
            alignment      = 3,
            position       = prices_inputs[i].position,
            width          = 1300,
            height         = 500,
            font_size      = 370,
            color          = {0,0,0,0.6},
            font_color     = {1,1,1},
            validation     = 2,
            tab            = 1,
        })
    end
    
    self.createButton({
        click_function = "deal",
        function_owner = self,
        label          = "",
        position       = {0.65,0.12,-0.05},
        width          = 1500,
        height         = 550,
        font_size      = 380,
        color          = {0,0,0,0.6},
        font_color     = {1,1,1},
        tooltip        = "Сделка",
    })

    self.createButton({
        click_function = "deal",
        function_owner = self,
        label          = result_price,
        position       = {0.65,0.12,-0.1},
        width          = 0,
        height         = 0,
        font_size      = 380,
        color          = {0,0,0,0.6},
        font_color     = {1,1,1},
    })


    self.createButton({
        click_function = "setRep",
        function_owner = self,
        label          = symbols[reputation],
        position       = {-4.9,0.12,-0.05},
        width          = 620,
        height         = 550,
        font_size      = 360,
        color          = {0,0,0,0.6},
        hover_color    = {0,0,0,0.6},
        press_color    = {0,0,0,0.6},
        font_color     = {1,1,1},
    })
    
end

function setPrice(i, value)
    if i == 1 then
        selling_price = tonumber(value)
    else
        buying_price = tonumber(value)
    end
end

function setRep(obj,color, alt)
    if alt == true then
        if reputation > 1 then
            reputation = reputation - 1
        end
    else
        if reputation < 10 then
            reputation = reputation + 1
        end
    end
    self.editButton({
        index          = 4,
        label          = symbols[reputation],
    })
end

function confirm(i)
    if i == 1 then
        result_price = result_price + selling_price + math.floor(selling_price*selling_rep[reputation]/100)
        self.editInput({
            index          = 0,
            value          = nil,
        })
    else
        result_price = result_price - buying_price + math.floor(buying_price*buying_rep[reputation]/100)
        self.editInput({
            index          = 1,
            value          = nil,
        })
    end
    self.editButton({
        index          = 3,
        label          = result_price,
    })
end

function deal(obj, player_color)
    if result_price > 0 then
        printToAll(Player[player_color].steam_name .. ": [FFFF96]Сделка состоялась. Вы получили[-]: [99ff33]" .. result_price)
    elseif result_price == 0 then
        printToAll("Торговец: [FFFF96]" .. phrases[math.random(#phrases)])
    else
        printToAll(Player[player_color].steam_name .. ": [FFFF96]Сделка состоялась. Вы должны[-]: [ff8080]" .. math.abs(result_price))
    end

    result_price = 0
    self.editButton({
        index          = 3,
        label          = result_price,
    })
end