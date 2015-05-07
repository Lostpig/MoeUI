local addon, namespace = ...

namespace.Moe = {
    Lib = {},
    Media = {},
    Config = {},
    Theme = {},
    Modules = {},
}

if not MoeDB then 
    MoeDB = {
        Version = GetAddOnMetadata(addon, 'Version')
    } 
end

local global = GetAddOnMetadata(addon, 'X-MoeUI')
if global == "Moe" then
    _G[global] = namespace.Moe
end