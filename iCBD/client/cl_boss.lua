ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societycbdmoney = nil

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


---------------- FONCTIONS ------------------

function Bosscbd()
    local Bcbd = RageUI.CreateMenu("Actions Patron", "CBD")
  
      RageUI.Visible(Bcbd, not RageUI.Visible(Bcbd))
  
              while Bcbd do
                  Citizen.Wait(0)
                      RageUI.IsVisible(Bcbd, true, true, true, function()
  
            if societycbdmoney ~= nil then
                RageUI.ButtonWithStyle("Argent société :", nil, {RightLabel = "$" .. societycbdmoney}, true, function()
                end)
            end

            RageUI.ButtonWithStyle("Retirer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "Montant invalide"})
                    else
                        TriggerServerEvent('esx_society:withdrawMoney', 'cbd', amount)
                        RefreshcbdMoney()
                    end
                end
            end)

            RageUI.ButtonWithStyle("Déposer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "Montant invalide"})
                    else
                        TriggerServerEvent('esx_society:depositMoney', 'cbd', amount)
                        RefreshcbdMoney()
                    end
                end
            end) 

           RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    MenuBosscbd()
                    RageUI.CloseAll()
                end
            end)


        end, function()
        end)
        if not RageUI.Visible(Bcbd) then
        Bcbd = RMenu:DeleteType("Bcbd", true)
    end
end
end

----------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cbd' and ESX.PlayerData.job.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, cbd.pos.boss.position.x, cbd.pos.boss.position.y, cbd.pos.boss.position.z)
        if dist3 <= 7.0 and cbd.marker then
            Timer = 0
            DrawMarker(20, cbd.pos.boss.position.x, cbd.pos.boss.position.y, cbd.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 75, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder aux actions patron", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            RefreshcbdMoney()           
                            Bosscbd()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshcbdMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietycbdMoney(money)
        end, ESX.PlayerData.job.name)
    end
end

function UpdateSocietycbdMoney(money)
    societycbdmoney = ESX.Math.GroupDigits(money)
end

function MenuBosscbd()
    TriggerEvent('esx_society', 'cbd', false, false)
end