local addon, namespace = ...
local Moe = _G["Moe"]
local MoeEmote = Moe.Modules:Get("Emote")

local path = "Interface\\Addons\\Moe_Emote_AC\\"
local ACPack = {
	name = "AC娘",
	size = 54,
	emo = {
	["{天使}"] =	path .. [=[icon\Angel]=],
	["{生气}"] =	path .. [=[icon\Angry]=],
	["{大笑}"] =	path .. [=[icon\Biglaugh]=],
	["{鼓掌}"] =	path .. [=[icon\Clap]=],
	["{酷}"] =		path .. [=[icon\Cool]=],
	["{哭}"] =		path .. [=[icon\Cry]=],
	["{可爱}"] =	path .. [=[icon\Cutie]=],
	["{鄙视}"] =	path .. [=[icon\Despise]=],
	["{美梦}"] =	path .. [=[icon\Dreamsmile]=],
	["{尴尬}"] =	path .. [=[icon\Embarrass]=],  
	--10
	["{邪恶}"] =	path .. [=[icon\Evil]=],
	["{兴奋}"] =	path .. [=[icon\Excited]=],
	["{晕}"] =		path .. [=[icon\Faint]=],
	["{打架}"] =	path .. [=[icon\Fight]=],
	["{流感}"] =	path .. [=[icon\Flu]=],
	["{呆}"] =		path .. [=[icon\Freeze]=],
	["{皱眉}"] =	path .. [=[icon\Frown]=],
	["{致敬}"] =	path .. [=[icon\Greet]=],
	["{鬼脸}"] =	path .. [=[icon\Grimace]=],
	["{龇牙}"] =	path .. [=[icon\Growl]=],
	--20
	["{开心}"] =	path .. [=[icon\Happy]=],
	["{心}"] =		path .. [=[icon\Heart]=],
	["{恐惧}"] =	path .. [=[icon\Horror]=],
	["{生病}"] =	path .. [=[icon\Ill]=],
	["{无辜}"] =	path .. [=[icon\Innocent]=],
	["{功夫}"] =	path .. [=[icon\Kongfu]=],
	["{花痴}"] =	path .. [=[icon\Love]=],
	["{邮件}"] =	path .. [=[icon\Mail]=],
	["{化妆}"] =	path .. [=[icon\Makeup]=],
	["{马里奥}"] =	path .. [=[icon\Mario]=],
	--30
	["{沉思}"] =	path .. [=[icon\Meditate]=],
	["{可怜}"] =	path .. [=[icon\Miserable]=],
	["{好}"] =		path .. [=[icon\Okay]=],
	["{漂亮}"] =	path .. [=[icon\Pretty]=],
	["{吐}"] =		path .. [=[icon\Puke]=],
	["{握手}"] =	path .. [=[icon\Shake]=],
	["{喊}"] =		path .. [=[icon\Shout]=],
	["{闭嘴}"] =	path .. [=[icon\Shuuuu]=],
	["{害羞}"] =	path .. [=[icon\Shy]=],
	["{睡觉}"] =	path .. [=[icon\Sleep]=],
	--40
	["{微笑}"] =	path .. [=[icon\Smile]=],
	["{吃惊}"] =	path .. [=[icon\Suprise]=],
	["{失败}"] =	path .. [=[icon\Surrender]=],
	["{流汗}"] =	path .. [=[icon\Sweat]=],
	["{流泪}"] =	path .. [=[icon\Tear]=],
	["{悲剧}"] =	path .. [=[icon\Tears]=],
	["{想}"] =		path .. [=[icon\Think]=],
	["{偷笑}"] =	path .. [=[icon\Titter]=],
	["{猥琐}"] =	path .. [=[icon\Ugly]=],
	["{胜利}"] =	path .. [=[icon\Victory]=],
	--50
	["{雷锋}"] =	path .. [=[icon\Volunteer]=],
	["{委屈}"] =	path .. [=[icon\Wronged]=],
	}
}

MoeEmote:RegisterPack(ACPack)