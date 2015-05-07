local addon, namespace = ...
local Config = namespace.Moe.Config
local Lib = namespace.Moe.Lib
local Modules = namespace.Moe.Modules

local modulens = {}
local modules = {}
Modules.Get = function(self, modulename)
    if not modulens[modulename] then modulens[modulename] = {} end
    return modulens[modulename]
end
Modules.AddModule = function(self, name, load, loadAfter)
    if modules[name] then return Lib.Error("Module [%s] 已存在", name) end
    modules[name] = {Name = name, Load = load, After = loadAfter}
end
Modules.Load = function(self)
    local AfterLoad = {}
    local Loaded = {}
    local Enables = Config["Modules"]
    for name, module in next, modules do
        if Enables[name] then 
            if module.After and not Loaded[module.After] then
                if not AfterLoad[module.After] then AfterLoad[module.After] = {} end
                tinsert(AfterLoad[module.After], module)
            else
                module.Load()
                if AfterLoad[name] then
                    for _, m in AfterLoad[name] do m.Load() end
                    wipe(AfterLoad[name])
                    AfterLoad[name] = nil
                end
                Loaded[name] = true
            end
        --else print("Module ["..name.."]已被禁用")
        end
    end
    --for k,v in pairs(Loaded) do print("Module ["..k.."]已启用") end
    
    for k, v in pairs(AfterLoad) do
        if v then
            for i = 1, #v do
                Lib.Error("前置Module [%s]不存在，导致Module [%s] 无法加载", k, v[i].Name)
            end
        end
    end
    
    --wipe(modulens)
    wipe(modules)
end