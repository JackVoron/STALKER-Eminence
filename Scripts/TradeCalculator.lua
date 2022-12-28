confirm_buttons = {
    {
        position       = {-1.25,0.12,0},
    },
    {
        position       = {2.5,0.12,0},
    }
}

font_colors = {"#660808", "#000000", "#084008"}
colors = {White = "FFFFFF", Brown = "713B17", Red = "DA1A18", Orange = "F4641D", Yellow = "E7E52C", Green = "31B32B", 
        Teal = "21B19B", Blue = "1E87FF", Purple = "A020F0", Pink = "F570CE", Grey = "808080", Black = "000000"}

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


reputation = 3

selling_price = 0
buying_price = 0
result_price = 0

function onLoad(save_state)
    self.UI.setCustomAssets({
        {
            type = 1,
            name = "cifont",
            url = "http://cloud-3.steamusercontent.com/ugc/1986680868878944084/44125D7412F853AA4ED4A3701035C20D4FE14E90/",
        }
    })
    createButtonsAndInputs()
end

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
    
    self.createButton({
        click_function = "deal",
        function_owner = self,
        label          = "",
        position       = {0.65,0.12,-0.05},
        width          = 1500,
        height         = 550,
        font_size      = 380,
        color          = {0,0,0,0},
        font_color     = {1,1,1},
        tooltip        = "Сделка",
    })

    self.createButton({
        click_function = "setRep",
        function_owner = self,
        label          = "",
        position       = {-4.9,0.12,-0.05},
        width          = 620,
        height         = 550,
        font_size      = 360,
        color          = {0,0,0,0},
        font_color     = {1,1,1},
    })

    self.UI.setXml([[
    <Text
        id="reputation"
        height="300"
        width="500"
        color="#000000"
        fontSize="80"
        font="cifont/cifont"
        rotation="180 180 0"
        horizontalOverflow="overflow"
        verticalOverflow="overflow"
        position="490 -7 -12"
        text="E"
    />
    <InputField
        id="sellInput"
        height="90"
        width="250"
        color="#00000000"
        textColor="#000000"
        fontSize="60"
        font="cifont/cifont"
        rotation="180 180 0"
        horizontalOverflow="overflow"
        verticalOverflow="overflow"
        textAlignment="MiddleCenter"
        position="290 -7 -12"
        text="error"
        placeholder=" "
        characterLimit = "7"
        characterValidation = "Integer"
        onEndEdit = "setPrice"
    />
    <InputField
        id="buyInput"
        height="90"
        width="250"
        color="#00000000"
        textColor="#000000"
        fontSize="60"
        font="cifont/cifont"
        rotation="180 180 0"
        horizontalOverflow="overflow"
        verticalOverflow="overflow"
        textAlignment="MiddleCenter"
        position="-420 -7 -12"
        text="error"
        placeholder=" "
        characterLimit = "7"
        characterValidation = "Integer"
        onEndEdit = "setPrice"
    />
    <Text
        id="offer"
        height="300"
        width="500"
        color="#000000"
        fontSize="60"
        font="cifont/cifont"
        rotation="180 180 0"
        horizontalOverflow="overflow"
        verticalOverflow="overflow"
        position="-70 -7 -12"
        text="error"
    />
    ]])
    Wait.frames(function()
        self.UI.setAttribute("offer", "text", tostring(result_price))

        local my_font_color
        if reputation < 3 then
            my_font_color = font_colors[1]
        elseif reputation < 8 then
            my_font_color = font_colors[2]
        else
            my_font_color = font_colors[3]
        end
        
        self.UI.setAttribute("reputation", "color", my_font_color)
    
        if reputation > 1 then
            self.UI.setAttribute("reputation", "text", tostring(reputation))
        else
            self.UI.setAttribute("reputation", "text", "Ø")
        end
        self.UI.setAttribute("sellInput", "text", "")
        self.UI.setAttribute("buyInput", "text", "")
    end, 5)
end

function setPrice(player, value, id)
    if id == "sellInput" then
        selling_price = tonumber(value)
    else
        buying_price = tonumber(value)
    end
end

function setRep(obj, color, alt)
    if alt == true then
        if reputation > 1 then
            reputation = reputation - 1
        end
    else
        if reputation < 10 then
            reputation = reputation + 1
        end
    end

    local my_font_color
    if reputation < 3 then
        my_font_color = font_colors[1]
    elseif reputation < 8 then
        my_font_color = font_colors[2]
    else
        my_font_color = font_colors[3]
    end
    
    self.UI.setAttribute("reputation", "color", my_font_color)

    if reputation > 1 then
        self.UI.setAttribute("reputation", "text", tostring(reputation))
    else
        self.UI.setAttribute("reputation", "text", "Ø")
    end
end

function confirm(i)
    if i == 1 then
        result_price = result_price + selling_price + math.floor(selling_price*selling_rep[reputation]/100)
        selling_price = 0
        self.UI.setAttribute("sellInput", "text", "")
    else
        result_price = result_price - buying_price + math.floor(buying_price*buying_rep[reputation]/100)
        buying_price = 0
        self.UI.setAttribute("buyInput", "text", "")
    end

    self.UI.setAttribute("offer", "text", tostring(result_price))
end

function deal(obj, player_color)
    if result_price > 0 then
        printToAll("[" .. colors[player_color] .. "]" .. Player[player_color].steam_name .. "[-]: [FFFF96]Сделка состоялась. Вы получили[-]: [99ff33]" .. result_price)
    elseif result_price == 0 then
        printToAll("Торговец: [FFFF96]" .. phrases[math.random(#phrases)])
    else
        printToAll("[" .. colors[player_color] .. "]" .. Player[player_color].steam_name .. "[-]: [FFFF96]Сделка состоялась. Вы должны[-]: [ff8080]" .. math.abs(result_price))
    end

    result_price = 0

    self.UI.setAttribute("offer", "text", tostring(result_price))
end