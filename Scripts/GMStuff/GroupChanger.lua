

function onLoad()
    self.createButton({
        click_function = "changeGroup",
        label          = "☺",
        function_owner = self,
        height         = 525,
        width          = 525,
        position       = {0,0.25,0},
        color          = {0,0,0},
        font_color     = {1,1,1},
        font_size      = 600,
    })
    changeGroup()
    changeGroup()
end

function changeGroup()
    local temp = getNotes()
    if self.memo ~= nil then
        setNotes(self.memo)
    else
        setNotes("")
    end
    self.memo = temp
    
    objects = getAllObjects()
    if self.getGMNotes() == "0" then
        self.setGMNotes("1")
        for _, obj in pairs(objects) do
            if obj.hasTag("Group0") then
                obj.setInvisibleTo({"White", "Green", "Purple", "Red", "Yellow", "Grey"})
            end
            if obj.hasTag("Group1") then
                obj.setInvisibleTo()
            end
        end
    else
        self.setGMNotes("0")
        for _, obj in pairs(objects) do
            if obj.hasTag("Group1") then
                obj.setInvisibleTo({"White", "Green", "Purple", "Red", "Yellow", "Grey"})
            end
            if obj.hasTag("Group0") then
                obj.setInvisibleTo()
            end
        end
    end
end