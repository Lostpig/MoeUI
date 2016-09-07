local addon, namespace = ...
local Moe = namespace.Moe
local Config = Moe.Config
local Media = Moe.Media

--默认主题 不要修改
Config["Theme"] = "Default"
--启用模块
Config["Modules"] = {   
    ["ActionBar"] = true,   --动作条
    ["Bags"] = false,       --背包(暂时放弃支持，不要启用)
    ["Chat"] = true,        --聊天框美化
    ["Emote"] = true,       --聊天表情
    ["GUI"] = true,         --界面
    ["InfoBar"] = true,     --信息/菜单条
    ["Monitor"] = true,     --职业监视 仅支持武僧(奶,DPS)和牧师(戒,暗)
    ["Status"] = true,      --属性监视
    ["Tooltip"] = true,     --鼠标提示美化
    ["UnitFrame"] = true,   --头像(不支持小队和竞技场)
    ["Minimap"] = true,     --小地图
    --Toys
    ["Remilia"] = true,     --雷米&芙兰卖萌小插件
    ["Card"] = true,        --翻转提示小插件
    ["Warning"] = true,     --艦コレ低血量提示小插件
}
--动作条
Config["ActionBar"] = {
    showmainbar = true,  --进入游戏是否默认显示主动作条
    bar1 = {
        scale		= 1,
        spacing		= 4,
        size        = 26,
        point		= {"BOTTOM", "UIParent", "BOTTOM", 0, 15 },
        enable		= true,
    },
    bar2 = {
        scale		= 1,
        spacing		= 4,
        size        = 26,
        point		= {"BOTTOM", "UIParent", "BOTTOM", 0, 45 },
    },
    bar3 = {
        scale		= 1,
        spacing		= 4,
        size        = 26,
        point		= {"BOTTOM", "UIParent", "BOTTOM", 0, 75 },
        vertical	= false,
    },
    bar4 = {
        scale		= 1,
        spacing		= 4,
        size        = 26,
        point		= {"RIGHT", "UIParent", "RIGHT", -2, 15 },
        vertical	= true,
        fade 		= true,
        fadein		= 1,
        fadeout		= 0,
        fadetime 	= 0.5,
    },
    bar5 = {
        scale		= 1,
        spacing		= 4,
        size        = 26,
        point		= {"RIGHT", "UIParent", "RIGHT", -32, 15 },
        vertical	= true,
        fade 		= true,
        fadein		= 1,
        fadeout		= 0,
        fadetime 	= 0.5,
    },
    petbar = {
        scale		= 1,
        spacing		= 2,
        size        = 24,
        point		= {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", 0, 182},
    },
    stancebar = {
        scale		= 1,
        spacing		= 2,
        size        = 24,
        point		= {"BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 182},
    },
    extrabar = {
        scale		= 1,
        spacing		= 2,
        size        = 32,
        point		= {"BOTTOMRIGHT", "UIParent", "BOTTOM", -184, 75 },
    },
    leavevehicle = {
        scale		= 0.92,
        spacing		= 2,
        size        = 26,
        point		= {"BOTTOM", "UIParent", "BOTTOMRIGHT", 180, 0 },
    },
    overridebar = {
        scale		= 0.92,
        spacing		= 2,
        size        = 26,
        point		= {"BOTTOM", "UIParent", "BOTTOM", 0, 10 },
    },
    micromenu = {
        scale		= 0.92,
        spacing		= 2,
        size        = 26,
        point		= {"TOP", "UIParent", "TOP", 0, -100 },
        hide		= true,
    },
    bagbar = {
        scale		= 0.92,
        spacing		= 2,
        size        = 26,
        point		= {"TOP", "UIParent", "TOP", 0, -200 },
        hide		= true,
    },
}
--背包(暂时放弃支持)
Config["Bag"] = {
    bag = { size = 36, spacing = 4, column = 10 },
	bank = { size = 36, spacing = 4, column = 12 },
	reagent = { size = 36, spacing = 4, column = 12 },
}
--小地图
Config["Minimap"] = {
    size = 120,
    anchor = "TOPRIGHT", relative = "TOPRIGHT",
    x = -7,y = -29,
}
--鼠标提示
Config["Tip"] = {
    font = Media.Fonts.Default,
    fontsize = 13,
    outline = "OUTLINE",
    tex = Media.Bar.Armory,

    scale = 1,
    point = { "BOTTOMRIGHT", "BOTTOMRIGHT", -65, 180 },
    cursor = false,

    hideTitles = false,
    hideRealm = false,

    bgcolor = { r=0.05, g=0.05, b=0.05, t=0.9 },
    bdrcolor = { r=0.3, g=0.3, b=0.3 },
    gcolor = { r=1, g=0.1, b=0.8 },

    you = "<你>",
    boss = "首領",
    colorborderClass = false,
    combathide = true,
}
--头像
Config["UnitFrame"] = {
	theme = "Default",
	player = {
		show = true, scale = 1,
		anchor = "RIGHT", relative = "CENTER", x = -135, y = -100,
	},
	target = {
		show = true, scale = 1,
		anchor = "LEFT", relative = "CENTER", x = 135, y = -100,
	},
	targettarget = {
		show = true, scale = 1,
		anchor = "TOPLEFT", relative = "TOPRIGHT", x = 4, y = 0,
		anchorTo = "target",
	},
	pet = {
		show = true, scale = 1,
		anchor = "TOPRIGHT", relative = "TOPLEFT", x = -4, y = 0,
		anchorTo = "player",
	},
	focus = {
		show = true, scale = 1,
		anchor = "RIGHT", relative = "CENTER", x = -140, y = 120,
	},
	focustarget = {
		show = true, scale = 1,
		anchor = "TOP", relative = "BOTTOM", x = 0, y = -22,
		anchorTo = "focus",
	},
	boss = {
		show = true, scale = 1,
		anchor = "BOTTOMRIGHT", relative = "TOPRIGHT", x = 0, y = 220,
		anchorTo = "target",
		relativepos = { direction = "DOWN", spacing = 5 },
	},
}
--翻转提示小插件
Config["Card"] = {
    Theme = "Default",
	Pos = {
		a1 = "CENTER",
		a2 = "BOTTOM",
		x = 282,
		y = 102,
	}
}
--艦コレ低血量提示小插件
Config["Warning"] = {
    duration = 1.2,
    delay = 0.8,
    medium = 0.6,
    broken = 0.3,
}

