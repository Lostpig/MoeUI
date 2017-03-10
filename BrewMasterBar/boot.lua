local addon, namespace = ...
local BMB = namespace.BMB
local Func = BMB.Func

Func.NewTrigger(nil, {
    Events = { 'PLAYER_ENTERING_WORLD' },
    Script = function (self)
        self:Destroy();
        
        local _, class = UnitClass('player')
        if class == 'MONK' then
            BMB.InitOption()
            BMB.Main:Create()
            BMB.Main.Bar:enable()
        end
    end
})