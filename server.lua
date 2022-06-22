local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('ik-illegalweapon:client:GetItem', function(amount, billtype, item, shoptable, price)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local BlackMoneyName = Config.BlackMoneyName
	if billtype == "blackmoney" then
		if BlackMoneyName == "markedbills" then
			Balance = getMarkedBillWorth()
		else
			Balance = Player.Functions.GetItemByName(BlackMoneyName).amount
		end
	else
		Balance = Player.Functions.GetMoney(tostring(billtype))
	end
    if Balance <= (tonumber(price) * tonumber(amount)) then
        TriggerClientEvent("QBCore:Notify", src, Lang:t("error.no_money"), "error") return
    end
    for i = 1, amount do
        local info = {
            ammo = weaponammo,
            serie="xxxxxx"
        }
        if Player.Functions.AddItem(item, 1, false, info) then
            if tonumber(i) == tonumber(amount) then
                if Config.UseBlackMoney and BlackMoneyName == "markedbills" then
                    payByMarkedBills(Balance,price)
                else
                    Player.Functions.RemoveMoney(tostring(billtype), (tonumber(price) * tonumber(amount)), 'shop-payment')
                end
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.cant_give"), "error") break
        end
        Wait(5)
    end
	local data = {}
	data.shoptable = shoptable
	if Config.RemoveItem then
		local itemused = Config.ItemName
		Player.Functions.RemoveItem(itemused, 1)
	else
		TriggerClientEvent('ik-illegalweapon:client:ShopMenu', src, data)
	end
end)

RegisterNetEvent('ik-illegalweapon:client:scratch', function(weapon, weaponammo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local weaponInfo = QBCore.Shared.Weapons[weapon]
    local weaponName = weaponInfo["name"]
    local price = Config.ScratchPrice
    if Config.UseBlackMoney then
        if BlackMoneyName == "markedbills" then
			Balance = getMarkedBillWorth()
		else
			Balance = Player.Functions.GetItemByName(BlackMoneyName).amount
		end
	else
		Balance = Player.Functions.GetMoney("bank")
	end
    if Balance <= tonumber(price) then
        TriggerClientEvent("QBCore:Notify", src, Lang:t("error.no_money"), "error") return
    end
    if weaponInfo then
        weaponInfo = Player.Functions.GetItemByName(weaponName)
        if weaponInfo then
            local info = {
                ammo = weaponammo,
                serie="xxxxxx"
            }
            for k, v in pairs(Player.PlayerData.items) do
                if v.info.serie == weaponInfo.info.serie then
                    if v.info.serie ~= "xxxxxx" then
                        if Config.UseBlackMoney and BlackMoneyName == "markedbills" then
                            payByMarkedBills(Balance,price)
                        else
                            Player.Functions.RemoveMoney("bank", tonumber(price), 'shop-payment')
                        end
                        Player.Functions.RemoveItem(weaponName, 1)
                        Player.Functions.AddItem(weaponName, 1, weaponInfo.slot, info)
                    else
                        TriggerClientEvent("QBCore:Notify", src, Lang:t("error.no_serie"), "error") return
                    end
                end
            end
        end
    end
end)

function getMarkedBillWorth() 
	local Player = QBCore.Functions.GetPlayer(source)
	local markedbilltotal = 0 
	for k, v in pairs(Player.PlayerData.items) do
		if v.name == "markedbills" then
			markedbilltotal = markedbilltotal + v.info.worth
		end
	end
	return markedbilltotal
end

function payByMarkedBills(balance, price)
	local Player = QBCore.Functions.GetPlayer(source)
	local newworth = balance - price
	info = {
		worth = newworth
	}
	for k, v in pairs(Player.PlayerData.items) do
		if v.name == "markedbills" then
			Player.Functions.RemoveItem("markedbills", 1, false)
		end
	end
	Player.Functions.AddItem("markedbills", 1 , false ,info)
end