-- SpectreWare | Build An Ant Empire (SpectreUI)
local function initializeHub()
	repeat
		task.wait()
	until game:IsLoaded()
	if makefolder then
		for folderIndex, folderPath in ipairs({ "SpectreWare", "SpectreWare/AntEmpire" }) do
			pcall(makefolder, folderPath)
		end
	end
	local playersService = game:GetService("Players")
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local httpService = game:GetService("HttpService")
	local localPlayer = playersService.LocalPlayer
	local sharedEnvironment = getgenv and getgenv() or _G
	if sharedEnvironment.NOPE_HUB_UI_CLEANUP then
		pcall(sharedEnvironment.NOPE_HUB_UI_CLEANUP)
	end
	local gameContext = require(replicatedStorage.Battle.Game.Context)
	local eventBus = require(replicatedStorage.Packages.EventBus)
	local playerDataHelper = gameContext.Helper.PlayerDataHelper
	local roomHelper = gameContext.Helper.RoomHelper
	local rollPresentationHelper = require(replicatedStorage.Battle.Game.Helper.RollPresentationHelper)
	local backpackModel = require(replicatedStorage.UI.Backpack.Model.BackpackModel)
	local playerData = require(replicatedStorage.UI._global.PlayerData)
	local modelContext = { Ecs = { Context = gameContext }, PlayerData = playerData }
	local gearShopModel = require(replicatedStorage.UI.GearShop.Model.GearShopModel)
	local compostModel = require(replicatedStorage.UI.Compost.Model.CompostModel)
	local rideState = require(replicatedStorage.UI.Ride.Model.State)
	local tameState = require(replicatedStorage.UI.TamePanel.Model.State)
	local autoToolState = require(replicatedStorage.UI.AutoUserTool.Model.State)
	local onlineRewardState = require(replicatedStorage.UI.OnlineReward.Model.OnlineState)
	local sevenDayState = require(replicatedStorage.UI["7DAY"].Model.SevenDayState)
	local indexModel = require(replicatedStorage.UI.Index.Model.IndexModel)
	local blackMarket = require(replicatedStorage.Battle.Game.Helper.Activities.BlackMarket)
	local vineConfig = require(replicatedStorage.Battle.Game.Helper.Activities.Vine.Config)
	local activityState = require(replicatedStorage.UI.ActivityEvent.Model.State)
	local clickBoost = require(replicatedStorage.Battle.Game.Dungeon.ClickBoost)
	local dungeonConfig = require(replicatedStorage.Battle.Game.Config.DungeonConfig)
	local activityScheduleConfig = require(replicatedStorage.Battle.Game.Helper.Activities.ActivityScheduleConfig)
	local antFoodStore = require(replicatedStorage.WuKongHooks.AntFoodStore)
	local wuKong = require(replicatedStorage.WuKong)
	local purchaseGuard = { Active = true, Blocked = 0 }
	local executeQueryTarget = wuKong.ExecuteQuery
	local originalExecuteQuery
	originalExecuteQuery = hookfunction(executeQueryTarget, function(querySelf, queryPath, ...)
		if
			purchaseGuard.Active
			and type(queryPath) == "string"
			and string.find(queryPath, "弹出购买窗口", 1, true)
		then
			purchaseGuard.Blocked += 1
			return false
		end
		return originalExecuteQuery(querySelf, queryPath, ...)
	end)
	local function restorePurchaseQuery()
		if purchaseGuard.Active then
			purchaseGuard.Active = false
			restorefunction(executeQueryTarget)
		end
	end
	if STATE then
		STATE.onCleanup(restorePurchaseQuery)
	end
	local ecsWorld, replicationState
	for connectionIndex, replicationConnection in ipairs(getconnections(replicatedStorage.MatterDiff.OnClientEvent)) do
		if replicationConnection.Function then
			for upvalueIndex, upvalue in pairs(debug.getupvalues(replicationConnection.Function)) do
				if type(upvalue) == "table" then
					if upvalue._storages then
						ecsWorld = upvalue
					end
					if upvalue.LocalPlayerAttributes then
						replicationState = upvalue
					end
				end
			end
		end
	end
	assert(ecsWorld and replicationState, "Game replication is not ready")
	gearShopModel:Init()
	indexModel:Init()
	rideState:Load()
	activityState:Load()
	setthreadidentity(8)
	local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SpectreWareZ/SpectreWare/refs/heads/main/Tools/Ui/SpectreUI.lua"))()
	local window = Library:CreateWindow({
		Title = "SpectreWare | Build An Ant Empire",
		ToggleKey = Enum.KeyCode.RightShift,
		Logo = 84699118856259,
		Splash = { Title = "SPECTREWARE", Subtitle = "BUILD AN ANT EMPIRE", Duration = 2.5, Logo = 84699118856259 },
	})
	local uiDestroyed = false
	local function destroyUi()
		if uiDestroyed then
			return
		end
		uiDestroyed = true
		pcall(function()
			window:Destroy()
		end)
	end
	local initialCleanup = function()
		restorePurchaseQuery()
		setthreadidentity(8)
		destroyUi()
	end
	sharedEnvironment.NOPE_HUB_UI_CLEANUP = initialCleanup
	if STATE then
		STATE.onCleanup(initialCleanup)
	end
	local tabs, sections, currentSection = {}, {}, {}
	for tabIndex, tabDefinition in ipairs({
		{ "Autofarm", "leaf" },
		{ "Upgrades", "trending-up" },
		{ "Resource Converter", "recycle" },
		{ "Trash", "trash-2" },
		{ "Dungeon", "swords" },
		{ "Events", "star" },
		{ "Gear", "shopping-cart" },
		{ "Potions", "flask-conical" },
		{ "Ride", "car" },
		{ "Rewards", "gift" },
		{ "Settings", "settings" },
	}) do
		tabs[tabDefinition[1]] = window:CreateTab({ Name = tabDefinition[1], Icon = "lucide:" .. tabDefinition[2] })
	end
	local function useSection(tabName, sectionName)
		currentSection[tabName] = sectionName
	end
	local function sectionFor(tabName)
		local sectionName = currentSection[tabName] or tabName
		local sectionKey = tabName .. "/" .. sectionName
		if not sections[sectionKey] then
			sections[sectionKey] = tabs[tabName]:CreateSection({ Name = sectionName })
		end
		return sections[sectionKey]
	end
	local running = true
	local hubSettings, options, jobs, jobErrors, jobCounts, connections = {}, {}, {}, {}, {}, {}
	local configPath = "SpectreWare/AntEmpire/" .. tostring(localPlayer.UserId) .. ".json"
	local loadingConfig = false
	local configStore = { Version = 2, Profiles = {}, AutoLoad = "" }
	if isfile(configPath) then
		local configReadOk, savedConfig = pcall(function()
			return httpService:JSONDecode(readfile(configPath))
		end)
		if configReadOk and type(savedConfig) == "table" then
			if savedConfig.Version == 2 and type(savedConfig.Profiles) == "table" then
				configStore = savedConfig
			elseif savedConfig.Version == 1 and type(savedConfig.Settings) == "table" then
				configStore.Profiles.Default = savedConfig.Settings
			end
		end
	end
	local selectedProfile, profileNameInput = nil, ""
	local profileDropdown
	local function writeConfigStore()
		writefile(configPath, httpService:JSONEncode(configStore))
	end
	local function onSettingChangedNoop() end
	local function notifyConfig(notificationText)
		window:Info("Config", notificationText, 3)
	end
	local function refreshProfileDropdown()
		local profileNames = {}
		for storedProfileName in pairs(configStore.Profiles) do
			table.insert(profileNames, storedProfileName)
		end
		table.sort(profileNames)
		if profileDropdown then
			profileDropdown:SetValues(profileNames)
			if selectedProfile then
				profileDropdown:SetValue(selectedProfile)
			end
		end
	end
	local function snapshotSettings()
		local settingsSnapshot = {}
		for optionKey, optionControl in pairs(options) do
			if optionControl.Type == "Input" then
				settingsSnapshot[optionKey] = tonumber(optionControl.Value) or hubSettings[optionKey]
			else
				settingsSnapshot[optionKey] = optionControl.Value
			end
		end
		return httpService:JSONDecode(httpService:JSONEncode(settingsSnapshot))
	end
	local function createProfile(newProfileName)
		newProfileName = tostring(newProfileName or profileNameInput):match("^%s*(.-)%s*$")
		assert(
			newProfileName ~= "" and newProfileName ~= "None" and #newProfileName <= 64,
			"Enter a config name (1-64 characters)"
		)
		assert(not configStore.Profiles[newProfileName], "Config already exists; use Overwrite Config")
		configStore.Profiles[newProfileName] = snapshotSettings()
		writeConfigStore()
		selectedProfile = newProfileName
		refreshProfileDropdown()
		notifyConfig("Created: " .. newProfileName)
	end
	local function saveProfile(saveProfileName)
		saveProfileName = saveProfileName or selectedProfile
		assert(saveProfileName and configStore.Profiles[saveProfileName], "Select a config first")
		configStore.Profiles[saveProfileName] = snapshotSettings()
		writeConfigStore()
		notifyConfig("Saved: " .. saveProfileName)
	end
	local function setAutoLoadProfile(autoLoadProfileName)
		autoLoadProfileName = autoLoadProfileName == "None" and "" or autoLoadProfileName
		assert(autoLoadProfileName == "" or configStore.Profiles[autoLoadProfileName], "Config does not exist")
		configStore.AutoLoad = autoLoadProfileName
		writeConfigStore()
		refreshProfileDropdown()
		notifyConfig(autoLoadProfileName == "" and "Auto load disabled" or "Auto load: " .. autoLoadProfileName)
	end
	local function loadProfile(loadProfileName)
		loadProfileName = loadProfileName or selectedProfile
		assert(loadProfileName and type(configStore.Profiles[loadProfileName]) == "table", "Select a config first")
		local profileData = { Settings = configStore.Profiles[loadProfileName] }
		loadingConfig = true
		local loadOk, loadError = pcall(function()
			setthreadidentity(8)
			for loadPassIndex, loadJobToggles in ipairs({ false, true }) do
				for loadedSettingKey, loadedSettingValue in pairs(profileData.Settings) do
					if loadedSettingKey == "PotionTarget" and loadedSettingValue == "Selected Slots" then
						loadedSettingValue = "Select Ant"
					end
					local loadedOption = options[loadedSettingKey]
					if loadedOption and (jobs[loadedSettingKey] ~= nil) == loadJobToggles then
						if jobs[loadedSettingKey] then
							if type(loadedSettingValue) == "boolean" then
								loadedOption:SetValue(loadedSettingValue)
							end
						elseif loadedOption.Values then
							if type(loadedSettingValue) == "table" then
								local validSelections = {}
								for selectionValue, selectionEnabled in pairs(loadedSettingValue) do
									if selectionEnabled == true and table.find(loadedOption.Values, selectionValue) then
										validSelections[selectionValue] = true
									end
								end
								loadedOption:SetValue(validSelections)
							elseif table.find(loadedOption.Values, loadedSettingValue) then
								loadedOption:SetValue(loadedSettingValue)
							end
						elseif type(loadedSettingValue) == "number" then
							loadedOption:SetValue(tostring(loadedSettingValue))
						end
					end
				end
			end
		end)
		loadingConfig = false
		if not loadOk then
			error(loadError)
		end
		selectedProfile = loadProfileName
		refreshProfileDropdown()
	end
	local function isAlive()
		return running and not uiDestroyed and (not STATE or STATE.alive())
	end
	local function connectTracked(trackedSignal, trackedCallback)
		local trackedConnection = trackedSignal:Connect(trackedCallback)
		table.insert(connections, trackedConnection)
		return trackedConnection
	end
	local function sendCommand(commandName, commandPayload)
		if isAlive() then
			gameContext.SendCommand(commandName, commandPayload or {})
		end
	end
	local function getPlayerGold()
		return playerDataHelper.GetPlayerGold(localPlayer.UserId)
	end
	local pendingPurchase, nextPurchaseAt = nil, 0
	local function tryPurchase(completionEventOrPredicate, purchaseCost, purchaseCallback)
		if not isAlive() or pendingPurchase or os.clock() < nextPurchaseAt then
			return false
		end
		purchaseCost = tonumber(purchaseCost)
		if not purchaseCost or purchaseCost < 0 or getPlayerGold() < purchaseCost then
			return false
		end
		pendingPurchase = { Event = completionEventOrPredicate, Started = os.clock() }
		local purchaseOk, purchaseResult = pcall(purchaseCallback)
		if not purchaseOk or purchaseResult == false then
			pendingPurchase = nil
			nextPurchaseAt = os.clock() + 1
			if not purchaseOk then
				error(purchaseResult)
			end
			return false
		end
		if not completionEventOrPredicate then
			pendingPurchase = nil
			nextPurchaseAt = os.clock() + 0.75
		end
		return true
	end
	local function getLocalRoom()
		return roomHelper.GetLocalClientRoomObject()
	end
	local function getRootPart()
		return localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
	end
	local function teleportTo(targetPosition)
		local rootPart = getRootPart()
		if rootPart and typeof(targetPosition) == "Vector3" then
			localPlayer.Character:PivotTo(CFrame.new(targetPosition + Vector3.new(0, 3, 0)))
			return true
		end
		return false
	end
	local function toMap(selection)
		local selectionMap = {}
		if type(selection) == "table" then
			for selectionKey, selectionValue in pairs(selection) do
				if selectionValue == true then
					selectionMap[selectionKey] = true
				elseif type(selectionValue) == "string" then
					selectionMap[selectionValue] = true
				end
			end
		end
		return selectionMap
	end
	-- Fluent-style wrapper around a SpectreUI control (.Value / .Values / :SetValue / :SetValues / :OnChanged)
	local function newAdapter(controlType, isMulti, controlValues)
		local adapter = { Type = controlType, Multi = isMulti, Values = controlValues, Listeners = {} }
		function adapter:OnChanged(listener)
			table.insert(self.Listeners, listener)
		end
		function adapter:Fire(newValue)
			for listenerIndex, listener in ipairs(self.Listeners) do
				local listenerOk, listenerError = pcall(listener, newValue)
				if not listenerOk then
					warn("[SpectreWare] UI callback", listenerError)
				end
			end
		end
		function adapter:SetValue(newValue)
			local control = self.Control
			if not control then
				return
			end
			if self.Type == "Toggle" then
				newValue = newValue == true
				if control:Get() ~= newValue then
					control:Set(newValue)
				end
			elseif self.Type == "Input" then
				control:Set(tonumber(newValue) or newValue)
			else
				control:Set(newValue)
			end
		end
		function adapter:SetValues(newValues)
			local control = self.Control
			if not control or self.Type ~= "Dropdown" then
				return
			end
			self.Values = newValues
			control:Refresh(newValues, true)
			if self.Multi then
				control:Set(control:Get())
			end
		end
		return setmetatable(adapter, {
			__index = function(self, indexKey)
				if indexKey == "Value" then
					local control = rawget(self, "Control")
					if not control then
						return nil
					end
					local currentValue = control:Get()
					if self.Type == "Dropdown" and self.Multi then
						return toMap(currentValue)
					end
					return currentValue
				end
			end,
		})
	end
	local function addJobToggle(jobTab, jobKey, jobTitle, jobInterval, jobCallback, onJobDisable)
		setthreadidentity(8)
		hubSettings[jobKey] = false
		jobs[jobKey] =
			{ interval = jobInterval, callback = jobCallback, nextAt = 0, busy = false, onDisable = onJobDisable }
		local jobToggle = newAdapter("Toggle", false)
		jobToggle.Control = sectionFor(jobTab):CreateToggle({
			Name = jobTitle,
			Default = false,
			Flag = jobKey,
			Callback = function(toggleValue)
				jobToggle:Fire(toggleValue)
			end,
		})
		options[jobKey] = jobToggle
		jobToggle:OnChanged(function(toggleValue)
			hubSettings[jobKey] = toggleValue == true
			jobs[jobKey].nextAt = 0
			if not toggleValue and onJobDisable then
				pcall(onJobDisable)
			end
			onSettingChangedNoop()
		end)
	end
	local function addDropdown(dropdownTab, dropdownKey, dropdownTitle, dropdownValues, isMultiSelect, dropdownDefault)
		setthreadidentity(8)
		local dropdownControl = newAdapter("Dropdown", isMultiSelect == true, dropdownValues)
		dropdownControl.Control = sectionFor(dropdownTab):CreateDropdown({
			Name = dropdownTitle,
			Options = dropdownValues,
			Multi = isMultiSelect == true,
			Default = dropdownDefault,
			Flag = dropdownKey,
			Callback = function(dropdownValue)
				dropdownControl:Fire(isMultiSelect and toMap(dropdownValue) or dropdownValue)
			end,
		})
		hubSettings[dropdownKey] = dropdownControl.Value
		options[dropdownKey] = dropdownControl
		dropdownControl:OnChanged(function(dropdownValue)
			hubSettings[dropdownKey] = dropdownValue
			onSettingChangedNoop()
		end)
		return dropdownControl
	end
	local function addNumberInput(inputTab, inputKey, inputTitle, inputDefault)
		setthreadidentity(8)
		hubSettings[inputKey] = inputDefault
		local inputControl = newAdapter("Input", false)
		inputControl.Control = sectionFor(inputTab):CreateTextbox({
			Name = inputTitle,
			Default = inputDefault,
			Numeric = true,
			Min = 0,
			Flag = inputKey,
			Callback = function(inputValue)
				inputControl:Fire(inputValue)
			end,
		})
		options[inputKey] = inputControl
		inputControl:OnChanged(function(inputValue)
			hubSettings[inputKey] = math.max(tonumber(inputValue) or inputDefault, 0)
			onSettingChangedNoop()
		end)
	end
	local function addButton(buttonTab, buttonTitle, buttonCallback)
		setthreadidentity(8)
		sectionFor(buttonTab):CreateButton({
			Name = buttonTitle,
			Callback = function()
				local buttonOk, buttonError = pcall(buttonCallback)
				if not buttonOk then
					warn("[SpectreWare]", buttonTitle, buttonError)
					window:Error(buttonTitle, tostring(buttonError), 5)
				end
			end,
		})
	end
	local function getDungeonSnapshot()
		local dungeonClient = replicationState.Core and replicationState.Core.DungeonClient
		local dungeonEntityId = dungeonClient and dungeonClient.EntityId
		local dungeonComponent = dungeonEntityId
			and ecsWorld:contains(dungeonEntityId)
			and ecsWorld:get(dungeonEntityId, gameContext.Components.DungeonClient)
		return dungeonComponent and dungeonComponent.Snapshot, dungeonClient
	end
	local function claimWorkerFood()
		local foodSlotsOk, foodSlots = antFoodStore.GetSlots(localPlayer.UserId)
		if not foodSlotsOk then
			return
		end
		local foodClaims = {}
		for foodSlotIndex, foodAmount in pairs(foodSlots) do
			foodAmount = math.floor(tonumber(foodAmount) or 0)
			if tonumber(foodSlotIndex) and foodAmount > 0 then
				table.insert(foodClaims, { SlotIndex = tonumber(foodSlotIndex), Amount = foodAmount })
			end
		end
		if #foodClaims > 0 then
			sendCommand("ClaimWorkerAntFood", { SubmissionId = httpService:GenerateGUID(false), Claims = foodClaims })
		end
	end
	local currentSellPrice = nil
	table.insert(
		connections,
		eventBus.RemoteEvent.OnClientEvent:Connect(function(receivedEventName, receivedEventData)
			if
				receivedEventName == roomHelper.FoodSellConfig.PriceUpdateEvent
				and type(receivedEventData) == "table"
			then
				currentSellPrice = receivedEventData
			end
			if pendingPurchase and receivedEventName == pendingPurchase.Event then
				pendingPurchase = nil
				nextPurchaseAt = os.clock() + 0.75
			end
		end)
	)
	local function sellPlayerFood()
		local foodToSell = playerDataHelper.GetPlayerFood(localPlayer.UserId)
		if hubSettings.BlackMarketSell and blackMarket.IsSellOpen() then
			return
		end
		if foodToSell > 0 then
			sendCommand("SellPlayerFood", { FoodAmount = foodToSell, Source = "SpectreWare" })
		end
	end
	useSection("Autofarm", "Food")
	addJobToggle("Autofarm", "CollectFood", "Auto Collect Food", 1.5, claimWorkerFood)
	addNumberInput("Autofarm", "SellPrice", "Minimum Sell Price", 2)
	addJobToggle("Autofarm", "SellFood", "Auto Sell Food", 3, function()
		if not hubSettings.SellByPrice then
			sellPlayerFood()
		end
	end)
	addJobToggle("Autofarm", "SellByPrice", "Auto Sell By Price", 3, function()
		if currentSellPrice and (tonumber(currentSellPrice.GoldPerFood) or 0) >= hubSettings.SellPrice then
			sellPlayerFood()
		end
		sendCommand("RequestSellFoodPrice", {})
	end)
	local nextRollAt = 0
	useSection("Autofarm", "Ants")
	addJobToggle("Autofarm", "RollAnt", "Auto Roll Ant", 0.3, function()
		if hubSettings.VineRoll and workspace:GetAttribute("CurrentActivityId") == "Vine" then
			return
		end
		if os.clock() < nextRollAt or rollPresentationHelper.IsPlaying() then
			return
		end
		nextRollAt = os.clock() + math.max(playerDataHelper.GetPlayerRollInterval(gameContext, localPlayer.UserId), 0.5)
		sendCommand("RollAnt", { Source = "SpectreWare" })
	end)
	local claimCooldowns = {}
	local rarityNames =
		{ "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Exotic", "Secret", "Divine", "OP", "Celestial" }
	addDropdown("Autofarm", "ClaimRarities", "Buy Ant Rarity", rarityNames, true, table.clone(rarityNames))
	addJobToggle("Autofarm", "ClaimRolled", "Auto Buy Ant", 0.5, function()
		local antRollManager = rollPresentationHelper.GetManager()
		for antClaimId, antClaimPlatform in pairs(antRollManager and antRollManager.ClaimPlatforms or {}) do
			local antRollResult = antClaimPlatform.Result
			local antRollCost = antRollResult and tonumber(antRollResult.Cost)
			local rolledUnitConfig = antRollResult and gameContext.Config.UnitConfig[antRollResult.UnitId] or {}
			local rolledRarity = antRollResult and (antRollResult.Rarity or rolledUnitConfig.Rarity)
			local raritySelected = rolledRarity and (hubSettings.ClaimRarities or {})[rolledRarity] == true
			if
				antRollResult
				and antRollResult.ResultType ~= "Item"
				and raritySelected
				and antRollCost
				and getPlayerGold() >= antRollCost
				and not antClaimPlatform.ClaimRequested
				and os.clock() >= (claimCooldowns[antClaimId] or 0)
			then
				if
					tryPurchase("ClaimRolledAntResult", antRollCost, function()
						sendCommand("ClaimRolledAnt", { ClaimId = antClaimId })
					end)
				then
					claimCooldowns[antClaimId] = os.clock() + 4
					break
				end
			end
		end
	end)
	local antSlotLabels, antSlotByLabel = {}, {}
	addJobToggle("Autofarm", "PickupRolledStar", "Auto Pickup Star", 0.5, function()
		local starRollManager = rollPresentationHelper.GetManager()
		local starItemId = require(replicatedStorage.Battle.Game.Config.StarRollConfig).ItemId
		for starClaimId, starClaimPlatform in pairs(starRollManager and starRollManager.ClaimPlatforms or {}) do
			local starRollResult = starClaimPlatform.Result
			if
				starRollResult
				and starRollResult.ResultType == "Item"
				and starRollResult.ItemId == starItemId
				and not starClaimPlatform.ClaimRequested
				and os.clock() >= (claimCooldowns[starClaimId] or 0)
			then
				local starRollCost = tonumber(starRollResult.Cost) or 0
				if
					tryPurchase("ClaimRolledAntResult", starRollCost, function()
						sendCommand("ClaimRolledAnt", { ClaimId = starClaimId })
					end)
				then
					claimCooldowns[starClaimId] = os.clock() + 4
					return
				end
			end
		end
	end)
	local antSlotDropdowns = {}
	local lastSlotSignature
	local function refreshAntSlots()
		local refreshedSlotLabels, refreshedSlotMap = {}, {}
		local equippedEntries = backpackModel:BuildEquippedEntries()
		local sortedSlotIndices = {}
		for equippedSlotKey in pairs(equippedEntries) do
			table.insert(sortedSlotIndices, equippedSlotKey)
		end
		table.sort(sortedSlotIndices)
		for sortedSlotOrder, equippedSlotIndex in ipairs(sortedSlotIndices) do
			local equippedEntry = equippedEntries[equippedSlotIndex]
			local equippedSlotLabel = tostring(equippedSlotIndex)
				.. " - "
				.. tostring((equippedEntry.UnitConfig or {}).DisplayName or equippedEntry.UnitId)
			table.insert(refreshedSlotLabels, equippedSlotLabel)
			refreshedSlotMap[equippedSlotLabel] = equippedSlotIndex
		end
		local slotSignature = table.concat(refreshedSlotLabels, "\n")
		if lastSlotSignature == slotSignature then
			return
		end
		lastSlotSignature = slotSignature
		antSlotLabels, antSlotByLabel = refreshedSlotLabels, refreshedSlotMap
		setthreadidentity(8)
		for slotDropdownIndex, slotDropdown in ipairs(antSlotDropdowns) do
			slotDropdown:SetValues(antSlotLabels)
			task.wait()
			if not isAlive() then
				return
			end
		end
	end
	refreshAntSlots()
	local lastEquipSignature
	local function getBackpackSignature()
		local backpackSignatureData = backpackModel:GetData()
		local signatureParts = {}
		for stackKey, stackAmount in pairs(backpackSignatureData.Stacks or {}) do
			table.insert(signatureParts, "S:" .. tostring(stackKey) .. ":" .. tostring(stackAmount))
		end
		for signatureSlotIndex, signatureEquippedEntry in pairs(backpackSignatureData.EquippedBySlot or {}) do
			table.insert(
				signatureParts,
				"E:" .. tostring(signatureSlotIndex) .. ":" .. tostring(signatureEquippedEntry.V)
			)
		end
		for unlockedSlotKey, slotUnlocked in pairs(backpackSignatureData.UnlockedAntSlots or {}) do
			if slotUnlocked then
				table.insert(signatureParts, "U:" .. tostring(unlockedSlotKey))
			end
		end
		table.sort(signatureParts)
		return table.concat(signatureParts, "|")
	end
	addJobToggle("Autofarm", "EquipBest", "Auto Equip Best", 3, function()
		if backpackModel.IsEquipBestRunning then
			return
		end
		local currentEquipSignature = getBackpackSignature()
		if lastEquipSignature == currentEquipSignature then
			return
		end
		lastEquipSignature = currentEquipSignature
		if
			not backpackModel:EquipBest(function()
				if isAlive() and hubSettings.EquipBest then
					lastEquipSignature = getBackpackSignature()
					refreshAntSlots()
				end
			end)
		then
			lastEquipSignature = nil
		end
	end, function()
		lastEquipSignature = nil
	end)
	useSection("Upgrades", "Ant Upgrades")
	table.insert(antSlotDropdowns, addDropdown("Upgrades", "UpgradeSlots", "Ant Slots", antSlotLabels, true))
	addJobToggle("Upgrades", "UpgradeAnt", "Auto Upgrade Ant", 2.5, function()
		for upgradeSlotLabel, upgradeSlotSelected in pairs(hubSettings.UpgradeSlots or {}) do
			if upgradeSlotSelected and antSlotByLabel[upgradeSlotLabel] then
				local upgradeInfoOk, upgradeInfo =
					require(replicatedStorage.WuKongHooks.BackPackStore).GetEquippedUpgradeInfo(
						localPlayer.UserId,
						antSlotByLabel[upgradeSlotLabel]
					)
				if
					upgradeInfoOk
					and upgradeInfo
					and tryPurchase(
						function()
							local upgradedSlotEntry =
								backpackModel:GetData().EquippedBySlot[tostring(antSlotByLabel[upgradeSlotLabel])]
							return not upgradedSlotEntry or upgradedSlotEntry.V ~= upgradeInfo.V
						end,
						upgradeInfo.CostGold or upgradeInfo.CostFood,
						function()
							sendCommand("UpgradeEquippedAnt", { AntIndex = antSlotByLabel[upgradeSlotLabel] })
						end
					)
				then
					break
				end
			end
		end
	end)
	local statAttributeByLabel = {
		["Expand the Ant Nest"] = "巢穴层数",
		["Food Gain Multiplier"] = "蚂蚁攻击力",
		["Ant Speed"] = "蚂蚁移速",
		["Upgrade Egg Luck"] = "幸运值",
		["Queen Level"] = "蚁后等级",
		["Roll Count"] = "单抽数量",
	}
	local statLabels =
		{ "Expand the Ant Nest", "Food Gain Multiplier", "Ant Speed", "Upgrade Egg Luck", "Queen Level", "Roll Count" }
	useSection("Upgrades", "Stats & Pool")
	addDropdown("Upgrades", "Stats", "Stats", statLabels, true)
	addJobToggle("Upgrades", "UpgradeStats", "Auto Upgrade Stats", 0.5, function()
		for statIndex, statLabel in ipairs(statLabels) do
			local statSelected = (hubSettings.Stats or {})[statLabel]
			local statAttribute = statAttributeByLabel[statLabel]
			if statSelected and statAttribute then
				local statUpgradeInfo =
					playerDataHelper.GetPlayerUpgradeAttributeInfo(gameContext, localPlayer.UserId, statAttribute)
				if
					statUpgradeInfo
					and not statUpgradeInfo.IsMax
					and tryPurchase("UpgradePlayerAttributeResult", statUpgradeInfo.Price, function()
						sendCommand("UpgradePlayerAttribute", { AttributeName = statAttribute })
					end)
				then
					break
				end
			end
		end
	end)
	addJobToggle("Upgrades", "UpgradePool", "Auto Upgrade Pool", 3, function()
		local poolUpgradeConfig = playerDataHelper.GetPoolLevelUpgradeConfig(
			gameContext,
			playerDataHelper.GetPlayerCardPoolLevel(localPlayer.UserId)
		)
		if poolUpgradeConfig and poolUpgradeConfig.NextLevel then
			tryPurchase(
				"PoolLevelUpgradeResult",
				poolUpgradeConfig.CostFood or poolUpgradeConfig.Cost or poolUpgradeConfig.FoodCost,
				function()
					sendCommand("PoolLevelUpgrade", {})
				end
			)
		end
	end)
	addJobToggle("Upgrades", "AddSlot", "Auto Unlock Ant Slot", 0.5, function()
		local slotUnlockData = backpackModel:GetData()
		local unlockedSlotCount = 0
		for unlockCountKey, isSlotUnlocked in pairs(slotUnlockData.UnlockedAntSlots or {}) do
			if isSlotUnlocked then
				unlockedSlotCount += 1
			end
		end
		local nextSlotUnlockConfig = require(replicatedStorage._genConfigs.battle_tbnestunlock)[unlockedSlotCount]
		if not nextSlotUnlockConfig or getPlayerGold() < nextSlotUnlockConfig.Price then
			return
		end
		local nestUnlockConfigs = require(replicatedStorage._genConfigs.battle_tbnestunlock)
		for candidateSlotIndex = 1, #nestUnlockConfigs + 1 do
			if
				not slotUnlockData.UnlockedAntSlots[tostring(candidateSlotIndex)]
				and roomHelper.HasAntSlot(localPlayer, candidateSlotIndex)
			then
				tryPurchase("AddAntSlotResult", nextSlotUnlockConfig.Price, function()
					sendCommand("AddAntSlot", { SlotIndex = candidateSlotIndex, Source = "SpectreWare" })
				end)
				break
			end
		end
	end)
	useSection("Upgrades", "Ant Upgrades")
	addButton("Upgrades", "Refresh Ant Slots", refreshAntSlots)
	local compostAntsByLabel = {}
	addDropdown("Resource Converter", "CompostRarities", "Ant Rarity", rarityNames, true)
	local compostAntDropdown = addDropdown("Resource Converter", "CompostAnts", "Ants", {}, true)
	local function refreshCompostAnts()
		backpackModel:Refresh()
		local compostLabels = {}
		compostAntsByLabel = {}
		for compostEntryIndex, compostEntry in ipairs(backpackModel:BuildBackPackEntries(modelContext)) do
			if not compostEntry.Favorite then
				local compostLabel = tostring((compostEntry.UnitConfig or {}).DisplayName or compostEntry.UnitId)
					.. " | "
					.. tostring(compostEntry.Tag or "")
					.. " | Lv."
					.. tostring(compostEntry.Level)
					.. " | "
					.. tostring(compostEntry.V)
				table.insert(compostLabels, compostLabel)
				compostAntsByLabel[compostLabel] = compostEntry
			end
		end
		setthreadidentity(8)
		compostAntDropdown:SetValues(compostLabels)
	end
	addNumberInput("Resource Converter", "CompostCount", "Ants Per Deposit", 1)
	addJobToggle("Resource Converter", "AutoCompost", "Auto Convert Ants", 4.5, function()
		local compostState = compostModel:GetState(modelContext)
		if not compostState.Unlocked then
			return
		end
		if compostState.CanPull then
			compostModel:PullLever(modelContext)
			return
		end
		if compostState.Progress >= 1 then
			return
		end
		refreshCompostAnts()
		local compostBackpackData, compostDeposits = backpackModel:GetData(), {}
		for compostCandidateLabel, compostCandidate in pairs(compostAntsByLabel) do
			local compostRarity = compostCandidate.Rarity or (compostCandidate.UnitConfig or {}).Rarity
			local compostSelected = (hubSettings.CompostAnts or {})[compostCandidateLabel] == true
				or (hubSettings.CompostRarities or {})[compostRarity] == true
			if
				compostSelected
				and compostCandidate
				and not (compostBackpackData.Favorites or {})[compostCandidate.EntryKey]
			then
				local compostStackCount = tonumber(
					(compostBackpackData.Stacks or {})[tostring(compostCandidate.V)]
						or (compostBackpackData.Stacks or {})[compostCandidate.V]
				) or 0
				if compostStackCount > 0 then
					compostDeposits[compostCandidate.V] =
						math.min(compostStackCount, math.floor(hubSettings.CompostCount))
				end
			end
		end
		if next(compostDeposits) then
			compostModel:AddAnts(modelContext, compostDeposits)
		end
	end)
	addJobToggle("Resource Converter", "UpgradeCompost", "Auto Upgrade Converter", 5, function()
		local compostUpgradeState = compostModel:GetState(modelContext)
		if compostUpgradeState.CanUpgrade then
			tryPurchase("CompostMachineResult", compostUpgradeState.UpgradePrice, function()
				return compostModel:Upgrade(modelContext)
			end)
		end
	end)
	addJobToggle("Resource Converter", "UnlockConverter", "Auto Unlock Converter", 2, function()
		local compostUnlockState = compostModel:GetState(modelContext)
		if compostUnlockState.CanUnlock then
			tryPurchase(nil, compostUnlockState.UnlockPrice, function()
				return compostModel:Unlock(modelContext)
			end)
		end
	end)
	addJobToggle("Resource Converter", "PullConverter", "Auto Pull Lever", 1, function()
		local compostPullState = compostModel:GetState(modelContext)
		if compostPullState.CanPull then
			compostModel:PullLever(modelContext)
		end
	end)
	addButton("Resource Converter", "Refresh Ants", refreshCompostAnts)
	addButton("Resource Converter", "Unlock Converter", function()
		local manualCompostUnlockState = compostModel:GetState(modelContext)
		if manualCompostUnlockState.CanUnlock then
			tryPurchase(nil, manualCompostUnlockState.UnlockPrice, function()
				return compostModel:Unlock(modelContext)
			end)
		end
	end)
	local trashAntsByLabel = {}
	addDropdown("Trash", "TrashRarities", "Ant Rarity", rarityNames, true)
	local trashAntDropdown = addDropdown("Trash", "TrashAnts", "Ants", {}, true)
	addNumberInput("Trash", "TrashCount", "Ants Per Delete", 1)
	local function refreshTrashAnts()
		backpackModel:Refresh()
		local trashLabels = {}
		trashAntsByLabel = {}
		for trashEntryIndex, trashEntry in ipairs(backpackModel:BuildBackPackEntries(modelContext)) do
			if not trashEntry.Favorite then
				local trashLabel = tostring((trashEntry.UnitConfig or {}).DisplayName or trashEntry.UnitId)
					.. " | "
					.. tostring(trashEntry.Tag or "")
					.. " | Lv."
					.. tostring(trashEntry.Level)
					.. " | "
					.. tostring(trashEntry.V)
				table.insert(trashLabels, trashLabel)
				trashAntsByLabel[trashLabel] = trashEntry
			end
		end
		setthreadidentity(8)
		trashAntDropdown:SetValues(trashLabels)
	end
	addJobToggle("Trash", "AutoTrash", "Auto Trash Ants", 3, function()
		refreshTrashAnts()
		local trashBackpackData = backpackModel:GetData()
		for trashCandidateLabel, trashCandidate in pairs(trashAntsByLabel) do
			local trashRarity = trashCandidate.Rarity or (trashCandidate.UnitConfig or {}).Rarity
			local trashSelected = (hubSettings.TrashAnts or {})[trashCandidateLabel] == true
				or (hubSettings.TrashRarities or {})[trashRarity] == true
			local trashFavorite = trashCandidate.Favorite
				or (trashBackpackData.Favorites or {})[trashCandidate.EntryKey]
				or (trashBackpackData.Favorites or {})["Ant:" .. tostring(trashCandidate.V)]
			local trashStackCount = tonumber(
				(trashBackpackData.Stacks or {})[tostring(trashCandidate.V)]
					or (trashBackpackData.Stacks or {})[trashCandidate.V]
			) or 0
			local trashAmount = math.min(trashStackCount, math.floor(hubSettings.TrashCount))
			if trashSelected and not trashFavorite and trashAmount > 0 then
				backpackModel:ExecuteAction(
					"/背包系统/背包移除物品?购买",
					{ V = trashCandidate.V, Count = trashAmount, Section = "BackPack" }
				)
				return
			end
		end
	end)
	addButton("Trash", "Refresh Ants", refreshTrashAnts)
	addJobToggle("Dungeon", "AutoDungeon", "Auto Dungeon", 3, function()
		local autoDungeonSnapshot, autoDungeonClient = getDungeonSnapshot()
		if autoDungeonSnapshot then
			if autoDungeonSnapshot.status == "ready" then
				sendCommand("DungeonCommand", { Action = "Start", SessionId = autoDungeonSnapshot.sessionId })
			end
			return
		end
		if autoDungeonClient and autoDungeonClient.Transition then
			return
		end
		local dungeonEntrances = workspace:FindFirstChild("DungeonEntrances")
		for entranceIndex, dungeonEntrance in ipairs(dungeonEntrances and dungeonEntrances:GetChildren() or {}) do
			local entrancePrompt = dungeonEntrance:FindFirstChildWhichIsA("ProximityPrompt", true)
			local entranceExpiresAt = tonumber(dungeonEntrance:GetAttribute("ExpiresAt")) or 0
			if
				entrancePrompt
				and entrancePrompt.Enabled
				and entranceExpiresAt > workspace:GetServerTimeNow()
				and dungeonEntrance:GetAttribute("DungeonUsed_" .. tostring(localPlayer.UserId)) ~= true
			then
				local entrancePromptParent = entrancePrompt.Parent
				local entrancePosition = entrancePromptParent:IsA("Attachment") and entrancePromptParent.WorldPosition
					or entrancePromptParent:IsA("BasePart") and entrancePromptParent.Position
					or dungeonEntrance:GetPivot().Position
				if teleportTo(entrancePosition) then
					task.wait(0.3)
					if isAlive() and hubSettings.AutoDungeon then
						fireproximityprompt(entrancePrompt)
					end
				end
				break
			end
		end
	end)
	addJobToggle("Dungeon", "ClickBoost", "Auto Click Boost", 0.05, function()
		local boostSnapshot, boostClient = getDungeonSnapshot()
		if
			not boostSnapshot
			or boostSnapshot.status == "ready"
			or boostSnapshot.status == "ended"
			or (boostClient and boostClient.Transition)
		then
			return
		end
		local boostServerTime = workspace:GetServerTimeNow()
		local projectedClickScore, projectedAttackMultiplier = clickBoost.Project(
			boostSnapshot.clickScore or 0,
			boostSnapshot.attackSpeedMultiplier or 1,
			math.max(boostServerTime - (boostSnapshot.clickUpdatedAt or boostServerTime), 0),
			dungeonConfig.ClickBoost
		)
		if projectedAttackMultiplier < 4 then
			sendCommand("DungeonCommand", { Action = "Click", SessionId = boostSnapshot.sessionId })
		end
	end)
	addJobToggle("Dungeon", "TimeCoin", "Auto Pickup Time Coin", 0.75, function()
		local coinDungeonSnapshot, coinDungeonClient = getDungeonSnapshot()
		if not coinDungeonSnapshot then
			return
		end
		for rendererResourceKey, rendererResource in pairs(coinDungeonClient.RendererResources or {}) do
			local timeCoinManager = rendererResource.timeCoins
			if timeCoinManager then
				for timeCoinId, timeCoin in pairs(timeCoinManager.coins or {}) do
					if timeCoin.landed and timeCoin.positionConfirmed then
						local timeCoinPosition = timeCoin.model and timeCoin.model.Position
							or timeCoin.data and timeCoin.data.position
						if timeCoinPosition then
							teleportTo(timeCoinPosition)
						end
						timeCoinManager:RequestPickup(timeCoinId, workspace:GetServerTimeNow())
						return
					end
				end
			end
		end
	end)
	addJobToggle("Rewards", "Activity14DayReward", "Auto 14-Day Reward", 5, function()
		activityState:Refresh()
		for rewardDayIndex, rewardDay in ipairs(activityState:GetDays()) do
			if rewardDay.Status == "Claim" then
				activityState:Claim(rewardDay.DayId)
				return
			end
		end
	end)
	local activityShopByLabel, activityShopLabels = {}, {}
	for activityItemIndex, activityItem in ipairs(activityState:GetShopCatalog()) do
		local activityItemLabel = tostring(activityItem.DisplayName) .. " [" .. tostring(activityItem.ProductId) .. "]"
		activityShopByLabel[activityItemLabel] = activityItem
		table.insert(activityShopLabels, activityItemLabel)
	end
	addDropdown("Events", "ActivityShopItems", "Activity Shop Items", activityShopLabels, true, {})
	addJobToggle("Events", "ActivityShop", "Auto Buy Activity Shop", 2, function()
		if activityState.PendingShopPurchase or activityState:GetActivityRemainingSeconds() <= 0 then
			return
		end
		activityState:Refresh()
		local wishCurrencyBalance = activityState:RefreshWishCurrencyBalance()
		for shopLabelIndex, shopLabel in ipairs(activityShopLabels) do
			local shopItem = activityShopByLabel[shopLabel]
			if
				hubSettings.ActivityShopItems[shopLabel]
				and wishCurrencyBalance >= shopItem.Price
				and (shopItem.Limit <= 0 or activityState:GetShopPurchaseCount(shopItem.ProductId) < shopItem.Limit)
			then
				activityState:PurchaseShopItem(shopItem.ProductId)
				return
			end
		end
	end)
	local vineModels, nextVineScanAt = {}, 0
	addJobToggle("Events", "VineRoll", "Auto Vine Roll", 0.2, function()
		if
			getDungeonSnapshot()
			or workspace:GetAttribute("CurrentActivityId") ~= "Vine"
			or (tonumber(workspace:GetAttribute("CurrentActivityCountdownSeconds")) or 0) <= 0
		then
			return
		end
		if os.clock() < nextRollAt or rollPresentationHelper.IsPlaying() then
			return
		end
		if os.clock() >= nextVineScanAt then
			nextVineScanAt = os.clock() + 5
			table.clear(vineModels)
			for descendantIndex, descendant in ipairs(workspace:GetDescendants()) do
				if descendant:IsA("Model") and descendant:GetAttribute(vineConfig.ReadyAttribute) == true then
					table.insert(vineModels, descendant)
				end
			end
		end
		for vineModelIndex, vineModel in ipairs(vineModels) do
			if vineModel:IsDescendantOf(workspace) and vineModel:GetAttribute(vineConfig.ReadyAttribute) == true then
				local vineBase = vineModel:FindFirstChild(vineConfig.BaseName)
				local vineQueenPosition = vineBase and vineBase:FindFirstChild(vineConfig.QueenPositionName)
				if
					vineQueenPosition
					and vineQueenPosition:IsA("BasePart")
					and teleportTo(vineQueenPosition.Position)
				then
					nextRollAt = os.clock()
						+ math.max(playerDataHelper.GetPlayerRollInterval(gameContext, localPlayer.UserId), 0.5)
					sendCommand("RollAnt", { Source = vineConfig.Id })
					return
				end
			end
		end
	end)
	addJobToggle("Events", "BlackMarketSell", "Auto Black Market Sell", 1, function()
		if getDungeonSnapshot() or not blackMarket.IsSellOpen() then
			return
		end
		local blackMarketFood = playerDataHelper.GetPlayerFood(localPlayer.UserId)
		if blackMarketFood <= 0 then
			return
		end
		local blackMarketSellPart = blackMarket.GetClientSellPart()
		if blackMarketSellPart and blackMarketSellPart:IsA("BasePart") and teleportTo(blackMarketSellPart.Position) then
			sendCommand("SellPlayerFood", { FoodAmount = blackMarketFood, Source = "BlackMarket" })
		end
	end)
	addJobToggle("Events", "TravelSnail", "Auto Travel Snail", 0.55, function()
		if getDungeonSnapshot() then
			return
		end
		local activityAttributes = activityScheduleConfig.WorkspaceAttributes
		if
			workspace:GetAttribute(activityAttributes.ActivityId) ~= "TravelSnail"
			or (tonumber(workspace:GetAttribute(activityAttributes.CountdownSeconds)) or 0) <= 0
		then
			return
		end
		wuKong:ExecuteAction("/功能商人/蜗牛活动抽奖?购买")
	end)
	addJobToggle("Events", "StrawberryCoin", "Auto Strawberry Coin", 0.75, function()
		if getDungeonSnapshot() then
			return
		end
		for strawberryEntityId, strawberryCoin in ecsWorld:query(gameContext.Components.StrawberryCoin) do
			if
				(tonumber(strawberryCoin.ReadyAt) or math.huge) <= workspace:GetServerTimeNow()
				and (tonumber(strawberryCoin.ExpiresAt) or 0) > workspace:GetServerTimeNow()
			then
				if teleportTo(strawberryCoin.Position) then
					sendCommand("PickupStrawberryCoin", { CoinEntityId = strawberryEntityId })
				end
				break
			end
		end
	end)
	addDropdown(
		"Events",
		"StarMode",
		"Star Event Mode",
		{ "Submit", "Enter", "Submit + Enter" },
		false,
		"Submit + Enter"
	)
	local nextStarEnterAt = 0
	addJobToggle("Events", "StarEvent", "Auto Star Event", 0.75, function()
		local starEventState = replicationState.Core
			and replicationState.Core.StarEventClient
			and replicationState.Core.StarEventClient.State
		if not starEventState or getDungeonSnapshot() or not gameContext.Helper.StarEventTime.IsActive() then
			return
		end
		if starEventState.IsOpen and starEventState.EndsAt > workspace:GetServerTimeNow() then
			if
				hubSettings.StarMode ~= "Submit"
				and localPlayer:GetAttribute("StarEventUsedCycleId") ~= starEventState.CycleId
			then
				if os.clock() < nextStarEnterAt then
					return
				end
				local starPresentation = replicationState.Core.StarEventClient.Presentation
				local starEnterPrompt = starPresentation and starPresentation.EnterPrompt
				local starPromptParent = starEnterPrompt and starEnterPrompt.Parent
				local starEnterPosition = starPromptParent
					and (
						starPromptParent:IsA("Attachment") and starPromptParent.WorldPosition
						or starPromptParent:IsA("BasePart") and starPromptParent.Position
					)
				local starPlayerRoot = getRootPart()
				if starEnterPosition and starPlayerRoot then
					if
						(starPlayerRoot.Position - starEnterPosition).Magnitude
						> math.max(starEnterPrompt.MaxActivationDistance - 1, 3)
					then
						if not teleportTo(starEnterPosition) then
							return
						end
						task.wait(0.3)
					end
					if isAlive() and hubSettings.StarEvent and not getDungeonSnapshot() then
						nextStarEnterAt = os.clock() + 3
						sendCommand("StarEventCommand", { Action = "Enter", CycleId = starEventState.CycleId })
					end
				end
			end
		elseif hubSettings.StarMode ~= "Enter" then
			local starRollConfig = require(replicatedStorage.Battle.Game.Config.StarRollConfig)
			if backpackModel:GetItemCount(starRollConfig.ItemId) > 0 then
				if
					localPlayer:GetAttribute("BackpackHeldItemId") ~= starRollConfig.ItemId
					or localPlayer:GetAttribute("BackpackHeldEntryKey") ~= "Item:" .. starRollConfig.ItemId
				then
					for starInventoryIndex, starInventoryEntry in ipairs(backpackModel:BuildItemEntries()) do
						if starInventoryEntry.Id == starRollConfig.ItemId then
							eventBus.FireServer("SetBackpackHeldEntry", {
								Kind = "Item",
								EntryKey = starInventoryEntry.EntryKey,
								ItemId = starRollConfig.ItemId,
								Pos = starInventoryEntry.Pos,
							})
							return
						end
					end
				else
					sendCommand("StarEventCommand", { Action = "Submit", CycleId = starEventState.CycleId })
				end
			end
		end
	end)
	addJobToggle("Events", "StrawberryBase", "Auto Unlock Strawberry Base", 10, function()
		local strawberryKingState = require(replicatedStorage.UI.StrawberryKingPanel.Model.State)
		if not strawberryKingState:IsStrawberryBaseUnlocked() and strawberryKingState:HasEnoughActivityCoin() then
			tryPurchase(nil, 0, function()
				return strawberryKingState:StrawberrgBaseUnlock()
			end)
		end
	end)
	local gearLabels, gearByLabel = {}, {}
	for gearCatalogIndex, gearCatalogEntry in ipairs(gearShopModel:GetCatalog()) do
		local gearLabel = gearCatalogEntry.Config.DisplayName or gearCatalogEntry.ItemId
		table.insert(gearLabels, gearLabel)
		gearByLabel[gearLabel] = gearCatalogEntry
	end
	addDropdown("Gear", "GearItems", "Gear Items", gearLabels, true)
	addJobToggle("Gear", "BuyGear", "Auto Buy Gear", 3, function()
		for selectedGearLabel, gearSelected in pairs(hubSettings.GearItems or {}) do
			local selectedGear = gearByLabel[selectedGearLabel]
			if
				gearSelected
				and selectedGear
				and gearShopModel:GetStock(selectedGear.ItemId) > 0
				and tryPurchase("GearShopResult", selectedGear.Config.CoinPrice, function()
					return gearShopModel:Purchase(selectedGear.ItemId)
				end)
			then
				break
			end
		end
	end)
	addButton("Gear", "Refresh Stock", function()
		gearShopModel:RequestSnapshot()
	end)
	table.insert(antSlotDropdowns, addDropdown("Potions", "PotionSlots", "Select Ant", antSlotLabels, true))
	addDropdown(
		"Potions",
		"PotionTarget",
		"Apply To",
		{ "Select Ant", "All Ants", "All Mutation", "All No Mutation" },
		false,
		"Select Ant"
	)
	local mutationSlotByLabel, lastMutationSignature = {}, nil
	local nextMutationRefreshAt = 0
	local mutationSlotDropdown = addDropdown("Potions", "PotionMutationSlots", "Mutation Ants", {}, true, {})
	local function refreshMutationSlots(baseUnitInfos)
		local mutationLabels, refreshedMutationSlots = {}, {}
		for mutationUnitIndex, mutationUnit in ipairs(baseUnitInfos or autoToolState:GetAllBaseUnitInfo()) do
			if mutationUnit.TagId > 0 then
				local mutationTagLabel = mutationUnit.Tag ~= "" and mutationUnit.Tag
					or "Mutation " .. tostring(mutationUnit.TagId)
				local mutationSlotLabel = tostring(mutationUnit.SlotIndex)
					.. " - "
					.. mutationUnit.Name
					.. " ["
					.. mutationTagLabel
					.. "]"
				table.insert(mutationLabels, mutationSlotLabel)
				refreshedMutationSlots[mutationSlotLabel] =
					{ Slot = mutationUnit.SlotIndex, TagId = mutationUnit.TagId }
			end
		end
		mutationSlotByLabel = refreshedMutationSlots
		local mutationSignature = table.concat(mutationLabels, "\n")
		if mutationSignature ~= lastMutationSignature then
			lastMutationSignature = mutationSignature
			local retainedMutationSelections = {}
			for mutationSelectionLabel, mutationSelectionEnabled in pairs(hubSettings.PotionMutationSlots or {}) do
				if mutationSelectionEnabled and refreshedMutationSlots[mutationSelectionLabel] then
					retainedMutationSelections[mutationSelectionLabel] = true
				end
			end
			setthreadidentity(8)
			mutationSlotDropdown:SetValues(mutationLabels)
			mutationSlotDropdown:SetValue(retainedMutationSelections)
		end
	end
	local potionIdByName = {}
	local potionConfig = require(replicatedStorage.Configs.PotionConfig)
	local mutationCrystalConfig = require(replicatedStorage.Configs.MutationCrystalConfig)
	local backpackItemConfig = require(replicatedStorage._genConfigs.ui_tbbackpackitem)
	local potionDropdown = addDropdown("Potions", "Potion", "Potion", {}, false)
	local function refreshPotions()
		refreshAntSlots()
		refreshMutationSlots()
		local potionNames = {}
		potionIdByName = {}
		local sortedPotionItems = {}
		for potionConfigId, potionItemConfig in pairs(backpackItemConfig) do
			if potionConfig.Get(potionConfigId) or mutationCrystalConfig.Get(potionConfigId) then
				table.insert(sortedPotionItems, {
					Id = potionConfigId,
					Name = potionItemConfig.DisplayName or potionConfigId,
					Sort = tonumber(potionItemConfig.sort or potionItemConfig.Index) or math.huge,
				})
			end
		end
		table.sort(sortedPotionItems, function(firstPotionItem, secondPotionItem)
			if firstPotionItem.Sort == secondPotionItem.Sort then
				return firstPotionItem.Id < secondPotionItem.Id
			end
			return firstPotionItem.Sort < secondPotionItem.Sort
		end)
		for potionItemIndex, potionItem in ipairs(sortedPotionItems) do
			table.insert(potionNames, potionItem.Name)
			potionIdByName[potionItem.Name] = potionItem.Id
		end
		setthreadidentity(8)
		potionDropdown:SetValues(potionNames)
	end
	local autoPotionSlots = {}
	local nextCrystalUseAt = 0
	local function disableAutoPotions()
		for autoPotionSlotToDisable in pairs(autoPotionSlots) do
			autoToolState:RequestSetAutoUsePotion(autoPotionSlotToDisable, false)
		end
		table.clear(autoPotionSlots)
	end
	addJobToggle("Potions", "UsePotion", "Auto Use Potion", 1, function()
		local selectedPotionId = potionIdByName[hubSettings.Potion]
		if not selectedPotionId then
			return
		end
		local potionUnitInfos = autoToolState:GetAllBaseUnitInfo()
		if os.clock() >= nextMutationRefreshAt then
			nextMutationRefreshAt = os.clock() + 5
			refreshMutationSlots(potionUnitInfos)
		end
		local crystalConfig = mutationCrystalConfig.Get(selectedPotionId)
		local desiredPotionSlots = {}
		local potionActionTaken = false
		local selectedPotionSlots = {}
		for potionSlotLabel, potionSlotSelected in pairs(hubSettings.PotionSlots or {}) do
			if potionSlotSelected and antSlotByLabel[potionSlotLabel] then
				selectedPotionSlots[antSlotByLabel[potionSlotLabel]] = true
			end
		end
		for selectedMutationLabel, selectedMutationEnabled in pairs(hubSettings.PotionMutationSlots or {}) do
			local selectedMutationSlot = mutationSlotByLabel[selectedMutationLabel]
			if selectedMutationEnabled and selectedMutationSlot then
				selectedPotionSlots[selectedMutationSlot.Slot] = true
			end
		end
		for potionUnitIndex, potionUnit in ipairs(potionUnitInfos) do
			local potionSlotIndex = potionUnit.SlotIndex
			local potionTargetMode = hubSettings.PotionTarget
			local isPotionTarget = potionTargetMode == "All Ants"
				or potionTargetMode == "All Mutation" and potionUnit.TagId > 0
				or potionTargetMode == "All No Mutation" and potionUnit.TagId == 0
				or potionTargetMode == "Select Ant" and selectedPotionSlots[potionSlotIndex]
			if isPotionTarget then
				desiredPotionSlots[potionSlotIndex] = true
				if crystalConfig then
					local canApplyCrystal = crystalConfig.Mode == "Remove" and potionUnit.TagId > 0
						or crystalConfig.Mode == "Apply" and potionUnit.TagId == 0
					if
						canApplyCrystal
						and not potionActionTaken
						and backpackModel:GetItemCount(selectedPotionId) > 0
						and os.clock() >= nextCrystalUseAt
						and not getDungeonSnapshot()
					then
						if
							localPlayer:GetAttribute("BackpackHeldItemId") ~= selectedPotionId
							or localPlayer:GetAttribute("BackpackHeldEntryKey") ~= "Item:" .. selectedPotionId
						then
							for crystalInventoryIndex, crystalInventoryEntry in ipairs(backpackModel:BuildItemEntries()) do
								if crystalInventoryEntry.Id == selectedPotionId then
									eventBus.FireServer("SetBackpackHeldEntry", {
										Kind = "Item",
										EntryKey = crystalInventoryEntry.EntryKey,
										ItemId = selectedPotionId,
										Pos = crystalInventoryEntry.Pos,
									})
									potionActionTaken = true
									break
								end
							end
						else
							local potionRoom = getLocalRoom()
							if potionRoom and potionRoom.RoomIndex then
								eventBus.FireServer("UsePotionOnRoomSlot", {
									RoomIndex = potionRoom.RoomIndex,
									SlotIndex = potionSlotIndex,
									ItemId = selectedPotionId,
								})
								nextCrystalUseAt = os.clock() + 2
								potionActionTaken = true
							end
						end
					end
				elseif not potionUnit.PotionId then
					if not potionActionTaken and backpackModel:GetItemCount(selectedPotionId) > 0 then
						potionActionTaken = autoToolState:RequestUsePotion(potionSlotIndex, selectedPotionId) ~= nil
					end
				elseif potionUnit.PotionId == selectedPotionId then
					if not potionUnit.AutoUsePotion or potionUnit.AutoPotionItemId ~= selectedPotionId then
						autoToolState:RequestSetAutoUsePotion(potionSlotIndex, true)
					end
					autoPotionSlots[potionSlotIndex] = true
				end
			end
		end
		for previousAutoPotionSlot in pairs(autoPotionSlots) do
			if not desiredPotionSlots[previousAutoPotionSlot] then
				autoToolState:RequestSetAutoUsePotion(previousAutoPotionSlot, false)
				autoPotionSlots[previousAutoPotionSlot] = nil
			end
		end
	end, disableAutoPotions)
	addButton("Potions", "Refresh Potions", refreshPotions)
	addJobToggle("Ride", "AutoTame", "Auto Tame Held Unit", 4, function()
		local heldAntValue = localPlayer:GetAttribute("BackpackHeldAntValue")
		local heldAntEntryKey = localPlayer:GetAttribute("BackpackHeldEntryKey")
		if heldAntValue and not (backpackModel:GetData().Favorites or {})[heldAntEntryKey] then
			tryPurchase(nil, 0, function()
				return tameState:TameUnit(true)
			end)
		end
	end)
	local rideIdByName = {}
	local rideDropdown = addDropdown("Ride", "RideUnit", "Ride", {}, false)
	local function refreshRides()
		rideState:Refresh()
		local rideNames = {}
		rideIdByName = {}
		for rideEntryIndex, rideEntry in ipairs(rideState:GetEntries()) do
			if rideEntry.Unlocked then
				table.insert(rideNames, rideEntry.DisplayName)
				rideIdByName[rideEntry.DisplayName] = rideEntry.UnitId
			end
		end
		setthreadidentity(8)
		rideDropdown:SetValues(rideNames)
	end
	addJobToggle("Ride", "EquipRide", "Auto Equip Ride", 5, function()
		local selectedRideId = rideIdByName[hubSettings.RideUnit]
		if selectedRideId and rideState:GetEquippedUnitId() ~= selectedRideId then
			if tameState:EquipRide(selectedRideId) and isAlive() then
				eventBus.FireServer("Ride", { UnitName = selectedRideId })
			end
		end
	end)
	addJobToggle("Ride", "RideReward", "Auto Ride Progress Reward", 8, function()
		rideState:Refresh()
		local rideRewardState = rideState:GetRewardState()
		if rideRewardState.CanClaim then
			rideState:ClaimProgressReward(rideRewardState.RewardIndex)
		end
	end)
	addButton("Ride", "Refresh Rides", refreshRides)
	addJobToggle("Rewards", "OnlineReward", "Auto Claim Online Rewards", 8, function()
		local onlineRewardIndex = onlineRewardState:GetFirstClaimableRewardIndex()
		if onlineRewardIndex then
			onlineRewardState:GetReward(onlineRewardIndex, modelContext)
		end
	end)
	addJobToggle("Rewards", "IndexReward", "Auto Claim Index Rewards", 8, function()
		for indexCategoryIndex, indexCategory in ipairs({ "Ants", "Mutations" }) do
			local indexRewardState = indexModel:GetRewardState(indexCategory)
			if indexRewardState and indexRewardState.CanClaim then
				indexModel:ClaimReward(indexCategory)
			end
		end
	end)
	addJobToggle("Rewards", "SevenReward", "Auto 7-Day Reward", 15, function()
		if sevenDayState:IsAward() then
			sevenDayState:GetReward()
		end
	end)
	addJobToggle("Rewards", "OfflineReward", "Auto Offline Reward", 5, function()
		local hudContainer = localPlayer.PlayerGui:FindFirstChild("HUDContainer")
		local offlineRewardPanel = hudContainer and hudContainer:FindFirstChild("OfflineReward")
		if offlineRewardPanel and offlineRewardPanel.Visible then
			eventBus.Fire("OfflineRewardCloseRequested")
		end
	end)
	useSection("Settings", "General")
	addDropdown("Settings", "Theme", "Theme", Library:ListThemes(), false, Library.ThemeName):OnChanged(function(themeName)
		if themeName then
			pcall(function()
				window:SetTheme(themeName, true)
			end)
		end
	end)
	local function stopAllJobs()
		setthreadidentity(8)
		for jobKeyToStop in pairs(jobs) do
			setthreadidentity(8)
			options[jobKeyToStop]:SetValue(false)
		end
	end
	addButton("Settings", "Stop All", stopAllJobs)
	useSection("Settings", "Config")
	local configNameControl = newAdapter("Input", false)
	configNameControl.Type = "Text"
	configNameControl.Control = sectionFor("Settings"):CreateTextbox({
		Name = "Config Name",
		Default = "default",
		Placeholder = "default",
		Live = true,
		Callback = function(enteredConfigName)
			configNameControl:Fire(enteredConfigName)
		end,
	})
	configNameControl:OnChanged(function(enteredConfigName)
		profileNameInput = enteredConfigName
	end)
	profileDropdown = newAdapter("Dropdown", false, {})
	profileDropdown.Control = sectionFor("Settings"):CreateDropdown({
		Name = "Select Config",
		Options = {},
		Multi = false,
		Callback = function(selectedConfigName)
			profileDropdown:Fire(selectedConfigName)
		end,
	})
	profileDropdown:OnChanged(function(selectedConfigName)
		selectedProfile = selectedConfigName
		if selectedConfigName then
			configNameControl:SetValue(selectedConfigName)
		end
	end)
	addButton("Settings", "Refresh Configs", refreshProfileDropdown)
	addButton("Settings", "Create Config", function()
		createProfile(configNameControl.Value)
	end)
	addButton("Settings", "Save Config", function()
		local configNameToSave = tostring(configNameControl.Value):match("^%s*(.-)%s*$")
		if configStore.Profiles[configNameToSave] then
			saveProfile(configNameToSave)
			selectedProfile = configNameToSave
			refreshProfileDropdown()
		else
			createProfile(configNameToSave)
		end
	end)
	addButton("Settings", "Overwrite Config", function()
		saveProfile()
	end)
	addButton("Settings", "Load Config", function()
		loadProfile()
	end)
	addButton("Settings", "Auto Load", function()
		assert(selectedProfile and configStore.Profiles[selectedProfile], "Select a saved config first")
		setAutoLoadProfile(selectedProfile)
	end)
	addButton("Settings", "Disable Auto Load", function()
		setAutoLoadProfile("None")
	end)
	selectedProfile = configStore.Profiles[configStore.AutoLoad] and configStore.AutoLoad or nil
	refreshProfileDropdown()
	local function cleanupHub()
		if not running then
			return
		end
		running = false
		for settingToDisable in pairs(hubSettings) do
			if jobs[settingToDisable] then
				hubSettings[settingToDisable] = false
			end
		end
		pcall(disableAutoPotions)
		restorePurchaseQuery()
		setthreadidentity(8)
		for cleanupConnectionIndex, cleanupConnection in ipairs(connections) do
			pcall(function()
				cleanupConnection:Disconnect()
			end)
		end
		destroyUi()
	end
	sharedEnvironment.NOPE_HUB_UI_CLEANUP = cleanupHub
	if STATE then
		STATE.onCleanup(cleanupHub)
	end
	useSection("Settings", "General")
	addButton("Settings", "Unload", cleanupHub)
	refreshCompostAnts()
	refreshTrashAnts()
	refreshPotions()
	refreshRides()
	if configStore.AutoLoad and configStore.AutoLoad ~= "" then
		local autoLoadOk, autoLoadError = pcall(loadProfile, configStore.AutoLoad)
		if not autoLoadOk then
			warn("[SpectreWare] Load Config", autoLoadError)
		end
	end
	sendCommand("RequestSellFoodPrice", {})
	local hubApi = {
		Settings = hubSettings,
		Options = options,
		Jobs = jobs,
		Errors = jobErrors,
		Counts = jobCounts,
		Stop = stopAllJobs,
		Cleanup = cleanupHub,
		Tabs = tabs,
		Window = window,
		Library = Library,
		PurchaseGuard = purchaseGuard,
	}
	hubApi.SaveConfig = saveProfile
	hubApi.LoadConfig = loadProfile
	hubApi.ConfigPath = configPath
	hubApi.CreateConfig = createProfile
	hubApi.SetAutoLoad = setAutoLoadProfile
	hubApi.ConfigStore = configStore
	sharedEnvironment.NOPE_ANT_HUB = hubApi
	_G.NOPE_ANT_HUB = hubApi
	if STATE then
		STATE.api = hubApi
	end
	task.spawn(function()
		while isAlive() do
			local schedulerNow = os.clock()
			if pendingPurchase and type(pendingPurchase.Event) == "function" then
				local completionCheckOk, purchaseCompleted = pcall(pendingPurchase.Event)
				if completionCheckOk and purchaseCompleted then
					pendingPurchase = nil
					nextPurchaseAt = schedulerNow + 0.75
				end
			end
			if pendingPurchase and schedulerNow - pendingPurchase.Started > 8 then
				pendingPurchase = nil
				nextPurchaseAt = schedulerNow + 5
			end
			for scheduledJobKey, scheduledJob in pairs(jobs) do
				if hubSettings[scheduledJobKey] and not scheduledJob.busy and schedulerNow >= scheduledJob.nextAt then
					scheduledJob.nextAt = schedulerNow + scheduledJob.interval
					scheduledJob.busy = true
					task.spawn(function()
						if isAlive() and hubSettings[scheduledJobKey] then
							local jobOk, jobError = pcall(scheduledJob.callback)
							if not jobOk then
								jobErrors[scheduledJobKey] = tostring(jobError)
								scheduledJob.nextAt = os.clock() + math.max(scheduledJob.interval, 10)
								warn("[SpectreWare]", scheduledJobKey, jobError)
							else
								jobErrors[scheduledJobKey] = nil
								jobCounts[scheduledJobKey] = (jobCounts[scheduledJobKey] or 0) + 1
							end
						end
						scheduledJob.busy = false
					end)
				end
			end
			task.wait(hubSettings.ClickBoost and 0.02 or 0.1)
		end
		cleanupHub()
	end)
	setthreadidentity(8)
	window:SelectTab(tabs.Autofarm)
end
task.spawn(function()
	local startupOk, startupError = xpcall(initializeHub, debug.traceback)
	if not startupOk then
		warn("[SpectreWare]", startupError)
	end
end)
