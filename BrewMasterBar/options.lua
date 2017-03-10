local addon, namespace = ...
local BMB = namespace.BMB
local Func = BMB.Func

local media = LibStub("LibSharedMedia-3.0")
local reverseMap = function (map)
    local newMap = {}
    for k, v in pairs(map) do
        if type(v) == "string" then
            newMap[v] = k
        end
    end
    
    return newMap
end

local defaultDB = {
    version = '1.11',
    
    locked = true,

    anchor   = 'CENTER',
    relative = 'CENTER',
    x        = 0,
    y        = 0,
    height   = 20,
    width    = 240,
    
    dmg = {
        show = true,
        font = 'Fonts\\ARKai_T.ttf',
        fontsize  = 14,
        fontflags = 'OUTLINE',
        point = 'RIGHT', x = 0, y = -20,
        align = 'RIGHT',
        numformat = 'full',
    },
    dmgperc = {
        show = true,
        font = 'Fonts\\ARKai_T.ttf',
        fontsize  = 14,
        fontflags = 'OUTLINE',
        point = 'RIGHT', x = 0, y = 0,
        align = 'RIGHT'
    },
    dpl = {
        show = true,
        font = 'Fonts\\ARKai_T.ttf',
        fontsize  = 12,
        fontflags = 'OUTLINE',
        point = 'RIGHT', x = 5, y = 0,
        align = 'LEFT',
        numformat = 'full',
    },
    winetime = {
        show = true,
        font = 'Fonts\\ARKai_T.ttf',
        fontsize  = 14,
        fontflags = 'OUTLINE',
        point = 'LEFT', x = 0, y = 18,
        align = 'LEFT'
    },
    winecount = {
        show = true,
        font = 'Fonts\\ARKai_T.ttf',
        fontsize  = 14,
        fontflags = 'OUTLINE',
        point = 'LEFT', x = -5, y = 0,
        align = 'RIGHT'
    },
    
    texture = media:HashTable('statusbar')['Blizzard'],
    timer = 0.2,
    uncombat = 'fade'
}

local pointsMap = {
    ['CENTER']      = '中间', 
    ['TOP']         = '上方', 
    ['BOTTOM']      = '下方',
    --['LEFTIN']      = '左侧内部',
    --['LEFTOUT']     = '左侧外部',
    ['LEFT']        = '左侧',
    ['TOPLEFT']     = '左上方',
    ['BOTTOMLEFT']  = '左下方',
    --['RIGHTIN']     = '右侧内部',
    --['RIGHTOUT']    = '右侧外部',
    ['RIGHT']       = '右侧',
    ['TOPRIGHT']    = '右上方',
    ['BOTTOMRIGHT'] = '右下方',
}
local alignsMap = {
    ['CENTER'] = '居中对齐',
    ['LEFT']   = '左对齐',
    ['RIGHT']  = '右对齐',
}
local flagsMap = {
    ['NONE'] = 'NONE',
    ['OUTLINE'] = 'OUTLINE',
    ['THICKOUTLINE'] = 'THICKOUTLINE',
    ['MONOCHROME'] = 'MONOCHROME',
}

local texts = {
    { name = 'dmg'       , text = '醉拳总伤害' }, 
    { name = 'dmgperc'   , text = '醉拳伤害占最大生命值百分比' },
    { name = 'dpl'       , text = '醉拳每跳伤害' },
    { name = 'winetime'  , text = '铁骨酒剩余时间' },
    { name = 'winecount' , text = '铁骨酒/活血酒可用次数' },
}
local GetOptionsSetting = function()
    local options = {
        type = 'group',
        name = 'BrewMasterBar',
        plugins = { },
        args = {
            d = {
                type  = 'description',
                name  = '酒仙武僧醉拳计量条',
                order = 0,
            },
            group_locked = {
                type  = "group",
                name  = '锁定',
                inline= true,
                order = 1,
                args  = {
                    barlocked = {
                        type  = 'toggle',
                        name  = '锁定',
                        desc  = '锁定/解锁醉拳计量条',
                        order = 1,
                        get   = function() 
                            return BMBDB.locked 
                        end,
                        set   = function() 
                            BMBDB.locked = not BMBDB.locked 
                            BMB.Main:Locked()
                        end
                    }
                }
            },
            group_size = {
                type  = "group",
                name  = '基本设置',
                inline= true,
                order = 2,
                args  = {
                    barwidth = {
                        type  = 'range',
                        name  = '宽度',
                        desc  = '设置计量条宽度',
                        min   = 50,
                        max   = 1000,
                        step  = 1,
                        get   = function() return BMBDB.width end,
                        set   = function(self, val) 
                            BMBDB.width = val 
                            BMB.Main:ApplySetting()
                        end,
                        order = 1,
                    },
                    barheight = {
                        type  = 'range',
                        name  = '高度',
                        desc  = '设置计量条高度',
                        min   = 5,
                        max   = 200,
                        step  = 1,
                        get   = function() return BMBDB.height end,
                        set   = function(self, val) 
                            BMBDB.height = val 
                            BMB.Main:ApplySetting()
                        end,
                        order = 2,
                    },
                    bartexture = {
                        type  = 'select',
                        name  = '材质',
                        desc  = '设置计量条材质',
                        values=	reverseMap(media:HashTable('statusbar')),
                        get   = function() return BMBDB.texture end,
                        set   = function(self, opt) 
                            BMBDB.texture = opt
                            BMB.Main:ApplySetting()
                        end,
                        order = 3,
                    },
                    barrefresh = {
                        type  = 'select',
                        name  = '刷新速度',
                        desc  = '设置监视的刷新速度',
                        values=	{
                            [0.033]= '快(30fps)', 
                            [0.05] = '较快(20fps)', 
                            [0.1]  = '普通(10fps)', 
                            [0.2]  = '较慢(5fps)', 
                            [0.5]  = '慢(2fps)'
                        },
                        get   = function() return BMBDB.timer end,
                        set   = function(self, opt) 
                            BMBDB.timer = opt
                            BMB.Main:ApplySetting()
                        end,
                        order = 4,
                    },
                    uncombat = {
                        type  = 'select',
                        name  = '脱战后隐藏',
                        desc  = '设置脱战显示状态',
                        values=	{
                            ['show'] = '正常显示', 
                            ['fade'] = '半透明显示', 
                            ['hide'] = '完全隐藏'
                        },
                        get   = function() return BMBDB.uncombat end,
                        set   = function(self, opt) 
                            BMBDB.uncombat = opt
                            BMB.Main:ApplySetting()
                        end,
                        order = 5,
                    },
                }
            },
        }
    }
    
    local textObj, textOpt
    for index, textitem in pairs(texts) do
        options.args[textitem.name] = {
            type  = "group",
            name  = textitem.text,
            inline= true,
            order = 3 + index,
            args  = {
                isshow = {
                    type  = 'toggle',
                    name  = '显示',
                    desc  = '是否显示',
                    order = 0,
                    get   = function() 
                        return BMBDB.dmg.show 
                    end,
                    set   = function() 
                        BMBDB[textitem.name].show = not BMBDB[textitem.name].show
                        BMB.Main:ApplySetting()
                    end
                },
                barfont = {
                    type  = 'select',
                    name  = '字体',
                    desc  = '设置数字字体',
                    values=	reverseMap(media:HashTable('font')),
                    get   = function() return BMBDB[textitem.name].font end,
                    set   = function(self, opt) 
                        BMBDB[textitem.name].font = opt
                        BMB.Main:ApplySetting()
                    end,
                    order = 1,
                },
                barfontsize = {
                    type  = 'range',
                    name  = '字体大小',
                    desc  = '设置数字字体大小',
                    min   = 6,
                    max   = 50,
                    step  = 1,
                    get   = function() return BMBDB[textitem.name].fontsize end,
                    set   = function(self, val) 
                        BMBDB[textitem.name].fontsize = val
                        BMB.Main:ApplySetting()
                    end,
                    order = 2,
                },
                outline = {
                    type  = 'select',
                    name  = '文字轮廓',
                    desc  = '设置文字轮廓',
                    values=	flagsMap,
                    get   = function() return BMBDB[textitem.name].fontflags end,
                    set   = function(self, opt) 
                        BMBDB[textitem.name].fontflags = opt 
                        BMB.Main:ApplySetting()
                    end,
                    order = 3,
                },
                anchor = {
                    type  = 'select',
                    name  = '锚点',
                    desc  = '设置文字锚点',
                    values=	pointsMap,
                    get   = function() return BMBDB[textitem.name].point end,
                    set   = function(self, opt) 
                        BMBDB[textitem.name].point = opt 
                        BMB.Main:ApplySetting()
                    end,
                    order = 4,
                },
                point_x = {
                    type  = 'range',
                    name  = 'x轴偏移',
                    desc  = '文字x轴偏移量',
                    min   = -100,
                    max   = 100,
                    step  = 1,
                    get   = function() return BMBDB[textitem.name].x end,
                    set   = function(self, val) 
                        BMBDB[textitem.name].x = val 
                        BMB.Main:ApplySetting()
                    end,
                    order = 5,
                },
                point_y = {
                    type  = 'range',
                    name  = 'y轴偏移',
                    desc  = '文字y轴偏移量',
                    min   = -100,
                    max   = 100,
                    step  = 1,
                    get   = function() return BMBDB[textitem.name].y end,
                    set   = function(self, val) 
                        BMBDB[textitem.name].y = val 
                        BMB.Main:ApplySetting()
                    end,
                    order = 6,
                },
                align = {
                    type  = 'select',
                    name  = '文字对齐',
                    desc  = '设置数字的对齐方式',
                    values=	alignsMap,
                    get   = function() return BMBDB[textitem.name].align end,
                    set   = function(self, opt) 
                        BMBDB[textitem.name].align = opt 
                        BMB.Main:ApplySetting()
                    end,
                    order = 7,
                },
            }
        }
        
        if (textitem.name == 'dmg' or textitem.name == 'dpl') then
            options.args[textitem.name].args.numformat = {
                type  = 'select',
                name  = '数字格式',
                desc  = '设置数字的显示格式',
                values=	{
                    ['full'] = '完整', 
                    ['cn']   = '中式缩写', 
                    ['en']   = '西式缩写'
                },
                get   = function() return BMBDB[textitem.name].numformat end,
                set   = function(self, opt) 
                    BMBDB[textitem.name].numformat = opt 
                    BMB.Main:ApplySetting()
                end,
                order = 8,
            }
        end
    end
    
    return options
end
local InitOption = function ()
    if ((not BMBDB) or (BMBDB.version ~= defaultDB.version)) then
        BMBDB = defaultDB
    end
    
    LibStub('AceConfigRegistry-3.0'):RegisterOptionsTable('BrewMasterBar', GetOptionsSetting(), true)
    BMB.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('BrewMasterBar', 'BrewMasterBar')
end

BMB.InitOption = InitOption