RegisterServerEvent('houserobberies:enter')
AddEventHandler('houserobberies:enter', function(robnum, ismansion, flashbang)
TriggerClientEvent('houserobberies:createhouse', source, robnum, false, flashbang)
Citizen.Wait(10)
TriggerClientEvent('houserobberies:enterhouse', source, robnum, flashbang)
end)

RegisterServerEvent('houserobberies:exit')
AddEventHandler('houserobberies:exit', function(houseid, ismansion2, backdoor)
TriggerClientEvent('houserobberies:delete', source, houseid, backdoor)
end)