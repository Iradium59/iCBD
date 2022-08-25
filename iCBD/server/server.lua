ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


TriggerEvent('esx_phone:registerNumber', 'cbd', 'alerte cbd', true, true)
TriggerEvent('esx_society:registerSociety', 'cbd', 'cbd', 'society_cbd', 'society_cbd', 'society_cbd', {type = 'private'})


ESX.RegisterServerCallback('icbd:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cbd', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('icbd:getStockItem')
AddEventHandler('icbd:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cbd', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'Objet retiré', count, inventoryItem.label)
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('icbd:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('icbd:putStockItems')
AddEventHandler('icbd:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cbd', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, inventoryItem.name))
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local _source = source

	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)

		-- Is it worth telling all clients to refresh?
		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'cbd' then
			Citizen.Wait(5000)
			TriggerClientEvent('esx_cbdjob:updateBlip', -1)
		end
	end
end)

RegisterServerEvent('esx_cbdjob:spawned')
AddEventHandler('esx_cbdjob:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'cbd' then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_cbdjob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_cbdjob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'cbd')
	end
end)

RegisterServerEvent('esx_cbdjob:message')
AddEventHandler('esx_cbdjob:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)

RegisterServerEvent('AnnoncecbdOuvert')
AddEventHandler('AnnoncecbdOuvert', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'cbd', '~g~Annonce', 'Venez faire vos courses !', 'HC_N_KAR', 8)
	end
end)

RegisterServerEvent('AnnoncecbdFermer')
AddEventHandler('AnnoncecbdFermer', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'cbd', '~g~Annonce', 'Le cbd est désormais fermé à plus tard!', 'HC_N_KAR', 8)
	end
end)

RegisterServerEvent('cbd:prendreitems')
AddEventHandler('cbd:prendreitems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cbd', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'Objet retiré', count, inventoryItem.label)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
		end
	end)
end)


RegisterNetEvent('cbd:stockitem')
AddEventHandler('cbd:stockitem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cbd', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, "Objet déposé "..count..""..inventoryItem.label.."")
		else
			TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
		end
	end)
end)


ESX.RegisterServerCallback('cbd:inventairejoueur', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('cbd:prendreitem', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cbd', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('cbd:getArmoryWeapons', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_cbd', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('cbd:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_cbd', function(store)
		local weapons = store.get('weapons') or {}
		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('cbd:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_cbd', function(store)
		local weapons = store.get('weapons') or {}

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

RegisterNetEvent('cbd:recolte')
AddEventHandler('cbd:recolte', function()
    local item = "cbd"
    local limiteitem = 50
    local xPlayer = ESX.GetPlayerFromId(source)
    local nbitemdansinventaire = xPlayer.getInventoryItem(item).count
    

    if nbitemdansinventaire >= limiteitem then
        TriggerClientEvent('esx:showNotification', source, "T\'as pas assez de place dans ton inventaire !")
    else
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('esx:showNotification', source, "Récolte en cours...")
    end
end)

RegisterNetEvent('cbd:transformation')
AddEventHandler('cbd:transformation', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local cbd = xPlayer.getInventoryItem('cbd').count
    local splif = xPlayer.getInventoryItem('splif').count

    if splif > 50 then
        TriggerClientEvent('esx:showNotification', source, '~r~Il semble que tu ne puisses plus porter de splif ...')
    elseif cbd < 5 then
        TriggerClientEvent('esx:showNotification', source, '~r~Pas assez de cbd a transformer...')
    else
        xPlayer.removeInventoryItem('cbd', 5)
        xPlayer.addInventoryItem('splif', 1)    
    end
end)

ESX.RegisterUsableItem('splif', function(source)

	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
  
	xPlayer.removeInventoryItem('splif', 1)
	
	TriggerClientEvent('icbd:SmokeSplif', _source)
	TriggerClientEvent('esx_status:add', source, 'thirst', -80000)
	TriggerClientEvent('esx_status:add', source, 'hunger', -80000)
	TriggerClientEvent('esx:showNotification', source, 'Vous fumez un splif de CBD')
	TriggerClientEvent('esx_status:add', source, 'drunk', 150000)
  
end)

RegisterNetEvent('vente')
AddEventHandler('vente', function()

    local money = math.random(100,200)
    local xPlayer = ESX.GetPlayerFromId(source)
    local societyAccount = nil
    local splif = 0

    if xPlayer.getInventoryItem('splif').count <= 0 then
        splif = 0
    else
        splif = 1
    end

    if splif == 0 then
        TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Pas assez de splif pour vendre...')
        return
    elseif xPlayer.getInventoryItem('splif').count <= 0 and argent == 0 then
        TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Pas assez de splif pour vendre...')
        splif = 0
        return
    elseif splif == 1 then
        local money = math.random(cbd.ventemin,cbd.ventemax)
        xPlayer.removeInventoryItem('splif', 1)
		local societyAccount = nil

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cbd', function(account)
			societyAccount = account
		end)
		if societyAccount ~= nil then
			societyAccount.addMoney(money)
			xPlayer.addMoney(cbd.argentjoueur)
			TriggerClientEvent('esx:showNotification', source, "~g~Vendue avec sucess...")
		end
	end
end) 
