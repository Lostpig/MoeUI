local addon, namespace = ...
local Media = namespace.Moe.Media

local locale = GetLocale()
local localFonts = {}
if locale == "zhTW" then
    localFonts.D = [[Fonts\bLEI00D.ttf]]
    localFonts.C = [[Fonts\bHEI01B.ttf]]
    localFonts.T = [[Fonts\bKAI00M.ttf]]
    localFonts.F = [[Fonts\bHEI00M.ttf]]
else
    localFonts.D = [[Fonts\ARHei.ttf]]
    localFonts.C = [[Fonts\ARKai_C.ttf]]
    localFonts.T = [[Fonts\ARKai_T.ttf]]
    localFonts.F = [[Fonts\ARHei.ttf]]
end

local path = "Interface\\Addons\\MoeUI\\Media\\"
Media.Path = path
Media.Fonts = {
    Default = localFonts.D,
    C       = localFonts.C,
    T       = localFonts.T,
    F       = localFonts.F,
    NUM1    = path..[=[font\N1.ttf]=],
    NUM2    = path..[=[font\N2.ttf]=],
    NUM3    = path..[=[font\N3.ttf]=],
    NUM4    = path..[=[font\N4.ttf]=],
    NUM5    = path..[=[font\N5.ttf]=],
    NUM6    = path..[=[font\N6.ttf]=],
    NUM7    = path..[=[font\N7.ttf]=],
}
Media.Texture = {
    Blank      = [=[Interface\BUTTONS\WHITE8X8]=],
    BackGround = [=[Interface\ChatFrame\ChatFrameBackground]=],
    Glow       = path..[=[texture\glowTex]=],
    GlowTex    = path..[=[texture\glow]=],
    Solid      = path..[=[texture\solid]=],
    Halo       = path..[=[texture\halo]=],
    Arrow      = path..[=[texture\arrow]=],
}
Media.Bar = {
    Armory = path..[=[bar\armory]=],
    GradCE = path..[=[bar\gradientCEBar]=],
    GradV  = path..[=[bar\gradientBar]=],
    GradC  = path..[=[bar\gradientCBar]=],
    GradCR = path..[=[bar\gradientCRBar]=],
    GradH  = path..[=[bar\gradientHBar]=],
}
Media.Button = {
    Gloss   = path..[=[button\gloss]=],
    Flash   = path..[=[button\flash]=],
    Hover   = path..[=[button\hover]=],
    Pushed  = path..[=[button\pushed]=],
    Checked = path..[=[button\checked]=],
    Grey    = path..[=[button\gloss_grey]=],
    BG      = path..[=[button\button_background]=],
    BGFlat  = path..[=[button\button_background_flat]=],
    Shadow  = path..[=[button\outer_shadow]=],
}

if LibStub then
    local lsm = LibStub("LibSharedMedia-3.0")
    lsm:Register("statusbar", "GradientV",  path..[=[bar\gradientBar]=])
    lsm:Register("statusbar", "GradientH",  path..[=[bar\gradientHBar]=])
    lsm:Register("statusbar", "GradientD",  path..[=[bar\gradientCBar]=])
    lsm:Register("statusbar", "GradientC",  path..[=[bar\gradientCEBar]=])
    lsm:Register("statusbar", "GradientLH", path..[=[bar\gradientLHBar]=])
    
    lsm:Register("texture",   "GradientLH", path..[=[bar\gradientLHBar]=])
    lsm:Register("texture",   "GradientC",  path..[=[bar\gradientCEBar]=])
end

