URPCore = nil
TriggerEvent('urp:getSharedObject', function(obj) URPCore = obj end)

RegisterNetEvent('FinishMoneyCheckForVeh69')
RegisterNetEvent('vehshop:spawnVehicle69')
local vehshop_blips = {}
local financedPlates = {}
local inrangeofvehshop = false
local currentlocation = nil
local boughtcar = false
local vehicle_price = 0
local backlock = false
local firstspawn = 0
local commissionbuy = 0
local insideVehShop = false


local carSafeSpawn = { ['x'] = 935.61, ['y'] = -990.8, ['z'] = 38.0, ['h'] = 252.4, ['info'] = ' Test Drive Spawn' }

local carBrowserLocation = { ['x'] = 920.73, ['y'] = -949.92,['z'] = 39.23, ['h'] = 119.9, ['info'] = ' Car Browser Location' }


function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
local currentCarSpawnLocation = 0
local ownerMenu = false

local vehshopDefault = {
	opened = false,
	title = "Tuner Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {
				{name = "Job Vehicles", description = ''},
			}
		},		
	}
}

vehshop = vehshopDefault
local vehshopOwner = {
	opened = false,
	title = "Tuner Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,

		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
			}
		},

		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {
				{name = "Sports", description = ''},
				{name = "Drift", description = ''},
				{name = "Sold/Reserved", description = ''},
			}
		},

		["sports"] = {
			title = "sports",
			name = "sports",
			buttons = {
				
				{model = "gt2rwb", name = "Porsche 911 GT2 993 RWB", costs = 320000, description = {} },
				{model = "revolution6str2", name = "6STR Revolution SR", costs = 390000, description = {} }, 
				{model = "zx10", name = "Kawasaki Ninja ZX10R", costs = 250000, description = {} }, 
				{model = "banshee2", name = "Banshee 900R", costs = 287500, description = {} }, 
				{model = "elegy", name = "Elegy Retro", costs = 287500, description = {} }, 
				{model = "sultanrs", name = "Sultan RS", costs = 287500, description = {} },
				{model = "dc5", name = "Honda Integra Type R", costs = 250000, description = {} },
				{model = "eclipse", name = "Mitsubishi Eclipse GSX", costs = 287500, description = {} },
				{model = "primoard", name = "Primo ARD", costs = 287500, description = {} },
				
			}
		},

		["drift"] = {
			title = "drift",
			name = "drift",
			buttons = {
				{model = "sentinel6str", name = "6STR Sentinel", costs = 200000, description = {} }, 
				{model = "flashgt", name = "Flash GT", costs = 200000, description = {} },
			}
		},

		["sold/reserved"] = {
			title = "sold/reserved",
			name = "sold/reserved",
			buttons = {

				-- Reserved/Custom 3D

				{model = "filthynsx", name = "Acura NSX LW", costs = 390000, description = {} },
				{model = "bdragon", name = "Bentley CGT Dragon", costs = 390000, description = {} },
				{model = "por930", name = "Porsche 911 930", costs = 390000, description = {} },
				{model = "gtrc", name = "Mercedes AMG GTR", costs = 390000, description = {} },
				{model = "e36prb", name = "BMW M3 E36", costs = 390000, description = {} },
				{model = "cp9a", name = "Mitsubishi Lancer Evolution VI GSR TME", costs = 390000, description = {} },
				{model = "hellion6str", name = "Hellion V2", costs = 320000, description = {} },
				{model = "na1", name = "Honda NSX NA1", costs = 390000, description = {} },
				{model = "gtr", name = "Nissan GTR R35", costs = 390000, description = {} },
				{model = "raid", name = "Dodge Challenger Raid", costs = 320000, description = {} },
				{model = "z32", name = "Nissan 300ZX Z32", costs = 390000, description = {} },
				{model = "500gtrlam", name = "Diablo GTR", costs = 320000, description = {} },
				{model = "lwlp670", name = "Lamborghini Murcielago LW LP670", costs = 390000, description = {} },
				{model = "granlb", name = "Maserati Gran Turismo LW", costs = 390000, description = {} },
				{model = "300zw", name = "Nissan 300ZW", costs = 390000, description = {} },
				{model = "bluecunt", name = "Holden HSV", costs = 325000, description = {} },
				{model = "mbw124", name = "Mercedes W124 300D", costs = 325000, description = {} },
				{model = "hoabrawler", name = "HOA Brawler", costs = 70000, description = {} },
				{model = "vuwashington", name = "VIP Washington", costs = 30000, description = {} },
				{model = "vustretch", name = "VIP Stretch", costs = 45000, description = {} },
				{model = "rumpo2", name = "HerrKutz Rumpo", costs = 12500, description = {} },
				{model = "tessaoracle", name = "ROW Driving School Oracle", costs = 25000, description = {} },
				{model = "payneschaf", name = "PRE Schafter", costs = 60000, description = {} },
				{model = "dabneon", name = "DC Neon", costs = 230000, description = {} },
				{model = "mwgranger", name = "Security Granger", costs = 60000, description = {} },
				{model = "m3e46", name = "BMW M3 GTR", costs = 390000, description = {} },
				{model = "esv", name = "Cadillac Escalade", costs = 325000, description = {} },
				{model = "wraith", name = "Rolls Royce Wraith", costs = 425000, description = {} },
				{model = "monroec", name = "Monroe Custom", costs = 200000, description = {} },
				
				-- 6STR Tuner Cars

				{model = "hustler6str", name = "6STR Hustler", costs = 130000, description = {} }, 
				{model = "zr3806str", name = "6STR ZR380", costs = 390000, description = {} }, 
				{model = "ellie6str", name = "6STR Ellie", costs = 390000, description = {} }, 
				{model = "gauntlet6str", name = "6STR Gauntlet", costs = 390000, description = {} }, 
				{model = "ladybird6str", name = "6STR Ladybird", costs = 390000, description = {} }, 
				{model = "ruiner6str", name = "6STR Ruiner", costs = 390000, description = {} }, 
				{model = "schwarzer2", name = "6STR Schwartzer", costs = 390000, description = {} }, 
				{model = "sentinel6str2", name = "6STR Sentinel Classic", costs = 290000, description = {} }, 
				{model = "tempesta2", name = "6STR Tempesta", costs = 390000, description = {} }, 

                -- Pack 1

				{model = "golfp", name = "VW Pandem Golf R", costs = 200000, description = {} }, 
				{model = "c63", name = "Mercedes C63 AMG", costs = 287500, description = {} },
				{model = "m4", name = "BMW LW M4", costs = 287500, description = {} }, 
				{model = "rcf", name = "Lexus RCF", costs = 325000, description = {} }, 
				{model = "rudiharley", name = "Harley Fatboy", costs = 250000, description = {} }, 
				{model = "sanctus", name = "Sanctus", costs = 200000, description = {} },
				{model = "deathbike", name = "Deathbike", costs = 250000, description = {} },
				{model = "shotaro", name = "Shotaro", costs = 250000, description = {} }, 
				{model = "deviant", name = "Deviant", costs = 350000, description = {} },
				{model = "stafford", name = "Stafford", costs = 325000, description = {} },
				{model = "toros", name = "Toros", costs = 425000, description = {} },

                -- Pack 2

				{model = "m5e60", name = "BMW E60 M5", costs = 325000, description = {} },
				{model = "r35", name = "Nissan GTR R35", costs = 325000, description = {} },

				-- Drift Cars

				{model = "pigalle6str", name = "6STR Pigalle", costs = 175000, description = {} }, 
				{model = "sultanrsv8", name = "Sultan RS MK2", costs = 250000, description = {} },
				{model = "evo9", name = "Mitsubishi Lancer Evolution IX MR FQ-360", costs = 250000, description = {} },
				{model = "stratumc", name = "Zircoflow Stratum", costs = 250000, description = {} },
				{model = "m235", name = "BMW M235", costs = 250000, description = {} },
				{model = "nis13", name = "Nissan Silvia S13", costs = 200000, description = {} },
				{model = "futo2", name = "6STR Futo", costs = 200000, description = {} }, 
				{model = "tampa5", name = "6STR Drift Tampa V2", costs = 250000, description = {} },
				{model = "fc3s", name = "Mazda RX7 FC", costs = 200000, description = {} },
				{model = "er34", name = "Nissan Skyline ER34", costs = 250000, description = {} },
				{model = "z190custom", name = "Z190D", costs = 200000, description = {}},

			}
		}
	}
}

local fakecar = {model = '', car = nil}
local vehshop_locations = {
	{
		entering = { 920.73, -949.92, 39.23, 119.9 },
		inside = {944.54, -978.62, 39.51, 187.47}, 
		outside = {944.54, -978.62, 39.51, 187.47},
		browsing = { 911.38, -967.77, 39.51, 265.04},
	}
}

local carspawns = {
	[1] =  { ['x'] = 954.1,['y'] = -954.0,['z'] = 39.51,['h'] = 95.0, ['info'] = ' car1' },
	[2] =  { ['x'] = 954.1,['y'] = -951.0,['z'] = 39.51,['h'] = 95.0, ['info'] = ' car2' },
	[3] =  { ['x'] = 954.1,['y'] = -948.0,['z'] = 39.51,['h'] = 95.0, ['info'] = ' car3' },
	[4] =  { ['x'] = 953.1,['y'] = -945.0,['z'] = 39.51,['h'] = 95.0, ['info'] = ' car4' },
	[5] =  { ['x'] = 949.87,['y'] = -940.38,['z'] = 39.51,['h'] = 171.34, ['info'] = ' car5' },
	[6] =  { ['x'] = 946.03,['y'] = -940.72,['z'] = 39.51,['h'] = 184.55, ['info'] = ' car6' },
	[7] =  { ['x'] = 942.07,['y'] = -942.46,['z'] = 39.51,['h'] = 211.21, ['info'] = ' car7' },
}

local carTable = {
	[1] = { ["name"] = "Kawasaki Ninja ZX10R", ["model"] = "zx10", ["baseprice"] = 250000, ["commission"] = 25 }, 
	[2] = { ["name"] = "BMW LW M4", ["model"] = "m4", ["baseprice"] = 287500, ["commission"] = 25 }, 
	[3] = { ["name"] = "Honda Integra Type R", ["model"] = "dc5", ["baseprice"] = 250000, ["commission"] = 25 }, 
	[4] = { ["name"] = "Dodge Challenger Raid", ["model"] = "raid", ["baseprice"] = 320000, ["commission"] = 25 }, 
	[5] = { ["name"] = "Lamborghini Murcielago LW LP670", ["model"] = "lwlp670", ["baseprice"] = 390000, ["commission"] = 25 }, 
	[6] = { ["name"] = "Porsche 911 GT2 993 RWB", ["model"] = "gt2rwb", ["baseprice"] = 320000, ["commission"] = 25 }, 
	[7] = { ["name"] = "Bentley CGT Dragon", ["model"] = "bdragon", ["baseprice"] = 390000, ["commission"] = 25 }, 
}

function updateCarTable(model,price,name)
	carTable[currentCarSpawnLocation]["model"] = model
	carTable[currentCarSpawnLocation]["baseprice"] = price
	carTable[currentCarSpawnLocation]["name"] = name
	TriggerServerEvent("carshop:table69",carTable)
end

local myspawnedvehs = {}

RegisterNetEvent("car:testdrive")
AddEventHandler("car:testdrive", function()
	local pData = exports["isPed"]:isPed("myJob")
	if pData == "tuner" or #(vector3(carSafeSpawn["x"],carSafeSpawn["y"],carSafeSpawn["z"]) - GetEntityCoords(PlayerPedId())) > 50.0 then
		return
	end	

	local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
	if not DoesEntityExist(veh) then
		TriggerEvent("DoLongHudText","Could not locate vehicle",2)
		return
	end
	
	local model = GetEntityModel(veh)
	local veh = GetClosestVehicle(carSafeSpawn["x"],carSafeSpawn["y"],carSafeSpawn["z"], 3.000, 0, 70)

	if not DoesEntityExist(veh) then

		local modelwait = 1
		RequestModel(model)
		while not HasModelLoaded(model) and modelwait < 100 do
			Citizen.Wait(100)
			modelwait = modelwait + 1
		end
		if modelwait > 100 then
			CloseCreator()
			return
		end

		local veh = CreateVehicle(model,carSafeSpawn["x"],carSafeSpawn["y"],carSafeSpawn["z"],carSafeSpawn["h"],true,false)
		local vehplate = "CAR"..math.random(10000,99999) 
		SetVehicleNumberPlateText(veh, vehplate)
		Citizen.Wait(100)
		TriggerEvent("keys:addNew", veh, vehplate)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityAsMissionEntity(veh,false,true)
		TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
		myspawnedvehs[veh] = true
	else
		TriggerEvent("DoLongHudText","A car is on the spawn point.",2)
	end

end)

RegisterNetEvent("finance")
AddEventHandler("finance", function()
	if #(vector3(carSafeSpawn["x"],carSafeSpawn["y"],carSafeSpawn["z"]) - GetEntityCoords(PlayerPedId())) > 50.0 then
		return
	end	
	local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
	if not DoesEntityExist(veh) then
		TriggerEvent("DoLongHudText","Could not locate vehicle",2)
		return
	end
	local vehplate = GetVehicleNumberPlateText(veh)	
	TriggerServerEvent("finance:enable",vehplate)
end)

RegisterNetEvent("finance:enableOnClient")
AddEventHandler("finance:enableOnClient", function(addplate)
	financedPlates[addplate] = true
	Citizen.Wait(60000)
	financedPlates[addplate] = nil
end)	

RegisterNetEvent("commission")
AddEventHandler("commission", function(newAmount)
	local pData = exports["isPed"]:isPed("myJob")
	if pData == "tuner" or #(vector3(carSafeSpawn["x"],carSafeSpawn["y"],carSafeSpawn["z"]) - GetEntityCoords(PlayerPedId())) > 50.0 then
		return
	end
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			carTable[i]["commission"] = tonumber(newAmount)
			TriggerServerEvent("carshop:table69",carTable)

		end
	end
end)

RegisterNetEvent("veh_shop:returnTable69")
AddEventHandler("veh_shop:returnTable69", function(newTable)

	carTable = newTable
	DespawnSaleVehicles()
	SpawnSaleVehicles()

end)

local hasspawned = false

local spawnedvehicles = {}
local vehicles_spawned = false
function BuyMenu()
	for i = 1, #carspawns do

		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= nil and GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 then
				ClearPedTasksImmediately(PlayerPedId())
			end
			DisableControlAction(0,23)

			if IsControlJustReleased(0,23) or IsDisabledControlJustReleased(0,23) then
				local veh = GetClosestVehicle(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], 3.000, 0, 70)
				local addplate = GetVehicleNumberPlateText(veh)
				if financedPlates[addplate] ~= nil then
					TriggerEvent("DoLongHudText","Attempting Purchase")
					AttemptBuy(i,true)
				end
			end
		end
	end
end

function AttemptBuy(tableid,financed)

	local veh = GetClosestVehicle(carspawns[tableid]["x"],carspawns[tableid]["y"],carspawns[tableid]["z"], 3.000, 0, 70)

	if not DoesEntityExist(veh) then
		TriggerEvent("DoLongHudText","Could not locate vehicle",2)
		return
	end

	local model = carTable[tableid]["model"]
	local commission = carTable[tableid]["commission"]
	local baseprice = carTable[tableid]["baseprice"]
	local name = carTable[tableid]["name"]
	local price = baseprice + (baseprice * commission/100)
	currentlocation = vehshop_blips[1]
	TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
	TriggerServerEvent('CheckMoneyForVeh69',name, model, price, financed)
	commissionbuy = (baseprice * commission / 200)

end


function OwnerMenu()
	if not vehshop.opened then
		currentCarSpawnLocation = 0
		ownerMenu = false
	end
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			ownerMenu = true
			currentCarSpawnLocation = i
			if IsControlJustReleased(0,Controlkey["generalUse"][1]) then
				TriggerEvent("DoLongHudText","We Opened")
				if vehshop.opened then
					CloseCreator()
				else
					OpenCreator()
				end
			end
		end
	end

end

function DrawPrices()
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.5 then
			local commission = carTable[i]["commission"]
			local baseprice = carTable[i]["baseprice"]
			local price = baseprice + (baseprice * commission/100)
			local veh = GetClosestVehicle(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], 3.000, 0, 70)
			local addplate = GetVehicleNumberPlateText(veh)
			local pData = exports["isPed"]:isPed("myJob")
	        if pData == 'tuner' then
				if financedPlates[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " | Com: %" ..commission.. " | ["..Controlkey["generalUse"][2].."] to change | [F] to Finance ")
				else
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " | Com: %" ..commission.. " | ["..Controlkey["generalUse"][2].."] to change ")
				end
			else
				if financedPlates[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price/10) .. " upfront, $" .. math.ceil(price) .. " over 10 weeks, [F] to finance. ")
				end			
			end
		end
	end
end
function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
function SpawnSaleVehicles()
	if not hasspawned then
		TriggerServerEvent("carshop:requesttable69")
		--Citizen.Wait(1500)
	end
	DespawnSaleVehicles(true)
	vehicles_spawned = true
	hasspawned = true
	for i = 1, #carTable do
		local model = GetHashKey(carTable[i]["model"])
		local modelwait = 1

		RequestModel(model)
		while not HasModelLoaded(model) and modelwait < 100 do
			Citizen.Wait(100)
			modelwait = modelwait + 1
		end

		if modelwait > 100 then
			DespawnSaleVehicles()
			TriggerEvent("customNotification","Vehicles failed to load, please be patient",2)
			Wait(10000)
			return
		end

		local veh = CreateVehicle(model,carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]-1,carspawns[i]["h"],false,false)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)
		SetEntityAsMissionEntity(veh,false,true)
		FreezeEntityPosition(veh,true)
		spawnedvehicles[#spawnedvehicles+1] = veh
		for i = 0,24 do
			SetVehicleModKit(veh,0)
			RemoveVehicleMod(veh,i)
		end
		SetVehicleNumberPlateText(veh, i .. "IMPORT")
	end
	
end

function DespawnSaleVehicles(pDontWait)
	if pDontWait == nil and not pDontWait then
		Wait(15000)
	end
	for i = 1, #spawnedvehicles do
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(spawnedvehicles[i]))
	end
	vehicles_spawned = false
end

--[[Functions]]--

function LocalPed()
	return PlayerPedId()
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function IsPlayerInRangeOfVehshop()
	return inrangeofvehshop
end

function ShowVehshopBlips(bool)
	if bool and #vehshop_blips == 0 then
		for station,pos in pairs(vehshop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(946.42, -990.2, 39.21)
			-- 60 58 137
			SetBlipSprite(blip,326)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Tuner Shop')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			SetBlipScale(blip, 0.8)
			SetBlipColour(blip, 3)
			vehshop_blips[#vehshop_blips+1]= {blip = blip, pos = loc}
		end
		Citizen.CreateThread(function()
			while #vehshop_blips > 0 do
				Citizen.Wait(1)
				local inrange = false
				local inrangereturn = false
				if #(vector3(carSafeSpawn["x"],carSafeSpawn["y"],carSafeSpawn["z"]) - GetEntityCoords(LocalPed())) < 5.0 then
					local veh = GetVehiclePedIsUsing(LocalPed())
					if myspawnedvehs[veh] ~= nil then
						DrawText3D(carSafeSpawn["x"],carSafeSpawn["y"],carSafeSpawn["z"],"["..Controlkey["generalUse"][2].."] return vehicle")
						inrangereturn = true
						if IsControlJustReleased(0,Controlkey["generalUse"][1]) then
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
						end
					end
				end

				for i,b in ipairs(vehshop_blips) do

					if insideVehShop then
						currentlocation = b
						if not vehicles_spawned then
							print("spawning?")
							SpawnSaleVehicles()
						end
						if #(vector3(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]) - GetEntityCoords(LocalPed())) < 35 then
							DrawPrices()
						end
						DrawMarker(27,b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,50,0,0,0,0)
						if vehshop.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and #(vector3(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]) - GetEntityCoords(LocalPed())) < 1 then		
							inrange = true
						end
						if vehshop.opened == true then
							DisplayHelpText('~g~E~s~ or ~g~Enter~s~ Accepts ~g~Arrows~s~ Move ~g~Backspace~s~ Exit')
						end
						local pData = exports["isPed"]:isPed("myJob")
						if pData == "tuner" then
							OwnerMenu()
						end
						BuyMenu()				
					else
						if vehicles_spawned then
							DespawnSaleVehicles()
						end
						if not inrangereturn then
							Citizen.Wait(1000)
						end
					end
				end
				inrangeofvehshop = inrange
			end
		end)
	elseif bool == false and #vehshop_blips > 0 then
		for i,b in ipairs(vehshop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		vehshop_blips = {}
	end
end

function f(n)
	return n + 0.0001
end

function try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function OpenCreator()
	boughtcar = false
	
	if ownerMenu then
		vehshop = vehshopOwner	
	else
		return
	end

	local ped = LocalPed()
	local pos = carBrowserLocation
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,carBrowserLocation.x,carBrowserLocation.y,carBrowserLocation.z,Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,carBrowserLocation.x,carBrowserLocation.y,g)
	SetEntityHeading(ped,carBrowserLocation.h)

	vehshop.currentmenu = "main"
	vehshop.opened = true
	vehshop.selectedbutton = 0
end

function CloseCreator(name, veh, price, financed)
	Citizen.CreateThread(function()
		local ped = LocalPed()
		local pPrice = price
		if not boughtcar then
			local pos = currentlocation.pos.browsing
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
		else			
			local name = name	
			local vehicle = veh
			local price = price		
			local veh = GetVehiclePedIsUsing(ped)
			local model = GetEntityModel(veh)
			local colors = table.pack(GetVehicleColours(veh))
			local extra_colors = table.pack(GetVehicleExtraColours(veh))

			local mods = {}
			for i = 0,24 do
				mods[i] = GetVehicleMod(veh,i)
			end
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
			local pos = currentlocation.pos.outside

			FreezeEntityPosition(ped,false)

			local modelwait = 1
			RequestModel(model)
			while not HasModelLoaded(model) and modelwait < 100 do
				Citizen.Wait(100)
				modelwait = modelwait + 1
			end
			if modelwait > 100 then
				CloseCreator()
				return
			end

			personalvehicle = CreateVehicle(model,pos[1],pos[2],pos[3],pos[4],true,false)
			SetModelAsNoLongerNeeded(model)

			for i,mod in pairs(mods) do
				SetVehicleModKit(personalvehicle,0)
				SetVehicleMod(personalvehicle,i,mod)
			end

			SetVehicleOnGroundProperly(personalvehicle)

			local plate = GetVehicleNumberPlateText(personalvehicle)
			TriggerServerEvent('garage:addKeys', plate)

			SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
			local id = NetworkGetNetworkIdFromEntity(personalvehicle)
			SetNetworkIdCanMigrate(id, true)
			Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
			SetVehicleColours(personalvehicle,colors[1],colors[2])
			SetVehicleExtraColours(personalvehicle,extra_colors[1],extra_colors[2])
			TaskWarpPedIntoVehicle(PlayerPedId(),personalvehicle,-1)
			SetEntityVisible(ped,true)
			local vehProps = URPCore.Game.GetVehicleProperties(personalvehicle)
			TriggerServerEvent('BuyForVeh69', vehProps, name, vehicle, pPrice, financed)
			TriggerServerEvent("garages:CheckGarageForVeh")
			DespawnSaleVehicles()
			SpawnSaleVehicles()

		end
		vehshop.opened = false
		vehshop.menu.from = 1
		vehshop.menu.to = 10
	end)
end


RegisterNetEvent("carshop:failedpurchase69")
AddEventHandler("carshop:failedpurchase69", function()
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	TaskLeaveVehicle(PlayerPedId(),veh,0)
end)


function drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,51,122,181,220)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,250)
	DrawText(0.255, 0.254)
end

function drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.2, 0.2)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(250,250,250, 255)
	else
		SetTextColour(0, 0, 0, 255)
		
	end
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 + 0.025, y - menu.height/3 + 0.0002)

	if selected then
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,51,122,181,250)
	else
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,255, 255, 255,250) 
	end
	

end

function drawMenuTitle(txt,x,y)
	local menu = vehshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)

	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,250)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end



function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function ButtonSelected(button)
	local ped = PlayerPedId()
	local this = vehshop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Vehicles" then
			OpenMenu('vehicles')
		elseif btn == "Motorcycles" then
			OpenMenu('motorcycles')
		elseif btn == "Cycles" then
			OpenMenu('cycles')
		end
	elseif this == "vehicles" then
		if btn == "Sports" then
			OpenMenu('sports')
		elseif btn == "Drift" then
			OpenMenu('drift')
		elseif btn == "Sold/Reserved" then
			OpenMenu('sold/reserved')
		elseif btn == "Sedans" then
			OpenMenu('sedans')
		elseif btn == "Job Vehicles" then
			OpenMenu('jobvehicles')
		elseif btn == "Compacts" then
			OpenMenu('compacts')
		elseif btn == "Coupes" then
			OpenMenu('coupes')
		elseif btn == "Sports Classics" then
			OpenMenu("sportsclassics")
		elseif btn == "Super" then
			OpenMenu('super')
		elseif btn == "Muscle" then
			OpenMenu('muscle')
		elseif btn == "Off-Road" then
			OpenMenu('offroad')
		elseif btn == "SUVs" then
			OpenMenu('suvs')
		elseif btn == "Vans" then
			OpenMenu('vans')
		end
	elseif this == "jobvehicles" or this == "compacts" or this == "coupes" or this == "sedans" or this == "sports" or this == "sportsclassics" or this == "super" or this == "muscle" or this == "offroad" or this == "suvs" or this == "vans" or this == "industrial" or this == "cycles" or this == "motorcycles" or this == "drift" or this == "sold/reserved" then
		if ownerMenu then
			updateCarTable(button.model,button.costs,button.name)
		else
			TriggerServerEvent('CheckMoneyForVeh69',button.name, button.model, button.costs)
		end
		
	end

end

function OpenMenu(menu)
	fakecar = {model = '', car = nil}
	vehshop.lastmenu = vehshop.currentmenu
	if menu == "vehicles" then
		vehshop.lastmenu = "main"
	elseif menu == "bikes"  then
		vehshop.lastmenu = "main"
	elseif menu == 'race_create_objects' then
		vehshop.lastmenu = "main"
	elseif menu == "race_create_objects_spawn" then
		vehshop.lastmenu = "race_create_objects"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "main" then
		CloseCreator()
	elseif vehshop.currentmenu == "jobvehicles" or vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" or vehshop.currentmenu == "drift" or vehshop.currentmenu == "sold/reserved" then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		end
		fakecar = {model = '', car = nil}
		OpenMenu(vehshop.lastmenu)
	else
		OpenMenu(vehshop.lastmenu)
	end
end



Controlkey = {["generalUse"] = {38,"E"},["generalUseSecondary"] = {18,"Enter"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["generalUse"] = table["generalUse"]
	Controlkey["generalUseSecondary"] = table["generalUseSecondary"]
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ( IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1, Controlkey["generalUseSecondary"][1]) ) and IsPlayerInRangeOfVehshop() then
			if vehshop.opened then
				CloseCreator()
			else
				OpenCreator()
			end
		end
		if vehshop.opened then

			local ped = LocalPed()
			local menu = vehshop.menu[vehshop.currentmenu]
			local y = vehshop.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= vehshop.menu.from and i <= vehshop.menu.to then

					if i == vehshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,vehshop.menu.x,y,selected)
					if button.costs ~= nil then

						drawMenuRight("$"..button.costs,vehshop.menu.x,y,selected)

					end
					y = y + 0.04
					if vehshop.currentmenu == "jobvehicles" or vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" or vehshop.currentmenu == "drift" or vehshop.currentmenu == "sold/reserved" then
						if selected then
							if fakecar.model ~= button.model then
								if DoesEntityExist(fakecar.car) then
									Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
								end
								local pos = currentlocation.pos.browsing
								local hash = GetHashKey(button.model)
								RequestModel(hash)



								local modelwait = 1
								RequestModel(hash)
								while not HasModelLoaded(hash) and modelwait < 10 do
									Citizen.Wait(100)
									modelwait = modelwait + 1
								end

								if modelwait > 10 then
									CloseCreator()
								else
									local veh = CreateVehicle(hash,pos[1],pos[2],pos[3],pos[4],false,false)
									SetModelAsNoLongerNeeded(hash)
									local timer = 9000
									while not DoesEntityExist(veh) and timer > 0 do
										timer = timer - 1
										Citizen.Wait(1)
									end
									TriggerEvent("vehsearch:disable",veh)

		


									FreezeEntityPosition(veh,true)
									SetEntityInvincible(veh,true)
									SetVehicleDoorsLocked(veh,4)
									--SetEntityCollision(veh,false,false)
									TaskWarpPedIntoVehicle(LocalPed(),veh,-1)
									for i = 0,24 do
										SetVehicleModKit(veh,0)
										RemoveVehicleMod(veh,i)
									end
									fakecar = { model = button.model, car = veh}

										local topspeed = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel') / 2)
									    local handling = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock') * 2)
									    local braking = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce') * 100)
									    local accel = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce') * 100) 
									
									if button.model == "rumpo" then
										SetVehicleLivery(veh,2)
									end


									-- not sure why it doesnt refresh itself, but blocks need to be set to their maximum 20 40 60 80 100 before a new number is pushed.
									--for i = 1, 5 do
									-- 	scaleform = resetscaleform(topspeed,handling,braking,accel,"mp_car_stats_01",i)
								    --    x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
								    --    Citizen.InvokeNative(0x87D51D72255D4E78,scaleform, x-1,y+1.8,z+7.0, 0.0, 180.0, 90.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0)
									--end

									--scaleform = Initialize("mp_car_stats_01",fakecar.car,fakecar.model)

								end
							end
						end
					end
					if selected and ( IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1, Controlkey["generalUseSecondary"][1]) ) then
						ButtonSelected(button)
					end
				end
			end

			if DoesEntityExist(fakecar.car) then
				if vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
					daz = 6.0
					if fakecar.model == "Chimera" then
						daz = 8.0
					end
					if fakecar.model == "bmx" then
						daz = 8.0
					end
					 x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, -1.5, daz))
		        	Citizen.InvokeNative(0x87D51D72255D4E78,scaleform, x,y,z, 0.0, 180.0, 100.0, 1.0, 1.0, 1.0, 7.0, 7.0, 7.0, 0)
				else
		       		x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, -1.5, 10.0))
		       		Citizen.InvokeNative(0x87D51D72255D4E78,scaleform, x,y,z, 0.0, 180.0, 100.0, 1.0, 1.0, 1.0, 10.0, 10.0, 10.0, 0)		
				end
				TaskWarpPedIntoVehicle(LocalPed(),fakecar.car,-1)
		    end

		end
		if vehshop.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if vehshop.selectedbutton > 1 then
					vehshop.selectedbutton = vehshop.selectedbutton -1
					if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
						vehshop.menu.from = vehshop.menu.from -1
						vehshop.menu.to = vehshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if vehshop.selectedbutton < buttoncount then
					vehshop.selectedbutton = vehshop.selectedbutton +1
					if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
						vehshop.menu.to = vehshop.menu.to + 1
						vehshop.menu.from = vehshop.menu.from + 1
					end
				end
			end
		end

	end
end)

AddEventHandler('FinishMoneyCheckForVeh69', function(name, vehicle, price,financed)	
	local name = name
	local vehicle = vehicle
	local price = price
	boughtcar = true
	CloseCreator(name, vehicle, price,financed)
end)

AddEventHandler('vehshop:spawnVehicle69', function(v)
	local car = GetHashKey(v)
	local playerPed = PlayerPedId()
	if playerPed and playerPed ~= -1 then
		RequestModel(car)

		local modelwait = 1
		while not HasModelLoaded(car) and modelwait < 100 do
			Citizen.Wait(100)
			modelwait = modelwait + 1
		end

		if modelwait > 100 then
			CloseCreator()
			return
		end

		local playerCoords = GetEntityCoords(playerPed)
		veh = CreateVehicle(car, playerCoords, 0.0, true, false)
		SetModelAsNoLongerNeeded(car)
		TaskWarpPedIntoVehicle(playerPed, veh, -1)
		SetEntityInvincible(veh, true)
	end
end)
ShowVehshopBlips(true)
AddEventHandler('playerSpawned', function(spawn)
if firstspawn == 0 then
	--326 car blip 227 225
	ShowVehshopBlips(true)
	firstspawn = 1
end
end)




local vehshopLoc = PolyZone:Create({
	vector2(901.94128417969, -944.42016601563),
	vector2(901.19378662109, -988.61682128906),
	vector2(937.08911132813, -986.65545654297),
	vector2(938.18969726563, -995.44683837891),
	vector2(949.73962402344, -995.05004882813),
	vector2(953.41033935547, -995.00726318359),
	vector2(952.57049560547, -985.20684814453),
	vector2(963.91479492188, -984.59216308594),
	vector2(964.98822021484, -983.99652099609),
	vector2(961.36340332031, -933.67346191406),
	vector2(926.74658203125, -933.97003173828)
}, {
    name = "veh_shop",
    minZ = 0,
    maxZ = 55,
    debugGrid = false,
    gridDivisions = 25
})

local HeadBone = 0x796e;
Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local coord = GetPedBoneCoords(plyPed, HeadBone)
        local inPoly = vehshopLoc:isPointInside(coord)
        -- if true, then player just entered zone
        if inPoly and not insideVehShop then
            insideVehShop = true
        elseif not inPoly and insideVehShop then
            insideVehShop = false
        end
        Citizen.Wait(500)
    end
end)

RegisterCommand('finance', function(source, args, raw)
	local pData = exports["isPed"]:isPed("myJob")
	if pData == 'tuner' then
		TriggerEvent('finance')
	elseif pData == 'tuner' then
		TriggerEvent('finance_tuner')
	else
		TriggerEvent('DoLongHudText', 'You dont have permissions for this!', 2)
	end
end)

RegisterCommand('commission', function(source, args, raw)
	local pData = exports["isPed"]:isPed("myJob")
	if pData == 'tuner' then
		local amount = args[1]
		if amount ~= nil then
			TriggerEvent('commission', amount)
		else
			TriggerEvent('DoLongHudText', 'Invalid amount "/commision [amount]', 1)
		end
	elseif pData == 'tuner' then
		local amount = args[1]
		if amount ~= nil then
			TriggerEvent('commission_tuner', amount)
		else
			TriggerEvent('DoLongHudText', 'Invalid amount "/commision [amount]', 1)
		end
	else
		TriggerEvent('DoLongHudText', 'You dont have permissions for this!', 2)
	end
end)

RegisterCommand('testdrive', function(source, args, raw)
	local pData = exports["isPed"]:isPed("myJob")
	if pData == 'tuner' then
		TriggerEvent('car:testdrive')
	elseif pData == 'tuner' then
		TriggerEvent('car:testdrive_tuner')
	else
		TriggerEvent('DoLongHudText', 'You dont have permissions for this!', 2)
	end
end)