-- Tip4serv plugin 1.6.0

-- JSON data files
local response_path = "data/response.json"
local active_players_path = "data/active_players.json"
-- Utility functions
if not Tip4serv then
	Tip4serv = {}
	Tip4serv.check_pending_commands = function (server_id,private_key,public_key,timestamp,get_cmd)
		--MAC calculation		
		local MAC = Tip4serv.calculateHMAC(server_id, public_key, private_key, timestamp)
		--Get last infos json file
		local response = LoadResourceFile(GetCurrentResourceName(), response_path)
		local json_encoded = ""
		if (response) then
			json_encoded = Tip4serv.urlencode(response)
		end
		--Request Tip4serv
		local statusUrl = "https://api.tip4serv.com/payments_api_v2.php?id="..server_id.."&time="..timestamp.."&json="..json_encoded.."&get_cmd="..get_cmd
		PerformHttpRequest(statusUrl, function(statusCode, tip4serv_response, _)
			if (statusCode ~= 200 or tip4serv_response == nil) then
				if (get_cmd == "no") then
					print("^5Tip4serv API is temporarily unavailable, maybe you are making too many requests. Please try again later^7") return	
				end
				return
			end
			local json_decoded = json.decode(tip4serv_response)			
			--Tip4serv connect
			if (get_cmd == "no") then
				print("^5"..json_decoded.."^7") return
			end	
			--Check for error
			if (json_decoded[1] == nil) then
				if string.match(json_decoded, "No pending payments found") then
					SaveResourceFile(GetCurrentResourceName(), response_path, "")
					--print("^5"..json_decoded.."^7")
					return
				elseif string.match(json_decoded, "Tip4serv") then
					print("^5"..json_decoded.."^7") return
				end	
			end
			--Clear old json infos
			SaveResourceFile(GetCurrentResourceName(), response_path, "")
			--Get active players list
			local active_players = json.decode(LoadResourceFile(GetCurrentResourceName(), active_players_path))	
			--Loop customers
			local new_json = {}
			for k,infos in ipairs(json_decoded) do
				local new_obj = {} local new_cmds = {}
				new_obj["date"] = os.date("%c")
				new_obj["action"] = infos["action"]
				--Check if player is online and loaded and get licence
				player_infos = Tip4serv.checkifPlayerIsLoaded(infos,active_players)
				licence = infos["xplayerid"]
				if player_infos then
					new_obj["fivem_live_id"] = player_infos["playerId"]
					new_obj["xplayerid"] = player_infos["licence"]
					TriggerClientEvent("tip4serv:showSubtitle", player_infos["playerId"], Config.order_received_text, 10000)
				end
				--Execute commands for player
				if type(infos["cmds"]) == "table" then
					for k,cmd in ipairs(infos["cmds"]) do
						--Do not run this command if the player must be online
						if (player_infos == false and (string.match(cmd["str"], "{") or cmd["state"] == 1)) then
							new_obj["status"] = 14
						else
							if (player_infos and player_infos["playerId"] and string.match(cmd["str"], "{fivem_live_id}")) then
								cmd["str"] = string.gsub(cmd["str"], "{fivem_live_id}", player_infos["playerId"])
							end
							if (licence and string.match(cmd["str"], "{fivem_licence}")) then
								cmd["str"] = string.gsub(cmd["str"], "{fivem_licence}", licence)
							end
							Tip4serv.exe_command(cmd["str"])
							Citizen.Wait(Config.time_between_each_command)
							new_cmds[tostring(cmd["id"])] = 3
						end
					end
					new_obj["cmds"] = new_cmds
					if new_obj["status"] == nil then new_obj["status"] = 3 end
					new_json[infos["id"]] = new_obj
				end
			end
			--Save the new json file
			SaveResourceFile(GetCurrentResourceName(), response_path, json.encode(new_json, {indent = true}))
		end, 'GET', '', { ['Authorization'] = MAC })
	end	
	local char_to_hex = function(c)
	  return string.format("%%%02X", string.byte(c))
	end	
	Tip4serv.getHexSteamId = function ( steamId )
		return string.format("%x", steamId)
	end
	Tip4serv.checkifPlayerIsLoaded = function ( infos, active_players )
		local steamHash = "no"
		if infos["steamid"] ~= "" then
			steamHash = Tip4serv.getHexSteamId(infos["steamid"])
		end	
		for _, playerId in ipairs(active_players) do		
		    local identifiers = GetPlayerIdentifiers(playerId)
			local player_infos = {}
			for k,v in pairs(identifiers) do		
				if (v == "licence:" .. infos["xplayerid"]) or (infos["auth"] == "steamid" and v == "steam:" .. steamHash) or (infos["auth"] == "discordid" and v == "discord:" .. infos["discordid"]) then
					--get licence here
					player_infos["playerId"] = playerId
					for _, v in pairs(identifiers) do
						if (string.match(v, "licence:") or string.match(v, "license:")) then
							local licence = Tip4serv.split(v, ":")
							player_infos["licence"] = licence[2]								
							break
						end	
					end			
					return player_infos
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
	Tip4serv.split =  function(inputstr, sep)
		if sep == nil then
			sep = "%s"
		end
		local t={}
		for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
		end
		return t
	end
end

local missing_key = "^5[Tip4serv error] Please set Config.key to a valid key in tip4serv/config.lua then restart tip4serv resource. Make sure you have copied the entire key on Tip4serv.com (CTRL+A then CTRL+C)^7"

-- Asynchronously checks if a purchase has been made (every 30 seconds)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.request_interval_in_minutes*60*1000)	
		key_arr = {} i = 0
		for info in string.gmatch(Config.key, '([^.]+)') do key_arr[i] = info i = i+1 end
		if (i ~= 3) then
			print(missing_key)
			CancelEvent() return
		end
		Tip4serv.check_pending_commands(key_arr[0], key_arr[1], key_arr[2], os.time(os.date("!*t")),"yes")
	end
end)

-- Check Tip4serv connection on script start
AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end
	SaveResourceFile(GetCurrentResourceName(), active_players_path, json.encode({}, {indent = true}))
	key_arr = {} i = 0
	for info in string.gmatch(Config.key, '([^.]+)') do key_arr[i] = info i = i+1 end
	if (i ~= 3) then
		print(missing_key)
		return false
	end
	Tip4serv.check_pending_commands(key_arr[0], key_arr[1], key_arr[2], os.time(os.date("!*t")),"no")
end)

-- Add player in active list when his data and client scripts is completely loaded
RegisterNetEvent('tip4serv:onPlayerLoaded')
AddEventHandler('tip4serv:onPlayerLoaded', function(currentPos,prevPos)
	if (GetPlayerPing(source) ~= 0) then
		local active_players = json.decode(LoadResourceFile(GetCurrentResourceName(), active_players_path))
		for i = 1, #active_players do
			if (active_players[i] == source) then
				table.remove( active_players, i )
			end
		end
		table.insert(active_players, tonumber(source))
		SaveResourceFile(GetCurrentResourceName(), active_players_path, json.encode(active_players, {indent = true}))
	end
end)

-- Remove player from active list when player leave the server
AddEventHandler('playerDropped', function ()
	local active_players = json.decode(LoadResourceFile(GetCurrentResourceName(), active_players_path))
	for i = 1, #active_players do
		if (active_players[i] == source) then
			table.remove( active_players, i )
		end
	end	
	SaveResourceFile(GetCurrentResourceName(), active_players_path, json.encode(active_players, {indent = true}))	
end)

-- Check command: check if a purchase has been made and give order to player
local error_cmd = "^5[Tip4serv error] This command must be executed in the server chat^7"
RegisterCommand(Config.check_cmd_name, function(src, args, raw)
	if src > 0 then
		local active_players = json.decode(LoadResourceFile(GetCurrentResourceName(), active_players_path))
		for i = 1, #active_players do
			if (active_players[i] == src) then
				table.remove( active_players, i )
			end
		end
		table.insert(active_players, tonumber(src))
		SaveResourceFile(GetCurrentResourceName(), active_players_path, json.encode(active_players, {indent = true}))
		TriggerClientEvent("tip4serv:showSubtitle", tonumber(src), Config.order_waiting_text, 5000)
	else
		print(error_cmd)
		return
	end
end, false)
