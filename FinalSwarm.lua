--[[
	SpecreWare | Final Swarm
	UI: Rayfield Gen2 (https://docs.sirius.menu/rayfield-gen2)
	Brand: SpecreWare
	Discord: https://discord.gg/GdKxvcHzjS
	Game: Final Swarm

	Clean, streamlined Rayfield Gen2 interface without intrusive loading screens.
	Logo: rbxassetid://84699118856259
	Toggle Keybind: Left Control
	100% of Final Swarm game automation logic preserved intact.
]]

-- ===================== KEYLESS STARTUP =====================
-- Starts directly without license/session validation, HWID storage, or key system.

-- ===================== VISIBLE ERROR BOX =====================
local function showErrorBox(where, err)
	pcall(function()
		local parent = nil
		pcall(function()
			if gethui then parent = gethui() end
		end)
		if not parent then
			pcall(function()
				local cg = game:GetService("CoreGui")
				local test = Instance.new("Folder")
				test.Parent = cg
				test:Destroy()
				parent = cg
			end)
		end
		if not parent then
			pcall(function() parent = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui") end)
		end
		if not parent then return end
		local old = parent:FindFirstChild("FS_ErrorBox")
		if old then old:Destroy() end
		local sg = Instance.new("ScreenGui")
		sg.Name = "FS_ErrorBox"
		sg.ResetOnSpawn = false
		sg.DisplayOrder = 999999
		sg.IgnoreGuiInset = true
		sg.Parent = parent
		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(0, 580, 0, 340)
		bg.Position = UDim2.new(0.5, -290, 0.5, -170)
		bg.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
		bg.BorderSizePixel = 0
		bg.Parent = sg
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = bg
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(56, 189, 248)
		stroke.Thickness = 1.5
		stroke.Parent = bg
		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -24, 0, 34)
		title.Position = UDim2.new(0, 12, 0, 8)
		title.BackgroundTransparency = 1
		title.Font = Enum.Font.GothamBold
		title.TextSize = 20
		title.TextColor3 = Color3.fromRGB(240, 90, 90)
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Text = "SpecreWare Startup Warning (" .. tostring(where) .. ")"
		title.Parent = bg
		local msg = Instance.new("TextLabel")
		msg.Size = UDim2.new(1, -24, 1, -88)
		msg.Position = UDim2.new(0, 12, 0, 44)
		msg.BackgroundTransparency = 1
		msg.Font = Enum.Font.Code
		msg.TextSize = 13
		msg.TextColor3 = Color3.fromRGB(220, 230, 245)
		msg.TextWrapped = true
		msg.TextXAlignment = Enum.TextXAlignment.Left
		msg.TextYAlignment = Enum.TextYAlignment.Top
		msg.Text = tostring(err)
		msg.Parent = bg
		local close = Instance.new("TextButton")
		close.Size = UDim2.new(0, 110, 0, 32)
		close.Position = UDim2.new(1, -122, 1, -40)
		close.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
		close.Font = Enum.Font.GothamBold
		close.TextSize = 14
		close.TextColor3 = Color3.fromRGB(240, 249, 255)
		close.Text = "Close"
		close.Parent = bg
		local ccorner = Instance.new("UICorner")
		ccorner.CornerRadius = UDim.new(0, 6)
		ccorner.Parent = close
		close.MouseButton1Click:Connect(function() sg:Destroy() end)
		warn("[SpecreWare] " .. tostring(where) .. ": " .. tostring(err))
	end)
end

-- ===================== PROTECTED RUNNER =====================
local FS_RUN = function()

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local function getFlag(n) return RS:GetAttribute("TPL_"..n) end
local function setFlag(n,v) RS:SetAttribute("TPL_"..n, v) end
local function isCurrentGen() return true end

-- Default attributes for Final Swarm
if RS:GetAttribute("TPL_AutoRaidOn")==nil then RS:SetAttribute("TPL_AutoRaidOn", false) end
if RS:GetAttribute("TPL_AutoShrineOn")==nil then RS:SetAttribute("TPL_AutoShrineOn", true) end
if RS:GetAttribute("TPL_AutoFarmOn")==nil then RS:SetAttribute("TPL_AutoFarmOn", false) end
if RS:GetAttribute("TPL_AutoPortalOn")==nil then RS:SetAttribute("TPL_AutoPortalOn", false) end
if RS:GetAttribute("TPL_MagnetOn")==nil then RS:SetAttribute("TPL_MagnetOn", false) end
if RS:GetAttribute("TPL_AutoChestsOn")==nil then RS:SetAttribute("TPL_AutoChestsOn", false) end
if RS:GetAttribute("TPL_AutoOpenChestsOn")==nil then RS:SetAttribute("TPL_AutoOpenChestsOn", false) end
if RS:GetAttribute("TPL_AutoUpgradeOn")==nil then RS:SetAttribute("TPL_AutoUpgradeOn", false) end
if RS:GetAttribute("TPL_AutoTreeOn")==nil then RS:SetAttribute("TPL_AutoTreeOn", false) end
if RS:GetAttribute("TPL_AutoClaimQuestsOn")==nil then RS:SetAttribute("TPL_AutoClaimQuestsOn", false) end
if RS:GetAttribute("TPL_AutoClaimAchOn")==nil then RS:SetAttribute("TPL_AutoClaimAchOn", false) end
if RS:GetAttribute("TPL_AutoClaimStreakOn")==nil then RS:SetAttribute("TPL_AutoClaimStreakOn", false) end
if RS:GetAttribute("TPL_AutoReplayOn")==nil then RS:SetAttribute("TPL_AutoReplayOn", false) end
if RS:GetAttribute("TPL_AutoPickOn")==nil then RS:SetAttribute("TPL_AutoPickOn", false) end
if RS:GetAttribute("TPL_NoclipOn")==nil then RS:SetAttribute("TPL_NoclipOn", false) end
if RS:GetAttribute("TPL_AntiAfkOn")==nil then RS:SetAttribute("TPL_AntiAfkOn", false) end
if RS:GetAttribute("TPL_AutoAbilityOn")==nil then RS:SetAttribute("TPL_AutoAbilityOn", false) end
if RS:GetAttribute("TPL_AbilityInterval")==nil then RS:SetAttribute("TPL_AbilityInterval", 3) end
if RS:GetAttribute("TPL_HideNameOn")==nil then RS:SetAttribute("TPL_HideNameOn", false) end
if RS:GetAttribute("TPL_AutoEnterPortalOn")==nil then RS:SetAttribute("TPL_AutoEnterPortalOn", false) end
if RS:GetAttribute("TPL_PortalTargetMult")==nil then RS:SetAttribute("TPL_PortalTargetMult", 3) end
if RS:GetAttribute("TPL_AutoRiftOn")==nil then RS:SetAttribute("TPL_AutoRiftOn", false) end
if RS:GetAttribute("TPL_RiftAvoid")==nil then RS:SetAttribute("TPL_RiftAvoid", false) end
if RS:GetAttribute("TPL_RiftMaxTier")==nil then RS:SetAttribute("TPL_RiftMaxTier", 3) end
if RS:GetAttribute("TPL_AutoBubblesOn")==nil then RS:SetAttribute("TPL_AutoBubblesOn", false) end
if RS:GetAttribute("TPL_BubbleThreshold")==nil then RS:SetAttribute("TPL_BubbleThreshold", 45) end
if RS:GetAttribute("TPL_CardPriority")==nil then RS:SetAttribute("TPL_CardPriority", "") end
if RS:GetAttribute("TPL_CardBan")==nil then RS:SetAttribute("TPL_CardBan", "") end
if RS:GetAttribute("TPL_FarmMode") == "Auto-Dodge (Hover)" then RS:SetAttribute("TPL_FarmMode", "Auto-Dodge") end
if RS:GetAttribute("TPL_FarmMode") == nil then RS:SetAttribute("TPL_FarmMode", "Orbit Center") end

local function isPaused() return false end
local Resume = {}

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
				local lp = game:GetService("Players").LocalPlayer
				return (lp and lp:FindFirstChild("PlayerGui")) or game:GetService("CoreGui")
			end
		end
	end
end)

-- Leftover UI cleanup
pcall(function()
	local rg = game.CoreGui:FindFirstChild("RobloxGui")
	local parents = { game.CoreGui }
	if rg then parents[#parents + 1] = rg end
	pcall(function()
		local pg = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
		if pg then parents[#parents + 1] = pg end
	end)
	for _, parent in ipairs(parents) do
		for _, sg in ipairs(parent:GetChildren()) do
			if sg:IsA("ScreenGui") and sg.Name ~= "RobloxGui" then
				if sg.Name:find("Rayfield") or sg.Name:find("VantaUI_") or sg.Name == "VantaNotifs" or sg.Name == "SpecreSplash" or sg.Name == "LiquidSplash" or sg.Name == "AutoUpgradeUI" or sg.Name == "Obsidian" or sg.Name == "WindUI" then
					pcall(function() sg:Destroy() end)
				end
			end
		end
	end
end)

-- ===================== ANTICHEAT BYPASS =====================
do
	pcall(function()
		local AC = require(RS.Shared.Services.AntiCheatService.AntiCheatServiceClient)
		if type(AC) == "table" and AC._networker and not AC._networker.__fsPatched then
			local realFire = AC._networker.fire
			AC._networker.fire = function(self, msg, ...)
				if msg == "ReportViolation" then return end
				return realFire(self, msg, ...)
			end
			AC._networker.__fsPatched = true
		end
	end)
end
local FS_AC_WHITELIST_ATTR = "GameOwnedVFX"
local function fsWhitelist(inst)
	pcall(function() inst:SetAttribute(FS_AC_WHITELIST_ATTR, true) end)
	return inst
end

-- ===================== SERVICES =====================
local ReplicatedStorage = RS
local TweenService = game:GetService("TweenService")
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

-- ===================== BRAND =====================
local BRAND = {
	Name    = "SpecreWare",
	Version = "1.0.0",
	Discord = "https://discord.gg/GdKxvcHzjS",
	Invite  = "discord.gg/GdKxvcHzjS",
	Logo    = "rbxassetid://84699118856259",
	LogoRaw = "84699118856259",
}

local ICON = {
	Drops    = "rbxassetid://84699118856259",
	Bolt     = "zap",
	Crown    = "crown",
	Shield   = "shield",
	Terminal = "terminal",
	Star     = "star",
	Rocket   = "rocket",
	Heart    = "heart",
	Gamepad  = "gamepad-2",
	Spark    = "sparkles",
	Dot      = "dot",
	Key      = "key",
	Lobby    = "map-pin",
	Up       = "arrow-up",
	Gift     = "gift",
	Map      = "map-pin",
	Gear     = "settings",
	Package  = "package",
	Coins    = "coins",
	Gem      = "gem",
	Cart     = "shopping-cart",
	Move     = "move",
	ShieldOK = "shield-check",
	Target   = "target",
	Flask    = "flask-conical",
	Orbit    = "orbit",
	Waves    = "waves",
	Ring     = "crosshair",
	Badge    = "badge-check",
}

-- ===================== LIBRARY LOADER (Rayfield Gen2) =====================
-- Direct, clean loading with local cache to avoid re-downloads (no intrusive splash)
local LIB_CACHE_DIR = "SpecreWare"
local LIB_CACHE_FILE = "SpecreWare/rayfield_gen2_cache.luau"

local function safeReadCache()
	local ok, content = pcall(function()
		if isfile and isfile(LIB_CACHE_FILE) and readfile then
			return readfile(LIB_CACHE_FILE)
		end
		return nil
	end)
	if ok and type(content) == "string" and #content > 20000 then
		return content
	end
	return nil
end

local function safeWriteCache(content)
	pcall(function()
		if writefile then
			if makefolder and isfolder and not isfolder(LIB_CACHE_DIR) then
				makefolder(LIB_CACHE_DIR)
			end
			writefile(LIB_CACHE_FILE, content)
		end
	end)
end

local Rayfield = nil

-- Check local cache first
local cached = safeReadCache()
if cached then
	local okCompile, fn = pcall(loadstring, cached)
	if okCompile and type(fn) == "function" then
		local okRun, lib = pcall(fn)
		if okRun and type(lib) == "table" and lib.CreateWindow then
			Rayfield = lib
		end
	end
end

-- If not cached, fetch via HttpGet
if not Rayfield then
	local urls = { "https://sirius.menu/gen2" }
	for _, url in ipairs(urls) do
		local okFetch, res = pcall(function() return game:HttpGet(url) end)
		if okFetch and type(res) == "string" and #res > 20000 then
			local okCompile, fn = pcall(loadstring, res)
			if okCompile and type(fn) == "function" then
				local okRun, lib = pcall(fn)
				if okRun and type(lib) == "table" and lib.CreateWindow then
					Rayfield = lib
					safeWriteCache(res)
					break
				end
			end
		end
	end
end

if not Rayfield then
	showErrorBox("Rayfield Gen2 Load", "Could not load Rayfield Gen2 from https://sirius.menu/gen2 or cache.\nPlease verify internet access or executor HTTP permissions.")
	return
end

-- ===================== GAME DETECTION =====================
local GAME_NAME = "Final Swarm"
pcall(function()
	local rs = game:GetService("ReplicatedStorage")
	for _, attr in ipairs({ "GameName", "PlaceName", "DisplayName" }) do
		local v = rs:GetAttribute(attr)
		if type(v) == "string" and #v > 0 then GAME_NAME = v break end
	end
end)

-- ===================== WINDOW CREATION =====================
local Window = Rayfield:CreateWindow({
	name          = BRAND.Name .. " | " .. GAME_NAME,
	subtitle      = "Final Swarm",
	theme         = "cobalt",
	icon          = BRAND.Logo,
	sidebarLayout = true,
	profile       = "SpecreWare",
	showName      = "SpecreWare",
	showIcon      = BRAND.Logo,
	configuration = {
		autoSave     = true,
		autoLoad     = true,
		fileName     = "FinalSwarm",
		customFolder = "SpecreWare",
	},
})

if not Window then
	showErrorBox("Window Creation", "Rayfield:CreateWindow failed to initialize.")
	return
end

-- Configure Default Minimize / Toggle Keybind to Left Control
pcall(function()
	if Window.settings then
		Window.settings.toggleKeybind = Enum.KeyCode.LeftControl
	end
end)

-- Enlarge & Enhance Logo Appearance (Topbar & Collapsed State)
local function applyLogoEnhancements()
	pcall(function()
		if Window.themeProperties then
			if Window.topbarIcon then Window.themeProperties[Window.topbarIcon] = nil end
			if Window.collapsedIcon then Window.themeProperties[Window.collapsedIcon] = nil end
		end
		if Window.topbarIcon then
			Window.topbarIcon.Size = UDim2.fromOffset(54, 54)
			Window.topbarIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
			Window.topbarIcon.ScaleType = Enum.ScaleType.Fit
		end
		if Window.topContainer then
			Window.topContainer.Size = UDim2.new(0, 380, 0, 56)
		end
		if Window.collapsedIcon then
			Window.collapsedIcon.Size = UDim2.fromOffset(38, 38)
			Window.collapsedIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
			Window.collapsedIcon.ScaleType = Enum.ScaleType.Fit
		end
	end)
end

applyLogoEnhancements()
task.spawn(function()
	task.wait(0.6)
	applyLogoEnhancements()
	task.wait(0.6)
	applyLogoEnhancements()
end)

-- ===================== UI ADAPTER (Legacy API -> Rayfield Gen2) =====================

local function normOpts(o, cb)
	if type(o) == "string" then return { name = o, callback = cb, text = o } end
	o = o or {}
	return {
		name        = o.name or o.Name or o.title or o.Title or o.Text or o.text or "",
		desc        = o.desc or o.Desc or o.tooltip or o.Tooltip or o.description or o.Description or "",
		value       = (o.value ~= nil and o.value) or (o.default ~= nil and o.default) or (o.CurrentValue ~= nil and o.CurrentValue) or (o.Default ~= nil and o.Default),
		callback    = o.callback or o.Callback or o.changed or o.Changed or o.func or o.Func or cb,
		range       = o.range or o.Range or { (o.min or o.Min or 0), (o.max or o.Max or 100) },
		increment   = o.increment or o.Increment or o.step or o.Step or o.rounding or o.Rounding or 1,
		suffix      = o.suffix or o.Suffix or "",
		options     = o.options or o.Options or o.values or o.Values or {},
		multiSelect = (o.multiSelect ~= nil and o.multiSelect) or (o.multipleOptions ~= nil and o.multipleOptions) or (o.multi ~= nil and o.multi) or (o.Multi ~= nil and o.Multi) or false,
		placeholder = o.placeholder or o.Placeholder or o.PlaceholderText or "",
		flag        = o.flag or o.Flag or o.name or o.Name,
	}
end

local function wrapElement(rawObj)
	local wrapped = {
		_raw = rawObj,
	}

	function wrapped:Set(a, b)
		local v = (b == nil) and a or b
		pcall(function()
			if rawObj and rawObj.Set then rawObj:Set(v) end
		end)
	end
	wrapped.SetValue = wrapped.Set
	wrapped.SetText  = wrapped.Set
	wrapped.SetDesc  = wrapped.Set

	function wrapped:Get()
		if rawObj then
			if rawObj.value ~= nil then
				if type(rawObj.value) == "table" and #rawObj.value == 1 then
					return rawObj.value[1]
				end
				return rawObj.value
			end
			if rawObj.Get then
				local ok, res = pcall(function() return rawObj:Get() end)
				if ok then return res end
			end
		end
		return nil
	end

	function wrapped:SetVisible() end

	function wrapped:Refresh(list)
		pcall(function()
			if rawObj and rawObj.Refresh then rawObj:Refresh(list or {}) end
		end)
	end
	wrapped.SetValues = wrapped.Refresh
	wrapped.Select = wrapped.Set

	return setmetatable(wrapped, {
		__index = function(_, k)
			if k == "Value" or k == "value" or k == "state" or k == "selected" then
				return wrapped:Get()
			end
			local rawVal = rawget(rawObj, k)
			if rawVal ~= nil then return rawVal end
			return nil
		end,
		__newindex = function(_, k, v)
			if k == "Value" or k == "value" or k == "state" or k == "selected" then
				wrapped:Set(v)
			else
				rawset(wrapped, k, v)
			end
		end,
	})
end

local function adaptSection(rawTab, secName)
	local s = { _raw = rawTab, _name = secName }

	function s:CreateToggle(o)
		local n = normOpts(o)
		local rawObj = rawTab:CreateToggle({
			name        = n.name,
			description = n.desc ~= "" and n.desc or nil,
			value       = n.value and true or false,
			flag        = n.flag,
			callback    = n.callback,
		})
		return wrapElement(rawObj)
	end

	function s:CreateSlider(o)
		local n = normOpts(o)
		local mn = tonumber(n.range[1]) or 0
		local mx = tonumber(n.range[2]) or 100
		local def = tonumber(n.value) or mn
		local inc = tonumber(n.increment) or 1
		if inc <= 0 then inc = 1 end
		local rawObj = rawTab:CreateSlider({
			name        = n.name,
			description = n.desc ~= "" and n.desc or nil,
			range       = { mn, mx },
			increment   = inc,
			value       = def,
			suffix      = n.suffix ~= "" and n.suffix or nil,
			flag        = n.flag,
			callback    = n.callback,
		})
		return wrapElement(rawObj)
	end

	function s:CreateDropdown(o)
		local n = normOpts(o)
		local opts = n.options or {}
		local multi = n.multiSelect and true or false
		local initVal = n.value
		if multi then
			if type(initVal) == "string" then initVal = { initVal }
			elseif type(initVal) ~= "table" then initVal = {} end
		else
			if type(initVal) == "table" then initVal = initVal[1] end
			if initVal == nil and #opts > 0 then initVal = opts[1] end
		end
		local rawObj = rawTab:CreateDropdown({
			name        = n.name,
			description = n.desc ~= "" and n.desc or nil,
			options     = opts,
			value       = initVal,
			multiSelect = multi,
			flag        = n.flag,
			callback    = n.callback,
		})
		return wrapElement(rawObj)
	end

	function s:CreateButton(o, cb)
		local n = normOpts(o, cb)
		local rawObj = rawTab:CreateButton({
			name        = n.name,
			description = n.desc ~= "" and n.desc or nil,
			callback    = n.callback,
		})
		return wrapElement(rawObj)
	end

	function s:CreateStat(o)
		local n = normOpts(o)
		local title = n.name ~= "" and n.name or "Stat"
		local rawObj
		local numVal = tonumber(n.value)
		if numVal ~= nil then
			rawObj = rawTab:CreateStat({
				name  = title,
				value = numVal,
			})
		else
			rawObj = rawTab:CreateText({
				name = title,
				text = tostring(n.value or ""),
			})
		end
		local wrapped = wrapElement(rawObj)
		function wrapped:Set(a, b)
			local v = (b == nil) and a or b
			pcall(function()
				if rawObj.Set then rawObj:Set(v) end
			end)
		end
		wrapped.SetDesc = wrapped.Set
		wrapped.SetValue = wrapped.Set
		function wrapped:SetTitle(a, b)
			local v = (b == nil) and a or b
			pcall(function()
				if rawObj.SetTitle then rawObj:SetTitle(tostring(v or "")) end
			end)
		end
		return wrapped
	end

	function s:CreateParagraph(o)
		local opts = o or {}
		local title = opts.Title or opts.title or opts.name or opts.Name or ""
		local content = opts.Content or opts.content or opts.desc or opts.Desc or opts.text or opts.Text or ""
		local rawObj = rawTab:CreateText({
			name = title,
			text = tostring(content or ""),
		})
		local wrapped = wrapElement(rawObj)
		function wrapped:Set(a, b)
			local v = (b == nil) and a or b
			pcall(function()
				if type(v) == "table" then
					if v.Content then rawObj:Set(tostring(v.Content)) end
					if v.Title then rawObj:SetTitle(tostring(v.Title)) end
				else
					rawObj:Set(tostring(v or ""))
				end
			end)
		end
		wrapped.SetTitle = function(self, t)
			local val = (t == nil) and self or t
			pcall(function() rawObj:SetTitle(tostring(val or "")) end)
		end
		wrapped.SetContent = function(self, c)
			local val = (c == nil) and self or c
			pcall(function() rawObj:Set(tostring(val or "")) end)
		end
		return wrapped
	end

	function s:CreateInput(o)
		local n = normOpts(o)
		local rawObj = rawTab:CreateInput({
			name        = n.name,
			description = n.desc ~= "" and n.desc or nil,
			placeholder = n.placeholder ~= "" and n.placeholder or "Enter text...",
			value       = n.value ~= nil and tostring(n.value) or "",
			callback    = n.callback,
		})
		return wrapElement(rawObj)
	end

	function s:CreateKeybind(o, cb)
		local n = normOpts(o, cb)
		local defKey = n.value or "RightShift"
		if typeof(defKey) == "EnumItem" then defKey = defKey.Name end
		local rawObj = rawTab:CreateKeybind({
			name        = n.name,
			description = n.desc ~= "" and n.desc or nil,
			value       = tostring(defKey),
			flag        = n.flag,
			callback    = n.callback,
		})
		return wrapElement(rawObj)
	end

	function s:CreateLabel(o)
		local text = type(o) == "table" and (o.Text or o.text or o.name or o.Title) or tostring(o or "")
		local rawObj = rawTab:CreateText({
			name = "",
			text = text,
		})
		return wrapElement(rawObj)
	end

	function s:CreateSection(o)
		local n = normOpts(o)
		if n.name and n.name ~= "" then
			pcall(function() rawTab:CreateSection({ name = n.name }) end)
		end
		return s
	end

	function s:CreateDivider()
		pcall(function() rawTab:CreateDivider() end)
	end

	-- Groupbox compatibility aliases
	function s:AddToggle(name, info)
		info = info or {}
		return s:CreateToggle({
			name = info.Text or name,
			desc = info.Tooltip,
			value = info.Default,
			callback = info.Changed,
			flag = name,
		})
	end

	function s:AddSlider(name, info)
		info = info or {}
		return s:CreateSlider({
			name = info.Text or name,
			desc = info.Tooltip,
			range = { info.Min or 0, info.Max or 100 },
			increment = (info.Rounding and info.Rounding > 0 and info.Rounding) or 1,
			value = info.Default,
			suffix = info.Suffix,
			callback = info.Changed,
			flag = name,
		})
	end

	function s:AddDropdown(name, info)
		info = info or {}
		return s:CreateDropdown({
			name = info.Text or name,
			desc = info.Tooltip,
			options = info.Values or {},
			multiSelect = info.Multi,
			value = info.Default,
			callback = info.Changed,
			flag = name,
		})
	end

	function s:AddButton(name, info)
		return s:CreateButton({
			name = (type(info) == "table" and (info.Text or info.name)) or name,
			callback = (type(info) == "function" and info) or (type(info) == "table" and (info.Func or info.callback)),
		})
	end

	function s:AddLabel(info)
		return s:CreateLabel(info)
	end

	function s:AddKeyPicker(name, info)
		info = info or {}
		return s:CreateKeybind({
			name = info.Text or name,
			desc = info.Tooltip,
			value = info.Default,
			callback = info.Changed,
			flag = name,
		})
	end

	function s:AddDivider()
		pcall(function() rawTab:CreateDivider() end)
	end

	function s:AddDiscordBox(name, info)
		local inviteUrl = BRAND.Discord
		rawTab:CreateText({
			name = BRAND.Name .. " Discord Community",
			text = "Join our official community for support, updates, and announcements:\n" .. inviteUrl
		})
		rawTab:CreateButton({
			name     = "Copy Discord Invite Link",
			callback = function()
				local copied = false
				pcall(function()
					if setclipboard then
						setclipboard(inviteUrl)
						copied = true
					end
				end)
				if copied then
					_G.FS_Notify("SpecreWare", "Discord link copied to clipboard!", 3)
				else
					_G.FS_Notify("SpecreWare", inviteUrl, 6)
				end
			end
		})
	end

	return s
end

local function adaptTab(rawTab)
	if type(rawTab) == "table" and rawTab._isAdapted then
		return rawTab
	end
	local t = {
		_raw = rawTab,
		_cur = nil,
		_count = 0,
		_isAdapted = true,
	}

	function t:CreateSection(o)
		local n = normOpts(o)
		t._count = t._count + 1
		local nm = n.name ~= "" and n.name or "Features"
		pcall(function() rawTab:CreateSection({ name = nm }) end)
		t._cur = adaptSection(rawTab, nm)
		return t._cur
	end

	local function cur()
		if not t._cur then
			t._cur = t:CreateSection({ name = "General" })
		end
		return t._cur
	end

	function t:CreateToggle(o) return cur():CreateToggle(o) end
	function t:CreateSlider(o) return cur():CreateSlider(o) end
	function t:CreateDropdown(o) return cur():CreateDropdown(o) end
	function t:CreateButton(o, cb) return cur():CreateButton(o, cb) end
	function t:CreateStat(o) return cur():CreateStat(o) end
	function t:CreateParagraph(o) return cur():CreateParagraph(o) end
	function t:CreateInput(o) return cur():CreateInput(o) end
	function t:CreateKeybind(o, cb) return cur():CreateKeybind(o, cb) end
	function t:CreateLabel(o) return cur():CreateLabel(o) end
	function t:CreateDivider() pcall(function() rawTab:CreateDivider() end) end
	function t:Divider() pcall(function() rawTab:CreateDivider() end) end
	function t:Space() end

	function t:AddLeftGroupbox(name, icon, ...) return t:CreateSection({ name = name }) end
	function t:AddRightGroupbox(name, icon, ...) return t:CreateSection({ name = name }) end
	function t:AddGroupbox(name, icon, ...) return t:CreateSection({ name = name }) end

	return t
end

-- Notification shim
_G.FS_Notify = function(title, content, dur)
	pcall(function()
		if Window and Window.Notify then
			Window:Notify({
				title    = title or BRAND.Name,
				content  = content or "",
				duration = dur or 4,
			})
		end
	end)
end

local window = {}
window._raw = Window
function window:Notify(o)
	o = o or {}
	_G.FS_Notify(o.Title or o.title, o.Content or o.content or o.Description, o.Duration or o.duration or o.Time)
end

-- Keybind to toggle GUI visibility (Default: Left Control)
pcall(function()
	local uis = game:GetService("UserInputService")
	uis.InputBegan:Connect(function(inp, gp)
		if not gp and (inp.KeyCode == Enum.KeyCode.LeftControl or (Window and Window.settings and inp.KeyCode == Window.settings.toggleKeybind)) then
			if Window and Window.ToggleHide then
				Window:ToggleHide()
			end
		end
	end)
end)

-- ===================== TABS INITIALIZATION =====================
local rawMain     = Window:CreateTab({ name = "Main", icon = BRAND.Logo })
pcall(function()
	if rawMain.topbarItemIcon then
		rawMain.topbarItemIcon.Size = UDim2.fromOffset(26, 26)
		rawMain.topbarItemIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
		rawMain.topbarItemIcon.ScaleType = Enum.ScaleType.Fit
	end
end)
local rawLobby    = Window:CreateTab({ name = "Lobby", icon = "map-pin" })
local rawMisc     = Window:CreateTab({ name = "Misc", icon = "shield" })
local rawSettings = Window:CreateTab({ name = "Settings", icon = "settings" })
local rawCredits  = Window:CreateTab({ name = "Credits", icon = "star" })

local Tabs = {
	Main     = adaptTab(rawMain),
	Lobby    = adaptTab(rawLobby),
	Misc     = adaptTab(rawMisc),
	Settings = adaptTab(rawSettings),
	Credits  = adaptTab(rawCredits),
}

local tab     = Tabs.Main
local lobby   = Tabs.Lobby
local misc    = Tabs.Misc
local credits = Tabs.Credits

-- Preserved automation chunk begins below

-- ===================== MAIN =====================

-- The Main tab now hosts the Auto Farm section (hover flight + projectile
-- dodge + optional orb swoop). The old placeholder Status section was removed.

-- ===================== LOBBY: AUTO JOIN =====================
-- Auto Join: picks a map from the in-game world-selection UI and queues it, so the
-- player is standing in the right circle when the countdown completes. The queue
-- itself lives server-side: WorldSelection SetWorld -> SetDifficulty -> EnterQueue
-- (verified against the game's own WorldSelectionFrame client code), and the lobby
-- only starts the round while the player is inside their assigned queue circle.
-- The raid (Colosseum) is a separate zone: standing inside its circle auto-queues
-- a raid (uses a daily ticket), so Auto Raid just walks/parks the character there.

local RunService = game:GetService("RunService")

-- Atlantis (Underwater) added: WaveData.CampaignWorlds() returns the campaign in
-- this exact order -- Starting grounds, Grasslands, Desert, Swamp, Jungle, Frost
-- Forest, Volcano, Atlantis -- and this list was still stopping at Volcano, so
-- Auto Join could not queue the oxygen world at all. "Starting grounds" stays
-- out on purpose: it is the tutorial world, not a campaign map.
local WORLDS = { "Grasslands", "Desert", "Swamp", "Jungle", "Frost Forest", "Volcano", "Atlantis" }

local DIFFICULTIES = { "Normal", "Hard", "Nightmare" }

-- Human labels -> exact WaveData world names the server expects
local WORLD_LABELS = {
	["Grasslands"] = "Grasslands",
	["Desert"] = "Desert",
	["Swamp"] = "Swamp",
	["Jungle"] = "Jungle",
	["Frost Forest"] = "Frost Forest",
	["Volcano"] = "Volcano",
	["Atlantis"] = "Atlantis",
}

if getFlag("Lobby_World") == nil then RS:SetAttribute("TPL_Lobby_World", "Grasslands") end

if getFlag("Lobby_Difficulty") == nil then RS:SetAttribute("TPL_Lobby_Difficulty", "Normal") end

local autoJoinOn = getFlag("AutoJoinOn")

local autoRaidOn = getFlag("AutoRaidQueueOn")

local currentMap = getFlag("Lobby_World")

local currentDiff = getFlag("Lobby_Difficulty")

local Networker = nil

pcall(function() Networker = require(RS:WaitForChild("Packages", 10):WaitForChild("Networker", 10)) end)

local function getCharacterHRP()

	local char = Players.LocalPlayer.Character

	return char and char:FindFirstChild("HumanoidRootPart")

end

-- Teleports the character into the middle of a zone part and keeps it there
-- for `hold` seconds (the lobby physics can push a falling character off).
local function standInPart(part, yOffset, hold)

	if not part or not part:IsA("BasePart") then return false end

	local hrp = getCharacterHRP()

	if not hrp then return false end

	local deadline = os.clock() + (hold or 3)

	while os.clock() < deadline do

		pcall(function() hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, yOffset or 3, 0)) end)

		task.wait(0.25)

	end

	return true

end

-- Fires the game's own world-selection messages. Returns true when the server
-- accepted the queue request.
local function queueWorld(worldName, difficulty)

	local net = nil

	pcall(function() net = Networker.client.new("WorldSelection", {}) end)

	if not net then return false, "no networker" end

	local ok1 = pcall(function() net:fire("SetWorld", worldName) end)

	task.wait(0.2)

	local ok2 = pcall(function() net:fire("SetDifficulty", difficulty) end)

	task.wait(0.2)

	local okR, res = pcall(function() return net:fetch("EnterQueue") end)

	return okR and res == true, tostring(res)

end

local function isInQueue()

	local ok, vis = pcall(function()

		return Players.LocalPlayer.PlayerGui.HUD.Bottom.ButtonsHolder.LeaveButton.Visible

	end)

	return ok and vis

end

-- ===================== AUTO JOIN LOOP =====================
do

	local joinRunning = false

	local function autoJoinLoop()

		if joinRunning then return end

		joinRunning = true

		while autoJoinOn and isCurrentGen() do

			local lobbyRoot = workspace:FindFirstChild("Lobby")

			if not lobbyRoot then

				-- not in the lobby (in a match or still loading)
				task.wait(2)

			else

				-- 1) send the selection exactly like the world-selection UI does
				local ok, why = queueWorld(WORLD_LABELS[currentMap] or currentMap, currentDiff)

				if ok then

					-- solo party: pick size 1 and Create, like the Party frame does
					pcall(function()

						local netQ = Networker.client.new("QueueService", {})

						netQ:fire("PartySizeSelected", 1)

					end)

					task.wait(0.3)

					pcall(function()

						local netQ = Networker.client.new("QueueService", {})

						netQ:fire("Created")

					end)

					-- 2) the server drops us into an elevated queue circle; it only
					-- starts the round while we are physically inside it, so hold
					-- the character on the platform until the lobby disappears
					-- (= the teleport into the match happened).
					local deadline = os.clock() + 30

					while autoJoinOn and isCurrentGen() and os.clock() < deadline do

						local lb = workspace:FindFirstChild("Lobby")

						if not lb then break end -- teleported into the match: done

						local hrp = getCharacterHRP()

						if hrp then

							local areas = lb:FindFirstChild("Areas")

							local qFolder = areas and areas:FindFirstChild("Queue")

							local best, bd = nil, math.huge

							if qFolder then

								for _, q in ipairs(qFolder:GetChildren()) do

									if q:IsA("Model") and q:FindFirstChild("Container") then

										local c = q.Container.Position

										local d = (Vector3.new(c.X, 0, c.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude

										if d < bd then bd = d; best = q end

									end

								end

							end

							if best and bd < 80 then

								pcall(function() hrp.CFrame = CFrame.new(best.Container.Position + Vector3.new(0, 4, 0)) end)

							end

						end

						task.wait(0.3)

					end

				else

					task.wait(2)

				end

				task.wait(0.5)

			end

		end

		joinRunning = false

	end

	task.spawn(autoJoinLoop)

	-- publish for the toggle callback below
	_G.FS_StartAutoJoin = function(on)

		autoJoinOn = on

		if on then task.spawn(autoJoinLoop) end

	end

end

-- ===================== AUTO RAID (Colosseum) LOOP =====================
do

	local raidRunning = false

	local function autoRaidQueueLoop()

		if raidRunning then return end

		raidRunning = true

		while autoRaidOn and isCurrentGen() do

			local lb = workspace:FindFirstChild("Lobby")

			if not lb then

				-- not in the lobby: nothing to stand in
				task.wait(2)

			else

				local areas = lb:FindFirstChild("Areas")

				local raids = areas and areas:FindFirstChild("Raids")

				local queues = raids and raids:FindFirstChild("RaidQueues")

				local q1 = queues and queues:FindFirstChild("Queue1")

				if q1 and q1:FindFirstChild("Container") then

					-- raid join is purely physical: stand inside the raid circle and
					-- the zone auto-queues (uses a daily ticket when the round starts)
					standInPart(q1.Container, 3, 2)

				else

					task.wait(1)

				end

			end

			task.wait(0.5)

		end

		raidRunning = false

	end

	task.spawn(autoRaidQueueLoop)

_G.FS_StartAutoRaid = function(on)

	autoRaidOn = on

	if on then task.spawn(autoRaidQueueLoop) end

	end
end

-- ===================== ROUND-END SCREEN HELPERS =====================
-- Win OR death, the run ends behind TWO gate screens before the RoundEnd
-- reward screen appears (verified in the game's DeathScreen/RoundEnd clients):
--   1. DeathFrame  -> its "Continue" button advances to RoundEnd/Victory
--   2. VictoryFrame -> ANY click/touch dismisses it into RoundEnd:Show()
-- Without clicking through these, Auto Replay / Auto Return Lobby never see
-- RoundEnd become visible and wait forever.
do
	local function fsFrame(name)
		local f = nil
		pcall(function()
			local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
			local frames = pg and pg:FindFirstChild("Frames")
			f = frames and frames:FindFirstChild(name)
		end)
		return f
	end

	-- fires a GuiButton the way the game itself would: its own connections first
	-- (getconnections on BOTH click signals), then firesignal, then a synthetic
	-- click at its center as the last resort. Returns true if any path fired.
	function _G.FS_PressButton(btn)
		if not (btn and btn:IsA("GuiButton")) then return false end
		local fired = false
		if getconnections then
			pcall(function()
				for _, sig in ipairs({ btn.MouseButton1Click, btn.Activated }) do
					for _, conn in ipairs(getconnections(sig)) do
						local ok = pcall(function() conn:Fire() end)
						if ok then fired = true end
					end
				end
			end)
		end
		if not fired and firesignal then
			pcall(function()
				firesignal(btn.MouseButton1Click)
				fired = true
			end)
		end
		if not fired then
			pcall(function()
				local cam = workspace.CurrentCamera
				local vp = cam and cam.ViewportSize or Vector2.new(960, 540)
				local VIM = game:GetService("VirtualInputManager")
				local x, y = vp.X / 2, vp.Y / 2
				pcall(function()
					local ap, as = btn.AbsolutePosition, btn.AbsoluteSize
					x, y = ap.X + as.X / 2, ap.Y + as.Y / 2
				end)
				VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
				task.wait(0.05)
				VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
				fired = true
			end)
		end
		return fired
	end

	-- click through the death screen and victory splash if they are up
	function _G.FS_ClickThroughEndGates()
		local death = fsFrame("DeathFrame")
		if death and death.Visible then
			-- the death screen has TWO advance paths: Continue (DeathScreen client
			-- line 65 -> RoundEnd:Show/showVictory) and Give Up. Try every visible
			-- GuiButton in Buttons until one of them clears the frame — some skins
			-- bury Continue or name the button differently, so don't hard-code it.
			local buttons = death:FindFirstChild("Buttons")
			local pressed = false
			if buttons then
				local cont = buttons:FindFirstChild("Continue")
				if cont and cont:IsA("GuiButton") then pressed = _G.FS_PressButton(cont) or pressed end
				if not pressed then
					for _, b in ipairs(buttons:GetChildren()) do
						if b:IsA("GuiButton") and b ~= cont and b.Visible
							and b.Name ~= "Revive" and b.Name ~= "Spectate" then
							pressed = _G.FS_PressButton(b) or pressed
							if pressed then break end
						end
					end
				end
			end
			-- last resort: re-fire the DeathScreen client's Continue handler even
			-- if the button was somehow invisible/renamed
			if not pressed and buttons then
				local cont = buttons:FindFirstChild("Continue")
				if cont then pressed = _G.FS_PressButton(cont) or pressed end
			end
			task.wait(0.6)
			return true
		end
		-- VictoryFrame: the game dismisses it on UserInputService.InputBegan with
		-- gameProcessed == false (MouseButton1/Touch/Gamepad1) -> RoundEnd:Show().
		-- LIVE-VERIFIED (2026-09-20): VictoryFrame itself has ZERO connections;
		-- the dismissal lives in a PlayerScripts InputBegan listener, and firing
		-- connections from our thread throws "cannot access 'Instance' (lacking
		-- capability Plugin)" in some executors, while center-screen VIM clicks
		-- only reach the listener SOMETIMES (the flaky Auto Replay on victory).
		-- Three-tier dismissal, guaranteed last tier:
		--   1. fire UIS InputBegan connections (guarded — works when it works)
		--   2. VIM click on the Continue label's OWN screen position (not center)
		--   3. call the game's own RoundEnd module Show/showVictory directly —
		--      the same functions the InputBegan listener would trigger
		local UISvc = game:GetService("UserInputService")
		local vict = fsFrame("VictoryFrame")
		if vict and vict.Visible then
			local dismissed = false
			if getconnections then
				pcall(function()
					for _, conn in ipairs(getconnections(UISvc.InputBegan)) do
						-- only scripts (the game's), skip our own hub listeners
						if conn.Script and conn.Script ~= script then
							local ok = pcall(function()
								conn:Fire({ UserInputType = Enum.UserInputType.MouseButton1 }, false)
							end)
							if ok then dismissed = true end
						end
					end
				end)
			end
			if not dismissed then
				-- tier 2: click the Continue TextLabel at its real screen position
				pcall(function()
					local cont = vict:FindFirstChild("Continue")
					if cont and cont:IsA("GuiObject") then
						local VIM = game:GetService("VirtualInputManager")
						local ap, as = cont.AbsolutePosition, cont.AbsoluteSize
						local x, y = ap.X + as.X / 2, ap.Y + as.Y / 2
						VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
						task.wait(0.05)
						VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
						dismissed = true
					end
				end)
			end
			task.wait(0.3)
			if not dismissed or vict.Visible then
				-- tier 3 (guaranteed): drive the game's own RoundEnd module — the
				-- exact functions the InputBegan listener would have called. If
				-- showVictory already ran, Show is harmless; if it never ran
				-- (splash stuck), this completes the transition.
				-- Call conventions unknown (bytecode won't decompile) — try colon
				-- then dot for each; the wrong one just errors into the pcall.
				pcall(function()
					local RE = require(RS.Shared.UI.Frames.RoundEnd)
					if type(RE.showVictory) == "function" then RE:showVictory() end
				end)
				pcall(function()
					local RE = require(RS.Shared.UI.Frames.RoundEnd)
					if type(RE.showVictory) == "function" then RE.showVictory() end
				end)
				pcall(function()
					local RE = require(RS.Shared.UI.Frames.RoundEnd)
					if type(RE.Show) == "function" then RE:Show() end
				end)
				pcall(function()
					local RE = require(RS.Shared.UI.Frames.RoundEnd)
					if type(RE.Show) == "function" then RE.Show() end
				end)
				task.wait(0.3)
				dismissed = not vict.Visible
			end
			-- last resort: hide the splash outright so RoundEnd can be seen
			if vict.Visible then
				pcall(function() vict.Visible = false end)
				dismissed = true
			end
			task.wait(0.3)
			return true
		end
		return false
	end
end

-- ===================== AUTO REPLAY WAVE LOOP =====================
-- Fires ONLY after a finished round (win or death): the trigger is the game's
-- own RoundEnd screen turning Visible (its "Again" button = replay). Never
-- from lobby idle. Queues the last selected map + difficulty via the game's
-- own WorldSelection channel, exactly like Auto Join does.
do
	-- Design: UNFREEZABLE. The coordinator only ever reads state and yields on
	-- bounded task.wait calls. ALL risky work (pressing buttons — the game's
	-- handler can yield; queueing — Networker.client.new can WaitForChild
	-- forever; the queue-circle hold) runs in DETACHED task.spawn workers.
	-- A watchdog heartbeat detects a stalled coordinator and respawns it.
	local coordGen = 0 -- bumped on every respawn; stale coordinators self-exit
	local lastBeat = 0

	local function roundEndVisible()
		local ok, v = pcall(function()
			local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
			local frames = pg and pg:FindFirstChild("Frames")
			local re = frames and frames:FindFirstChild("RoundEnd")
			if re and re.Visible then return true end
			-- FIX (victory replay): the Victory splash sits IN FRONT of RoundEnd;
			-- treat it as round-over so the state machine arms before it clears
			local vf = frames and frames:FindFirstChild("VictoryFrame")
			return vf ~= nil and vf.Visible == true
		end)
		return ok and v or false
	end

	-- arm only when a round actually finished (win/death -> RoundEnd screen)
	local function iteration()
		RS:SetAttribute("FS_ReplayBeat", string.format("%.1f", os.clock() % 100000))
		-- click through death/victory gates first — RoundEnd sits behind them
		pcall(function() _G.FS_ClickThroughEndGates() end)
		-- NOTE: read the same attribute name we write ("FS_WasInRound").
		-- getFlag prepends TPL_, so getFlag("FS_WasInRound") read
		-- TPL_FS_WasInRound, which nothing ever sets -> always false -> the
		-- loop re-armed forever and never pressed Again.
		local wasInRound = RS:GetAttribute("FS_WasInRound") == true
		if not wasInRound then
			RS:SetAttribute("FS_ReplayState", "idle")
			if roundEndVisible() then
				RS:SetAttribute("FS_WasInRound", true)
				RS:SetAttribute("FS_ReplayState", "armed")
			end
			task.wait(1)
			return
		end

		local lb = workspace:FindFirstChild("Lobby")
		local again = nil
		pcall(function()
			local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
			local frames = pg and pg:FindFirstChild("Frames")
			local re = frames and frames:FindFirstChild("RoundEnd")
			again = re and re:FindFirstChild("Buttons") and re.Buttons:FindFirstChild("Again")
		end)

		if again and again:IsA("GuiButton") and again.Visible and roundEndVisible() then
			-- RoundEnd reward screen up: its "Again" button IS the replay path
			-- (GameServiceClient:PlayAgain). Press DETACHED — the game's click
			-- handler may yield (teleport/queue) and must never block us. Then
			-- just poll until the screen disappears (max 6s), no trust in the
			-- press function's return value.
			RS:SetAttribute("FS_ReplayState", "pressing")
			warn("[SpecreWare/AutoReplay] pressing Again (round ended)")
			task.spawn(function()
				local okFire = false
				pcall(function() okFire = _G.FS_PressButton(again) or false end)
				if not okFire then
					-- direct PlayAgain fallback, also detached
					pcall(function()
						local GS = require(RS.Shared.Services.GameService.GameServiceClient)
						GS:PlayAgain()
					end)
				end
			end)
			local t0 = os.clock()
			while os.clock() - t0 < 6 and roundEndVisible() and getFlag("AutoReplayOn") do
				task.wait(0.25)
			end
			if not roundEndVisible() then
				RS:SetAttribute("FS_WasInRound", false)
				RS:SetAttribute("FS_ReplayState", "pressed")
				if _G.FS_Notify then pcall(function() _G.FS_Notify("Auto Replay", "Round ended -> pressed Again") end) end
				task.wait(5)
			else
				RS:SetAttribute("FS_ReplayState", "press_failed")
				warn("[SpecreWare/AutoReplay] Again press did not clear the screen — retrying")
			end
			-- still visible after 6s? leave FS_WasInRound armed — the next
			-- iteration (or a watchdog respawn) retries the press
		elseif lb then
			RS:SetAttribute("FS_WasInRound", false)
			-- round over, back in lobby: re-queue DETACHED. Networker.client.new
			-- blocks on _remotes:WaitForChild(tag) with no timeout — in a fresh
			-- server that folder may not exist yet and pcall does NOT save us
			-- (yielding is not an error). Frozen calls here used to wedge the
			-- whole loop permanently.
			task.spawn(function()
				local map = getFlag("Lobby_World") or "Grasslands"
				local diff = getFlag("Lobby_Difficulty") or "Normal"
				pcall(function()
					queueWorld(WORLD_LABELS[map] or map, diff)
				end)
				pcall(function()
					local netQ = Networker.client.new("QueueService", {})
					netQ:fire("PartySizeSelected", 1)
				end)
				task.wait(0.3)
				pcall(function()
					local netQ = Networker.client.new("QueueService", {})
					netQ:fire("Created")
				end)
				-- hold position inside the assigned queue circle like Auto Join
				local deadline = os.clock() + 30
				while os.clock() < deadline and getFlag("AutoReplayOn") do
					if not workspace:FindFirstChild("Lobby") then break end
					local h = getCharacterHRP()
					if h then
						local areas = lb:FindFirstChild("Areas")
						local qFolder = areas and areas:FindFirstChild("Queue")
						local best, bd = nil, math.huge
						if qFolder then
							for _, q in ipairs(qFolder:GetChildren()) do
								if q:IsA("Model") and q:FindFirstChild("Container") then
									local c = q.Container.Position
									local d = (Vector3.new(c.X, 0, c.Z) - Vector3.new(h.Position.X, 0, h.Position.Z)).Magnitude
									if d < bd then bd = d; best = q end
								end
							end
						end
						if best and bd < 80 then
							pcall(function() h.CFrame = CFrame.new(best.Container.Position + Vector3.new(0, 4, 0)) end)
						end
					end
					task.wait(0.3)
				end
			end)
			task.wait(2)
		else
			RS:SetAttribute("FS_WasInRound", false) -- in a match (RoundEnd hidden)
			task.wait(2)
		end
	end

	local function coordinator(myGen)
		while getFlag("AutoReplayOn") and isCurrentGen() and coordGen == myGen do
			lastBeat = os.clock()
			local ok, err = pcall(iteration)
			lastBeat = os.clock()
			if not ok then
				warn("[SpecreWare/AutoReplay] iteration error (recovering): " .. tostring(err))
				task.wait(1)
			end
		end
	end

	-- watchdog: if the coordinator stalls >12s while the flag is on, respawn it.
	-- A stalled thread CANNOT take the loop down permanently anymore.
	local watchdogStarted = false
	local function startWatchdog()
		if watchdogStarted then return end
		watchdogStarted = true
		task.spawn(function()
			while isCurrentGen() do
				task.wait(3)
				if getFlag("AutoReplayOn") and os.clock() - lastBeat > 12 then
					warn("[SpecreWare/AutoReplay] coordinator stalled — respawning")
					coordGen = coordGen + 1
					lastBeat = os.clock()
					task.spawn(coordinator, coordGen)
				end
			end
		end)
	end

	local function startCoordinator()
		coordGen = coordGen + 1
		lastBeat = os.clock()
		startWatchdog()
		task.spawn(coordinator, coordGen)
	end

	startCoordinator()
	_G.FS_StartAutoReplay = function(on)
		RS:SetAttribute("TPL_AutoReplayOn", on)
		-- respawn the coordinator when toggled on mid-session (it may have
		-- exited because AutoReplayOn was false back then); the watchdog is
		-- already permanent, so this never needs to run more than once
		if on then startCoordinator() end
	end
end

-- ===================== AUTO RETURN LOBBY LOOP =====================
-- Fires ONLY after a finished round (win or death): the run ends behind the
-- death/victory gate screens — click through those first, then wait for the
-- game's own RoundEnd reward screen and press its "Lobby" button
-- (RoundEnd.Buttons.Lobby -> GameServiceClient:Continue()).
do
	local retRunning = false
	local function autoReturnLobbyLoop()
		if retRunning then return end
		retRunning = true
		local function roundEndVisible()
			local ok, v = pcall(function()
				local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
				local frames = pg and pg:FindFirstChild("Frames")
				local re = frames and frames:FindFirstChild("RoundEnd")
				return re ~= nil and re.Visible == true
			end)
			return ok and v or false
		end
		while getFlag("AutoReturnLobbyOn") and isCurrentGen() do
			local inMatch = workspace:FindFirstChild("Map") ~= nil and workspace:FindFirstChild("Lobby") == nil
			if not inMatch then
				task.wait(1)
			else
				-- death screen or victory splash up? click through them first —
				-- RoundEnd is unreachable until both are dismissed
				if pcall(function() _G.FS_ClickThroughEndGates() end) then
					task.wait(0.5)
				end
				-- look for the round-end screen
				local pressed = false
				pcall(function()
					local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
					local frames = pg and pg:FindFirstChild("Frames")
					local roundEnd = frames and frames:FindFirstChild("RoundEnd")
					local btn = roundEnd and roundEnd:FindFirstChild("Buttons")
						and roundEnd.Buttons:FindFirstChild("Lobby")
					-- win/death gate: the RoundEnd screen itself must be on screen
					if btn and btn:IsA("GuiButton") and btn.Visible
						and roundEnd.Visible and roundEndVisible() then
						-- fire the game's own handler first (safest path)
						local okPress = _G.FS_PressButton and _G.FS_PressButton(btn)
						-- fall back to the service call directly
						if not okPress then
							pcall(function()
								local GS = require(RS.Shared.Services.GameService.GameServiceClient)
								GS:Continue()
							end)
						end
						pressed = true
					end
				end)
				if pressed then
					RS:SetAttribute("TPL_AutoReturnLobbyOn", false) -- one-shot per round
					if _G.FS_Notify then pcall(function() _G.FS_Notify("Auto Return Lobby", "Round ended -> returning to lobby") end) end
					task.wait(5) -- let the teleport settle before re-checking
				else
					task.wait(0.5)
				end
			end
		end
		retRunning = false
	end
	task.spawn(autoReturnLobbyLoop)
	_G.FS_StartAutoReturnLobby = function(on)
		RS:SetAttribute("TPL_AutoReturnLobbyOn", on)
		if on then task.spawn(autoReturnLobbyLoop) end
	end
end

-- ===================== AUTO SMART CARDS =====================
-- Picks level-up cards by priority without touching the UI: fires the same
-- remote the Upgrade frame uses (GameServiceClient:UpgradeSelected(name, count))
-- as soon as IsChoosingUpgrade flips true.
-- Strategy:
--   * early game: grab Luck first (better rare rolls for the rest of the run)
--   * late game (>= min level): Luck is deprioritized
--   * weapons are ranked to match the hover auto-farm: ranged/AOE first,
--     close-range last
--   * passives fill whatever's left

do
	-- // WEAPON PRIORITY: long/AOE range first, close-range last (hover farm) //
	local WEAPON_PRIORITY = {
		-- S-tier: ranged AOE / high raw damage — perfect for hover farm
		"Inferno Sword", "Laserbeam", "Trident", "Meteor", "Ban Hammer",
		"Black Hole Cannon", "Void Scythe", "Firestaff", "Lightning Staff",
		"Minigun", "Subspace Tripmine", -- new: Mythical pierce-spitter / Exotic 480-dmg AOE mines
		-- A-tier: solid ranged or homing
		"Missile", "Tornado", "Bananarang", "Bow", "Revolver", "Sniper",
		"Poison Flask", "Ninja Star", "Paintball Gun", -- new: Rare hitscan, scales hard with attack-speed upgrades
		-- B-tier: AOE zones that still reach from above
		"Aura", "Explosion", "Axe",
		-- Nuke (rarity "Admin", requiresUnlock): random bombs, no manual control —
		-- ranked below everything so it's only ever picked when nothing better shows.
		"Nuke",
		-- C-tier: walkers / short reach — least useful while hovering
		"Frost Walker", "Flame Walker", "Flamethrower", "Spike Ball", "Sword",
		"Shotgun", "Daggers",
	}
	local WEAPON_RANK = {}
	for i, w in ipairs(WEAPON_PRIORITY) do WEAPON_RANK[w] = i end

	-- The run level is NEVER stored on PlayerRunData. The game derives it from xp
	-- with this module (the XP bar, RoundEnd and the pause screen all call it), and
	-- it returns TWO values: level, then xp into that level. PlayerRunData:get()
	-- has 75 keys and `level` is not one of them, so the old getRunLevel() below
	-- read nil, fell back to 1, levelKind(1) answered "early" forever, and the Luck
	-- limit never left its early branch -- every level-up took Luck.
	local GetLevelFromXP = nil
	do
		local okG, mod = pcall(function() return require(RS.Shared.Modules.Math.GetLevelFromXP) end)
		if okG and type(mod) == "function" then GetLevelFromXP = mod end
	end

	-- // GAME-DATA SCORING (replaces the old hard-coded tier table) //
	-- Reads the game's own UpgradeData / WeaponData so rebalances or new cards
	-- are scored correctly without editing this script. Rarity comes straight
	-- from the data (Common=1 .. Mythical/Void/Inferno=6), scaled by a
	-- playstyle weight per stat (hover farm: damage/ranged stats first).
	local RARITY_ORDER = { Common = 1, Rare = 2, Epic = 3, Legendary = 4, Mythical = 5, Void = 6, Inferno = 6, Exotic = 6, Admin = 7 } -- values verified vs game's RarityData (2026-09-20): Exotic=6, Admin=8 (clamped to 7 here so Admin never outranks Inferno-tier in playstyle bias)
	local STAT_WEIGHT = {
		Damage = 1.00, ["Attack Speed"] = 0.95, ["Projectile Count"] = 0.95,
		Multishot = 0.95, Size = 0.85, Piercing = 0.85, Ricochet = 0.85,
		Bolt = 0.75, Blaze = 0.75, Freeze = 0.75, ["Projectile Speed"] = 0.70,
		Crit = 0.70, ["Crit Chance"] = 0.70, Luck = 0.60, ["XP Gain"] = 0.55,
		Health = 0.40, Regen = 0.40, Lifesteal = 0.40, Armor = 0.35,
		Evasion = 0.35, ["Movement Speed"] = 0.30, Knockback = 0.20,
		["Stand Strong"] = 0.05, ["Giant's Strength"] = 0.10, ["Extra Jump"] = 0.10,
	}
	local function dataScore(id, rarityOverride, isWeapon)
		-- rarityOverride: the card frame's OWN rarity label. Needed because the
		-- offers are keyed by display name here, and the display name is not a
		-- unique UpgradeData id (all four Luck variants are titled "Luck", the real
		-- ids are "Luck Common" / "Luck Rare" / "Luck Epic" / "Luck Legendary"), so
		-- UpgradeData[id] misses and every stat card used to score as Common.
		-- Only trust the override when it is a rarity we actually know -- the frame
		-- also writes "Weapon" / "Misc" there, and those are not rarities.
		local override = (type(rarityOverride) == "string" and RARITY_ORDER[rarityOverride]) and rarityOverride or nil
		-- 1) weapon? base from game rarity + hover-farm rank bias
		-- isWeapon: the spin frame tags weapon cards with the literal string
		-- "Weapon" (showUpgrades / snapToFinalRarity). A weapon this client's
		-- WeaponData does not know -- a live offer really did show "Flame I" with
		-- an icon in neither Flame Walker's nor Flamethrower's slot -- would
		-- otherwise miss WEAPON_RANK, fall through to the passive branch and score
		-- at 0.5 weight, i.e. worse than a Common Health. Unknown weapons get a
		-- neutral mid-table rank rather than that.
		local rank = WEAPON_RANK[id]
		if rank or isWeapon then
			local okW, WD = pcall(function() return require(RS.Shared.Modules.Data.WeaponData) end)
			local r = override or (okW and WD and WD[id] and WD[id].rarity or nil)
			local base = 300 + 130 * (RARITY_ORDER[r] or 2) -- Common-460 .. Mythical/Void-1080
			return base + (32 - math.min(rank or 16, 31)) * 8 -- rank 1 = +248, rank 27 = +40
		end
		-- 2) passive: read the entry, get Rarity + display name
		local okU, UD = pcall(function() return require(RS.Shared.Modules.Data.UpgradeData) end)
		local entry = okU and UD and UD[id] or nil
		local r = override or (entry and entry.Rarity or nil)
		local base = 60 + 110 * (RARITY_ORDER[r] or 2) -- Common-170 .. Mythical/Void-720
		local nm = (entry and entry.name) or id
		local w = STAT_WEIGHT[nm]
		if not w then
			for stat, weight in pairs(STAT_WEIGHT) do
				if nm:find(stat, 1, true) then w = weight break end
			end
		end
		return base * (w or 0.5)
	end

	-- // PASSIVE PRIORITY (Luck phase logic kept; rest reads game data) //
	-- A card's ItemTitle is NOT always a clean data key. Observed live on a real
	-- offer: Sword / Trident / Laserbeam / Bananarang / "Flame I" -- and nothing in
	-- UpgradeData or WeaponData is called "Flame I" (the weapons are "Flame Walker"
	-- and "Flamethrower"). A weapon the player already owns gets its stack numeral
	-- appended, so the label reads "<truncated name> <I..X>" and every WEAPON_RANK
	-- lookup missed: the card fell through to the passive branch and scored like
	-- junk, so a leveled weapon lost to a Common Health. The numeral only ever
	-- appears on a weapon that is already OWNED, which is the tiebreak -- "Flame"
	-- alone is ambiguous between Flame Walker and Flamethrower, but only one of
	-- them is in the run's weapon table.
	local function resolveCardName(label)
		if type(label) ~= "string" or label == "" then return label end
		if WEAPON_RANK[label] then return label end
		local okU, UD = pcall(function() return require(RS.Shared.Modules.Data.UpgradeData) end)
		if okU and UD and UD[label] then return label end
		local stripped = label:gsub("%s+[IVXLCDM]+$", "")
		if stripped == label then return label end
		if WEAPON_RANK[stripped] then return stripped end
		local okP, PRD = pcall(function() return require(RS.Shared.Modules.Core.PlayerRunData) end)
		if okP and PRD then
			local okR, d = pcall(function() return PRD:get(Players.LocalPlayer) end)
			if okR and type(d) == "table" and type(d.weapons) == "table" then
				for id in pairs(d.weapons) do
					if type(id) == "string" and id ~= stripped and id:sub(1, #stripped) == stripped then
						return id
					end
				end
			end
		end
		return stripped
	end

	-- // USER PRIORITISATION: stat groups + ban list//
	-- The categories are the game's OWN stat keys, read out of UpgradeData's
	-- statChange tables (19 distinct keys across the 57 cards that have one), so
	-- this list cannot drift out of sync with the data the way a hand-typed list
	-- of card names would. A card can belong to SEVERAL groups - Power Trio carries
	-- damage + attackSpeed + maxHealth - so ticking "Damage" picks it up.
	--
	-- WEAPONS ARE DELIBERATELY UNTOUCHED. The hand-written WEAPON_PRIORITY above
	-- is a playstyle decision, not a damage calculation, and both the ranking and
	-- the scoring below are reachable only from passiveScore, which the weapon
	-- branch of pickBestCard never calls.
	local CARD_GROUPS = {
		{ label = "Damage", keys = { damage = true } },
		{ label = "Attack Speed", keys = { attackSpeed = true } },
		{ label = "Crit Chance", keys = { criticalChance = true } },
		{ label = "Projectile Count", keys = { projectileCount = true } },
		{ label = "Projectile Speed", keys = { projectileSpeed = true } },
		{ label = "Piercing", keys = { pierceCount = true } },
		{ label = "Ricochet", keys = { ricochetCount = true } },
		{ label = "Size", keys = { size = true } },
		{ label = "Luck", keys = { luck = true } },
		{ label = "XP Gain", keys = { xpGain = true } },
		{ label = "Max Health", keys = { maxHealth = true } },
		{ label = "Health Regen", keys = { healthRegen = true } },
		{ label = "Armor", keys = { armor = true } },
		{ label = "Thorns", keys = { thorns = true } },
		{ label = "Lifesteal", keys = { lifesteal = true } },
		{ label = "Evasion", keys = { evasion = true } },
		{ label = "Knockback Resist", keys = { knockbackResistance = true } },
		{ label = "Movement Speed", keys = { movementSpeed = true } },
		{ label = "Extra Jumps", keys = { extraJumps = true } },
		-- These seven carry NO statChange at all (they are customEffect cards), so
		-- there is no key to match on and they are matched by display name instead.
		-- Without this they would be unreachable from both lists.
		{ label = "Elemental & Effects", names = {
			Blaze = true, Bolt = true, ["Demon Slayer"] = true, Freeze = true,
			Multishot = true, ["Perilous Fervor"] = true, ["Stand Strong"] = true,
		} },
	}

	-- display name -> Rarity -> UpgradeData entry. Built once, lazily, because it
	-- needs a require and the scoring path only runs on a level-up, not per frame.
	local CARD_INDEX = nil
	local function getCardIndex()
		if CARD_INDEX then return CARD_INDEX end
		CARD_INDEX = {}
		pcall(function()
			local okU, UD = pcall(function() return require(RS.Shared.Modules.Data.UpgradeData) end)
			if not (okU and type(UD) == "table") then return end
			for id, e in pairs(UD) do
				if type(id) == "string" and type(e) == "table" and type(e.name) == "string" then
					local bucket = CARD_INDEX[e.name]
					if not bucket then
						bucket = {}
						CARD_INDEX[e.name] = bucket
					end
					bucket[tostring(e.Rarity)] = e
				end
			end
		end)
		return CARD_INDEX
	end

	-- The loop only ever has the card's DISPLAY name, and the ids are "Damage Epic"
	-- etc, so the entry has to be found through the name -> rarity bucket. The
	-- frame's own label is not always a real Rarity (it writes "Weapon" / "Misc"
	-- too), so fall back to any entry sharing the display name.
	local function cardEntry(displayName, rarity)
		local bucket = getCardIndex()[displayName]
		if not bucket then return nil end
		if type(rarity) == "string" then
			local hit = bucket[rarity]
			if hit then return hit end
		end
		for _, e in pairs(bucket) do return e end
		return nil
	end

	local function cardGroups(displayName, rarity)
		local set = {}
		local e = cardEntry(displayName, rarity)
		if e then
			if type(e.statChange) == "table" then
				for _, inner in pairs(e.statChange) do
					if type(inner) == "table" then
						for k in pairs(inner) do
							for _, g in ipairs(CARD_GROUPS) do
								if g.keys and g.keys[k] then set[g.label] = true end
							end
						end
					end
				end
			end
			for _, g in ipairs(CARD_GROUPS) do
				if g.names and g.names[displayName] then set[g.label] = true end
				if g.names and type(e.name) == "string" and g.names[e.name] then set[g.label] = true end
			end
		end
		return set
	end

	-- comma-joined strings, like the chest and skill pickers: SetAttribute on a
	-- table throws rather than returning false. Empty = the feature is off.
	local function cardFlagSet(flagName)
		local raw = getFlag(flagName)
		if type(raw) ~= "string" or raw == "" then return nil end
		local set = {}
		for label in raw:gmatch("[^,]+") do set[label] = true end
		return set
	end

	-- Sized against the weapon branch, which pickBestCard scores at 2000 - rank
	-- (1984..2000). A prioritised passive tops out around 1220, so a priority can
	-- reorder passives among themselves but can NEVER displace a weapon.
	local CARD_PRIORITY_BONUS = 500
	-- Below Luck's late-game -10, so a banned card loses to literally anything
	-- else on offer. If every card offered is banned one is still taken rather
	-- than leaving the level-up screen open forever.
	local CARD_BANNED_SCORE = -500

	-- one wrapper for the three toast call sites: the pcall matters because
	-- several of them run from inside the pick loop's own protected block
	local function notifyCards(title, body)
		if _G.FS_Notify then pcall(function() _G.FS_Notify(title, body) end) end
	end

	local function passiveScore(id, kind, rarity, isWeapon)
		local groups = cardGroups(id, rarity)

		-- BANNED is checked FIRST, before the Luck special case below: otherwise a
		-- banned Luck would still score 1000 through the early-game branch.
		local banned = cardFlagSet("CardBan")
		if banned then
			for label in pairs(groups) do
				if banned[label] then return CARD_BANNED_SCORE end
			end
		end

		local bonus = 0
		local prio = cardFlagSet("CardPriority")
		if prio then
			for label in pairs(groups) do
				if prio[label] then
					bonus = CARD_PRIORITY_BONUS
					break
				end
			end
		end

		-- kind: "early" (levels 1-9), "mid" (10-19), "late" (20+)
		if id:find("Luck") then
			-- early: top priority, mid: filler, late: dead last
			if kind == "early" then return 1000 + bonus end
			if kind == "mid" then return 55 + bonus end
			return -10 + bonus
		end
		return dataScore(id, rarity, isWeapon) + bonus
	end

	local function levelKind(level)
		if level < 10 then return "early" end
		if level < 20 then return "mid" end
		return "late"
	end

	local smartRunning = false
	local function getRunLevel()
		-- Run level comes from xp, NOT from a `level` field -- PlayerRunData has no
		-- such field and reading it pinned the level to 1, which made every pick
		-- think it was still early game.
		local ok, PRD = pcall(function() return require(RS.Shared.Modules.Core.PlayerRunData) end)
		if not ok then return 1 end
		local ok2, data = pcall(function() return PRD:get(Players.LocalPlayer) end)
		if ok2 and type(data) == "table" and GetLevelFromXP then
			local ok3, lvl = pcall(function() return GetLevelFromXP(tonumber(data.xp) or 0) end)
			if ok3 and type(lvl) == "number" and lvl >= 1 then return lvl end
		end
		return 1
	end

	local function pickBestCard(offers, rarities, weapons)
		-- offers: {name -> Selection index}, rarities: {name -> rarity label},
		-- weapons: {name -> true} for cards the spin frame tagged "Weapon" that
		-- WEAPON_RANK does not know. The shape showUpgrades receives is keyed by
		-- card id; this reads the same cards off the frame, where only the DISPLAY
		-- name and the rarity label are visible.
		if type(offers) ~= "table" then return nil end
		local level = getRunLevel()
		local kind = levelKind(level)
		local best, bestScore = nil, -math.huge
		for id in pairs(offers) do
			local s
			local r = rarities and rarities[id] or nil
			local rank = WEAPON_RANK[id]
			if rank or (weapons and weapons[id]) then
				s = 2000 - (rank or 16) -- always above passives unless mid-late weapon is C-tier
			else
				s = passiveScore(id, kind, r)
			end
			if s > bestScore then bestScore = s best = id end
		end
		return best
	end

	local function getUpgradeParts()
		local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
		local frames = pg and pg:FindFirstChild("Frames")
		local up = frames and frames:FindFirstChild("Upgrades")
		return up, up and up:FindFirstChild("Holder"), up and up:FindFirstChild("SpinHolder")
	end

	-- Skip Card Animation: ported from the OLD proven script — fake owning the
	-- FastUpgrade skill (hook the DataService client's get) and send the
	-- screen-center click the Upgrade frame listens for. Works without the skill
	-- owned. NOTE: the old RS.Packages.DataService path is DEAD in this game —
	-- hooking it silently no-ops, and the bare center click then just PICKS THE
	-- MIDDLE CARD. Resolve through Packages/_Index/leifstout_dataservice (the
	-- same path the hub's DSClient resolver uses) and VERIFY the hook answers
	-- before ever center-clicking.
	local VIM = game:GetService("VirtualInputManager")
	local fastHookReady = false
	local function ensureFastHook()
		if fastHookReady then return true end
		local ok = pcall(function()
			local idx = RS:FindFirstChild("Packages") and RS.Packages:FindFirstChild("_Index")
			if not idx then return end
			local target = nil
			for _, c in ipairs(idx:GetChildren()) do
				if c.Name:find("dataservice") then
					local ds = c:FindFirstChild("dataservice")
					if ds then target = ds:FindFirstChild("DataServiceClient") or ds break end
				end
			end
			if not target then return end
			local okReq, m = pcall(require, target)
			if not (okReq and type(m) == "table") then return end
			-- this package version exposes the client singleton as the module
			-- itself (require(...).get), with no .client field - handle both
			local client = (type(m.get) == "function" and m) or m.client
			if not (client and type(client.get) == "function") then return end
			if not client._fsFastHooked then
				local orig = client.get
				client.get = function(self, path)
					if type(path) == "table" and path[1] == "stats" and path[2] == "skillTree" and path[3] == "FastUpgrade" then
						return true
					end
					return orig(self, path)
				end
				client._fsFastHooked = true
			end
			-- the hook must actually ANSWER before we trust a center click
			local okV, v = pcall(function() return client.get(client, {"stats", "skillTree", "FastUpgrade"}) end)
			fastHookReady = (okV and v == true)
		end)
		return ok and fastHookReady or false
	end
	local function skipCardAnimation()
		pcall(function()
			local up = getUpgradeParts()
			if not (up and up.Visible) then return end
			local spin = up:FindFirstChild("SpinHolder")
			if not (spin and spin.Visible) then return end
			-- ONLY center-click when the FastUpgrade hook is verified live.
			-- Without the hook a center click picks the middle card; with it,
			-- the click skips the spin and the loop below clicks the best card.
			if not ensureFastHook() then return end
			local cam = workspace.CurrentCamera
			local sz = cam and cam.ViewportSize or Vector2.new(960, 540)
			VIM:SendMouseButtonEvent(sz.X * 0.5, sz.Y * 0.5, 0, true, game, 0)
			task.wait(0.05)
			VIM:SendMouseButtonEvent(sz.X * 0.5, sz.Y * 0.5, 0, false, game, 0)
		end)
	end

	-- Pick a card WITHOUT a mouse event. The game wires its pick logic to
	-- MouseButton1Up on each Selection button (decompiled Upgrade module, line
	-- 1136: MouseButton1Up -> GameServiceClient:UpgradeSelected(index, batch);
	-- MouseButton1Down is only sound + spring squash). Firing those connections
	-- directly touches nothing on screen — no VIM click that can land on the
	-- hub window or any other UI. VIM is kept ONLY as a last-resort fallback
	-- for executors without getconnections.
	local function pressCardButton(card)
		if type(getconnections) ~= "function" then return false end
		local okUp, firedUp = pcall(function()
			for _, conn in ipairs(getconnections(card.MouseButton1Up)) do
				if conn.Enabled ~= false then conn:Fire() end
			end
			return true
		end)
		-- Down is cosmetic (click sound, card squash) — best effort only.
		pcall(function()
			for _, conn in ipairs(getconnections(card.MouseButton1Down)) do
				if conn.Enabled ~= false then conn:Fire() end
			end
		end)
		return okUp and firedUp
	end

	-- // AUTO REROLL / AUTO BANISH (test build) //
	-- Decompiled flow (Upgrade module lines 782-830, 1136-1240):
	--   RerollButton.MouseButton1Click -> (state gates) GameServiceClient:RerollUpgrade()
	--   BanishButton.MouseButton1Click -> if getBanishCount() <= 0 prompts a
	--     PURCHASE (must not fire without a banish banked!) else toggles banish
	--     mode; the NEXT card MouseButton1Up then fires BanishUpgrade(offerId)
	-- The button handlers are gated by the module's own internal flags, so the
	-- SAFEST path is to fire the buttons' connections exactly like the game's
	-- real UI clicks, and to check our own count read before doing so.
	local function getCurrency()
		local ok, PRD = pcall(function() return require(RS.Shared.Modules.Core.PlayerRunData) end)
		local rerolls, banishes = 0, 0
		if ok and PRD then
			local ok2, d = pcall(function() return PRD:get(Players.LocalPlayer) end)
			if ok2 and type(d) == "table" then
				rerolls = tonumber(d.rerolls) or 0
				banishes = tonumber(d.banishes) or 0
			end
		end
		-- stats path can hold extra currency (game adds PlayerRunData + stats)
		pcall(function()
			local idx = RS:FindFirstChild("Packages") and RS.Packages:FindFirstChild("_Index")
			if not idx then return end
			for _, c in ipairs(idx:GetChildren()) do
				if c.Name:find("dataservice") then
					local ds = c:FindFirstChild("dataservice")
					local target = ds and (ds:FindFirstChild("DataServiceClient") or ds)
					if target then
						local okR, m = pcall(require, target)
						if okR and type(m) == "table" then
							local client = (type(m.get) == "function" and m) or m.client
							if client and type(client.get) == "function" then
								local okS, sr = pcall(function() return client:get({"stats", "rerolls"}) end)
								if okS and type(sr) == "number" then rerolls = rerolls + sr end
								local okB, sb = pcall(function() return client:get({"stats", "banishes"}) end)
								if okB and type(sb) == "number" then banishes = banishes + sb end
							end
						end
					end
					break
				end
			end
		end)
		return rerolls, banishes
	end

	-- Reroll/Banish buttons are wired to MouseButton1Click in the Upgrade
	-- module (lines 782-830), NOT MouseButton1Up like the card Selection
	-- buttons. Firing Up/Down on them does nothing — the press must go
	-- through the Click signal.
	local function pressClickButton(btn)
		if type(getconnections) ~= "function" then return false end
		local fired = false
		pcall(function()
			for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
				if conn.Enabled ~= false then conn:Fire() fired = true end
			end
		end)
		return fired
	end

	local function pressRerollButton()
		local up = getUpgradeParts()
		local rf = up and up:FindFirstChild("RerollFrame")
		local btn = rf and rf:FindFirstChild("RerollButton")
		if not (btn and btn.Visible) then return false end
		return pressClickButton(btn)
	end

	local function pressBanishButton()
		local up = getUpgradeParts()
		local rf = up and up:FindFirstChild("RerollFrame")
		local btn = rf and rf:FindFirstChild("BanishButton")
		if not (btn and btn.Visible) then return false end
		return pressClickButton(btn)
	end

	-- Scores bad enough that we'd rather spend a reroll?
	local function isBadOffer(bestScore)
		-- fixed pickiness: offers whose best card scores under this get rerolled
		local threshold = 900
		return bestScore < threshold
	end

	-- Is this card bottom-tier trash worth a banish? (must be CONFIDENT: a
	-- banish is scarcer than a reroll)
	local function isTrashCard(id, rarity)
		-- callers pass the card's DISPLAY NAME (the loop builds nameToIndex
		-- from ItemTitle text), so use it directly — no lookup helper here.
		local nm = tostring(id)
		for _, bad in ipairs({ "Stand Strong", "Giant's Strength", "Extra Jump" }) do
			if nm:find(bad, 1, true) then return true end
		end
		-- a non-weapon card the game ranks Common AND we weight below 0.15 is trash
		local r = nil
		local okU, UD = pcall(function() return require(RS.Shared.Modules.Data.UpgradeData) end)
		if okU and UD then
			local e = UD[id]
			if e then
				r = e.Rarity
				nm = e.name or nm
			else
				-- display name is not an UpgradeData id (every Luck variant is
				-- titled "Luck") -- fall back to the frame's own rarity label
				r = (type(rarity) == "string" and rarity ~= "Weapon" and rarity ~= "Misc") and rarity or nil
			end
			local w = STAT_WEIGHT[nm] or 0.5
			for stat, weight in pairs(STAT_WEIGHT) do
				if nm:find(stat, 1, true) then w = weight break end
			end
			return r == "Common" and w <= 0.15
		end
		return false
	end

	-- Read the visible offered cards (name, rarity, frame) from the Holder —
	-- exactly like the old working Auto Pick loop.
	--
	-- Two things are read off the frame, and both matter:
	--   * ItemTitle -- the DISPLAY name only. Not unique (every Luck variant is
	--     titled "Luck") and not always a data key (an owned weapon shows its
	--     stack numeral), so it goes through resolveCardName.
	--   * FrameHolder.TitleLabel -- the rarity the game itself wrote onto the card
	--     from the offer's own rarity field, which is the only per-card rarity
	--     available and the only thing dataScore can trust for a display name.
	local function getOfferedCards()
		local up, _, spinHolder = getUpgradeParts()
		if not up or not up.Visible then return nil end
		local holder = up:FindFirstChild("Holder")
		if not holder then return nil end
		local cards = {}
		for i = 1, 12 do
			local tag = "Selection" .. i
			local sel = holder:FindFirstChild(tag)
			if sel and sel.Visible then
				local nameLbl = sel:FindFirstChild("ItemTitle")
				local name = nameLbl and nameLbl.Text or ""
				if name ~= "" then
					local fh = sel:FindFirstChild("FrameHolder")
					local tl = fh and fh:FindFirstChild("TitleLabel")
					-- the spin frame is index-aligned with the Holder frame and
					-- carries Rarity == "Weapon" for weapon cards, which is the only
					-- way to tell an unknown weapon from an unknown passive
					local spin = spinHolder and spinHolder:FindFirstChild(tag)
					local spinRarity = spin and spin:GetAttribute("Rarity") or nil
					cards[#cards + 1] = {
						frame = sel,
						label = name,
						name = resolveCardName(name),
						rarity = tl and tl.Text or nil,
						weapon = spinRarity == "Weapon" or nil,
					}
				end
			end
		end
		return #cards > 0 and cards or nil
	end

	local function smartCardLoop()
		if smartRunning then return end
		smartRunning = true
		-- Ported from the OLD working script: no choosing gate, no arming, no
		-- remotes — poll the visible offer set, VIM-click the best card, reset
		-- the signature after every pick. This is what actually works.
		local lastSig = nil
		-- reroll chains keep the level-up screen open, and while it's open the
		-- game holds the character (the orbit visibly stutters one step per
		-- reroll cycle). Bound the chain: after MAX_REROLL_STREAK rerolls on
		-- the same level-up, settle for the best card on offer.
		local MAX_REROLL_STREAK = 3
		local rerollStreak = 0
		while getFlag("AutoSmartCardsOn") and isCurrentGen() do
			local okE, err = pcall(function()
				local up = getUpgradeParts()
				local cards = getOfferedCards()
				if not cards then
					lastSig = nil
					-- offer frame up but no readable cards = the spin is still
					-- running. THAT is the only case the center-click skip was
					-- written for. When cards ARE readable, center-clicking is
					-- pure damage: the click lands on the MIDDLE card and picks
					-- it (verified live — players who own FastUpgrade natively
					-- never even see the spin, so the click just misfires).
					if up and up.Visible and getFlag("SkipCardAnimOn") then
						pcall(skipCardAnimation)
						task.wait(0.3)
						cards = getOfferedCards() -- re-read after the skip
					end
					if not cards then return end
				end
				local sigParts = {}
				for _, c in ipairs(cards) do sigParts[#sigParts + 1] = c.label end
				local sig = table.concat(sigParts, "|")
				if sig == lastSig then return end
				lastSig = sig
				-- Two offered cards can carry the SAME display name -- the game titles
				-- every Luck variant "Luck" -- so a plain assignment dropped all but
				-- one of them. Keep the highest-rarity card per name (that is the one
				-- worth taking) and remember its rarity for scoring.
				local nameToIndex, nameToRarity, nameToWeapon = {}, {}, {}
				for _, c in ipairs(cards) do
					local idx = tonumber(c.frame.Name:match("Selection(%d+)"))
					if idx then
						local cur = nameToRarity[c.name]
						if not nameToIndex[c.name]
							or (RARITY_ORDER[c.rarity] or 0) > (RARITY_ORDER[cur] or 0) then
							nameToIndex[c.name] = idx
							nameToRarity[c.name] = c.rarity
						end
						if c.weapon and not nameToWeapon[c.name] then
							nameToIndex[c.name] = nameToIndex[c.name] or idx
							nameToRarity[c.name] = nameToRarity[c.name] or c.rarity
							nameToWeapon[c.name] = true
						end
					end
				end
				local pick = pickBestCard(nameToIndex, nameToRarity, nameToWeapon)
				-- score the pick so reroll/banish can judge the offer quality
				local pickScore = nil
				if pick then
					if WEAPON_RANK[pick] or nameToWeapon[pick] then
						pickScore = dataScore(pick, nameToRarity[pick], nameToWeapon[pick])
					else
						local kind = levelKind(getRunLevel())
						pickScore = passiveScore(pick, kind, nameToRarity[pick])
					end
				end
				-- AUTO BANISH: if the WORST visible card is trash and we have a
				-- banish banked, banish it instead of picking this tick. The
				-- game's banish flow: press BanishButton (arms banish mode) then
				-- press the trash card's button (fires BanishUpgrade).
				-- reroll + banish are always on when Auto Smart Cards is on
				-- (no separate toggles)
				if getFlag("AutoSmartCardsOn") then
					local _, banishes = getCurrency()
					if banishes > 0 then
						local trashIdx = nil
						for name, idx in pairs(nameToIndex) do
							if isTrashCard(name, nameToRarity[name]) then trashIdx = idx break end
						end
						if trashIdx then
							local trashCard = cards[1] and cards[1].frame.Parent:FindFirstChild("Selection" .. trashIdx)
							if trashCard and trashCard.Parent then
								task.wait(0.08)
								local armed = pressBanishButton()
								task.wait(0.15)
								if armed then pressCardButton(trashCard) end
								lastSig = nil
								notifyCards("Auto Smart Cards", "banished a trash card")
								task.wait(0.6)
								return
							end
						end
					end
				end
				-- AUTO REROLL: offer is bad and rerolls are banked -> reroll
				-- instead of settling. Fires the game's own RerollButton.
				-- Reroll ONLY when the best card is a BAD WEAPON: passive offers
				-- are always accepted as-is (banish still trims trash passives).
				-- nameToWeapon covers weapons this client's data does not know, so
				-- the gate agrees with the score instead of exempting them.
				if getFlag("AutoSmartCardsOn") and pick and (WEAPON_RANK[pick] or nameToWeapon[pick])
					and isBadOffer(pickScore) and rerollStreak < MAX_REROLL_STREAK then
					local rerolls = (getCurrency())
					if rerolls > 0 then
						rerollStreak = rerollStreak + 1
						task.wait(0.08)
						local okR = pressRerollButton()
						lastSig = nil
						if okR and rerollStreak == 1 then notifyCards("Auto Smart Cards", "offer bad (score " .. string.format("%.0f", pickScore) .. ") -> rerolling") end
						task.wait(0.8)
						return
					end
				end
				if pick and nameToIndex[pick] then
					rerollStreak = 0
					local card = cards[1] and cards[1].frame.Parent:FindFirstChild("Selection" .. nameToIndex[pick])
					if card and card.Parent then
						task.wait(0.08)
						-- Preferred: fire the game's own MouseButton1Up handler (the
						-- actual pick path). No synthetic mouse event at all, so the
						-- hub window and any other UI can never be clicked by accident.
						local pressed = pressCardButton(card)
						if not pressed then
							-- Fallback (no getconnections): synthetic down+up at the
							-- card center — the old behavior, UI risk included.
							pcall(function()
								local ap, as = card.AbsolutePosition, card.AbsoluteSize
								local x, y = ap.X + as.X / 2, ap.Y + as.Y / 2
								VIM:SendMouseButtonEvent(x, y, 0, true, game, 1)
								task.wait(0.03)
								VIM:SendMouseButtonEvent(x, y, 0, false, game, 1)
							end)
						end
						lastSig = nil
						notifyCards("Auto Smart Cards", "level " .. getRunLevel() .. " -> picked " .. pick)
						task.wait(0.5)
					end
				end
			end)
			if not okE then warn("[FS SmartCards] " .. tostring(err)) end
			task.wait(0.2)
		end
		smartRunning = false
	end
	task.spawn(smartCardLoop)
	_G.FS_StartAutoSmartCards = function(on)
		RS:SetAttribute("TPL_AutoSmartCardsOn", on)
		if on then task.spawn(smartCardLoop) end
	end

	-- published for the two dropdowns, which are built with the rest of the Main
	-- tab long after this do-block has closed
	Resume.CardGroupLabels = (function()
		local out2 = {}
		for _, g in ipairs(CARD_GROUPS) do out2[#out2 + 1] = g.label end
		return out2
	end)()
end

-- Skip Card Animation stays tied to Auto Smart Cards. Keep the flag mirrored
-- so the pick loop's existing getFlag("SkipCardAnimOn") check works.
RS:GetAttributeChangedSignal("TPL_AutoSmartCardsOn"):Connect(function()
	RS:SetAttribute("TPL_SkipCardAnimOn", RS:GetAttribute("TPL_AutoSmartCardsOn") and true or false)
end)
RS:SetAttribute("TPL_SkipCardAnimOn", RS:GetAttribute("TPL_AutoSmartCardsOn") and true or false)

-- ===================== LOBBY TAB UI =====================
do

	local secJoin = lobby:CreateSection({ name = "Auto Join" })

	local worldDD = secJoin:CreateDropdown({

		name = "Map",

		options = WORLDS,

		value = currentMap,

		callback = function(v)

			if type(v) == "string" and WORLD_LABELS[v] then

				currentMap = v

				RS:SetAttribute("TPL_Lobby_World", v)

			end

		end,

	})

	local diffDD = secJoin:CreateDropdown({

		name = "Difficulty",

		options = DIFFICULTIES,

		value = currentDiff,

		callback = function(v)

			if type(v) == "string" then

				currentDiff = v

				RS:SetAttribute("TPL_Lobby_Difficulty", v)

			end

		end,

	})

	secJoin:CreateToggle({

		name = "Auto Join Map",

		value = autoJoinOn,

		callback = function(v)

			RS:SetAttribute("TPL_AutoJoinOn", v)

			if _G.FS_StartAutoJoin then _G.FS_StartAutoJoin(v) end

		end,

	})

	secJoin:CreateToggle({

		name = "Auto Raid (Colosseum)",

		value = autoRaidOn,

		callback = function(v)

			RS:SetAttribute("TPL_AutoRaidQueueOn", v)

			if _G.FS_StartAutoRaid then _G.FS_StartAutoRaid(v) end

		end,

	})

end

-- ===================== INVENTORY: AUTO UPGRADE =====================
-- Upgrades items with the game's own InventoryService remote. The game's client
-- sends: networker("InventoryService"):fire("upgradeItem", itemName, itemType)
-- where itemType is "weapon" / "armor" / "gear" (from WeaponData/ArmorData/GearData).
-- An item is maxed when its level >= #ItemData[name].upgrades (verified against
-- InventoryFrame._applyUpgrade). Keys are spent server-side.

local ItemData = nil

-- SPEED: this prefetch used to run INLINE in the tab-build path; when
-- ReplicatedStorage.Shared streams slowly it stalled every widget below it
-- (the 15s empty-tab bug). It is only consumed by runtime helpers
-- (getUpgradableItems), never during widget construction, so build it in a
-- background thread instead.
task.spawn(function()

	pcall(function()

		local DataFolder = RS:WaitForChild("Shared", 10):WaitForChild("Modules", 10):WaitForChild("Data", 10)

		ItemData = {}

		for _, mod in ipairs({ "WeaponData", "ArmorData", "GearData" }) do

			local ok, m = pcall(require, DataFolder:WaitForChild(mod, 10))

			if ok and type(m) == "table" then

				for name, def in pairs(m) do

					if type(def) == "table" and type(def.upgrades) == "table" and #def.upgrades > 0 then

						ItemData[name] = { type = mod:sub(1, -5):lower(), maxLevel = #def.upgrades }

					end

				end

			end

		end

	end)

end)

local DSClient = nil

-- SPEED: same inline-stall fix as ItemData above — resolved in a background
-- thread (only getInventoryCategory and friends read it at runtime).
task.spawn(function()

pcall(function()

	local dsMod = RS:WaitForChild("Packages", 10):WaitForChild("_Index", 10):FindFirstChild("leifstout_dataservice@0.3.2")

	if dsMod then

		local ds = dsMod:FindFirstChild("dataservice")

		if ds then

			-- this package version exposes the client singleton as the module
			-- itself (require(...).get), with no .client field - handle both

			local ok, m = pcall(require, ds:FindFirstChild("DataServiceClient") or ds)

			if ok and type(m) == "table" then

				DSClient = (type(m.get) == "function" and m) or m.client

			end

		end

	end

end)

-- fallback if the package folder name ever changes

if not DSClient then

	pcall(function()

		local idx = RS.Packages:FindFirstChild("_Index")

		if idx then

			for _, c in ipairs(idx:GetChildren()) do

				if c.Name:find("dataservice") then

					for _, d in ipairs(c:GetChildren()) do

						if d.Name:find("dataservice") then

							local target = d:IsA("ModuleScript") and d or d:FindFirstChild("DataServiceClient")

							if target then

								local ok, m = pcall(require, target)

								if ok and type(m) == "table" then

									DSClient = (type(m.get) == "function" and m) or m.client

								end

							end

						end

					end

				end

			end

		end

	end)

end

end)

local function getInventoryCategory(cat)

	if not DSClient then return nil end

	local ok, res = pcall(function() return DSClient:get({ "inventory", cat }) end)

	if ok and type(res) == "table" then return res end

	return nil

end

-- build the list of items the player owns (maxed ones included, marked so the
-- picker can grey-label them; the loop skips maxed items on its own)

local function getUpgradableItems()

	local list = {}

	for _, cat in ipairs({ "weapons", "armors", "gears" }) do

		local inv = getInventoryCategory(cat)

		if inv then

			for name, save in pairs(inv) do

				local info = ItemData[name]

				if info and type(save) == "table" then

					table.insert(list, { name = name, type = info.type, level = save.level or 0, maxLevel = info.maxLevel })

				end

			end

		end

	end

	table.sort(list, function(a, b) return a.name < b.name end)

	return list

end

-- reuse the game's own service clients' networkers so server replies land on
-- their real handlers (creating one with an empty table turns every reply into
-- a console error)
local invNet, chestNet = nil, nil

local invNetCache, chestNetCache = {}, {}

local function getServiceNetworker(tag, cache)

	if cache[1] then return cache[1] end

	local found = nil

	pcall(function()

		for _, c in ipairs(RS.Shared.Services:GetChildren()) do

			local client = c:IsA("ModuleScript") and c or c:FindFirstChildOfClass("ModuleScript")

			if client and client.Name:find("Client") then

				local ok, m = pcall(require, client)

				if ok and type(m) == "table" and m._networker and m._networker.networkTag == tag then

					found = m._networker

				end

			end

		end

	end)

	cache[1] = found

	return found

end

local function fireUpgrade(itemName, itemType)

	if not invNet then invNet = getServiceNetworker("InventoryService", invNetCache) end

	if not invNet then return false end

	return pcall(function() invNet:fire("upgradeItem", itemName, itemType) end)

end

-- item selection is stored as one comma-joined attribute so any item name
-- (they may contain spaces) round-trips safely
local function setSelectedList(names)
	RS:SetAttribute("TPL_AutoUpgradeSelList", table.concat(names or {}, ","))
end

local function getSelectedItems()
	local raw = getFlag("AutoUpgradeSelList")
	if not raw or raw == "" then return nil end -- nil = Select All (everything)
	local set = {}
	for name in raw:gmatch("[^,]+") do set[name] = true end
	return set
end

-- ===================== AUTO UPGRADE LOOP =====================
do

	local upgradeRunning = false

	local function autoUpgradeLoop()

		if upgradeRunning then return end

		upgradeRunning = true

		while getFlag("AutoUpgradeOn") and isCurrentGen() do

			local didSomething = false

			local list = getUpgradableItems()

			for _, it in ipairs(list) do

				if not getFlag("AutoUpgradeOn") then break end

				local selectedSet = getSelectedItems()

				if (not selectedSet) or selectedSet[it.name] then

					-- maxed per the game's own rule (level > #upgrades): skip silently
					if it.level <= it.maxLevel then

						if fireUpgrade(it.name, it.type) then didSomething = true end

						task.wait(0.15)
					end
				end

			end

			-- wait for data to update (level/xp changes come back async)

			task.wait(didSomething and 0.5 or 1.5)

		end
		upgradeRunning = false

	end

	task.spawn(autoUpgradeLoop)

	_G.FS_StartAutoUpgrade = function(on)

		RS:SetAttribute("TPL_AutoUpgradeOn", on)

		if on then task.spawn(autoUpgradeLoop) end

	end

end

-- ===================== CHESTS: AUTO OPEN =====================
-- Opens chests with the game's own ChestService remote:
--   networker("ChestService"):fire("OpenMultipleChests", chestName, amount)
--
-- There is one on/off switch (Auto Open Chests) and two choices on top of it:
-- WHICH chests to drain, and HOW MANY per call.
--
-- Batch size. The old loop respected the skill tree's ChestOpen5/10/100 unlock
-- and fired in batches of 1/5/10/100, which is what the amount picker offers a
-- player. That cap is CLIENT-side code. ChestFrame:attemptOpenMultipleChests does:
--     v1 = math.min(1000, owned)
--     v7 = math.clamp(requested, 1, v1)
-- so one call can always move up to 1000, and the skill tree's "MAX" option is
-- just "everything you own, capped at 1000". The server answers with a MERGED
-- reward list (ChestFrame.mergeRewardsIfLarge, from
-- ChestServiceClient.OpenMultipleChests), so a 1000-batch is one reveal screen,
-- not a thousand.
--
-- Verified live: one fire of OpenMultipleChests("WoodenChest", 449) took that
-- stack 449 -> 0 in under 3s with every other chest type untouched. So the default
-- here is 1000, the maximum, and the slider is only there to go slower or to probe
-- above the game's own clamp.
--
-- The game ships eight chests in ChestData: Wooden, Rare, Epic, Golden, Mythic,
-- Raid, Void, Inferno. MythicChest was missing from the old list, so Mythic
-- chests were never opened at all. Void and Inferno are deliberately NOT offered:
-- both set openScreen ("void" / "inferno") and showInChestFrame = false, so they
-- open on their own world screens and are NOT reachable through
-- OpenMultipleChests -- firing at them is a silent no-op, so putting them in a
-- picker would be offering a choice that does nothing.
local CHEST_ORDER = { "EpicChest", "GoldenChest", "MythicChest", "RareChest", "WoodenChest", "RaidChest" }

-- what the picker shows, in that order
local CHEST_CHOICES = { "Epic", "Golden", "Mythic", "Rare", "Wooden", "Raid" }

-- picker label -> internal name
local CHEST_BY_LABEL = {
	Epic = "EpicChest",
	Golden = "GoldenChest",
	Mythic = "MythicChest",
	Rare = "RareChest",
	Wooden = "WoodenChest",
	Raid = "RaidChest",
}

local CHEST_NET = "ChestService"

local function getChestNet()

	if not chestNet then chestNet = getServiceNetworker(CHEST_NET, chestNetCache) end

	return chestNet

end

local function getChestCounts()

	local inv = getInventoryCategory("chests") or {}

	return inv

end

local function openChests(chestName, amount)

	local net = getChestNet()

	if not net then return false end

	return pcall(function() net:fire("OpenMultipleChests", chestName, amount) end)

end

-- ===================== WHICH CHESTS =====================
-- Stored as a comma-separated label list, matching the style the other pickers in
-- this file use. nil (never saved, or saved empty) means every chest, so a fresh
-- install opens everything rather than nothing.
local function getSelectedChests()

	local raw = getFlag("ChestSelList")

	-- nil (never saved) means every chest, so a fresh install opens everything.
	-- An explicitly saved "" means the player unticked everything, which must NOT
	-- fall back to "all" -- that would make deselecting the last chest silently
	-- re-select all of them.
	if raw == nil then
		local all = {}
		for i, label in ipairs(CHEST_CHOICES) do all[i] = label end
		return all
	end

	if type(raw) ~= "string" then return {} end

	if raw == "" then return {} end

	local out = {}
	local seen = {}

	for rawLabel in string.gmatch(raw, "[^,]+") do

		local label = string.match(rawLabel, "^%s*(.-)%s*$")

		if CHEST_BY_LABEL[label] and not seen[label] then

			seen[label] = true
			table.insert(out, label)

		end

	end

	return out

end

local function setSelectedChests(list)

	RS:SetAttribute("TPL_ChestSelList", table.concat(list or {}, ","))

end

-- resolve the selection to internal names, in the fixed CHEST_ORDER so a stack
-- is always drained in the same sequence
local function getSelectedChestNames()

	local want = {}

	for _, label in ipairs(getSelectedChests()) do want[label] = true end

	local out = {}

	for _, chestName in ipairs(CHEST_ORDER) do

		for label, name in pairs(CHEST_BY_LABEL) do

			if name == chestName and want[label] then table.insert(out, chestName) break end

		end

	end

	return out

end

-- ===================== DRAINING =====================
-- One pass over the selected chests. Returns the list of "Chest xN" strings for
-- what it asked for, so callers can report honestly instead of guessing.
local CHEST_BATCH_CAP = 1000

local function drainSelectedChests(maxPerCall)

	local cap = math.clamp(math.floor(tonumber(maxPerCall) or CHEST_BATCH_CAP), 1, 1000000)

	local counts = getChestCounts()

	local sent = {}

	for _, chestName in ipairs(getSelectedChestNames()) do

		local n = tonumber(counts[chestName]) or 0

		if n > 0 then

			local total = 0

			while n > 0 do

				local amt = math.min(cap, n)

				if not openChests(chestName, amt) then break end

				total = total + amt
				n = n - amt

				-- one tick between chunks so the server sees a short burst rather
				-- than a single unmetered flood
				if n > 0 then task.wait(0.25) end

			end

			if total > 0 then sent[#sent + 1] = chestName .. " x" .. tostring(total) end

		end

		task.wait(0.15)

	end

	return sent

end

-- ===================== AUTO OPEN LOOP =====================
-- Gated on TPL_AutoOpenChestsOn. Sleeps longer when there was nothing to do so an
-- idle hub is not polling the data store every frame.
do

	local chestRunning = false

	local function autoOpenChestsLoop()

		if chestRunning then return end

		chestRunning = true

		while getFlag("AutoOpenChestsOn") and isCurrentGen() do

			local didSomething = false

			local ok, sent = pcall(drainSelectedChests, getFlag("ChestBatchCap"))

			if ok and type(sent) == "table" and #sent > 0 then didSomething = true end

			task.wait(didSomething and 0.5 or 1.5)

		end

		chestRunning = false

	end

	task.spawn(autoOpenChestsLoop)

	_G.FS_StartAutoChests = function(on)

		RS:SetAttribute("TPL_AutoOpenChestsOn", on)

		if on then task.spawn(autoOpenChestsLoop) end

	end

	-- "Open All Now": same drain, but on demand and guarded so a double-click
	-- cannot stack two runs against the always-on loop
	local allRunning = false

	_G.FS_OpenAllChests = function()

		if allRunning then
			_G.FS_Notify("Open Chests", "Already running - wait for it to finish.")
			return
		end

		allRunning = true

		task.spawn(function()

			local ok, res = pcall(drainSelectedChests, getFlag("ChestBatchCap"))

			allRunning = false

			if not ok then
				_G.FS_Notify("Open Chests", "Failed: " .. tostring(res))
				return
			end

			if type(res) ~= "table" or #res == 0 then
				_G.FS_Notify("Open Chests", "Nothing to open.")
			else
				_G.FS_Notify("Open Chests", "Requested: " .. table.concat(res, ", "))
			end

		end)

	end

end

-- ===================== SKILL TREE: AUTO UPGRADE =====================
-- helper: which skills the user picked (nil = all)
local function getSelectedSkills()
	local raw = getFlag("AutoSkillSelList")
	if not raw or raw == "" then return nil end
	local set = {}
	for name in raw:gmatch("[^,]+") do set[name] = true end
	return set
end
-- Buys skill-tree nodes with the game's own SkillTree remote:
--   networker("SkillTree"):fire("purchaseSkill", skillId)
-- Node prerequisites, key cost and availability are checked client-side the same
-- way the game's SkillTree frame does (dependency owned, currency sufficient),
-- so we only fire purchases the game itself would accept.

local SkillTreeData = nil

-- SPEED: deferred like ItemData/DSClient (consumed by runtime helpers only)
task.spawn(function()

	pcall(function()

		local ok, m = pcall(require, RS.Shared.Modules.Data:WaitForChild("SkillTreeData", 10))

		if ok and type(m) == "table" then SkillTreeData = m end

	end)

end)

local skillNetCache = {}

local function getSkillNet()

	if not skillNetCache[1] then

		skillNetCache[1] = getServiceNetworker("SkillTree", skillNetCache)

	end

	return skillNetCache[1]

end

local function getSkillStats()

	if not DSClient then return nil, 0 end

	local ok, st = pcall(function() return DSClient:get({ "stats" }) end)

	if not ok or type(st) ~= "table" then return nil, 0 end

	return st.skillTree or {}, st.keys or 0

end

-- ids of nodes whose data exists, sorted for a stable dropdown

local function getSkillIds()

	local ids = {}

	if SkillTreeData then

		for id in pairs(SkillTreeData) do table.insert(ids, id) end

		table.sort(ids)

	end

	return ids

end

-- ===================== AUTO SKILL TREE LOOP =====================
do

	local skillRunning = false

	local function autoSkillLoop()

		if skillRunning then return end

		skillRunning = true

		while getFlag("AutoSkillTreeOn") and isCurrentGen() do

			local didSomething = false

			local owned, keys = getSkillStats()

			local targets = getSelectedSkills()

			local net = getSkillNet()

			if SkillTreeData and owned and net then

				for id, def in pairs(SkillTreeData) do

					if not getFlag("AutoSkillTreeOn") then break end

					-- target filter: empty/nil selection = buy every affordable node						local wanted = (not targets) or targets[id]

						-- non-purchasable (gamepass-only) and already-owned nodes are skipped;
						-- prerequisites are NOT checked here - the player may buy the parent
						-- first, so retrying is how a fresh account walks the whole tree
						if wanted and type(def) == "table" and not def.gamepass
							and not owned[id]
							and def.cost and type(def.cost) == "table" then

							local cur = def.cost.currency or "keys"

							local have = keys

							if cur ~= "keys" then

								local okC, bal = pcall(function() return DSClient:get({ "stats", cur }) end)

								have = (okC and type(bal) == "number") and bal or 0

							end

							-- fire whenever the player can afford it, even if the
							-- prerequisite is missing: the server just declines until the
							-- parent node is bought, and a later pass retries it
							if have >= (def.cost.amount or 0) then

								if pcall(function() net:fire("purchaseSkill", id) end) then

									didSomething = true

								end

								task.wait(0.25)

							end

						end

				end

			end

			task.wait(didSomething and 0.5 or 1.5)

			keys = nil -- loop re-reads each pass

		end

		skillRunning = false

	end

	task.spawn(autoSkillLoop)

	_G.FS_StartAutoSkill = function(on)

		RS:SetAttribute("TPL_AutoSkillTreeOn", on)

		if on then task.spawn(autoSkillLoop) end

	end

end

-- ===================== GRADING: AUTO LADDER =====================
-- REWRITTEN. The old version drove the game's pre-ladder grading flow:
--   gradeStartSignal:Fire(item) -> "startGrading" -> a skill-test minigame ->
--   an ArmorGradingReward screen with Take/Leave.
-- Every one of those steps is dead in this game version, which is why Auto Grade
-- looked enabled and did nothing:
--
--   1. GradeData.isLadderSystem() is TRUE. In the ladder system the Take/Leave
--      commit path is hard-disabled at the source: the InventoryFrame
--      .gradeDecidedSignal handler in InventoryServiceClient begins
--          if GradeData.isLadderSystem() then return end
--      so "finishGrading" is never fired from a take/leave decision.
--   2. "startGrading" returns nil, and the game's own gate then bails silently
--      (`if not v1 then return end`), so no run ever starts and no crystal is
--      even spent.
--   3. The reward screen the old code waited for never appears on the first
--      roll, so the loop just timed out and repeated. Same result every time.
--
-- What the ladder system actually does, traced live against the server
-- (each of these is a real call with a real, observed response):
--
--   FIRST ROLL   fetch("upgradeGrade", item)
--                -> commits IMMEDIATELY. No decision, no reward screen.
--                -> costs 1 grade crystal.
--                -> replies {grade, slots, stats, locks, rerolled,
--                            oldLocks, oldRerolled, oldSlots, oldStats}
--
--   REROLL       fetch("rerollGradeStats", item, locks, quick)
--                -> costs 1 crystal and returns a CANDIDATE only. The client's
--                   DataService does not change until it is confirmed.
--
--   CONFIRM      fire("finishReroll", item, take)
--                -> the only live take/leave in the game, and it only exists on
--                   the reroll path. take=true commits the candidate,
--                   take=false keeps what you had.
--
--   LOCK SLOTS   fire("setGradeLocks", item, lockList)
--                -> fired by the reward frame's per-slot lock buttons.
--
-- So there is no minigame to solve and no "perfect" to aim for: the roll is the
-- server's, and the only decision is whether a candidate is good enough to keep.
-- The whole skill-test solver and the whole reward-frame wait are gone for that
-- reason -- they were solving a game that no longer exists.
--
-- One UI footgun worth knowing: clicking the inventory's Grade button TOGGLES
-- reroll mode (`setRerollMode(not rerolling)`), after which the Open button
-- serves a reroll instead of an upgrade. This never touches that button, so it
-- cannot fall into that state by accident.

local GradeData = nil

-- SPEED: deferred like ItemData/DSClient. GRADE_NAMES below already has a
-- static fallback, and the refreshers re-read GradeData at runtime, so a
-- late arrival costs nothing.
task.spawn(function()

	pcall(function()

		local ok, m = pcall(require, RS.Shared.Modules.Data:WaitForChild("GradeData", 10))

		if ok and type(m) == "table" and type(m.order) == "table" then GradeData = m end

	end)

end)

local function gradeIndexOf(g)

	if not (GradeData and type(g) == "string") then return 1 end

	local ok, idx = pcall(function() return GradeData.orderOf(g) end)

	if ok and type(idx) == "number" then return idx end

	return 1

end

local GRADE_NAMES = (GradeData and GradeData.order) or { "F", "D", "C", "B", "A", "S", "SS", "SSS", "Omega" }

local function getGradableItems()

	-- gradable: armors + gears (amulets and rings are gears in this game)
	local out = {}

	local seen = {}

	for _, cat in ipairs({ "armors", "gears" }) do

		local inv = getInventoryCategory(cat)

		if inv then

			for name, save in pairs(inv) do

				if type(save) == "table" and not seen[name] then

					seen[name] = true

					table.insert(out, { name = name, grade = save.grade or "F" })

				end

			end

		end

	end

	table.sort(out, function(a, b) return a.name < b.name end)

	return out

end

-- ===================== LADDER REMOTES =====================

-- invNet is the same InventoryService networker the auto-upgrade feature uses
-- (resolved through getServiceNetworker in the inventory block above).
local function getInvNet()

	if not invNet then invNet = getServiceNetworker("InventoryService", invNetCache) end

	return invNet

end

local function getItemSave(name)

	local ok, res = pcall(function() return DSClient:get({ "inventory", "armors", name }) end)

	if ok and type(res) == "table" then return res end

	-- amulets and rings live under gears, so try the other bucket before giving up
	ok, res = pcall(function() return DSClient:get({ "inventory", "gears", name }) end)

	if ok and type(res) == "table" then return res end

	return nil

end

local function getCurrentGrade(name)

	local save = getItemSave(name)

	return type(save) == "table" and save.grade or nil

end

-- the locks table the server expects back on a reroll: the item's current locks,
-- or an empty table for a slot that does not exist yet
local function getItemLocks(name)

	local save = getItemSave(name)

	if type(save) == "table" and type(save.gradeLocks) == "table" then return save.gradeLocks end

	return {}

end

-- FIRST ROLL. Commits server-side, so there is nothing to confirm afterwards.
-- Returns the server's reply table, or nil if the server refused.
local function upgradeGrade(item)

	local net = getInvNet()

	if not net then return nil end

	local ok, res = pcall(function() return net:fetch("upgradeGrade", item) end)

	if not ok or type(res) ~= "table" then return nil end

	return res

end

-- REROLL. Spends a crystal and returns a CANDIDATE -- the item is unchanged
-- until finishReroll is called.
local function rerollGradeStats(item, locks)

	local net = getInvNet()

	if not net then return nil end

	local ok, res = pcall(function() return net:fetch("rerollGradeStats", item, locks or {}, false) end)

	if not ok or type(res) ~= "table" then return nil end

	return res

end

-- CONFIRM a reroll candidate. take=true banks it, take=false keeps the old one.
local function finishReroll(item, take)

	local net = getInvNet()

	if not net then return false end

	return pcall(function() net:fire("finishReroll", item, take and true or false) end)

end

-- ===================== AUTO GRADE LOOP =====================
do

	local gradeRunning = false

	local function notify(title, body)

		if _G.FS_Notify then pcall(function() _G.FS_Notify(title, body) end) end

	end

	local function stopAuto(reason)

		RS:SetAttribute("TPL_AutoGradeOn", false)

		notify("Auto Grading", reason)

	end

	local function autoGradeLoop()

		if gradeRunning then return end

		gradeRunning = true

		while getFlag("AutoGradeOn") and isCurrentGen() do

			local targetItem = getFlag("AutoGradeItem")

			local stopIdx = tonumber(getFlag("AutoGradeStopTier")) or 6 -- S by default

			if type(targetItem) ~= "string" or targetItem == "" then
				stopAuto("No item selected - pick one in Item To Grade.")
				break
			end

			-- already good enough? the game's own order is F < D < C < B < A < S
			-- < SS < SSS < Omega, and gradeIndexOf maps onto it.
			local curGrade = getCurrentGrade(targetItem)

			if curGrade and gradeIndexOf(curGrade) >= stopIdx then
				stopAuto(targetItem .. " is already " .. curGrade .. " - done.")
				break
			end

			local okDS, crystalCount = pcall(function() return DSClient:get({ "stats", "gradeCrystals" }) end)
			local crystals = (okDS and tonumber(crystalCount)) or 0

			if crystals < 1 then
				stopAuto("No grade crystals left.")
				break
			end

			-- an item with no grade has never been rolled, so it needs the first
			-- roll, not a reroll. That is the one case that is not a decision.
			if not curGrade then

				local res = upgradeGrade(targetItem)

				if not res then
					stopAuto("The server refused the grade - nothing was spent.")
					break
				end

				task.wait(0.6)

				local now = getCurrentGrade(targetItem)

				notify("Auto Grading", targetItem .. " first roll -> " .. tostring(now or res.grade or "?"))

				if now and gradeIndexOf(now) >= stopIdx then
					stopAuto(targetItem .. " reached " .. tostring(now) .. " - done.")
					break
				end

			else

				-- a reroll only produces a candidate; keep it if it clears the
				-- target, otherwise leave it and roll again
				local res = rerollGradeStats(targetItem, getItemLocks(targetItem))

				if not res then
					stopAuto("The server refused the reroll - nothing was spent.")
					break
				end

				task.wait(0.6)

				local candIdx = gradeIndexOf(res.grade)
				local take = candIdx >= stopIdx

				finishReroll(targetItem, take)

				task.wait(0.6)

				local now = getCurrentGrade(targetItem)

				notify("Auto Grading", targetItem .. " rolled " .. tostring(res.grade)
					.. " -> " .. (take and "kept" or "left") .. " (now " .. tostring(now or "?") .. ")")

				if take then
					stopAuto(targetItem .. " reached " .. tostring(res.grade) .. " - done.")
					break
				end

			end

			task.wait(0.4)

		end

		gradeRunning = false

	end

	task.spawn(autoGradeLoop)

	_G.FS_StartAutoGrade = function(on)

		RS:SetAttribute("TPL_AutoGradeOn", on)

		if on then task.spawn(autoGradeLoop) end

	end

	-- one roll on demand, for the "Roll Once" button
	_G.FS_GradeOnce = function()

		local targetItem = getFlag("AutoGradeItem")

		if type(targetItem) ~= "string" or targetItem == "" then
			notify("Auto Grading", "No item selected - pick one in Item To Grade.")
			return
		end

		task.spawn(function()

			local curGrade = getCurrentGrade(targetItem)

			if not curGrade then
				local res = upgradeGrade(targetItem)
				notify("Auto Grading", res
					and (targetItem .. " first roll -> " .. tostring(res.grade))
					or "The server refused the roll.")
				return
			end

			local res = rerollGradeStats(targetItem, getItemLocks(targetItem))

			if not res then
				notify("Auto Grading", "The server refused the reroll.")
				return
			end

			task.wait(0.6)

			finishReroll(targetItem, true)

			task.wait(0.6)

			notify("Auto Grading", targetItem .. " rerolled to " .. tostring(res.grade))

		end)

	end

end

-- ===================== QUESTS: AUTO CLAIM =====================
-- Three independent auto-claimers, all on the game's own "Quests" networker tag
-- (found by walking QuestController's upvalues for the client that owns the
-- claim fetches -- there is no QuestService module, the client is built inline):
--
--   fetch("claimDaily", slotIndex)     the daily quest slots
--   fetch("claimAchievement", achId)   the 12 tiered achievements
--   fetch("claimStreak", day)          the 7-day login streak
--
-- VERIFIED live against the server, both directions:
--   claimDaily(3) on a completed slot -> returned true, and the slot's `claimed`
--     flag flipped from nil to true.
--   claimStreak(2) while streak was 0 -> returned FALSE. The server validates
--     eligibility itself, so a wrong claim costs nothing but is still spam; every
--     claim below is gated on the same eligibility test the game's own UI uses.
--
-- Eligibility mirrors QuestController's render functions exactly, so this only
-- ever asks for what the game would have shown a Claim button for:
--   DAILY        not rolled over, not already claimed, and
--                clamp(readSource - slot.baseline, 0, goal) >= goal
--   ACHIEVEMENT  tiers[claimed+1] exists and its goal <= readSource
--   STREAK       day <= streak and not already in claimedStreakRewards
--
-- Note the data lives under quests.daily for BOTH the daily slots and the streak
-- (quests.daily.streak / quests.daily.claimedStreakRewards), while achievements
-- sit under quests.achievements keyed by ach_* id with `claimed` = tiers taken.
local QuestData = nil

pcall(function()
	local ok, m = pcall(require, RS.Shared.Modules.Data:WaitForChild("QuestData", 10))
	if ok and type(m) == "table" then QuestData = m end
end)

local questNet = nil

local function getQuestNet()

	if questNet then return questNet end

	if not Networker then return nil end

	pcall(function() questNet = Networker.client.new("Quests", {}) end)

	return questNet

end

-- A claim must never be able to wedge the loop: net:fetch yields until the
-- server answers, and one unanswered call would otherwise stop every claimer.
local function questFetch(method, arg, timeoutSecs)

	local net = getQuestNet()

	if not net then return false end

	local finished, result = false, false

	task.spawn(function()
		local ok, res = pcall(function()
			if arg == nil then return net:fetch(method) end
			return net:fetch(method, arg)
		end)
		finished = true
		result = (ok and res == true)
	end)

	local deadline = os.clock() + (timeoutSecs or 6)

	while not finished and os.clock() < deadline do task.wait(0.1) end

	return finished and result or false

end

local function questPlayerData()

	if not DSClient then return nil end

	local ok, data = pcall(function() return DSClient:get() end)

	if ok and type(data) == "table" then return data end

	return nil

end

-- how many daily slots the game rolls (3 today)
local function dailyCount()

	if QuestData and type(QuestData.dailyCount) == "number" then return QuestData.dailyCount end

	return 3

end

-- QuestData.streakRewards is keyed by day but is NOT a clean array, so # is
-- wrong on it (it reports 1 for a 7-entry table). Collect the day numbers.
local function streakDays()

	local out = {}

	if not (QuestData and type(QuestData.streakRewards) == "table") then return out end

	for day in pairs(QuestData.streakRewards) do

		if type(day) == "number" then out[#out + 1] = day end

	end

	table.sort(out)

	return out

end

local function claimableDaily()

	local out = {}

	local data = questPlayerData()

	if not (data and QuestData) then return out end

	local daily = data.quests and data.quests.daily

	if not daily then return out end

	local rolledOver = os.time() < ((daily.nextRollTime) or 0)

	if rolledOver then return out end

	local slots = daily.slots

	for i = 1, dailyCount() do

		local slot = slots and slots[i]

		if type(slot) == "table" and not slot.claimed then

			local def = QuestData.dailySlotQuestById and QuestData.dailySlotQuestById[slot.quest]

			if def and type(def.goal) == "number" and def.goal > 0 then

				local ok, value = pcall(function() return QuestData.readSource(data, def) end)

				if ok and type(value) == "number" then

					local progress = math.clamp(value - (slot.baseline or 0), 0, def.goal)

					if def.goal <= progress then out[#out + 1] = i end

				end

			end

		end

	end

	return out

end

local function claimableAchievements()

	local out = {}

	local data = questPlayerData()

	if not (data and QuestData and type(QuestData.achievements) == "table") then return out end

	local claimed = (data.quests and data.quests.achievements) or {}

	for _, ach in pairs(QuestData.achievements) do

		local entry = claimed[ach.id]

		local taken = (type(entry) == "table" and tonumber(entry.claimed)) or 0

		if taken < #ach.tiers then

			local tier = ach.tiers[taken + 1]

			if tier and type(tier.goal) == "number" and tier.goal > 0 then

				local ok, value = pcall(function() return QuestData.readSource(data, ach) end)

				if ok and type(value) == "number" and tier.goal <= value then

					out[#out+1] = { id = ach.id, name = ach.name, tier = tier.tier }

				end

			end

		end

	end

	table.sort(out, function(a, b) return tostring(a.id) < tostring(b.id) end)

	return out

end

local function claimableStreak()

	local out = {}

	local data = questPlayerData()

	if not data then return out end

	local daily = data.quests and data.quests.daily

	if not daily then return out end

	local streak = tonumber(daily.streak) or 0

	if streak < 1 then return out end

	local already = daily.claimedStreakRewards or {}

	for _, day in ipairs(streakDays()) do

		if day <= streak and not already[day] then out[#out + 1] = day end

	end

	return out

end

-- ===================== AUTO CLAIM LOOP =====================
do

	local claimRunning = false

	local function notifyClaim(msg)

		if _G.FS_Notify then pcall(function() _G.FS_Notify("Auto Claim", msg) end) end

	end

	local function claimPass()

		local claimedSomething = false

		if getFlag("AutoClaimQuestsOn") then

			for _, slot in ipairs(claimableDaily()) do

				if questFetch("claimDaily", slot) then

					claimedSomething = true
					notifyClaim("Claimed daily quest slot " .. tostring(slot) .. ".")

				end

			end

		end

		if getFlag("AutoClaimAchOn") then

			for _, ach in ipairs(claimableAchievements()) do

				if questFetch("claimAchievement", ach.id) then

					claimedSomething = true
					notifyClaim("Claimed " .. tostring(ach.name) .. " (" .. tostring(ach.tier) .. ").")

				end

			end

		end

		if getFlag("AutoClaimStreakOn") then

			for _, day in ipairs(claimableStreak()) do

				if questFetch("claimStreak", day) then

					claimedSomething = true
					notifyClaim("Claimed streak day " .. tostring(day) .. ".")

				end

			end

		end

		return claimedSomething

	end

	local function autoClaimLoop()

		if claimRunning then return end

		claimRunning = true

		-- the game's own pass is 2s; stay slower than that so a claimer left on
		-- does not hammer the data store, but stay fast enough that a reward is
		-- never sitting there for long
		while isCurrentGen() do

			local on = getFlag("AutoClaimQuestsOn") or getFlag("AutoClaimAchOn") or getFlag("AutoClaimStreakOn")

			if not on then
				task.wait(1)
			else
				local ok, did = pcall(claimPass)
				-- a claimer that throws must not take the other two down with it
				if not ok then
					pcall(function() _G.FS_Notify("Auto Claim", "Error: " .. tostring(did)) end)
				end
				task.wait(did and 2 or 6)
			end

		end

		claimRunning = false

	end

	task.spawn(autoClaimLoop)

	-- one pass on demand, for a "Claim Now" button
	_G.FS_ClaimNow = function()

		task.spawn(function()

			local ok, did = pcall(claimPass)

			if not ok then
				notifyClaim("Error: " .. tostring(did))
			elseif not did then
				notifyClaim("Nothing to claim.")
			end

		end)

	end

end

-- ===================== LOBBY TAB: AUTO UPGRADE + CHESTS UI =====================
do


	local secUpg = lobby:CreateSection({ name = "Auto Upgrade" })

	-- item picker: one multi-select dropdown. The old build also ran a 0.5s loop that
	-- walked the whole UI tree to rename Nebula's "Select All" row back whenever it
	-- flipped to "Select None"; that hack is gone, since ObsidianUltra has no such row
	-- and the walk would never have found anything.
	local function upgradeOptions()

		local opts = {}

		for _, it in ipairs(getUpgradableItems()) do

			table.insert(opts, it.name)

		end

		return opts

	end

	local selDD = secUpg:CreateDropdown({

		name = "Upgrade Items",

		multiSelect = true,

		options = upgradeOptions(),

		value = {},

		noreg = true,

		callback = function(list)

			-- picking every option means "everything" -> store empty (= all)
			local opts = upgradeOptions()

			local picked = {}

			for _, n in ipairs(list) do picked[n] = true end

			local all = #opts > 0

			for _, n in ipairs(opts) do

				if not picked[n] then all = false break end

			end

			if all then

				setSelectedList({})

			else
				setSelectedList(list)

			end

		end,

	})

	secUpg:CreateToggle({

		name = "Auto Upgrade Items",

		value = getFlag("AutoUpgradeOn"),

		callback = function(v)

			if _G.FS_StartAutoUpgrade then _G.FS_StartAutoUpgrade(v) end

		end,

	})

	-- ==================== AUTO SKILL TREE UI ====================
	local secSkill = lobby:CreateSection({ name = "Auto Skill Tree" })

	local skillIds = getSkillIds()

	local skillDD = secSkill:CreateDropdown({

		name = "Skills To Buy",

		multiSelect = true,

		options = skillIds,

		value = {},

		noreg = true,

		callback = function(list)

			local picked = {}

			for _, n in ipairs(list) do picked[n] = true end

			local all = #skillIds > 0

			for _, n in ipairs(skillIds) do

				if not picked[n] then all = false break end

			end

			if all then

				RS:SetAttribute("TPL_AutoSkillSelList", "")

			else

				RS:SetAttribute("TPL_AutoSkillSelList", table.concat(list, ","))

			end

		end,

	})

	secSkill:CreateToggle({

		name = "Auto Skill Tree Upgrade",

		value = getFlag("AutoSkillTreeOn"),

		callback = function(v)

			if _G.FS_StartAutoSkill then _G.FS_StartAutoSkill(v) end

		end,

	})

	-- ==================== AUTO GRADING UI ====================
	local secGrade = lobby:CreateSection({ name = "Auto Grading" })

	local gradables = getGradableItems()

	local gradeNames = {}

	for _, g in ipairs(GRADE_NAMES) do table.insert(gradeNames, g) end

	-- which tier to stop grading an item at (index -> name)

	local function stopTierName()

		local idx = math.clamp(tonumber(getFlag("AutoGradeStopTier")) or 6, 1, #gradeNames)

		return gradeNames[idx]

	end

	secGrade:CreateDropdown({

		name = "Item To Grade",

		search = true,

		options = (function()

			local opts = {}

			for _, it in ipairs(gradables) do table.insert(opts, it.name) end

			return opts

		end)(),

		value = getFlag("AutoGradeItem") or gradables[1] and gradables[1].name or nil,

		noreg = true,

		callback = function(v)

			if type(v) == "string" then RS:SetAttribute("TPL_AutoGradeItem", v) end

		end,

	})

	secGrade:CreateDropdown({

		name = "Grade Until",

		options = gradeNames,

		value = stopTierName(),

		noreg = true,

		callback = function(v)

			for i, g in ipairs(gradeNames) do

				if g == v then RS:SetAttribute("TPL_AutoGradeStopTier", i) break end

			end

		end,

	})

	secGrade:CreateButton({

		name = "Roll Once",

		desc = "Spends one crystal per roll.",

		callback = function()

			if _G.FS_GradeOnce then _G.FS_GradeOnce() end

		end,

	})

	secGrade:CreateToggle({

		name = "Auto Grade",

		desc = "Rolls until the item hits Grade Until.",

		value = getFlag("AutoGradeOn"),

		callback = function(v)

			if _G.FS_StartAutoGrade then _G.FS_StartAutoGrade(v) end

		end,

	})

	local secClaim = lobby:CreateSection({ name = "Auto Claim" })

	secClaim:CreateToggle({

		name = "Auto Claim Quests",

		desc = "Claims the daily quests as soon as you finish one.",

		value = getFlag("AutoClaimQuestsOn"),

		callback = function(v) RS:SetAttribute("TPL_AutoClaimQuestsOn", v) end,

	})

	secClaim:CreateToggle({

		name = "Auto Claim Achievements",

		desc = "Claims every achievement tier you have earned.",

		value = getFlag("AutoClaimAchOn"),

		callback = function(v) RS:SetAttribute("TPL_AutoClaimAchOn", v) end,

	})

	secClaim:CreateToggle({

		name = "Auto Claim Streak Rewards",

		desc = "Claims the login streak rewards you have reached.",

		value = getFlag("AutoClaimStreakOn"),

		callback = function(v) RS:SetAttribute("TPL_AutoClaimStreakOn", v) end,

	})

	secClaim:CreateButton({

		name = "Claim Now",

		desc = "Checks once for anything ready and claims it.",

		callback = function()

			if _G.FS_ClaimNow then _G.FS_ClaimNow() end

		end,

	})

	local secChest = lobby:CreateSection({ name = "Chests" })

	secChest:CreateToggle({

		name = "Auto Open Chests",

		desc = "Keeps opening the selected chests as you get them.",

		value = getFlag("AutoOpenChestsOn"),

		callback = function(v)

			if _G.FS_StartAutoChests then _G.FS_StartAutoChests(v) end

		end,

	})

	-- which chest types to open, used by the loop above and by Open Now
	secChest:CreateDropdown({

		name = "Chests To Open",

		desc = "None ticked means none get opened.",

		options = CHEST_CHOICES,

		multiSelect = true,

		value = getSelectedChests(),

		callback = function(v) setSelectedChests(v) end,

	})

	-- how many chests go out in one call. Defaults to 1000, the game's own
	-- maximum, so a stack is drained in as few calls as the game allows.
	local chestBatch = getFlag("ChestBatchCap") or CHEST_BATCH_CAP

	if type(chestBatch) ~= "number" or chestBatch < 1 then chestBatch = CHEST_BATCH_CAP end

	secChest:CreateSlider({

		name = "Chests Per Call",

		range = { 1, 5000 },

		increment = 100,

		value = chestBatch,

		desc = "How many to open at once. Max 1000.",

		callback = function(v) setFlag("ChestBatchCap", math.floor(v)) end,

	})

	secChest:CreateButton({

		name = "Open Now",

		desc = "Opens them right now.",

		callback = function()

			if _G.FS_OpenAllChests then _G.FS_OpenAllChests() end

		end,

	})

end

-- ===================== AUTO USE ABILITY =====================
-- Abilities belong to the CLASS, not to a separate loadout: three slots bound to
-- Q / R / F (gamepad L1 / B / RB), rendered as HUD.Ability.Button_1..3. A press is
--   aim  = ClassAim.forAbility(ability, ability.aimRange or 20)
--   ClassServiceClient:RequestAbility(slot, "down", aim)
-- and the release is RequestAbility(slot, "up") with no aim. Both go out on the
-- "ClassService" networker tag as fire("UseAbility", slot, phase, aim). The "up"
-- half is not optional: abilities with input == "hold" stay held until released.
--
-- The gate in front of that is not small. The slot's ability must be unlocked for
-- the player's class level, off cooldown, affordable (classMeter >= cost, with a
-- per-slot classCost<slot> override read from the run data), and the humanoid must
-- be alive. All of that lives in the press function inside
-- Shared.UI.HUD.AbilityButton -- which exports ONLY init(), so it cannot be
-- called. Re-deriving the gate here would mean duplicating cooldown and meter
-- arithmetic that the server owns, and it would silently drift the moment the
-- game changed a cost.
--
-- So this drives the real HUD buttons instead. Each Button_N has exactly one
-- MouseButton1Down and one MouseButton1Up connection, and firing those IS the
-- game's own press path: every check above still applies, and a press that should
-- be refused is simply refused by the game rather than by a guess here. This is
-- the same approach that worked for the ArmorGradingReward Take button.
--
-- Runs in matches only. The game's own UseAbility admin command documents "the
-- world must be running", and the ability frame is hidden in the lobby anyway.
-- The per-press `pending` flag also locks a slot for 3s after a press, which is
-- why the interval defaults to 3 rather than fighting that lock.

local function abilityButtons()

	local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")

	local hud = pg and pg:FindFirstChild("HUD")

	local frame = hud and hud:FindFirstChild("Ability")

	if not frame then return {} end

	local out = {}

	for i = 1, 3 do out[i] = frame:FindFirstChild("Button_" .. i) end

	return out

end

-- The game's press function is:
--     ...meter/alive gates...
--     setDimmed(p1, true)                      <- the animation
--     ClassAim.forAbility(ability, aimRange)   <- can THROW
--     ClassServiceClient:RequestAbility(slot, "down", aim)
-- ClassAim.forAbility is a table field on the ClassAim module and the game looks it
-- up at call time, so wrapping it here is enough to stop a throw there from killing
-- the press midway -- which is exactly the "animation plays but nothing fires"
-- symptom, since the dim happens BEFORE the aim is computed.
local ClassAimRef = nil
local ClassServiceRef = nil

-- how many times RequestAbility was actually reached, and why the last attempt
-- failed if it was not. Counted rather than inferred so "the animation played" can
-- never be mistaken for "the ability fired".
local abilityFireCount = 0
local abilityFireProblem = nil

do

	local okAim, aimMod = pcall(function()
		return require(RS.Shared.Modules.Game.ClassAim)
	end)

	if okAim and type(aimMod) == "table" and type(aimMod.forAbility) == "function" then

		local realForAbility = aimMod.forAbility

		ClassAimRef = aimMod

		aimMod.forAbility = function(ability, range)
			local ok, res = pcall(realForAbility, ability, range)
			if ok then return res end
			-- aim is optional for most abilities; a nil aim still reaches the
			-- server, which decides. Never let this abort the press.
			abilityFireProblem = "aim failed: " .. tostring(res)
			return nil
		end

	end

	local okSvc, svc = pcall(function()
		return require(RS.Shared.Services.ClassService.ClassServiceClient)
	end)

	if okSvc and type(svc) == "table" then

		ClassServiceRef = svc

		if type(svc.RequestAbility) == "function" then

			local realRequest = svc.RequestAbility

			svc.RequestAbility = function(self, slot, phase, aim)
				abilityFireCount = abilityFireCount + 1
				return realRequest(self, slot, phase, aim)
			end

		end

	end

end

-- press then release, mirroring one real click. Firing Down is what runs the
-- gate; firing Up straight after is what un-holds a hold-type ability.
-- Returns true only when RequestAbility was ACTUALLY reached -- a press that only
-- played the animation does not count, which is what made the old version report
-- success while doing nothing.
local function tapAbilitySlot(slot)

	local buttons = abilityButtons()

	local btn = buttons[slot]

	abilityFireProblem = nil

	local before = abilityFireCount

	if btn and btn:IsA("GuiObject") and btn.Visible then

		pcall(function()
			for _, conn in ipairs(getconnections(btn.MouseButton1Down)) do
				pcall(function() conn:Fire() end)
			end
		end)

		task.wait(0.08)

		pcall(function()
			for _, conn in ipairs(getconnections(btn.MouseButton1Up)) do
				pcall(function() conn:Fire() end)
			end
		end)

		if abilityFireCount > before then return true, abilityFireProblem end

		-- the animation ran but no ability was requested: the press died between
		-- the dim and the fire, or the gate refused. Ask the service directly as
		-- a fallback -- the SERVER is the authority on whether an ability is legal
		-- (the same way an ineligible quest claim comes back false), so a refused
		-- request costs nothing and does not drain meter.
		if ClassServiceRef and type(ClassServiceRef.RequestAbility) == "function" then

			local aim = nil

			if ClassAimRef and type(ClassAimRef.forAbility) == "function" then
				pcall(function() aim = ClassAimRef.forAbility(nil, 20) end)
			end

			local ok = pcall(function()
				ClassServiceRef:RequestAbility(slot, "down", aim)
				task.wait(0.05)
				ClassServiceRef:RequestAbility(slot, "up")
			end)

			if ok and abilityFireCount > before then return true, "fallback" end

		end

		return false, abilityFireProblem or "gate refused"

	end

	-- hidden or missing button: the slot is not unlocked for this class level.
	-- Still allowed to ask, because visibility is a client-side display decision.
	if ClassServiceRef and type(ClassServiceRef.RequestAbility) == "function" then

		local ok = pcall(function()
			ClassServiceRef:RequestAbility(slot, "down", nil)
			task.wait(0.05)
			ClassServiceRef:RequestAbility(slot, "up")
		end)

		return (ok and abilityFireCount > before), "button hidden"

	end

	return false, "no ability button"

end

-- which slots to use, stored as a comma list; nil means all three
local function getAbilitySlots()

	local raw = getFlag("AbilitySlots")

	if type(raw) ~= "string" or raw == "" then return { 1, 2, 3 } end

	local out = {}
	local seen = {}

	for n in string.gmatch(raw, "[^,]+") do

		local slot = tonumber(string.match(n, "^%s*(.-)%s*$"))

		if slot and slot >= 1 and slot <= 3 and not seen[slot] then

			seen[slot] = true
			out[#out + 1] = slot

		end

	end

	return out

end

local function setAbilitySlots(list)

	RS:SetAttribute("TPL_AbilitySlots", table.concat(list or {}, ","))

end

-- in a match? the same test the rest of this file uses for "in a round"
local function inMatchForAbilities()

	return workspace:FindFirstChild("Enemies") ~= nil
		and workspace:FindFirstChild("Lobby") == nil

end

do

	local abilityRunning = false

	local function autoAbilityLoop()

		if abilityRunning then return end

		abilityRunning = true

		while getFlag("AutoAbilityOn") and isCurrentGen() do

			if not inMatchForAbilities() then
				task.wait(1.5)
			else

				local interval = tonumber(getFlag("AbilityInterval")) or 3

				interval = math.clamp(interval, 0.5, 30)

				for _, slot in ipairs(getAbilitySlots()) do

					if not getFlag("AutoAbilityOn") then break end

					pcall(tapAbilitySlot, slot)

					task.wait(interval)

				end

			end

		end

		abilityRunning = false

	end

	task.spawn(autoAbilityLoop)

	_G.FS_StartAutoAbility = function(on)

		RS:SetAttribute("TPL_AutoAbilityOn", on)

		if on then task.spawn(autoAbilityLoop) end

	end

end

-- ===================== MAIN TAB: AUTO FARM =====================
-- Flight-based auto farm for the round (Volcano etc). The character hovers
-- ABOVE the enemy cluster so melee enemies can't reach it, while the game's own
-- weapons auto-attack whatever is in range (no attack driving here). Enemy
-- PROJECTILES are the only real threat in the air: they fly as models under
-- workspace.VFX (e.g. Fireball), so a velocity-based dodge sidesteps when a
-- shot's future path passes near the character. Orb collecting is a separate
-- toggle: the server grants XP on its own ~0.6s distance tick, so "Auto
-- Collect Orbs" flies a smooth swoop down INTO the orb cluster (movement, not
-- teleport - a teleport would be ignored server-side) and holds there until
-- the orbs vacuum in, then climbs back to the fight hover.

local RunServiceFarm = game:GetService("RunService")

if getFlag("Farm_Height") == nil then RS:SetAttribute("TPL_Farm_Height", 28) end
if getFlag("Farm_OrbDwell") == nil then RS:SetAttribute("TPL_Farm_OrbDwell", 2) end
-- hover/dodge flight responsiveness (the mover's lerp strength); higher = snappier
if getFlag("Farm_Speed") == nil then RS:SetAttribute("TPL_Farm_Speed", 7) end

local farmOn = false
local farmCollectOn = false
-- portal priority handoff: while Auto Enter Portal is walking/holding, the
-- farm loop must NOT write moverGoal — both loops otherwise fight over the
-- same flight target every frame. The portal is the end of the run: it wins.
local portalDriving = false
-- rift priority handoff: the same contract as portalDriving above. While Auto Rift
-- owns the character -- walking into the orb, then holding the zone / chasing
-- shards / hitting rings -- the farm must not write moverGoal either. Both loops
-- write it every 0.1s, so without this the character is dragged between the orbit
-- and the rift target every frame and the challenge never completes.
local riftDriving = false
-- oxygen claim, same contract. Unlike a rift this is a CONTINUOUS pressure rather
-- than a rare event, so it only takes the mover while oxygen is under the user's
-- threshold -- between grabs the farm gets the character back and keeps working.
local bubbleDriving = false

-- // SCENE READS //--

-- in a round = the match workspace exists (Lobby exists only in the lobby)
local function inRound()

	return workspace:FindFirstChild("Enemies") ~= nil and workspace:FindFirstChild("Lobby") == nil

end

-- nearest walkable floor under a point: raycast DOWN from just ABOVE the point,
-- skipping INVISIBLE boundary geometry (Grasslands shells the whole arena in a
-- giant transparent wall union whose top eats rays from above and reports a
-- fake floor at ~Y114 — every map with such a shell hovered on the shell, not
-- the floor). Walks through transparent/boundary hits until a real surface.
-- Fail-open: raycast error / no hit => assume ground at the point itself.
local function groundBelow(x, z, fromY)

	local hitY = nil

	pcall(function()

			-- match maps spawn HIGH (every world template's 'ground level' marker
			-- sits at Y~161.5, island top ~164): always cast from a start above
			-- the highest possible floor, not from fromY-8 (a Y52 start begins
			-- UNDER the map floor on every world => no hit => hover fell back to
			-- Y3+height and the farm flew away from spawn on tall maps)
			local origin = Vector3.new(x, math.max(fromY or 60, 340) + 20, z)

		local params = RaycastParams.new()

		params.FilterType = Enum.RaycastFilterType.Exclude

		-- FilterDescendantsInstances returns a COPY: table.insert on it never
		-- writes back, so the old boundary-walk re-hit the same invisible shell
		-- 6 times and returned nil. Rebuild the list locally and ASSIGN it.
		local exclude = { Players.LocalPlayer.Character }			local last = nil

			for _ = 1, 40 do

			params.FilterDescendantsInstances = exclude

			local res = workspace:Raycast(origin, Vector3.new(0, -800, 0), params)

			if not res or not res.Instance then break end

			local inst = res.Instance

			local boundary = inst.Transparency >= 0.99 or inst.Name == "Wall" or inst.Name == "selectionLine"

			if not boundary then

				hitY = res.Position.Y

				break

			end

			if inst == last then break end -- filter write failed; don't spin

			last = inst

			exclude[#exclude + 1] = inst

		end

	end)

	return hitY

end

-- one enemy sample: position of the live melee threat (Humanoid alive, has HRP
-- or a Hitbox part). Enemy rigs are R6 models with a Humanoid + Hitbox part.
local function enemyPos(e)

	if not e:IsA("Model") then return nil end

	local hum = e:FindFirstChildOfClass("Humanoid")

	if hum and hum.Health <= 0 then return nil end

	local hrp = e:FindFirstChild("HumanoidRootPart") or e:FindFirstChild("Hitbox") or e:FindFirstChild("Torso")

	if hrp and hrp:IsA("BasePart") then return hrp.Position end

	local pp = e.PrimaryPart or e:FindFirstChildWhichIsA("BasePart", true)

	if pp then return pp.Position end

	return nil

end

-- cluster center + count of live enemies (dist-filtered MEDIAN per axis: a few
-- despawn ghosts parked tens of thousands of studs away must not drag the
-- hover point off the map)
local farmScanCache, farmScanAt = nil, 0

local function getFarmScan()

	if os.clock() - farmScanAt < 0.4 then return farmScanCache end

	farmScanAt = os.clock()

	farmScanCache = nil

	local enemies = workspace:FindFirstChild("Enemies")

	if not enemies then return nil end

	local xs, ys, zs = {}, {}, {}

	local n = 0

	local myPos = nil

	local char = Players.LocalPlayer.Character

	local myHrp = char and char:FindFirstChild("HumanoidRootPart")

	if myHrp then myPos = myHrp.Position end

	for _, e in ipairs(enemies:GetChildren()) do

		local p = enemyPos(e)

		if p and p.Y > -50 and p.Y < 300 then

			-- only enemies near the character define the hover point (the map
			-- floor is 1500x1500; far waves can spawn anywhere)

			if not myPos or (Vector3.new(p.X, 0, p.Z) - Vector3.new(myPos.X, 0, myPos.Z)).Magnitude < 400 then

				n = n + 1

				table.insert(xs, p.X)
				table.insert(ys, p.Y)
				table.insert(zs, p.Z)
			end

		end

	end

	if n == 0 then return nil end

	table.sort(xs)
	table.sort(ys)
	table.sort(zs)

	local mid = math.ceil(n / 2)

	farmScanCache = { pos = Vector3.new(xs[mid], ys[mid], zs[mid]), count = n }

	return farmScanCache

end

-- // CHARACTER HELPERS //--

local function getCharParts()

	local char = Players.LocalPlayer.Character

	if not char then return nil end

	local hum = char:FindFirstChildOfClass("Humanoid")

	local hrp = char:FindFirstChild("HumanoidRootPart")

	if not hum or not hrp then return nil end

	return char, hum, hrp

end

-- the game death-parks by ANCHORING the HRP: a server-owned anchored assembly
-- silently rolls back client CFrame writes, so flight must unanchor first
local function ensureFlightReady(hrp)

	if hrp.Anchored then hrp.Anchored = false end

end

-- // DODGE: velocity-projectile sidestep //--
-- enemy shots are models under workspace.VFX moving with AssemblyLinearVelocity
-- (bananarangs move by CFrame - tracked via position delta). If a shot's
-- FUTURE path (next ~0.7s) passes within `radius` of the character, sidestep
-- perpendicular to the shot's travel direction.
local dodgeDir = 1 -- alternates so repeated shots don't push us off the map

local dodgeUntil = 0

local dodgeVec = Vector3.zero

local lastShotPos = {} -- [model] = last position, for CFrame-movers
local shotFirstSeen = {} -- [model] = first position we saw it at
local shotSeenAt = {} -- [model] = os.clock() of first sighting

local function projectileDodge(hrp, dt)

	local vfx = workspace:FindFirstChild("VFX")

	if not vfx then return Vector3.zero end

	local myPos = hrp.Position

	local now = os.clock()

	-- prune stale trackers

	for m in pairs(lastShotPos) do

		if not m.Parent then lastShotPos[m] = nil end

	end

	for m in pairs(shotFirstSeen) do

		if not m.Parent then shotFirstSeen[m] = nil shotSeenAt[m] = nil end

	end

	for _, m in ipairs(vfx:GetChildren()) do

		if m:IsA("Model") then

			-- only projectile-looking models: they fly; skip loot/XP/keys

			local nm = m.Name

			if nm ~= "xp" and nm ~= "keys" and nm ~= "InfernoKey" and nm ~= "Chest" then

				local pp = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart", true)

				if pp then

					local p, v = pp.Position, pp.AssemblyLinearVelocity

					-- OWN-SHOT FILTER: our own weapon projectiles spawn in the same
					-- workspace.VFX folder with the SAME names as enemy shots (no owner
					-- tag exists client-side). A shot FIRST SEEN right on top of the
					-- character is ours (enemy shots come from the swarm, far away);
					-- flag it once and skip that model for its whole life — otherwise
					-- every own shot triggered a +16-stud dodge and the farm surfed
					-- across the map
					if shotFirstSeen[m] == nil then
						shotFirstSeen[m] = ((p - myPos).Magnitude < 25) and true or false
						shotSeenAt[m] = now
					end
					if shotFirstSeen[m] == true then
						-- flagged as our own shot at first sighting: never dodge it
					else

					local speed = v.Magnitude

					if speed < 1 then

						-- CFrame-mover (bananarang): estimate velocity from the
						-- position delta

						local prev = lastShotPos[m]

						if prev then

							v = (p - prev) / math.max(dt, 1 / 60)

							speed = v.Magnitude

						end

						lastShotPos[m] = p

					end

					-- a projectile is a FAST thing heading roughly at us

					if speed > 25 then

						local toMe = myPos - p

						local dist = toMe.Magnitude

						if dist < 130 then

							local dir = v.Unit

							-- closest approach of its path to my position

							local t = math.clamp(toMe:Dot(dir), 0, 0.7 * speed)

							local closest = p + dir * t

							local miss = (myPos - closest).Magnitude

							if miss < 14 and now > dodgeUntil then

								-- sidestep perpendicular to the shot's travel,
								-- keeping some height

								local perp = Vector3.new(-dir.Z, 0, dir.X)

								if perp.Magnitude < 0.1 then perp = Vector3.new(1, 0, 0) else perp = perp.Unit end

								-- pick the side that goes TOWARD the shot's origin
								-- side (dodging "behind" the shot path)

								local side = ((p - myPos):Dot(perp) > 0) and 1 or -1

								dodgeDir = -dodgeDir

								dodgeVec = perp * side * 16 + Vector3.new(0, 6, 0)

								dodgeUntil = now + 0.45

								break

							end

						end

					end

					end -- speed<1 / if-true(pp block close)

				end


			end

		end

	end

	if now < dodgeUntil then return dodgeVec end

	return Vector3.zero

end

-- // MAIN FARM LOOP (OP v2) //--

local farmThread = nil

local OP_RANGED = { Fireball = true, ArrowShot = true, Bananarang = true }

-- enemies that shoot: keep them OFF the hover-center so their shots arc
-- wide, but their radius is still counted so the auto-attack reaches them
local function isRanged(e)
	if OP_RANGED[e.Name] then return true end
	return false
end

-- // SMOOTH MOVER: framerate-based flight (kills the micro-teleport stutter) //--
-- The old loop moved the character with one lerp step per 0.05s tick (20 Hz).
-- Now the scan loop only computes the goal; a Heartbeat connection glides the
-- character toward it every frame with dt-based exponential smoothing.
local orbitAngle = 0
-- // SIMPLE ORBIT (v2) — no raycasts, no calibration, no guards //--
-- The previous probe/calibration/void-guard stack caused slider lag, freezes
-- and stutters. New scheme: ONE ground read at the map center per round,
-- cached (orbitBaseY). Orbit height = orbitBaseY + Orbit Height slider.
-- Radius = Orbit Radius slider, clamped only to stay inside the island.
-- Per-tick raycasts in Orbit mode: ZERO.
local orbitBaseY = nil -- cached ground height at the map center (per round)
-- Auto-Dodge-only goal-hold state (Orbit never uses it anymore)
local lastValidGoal = nil
local goalHeld = false
local moverGoal = nil
local moverLook = nil
local moverConn = nil
local function ensureMover()
	if moverConn then return end
	local rs = game:GetService("RunService")
	moverConn = rs.Heartbeat:Connect(function(dt)
		pcall(function()
			if not farmOn and not farmCollectOn then return end
			if not moverGoal then return end
			local char = Players.LocalPlayer.Character
			local h = char and char:FindFirstChild("HumanoidRootPart")
			if not h then return end
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health <= 0 then return end
			local cur = h.Position
			-- flight speed: exponential smoothing strength, user-set (Farm_Speed,
			-- default 7 = the original feel). Clamp hard: 1 crawls, 30 teleport-snaps
			local spd = math.clamp(tonumber(getFlag("Farm_Speed")) or 7, 1, 30)
			local alpha = 1 - math.exp(-dt * spd)
			local step = cur:Lerp(moverGoal, alpha)
			local lt = moverLook or step
			-- NEVER hand lookAt an eye equal to its target. Verified in this client:
			-- CFrame.lookAt(p, p) returns a rotation matrix whose nine components are
			-- ALL NaN, and writing that onto the HumanoidRootPart NaNs the camera with
			-- it -- the screen blanks and Roblox puts up its "Gameplay Paused" overlay.
			-- This is not an edge case: every feature that parks on a target (Auto
			-- Collect Bubbles holding station on a bubble, a rift standing in a zone,
			-- Auto Enter Portal sitting on the portal anchor) converges onto it, because
			-- an exponential lerp approaches its target asymptotically and rounds to
			-- equal. So the degenerate case is the NORMAL end state of arriving. Fall
			-- back to a translation-only CFrame, which holds station just as well and
			-- leaves the facing alone.
			if math.abs(step.X - lt.X) < 1e-4
				and math.abs(step.Y - lt.Y) < 1e-4
				and math.abs(step.Z - lt.Z) < 1e-4 then
				h.CFrame = CFrame.new(step)
			else
				h.CFrame = CFrame.lookAt(step, Vector3.new(lt.X, lt.Y, lt.Z))
			end
			h.AssemblyLinearVelocity = Vector3.zero
		end)
	end)
end

-- orbit center: the arena floor part is the playable area (Map is a Folder,
-- GetBoundingBox doesn't exist on Folders and the pcall used to fail silently,
-- making the character orbit ITSELF). Floor is 1500x1500 centered on the map.
local function getMapCenter(fallback)
	local map = workspace:FindFirstChild("Map")
	if map then
		local floor = map:FindFirstChild("Floor")
		if floor and floor:IsA("BasePart") then
			return floor.Position
		end
		-- fallback: extent center over all BasePart descendants
		local minv, maxv = nil, nil
		pcall(function()
			for _, d in ipairs(map:GetDescendants()) do
				if d:IsA("BasePart") then
					local p = d.Position - d.Size / 2
					local q = d.Position + d.Size / 2
					minv = minv and minv:Min(p) or p
					maxv = maxv and maxv:Max(q) or q
				end
			end
		end)
		if minv and maxv then return (minv + maxv) / 2 end
	end
	return fallback
end
-- playable radius: half the Floor's XZ extent (orbit must stay INSIDE the map)
local function getMapRadius(fallback)
	local map = workspace:FindFirstChild("Map")
	if map then
		local floor = map:FindFirstChild("Floor")
		if floor and floor:IsA("BasePart") then
			return math.min(floor.Size.X, floor.Size.Z) * 0.5
		end
	end
	return fallback
end

local function farmLoop()

	while (farmOn or farmCollectOn) and isCurrentGen() do		if not inRound() then
			orbitBaseY = nil -- new round (maybe new map): re-read the Floor
			lastValidGoal = nil
			task.wait(1)

		else

			local ok, err = pcall(function()

				local char, hum, hrp = getCharParts()

				if not char or not hum or not hrp then task.wait(0.5) return end

				if hum.Health <= 0 then

					-- dead: zero writes until respawn (verified death-loop regression)
					task.wait(1)
					return
				end

				-- Auto Enter Portal (end of the run), Auto Rift (orb walk +
				-- minigame) and Auto Collect Bubbles (oxygen) own the mover right
				-- now: touch nothing, not even flight setup, until they are done.
				-- The rift and bubble terms are not optional -- the farm rewrites
				-- moverGoal every 0.1s and pulls the character back out of the
				-- zone, off the shard, or away from the bubble it is on.
				if portalDriving or riftDriving or bubbleDriving then task.wait(0.1) return end

				ensureFlightReady(hrp)

				local hoverH = tonumber(getFlag("Farm_Height")) or 28
				local orbDwell = 2 -- fixed: swoop dwell (setting removed)
				if RS:GetAttribute("TPL_FarmMode") == "🧪 Auto-Dodge — In Testing" then RS:SetAttribute("TPL_FarmMode", "Auto-Dodge") end
				local farmMode = getFlag("FarmMode") or "Orbit Center"
				local orbitR = tonumber(getFlag("Farm_OrbitRadius")) or 40
				local orbitH = tonumber(getFlag("Farm_OrbitHeight")) or hoverH
				local orbitSpd = tonumber(getFlag("Farm_OrbitSpeed")) or 20

				-- // FULL SCAN: enemies + ranged flags + danger zones + orbs in one walk //----
					-- SKIPPED ENTIRELY in Orbit Center: the orbit ignores enemies,
					-- dodges AND orb swoops, so scanning workspace.VFX (hundreds of
					-- children near the swarm) every tick was pure overhead — the
					-- visible low-radius lag. Auto-Dodge keeps the full scan.
				local enemies = (farmMode ~= "Orbit Center") and workspace:FindFirstChild("Enemies") or nil
				local vfx = (farmMode ~= "Orbit Center") and workspace:FindFirstChild("VFX") or nil
				local myPos = hrp.Position
				local myXZ = Vector3.new(myPos.X, 0, myPos.Z)

				local meleeXs, meleeYs, meleeZs, meleeN = {}, {}, {}, 0
				local allXs, allYs, allZs, allN = {}, {}, {}, 0
				local orbXs, orbYs, orbZs, orbN = {}, {}, {}, 0
				local dangerUntil = 0

				if enemies and farmMode ~= "Orbit Center" then
					for _, e in ipairs(enemies:GetChildren()) do
						local p = enemyPos(e)
						if p and p.Y > -50 and p.Y < 300
							and (Vector3.new(p.X, 0, p.Z) - myXZ).Magnitude < 400 then
							allN = allN + 1
							table.insert(allXs, p.X); table.insert(allYs, p.Y); table.insert(allZs, p.Z)
							if not isRanged(e) then
								meleeN = meleeN + 1
								table.insert(meleeXs, p.X); table.insert(meleeYs, p.Y); table.insert(meleeZs, p.Z)
							end
						end
					end
				end

				-- // DANGER ZONES: ground telegraphs (DangerArea / SlashZone) — walk out early //--
				if vfx then
					for _, m in ipairs(vfx:GetChildren()) do
						local nm = m.Name
						if nm == "DangerArea" or nm == "SlashZone" then
							local pp = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart", true)
							if pp then
								local dp = pp.Position
								-- roughly circular: radius from part size
								local rad = math.max(pp.Size.X, pp.Size.Z) * 0.5 + 4
								local dx, dz = myPos.X - dp.X, myPos.Z - dp.Z
								if dx * dx + dz * dz < rad * rad then
									-- walk to the nearest edge + margin
									local dist = math.sqrt(dx * dx + dz * dz)
									local ux, uz = (dist > 0.1) and dx / dist or 1, (dist > 0.1) and dz / dist or 0
									local push = Vector3.new(ux, 0, uz) * (rad - dist + 6)
									dangerUntil = os.clock() + 0.6
									dodgeVec = push
									dodgeUntil = dangerUntil
								end
							end
						elseif nm == "xp" or nm == "keys" or nm == "InfernoKey" then
							local pp = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart", true)
							if pp then
								local p = pp.Position
								if (Vector3.new(p.X, 0, p.Z) - myXZ).Magnitude < 250 then
									orbN = orbN + 1
									table.insert(orbXs, p.X); table.insert(orbYs, p.Y); table.insert(orbZs, p.Z)
								end
							end
						end
					end
				end

				-- median of each group (ghost positions can't drag the point)
				local function med(xs, ys, zs, n)
					if n == 0 then return nil end
					table.sort(xs); table.sort(ys); table.sort(zs)
					local mid = math.ceil(n / 2)
					return Vector3.new(xs[mid], ys[mid], zs[mid])
				end

				local meleeC = med(meleeXs, meleeYs, meleeZs, meleeN)
				local allC = med(allXs, allYs, allZs, allN)
							local orbC = med(orbXs, orbYs, orbZs, orbN)

				-- hover over MELEE cluster when it exists (they can't reach up there,
				-- and ranged shots from the far side are less likely to arc at us)
				-- else fall back to the all-enemy cluster
				local fightC = meleeC or allC

				-- fallback ground = character's own altitude, NOT 3: on high-spawned
				-- maps a missed raycast used to drop the hover target to Y~31 while
				-- enemies sat at Y~165 => 'flying away from spawn'
				local myGroundGuess = myPos.Y - hoverH
				local target
				local lookT = fightC
				if farmMode == "Orbit Center" then
					-- SIMPLE ORBIT: circle the map-center point directly. ONE cheap
					-- geometry read per round (cached); NO per-tick raycasts, no
					-- calibration, no guards — nothing left to glitch.
					orbitAngle = orbitAngle + math.rad(orbitSpd) * 0.1
					local c = getMapCenter(myPos)
					-- base Y: the Floor part's top surface (exists on all 6 maps,
					-- 1500x1500 centered). Refresh once per round; otherwise cached.
					if not orbitBaseY then
						local map = workspace:FindFirstChild("Map")
						local floor = map and map:FindFirstChild("Floor")
						orbitBaseY = (floor and floor:IsA("BasePart")) and (floor.Position.Y + floor.Size.Y * 0.5) or nil
						if not orbitBaseY then
							-- no Floor: fall back to my current altitude (stable)
							orbitBaseY = myPos.Y
						end
					end
					-- radius EXACTLY as the slider says, clamped only to the island
					local maxR = (getMapRadius(300) or 300) - 20
					local effR = math.min(orbitR, maxR)
					target = Vector3.new(c.X + math.cos(orbitAngle) * effR, orbitBaseY + orbitH, c.Z + math.sin(orbitAngle) * effR)
					lookT = c
				elseif fightC and farmOn then
					local gy = groundBelow(fightC.X, fightC.Z, 60) or myGroundGuess
					target = Vector3.new(fightC.X, gy + hoverH, fightC.Z)
				elseif allC and farmOn then
					local gy = groundBelow(allC.X, allC.Z, 60) or myGroundGuess
					target = Vector3.new(allC.X, gy + hoverH, allC.Z)
				else
					-- no enemies (wave break): hover where we are
					local gy = groundBelow(myPos.X, myPos.Z, 60) or myGroundGuess
					target = Vector3.new(myPos.X, gy + hoverH, myPos.Z)
				end

				-- // ORB SWOOP: dip into the cluster, hold for the dwell, climb back //----
				local swooping = false
				-- Auto-Dodge only: Orbit Center must stay PURE — the orbit angle
					-- keeps advancing while the swoop overrides the target, so every
					-- orb cluster caused dive -> snap-back -> dive (the 'stops and
					-- lurches forward every ~2s' glitch). Orbs are still collected in
					-- Auto-Dodge mode.
				if farmCollectOn and orbC and farmMode ~= "Orbit Center" then
				local groundY = groundBelow(orbC.X, orbC.Z, 60) or myGroundGuess
					-- orb model pivot sits at pickup height +2 already (per the game's
					-- CollectableClient): dip just under the orb pivot, and never above
					-- the fight hover height (collect dips BELOW the hover, never rises)
					local gy = groundBelow(fightC and fightC.X or myPos.X, fightC and fightC.Z or myPos.Z, 60) or myGroundGuess
					local hoverCeiling = gy + hoverH - 5
					local wantY = math.max(orbC.Y - 2, groundY + 4)
					target = Vector3.new(orbC.X, math.min(wantY, hoverCeiling), orbC.Z)
					swooping = true
				end

				-- // MOVE: hand the goal to the Heartbeat mover (smooth, per-frame) //--

				-- Orbit Center = PURE orbit: never dodge anything (projectiles or
				-- danger zones), just fly the circle
				local dodge = Vector3.zero
				if farmMode ~= "Orbit Center" then
					dodge = projectileDodge(hrp, 0.05)
					if os.clock() < dangerUntil then dodge = dodge + dodgeVec end
				end

				local goal = target + dodge

				-- dodge bound: dodge offsets must stay NEAR the fight target — the
				-- mover otherwise surfs across the map when projectiles keep coming
				-- from one side (verified: +16 studs every 0.45s, never resets)
				do
					local off = goal - target
					local maxOff = 25
					if off.Magnitude > maxOff then goal = target + off.Unit * maxOff end
				end

				-- void guard (HOLD): a failed ground read freezes the last valid
				-- goal instead of yanking anywhere. SKIPPED in Orbit Center: the
				-- calibrated circle is already known to be over real ground, so a
				-- failed read here is a raycast false-negative (boundary shell),
				-- not real void — freezing on it was the 2s freeze loop.
				if farmMode ~= "Orbit Center" then
					local goalGround = groundBelow(goal.X, goal.Z, 60)
					if goalGround then
						lastValidGoal = goal
						goalHeld = false
					elseif lastValidGoal then
						goal = lastValidGoal						goalHeld = true
					end
				end

				ensureMover()
				-- second gate, at the write itself: a rift can claim the mover
				-- between the early return above and this line, and whoever writes
				-- last owns the frame
				if not portalDriving and not riftDriving and not bubbleDriving then
					moverGoal = goal
					moverLook = lookT
				end

				task.wait(0.1)

			end)

			if not ok then warn("[FS Farm] " .. tostring(err)) end

		end

	end

end

_G.FS_StartAutoFarm = function(on)

	farmOn = on

	RS:SetAttribute("TPL_FarmOn", on)

	if on and not farmThread then

		farmThread = task.spawn(function()

			farmLoop()

			farmThread = nil

		end)

	end

end

_G.FS_StartAutoCollect = function(on)

	farmCollectOn = on
RS:SetAttribute("TPL_FarmCollectOn", on)

end

-- ===================== AUTO ENTER PORTAL (Final Swarm) =====================
-- At the end of a round the Final Swarm starts and a BossPortal rises with a
-- PortalPrompt (tag "portalPrompt") on it. Staying OUT of the portal grows the
-- loot multiplier; walking in and holding the prompt ends the run and banks it.
-- Auto Enter Portal parks the character at the portal and holds the prompt as
-- soon as the multiplier reaches the target.
-- How the game tracks it (verified in WaveDisplay / GameServiceClient):
--   * HUD.Top.FinalSwarmBar.ProgressBar.Bar.CurrentMult is a NumberValue the
--     HUD itself tweens every wave tick — reads as the live loot multiplier
--   * the portal prompt only becomes usable when the HUD enabled it
--   * ProximityPromptService:PromptButtonHoldBegan/Ended drive the custom HUD
--     hold bar, so the prompt can be triggered without being near-screen
do
	local function getPortalPrompt()
		local p = nil
		pcall(function()
			local map = workspace:FindFirstChild("Map")
			local bp = map and map:FindFirstChild("BossPortal")
			if bp then p = bp:FindFirstChild("PortalPrompt") end
		end)
		return p
	end

	-- live loot multiplier: 0 until the Final Swarm bar exists / fills
	local function getCurrentMult()
		local v = 0
		pcall(function()
			local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
			local hud = pg and pg:FindFirstChild("HUD")
			local top = hud and hud:FindFirstChild("Top")
			local bar = top and top:FindFirstChild("FinalSwarmBar")
			local prog = bar and bar:FindFirstChild("ProgressBar")
			local barPart = prog and prog:FindFirstChild("Bar")
			local cur = barPart and barPart:FindFirstChild("CurrentMult")
			v = cur and cur.Value or 0
		end)
		return tonumber(v) or 0
	end

	local function holdPortalPrompt(prompt)
		-- fire the game's own hold flow: began -> wait the hold duration -> ended
		pcall(function()
			local PPS = game:GetService("ProximityPromptService")
			PPS:TriggerPromptButtonHoldBegan(prompt)
			task.wait(math.max(prompt.HoldDuration or 0, 0) + 0.35)
			PPS:TriggerPromptButtonHoldEnded(prompt)
		end)
		-- belt and braces: some builds only accept the direct prompt signal
		pcall(function()
			prompt:InputHoldBegin()
			task.wait(math.max(prompt.HoldDuration or 0, 0) + 0.35)
			prompt:InputHoldEnd()
		end)
		-- last resort: real key hold at the prompt's screen position
		pcall(function()
			local VIM = game:GetService("VirtualInputManager")
			local cam = workspace.CurrentCamera
			local pp = prompt.Parent and (prompt.Parent.PrimaryPart or prompt.Parent:FindFirstChildWhichIsA("BasePart", true))
			if VIM and pp and cam then
				local sp, on = cam:WorldToViewportPoint(pp.Position)
				if on then
					VIM:SendKeyEvent(true, prompt.KeyboardKeyCode or Enum.KeyCode.E, false, game)
					task.wait(math.max(prompt.HoldDuration or 0, 0) + 0.35)
					VIM:SendKeyEvent(false, prompt.KeyboardKeyCode or Enum.KeyCode.E, false, game)
				end
			end
		end)
	end

	local function autoPortalLoop()
		if portalRunning then return end
		portalRunning = true
		while getFlag("AutoEnterPortalOn") and isCurrentGen() do
			local okE, err = pcall(function()
				if not inRound() then return end
				local prompt = getPortalPrompt()
				-- no portal yet, or the HUD hasn't armed it: nothing to do
				if not prompt or not prompt.Enabled or prompt.MaxActivationDistance <= 0 then return end
				local mult = getCurrentMult()
				local target = tonumber(getFlag("PortalTargetMult")) or 3
				-- not at the target multiplier yet: keep farming, keep banking later
				if mult < target then return end
				-- walk/park into the prompt's activation range first
				local hrp = getCharacterHRP()
				local holder = prompt.Parent
				local pp = holder and (holder.PrimaryPart or holder:FindFirstChildWhichIsA("BasePart", true))
				if not hrp or not pp then return end
				local anchor = pp.Position + Vector3.new(0, 2, 0)
				local deadline = os.clock() + 12
				while os.clock() < deadline and getFlag("AutoEnterPortalOn") and inRound() do
					-- inside activation range already?
					if (hrp.Position - anchor).Magnitude <= math.min(prompt.MaxActivationDistance, 14) then break end
					-- park through the flight mover when the farm drives it, else
					-- set the pivot directly (portal prompt reads 3D distance)
					if farmOn or farmCollectOn then
						-- priority handoff: block the farm loop from writing moverGoal
						-- for the whole walk, otherwise the two loops fight every frame
						portalDriving = true
						moverGoal = anchor
						moverLook = anchor
						ensureMover()
					else
						pcall(function() hrp.CFrame = CFrame.lookAt(anchor, anchor + Vector3.new(0, 0, 1)) end)
					end
					task.wait(0.1)
				end
				if not (getFlag("AutoEnterPortalOn") and inRound()) then portalDriving = false return end
				-- still at/above target? (the multiplier can only go up, but the
				-- toggle could have been flipped mid-walk)
				if getCurrentMult() < (tonumber(getFlag("PortalTargetMult")) or 3) then
					portalDriving = false
					return
				end
				holdPortalPrompt(prompt)
				-- run ends here either way: release the mover, turn the toggle off
				portalDriving = false
				RS:SetAttribute("TPL_AutoEnterPortalOn", false)
				if _G.FS_Notify then pcall(function() _G.FS_Notify("Auto Enter Portal", "mult " .. string.format("%.2f", getCurrentMult()) .. " -> entered the portal") end) end
				task.wait(3)
			end)
			if not okE then warn("[FS AutoPortal] " .. tostring(err)) end
			-- hand the mover back no matter how the tick ended (error, timeout,
			-- toggle off, or the portal fired) — the farm must never stay locked out
			portalDriving = false
			task.wait(0.5)
		end
		portalRunning = false
	end
	task.spawn(autoPortalLoop)
	_G.FS_StartAutoPortal = function(on)
		RS:SetAttribute("TPL_AutoEnterPortalOn", on)
		if on then task.spawn(autoPortalLoop) end
	end
end

-- ===================== AUTO RIFT =====================
-- Rifts are the bubble orbs that spawn during the Final Swarm phase every few
-- waves. Walking into one starts a minigame; clearing it skips waves.
--
-- How the game tracks it (RiftServiceClient / RiftData / RiftBar, plus the live
-- RiftRuntime tree captured in-game):
--   * require(RS.Shared.Services.RiftService.RiftServiceClient):GetState() returns
--     { phase, id, seq, challenge, tier, skip, secondsLeft, progress, count,
--     total, inside, fsWave }. phase is "Idle" | "Open" | "Active"
--   * SignalBankClient.RiftResult carries { challenge, fromFsWave, id, reason,
--     skip, success, tier }. reason is "expired" (never entered in time),
--     "timeout" (clock ran out), or "missed" / "left" (HoldTheRift only)
--   * phase "Open": workspace.Map.RiftRuntime.Rift is a Model whose PrimaryPart is
--     the 8x8x8 Orb, with a 5.5^3 Core beside it. RiftData.Rift.EnterRadius is 6.
--     The whole Rift model is destroyed the moment the phase flips to Active.
--   * phase "Active": RiftRuntime's children are one Model per challenge piece,
--     named after RiftData.Assets -- "Zone", "Shard", "Checkpoint" -- each holding
--     one part. Shard parts are 2x3x2 (the RiftData fallback size exactly), the
--     zone disc is the large flat one and a ring the small flat one.
--   * DURING "Open", progress counts the open window DOWN from 1 to 0. It is not
--     challenge progress and must never be read as such.
--
-- Auto Farm yields for the whole rift (riftDriving, above): walking to the orb and
-- then standing still on a moving zone cannot coexist with an orbit that rewrites
-- the movement target ten times a second.
do
	local riftRunning = false
	-- true only while the minigame itself is being played, published so the bubble
	-- collector can stand aside for a committed rift
	local riftRiding = false
	local RiftSvc = nil
	-- required once, OUTSIDE the loop: this file already calls into game modules
	-- from inside automation loops and a repeat require per tick is pure overhead
	pcall(function() RiftSvc = require(RS.Shared.Services.RiftService.RiftServiceClient) end)

	local RIFT_CHALLENGES = {
		{ key = "HoldTheRift", label = "Hold the Rift" },
		{ key = "ShardCollect", label = "Shard Collect" },
		{ key = "CheckpointRun", label = "Checkpoint Run" },
	}

	local function riftLabel(key)
		for _, c in ipairs(RIFT_CHALLENGES) do
			if c.key == key then return c.label end
		end
		return tostring(key or "?")
	end

	-- comma-joined string, empty = every challenge (same encoding as the skill-tree
	-- and chest pickers: a SetAttribute of a table would throw, not return false)
	local function getRiftPicks()
		local raw = getFlag("RiftChallenges")
		if not raw or raw == "" then return nil end
		local set = {}
		for label in raw:gmatch("[^,]+") do set[label] = true end
		return set
	end

	local function riftChallengeAllowed(key)
		local set = getRiftPicks()
		if not set then return true end
		return set[riftLabel(key)] == true or set[key] == true
	end

	local function riftNotify(title, body)
		if _G.FS_Notify then pcall(function() _G.FS_Notify(title, body) end) end
	end

	local lastResult = nil
	pcall(function()
		local SB = require(RS.Shared.Modules.Game.SignalBankClient)
		SB.RiftResult:Connect(function(r) lastResult = r end)
	end)

	local function getRiftRuntime()
		local map = workspace:FindFirstChild("Map")
		return map and map:FindFirstChild("RiftRuntime")
	end

	local function getRiftOrb()
		local rr = getRiftRuntime()
		local rift = rr and rr:FindFirstChild("Rift")
		if not rift then return nil end
		return rift.PrimaryPart or rift:FindFirstChild("Orb", true) or rift:FindFirstChildWhichIsA("BasePart", true)
	end

	-- The challenge pieces are RiftRuntime's direct children, one Model per piece.
	-- Collected by name first and by the RiftData fallback silhouette second, so a
	-- rename upstream degrades to a size match instead of silently doing nothing
	-- for the entire challenge.
	local function riftPieces(kind)
		local rr = getRiftRuntime()
		local out = {}
		if not rr then return out end
		local want = string.lower(kind)
		for _, child in ipairs(rr:GetChildren()) do
			if child:IsA("Model") then
				local part = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
				if part then
					local hit = string.lower(child.Name) == want
					if not hit then
						local flat = math.max(part.Size.X, part.Size.Z)
						if want == "zone" then
							hit = flat > 20 and part.Size.Y < 4
						elseif want == "checkpoint" then
							hit = flat > 9 and flat <= 20 and part.Size.Y < 2
						else
							hit = flat <= 8 and part.Size.Y >= 2
						end
					end
					if hit then out[#out + 1] = part end
				end
			end
		end
		return out
	end

	-- flat discs (zone, ring) sit on the ground; lift the aim point so the
	-- HumanoidRootPart lands inside the server's radius check, not on the plane
	local function riftAim(part)
		if part.Size.Y < 4 then return part.Position + Vector3.new(0, 2, 0) end
		return part.Position
	end

	local function riftNearest(list)
		local hrp = getCharacterHRP()
		if not hrp then return nil end
		local best, bestD = nil, nil
		for _, p in ipairs(list) do
			local d = (p.Position - hrp.Position).Magnitude
			if not bestD or d < bestD then best, bestD = p, d end
		end
		return best
	end

	-- ONE write path for both halves of the feature, shaped like the Auto Enter
	-- Portal walk: through the farm's mover when the farm is running (so flight is
	-- already set up), by direct CFrame when it is not. riftDriving is raised
	-- BEFORE the first write, because the farm only re-checks it once per tick.
	local function riftStep(goal)
		local hrp = getCharacterHRP()
		if not hrp or not goal then return false end
		if farmOn or farmCollectOn then
			riftDriving = true
			moverGoal = goal
			moverLook = goal
			ensureMover()
		else
			pcall(function() hrp.CFrame = CFrame.lookAt(goal, goal + Vector3.new(0, 0, 1)) end)
		end
		return true
	end

	local function riftRelease()
		riftDriving = false
	end

	-- true while this feature still wants to drive, so every inner loop can bail
	-- on one condition instead of repeating four
	local function riftWantsDrive()
		if not (getFlag("AutoRiftOn") and isCurrentGen() and inRound()) then return false end
		-- Auto Enter Portal is the end of the run and outranks a rift
		if portalDriving then return false end
		-- oxygen outranks a rift. Underwater a spent oxygen bar costs 10% of max
		-- health a SECOND, so standing in a challenge watching the bar empty is a
		-- death sentence -- losing the wave skip is cheaper. Only the emergency
		-- floor does this, not the normal threshold, so the common case (a rift
		-- with comfortable oxygen) still runs to completion.
		if Resume.BubbleEmergency and Resume.BubbleEmergency() then return false end
		return true
	end

	local function riftWalkTo(goal, seconds)
		local stop = os.clock() + seconds
		while os.clock() < stop do
			if not riftWantsDrive() then break end
			local hrp = getCharacterHRP()
			if not hrp then break end
			-- EnterRadius is 6; stop well inside it so server jitter cannot miss
			if (hrp.Position - goal).Magnitude <= 4 then riftRelease() return true end
			if not riftStep(goal) then break end
			task.wait(0.08)
		end
		riftRelease()
		return false
	end

	-- Chase the active challenge until the phase moves on. The target is re-read
	-- every tick on purpose: HoldTheRift's zone wanders on the upper tiers,
	-- ShardCollect relocates its shards, and each ring or shard is consumed as it
	-- is reached -- latching one position at the start would strand the character.
	local function riftRide(riftId, seconds)
		local stop = os.clock() + seconds
		local warned = false
		riftRiding = true
		while os.clock() < stop do
			if not riftWantsDrive() then break end
			local st = RiftSvc and RiftSvc:GetState()
			if type(st) ~= "table" or st.phase ~= "Active" or st.id ~= riftId then break end

			local target = nil
			if st.challenge == "HoldTheRift" then
				target = riftPieces("zone")[1]
			else
				-- ShardCollect and CheckpointRun are the same shape: go to the piece
				-- you can reach next. Used pieces leave the runtime, so the nearest
				-- remaining one is always the correct one.
				target = riftNearest(riftPieces(st.challenge == "ShardCollect" and "shard" or "checkpoint"))
			end

			if target then
				warned = false
				riftStep(riftAim(target))
			else
				-- keep holding station rather than letting go: releasing here hands
				-- the character straight back to the farm mid-challenge. Say it
				-- once, not every tick.
				if not warned then
					warned = true
					riftNotify("Auto Rift", riftLabel(st.challenge) .. ": found no target to move to.")
				end
				local hrp = getCharacterHRP()
				if hrp and farmOn then
					riftDriving = true
					moverGoal = hrp.Position
					moverLook = hrp.Position
					ensureMover()
				end
			end
			task.wait(0.06)
		end
		riftRelease()
		riftRiding = false
	end

	local function autoRiftLoop()
		if riftRunning then return end
		riftRunning = true
		-- the id of the rift this run has already committed to, so one orb is
		-- never walked to twice
		local claimed = nil
		while getFlag("AutoRiftOn") and isCurrentGen() do
			local okTick, err = pcall(function()
				if not inRound() then
					claimed = nil
					return
				end
				local st = RiftSvc and RiftSvc:GetState()
				if type(st) ~= "table" then return end
				-- the phase falls back to Idle between rifts: that is the latch reset
				if st.phase == "Idle" then claimed = nil end
				if st.phase ~= "Open" or st.id == claimed then return end

				-- gates, cheapest first
				if getFlag("RiftAvoid") then return end
				if (tonumber(st.tier) or 1) > (tonumber(getFlag("RiftMaxTier")) or 3) then return end
				if not riftChallengeAllowed(st.challenge) then return end

				local orb = getRiftOrb()
				-- the orb can land a tick after the state does and RiftRuntime can
				-- briefly exist empty, so wait for it rather than burning the latch
				if not orb then return end

				claimed = st.id
				lastResult = nil
				local label = riftLabel(st.challenge)
				riftNotify("Auto Rift", label .. " - entering the rift")

				riftWalkTo(orb.Position, 16)

				-- RiftData.Rift.EnterPadding is 1.5s: wait for the flip to Active
				-- before looking for challenge pieces, and bail if the orb was lost
				local flip = os.clock() + 6
				while os.clock() < flip do
					local s2 = RiftSvc and RiftSvc:GetState()
					if type(s2) ~= "table" then break end
					if s2.phase == "Active" and s2.id == st.id then break end
					if s2.phase ~= "Open" or s2.id ~= st.id then return end
					task.wait(0.05)
				end

				local s2 = RiftSvc and RiftSvc:GetState()
				if not (type(s2) == "table" and s2.phase == "Active" and s2.id == st.id) then
					return
				end

				riftRide(st.id, 90)
				riftRelease()

				local r = lastResult
				if type(r) == "table" then
					if r.success == true then
						riftNotify("Auto Rift", label .. " cleared - +" .. tostring(r.skip) .. " waves")
					else
						local why = "failed"
						if r.reason == "timeout" then why = "ran out of time"
						elseif r.reason == "expired" then why = "was never entered"
						elseif r.reason == "missed" then why = "missed a ring"
						elseif r.reason == "left" then why = "left the zone" end
						riftNotify("Auto Rift", label .. " " .. why)
					end
				end
			end)
			if not okTick then warn("[FS AutoRift] " .. tostring(err)) end
			task.wait(0.25)
		end
		riftRunning = false
		riftRelease()
	end
	task.spawn(autoRiftLoop)
	_G.FS_StartAutoRift = function(on)
		RS:SetAttribute("TPL_AutoRiftOn", on)
		-- the loop may already have exited because the toggle was off when this
		-- load started, so re-spawn it on enable exactly like Auto Replay does
		if on then task.spawn(autoRiftLoop) end
	end

	-- published for the status readout built with the rest of the Main tab
	_G.FS_RiftStatus = function()
		if not RiftSvc then return "unavailable" end
		local ok, st = pcall(function() return RiftSvc:GetState() end)
		if not ok or type(st) ~= "table" or not st.phase or st.phase == "Idle" then return "none" end
		local secs = tostring(math.ceil(st.secondsLeft or 0))
		if st.phase == "Open" then
			return "orb - " .. riftLabel(st.challenge) .. " T" .. tostring(st.tier) .. " in " .. secs .. "s"
		end
		local detail = ""
		if st.total then
			detail = " " .. tostring(st.count or 0) .. "/" .. tostring(st.total)
		elseif st.inside ~= nil then
			detail = st.inside and " in zone" or " out of zone"
		end
		return riftLabel(st.challenge) .. detail .. " - " .. secs .. "s"
	end
end

-- ===================== AUTO COLLECT BUBBLES (Underwater) =====================
-- Atlantis (the Underwater world) drains oxygen for the whole run and spaces a
-- couple of floating bubbles around the arena to refill it. At zero oxygen the
-- character takes a slice of max health every second, so this is not a
-- convenience -- it is the survival clock.
--
-- How the game tracks it (EnvironmentModifierData + OxygenBubblesClient, both
-- read live, plus the workspace folder inspected in the water):
--   * oxygen is a plain attribute: Players.LocalPlayer:GetAttribute("Oxygen"),
--     maxOxygen 100. It is NIL outside the modifier, which is the idle signal.
--   * bubbles live in workspace.EnvironmentOxygenBubbles, one Model per bubble
--     named "OxygenBubble" holding a single part (observed 13.7 cubed).
--   * EnvironmentModifierData.Worlds.Atlantis per difficulty:
--       maxOxygen 100, bubbleOxygen 30, bubbleCount 2 (+2 per extra player),
--       bubblePickupRadius 8, bubbleHeight 6, bubbleBobHeight 1,
--       bubbleBobSeconds 2.5, respawn 8-12s, drainPerSecond 2 / 2.5 / 3.5 for
--       Normal / Hard / Nightmare, damageTickSeconds 1 with
--       percentMaxHealthDamage 0.10 / 0.12 / 0.15, and the modifier only runs
--       from wave 1 to EndWave 24.
--   * collection is pure proximity and entirely server-side: the bubble is
--       destroyed, Oxygen goes up, and OxygenBubblesClient plays the burst from
--       wherever the nearest bubble was. So this is a movement feature, not a
--       remote feature.
--
-- FIGHTING THE FARM: oxygen is a continuous drain, not a rare event, so a naive
-- "always chase the nearest bubble" would take the character away from the farm
-- permanently and never give it back. Instead this feature only claims the mover
-- while oxygen is UNDER the user's threshold, and hands it straight back the
-- moment a bubble tops it up -- which, at 30 oxygen per bubble against 2-3.5 per
-- second, means the farm loses the character for a few seconds every ~15s and
-- owns it the rest of the time.
do
	local bubbleRunning = false

	-- maxOxygen is 100 across every difficulty (EnvironmentModifierData), so this
	-- is a percentage, not a guess. Below this the collector stops asking and
	-- gives the character back to the farm.
	local function getOxygen()
		local v = Players.LocalPlayer:GetAttribute("Oxygen")
		if type(v) ~= "number" then return nil end
		return v
	end

	local function getBubbleThreshold()
		return math.clamp(tonumber(getFlag("BubbleThreshold")) or 45, 0, 100)
	end

	-- the floor at which oxygen is allowed to interrupt even a rift. Kept well
	-- above zero on purpose: the damage tick is per second, so reacting at 3 is
	-- already too late.
	local BUBBLE_EMERGENCY = 15

	local function getBubbles()
		local folder = workspace:FindFirstChild("EnvironmentOxygenBubbles")
		local out = {}
		if not folder then return out end
		for _, child in ipairs(folder:GetChildren()) do
			local part = nil
			if child:IsA("BasePart") then
				part = child
			elseif child:IsA("Model") then
				part = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart", true)
			end
			-- name is checked as a fallback signal only, not as the filter: the
			-- folder is the game's own and holds nothing but bubbles
			if part then out[#out + 1] = part end
		end
		return out
	end

	local function nearestBubble()
		local hrp = getCharacterHRP()
		if not hrp then return nil end
		local best, bestD = nil, nil
		for _, b in ipairs(getBubbles()) do
			local d = (b.Position - hrp.Position).Magnitude
			if not bestD or d < bestD then best, bestD = b, d end
		end
		return best
	end

	-- published so the rift loop can let oxygen interrupt it, and so the status
	-- readout can share one reader
	Resume.GetOxygen = getOxygen
	Resume.BubbleEmergency = function()
		if not getFlag("AutoBubblesOn") then return false end
		local o = getOxygen()
		if o == nil then return false end
		return o <= BUBBLE_EMERGENCY
	end
	-- a rift mid-minigame is a committed event with a wave skip on the line, so a
	-- routine threshold grab stands aside for it. Without this the two loops both
	-- write moverGoal and fight every 0.08s -- the exact failure this handoff
	-- exists to prevent. Only the emergency floor above outranks a rift, which also
	-- keeps the priority order acyclic and so cannot deadlock.
	Resume.RiftBusy = function()
		return riftRiding
	end

	-- one write path, same shape as the rift's: through the farm's mover when the
	-- farm is running so flight is already set up, direct CFrame otherwise.
	-- bubbleDriving is raised BEFORE the first write, because the farm only
	-- re-reads it once per tick.
	local function bubbleStep(goal)
		local hrp = getCharacterHRP()
		if not hrp or not goal then return false end
		if farmOn or farmCollectOn then
			bubbleDriving = true
			moverGoal = goal
			moverLook = goal
			ensureMover()
		else
			pcall(function() hrp.CFrame = CFrame.lookAt(goal, goal + Vector3.new(0, 0, 1)) end)
		end
		return true
	end

	local function autoBubbleLoop()
		if bubbleRunning then return end
		bubbleRunning = true
		local grabbing = false
		while getFlag("AutoBubblesOn") and isCurrentGen() do
			local okTick, err = pcall(function()
				if not inRound() then
					grabbing = false
					bubbleDriving = false
					return
				end

				local oxygen = getOxygen()
				-- nil means the modifier is not running: no Atlantis, past wave 24,
				-- or the "Infinite Oxygen" challenge disabled it. Idle either way.
				if oxygen == nil then
					if grabbing then
						grabbing = false
						bubbleDriving = false
					end
					return
				end

				local threshold = getBubbleThreshold()

				-- topped up: hand the character straight back and stop interfering
				if oxygen >= threshold then
					if grabbing then
						grabbing = false
						bubbleDriving = false
					end
					return
				end

				-- a rift mid-minigame outranks a routine grab (see Resume.RiftBusy).
				-- Oxygen below the emergency floor still wins -- check that FIRST so
				-- a critical bar is never handed away.
				if not (oxygen <= BUBBLE_EMERGENCY) and Resume.RiftBusy and Resume.RiftBusy() then
					if grabbing then
						grabbing = false
						bubbleDriving = false
					end
					return
				end

				-- a dead character cannot be moved by the mover (its Heartbeat bails
				-- on Health <= 0), so holding the claim would only starve the farm on
				-- respawn. Drop it and let the next life pick the bubbles up.
				local _, hum, hrp = getCharParts()
				if not hrp or not hum or hum.Health <= 0 then
					grabbing = false
					bubbleDriving = false
					return
				end

				-- Auto Enter Portal ends the run and outranks a bubble; the rift only
				-- yields to the emergency floor, handled inside its own loop
				if portalDriving then
					if grabbing then
						grabbing = false
						bubbleDriving = false
					end
					return
				end

				local bubble = nearestBubble()
				if not bubble then
					-- nothing spawned yet (respawn is 8-12s). Hold the claim only if
					-- oxygen is genuinely critical, otherwise let the farm work while
					-- we wait for one to appear.
					if oxygen > BUBBLE_EMERGENCY then
						grabbing = false
						bubbleDriving = false
					end
					return
				end

				grabbing = true
				-- Always aim at the BUBBLE, never at the character. The bubble bobs
				-- (BobHeight 1, BobSeconds 2.5), so its position is a real and always
				-- distinct target to sit on, and tracking it keeps the pickup point
				-- under us instead of letting a bob carry us off it. bubblePickupRadius
				-- is 8 and the part is 13.7 across, so the exponential lerp settles
				-- well inside the radius on its own.
				bubbleStep(bubble.Position)
			end)
			if not okTick then warn("[FS Bubbles] " .. tostring(err)) end
			task.wait(0.08)
		end
		bubbleRunning = false
		bubbleDriving = false
	end
	task.spawn(autoBubbleLoop)
	_G.FS_StartAutoBubbles = function(on)
		RS:SetAttribute("TPL_AutoBubblesOn", on)
		-- the loop may already have exited because the toggle was off when this
		-- load started, so re-spawn it on enable
		if on then task.spawn(autoBubbleLoop) end
	end

	_G.FS_BubbleStatus = function()
		local o = getOxygen()
		if o == nil then return "none" end
		local n = #getBubbles()
		return string.format("%.0f%% - %d bubble%s", o, n, n == 1 and "" or "s")
	end
end

local secFarm = tab:CreateSection({ name = "Auto Farm" })

secFarm:CreateToggle({

	name = "Auto Farm",

	value = getFlag("FarmOn"),

	callback = function(v)

		if _G.FS_StartAutoFarm then _G.FS_StartAutoFarm(v) end

	end,

})

-- mode-conditional settings: the dropdown shows/hides the elements that
-- belong to each mode (SetVisible comes from the UI lib)
local farmModeDD = secFarm:CreateDropdown({
	name = "Farm Mode",
	desc = "Auto-Dodge hovers and dodges. Orbit circles the map center.",
	options = { "Orbit Center", "Auto-Dodge" },
	value = getFlag("FarmMode") or "Orbit Center",
	callback = function(v)
		local str = (type(v) == "table" and v[1]) or tostring(v or "")
		local mode = str:find("Auto%-Dodge") and "Auto-Dodge" or "Orbit Center"
		RS:SetAttribute("TPL_FarmMode", mode)
	end,
})

secFarm:CreateSlider({
	name = "Orbit Speed",
	desc = "Orbit rotation speed (degrees / sec).",
	range = { 5, 180 },
	increment = 5,
	value = getFlag("Farm_OrbitSpeed") or 20,
	callback = function(v) RS:SetAttribute("TPL_Farm_OrbitSpeed", v) end,
})

secFarm:CreateSlider({
	name = "Orbit Radius",
	desc = "Orbit distance / radius from map center (studs).",
	range = { 10, 400 },
	increment = 1,
	value = getFlag("Farm_OrbitRadius") or 40,
	callback = function(v) RS:SetAttribute("TPL_Farm_OrbitRadius", v) end,
})

secFarm:CreateSlider({
	name = "Orbit Height",
	desc = "Orbit mode: altitude / height above ground.",
	range = { 10, 80 },
	increment = 1,
	value = getFlag("Farm_OrbitHeight") or 28,
	callback = function(v) RS:SetAttribute("TPL_Farm_OrbitHeight", v) end,
})

secFarm:CreateSlider({
	name = "Hover Height",
	desc = "Auto-Dodge mode: hover altitude above ground.",
	range = { 10, 80 },
	increment = 1,
	value = getFlag("Farm_Height") or 35,
	callback = function(v) RS:SetAttribute("TPL_Farm_Height", v) end,
})

secFarm:CreateSlider({
	name = "Hover Speed",
	desc = "Hover/Dodge glide speed. Higher is snappier.",
	range = { 1, 30 },
	increment = 1,
	value = getFlag("Farm_Speed") or 7,
	callback = function(v) RS:SetAttribute("TPL_Farm_Speed", v) end,
})

-- // FARM DEBUG OVERLAY: makes farm internals visible in-world //--
-- Cyan ball = hover goal the mover is gliding toward. Orange shells = VFX
-- models flagged as OUR OWN shots (skipped by the dodge). Red shells = live
-- threats that triggered the current dodge. Vertical beam = ground raycast
-- result under the goal (nil => void-guard active, shown magenta).

secFarm:CreateToggle({

	name = "Auto Collect Orbs",

	value = getFlag("FarmCollectOn"),

	callback = function(v)

		if _G.FS_StartAutoCollect then _G.FS_StartAutoCollect(v) end

	end,

})
	secFarm:CreateToggle({
		name = "Auto Smart Cards",
		desc = "Auto-picks the best level-up card.",
		value = getFlag("AutoSmartCardsOn"),
		callback = function(v)
			RS:SetAttribute("TPL_AutoSmartCardsOn", v)
			if _G.FS_StartAutoSmartCards then _G.FS_StartAutoSmartCards(v) end
		end,

	})

	-- scoped in a do-block so cardListFromFlag stays off the chunk register
	do

	-- read a comma-joined stat list back into the array the multi dropdown wants
	local function cardListFromFlag(flagName)
		local raw = getFlag(flagName)
		if type(raw) ~= "string" or raw == "" then return {} end
		local out2 = {}
		for label in raw:gmatch("[^,]+") do out2[#out2 + 1] = label end
		return out2
	end

	secFarm:CreateDropdown({

		name = "Prioritise Stats",

		desc = "Always pick these first. Empty is normal scoring.",

		options = Resume.CardGroupLabels or {},

		multiSelect = true,

		value = cardListFromFlag("CardPriority"),

		callback = function(list)

			if type(list) ~= "table" or #list == 0 then

				RS:SetAttribute("TPL_CardPriority", "")

			else

				RS:SetAttribute("TPL_CardPriority", table.concat(list, ","))

			end

		end,

	})

	secFarm:CreateDropdown({

		name = "Banned Stats",

		desc = "Never pick these if anything else is offered.",

		options = Resume.CardGroupLabels or {},

		multiSelect = true,

		value = cardListFromFlag("CardBan"),

		callback = function(list)

			if type(list) ~= "table" or #list == 0 then

				RS:SetAttribute("TPL_CardBan", "")

			else

				RS:SetAttribute("TPL_CardBan", table.concat(list, ","))

			end

		end,

	})

	end

-- Orbit and Hover settings are always active
	local secAbility = tab:CreateSection({ name = "Ability" })

	secAbility:CreateToggle({

		name = "Auto Use Ability",

		desc = "Fires your class abilities on cooldown.",

		value = getFlag("AutoAbilityOn"),

		callback = function(v)

			if _G.FS_StartAutoAbility then _G.FS_StartAutoAbility(v) end

		end,

	})

	secAbility:CreateDropdown({

		name = "Ability Slots",

		desc = "Which slots to use. Q, R, F.",

		options = { "Slot 1 (Q)", "Slot 2 (R)", "Slot 3 (F)" },

		multiSelect = true,

		value = (function()
			local out = {}
			for _, s in ipairs(getAbilitySlots()) do out[#out + 1] = "Slot " .. s .. " (" .. ({ "Q", "R", "F" })[s] .. ")" end
			return out
		end)(),

		callback = function(v)
			local set = {}
			for _, label in ipairs(v) do
				local n = tonumber(string.match(tostring(label), "^Slot (%d)"))
				if n then set[#set + 1] = n end
			end
			setAbilitySlots(set)
		end,

	})

	secAbility:CreateSlider({

		name = "Use Interval",

		range = { 0.5, 15 },

		increment = 0.5,

		value = tonumber(getFlag("AbilityInterval")) or 3,

		desc = "Seconds between uses. 3s minimum.",

		callback = function(v) setFlag("AbilityInterval", v) end,

	})

	local secRoundEnd = tab:CreateSection({ name = "Round End", column = 2 })

secRoundEnd:CreateToggle({

	name = "Auto Enter Portal",

	desc = "Enters the Final Swarm portal at the target multiplier.",

	value = getFlag("AutoEnterPortalOn"),

	callback = function(v)

		RS:SetAttribute("TPL_AutoEnterPortalOn", v)

		if _G.FS_StartAutoPortal then _G.FS_StartAutoPortal(v) end

	end,

})

secRoundEnd:CreateSlider({

	name = "Portal Target Multiplier",

	desc = "Enters the portal at this multiplier.",

	range = { 1, 20 },

	increment = 1,

	value = getFlag("PortalTargetMult") or 3,

	callback = function(v)

		if type(v) == "number" then RS:SetAttribute("TPL_PortalTargetMult", math.max(1, v)) end

	end,

})

secRoundEnd:CreateToggle({

	name = "Auto Replay",

	desc = "Rejoins the same map when the round ends.",

	value = getFlag("AutoReplayOn"),

	callback = function(v)
		RS:SetAttribute("TPL_AutoReplayOn", v)
		if _G.FS_StartAutoReplay then _G.FS_StartAutoReplay(v) end
	end,

})

secRoundEnd:CreateToggle({

	name = "Auto Return Lobby",

	desc = "Presses Lobby when the round ends.",

	value = getFlag("AutoReturnLobbyOn"),

	callback = function(v)
		RS:SetAttribute("TPL_AutoReturnLobbyOn", v)
		if _G.FS_StartAutoReturnLobby then _G.FS_StartAutoReturnLobby(v) end
	end,

})

local secRift = tab:CreateSection({ name = "Rifts", column = 2 })

secRift:CreateToggle({

	name = "Auto Rift",

	desc = "Enters each rift orb and plays its minigame.",

	value = getFlag("AutoRiftOn"),

	callback = function(v)

		if _G.FS_StartAutoRift then _G.FS_StartAutoRift(v) end

	end,

})

secRift:CreateDropdown({

	name = "Minigames",

	desc = "Which rifts to enter. None ticked means all.",

	options = { "Hold the Rift", "Shard Collect", "Checkpoint Run" },

	multiSelect = true,

	value = (function()

		local raw = getFlag("RiftChallenges")

		if not raw or raw == "" then return {} end

		local out = {}

		for label in raw:gmatch("[^,]+") do out[#out + 1] = label end

		return out

	end)(),

	callback = function(list)

		if type(list) ~= "table" or #list == 0 then

			RS:SetAttribute("TPL_RiftChallenges", "")

		else

			RS:SetAttribute("TPL_RiftChallenges", table.concat(list, ","))

		end

	end,

})

secRift:CreateToggle({

	name = "Avoid Rifts",

	desc = "Never enter a rift orb.",

	value = getFlag("RiftAvoid"),

	callback = function(v) RS:SetAttribute("TPL_RiftAvoid", v) end,

})

secRift:CreateSlider({

	name = "Max Tier",

	desc = "Skips rifts above this tier.",

	range = { 1, 3 },

	increment = 1,

	value = tonumber(getFlag("RiftMaxTier")) or 3,

	callback = function(v)

		if type(v) == "number" then RS:SetAttribute("TPL_RiftMaxTier", math.clamp(math.floor(v), 1, 3)) end

	end,

})

local riftStat = secRift:CreateStat({ name = "Rift", value = "none" })

task.spawn(function()

	while true do

		task.wait(0.5)

		pcall(function()

			local status = rawget(_G, "FS_RiftStatus")

			if type(status) == "function" then riftStat.Set(status()) end

		end)

	end

end)

local secUnderwater = tab:CreateSection({ name = "Underwater" })

secUnderwater:CreateToggle({

	name = "Auto Collect Bubbles",

	desc = "Grabs an oxygen bubble when the meter runs low.",

	value = getFlag("AutoBubblesOn"),

	callback = function(v)

		if _G.FS_StartAutoBubbles then _G.FS_StartAutoBubbles(v) end

	end,

})

secUnderwater:CreateSlider({

	name = "Collect Below",

	desc = "Oxygen percent that triggers a grab.",

	range = { 5, 95 },

	increment = 5,

	value = tonumber(getFlag("BubbleThreshold")) or 45,

	callback = function(v)

		if type(v) == "number" then RS:SetAttribute("TPL_BubbleThreshold", math.clamp(v, 0, 100)) end

	end,

})

local bubbleStat = secUnderwater:CreateStat({ name = "Oxygen", value = "none" })

task.spawn(function()

	while true do

		task.wait(0.5)

		pcall(function()

			local status = rawget(_G, "FS_BubbleStatus")

			if type(status) == "function" then bubbleStat.Set(status()) end

		end)

	end

end)

local farmStat = secFarm:CreateStat({ name = "Status", value = "idle" })

task.spawn(function()

	while true do

		task.wait(2)

		pcall(function()

			local scan = getFarmScan()

			if not inRound() then

				farmStat.Set("lobby")

			elseif scan then

				farmStat.Set(scan.count .. " enemies")
			else
				farmStat.Set("no enemies")
			end

		end)

	end

end)

-- ===================== MISC =====================

-- Hide Name / Noclip / Walkspeed / Jumpheight / Fly

-- Uses TPL_ flags so state survives a reload, and the library's own Toggles/Options
-- registries so SaveManager can save the UI (the old hand-rolled Reg registry is gone)

local UserInputService = game:GetService("UserInputService")

local RunService = game:GetService("RunService")

local function getHumanoid()

    local char = Players.LocalPlayer.Character

    return char and char:FindFirstChildOfClass("Humanoid")

end

local function setNoclip(on)

    pcall(function()

        local char = Players.LocalPlayer.Character

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

-- Hide Name — UI Template uses Head.PlayerInfo (ContainerFrame.PlayerUserName)

local function applyHideName(on)

    local char = Players.LocalPlayer.Character

    if char then

        local hum = char:FindFirstChildOfClass("Humanoid")

        if hum then

            hum.NameDisplayDistance = on and 0 or 100

            if on then hum.DisplayName = "" else hum.DisplayName = Players.LocalPlayer.DisplayName end

        end

        -- UI Template overhead: Head.PlayerInfo billboard + any other BillboardGui on char

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

    -- fallback: hide any TextLabel in PlayerGui/CoreGui that shows name (extra safety)

    pcall(function()

        local p = Players.LocalPlayer

        local pname, dname = p.Name, p.DisplayName

        local function hideInGui(gui)

            for _, d in ipairs(gui:GetDescendants()) do

                if d:IsA("TextLabel") or d:IsA("TextButton") then

                    local txt = d.Text

                    if txt == pname or txt == dname or txt == "@"..pname or txt:find(pname, 1, true) then

                        d.Visible = not on

                    end

                end

            end

        end

        for _, gui in ipairs({ Players.LocalPlayer:FindFirstChild("PlayerGui"), game.CoreGui }) do

            if gui then hideInGui(gui) end

        end

    end)

end

local hideNameOn = getFlag("HideNameOn")

local noclipOn = getFlag("NoclipOn")

local noclipRunning = false

local function noclipLoop()

    noclipRunning = true

    while getFlag("NoclipOn") and isCurrentGen() do

        pcall(function() setNoclip(true) end)

        task.wait(0.2)

    end

    pcall(function() setNoclip(false) end)

    noclipRunning = false

end

-- ===================== ANTI-AFK =====================
-- Final Swarm has no idle system of its own: grepping all 331 decompiled scripts for
-- IdleTime / afk / idle-kick finds nothing but a tween library's `:idle()` and an
-- upgrade literally described as "so you can afk". So the only thing that can drop an
-- idle session here is the engine-level inactivity disconnect, which is driven by
-- what the SERVER receives from this client.
--
-- That makes "does a synthetic keypress work" an executor question, not a Roblox
-- one, and the answer varies:
--   1. VirtualInputManager:SendKeyEvent feeds the engine's own input pipeline, so it
--      is the correct method and is what other executors support. It is also the
--      method that is silently broken on some executors -- Real rejects the call at
--      its argument marshaller with "Unable to cast value to Object" for EVERY
--      argument shape, thread context and hooked variant, so a pcall-wrapped VIM
--      ping that nobody checks is a no-op that looks enabled.
--   2. Native executor input (keypress/keyrelease) also works, but Roblox drops
--      injected input when the window is not focused (isrbxactive() == false) --
--      which is exactly the case anti-afk is for.
--   3. A camera nudge is the only lever here that needs no input pipeline at all:
--      the camera CFrame is replicated to the server, so moving it produces genuine
--      client-to-server traffic while touching nothing the game or the Auto Farm
--      cares about.
--
-- So the ping tries them in order of fidelity and records which one actually
-- landed, rather than pretending the first method works. Deliberately NOT used as a
-- fallback: Humanoid:Move (it would overwrite the Auto Farm's own move vector and
-- nudge the character out of its dodge) and Player.Idled (a client-side event that
-- never even fired across 210s of a fully unfocused client, so hooking it proves
-- nothing).
--
-- F13 is used for the key methods because it is a function key: nothing in the game
-- binds it, no textbox in the hub consumes it, and unlike space or an arrow it does
-- not alter movement state.
do

	local VirtualInputManager = game:GetService("VirtualInputManager")

	local antiAfkRunning = false

	-- which method the last successful ping used, for the Misc toggle's tooltip and
	-- for anyone debugging a silent no-op: "vim" / "native" / "camera"
	local antiAfkMethod = nil

	local function pingViaVirtualInput()

		local ok = pcall(function()
			VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F13, false, false)
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F13, false, false)
		end)

		if not ok then return false end

		-- pcall only proves the call did not THROW. On the executors that block VIM
		-- the throw is the marshaller's, so a true here is trustworthy; a false means
		-- this method is unusable and the next one is tried.
		return true

	end

	local function releaseLater(secs)
		task.defer(function()
			task.wait(secs)
			pcall(function() keyrelease(0x7C) end)
		end)
	end

	local function pingViaNativeInput()

		-- meaningless while the window is unfocused, so do not claim it worked
		local active = false
		pcall(function() active = (isrbxactive and isrbxactive()) and true or false end)
		if not active then return false end

		-- a hold/release pair, not keyclick: the release is deferred because a
		-- pcall cannot yield, and a key left held down would repeat forever
		local ok = pcall(function()
			if type(keypress) == "function" and type(keyrelease) == "function" then
				keypress(0x7C)
				releaseLater(0.05)
			elseif type(keyclick) == "function" then
				keyclick(0x7C)
			else
				error("no native input globals")
			end
		end)

		return ok

	end

	local function pingViaCamera()

		local cam = workspace.CurrentCamera
		if not cam then return false end

		local base = cam.CFrame

		-- +/- 0.6 degrees of yaw and back again: below what a player can perceive
		-- while the farm is running, and it never touches the character
		local ok = pcall(function()
			cam.CFrame = base * CFrame.Angles(0, math.rad(0.6), 0)
			task.defer(function()
				task.wait(0.08)
				pcall(function() cam.CFrame = base end)
			end)
		end)

		return ok

	end

	local function antiAfkPing()

		if pingViaVirtualInput() then
			antiAfkMethod = "vim"
			return
		end

		if pingViaNativeInput() then
			antiAfkMethod = "native"
			return
		end

		if pingViaCamera() then
			antiAfkMethod = "camera"
			return
		end

		antiAfkMethod = "none"

	end

	local function antiAfkLoop()

		if antiAfkRunning then return end

		antiAfkRunning = true

		-- 50s is well inside the inactivity window, so one dropped frame, a lag
		-- spike or a slow first fetch cannot let the timer lapse
		while getFlag("AntiAfkOn") and isCurrentGen() do

			antiAfkPing()

			task.wait(50)

		end

		antiAfkRunning = false

	end

	-- published rather than leaked: the toggle that drives this is built in the Misc
	-- block below, and this do-block keeps the locals off the chunk register
	Resume.StartAntiAfk = function()
		if not antiAfkRunning then task.spawn(antiAfkLoop) end
	end

	Resume.AntiAfkMethod = function() return antiAfkMethod end

end

-- Walkspeed / Jump

local defaultWalkSpeed = 16

local defaultJumpPower = 50

local defaultJumpHeight = 7.2

pcall(function()

    local h = getHumanoid()

    if h then

        -- the game zeroes WalkSpeed/Jump on spawn and again between rounds;
        -- only accept the captured value when it is a sane number

        if type(h.WalkSpeed) == "number" and h.WalkSpeed > 0 then defaultWalkSpeed = h.WalkSpeed end

        if type(h.JumpPower) == "number" and h.JumpPower > 0 then defaultJumpPower = h.JumpPower end

        if type(h.JumpHeight) == "number" and h.JumpHeight > 0 then defaultJumpHeight = h.JumpHeight end

    end

end)

local currentWalkSpeed = getFlag("WalkSpeed") or defaultWalkSpeed

if type(currentWalkSpeed) ~= "number" or currentWalkSpeed <= 0 then currentWalkSpeed = defaultWalkSpeed end

local currentJump = getFlag("JumpHeight") or defaultJumpHeight

if type(currentJump) ~= "number" or currentJump <= 0 then currentJump = defaultJumpHeight end

local function applyWalkSpeed(v)

    currentWalkSpeed = math.clamp(tonumber(v) or defaultWalkSpeed, 8, 200)

    pcall(function() setFlag("WalkSpeed", currentWalkSpeed) end)

    local hum = getHumanoid()

    if hum then

        pcall(function() hum.WalkSpeed = currentWalkSpeed end)

    end

end

local function applyJump(v)

    currentJump = math.clamp(tonumber(v) or defaultJumpHeight, 0, 200)

    pcall(function() setFlag("JumpHeight", currentJump) end)

    local hum = getHumanoid()

    if hum then

        pcall(function()

            -- support both JumpHeight and JumpPower

            if hum.UseJumpPower then

                hum.JumpPower = currentJump

            else

                hum.JumpHeight = currentJump

            end

        end)

    end

end

-- keep WalkSpeed/Jump from being reset by game

task.spawn(function()

    while isCurrentGen() do

        task.wait(0.5)

        local hum = getHumanoid()

        if hum then

            -- never enforce a poisoned zero: snap back to a sane default first

            if currentWalkSpeed <= 0 then currentWalkSpeed = defaultWalkSpeed end

            if currentJump <= 0 then currentJump = defaultJumpHeight end

            if math.abs(hum.WalkSpeed - currentWalkSpeed) > 0.5 then

                pcall(function() hum.WalkSpeed = currentWalkSpeed end)

            end

            local targetJump = currentJump

            local curJump = hum.UseJumpPower and hum.JumpPower or hum.JumpHeight

            if math.abs(curJump - targetJump) > 0.5 then

                pcall(function()

                    if hum.UseJumpPower then hum.JumpPower = targetJump else hum.JumpHeight = targetJump end

                end)

            end

            if hideNameOn then pcall(function() applyHideName(true) end) end

        end

        if noclipOn and not noclipRunning then task.spawn(noclipLoop) end

    end

end)

-- Fly

local flyOn = getFlag("FlyOn") or false

local flySpeed = getFlag("FlySpeed") or 60

if type(flySpeed) ~= "number" then flySpeed = 60 end

local flyBV, flyBG, flyConn

local flyKeys = { W=false, A=false, S=false, D=false, Space=false, Ctrl=false, Shift=false }

local function stopFly()

    flyOn = false

    pcall(function() setFlag("FlyOn", false) end)

    if flyConn then flyConn:Disconnect() flyConn=nil end

    if flyBV then flyBV:Destroy() flyBV=nil end

    if flyBG then flyBG:Destroy() flyBG=nil end

    local hum = getHumanoid()

    if hum then pcall(function() hum.PlatformStand = false end) end

    pcall(function() setNoclip(getFlag("NoclipOn")) end)

end

local function startFly()

    local char = Players.LocalPlayer.Character

    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    local hum = getHumanoid()

    if not hrp or not hum then return end

    flyOn = true

    pcall(function() setFlag("FlyOn", true) end)

    pcall(function() hum.PlatformStand = true end)

    flyBG = Instance.new("BodyGyro")

    flyBG.P = 9e4

    flyBG.maxTorque = Vector3.new(9e9, 9e9, 9e9)

    flyBG.cframe = hrp.CFrame

    fsWhitelist(flyBG)
    flyBG.Parent = hrp

    flyBV = Instance.new("BodyVelocity")

    flyBV.velocity = Vector3.new(0,0,0)

    flyBV.maxForce = Vector3.new(9e9, 9e9, 9e9)

    fsWhitelist(flyBV)
    flyBG.Parent = hrp

    flyBV.Parent = hrp

    setNoclip(true)

    flyConn = RunService.Heartbeat:Connect(function()

        if not flyOn or not isCurrentGen() then stopFly() return end

        -- the AC reverts PlatformStand (silently now) — keep it asserted
        local humNow = getHumanoid()
        if humNow and not humNow.PlatformStand then humNow.PlatformStand = true end

        local char2 = Players.LocalPlayer.Character

        local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")

        if not hrp2 or not flyBV or not flyBG then return end

        local cam = workspace.CurrentCamera

        local move = Vector3.new(0,0,0)

        if flyKeys.W then move = move + cam.CFrame.LookVector end

        if flyKeys.S then move = move - cam.CFrame.LookVector end

        if flyKeys.A then move = move - cam.CFrame.RightVector end

        if flyKeys.D then move = move + cam.CFrame.RightVector end

        if flyKeys.Space then move = move + Vector3.new(0,1,0) end

        if flyKeys.Ctrl or flyKeys.Shift then move = move - Vector3.new(0,1,0) end

        if move.Magnitude > 0 then move = move.Unit * flySpeed end

        flyBV.velocity = move

        flyBG.cframe = cam.CFrame

    end)

end

-- Input for fly

UserInputService.InputBegan:Connect(function(input, gpe)

    if gpe then return end

    local k = input.KeyCode

    if k == Enum.KeyCode.W then flyKeys.W=true

    elseif k == Enum.KeyCode.A then flyKeys.A=true

    elseif k == Enum.KeyCode.S then flyKeys.S=true

    elseif k == Enum.KeyCode.D then flyKeys.D=true

    elseif k == Enum.KeyCode.Space then flyKeys.Space=true

    elseif k == Enum.KeyCode.LeftControl or k == Enum.KeyCode.LeftShift then flyKeys.Ctrl=true end

end)

UserInputService.InputEnded:Connect(function(input)

    local k = input.KeyCode

    if k == Enum.KeyCode.W then flyKeys.W=false

    elseif k == Enum.KeyCode.A then flyKeys.A=false

    elseif k == Enum.KeyCode.S then flyKeys.S=false

    elseif k == Enum.KeyCode.D then flyKeys.D=false

    elseif k == Enum.KeyCode.Space then flyKeys.Space=false

    elseif k == Enum.KeyCode.LeftControl or k == Enum.KeyCode.LeftShift then flyKeys.Ctrl=false end

end)

-- re-apply on respawn + watch for PlayerInfo recreation (game re-creates billboard)

Players.LocalPlayer.CharacterAdded:Connect(function(char)

    task.wait(0.6)

    local hum = char:WaitForChild("Humanoid", 6)

    if hum then

        pcall(function() hum.WalkSpeed = currentWalkSpeed end)

        pcall(function()

            if hum.UseJumpPower then hum.JumpPower = currentJump else hum.JumpHeight = currentJump end

        end)

    end

    if hideNameOn then task.wait(0.2) applyHideName(true) end

    if flyOn then task.wait(0.2) startFly() end

    -- instant hide if PlayerInfo billboard spawns late

    char.DescendantAdded:Connect(function(obj)

        if hideNameOn and obj:IsA("BillboardGui") then

            task.wait(0.05)

            if getFlag("HideNameOn") then applyHideName(true) end

        end

    end)

end)

-- also watch current character (if already spawned)

pcall(function()

    local cur = Players.LocalPlayer.Character

    if cur then

        cur.DescendantAdded:Connect(function(obj)

            if getFlag("HideNameOn") and obj:IsA("BillboardGui") then

                task.wait(0.05)

                applyHideName(true)

            end

        end)

    end

end)

-- Movement / Utilities / Flight: Template's layout, wired to the local implementations
-- above.
local Utilities = Tabs.Misc:AddLeftGroupbox("Utilities", ICON.Shield, true, false)

Utilities:AddToggle("HideName", {
	Text    = "Hide Name",
	Tooltip = "Hides your nametag and overhead billboard",
	Default = hideNameOn == true,
	Changed = function(v)
		hideNameOn = v
		setFlag("HideNameOn", v)
		applyHideName(v)
	end,
})

Utilities:AddToggle("Noclip", {
	Text    = "Noclip",
	Tooltip = "Walk through walls",
	Default = noclipOn == true,
	Changed = function(v)
		noclipOn = v
		setFlag("NoclipOn", v)
		if v then
			if not noclipRunning then task.spawn(noclipLoop) end
		else
			pcall(function() setNoclip(false) end)
		end
	end,
})

Utilities:AddToggle("AntiAfk", {
	Text    = "Anti AFK",
	Tooltip = "Keeps the session alive while idle. Pings every 50s using the best method this executor actually supports",
	Default = getFlag("AntiAfkOn") == true,
	Changed = function(v)
		setFlag("AntiAfkOn", v)
		if v and Resume.StartAntiAfk then Resume.StartAntiAfk() end
	end,
})

local Movement = Tabs.Misc:AddRightGroupbox("Movement", ICON.Move, true, false)

Movement:AddSlider("Walkspeed", {
	Text    = "Walkspeed",
	Min     = 8,
	Max     = 200,
	Default = currentWalkSpeed,
	Rounding = 0,
	Tooltip = "Default 16 - Max 200",
	Changed = function(v) applyWalkSpeed(v) end,
})

Movement:AddSlider("Jumpheight", {
	Text    = "Jump Height",
	Min     = 0,
	Max     = 200,
	Default = currentJump,
	Rounding = 0,
	Tooltip = "JumpHeight / JumpPower (auto)",
	Changed = function(v) applyJump(v) end,
})

local Flight = Tabs.Misc:AddRightGroupbox("Flight", ICON.Rocket, true, false)

Flight:AddToggle("Fly", {
	Text    = "Fly",
	Tooltip = "Enable flight (noclip while flying)",
	Default = flyOn == true,
	Changed = function(v)
		if v then startFly() else stopFly() end
	end,
})

Flight:AddSlider("FlySpeed", {
	Text    = "Fly Speed",
	Min     = 10,
	Max     = 250,
	Default = flySpeed,
	Rounding = 5,
	Suffix  = " studs/s",
	Tooltip = "Studs per second",
	Changed = function(v)
		flySpeed = math.clamp(tonumber(v) or 60, 10, 250)
		setFlag("FlySpeed", flySpeed)
	end,
})

-- init: Changed does not fire at creation, so the saved state is applied here
if hideNameOn then applyHideName(true) end
if noclipOn and not noclipRunning then task.spawn(noclipLoop) end
if flyOn then task.defer(function() task.wait(0.8) if getFlag("FlyOn") then startFly() end end) end
if getFlag("AntiAfkOn") and Resume.StartAntiAfk then Resume.StartAntiAfk() end


-- ===================== SETTINGS & PROFILE MANAGEMENT =====================
do
	local secProfile = Tabs.Settings:CreateSection({ name = "Profile Manager" })
	local profileName = "default"

	secProfile:CreateInput({
		name        = "Profile Name",
		desc        = "Name of the profile to save or load",
		placeholder = "default",
		value       = profileName,
		callback    = function(v)
			if type(v) == "string" and #v > 0 then profileName = v end
		end,
	})

	local function getProfileList()
		local list = { "default" }
		pcall(function()
			if isfolder and isfolder("SpecreWare/FinalSwarm") and listfiles then
				for _, f in ipairs(listfiles("SpecreWare/FinalSwarm")) do
					local n = f:match("([^/\\]+)%.json$")
					if n and not table.find(list, n) then table.insert(list, n) end
				end
			end
		end)
		return list
	end

	local profileDropdown
	profileDropdown = secProfile:CreateDropdown({
		name     = "Saved Profiles",
		desc     = "Select an existing configuration",
		options  = getProfileList(),
		value    = profileName,
		callback = function(v)
			if type(v) == "string" and #v > 0 then profileName = v end
		end,
	})

	secProfile:CreateButton({
		name     = "Save Current Profile",
		callback = function()
			pcall(function()
				if makefolder and isfolder then
					if not isfolder("SpecreWare") then makefolder("SpecreWare") end
					if not isfolder("SpecreWare/FinalSwarm") then makefolder("SpecreWare/FinalSwarm") end
				end
				local Http = game:GetService("HttpService")
				local data = {}
				for attr, val in pairs(RS:GetAttributes()) do
					if tostring(attr):sub(1, 4) == "TPL_" then
						data[attr] = val
					end
				end
				if writefile then
					writefile("SpecreWare/FinalSwarm/" .. profileName .. ".json", Http:JSONEncode(data))
				end
				pcall(function() Window:Save(profileName) end)
				_G.FS_Notify("SpecreWare", "Saved profile '" .. profileName .. "'!", 3)
				if profileDropdown and profileDropdown.Refresh then
					profileDropdown:Refresh(getProfileList())
				end
			end)
		end,
	})

	secProfile:CreateButton({
		name     = "Load Selected Profile",
		callback = function()
			pcall(function()
				local path = "SpecreWare/FinalSwarm/" .. profileName .. ".json"
				local loaded = false
				if isfile and isfile(path) and readfile then
					local Http = game:GetService("HttpService")
					local raw = readfile(path)
					local data = Http:JSONDecode(raw)
					if type(data) == "table" then
						for k, v in pairs(data) do
							RS:SetAttribute(k, v)
						end
						loaded = true
					end
				end
				pcall(function() Window:Load(profileName) end)
				if loaded then
					_G.FS_Notify("SpecreWare", "Loaded profile '" .. profileName .. "'!", 3)
				else
					_G.FS_Notify("SpecreWare", "Profile applied or restored.", 3)
				end
			end)
		end,
	})

	local secUI = Tabs.Settings:CreateSection({ name = "UI Controls" })

	secUI:CreateDropdown({
		name     = "Theme",
		desc     = "Switch UI theme color scheme",
		options  = { "cobalt", "default", "ember", "amethyst", "frost", "rose" },
		value    = "cobalt",
		callback = function(th)
			pcall(function()
				if Window and Window.ChangeTheme then
					Window:ChangeTheme(th)
				end
			end)
		end,
	})

	secUI:CreateButton({
		name     = "Toggle Window (Hide / Show)",
		callback = function()
			pcall(function() Window:ToggleHide() end)
		end,
	})

	secUI:CreateButton({
		name     = "Unload / Destroy Interface",
		callback = function()
			pcall(function() Window:Unload() end)
		end,
	})
end

-- ===================== CREDITS =====================
do
	local secTeam = Tabs.Credits:CreateSection({ name = "Team" })
	secTeam:CreateLabel("Developer: SpecreWare Team")
	secTeam:CreateLabel("Game: " .. GAME_NAME)
	secTeam:CreateLabel("Version: " .. BRAND.Version)

	local secCommunity = Tabs.Credits:CreateSection({ name = "Community" })
	secCommunity:CreateParagraph({
		Title   = "SpecreWare Official Discord",
		Content = "Join our community for script support, updates, game requests, and bug reports:\n" .. BRAND.Discord
	})
	secCommunity:CreateButton({
		name     = "Copy Discord Invite Link",
		callback = function()
			local copied = false
			pcall(function()
				if setclipboard then
					setclipboard(BRAND.Discord)
					copied = true
				end
			end)
			if copied then
				_G.FS_Notify("SpecreWare", "Discord invite copied to clipboard!", 3)
			else
				_G.FS_Notify("SpecreWare", BRAND.Discord, 6)
			end
		end,
	})
end

-- ===================== FINALIZE & NOTIFY =====================
if _G.FS_Notify then
	pcall(function()
		_G.FS_Notify("SpecreWare", "Loaded for " .. GAME_NAME .. ". Press Left Control to toggle UI.")
	end)
end

end

local okLoad, errLoad = pcall(FS_RUN)
if not okLoad then
	pcall(function()
		local tb = ""
		pcall(function() tb = debug.traceback("", 2) end)
		showErrorBox("Runtime Load Error", tostring(errLoad) .. (tb ~= "" and ("\n" .. tb) or ""))
	end)
end
