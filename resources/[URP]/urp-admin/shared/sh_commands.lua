URPCore = nil

TriggerEvent('urp:getSharedObject', function(obj) URPCore = obj end)


local cmd = {}
cmd = {
    title = "Set Rank",
    command = "setrank",
    concmd = "setrank",
    category = "User Management",
    usage = "setrank <source> <rank>",
    description = "Sets the selected player's rank",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.rank then return end
    TriggerServerEvent('admin:setGroup', caller.target, caller.rank)
end

function cmd.DrawCommand()
        cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil
        cmd.vars.rank = cmd.vars.rank ~= nil and cmd.vars.rank or nil

        if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then URP.Admin.Menu:DrawTargets(cmd.command, function(_target)
            cmd.vars.target = _target
        end) end           

        if WarMenu.Button("Select a rank", "Selected: " .. (cmd.vars.rank ~= nil and tostring(cmd.vars.rank) or "None")) then URP.Admin.Menu:DrawRanks(cmd.command, function(_rank)
            cmd.vars.rank = _rank
        end) end

        local args = {
            target = cmd.vars.target,
            rank = cmd.vars.rank
        }
    
        if args.target and args.rank then if WarMenu.Button("Set " .. args.target.name .. "'s rank to " .. args.rank) then URP.Admin:GetCommandData(cmd.command).runcommand(args) cmd.vars.target = nil cmd.vars.rank = nil end end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "God",
    command = "god",
    concmd = "god",
    category = "Player",
    usage = "god",
    description = "Enables god mode",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    local godenabled = false
end

function cmd.Init()
    if IsDuplicityVersion() then return end

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if cmd.vars.enable then
                SetPlayerInvincible(PlayerId(), true)
            end
        end
    end)
end

function cmd.RunClCommand(args)
    cmd.vars.enable = args.toggle
    if not caller.toggle then SetPlayerInvincible(PlayerId(), false) end
    TriggerEvent("carandplayerhud:godCheck", caller.toggle)
end

function cmd.DrawCommand()
    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil         
    if WarMenu.Button("God Mode: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle URP.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle}) end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Marker Teleport",
    command = "marker",
    concmd = "marker",
    category = "Player",
    usage = "marker",
    description = "Teleport To marker",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
end

function cmd.RunClCommand(args)
    URP.Admin.teleportMarker()
end

function cmd.DrawCommand()      
    if WarMenu.Button("Teleport to marker") then URP.Admin:GetCommandData(cmd.command).runcommand({}) 
        local WaypointHandle = GetFirstBlipInfoId(8)

        if DoesBlipExist(WaypointHandle) then
            local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
            SetEntityCoords(PlayerPedId(), waypointCoords.x, waypointCoords.y, waypointCoords.z, false, false, false, false)
        end
    end
end

URP.Admin:AddCommand(cmd)



local cmd = {}
cmd = {
    title = "Teleport Coord",
    command = "tcoords",
    concmd = "tcoords",
    category = "Player",
    usage = "tcoords",
    description = "Teleport To Coords",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if caller.x ~= nil and caller.y ~= nil and caller.z ~= nil then
        local pos = vector3(caller.x,caller.y,caller.z)
    end
end

function cmd.RunClCommand(args)
    if caller.x ~= nil and caller.y ~= nil and caller.z ~= nil then
        local pos = vector3(caller.x,caller.y,caller.z)
        local ped = PlayerPedId()

        Citizen.CreateThread(function()
            RequestCollisionAtCoord(pos)
            SetPedCoordsKeepVehicle(ped, pos)
            FreezeEntityPosition(ped, true)
            SetPlayerInvincible(PlayerId(), true)

            local startedCollision = GetGameTimer()

            while not HasCollisionLoadedAroundEntity(ped) do
                if GetGameTimer() - startedCollision > 5000 then break end
                Citizen.Wait(0)
            end

            FreezeEntityPosition(ped, false)
            SetPlayerInvincible(PlayerId(), false)
        end)

    end 

end

function cmd.DrawCommand()      
    cmd.vars.x = cmd.vars.x ~= nil and cmd.vars.x or nil
    cmd.vars.y = cmd.vars.y ~= nil and cmd.vars.y or nil
    cmd.vars.z = cmd.vars.z ~= nil and cmd.vars.z or nil
    if WarMenu.Button("Enter x", "x: " .. (cmd.vars.x and cmd.vars.x or "0.0")) then
        URP.Admin.Menu:ShowTextEntry("Enter Item", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            if string.find(result, ",") then
                local resultSplit = URP.Admin.split(result, ',')
                local x = tonumber(resultSplit[1]) 
                local y = tonumber(resultSplit[2]) 
                local z = tonumber(resultSplit[3]) 

                if x ~= nil and y ~= nil and z ~= nil then
                    cmd.vars.x = x +0.0
                    cmd.vars.y = y +0.0
                    cmd.vars.z = z +0.0
                end
            else
                local x = tonumber(result)
                if x ~= nil then
                    cmd.vars.x = x +0.0
                end
            end
        end)
    end

    if WarMenu.Button("Enter y", "y: " .. (cmd.vars.y and cmd.vars.y or "0.0")) then
        URP.Admin.Menu:ShowTextEntry("Enter y", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            local y = tonumber(result)
            if y ~= nil then
                cmd.vars.y = y +0.0
            end
        end)
    end

    if WarMenu.Button("Enter z", "z: " .. (cmd.vars.z and cmd.vars.z or "0.0")) then
        URP.Admin.Menu:ShowTextEntry("Enter z", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            local z = tonumber(result)
            if z ~= nil then
                cmd.vars.z = z +0.0
            end
        end)
    end

    if cmd.vars.x and cmd.vars.y and cmd.vars.z then if WarMenu.Button("Teleport to: " .. "X:["..cmd.vars.x.."] Y:["..cmd.vars.y.."] Z:["..cmd.vars.z.."]") then URP.Admin:GetCommandData(cmd.command).runcommand({x = cmd.vars.x,y = cmd.vars.y,z = cmd.vars.z}) ExecuteCommand("tp "..cmd.vars.x.." "..cmd.vars.y.." "..cmd.vars.z) end end
end

URP.Admin:AddCommand(cmd)



local cmd = {}
cmd = {
    title = "Dev Spawn",
    command = "devspawn",
    concmd = "devspawn",
    category = "Utility",
    usage = "devspawn",
    description = "Dev Spawn",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
end

function cmd.RunClCommand(args)
    cmd.vars.pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
    local heading = GetEntityHeading(PlayerPedId())
    local value = vector4(cmd.vars.pos.x,cmd.vars.pos.y,cmd.vars.pos.z,heading)
    exports["storage"]:set(value,"devspawn")
end

function cmd.DrawCommand()
    cmd.vars.pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)      
    if WarMenu.Button("Set Dev Spawn") then URP.Admin:GetCommandData(cmd.command).runcommand({pos = cmd.vars.pos}) end
end

URP.Admin:AddCommand(cmd)


local cmd = {}
cmd = {
    title = "Noclip",
    command = "noclip",
    concmd = "noclip",
    category = "Player",
    usage = "noclip",
    description = "Enables noclip",
    ranks = {"admin"},
    vars = {}
}

function noclip(bool)
    
    if bool and isInNoclip then return end
    isInNoclip = bool
    if not isInNoclip then return end

    Citizen.CreateThread(function()
        local speed = 0.5
        while isInNoclip do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            cmd.vars.targetEntity = playerPed
            cmd.vars.heading = cmd.vars.heading == nil and GetEntityHeading(playerPed) or cmd.vars.heading
            cmd.vars.noclip_pos = cmd.vars.noclip_pos == nil and GetEntityCoords(playerPed, false) or cmd.vars.noclip_pos

            SetPlayerInvincible(PlayerId(), true)

            if IsPedInAnyVehicle(playerPed, true) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                if vehicle and vehicle ~= 0 then
                    if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                        cmd.vars.targetEntity = vehicle
                    end
                end
            end

            SetEntityCollision(cmd.vars.targetEntity,false, false)

            SetEntityCoordsNoOffset(cmd.vars.targetEntity,  cmd.vars.noclip_pos.x,  cmd.vars.noclip_pos.y,  cmd.vars.noclip_pos.z,  0, 0, 0)

            if IsControlPressed(1, 34) then
                cmd.vars.heading = cmd.vars.heading + 1.5
                if cmd.vars.heading > 360 then
                    cmd.vars.heading = 0
                end
                SetEntityHeading(cmd.vars.targetEntity,  cmd.vars.heading)
            end

            if IsControlPressed(1, 9) then
                cmd.vars.heading = cmd.vars.heading - 1.5
                if cmd.vars.heading < 0 then
                    cmd.vars.heading = 360
                end
                SetEntityHeading(cmd.vars.targetEntity,  cmd.vars.heading)
            end

            if IsControlPressed(0, 8) then
                cmd.vars.noclip_pos = GetOffsetFromEntityInWorldCoords(cmd.vars.targetEntity, 0.0, -speed, 0.0)
            end

            if IsControlPressed(0, 32) then
                cmd.vars.noclip_pos = GetOffsetFromEntityInWorldCoords(cmd.vars.targetEntity, 0.0, speed, 0.0)
            end

            if IsControlPressed(0, 22) then
                cmd.vars.noclip_pos = GetOffsetFromEntityInWorldCoords(cmd.vars.targetEntity, 0.0, 0.0, speed)
            end
            if IsControlPressed(0, 73) then
                cmd.vars.noclip_pos = GetOffsetFromEntityInWorldCoords(cmd.vars.targetEntity, 0.0, 0.0, -speed)
            end

            if IsControlJustPressed(0, 131) then
                if speed >= 6.5 then speed = 0.5 else speed = speed + 1.0 end
            end
        end
        cmd.vars.heading = nil 
        cmd.vars.noclip_pos = nil 
        SetPlayerInvincible(PlayerId(), false) 
        SetEntityCollision(cmd.vars.targetEntity,true, true) 
        cmd.vars.targetEntity = nil
    end)
end

function cmd.RunCommand(caller, args)
    TriggerEvent("admin:isFlying",caller.toggle)
end

function cmd.Init()
    if IsDuplicityVersion() then return end

    RegisterNetEvent("urp-admin:NoclipState")
    AddEventHandler("urp-admin:NoclipState", function(toggle)
        cmd.vars.toggle = toggle
    end)
end

function cmd.RunClCommand(args)
    cmd.vars.enable = args.toggle
    URP.Admin:RunNclp(cmd.vars.enable)
end

function cmd.DrawCommand()
    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    if WarMenu.Button("Noclip: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle URP.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle}) 
        noclip(cmd.vars.toggle)
    end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Teleport",
    command = "teleport",
    concmd = "teleport",
    category = "Player",
    usage = "teleport <source>",
    description = "Teleports to selected target",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.target then return end
end

function cmd.RunClCommand(args)
    local ped = PlayerPedId()
    local targId = not caller.retn and GetPlayerFromServerId(caller.target.source)
    local targPed = not caller.retn and GetPlayerPed(targId)
    local targPos = caller.retn and cmd.vars.lastPos or GetEntityCoords(targPed, false)

    if caller.retn then caller.vars.lastPos = nil else caller.vars.lastPos = GetEntityCoords(ped) end

    Citizen.CreateThread(function()
        RequestCollisionAtCoord(targPos)
        SetPedCoordsKeepVehicle(PlayerPedId(), targPos)
        FreezeEntityPosition(PlayerPedId(), true)
        SetPlayerInvincible(PlayerId(), true)

        local startedCollision = GetGameTimer()

        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            if GetGameTimer() - startedCollision > 5000 then break end
            Citizen.Wait(0)
        end

        FreezeEntityPosition(PlayerPedId(), false)
        SetPlayerInvincible(PlayerId(), false)
    end)    
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then URP.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    if cmd.vars.target then if WarMenu.Button("Teleport to " .. cmd.vars.target.name .. "'s position") then URP.Admin:GetCommandData(cmd.command).runcommand({target = cmd.vars.target, retn = false}) end end
    if cmd.vars.lastPos then if WarMenu.Button("Return to your last position") then URP.Admin:GetCommandData(cmd.command).runcommand({target = false, retn = true}) end end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Bring",
    command = "bring",
    concmd = "bring",
    category = "Player",
    usage = "bring <source>",
    description = "Brings targeted player to you.",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.target then return end
    URP.Admin:Bring(caller, caller.target.source)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then URP.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    if cmd.vars.target then if WarMenu.Button("Bring " .. cmd.vars.target.name .. " to you.") then URP.Admin:GetCommandData(cmd.command).runcommand({target = cmd.vars.target, retn = false}) 
        end 
    end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Attach",
    command = "attach",
    concmd = "attach",
    category = "Player",
    usage = "attach <source>",
    description = "Attaches to selected target",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.target then return end
end

function cmd.RunClCommand(args)
    if caller.target == nil then return end 
    local ped = PlayerPedId()
    local targId = not caller.retn and GetPlayerFromServerId(caller.target.source)
    local targPed = not caller.retn and GetPlayerPed(targId)
    local targPos = caller.retn and cmd.vars.lastPos or GetEntityCoords(targPed, false)

    Citizen.CreateThread(function()
        if caller.toggle == true and ped ~= targPed then 
            RequestCollisionAtCoord(targPos)
            SetEntityCoordsNoOffset(PlayerPedId(), targPos, 0, 0, 4.0)
            
            local startedCollision = GetGameTimer()

            SetEntityCollision(ped,false,false)


            while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                if GetGameTimer() - startedCollision > 5000 then break end
                Citizen.Wait(0)
            end

            AttachEntityToEntity(ped, targPed, 11816, 0.0, -1.48, 2.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            
        else
            DetachEntity(ped,true,true)
            SetEntityCollision(ped,true,true)
        end
    end)    
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then URP.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    if WarMenu.Button("Attach: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle URP.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle,target = cmd.vars.target}) 
        SetEntityCollision(PlayerPedId(), cmd.vars.toggle, cmd.vars.toggle)
        SetEntityVisible(PlayerPedI, cmd.vars.toggle)
        NetworkSetInSpectatorMode(cmd.vars.toggle, cmd.vars.target)
    
    end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Kick",
    command = "kick",
    concmd = "kick",
    category = "User Management",
    usage = "kick <source>",
    description = "Kicks selected target",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    if not args.reason then args.reason = "No Reason Given" end

    local log = string.format("%s [%s] Kicked player: %s [%s] | Reason: %s", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"), args.reason)
    URP.Admin:Log(log, caller)

    DropPlayer(args.target:getVar("source"), "You were kicked | Reason: " .. args.reason)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil
    cmd.vars.reason = cmd.vars.reason ~= nil and cmd.vars.reason or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then URP.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    if WarMenu.Button("Enter a reason", "Reason: " .. (cmd.vars.reason and cmd.vars.reason or "No Reason Given")) then
        URP.Admin.Menu:DrawTextInput(cmd.vars.reason and cmd.vars.reason or "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.reason = result
        end)
    end

    if cmd.vars.target then if WarMenu.Button("Kick " .. cmd.vars.target.name) then URP.Admin:GetCommandData(cmd.command).runcommand({target = cmd.vars.target, reason = cmd.vars.reason}) 
        TriggerServerEvent('urp-admin:kick', cmd.vars.target, cmd.vars.reason)
        --TriggerServerEvent('urp-admin:kick', GetPlayerServerId(cmd.vars.target), cmd.vars.reason)
        end 
    end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Cloak",
    command = "cloak",
    concmd = "cloak",
    category = "Player",
    usage = "cloak",
    description = "Turn your self invisible",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    local src = GetPlayerServerId(PlayerId())
    if caller.toggle == true then cmd.vars.cloaked[src] = true else cmd.vars.cloaked[src] = nil end
    TriggerServerEvent('urp-admin:Cloak', src, caller.toggle)
end

function cmd.Init()
    cmd.vars.cloaked = {}
    cmd.vars.cloakedVeh = {}

    if IsDuplicityVersion() then 
        AddEventHandler("playerDropped", function()
            local src = source
            if cmd.vars.cloaked[src] then
                TriggerServerEvent('urp-admin:Cloak', src, false)
                cmd.vars.cloaked[src] = nil
            end
        end)

        return
    end

    RegisterNetEvent("urp-admin:CloakRemote")
    AddEventHandler("urp-admin:CloakRemote", function()
        if URP.Admin:GetPlayerRank() == "dev" then
            cmd.vars.toggle = not cmd.vars.toggle
            URP.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle})
        end
    end)

    RegisterNetEvent("urp-admin:Cloak")
    AddEventHandler("urp-admin:Cloak", function(player, toggle)
        if type(player) == "table" then
            cmd.vars.cloaked = player
            TriggerEvent("hud:HidePlayer", player)
        else
            cmd.vars.cloaked[player] = toggle
            TriggerEvent("hud:HidePlayer", player, toggle)
        end
    end)
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            for k,v in pairs(cmd.vars.cloaked) do
                local playerId = GetPlayerFromServerId(k)
                local ped = GetPlayerPed(playerId)
                local isInVehicle = IsPedInAnyVehicle(ped, true)
                local vehicle = cmd.vars.cloakedVeh[k]

                local function uncloakCar(vehicle)
                    NetworkFadeInEntity(vehicle, 0)
                    SetEntityCanBeDamaged(vehicle, true)
                    SetEntityInvincible(vehicle, false)
                    SetVehicleCanBeVisiblyDamaged(vehicle, true)
                    SetVehicleStrong(vehicle, false)
                    SetVehicleSilent(vehicle, false)
                    SetEntityAlpha(vehicle, 255, false)
                    SetEntityLocallyVisible(vehicle)
                    cmd.vars.cloakedVeh[k] = nil
                end

                if not v then
                    NetworkFadeInEntity(ped, 0)
                    SetEntityLocallyVisible(ped)
                    SetPlayerVisibleLocally(playerId, true)
                    SetPedConfigFlag(ped, 52, false)
                    SetPlayerInvincible(playerId, false)
                    SetPedCanBeTargettedByPlayer(ped, playerId, true)
                    SetPedCanBeTargetted(ped, false)
                    SetEveryoneIgnorePlayer(playerId, false)
                    SetIgnoreLowPriorityShockingEvents(playerId, false)
                    SetPlayerCanBeHassledByGangs(playerId, true)
                    SetEntityAlpha(ped, 255, false)
                    SetPedCanRagdoll(ped, true)
                    if vehicle then uncloakCar(vehicle) end
                    cmd.vars.cloaked[k] = nil
                else
                    if ped == PlayerPedId() then
                        SetEntityAlpha(ped, 100, false)
                    else
                        SetEntityAlpha(ped, 0, false)
                        SetEntityLocallyInvisible(ped)
                        SetPlayerInvisibleLocally(playerId, true)
                        NetworkFadeOutEntity(ped, true, false)
                    end

                    SetPedCanRagdoll(ped, false)
                    SetPedConfigFlag(ped, 52, true)
                    SetPlayerCanBeHassledByGangs(playerId, false)
                    SetIgnoreLowPriorityShockingEvents(playerId, true)
                    SetPedCanBeTargettedByPlayer(ped, playerId, false)
                    SetPedCanBeTargetted(ped, false)
                    SetEveryoneIgnorePlayer(playerId, true)
                    SetPlayerInvincible(playerId, true)

                    if vehicle then
                        if not IsPedInAnyVehicle(ped, true) then
                            uncloakCar(vehicle)
                        else
                            if ped == GetPedInVehicleSeat(vehicle, -1) then
                                if ped == PlayerPedId() then
                                    SetEntityAlpha(vehicle, 100, false)
                                else
                                    NetworkFadeOutEntity(vehicle, true, false)
                                    SetEntityAlpha(vehicle, 0, false)
                                    SetEntityLocallyInvisible(vehicle)
                                end
                                SetVehicleSilent(vehicle, true)
                                SetEntityCanBeDamaged(vehicle, false)
                                SetEntityInvincible(vehicle, true)
                                SetVehicleCanBeVisiblyDamaged(vehicle, false)
                                SetVehicleStrong(vehicle, true)
                            else
                                uncloakCar(vehicle)
                            end
                        end
                    else
                        if IsPedInAnyVehicle(ped, true) then
                            local vehicle = GetVehiclePedIsIn(ped, false)
                            if vehicle and vehicle ~= 0 then
                                if GetPedInVehicleSeat(vehicle, -1) == ped then
                                    cmd.vars.cloakedVeh[k] = vehicle
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

function cmd.DrawCommand()
    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    if WarMenu.Button("Cloak: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle URP.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle}) end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Ban",
    command = "ban",
    concmd = "ban",
    category = "User Management",
    usage = "ban <source> <time>",
    description = "Bans selected target",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    if not args.reason then args.reason = "No Reason Given" end
    if not args.time then return end

    local temp, timeSum, addedTime = URP.Admin:GetBanTimeFromString(args.time)

    if temp and temp ~= 0 and timeSum <= 0 then URP.Admin:Log(string.format("%s [%s] attempted to ban %s [%s]; Invalid ban length", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))) return end

    local log = string.format("%s [%s] Banned player: %s [%s] | Reason: %s | Time: %s", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"), args.reason, args.time)
    URP.Admin:Log(log, caller)

    URP.Admin:BanPlayer(args.target, caller, args.time, args.reason)
    DropPlayer(args.target:getVar("source"), string.format("You were banned | Reason: %s | Length: %s", args.reason, args.time == "0" and "permanent" or args.time))
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil
    cmd.vars.reason = cmd.vars.reason ~= nil and cmd.vars.reason or nil
    cmd.vars.time = cmd.vars.time ~= nil and cmd.vars.time or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then URP.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    if WarMenu.Button("Enter a ban length", "Length: " .. (cmd.vars.time and cmd.vars.time or "No Time Given")) then
        URP.Admin.Menu:DrawTextInput(cmd.vars.time and cmd.vars.time or "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end

                local timeTable, timeSum, addedTime = URP.Admin:GetBanTimeFromString(result)
                if not timeTable and not timeSum then result = nil end
            end

            cmd.vars.time = result
        end)
    end

    if WarMenu.Button("Enter a reason", "Reason: " .. (cmd.vars.reason and cmd.vars.reason or "No Reason Given")) then
        URP.Admin.Menu:DrawTextInput(cmd.vars.reason and cmd.vars.reason or "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.reason = result
        end)
    end

    if cmd.vars.target and cmd.vars.time then if WarMenu.Button("Ban " .. cmd.vars.target.name) then URP.Admin:GetCommandData(cmd.command).runcommand({target = cmd.vars.target, reason = cmd.vars.reason, time = cmd.vars.time}) cmd.vars.target = nil cmd.vars.reason = nil cmd.vars.time = nil end end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Ban ID",
    command = "banid",
    concmd = "banid",
    category = "User Management",
    usage = "banid <source> <time>",
    description = "Bans entered steamid",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.steamid or not exports["urp-core"]:getModule("Util"):IsSteamId(args.steamid) then return end
    if not args.reason then args.reason = "No Reason Given" end
    if not args.time then return end

    local players = exports["urp-core"]:getModule("Player"):GetUsers()

    for k,v in pairs(players) do
        local user = exports["urp-core"]:getModule("Player"):GetUser(v)
        if user:getVar("steamid") == args.steamid then URP.Admin:GetCommandData("ban").runcommand(caller, {target = user, reason = args.reason, time = args.time}) return end
    end

    local temp, timeSum, addedTime = URP.Admin:GetBanTimeFromString(args.time)

    if temp and temp ~= 0 and timeSum <= 0 then URP.Admin:Log(string.format("%s [%s] attempted to ban steamid: %s; Invalid ban length", caller:getVar("name"), caller:getVar("steamid"), args.steamid)) return end

    local log = string.format("%s [%s] Banned steamid: %s | Reason: %s | Time: %s", caller:getVar("name"), caller:getVar("steamid"), args.steamid, args.reason, args.time)
    URP.Admin:Log(log, caller)
    URP.Admin:BanId(args.steamid, caller, args.time, args.reason)
end

function cmd.DrawCommand()
    cmd.vars.steamid = cmd.vars.steamid ~= nil and cmd.vars.steamid or nil
    cmd.vars.reason = cmd.vars.reason ~= nil and cmd.vars.reason or nil
    cmd.vars.time = cmd.vars.time ~= nil and cmd.vars.time or nil

    if WarMenu.Button("Enter a Steam ID", "Entered: " .. (cmd.vars.steamid and cmd.vars.steamid or "None")) then 
        URP.Admin.Menu:ShowTextEntry("Enter a Steam ID", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
                if not exports["urp-core"]:getModule("Util"):IsSteamId(result) then result = nil end
            end

            cmd.vars.steamid = result
        end)
    end

    if WarMenu.Button("Enter a ban length", "Length: " .. (cmd.vars.time and cmd.vars.time or "No Time Given")) then
        URP.Admin.Menu:DrawTextInput(cmd.vars.time and cmd.vars.time or "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end

                local timeTable, timeSum, addedTime = URP.Admin:GetBanTimeFromString(result)
                if not timeTable and not timeSum then result = nil end
            end

            cmd.vars.time = result
        end)
    end

    if WarMenu.Button("Enter a reason", "Reason: " .. (cmd.vars.reason and cmd.vars.reason or "No Reason Given")) then
        URP.Admin.Menu:DrawTextInput(cmd.vars.reason and cmd.vars.reason or "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.reason = result
        end)
    end

    if cmd.vars.steamid and cmd.vars.time then if WarMenu.Button("Ban " .. cmd.vars.steamid) then URP.Admin:GetCommandData(cmd.command).runcommand({steamid = cmd.vars.steamid, reason = cmd.vars.reason, time = cmd.vars.time}) cmd.vars.steamid = nil cmd.vars.reason = nil cmd.vars.time = nil end end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Unban",
    command = "unban",
    concmd = "unban",
    category = "User Management",
    usage = "unban <steamid>",
    description = "Unbans entered steamid",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.steamid or not exports["urp-core"]:getModule("Util"):IsSteamId(args.steamid) then return end

    local log = string.format("%s [%s] Unbanned steamid: %s", caller:getVar("name"), caller:getVar("steamid"), args.steamid)
    URP.Admin:Log(log, caller)

    URP.Admin.DB:UnbanSteamId(args.steamid)
end

function cmd.DrawCommand()
    cmd.vars.steamid = cmd.vars.steamid ~= nil and cmd.vars.steamid or nil

    if WarMenu.Button("Enter a Steam ID", "Entered: " .. (cmd.vars.steamid and cmd.vars.steamid or "None")) then 
        URP.Admin.Menu:ShowTextEntry("Enter a Steam ID", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
                if not exports["urp-core"]:getModule("Util"):IsSteamId(result) then result = nil end
            end

            cmd.vars.steamid = result
        end)
    end

    if cmd.vars.steamid then if WarMenu.Button("Unban " .. cmd.vars.steamid) then URP.Admin:GetCommandData(cmd.command).runcommand({steamid = cmd.vars.steamid}) cmd.vars.steamid = nil end end
end

URP.Admin:AddCommand(cmd)

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Temp Ban",
    command = "tempban",
    concmd = "tempban",
    category = "User Management",
    usage = "tempban <source>",
    description = "Temporarily bans player until next restart",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    cmd.vars.bannedplayers[args.target:getVar("hexid")] = true

    local log = string.format("%s [%s] Temp banned %s [%s]", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    URP.Admin:Log(log, caller)

    DropPlayer(args.target:getVar("source"), "You were temporarily banned until next restart")
end

function cmd.Init()
    if not IsDuplicityVersion() then return end

    cmd.vars.bannedplayers = {}

    AddEventHandler("queue:playerJoinQueue", function(src, setReason)
        local hexId = exports["urp-core"]:getModule("Util"):GetHexId(src)
        if cmd.vars.bannedplayers[steamId] then setReason("You are temporarily banned until next server restart") CancelEvent() end
    end)

    AddEventHandler("urp-core:playerLoggedIn", function(user)
        Citizen.Wait(1000)
        if cmd.vars.bannedplayers[user:getVar("hexid")] then DropPlayer(user:getVar("source"), "You are temporarily banned until next restart") end
    end)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then URP.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end  

    if cmd.vars.target then if WarMenu.Button("Tempban " .. cmd.vars.target.name) then URP.Admin:GetCommandData(cmd.command).runcommand({target = cmd.vars.target}) cmd.vars.target = nil end end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Csay",
    command = "csay",
    concmd = "csay",
    category = "Utility",
    usage = "csay <message>",
    description = "Sends a serverwide chat message",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.message then return end
    TriggerServerEvent('admin:addChatMessage', caller.message)
end

function cmd.DrawCommand()
    cmd.vars.message = cmd.vars.message ~= nil and cmd.vars.message or nil

    if WarMenu.Button("Enter a message", "Message: " .. (cmd.vars.message and cmd.vars.message or "No Message")) then
        URP.Admin.Menu:ShowTextEntry("Enter a Message", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.message = result
        end)
    end

    if cmd.vars.message then if WarMenu.Button("Send Message: " .. cmd.vars.message) then URP.Admin:GetCommandData(cmd.command).runcommand({message = cmd.vars.message}) end end
end


URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Spawn Car",
    command = "scar",
    concmd = "scar",
    category = "Utility",
    usage = "scar <model>",
    description = "spawn's you a car",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.message then return end
    TriggerEvent("urp-admin:runSpawnCommand", caller.message)
end

function cmd.DrawCommand()
    cmd.vars.message = cmd.vars.message ~= nil and cmd.vars.message or nil

    if WarMenu.Button("Enter a model", "Model: " .. (cmd.vars.message and cmd.vars.message or "No model")) then
        URP.Admin.Menu:ShowTextEntry("Enter a model", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.message = result
        end)
    end 
    if WarMenu.Button("Seat into Vehicle") then TriggerEvent("urp-admin:SeatIntoLast") end

    if cmd.vars.message then if WarMenu.Button("Spawn model: " .. cmd.vars.message) then URP.Admin:GetCommandData(cmd.command).runcommand({message = cmd.vars.message})
        end 
    end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Give Car",
    command = "gcar",
    concmd = "gcar",
    category = "Utility",
    usage = "gcar <model> <cid>",
    description = "gives a cid a car",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.message then return end
    local src = caller:getVar("source")
    
    URP.Admin.DB:giveCar(args.message, args.reciver)

    URP.Admin:Log(log, caller)
end

function cmd.DrawCommand()
    cmd.vars.message = cmd.vars.message ~= nil and cmd.vars.message or nil
    cmd.vars.reciver = cmd.vars.reciver ~= nil and cmd.vars.reciver or nil

    if WarMenu.Button("Enter a model", "Model: " .. (cmd.vars.message and cmd.vars.message or "No model")) then
        URP.Admin.Menu:ShowTextEntry("Enter a model", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.message = result
        end)
    end

    if WarMenu.Button("Enter a cid", "Cid: " .. ( cmd.vars.reciver and  cmd.vars.reciver or "No cid")) then
        URP.Admin.Menu:ShowTextEntry("Enter a cid", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

             cmd.vars.reciver = result
        end)
    end

    if cmd.vars.message and cmd.vars.reciver then if WarMenu.Button("Give model: " .. cmd.vars.message.." to "..cmd.vars.reciver) then URP.Admin:GetCommandData(cmd.command).runcommand({message = cmd.vars.message,reciver = cmd.vars.reciver}) end end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Spawn Item",
    command = "stim",
    concmd = "stim",
    category = "Utility",
    usage = "stim <name>",
    description = "Gives you an item",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.message then return end
    if not caller.amount then caller.amount = 1 end
    if (caller.message == "badlsdtab" or caller.message == "lsdtab") then
        local steamId = (caller and type(caller) ~= "string") and caller:getVar("steamid") or (caller and caller or "Unknown")
    end
    TriggerEvent('player:receiveItem', caller.message, caller.amount)
end

function cmd.DrawCommand()
    cmd.vars.message = cmd.vars.message ~= nil and cmd.vars.message or nil
    cmd.vars.amount = cmd.vars.amount ~= nil and cmd.vars.amount or nil
    if WarMenu.Button("Enter a item name", "Model: " .. (cmd.vars.message and cmd.vars.message or "No item")) then
        URP.Admin.Menu:ShowTextEntry("Enter Item", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.message = result
            if cmd.vars.amount == nil then cmd.vars.amount = 1 end
        end)
    end

    if WarMenu.Button("Enter Amount", "Amount: " .. (cmd.vars.amount and cmd.vars.amount or "1")) then
        URP.Admin.Menu:ShowTextEntry("Enter Amount", "", function(result)
            print(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            local amount = tonumber(result)
            if amount == nil or amount <= 0 or amount >= 51 then amount = 1 end
            cmd.vars.amount = amount
        end)
    end

    if cmd.vars.message then if WarMenu.Button("Spawn Item: " .. cmd.vars.message.." | "..cmd.vars.amount) then URP.Admin:GetCommandData(cmd.command).runcommand({message = cmd.vars.message,amount = cmd.vars.amount}) end end
end

URP.Admin:AddCommand(cmd)


local cmd = {}
cmd = {
    title = "Weather / Time",
    command = "wTime",
    concmd = "wTime",
    category = "Utility",
    usage = "wTime <name>",
    description = "Changes weather ,time and light",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)

    local src = caller:getVar("source")

    if args.time ~= nil and args.time ~= 0 then
        TriggerEvent("weather:time",src,args.time)
    end

    if args.weather ~= nil and args.weather ~= "" then
        TriggerEvent("weather:setWeather",src,args.weather)
    end

    if args.light ~= nil and args.light ~= "" then
        TriggerClientEvent("weather:setCycle",src,args.light)
    end

    TriggerClientEvent("weather:blackout",src,args.blackout)
end

function cmd.DrawCommand()
    cmd.vars.time = cmd.vars.time ~= nil and cmd.vars.time or nil
    cmd.vars.weather = cmd.vars.weather ~= nil and cmd.vars.weather or nil
    cmd.vars.lightType = cmd.vars.lightType ~= nil and cmd.vars.lightType or nil


    if WarMenu.Button("Enter a time", "Time: " .. (cmd.vars.time and cmd.vars.time or "0")) then
        URP.Admin.Menu:ShowTextEntry("Enter Time", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            local time = tonumber(result)
            if time == nil then time = 0 end
            cmd.vars.time = time
        end)
    end


    if WarMenu.Button("Enter a Weather status", "Weather: " .. (cmd.vars.weather and cmd.vars.weather or "none")) then
        URP.Admin.Menu:ShowTextEntry("Enter Weather status", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.weather = result
        end)
    end


    if WarMenu.Button("Enter a Cycle Effect", "Cycle: " .. (cmd.vars.lightType and cmd.vars.lightType or "none")) then
        URP.Admin.Menu:ShowTextEntry("Enter Time Cycle Effect", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.lightType = result
        end)
    end


    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    if WarMenu.Button("Blackout: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle 
        SetArtificialLightsState(cmd.vars.toggle --[[ boolean ]])
    end


    if cmd.vars.time or cmd.vars.weather or cmd.vars.lightType then if WarMenu.Button("Update Server/Client - Time") then URP.Admin:GetCommandData(cmd.command).runcommand({time = cmd.vars.time, weather = cmd.vars.weather, light = cmd.vars.lightType, blackout = cmd.vars.toggle}) 
        TriggerServerEvent('kTimeSync', cmd.vars.weather)
        -- ExecuteCommand('time '..cmd.vars.time)
    end 
    if cmd.vars.time or cmd.vars.weather or cmd.vars.lightType then if WarMenu.Button("Update Server/Client - Weather") then URP.Admin:GetCommandData(cmd.command).runcommand({time = cmd.vars.time, weather = cmd.vars.weather, light = cmd.vars.lightType, blackout = cmd.vars.toggle})
            TriggerServerEvent('kWeatherSync', cmd.vars.weather)
            --ExecuteCommand('weather '..cmd.vars.weather)
    end 
end
end
end

URP.Admin:AddCommand(cmd)


local cmd = {}
cmd = {
    title = "Become Model",
    command = "bModel",
    concmd = "bModel",
    category = "Utility",
    usage = "bModel <name>",
    description = "Set's current model",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.message then return end
    TriggerEvent('urp-clothing:AdminSetModel', caller.message)
end

function cmd.DrawCommand()
    cmd.vars.message = cmd.vars.message ~= nil and cmd.vars.message or nil

    if WarMenu.Button("Enter model name", "Model: " .. (cmd.vars.message and cmd.vars.message or "No model")) then
        URP.Admin.Menu:ShowTextEntry("Enter Model", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.message = result
        end)
    end

    if cmd.vars.message then if WarMenu.Button("Set Model: " .. cmd.vars.message) then URP.Admin:GetCommandData(cmd.command).runcommand({message = cmd.vars.message}) 
        TriggerEvent('urp-admin:setmodel', cmd.vars.message)
        --ChangePlayerPed(PlayerPedId(), cmd.var.message, true, true)
        end 
    end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Tsay",
    command = "tsay",
    concmd = "tsay",
    category = "Utility",
    usage = "tsay <message>",
    description = "Sends a serverwide announcement",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.message then return end
    TriggerServerEvent('admin:addChatAnnounce', caller.message)
end

function cmd.DrawCommand()
    cmd.vars.message = cmd.vars.message ~= nil and cmd.vars.message or nil

    if WarMenu.Button("Enter a message", "Message: " .. (cmd.vars.message and cmd.vars.message or "No Message")) then
        URP.Admin.Menu:ShowTextEntry("Enter a Message", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.message = result
        end)
    end

    if cmd.vars.message then if WarMenu.Button("Send Announcement: " .. cmd.vars.message) then URP.Admin:GetCommandData(cmd.command).runcommand({message = cmd.vars.message}) end end
end

URP.Admin:AddCommand(cmd)

--[[ local cmd = {}
cmd = {
    title = "Rave Mode",
    command = "rave",
    concmd = "rave",
    category = "Fun",
    usage = "rave",
    description = "Enables rave mode",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    local log = string.format("%s [%s] set ravemode: %s", caller:getVar("name"), caller:getVar("steamid"), args.toggle and "true" or "false")
    URP.Admin:Log(log, caller)
end

function cmd.Init()
    if IsDuplicityVersion() then
        cmd.vars.toggle = false

        RegisterNetEvent("urp-admin:RaveMode")
        AddEventHandler("urp-admin:RaveMode", function(enabled)
            cmd.vars.toggle = enabled
            TriggerClientEvent("urp-admin:RaveMode", -1, enabled)
        end)

        AddEventHandler("urp-core:characterLoaded", function(user, char)
            local src = user:getVar("source")
            if cmd.vars.toggle then TriggerClientEvent("urp-admin:RaveMode", src, cmd.vars.toggle) end
        end)

        return
    end

    local color = {255, 255, 255}
    local particles = {}

    local function StartRaveMode()
        Citizen.CreateThread(function()
            local particleDict = "core"
            local particleName = "ent_amb_wind_grass_dir"

            RequestNamedPtfxAsset(particleDict)

            while not HasNamedPtfxAssetLoaded(particleDict) do Citizen.Wait(0) end

            UseParticleFxAssetNextCall(particleDict)

            for i = 0, 255 do
                if IsPlayerPlaying(i) then
                    local particle = StartParticleFxLoopedOnPedBone(particleName, GetPlayerPed(i), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 31086, 0.5, 0.0, 0.0, 0.0)
                    particles[#particles+1]= particle
                end
            end

            while true do
                Citizen.Wait(200)
                color = {GetRandomIntInRange(1, 255), GetRandomIntInRange(1, 255),GetRandomIntInRange(1, 255)}
                if not cmd.vars.toggle then return end
            end
        end)
    
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                for i = 0, 255 do
                    if IsPlayerPlaying(i) then
                        local coords = GetEntityCoords(GetPlayerPed(i), false)
                        DrawLightWithRange(coords.x, coords.y, coords.z + 5.0, color[1], color[2], color[3], 999999999999.0, 9999.0)
                    end
                    NetworkOverrideClockTime(23, 12, 23)
                end
                if not cmd.vars.toggle then 
                    for i = 0, 255 do
                        for k,v in pairs(particles) do
                            RemoveParticleFx(v, true)
                        end
                    end
                    return
                end
            end
        end)
    end

    RegisterNetEvent("urp-admin:RaveMode")
    AddEventHandler("urp-admin:RaveMode", function(toggle)
        cmd.vars.toggle = toggle
        if toggle == true then StartRaveMode() end
    end)
end

function cmd.RunClCommand(args)
    TriggerServerEvent("urp-admin:RaveMode", cmd.vars.toggle)
end

function cmd.DrawCommand()
    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    if WarMenu.Button("Rave Mode: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle URP.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle}) end
end

URP.Admin:AddCommand(cmd) ]]

local cmd = {}
cmd = {
    title = "Player Blips",
    command = "playerblips",
    concmd = "playerblips",
    category = "Player",
    usage = "playerblips",
    description = "Enables player blips",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
end

function cmd.Init()
    if IsDuplicityVersion() then return end
    cmd.vars.loopWait = true 
    cmd.vars.blips = {}
    cmd.vars.toggle = false

    Citizen.CreateThread(function()
        local function CreateBlip(playerId)
            local playerPed = GetPlayerPed(playerId)
            local blip = AddBlipForEntity(playerPed)
    
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Player")
            EndTextCommandSetBlipName(blip)
            
            ShowNumberOnBlip(blip,GetPlayerServerId(playerId))
            SetBlipCategory(blip, 2)
            SetBlipAsShortRange(blip, false)
            SetBlipColour(blip, 1)
            SetBlipNameToPlayerName(blip, playerId)
            SetBlipScale(blip, 1.0)
    
            cmd.vars.blips[playerId] = blip
        end

        local function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
            local onScreen, _x, _y = World3dToScreen2d(x , y, z)
            local px, py, pz = table.unpack(GetGameplayCamCoords())
            local dist = #(vector3(px, py, pz) - vector3(x, y, z))
            
            if onScreen then
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 1.0)
                SetTextColour(255, 0, 0, 255)
                SetTextDropshadow(0, 0, 0, 0, 55)
                SetTextEdge(2, 0, 0, 0, 150)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                SetTextCentre(1)
                AddTextComponentString(text)
                DrawText(_x, _y)
            end
        end

        while true do
            Citizen.Wait(0)
            if cmd.vars.toggle then
                cmd.vars.loopWait = false
                for i = 0, 255 do
                    if NetworkIsPlayerActive(i) and IsPlayerPlaying(i) and not (PlayerPedId() == GetPlayerPed(i)) then
                        if not cmd.vars.blips[i] then CreateBlip(i) end

                        local pCoords = GetEntityCoords(GetPlayerPed(i), false)
                        local lCoords = GetEntityCoords(PlayerPedId(), false)
                        local dist = Vdist2(pCoords, lCoords)

                        if dist <= 100.0 then
                            DrawText3D(pCoords.x, pCoords.y, pCoords.z + 1.15, string.format("[%d] - %s", GetPlayerServerId(i), GetPlayerName(i)))
                        end
                    end
                end
            else
                if cmd.vars.blips ~= {} and not cmd.vars.loopWait then
                    for i = 0, 255 do
                        if cmd.vars.blips[i] then RemoveBlip(cmd.vars.blips[i]) cmd.vars.blips[i] = nil end

                        if cmd.vars.blips[i] ~= nil then
                            cmd.vars.loopWait = false
                        else
                            cmd.vars.loopWait = true
                        end
                    end
                end
            end
        end
    end)
end

function cmd.RunClCommand(args)
    cmd.vars.toggle = args.toggle
end

function cmd.DrawCommand()
    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    if WarMenu.Button("Player Blips: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle URP.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle}) 
        --TriggerEvent('mostraBlips')
    end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Revive/Heal",
    command = "revive",
    concmd = "revive",
    category = "Player",
    usage = "revive <source>",
    description = "revives/heals selected player",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.target then return end

    TriggerEvent("reviveGranted", caller.target.source)
    TriggerClientEvent("Hospital:HealInjuries", caller.target.source,true) 
    TriggerEvent("ems:healplayer", caller.target.source)
    TriggerClientEvent("heal", caller.target.source)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then URP.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    if WarMenu.Button("Revive in Distance") then 
        TriggerEvent("urp-admin:ReviveInDistance")
    end


    if cmd.vars.target then if WarMenu.Button("Revive and Heal " .. cmd.vars.target.name) then URP.Admin:GetCommandData(cmd.command).runcommand({target = cmd.vars.target, runontarget = true}) end end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Fix Car",
    command = "fixc",
    concmd = "fixc",
    category = "Player",
    usage = "fixc <source>",
    description = "Fixes the car the selected target is in or Current vehicle",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    local log = string.format("%s [%s] fixed %s's [%s] vehicle", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    URP.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)
    local ped = PlayerPedId()
    

    if args.runontarget then
        local playerIdx = GetPlayerFromServerId(args.target.source)
        ped = GetPlayerPed(playerIdx)
    end

    local vehicle = GetVehiclePedIsIn(ped, false)
    if not vehicle then return end

    SetVehicleFixed(vehicle)
    SetVehiclePetrolTankHealth(vehicle, 4000.0)
end

function cmd.DrawCommand()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    cmd.vars.target = cmd.vars.target or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then URP.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    if cmd.vars.target then if WarMenu.Button("Fix " .. cmd.vars.target.name .. "'s vehicle") then URP.Admin:GetCommandData(cmd.command).runcommand({target = cmd.vars.target, runontarget = true}) 
    TriggerServerEvent('urp-admin:repair', _target)
    end 
end
    if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then 
        if WarMenu.Button("Fix Current vehicle.") then 
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
    end 
end

end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Request Job",
    command = "rJob",
    concmd = "rJob",
    category = "Player",
    usage = "setjob <source>",
    description = "Attempt to sign onto a job.",
    ranks = {"admin"},
    vars = {}
}
function setmyjob(args)
    local jobName = caller

    if jobName == "1" then
        TriggerClientEvent('urp:setJob', "police")
    elseif jobName == "2" then 
        TriggerClientEvent('urp:setJob', "ems")
    elseif jobName == "3" then
        TriggerClientEvent('urp:setJob', "gov")
    end
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target or nil

    if WarMenu.Button("Select a job", "Selected: " .. (cmd.vars.target and cmd.vars.target or "None")) then URP.Admin.Menu:DrawJobs(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    if cmd.vars.target then 
        if WarMenu.Button("Request [" .. cmd.vars.target .. "]") then 
            setmyjob(cmd.vars.target) 
            print(cmd.vars.target) 
            TriggerServerEvent('urp-admin:setjob', cmd.vars.target)
            print("afterjob") 
        end 
    end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Entity View",
    command = "entview",
    concmd = "entview",
    category = "Utility",
    usage = "entview",
    description = "Enables entity view mode",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    local log = string.format("%s [%s] set ent view: %s", caller:getVar("name"), caller:getVar("steamid"), args.toggle and "true" or "false")
    URP.Admin:Log(log, caller)
end

function cmd.Init()
    if IsDuplicityVersion() then return end

    WarMenu.CreateSubMenu("filtermenu", "amenu", "Available Filters")
    URP.Admin.Menu:SetSubMenuProperties("filtermenu")

    cmd.vars.filters = {
        ["all"] = false,
        ["ped"] = 1,
        ["veh"] = 2,
        ["obj"] = 3,
    }

    local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
    }

    local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
        return coroutine.wrap(function()
            local iter, id = initFunc()
            if not id or id == 0 then
            disposeFunc(iter)
            return
            end
            
            local enum = {handle = iter, destructor = disposeFunc}
            setmetatable(enum, entityEnumerator)
            
            local next = true
            repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
            until not next
            
            enum.destructor, enum.handle = nil, nil
            disposeFunc(iter)
        end)
    end

    local function EnumerateObjects()
        return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
    end

    local function EnumeratePeds()
        return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
    end

    local function EnumerateVehicles()
        return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
    end

    Citizen.CreateThread(function()
        while true do
            if cmd.vars.enable then
                local filter = cmd.vars.filters[cmd.vars.filter]
                local toDraw = {}
                local pedPos = GetEntityCoords(PlayerPedId(), false)

                local function debugEnt(ent)
                    local entPos = GetEntityCoords(ent, false)
                    local dist = Vdist2(entPos, pedPos)
                    if dist< cmd.vars.distance then toDraw[#toDraw+1]= ent end
                end

                if not filter or filter == 2 then
                    for veh in EnumerateVehicles() do
                        debugEnt(veh)
                    end
                end

                if not filter or filter == 3 then
                    for obj in EnumerateObjects() do
                        debugEnt(obj)
                    end
                end

                if not filter or filter == 1 then 
                    for ped in EnumeratePeds() do
                        if ped ~= PlayerPedId() then
                            debugEnt(ped)
                        end
                    end
                end

                for _, ent in ipairs(toDraw) do
                    local x, y, z = table.unpack(GetEntityCoords(ent, false))
                    local _, _x, _y = World3dToScreen2d(x, y, z)
                    local px, py, pz = table.unpack(GetGameplayCamCoords())
                    local dist = #(vector3(px, py, pz) - vector3(x, y, z))
                    local model = tostring(GetEntityModel(ent))
                    local isMission = tostring(IsEntityAMissionEntity(ent))
                    local isInControl = tostring(NetworkHasControlOfEntity(ent) == 1 and true or false)
                    local entType = tostring(GetEntityType(ent))

                    local scale = (1/dist) * 20
                    scale = scale * ((1/GetGameplayCamFov()) * 100)

                    SetDrawOrigin(x, y, z, 0)

                    SetTextScale(0.0*scale, 0.05*scale)
                    SetTextFont(0)
                    SetTextProportional(1)
                    SetTextColour(255, 0, 0, 255)
                    SetTextDropshadow(0, 0, 0, 0, 255)
                    SetTextEdge(2, 0, 0, 0, 150)
                    SetTextDropShadow()
                    SetTextOutline()
                    SetTextEntry("STRING")
                    SetTextCentre(1)
                    AddTextComponentString("Id: " .. ent .. "\nModel: " .. model .. "\nMission Ent: " .. isMission .. "\nNetwork Control: " .. isInControl .. "\nType: " .. entType)
                    DrawText()
                    
                    ClearDrawOrigin()
                end
            end

            Citizen.Wait(0)
        end
    end)
end

function cmd.RunClCommand(args)
    cmd.vars.enable = args.toggle
    cmd.vars.filter = args.filter
end

function cmd.DrawCommand()
    cmd.vars.toggle = cmd.vars.toggle or nil
    cmd.vars.filter = cmd.vars.filter or "all"
    cmd.vars.distance = cmd.vars.distance or 150

    if WarMenu.Button("Entity View: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle URP.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle, filter = cmd.vars.filter}) end

    if WarMenu.Button("Enter view distance", "Entered: " .. (cmd.vars.distance or "150")) then 
        URP.Admin.Menu:ShowTextEntry("Enter a distance", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
                result = tonumber(result)
                if not result then result = nil end
            end

            cmd.vars.distance = result
        end)
    end

    local function DrawFilters()
        WarMenu.OpenMenu("targetmenu")

        Citizen.CreateThread(function()
            while WarMenu.IsMenuOpened("targetmenu") do
                Citizen.Wait(0)
                for f, t in pairs(cmd.vars.filters) do
                    if WarMenu.MenuButton(f, "command") then cmd.vars.filter = f URP.Admin.Menu:DrawCommand(cmd.command) return end
                end
                if WarMenu.MenuButton("Back", "command") then URP.Admin.Menu:DrawCommand(cmd.command) return end
            end
        end)
    end

    if WarMenu.Button("Filter: " .. (cmd.vars.filter or "all")) then DrawFilters() end
end

URP.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Delete Entity",
    command = "deleteent",
    concmd = "deleteent",
    category = "Utility",
    usage = "deleteent <entid>",
    description = "Deletes selected entities",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.ent then return end
    local log = string.format("%s [%s] Deleted entity: %s", caller:getVar("name"), caller:getVar("steamid"), args.ent)
    if not args.target then return end
    local log = string.format("%s [%s] Attempted to sign on %s's [%s] to cop", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    URP.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)
    if not caller.ent then return end
    if not DoesEntityExist(caller.ent) then return end

    Citizen.CreateThread(function()
        local timeout = 0

        while true do
            if timeout >= 3000 then return end
            timeout = timeout + 1

            NetworkRequestControlOfEntity(caller.ent)

            local nTimeout = 0

            while not NetworkHasControlOfEntity(caller.ent) and nTimeout < 1000 do
                nTimeout = nTimeout + 1
                NetworkRequestControlOfEntity(caller.ent)
                Citizen.Wait(0)
            end

            SetEntityAsMissionEntity(caller.ent, true, true)

            DeleteEntity(caller.ent)
            if GetEntityType(caller.ent) == 2 then DeleteVehicle(caller.ent) end

            if not DoesEntityExist(caller.ent) then cmd.vars.ent = nil return end

            Citizen.Wait(0)
        end
    end)
end

function cmd.DrawCommand()
    cmd.vars.ent = cmd.vars.ent or nil

    if WarMenu.Button("Enter an entity ID") then 
        URP.Admin.Menu:ShowTextEntry("Enter an entity ID", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
                result = tonumber(result)
                if not result then result = nil end
            end

            cmd.vars.ent = result
        end)
    end

    if WarMenu.Button("Select Entity Infront") then
        local coordA = GetEntityCoords(PlayerPedId(), false)
		local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, 0.0)

        local offset = 0
        local rayHandle
        local entity

        for i = 0, 100 do
            rayHandle = CastRayPointToPoint(coordA.x, coordA.y, coordA.z, coordB.x, coordB.y, coordB.z + offset, 10, PlayerPedId(), -1)	
            a, b, c, d, entity = GetRaycastResult(rayHandle)
            offset = offset - 1
            if entity and Vdist(GetEntityCoords(entity, false), coordA) < 150 then break end
        end

        if entity then cmd.vars.ent = entity end
    end

    if cmd.vars.ent and DoesEntityExist(cmd.vars.ent) then
        x, y, z = table.unpack(GetEntityCoords(cmd.vars.ent, true))
        SetDrawOrigin(x, y, z, 0)
        RequestStreamedTextureDict("helicopterhud", false)
        DrawSprite("helicopterhud", "hud_corner", -0.01, -0.01, 0.05, 0.05, 0.0, 0, 255, 0, 200)
        DrawSprite("helicopterhud", "hud_corner", 0.01, -0.01, 0.05, 0.05, 90.0, 0, 255, 0, 200)
        DrawSprite("helicopterhud", "hud_corner", -0.01, 0.01, 0.05, 0.05, 270.0, 0, 255, 0, 200)
        DrawSprite("helicopterhud", "hud_corner", 0.01, 0.01, 0.05, 0.05, 180.0, 0, 255, 0, 200)
        ClearDrawOrigin()
    end

    if cmd.vars.ent then if WarMenu.Button("Delete Entity", "Entity: " .. (cmd.vars.ent or "none")) then
        DeleteEntity(cmd.vars.ent)
    end end
end

URP.Admin:AddCommand(cmd)

--[[
    function cmd.ChatCommand(args)
        local cmd = args[1] and args[1] or false
        local target = args[2] and args[2] or false
        local rank = args[3] and args[3] or false

        if not cmd or not target or not rank then return end

        if not URP.Admin:RankExists(rank) then return end
        if not URP.Admin:IsValidUser(target) then return end

        local args = {
            target = exports["urp-core"]:getModule("Player"):getUser(target),
            rank = rank
        }

        return args
    end
]]