status = {
    unknown = "http://cloud-3.steamusercontent.com/ugc/1906728591384224568/D030143F7635D0105F9F29AE42B754B81DFEF173/",
    open = "http://cloud-3.steamusercontent.com/ugc/1829029367518880045/E31378244C47EC6404504CEDB200324CCA16C2E2/",
    exist = "http://cloud-3.steamusercontent.com/ugc/1829029367518891417/7EAECE9514090DE8ECCFD9959EB1069B2E08853D/",
    miss = "http://cloud-3.steamusercontent.com/ugc/1829029367518887905/B098895B7071A771A1EED61C6F4EFC286BD2316B/",
}

numbers = {
    "http://cloud-3.steamusercontent.com/ugc/1892091893979316688/AAE238591A229ACEE6B66617B60C36E2A68D3030/", -- one
    "http://cloud-3.steamusercontent.com/ugc/1892091893979317813/A5E69D802F69645E2EC93974679ADCDD4F089C37/", -- two
    "http://cloud-3.steamusercontent.com/ugc/1892091893979318408/9C631D51DD28DE4670979232DABF73D810EDA450/", -- etc
    "http://cloud-3.steamusercontent.com/ugc/1892091893979319045/B7AAFC5AD3E2FC7A8FA63744B7E8E2382275DF33/",
    "http://cloud-3.steamusercontent.com/ugc/1892091893979319800/7293E0ADB0486362FE9689B3AABE761E4F41F2E5/",
    "http://cloud-3.steamusercontent.com/ugc/1892091893979320955/2E4165A1CC69846C322D5FBE41E00F68334CC7D5/",
    "http://cloud-3.steamusercontent.com/ugc/1892091893979321527/1D7B394126C017AA9CD109C7BCF5A5C2349E31B4/",
    "http://cloud-3.steamusercontent.com/ugc/1892091893979325688/E18D93BB23516220AD06AB7364B23835228BFEEF/",
    "http://cloud-3.steamusercontent.com/ugc/1892091893979326332/41A8E5BB9734242711E58AC3F8A66D8C09DFCEBB/",
    "http://cloud-3.steamusercontent.com/ugc/1892091893979311743/01502B5189EB83274C821ACE7C1B867D793683B9/" -- zero
}

lock_buttons = {
    {
        position = {-5.475,0.6,5.85}
    },
    {
        position = {-1.85,0.6,5.85}
    },
    {
        position = {1.775,0.6,5.85}
    },
    {
        position = {5.415,0.6,5.85}
    },
}

try_count = 1
try_code = {}
code = {}

function onLoad()
    createButtons()
    reset()
    self.addContextMenuItem("Сбросить", function() reset() end)
end

function createButtons()
    for i = 1,4 do
        local funcname = "changeNumber" .. i
        local func = function(obj, color, alt_click) changeNumber(i, alt_click) end
        self.setVar(funcname, func)
        self.createButton({
            click_function = funcname,
            function_owner = self,
            position       = lock_buttons[i].position,
            width          = 1500,
            height         = 1500,
            color          = {0,0,0,00},
        })
    end
    self.createButton({
        click_function = "tryOpen",
        function_owner = self,
        position       = {0,0.6,-3},
        width          = 1000,
        height         = 1000,
        color          = {0,0,0,0},
    })
    self.createButton({
        click_function = "tryOpen",
        function_owner = self,
        label          = try_count,
        position       = {0,0.6,-6.2},
        width          = 0,
        height         = 0,
        font_size      = 1000,
        color          = {0,0,0},
        font_color     = {0.74,0.71,0.42,0.65}
    })
end

function changeNumber(i, alt_click)
    if alt_click == true then
        try_code[i] = try_code[i] - 1
        if try_code[i] < 0 then
            try_code[i] = 9
        end
    else
        try_code[i] = try_code[i] + 1
        if try_code[i] > 9 then
            try_code[i] = 0
        end
    end
    local num = try_code[i]
    self.editButton({index = i -1, label = try_code[i]})
    local num = try_code[i]
    if num == 0 then
        num = 10
    end
    local children = self.removeAttachments()
    local icon = children[i+4]
    icon.setCustomObject({diffuse = numbers[num]})
    for __, icon in pairs(children) do
        self.addAttachment(icon)
    end
end

function tryOpen(obj, player_color)
    local flag = true
    if try_count > 0 then
        local children = self.removeAttachments()
        for i=1,4 do
            local icon = children[i]
            if try_code[i] == code[i] then
                icon.setCustomObject({diffuse = status.open})
            elseif tableContains(code, try_code[i]) then
                icon.setCustomObject({diffuse = status.exist})
            else
                icon.setCustomObject({diffuse = status.miss})
            end
        end
        for __, icon in pairs(children) do
            self.addAttachment(icon)
        end
        try_count = try_count - 1
        self.editButton({
            index          = 5,
            label          = try_count,
        })
        for i=1,4 do
            if try_code[i] ~= code[i] then
                flag = false
                break
            end
        end
        if flag == true then
            printToAll(Player[player_color].steam_name .. ": [FFFF96]Пароль взломан")
        end
        if flag == false and try_count == 0 then
            printToAll("Надпись на экране: [FFFF96]Ублюдок, мать твою, а ну иди сюда, говно собачье, решил меня взломать? Ты, вор вонючий, мать твою, а? Ну иди сюда, попробуй меня взломать, я тебя сломаю, ублюдок, хакер чертов, будь ты перезаписан, иди идиот, трахать тебя и всю семью, говно собачье, жлоб вонючий, дерьмо, сука, падла, я твой айпи запомнил, маордер, негодяй, гад, иди сюда, ты — говно, жопа!")
        end
    else
        printToAll("Надпись на экране: [FFFF96]Ублюдок, мать твою, а ну иди сюда, говно собачье, решил меня взломать? Ты, вор вонючий, мать твою, а? Ну иди сюда, попробуй меня взломать, я тебя сломаю, ублюдок, хакер чертов, будь ты перезаписан, иди идиот, трахать тебя и всю семью, говно собачье, жлоб вонючий, дерьмо, сука, падла, я твой айпи запомнил, маордер, негодяй, гад, иди сюда, ты — говно, жопа!")
    end
end

function reset()
    local temp = self.getGMNotes()
    local settings = {}
    for k in string.gmatch(temp, "([^\n]+)") do
        for name, value in string.gmatch(k, "(.+)%s+=%s+(.+)") do
            settings[name] = value
        end
    end

    if settings.try_count == nil then
        try_count = 1
    else
        try_count = tonumber(settings.try_count)
    end
    self.editButton({
        index          = 5,
        label          = try_count,
    })

    if settings.code == nil then
        code = {0,0,0,0}
    else
        for i = 1,4 do
            code[i] = tonumber(string.sub(settings.code,i,i))
        end
    end

    try_code = {0,0,0,0}

    local children = self.removeAttachments()
    for i=1,4 do
        local icon = children[i]
        icon.setCustomObject({diffuse = status.unknown})
        local icon = children[i+4]
        icon.setCustomObject({diffuse = numbers[10]})
    end
    for __, icon in pairs(children) do
        self.addAttachment(icon)
    end
end

function tableContains(table, x)
    found = false
    for _, v in pairs(table) do
        if v == x then
            found = true
        end
    end
    return found
end