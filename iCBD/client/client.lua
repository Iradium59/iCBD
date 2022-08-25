ESX = nil

TriggerServerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

function Menuf6cbd()
    local cbdf6 = RageUI.CreateMenu("CBD", "Interactions")
    local cbdf6sub = RageUI.CreateSubMenu(cbdf6, "CBD", "Interaction")
    RageUI.Visible(cbdf6, not RageUI.Visible(cbdf6))
    while cbdf6 do
        Citizen.Wait(0)
        RageUI.IsVisible(cbdf6, true, true, true, function()
            RageUI.Separator("~y~↓ Facture ↓")

            RageUI.ButtonWithStyle("Facture",nil, {RightLabel = "→"}, true, function(_,_,s)
                local player, distance = ESX.Game.GetClosestPlayer()
                if s then
                    local raison = ""
                    local montant = 0
                    AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0)
                        Wait(0)
                    end
                    if (GetOnscreenKeyboardResult()) then
                        local result = GetOnscreenKeyboardResult()
                        if result then
                            raison = result
                            result = nil
                            AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0)
                                Wait(0)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                result = GetOnscreenKeyboardResult()
                                if result then
                                    montant = result
                                    result = nil
                                    if player ~= -1 and distance <= 3.0 then
                                        TriggerServerEvent('esx_billing:sendBill1', GetPlayerServerId(player), 'society_cbd', ('CBD'), montant)
                                        TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                    else
                                        ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                    end
                                end
                            end
                        end
                    end
                end
            end)


            RageUI.Separator("~y~↓ Annonce ↓")



            RageUI.ButtonWithStyle("Annonces d'ouverture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then       
                    TriggerServerEvent('AnnoncecbdOuvert')
                end
            end)
    
            RageUI.ButtonWithStyle("Annonces de fermeture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then      
                    TriggerServerEvent('AnnoncecbdFermer')
                end
            end)

            RageUI.Separator("")

            RageUI.ButtonWithStyle("Récolte cbd",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then       
                    SetNewWaypoint(cbd.pos.recolte.position.x, cbd.pos.recolte.position.y)
                end
            end)

            RageUI.ButtonWithStyle("Traitement cbd",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then       
                    SetNewWaypoint(cbd.pos.traitement.position.x, cbd.pos.traitement.position.y)
                end
            end)

            RageUI.ButtonWithStyle("vente splif",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then       
                    SetNewWaypoint(cbd.pos.vente.position.x, cbd.pos.vente.position.y)
                end
            end)

            RageUI.Separator("")

            
        end, function() 
        end)

            

            if not RageUI.Visible(cbdf6) and not RageUI.Visible(cbdf6sub) then
                cbdf6 = RMenu:DeleteType("cbdf6", true)
        end
    end
end

Keys.Register('F6', 'CBD', 'Ouvrir le menu CBD', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cbd' then
        Menuf6cbd()
    end
end)

function Garagecbd()
    local Gcbd = RageUI.CreateMenu("Garage", "CBD")
      RageUI.Visible(Gcbd, not RageUI.Visible(Gcbd))
          while Gcbd do
              Citizen.Wait(0)
                  RageUI.IsVisible(Gcbd, true, true, true, function()
                      RageUI.ButtonWithStyle("Ranger la voiture", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                          if (Selected) then   
                          local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                          if dist4 < 4 then
                              DeleteEntity(veh)
                              RageUI.CloseAll()
                              end 
                          end
                      end) 
  
                      for k,v in pairs(cbdvehicule) do
                      RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                          if (Selected) then
                          Citizen.Wait(1)  
                              spawnuniCarcbd(v.modele)
                              RageUI.CloseAll()
                              end
                          end)
                      end
                  end, function()
                  end)
              if not RageUI.Visible(Gcbd) then
              Gcbd = RMenu:DeleteType("Garage", true)
          end
      end
  end

  function spawnuniCarcbd(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, cbd.pos.spawnvoiture.position.x, cbd.pos.spawnvoiture.position.y, cbd.pos.spawnvoiture.position.z, cbd.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "cbd"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
end

  Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cbd' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, cbd.pos.garage.position.x, cbd.pos.garage.position.y, cbd.pos.garage.position.z)
        if dist3 <= 10.0 and cbd.marker then
            Timer = 0
            DrawMarker(20, cbd.pos.garage.position.x, cbd.pos.garage.position.y, cbd.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 75, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 3.0 then
            Timer = 0   
                RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au garage", time_display = 1 })
                if IsControlJustPressed(1,51) then           
                    Garagecbd()
                end   
            end
        end 
    Citizen.Wait(Timer)
 end
end)

function Coffrecbd()
    local Ccbd = RageUI.CreateMenu("Coffre", "CBD")
        RageUI.Visible(Ccbd, not RageUI.Visible(Ccbd))
            while Ccbd do
            Citizen.Wait(0)
            RageUI.IsVisible(Ccbd, true, true, true, function()

                RageUI.Separator("↓ Objet ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            CBDRetirerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            CBDDeposerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                end, function()
                end)
            if not RageUI.Visible(Ccbd) then
            Ccbd = RMenu:DeleteType("Ccbd", true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cbd' then
        local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
        local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, cbd.pos.coffre.position.x, cbd.pos.coffre.position.y, cbd.pos.coffre.position.z)
        if jobdist <= 10.0 and cbd.marker then
            Timer = 0
            DrawMarker(20, cbd.pos.coffre.position.x, cbd.pos.coffre.position.y, cbd.pos.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 75, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if jobdist <= 1.0 then
                Timer = 0
                    RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au coffre", time_display = 1 })
                    if IsControlJustPressed(1,51) then
                    Coffrecbd()
                end   
            end
        end 
    Citizen.Wait(Timer)   
end
end)

itemstock = {}
function CBDRetirerobjet()
    local Stockcbd = RageUI.CreateMenu("Coffre", "CBD")
    ESX.TriggerServerCallback('icbd:getStockItems', function(items) 
    itemstock = items
   
    RageUI.Visible(Stockcbd, not RageUI.Visible(Stockcbd))
        while Stockcbd do
            Citizen.Wait(0)
                RageUI.IsVisible(Stockcbd, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", "", 2)
                                    TriggerServerEvent('icbd:getStockItem', v.name, tonumber(count))
                                    CBDRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(Stockcbd) then
            Stockcbd = RMenu:DeleteType("Coffre", true)
        end
    end
     end)
end

local PlayersItem = {}
function CBDDeposerobjet()
    local StockPlayer = RageUI.CreateMenu("Coffre", "CBD")
    ESX.TriggerServerCallback('icbd:getPlayerInventory', function(inventory)
        RageUI.Visible(StockPlayer, not RageUI.Visible(StockPlayer))
    while StockPlayer do
        Citizen.Wait(0)
            RageUI.IsVisible(StockPlayer, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('icbd:putStockItems', item.name, tonumber(count))
                                            CBDDeposerobjet()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(StockPlayer) then
                StockPlayer = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end

function OpenRecolte()
    local Recolte = RageUI.CreateMenu("Recolte CBD", "CBD")
    RageUI.Visible(Recolte, not RageUI.Visible(Recolte))
    while Recolte do
        Citizen.Wait(0)
        RageUI.IsVisible(Recolte, true, true, true, function()
                RageUI.ButtonWithStyle("Récolte de CBD", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    RageUI.CloseAll()
                    recolte()
                    end
                end)
        end)
    
        if not RageUI.Visible(Recolte) then
            Recolte = RMenu:DeleteType("Recolte", true)
            end
        end
    end

local recolteppossible = false
Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        while true do
            local Timer = 500
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local playerCoords = GetEntityCoords(PlayerPedId())
            zoneDistance = GetDistanceBetweenCoords(playerCoords, cbd.pos.recolte.position.x, cbd.pos.recolte.position.y, cbd.pos.recolte.position.z)
                if IsEntityAtCoord(PlayerPedId(), 0.0, -0.0, -0.0, 1.5, 1.5, 1.5, 0, 1, 0) then 
                    Timer = 0
                        if IsControlJustPressed(1, 51) then
                            OpenRecolte()
                        end
            end
            if zoneDistance ~= nil then
                if zoneDistance > 1.5 then
                    recolteppossible = false
                end
            end
        Wait(Timer)
    end    
end)

function recolte()
    if not recolteppossible then
        recolteppossible = true
    while recolteppossible do
        Citizen.Wait(2000)
        TriggerServerEvent('cbd:recolte')
    end
    else
        recolteppossible = false
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cbd' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, cbd.pos.recolte.position.x, cbd.pos.recolte.position.y, cbd.pos.recolte.position.z)
        if dist3 <= 10.0 and cbd.marker then
            Timer = 0
            DrawMarker(20, cbd.pos.recolte.position.x, cbd.pos.recolte.position.y, cbd.pos.recolte.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 75, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 1.5 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour récolter du CBD", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            OpenRecolte()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function Transformation()
    local Transformation = RageUI.CreateMenu("Transformation CBD", "CBD")
    RageUI.Visible(Transformation, not RageUI.Visible(Transformation))
    
    while Transformation do
        Citizen.Wait(0)
        RageUI.IsVisible(Transformation, true, true, true, function()
                RageUI.ButtonWithStyle("Faire des splif de CBD", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    RageUI.CloseAll()
                    transformationcbd()
                    end
                end)
        end)
    
        if not RageUI.Visible(Transformation) then
            Transformation = RMenu:DeleteType("Transformation", true)
            end
        end
    end

local transformationpossible = false
Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        while true do
            local Timer = 500
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local playerCoords = GetEntityCoords(PlayerPedId())
            zoneDistance = GetDistanceBetweenCoords(playerCoords, cbd.pos.traitement.position.x, cbd.pos.traitement.position.y, cbd.pos.traitement.position.z)
                if IsEntityAtCoord(PlayerPedId(), 0.0, -0.0, -0.0, 1.5, 1.5, 1.5, 0, 1, 0) then 
                    Timer = 0
                        if IsControlJustPressed(1, 51) then
                            Transformation()
                        end
                    end
                    if zoneDistance ~= nil then
                        if zoneDistance > 1.5 then
                            transformationpossible = false
                        end
                    end
                Wait(Timer)
            end    
        end)

Citizen.CreateThread(function()
            while true do
                local Timer = 500
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cbd' then
                local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, cbd.pos.traitement.position.x, cbd.pos.traitement.position.y, cbd.pos.traitement.position.z)
                if dist3 <= 10.0 and cbd.marker then
                    Timer = 0
                    DrawMarker(20, cbd.pos.traitement.position.x, cbd.pos.traitement.position.y, cbd.pos.traitement.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 75, 0, 255, 0, 1, 2, 0, nil, nil, 0)
                    end
                    if dist3 <= 1.5 then
                        Timer = 0   
                                RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour traiter", time_display = 1 })
                                if IsControlJustPressed(1,51) then           
                                    Transformation()
                            end   
                        end
                    end 
                Citizen.Wait(Timer)
            end
        end)

function transformationcbd()
    if not transformationpossible then
        transformationpossible = true
    while transformationpossible do
        Citizen.Wait(2000)
        TriggerServerEvent('cbd:transformation')
    end
    else
        transformationpossible = false
    end
end

function OpenVente()
    local cbdVente = RageUI.CreateMenu("Vente de split", "CBD")
    
    RageUI.Visible(cbdVente, not RageUI.Visible(cbdVente))
    
    while cbdVente do
        Citizen.Wait(0)
        RageUI.IsVisible(cbdVente, true, true, true, function()
                RageUI.ButtonWithStyle("Vendre les split", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    RageUI.CloseAll()
                    ventecbd()
                    end
                end)
    end)  

        if not RageUI.Visible(cbdVente) then
            cbdVente = RMenu:DeleteType("cbdVente", true)
            end
        end
    end

    local ventepossible = false
    Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            while true do
                local Timer = 500
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local playerCoords = GetEntityCoords(PlayerPedId())
                zoneDistance = GetDistanceBetweenCoords(playerCoords, cbd.pos.vente.position.x, cbd.pos.vente.position.y, cbd.pos.vente.position.z)
                    if IsEntityAtCoord(PlayerPedId(), 0.0, -0.0, -0.0, 1.5, 1.5, 1.5, 0, 1, 0) then 
                        Timer = 0
                            if IsControlJustPressed(1, 51) then
                                OpenVente()
                            end
                end
                if zoneDistance ~= nil then
                    if zoneDistance > 1.5 then
                        ventepossible = false
                    end
                end
            Wait(Timer)
        end    
    end)

    function ventecbd()
        if not ventepossible then
            ventepossible = true
        while ventepossible do
            Citizen.Wait(2000)
            TriggerServerEvent('vente')
        end
        else
            ventepossible = false
        end
    end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cbd' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, cbd.pos.vente.position.x, cbd.pos.vente.position.y, cbd.pos.vente.position.z)
        if dist3 <= 7.0 and cbd.marker then
            Timer = 0
            DrawMarker(20, cbd.pos.vente.position.x, cbd.pos.vente.position.y, cbd.pos.vente.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 75, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour vendre les splif", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            OpenVente()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)


Citizen.CreateThread(function()
    if cbd.blips then
        local cbdmap = AddBlipForCoord(cbd.pos.blips.position.x, cbd.pos.blips.position.y, cbd.pos.blips.position.z)

        SetBlipSprite(cbdmap, 140)
        SetBlipColour(cbdmap, 2)
        SetBlipScale(cbdmap, 0.65)
        SetBlipAsShortRange(cbdmap, true)
        BeginTextCommandSetBlipName('String')
        AddTextComponentString("CBD")
        EndTextCommandSetBlipName(cbdmap)
    end
end)   

RegisterNetEvent('icbd:SmokeSplif')
AddEventHandler('icbd:SmokeSplif', function()
    RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
    while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
        Citizen.Wait(1)
        ESX.ShowNotification('Si vous fumez attention au volant..')
    end
    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_SMOKING_POT", 0, true)
    Citizen.Wait(15000)
    DoScreenFadeOut(10000)
    Citizen.Wait(5000)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
    SetPedIsDrunk(GetPlayerPed(-1), true)
    DoScreenFadeIn(1000)
    Citizen.Wait(600000)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
    SetPedIsDrunk(GetPlayerPed(-1), false)
    SetPedMotionBlur(GetPlayerPed(-1), false)
end)