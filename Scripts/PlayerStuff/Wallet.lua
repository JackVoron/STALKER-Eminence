money = {0, 0}
current_state = 1
tochange = 0
inp_value = nil

colors = {White = "FFFFFF", Brown = "713B17", Red = "DA1A18", Orange = "F4641D", Yellow = "E7E52C", Green = "31B32B", 
        Teal = "21B19B", Blue = "1E87FF", Purple = "A020F0", Pink = "F570CE", Grey = "808080", Black = "000000"}
function onSave()
    data_to_save = {money, current_state}
    saved_data = JSON.encode(data_to_save)
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
    
    if save_state ~= nil then
        loaded_data = JSON.decode(save_state)
        money = loaded_data[1]
        current_state = loaded_data[2]
    end
    if current_state == nil then
        current_state = 1
    end
    if money[1] == nil then
        money[1] = 0
    end
    if money[2] == nil then
        money[2] = 0
    end

    createButtons()
end

function createButtons()

    self.createButton({
        click_function = "changeMoney",
        function_owner = self,
        label          = "",
        position       = {0,0.6,-1.95},
        width          = 4950,
        height         = 2850,
        font_size      = 200,
        color          = {0,0,0,0},
        font_color     = {1,1,1},
    })
    
    local func = function(obj, color, alt_click) changeMoney(obj, color, true) end
    self.setVar("minusMoney", func)
    self.createButton({
        click_function = "minusMoney",
        function_owner = self,
        position       = {-6.5,0.6,1},
        width          = 1200,
        height         = 5800,
        color          = {0,0,0,0},
    })

    func = function(obj, color, alt_click) changeMoney(obj, color, false) end
    self.setVar("plusMoney", func)
    self.createButton({
        click_function = "plusMoney",
        function_owner = self,
        position       = {6.5,0.6,1},
        width          = 1200,
        height         = 5800,
        color          = {0,0,0,0},
    })

    self.createButton({
        click_function = "switchMoney",
        function_owner = self,
        position       = {0,0.6,-6.3},
        width          = 7400,
        height         = 1000,
        color          = {0,0,0,0},
    })

    self.UI.setXml([[<Text
        id="mainCurrency"
        height="300"
        width="500"
        color="#000000"
        fontSize="170"
        font="cifont/cifont"
        rotation="180 180 0"
        horizontalOverflow="overflow"
        verticalOverflow="overflow"
        position="0 -200 -60"
        text="error"
        scale = "1.2 2 1"
    />
    <Text
        id="secondCurrency"
        height="300"
        width="500"
        color="#000000"
        fontSize="70"
        font="cifont/cifont"
        rotation="180 180 0"
        horizontalOverflow="overflow"
        verticalOverflow="overflow"
        position="0 -620 -60"
        text="error"
        scale = "1.2 2 1"
    />
    <InputField
        id="moneyInput"
        height="200"
        width="800"
        color="#00000000"
        textColor="#000000"
        fontSize="200"
        font="cifont/cifont"
        rotation="180 180 0"
        horizontalOverflow="overflow"
        verticalOverflow="overflow"
        textAlignment="MiddleCenter"
        position="0 410 -60"
        text="error"
        placeholder=" "
        characterLimit = "7"
        characterValidation = "Integer"
        scale = "1.2 2 1"
        onEndEdit = "inputMoney"
    />
    ]])
    Wait.frames(updateDisplays, 5)
end

function changeMoney(obj, color, alt_click)
    if tochange == nil then
        return
    end
    if tochange > 0 then
        if alt_click == false then
            if money[current_state] + tochange > 9999999 then
                tochange = 9999999 - money[current_state]
            end     
            money[current_state] = money[current_state] + tochange
            printToAll("[" .. colors[color] .. "]" .. Player[color].steam_name .. "[-] [FFFF96]начислил[-] ".. tochange .. " " .. getCurrency()[1]:gsub("P", "₽"))
        else
            if money[current_state] - tochange < 0 then
                tochange = money[current_state]
            end   
            money[current_state] = money[current_state] - tochange 
            printToAll("[" .. colors[color] .. "]" .. Player[color].steam_name .. "[-] [FFFF96]cписал[-] ".. tochange .. " " .. getCurrency()[1]:gsub("P", "₽"))
        end
    else
        printToAll("Введите положительное число")
    end
    updateDisplays()
end

function switchMoney(obj, color, alt_click)
    if current_state == 1 then
        current_state = 2
    else
        current_state = 1
    end
    updateDisplays()
end

function updateDisplays()
    local another_state = 1
    if current_state == 1 then
        another_state = 2
    end
    
    local currency = getCurrency()
    local my_label = tostring(money[current_state]) .. " " .. currency[1]
    self.UI.setAttribute("mainCurrency", "text", my_label)

    my_label = tostring(money[another_state]) .. " " .. currency[2]
    self.UI.setAttribute("secondCurrency", "text", my_label)

    self.UI.setAttribute("moneyInput", "text", "")
    tochange = 0
end

function getCurrency()
    if current_state == 1 then
        return {"P","$"}
    else
        return {"$","P"}
    end
end

function inputMoney(player, value, id)
    tochange = tonumber(value)
end