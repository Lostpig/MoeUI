local addon, namespace = ...

local Media = namespace.Moe.Media
local Sets = {
    FontString = {
        attrname = "text",
        size = 14, 
        outline = "THINOUTLINE",
        anchor = "CENTER",
        align = "LEFT",
        x_off = 0,
        y_off = 0,
        textcolor = {1, 1, 1, 1},
        font = Media.Fonts.Default
    }, 
    ShadowBackdrop = { 
		edgeFile = Media.Texture.Glow,
		bgFile = Media.Texture.Blank, 
		edgeSize = size,
		tile = false,
		tileSize = 0,
		insets = {left = size, right = size, top = size, bottom = size},
	},
    BorderBackdrop = {
		edgeFile = Media.Texture.Blank, 
		edgeSize = size, 
		tile = false,
		tileSize = 0,
	}
}

namespace.Moe.DefaultSets = Sets