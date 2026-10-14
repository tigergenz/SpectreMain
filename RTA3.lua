--[[
	SpectreWare | Restaurant Tycoon 3
	UI: SpectreUI v3.17 (dark/cyan-navy Roblox UI library by SpectreWare)
	Theme: Spectre (Dark Graphite / Deep Navy Slate / Electric Cyan)
	Brand: SpectreWare
	Discord: https://discord.gg/GdKxvcHzjS
	Game: Restaurant Tycoon 3 (PlaceId: 119048529960596, 99889627739043)

	Features:
	  • Built with SpectreUI v3.17 (Keyless official build)
	  • Auto Farm: Auto Cook Food, Instant Cook, Auto Seat Customers, Auto Take Orders, Auto Give Food
	  • Service: Auto Pickup Dirty Dishes, Auto Collect Bills, Auto Collect Tips, Auto Serve Drive Thru, Auto Calm Rude Customer
	  • Upgrades: Smart Auto Upgrade with custom selection & balance checking
	  • Farming: Auto Plant Crops, Auto Harvest Crops, Destroy Crops, Farm Teleport
	  • Shops: Auto Buy Ingredients from FarmShop, Supermarket, Butcher, Fishmonger, Bakery
	  • Rewards: Auto Claim Daily Rewards, Auto Complete & Collect Objectives, Redeem All Codes
	  • Teleports: Tycoon, Plaza, EKEA, Campsite, Farm, Supermarket, Butcher, Fishmonger, Bakery
	  • Visuals & Player: ESP / Chams, Fullbright, X-Ray, Fly, Noclip, Custom WalkSpeed / JumpPower, Anti-AFK
]]

-- ===================== GAME GUARD =====================
local supportedPlaces = {
	[119048529960596] = true,
	[99889627739043]  = true,
}

if not supportedPlaces[game.PlaceId] then
	-- Allow execution if PlaceId matches, or warn if injected into wrong place
	warn(string.format("[SpectreWare | RT3] Unexpected PlaceId: %s", tostring(game.PlaceId)))
end

-- ===================== EXECUTOR IDENTITY =====================
pcall(function()
	local set = setthreadidentity or set_thread_identity or setthreadcontext or set_identity
	if set then pcall(set, 8) pcall(set, 7) end
end)

-- ===================== SPECTRE UI LIBRARY LOADER =====================
local Library
pcall(function()
	if isfile and isfile("SpectreUI.lua") and readfile then
		local c = readfile("SpectreUI.lua")
		if #c > 20000 then
			c = c:gsub(
				"if parent then o%.Parent = parent end",
				"if parent then local ok = pcall(function() o.Parent = parent end) if not ok then local setid = setthreadidentity or set_thread_identity or setthreadcontext or set_identity or (syn and syn.set_thread_identity) if setid then pcall(setid, 8) end pcall(function() o.Parent = parent end) end end"
			)
			Library = loadstring(c)()
		end
	end
end)

if not Library then
	pcall(function()
		local ok, res = pcall(function()
			return game:HttpGet("https://raw.githubusercontent.com/SpectreWareZ/SpectreWare/refs/heads/main/Tools/Ui/SpectreUI.lua")
		end)
		if ok and type(res) == "string" and #res > 20000 then
			res = res:gsub(
				"if parent then o%.Parent = parent end",
				"if parent then local ok = pcall(function() o.Parent = parent end) if not ok then local setid = setthreadidentity or set_thread_identity or setthreadcontext or set_identity or (syn and syn.set_thread_identity) if setid then pcall(setid, 8) end pcall(function() o.Parent = parent end) end end"
			)
			Library = loadstring(res)()
		end
	end)
end

if not Library then
	return warn("[SpectreWare] Failed to load SpectreUI library from storage or GitHub.")
end

-- ===================== SERVICES & LOCALS =====================
local players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local httpService = game:GetService("HttpService")
local userInputService = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local teleportService = game:GetService("TeleportService")
local stats = game:GetService("Stats")
local virtualUser = game:GetService("VirtualUser")
local virtualInputManager = game:GetService("VirtualInputManager")

local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)

local BRAND = {
	Name    = "SpectreWare",
	Version = "1.0.0",
	Discord = "https://discord.gg/GdKxvcHzjS",
	Logo    = 84699118856259,
}

-- ===================== GENERATION GUARD =====================
getgenv()._rt3_gen = (getgenv()._rt3_gen or 0) + 1
local MY_GEN = getgenv()._rt3_gen
local function isCurrentGen()
	return getgenv()._rt3_gen == MY_GEN
end

-- Cleanup old UIs
pcall(function()
	local function clean(parent)
		if not parent then return end
		for _, c in ipairs(parent:GetChildren()) do
			if c:IsA("ScreenGui") and (c.Name:find("Samuraa1") or c.Name:find("Mentality") or c.Name == "SpectreUI_RT3") then
				pcall(function() c:Destroy() end)
			end
		end
	end
	clean(game:GetService("CoreGui"))
	if gethui then clean(gethui()) end
	if playerGui then clean(playerGui) end
end)

-- Theme setup
pcall(function()
	if Library and Library.Themes then
		Library.Themes.Spectre = {
			Background = Color3.fromRGB(10, 13, 20),
			Panel      = Color3.fromRGB(14, 19, 30),
			Card       = Color3.fromRGB(20, 27, 42),
			Control    = Color3.fromRGB(28, 38, 58),
			Border     = Color3.fromRGB(35, 48, 72),
			Accent     = Color3.fromRGB(56, 189, 248),
			Accent2    = Color3.fromRGB(37, 99, 235),
			AccentSoft = Color3.fromRGB(10, 26, 48),
			Sheen      = Color3.fromRGB(186, 230, 253),
			Text       = Color3.fromRGB(240, 246, 255),
			SubText    = Color3.fromRGB(125, 142, 172),
			FX         = "snow",
		}
	end
end)

-- ===================== GAME REMOTES =====================
local events = replicatedStorage:WaitForChild("Events", 10)
if not events then return warn("[SpectreWare | RT3] Failed to locate ReplicatedStorage.Events") end

local taskCompleted = events:WaitForChild("Restaurant"):WaitForChild("TaskCompleted")
local customerActionReplicated = events.Restaurant:WaitForChild("CustomerActionReplicated")
local cookInputRequested = events:WaitForChild("Cook"):WaitForChild("CookInputRequested")
local grabFood = events.Restaurant:FindFirstChild("GrabFood")
local tipsCollected = events.Restaurant:FindFirstChild("TipsCollected")
local getRudeCustomerDialog = events.Restaurant:FindFirstChild("Customers") and events.Restaurant.Customers:FindFirstChild("GetRudeCustomerDialog")
local dialogCompleted = events:FindFirstChild("Dialog") and events.Dialog:FindFirstChild("DialogCompleted")

local unlockUpgradeRequested = events:FindFirstChild("Upgrades") and events.Upgrades:FindFirstChild("UnlockUpgradeRequested")
local requestCropPlant = events:FindFirstChild("Farming") and events.Farming:FindFirstChild("RequestCropPlant")
local requestHarvest = events:FindFirstChild("Farming") and events.Farming:FindFirstChild("RequestHarvest")

-- ===================== CORE AUTOMATION STATE =====================
local v8 = {
	AutoCustomer  = false,
	PickupCash    = false,
	PickupDishes  = false,
	AutoTakeOrder = false,
	AutoCook      = false,
	InstantCook   = false,
	AutoGiveFood  = false,
	AutoDriveThru = false,
	AutoTips      = false,
}

_G.AutoCalmRude = false
_G.CollectDropMoney = false
_G.AutoDailyReward = false
_G.AutoTestRewardq = false
_G.AutoUpgrade = false
_G.AutoPlant = false
_G.AutoHarvest = false
_G.SelectedCrops = {}
_G.AutoBuyIngredients = false
_G.IngredientsToBuy = {}
_G.AutoBuySupermarket = false
_G.SupermarketIngredients = {}
_G.AutoBuyButcher = false
_G.ButcherIngredients = {}
_G.AutoBuyFishmonger = false
_G.FishmongerIngredients = {}
_G.AutoBuyBakery = false
_G.BakeryIngredients = {}

-- Rate limiter & framerate tracker
local v9 = 0.016666666666667
local heartbeat = runService.Heartbeat
heartbeat:Connect(function(dt)
	v9 = v9 * 0.9 + math.clamp(dt, 0.0041666666666667, 0.2) * 0.1
end)

local function f8()
	if v9 > 0.03125 then return 1, 0.05 end
	if v9 > 0.022222222222222 then return 3, 0.025 end
	return 6, 0.012
end

local v12 = 0
local v13 = 0
local function f9(p6)
	local v14 = p6 or 1
	local v15 = os.clock()
	if v15 - v13 >= 0.5 then
		v12 = 0
		v13 = v15
	end
	if v12 + v14 <= 260 then
		v12 = v12 + v14
		return true
	end
	return false
end

local function f4(p1)
	if not (p1 and p1.Parent) then return end
	local holdDuration = p1.HoldDuration
	local maxActivationDistance = p1.MaxActivationDistance
	if holdDuration ~= 0 then p1.HoldDuration = 0 end
	if maxActivationDistance < 100 then p1.MaxActivationDistance = 100 end

	p1:InputHoldBegin()
	task.wait()
	if p1.Parent then p1:InputHoldEnd() end
	if holdDuration ~= 0 and p1.Parent then p1.HoldDuration = holdDuration end
	if maxActivationDistance < 100 and p1.Parent then p1.MaxActivationDistance = maxActivationDistance end
end

local function f5(p2, ...)
	return pcall(p2.InvokeServer, p2, ...)
end

local function f7(p4, ...)
	return pcall(p4.FireServer, p4, ...)
end

-- Tycoon Resolution
local v16 = 0
local v17 = nil
local function f10()
	local v18 = v17
	local v19 = os.clock()
	if v18 and v18.Parent and v19 < v16 then
		return v18
	end

	local v20 = nil
	local tycoons = workspace:FindFirstChild("Tycoons")
	if tycoons then
		for _, value in ipairs(tycoons:GetChildren()) do
			local owner = value:FindFirstChild("Owner")
			if owner and owner:IsA("ObjectValue") and owner.Value == localPlayer then
				v20 = value
				break
			end
		end
		if not v20 then
			for _, value2 in ipairs(tycoons:GetChildren()) do
				for _, value3 in ipairs(value2:GetChildren()) do
					if value3:IsA("ObjectValue") and value3.Value == localPlayer then
						v20 = value2
						break
					end
				end
				if v20 then break end
			end
		end
	end

	v17 = v20
	v16 = v19 + (v20 and 4 or 0.5)
	return v20
end

local function f11(name3, furnitureModel, tycoon)
	if taskCompleted and f9() then
		f7(taskCompleted, { Tycoon = tycoon, Name = name3, FurnitureModel = furnitureModel })
	end
end

local function f12(p7, p8, p9)
	if not (taskCompleted and customerActionReplicated) then return end
	if not f9(2) then return end
	f7(taskCompleted, { GroupId = p8, Tycoon = p9, Name = "TakeOrder", CustomerId = p7 })
	f7(customerActionReplicated, p9, "SetCustomerState", p7, p8, "WaitingForDish")
end

local function f13(p10, p11, p12, p13)
	local items = p10:FindFirstChild("Items")
	local surface = items and items:FindFirstChild("Surface")
	if not surface then return end
	local huge = p13 or math.huge
	local count = 0
	for _, value4 in ipairs(surface:GetChildren()) do
		if value4:FindFirstChild(p11) then
			f11(p12, value4, p10)
			count = count + 1
			if count >= huge then break end
		end
	end
end

-- Customer Speech Cache
local v21 = { list = {}, byKey = {}, byCust = {}, valid = false, buildTime = 0 }
local function f14()
	local v22 = {}
	local v23 = {}
	local v24 = {}
	for _, value5 in ipairs(playerGui:GetChildren()) do
		if value5.Name == "CustomerSpeechUI" then
			local adornee = value5.Adornee
			if adornee then
				local model = adornee:FindFirstAncestorOfClass("Model")
				local parent = model and model.Parent
				if model and parent then
					local findFirstChild = value5:FindFirstChild("Header", true)
					if findFirstChild and findFirstChild:IsA("TextLabel") then
						local name4 = model.Name
						local name5 = parent.Name
						local v25 = {
							ui = value5,
							customerId = name4,
							groupId = name5,
							header = findFirstChild,
							key = name5 .. ":" .. name4,
						}
						v24[#v24 + 1] = v25
						v23[v25.key] = v25
						if not v22[name4] then v22[name4] = v25 end
					end
				end
			end
		end
	end
	v21.list = v24
	v21.byKey = v23
	v21.byCust = v22
	v21.valid = true
	v21.buildTime = os.clock()
end

playerGui.ChildAdded:Connect(function(c) if c.Name == "CustomerSpeechUI" then v21.valid = false end end)
playerGui.ChildRemoved:Connect(function(c) if c.Name == "CustomerSpeechUI" then v21.valid = false end end)

local function f15(p14)
	local objects = p14 and p14:FindFirstChild("Objects")
	if not objects then return nil end
	return objects:FindFirstChild("Food") or objects:FindFirstChild("Foods")
end

local function f16()
	if not v21.valid or os.clock() - v21.buildTime > 0.5 then f14() end
	return v21.list
end

local function f17(p15)
	local header = p15 and p15.header
	if not (header and header.Parent) then return false end
	local text = header.Text
	if not text or text == "" then return false end
	return string.find(string.lower(text), "table for", 1, true) ~= nil
end

local function f18(p16, p17)
	if not p16 then return nil end
	local getAttribute = p16:GetAttribute(p17)
	if getAttribute ~= nil then return tostring(getAttribute) end
	local findFirstChild2 = p16:FindFirstChild(p17)
	if findFirstChild2 and (findFirstChild2:IsA("StringValue") or findFirstChild2:IsA("IntValue") or findFirstChild2:IsA("NumberValue")) then
		return tostring(findFirstChild2.Value)
	end
	return nil
end

local v27 = {}
local v28 = 0
local function f19(p18, p19)
	local v29 = os.clock()
	for i = 1, #p19 do
		local v30 = p19[i]
		if not f17(v30) then
			local key = v30.key
			local v31 = v27[key]
			if not v31 or v29 - v31 >= 0.35 then
				f12(v30.customerId, v30.groupId, p18)
				v27[key] = v29
			end
		end
	end
	if v29 - v28 > 5 then
		v28 = v29
		for key2, value6 in pairs(v27) do
			if v29 - value6 > 10 then v27[key2] = nil end
		end
	end
end

local v32 = {}
local v33 = 1
local v34 = 1
local v35 = nil
local v26 = 0
local function f20(p20)
	local v36 = os.clock()
	if v35 == p20 and v36 < v26 then
		return v32
	end
	local v37 = {}
	local clientCars = p20 and p20:FindFirstChild("ClientCars")
	if clientCars then
		for _, value7 in ipairs(clientCars:GetChildren()) do
			if tonumber(value7.Name) then v37[#v37 + 1] = value7.Name end
		end
		table.sort(v37, function(a, b) return tonumber(a) < tonumber(b) end)
	end
	v35 = p20
	v32 = v37
	v26 = v36 + 0.2
	if v34 > #v37 then v34 = 1 end
	return v37
end

local v38 = {}
local function f21(p23)
	if not p23 or not p23.Parent then return false end
	if p23:FindFirstChild("Bill") or p23:FindFirstChild("Trash") then return false end
	if p23:GetAttribute("Occupied") or p23:GetAttribute("IsOccupied") or p23:GetAttribute("InUse") or p23:GetAttribute("Taken") then
		return false
	end
	local v39 = v38[p23]
	if v39 then
		for j = 1, #v39 do
			if v39[j].Occupant then return false end
		end
	end
	return true
end

local v40 = 0
local v41 = {}
local v42 = 0
local v43 = nil
local function f22(p24)
	local v44 = os.clock()
	if v43 == p24 and v44 < v40 then return v41 end
	local v45 = {}
	local v46 = {}
	local items2 = p24:FindFirstChild("Items")
	local surface2 = items2 and items2:FindFirstChild("Surface")
	if surface2 then
		for _, value8 in ipairs(surface2:GetChildren()) do
			if value8.Name:match("^T%d+$") then
				v45[#v45 + 1] = value8
				local v47 = {}
				for _, value9 in ipairs(value8:GetDescendants()) do
					if value9:IsA("Seat") then v47[#v47 + 1] = value9 end
				end
				v46[value8] = v47
			end
		end
	end
	v38 = v46
	v43 = p24
	v41 = v45
	v40 = v44 + 1
	if v42 > #v45 then v42 = 0 end
	return v45
end

local function f23(p25)
	local v48 = f15(p25)
	if not v48 or not grabFood then return end
	local getChildren = v48:GetChildren()
	local v49 = #getChildren
	if v49 == 0 then v33 = 1; v34 = 1; return end
	local v50 = f20(p25)
	local v51 = #v50
	if v51 == 0 then v34 = 1; return end
	if v33 > v49 then v33 = 1 end
	if v34 > v51 then v34 = 1 end

	local v52 = f8()
	for k = 1, math.min(v49, math.min(v52, 4)) do
		local v53 = getChildren[v33]
		if not v53 or v53.Parent ~= v48 then break end
		if f9() then f5(grabFood, v53) end
		local v54 = f18(v53, "CarId")
		local v55 = v54 or v50[v34]
		if v55 and f9(2) then
			f7(taskCompleted, { Name = "Serve", Tycoon = p25, FoodModel = v53, CarId = v55 })
			f7(taskCompleted, { Name = "CollectDriveThruBill", Tycoon = p25, CarId = v55 })
		end
		if not v54 then
			v34 = v34 + 1
			if v34 > v51 then v34 = 1 end
		end
		v33 = v33 + 1
		if v33 > v49 then v33 = 1 end
	end
end

local v56 = {}
local v57 = 0
local function f24(p26, p27)
	local v58 = f22(p26)
	local v59 = #v58
	if v59 == 0 then return end
	local v60 = os.clock()
	local v61 = {}
	for m = 1, #p27 do
		local v62 = p27[m]
		if f17(v62) then
			local groupId = v62.groupId
			if not v61[groupId] then
				v61[groupId] = true
				local v63 = v56[groupId]
				if not v63 or v60 - v63 >= 0.25 then
					local v64 = nil
					for n = 1, v59 do
						local v65 = (v42 + n - 1) % v59 + 1
						local v66 = v58[v65]
						if f21(v66) then
							v42 = v65
							v64 = v66
							break
						end
					end
					if v64 and f9() then
						f7(taskCompleted, { FurnitureModel = v64, Tycoon = p26, Name = "SendToTable", GroupId = groupId })
						v56[groupId] = v60
					end
				end
			end
		end
	end
	if v60 - v57 > 6 then
		v57 = v60
		for key3, value10 in pairs(v56) do
			if v60 - value10 > 12 then v56[key3] = nil end
		end
	end
end

local v67 = 1
local v68 = 1
local function f25(p28, p29)
	local v69 = f15(p28)
	if not v69 or not grabFood then return end
	local getChildren2 = v69:GetChildren()
	local v70 = #getChildren2
	if v70 == 0 then v67 = 1; v68 = 1; return end

	local v71 = {}
	for i6 = 1, #p29 do
		local v72 = p29[i6]
		if not f17(v72) then v71[#v71 + 1] = v72 end
	end
	local v73 = #v71
	if v73 == 0 then v68 = 1; return end
	if v67 > v70 then v67 = 1 end
	if v68 > v73 then v68 = 1 end

	local v74 = f8()
	local v75 = math.min(v70, v74)
	local byKey = v21.byKey
	local byCust = v21.byCust

	for i7 = 1, v75 do
		local v76 = getChildren2[v67]
		if not v76 or v76.Parent ~= v69 then break end
		if f9() then f5(grabFood, v76) end
		local v77 = f18(v76, "CustomerId")
		local v78 = nil
		local v79 = f18(v76, "GroupId")
		if v77 then v78 = v79 and byKey[v79 .. ":" .. v77] or byCust[v77] end

		if v78 then
			if f9() then
				f7(taskCompleted, { Name = "Serve", Tycoon = p28, FoodModel = v76, CustomerId = v78.customerId, GroupId = v78.groupId })
			end
		else
			local v80 = math.min(v73, v74 >= 5 and 3 or v74)
			local v81 = v68
			for i8 = 1, v80 do
				local v82 = v71[v81]
				if v82 and f9() then
					f7(taskCompleted, { Name = "Serve", Tycoon = p28, FoodModel = v76, CustomerId = v82.customerId, GroupId = v82.groupId })
				end
				v81 = v81 + 1
				if v81 > v73 then v81 = 1 end
			end
			v68 = v81
		end
		v67 = v67 + 1
		if v67 > v70 then v67 = 1 end
	end
end

local v83 = 1
local function f26(p30, p31)
	if not (getRudeCustomerDialog and dialogCompleted) then return end
	local v84 = #p31
	if v84 == 0 then v83 = 1; return end
	if v83 > v84 then v83 = 1 end

	for i9 = 1, math.min(v84, 3) do
		local v85 = p31[v83]
		v83 = v83 + 1
		if v83 > v84 then v83 = 1 end
		if v85 and not f17(v85) and f9() then
			local v86, v87 = f5(getRudeCustomerDialog, p30, v85.customerId, v85.groupId)
			local v88 = false
			if v86 then
				if type(v87) == "string" then
					local v89 = string.lower(v87)
					v88 = v89 ~= "" and not string.find(v89, "already", 1, true) and not string.find(v89, "not rude", 1, true)
				else
					v88 = v87 ~= nil
				end
			end
			if v88 then
				if f9() then
					f5(getRudeCustomerDialog, p30, v85.customerId, v85.groupId, "We really appreciate you bringing this to our attention.")
				end
				if f9() then f7(dialogCompleted) end
				break
			end
		end
	end
end

-- Cook prompt tracker
local v10 = {}
local v90 = {}
local v11 = true
local f27

local function f6(p3)
	if p3:IsA("ProximityPrompt") and not v10[p3] then
		v10[p3] = true
		v11 = true
	end
end

local function f28(p32)
	if not p32 or p32:GetAttribute("_rt3_watched") then return end
	p32:SetAttribute("_rt3_watched", true)
	for _, value11 in ipairs(p32:GetDescendants()) do f6(value11) end
	p32.DescendantAdded:Connect(f6)
	p32.DescendantRemoving:Connect(f27)
end

function f27(p33)
	if v10[p33] then
		v10[p33] = nil
		v11 = true
	end
end

f28(workspace:FindFirstChild("Temp"))
workspace.ChildAdded:Connect(function(child3)
	if child3.Name == "Temp" then f28(child3) end
end)

local function f29()
	if v11 then
		local v91 = {}
		for key4 in pairs(v10) do
			if not key4.Parent then
				v10[key4] = nil
			elseif key4.ActionText == "Cook" then
				v91[#v91 + 1] = key4
			end
		end
		v90 = v91
		v11 = false
	end
	return v90
end

task.spawn(function()
	while isCurrentGen() do
		task.wait(0.6)
		v21.valid = false
		v11 = true
	end
end)

-- Background Automation Loop 1 (Customers, Orders, Serve, Rude)
task.spawn(function()
	local v92 = 0
	local v93 = 0
	local v94 = 0
	local v95 = 0
	while isCurrentGen() do
		task.wait()
		if v8.AutoTakeOrder or v8.AutoCustomer or v8.AutoGiveFood or _G.AutoCalmRude then
			local v96 = f10()
			if v96 then
				local v97 = os.clock()
				local v98 = f16()
				local _, v100 = f8()
				if v8.AutoTakeOrder and v97 - v94 >= 0.05 then
					f19(v96, v98)
					v94 = v97
				end
				if v8.AutoCustomer and v97 - v95 >= 0.06 then
					f24(v96, v98)
					v95 = v97
				end
				if v8.AutoGiveFood and v97 - v92 >= v100 then
					f25(v96, v98)
					v92 = v97
				end
				if _G.AutoCalmRude and v97 - v93 >= 0.18 then
					f26(v96, v98)
					v93 = v97
				end
			end
		end
	end
end)

-- Background Automation Loop 2 (Cooking & Instant Cook)
task.spawn(function()
	local v101 = 0
	local v102 = 0
	while isCurrentGen() do
		task.wait()
		local instantCook = v8.InstantCook
		local autoCook = v8.AutoCook
		if autoCook or instantCook then
			if f10() then
				local v103 = os.clock()
				local v104 = v9 > 0.03125 and 6 or 12
				if autoCook and v103 - v102 >= 0.07 then
					local v105 = f29()
					local v106 = #v105
					if v106 > 0 then
						for i10 = 1, math.min(v106, 6) do
							local v107 = v105[i10]
							if v107 and v107.Parent then task.spawn(f4, v107) end
						end
						local v108 = math.max(4, v104 - 4)
						for i11 = 1, v108 do
							if f9() then f7(cookInputRequested, "Interact", workspace, "Oven") end
						end
					end
					v102 = v103
				end
				if instantCook and v103 - v101 >= 0.04 then
					for i12 = 1, v104 do
						if f9() then f7(cookInputRequested, "Interact", workspace, "Oven") end
					end
					v101 = v103
				end
			end
		end
	end
end)

-- Background Automation Loop 3 (Drive Thru)
task.spawn(function()
	local v109 = 0
	while isCurrentGen() do
		task.wait()
		if v8.AutoDriveThru then
			local v110 = f10()
			if v110 then
				local v111 = os.clock()
				local v112 = { f8() }
				if v111 - v109 >= v112[2] then
					f23(v110)
					v109 = v111
				end
			end
		end
	end
end)

-- Background Automation Loop 4 (Bills, Dishes, Tips)
task.spawn(function()
	local v113 = 0
	local v114 = 0
	local v115 = 0
	while isCurrentGen() do
		task.wait(0.05)
		if v8.PickupCash or v8.PickupDishes or v8.AutoTips then
			local v116 = f10()
			if v116 then
				local v117 = os.clock()
				if v8.PickupCash and v117 - v115 >= 0.1 then
					f13(v116, "Bill", "CollectBill", 12)
					v115 = v117
				end
				if v8.PickupDishes and v117 - v114 >= 0.1 then
					f13(v116, "Trash", "CollectDishes", 12)
					v114 = v117
				end
				if v8.AutoTips and tipsCollected and v117 - v113 >= 0.4 then
					if f9() then f7(tipsCollected, v116) end
					v113 = v117
				end
			end
		end
	end
end)

-- Objectives Auto Collect
task.spawn(function()
	local function f30(p34)
		if not p34 or not p34.Parent then return end
		pcall(function()
			if firesignal then
				firesignal(p34.MouseButton1Click)
				firesignal(p34.Activated)
			else
				local v118 = p34.AbsolutePosition + p34.AbsoluteSize / 2
				virtualInputManager:SendMouseButtonEvent(v118.X, v118.Y, 0, true, game, 0)
				task.wait(0.15)
				virtualInputManager:SendMouseButtonEvent(v118.X, v118.Y, 0, false, game, 0)
			end
		end)
	end

	local function f31(p35)
		local findFirstChild3 = p35:FindFirstChild("SelectButton", true)
		if findFirstChild3 then
			for _ = 1, 2 do f30(findFirstChild3); task.wait(0.4) end
		end
	end

	local function f32()
		task.wait(1.5)
		local rewardDisplay = localPlayer.PlayerGui:FindFirstChild("RewardDisplay")
		if rewardDisplay then rewardDisplay = rewardDisplay.Frame.Buttons:FindFirstChild("AddToMenu") end
		if rewardDisplay and rewardDisplay.Visible then
			for _ = 1, 3 do f30(rewardDisplay); task.wait(0.5) end
		end
	end

	pcall(function()
		local collectBtn = localPlayer.PlayerGui:WaitForChild("Objectives", 5)
		collectBtn = collectBtn and collectBtn:WaitForChild("Frame", 5)
		collectBtn = collectBtn and collectBtn:WaitForChild("Standard", 5)
		collectBtn = collectBtn and collectBtn:WaitForChild("CollectRewardButton", 5)

		if collectBtn then
			task.spawn(function()
				while isCurrentGen() do
					task.wait(0.5)
					if _G.AutoTestRewardq and collectBtn.Visible then
						pcall(function()
							replicatedStorage.Events.Rewards.RewardRequested:FireServer("Obejctives")
						end)
						task.wait(1)
					end
				end
			end)
		end

		local selectReward = localPlayer.PlayerGui:WaitForChild("SelectReward", 5)
		if selectReward and selectReward:FindFirstChild("Frame") then
			selectReward.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
				if selectReward.Frame.Visible and _G.AutoTestRewardq then
					task.wait(2.8)
					if not selectReward.Frame.Visible then return end
					local v119 = {}
					for _, value12 in ipairs(selectReward.Frame.List:GetChildren()) do
						if value12:IsA("ImageLabel") and value12.Name:match("^Reward_%d+$") then
							table.insert(v119, value12)
						end
					end
					if #v119 > 0 then
						f31(v119[math.random(1, #v119)])
						task.wait(3.5)
						f32()
					end
				end
			end)
		end
	end)
end)

-- Upgrades Dictionary
local UPGRADE_LIST = {}
local UPGRADE_MAP = {}
for _, item in ipairs({
	{ Name = "TipJar", Price = 150 }, { Name = "WaiterTray", Price = 200 },
	{ Name = "Drinks", Price = 250 }, { Name = "Level2Kitchens", Price = 400 },
	{ Name = "PosterAdvertising", Price = 600 }, { Name = "KidsMenu", Price = 600 },
	{ Name = "ManagerDesk", Price = 700 }, { Name = "RestaurantStorage", Price = 800 },
	{ Name = "WaiterCart", Price = 900 }, { Name = "RestaurantControls", Price = 950 },
	{ Name = "LeftExpansion1", Price = 1200 }, { Name = "RightExpansion1", Price = 1200 },
	{ Name = "Franchise", Price = 1200 }, { Name = "Security", Price = 1250 },
	{ Name = "Level3Kitchens", Price = 1500 }, { Name = "NewspaperAdvertising", Price = 1600 },
	{ Name = "CardPayments", Price = 1750 }, { Name = "BackExpansion1", Price = 1800 },
	{ Name = "DriveThru", Price = 2000 }, { Name = "BillboardAdvertising", Price = 2750 },
	{ Name = "LeftExpansion2", Price = 3400 }, { Name = "RightExpansion2", Price = 3400 },
	{ Name = "BackExpansion2", Price = 4200 }, { Name = "TVAdvertising", Price = 5500 },
	{ Name = "LeftExpansion3", Price = 6000 }, { Name = "RightExpansion3", Price = 6000 },
	{ Name = "SecondFloor", Price = 12500 }, { Name = "ThirdFloor", Price = 45000 },
}) do
	local label = item.Name .. " ($" .. item.Price .. ")"
	UPGRADE_LIST[#UPGRADE_LIST + 1] = label
	UPGRADE_MAP[label] = item
end

-- Auto Upgrade Loop
task.spawn(function()
	while isCurrentGen() do
		task.wait(0.5)
		if _G.AutoUpgrade then
			local selected = Library and Library.Flags and Library.Flags.UpgradeDropdown
			if type(selected) == "table" and #selected > 0 then
				local tycoon = f10()
				local cash = localPlayer:FindFirstChild("Cash")
				if tycoon and cash and unlockUpgradeRequested then
					for _, label in ipairs(selected) do
						local upg = UPGRADE_MAP[label]
						if upg and cash.Value >= upg.Price then
							pcall(function() unlockUpgradeRequested:FireServer(tycoon, upg.Name) end)
							task.wait(0.2)
						end
					end
				end
			end
		end
	end
end)

-- Crops Farming Loops
task.spawn(function()
	while isCurrentGen() do
		if _G.AutoPlant and requestCropPlant then
			local sel = _G.SelectedCrops
			if sel and #sel > 0 then
				for i = 1, 8 do
					if not _G.AutoPlant then break end
					local crop = sel[math.random(1, #sel)]
					if crop then
						pcall(function() requestCropPlant:InvokeServer(crop, "Tile" .. i) end)
					end
					task.wait(0.3)
				end
			else
				task.wait(0.3)
			end
		end
		task.wait(0.5)
	end
end)

task.spawn(function()
	while isCurrentGen() do
		if _G.AutoHarvest and requestHarvest then
			for i = 1, 8 do
				if not _G.AutoHarvest then break end
				pcall(function() requestHarvest:InvokeServer("Tile" .. i) end)
				task.wait(0.3)
			end
		end
		task.wait(0.5)
	end
end)

-- Drop Money Collection Loop
task.spawn(function()
	while isCurrentGen() do
		task.wait(0.5)
		if _G.CollectDropMoney then
			local dropFolder = workspace:FindFirstChild("DropFolder")
			local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
			if dropFolder and hrp then
				local children = dropFolder:GetChildren()
				if #children > 0 then
					local oldCF = hrp.CFrame
					for i = 1, #children do
						if not _G.CollectDropMoney then break end
						local part = children[i]
						if part and part:IsA("BasePart") then
							hrp.CFrame = part.CFrame
							task.wait(0.2)
						end
					end
					hrp.CFrame = oldCF
					task.wait(4)
				end
			end
		end
	end
end)

-- Auto Buy Ingredients Across All Shops
task.spawn(function()
	while isCurrentGen() do
		task.wait(0.1)
		local tycoon = f10()
		local purchaseRemote = events:FindFirstChild("Food") and events.Food:FindFirstChild("PurchaseIngredientRequested")
		if tycoon and purchaseRemote then
			if _G.AutoBuyIngredients and _G.IngredientsToBuy and #_G.IngredientsToBuy > 0 then
				for _, item in ipairs(_G.IngredientsToBuy) do
					pcall(function() purchaseRemote:FireServer(tycoon, item, "FarmShop") end)
					task.wait(0.1)
				end
			end
			if _G.AutoBuySupermarket and _G.SupermarketIngredients and #_G.SupermarketIngredients > 0 then
				for _, item in ipairs(_G.SupermarketIngredients) do
					pcall(function() purchaseRemote:FireServer(tycoon, item, "Supermarket") end)
					task.wait(0.1)
				end
			end
			if _G.AutoBuyButcher and _G.ButcherIngredients and #_G.ButcherIngredients > 0 then
				for _, item in ipairs(_G.ButcherIngredients) do
					pcall(function() purchaseRemote:FireServer(tycoon, item, "Butcher") end)
					task.wait(0.1)
				end
			end
			if _G.AutoBuyFishmonger and _G.FishmongerIngredients and #_G.FishmongerIngredients > 0 then
				for _, item in ipairs(_G.FishmongerIngredients) do
					pcall(function() purchaseRemote:FireServer(tycoon, item, "Fishmonger") end)
					task.wait(0.1)
				end
			end
			if _G.AutoBuyBakery and _G.BakeryIngredients and #_G.BakeryIngredients > 0 then
				for _, item in ipairs(_G.BakeryIngredients) do
					pcall(function() purchaseRemote:FireServer(tycoon, item, "Bakery") end)
					task.wait(0.1)
				end
			end
		end
	end
end)

-- Teleport helper
local function tp(pos)
	local char = localPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(pos)
	end
end

-- ===================== SPECTRE UI WINDOW =====================
local Window = Library:CreateWindow({
	Title     = BRAND.Name .. " | Restaurant Tycoon 3",
	Logo      = BRAND.Logo,
	ToggleKey = Enum.KeyCode.RightShift,
	Theme     = "Spectre",
	AutoCheck = { Skip = { TextClip = true } },
	Splash    = {
		Title     = "SPECTREWARE",
		Subtitle  = "RESTAURANT TYCOON 3",
		Duration  = 2.0,
		Steps     = { "Hooking tycoon events", "Indexing customers", "Preparing interface", "Ready!" },
		Logo      = BRAND.Logo,
		Skippable = true,
	},
})

if not Window then return warn("[SpectreWare] Failed to create SpectreUI window.") end

-- ===================== TAB 1: OVERVIEW =====================
local OverviewTab = Window:CreateTab({ Name = "Overview", Icon = "lucide:layout-dashboard" })

local StatsSec = OverviewTab:CreateSection({ Name = "Live Stats" })
local StatUptime = StatsSec:CreateKeyValue({ Name = "Uptime", Value = "00:00:00", Copyable = false })
local StatPlayer = StatsSec:CreateKeyValue({ Name = "Player", Value = localPlayer.DisplayName, Copyable = false })
local StatCash   = StatsSec:CreateKeyValue({ Name = "Cash",   Value = "$0", Copyable = false })
local StatTycoon = StatsSec:CreateKeyValue({ Name = "Tycoon", Value = "Searching...", Copyable = false })
local StatPing   = StatsSec:CreateKeyValue({ Name = "Ping",   Value = "0 ms", Copyable = false })

local StartedAt = os.clock()
task.spawn(function()
	while isCurrentGen() do
		pcall(function()
			local s = math.floor(os.clock() - StartedAt)
			StatUptime:Set(string.format("%02d:%02d:%02d", math.floor(s / 3600), math.floor(s % 3600 / 60), s % 60))
			StatPlayer:Set(localPlayer.DisplayName)
			local cashObj = localPlayer:FindFirstChild("Cash")
			if cashObj then
				StatCash:Set("$" .. tostring(cashObj.Value))
			end
			local ty = f10()
			StatTycoon:Set(ty and ty.Name or "Not Found")
			local dataPing = stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
			if dataPing then
				StatPing:Set(math.floor(dataPing:GetValue()) .. " ms")
			end
		end)
		task.wait(1)
	end
end)

local QuickSec = OverviewTab:CreateSection({ Name = "Quick Teleports" })
QuickSec:CreateButton({
	Name = "Teleport to Tycoon",
	Callback = function()
		events.Teleports.TeleportRequestedClient:Fire("Tycoon")
	end,
})
QuickSec:CreateButton({
	Name = "Teleport to Plaza",
	Callback = function()
		events.Teleports.TeleportRequestedClient:Fire("Plaza")
	end,
})
QuickSec:CreateButton({
	Name = "Teleport to EKEA",
	Callback = function()
		events.Teleports.TeleportRequestedClient:Fire("EKEA")
	end,
})
QuickSec:CreateButton({
	Name = "Teleport to Campsite",
	Callback = function()
		events.Teleports.TeleportRequestedClient:Fire("Campsite")
	end,
})
QuickSec:CreateButton({
	Name = "Teleport to Farm",
	Callback = function()
		events.Teleports.TeleportRequestedClient:Fire("Farm")
	end,
})

local AboutSec = OverviewTab:CreateSection({ Name = "Community & Actions" })
AboutSec:CreateButton({
	Name = "Copy Discord Invite",
	Callback = function()
		pcall(function()
			if setclipboard then setclipboard(BRAND.Discord) end
			Window:Toast("Copied Discord invite to clipboard!", "Success")
		end)
	end,
})
AboutSec:CreateButton({
	Name = "Rejoin Server",
	Callback = function()
		teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
	end,
})

-- ===================== TAB 2: RESTAURANT =====================
local RestTab = Window:CreateTab({ Name = "Restaurant", Icon = "lucide:utensils" })

local FarmSec = RestTab:CreateSection({ Name = "Auto Farm" })
local farmToggles = {}

FarmSec:CreateButton({
	Name = "Enable All Auto Farm",
	Callback = function()
		for _, tog in pairs(farmToggles) do
			if tog and tog.Set then tog:Set(true) end
		end
	end,
})
FarmSec:CreateButton({
	Name = "Disable All Auto Farm",
	Callback = function()
		for _, tog in pairs(farmToggles) do
			if tog and tog.Set then tog:Set(false) end
		end
	end,
})

farmToggles.AutoCook = FarmSec:CreateToggle({
	Name = "Auto Cook Food",
	Default = false,
	Flag = "AutoCook",
	Tooltip = "Automatically cook when prompts are available",
	Callback = function(v) v8.AutoCook = v end,
})
farmToggles.InstantCook = FarmSec:CreateToggle({
	Name = "Instant Cook (Rapid)",
	Default = false,
	Flag = "InstantCook",
	Tooltip = "Force rapid/instant cooking interact calls",
	Callback = function(v) v8.InstantCook = v end,
})
farmToggles.AutoCustomer = FarmSec:CreateToggle({
	Name = "Auto Seat Customers",
	Default = false,
	Flag = "AutoCustomer",
	Tooltip = "Automatically seat customers at available tables",
	Callback = function(v) v8.AutoCustomer = v end,
})
farmToggles.AutoTakeOrder = FarmSec:CreateToggle({
	Name = "Auto Take Orders",
	Default = false,
	Flag = "AutoTakeOrder",
	Tooltip = "Automatically take orders from waiting customers",
	Callback = function(v) v8.AutoTakeOrder = v end,
})
farmToggles.AutoGiveFood = FarmSec:CreateToggle({
	Name = "Auto Give Food",
	Default = false,
	Flag = "AutoGiveFood",
	Tooltip = "Automatically serve prepared food to customers",
	Callback = function(v) v8.AutoGiveFood = v end,
})
farmToggles.PickupDishes = FarmSec:CreateToggle({
	Name = "Auto Pickup Dirty Dishes",
	Default = false,
	Flag = "PickupDishes",
	Tooltip = "Collects trash & dirty dishes from tables",
	Callback = function(v) v8.PickupDishes = v end,
})
farmToggles.CollectBills = FarmSec:CreateToggle({
	Name = "Auto Collect Bills",
	Default = false,
	Flag = "CollectBills",
	Tooltip = "Automatically collect bill cash from tables",
	Callback = function(v) v8.PickupCash = v end,
})
farmToggles.AutoTips = FarmSec:CreateToggle({
	Name = "Auto Collect Tips",
	Default = false,
	Flag = "AutoTips",
	Tooltip = "Automatically collect tip jars & rewards",
	Callback = function(v) v8.AutoTips = v end,
})
farmToggles.CollectDropMoney = FarmSec:CreateToggle({
	Name = "Auto Collect Drop Money / Critic",
	Default = false,
	Flag = "CollectDropMoney",
	Tooltip = "Automatically teleports to collect money drops & critic cash",
	Callback = function(v) _G.CollectDropMoney = v end,
})
farmToggles.AutoDriveThru = FarmSec:CreateToggle({
	Name = "Auto Serve Drive-Thru",
	Default = false,
	Flag = "AutoDriveThru",
	Tooltip = "Automatically serve drive-thru cars & collect bills",
	Callback = function(v) v8.AutoDriveThru = v end,
})
farmToggles.AutoCalmRude = FarmSec:CreateToggle({
	Name = "Auto Calm Rude Customers",
	Default = false,
	Flag = "AutoCalmRude",
	Tooltip = "Resolves dialogue with angry customers instantly",
	Callback = function(v) _G.AutoCalmRude = v end,
})

local ManageSec = RestTab:CreateSection({ Name = "Restaurant Controls" })
ManageSec:CreateButton({
	Name = "Open Restaurant",
	Callback = function()
		local ty = f10()
		if ty then events.Restaurant.RestaurantStatusUpdated:FireServer(ty, "Open") end
	end,
})
ManageSec:CreateButton({
	Name = "Close Restaurant",
	Callback = function()
		local ty = f10()
		if ty then events.Restaurant.RestaurantStatusUpdated:FireServer(ty, "Closed") end
	end,
})
ManageSec:CreateButton({
	Name = "Kick All Customers",
	Callback = function()
		local ty = f10()
		if ty then events.Restaurant.RestaurantStatusUpdated:FireServer(ty, "Empty") end
	end,
})

local newRestName = ""
ManageSec:CreateTextbox({
	Name = "New Restaurant Name",
	Placeholder = "Enter restaurant name...",
	Callback = function(t) newRestName = tostring(t or "") end,
})
ManageSec:CreateButton({
	Name = "Apply Name Change",
	Callback = function()
		local ty = f10()
		if ty and newRestName ~= "" then
			events.Restaurant.RestaurantNameUpdated:FireServer(ty, newRestName)
			Window:Toast("Restaurant name updated!", "Success")
		end
	end,
})

local UpgSec = RestTab:CreateSection({ Name = "Auto Upgrades" })
UpgSec:CreateToggle({
	Name = "Enable Auto Upgrade",
	Default = false,
	Flag = "AutoUpgrade",
	Tooltip = "Purchases selected upgrades when you have enough cash",
	Callback = function(v) _G.AutoUpgrade = v end,
})

local upgDropdown = UpgSec:CreateDropdown({
	Name = "Selected Upgrades",
	Options = UPGRADE_LIST,
	Default = {},
	Multi = true,
	Flag = "UpgradeDropdown",
	Tooltip = "Choose which upgrades to purchase automatically",
})
UpgSec:CreateButton({
	Name = "Select All Upgrades",
	Callback = function()
		if upgDropdown and upgDropdown.Set then upgDropdown:Set(UPGRADE_LIST) end
	end,
})
UpgSec:CreateButton({
	Name = "Clear Upgrade Selection",
	Callback = function()
		if upgDropdown and upgDropdown.Set then upgDropdown:Set({}) end
	end,
})

local RewardsSec = RestTab:CreateSection({ Name = "Rewards & Codes" })
RewardsSec:CreateToggle({
	Name = "Auto Claim Daily Reward",
	Default = false,
	Flag = "ClaimDailyReward",
	Tooltip = "Claims daily reward automatically on timer",
	Callback = function(v)
		_G.AutoDailyReward = v
		if v then
			task.spawn(function()
				while _G.AutoDailyReward and isCurrentGen() do
					task.wait(5)
					pcall(function() events.DailyRewards.DailyRewardClaimed:FireServer() end)
				end
			end)
		end
	end,
})
RewardsSec:CreateToggle({
	Name = "Auto Complete Objectives",
	Default = false,
	Flag = "AutoCollectObjectives",
	Tooltip = "Automatically claims and redeems objectives",
	Callback = function(v) _G.AutoTestRewardq = v end,
})
RewardsSec:CreateButton({
	Name = "Redeem Known Codes",
	Callback = function()
		pcall(function()
			events.Shop.CodeSubmitted:FireServer("dineanddash")
			events.Shop.CodeSubmitted:FireServer("UltrawEats")
			Window:Toast("Redeemed codes: dineanddash, UltrawEats", "Success")
		end)
	end,
})

-- ===================== TAB 3: FARMING & SHOPS =====================
local FarmTab = Window:CreateTab({ Name = "Farm & Shops", Icon = "lucide:shopping-bag" })

local CropsSec = FarmTab:CreateSection({ Name = "Crops & Farm" })
local cropList = { "Onion", "Wheat", "Sugarcane", "Tomato", "Carrot", "Potato", "Berry Bush", "Lettuce", "Apple Tree" }

CropsSec:CreateDropdown({
	Name = "Crops to Plant",
	Options = cropList,
	Default = { "Onion", "Wheat" },
	Multi = true,
	Flag = "CropSelection",
	Tooltip = "Choose crops to automatically plant in tiles",
	Callback = function(v) _G.SelectedCrops = type(v) == "table" and v or {} end,
})
CropsSec:CreateToggle({
	Name = "Auto Plant Crops",
	Default = false,
	Flag = "AutoPlant",
	Callback = function(v) _G.AutoPlant = v end,
})
CropsSec:CreateToggle({
	Name = "Auto Harvest Crops (Fridge Required)",
	Default = false,
	Flag = "AutoHarvest",
	Callback = function(v) _G.AutoHarvest = v end,
})
CropsSec:CreateButton({
	Name = "Destroy All Crops",
	Callback = function()
		for i = 1, 8 do
			events.Farming.CropRemoved:FireServer("Tile" .. i)
		end
		Window:Toast("Crops removed", "Warning")
	end,
})

local FarmShopSec = FarmTab:CreateSection({ Name = "Farm Shop Ingredients" })
FarmShopSec:CreateToggle({
	Name = "Auto Buy Farm Ingredients",
	Default = false,
	Flag = "AutoBuyIngredients",
	Callback = function(v) _G.AutoBuyIngredients = v end,
})
FarmShopSec:CreateDropdown({
	Name = "Farm Ingredients",
	Options = { "Sugar", "Onion", "Mushroom", "Tomato", "Pepper", "Cheese", "Milk", "Lettuce" },
	Default = {},
	Multi = true,
	Flag = "IngredientsToBuy",
	Callback = function(v) _G.IngredientsToBuy = type(v) == "table" and v or {} end,
})

local SupermarketSec = FarmTab:CreateSection({ Name = "Supermarket" })
SupermarketSec:CreateToggle({
	Name = "Auto Buy Supermarket Items",
	Default = false,
	Flag = "AutoBuySupermarket",
	Callback = function(v) _G.AutoBuySupermarket = v end,
})
SupermarketSec:CreateDropdown({
	Name = "Supermarket Ingredients",
	Options = { "Pasta", "Ice", "Egg", "Bread", "Cheese", "Milk", "Chocolate" },
	Default = {},
	Multi = true,
	Flag = "SupermarketIngredients",
	Callback = function(v) _G.SupermarketIngredients = type(v) == "table" and v or {} end,
})
SupermarketSec:CreateButton({
	Name = "Teleport to Supermarket",
	Callback = function() tp(Vector3.new(1332.6, -30.1, 1675.1)) end,
})

local ButcherSec = FarmTab:CreateSection({ Name = "Butcher Shop" })
ButcherSec:CreateToggle({
	Name = "Auto Buy Butcher Meat",
	Default = false,
	Flag = "AutoBuyButcher",
	Callback = function(v) _G.AutoBuyButcher = v end,
})
ButcherSec:CreateDropdown({
	Name = "Meat Selection",
	Options = { "Beef", "Chicken", "Pork", "Lamb" },
	Default = {},
	Multi = true,
	Flag = "ButcherIngredients",
	Callback = function(v) _G.ButcherIngredients = type(v) == "table" and v or {} end,
})
ButcherSec:CreateButton({
	Name = "Teleport to Butcher Shop",
	Callback = function() tp(Vector3.new(1160.2, -30.1, 1652.7)) end,
})

local FishSec = FarmTab:CreateSection({ Name = "Fishmonger & Bakery" })
FishSec:CreateToggle({
	Name = "Auto Buy Fish",
	Default = false,
	Flag = "AutoBuyFishmonger",
	Callback = function(v) _G.AutoBuyFishmonger = v end,
})
FishSec:CreateButton({
	Name = "Teleport to Fishmonger",
	Callback = function() tp(Vector3.new(1179.6, -46.8, -1433.3)) end,
})
FishSec:CreateToggle({
	Name = "Auto Buy Bakery Goods",
	Default = false,
	Flag = "AutoBuyBakery",
	Callback = function(v) _G.AutoBuyBakery = v end,
})
FishSec:CreateDropdown({
	Name = "Bakery Ingredients",
	Options = { "Flour", "Egg", "Sugar", "Bread" },
	Default = {},
	Multi = true,
	Flag = "BakeryIngredients",
	Callback = function(v) _G.BakeryIngredients = type(v) == "table" and v or {} end,
})
FishSec:CreateButton({
	Name = "Teleport to Bakery",
	Callback = function() tp(Vector3.new(1128.3, -28.7, 1526.6)) end,
})

-- ===================== TAB 4: VISUALS & EVENTS =====================
local VisTab = Window:CreateTab({ Name = "Visuals & Events", Icon = "lucide:eye" })

local EventSec = VisTab:CreateSection({ Name = "Events" })
EventSec:CreateButton({
	Name = "Find All Hidden Ghosts (Scavenger Hunt)",
	Callback = function()
		local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		local hunt = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("ScavengerHunt")
		if hrp and hunt then
			local oldCF = hrp.CFrame
			for _, part in ipairs(hunt:GetDescendants()) do
				if part:IsA("Model") and part.PrimaryPart then
					hrp.CFrame = part.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
					task.wait(1)
				end
			end
			hrp.CFrame = oldCF
			Window:Toast("Scavenger hunt scan completed!", "Success")
		end
	end,
})

local ChamsSec = VisTab:CreateSection({ Name = "ESP & Lighting" })
local chamsActive = false
local chamConns = {}

ChamsSec:CreateToggle({
	Name = "Player Chams (ESP)",
	Default = false,
	Flag = "PlayersChams",
	Tooltip = "Highlights all players through walls",
	Callback = function(v)
		chamsActive = v
		for _, p in ipairs(players:GetPlayers()) do
			if p ~= localPlayer and p.Character then
				if v then
					for _, part in ipairs(p.Character:GetDescendants()) do
						if part:IsA("BasePart") and not part:FindFirstChild("SW_Cham") then
							local h = Instance.new("Highlight")
							h.Name = "SW_Cham"
							h.FillColor = Color3.fromRGB(56, 189, 248)
							h.OutlineColor = Color3.fromRGB(255, 255, 255)
							h.FillTransparency = 0.4
							h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							h.Parent = part
						end
					end
				else
					for _, h in ipairs(p.Character:GetDescendants()) do
						if h:IsA("Highlight") and h.Name == "SW_Cham" then h:Destroy() end
					end
				end
			end
		end
	end,
})

local defaultLighting = {
	Ambient = lighting.Ambient,
	OutdoorAmbient = lighting.OutdoorAmbient,
	Brightness = lighting.Brightness,
	ClockTime = lighting.ClockTime,
	FogEnd = lighting.FogEnd,
	GlobalShadows = lighting.GlobalShadows,
}

ChamsSec:CreateToggle({
	Name = "Fullbright",
	Default = false,
	Flag = "Fullbright",
	Callback = function(v)
		if v then
			lighting.Brightness = 3
			lighting.ClockTime = 14
			lighting.FogEnd = 1e6
			lighting.GlobalShadows = false
			lighting.Ambient = Color3.fromRGB(255, 255, 255)
			lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
		else
			lighting.Brightness = defaultLighting.Brightness
			lighting.ClockTime = defaultLighting.ClockTime
			lighting.FogEnd = defaultLighting.FogEnd
			lighting.GlobalShadows = defaultLighting.GlobalShadows
			lighting.Ambient = defaultLighting.Ambient
			lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
		end
	end,
})

ChamsSec:CreateToggle({
	Name = "No Shadows",
	Default = false,
	Flag = "NoShadows",
	Callback = function(v) lighting.GlobalShadows = not v end,
})

ChamsSec:CreateButton({
	Name = "Set Day (14:00)",
	Callback = function() lighting.ClockTime = 14 end,
})
ChamsSec:CreateButton({
	Name = "Set Night (00:00)",
	Callback = function() lighting.ClockTime = 0 end,
})

-- ===================== TAB 5: LOCAL PLAYER =====================
local PlayerTab = Window:CreateTab({ Name = "Local Player", Icon = "lucide:user" })

local MoveSec = PlayerTab:CreateSection({ Name = "Movement" })
local wsOn = false
local wsVal = 40
local wsMethod = "Normal"

MoveSec:CreateToggle({
	Name = "Enable WalkSpeed",
	Default = false,
	Flag = "WalkSpeedEnabled",
	Callback = function(v)
		wsOn = v
		if not v and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
			localPlayer.Character.Humanoid.WalkSpeed = 24
		end
	end,
})
MoveSec:CreateDropdown({
	Name = "WalkSpeed Method",
	Options = { "Normal", "CFrame" },
	Default = "Normal",
	Flag = "WalkSpeedMethod",
	Callback = function(v) wsMethod = v end,
})
MoveSec:CreateSlider({
	Name = "WalkSpeed Value",
	Min = 24,
	Max = 350,
	Increment = 1,
	Default = 40,
	Flag = "WalkSpeedValue",
	Callback = function(v) wsVal = v end,
})

task.spawn(function()
	while isCurrentGen() do
		task.wait(0.02)
		if wsOn and localPlayer.Character then
			local hum = localPlayer.Character:FindFirstChild("Humanoid")
			if hum then
				if wsMethod == "CFrame" then
					if hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
					if hum.MoveDirection.Magnitude > 0 then
						localPlayer.Character:TranslateBy(hum.MoveDirection.Unit * (wsVal / 100))
					end
				else
					if hum.WalkSpeed ~= wsVal then hum.WalkSpeed = wsVal end
				end
			end
		end
	end
end)

MoveSec:CreateSlider({
	Name = "JumpPower",
	Min = 50,
	Max = 500,
	Increment = 5,
	Default = 50,
	Flag = "JumpPower",
	Callback = function(v)
		if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
			localPlayer.Character.Humanoid.JumpPower = v
			localPlayer.Character.Humanoid.UseJumpPower = true
		end
	end,
})

local infJump = false
MoveSec:CreateToggle({
	Name = "Infinite Jump",
	Default = false,
	Flag = "InfiniteJump",
	Callback = function(v) infJump = v end,
})
userInputService.JumpRequest:Connect(function()
	if infJump and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
		localPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

local FlySec = PlayerTab:CreateSection({ Name = "Flight & Noclip" })
local flyOn = false
local flySpeed = 100
local flyBG, flyBV, flyConn

local function stopFly()
	flyOn = false
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end
	if flyBV then flyBV:Destroy() flyBV = nil end
	if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
		localPlayer.Character.Humanoid.PlatformStand = false
	end
end

local function startFly()
	local char = localPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")
	if not hrp or not hum then return end

	stopFly()
	flyOn = true
	hum.PlatformStand = true

	flyBG = Instance.new("BodyGyro")
	flyBG.P = 9e4
	flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	flyBG.CFrame = hrp.CFrame
	flyBG.Parent = hrp

	flyBV = Instance.new("BodyVelocity")
	flyBV.Velocity = Vector3.zero
	flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	flyBV.Parent = hrp

	flyConn = runService.RenderStepped:Connect(function()
		if not flyOn or not hrp or not flyBV or not flyBG then stopFly() return end
		local cam = workspace.CurrentCamera
		if not cam then return end
		local dir = hum.MoveDirection
		if dir.Magnitude > 0 then
			flyBV.Velocity = dir.Unit * flySpeed
		else
			flyBV.Velocity = Vector3.zero
		end
		flyBG.CFrame = cam.CFrame
	end)
end

FlySec:CreateToggle({
	Name = "Fly",
	Default = false,
	Flag = "Fly",
	Callback = function(v)
		if v then startFly() else stopFly() end
	end,
})
FlySec:CreateSlider({
	Name = "Fly Speed",
	Min = 20,
	Max = 400,
	Increment = 5,
	Default = 100,
	Flag = "FlySpeedRT3",
	Callback = function(v) flySpeed = v end,
})

local noclipActive = false
local noclipConn
FlySec:CreateToggle({
	Name = "Noclip",
	Default = false,
	Flag = "Noclip",
	Callback = function(v)
		noclipActive = v
		if noclipConn then noclipConn:Disconnect() noclipConn = nil end
		if v then
			noclipConn = runService.Stepped:Connect(function()
				if localPlayer.Character then
					for _, p in ipairs(localPlayer.Character:GetDescendants()) do
						if p:IsA("BasePart") then p.CanCollide = false end
					end
				end
			end)
		end
	end,
})

local UtilSec = PlayerTab:CreateSection({ Name = "Utilities" })
local afkConn
UtilSec:CreateToggle({
	Name = "Anti-AFK",
	Default = true,
	Flag = "AntiAFK",
	Tooltip = "Prevents idle disconnection",
	Callback = function(v)
		if afkConn then afkConn:Disconnect() afkConn = nil end
		if v then
			afkConn = localPlayer.Idled:Connect(function()
				virtualUser:CaptureController()
				virtualUser:ClickButton2(Vector2.new())
			end)
		end
	end,
})

UtilSec:CreateSlider({
	Name = "Field of View",
	Min = 50,
	Max = 120,
	Increment = 1,
	Default = 70,
	Flag = "FOVValue",
	Callback = function(v)
		if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = v end
	end,
})

-- ===================== DEFAULT TABS (THEME & SETTINGS) =====================
Window:CreateDefaultTabs()

-- Autoload configuration when UI finishes loading
Window:OnLoaded(function()
	pcall(function() Library:AutoloadConfig("auto", true) end)
end)

Window:Notify({
	Title = BRAND.Name,
	Content = "Restaurant Tycoon 3 script loaded! Press RightShift to toggle.",
	Duration = 5,
	Kind = "Success",
})

print(string.format("[SpectreWare] Restaurant Tycoon 3 script initialized (Gen: %d)", MY_GEN))
