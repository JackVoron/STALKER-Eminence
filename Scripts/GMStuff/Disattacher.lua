function onLoad()
    self.addContextMenuItem("Выполнить", attach)
end

function attach()
    local temp = self.getGMNotes()
    local settings = {}
    for k in string.gmatch(temp, "([^\n]+)") do
        for name, value in string.gmatch(k, "(.+)%s+=%s+(.+)") do
            settings[name] = value
        end
    end
    main = getObjectFromGUID(settings.main_guid)
 
    main.removeAttachments()
end