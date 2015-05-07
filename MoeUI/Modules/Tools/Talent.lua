local CACHE_SIZE = 20
local cache = {}

local COLOR_TANK = "E06D1B";
local COLOR_HEAL = "1B70E0";
local COLOR_DPS  = "E01B35";
local COLOR_NONE = "B5B5B5";
local localrole = {
	["DAMAGER"] = "|cFF" .. COLOR_DPS .. "伤害输出|r",
	["TANK"] = "|cFF" .. COLOR_TANK .. "坦克|r",
	["HEALER"] = "|cFF" .. COLOR_HEAL .. "治疗者|r",
	[0] = "|cFF" .. COLOR_NONE .. "无|r"
}



local InspectFrame = CreateFrame("Frame")

local function InspectEvent(self,event,guid)
	local name, unit = GameTooltip:GetUnit()
	if not unit then
		self:UnregisterEvent("INSPECT_READY")
		self:SetScript("OnEvent",nil)
		return 
	end
	local unitguid = UnitGUID(unit)
	if guid == unitguid then
		local specid = GetInspectSpecialization(unit)
		if specid >= 0 and specid <= 999 then
			local cacheid = {
				g = guid,
				s = specid,
				writetime = GetTime()
			}
			--print("对比成功")
			tinsert(cache,cacheid)
		end
	end
	if #cache > CACHE_SIZE then
		tremove(cache,1);
	end
	self:UnregisterEvent("INSPECT_READY")
	self:SetScript("OnEvent",nil)
end

local function toInspect(unit)
	NotifyInspect(unit)
	InspectFrame:RegisterEvent("INSPECT_READY")
	InspectFrame:SetScript("OnEvent",InspectEvent)
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self, ...)
   local name, unit = GameTooltip:GetUnit();
   if (unit and unit == "player") then
		local activetalent = GetSpecialization()
		if not activetalent then 
			self:AddLine(format("专精:|cFFFFFFFF%s|r[%s]","无",localrole[0])) 
			return
		end
		local name = select(2, GetSpecializationInfo(activetalent))
		local role = localrole[GetSpecializationRole(activetalent)]
		self:AddLine(format("专精:|cFFFFFFFF%s|r[%s]",name,role))
   elseif(unit and UnitIsPlayer(unit)) then
         ug = UnitGUID(unit)
		 local isfind = false
		 for i = 1,#cache do
			if cache[i].g == ug then
				--print("读入成功")
				if  cache[i].s ~= 0 then
					local name = select(2,GetSpecializationInfoByID(cache[i].s))
					local role = localrole[GetSpecializationRoleByID(cache[i].s)]
					self:AddLine(format("专精:|cFFFFFFFF%s|r[%s]",name,role))
				else
					self:AddLine(format("专精:|cFFFFFFFF%s|r[%s]","无",localrole[0]))
				end
				isfind = true 
			end
		end
		if not isfind then
			toInspect(unit)
			self:AddLine(format("专精:读取中"))
		end
   end
end)

SLASH_SPECTEST1 = "/tw"
SlashCmdList["SPECTEST"] = function(msg)
	if msg == "clear" then
		for i = 1,CACHE_SIZE do
			tremove(cache,1);
		end
		print("观察天赋列表已清空。")
	elseif msg == "list" then
		print("已存天赋表:")
		for i = 1,#cache do
			print(i..":"..cache[i].s.."||"..cache[i].g.."||"..cache[i].writetime.."||")
		end
	else
		print("MOP天赋观察测试版。")
		print("/tw clear 清空列表")
	end
end