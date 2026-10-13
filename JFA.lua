--[[
	SpecreWare | Jump for Animals
	UI: SpectreUI v3.17 (dark/cyan-navy Roblox UI library by SpectreWare)
	Theme: Spectre (Dark Graphite / Deep Navy Slate / Electric Cyan)
	Brand: SpecreWare
	Discord: https://discord.gg/GdKxvcHzjS
	Game: Jump for Animals
	PlaceId: 126870639873289

	Features:
	  • Built with SpectreUI v3.17 with Minimize Bind Customization
	  • All automation logic from J-Hub preserved intact
	  • Auto Train 2x / Smart Train / Auto Trampoline / Smart Trampoline
	  • Auto Collect Eggs / Skylands Eggs / Place Eggs / Incubator
	  • Auto Sell Pets / Equip Best / Buy Pet Slot / Mutation
	  • Auto Buy Barbell / Auto Buy Plot / Auto Claim Rewards
	  • Auto Fossil Dig & Clean / Auto Buy Fossil Egg
	  • Teleports (Zones) / More FPS / Anti-AFK
	  • Config Save/Load/Auto-Load system
	  • Key system removed — keyless
]]

-- AUTO Plugin fix for Delta / Wave / Arceus / Fluxus
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
	return warn("[SpecreWare] Failed to load SpectreUI. Check internet/executor.")
end

-- ===================== PROTECTED RUNNER =====================
local JFA_RUN = function()

-- ===================== GAME GUARD =====================
local PLACE_ID = "126870639873289"
if tostring(game.PlaceId) ~= PLACE_ID then
	warn("[SpecreWare | JFA] Wrong game! PlaceId=" .. tostring(game.PlaceId))
	return
end

-- ===================== SERVICES & LOCALS =====================
local Players    = game:GetService("Players")
local RS         = game:GetService("ReplicatedStorage")
local UIS        = game:GetService("UserInputService")
local HttpSvc    = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local W          = task.wait
local p          = task.spawn

-- ===================== GENERATION / ALIVE CHECK =====================
getgenv().JumpAnimalsGen = (getgenv().JumpAnimalsGen or 0) + 1
local V = getgenv().JumpAnimalsGen
getgenv().JumpAnimalsAlive = true
getgenv().JumpAnimalsEn    = getgenv().JumpAnimalsEn or {}
getgenv().JumpAnimalsVersion = "jfa-specreware-1.0"

local function H() -- isAlive
	return getgenv().JumpAnimalsAlive == true and getgenv().JumpAnimalsGen == V
end

-- ===================== CLEANUP OLD UIs =====================
pcall(function()
	local function tryClean(parent)
		for _, sg in ipairs(parent:GetChildren()) do
			if sg:IsA("ScreenGui") and sg.Name ~= "JumpAnimals_MiniIcon" then
				local shouldDestroy = false
				if sg.Name == "JHub_MiniIcon" or sg.Name == "JHubKeySystem" then
					shouldDestroy = true
				else
					for _, d in ipairs(sg:GetDescendants()) do
						if d:IsA("TextLabel") then
							local t = tostring(d.Text or "")
							if t:find("J HUB") and (t:find("Jump for Animals") or t:find("Jump for Animal")) then
								shouldDestroy = true; break
							end
						end
					end
				end
				if shouldDestroy then pcall(function() sg:Destroy() end) end
			end
		end
	end
	local roots = { game:GetService("CoreGui") }
	if gethui then pcall(function() roots[#roots+1] = gethui() end) end
	for _, r in ipairs(roots) do tryClean(r) end
end)
pcall(function()
	if getgenv().JumpAnimals_MiniIcon then
		getgenv().JumpAnimals_MiniIcon:Destroy()
		getgenv().JumpAnimals_MiniIcon = nil
	end
end)

-- ===================== SAFE EXECUTOR ENVIRONMENT =====================
pcall(function()
	local canCoreGui = false
	pcall(function()
		local f = Instance.new("Folder")
		f.Parent = game:GetService("CoreGui")
		f:Destroy()
		canCoreGui = true
	end)
	if not gethui or not pcall(function() local f = Instance.new("Folder", gethui()) f:Destroy() end) then
		if canCoreGui then
			gethui = function() return game:GetService("CoreGui") end
		else
			gethui = function()
				return (LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")) or game:GetService("CoreGui")
			end
		end
	end
end)

-- Remove glass effect blockers
pcall(function()
	for _, d in ipairs(workspace:GetDescendants()) do
		if d:IsA("BasePart") and d.Name == "Body" and d.Material == Enum.Material.Glass
			and d.Anchored and not d.CanCollide
			and d.Size.X == 1 and d.Size.Y == 1 and d.Size.Z <= 0.01
			and d:FindFirstChildOfClass("SpecialMesh") then
			pcall(function() d:Destroy() end)
		end
	end
end)

-- Anti-AFK
pcall(function()
	if type(getconnections) == "function" then
		for _, c in ipairs(getconnections(LocalPlayer.Idled)) do c:Disable() end
	end
end)
LocalPlayer.Idled:Connect(function()
	local en = getgenv().JumpAnimalsEn
	if en and en.antiAfk == false then return end
	pcall(function()
		local vu = game:GetService("VirtualUser")
		vu:CaptureController()
		vu:ClickButton2(Vector2.new(0,0))
	end)
end)

-- ===================== CORE HELPERS =====================
local function getRoot()
	local ch = LocalPlayer.Character
	return ch and ch:FindFirstChild("HumanoidRootPart")
end

local function tpTo(cf, label)
	local root = getRoot()
	if root and cf then
		pcall(function()
			local log = getgenv().JfaTpLog or {}
			log[#log+1] = string.format("%.0f", os.clock()%10000) .. " [" .. tostring(label or "-") .. "] -> " .. string.format("%.0f,%.0f,%.0f", cf.Position.X, cf.Position.Y, cf.Position.Z)
			while #log > 25 do table.remove(log,1) end
			getgenv().JfaTpLog = log
		end)
		pcall(function()
			root.AssemblyLinearVelocity  = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			root.CFrame = cf
		end)
	end
end

getgenv().JumpAnimalsTpLock = getgenv().JumpAnimalsTpLock or { owner=nil, untilT=0 }
local function getTpOwner()
	local a = getgenv().JumpAnimalsTpLock
	if a and a.owner and tick() < (a.untilT or 0) then return a.owner end
	return nil
end
local function waitForTp(owner, maxT)
	owner = owner or "misc"; maxT = maxT or 8
	local waited = 0
	while H() do
		local o = getTpOwner()
		if not o or o == owner then return true end
		if waited >= maxT then return false end
		W(.05); waited = waited + .05
	end
	return false
end
local function lockTp(owner, dur)
	owner = owner or "misc"
	getgenv().JumpAnimalsTpLock = { owner=owner, untilT=tick()+(dur or 3.5) }
end

getgenv().JfaMove = getgenv().JfaMove or { owner=nil, prio=0, untilT=0 }
local MOVE_PRIO = { collect=1, skyEggs=2, smartTramp=2, fossil=2, place=3, mutate=4, incubator=5, fossilBuy=5, smartSteal=2, smartSquat=6, trampoline=6 }
local function getMovePrio(k) return 7 - (MOVE_PRIO[k] or 6) end
local function getCurrentMove()
	local a = getgenv().JfaMove
	if a and a.owner and tick() < (a.untilT or 0) then return a end
	return nil
end
local function acquireMove(owner, prio, timeout)
	prio = prio or 1; timeout = timeout or 10
	if prio < 0 then return false end
	local t0 = os.clock()
	while H() do
		local m = getgenv().JfaMove
		if not m or not m.owner or tick() >= (m.untilT or 0) or m.owner == owner then
			getgenv().JfaMove = { owner=owner, prio=prio, untilT=tick()+1.5 }
			return true
		end
		local tpL = getgenv().JumpAnimalsTpLock
		local tpBusy = tpL and tpL.owner and tpL.owner ~= owner and tick() < (tpL.untilT or 0)
		if prio > (m.prio or 0) and not tpBusy then
			getgenv().JfaMove = { owner=owner, prio=prio, untilT=tick()+1.5 }
			return true
		end
		if os.clock() - t0 >= timeout then return false end
		W(.05)
	end
	return false
end
local function extendMove(owner, prio, dur)
	local m = getgenv().JfaMove
	if m and m.owner == owner then
		m.untilT = tick() + (dur or 1.5)
		m.prio = prio or m.prio or 1
	end
end
local function releaseMove(owner)
	local m = getgenv().JfaMove
	if m and m.owner == owner then
		getgenv().JfaMove = { owner=nil, prio=0, untilT=0 }
	end
end

getgenv().JfaHands = getgenv().JfaHands or { owner=nil, untilT=0 }
local function acquireHands(owner, timeout)
	timeout = timeout or 10
	local t0 = os.clock()
	while H() do
		local h = getgenv().JfaHands
		if not h.owner or tick() >= (h.untilT or 0) or h.owner == owner then
			getgenv().JfaHands = { owner=owner, untilT=tick()+3 }
			return true
		end
		if os.clock() - t0 >= timeout then return false end
		W(.15)
	end
	return false
end
local function extendHands(owner, dur)
	local h = getgenv().JfaHands
	if h and h.owner == owner then h.untilT = tick() + (dur or 3) end
end
local function releaseHands(owner)
	local h = getgenv().JfaHands
	if h and h.owner == owner then
		getgenv().JfaHands = { owner=nil, untilT=0 }
	end
end

-- ===================== GAME FINDERS =====================
local Remotes = RS:WaitForChild("Remotes", 10)
local function findRemote(name)
	if not Remotes then return nil end
	return Remotes:FindFirstChild(name) or Remotes:WaitForChild(name, 5)
end
local function fireRemote(name, ...)
	local r = findRemote(name)
	if r and r:IsA("RemoteEvent") then
		pcall(r.FireServer, r, ...)
		return true
	end
	return false
end

local function getPlot()
	local ok, v = pcall(function() local p = LocalPlayer:WaitForChild("Plot",5) return p and p.Value or nil end)
	return ok and v or nil
end
local function getDetectorCF()
	local ok, v = pcall(function()
		local plot = getPlot()
		local det = plot and plot:FindFirstChild("Detector")
		if det and det:IsA("BasePart") then return det.CFrame + Vector3.new(0,5,0) end
	end)
	return ok and v or nil
end
local function goToDetector()
	local plot = getPlot()
	local det  = plot and plot:FindFirstChild("Detector")
	local root = getRoot()
	if det and det:IsA("BasePart") and root then
		local a = det.CFrame:PointToWorldSpace(Vector3.new(math.max(det.Size.X/2-5, 0), 5, 0))
		if (root.Position - a).Magnitude > 8 then
			tpTo(CFrame.new(a))
			W(.3)
		end
	end
end
local function getSquatZone()
	local ok, sqZ, det, floor = pcall(function()
		local plot = getPlot()
		local sqZ = plot and plot:FindFirstChild("SquatZone")
		local floor = sqZ and sqZ:FindFirstChild("Floor")
		local det = floor and floor:FindFirstChild("Detector")
		return sqZ, det, floor
	end)
	if ok then return sqZ, det, floor end
	return nil, nil, nil
end
local function getSellZone()
	local ok, det, prompt = pcall(function()
		local map = workspace:FindFirstChild("Map")
		local sell = map and map:FindFirstChild("Sell")
		local det = sell and sell:FindFirstChild("Detector")
		local prompt = det and det:FindFirstChild("SellAnimalPrompt")
		if not prompt and sell then prompt = sell:FindFirstChild("SellAnimalPrompt", true) end
		return det, prompt
	end)
	return ok and det or nil, ok and prompt or nil
end

-- ===================== MISC UTILITY =====================
local function formatNum(n)
	if not n or n ~= n then return "0" end
	if n >= 1e18 then return string.format("%.1fQi", n/1e18)
	elseif n >= 1e15 then return string.format("%.1fQa", n/1e15)
	elseif n >= 1e12 then return string.format("%.1fT", n/1e12)
	elseif n >= 1e9  then return string.format("%.1fB", n/1e9)
	elseif n >= 1e6  then return string.format("%.1fM", n/1e6)
	elseif n >= 1e3  then return string.format("%.1fK", n/1e3)
	else return tostring(math.floor(n)) end
end

local function getCash()
	local ok, v = pcall(function()
		local ls = LocalPlayer:FindFirstChild("leaderstats")
		local cash = ls and ls:FindFirstChild("Cash")
		local vChild = cash and cash:FindFirstChild("V")
		return vChild and tonumber(vChild.Value) or nil
	end)
	return ok and v or nil
end

local function getJumpPower()
	local ok, v = pcall(function()
		local jp = LocalPlayer:FindFirstChild("JumpPower")
		return jp and tonumber(jp.Value) or nil
	end)
	return ok and v or nil
end

local SUFFIX_MAP = { k=1e3, m=1e6, b=1e9, t=1e12, qa=1e15, q=1e15, qi=1e18, sx=1e21, sp=1e24, oc=1e27, no=1e30, dc=1e33, ud=1e36, dd=1e39, td=1e42, qd=1e45, qn=1e48 }
local function parseNum(a)
	if type(a) == "number" then return a, false end
	if type(a) ~= "string" then return nil, false end
	local s = a:gsub("%s","")
	if s:upper():find("MAX") then return nil, true end
	s = s:gsub("[%$%,]","")
	local exp = s:match("^([%d%.]+[eE][%+%-]?%d+)$")
	if exp then local n=tonumber(exp) if n then return n, false end end
	local num, suf = s:match("^([%d%.]+)([a-zA-Z]*)$")
	local nVal = tonumber(num)
	if not nVal then return nil, false end
	if suf and suf ~= "" then
		local mult = SUFFIX_MAP[string.lower(suf)]
		if mult then return nVal*mult, false end
		return nil, false
	end
	return nVal, false
end

local function tableContains(tbl, val)
	if type(tbl) ~= "table" or val == nil then return false end
	if tbl[val] == true then return true end
	local lv = string.lower(tostring(val))
	for k, v in pairs(tbl) do
		if type(k) == "number" and string.lower(tostring(v)) == lv then return true end
		if type(v) == "string" and string.lower(v) == lv then return true end
	end
	return false
end

local function fireProximityPrompt(prompt)
	if not prompt then return false end
	local hd = tonumber(prompt.HoldDuration) or 0
	if hd > 0 then pcall(function() prompt.HoldDuration = 0 end) end
	if type(fireproximityprompt) == "function" then
		pcall(fireproximityprompt, prompt)
	else
		pcall(function() prompt:InputHoldBegin() W(.05) prompt:InputHoldEnd() end)
	end
	if hd > 0 then pcall(function() prompt.HoldDuration = hd end) end
	return true
end

local function fireProxAsync(prompt)
	if not prompt or not prompt.Enabled then return false end
	local done = false
	p(function() pcall(fireProximityPrompt, prompt) done = true end)
	local t0 = os.clock()
	while not done and os.clock()-t0 < 2 do W(.05) end
	return done
end

local function fireTouchInterest(part)
	local root = getRoot()
	if not root or not part or not part:IsA("BasePart") then return false end
	if type(firetouchinterest) == "function" then
		pcall(firetouchinterest, root, part, 0)
		W(.05)
		pcall(firetouchinterest, root, part, 1)
		return true
	end
	tpTo(part.CFrame + Vector3.new(0, 1.5, 0))
	return true
end

local function tpToObj(obj, offset, lockOwner)
	if not obj then return false end
	waitForTp(lockOwner or "misc")
	local cf = nil
	if obj:IsA("BasePart") then cf = obj.CFrame
	elseif obj:IsA("Model") then cf = obj:GetPivot()
	elseif obj:IsA("Attachment") then cf = obj.WorldCFrame
	elseif obj.Parent and obj.Parent:IsA("BasePart") then cf = obj.Parent.CFrame
	end
	if cf then
		tpTo(cf + (offset or Vector3.new(0, 2.5, 0)))
		lockTp(lockOwner or "misc")
		W(.1)
		return true
	end
	return false
end

-- ===================== AREA / ZONE DATA =====================
local RARITY_RANK = {}
local RARITIES = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Divine","Celestial","Eternal"}
for i, v in ipairs(RARITIES) do RARITY_RANK[v] = i end

local ZONE_JUMP = {
	["Meadow"]=0, ["Coral Reef"]=60, ["Winter"]=115, ["Desert"]=180,
	["Crystal Mines"]=210, ["Jungle"]=245, ["Mystic Isles"]=285,
	["Prehistoric"]=325, ["Celestial Heights"]=450, ["Savannah"]=575,
	["The Underworld"]=800,
}
local ZONE_JUMP2 = {
	["Coral Reef1"]=60, ["Coral Reef2"]=80, ["Winter1"]=115, ["Winter2"]=150,
	["Desert1"]=180, ["Desert2"]=205, ["Crystal Mines1"]=210, ["Crystal Mines2"]=230,
	["Jungle1"]=245, ["Jungle2"]=265, ["Mystic Isles1"]=285, ["Mystic Isles2"]=305,
	["Prehistoric1"]=325, ["Prehistoric2"]=395, ["Celestial Heights1"]=450,
	["Celestial Heights2"]=510, ["Savannah1"]=575, ["Savannah2"]=640,
	["The Underworld1"]=800, ["The Underworld2"]=900,
}
local function getCurrentJump()
	local ok, v = pcall(function()
		local jp = LocalPlayer:FindFirstChild("JumpPower")
		return jp and tonumber(jp.Value) or 0
	end)
	return ok and v or 0
end

local function getRecommendedJumps()
	local cache = getgenv().JfaRecJumps
	if type(cache) == "table" and os.clock() - (cache.t or 0) < 300 and type(cache.map) == "table" then
		return cache.map
	end
	local L = {}
	pcall(function()
		local settings = RS:FindFirstChild("Settings")
		if settings then
			local rj = settings:FindFirstChild("RecommendedJumps")
			local mod = rj and require(rj)
			if type(mod) == "table" then
				local list = type(mod.List) == "table" and mod.List or mod
				for k, v in pairs(list) do if tonumber(v) then L[tostring(k)] = tonumber(v) end end
			end
			local areas = settings:FindFirstChild("Areas")
			local aMod = areas and require(areas)
			if type(aMod) == "table" then
				local list = type(aMod.List) == "table" and aMod.List or aMod
				for k, v in pairs(list) do
					if type(v) == "table" then
						local req = tonumber(v.JumpPower or v.JumpReq or v.MinimumJumpPower or v.RequiredJump)
						if req then L[tostring(k)] = req end
					end
				end
			end
		end
	end)
	pcall(function()
		local stages = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Stages")
		if stages then
			for _, st in ipairs(stages:GetChildren()) do
				local req = tonumber(st:GetAttribute("JumpPower") or st:GetAttribute("JumpRequirement") or st:GetAttribute("RequiredJump"))
				if req then L[st.Name] = req end
			end
		end
	end)
	if next(L) then
		getgenv().JfaRecJumps = { t=os.clock(), map=L }
		return L
	end
	return cache and cache.map or nil
end

local function getZoneReq(zoneName, variant)
	if not zoneName or zoneName == "" then return 0 end
	zoneName = tostring(zoneName):match("^%s*(.-)%s*$")
	if zoneName == "" or zoneName:lower() == "meadow" then return 0 end
	local rec = getRecommendedJumps()
	if rec then
		if variant and rec[zoneName .. variant] then return rec[zoneName .. variant] end
		if rec[zoneName] then return rec[zoneName] end
	end
	if variant then
		local v2 = ZONE_JUMP2[zoneName .. variant]
		if v2 then return v2 end
	end
	local v = ZONE_JUMP[zoneName]
	if v then return v end
	if getCurrentJump() >= 1000 then return 0 end
	return nil
end

-- ===================== EGG / PET HELPERS =====================
getgenv().JfaCarryFull     = getgenv().JfaCarryFull or false
getgenv().JfaCarryBaseline = getgenv().JfaCarryBaseline or 0
getgenv().JfaEggBlacklist  = getgenv().JfaEggBlacklist or {}

local function countEggTools()
	local n = 0
	pcall(function()
		for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
			if t:IsA("Tool") and t:GetAttribute("IsEggTool") then n = n + 1 end
		end
		local ch = LocalPlayer.Character
		if ch then
			for _, t in ipairs(ch:GetChildren()) do
				if t:IsA("Tool") and t:GetAttribute("IsEggTool") then n = n + 1 end
			end
		end
	end)
	return n
end

local function getPenCapacity()
	local lvl = tonumber(LocalPlayer:GetAttribute("PenUpgradeLevel")) or 0
	return math.max(1, 1 + math.floor(lvl))
end

local function blacklistEgg(id)
	local bl = getgenv().JfaEggBlacklist
	if type(bl) ~= "table" then bl = {} getgenv().JfaEggBlacklist = bl end
	if next(bl) and #bl > 100 then getgenv().JfaEggBlacklist = {}; bl = getgenv().JfaEggBlacklist end
	bl[id] = os.clock() + 60
end
local function unblacklistEgg(id) local bl = getgenv().JfaEggBlacklist if type(bl)=="table" then bl[id]=nil end end
local function isEggBlacklisted(id)
	if not id then return false end
	local bl = getgenv().JfaEggBlacklist
	if type(bl) ~= "table" then return false end
	local t = bl[id]
	if not t then return false end
	if os.clock() < t then return true end
	bl[id] = nil; return false
end

-- Watch carry-full notifications
do
	local function setFull(full)
		if full then getgenv().JfaCarryFull=true; getgenv().JfaCarryBaseline=countEggTools()
		else getgenv().JfaCarryFull=false end
	end
	local function checkGui(gui)
		local found = false
		local function scan(obj, depth)
			if depth > 5 or found then return end
			for _, c in ipairs(obj:GetChildren()) do
				if c:IsA("TextLabel") or c:IsA("TextButton") then
					if string.lower(tostring(c.Text or "")):find("capacity is full") then found = true end
				end
				scan(c, depth+1)
			end
		end
		scan(gui, 0); return found
	end
	p(function()
		for _ = 1, 10 do
			if not H() then return end
			local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
			local ui = pg and pg:FindFirstChild("UI")
			local notif = ui and ui:FindFirstChild("Notification")
			if notif then
				notif.ChildAdded:Connect(function()
					p(function() W(.3) if checkGui(notif) then setFull(true) end end)
				end)
				break
			end
			W(1)
		end
		while H() do
			W(1)
			pcall(function()
				if getgenv().JfaCarryFull then
					if countEggTools() < (tonumber(getgenv().JfaCarryBaseline) or 0) then setFull(false) end
				end
			end)
		end
	end)
end

-- Anti-platform stand
do
	p(function()
		while H() do
			W(0.25)
			pcall(function()
				local ch = LocalPlayer.Character
				local hum = ch and ch:FindFirstChildOfClass("Humanoid")
				local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
				if not hum or not hrp or hum.PlatformStand ~= true then return end
				if hum.Health <= 0 then return end
				hum.PlatformStand = false
				hum:ChangeState(Enum.HumanoidStateType.GettingUp)
				hrp.AssemblyLinearVelocity  = Vector3.zero
				hrp.AssemblyAngularVelocity = Vector3.zero
			end)
		end
	end)
end

-- ===================== BRAND & ICONS =====================
local BRAND = {
	Name    = "SpecreWare",
	Version = "3.17.0",
	Discord = "https://discord.gg/GdKxvcHzjS",
	Logo    = 84699118856259,
}
local ICON = {
	Bolt  = "lucide:zap",
	Crown = "lucide:crown",
	Star  = "lucide:star",
	Gear  = "lucide:settings",
	Map   = "lucide:map-pin",
	Gift  = "lucide:gift",
	Gem   = "lucide:gem",
	Heart = "lucide:heart",
	Spark = "lucide:sparkles",
	Key   = "lucide:key",
	Egg   = "lucide:egg",
	Bag   = "lucide:shopping-bag",
	Paw   = "lucide:paw-print",
	Up    = "lucide:arrow-up",
	Dna   = "lucide:dna",
	Flask = "lucide:flask-conical",
	TP    = "lucide:move",
	Fps   = "lucide:gauge",
}

-- ===================== REGISTER SPECTRE THEME =====================
pcall(function()
	if Library and Library.Themes then
		Library.Themes.Spectre = {
			Background = Color3.fromRGB(10,  13,  20),
			Panel      = Color3.fromRGB(14,  19,  30),
			Card       = Color3.fromRGB(20,  27,  42),
			Control    = Color3.fromRGB(28,  38,  58),
			Border     = Color3.fromRGB(35,  48,  72),
			Accent     = Color3.fromRGB(56, 189, 248),
			Accent2    = Color3.fromRGB(37,  99, 235),
			AccentSoft = Color3.fromRGB(10,  26,  48),
			Sheen      = Color3.fromRGB(186, 230, 253),
			Text       = Color3.fromRGB(240, 246, 255),
			SubText    = Color3.fromRGB(125, 142, 172),
			FX         = "snow",
		}
	end
end)

pcall(function()
	if Library and Library.AutoCheck then Library.AutoCheck.Skip = { TextClip = true } end
end)

-- ===================== MINIMIZE BIND PERSISTENCE =====================
local currentToggleKey = Enum.KeyCode.RightControl
pcall(function()
	if isfile and isfile("SpecreWare/JFAMenuKey.txt") and readfile then
		local saved = readfile("SpecreWare/JFAMenuKey.txt")
		if saved and #saved > 0 then
			local clean = saved:match("^%s*(.-)%s*$")
			local ok, k = pcall(function() return Enum.KeyCode[clean] end)
			if ok and k then currentToggleKey = k end
		end
	end
end)

local menuKeyConn = nil
local Window
local function updateMenuKeyListener()
	if menuKeyConn then pcall(function() menuKeyConn:Disconnect() end); menuKeyConn = nil end
	if currentToggleKey then
		menuKeyConn = UIS.InputBegan:Connect(function(input)
			if UIS:GetFocusedTextBox() then return end
			if input.KeyCode == currentToggleKey then
				if Window then
					pcall(function()
						if Window.Toggle then Window:Toggle()
						elseif Window.SetVisible then Window:SetVisible(not Window.Visible) end
					end)
				end
			end
		end)
	end
end

local function setMinimizeKey(k)
	if type(k) == "string" then
		local ok, ek = pcall(function() return Enum.KeyCode[k] end)
		k = ok and ek or nil
	end
	if typeof(k) == "EnumItem" and k.EnumType == Enum.KeyCode then
		currentToggleKey = k
		pcall(function()
			if Window then
				if Window.Cfg then Window.Cfg.ToggleKey = k end
				if Window.OpenBtn and Window.OpenBtn:FindFirstChild("OpenTooltip") then
					Window.OpenBtn.OpenTooltip.Text = "Open " .. BRAND.Name .. "  [" .. k.Name .. "]"
				end
			end
		end)
		updateMenuKeyListener()
		pcall(function()
			if makefolder and isfolder and not isfolder("SpecreWare") then makefolder("SpecreWare") end
			if writefile then writefile("SpecreWare/JFAMenuKey.txt", k.Name) end
		end)
	end
end

-- ===================== CREATE WINDOW =====================
Window = Library:CreateWindow({
	Title      = BRAND.Name .. " | Jump for Animals",
	Logo       = BRAND.Logo,
	ToggleKey  = currentToggleKey,
	Theme      = "Spectre",
	StagedLoad = false,
	AutoCheck  = { Skip = { TextClip = true } },
	Splash     = {
		Title     = "SpecreWare",
		Subtitle  = "JUMP FOR ANIMALS",
		Duration  = 2.0,
		Steps     = { "Checking remotes", "Loading features", "Preparing interface", "Ready!" },
		Logo      = BRAND.Logo,
		Skippable = true,
	},
})

if not Window then return warn("[SpecreWare | JFA] CreateWindow failed.") end

-- Disconnect internal keybind so ours takes full control
pcall(function()
	if Window.Conns and Window.Conns[1] then
		Window.Conns[1]:Disconnect()
		Window.Conns[1] = nil
	end
end)

Window.SetToggleKey = setMinimizeKey
updateMenuKeyListener()

-- Compatibility shims
function Window:ToggleHide() pcall(function() self:Toggle() end) end
function Window:Unload() pcall(function() self:Destroy() end) end
function Window:ChangeTheme(name)
	pcall(function()
		if self.SetTheme then self:SetTheme(name, true)
		elseif Library.SetTheme then Library:SetTheme(name) end
	end)
end
function Window:Save(name) end
function Window:Load(name) end

-- Notification helper
local function Notify(title, content, dur)
	pcall(function()
		if Window and Window.Notify then
			Window:Notify({ Title=title or BRAND.Name, Content=tostring(content or ""), Duration=dur or 3 })
		end
	end)
end

-- ===================== UI ADAPTER (Fluent API → SpectreUI) =====================
-- This adapter maps the original Fluent-style calls to SpectreUI calls
local function sanitizeAttr(name)
	if not name then return nil end
	local clean = tostring(name):gsub("[%s%c%p]","")
	return clean ~= "" and clean or nil
end

local Toggles = {}
local Options  = {}
Library.Toggles = Toggles
Library.Options  = Options

local function normOpts(o, cb)
	if type(o) == "string" then return {name=o, callback=cb, text=o} end
	o = o or {}
	return {
		name     = o.name or o.Name or o.title or o.Title or o.Text or o.text or "",
		desc     = o.desc or o.Desc or o.tooltip or o.Tooltip or o.description or o.Description or "",
		value    = (o.value ~= nil and o.value) or (o.default ~= nil and o.default) or (o.Default ~= nil and o.Default),
		callback = o.callback or o.Callback or o.changed or o.Changed or o.func or o.Func or cb,
		range    = o.range or o.Range or { o.min or o.Min or 0, o.max or o.Max or 100 },
		increment= o.increment or o.Increment or o.step or o.Step or o.rounding or o.Rounding or 1,
		suffix   = o.suffix or o.Suffix or "",
		options  = o.options or o.Options or o.values or o.Values or {},
		multiSelect = (o.multiSelect ~= nil and o.multiSelect) or (o.multi ~= nil and o.multi) or (o.Multi ~= nil and o.Multi) or false,
		placeholder = o.placeholder or o.Placeholder or o.PlaceholderText or "",
		flag     = o.flag or o.Flag or (o.name and sanitizeAttr(o.name)) or (o.Name and sanitizeAttr(o.Name)),
	}
end

local function wrapElement(rawObj, extraCb, flagName)
	local watchers = {}
	local wrapped = {
		_raw = rawObj,
		OnChanged = function(self, fn)
			if type(fn) == "function" then
				table.insert(watchers, fn)
				pcall(function() local val=self:Get() if val ~= nil then fn(val) end end)
			end
		end,
		_fire = function(self, v)
			for _, fn in ipairs(watchers) do pcall(fn, v) end
			if extraCb then pcall(extraCb, v) end
		end,
	}
	function wrapped:Get()
		if rawObj and rawObj.Get then
			local ok, res = pcall(function() return rawObj:Get() end)
			if ok and res ~= nil then return res end
		end
		return nil
	end
	function wrapped:Set(a, b)
		local v = (b == nil) and a or b
		pcall(function()
			if rawObj and rawObj.Set then rawObj:Set(v) else self:_fire(v) end
		end)
	end
	wrapped.SetValue = wrapped.Set
	wrapped.SetText  = wrapped.Set
	wrapped.SetDesc  = function(self, v)
		pcall(function()
			if rawObj and rawObj.Set then rawObj:Set(nil, tostring(v or "")) end
		end)
	end
	function wrapped:Refresh(list)
		pcall(function() if rawObj and rawObj.Refresh then rawObj:Refresh(list or {}) end end)
	end
	wrapped.SetValues = wrapped.Refresh
	wrapped.Select    = wrapped.Set
	return setmetatable(wrapped, {
		__index = function(_, k)
			if k == "Value" or k == "value" then return wrapped:Get() end
			if rawObj and rawObj[k] ~= nil then return rawObj[k] end
			return nil
		end,
		__newindex = function(_, k, v)
			if k == "Value" or k == "value" then wrapped:Set(v)
			else rawset(wrapped, k, v) end
		end,
	})
end

local function adaptSection(rawSec)
	local s = { _raw = rawSec }

	function s:CreateToggle(o)
		local n = normOpts(o)
		local flag = n.flag
		local initVal = n.value
		local cb = n.callback
		local wrapped
		local el = rawSec:CreateToggle({
			Name     = n.name ~= "" and n.name or "Toggle",
			Default  = initVal and true or false,
			Flag     = flag,
			Tooltip  = n.desc ~= "" and n.desc or nil,
			Callback = function(v)
				if wrapped then wrapped:_fire(v) elseif cb then pcall(cb, v) end
			end,
		})
		wrapped = wrapElement(el, cb, flag)
		if flag then Toggles[flag] = wrapped; Options[flag] = wrapped end
		return wrapped
	end
	s.AddToggle = function(self, name, info)
		info = info or {}
		return s:CreateToggle({
			name=info.Title or info.Text or name, desc=info.Description or info.Tooltip,
			value=info.Default, callback=info.Callback or info.Changed, flag=name,
		})
	end

	function s:CreateSlider(o)
		local n = normOpts(o)
		local flag = n.flag
		local mn = tonumber(n.range[1]) or 0
		local mx = tonumber(n.range[2]) or 100
		local def = tonumber(n.value) or mn
		local inc = tonumber(n.increment) or 1
		if inc <= 0 then inc = 1 end
		local cb = n.callback
		local wrapped
		local el = rawSec:CreateSlider({
			Name=n.name ~="" and n.name or "Slider", Min=mn, Max=mx,
			Increment=inc, Default=def, Suffix=n.suffix ~="" and n.suffix or nil,
			Flag=flag, Tooltip=n.desc ~="" and n.desc or nil,
			Callback=function(v) if wrapped then wrapped:_fire(v) elseif cb then pcall(cb,v) end end,
		})
		wrapped = wrapElement(el, cb, flag)
		if flag then Options[flag] = wrapped end
		return wrapped
	end
	s.AddSlider = function(self, name, info)
		info = info or {}
		return s:CreateSlider({
			name=info.Title or info.Text or name, desc=info.Description,
			range={info.Min or 0, info.Max or 100},
			increment=(info.Rounding or info.Step or 1),
			value=info.Default, suffix=info.Suffix,
			callback=info.Callback or info.Changed, flag=name,
		})
	end

	function s:CreateDropdown(o)
		local n = normOpts(o)
		local flag = n.flag
		local opts = n.options or {}
		local multi = n.multiSelect and true or false
		local initVal = n.value
		if multi then
			if type(initVal) == "string" then initVal = {initVal}
			elseif type(initVal) == "table" and not initVal[1] then
				local arr = {}
				for k, v in pairs(initVal) do if v == true then table.insert(arr, k) end end
				initVal = arr
			elseif type(initVal) ~= "table" then initVal = {} end
		else
			if type(initVal) == "table" then initVal = initVal[1] end
			if initVal == nil and #opts > 0 then initVal = opts[1] end
		end
		local cb = n.callback
		local wrapped
		local el = rawSec:CreateDropdown({
			Name=n.name ~="" and n.name or "Dropdown", Options=opts,
			Default=initVal, Multi=multi, Flag=flag,
			Tooltip=n.desc ~="" and n.desc or nil,
			Callback=function(v) if wrapped then wrapped:_fire(v) elseif cb then pcall(cb,v) end end,
		})
		wrapped = wrapElement(el, cb, flag)
		if flag then Options[flag] = wrapped end
		return wrapped
	end
	s.AddDropdown = function(self, name, info)
		info = info or {}
		return s:CreateDropdown({
			name=info.Title or info.Text or name, desc=info.Description,
			options=info.Values or info.options or {}, multiSelect=info.Multi,
			value=info.Default, callback=info.Callback or info.Changed, flag=name,
		})
	end

	function s:CreateButton(o, cb)
		local n = normOpts(o, cb)
		local fn = n.callback or function() end
		local el = rawSec:CreateButton({ Name=n.name ~="" and n.name or "Button", Callback=fn })
		return wrapElement(el, fn)
	end
	s.AddButton = function(self, name, info)
		return s:CreateButton({
			name=(type(info)=="table" and (info.Title or info.Text or info.name)) or name,
			callback=(type(info)=="function" and info) or (type(info)=="table" and (info.Func or info.Callback or info.callback)),
		})
	end

	function s:CreateInput(o)
		local n = normOpts(o)
		local flag = n.flag
		local currentText = n.value ~= nil and tostring(n.value) or ""
		local cb = n.callback
		local wrapped
		local el = rawSec:CreateTextbox({
			Name=n.name ~="" and n.name or "Input",
			Placeholder=n.placeholder ~="" and n.placeholder or "Enter text...",
			Default=currentText, Flag=flag,
			Callback=function(txt)
				currentText = tostring(txt or "")
				if wrapped then wrapped:_fire(currentText) elseif cb then pcall(cb, currentText) end
			end,
		})
		wrapped = wrapElement(el, cb, flag)
		wrapped.Get = function() return currentText end
		wrapped.Set = function(self, val)
			currentText = tostring(val or "")
			pcall(function() if el.Set then el:Set(currentText) end end)
			if wrapped then wrapped:_fire(currentText) end
		end
		if flag then Options[flag] = wrapped end
		return wrapped
	end
	s.AddInput = function(self, name, info)
		info = info or {}
		return s:CreateInput({
			name=info.Title or info.Text or name,
			placeholder=info.Placeholder, value=info.Default,
			callback=info.Callback or info.Changed, flag=name,
		})
	end

	function s:CreateKeybind(o, cb)
		local n = normOpts(o, cb)
		local flag = n.flag
		local defKey = n.value or "RightControl"
		if typeof(defKey) == "EnumItem" then defKey = defKey.Name end
		local fn = n.callback
		local changeFn = (type(o)=="table" and (o.Changed or o.changed)) or nil
		local wrapped
		local el = rawSec:CreateKeybind({
			Name=n.name ~="" and n.name or "Keybind", Default=defKey,
			Mode=(type(o)=="table" and (o.Mode or o.mode)) or "Toggle", Flag=flag,
			Changed=function(k) if wrapped then wrapped:_fire(k) end if changeFn then pcall(changeFn, k) end end,
			Callback=function(k) if fn then pcall(fn,k) end end,
		})
		wrapped = wrapElement(el, changeFn or fn, flag)
		if flag then Options[flag] = wrapped end
		return wrapped
	end
	s.AddKeyPicker = function(self, name, info)
		info = info or {}
		return s:CreateKeybind({
			name=info.Text or name, desc=info.Tooltip,
			value=info.Default, callback=info.Changed or info.Callback, flag=name,
		})
	end

	function s:CreateParagraph(o)
		local opts = o or {}
		local title = opts.Title or opts.title or opts.name or opts.Name or ""
		local content = opts.Content or opts.content or opts.desc or opts.text or ""
		local el = rawSec:CreateParagraph({ Title=tostring(title or ""), Content=tostring(content or "") })
		local wrapped = wrapElement(el)
		wrapped.Set = function(self, a, b)
			local v = (b==nil) and a or b
			pcall(function()
				if type(v)=="table" then
					if v.Title or v.Content then el:Set(v.Title, v.Content) end
				else el:Set(nil, tostring(v or "")) end
			end)
		end
		wrapped.SetContent = function(self, c)
			local val = (c==nil) and self or c
			pcall(function() el:Set(nil, tostring(val or "")) end)
		end
		wrapped.SetDesc = wrapped.SetContent
		return wrapped
	end
	s.AddParagraph = function(self, info)
		return s:CreateParagraph(info)
	end
	s.AddSection = function(self, name)
		pcall(function() rawSec:CreateLabel({ Text=tostring(name or "") }) end)
	end

	return s
end

-- Tab adapter
local function adaptTab(rawTab)
	local t = { _raw=rawTab }
	function t:CreateSection(name)
		local raw = rawTab:CreateSection(tostring(name or ""))
		return adaptSection(raw)
	end
	t.AddSection = t.CreateSection
	-- Passthrough common section methods at tab level
	local _sec = nil
	local function ensureSec(name)
		if not _sec then _sec = t:CreateSection(name or "") end
		return _sec
	end
	for _, method in ipairs({"CreateToggle","AddToggle","CreateSlider","AddSlider","CreateDropdown","AddDropdown","CreateButton","AddButton","CreateInput","AddInput","CreateKeybind","AddKeyPicker","CreateParagraph","AddParagraph","AddSection"}) do
		t[method] = function(self, ...)
			local sec = ensureSec("Features")
			return sec[method](sec, ...)
		end
	end
	return t
end

-- ===================== CREATE TABS =====================
local MainTab  = adaptTab(Window:CreateTab({ Name="Main",      Icon=ICON.Bolt  }))
local EggTab   = adaptTab(Window:CreateTab({ Name="Eggs",      Icon=ICON.Egg   }))
local PetTab   = adaptTab(Window:CreateTab({ Name="Pets",      Icon=ICON.Paw   }))
local EventTab = adaptTab(Window:CreateTab({ Name="Event",     Icon=ICON.Star  }))
local TpTab    = adaptTab(Window:CreateTab({ Name="Teleports", Icon=ICON.Map   }))
local MiscTab  = adaptTab(Window:CreateTab({ Name="Misc",      Icon=ICON.Gear  }))
local CfgTab   = adaptTab(Window:CreateTab({ Name="Config",    Icon=ICON.Key   }))

-- ===================== TOGGLE STATUS SYSTEM =====================
getgenv().JumpAnimalsToggleBtns = {}
getgenv().JumpAnimalsStatusText = getgenv().JumpAnimalsStatusText or {}
local statusDesc = {} -- flag -> base description string
local lastStatus = {} -- flag -> last rendered text
local showStatus = false
local J9 = {} -- toggle fn map

local function setStatus(flag, msg)
	if not flag then return end
	getgenv().JumpAnimalsStatusText[flag] = msg or ""
	local el = getgenv().JumpAnimalsToggleBtns[flag]
	if not el then return end
	local isErr = msg and msg:find("ERROR", 1, true) ~= nil or (flag=="autoMutation" or flag=="autoSellPets")
	local base = statusDesc[flag] or ""
	local text
	if isErr or (showStatus and msg and msg ~= "") then
		text = (msg and msg ~= "") and (base ~= "" and base.."\nStatus: "..msg or msg) or base
	else
		text = base
	end
	if lastStatus[flag] == text then return end
	lastStatus[flag] = text
	pcall(function() el:SetDesc(text) end)
end

local loadingSuppressed = true
task.delay(8, function() loadingSuppressed = false end)

local function makeToggle(sec, flag, title, desc, onFn, offFn, defaultOn)
	statusDesc[flag] = desc or ""
	local defaultVal = defaultOn == true
	local n = sec:CreateToggle({
		name = title, desc = desc or "", value = defaultVal,
		flag = sanitizeAttr(flag),
		callback = function(active)
			getgenv().JumpAnimalsEn[flag] = active
			if active then
				setStatus(flag, "Active")
				if onFn then
					p(function()
						local ok, err = xpcall(onFn, function(e) return tostring(e).."\n"..debug.traceback() end)
						if not ok then
							warn("[JFA] Toggle '"..flag.."' crashed: "..tostring(err))
							setStatus(flag, "ERROR - see console (F9)")
						end
					end)
				end
			else
				setStatus(flag, "")
				if offFn then
					p(function()
						local ok, err = xpcall(offFn, function(e) return tostring(e).."\n"..debug.traceback() end)
						if not ok then
							warn("[JFA] Toggle '"..flag.."' stop-err: "..tostring(err))
						end
					end)
				end
			end
		end,
	})
	getgenv().JumpAnimalsToggleBtns[flag] = n
	J9[flag] = function(val)
		if val ~= nil then pcall(function() n:Set(val) end)
		else pcall(function() n:Set(not (getgenv().JumpAnimalsEn[flag] or false)) end)
		end
	end
	-- Fire default on
	if defaultVal and not getgenv().JumpAnimalsEn[flag] then
		getgenv().JumpAnimalsEn[flag] = true
		setStatus(flag, "Active")
		if onFn then
			p(function()
				local ok, err = xpcall(onFn, function(e) return tostring(e).."\n"..debug.traceback() end)
				if not ok then
					warn("[JFA] Toggle '"..flag.."' default-crashed: "..tostring(err))
					setStatus(flag, "ERROR - see console (F9)")
				end
			end)
		end
	end
	return n
end

-- ===================== CONFIG STATE =====================
local J = {
	EquipBestInterval = 30, ClaimInterval = 60,
	EggRarities = {}, SmartEggRarities = {}, PlaceEggRarities = {},
	EggPriority = "Highest", FossilPriority = "Highest",
	PetRarities = {}, MutationRarities = {}, SelectedZone = nil,
	SkyEggSpecies = {}, SkyEggPriority = "Highest",
}

-- ========================= MAIN TAB =========================
local secStatus = MainTab:CreateSection("Status")
local statsLabel = secStatus:CreateParagraph({ Title="Stats", Content="Loading..." })
p(function()
	while H() do
		pcall(function()
			local cash = getCash()
			local jump = getJumpPower()
			local txt = "Cash: " .. (cash and "$"..formatNum(cash) or "?")
			if jump then txt = txt .. "  |  Jump: " .. formatNum(jump) end
			statsLabel:SetContent(txt)
		end)
		W(2)
	end
end)
secStatus:CreateParagraph({
	Title = "How to use",
	Content = "Main: train, pets, rewards.\nEggs tab: collect & hatch.\nEvent: Skylands trampoline.\nConfig: save/load your setup."
})

-- TRAINING
local secTrain = MainTab:CreateSection("Training")
makeToggle(secTrain, "autoTrain", "Auto Train 2x", "Squats to train and clicks 2x bonus targets.",
	function()
		local a = getgenv().JumpAnimalsEn
		if a.smartTrain or a.autoTrampoline or a.smartTrampoline then
			Notify("SpecreWare", "Turn off Smart Train / Auto Trampoline / Smart Trampoline first.", 4)
			a.autoTrain = false
			local btn = getgenv().JumpAnimalsToggleBtns.autoTrain
			if btn then pcall(function() btn:Set(false) end) end
			return
		end
		if not getgenv()._jfa_trainHome then
			pcall(function() local r=getRoot() if r then getgenv()._jfa_trainHome=r.CFrame end end)
		end
		while a.autoTrain and H() do
			local ok, err = pcall(function()
				local tpO = getTpOwner()
				if tpO and tpO ~= "train" then setStatus("autoTrain","Paused (trip in progress)...") W(1) return end
				local _, det, _ = getSquatZone()
				if not det then setStatus("autoTrain","No squat zone (claim a plot?)") W(3) return end
				local root = getRoot()
				if root and det:IsA("BasePart") then
					local target = det.CFrame + Vector3.new(0,3,0)
					if (root.Position - target.Position).Magnitude > 5 then
						waitForTp("train")
						tpTo(CFrame.new(target.Position))
						lockTp("train", 1)
						W(.15)
					end
				end
				local remote = findRemote("SquatTrainingRequest")
				if remote then
					pcall(remote.FireServer, remote, det)
					local squatting = LocalPlayer:GetAttribute("IsSquatting") == true
					if squatting and LocalPlayer:GetAttribute("SquatBonusAvailable") == true then
						local ver = math.floor(tonumber(LocalPlayer:GetAttribute("SquatBonusVersion")) or 0)
						local br = findRemote("SquatBonusRequest")
						if br then pcall(br.FireServer, br, ver) end
					end
					setStatus("autoTrain", squatting and "Training..." or "Requesting...")
				else
					setStatus("autoTrain","ERROR - SquatTrainingRequest missing"); W(3); return
				end
				W(.3)
			end)
			if not ok then setStatus("autoTrain","Hiccup, retrying") W(1) end
		end
		pcall(function() fireRemote("StopSquattingRequest") end)
		getgenv()._jfa_trainHome = nil
		setStatus("autoTrain","")
	end,
	function() pcall(function() fireRemote("StopSquattingRequest") end) getgenv()._jfa_trainHome = nil end
)

-- SMART TRAIN (uses egg rarities dropdown)
local allRarities = {}
local rarityRankAll = {}
for i, v in ipairs(RARITIES) do allRarities[v] = true; rarityRankAll[v] = i end
J.SmartEggRarities = allRarities

local secSmartTrain = MainTab:CreateSection("Smart Train Settings")
local smartRarityDrop = secSmartTrain:AddDropdown("SmartEggRarityDrop", {
	Title="Smart Train Egg Rarities", Values=RARITIES, Multi=true, Default={}
})
pcall(function() task.spawn(function() W(1) pcall(function() smartRarityDrop:Set(allRarities) end) end) end)
smartRarityDrop:OnChanged(function(a)
	local v = {}
	if type(a)=="table" then
		for k, val in pairs(a) do
			if val==true then v[k]=true
			elseif type(k)=="number" and type(val)=="string" and val~="" then v[val]=true end
		end
	end
	J.SmartEggRarities = v
end)

makeToggle(secTrain, "smartTrain", "Smart Train", "Steals eggs of chosen rarities, then trains.",
	function()
		local a = getgenv().JumpAnimalsEn
		if a.autoCollectEggs or a.autoSkyEggs or a.smartTrampoline then
			Notify("SpecreWare","Turn off Auto Collect Eggs / Skylands Eggs / Smart Trampoline first.",4)
			a.smartTrain=false
			local btn=getgenv().JumpAnimalsToggleBtns.smartTrain if btn then pcall(function() btn:Set(false) end) end
			return
		end
		-- Turn off conflicting trainers
		for _, flag in ipairs({"autoTrain","autoTrampoline","autoFossil"}) do
			if a[flag] then
				a[flag]=false
				local btn=getgenv().JumpAnimalsToggleBtns[flag]
				if btn then pcall(function() btn:Set(false) end) end
			end
		end
		if getgenv().JfaCarryFull then getgenv().JfaCarryFull=false end
		local function goSafe()
			local _, det, _ = getSquatZone()
			if det and det:IsA("BasePart") then
				local target = det.CFrame + Vector3.new(0,3,0)
				tpTo(CFrame.new(target.Position))
			else goToDetector() end
		end
		local squatActive = false
		while a.smartTrain and H() do
			local ok, err = pcall(function()
				-- Check carry
				local carried = tonumber(LocalPlayer:GetAttribute("CarriedEggCount")) or 0
				if carried > 0 then
					if squatActive then pcall(function() fireRemote("StopSquattingRequest") end) squatActive=false end
					if not acquireMove("smart", getMovePrio("smartSteal"), 6) then
						setStatus("smartTrain","Deliver blocked — movement busy"); W(.5); return
					end
					setStatus("smartTrain","Carrying egg — back to safe zone...")
					extendMove("smart", getMovePrio("smartSteal"), 5)
					goSafe()
					-- wait for egg delivered
					local t0=os.clock()
					while os.clock()-t0 < 12 do
						W(.2)
						if countEggTools() > 0 then continue end
						if (tonumber(LocalPlayer:GetAttribute("CarriedEggCount")) or 0)==0 and os.clock()-t0>1.5 then break end
					end
					releaseMove("smart")
					setStatus("smartTrain","Delivered — resuming")
					return
				end
				-- Scan eggs
				local eggs = {}
				local skipped = 0
				local curJump = getCurrentJump()
				pcall(function()
					for _, d in ipairs(workspace:GetDescendants()) do
						if d:IsA("ProximityPrompt") and d.Enabled and d.Name=="CollectPrompt" and not isEggBlacklisted(d) then
							local fn = d:GetFullName():lower()
							if (fn:find("eggprompt") or fn:find("dynamicegg") or fn:find("spawnedeggs")) and not fn:find("sell") and not fn:find("shop") then
								local model = d:FindFirstAncestorWhichIsA("Model")
								local rarity = model and model:GetAttribute("Rarity")
								local area = model and tostring(model:GetAttribute("AreaName") or "")
								if area == "" then
									local folder = d:FindFirstAncestor("Stages") and d:FindFirstAncestorWhichIsA("Folder")
									if folder and folder.Parent and folder.Parent.Name=="Stages" then area=folder.Name end
								end
								local req = getZoneReq(area)
								if req and curJump < req then
									skipped = skipped + 1
								elseif tableContains(J.SmartEggRarities, tostring(rarity or "")) or not rarity then
									table.insert(eggs, d)
								end
							end
						end
					end
				end)
				if #eggs > 0 then
					-- Sort by rarity
					local rankOf = function(e)
						local m=e.Parent and e.Parent:FindFirstAncestorWhichIsA("Model")
						return m and rarityRankAll[tostring(m:GetAttribute("Rarity") or "")] or 0
					end
					table.sort(eggs, function(a,b)
						local ra, rb = rankOf(a), rankOf(b)
						if ra ~= rb then return J.EggPriority=="Highest" and ra>rb or ra<rb end
						return false
					end)
					local target = eggs[1]
					if squatActive then
						pcall(function() fireRemote("StopSquattingRequest") end)
						squatActive = false
						local t0=os.clock()
						while LocalPlayer:GetAttribute("IsSquatting")==true and os.clock()-t0<2 do W(.1) end
					end
					if not acquireMove("smart", getMovePrio("smartSteal"), 5) then
						setStatus("smartTrain","Movement busy..."); W(.5); return
					end
					local model = target.Parent and target.Parent:FindFirstAncestorWhichIsA("Model")
					local rar = model and tostring(model:GetAttribute("Rarity") or "?") or "?"
					setStatus("smartTrain","Stealing egg ("..rar..")...")
					-- TP to egg
					local cf = nil
					if target.Parent:IsA("BasePart") then cf=target.Parent.CFrame
					elseif target.Parent:IsA("Model") then cf=target.Parent:GetPivot() end
					if cf then
						tpTo(cf + Vector3.new(0,3,0))
						lockTp("smart", 4.5)
						W(.08)
					end
					-- fire prompt
					local grabbed = false
					if target.Parent and target.Enabled then
						fireProxAsync(target)
						local t0=os.clock()
						while os.clock()-t0<3 do
							W(.05)
							if countEggTools()>0 or (tonumber(LocalPlayer:GetAttribute("CarriedEggCount")) or 0)>0 then
								grabbed=true; break
							end
							if not target.Parent or not target.Enabled then break end
						end
					end
					if grabbed then
						unblacklistEgg(target)
						setStatus("smartTrain","Stole it — back to safe zone...")
						goSafe()
					else
						blacklistEgg(target)
						setStatus("smartTrain","Grab failed — retrying")
						W(.5)
					end
					extendMove("smart", getMovePrio("smartSteal"), 5)
					-- wait for delivery
					local t0=os.clock()
					while os.clock()-t0<12 do
						W(.2)
						if (tonumber(LocalPlayer:GetAttribute("CarriedEggCount")) or 0)==0 and os.clock()-t0>1.5 then break end
					end
					releaseMove("smart")
					W(.1)
				else
					-- Train instead
					local _, det, _ = getSquatZone()
					if not det then setStatus("smartTrain","No squat zone (claim a plot?)") W(3) return end
					squatActive = LocalPlayer:GetAttribute("IsSquatting")==true
					if not squatActive then
						if not acquireMove("smart", getMovePrio("smartSquat"), 3) then
							setStatus("smartTrain","Movement busy..."); W(1); return
						end
						local root=getRoot()
						if root and det:IsA("BasePart") then
							local target = det.CFrame+Vector3.new(0,3,0)
							if (root.Position-target.Position).Magnitude>5 then
								waitForTp("smart")
								tpTo(CFrame.new(target.Position))
								lockTp("smart",1); W(.15)
							end
						end
						releaseMove("smart")
					end
					local sqRemote = findRemote("SquatTrainingRequest")
					if sqRemote then
						if not squatActive then pcall(sqRemote.FireServer, sqRemote, det) squatActive=LocalPlayer:GetAttribute("IsSquatting")==true end
						if squatActive and LocalPlayer:GetAttribute("SquatBonusAvailable")==true then
							local ver=math.floor(tonumber(LocalPlayer:GetAttribute("SquatBonusVersion")) or 0)
							local br=findRemote("SquatBonusRequest")
							if br then pcall(br.FireServer, br, ver) end
						end
					end
					setStatus("smartTrain","Training (no eggs".. (skipped>0 and ", "..skipped.." high-jump" or "") ..")")
					W(.3)
				end
			end)
			if not ok then
				warn("[JFA] smartTrain cycle error: "..tostring(err))
				setStatus("smartTrain","Hiccup, retrying")
				pcall(function() fireRemote("StopSquattingRequest") end)
				squatActive=false; W(1)
			end
		end
		pcall(function() fireRemote("StopSquattingRequest") end)
		setStatus("smartTrain","")
	end,
	function() pcall(function() fireRemote("StopSquattingRequest") end) end
)

-- PETS SECTION
local secPets = MainTab:CreateSection("Pets & Equipment")
makeToggle(secPets, "autoEquipBest", "Auto Equip Best", "Equips your strongest animals on a timer.",
	function()
		local a = getgenv().JumpAnimalsEn
		while a.autoEquipBest and H() do
			if not getgenv().JfaSellMutateBusy then
				if fireRemote("PetInventory","EquipBest") then setStatus("autoEquipBest","Equipped best")
				else setStatus("autoEquipBest","ERROR - PetInventory missing") end
				W(math.max(10, J.EquipBestInterval))
			else W(1) end
		end
		setStatus("autoEquipBest","")
	end
)

makeToggle(secPets, "autoBuyPetSlot", "Auto Buy Pet Slot", "Buys more pet slots when you can afford them.",
	function()
		local a = getgenv().JumpAnimalsEn
		while a.autoBuyPetSlot and H() do
			local cost, maxed = nil, false
			pcall(function()
				local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
				local ui = pg and pg:FindFirstChild("UI")
				local pages = ui and ui:FindFirstChild("Pages")
				local pets = pages and pages:FindFirstChild("Pets")
				local main = pets and pets:FindFirstChild("Main")
				local sf = main and main:FindFirstChild("ScrollingFrame")
				local slotBtn = sf and sf:FindFirstChild("+1Equip")
				if slotBtn then
					for _, c in ipairs(slotBtn:GetDescendants()) do
						if c:IsA("TextLabel") and c.Name=="Title" then
							local t = tostring(c.Text or "")
							if t:upper():find("MAX") then maxed=true
							else local n=parseNum(t) if n then cost=n; break end end
						end
					end
				end
			end)
			if maxed then setStatus("autoBuyPetSlot","Slots MAXED") W(30)
			elseif not cost then setStatus("autoBuyPetSlot","Price unknown, waiting...") W(10)
			else
				local cash = getCash() or 0
				if cash < cost then setStatus("autoBuyPetSlot","Need $"..formatNum(cost)) W(10)
				else
					setStatus("autoBuyPetSlot","Buying slot ($"..formatNum(cost)..")...")
					fireRemote("PetInventory","BuyEquipSlot")
					W(2)
					local newCash = getCash() or cash
					if newCash < cash then setStatus("autoBuyPetSlot","Slot bought!")
					else setStatus("autoBuyPetSlot","Buy failed, retrying...") end
					W(10)
				end
			end
		end
		setStatus("autoBuyPetSlot","")
	end
)

local secPetSell = MainTab:CreateSection("Sell Pets")
local petSellRarityDrop = secPetSell:AddDropdown("PetSellRarityDrop", {
	Title="Sell Pet Rarities", Values=RARITIES, Multi=true, Default={}
})
petSellRarityDrop:OnChanged(function(a)
	local v={} if type(a)=="table" then for k,val in pairs(a) do if val==true then v[k]=true elseif type(k)=="number" and type(val)=="string" and val~="" then v[val]=true end end end
	J.PetRarities=v
end)

makeToggle(secPetSell, "autoSellPets", "Auto Sell Pets", "Sells pets of the selected rarities.",
	function()
		local a = getgenv().JumpAnimalsEn
		while a.autoSellPets and H() do
			local rarities = J.PetRarities
			if not next(rarities) then setStatus("autoSellPets","Select rarities first!") W(5) else
				local sold = 0
				pcall(function()
					local snap = getgenv().JumpAnimalsSnapshot
					if type(snap)=="table" then
						for id, pet in pairs(snap) do
							if type(pet)=="table" and pet.Kind=="Pet" and pet.Rarity then
								if tableContains(rarities, tostring(pet.Rarity)) and not pet.LockedInMutationMachine then
									fireRemote("PetInventory","SellPet",id)
									sold=sold+1; W(.2)
								end
							end
						end
					end
				end)
				setStatus("autoSellPets", sold>0 and "Sold "..sold.." pets" or "No matching pets")
				W(5)
			end
		end
		setStatus("autoSellPets","")
	end
)

-- REWARDS
local secRewards = MainTab:CreateSection("Rewards & Upgrades")
makeToggle(secRewards, "autoBuyBarbell", "Auto Buy Barbell", "Buys barbell upgrades automatically.",
	function()
		local a = getgenv().JumpAnimalsEn
		while a.autoBuyBarbell and H() do
			local bought = false
			pcall(function()
				local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
				local ui = pg and pg:FindFirstChild("UI")
				local pages = ui and ui:FindFirstChild("Pages")
				local upg = pages and pages:FindFirstChild("Upgrades")
				local main = upg and upg:FindFirstChild("Main")
				local sf = main and main:FindFirstChild("ScrollingFrame")
				if sf then
					for _, btn in ipairs(sf:GetChildren()) do
						if (btn:IsA("TextButton") or btn:IsA("Frame")) and btn.Name:find("Barbell") then
							for _, c in ipairs(btn:GetDescendants()) do
								if c:IsA("TextLabel") and c.Name=="Price" then
									local price, isMax = parseNum(tostring(c.Text or ""))
									if isMax then break end
									if price then
										local cash = getCash() or 0
										if cash >= price then
											fireRemote("BuyUpgrade","Barbell")
											bought=true; W(.5)
										end
									end
									break
								end
							end
						end
					end
				end
			end)
			setStatus("autoBuyBarbell", bought and "Bought barbell!" or "Watching...")
			W(3)
		end
		setStatus("autoBuyBarbell","")
	end
)

makeToggle(secRewards, "autoBuyPlot", "Auto Buy Plot Upgrade", "Buys plot upgrades when you can afford them.",
	function()
		local a = getgenv().JumpAnimalsEn
		while a.autoBuyPlot and H() do
			local bought = false
			pcall(function()
				local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
				local ui = pg and pg:FindFirstChild("UI")
				local pages = ui and ui:FindFirstChild("Pages")
				local plot = pages and pages:FindFirstChild("Plot")
				local main = plot and plot:FindFirstChild("Main")
				local sf = main and main:FindFirstChild("ScrollingFrame")
				if sf then
					for _, btn in ipairs(sf:GetChildren()) do
						if btn:IsA("TextButton") or btn:IsA("Frame") then
							for _, c in ipairs(btn:GetDescendants()) do
								if c:IsA("TextLabel") and c.Name=="Price" then
									local price, isMax = parseNum(tostring(c.Text or ""))
									if isMax then break end
									if price then
										local cash = getCash() or 0
										if cash >= price then
											fireRemote("BuyPlotUpgrade")
											bought=true; W(.5)
										end
									end
									break
								end
							end
						end
					end
				end
			end)
			setStatus("autoBuyPlot", bought and "Bought upgrade!" or "Watching...")
			W(3)
		end
		setStatus("autoBuyPlot","")
	end
)

makeToggle(secRewards, "autoClaimRewards", "Auto Claim Rewards", "Claims daily/streak rewards automatically.",
	function()
		local a = getgenv().JumpAnimalsEn
		while a.autoClaimRewards and H() do
			pcall(function()
				local remote = findRemote("ClaimDailyReward")
				if remote then pcall(remote.FireServer, remote) end
				local streak = findRemote("ClaimStreakReward")
				if streak then pcall(streak.FireServer, streak) end
			end)
			setStatus("autoClaimRewards","Claimed rewards")
			W(J.ClaimInterval)
		end
		setStatus("autoClaimRewards","")
	end
)

-- ========================= EGGS TAB =========================
local secCollect = EggTab:CreateSection("Egg Collection")
local eggRarityDrop = secCollect:AddDropdown("EggRarityDrop", {
	Title="Collect Egg Rarities", Values=RARITIES, Multi=true, Default={}
})
eggRarityDrop:OnChanged(function(a)
	local v={} if type(a)=="table" then for k,val in pairs(a) do if val==true then v[k]=true elseif type(k)=="number" and type(val)=="string" and val~="" then v[val]=true end end end
	J.EggRarities=v
end)

local eggPriorityDrop = secCollect:AddDropdown("EggPriorityDrop", {
	Title="Egg Priority", Values={"Highest","Lowest"}, Multi=false, Default="Highest"
})
eggPriorityDrop:OnChanged(function(a) if a=="Highest" or a=="Lowest" then J.EggPriority=a end end)

makeToggle(secCollect, "autoCollectEggs", "Auto Collect Eggs", "Collects eggs of the selected rarities from the world.",
	function()
		local a = getgenv().JumpAnimalsEn
		if a.smartTrain or a.autoSkyEggs or a.smartTrampoline then
			Notify("SpecreWare","Turn off Smart Train / Skylands Eggs / Smart Trampoline first.",4)
			a.autoCollectEggs=false
			local btn=getgenv().JumpAnimalsToggleBtns.autoCollectEggs if btn then pcall(function() btn:Set(false) end) end
			return
		end
		while a.autoCollectEggs and H() do
			local ok, err = pcall(function()
				local curJump = getCurrentJump()
				local found = nil
				pcall(function()
					for _, d in ipairs(workspace:GetDescendants()) do
						if d:IsA("ProximityPrompt") and d.Enabled and d.Name=="CollectPrompt" and not isEggBlacklisted(d) then
							local fn = d:GetFullName():lower()
							if (fn:find("eggprompt") or fn:find("dynamicegg") or fn:find("spawnedeggs")) and not fn:find("sell") and not fn:find("shop") then
								local model = d:FindFirstAncestorWhichIsA("Model")
								local rarity = model and model:GetAttribute("Rarity")
								local area = model and tostring(model:GetAttribute("AreaName") or "")
								if area=="" then
									local folder=d:FindFirstAncestor("Stages") and d:FindFirstAncestorWhichIsA("Folder")
									if folder and folder.Parent and folder.Parent.Name=="Stages" then area=folder.Name end
								end
								local req = getZoneReq(area)
								if (not req or curJump >= req) and (tableContains(J.EggRarities, tostring(rarity or "")) or not next(J.EggRarities)) then
									found = d; break
								end
							end
						end
					end
				end)
				if found then
					setStatus("autoCollectEggs","Found egg — teleporting...")
					tpToObj(found, Vector3.new(0,3,0), "collect")
					W(.1)
					local startEggs = countEggTools()
					fireProxAsync(found)
					local t0=os.clock()
					while os.clock()-t0<3 do
						W(.05)
						if countEggTools()>startEggs then break end
						if not found.Parent or not found.Enabled then break end
					end
					if countEggTools()>startEggs then unblacklistEgg(found) setStatus("autoCollectEggs","Collected!")
					else blacklistEgg(found) setStatus("autoCollectEggs","Grab failed, retrying...") end
				else
					setStatus("autoCollectEggs","Scanning for eggs..."); W(1)
				end
			end)
			if not ok then setStatus("autoCollectEggs","Hiccup, retrying") W(1) end
		end
		setStatus("autoCollectEggs","")
	end
)

local secPlaceEgg = EggTab:CreateSection("Place Eggs")
local placeEggSpeciesDrop = secPlaceEgg:AddDropdown("PlaceEggRarityDrop", {
	Title="Place Egg Species/Rarity",
	Values={"Fossil","Griffin","Dark Unicorn","Sky Wyvern","Sky Ray","Aether Serpent","Dark Dragon","Sky Turtle","Cloud Leviathan"},
	Multi=true, Default={}
})
placeEggSpeciesDrop:OnChanged(function(a)
	local v={} if type(a)=="table" then for k,val in pairs(a) do if val==true then v[k]=true elseif type(k)=="number" and type(val)=="string" and val~="" then v[val]=true end end end
	J.PlaceEggRarities=v
end)

makeToggle(secPlaceEgg, "autoPlaceEgg", "Auto Place Egg", "Places eggs from your backpack onto your plot.",
	function()
		local a = getgenv().JumpAnimalsEn
		local slotIdx = 0
		while a.autoPlaceEgg and H() do
			local ok, err = pcall(function()
				-- Hatch ready eggs first
				local snap = getgenv().JumpAnimalsSnapshot
				if type(snap)=="table" then
					local serverTime = 0
					pcall(function() serverTime=workspace:GetServerTimeNow() end)
					for id, pet in pairs(snap) do
						if type(pet)=="table" and pet.Kind=="Egg" and pet.Id then
							local hatchAt = tonumber(pet.HatchAt) or 0
							if hatchAt>0 and hatchAt<=serverTime then
								fireRemote("PetInventory","EggAction",pet.Id)
								W(.4)
							end
						end
					end
				end
				-- Place egg
				local tools = {}
				pcall(function()
					for _,t in ipairs(LocalPlayer.Backpack:GetChildren()) do
						if t:IsA("Tool") and t:GetAttribute("IsEggTool") then table.insert(tools,t) end
					end
					local ch=LocalPlayer.Character
					if ch then for _,t in ipairs(ch:GetChildren()) do if t:IsA("Tool") and t:GetAttribute("IsEggTool") then table.insert(tools,t) end end end
				end)
				if #tools==0 then setStatus("autoPlaceEgg","No eggs in backpack") W(5) return end
				local chosen=nil
				if next(J.PlaceEggRarities) then
					for _,t in ipairs(tools) do
						local r=tostring(t:GetAttribute("Rarity") or "")
						local n=tostring(t:GetAttribute("EggName") or "")
						if tableContains(J.PlaceEggRarities,r) or tableContains(J.PlaceEggRarities,n) then chosen=t; break end
					end
					if not chosen then setStatus("autoPlaceEgg","No matching egg in backpack") W(3) return end
				else chosen=tools[1] end
				local eggId=chosen:GetAttribute("EggId")
				if not eggId then setStatus("autoPlaceEgg","No EggId attr") W(3) return end
				pcall(function()
					local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
					if hum then hum:EquipTool(chosen) end
				end)
				W(.5)
				-- Find spot
				local spot=nil
				pcall(function()
					local plot=getPlot()
					local det=plot and plot:FindFirstChild("Detector")
					local detPart=det and det:IsA("BasePart") and det or nil
					if not detPart then return end
					local yPos=detPart.Position.Y + detPart.Size.Y/2 + 1
					local halfX=math.min(detPart.Size.X/2-3, 24)
					local halfZ=math.min(detPart.Size.Z/2-3, 24)
					local s=slotIdx%25+1
					local sx=(s-1)%5-2; local sz=math.floor((s-1)/5)-2
					spot=detPart.Position + Vector3.new(sx*(halfX/2), 0, sz*(halfZ/2))
					spot=Vector3.new(spot.X, yPos, spot.Z)
				end)
				if not spot then setStatus("autoPlaceEgg","No spot found") W(3) return end
				fireRemote("PlaceEggRequest", tostring(eggId), spot)
				slotIdx=slotIdx+1; W(1.5)
				if chosen.Parent then setStatus("autoPlaceEgg","Place refused, retrying...")
				else setStatus("autoPlaceEgg","Placed egg!") end
			end)
			if not ok then setStatus("autoPlaceEgg","Hiccup, retrying") W(1) end
			W(1)
		end
		setStatus("autoPlaceEgg","")
	end
)

makeToggle(secPlaceEgg, "autoIncubator", "Auto Incubator", "Uses incubator on eggs in your inventory.",
	function()
		local a = getgenv().JumpAnimalsEn
		while a.autoIncubator and H() do
			local count = 0
			pcall(function()
				local snap = getgenv().JumpAnimalsSnapshot
				if type(snap)=="table" then
					local serverTime = 0
					pcall(function() serverTime=workspace:GetServerTimeNow() end)
					for id, pet in pairs(snap) do
						if type(pet)=="table" and pet.Kind=="Egg" and pet.Id then
							local hatchAt = tonumber(pet.HatchAt) or 0
							if hatchAt>0 and hatchAt<=serverTime then
								fireRemote("PetInventory","EggAction",pet.Id)
								count=count+1; W(.4)
							end
						end
					end
				end
			end)
			setStatus("autoIncubator", count>0 and "Hatched "..count.." eggs" or "Watching eggs...")
			W(3)
		end
		setStatus("autoIncubator","")
	end
)

-- ========================= PETS TAB =========================
local secMutation = PetTab:CreateSection("Mutation")
local mutationRarityDrop = secMutation:AddDropdown("MutationRarityDrop", {
	Title="Mutation Rarities", Values=RARITIES, Multi=true, Default={}
})
mutationRarityDrop:OnChanged(function(a)
	local v={} if type(a)=="table" then for k,val in pairs(a) do if val==true then v[k]=true elseif type(k)=="number" and type(val)=="string" and val~="" then v[val]=true end end end
	J.MutationRarities=v
end)

makeToggle(secMutation, "autoMutation", "Auto Mutation", "Automatically craft mutations when animals are ready.",
	function()
		local a = getgenv().JumpAnimalsEn
		while a.autoMutation and H() do
			local ok, err = pcall(function()
				local ready = LocalPlayer:GetAttribute("MutationCraftReady")==true
				if ready then
					setStatus("autoMutation","Crafting mutation...")
					fireRemote("PetInventory","CraftMutation")
					W(2)
					setStatus("autoMutation","Crafted!")
				else
					local storedCount = tonumber(LocalPlayer:GetAttribute("MutationStoredCount")) or 0
					local craftName = tostring(LocalPlayer:GetAttribute("MutationCraftAnimalName") or "")
					if storedCount>0 and craftName~="" then
						-- Check inventory
						local petsOfType = 0
						pcall(function()
							local snap=getgenv().JumpAnimalsSnapshot
							if type(snap)=="table" then
								for _,pet in pairs(snap) do
									if type(pet)=="table" and pet.Kind=="Pet" and pet.Name==craftName and not pet.LockedInMutationMachine then
										petsOfType=petsOfType+1
									end
								end
							end
						end)
						if storedCount+petsOfType>=5 then
							setStatus("autoMutation","Adding pets to mutation machine...")
							fireRemote("PetInventory","LockInMutationMachine",craftName)
							W(2)
						else
							setStatus("autoMutation","Need "..craftName.." ("..storedCount.."+"..petsOfType.."/5)")
						end
					else
						setStatus("autoMutation","Waiting for mutation readiness...")
					end
				end
			end)
			if not ok then setStatus("autoMutation","Hiccup: "..tostring(err)) end
			W(3)
		end
		setStatus("autoMutation","")
	end
)

-- ========================= EVENT TAB =========================
local secTramp = EventTab:CreateSection("Skylands Trampoline")

local function inSkylands()
	local root=getRoot()
	return root and root.Position.Z > 1500
end
local function getSkylandsPortal()
	local res=nil
	pcall(function()
		local map=workspace:FindFirstChild("Map")
		local portal=map and map:FindFirstChild("SkylandsPortal")
		local ring=portal and portal:FindFirstChild("Ring")
		local det=ring and ring:FindFirstChild("Detector")
		res=det and det:IsA("BasePart") and det or (portal and portal:FindFirstChild("PortalCore"))
	end)
	return res
end
local function enterSkylands(owner)
	if inSkylands() then return true end
	local portal=getSkylandsPortal()
	if not portal then return false end
	pcall(function()
		local root=getRoot()
		if root and root.Position.Z<1500 and (root.Position-portal.Position).Magnitude>30 then
			getgenv()._jfa_mainWorldSpot=root.CFrame
		end
	end)
	setStatus(owner or "autoTrampoline","Entering Skylands via gate…")
	waitForTp("trampoline")
	tpTo(CFrame.new(portal.Position+Vector3.new(0,6,0)))
	lockTp("trampoline",2)
	local t0=os.clock()
	while H() and os.clock()-t0<8 do
		if inSkylands() then return true end
		W(.25)
	end
	return inSkylands()
end
local function getNearestTrampoline()
	local nearest=nil
	pcall(function()
		local root=getRoot()
		local pos=root and root.Position
		local event=workspace:FindFirstChild("Event_SkyIslands")
		local map=event and event:FindFirstChild("Map")
		local spawn=map and map:FindFirstChild("Spawn")
		local rings=spawn and spawn:FindFirstChild("TrainingRings")
		if not rings then return end
		local others={}
		for _,pl in ipairs(Players:GetPlayers()) do
			if pl~=LocalPlayer then
				local hrp=pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
				if hrp then others[#others+1]=hrp.Position end
			end
		end
		local bestDist=math.huge
		for _,ring in ipairs(rings:GetChildren()) do
			if ring:IsA("Model") then
				local det=ring:FindFirstChild("Detector")
				if det and det:IsA("BasePart") then
					local dist=pos and (det.Position-pos).Magnitude or math.huge
					local occupied=false
					for _,op in ipairs(others) do
						local xz=Vector3.new(op.X-det.Position.X,0,op.Z-det.Position.Z).Magnitude
						if xz<10 and op.Y-det.Position.Y>-5 and op.Y-det.Position.Y<50 then occupied=true; break end
					end
					if not occupied and dist<bestDist then bestDist=dist; nearest=det end
				end
			end
		end
	end)
	return nearest
end

local function getTrampolinePower()
	local ok, v = pcall(function()
		local tp=LocalPlayer:FindFirstChild("TrampolinePower")
		return tp and tonumber(tp.Value) or nil
	end)
	return ok and v or nil
end

makeToggle(secTramp, "autoTrampoline", "Auto Trampoline", "Bounces Skylands training trampolines for TrampolinePower.",
	function()
		local a = getgenv().JumpAnimalsEn
		if a.autoTrain or a.smartTrain or a.autoSkyEggs or a.smartTrampoline then
			Notify("SpecreWare","Turn off Auto Train / Smart Train / Skylands Eggs / Smart Trampoline first.",4)
			a.autoTrampoline=false
			local btn=getgenv().JumpAnimalsToggleBtns.autoTrampoline if btn then pcall(function() btn:Set(false) end) end
			return
		end
		if not getgenv()._jfa_trampHome then
			pcall(function() local r=getRoot() if r then getgenv()._jfa_trampHome=r.CFrame end end)
		end
		local lastTP = getTrampolinePower() or 0
		local lastT = os.clock()
		local curTramp = nil
		while a.autoTrampoline and H() do
			local ok, err = pcall(function()
				local tpO = getTpOwner()
				if tpO and tpO~="trampoline" then setStatus("autoTrampoline","Paused (trip in progress)...") W(1) return end
				if not enterSkylands("autoTrampoline") then setStatus("autoTrampoline","Skylands gate unreachable") W(3) return end
				if curTramp==nil or curTramp.Parent==nil then curTramp=getNearestTrampoline() end
				if not curTramp then setStatus("autoTrampoline","No trampoline found (Skylands open?)") W(3) return end
				local root=getRoot()
				if root and curTramp:IsA("BasePart") then
					local target=Vector3.new(curTramp.Position.X, curTramp.Position.Y+1.5, curTramp.Position.Z)
					local xzDist=Vector3.new(root.Position.X-target.X,0,root.Position.Z-target.Z).Magnitude
					if a.autoTrampoline and xzDist>6 then
						waitForTp("trampoline")
						tpTo(CFrame.new(target))
						lockTp("trampoline",1); W(.15)
					end
					local now=os.clock()
					local newTP=getTrampolinePower() or 0
					if now-lastT>=5 then
						local rate=(newTP-lastTP)/math.max(now-lastT,.01)
						setStatus("autoTrampoline",string.format("Bouncing… TP %s (+%d/s)",formatNum(newTP),math.floor(rate)))
						lastTP,lastT=newTP,now
					end
				end
				if LocalPlayer:GetAttribute("SquatBonusAvailable")==true then
					local ver=math.floor(tonumber(LocalPlayer:GetAttribute("SquatBonusVersion")) or 0)
					local br=findRemote("SquatBonusRequest")
					if br then pcall(br.FireServer, br, ver) end
				end
				W(.1)
			end)
			if not ok then setStatus("autoTrampoline","Hiccup, retrying") W(1) end
		end
		-- Return to main world
		pcall(function()
			if inSkylands() then
				local home = getgenv()._jfa_trampHome or getgenv()._jfa_mainWorldSpot
				if home and home.Position.Z < 1500 then
					waitForTp("trampoline")
					tpTo(home)
					lockTp("trampoline",1)
				end
			end
		end)
		setStatus("autoTrampoline","")
	end
)

-- Skylands Eggs
makeToggle(secTramp, "autoSkyEggs", "Auto Skylands Eggs", "Collects Skylands eggs automatically.",
	function()
		local a = getgenv().JumpAnimalsEn
		if a.smartTrain or a.autoCollectEggs or a.smartTrampoline then
			Notify("SpecreWare","Turn off Smart Train / Auto Collect Eggs / Smart Trampoline first.",4)
			a.autoSkyEggs=false
			local btn=getgenv().JumpAnimalsToggleBtns.autoSkyEggs if btn then pcall(function() btn:Set(false) end) end
			return
		end
		while a.autoSkyEggs and H() do
			local ok, err = pcall(function()
				if not enterSkylands("autoSkyEggs") then setStatus("autoSkyEggs","Cannot enter Skylands") W(3) return end
				local found=nil
				pcall(function()
					for _,d in ipairs(workspace:GetDescendants()) do
						if d:IsA("ProximityPrompt") and d.Enabled and d.Name=="SkylandsEggPrompt" and not isEggBlacklisted(d) then
							found=d; break
						end
					end
				end)
				if found then
					setStatus("autoSkyEggs","Found sky egg!")
					tpToObj(found, Vector3.new(0,3,0), "skyEggs")
					W(.08)
					local before=tonumber(LocalPlayer:GetAttribute("SkylandsEggsCollected")) or 0
					fireProxAsync(found)
					local t0=os.clock()
					while os.clock()-t0<9 do
						W(.05)
						if (tonumber(LocalPlayer:GetAttribute("SkylandsEggsCollected")) or 0)>before then break end
						if not found.Parent or not found.Enabled then break end
					end
					if (tonumber(LocalPlayer:GetAttribute("SkylandsEggsCollected")) or 0)>before then
						unblacklistEgg(found); setStatus("autoSkyEggs","Collected sky egg!")
					else blacklistEgg(found); setStatus("autoSkyEggs","Grab failed") end
				else setStatus("autoSkyEggs","No sky eggs found") W(2) end
			end)
			if not ok then setStatus("autoSkyEggs","Hiccup, retrying") W(1) end
		end
		setStatus("autoSkyEggs","")
	end
)

-- Fossil
local secFossil = EventTab:CreateSection("Fossil")
local fossilPriorityDrop = secFossil:AddDropdown("FossilPriorityDrop", {
	Title="Fossil Priority", Values={"Highest","Lowest"}, Multi=false, Default="Highest"
})
fossilPriorityDrop:OnChanged(function(a) if a=="Highest" or a=="Lowest" then J.FossilPriority=a end end)

makeToggle(secFossil, "autoFossil", "Auto Fossil", "Digs and cleans fossils automatically.",
	function()
		local a = getgenv().JumpAnimalsEn
		while a.autoFossil and H() do
			local ok, err = pcall(function()
				-- Find dig spots
				local digSpot=nil
				pcall(function()
					local cs=game:GetService("CollectionService")
					for _,f in ipairs(cs:GetTagged("FossilSpot")) do
						if f:GetAttribute("Available")==true then digSpot=f; break end
					end
				end)
				if digSpot then
					setStatus("autoFossil","Digging fossil...")
					tpToObj(digSpot, Vector3.new(0,3,0), "fossil")
					W(.1)
					local digRemote=findRemote("FossilDig") or findRemote("Fossil")
					if digRemote then
						pcall(digRemote.FireServer, digRemote, "Dig")
						W(2)
					end
				end
				-- Clean
				local cleaning = LocalPlayer:GetAttribute("FossilCleaningOpen")==true
				if cleaning then
					local cleanRemote=findRemote("Fossil")
					if cleanRemote then
						pcall(cleanRemote.FireServer, cleanRemote, "Finish")
						W(1)
					end
				end
				local pendingFossil = tostring(LocalPlayer:GetAttribute("PendingFossilName") or "")
				if pendingFossil ~= "" then
					-- TP to cleaning table
					local tableSpot=nil
					pcall(function()
						local map=workspace:FindFirstChild("Map")
						local fossil=map and map:FindFirstChild("Fossil")
						local table_=fossil and fossil:FindFirstChild("Table")
						tableSpot=table_ and table_:FindFirstChild("Detector")
					end)
					if tableSpot then
						tpToObj(tableSpot, Vector3.new(0,3,0), "fossil")
						W(.1)
					end
					local cleanRemote=findRemote("Fossil")
					if cleanRemote then
						for _=1,3 do
							pcall(cleanRemote.FireServer, cleanRemote, "Finish")
							W(.5)
							if tostring(LocalPlayer:GetAttribute("PendingFossilName") or "")=="" then break end
						end
					end
					setStatus("autoFossil","Cleaned fossil!")
				end
				W(1)
			end)
			if not ok then setStatus("autoFossil","Hiccup: "..tostring(err)) W(1) end
		end
		setStatus("autoFossil","")
	end
)

makeToggle(secFossil, "autoBuyFossilEgg", "Auto Buy Fossil Egg", "Buys fossil eggs when you have enough cash.",
	function()
		local a = getgenv().JumpAnimalsEn
		while a.autoBuyFossilEgg and H() do
			local ok, err = pcall(function()
				local shopRemote=findRemote("BuyFossilEgg")
				if shopRemote then
					local cash=getCash() or 0
					if cash>=1000 then
						pcall(shopRemote.FireServer, shopRemote)
						setStatus("autoBuyFossilEgg","Bought fossil egg!")
					else setStatus("autoBuyFossilEgg","Saving cash... $"..formatNum(cash).."/$1000") end
				else setStatus("autoBuyFossilEgg","Shop remote not found") end
			end)
			if not ok then setStatus("autoBuyFossilEgg","Hiccup: "..tostring(err)) end
			W(5)
		end
		setStatus("autoBuyFossilEgg","")
	end
)

-- ========================= TELEPORTS TAB =========================
local secTeleport = TpTab:CreateSection("Zone Teleport")

local ZONE_LIST = {"Meadow","Coral Reef","Winter","Desert","Crystal Mines","Jungle","Mystic Isles","Prehistoric","Celestial Heights","Savannah","The Underworld"}
local zoneDrop = secTeleport:AddDropdown("ZoneDrop", {
	Title="Select Zone", Values=ZONE_LIST, Multi=false, Default=ZONE_LIST[1]
})
zoneDrop:OnChanged(function(a) if a then J.SelectedZone=tostring(a) end end)

secTeleport:AddButton("TeleportToZoneBtn", {
	Title="Teleport to Zone",
	Callback=function()
		if not J.SelectedZone then Notify("SpecreWare","Pick a zone first!",3) return end
		local found=nil
		pcall(function()
			local map=workspace:FindFirstChild("Map")
			local stages=map and map:FindFirstChild("Stages")
			local stage=stages and stages:FindFirstChild(J.SelectedZone)
			if stage then
				if stage:IsA("BasePart") then found=stage
				elseif stage:IsA("Model") then found=stage
				else found=stage:FindFirstChildWhichIsA("BasePart", true) end
			end
		end)
		if not found then Notify("SpecreWare","Zone not found: "..J.SelectedZone,3) return end
		tpToObj(found, Vector3.new(0,5,0), "tp")
		Notify("SpecreWare","Teleported to "..J.SelectedZone,2)
	end
})

secTeleport:AddButton("TeleportToPlotBtn", {
	Title="Teleport to My Plot",
	Callback=function()
		local cf=getDetectorCF()
		if cf then tpTo(cf) Notify("SpecreWare","Teleported to your plot!",2)
		else Notify("SpecreWare","No plot found (claim one first)!",3) end
	end
})

secTeleport:AddButton("TeleportToSellBtn", {
	Title="Teleport to Sell Area",
	Callback=function()
		local det=getSellZone()
		if det then tpToObj(det, Vector3.new(0,3,0), "tp") Notify("SpecreWare","Teleported to Sell Area!",2)
		else Notify("SpecreWare","Sell zone not found!",3) end
	end
})

-- ========================= MISC TAB =========================
local secPerf = MiscTab:CreateSection("Performance & Idle")
makeToggle(secPerf, "moreFps", "More FPS", "Removes graphics effects for more FPS. Rejoin to undo.",
	function()
		local a = getgenv().JumpAnimalsEn
		if getgenv()._jfa_fpsDone then setStatus("moreFps","Already applied (rejoin to undo)") return end
		getgenv()._jfa_fpsDone = true
		setStatus("moreFps","Applying FPS boost...")
		task.spawn(function()
			pcall(function()
				local lt = game:GetService("Lighting")
				pcall(function() lt.GlobalShadows=false; lt.FogEnd=9999; lt.FogStart=9998 end)
				pcall(function()
					local atm=lt:FindFirstChildOfClass("Atmosphere")
					if atm then atm.Density=0; atm.Haze=0; atm.Glare=0 end
				end)
				for _,fx in ipairs({"BloomEffect","SunRaysEffect","DepthOfFieldEffect"}) do
					pcall(function() local e=lt:FindFirstChildOfClass(fx) if e then e:Destroy() end end)
				end
				W(.05)
				local chars={}
				for _,pl in ipairs(Players:GetPlayers()) do if pl.Character then chars[pl.Character]=true end end
				local n=0
				for _,d in ipairs(workspace:GetDescendants()) do
					if not H() then break end
					local function isChar(inst)
						local p=inst.Parent
						while p and p~=workspace do if chars[p] then return true end p=p.Parent end
						return false
					end
					pcall(function()
						if isChar(d) then return end
						local cn=d.ClassName
						if d:IsA("BasePart") then d.Material=Enum.Material.SmoothPlastic; d.CastShadow=false
						elseif cn=="Texture" or cn=="Decal" then d.Transparency=1
						elseif cn=="ParticleEmitter" or cn=="Beam" or cn=="Trail" then d.Enabled=false
						elseif cn=="SurfaceAppearance" then d:Destroy()
						elseif cn=="PointLight" or cn=="SpotLight" or cn=="SurfaceLight" then d.Enabled=false end
					end)
					n=n+1; if n%100==0 then W() end
				end
			end)
			setStatus("moreFps","FPS boost applied (rejoin to undo)")
		end)
	end
)

makeToggle(secPerf, "antiAfk", "Anti AFK", "Keeps you online while AFK.", nil, nil, true)

local secSettings = MiscTab:CreateSection("Minimize Bind")
secSettings:CreateKeybind({
	name = "Minimize Bind",
	desc = "Key to show/hide the SpecreWare menu.",
	value = currentToggleKey.Name,
	mode  = "Toggle",
	Changed = function(k)
		if k then
			setMinimizeKey(k)
			Notify("SpecreWare","Minimize key changed to: "..tostring(k),3)
		end
	end,
})

-- ========================= CONFIG TAB =========================
local CFG_FOLDER = "JumpAnimalsSpecreWare"
local CFG_AUTOLOAD = CFG_FOLDER .. "/_autoload.txt"
pcall(function() if makefolder and isfolder and not isfolder(CFG_FOLDER) then makefolder(CFG_FOLDER) end end)

local function notifyCfg(msg) Notify("SpecreWare | Config", msg, 3) end
local currentCfgName = "Default"

local secCfg = CfgTab:CreateSection("Config Files")
local cfgNameInput = secCfg:CreateInput({
	name="Config Name", value="Default", placeholder="e.g. AFK Setup",
	flag="ConfigNameInput",
	callback=function(v) currentCfgName=tostring(v or "Default") end,
})
local savedCfgDrop = secCfg:CreateDropdown({
	name="Saved Configs", options={}, multiSelect=false, flag="SavedConfigsDrop",
	callback=function(a)
		if a and tostring(a)~="" then
			currentCfgName=tostring(a)
			pcall(function() cfgNameInput:Set(currentCfgName) end)
		end
	end,
})

local function refreshCfgList()
	if type(listfiles)~="function" then return end
	local ok, files=pcall(listfiles, CFG_FOLDER)
	if ok and type(files)=="table" then
		local names={}
		for _,f in ipairs(files) do
			local n=tostring(f):match("([^/\\]+)%.json$")
			if n then table.insert(names,n) end
		end
		table.sort(names)
		pcall(function() savedCfgDrop:Refresh(names) end)
	end
end

local function cfgPath(name)
	if not name or name=="" then return nil end
	return CFG_FOLDER.."/"..name..".json"
end

local function buildCfgTable()
	return {
		version  = tostring(getgenv().JumpAnimalsVersion or "unknown"),
		toggles  = getgenv().JumpAnimalsEn,
		config   = {
			EquipBestInterval=J.EquipBestInterval, ClaimInterval=J.ClaimInterval,
			EggRarities=J.EggRarities, SmartEggRarities=J.SmartEggRarities,
			PlaceEggRarities=J.PlaceEggRarities, EggPriority=J.EggPriority,
			FossilPriority=J.FossilPriority, PetRarities=J.PetRarities,
			MutationRarities=J.MutationRarities, SelectedZone=J.SelectedZone,
			SkyEggSpecies=J.SkyEggSpecies, SkyEggPriority=J.SkyEggPriority,
		}
	}
end

local function normRarityTable(tbl, validList)
	local result={}
	if type(tbl)~="table" then return result end
	for k,v in pairs(tbl) do
		local item=nil
		if type(k)=="string" and v==true then item=k
		elseif type(k)=="number" and type(v)=="string" and v~="" then item=v end
		if item then
			if not validList then
				for _,r in ipairs(RARITIES) do if r==item then result[item]=true break end end
			else
				for _,r in ipairs(validList) do if r==item then result[item]=true break end end
			end
		end
	end
	return result
end

local function applyCfg(data)
	if type(data)~="table" then return false end
	if type(data.config)=="table" then
		local c=data.config
		if c.EquipBestInterval~=nil then J.EquipBestInterval=tonumber(c.EquipBestInterval) or J.EquipBestInterval end
		if c.ClaimInterval~=nil    then J.ClaimInterval=tonumber(c.ClaimInterval) or J.ClaimInterval end
		if c.EggRarities~=nil      then J.EggRarities=normRarityTable(c.EggRarities) end
		if c.SmartEggRarities~=nil then J.SmartEggRarities=normRarityTable(c.SmartEggRarities) end
		if c.PlaceEggRarities~=nil then J.PlaceEggRarities=normRarityTable(c.PlaceEggRarities) end
		if c.EggPriority=="Highest" or c.EggPriority=="Lowest" then J.EggPriority=c.EggPriority end
		if c.FossilPriority=="Highest" or c.FossilPriority=="Lowest" then J.FossilPriority=c.FossilPriority end
		if c.PetRarities~=nil      then J.PetRarities=normRarityTable(c.PetRarities) end
		if c.MutationRarities~=nil then J.MutationRarities=normRarityTable(c.MutationRarities) end
		if c.SelectedZone~=nil     then J.SelectedZone=tostring(c.SelectedZone) end
	end
	-- Apply UI dropdowns
	task.spawn(function()
		loadingSuppressed=true
		pcall(function() eggRarityDrop:Set(J.EggRarities) end)
		pcall(function() smartRarityDrop:Set(J.SmartEggRarities) end)
		pcall(function() petSellRarityDrop:Set(J.PetRarities) end)
		pcall(function() mutationRarityDrop:Set(J.MutationRarities) end)
		pcall(function() eggPriorityDrop:Set(J.EggPriority) end)
		pcall(function() fossilPriorityDrop:Set(J.FossilPriority) end)
		pcall(function() if J.SelectedZone then zoneDrop:Set(J.SelectedZone) end end)
		W(.5)
		if type(data.toggles)=="table" then
			for flag, val in pairs(data.toggles) do
				local cur = getgenv().JumpAnimalsEn[flag]
				if cur~=val then
					W(.04)
					local fn = J9[flag]
					if fn then pcall(fn, val) end
				end
			end
			W(2)
			for flag, val in pairs(data.toggles) do
				if getgenv().JumpAnimalsEn[flag]~=val then
					local fn = J9[flag]
					if fn then pcall(fn, val) end
				end
			end
		end
		loadingSuppressed=false
	end)
	return true
end

secCfg:CreateButton({ name="Save Config", callback=function()
	local path=cfgPath(currentCfgName)
	if not path then notifyCfg("Enter a config name first!") return end
	if type(writefile)~="function" then notifyCfg("Filesystem not supported") return end
	local ok, json=pcall(function() return HttpSvc:JSONEncode(buildCfgTable()) end)
	if ok and json then
		local wrote=pcall(writefile, path, json)
		if wrote then notifyCfg("Saved: "..currentCfgName) refreshCfgList()
		else notifyCfg("Failed to write file") end
	else notifyCfg("Failed to encode JSON") end
end })
secCfg:CreateButton({ name="Load Config", callback=function()
	local path=cfgPath(currentCfgName)
	if not path then notifyCfg("Enter a config name first!") return end
	if type(readfile)~="function" then notifyCfg("Filesystem not supported") return end
	local ok, content=pcall(readfile, path)
	if not ok or not content then notifyCfg("Config '"..currentCfgName.."' not found") return end
	local dOk, data=pcall(function() return HttpSvc:JSONDecode(content) end)
	if not dOk or type(data)~="table" then notifyCfg("Failed to decode JSON") return end
	applyCfg(data)
	notifyCfg("Loaded: "..currentCfgName)
end })
secCfg:CreateButton({ name="Delete Config", callback=function()
	local path=cfgPath(currentCfgName)
	if not path then return end
	if type(delfile)=="function" then pcall(delfile, path) notifyCfg("Deleted: "..currentCfgName) refreshCfgList()
	else notifyCfg("Filesystem not supported") end
end })

local autoLoadToggle = secCfg:CreateToggle({
	name="Auto Load on Execute", desc="Loads this config every run.",
	value=false, flag="ConfigAutoLoad",
	callback=function(active)
		if loadingSuppressed then return end
		if active then
			local path=cfgPath(currentCfgName)
			if not path or type(readfile)~="function" or not pcall(readfile, path) then
				notifyCfg("Config '"..currentCfgName.."' not found! Save it first.")
				pcall(function() autoLoadToggle:Set(false) end)
				return
			end
			if type(writefile)=="function" then
				pcall(writefile, CFG_AUTOLOAD, currentCfgName)
				notifyCfg("Will auto-load '"..currentCfgName.."' on execute")
			end
		else
			if type(delfile)=="function" then pcall(delfile, CFG_AUTOLOAD)
			elseif type(writefile)=="function" then pcall(writefile, CFG_AUTOLOAD, "") end
			notifyCfg("Auto-load disabled")
		end
	end,
})

-- Auto-load on start
do
	refreshCfgList()
	if type(readfile)=="function" then
		local ok, autoName=pcall(readfile, CFG_AUTOLOAD)
		if ok and autoName and tostring(autoName)~="" then
			task.spawn(function()
				W(2)
				local path=cfgPath(tostring(autoName))
				local rok, content=pcall(readfile, path)
				if rok and content then
					local dok, data=pcall(function() return HttpSvc:JSONDecode(content) end)
					if dok and type(data)=="table" then
						applyCfg(data)
						notifyCfg("Auto-loaded config: "..tostring(autoName))
					end
				end
			end)
		end
	end
end

-- ========================= FINALIZE =========================
getgenv().JumpAnimalsToggleFuncs = J9
Window:SelectTab(1)
Notify("SpecreWare","Jump for Animals loaded! 🐾", 4)

end -- END FS_RUN

local ok, err = pcall(JFA_RUN)
if not ok then
	warn("[SpecreWare | JFA] Fatal error: "..tostring(err))
end
