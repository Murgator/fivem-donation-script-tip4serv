RegisterNetEvent("tip4serv:showSubtitle")
AddEventHandler("tip4serv:showSubtitle", function(text, time)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
	EndTextCommandPrint(time, true)
end)

Citizen.CreateThread(function()
	Citizen.Wait(30000)
	if NetworkIsPlayerActive(PlayerId()) then	
		while true do
			Citizen.Wait(1000)
			playerPed = GetPlayerPed(-1)
			if playerPed then
				currentPos = GetEntityCoords(playerPed, true)
				if (currentPos ~= prevPos) and (currentPos ~= nil and prevPos ~= nil) then
					TriggerServerEvent('tip4serv:onPlayerLoaded',currentPos,prevPos)
					CancelEvent() return
				end
				prevPos = currentPos
			end
		end
	end
end)
