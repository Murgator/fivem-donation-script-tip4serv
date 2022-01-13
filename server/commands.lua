-- Load QBcore
local QBCore = exports['qb-core']:GetCoreObject()
local msg_err = "This command must be executed by the server console or RCON client"

-- Money
RegisterCommand("giveaccountmoney", function(src, args, raw)
    if src > 0 then
        print(msg_err);
        return false
    elseif #args < 3 then
        print("Usage: giveaccountmoney [Player ID] [Type of money (cash, bank, crypto)] [amount]");
        return false
    end
	
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
    else
        print("Player is offline");
    end	
end, false)

-- Gang
RegisterCommand("setplayergang", function(src, args, raw)
    if src > 0 then
        print(msg_err);
        return false
    elseif #args < 3 then
        print("Usage: setplayergang [Player ID] [Name of a gang] [Grade]");
        return false
    end
	
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetGang(tostring(args[2]), tonumber(args[3]))
    else
        print("Player is offline");
    end	
end, false)

-- Job
RegisterCommand("setplayerjob", function(src, args, raw)
    if src > 0 then
        print(msg_err);
        return false
    elseif #args < 3 then
        print("Usage: setplayerjob [Player ID] [Name of a job] [Grade]");
        return false
    end
	
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetJob(tostring(args[2]), tonumber(args[3]))
    else
        print("Player is offline");
    end	
end, false)

-- Permissions
RegisterCommand("setplayerpermission", function(src, args, raw)
    if src > 0 then
        print(msg_err);
        return false
    elseif #args < 2 then
        print("Usage: setplayerpermission [Player ID] [Permission name]");
        return false
    end
	
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local permission = tostring(args[2]):lower()	
    if Player then
        QBCore.Functions.AddPermission(Player.PlayerData.source, permission)
    else
        print("Player is offline");
    end	
end, false)

RegisterCommand("removeplayerpermission", function(src, args, raw)
    if src > 0 then
        print(msg_err);
        return false
    elseif #args < 1 then
        print("Usage: removeplayerpermission [Player ID]");
        return false
    end
	
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        QBCore.Functions.RemovePermission(Player.PlayerData.source)
    else
        print("Player is offline");
    end	
end, false)