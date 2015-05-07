local addon, namespace = ...
local Modules = namespace.Moe.Modules
local Media = namespace.Moe.Media
local Lib = namespace.Moe.Lib
local MM = Modules:Get("Monitor")

MM.Private = {
    --参数检查,"#"为任意类型
    argcheck = function(value, num, ...)
        assert(type(num) == 'number', "执行'argcheck'时错误:参数#2需要'number'类型,但传入了'"..type(num).."'类型)")
        
        for i = 1,select("#", ...) do if type(value) == select(i, ...) then return end end
        local types = strjoin(", ", ...)
        local name = string.match(debugstack(2,2,0), ": in function [`<](.-)['>]")
        error(("执行'%s'时错误:参数#%d需要'%s'类型,但传入了'%s'类型"):format(name, num, types, type(value)), 3)
    end,
    print = function(...)
        print("|cffefea33MoeMonitor:|r", ...)
    end,
    error = function(...)
        print("|cffefea33MoeMonitor:|r|cffff0000Error:|r "..string.format(...))
    end
}