-- Load QBcore
local QBCore = exports['qb-core']:GetCoreObject()

-- Utility functions
if not Tip4serv then
	Tip4serv = {}
	Tip4serv.check_pending_commands = function (server_id,private_key,public_key,timestamp)
		--MAC calculation		
		local MAC = Tip4serv.calculateHMAC(server_id, public_key, private_key, timestamp)
		--Get last infos json file
		local response = LoadResourceFile(GetCurrentResourceName(), "response.json")
		local json_encoded = ""
		if (response) then
			json_encoded = Tip4serv.urlencode(response)
		end
		--Request Tip4serv
		local statusUrl = "https://api.tip4serv.com/payments_api.php?id="..server_id.."&time="..timestamp.."&json="..json_encoded
		PerformHttpRequest(statusUrl, function(statusCode, tip4serv_response, _)
			if (statusCode ~= 200 or tip4serv_response == nil) then
				return
			end
			--Clear old json infos
			SaveResourceFile(GetCurrentResourceName(), "response.json", "")
			--Check for error
			local json_decoded = json.decode(tip4serv_response)
			if (json_decoded[1] == nil) then		
				if string.match(json_decoded, "No pending payments found") then
					--print("^5"..json_decoded.."^7")
					return
				elseif string.match(json_decoded, "Tip4serv") then
					print("^5"..json_decoded.."^7") return
				end
			end			
			--Loop customers
			local new_json = {}
			for k,infos in ipairs(json_decoded) do
				local new_obj = {} local new_cmds = {}
				new_obj["date"] = os.date("%c")
				new_obj["action"] = infos["action"]
				--Check if player is online and get xplayerid (licence)
				Player_id = Tip4serv.checkifPlayerIsOnline(infos)
				licence = infos["xplayerid"]
				if Player_id then
					new_obj["fivem_live_id"] = Player_id
					--Check if player QBCore variable is fully loaded
					if QBCore then
						local qbPlayer = QBCore.Functions.GetPlayer(tonumber(Player_id))						
						if qbPlayer then
							licence = string.gsub(qbPlayer.PlayerData.license, "license:", "")
							new_obj["xplayerid"] = licence
						else
							--Player is connecting but his variables do not yet exist
							Player_id = false
						end
					end	
				end
				--Execute commands for player
				for k,cmd in ipairs(infos["cmds"]) do
					--Do not run this command if the player must be online
					if (Player_id == false and (string.match(cmd["str"], "{") or cmd["state"] == 1)) then
						new_obj["status"] = 14
					else
						if (Player_id and string.match(cmd["str"], "{fivem_live_id}")) then
							cmd["str"] = string.gsub(cmd["str"], "{fivem_live_id}", Player_id)
						end
						if (licence and string.match(cmd["str"], "{fivem_xplayer_id}")) then
							cmd["str"] = string.gsub(cmd["str"], "{fivem_xplayer_id}", licence)
						end
						Tip4serv.exe_command(cmd["str"])						
						new_cmds[tostring(cmd["id"])] = 3
					end
				end
				new_obj["cmds"] = new_cmds
				if new_obj["status"] == nil then new_obj["status"] = 3 end
		        new_json[infos["id"]] = new_obj
			end
			--Save the new json file
			SaveResourceFile(GetCurrentResourceName(), "response.json", json.encode(new_json, {indent = true}))
		end, 'GET', '', { ['Authorization'] = MAC })
	end	
	local char_to_hex = function(c)
	  return string.format("%%%02X", string.byte(c))
	end	
	Tip4serv.getHexSteamId = function ( steamId )
		return string.format("%x", steamId)
	end
	Tip4serv.checkifPlayerIsOnline = function ( infos )
		local steamHash = "no"
		if infos["steamid"] ~= "" then
			steamHash = Tip4serv.getHexSteamId(infos["steamid"])
		end
		for _, playerId in ipairs(GetPlayers()) do
			for k,v in pairs(GetPlayerIdentifiers(playerId))do
				if (v == "licence:" .. infos["xplayerid"]) or (infos["auth"] == "steamid" and v == "steam:" .. steamHash) or (infos["auth"] == "discordid" and v == "discord:" .. infos["discordid"]) then
					return playerId
				end
			end
		end
		return false
	end
	Tip4serv.base64_encode = function ( data )
		local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
		return ((data:gsub('.', function(x) 
			local r,b='',x:byte()
			for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
			return r;
		end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
			if (#x < 6) then return '' end
			local c=0
			for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
			return b:sub(c+1,c+1)
		end)..({ '', '==', '=' })[#data%3+1])
	end
	Tip4serv.calculateHMAC = function (server_id, public_key, private_key, timestamp)
		local datas = server_id..public_key..timestamp
		return Tip4serv.base64_encode(sha256.hmac_sha256(private_key, datas))
	end
	Tip4serv.urlencode = function(url)
	  if url == nil then
		return
	  end
	  url = url:gsub("\n", "\r\n")
	  url = url:gsub("([^%w ])", char_to_hex)
	  url = url:gsub(" ", "+")
	  return url
	end
	Tip4serv.exe_command = function(cmd)
		return_code, result = pcall(
			function(segment)
				print("^5[Tip4serv] execute command: "..cmd.."^7")
				local result = ExecuteCommand(cmd)
				return result
			end,
		segment)
		if return_code then return result
		else return false
		end
	end	
end

-- Asynchronously checks if a purchase has been made (every minute)
Citizen.CreateThread(function()
	while true do
		key_arr = {} i = 0
		for info in string.gmatch(Config.key, '([^.]+)') do key_arr[i] = info i = i+1 end
		if (i ~= 3) then
			print("^1[Tip4serv error] Please set Config.key to a valid key in tip4serv/config.lua then restart tip4serv resource. Make sure you have copied the entire key on Tip4serv.com (CTRL+A then CTRL+C)^7")
			CancelEvent() return
		end
		Tip4serv.check_pending_commands(key_arr[0], key_arr[1], key_arr[2], os.time(os.date("!*t")))
		Citizen.Wait(30000)
	end
end)
