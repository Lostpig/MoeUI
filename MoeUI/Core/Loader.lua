local addon, namespace = ...
local Moe = namespace.Moe

Moe.Lib.NewTrigger(nil, {
    Events = {"PLAYER_LOGIN"},
    Script = function(self, event)
        Moe.Media.Register();
        if Moe.Theme:Init() then 
            Moe.Modules:Load()
        end
        self:Destroy()
    end
})