local QBCore = exports['qb-core']:GetCoreObject()
peds = {}
m=0
props = {}
PlayerJob = {}
trunkpos = {}
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job end) end)
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo end)
RegisterNetEvent('QBCore:Client:SetDuty', function(duty) onDuty = duty end)
AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job end)
end)

Citizen.CreateThread(function()
	for k, v in pairs(Config.Locations) do
        m = math.random(1, #v["coords"]) -- generate a random coordinate
        if not v["hideblip"] then -- Create blip if set to false
            StoreBlip = AddBlipForCoord(b)
            SetBlipSprite(StoreBlip, v["blipsprite"])
            SetBlipScale(StoreBlip, 0.7)
            SetBlipDisplay(StoreBlip, 6)
            SetBlipColour(StoreBlip, v["blipcolour"])
            SetBlipAsShortRange(StoreBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v["label"])
            EndTextCommandSetBlipName(StoreBlip)
        end
        local i = math.random(1, #v["model"]) -- Get random ped model
        RequestModel(v["model"][i]) while not HasModelLoaded(v["model"][i]) do Wait(0) end
        if peds[k] == nil then peds[k] = CreatePed(0, v["model"][i], v["coords"][m].x, v["coords"][m].y, v["coords"][m].z -1, v["coords"][m].a, false, false) end
        SetEntityInvincible(peds[k], true)
        SetBlockingOfNonTemporaryEvents(peds[k], true)
        FreezeEntityPosition(peds[k], true)
        SetEntityNoCollisionEntity(peds[k], PlayerPedId(), false)
        if Config.Debug then print("Ped Created for Shop - ['"..k.."']") end

        if Config.Debug then print("Shop - ['"..k.."']") end
        if Config.OpenWithItem then
            exports['qb-target']:AddCircleZone("['"..k.."']", vector3(v["coords"][m].x, v["coords"][m].y, v["coords"][m].z), 1.5, { name="['"..k.."']", debugPoly=Config.Debug, useZ=true, },{ options = { { event = "ik-illegalweapon:client:ChoiseMenu", icon = "fas fa-certificate", label = Lang:t("target.browse"), item = Config.ItemName, shoptable = v, name = v["label"],  }, }, distance = 2.0 })
        else
            exports['qb-target']:AddCircleZone("['"..k.."']", vector3(v["coords"][m].x, v["coords"][m].y, v["coords"][m].z), 1.5, { name="['"..k.."']", debugPoly=Config.Debug, useZ=true, },{ options = { { event = "ik-illegalweapon:client:ChoiseMenu", icon = "fas fa-certificate", label = Lang:t("target.browse"), shoptable = v, name = v["label"],  }, }, distance = 2.0 })
        end
    end
end)

local function scratchserie(weapon,ammo)
    TaskStartScenarioInPlace(ped, 'PROP_HUMAN_PARKING_METER')
    QBCore.Functions.Progressbar("search_register", Lang:t("choisemenu.scratching"), math.random(3500,6500) , false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(ped)
        TriggerServerEvent('ik-illegalweapon:server:scratch', weapon, ammo)
    end, function()
        ClearPedTasks(ped)
    end) -- Cancel
end

RegisterNetEvent('ik-illegalweapon:client:ChoiseMenu', function(data)
    local data = data
    local settext = "- "..Lang:t("choisemenu.what").." -<br><br>"
    local header = data.shoptable["label"]
    local newinputs = {}
    newinputs[#newinputs+1] = { type = 'radio', name = 'choisemenu', text = settext, options = { { value = "scratch", text = Lang:t("choisemenu.scratch").."<br>($"..Config.ScratchPrice..")" }, { value = "buy", text = Lang:t("choisemenu.buyweapon").."<br>" } } }
    local dialog = exports['qb-input']:ShowInput({ header = header, submitText = Lang:t("choisemenu.confirm"), inputs = newinputs })
    if dialog then
        if dialog.choisemenu == "buy" then TriggerEvent("ik-illegalweapon:client:ShopMenu", data)
        elseif dialog.choisemenu == "scratch" then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
            local weaponammo = GetAmmoInPedWeapon(ped, weapon)
            if weapon == `WEAPON_UNARMED` then
                QBCore.Functions.Notify(Lang:t("error.noweapon"), 'error')
            else
                if Config.UseScratchItem and QBCore.Functions.HasItem(Config.ScratchItem) then
                    scratchserie(weapon, weaponammo)
                else
                    scratchserie(weapon, weaponammo)
                end
            end
        end
    end
end)

RegisterNetEvent('ik-illegalweapon:client:ShopMenu', function(data)
	local products = data.shoptable.products
	local WeaponMenu = {}
	WeaponMenu[#WeaponMenu + 1] = { header = data.shoptable["label"], txt = "", isMenuHeader = true }
	WeaponMenu[#WeaponMenu + 1] = { header = "", txt = Lang:t("menu.close"), params = { event = "ik-illegalweapon:client:CloseMenu" } }

	for i = 1, #products do
		local amount = nil
		local lock = false
		if products[i].price == 0 then
			price = "Free"
		else
			if Config.UseBlackMoney then
				totalprice = (products[i].price * Config.BlackMoneyMultiplier)
				price = Lang:t("menu.cost")..(products[i].price * Config.BlackMoneyMultiplier) 
			else
				totalprice = products[i].price
				price = Lang:t("menu.cost")..products[i].price
			end
		end

		local setheader = "<img src=nui://"..Config.img..QBCore.Shared.Items[products[i].name].image.." width=35px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items[tostring(products[i].name)].label
		local text = price.."<br>"..Lang:t("menu.weight").." "..(QBCore.Shared.Items[products[i].name].weight / 1000).." kg"
		if products[i].requiredGang then
			for i2 = 1, #products[i].requiredGang do
				if QBCore.Functions.GetPlayerData().job.name == products[i].requiredGang[i2] then
					WeaponMenu[#WeaponMenu + 1] = { icon = products[i].name, header = setheader, txt = text, isMenuHeader = lock,
						params = { event = "ik-illegalweapon:client:Charge", args = { item = products[i].name, cost = totalprice, sp = products[i].scratchprice, info = products[i].info, shoptable = data.shoptable, amount = amount } } }
				end
			end
		else
			WeaponMenu[#WeaponMenu + 1] = { icon = products[i].name, header = setheader, txt = text, isMenuHeader = lock,
					params = { event = "ik-illegalweapon:client:Charge", args = {
									item = products[i].name,
									cost = totalprice,
                                    sp = products[i].scratchprice,
									info = products[i].info,
									shoptable = data.shoptable,
									amount = amount,
								} } }
		end
		text, setheader = nil
	end
	exports['qb-menu']:openMenu(WeaponMenu)
end)

RegisterNetEvent('ik-illegalweapon:client:CloseMenu', function() exports['qb-menu']:closeMenu() end)

RegisterNetEvent('ik-illegalweapon:client:Charge', function(data)
	if data.cost == "Free" then price = data.cost else price = "$"..data.cost end
	if QBCore.Shared.Items[data.item].weight == 0 then weight = "" else weight = Lang:t("menu.weight").." "..(QBCore.Shared.Items[data.item].weight / 1000).." kg" end
	local settext = "- "..Lang:t("menu.confirm").." -<br><br>"
	settext = settext..weight.."<br> "..Lang:t("menu.cpi").." "..price.."<br>"..Lang:t("menu.sp").." "..data.sp.. "<br><br>- "..Lang:t("menu.payment_type").." -"
	local header = "<center><p><img src=nui://"..Config.img..QBCore.Shared.Items[data.item].image.." width=100px></p>"..QBCore.Shared.Items[data.item].label
	if data.shoptable["logo"] ~= nil then header = "<center><p><img src="..data.shoptable["logo"].." width=150px></img></p>"..header end

	local newinputs = {}
	if Config.UseBlackMoney then
		newinputs[#newinputs+1] = { type = 'radio', name = 'billtype', text = settext, options = { { value = "blackmoney", text = Lang:t("menu.blackmoney") } } }
	else
		newinputs[#newinputs+1] = { type = 'radio', name = 'billtype', text = settext, options = { { value = "cash", text = Lang:t("menu.cash") }, { value = "bank", text = Lang:t("menu.card") } } }
	end
	newinputs[#newinputs+1] = { type = 'number', isRequired = true, name = 'amount', text = Lang:t("menu.amount") }

	local dialog = exports['qb-input']:ShowInput({ header = header, submitText = Lang:t("menu.submittext"), inputs = newinputs })
	if dialog then
		if not dialog.amount then return end
		if tonumber(dialog.amount) <= 0 then TriggerEvent("QBCore:Notify", Lang:t("error.incorrect_amount"), "error") TriggerEvent("ik-illegalweapon:client:Charge", data) return end
		if data.cost == "Free" then data.cost = 0 end
        local totalpr = data.cost + data.sp
		TriggerServerEvent('ik-illegalweapon:server:GetItem', dialog.amount, dialog.billtype, data.item, data.shoptable, totalpr)
		RequestAnimDict('amb@prop_human_atm@male@enter')
        while not HasAnimDictLoaded('amb@prop_human_atm@male@enter') do Wait(1) end
        if HasAnimDictLoaded('amb@prop_human_atm@male@enter') then TaskPlayAnim(PlayerPedId(), 'amb@prop_human_atm@male@enter', "enter", 1.0,-1.0, 1500, 1, 1, true, true, true) end
	end
end)

AddEventHandler('onResourceStop', function(resource) if resource ~= GetCurrentResourceName() then return end
    for k, v in pairs(Config.Locations) do exports['qb-target']:RemoveZone("['"..k.."']") end
	for k, v in pairs(peds) do DeletePed(peds[k]) end
	for k, v in pairs(props) do DeleteEntity(props[k]) end
end)