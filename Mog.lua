--[[
	SpectreWare | Mog Evolution
	UI: SpectreUI v3.17 (dark/cyan-navy Roblox UI library by SpectreWare)
	Theme: Spectre (Dark Graphite / Deep Navy Slate / Electric Cyan)
	Brand: SpectreWare
	Discord: https://discord.gg/GdKxvcHzjS
	Game: Mog Evolution

	Features:
	  • Built with SpectreUI v3.17 (Keyless official build)
	  • Overview: Live Session statistics (Uptime, Wins, Appeal, Ping, World, Rebirths)
	  • Progression: Auto Ascend, Auto World Unlock, Auto Treadmill (with Belt picker), Auto Buy Hammers
	  • Automation: Auto Click, Auto Rebirth, Auto Win (with Pad selection & adaptive discovery), Mog Stage Bosses (with Mog Budget slider)
	  • Rewards: Auto Claim Daily, Auto Claim Play Time (all 8 tiers)
	  • Misc: Hide Name (instant + late billboard watcher), Noclip, WalkSpeed, Jump Height, Fly (BodyGyro/BodyVelocity), Anti-AFK
	  • Full Theme & Config persistence support
]]

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

-- ===================== SERVICES =====================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")

-- Auto-exec wait guard
pcall(function()
	if not game:IsLoaded() then game.Loaded:Wait() end
end)
pcall(function()
	local t0 = os.clock()
	while not Players.LocalPlayer and os.clock() - t0 < 30 do
		task.wait(0.1)
	end
end)
local LocalPlayer = Players.LocalPlayer

-- ===================== BRANDING =====================
local BRAND = {
	Name    = "SpectreWare",
	Version = "1.0.0",
	Discord = "https://discord.gg/GdKxvcHzjS",
	Invite  = "discord.gg/GdKxvcHzjS",
	Logo    = 84699118856259,
}

-- ===================== GENERATION GUARD =====================
local LOAD_GEN = math.floor(os.clock() * 100000) % 1000000 + math.random(1, 999) * 1000000
pcall(function()
	RS:SetAttribute("SW_LoadGen", LOAD_GEN)
	RS:SetAttribute("LH_LoadGen", LOAD_GEN)
end)

local function isCurrentGen()
	local swGen = RS:GetAttribute("SW_LoadGen")
	local lhGen = RS:GetAttribute("LH_LoadGen")
	return swGen == LOAD_GEN or lhGen == LOAD_GEN
end

-- ===================== ATTRIBUTE FLAGS HELPER =====================
local function getFlag(n)
	local v = RS:GetAttribute("SW_" .. n)
	if v ~= nil then return v end
	return RS:GetAttribute("LH_" .. n)
end

local function setFlag(n, v)
	pcall(function() RS:SetAttribute("SW_" .. n, v) end)
	pcall(function() RS:SetAttribute("LH_" .. n, v) end)
end

local function flagOn(name)
	local v = getFlag(name)
	if v == nil then return false end
	if type(v) == "string" then
		local s = v:lower()
		return s ~= "false" and s ~= "" and s ~= "0"
	end
	return v == true
end

-- Initialize default flags if missing
local defaultFlags = {
	AutoAscendOn = false,
	AutoWorldOn = false,
	AutoTreadmillOn = false,
	AutoHammerOn = false,
	AutoClickOn = false,
	AutoRebirthOn = false,
	AutoWinOn = false,
	WinPad = "Best",
	WinPadCeiling = 0,
	MogBlocked = "",
	AutoMogOn = true,
	MogBudget = 30,
	AntiAfkOn = false,
	AutoDailyOn = false,
	AutoPlayTimeOn = false,
	NoclipOn = false,
	WalkOn = false,
	JumpOn = false,
	HideNameOn = false,
	TreadmillBelt = "Best",
	FlyOn = false,
	FlySpeed = 60,
}

for k, def in pairs(defaultFlags) do
	if getFlag(k) == nil then
		setFlag(k, def)
	end
end

-- ===================== LEFTOVER UI CLEANUP =====================
pcall(function()
	local function cleanGui(parent)
		if not parent then return end
		for _, child in ipairs(parent:GetChildren()) do
			if child:IsA("ScreenGui") then
				local name = child.Name
				if name == "AutoUpgradeUI" or name == "LiquidSplash" or name == "LiquidHub_Gate" or name == "Obsidian" or name == "KeySystem" then
					pcall(function() child:Destroy() end)
				end
			end
		end
	end

	local roots = { game:GetService("CoreGui") }
	if gethui then pcall(function() table.insert(roots, gethui()) end) end
	pcall(function()
		local pg = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
		if pg then table.insert(roots, pg) end
	end)

	for _, r in ipairs(roots) do cleanGui(r) end
end)

-- ===================== SPECTRE THEME DEFINITION =====================
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

-- ===================== GAME HELPERS =====================
local function getCharacter() return LocalPlayer.Character end
local function getRoot()
	local char = getCharacter()
	return char and char:FindFirstChild("HumanoidRootPart")
end
local function getHumanoid()
	local char = getCharacter()
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function inBag(bag, name)
	local b = RS:FindFirstChild(bag)
	return b and b:FindFirstChild(name)
end

local function attr(n) return LocalPlayer:GetAttribute(n) end
local function num(n, d)
	local v = tonumber(attr(n))
	return v or d
end

local function reincarnate() return inBag("WorldRemotes", "Reincarnate") end
local function doRebirth() return inBag("RebirthRemotes", "DoRebirth") end
local function clickPower() return inBag("PowerRemotes", "ClickPower") end
local function claimDaily() return inBag("RewardRemotes", "ClaimDaily") end
local function claimPlay() return inBag("RewardRemotes", "ClaimPlayTime") end

local function appeal() return num("AppealTotal", 0) end
local function wins() return num("Wins", 0) end
local function power() return num("Power", 0) end
local function curWorld() return num("World", 1) end
local function rebirths() return num("Rebirths", 0) end

local function abbrev(n)
	n = tonumber(n) or 0
	if n >= 1e9 then return string.format("%.0fB", n / 1e9) end
	if n >= 1e6 then return string.format("%.0fM", n / 1e6) end
	if n >= 1e3 then return string.format("%.0fK", n / 1e3) end
	return tostring(math.floor(n))
end

local function formatClock(seconds)
	local s = math.max(0, math.floor(tonumber(seconds) or 0))
	return string.format("%02d:%02d:%02d", math.floor(s / 3600), math.floor(s % 3600 / 60), s % 60)
end

-- ── Play Time Rewards ──
local PLAYTIME_FALLBACK = {
	{ Index = 1, Seconds = 180 },  { Index = 2, Seconds = 300 },
	{ Index = 3, Seconds = 600 },  { Index = 4, Seconds = 900 },
	{ Index = 5, Seconds = 1200 }, { Index = 6, Seconds = 1800 },
	{ Index = 7, Seconds = 2400 }, { Index = 8, Seconds = 3000 },
}

local function playTimeTiers()
	local mods = RS:FindFirstChild("Modules")
	local mod = mods and mods:FindFirstChild("PlayTimeRewards")
	if not mod then return PLAYTIME_FALLBACK end
	local ok, P = pcall(require, mod)
	if ok and type(P) == "table" and type(P.Tiers) == "table" and #P.Tiers > 0 then
		local out = {}
		for _, t in ipairs(P.Tiers) do
			if type(t) == "table" and tonumber(t.Index) and tonumber(t.Seconds) then
				out[#out + 1] = { Index = tonumber(t.Index), Seconds = tonumber(t.Seconds) }
			end
		end
		if #out > 0 then return out end
	end
	return PLAYTIME_FALLBACK
end

local function playTimeClaimed(index)
	local mask = num("PlayTimeClaimed", 0) or 0
	return bit32.band(mask, bit32.lshift(1, index - 1)) ~= 0
end

-- ── Ascend Ladder ──
local function mogLadder()
	local mog = RS:FindFirstChild("Mog")
	local mod = mog and mog:FindFirstChild("MogLadder")
	if not mod then return nil end
	local ok, L = pcall(require, mod)
	if ok and type(L) == "table" and type(L.ByTier) == "function" then return L end
	return nil
end

local ASCEND_TIERS = {}
do
	local L = mogLadder()
	local tiers = (type(L) == "table") and L.Tiers or nil
	if type(tiers) == "table" then
		for _, e in ipairs(tiers) do
			if type(e) == "table" and e.Tier and e.Cost then
				ASCEND_TIERS[#ASCEND_TIERS + 1] = { Tier = e.Tier, Name = e.Name or ("Tier " .. tostring(e.Tier)), Cost = e.Cost }
			end
		end
		table.sort(ASCEND_TIERS, function(a, b) return a.Tier < b.Tier end)
	end
	if #ASCEND_TIERS == 0 then
		ASCEND_TIERS = {
			{ Tier = 1, Name = "Subhuman", Cost = 0 },
			{ Tier = 2, Name = "Sub 3", Cost = 5 },
			{ Tier = 3, Name = "Sub 5", Cost = 25 },
			{ Tier = 4, Name = "LTN", Cost = 100 },
			{ Tier = 5, Name = "MTN", Cost = 500 },
			{ Tier = 6, Name = "HTN", Cost = 2500 },
			{ Tier = 7, Name = "Chadlite", Cost = 10000 },
			{ Tier = 8, Name = "Chad", Cost = 40000 },
			{ Tier = 9, Name = "Adamlite", Cost = 150000 },
			{ Tier = 10, Name = "True Adam", Cost = 600000 },
		}
	end
end

local function ascendPackets()
	local mog = RS:FindFirstChild("Mog")
	local mod = mog and mog:FindFirstChild("MogPackets")
	if not mod then return nil end
	local ok, P = pcall(require, mod)
	if ok and type(P) == "table" then return P end
	return nil
end

local function nextAscend()
	local cur = num("BodyTier", 1)
	local L = mogLadder()
	local tiers = (type(L) == "table") and L.Tiers or nil
	if type(tiers) == "table" and tiers[cur + 1] then
		local e = tiers[cur + 1]
		if type(e) == "table" and e.Cost then
			return { Tier = cur + 1, Name = e.Name or ("Tier " .. (cur + 1)), Cost = e.Cost }
		end
	end
	for _, t in ipairs(ASCEND_TIERS) do
		if t.Tier == cur + 1 then return t end
	end
	return nil
end

-- ── Worlds ──
local WORLDS = {
	{ Id = 1, Name = "World 1", Folder = "World1", Cost = 0 },
	{ Id = 2, Name = "Primal", Folder = "World2", Cost = 2500000000 },
	{ Id = 3, Name = "Tropical", Folder = "World3", Cost = 1.5e15 },
}

-- ── Treadmills ──
local BELTS = {
	{ Name = "Deafult", Label = "Default", Mult = 1,   Rebirths = 0,  Owned = nil, Robux = false },
	{ Name = "x2",      Label = "x2",      Mult = 2,   Rebirths = 1,  Owned = "Beltx2BuyOwned", Robux = false },
	{ Name = "x3",      Label = "x3",      Mult = 3,   Rebirths = 3,  Owned = "Beltx3BuyOwned", Robux = false },
	{ Name = "x5",      Label = "x5",      Mult = 5,   Rebirths = 6,  Owned = "Beltx5BuyOwned", Robux = false },
	{ Name = "x8",      Label = "x8",      Mult = 8,   Rebirths = 9,  Owned = "Beltx8BuyOwned", Robux = false },
	{ Name = "x12",     Label = "x12",     Mult = 12,  Rebirths = 12, Owned = "Beltx12BuyOwned", Robux = false },
	{ Name = "x18",     Label = "x18",     Mult = 18,  Rebirths = 15, Owned = "Beltx18BuyOwned", Robux = false },
	{ Name = "x9",      Label = "x9",      Mult = 9,   Rebirths = 0,  Owned = "Beltx9Owned", Robux = true },
	{ Name = "x99",     Label = "x99",     Mult = 99,  Rebirths = 0,  Owned = "Beltx99Owned", Robux = true },
	{ Name = "x999",    Label = "x999",    Mult = 999, Rebirths = 0,  Owned = "Beltx999Owned", Robux = true },
	{ Name = "VIPx10",  Label = "VIP x10", Mult = 10,  Rebirths = 0,  Owned = "VIPOwned", Robux = true },
}

local function beltLabel(b) return b.Label or b.Name end

local function beltUnlocked(b)
	if b.Robux then return attr(b.Owned) == true end
	if b.Owned and attr(b.Owned) == true then return true end
	return rebirths() >= b.Rebirths
end

local function bestBelt()
	local top
	for _, b in ipairs(BELTS) do
		if beltUnlocked(b) and (not top or b.Mult > top.Mult) then top = b end
	end
	return top
end

local function beltByLabel(label)
	for _, b in ipairs(BELTS) do
		if beltLabel(b) == label and beltUnlocked(b) then return b end
	end
	return nil
end

local function beltPart(model)
	local best, area = nil, 0
	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("BasePart") and d.CanCollide and d.Size.Y <= 2 then
			local a = d.Size.X * d.Size.Z
			if area < a then area = a; best = d end
		end
	end
	return best
end

local function treadmillModel(beltName)
	local w = workspace:FindFirstChild("World" .. tostring(curWorld()))
	local bag = w and w:FindFirstChild("TreadmillFolder")
	local tms = bag and bag:FindFirstChild("Treadmills")
	if not tms then return nil end
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local best, bestDist
	for _, c in tms:GetChildren() do
		if c.Name == beltName then
			local part = beltPart(c)
			if part then
				if not root then return c end
				local d = (part.Position - root.Position).Magnitude
				if not bestDist or d < bestDist then best, bestDist = c, d end
			end
		end
	end
	return best
end

local function beltSpot(model)
	local p = beltPart(model)
	if not p then return nil end
	return (p.CFrame * CFrame.new(0, p.Size.Y / 2 + 3, 0)).Position
end

-- ── Hammers ──
local function parseAmount(txt)
	local s = txt:gsub("%s+", "")
	local mult = 1
	local last = s:sub(-1):upper()
	if last == "K" then
		mult = 1e3
		s = s:sub(1, -2)
	elseif last == "M" then
		mult = 1e6
		s = s:sub(1, -2)
	elseif last == "B" then
		mult = 1e9
		s = s:sub(1, -2)
	end
	local n = tonumber(s)
	return n and n * mult or nil
end

local function hammerStandCost(stand)
	local bb = stand:FindFirstChild("StatsBilboard")
	local main = bb and bb:FindFirstChild("Main")
	local wc = main and main:FindFirstChild("WinCost")
	local lbl = wc and wc:FindFirstChild("Cost")
	if not (lbl and lbl:IsA("TextLabel")) then return nil end
	local txt = lbl.Text
	if txt == "OWNED" or txt == "EQUIPPED" then return 0 end
	return parseAmount(txt)
end

local function hammerPodium(stand)
	for _, n in ipairs({ "Detail", "Frame" }) do
		local p = stand:FindFirstChild(n)
		if p and p:IsA("BasePart") then return p end
	end
	return stand:FindFirstChildWhichIsA("BasePart")
end

local HAMMER_FALLBACK = {
	{ Index = 1, Title = "Wooden Hammer", Multi = 1, Cost = 1 },
	{ Index = 2, Title = "Stone Hammer", Multi = 2, Cost = 10 },
	{ Index = 3, Title = "Iron Hammer", Multi = 4, Cost = 50 },
	{ Index = 4, Title = "Golden Hammer", Multi = 8, Cost = 200 },
	{ Index = 5, Title = "Diamond Hammer", Multi = 16, Cost = 1000 },
	{ Index = 6, Title = "Flaming Hammer", Multi = 32, Cost = 5000 },
	{ Index = 7, Title = "Darkness Hammer", Multi = 64, Cost = 20000 },
	{ Index = 8, Title = "Void Hammer", Multi = 128, Cost = 80000 },
	{ Index = 9, Title = "Galaxy Hammer", Multi = 256, Cost = 350000 },
	{ Index = 10, Title = "Rainbow Hammer", Multi = 512, Cost = 1500000 },
	{ Index = 11, Title = "Godly Hammer", Multi = 1024, Cost = 7500000 },
}

local function hammerTiers()
	local mog = RS:FindFirstChild("Mog")
	local mod = mog and mog:FindFirstChild("HammerConfig")
	if not mod then return HAMMER_FALLBACK end
	local ok, P = pcall(require, mod)
	if ok and type(P) == "table" and type(P.Tiers) == "table" and #P.Tiers > 0 then
		local out = {}
		for _, t in ipairs(P.Tiers) do
			if type(t) == "table" and tonumber(t.Index) and tonumber(t.Multi) and not t.Stand then
				out[#out + 1] = {
					Index = tonumber(t.Index),
					Title = tostring(t.Title or ("Hammer " .. tostring(t.Index))),
					Multi = tonumber(t.Multi),
					Cost = tonumber(t.Cost) or 0,
				}
			end
		end
		if #out > 0 then return out end
	end
	return HAMMER_FALLBACK
end

local HAMMER_TIERS = hammerTiers()

local function hammerInfo(tier)
	for _, t in ipairs(HAMMER_TIERS) do
		if t.Index == tier then return t end
	end
	return nil
end

local function hammerMulti(tier)
	local t = hammerInfo(tier)
	return t and t.Multi or nil
end

local function hammerOwned(ownedMask, tier)
	local bit = 2 ^ (tier - 1)
	return (math.floor(ownedMask / bit) % 2) == 1
end

local function hammerFloor()
	local owned = num("HammerOwned", 0) or 0
	local best = hammerMulti(num("HammerTier", 0) or 0) or 0
	for _, t in ipairs(HAMMER_TIERS) do
		if hammerOwned(owned, t.Index) then
			local m = t.Multi
			if m > best then best = m end
		end
	end
	return best
end

local function hammerTarget()
	local floorMulti = hammerFloor()
	local w = workspace:FindFirstChild("World" .. tostring(curWorld()))
	local bag = w and w:FindFirstChild("HammerStand")
	if not bag then return nil end
	local owned = num("HammerOwned", 0) or 0
	local cash = wins()
	local best
	for _, stand in ipairs(bag:GetChildren()) do
		local tier = tonumber(stand.Name)
		if tier and tier >= 1 and tier < 32 and stand:FindFirstChild("HammerDisplay") then
			local info = hammerInfo(tier)
			if info and info.Multi > floorMulti and not hammerOwned(owned, tier) then
				local cost = hammerStandCost(stand)
				local podium = hammerPodium(stand)
				if cost and podium and cash >= cost then
					if not best or tier > best.tier then
						best = {
							tier = tier,
							cost = cost,
							podium = podium,
							title = info.Title,
							multi = info.Multi,
						}
					end
				end
			end
		end
	end
	return best
end

-- ── Mog Bosses ──
local function mogPackets()
	local mog = RS:FindFirstChild("Mog")
	local mod = mog and mog:FindFirstChild("MogPackets")
	if not mod then return nil end
	local ok, P = pcall(require, mod)
	if ok and type(P) == "table" then return P end
	return nil
end

local function beatFlag(zoneIdx)
	return "Beat_Zone" .. tostring(zoneIdx)
end

local MogClickLimit, MogClickWindow = 3, 1
do
	local mog = RS:FindFirstChild("Mog")
	local mod = mog and mog:FindFirstChild("MogConfig")
	if mod then
		local ok, C = pcall(require, mod)
		if ok and type(C) == "table" then
			MogClickLimit = tonumber(C.ClickLimit) or MogClickLimit
			MogClickWindow = tonumber(C.ClickWindow) or MogClickWindow
		end
	end
end

local function moggerRoot(zoneIdx)
	local w = workspace:FindFirstChild("World" .. tostring(curWorld()))
	local bag = w and w:FindFirstChild("Moggers")
	local entry = bag and bag:FindFirstChild("Zone" .. tostring(zoneIdx))
	local m = entry and entry:FindFirstChild("Mogger")
	return m and m:FindFirstChild("HumanoidRootPart")
end

local function mogZone(zoneIdx, budget)
	local P = mogPackets()
	local mhrp = moggerRoot(zoneIdx)
	if not P or not P.Challenge or not P.Click then return false end
	if attr(beatFlag(zoneIdx)) == true then return true end
	if attr("InMogBattle") == true then return false end

	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root or not mhrp or not mhrp.Parent then return false end

	local near = mhrp.CFrame * CFrame.new(3.5, 0, 0)
	if LocalPlayer.Character ~= char or not root.Parent then return false end
	pcall(function()
		root.CFrame = near
		root.AssemblyLinearVelocity = Vector3.zero
	end)

	local dwell = os.clock() + 1.0
	while os.clock() < dwell do
		if LocalPlayer.Character ~= char or not root.Parent then return false end
		pcall(function()
			root.CFrame = near
			root.AssemblyLinearVelocity = Vector3.zero
		end)
		task.wait(0.05)
	end

	if not pcall(function() P.Challenge:Fire("Zone" .. tostring(zoneIdx)) end) then
		return false
	end

	local t0 = os.clock()
	local started = false
	while os.clock() - t0 < 5 do
		if attr(beatFlag(zoneIdx)) == true then return true end
		if attr("InMogBattle") == true then
			started = true
			break
		end
		task.wait(0.1)
	end

	if not started then return false end

	local CLICK_SPACING = (MogClickWindow / (MogClickLimit or 3)) * 1.02
	while os.clock() - t0 < budget do
		if attr(beatFlag(zoneIdx)) == true then return true end
		if LocalPlayer.Character ~= char or not root.Parent then return false end
		if attr("InMogBattle") == true then
			pcall(function() P.Click:Fire() end)
		end
		task.wait(CLICK_SPACING)
	end
	return attr(beatFlag(zoneIdx)) == true
end

-- ── Win Pads ──
local WIN_REWARDS = {
	1, 5, 20, 100, 500, 2000, 8000, 30000, 120000, 500000,
	2000000, 8000000, 30000000, 120000000, 500000000,
}

local WIN_LANE = "Normal"

local function worldList()
	local list = {}
	for _, c in ipairs(workspace:GetChildren()) do
		local n = string.match(c.Name, "^World(%d+)$")
		if n then list[#list + 1] = { name = c.Name, n = tonumber(n) } end
	end
	table.sort(list, function(a, b) return a.n < b.n end)
	return list
end

local function padHitbox(pad)
	local cur = "World" .. tostring(curWorld())
	local function hitboxIn(worldName)
		local world = workspace:FindFirstChild(worldName)
		local bags = world and world:FindFirstChild("WinPads")
		local lane = bags and bags:FindFirstChild(WIN_LANE)
		local zone = lane and lane:FindFirstChild(tostring(pad))
		local hb = zone and zone:FindFirstChild("Hitbox")
		if hb and hb:IsA("BasePart") then return hb end
		return nil
	end

	local hb = hitboxIn(cur)
	if hb then return hb end

	for _, w in ipairs(worldList()) do
		if w.name ~= cur then
			local alt = hitboxIn(w.name)
			if alt then return alt end
		end
	end
	return nil
end

local function padReward(pad) return WIN_REWARDS[pad] or 0 end

local function beatenFrontier()
	local n = 0
	for i = 0, #WIN_REWARDS - 1 do
		if attr(beatFlag(i)) == true then n = i + 1 else break end
	end
	return n - 1
end

local PROBE_EVERY = 8
local padCeiling = tonumber(getFlag("WinPadCeiling")) or 0
local probeCount = 0
local probeUp = false
local strandedRefusals = 0

local function savePadCeiling() setFlag("WinPadCeiling", padCeiling) end

local MOG_RETRY_AFTER = 600
local mogBlockAt = {}
do
	local raw = getFlag("MogBlocked")
	if type(raw) == "string" and raw ~= "" then
		for chunk in string.gmatch(raw, "[^,]+") do
			local z, n = string.match(chunk, "^(%d+)=(%d+)$")
			if z then mogBlockAt[tonumber(z)] = tonumber(n) or 0 end
		end
	end
end

local function saveMogBlocked()
	local parts = {}
	local now = os.time()
	for z, t in pairs(mogBlockAt) do
		if t > now then parts[#parts + 1] = string.format("%d=%d", z, t) end
	end
	setFlag("MogBlocked", table.concat(parts, ","))
end

local function zoneAppealReq(zoneIdx)
	local mog = RS:FindFirstChild("Mog")
	local mod = mog and mog:FindFirstChild("MogConfig")
	if not mod then return nil end
	local ok, C = pcall(require, mod)
	if ok and type(C) == "table" and type(C.Zones) == "table" then
		local z = C.Zones[zoneIdx + 1]
		if type(z) == "table" then return tonumber(z.AppealReq) end
	end
	return nil
end

local function mogBlocked(zone)
	local t = mogBlockAt[zone]
	if not t then return false end
	if os.time() < t then return true end
	mogBlockAt[zone] = nil
	saveMogBlocked()
	return false
end

local mogAppealShort = {}

local function recordMogResult(zone, won)
	if won then
		mogBlockAt[zone] = nil
		mogAppealShort[zone] = nil
	else
		mogBlockAt[zone] = os.time() + MOG_RETRY_AFTER
	end
	saveMogBlocked()
end

local function frontierAppealGap(zone)
	local req = zoneAppealReq(zone)
	if req == nil then return nil end
	local have = appeal()
	if have >= req then return nil end
	return req - have, req
end

local function floorPad()
	return math.clamp(beatenFrontier() + 2, 1, #WIN_REWARDS)
end

local function invalidateStaleCeiling()
	local lo = floorPad()
	if padCeiling > 0 and padCeiling < lo - 1 then
		padCeiling = 0
		probeCount = 0
		probeUp = false
		strandedRefusals = 0
		savePadCeiling()
		return true
	end
	return false
end

local function bestPad()
	invalidateStaleCeiling()
	local lo = floorPad()
	if padCeiling > 0 then return math.clamp(padCeiling, 1, #WIN_REWARDS) end
	return lo
end

local function padIndexFromLabel(v)
	if type(v) == "number" then return math.floor(v) end
	if type(v) ~= "string" then return nil end
	local n = tonumber(string.match(v, "^Pad%s+(%d+)"))
	if n then return math.floor(n) end
	return tonumber(v)
end

local function wantedPad()
	local v = getFlag("WinPad")
	local cap = bestPad()
	if v == nil or v == "Best" then
		if probeUp and padCeiling > 0 and padCeiling < #WIN_REWARDS then
			return padCeiling + 1
		end
		return cap
	end
	local n = padIndexFromLabel(v)
	if not n then return cap end
	return math.clamp(math.floor(n), 1, #WIN_REWARDS)
end

local function noteStrandedRefusal()
	strandedRefusals = strandedRefusals + 1
	if strandedRefusals >= 6 and padCeiling > 0 and padCeiling < floorPad() then
		padCeiling = 0
		probeCount = 0
		probeUp = false
		strandedRefusals = 0
		savePadCeiling()
		return true
	end
	return false
end

local function reportClaim(pad, paid)
	if paid then
		strandedRefusals = 0
		if pad > padCeiling then
			padCeiling = pad
			savePadCeiling()
		end
		probeCount = probeCount + 1
		if probeCount >= PROBE_EVERY then
			probeCount = 0
			if pad < #WIN_REWARDS then
				probeUp = true
			end
		end
	else
		probeCount = 0
		probeUp = false
		if noteStrandedRefusal() then return end
		local stepped = math.max(pad - 1, 1)
		if padCeiling == 0 or pad <= padCeiling then
			if stepped ~= padCeiling then
				padCeiling = stepped
				savePadCeiling()
			end
		end
	end
end

local function winStages(limit)
	local out = {}
	local hitbox = padHitbox(limit)
	if not hitbox then return out end
	for i = 0, limit - 2 do
		out[#out + 1] = { Zone = i, Mogger = moggerRoot(i) }
	end
	out[#out + 1] = { Zone = limit, Mogger = nil, Hitbox = hitbox, IsPad = true }
	return out
end

-- ===================== MOVEMENT & UTILITIES =====================
local defaultWalkSpeed = 16
local defaultJumpPower = 50
local defaultJumpHeight = 7.2
pcall(function()
	local h = getHumanoid()
	if h then
		defaultWalkSpeed = h.WalkSpeed
		defaultJumpPower = h.JumpPower
		defaultJumpHeight = h.JumpHeight
	end
end)

local currentWalkSpeed = tonumber(getFlag("WalkSpeed")) or defaultWalkSpeed
local currentJump = tonumber(getFlag("JumpHeight")) or defaultJumpHeight
local walkOn = flagOn("WalkOn")
local jumpOn = flagOn("JumpOn")
local hideNameOn = flagOn("HideNameOn")
local noclipOn = flagOn("NoclipOn")
local noclipRunning = false

local function setNoclip(on)
	pcall(function()
		local char = LocalPlayer.Character
		if not char then return end
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = not on
			end
		end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.CanCollide = not on end
	end)
end

local function noclipLoop()
	noclipRunning = true
	while flagOn("NoclipOn") and isCurrentGen() do
		pcall(function() setNoclip(true) end)
		task.wait(0.2)
	end
	pcall(function() setNoclip(false) end)
	noclipRunning = false
end

local function applyHideName(on)
	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.NameDisplayDistance = on and 0 or 100
			if on then hum.DisplayName = "" else hum.DisplayName = LocalPlayer.DisplayName end
		end
		for _, gui in ipairs(char:GetDescendants()) do
			if gui:IsA("BillboardGui") then
				if on then
					if gui:GetAttribute("HideName_OrigEnabled") == nil then
						gui:SetAttribute("HideName_OrigEnabled", gui.Enabled)
					end
					gui.Enabled = false
				else
					local orig = gui:GetAttribute("HideName_OrigEnabled")
					gui.Enabled = (orig ~= nil and orig) or true
					pcall(function() gui:SetAttribute("HideName_OrigEnabled", nil) end)
				end
				for _, lbl in ipairs(gui:GetDescendants()) do
					if lbl:IsA("TextLabel") then
						if on then
							if lbl:GetAttribute("HideName_OrigVis") == nil then
								lbl:SetAttribute("HideName_OrigVis", lbl.Visible)
							end
							lbl.Visible = false
							lbl.TextTransparency = 1
						else
							local v = lbl:GetAttribute("HideName_OrigVis")
							lbl.Visible = (v ~= nil and v) or true
							lbl.TextTransparency = 0
							pcall(function() lbl:SetAttribute("HideName_OrigVis", nil) end)
						end
					end
				end
			end
		end
	end
	pcall(function()
		local p = LocalPlayer
		local pname, dname = p.Name, p.DisplayName
		local function hideInGui(gui)
			for _, d in ipairs(gui:GetDescendants()) do
				if d:IsA("TextLabel") or d:IsA("TextButton") then
					local txt = d.Text
					if txt == pname or txt == dname or txt == "@" .. pname or txt:find(pname, 1, true) then
						d.Visible = not on
					end
				end
			end
		end
		for _, gui in ipairs({ LocalPlayer:FindFirstChild("PlayerGui"), game:GetService("CoreGui") }) do
			if gui then hideInGui(gui) end
		end
	end)
end

local function applyWalkSpeed(v)
	currentWalkSpeed = math.clamp(tonumber(v) or defaultWalkSpeed, 8, 200)
	setFlag("WalkSpeed", currentWalkSpeed)
	if walkOn then
		local hum = getHumanoid()
		if hum then pcall(function() hum.WalkSpeed = currentWalkSpeed end) end
	end
end

local function applyJump(v)
	currentJump = math.clamp(tonumber(v) or defaultJumpHeight, 0, 200)
	setFlag("JumpHeight", currentJump)
	if jumpOn then
		local hum = getHumanoid()
		if hum then
			pcall(function()
				if hum.UseJumpPower then hum.JumpPower = currentJump else hum.JumpHeight = currentJump end
			end)
		end
	end
end

local function syncWalk()
	if not walkOn then return end
	local hum = getHumanoid()
	if hum then pcall(function() hum.WalkSpeed = currentWalkSpeed end) end
end

local function syncJump()
	if not jumpOn then return end
	local hum = getHumanoid()
	if hum then
		pcall(function()
			if hum.UseJumpPower then hum.JumpPower = currentJump else hum.JumpHeight = currentJump end
		end)
	end
end

-- Flight
local flyOn = flagOn("FlyOn")
local flySpeed = tonumber(getFlag("FlySpeed")) or 60
local flyBV, flyBG, flyConn
local flyKeys = { W = false, A = false, S = false, D = false, Space = false, Ctrl = false, Shift = false }

local function stopFly()
	flyOn = false
	setFlag("FlyOn", false)
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if flyBV then flyBV:Destroy() flyBV = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end
	local hum = getHumanoid()
	if hum then pcall(function() hum.PlatformStand = false end) end
	setNoclip(flagOn("NoclipOn"))
end

local function startFly()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = getHumanoid()
	if not hrp or not hum then return end

	flyOn = true
	setFlag("FlyOn", true)
	pcall(function() hum.PlatformStand = true end)

	flyBG = Instance.new("BodyGyro")
	flyBG.P = 9e4
	flyBG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	flyBG.cframe = hrp.CFrame
	flyBG.Parent = hrp

	flyBV = Instance.new("BodyVelocity")
	flyBV.velocity = Vector3.new(0, 0, 0)
	flyBV.maxForce = Vector3.new(9e9, 9e9, 9e9)
	flyBV.Parent = hrp

	setNoclip(true)

	flyConn = RunService.Heartbeat:Connect(function()
		if not flyOn or not isCurrentGen() then stopFly() return end
		local char2 = LocalPlayer.Character
		local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")
		if not hrp2 or not flyBV or not flyBG then return end

		local cam = workspace.CurrentCamera
		local move = Vector3.new(0, 0, 0)
		if flyKeys.W then move += cam.CFrame.LookVector end
		if flyKeys.S then move -= cam.CFrame.LookVector end
		if flyKeys.A then move -= cam.CFrame.RightVector end
		if flyKeys.D then move += cam.CFrame.RightVector end
		if flyKeys.Space then move += Vector3.new(0, 1, 0) end
		if flyKeys.Ctrl or flyKeys.Shift then move -= Vector3.new(0, 1, 0) end

		if move.Magnitude > 0 then move = move.Unit * flySpeed end
		flyBV.velocity = move
		flyBG.cframe = cam.CFrame
	end)
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	local k = input.KeyCode
	if k == Enum.KeyCode.W then flyKeys.W = true
	elseif k == Enum.KeyCode.A then flyKeys.A = true
	elseif k == Enum.KeyCode.S then flyKeys.S = true
	elseif k == Enum.KeyCode.D then flyKeys.D = true
	elseif k == Enum.KeyCode.Space then flyKeys.Space = true
	elseif k == Enum.KeyCode.LeftControl or k == Enum.KeyCode.LeftShift then flyKeys.Ctrl = true end
end)

UserInputService.InputEnded:Connect(function(input)
	local k = input.KeyCode
	if k == Enum.KeyCode.W then flyKeys.W = false
	elseif k == Enum.KeyCode.A then flyKeys.A = false
	elseif k == Enum.KeyCode.S then flyKeys.S = false
	elseif k == Enum.KeyCode.D then flyKeys.D = false
	elseif k == Enum.KeyCode.Space then flyKeys.Space = false
	elseif k == Enum.KeyCode.LeftControl or k == Enum.KeyCode.LeftShift then flyKeys.Ctrl = false end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.6)
	local hum = char:WaitForChild("Humanoid", 6)
	if hum then
		syncWalk()
		syncJump()
	end
	if hideNameOn then task.wait(0.2) applyHideName(true) end
	if flyOn then task.wait(0.2) startFly() end
	char.DescendantAdded:Connect(function(obj)
		if hideNameOn and obj:IsA("BillboardGui") then
			task.wait(0.05)
			if flagOn("HideNameOn") then applyHideName(true) end
		end
	end)
end)

task.spawn(function()
	while isCurrentGen() do
		task.wait(0.5)
		local hum = getHumanoid()
		if hum then
			if walkOn and math.abs(hum.WalkSpeed - currentWalkSpeed) > 0.5 then
				pcall(function() hum.WalkSpeed = currentWalkSpeed end)
			end
			if jumpOn then
				local curJump = hum.UseJumpPower and hum.JumpPower or hum.JumpHeight
				if math.abs(curJump - currentJump) > 0.5 then
					pcall(function()
						if hum.UseJumpPower then hum.JumpPower = currentJump else hum.JumpHeight = currentJump end
					end)
				end
			end
			if hideNameOn then pcall(function() applyHideName(true) end) end
		end
		if noclipOn and not noclipRunning then task.spawn(noclipLoop) end
	end
end)

-- Anti-AFK
pcall(function()
	if type(getconnections) == "function" then
		for _, c in ipairs(getconnections(LocalPlayer.Idled)) do c:Disable() end
	end
end)
LocalPlayer.Idled:Connect(function()
	if not flagOn("AntiAfkOn") then return end
	pcall(function()
		local vu = game:GetService("VirtualUser")
		vu:CaptureController()
		vu:ClickButton2(Vector2.new(0, 0))
	end)
end)

-- ===================== LOOPS & SUPERVISOR =====================
local F = {
	Ascend = flagOn("AutoAscendOn"),
	World = flagOn("AutoWorldOn"),
	Treadmill = flagOn("AutoTreadmillOn"),
	Hammer = flagOn("AutoHammerOn"),
	Click = flagOn("AutoClickOn"),
	Rebirth = flagOn("AutoRebirthOn"),
	Win = flagOn("AutoWinOn"),
	Afk = flagOn("AntiAfkOn"),
	Daily = flagOn("AutoDailyOn"),
	PlayTime = flagOn("AutoPlayTimeOn"),
}
local run = {}
for k in pairs(F) do run[k] = false end

local loopErrors = {}
local loopCooldownUntil = {}

local HAMMER_PRIORITY_WAIT = 8
local FloorLock = { owner = nil, since = 0 }

local function lockFloor(name)
	while FloorLock.owner and FloorLock.owner ~= name do
		if os.clock() - FloorLock.since > 20 then break end
		if not isCurrentGen() then return end
		task.wait(0.2)
	end
	FloorLock.owner = name
	FloorLock.since = os.clock()
end

local function unlockFloor(name)
	if FloorLock.owner == name then FloorLock.owner = nil end
end

local function ascendLoop()
	run.Ascend = true
	while F.Ascend and isCurrentGen() do
		local nxt = nextAscend()
		if nxt and wins() >= nxt.Cost then
			local P = ascendPackets()
			if P and P.Ascend then pcall(function() P.Ascend:Fire() end) end
		end
		task.wait(1)
	end
	run.Ascend = false
end

local function worldLoop()
	run.World = true
	while F.World and isCurrentGen() do
		local w = curWorld()
		local r = reincarnate()
		if r and w < #WORLDS then pcall(function() r:FireServer(w + 1) end) end
		task.wait(1)
	end
	run.World = false
end

local TREADMILL_REPIN = 15
local function treadmillLoop()
	run.Treadmill = true
	local function standAt(spot)
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not root or not root.Parent then return false end
		local cf = root.CFrame
		pcall(function()
			root.CFrame = CFrame.new(spot) * (cf - cf.Position)
			root.AssemblyLinearVelocity = Vector3.zero
		end)
		return true
	end

	local pinned, heldAt = nil, nil
	while F.Treadmill and isCurrentGen() do
		local want = getFlag("TreadmillBelt") or "Best"
		local belt = (want ~= "Best") and beltByLabel(want) or nil
		if not belt then belt = bestBelt() end

		if belt then
			local model = treadmillModel(belt.Name)
			local spot = model and beltSpot(model)
			if spot then
				local key = beltLabel(belt)
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if key ~= pinned or not heldAt or os.clock() - heldAt >= TREADMILL_REPIN then
					if standAt(spot) then pinned, heldAt = key, os.clock() end
				elseif root and (root.Position - spot).Magnitude > 2.5 then
					standAt(spot)
				end
			end
		end
		task.wait(0.25)
	end
	run.Treadmill = false
end

local function hammerLoop()
	run.Hammer = true
	while F.Hammer and isCurrentGen() do
		local t = hammerTarget()
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if t and root then
			lockFloor("Hammer")
			local goal = t.podium.CFrame * CFrame.new(0, t.podium.Size.Y / 2 + 2.5, 0)
			local deadline = os.clock() + 1.2
			while os.clock() < deadline do
				if LocalPlayer.Character ~= char or not root.Parent then break end
				if not F.Hammer or not isCurrentGen() then break end
				pcall(function()
					root.CFrame = goal
					root.AssemblyLinearVelocity = Vector3.zero
				end)
				task.wait(0.05)
			end
			unlockFloor("Hammer")
		end
		task.wait(1.5)
	end
	run.Hammer = false
end

local function clickLoop()
	run.Click = true
	while F.Click and isCurrentGen() do
		local r = clickPower()
		if r then pcall(function() r:FireServer() end) end
		task.wait()
	end
	run.Click = false
end

local function rebirthLoop()
	run.Rebirth = true
	while F.Rebirth and isCurrentGen() do
		local r = doRebirth()
		if r then pcall(function() r:FireServer() end) end
		task.wait(0.5)
	end
	run.Rebirth = false
end

local function winLoop()
	run.Win = true
	local root = nil
	local chainArmed = nil

	local function invalidateChain() chainArmed = nil end
	local function alive() return root ~= nil and root.Parent ~= nil end

	local function walkTo(cf)
		if not alive() then return false end
		pcall(function()
			root.CFrame = cf
			root.AssemblyLinearVelocity = Vector3.zero
		end)
		return alive()
	end

	local spawnSpot = nil
	do
		local function locate()
			for _, parent in ipairs({ workspace, workspace:FindFirstChild("World1") }) do
				if parent then
					local sl = parent:FindFirstChildWhichIsA("SpawnLocation", true)
					if sl then return sl end
				end
			end
			return nil
		end
		local sl = locate()
		if sl then
			spawnSpot = { CFrame = sl.CFrame + Vector3.new(0, sl.Size.Y / 2 + 3, 0), Part = sl }
		else
			task.spawn(function()
				while isCurrentGen() and not spawnSpot do
					local s = locate()
					if s then
						spawnSpot = { CFrame = s.CFrame + Vector3.new(0, s.Size.Y / 2 + 3, 0), Part = s }
					end
					task.wait(2)
				end
			end)
		end
	end

	local function returnToSpawn()
		if not alive() then return false end
		if not spawnSpot or not spawnSpot.Part or not spawnSpot.Part.Parent then return false end
		return walkTo(spawnSpot.CFrame)
	end

	local ARRIVE_TOL = 6
	local function walkToVerified(cf, attempts)
		for a = 1, (attempts or 3) do
			if not alive() then return false end
			local d = (root.Position - cf.Position).Magnitude
			if d <= ARRIVE_TOL then return true end
			walkTo(cf)
			if alive() and (root.Position - cf.Position).Magnitude <= ARRIVE_TOL then return true end
		end
		return alive() and (root.Position - cf.Position).Magnitude <= ARRIVE_TOL
	end

	local function visitMogger(m)
		if not (m and m.Parent) then return end
		walkToVerified(m.CFrame * CFrame.new(4, 0, 0), 3)
		local untilAt = os.clock() + 0.8
		while os.clock() < untilAt do
			if not alive() or not F.Win then return end
			pcall(function()
				root.CFrame = m.CFrame * CFrame.new(4, 0, 0)
				root.AssemblyLinearVelocity = Vector3.zero
			end)
			task.wait(0.05)
		end
	end

	local function walkChain(limit)
		local from = 0
		if chainArmed ~= nil and chainArmed + 1 <= limit then from = chainArmed + 1 end
		for _, st in ipairs(winStages(limit)) do
			if not F.Win then return end
			if st.IsPad then break end
			if st.Zone >= from then
				visitMogger(st.Mogger)
				if st.Mogger then chainArmed = st.Zone end
			end
		end
	end

	local function settleAfterDuel()
		invalidateChain()
		task.wait(1.2)
		local first = moggerRoot(0)
		if first and first.Parent then
			visitMogger(first)
			chainArmed = 0
		else
			returnToSpawn()
		end
	end

	local function oneCycle()
		local char = LocalPlayer.Character
		if root ~= (char and char:FindFirstChild("HumanoidRootPart")) then invalidateChain() end
		root = char and char:FindFirstChild("HumanoidRootPart")
		if not root then return false end

		local pad = wantedPad()
		local frontier = beatenFrontier()
		local nextZone = frontier + 1
		local padIsBest = (getFlag("WinPad") == nil) or (getFlag("WinPad") == "Best")

		if flagOn("AutoMogOn") and padIsBest then
			local allMogged = (nextZone > #WIN_REWARDS - 1) or (attr(beatFlag(nextZone)) == true)
			if not allMogged then
				if not mogBlocked(nextZone) then
					walkChain(nextZone + 1)
					if not F.Win or LocalPlayer.Character ~= char or not root or not root.Parent then return false end
					local req = zoneAppealReq(nextZone)
					local appealNow = appeal()
					local gateOpen = (req == nil) or (appealNow >= req)
					local won = false
					if gateOpen then
						won = mogZone(nextZone, tonumber(getFlag("MogBudget")) or 30)
						recordMogResult(nextZone, won)
					else
						recordMogResult(nextZone, false)
						mogBlockAt[nextZone] = nil
						mogAppealShort[nextZone] = req - appealNow
					end
					if won then settleAfterDuel() end
				end
				pad = wantedPad()
			end
		end

		if not F.Win or LocalPlayer.Character ~= char or not root or not root.Parent then return false end
		walkChain(pad)
		if not F.Win or LocalPlayer.Character ~= char or not root or not root.Parent then return false end

		local hb = padHitbox(pad)
		if not hb then return true end

		local paid = false
		local before = wins()
		walkToVerified(hb.CFrame * CFrame.new(0, -3, 12), 3)
		task.wait(0.15)
		walkTo(hb.CFrame * CFrame.new(0, -3, 0))
		local t0 = os.clock()
		while os.clock() - t0 < 2.5 do
			if wins() ~= before then paid = true break end
			if not root or not root.Parent then break end
			task.wait(0.1)
		end
		if paid then invalidateChain() end
		reportClaim(pad, paid)
		if paid then returnToSpawn() end
		return true
	end

	while F.Win and isCurrentGen() do
		if F.Hammer then
			local give = os.clock() + HAMMER_PRIORITY_WAIT
			while F.Win and isCurrentGen() and os.clock() < give do
				if not hammerTarget() then break end
				task.wait(0.4)
			end
		end

		lockFloor("Win")
		local ok = oneCycle()
		unlockFloor("Win")

		if not ok then
			if not F.Win or not isCurrentGen() then break end
			task.wait(0.5)
		end
		task.wait(3.3)
	end
	run.Win = false
end

local function playTimeLoop()
	run.PlayTime = true
	local tiers = playTimeTiers()
	while F.PlayTime and isCurrentGen() do
		local sess = num("SessionSeconds", 0)
		local r = claimPlay()
		if r then
			for _, t in ipairs(tiers) do
				if not F.PlayTime then break end
				if t.Seconds <= sess and not playTimeClaimed(t.Index) then
					pcall(function() r:FireServer(t.Index) end)
					task.wait(0.5)
				end
			end
		end
		task.wait(2)
	end
	run.PlayTime = false
end

local DAILY_COOLDOWN = 86400
local function claimLoop()
	run.Daily = true
	local attemptedAt = 0
	while F.Daily and isCurrentGen() do
		local r = claimDaily()
		if r then
			local last = num("DailyLastClaim", 0) or 0
			local due = (last <= 0) or (os.time() - last >= DAILY_COOLDOWN)
			if due and (attemptedAt == 0 or os.time() - attemptedAt >= 60) then
				attemptedAt = os.time()
				pcall(function() r:FireServer() end)
			end
		end
		task.wait(20)
	end
	run.Daily = false
end

local FLAGOF = {
	Ascend = "AutoAscendOn", World = "AutoWorldOn", Treadmill = "AutoTreadmillOn",
	Hammer = "AutoHammerOn", Click = "AutoClickOn", Rebirth = "AutoRebirthOn",
	Win = "AutoWinOn", Afk = "AntiAfkOn", Daily = "AutoDailyOn",
	PlayTime = "AutoPlayTimeOn",
}

for k, flag in pairs(FLAGOF) do
	local function onFlagUpdate()
		F[k] = flagOn(flag)
	end
	RS:GetAttributeChangedSignal("SW_" .. flag):Connect(onFlagUpdate)
	RS:GetAttributeChangedSignal("LH_" .. flag):Connect(onFlagUpdate)
end

local STARTERS = {
	Ascend = ascendLoop, World = worldLoop, Treadmill = treadmillLoop,
	Hammer = hammerLoop, Click = clickLoop, Rebirth = rebirthLoop,
	Win = winLoop, PlayTime = playTimeLoop,
}

local LOOP_ERROR_BACKOFF = 3
local function supervise(name, starter)
	local ok, err = pcall(starter)
	run[name] = false
	if not ok then
		loopErrors[name] = (loopErrors[name] or 0) + 1
		local n = loopErrors[name]
		warn(string.format("[SpectreWare] %s loop crashed (error %d): %s", name, n, tostring(err)))
		loopCooldownUntil[name] = os.clock() + LOOP_ERROR_BACKOFF * math.min(n, 10)
	else
		loopErrors[name] = 0
	end
end

task.spawn(function()
	while isCurrentGen() do
		for k, starter in pairs(STARTERS) do
			local cooling = loopCooldownUntil[k] and os.clock() < loopCooldownUntil[k]
			if F[k] and not run[k] and not cooling then
				run[k] = true
				task.spawn(function() supervise(k, starter) end)
			end
		end
		if F.Daily and not run.Daily then
			local cooling = loopCooldownUntil.Daily and os.clock() < loopCooldownUntil.Daily
			if not cooling then
				run.Daily = true
				task.spawn(function() supervise("Daily", claimLoop) end)
			end
		end
		task.wait(0.2)
	end
end)

-- ===================== SPECTRE UI WINDOW & TABS =====================
local Window = Library:CreateWindow({
	Title     = BRAND.Name .. " | Mog Evolution",
	Logo      = BRAND.Logo,
	ToggleKey = Enum.KeyCode.RightShift,
	Theme     = "Spectre",
	AutoCheck = { Skip = { TextClip = true } },
	Splash    = {
		Title     = "SPECTREWARE",
		Subtitle  = "MOG EVOLUTION",
		Duration  = 2.2,
		Steps     = { "Checking remotes", "Loading progression data", "Preparing interface", "Ready!" },
		Logo      = BRAND.Logo,
		Skippable = true,
	},
})

if not Window then
	return warn("[SpectreWare] Failed to create SpectreUI window.")
end

-- ===================== TAB 1: OVERVIEW =====================
local OverviewTab = Window:CreateTab({ Name = "Overview", Icon = "lucide:layout-dashboard" })

local SessionSec = OverviewTab:CreateSection({ Name = "Session Stats" })
local StatUptime  = SessionSec:CreateKeyValue({ Name = "Uptime",  Value = "00:00:00", Copyable = false })
local StatPlayer  = SessionSec:CreateKeyValue({ Name = "Player",  Value = LocalPlayer.DisplayName, Copyable = false })
local StatWins    = SessionSec:CreateKeyValue({ Name = "Wins",    Value = tostring(wins()), Copyable = false })
local StatAppeal  = SessionSec:CreateKeyValue({ Name = "Appeal",  Value = tostring(appeal()), Copyable = false })
local StatWorld   = SessionSec:CreateKeyValue({ Name = "World",   Value = tostring(curWorld()), Copyable = false })
local StatRebirth = SessionSec:CreateKeyValue({ Name = "Rebirth", Value = tostring(rebirths()), Copyable = false })
local StatPing    = SessionSec:CreateKeyValue({ Name = "Ping",    Value = "0 ms", Copyable = false })

local StartedAt = os.clock()
task.spawn(function()
	while isCurrentGen() do
		pcall(function()
			StatUptime:Set(formatClock(os.clock() - StartedAt))
			StatPlayer:Set(LocalPlayer.DisplayName)
			StatWins:Set(abbrev(wins()) .. " (" .. tostring(wins()) .. ")")
			StatAppeal:Set(abbrev(appeal()) .. " (" .. tostring(appeal()) .. ")")
			StatWorld:Set(tostring(curWorld()))
			StatRebirth:Set(tostring(rebirths()))
			local ping = nil
			pcall(function()
				local stats = StatsService:GetNetworkStats()
				if stats and stats.DataSend and stats.DataReceive then
					ping = math.floor((stats.DataSend + stats.DataReceive) / 2)
				end
			end)
			if ping then StatPing:Set(string.format("%d ms", ping)) end
		end)
		task.wait(1)
	end
end)

local InfoSec = OverviewTab:CreateSection({ Name = "Information & Quick Actions" })
InfoSec:CreateParagraph({
	Title   = "SpectreWare Hub",
	Content = "Mog Evolution automation hub with adaptive Win Pad discovery, stage boss progression, and full multi-tier claiming.",
})
InfoSec:CreateButton({
	Name     = "Copy Discord Invite",
	Callback = function()
		pcall(function()
			if setclipboard then setclipboard(BRAND.Discord) end
			Window:Toast("Copied Discord invite to clipboard!", "Success")
		end)
	end,
})
InfoSec:CreateButton({
	Name     = "Rejoin Server",
	Callback = function()
		pcall(function()
			TeleportService:Teleport(game.PlaceId, LocalPlayer)
		end)
	end,
})

-- ===================== TAB 2: PROGRESSION =====================
local ProgressionTab = Window:CreateTab({ Name = "Progression", Icon = "lucide:trending-up" })

local AscSec = ProgressionTab:CreateSection({ Name = "Ascension & World" })
AscSec:CreateToggle({
	Name     = "Auto Ascend",
	Tooltip  = "Automatically ascends body tier ladder when enough Wins are reached",
	Default  = flagOn("AutoAscendOn"),
	Flag     = "AutoAscendOn",
	Callback = function(v) setFlag("AutoAscendOn", v) end,
})
AscSec:CreateToggle({
	Name     = "Auto World Unlock",
	Tooltip  = "Automatically unlocks and reincarnates to the next world when affordable",
	Default  = flagOn("AutoWorldOn"),
	Flag     = "AutoWorldOn",
	Callback = function(v) setFlag("AutoWorldOn", v) end,
})

local FarmSec = ProgressionTab:CreateSection({ Name = "Treadmill Farm" })
FarmSec:CreateToggle({
	Name     = "Auto Treadmill",
	Tooltip  = "Teleports you onto the belt once, then holds you in the middle",
	Default  = flagOn("AutoTreadmillOn"),
	Flag     = "AutoTreadmillOn",
	Callback = function(v) setFlag("AutoTreadmillOn", v) end,
})

local beltOpts = { "Best" }
for _, b in ipairs(BELTS) do beltOpts[#beltOpts + 1] = beltLabel(b) end
local beltSaved = getFlag("TreadmillBelt") or "Best"
if beltSaved == "Deafult" then beltSaved = "Default" end
if beltSaved == "VIPx10" then beltSaved = "VIP x10" end

FarmSec:CreateDropdown({
	Name     = "Belt Selection",
	Tooltip  = "Best picks your highest unlocked belt automatically",
	Options  = beltOpts,
	Default  = beltSaved,
	Flag     = "TreadmillBelt",
	Callback = function(v) setFlag("TreadmillBelt", v) end,
})

local HamSec = ProgressionTab:CreateSection({ Name = "Hammers" })
HamSec:CreateToggle({
	Name     = "Auto Buy Hammers",
	Tooltip  = "Buys the cheapest hammer that is an upgrade over held and owned hammers",
	Default  = flagOn("AutoHammerOn"),
	Flag     = "AutoHammerOn",
	Callback = function(v) setFlag("AutoHammerOn", v) end,
})
local HamStat = HamSec:CreateKeyValue({ Name = "Hammer Status", Value = "...", Copyable = false })

task.spawn(function()
	while isCurrentGen() do
		pcall(function()
			local equipped = hammerInfo(num("HammerTier", 0) or 0)
			local cash = wins()
			local nextT, nextCost
			local floorMulti = hammerFloor()
			for _, t in ipairs(HAMMER_TIERS) do
				if t.Multi > floorMulti and (not nextT or t.Cost < nextCost) then
					nextT, nextCost = t, t.Cost
				end
			end
			local held = equipped and string.format("%s (x%d)", equipped.Title, equipped.Multi) or "none"
			local line
			if not nextT then
				line = string.format("%s - All tiers owned", held)
			elseif cash < nextCost then
				line = string.format("%s - Next: %s needs %s (have %s)", held, nextT.Title, abbrev(nextCost), abbrev(cash))
			else
				line = string.format("%s - Buying: %s for %s", held, nextT.Title, abbrev(nextCost))
			end
			HamStat:Set(line)
		end)
		task.wait(1)
	end
end)

-- ===================== TAB 3: AUTOMATION =====================
local AutoTab = Window:CreateTab({ Name = "Automation", Icon = "lucide:zap" })

local WinSec = AutoTab:CreateSection({ Name = "Win Pad Farm" })
WinSec:CreateToggle({
	Name     = "Auto Win",
	Tooltip  = "Walks the mogger chain for the chosen pad, then claims it on repeat",
	Default  = flagOn("AutoWinOn"),
	Flag     = "AutoWinOn",
	Callback = function(v) setFlag("AutoWinOn", v) end,
})
WinSec:CreateToggle({
	Name     = "Mog Stage Bosses",
	Tooltip  = "Best only: fights the next unbeaten boss when Appeal is high enough",
	Default  = flagOn("AutoMogOn"),
	Flag     = "AutoMogOn",
	Callback = function(v) setFlag("AutoMogOn", v) end,
})
WinSec:CreateSlider({
	Name      = "Mog Budget",
	Tooltip   = "Seconds allowed per boss fight before giving up on it",
	Min       = 5,
	Max       = 120,
	Increment = 5,
	Default   = tonumber(getFlag("MogBudget")) or 30,
	Suffix    = "s",
	Flag      = "MogBudget",
	Callback  = function(v) setFlag("MogBudget", tonumber(v) or 30) end,
})

local padOptions = { "Best" }
for i, v in ipairs(WIN_REWARDS) do
	padOptions[#padOptions + 1] = string.format("Pad %d (+%s)", i, abbrev(v))
end

local padSaved = getFlag("WinPad") or "Best"
do
	local n = tonumber(padSaved)
	if n then
		n = math.clamp(math.floor(n), 1, #WIN_REWARDS)
		padSaved = string.format("Pad %d (+%s)", n, abbrev(WIN_REWARDS[n]))
	end
end

WinSec:CreateDropdown({
	Name     = "Win Pad",
	Tooltip  = "Best farms the highest pad your mogs unlock, and mogs up to reach it",
	Options  = padOptions,
	Default  = padSaved,
	Flag     = "WinPad",
	Callback = function(v) setFlag("WinPad", v) end,
})

local WinStat = WinSec:CreateKeyValue({ Name = "Farming Status", Value = "Pad 1", Copyable = false })

task.spawn(function()
	while isCurrentGen() do
		pcall(function()
			local pad = wantedPad()
			local frontier = beatenFrontier()
			local line = string.format("Pad %d (+%s) [Best %d, Mogged %d]", pad, abbrev(padReward(pad)), bestPad(), math.max(frontier, 0))
			if probeUp then line = line .. " (probing up)" end
			local nextZone = frontier + 1
			if nextZone > #WIN_REWARDS - 1 then
				line = line .. " - All zones cleared"
			elseif attr(beatFlag(nextZone)) ~= true then
				local gap = frontierAppealGap(nextZone)
				if gap then
					line = line .. string.format(" - Z%d needs %s more Appeal", nextZone, abbrev(math.ceil(gap)))
				else
					local untilAt = mogBlockAt[nextZone]
					if untilAt and untilAt > os.time() then
						line = line .. string.format(" - Z%d cooldown (%dm)", nextZone, math.max(1, math.ceil((untilAt - os.time()) / 60)))
					else
						line = line .. string.format(" - Fighting Z%d (Appeal %s)", nextZone, abbrev(math.floor(appeal())))
					end
				end
			end
			WinStat:Set(line)
		end)
		task.wait(1)
	end
end)

local AutoClickSec = AutoTab:CreateSection({ Name = "General Automation" })
AutoClickSec:CreateToggle({
	Name     = "Auto Click",
	Tooltip  = "Automatically fires click power remote",
	Default  = flagOn("AutoClickOn"),
	Flag     = "AutoClickOn",
	Callback = function(v) setFlag("AutoClickOn", v) end,
})
AutoClickSec:CreateToggle({
	Name     = "Auto Rebirth",
	Tooltip  = "Automatically triggers rebirths",
	Default  = flagOn("AutoRebirthOn"),
	Flag     = "AutoRebirthOn",
	Callback = function(v) setFlag("AutoRebirthOn", v) end,
})

local RewSec = AutoTab:CreateSection({ Name = "Rewards" })
RewSec:CreateToggle({
	Name     = "Auto Claim Daily",
	Tooltip  = "Claims daily reward automatically (24h cooldown)",
	Default  = flagOn("AutoDailyOn"),
	Flag     = "AutoDailyOn",
	Callback = function(v) setFlag("AutoDailyOn", v) end,
})
RewSec:CreateToggle({
	Name     = "Auto Claim Play Time",
	Tooltip  = "Claims every unlocked play time reward tier (1-8)",
	Default  = flagOn("AutoPlayTimeOn"),
	Flag     = "AutoPlayTimeOn",
	Callback = function(v) setFlag("AutoPlayTimeOn", v) end,
})
local PlayStat = RewSec:CreateKeyValue({ Name = "Play Time Status", Value = "...", Copyable = false })

task.spawn(function()
	while isCurrentGen() do
		pcall(function()
			local sess = num("SessionSeconds", 0)
			local tiers = playTimeTiers()
			local done, pending, nextAt = 0, {}, nil
			for _, t in ipairs(tiers) do
				if playTimeClaimed(t.Index) then
					done = done + 1
				else
					pending[#pending + 1] = t.Index
					if t.Seconds > sess and not nextAt then nextAt = t.Seconds end
				end
			end
			local left = ("%d min"):format(math.max(0, math.ceil((nextAt - sess) / 60)))
			PlayStat:Set(string.format("%d/%d claimed - next in %s", done, #tiers, left))
		end)
		task.wait(1)
	end
end)

-- ===================== TAB 4: MISC =====================
local MiscTab = Window:CreateTab({ Name = "Misc", Icon = "lucide:gamepad-2" })

local UtilSec = MiscTab:CreateSection({ Name = "Utilities" })
UtilSec:CreateToggle({
	Name     = "Hide Name",
	Tooltip  = "Hides nametag and overhead billboard completely",
	Default  = hideNameOn,
	Flag     = "HideNameOn",
	Callback = function(v)
		hideNameOn = v
		setFlag("HideNameOn", v)
		applyHideName(v)
	end,
})
UtilSec:CreateToggle({
	Name     = "Noclip",
	Tooltip  = "Walk through walls without collisions",
	Default  = noclipOn,
	Flag     = "NoclipOn",
	Callback = function(v)
		noclipOn = v
		setFlag("NoclipOn", v)
		if v then
			if not noclipRunning then task.spawn(noclipLoop) end
		else
			pcall(function() setNoclip(false) end)
		end
	end,
})
UtilSec:CreateToggle({
	Name     = "Anti-AFK",
	Tooltip  = "Prevents Roblox 20-minute idle disconnection",
	Default  = flagOn("AntiAfkOn"),
	Flag     = "AntiAfkOn",
	Callback = function(v) setFlag("AntiAfkOn", v) end,
})

local MoveSec = MiscTab:CreateSection({ Name = "Movement" })
MoveSec:CreateToggle({
	Name     = "Enable WalkSpeed",
	Tooltip  = "Applies custom WalkSpeed",
	Default  = walkOn,
	Flag     = "WalkOn",
	Callback = function(v)
		walkOn = v
		setFlag("WalkOn", v)
		if v then
			syncWalk()
		else
			pcall(function()
				local hum = getHumanoid()
				if hum then hum.WalkSpeed = defaultWalkSpeed end
			end)
		end
	end,
})
MoveSec:CreateSlider({
	Name      = "WalkSpeed",
	Min       = 8,
	Max       = 200,
	Increment = 1,
	Default   = currentWalkSpeed,
	Flag      = "WalkSpeed",
	Callback  = function(v) applyWalkSpeed(v) end,
})
MoveSec:CreateToggle({
	Name     = "Enable Jump Height",
	Tooltip  = "Applies custom Jump Height / Jump Power",
	Default  = jumpOn,
	Flag     = "JumpOn",
	Callback = function(v)
		jumpOn = v
		setFlag("JumpOn", v)
		if v then
			syncJump()
		else
			pcall(function()
				local hum = getHumanoid()
				if not hum then return end
				if hum.UseJumpPower then
					hum.JumpPower = defaultJumpPower
				else
					hum.JumpHeight = defaultJumpHeight
				end
			end)
		end
	end,
})
MoveSec:CreateSlider({
	Name      = "Jump Height",
	Min       = 0,
	Max       = 200,
	Increment = 1,
	Default   = currentJump,
	Flag      = "JumpHeight",
	Callback  = function(v) applyJump(v) end,
})

local FlySec = MiscTab:CreateSection({ Name = "Flight" })
FlySec:CreateToggle({
	Name     = "Fly",
	Tooltip  = "Fly freely with WASD + Space/Shift (noclip enabled while flying)",
	Default  = flyOn,
	Flag     = "FlyOn",
	Callback = function(v)
		if v then startFly() else stopFly() end
	end,
})
FlySec:CreateSlider({
	Name      = "Fly Speed",
	Min       = 10,
	Max       = 250,
	Increment = 5,
	Default   = flySpeed,
	Suffix    = " studs/s",
	Flag      = "FlySpeed",
	Callback  = function(v)
		flySpeed = math.clamp(tonumber(v) or 60, 10, 250)
		setFlag("FlySpeed", flySpeed)
	end,
})

-- ===================== DEFAULT TABS (THEME & SETTINGS) =====================
Window:CreateDefaultTabs()

-- Autoload configuration when UI completes loading
Window:OnLoaded(function()
	pcall(function()
		Library:AutoloadConfig("auto", true)
	end)
end)

-- Initial state activation
if hideNameOn then applyHideName(true) end
if noclipOn and not noclipRunning then task.spawn(noclipLoop) end
if flyOn then task.defer(function() task.wait(0.8) if flagOn("FlyOn") then startFly() end end) end

-- Ready Notification
Window:Notify({
	Title   = BRAND.Name,
	Content = "Mog Evolution script loaded successfully. Press RightShift to toggle menu.",
	Duration = 5,
	Kind    = "Success",
})

print(string.format("[SpectreWare] Mog Evolution script loaded successfully (LoadGen: %d)", LOAD_GEN))
