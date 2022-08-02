if Config.enable_custom_command == true then


    -- Load QBcore framework object (https://github.com/qbcore-framework)
    local QBCore = exports['qb-core']:GetCoreObject()


    -- Create a console command to give money to a player
    -- Usage: giveaccountmoney [Player ID] [Type of money (cash, bank, crypto)] [amount]
    RegisterCommand("giveaccountmoney", function(src, args, raw)

        -- Disallow players from using this command
        if src > 0 then
            print("This command must be executed by the server console or RCON client");
            return false
        end

        -- Create the variables received by the command
        local player_id = tonumber(args[1])
        local money_type = tostring(args[2])
        local amount = tonumber(args[3])

        -- Retrieve the player's data from qb-core framework
        local Player = QBCore.Functions.GetPlayer(player_id)

        -- Give money to player
        if Player then
            Player.Functions.AddMoney(money_type, amount)
        else
            print("Player is offline");
        end
    end, false)


    -- Set player gang
    -- Usage: setplayergang [Player ID] [Name of a gang] [Grade]
    RegisterCommand("setplayergang", function(src, args, raw)

        -- Disallow players from using this command
        if src > 0 then
            print("This command must be executed by the server console or RCON client");
            return false
        end

        -- Create the variables received by the command
        local player_id = tonumber(args[1])
        local gang_name = tostring(args[2])
        local grade_number = tonumber(args[3])

        -- Retrieve the player's data from qb-core framework       
        local Player = QBCore.Functions.GetPlayer(player_id)

        -- Set player gang and grade
        if Player then
            Player.Functions.SetGang(gang_name, grade_number)
        else
            print("Player is offline");
        end	
    end, false)


    -- Set player job
    -- Usage: setplayerjob [Player ID] [Name of a job] [Grade]
    RegisterCommand("setplayerjob", function(src, args, raw)

        -- Disallow players from using this command
        if src > 0 then
            print("This command must be executed by the server console or RCON client");
            return false
        end

        -- Create the variables received by the command
        local player_id = tonumber(args[1])
        local job_name = tostring(args[2])
        local grade_number = tonumber(args[3])

        -- Retrieve the player's data from qb-core framework  	
        local Player = QBCore.Functions.GetPlayer(player_id)

        -- Set player job and grade
        if Player then
            Player.Functions.SetJob(job_name, grade_number)
        else
            print("Player is offline");
        end	
    end, false)


    -- Set player permissions
    -- Usage: setplayerpermission [Player ID] [Permission name]
    RegisterCommand("setplayerpermission", function(src, args, raw)

        -- Disallow players from using this command
        if src > 0 then
            print("This command must be executed by the server console or RCON client");
            return false
        end

        -- Create the variables received by the command
        local player_id = tonumber(args[1])
        local permission_name = tostring(args[2]):lower()

        -- Retrieve the player's data from qb-core framework
        local Player = QBCore.Functions.GetPlayer(player_id)

        -- Set player permission
        if Player then
            QBCore.Functions.AddPermission(Player.PlayerData.source, permission_name)
        else
            print("Player is offline");
        end	
    end, false)


    -- Remove all player permissions
    -- Usage: removeplayerpermission [Player ID]
    RegisterCommand("removeplayerpermission", function(src, args, raw)

        -- Disallow players from using this command
        if src > 0 then
            print("This command must be executed by the server console or RCON client");
            return false
        end

        -- Create variable received by the command
        local player_id = tonumber(args[1])

        -- Retrieve the player's data from qb-core framework	
        local Player = QBCore.Functions.GetPlayer(player_id)

        -- Remove player permission
        if Player then
            QBCore.Functions.RemovePermission(Player.PlayerData.source)
        else
            print("Player is offline");
        end	
    end, false)
    
    -- Give an item to player inventory
    -- Usage: giveinventoryitem [Player ID] [Item name] [Amount]	
    RegisterCommand("giveinventoryitem", function(src, args, raw)

        -- Disallow players from using this command
        if src > 0 then
            print("This command must be executed by the server console or RCON client");
            return false
        end

        -- Create the variables received by the command
        local player_id = tonumber(args[1])
        local item_name = tostring(args[2])
        local amount = tonumber(args[3])

		-- Retrieve the player's data from qb-core framework	
		local Player = QBCore.Functions.GetPlayer(player_id)
		
		-- Check if item exist
		local itemData = QBCore.Shared.Items[item_name:lower()]
		
		if itemData["name"] then		
			-- Give item to the player
			if Player then
				local info = {}
				Player.Functions.AddItem(itemData["name"], amount, false, info)
			else
				print("Player is offline");
			end	
		else
			print("This item does not exist");
		end
    end, false)    

end

-- Display an announce on server chat
-- Usage: t4s_announce [prefix] [text]
RegisterCommand("t4s_announce", function(src, args, raw)
    if src > 0 then
        print("This command must be executed by the server console or RCON client");
        return false
    elseif #args < 2 then
        print("Usage: t4s_announce [prefix] [text]");
        return false
    end
    local title = args[1]
    args[1] = ""
    local words = table.concat(args, " ")
    TriggerClientEvent('chatMessage', -1, "\n"..title, {255, 0, 0}, words.." \n ")  
    print("^5[t4s_announce] "..title..words.."^7");
end, false)
