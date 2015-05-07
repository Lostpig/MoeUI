local addon, namespace = ...
local Moe = _G["Moe"]
local MoeEmote = Moe.Modules:Get("Emote")

local YoumuPack = {
	name = "Youmu",
	size = 45,
	emo = {
	["{天使}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Angel]=],
	["{生气}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Angry]=],
	["{大笑}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Biglaugh]=],
	["{鼓掌}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Clap]=],
	["{酷}"] =		[=[Interface\Addons\Moe_Emote_Youmu\icon\Cool]=],
	["{哭}"] =		[=[Interface\Addons\Moe_Emote_Youmu\icon\Cry]=],
	["{可爱}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Cutie]=],
	["{鄙视}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Despise]=],
	["{美梦}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Dreamsmile]=],
	["{尴尬}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Embarrass]=],  
	--10
	["{邪恶}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Evil]=],
	["{兴奋}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Excited]=],
	["{晕}"] =		[=[Interface\Addons\Moe_Emote_Youmu\icon\Faint]=],
	["{打架}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Fight]=],
	["{流感}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Flu]=],
	["{呆}"] =		[=[Interface\Addons\Moe_Emote_Youmu\icon\Freeze]=],
	["{皱眉}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Frown]=],
	["{致敬}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Greet]=],
	["{鬼脸}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Grimace]=],
	["{龇牙}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Growl]=],
	--20
	["{开心}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Happy]=],
	["{心}"] =		[=[Interface\Addons\Moe_Emote_Youmu\icon\Heart]=],
	["{恐惧}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Horror]=],
	["{生病}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Ill]=],
	["{无辜}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Innocent]=],
	["{功夫}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Kongfu]=],
	["{花痴}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Love]=],
	["{邮件}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Mail]=],
	["{化妆}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Makeup]=],
	["{马里奥}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Mario]=],
	--30
	["{沉思}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Meditate]=],
	["{可怜}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Miserable]=],
	["{好}"] =		[=[Interface\Addons\Moe_Emote_Youmu\icon\Okay]=],
	["{漂亮}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Pretty]=],
	["{吐}"] =		[=[Interface\Addons\Moe_Emote_Youmu\icon\Puke]=],
	["{握手}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Shake]=],
	["{喊}"] =		[=[Interface\Addons\Moe_Emote_Youmu\icon\Shout]=],
	["{闭嘴}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Shuuuu]=],
	["{害羞}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Shy]=],
	["{睡觉}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Sleep]=],
	--40
	["{微笑}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Smile]=],
	["{吃惊}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Suprise]=],
	["{失败}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Surrender]=],
	["{流汗}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Sweat]=],
	["{流泪}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Tear]=],
	["{悲剧}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Tears]=],
	["{想}"] =		[=[Interface\Addons\Moe_Emote_Youmu\icon\Think]=],
	["{偷笑}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Titter]=],
	["{猥琐}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Ugly]=],
	["{胜利}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Victory]=],
	--50
	["{雷锋}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Volunteer]=],
	["{委屈}"] =	[=[Interface\Addons\Moe_Emote_Youmu\icon\Wronged]=],
	}
}

MoeEmote:RegisterPack(YoumuPack)