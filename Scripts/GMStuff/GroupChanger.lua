colors = {Purple = "A020F0" , Red = "DA1A18", White = "FFFFFF", Yellow = "E7E52C", Green = "31B32B", Teal = "21B19B"}

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
        tooltip        = "Текущая группа: ".. self.getGMNotes()
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
    self.editButton({index = 0, tooltip = "Текущая группа: ".. self.getGMNotes()})
    changeNotes()
end

function changeNotes()
    notes = {}
    for i, note in pairs(getNotebookTabs()) do
        for color_name, color_code in pairs(colors) do
            if string.find(note.title, ".+" ..  color_code .. ".+") ~= nil then
                if note.color == "Black" then
                    if color_name ~= "Teal" then
                        note.color = color_name
                    else
                        note.color = "Grey"
                    end
                else
                    note.color = "Black"
                end
                break
            end
        end
        notes[i] = note
    end

    for i = #notes, 1, -1 do
        removeNotebookTab(i-1)
    end
    
    for i = 1, #notes do
        addNotebookTab(notes[i])
    end
end