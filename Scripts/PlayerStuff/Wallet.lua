money = {0,0}
current_state = 1
tochange = 0
inp_value = nil

function onSave()
    data_to_save = {money, current_state}
    saved_data = JSON.encode(data_to_save)
    return saved_data
end

function onLoad(save_state)
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
        scale          = {5.2, 1, 9},
        position       = {0,0.6,-1.93},
        width          = 0,
        height         = 0,
        font_size      = 200,
        color          = {0,0,0,1},
        font_color     = {0,0,0},
    })
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

    self.createInput({
        input_function = "inputMoney",
        function_owner = self,
        label          = "",
        scale          = {5.2, 1, 9},
        position       = {0,0.6,4.35},
        width          = 800,
        height         = 300,
        font_size      = 200,
        alignment      = 3,
        color          = {1,1,1,0},
        validation     = 2,
        })
    self.createButton({
        click_function = "inputMoney",
        function_owner = self,
        label          = "",
        scale          = {5.2, 1, 9},
        position       = {0,0.6,4.35},
        width          = 0,
        height         = 0,
        font_size      = 200,
        color          = {0,0,0,1},
        font_color     = {0,0,0},
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
        scale          = {5.2, 1, 9},
        position       = {0,0.6,-6.15},
        width          = 0,
        height         = 0,
        font_size      = 85,

    })
    self.createButton({
        click_function = "switchMoney",
        function_owner = self,
        position       = {0,0.6,-6.3},
        width          = 7400,
        height         = 1000,
        color          = {0,0,0,0},
    })
    updateDisplays()
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
            printToAll(Player[color].steam_name .. " [FFFF96]начислил[-] ".. tochange .. " " .. getCurrency()[1])
        else
            if money[current_state] - tochange < 0 then
                tochange = money[current_state]
            end   
            money[current_state] = money[current_state] - tochange 
            printToAll(Player[color].steam_name .. " [FFFF96]cписал[-] ".. tochange .. " " .. getCurrency()[1])
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
    self.editInput({index = 0, label= ""})
    self.editButton({index = 2, label = ""})
    tochange = 0
end

function updateDisplays()
    local another_state = 1
    if current_state == 1 then
        another_state = 2
    end
    
    local currency = getCurrency()
    local my_label = tostring(money[current_state]) .. " " .. currency[1]
    self.editButton({index = 0, label = my_label})

    local my_label2 = tostring(money[another_state]) .. " " .. currency[2]
    self.editButton({index = 5, label = my_label2})

    self.editInput({index = 0, value= ""})
    self.editButton({index = 2, label = ""})
    tochange = 0
    
end

function getCurrency()
    if current_state == 1 then
        return {"₽","$"}
    else
        return {"$","₽"}
    end
end

function inputMoney(obj, player_clicker_color, input_value, selected)
    if #input_value > 7 then
        input_value = string.sub(input_value, 0, 7)
        inp_value = input_value
        Wait.time(function()
            self.editInput({index = 0, value = inp_value})           
        end, 0.01)
    end
    self.editButton({index = 2, label = input_value})
    tochange = tonumber(input_value)
end