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
    if getObjectFromGUID(settings.main_guid) and getObjectFromGUID(settings.child_guid) then 
        main = getObjectFromGUID(settings.main_guid)
        child = getObjectFromGUID(settings.child_guid)
        main.addAttachment(child)
    end
end