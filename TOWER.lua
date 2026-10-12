--[[
	SpecreWare | Tower Incremental
	UI: SpectreUI v3.17 (dark/cyan-navy Roblox UI library by SpectreWare)
	Theme: Spectre (Dark Graphite / Deep Navy Slate / Electric Cyan / Vivid Blue)
	Brand: SpecreWare
	Discord: https://discord.gg/GdKxvcHzjS
	Game: [UPD3] Tower Incremental by Lucky CStudios
	PlaceId: 75766778174856 / Universe: 10765067592

	Features:
	  • Built with SpectreUI v3.17 with Command Palette (Ctrl+K), Theme & Settings
	  • Sleek Cyber/Spectre Aesthetic with Animated Weather Particles
	  • 2-Column Responsive Section Cards with Collapsible Headers
	  • User Logo (84699118856259) Embedded in Header, Splash & Open Button
	  • 100% of Tower Incremental Game Automation Logic Preserved Intact
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
		if #c > 20000 then Library = loadstring(c)() end
	end
end)

if not Library then
	pcall(function()
		local ok, res = pcall(function()
			return game:HttpGet("https://raw.githubusercontent.com/SpectreWareZ/SpectreWare/refs/heads/main/Tools/Ui/SpectreUI.lua")
		end)
		if ok and type(res) == "string" and #res > 20000 then
			Library = loadstring(res)()
		end
	end)
end

if not Library then
	return warn("[SpecreWare] Failed to load SpectreUI from GitHub. Please check your internet connection or executor.")
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

pcall(function()
	if not game:IsLoaded() then game.Loaded:Wait() end
end)
pcall(function()
	local t0 = os.clock()
	while not Players.LocalPlayer and os.clock() - t0 < 30 do
		task.wait(0.1)
	end
end)
LocalPlayer = Players.LocalPlayer

-- ===================== BRAND (สีฟ้าน้ำเงินเทาดำ) =====================
local BRAND = {
	Name    = "SpecreWare",
	Version = "3.17.0",
	Discord = "https://discord.gg/GdKxvcHzjS",
	Invite  = "discord.gg/GdKxvcHzjS",
	Logo    = "rbxassetid://84699118856259",
	LogoRaw = "84699118856259",

	Deep  = Color3.fromRGB(10, 13, 20),   -- เทาดำลึก (Dark Graphite)
	Navy  = Color3.fromRGB(14, 19, 30),   -- น้ำเงินเทาเข้ม (Dark Navy Slate)
	Mid   = Color3.fromRGB(20, 27, 42),   -- น้ำเงินเทาชั้นกลาง (Cool Navy Slate)
	Cyan  = Color3.fromRGB(56, 189, 248),  -- ฟ้าสว่างนีออน (Electric Cyan / Sky 400)
	Azure = Color3.fromRGB(37, 99, 235),  -- น้ำเงินสด (Vivid Blue)
	Royal = Color3.fromRGB(29, 78, 216),  -- น้ำเงินลึก (Deep Blue)
	Sheen = Color3.fromRGB(186, 230, 253), -- ฟ้าอ่อนประกาย (Ice Sheen)
	Text  = Color3.fromRGB(240, 246, 255), -- ขาวสว่างคมชัด (Crisp White)
}

local ICON = {
	Drops    = "lucide:droplet",
	Bolt     = "lucide:zap",
	Crown    = "lucide:crown",
	Shield   = "lucide:shield",
	Terminal = "lucide:terminal",
	Question = "lucide:circle-help",
	Star     = "lucide:star",
	Rocket   = "lucide:rocket",
	Heart    = "lucide:heart",
	Gamepad  = "lucide:gamepad-2",
	Spark    = "lucide:sparkles",
	Dot      = "lucide:dot",
	Key      = "lucide:key",
	House    = "lucide:house",
	Home     = "lucide:house",
	Package  = "lucide:package",
	Egg      = "lucide:egg",
	Coins    = "lucide:coins",
	Gift     = "lucide:gift",
	Dumbbell = "lucide:dumbbell",
	Flask    = "lucide:flask-conical",
	Cart     = "lucide:shopping-cart",
	Trend    = "lucide:arrow-up-right",
	Move     = "lucide:move",
	Gem      = "lucide:gem",
	ShieldOK = "lucide:shield-check",
	Gear     = "lucide:settings",
	Layers   = "lucide:layers",
	Pickaxe  = "lucide:pickaxe",
	Tree     = "lucide:trees",
	Tower    = "lucide:castle",
}

local LOAD_GEN = math.floor(os.clock() * 100000) % 1000000 + 1
pcall(function() ReplicatedStorage:SetAttribute("LH_LoadGen", LOAD_GEN) end)
local function isCurrentGen()
	return ReplicatedStorage:GetAttribute("LH_LoadGen") == LOAD_GEN
end

local Failures = {}
local function publishFailures()
	pcall(function() if getgenv then getgenv().LH_Failures = Failures end end)
end

local function logFail(where, err)
	local entry = string.format("[%s] %s", where, tostring(err))
	table.insert(Failures, entry)
	if #Failures > 40 then table.remove(Failures, 1) end
	publishFailures()
end

local FireFailed = {}
local function fire(remote, label, ...)
	local argc = select("#", ...)
	local args = table.pack(...)
	if not remote then
		if not FireFailed[label] then
			FireFailed[label] = true
			logFail(label, "remote is nil")
		end
		return false
	end
	local ok, err = pcall(function() remote:FireServer(table.unpack(args, 1, argc)) end)
	if not ok then
		if not FireFailed[label] then
			FireFailed[label] = true
			logFail(label, tostring(err))
		end
		return false
	end
	if FireFailed[label] then FireFailed[label] = nil end
	return true
end

-- ===================== GAME DETECTION =====================
local GAME_NAME = "Tower Incremental"
do
	local pid = game.PlaceId
	local ok, name = pcall(function()
		local Http = game:GetService("HttpService")
		local res = game:HttpGet("https://apis.roblox.com/universes/v1/places/" .. pid .. "/universe")
		local universeId = Http:JSONDecode(res).universeId
		local res2 = game:HttpGet("https://games.roblox.com/v1/games?universeIds=" .. universeId)
		return Http:JSONDecode(res2).data[1].name
	end)
	if ok and type(name) == "string" and #name > 0 then
		GAME_NAME = name
	else
		pcall(function()
			for _, attr in ipairs({ "GameName", "PlaceName", "DisplayName" }) do
				local v = ReplicatedStorage:GetAttribute(attr)
				if type(v) == "string" and #v > 0 then GAME_NAME = v break end
			end
		end)
	end
end

-- ===================== REGISTER SPECTRE THEME =====================
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
			FX         = "rain",
		}
	end
end)

-- ===================== CREATE SPECTRE UI WINDOW =====================
pcall(function()
	if Library and Library.AutoCheck then
		Library.AutoCheck.Skip = { TextClip = true }
	end
end)

local Window = Library:CreateWindow({
	Title      = "SpecreWare | Tower Incremental",
	Logo       = 84699118856259,
	ToggleKey  = Enum.KeyCode.RightControl,
	Theme      = "Spectre",
	StagedLoad = false,
	AutoCheck  = {
		Skip = { TextClip = true },
	},
	Splash     = {
		Subtitle  = "TOWER INCREMENTAL",
		Duration  = 2.2,
		Steps     = { "Checking remotes", "Loading Tower Incremental", "Preparing interface", "Ready!" },
		Logo      = 84699118856259,
		Skippable = true,
	},
})

-- Multi-keybind support: LeftControl, RightControl, RightShift
pcall(function()
	UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.RightShift then
			pcall(function() Window:Toggle() end)
		end
	end)
end)

-- Safe splash status
local function splashStatus(text)
	pcall(function()
		if Window and Window.Notify then
			Window:Notify({ Title = BRAND.Name, Content = tostring(text or ""), Duration = 2.5, Kind = "Info" })
		end
	end)
end

local function splashClose() end

-- ===================== SPECTRE UI ADAPTER =====================
local Toggles = {}
local Options = {}
Library.Toggles = Toggles
Library.Options = Options

local function wrapElement(rawObj, extraCb)
	local watchers = {}
	local wrapped = {
		_raw = rawObj,
		OnChanged = function(self, fn)
			if type(fn) == "function" then
				table.insert(watchers, fn)
				pcall(function()
					local val = self:Get()
					if val ~= nil then fn(val) end
				end)
			end
		end,
		_fire = function(self, v)
			for _, fn in ipairs(watchers) do
				pcall(fn, v)
			end
			if extraCb then
				pcall(extraCb, v)
			end
		end,
	}

	function wrapped:Get()
		if rawObj and rawObj.Get then
			local ok, res = pcall(function() return rawObj:Get() end)
			if ok and res ~= nil then return res end
		end
		return nil
	end

	function wrapped:Set(v, silent)
		if self ~= wrapped and self ~= rawObj and silent == nil then
			silent = v
			v = self
		end
		pcall(function()
			if rawObj and rawObj.Set then
				rawObj:Set(v, silent)
			else
				if not silent then self:_fire(v) end
			end
		end)
	end
	wrapped.SetValue = wrapped.Set

	wrapped.Changed = function(...)
		local args = table.pack(...)
		local v = args[1]
		if (v == wrapped or v == rawObj) and args.n >= 2 then
			v = args[2]
		end
		wrapped:Set(v)
	end

	function wrapped:Refresh(list)
		pcall(function()
			if rawObj and rawObj.Refresh then rawObj:Refresh(list or {}) end
		end)
	end
	wrapped.SetValues = wrapped.Refresh
	wrapped.Select = wrapped.Set
	wrapped.SetText = function(self, t)
		pcall(function()
			if rawObj and rawObj.Set then rawObj:Set(t) end
		end)
	end
	wrapped.SetVisible = function(self, v)
		pcall(function()
			if rawObj and rawObj.SetVisible then rawObj:SetVisible(v) end
		end)
	end

	return setmetatable(wrapped, {
		__index = function(_, k)
			if k == "Value" or k == "value" or k == "state" or k == "selected" or k == "Text" or k == "text" then
				local val = wrapped:Get()
				if type(val) == "table" then
					return setmetatable(val, {
						__index = function(tbl, subK)
							for _, item in ipairs(tbl) do
								if item == subK then return true end
							end
							return nil
						end,
					})
				end
				return val
			end
			if rawObj and rawObj[k] ~= nil then return rawObj[k] end
			return nil
		end,
		__newindex = function(_, k, v)
			if k == "Value" or k == "value" or k == "state" or k == "selected" or k == "Text" or k == "text" then
				wrapped:Set(v)
			else
				rawset(wrapped, k, v)
			end
		end,
	})
end

local function adaptSection(rawSec)
	local box = { _raw = rawSec }

	function box:AddToggle(name, info)
		info = info or {}
		local cb = info.Callback or info.Changed
		local wrapped
		local el = rawSec:CreateToggle({
			Name = info.Text or name,
			Default = info.Default and true or false,
			Flag = name,
			Tooltip = info.Tooltip,
			Callback = function(v)
				if wrapped then
					wrapped:_fire(v)
				elseif cb then
					pcall(cb, v)
				end
			end,
		})
		wrapped = wrapElement(el, cb)
		Toggles[name] = wrapped
		Options[name] = wrapped
		return wrapped
	end

	function box:AddSlider(name, info)
		info = info or {}
		local mn = tonumber(info.Min) or 0
		local mx = tonumber(info.Max) or 100
		local inc = tonumber(info.Rounding) or tonumber(info.Step) or 1
		if inc <= 0 then inc = 1 end
		local cb = info.Callback or info.Changed
		local wrapped
		local el = rawSec:CreateSlider({
			Name = info.Text or name,
			Min = mn,
			Max = mx,
			Increment = inc,
			Suffix = info.Suffix or "",
			Default = tonumber(info.Default) or mn,
			Flag = name,
			Tooltip = info.Tooltip,
			Callback = function(v)
				if wrapped then
					wrapped:_fire(v)
				elseif cb then
					pcall(cb, v)
				end
			end,
		})
		wrapped = wrapElement(el, cb)
		Options[name] = wrapped
		return wrapped
	end

	function box:AddDropdown(name, info)
		info = info or {}
		local cb = info.Callback or info.Changed
		local vals = info.Values or info.options or {}
		local isMulti = (info.Multi or info.MultipleOptions) and true or false
		local defaultVal = info.Default
		if isMulti and type(defaultVal) == "table" and not defaultVal[1] then
			local arr = {}
			for k, v in pairs(defaultVal) do
				if v == true then table.insert(arr, k) end
			end
			defaultVal = arr
		end
		local wrapped
		local el = rawSec:CreateDropdown({
			Name = info.Text or name,
			Options = vals,
			Default = defaultVal,
			Multi = isMulti,
			Flag = name,
			Tooltip = info.Tooltip,
			Callback = function(v)
				if wrapped then
					wrapped:_fire(v)
				elseif cb then
					pcall(cb, v)
				end
			end,
		})
		wrapped = wrapElement(el, cb)
		Options[name] = wrapped
		return wrapped
	end

	function box:AddInput(name, info)
		info = info or {}
		local cb = info.Callback or info.Changed
		local currentText = tostring(info.Default or "")
		local wrapped
		local el = rawSec:CreateTextbox({
			Name = info.Text or name,
			Placeholder = info.Placeholder or "",
			Default = currentText,
			Flag = name,
			Tooltip = info.Tooltip,
			Callback = function(txt)
				currentText = tostring(txt or "")
				if wrapped then
					wrapped:_fire(currentText)
				elseif cb then
					pcall(cb, currentText)
				end
			end,
		})
		wrapped = wrapElement(el, cb)
		wrapped.Get = function() return currentText end
		wrapped.Set = function(self, val)
			currentText = tostring(val or "")
			pcall(function() if el.Set then el:Set(currentText) end end)
			if wrapped then wrapped:_fire(currentText) end
		end
		Options[name] = wrapped
		return wrapped
	end

	function box:AddKeybind(name, info)
		info = info or {}
		local cb = info.Callback or info.Changed
		local defaultKey = info.Default or info.CurrentKeybind or Enum.KeyCode.RightControl
		local wrapped
		local el = rawSec:CreateKeybind({
			Name = info.Text or name,
			Default = defaultKey,
			Mode = "Toggle",
			Flag = name,
			Tooltip = info.Tooltip,
			Callback = function(k)
				if wrapped then
					wrapped:_fire(k)
				elseif cb then
					pcall(cb, k)
				end
			end,
		})
		wrapped = wrapElement(el, cb)
		Options[name] = wrapped
		return wrapped
	end

	function box:AddButton(name, info)
		local bName = (type(info) == "table" and (info.Text or info.name)) or name
		local cb = (type(info) == "table" and info.Callback) or (type(info) == "function" and info) or function() end
		local el = rawSec:CreateButton({
			Name = bName,
			Callback = cb,
		})
		return wrapElement(el, cb)
	end

	function box:AddLabel(info)
		local txt = (type(info) == "table" and (info.Text or info.text)) or tostring(info or "")
		local el = rawSec:CreateLabel({ Text = txt })
		local wrapped = wrapElement(el)
		wrapped.SetText = function(self, t)
			pcall(function() if el.Set then el:Set(tostring(t or "")) end end)
		end
		return wrapped
	end

	function box:AddDivider()
		return rawSec:CreateDivider()
	end

	return setmetatable(box, {
		__index = function(_, k)
			local rawVal = rawget(rawSec, k)
			if rawVal ~= nil then return rawVal end
			return nil
		end,
	})
end

local function adaptSubTab(rawTab, subName)
	local sub = { _tab = rawTab, _name = subName }

	function sub:AddLeftGroupbox(name, icon)
		local secName = type(name) == "table" and (name.Name or name.Text) or name
		local secIcon = (type(name) == "table" and name.Icon) or icon
		local s = rawTab:CreateSection({ Name = secName, Column = 1, Icon = secIcon })
		return adaptSection(s)
	end

	function sub:AddRightGroupbox(name, icon)
		local secName = type(name) == "table" and (name.Name or name.Text) or name
		local secIcon = (type(name) == "table" and name.Icon) or icon
		local s = rawTab:CreateSection({ Name = secName, Column = 2, Icon = secIcon })
		return adaptSection(s)
	end

	function sub:AddGroupbox(info)
		local name = type(info) == "table" and (info.Name or info.Text) or info
		local col = (type(info) == "table" and info.Side == "Right") and 2 or 1
		local icon = type(info) == "table" and info.Icon or nil
		local s = rawTab:CreateSection({ Name = name, Column = col, Icon = icon })
		return adaptSection(s)
	end

	return sub
end

local function adaptTab(rawTab)
	local tab = { _raw = rawTab }

	function tab:AddSubTab(name, icon)
		return adaptSubTab(rawTab, name)
	end

	function tab:AddLeftGroupbox(name, icon)
		local secName = type(name) == "table" and (name.Name or name.Text) or name
		local secIcon = (type(name) == "table" and name.Icon) or icon
		local s = rawTab:CreateSection({ Name = secName, Column = 1, Icon = secIcon })
		return adaptSection(s)
	end

	function tab:AddRightGroupbox(name, icon)
		local secName = type(name) == "table" and (name.Name or name.Text) or name
		local secIcon = (type(name) == "table" and name.Icon) or icon
		local s = rawTab:CreateSection({ Name = secName, Column = 2, Icon = secIcon })
		return adaptSection(s)
	end

	function tab:AddGroupbox(info)
		local name = type(info) == "table" and (info.Name or info.Text) or info
		local col = (type(info) == "table" and info.Side == "Right") and 2 or 1
		local icon = type(info) == "table" and info.Icon or nil
		local s = rawTab:CreateSection({ Name = name, Column = col, Icon = icon })
		return adaptSection(s)
	end

	function tab:AddPlayerInfo(name, info)
		local s = rawTab:CreateSection({ Name = "Player Info", Column = 2, Icon = "lucide:user" })
		local pName = LocalPlayer and (LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")") or "Player"
		local uId = LocalPlayer and tostring(LocalPlayer.UserId) or "0"
		s:CreateLabel({ Text = "👤 " .. pName, Bold = true, Color = BRAND.Cyan })
		s:CreateLabel({ Text = "🆔 UserId: " .. uId })
		s:CreateLabel({ Text = "🎮 " .. GAME_NAME .. " | " .. BRAND.Name })
		return adaptSection(s)
	end

	return setmetatable(tab, {
		__index = function(_, k)
			local rawVal = rawget(rawTab, k)
			if rawVal ~= nil then return rawVal end
			return nil
		end,
	})
end

-- ===================== LIBRARY & SAVEMANAGER SHIM =====================
pcall(function()
	Library.Toggles = Toggles
	Library.Options = Options
	Library.Flags   = Library.Flags or {}
	local _oldNotify = Library.Notify
	Library.Notify = function(self, o)
		o = o or {}
		local title = o.Title or o.title or BRAND.Name
		local desc  = o.Description or o.description or o.Content or o.content or o.Text or o.text or ""
		local dur   = o.Time or o.time or o.Duration or o.duration or 4
		local nType = o.Type or o.type or o.Kind or o.kind or "Info"
		if nType == "Error" then nType = "Warning" end
		pcall(function()
			if Window and Window.Notify then
				Window:Notify({
					Title    = title,
					Content  = desc,
					Duration = dur,
					Kind     = nType,
				})
			elseif _oldNotify then
				_oldNotify(self, {
					Title    = title,
					Content  = desc,
					Duration = dur,
					Kind     = nType,
				})
			end
		end)
	end
	Library.SetFont = function() end
	Library.UpdateColorsUsingRegistry = function() end
	Library.GetCustomIcon = function(self, icon) return icon end
end)

local LibraryShim = Library

local SaveManager = {
	SetLibrary = function() end,
	IgnoreThemeSettings = function() end,
	SetIgnoreIndexes = function() end,
	SetFolder = function() end,
	BuildConfigSection = function(self, tab)
		pcall(function()
			-- In SpectreUI, Window:CreateSettingsTab() builds the comprehensive config manager,
			-- hotkey binder, window controls, and unload button.
			local target = tab._raw or tab
			local menuSec = target:CreateSection({ Name = "Menu & Utilities", Column = 1, Icon = "lucide:shield-check" })
			
			local afkVal = false
			pcall(function()
				if getFlag then afkVal = getFlag("AntiAfkOn") ~= false end
			end)

			menuSec:CreateToggle({
				Name = "Anti AFK",
				Default = afkVal,
				Flag = "AntiAFK_Menu",
				Callback = function(v)
					pcall(function()
						if setFlag then setFlag("AntiAfkOn", v == true) end
						if Toggles and Toggles.AntiAFK and Toggles.AntiAFK.Value ~= v then
							Toggles.AntiAFK:Set(v)
						end
					end)
				end,
			})
			
			menuSec:CreateButton({
				Name = "Unload Script",
				Callback = function()
					pcall(function()
						Window:Notify({ Title = BRAND.Name, Content = "Unloading script...", Duration = 2 })
					end)
					task.wait(0.2)
					pcall(function() ReplicatedStorage:SetAttribute("LH_LoadGen", 0) end)
					pcall(function() Library:Unload() end)
				end,
			})
		end)
	end,
}

local Tabs = {}
do
	local rawMain        = Window:CreateTab({ Name = "MAIN", Icon = "lucide:house" })
	local rawFarming     = Window:CreateTab({ Name = "FARMING", Icon = "lucide:zap" })
	local rawProgression = Window:CreateTab({ Name = "PROGRESSION", Icon = "lucide:chevrons-up" })
	local rawMisc        = Window:CreateTab({ Name = "MISC", Icon = "lucide:gamepad-2" })
	local rawSettings    = Window:CreateTab({ Name = "CONFIGS", Icon = "lucide:folder" })
	local rawCredits     = Window:CreateTab({ Name = "CREDITS", Icon = "lucide:star" })

	Tabs.Main        = adaptTab(rawMain)
	Tabs.Farming     = adaptTab(rawFarming)
	Tabs.Progression = adaptTab(rawProgression)
	Tabs.Misc        = adaptTab(rawMisc)
	Tabs.Settings    = adaptTab(rawSettings)
	Tabs.Credits     = adaptTab(rawCredits)
end

-- Preserved automation chunk begins below

-- ===================== GAME WIRING =====================
-- Tower Incremental has NO leaderstats. Every number lives in the DataService
-- client mirror, which the server keeps in sync. So the hub reads state through
-- DS:get(...) and never through an IntValue it hopes is current.
--
-- Nothing here is guessed: Spec/75766778174856.json records the probe results
-- behind every shape and reach gate below.

splashStatus("Waiting for game data...")

local function getHumanoid()
	local char = LocalPlayer.Character
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
	local char = LocalPlayer.Character
	return char and char:FindFirstChild("HumanoidRootPart")
end

-- DataService. Requires Packages.DataService, not Packages.DataService.server:
-- the client half is the mirror with get/update/getChangedSignal.
local DS = nil
do
	local pkgs = ReplicatedStorage:FindFirstChild("Packages")
	local mod = pkgs and pkgs:FindFirstChild("DataService")
	local ok, loaded = pcall(require, mod)
	if ok and type(loaded) == "table" and loaded.client then DS = loaded.client end
end

if not DS then
	Library:Notify({
		Title = BRAND.Name,
		Description = "DataService.client not found - join the game and re-inject.",
		Time = 8,
		Type = "Error",
	})
	splashClose()
	return
end

-- Wait for the mirror, otherwise the first reads return nil and every cost
-- comparison reads as "free".
do
	local deadline = os.clock() + 20
	while not DS._data and os.clock() < deadline do
		if LocalPlayer:GetAttribute("DataReady") == true then break end
		task.wait(0.2)
	end
end

-- The remotes folder. Every name below exists in Shared.Remotes' own list, so a
-- nil here means the game version changed, not that the player did anything.
local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes", 15)
if not RemotesFolder then
	Library:Notify({ Title = BRAND.Name, Description = "Remotes folder not found. Join the game first.", Time = 6, Type = "Error" })
	splashClose()
	return
end

local function waitRemote(name)
	local success, instance = pcall(function()
		return RemotesFolder:WaitForChild(name, 8)
	end)
	if success then return instance end
	return nil
end

local BuyStairRemote         = waitRemote("BuyStair")
local BuyUpgradeRemote       = waitRemote("BuyUpgrade")
local MineBlockRemote        = waitRemote("MineBlock")
local UnlockDoorRemote       = waitRemote("UnlockDoor")
local BuyTreeNodeRemote      = waitRemote("BuyTreeNode")
local BuyPotionRemote        = waitRemote("BuyPotion")
local RebirthRemote          = waitRemote("Rebirth")
local SpinWheelRemote        = waitRemote("SpinWheel")
local SmelterDepositRemote   = waitRemote("SmelterDeposit")
local SmelterCollectRemote   = waitRemote("SmelterCollect")
local StarforgeDepositRemote = waitRemote("StarforgeDeposit")
local RefractorDepositRemote = waitRemote("RefractorDeposit")
local TotemRemote            = waitRemote("Totem")
local SaveSettingRemote      = waitRemote("SaveSetting")
local RedeemCodeRemote       = waitRemote("RedeemCode")
local EquipTrailRemote       = waitRemote("EquipTrail")
local BuyTrailRemote        = waitRemote("BuyTrail")
local EssenceRemote          = waitRemote("Essence")

-- Which of them actually resolved. Surfaced on Main, because a silently nil
-- remote is the single hardest failure to diagnose from the outside: the toggle
-- flips, the loop ticks, and nothing happens.
local REMOTE_TOTAL = 17
local REMOTE_COUNT = 0
for _, r in ipairs({
	BuyStairRemote, BuyUpgradeRemote, MineBlockRemote, UnlockDoorRemote,
	BuyTreeNodeRemote, BuyPotionRemote, RebirthRemote, SpinWheelRemote,
	SmelterDepositRemote, SmelterCollectRemote, StarforgeDepositRemote,
	RefractorDepositRemote, TotemRemote, SaveSettingRemote, EquipTrailRemote,
	EssenceRemote, BuyTrailRemote,
}) do
	if r then REMOTE_COUNT += 1 end
end

if REMOTE_COUNT < REMOTE_TOTAL then
	warn(string.format(
		"[SpecreWare] %d/%d remotes resolved - features using the missing ones will do nothing",
		REMOTE_COUNT, REMOTE_TOTAL))
end

-- Config modules. All of these are plain tables and safe to require client-side;
-- the game's own UI reads the same ones, so no cost is ever retyped here.
--
-- require() is retried with a wait rather than fired once. A module can be present
-- but not yet initialised when the hub loads, and a single pcall(require) at that
-- moment returns nil and leaves the whole hub silently dead - which is exactly the
-- failure this block is instrumented against.
local Shared = ReplicatedStorage:WaitForChild("Shared", 10)

local ConfigErrors = {}

local function requireShared(name)
	if not Shared then
		ConfigErrors[name] = "ReplicatedStorage.Shared is missing"
		return nil
	end
	local module = Shared:FindFirstChild(name)
	if not module then
		ConfigErrors[name] = "module instance not found"
		return nil
	end

	-- Three attempts with a short gap. The first one at load time, then two more
	-- in case the module was mid-initialisation.
	for attempt = 1, 3 do
		local success, result = pcall(require, module)
		if success and type(result) == "table" then
			ConfigErrors[name] = nil
			return result
		end
		ConfigErrors[name] = (success and "returned " .. type(result) or tostring(result))
		if attempt < 3 then task.wait(0.4) end
	end
	return nil
end

local StairConfig     = requireShared("StairConfig")
local UpgradeConfig   = requireShared("UpgradeConfig")
local RebirthConfig   = requireShared("RebirthConfig")
local DoorConfig      = requireShared("DoorConfig")
local MineConfig      = requireShared("MineConfig")
local PotionConfig    = requireShared("PotionConfig")
local WheelConfig     = requireShared("WheelConfig")
local SmelterConfig   = requireShared("SmelterConfig")
local StarforgeConfig = requireShared("StarforgeConfig")
local RefractorConfig = requireShared("RefractorConfig")
local TotemConfig     = requireShared("TotemConfig")
local GlyphConfig     = requireShared("GlyphConfig")
local TreeConfig     = requireShared("TreeConfig")
local TrailConfig     = requireShared("TrailConfig")

do
	local missing, details = {}, {}
	for name, value in pairs({
		StairConfig = StairConfig, UpgradeConfig = UpgradeConfig,
		RebirthConfig = RebirthConfig, DoorConfig = DoorConfig,
		MineConfig = MineConfig, PotionConfig = PotionConfig,
		WheelConfig = WheelConfig, SmelterConfig = SmelterConfig,
		StarforgeConfig = StarforgeConfig, RefractorConfig = RefractorConfig,
		TotemConfig = TotemConfig, GlyphConfig = GlyphConfig,
		TrailConfig = TrailConfig, TreeConfig = TreeConfig,
	}) do
		if not value then
			table.insert(missing, name)
			table.insert(details, name .. "=" .. tostring(ConfigErrors[name]))
		end
	end
	if #missing > 0 then
		warn("[SpecreWare] missing config modules: " .. table.concat(missing, ", ")
			.. " - features depending on them will do nothing")
	end
	-- Published so a dead config load is readable from outside the script:
	--   ReplicatedStorage:GetAttribute("LH_CfgStatus")
	-- Written inline because the flag helpers are defined further down, after the
	-- upgrade/door lists that depend on these modules.
	pcall(function()
		ReplicatedStorage:SetAttribute("LH_CfgStatus", #missing == 0
			and "all 14 config modules loaded"
			or table.concat(details, " | "))
	end)
end

-- ===================== STATE READS =====================

local function num(key)
	local ok, v = pcall(function() return DS:get(key) end)
	if ok and type(v) == "number" then return v end
	return 0
end

local function numAt(path)
	local ok, v = pcall(function() return DS:get(path) end)
	if ok and type(v) == "number" then return v end
	return 0
end

local function tblAt(path)
	local ok, v = pcall(function() return DS:get(path) end)
	if ok and type(v) == "table" then return v end
	return {}
end

local function getGold()      return num("gold") end
local function getSilver()    return num("silver") end
local function getIron()      return num("iron") end
local function getIngots()    return num("ingots") end
local function getStarmetal() return num("starmetal") end
local function getPrisms()    return num("prisms") end
local function getCrystals()  return num("crystals") end
local function getWood()      return num("wood") end
local function getEssence()   return num("essence") end
local function getStairs()    return num("stairsOwned") end
local function getRebirths()  return num("rebirths") end

local function upLevel(id)
	return numAt({ "upgrades", id })
end

-- One currency reader by name, so a cost check does not need its own if-chain.
local CURRENCY_READER = {
	gold = getGold, silver = getSilver, ingots = getIngots, iron = getIron,
	starmetal = getStarmetal, prisms = getPrisms, crystals = getCrystals,
	wood = getWood, essence = getEssence,
}

local function wallet(name)
	local reader = CURRENCY_READER[name or "gold"]
	if reader then return reader() end
	return 0
end

local function walletName(name)
	local map = {
		gold = "Gold", silver = "Silver", ingots = "Iron", iron = "Iron",
		starmetal = "Star Metal", prisms = "Prisms", crystals = "Crystals",
		wood = "Wood", essence = "Essence",
	}
	return map[name or "gold"] or tostring(name)
end

-- ===================== MOVEMENT =====================
-- Teleports are the load-bearing primitive here, because BuyStair and MineBlock
-- both carry a server-side reach gate. Teleport-then-fire is not a convenience,
-- it is the only way those two remotes accept a call.
local TP_SETTLE = 0.22

local function teleportTo(position, offset)
	local root = getRoot()
	if not root or not position then return false end
	local lift = offset or Vector3.new(0, 3, 0)
	local ok = pcall(function()
		root.CFrame = CFrame.new(position + lift)
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
	end)
	return ok
end

-- Teleport to a spot and keep it pinned for the duration. The server samples the
-- root on its own tick, and a teleport immediately overwritten by the physics
-- engine reads as "the player never arrived".
local function gotoAndHold(position, holdFor, offset)
	if not position then return false end
	local root = getRoot()
	if not root then return false end
	local lift = offset or Vector3.new(0, 3, 0)
	local target = CFrame.new(position + lift)
	local ok = pcall(function() root.CFrame = target end)
	if not ok then return false end
	local deadline = os.clock() + (holdFor or 0.3)
	while os.clock() < deadline do
		local r = getRoot()
		if not r then return false end
		pcall(function()
			r.CFrame = target
			r.AssemblyLinearVelocity = Vector3.zero
		end)
		task.wait(0.04)
	end
	return true
end

-- Every world container the game uses, in one place so a missing folder shows up
-- in the code rather than as a silent nil three loops deep.
local function world(name)
	return workspace:FindFirstChild(name)
end

local function abbreviate(value)
	value = tonumber(value) or 0
	if value ~= value then return "0" end
	local units = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp" }
	local index = 1
	while value >= 1000 and index < #units do
		value /= 1000
		index += 1
	end
	if index == 1 then return string.format("%.0f", value) end
	return string.format("%.2f%s", value, units[index])
end

-- ===================== STAIR GEOMETRY =====================
-- StairConfig.collect() walks workspace.Stairs (6863 descendants) and indexes them
-- by their StairIndex attribute.
--
-- The cache is keyed on stairsOwned, NOT on a timer. The map only changes when a
-- new stair is bought, and the script is the only thing buying them, so a timer
-- cache rebuilds a 6863-descendant walk every 2s forever while the answer cannot
-- have changed. Keying on the count means one walk per actual stair purchased.
local StairCache = nil
local StairCacheFor = nil

local function stairIndex()
	local owned = getStairs()
	if StairCache and StairCacheFor == owned then return StairCache end
	local folder = world("Stairs")
	if not folder then return nil end
	local map = {}
	-- Descendants() is a single non-yielding walk over ~6800 instances. It is
	-- acceptable once per purchase, not once per tick.
	for _, part in ipairs(folder:GetDescendants()) do
		if part:IsA("BasePart") then
			local idx = part:GetAttribute("StairIndex")
			if type(idx) == "number" then map[idx] = part end
		end
	end
	StairCache = map
	StairCacheFor = owned
	return map
end

-- The standable point ON TOP of a stair. StairConfig.withinReach measures against
-- the stair's home CFrame with REACH_EDGE 2.5, REACH_Y 6 and SLACK 6, so landing
-- just above the top face sits inside the box on every axis.
local function stairTop(index)
	local map = stairIndex()
	if not map then return nil end
	local part = map[index]
	if not part then return nil end
	if part:IsA("BasePart") then
		return part.Position + Vector3.new(0, part.Size.Y / 2 + 2.5, 0)
	end
	return nil
end

local function nextStairCost(index)
	if StairConfig and StairConfig.costOf then
		local ok, cost = pcall(function() return StairConfig.costOf(index) end)
		if ok and type(cost) == "number" then return cost end
	end
	return 0
end

-- Which "floor" (20-floor section) the player has climbed to.
-- StairConfig.floorFor walks the same stair map stairIndex() already caches, and
-- counts EndStair parts, so there is no second pass over the 6800 stair parts.
-- The tree and the trails both gate content on this, so it is computed once per
-- call and shared.
local function stairFloor()
	if not StairConfig or type(StairConfig.floorFor) ~= "function" then return 0 end
	local map = stairIndex()
	if not map then return 0 end
	local ok, floor = pcall(function() return StairConfig.floorFor(getStairs(), map) end)
	if ok and type(floor) == "number" then return floor end
	return 0
end

-- ===================== UPGRADE LOOKUP =====================
-- UpgradeConfig.BY_ID is the game's own index. Reading defs off it rather than
-- off a local table means a game update that re-caps an upgrade changes the hub
-- with it.
local UpgradeDefs = {}
local UpgradeOrder = {}

do
	if UpgradeConfig and type(UpgradeConfig.BY_ID) == "table" then
		for id, def in pairs(UpgradeConfig.BY_ID) do
			if type(def) == "table" and type(id) == "string" then
				UpgradeDefs[id] = def
				table.insert(UpgradeOrder, id)
			end
		end
	end
	if #UpgradeOrder == 0 and UpgradeConfig and type(UpgradeConfig.LIST) == "table" then
		for _, def in ipairs(UpgradeConfig.LIST) do
			if type(def) == "table" and type(def.id) == "string" then
				UpgradeDefs[def.id] = def
				table.insert(UpgradeOrder, def.id)
			end
		end
	end
	table.sort(UpgradeOrder)
end

local function upgradeDef(id)
	return UpgradeDefs[id]
end

local function upgradeLevel(id)
	return numAt({ "upgrades", id })
end

local function upgradeCapped(id)
	local def = upgradeDef(id)
	if not def then return true end
	if type(def.cap) ~= "number" then return false end
	return upgradeLevel(id) >= def.cap
end

-- Cost of the NEXT level. Returns nil rather than guessing 0, because a 0 here
-- would make an unaffordable upgrade look free and the loop would spam it.
local function upgradeNextCost(id, quantity)
	local def = upgradeDef(id)
	if not def or not UpgradeConfig then return nil end
	local level = upgradeLevel(id)
	-- Args are passed through an explicit table rather than ... : a vararg
	-- cannot be forwarded out of a nested pcall closure, and quantity is
	-- legitimately nil on the two-argument form.
	local function call(fnName, args)
		if type(UpgradeConfig[fnName]) ~= "function" then return nil end
		local ok, value = pcall(function() return UpgradeConfig[fnName](args[1], args[2], args[3]) end)
		if ok and type(value) == "number" then return value end
		return nil
	end
	if quantity and quantity > 1 then
		local total = call("totalCost", { def, level, quantity })
		if total then return total end
	end
	if quantity then
		return call("costAt", { def, level, quantity }) or call("costAt", { def, level })
	end
	return call("costAt", { def, level })
end

-- Keeper upgrades require a second currency on top of the gold. Both are checked,
-- because firing with the ingots short does nothing and looks like a dead toggle.
local function upgradeExtraCovered(id, level)
	local def = upgradeDef(id)
	if not def or type(def.extra) ~= "table" then return true end
	local extra = def.extra
	return wallet(extra.currency) >= (tonumber(extra.amount) or 0)
end

local function upgradeBuyable(id, quantity)
	local def = upgradeDef(id)
	if not def then return false, "unknown upgrade" end
	if type(def.cap) == "number" and upgradeLevel(id) >= def.cap then return false, "capped" end
	if not upgradeExtraCovered(id, upgradeLevel(id)) then
		local extra = def.extra
		return false, string.format("needs %s %s", abbreviate(extra.amount), walletName(extra.currency))
	end
	-- Affordability is ALWAYS "can I buy at least one more level", including in Max
	-- mode. Max changes how MANY levels the server buys, not whether the first one
	-- is affordable.
	--
	-- The earlier version short-circuited Max to `wallet > 0`. That was the bug
	-- behind "I choose buy MAX but it buys 1 at a time" the second time: with 374
	-- silver and moreSilver's next level costing 4642, the loop still considered it
	-- buyable, fired `BuyUpgrade("moreSilver", 0)` every tick, and the server
	-- rejected all of it - a permanently busy loop that achieved nothing.
	local cost = upgradeNextCost(id, 1)
	if not cost then return false, "no cost data" end
	if cost > wallet(def.currency or "gold") then
		return false, string.format("needs %s %s", abbreviate(cost), walletName(def.currency))
	end
	return true, nil
end

-- ===================== UPGRADE GROUPS =====================
-- The hub does not expose all 62 upgrades as individual toggles. It exposes
-- groups that map onto how the game plays: each board is bought by its own
-- currency, so a player grinding silver has no use for the starmetal board.
local UPGRADE_GROUPS = {
	{ id = "goldIncome",   label = "Gold Income",     ids = { "moreMoney", "fasterMoney", "speedBuff" } },
	{ id = "silverIncome", label = "Silver + Mining", ids = { "moreSilver", "fasterMining", "goldMultiplier" } },
	{ id = "ironChain",    label = "Iron Chain",      ids = { "fasterBelts", "ironCapacity", "silverMultiplier" } },
	{ id = "mineBoard",    label = "Mine Board",      ids = { "moreIron", "oreDensity", "luckyStrike" } },
	{ id = "glyphBoard",   label = "Glyph Board",     ids = { "glyphBulk", "fasterRolling", "glyphLuck" } },
	{ id = "crystalBoard", label = "Crystal Board",   ids = { "crystalYield", "growthSpeed", "crystalPower" } },
	{ id = "woodBoard",    label = "Wood Board",      ids = { "woodYield", "woodGrowth", "woodPower" } },
	{ id = "essenceBoard", label = "Essence Board",   ids = { "essenceCount", "essenceSpeed", "essenceYield" } },
	{ id = "forgeBoard",   label = "Starforge Board", ids = { "forgeSpeed", "forgeCapacity", "starmetalMulti" } },
	{ id = "refractBoard", label = "Refractor Board", ids = { "refractSpeed", "refractCapacity", "prismMulti" } },
	{ id = "autoDepositUp",label = "Auto Deposit",    ids = { "autoDeposit" } },
	{ id = "keepers",      label = "Rebirth Keepers", ids = { "keepTree", "keepBoard1", "keepTree2", "keepBoard2", "keepWaterGlyphs", "keepTree3", "keepBoard3", "keepPoisonGlyphs" } },
}

-- Close the lists above against UpgradeConfig, every load.
--
-- These lists were hand-written and hand-maintained, so they were silently
-- incomplete: UpgradeConfig ships 62 upgrades and the twelve groups covered 39.
-- The 20 keeper upgrades missing from `keepers` and all three range upgrades
-- (mineRange, chopRange, essenceRange) were in NO group, and a group the loop
-- never looks in is an upgrade it can never buy - no error, no status line, the
-- board just sits there.
--
-- Observed exactly: with keepBoard5 (6.4e18 gold, affordable against a 9.46e25
-- wallet) sitting unowned, Auto Upgrades reported
--   "nothing affordable (checked 39, buyable 0)"
-- 39 being precisely the number of hand-listed ids.
--
-- Anything unclaimed is filed by CURRENCY, and every "keep*" upgrade goes to the
-- keepers group regardless of the currency it is paid in. Existing group ids are
-- untouched, so a saved selection keeps working, and a game update that adds an
-- upgrade can no longer leave it invisible.
do
	local GroupByCurrency = {
		gold = "goldIncome", silver = "silverIncome", ingots = "ironChain",
		crystals = "crystalBoard", wood = "woodBoard", essence = "essenceBoard",
		starmetal = "forgeBoard", prisms = "refractBoard",
	}
	local claimed, lookup = {}, {}
	for _, group in ipairs(UPGRADE_GROUPS) do
		for _, id in ipairs(group.ids) do claimed[id] = true end
		lookup[group.id] = group
	end
	for _, def in ipairs((UpgradeConfig and UpgradeConfig.LIST) or {}) do
		if type(def) == "table" and type(def.id) == "string" and not claimed[def.id] then
			local wanted
			if string.find(def.id, "keep", 1, true) == 1 then
				wanted = "keepers"
			else
				wanted = GroupByCurrency[def.currency]
			end
			local g = wanted and lookup[wanted]
			if g then
				g.ids[#g.ids + 1] = def.id
				claimed[def.id] = true
			end
		end
	end
end

local GroupById = {}
for _, group in ipairs(UPGRADE_GROUPS) do GroupById[group.id] = group end

local function groupIds(groupId)
	local group = GroupById[groupId]
	return group and group.ids or {}
end

-- ===================== FLAG HELPERS =====================

local Options = Library.Options
local Toggles = Library.Toggles

-- Multi-select state is packed into a STRING attribute rather than stored as a
-- table: this client rejects table attributes outright ("Dictionary is not a
-- supported attribute type"). Names contain spaces but never commas.
local function packSet(sel)
	if type(sel) ~= "table" then return "" end
	local names = {}
	for k, v in pairs(sel) do
		if type(k) == "string" then names[#names + 1] = k end
		if type(v) == "string" then names[#names + 1] = v end
	end
	table.sort(names)
	return table.concat(names, ",")
end

local function unpackSet(str)
	local set = {}
	if type(str) == "string" and str ~= "" then
		for name in string.gmatch(str, "[^,]+") do
			set[name] = true
		end
	end
	return set
end

-- Obsidian's Multi dropdown wants its Default as a SEQUENTIAL ARRAY of values,
-- not as the {name = true} set the loops read back. It resolves the default with
-- `for _, Candidate in Default`, which walks a set by index and therefore finds
-- nothing -- so the dropdown comes up empty and the mirror immediately overwrites
-- the saved selection with "". That is why this function exists: the set is for
-- the loops, the array is for the widget.
local function asList(packed)
	local list = {}
	if type(packed) == "string" and packed ~= "" then
		for name in string.gmatch(packed, "[^,]+") do
			list[#list + 1] = name
		end
	end
	table.sort(list)
	return list
end

-- Every SetAttribute write is pcall'd. An unguarded write of an unsupported type
-- throws, and inside a spawned loop that kills the loop with no visible error.
local function getFlag(name)
	local ok, v = pcall(function() return ReplicatedStorage:GetAttribute("LH_" .. name) end)
	if ok then return v end
	return nil
end

local function setFlag(name, value)
	pcall(function() ReplicatedStorage:SetAttribute("LH_" .. name, value) end)
end

local function boolFlag(name, fallback)
	local v = getFlag(name)
	if type(v) == "boolean" then return v end
	setFlag(name, fallback)
	return fallback
end

local function numFlag(name, fallback)
	local v = getFlag(name)
	if type(v) == "number" then return v end
	setFlag(name, fallback)
	return fallback
end

-- For controls whose value is a LABEL rather than a number, e.g. the tree buy-order
-- dropdown. Reads the saved string back so the widget comes up on the same choice
-- it was left on.
local function stringFlag(name, fallback)
	local v = getFlag(name)
	if type(v) == "string" then return v end
	setFlag(name, fallback)
	return fallback
end

-- selHas treats an EMPTY selection as "allow everything", which is also what
-- makes a failed multi-select Set harmless.
local function selHas(sel, value)
	if type(sel) ~= "table" then return true end
	local count, hit = 0, false
	for k, v in pairs(sel) do
		count += 1
		if v == true and k == value then hit = true end
		if v == value then hit = true end
	end
	if count == 0 then return true end
	return hit
end

local function seedSet(flagName, list)
	local cur = getFlag(flagName)
	if type(cur) == "string" and cur ~= "" then return end
	local packed = packSet(list)
	if packed ~= "" then setFlag(flagName, packed) end
end

-- Door list for the multi-select, straight off DoorConfig so a game update that
-- adds a door shows up without a script change.
local DoorList = {}
local DoorOrder = {}
do
	if DoorConfig and type(DoorConfig.DOORS) == "table" then
		for _, def in pairs(DoorConfig.DOORS) do
			if type(def) == "table" and type(def.id) == "string" then
				DoorList[#DoorList + 1] = def.id
				DoorOrder[#DoorOrder + 1] = {
					id = def.id, floor = def.floor or 999,
					cost = def.cost or 0, currency = def.currency or "gold",
					rebirths = def.rebirths or 0,
				}
			end
		end
	end
	-- unlock them in the order the game intends, not whatever order pairs() gave
	table.sort(DoorList)
	table.sort(DoorOrder, function(a, b) return a.floor < b.floor end)
end
if #DoorList == 0 then DoorList = { "mine", "ironOre", "upgradeTree", "potions" } end

-- Only potions that can actually be bought.
--
-- PotionConfig.LIST ships a decoy: id "crystals2x" ("Crystal Potion") has
-- booth = nil, cost = nil and door = nil. It is a real row in the config, so
-- anything iterating LIST naively offers it in the UI and then can never buy it -
-- a checkbox that silently does nothing. Offer a def only when it has both a
-- booth to stand at and a cost to pay.
local PotionList = {}
do
	if PotionConfig and type(PotionConfig.LIST) == "table" then
		for _, def in ipairs(PotionConfig.LIST) do
			if type(def) == "table" and type(def.id) == "string"
				and def.booth ~= nil and def.cost ~= nil then
				PotionList[#PotionList + 1] = def
			end
		end
	end
end

-- Show the game's own display name ("Greater Gold Potion"), not the raw id
-- ("gold2x"), ordered by shop so the tiers read top to bottom. The loop matches a
-- selection against both the name and the id, so no lookup table is needed here.
local PotionNames = {}
do
	local ordered = {}
	for _, def in ipairs(PotionList) do ordered[#ordered+1] = def end
	table.sort(ordered, function(a, b)
		local sa = tonumber(a.shop) or 99
		local sb = tonumber(b.shop) or 99
		if sa ~= sb then return sa < sb end
		local ca = tonumber(a.cost) or 0
		local cb = tonumber(b.cost) or 0
		if ca ~= cb then return ca < cb end
		return tostring(a.id) < tostring(b.id)
	end)
	for _, def in ipairs(ordered) do
		local label = (type(def.name) == "string" and def.name ~= "") and def.name or def.id
PotionNames[#PotionNames+1] = label
	end
end

local RebirthList = {}
do
	if RebirthConfig and type(RebirthConfig.LIST) == "table" then
		for i, def in ipairs(RebirthConfig.LIST) do
			if type(def) == "table" then
				RebirthList[#RebirthList + 1] = { index = i, def = def }
			end
		end
	end
end

-- First run: allow everything, so a fresh install is useful immediately.
seedSet("UpgradeGroups", (function()
	local names = {}
	for _, group in ipairs(UPGRADE_GROUPS) do names[#names + 1] = group.id end
	return names
end)())
seedSet("DoorList", DoorList)
seedSet("PotionList", PotionNames)
seedSet("MineOre", { "Both" })

-- ===================== WORLD SPOTS =====================
-- Cached, because the mine list is expensive to compute and almost never changes.
local Spots = {}
local SpotsAt = 0
local SPOTS_TTL = 5

-- The mine cell list lives in its own upvalues rather than inside Spots, because
-- refreshSpots reassigns Spots = {} on every rebuild and that would throw the
-- cache away each time - turning a once-per-density-change walk of 585 cells into
-- a walk every 5 seconds.
local MineOre = {}
local MineIron = {}
local MineTotal = nil
local MineDensity = nil
local MineIronOpen = nil
local MineBuilt = false

-- type() reports a Vector3 as "vector"; typeof() reports "Vector3". Checking for
-- only one of those two strings is a silent-failure generator, so accept both and
-- fall back to duck typing on the numeric fields. Verified: type(Vector3.new())
-- == "vector", which is what broke the mine's cell list the first time.
--
-- This was a local function and is now inlined at its two call sites. The chunk is
-- on Luau's 200-register ceiling, and this was a clean place to reclaim one.
local function refreshSpots(force)
	if not force and SpotsAt > 0 and (os.clock() - SpotsAt) < SPOTS_TTL then return Spots end
	SpotsAt = os.clock()
	Spots = {}

	-- ===================== MINE BLOCK POSITIONS =====================
	-- COMPUTED from MineConfig, never read off the live folder.
	--
	-- workspace.Mine.MineBlocks is a CLIENT-SIDE visual built by MineClient. It does
	-- not exist unless the player is currently standing in the mine, and it is
	-- destroyed block by block as you mine. Reading it means mining silently does
	-- nothing the moment you walk away - which is the entire time you would want it.
	-- (Verified: with the folder absent and Auto Mine on, the loop ticked for 20s,
	-- never moved the player, and silver never changed by a single point.)
	--
	-- MineConfig.oreCells / ironCells / centreOf are the authoritative, pure source.
	-- The server regenerates the SAME cells on every reset, so this list is stable
	-- and only needs rebuilding when oreDensity rises or the iron door opens.
	local mine = world("Mine")
	local gen = mine and mine:FindFirstChild("GenerationArea")
	Spots.mineArea = gen
	Spots.oreBlocks = MineOre
	Spots.ironBlocks = MineIron

	if MineConfig and gen and type(MineConfig.grid) == "function" then
		-- grid() returns TWO Vector3s: the cell counts, then the grid ORIGIN.
		-- Verified live: grid() -> 13, 3, 15   then   -69.5, 37, 96
		local okGrid, grid, origin = pcall(function() return MineConfig.grid(gen) end)

		local gridT = okGrid and (typeof and typeof(grid) or type(grid)) or nil
		if okGrid and (gridT == "Vector3" or gridT == "vector") then
			local total = grid.X * grid.Y * grid.Z
			local density = upLevel("oreDensity")
			local ironOpen = tblAt("doors")[MineConfig.IRON_DOOR] == true

			if MineTotal ~= total or MineDensity ~= density
				or MineIronOpen ~= ironOpen or not MineBuilt then

				local originT = origin and (typeof and typeof(origin) or type(origin)) or nil
				if originT ~= "Vector3" and originT ~= "vector" then origin = gen.Position end

				local oreSet = {}
				if type(MineConfig.oreCells) == "function" then
					local ok, cells = pcall(function()
						return MineConfig.oreCells(total, LocalPlayer.UserId, density)
					end)
					if ok and type(cells) == "table" then oreSet = cells end
				end

				local ironSet = {}
				if ironOpen and type(MineConfig.ironCells) == "function" then
					local ok, cells = pcall(function()
						return MineConfig.ironCells(total, LocalPlayer.UserId, oreSet)
					end)
					if ok and type(cells) == "table" then ironSet = cells end
				end

				-- Cell numbering copied from MineClient's own build loop:
				--   for i = 0, Z-1 / for j = 0, Y-1 / for k = 0, X-1, with n += 1
				-- giving k = (n-1) % X, j = ((n-1) - k) / X % Y, i = ((n-1) - k) / X / Y.
				-- Getting this wrong fires cells that do not exist, which the server
				-- ignores without a sound - so it has to be right, not plausible.
				local ore, iron = {}, {}
				local sx = grid.X
				for cell = 1, total do
					if cell % 64 == 0 then task.wait() end
					if oreSet[cell] == true then
						local k = (cell - 1) % sx
						local rest = (cell - 1 - k) / sx
						local j = rest % grid.Y
						local i = (rest - j) / grid.Y
						local ok, pos = pcall(function() return MineConfig.centreOf(origin, k, j, i) end)
						if ok and pos then
							local entry = { cell = cell, pos = pos }
							if ironSet[cell] == true then
								table.insert(iron, entry)
							else
								table.insert(ore, entry)
							end
						end
					end
				end

				MineOre = ore
				MineIron = iron
				MineTotal = total
				MineDensity = density
				MineIronOpen = ironOpen
				MineBuilt = true
				Spots.oreBlocks = MineOre
				Spots.ironBlocks = MineIron
			end
		end
	end

	local doors = world("Doors")
	Spots.doorModels = {}
	if doors then
		for _, model in ipairs(doors:GetChildren()) do
			if model:IsA("Model") then
				local anchor = model:FindFirstChildWhichIsA("BasePart", true)
				if anchor then Spots.doorModels[model.Name] = anchor.Position end
			end
		end
	end

	Spots.wheel = world("PrizeWheel")
	local wheelPart = Spots.wheel and Spots.wheel:FindFirstChildWhichIsA("BasePart", true)
	Spots.wheelPos = wheelPart and wheelPart.Position or nil

	Spots.essenceField = world("EssenceField")

	local treeSpots = world("TreeSpots")
	Spots.treeSpots = {}
	if treeSpots then
		for _, part in ipairs(treeSpots:GetChildren()) do
			if part:IsA("BasePart") then table.insert(Spots.treeSpots, part.Position) end
		end
	end

	local crystalSpots = world("CrystalSpots")
	Spots.crystalSpots = {}
	if crystalSpots then
		for _, part in ipairs(crystalSpots:GetChildren()) do
			if part:IsA("BasePart") then table.insert(Spots.crystalSpots, part.Position) end
		end
	end

	-- Machine rooms. Each config's inRoom() is the authority; we only need a
	-- point INSIDE the room to hold at, so find the first base part of the
	-- system folder and stand a little above it.
	for name, key in pairs({
		SmelterSystem = "smelter", StarforgeSystem = "starforge",
		RefractorSystem = "refractor",
	}) do
		local folder = world(name)
		local part = folder and folder:FindFirstChildWhichIsA("BasePart", true)
		Spots[key] = part and part.Position or nil
	end

	local totems = world("Totems")
	Spots.totemPos = nil
	if totems then
		local part = totems:FindFirstChildWhichIsA("BasePart", true)
		Spots.totemPos = part and part.Position or nil
	end

	-- Potion booths, keyed by the booth name PotionConfig gives us.
	-- FindFirstChildWhichIsA picks the merchant NPC's accessory handle, not the
	-- counter you actually stand at, so take the largest structural part instead.
	-- (Verified: PotionBooth1 is a Model holding a rig of 24 tiny parts; the booth
	-- counter is the only one big enough to matter.)
	Spots.booths = {}
	for _, def in ipairs(PotionList) do
		if def.booth and not Spots.booths[def.booth] then
			-- DO NOT fold these into an ipairs'd table constructor. world("Booths")
			-- and world("Map") are nil in this game, and ipairs stops dead at the
			-- first nil, so `{ nil, nil, workspace }` yielded zero iterations and
			-- Spots.booths stayed permanently empty - which is why Auto Potions
			-- reported nothing and never fired.
			for _, name in ipairs({ "Booths", "Map" }) do
				local folder = world(name)
				if folder then
					local booth = folder:FindFirstChild(def.booth, true)
					if booth then
						Spots.booths[def.booth] = booth:FindFirstChildWhichIsA("BasePart", true)
						break
					end
				end
			end
			if not Spots.booths[def.booth] then
				local booth = workspace:FindFirstChild(def.booth, true)
				-- FindFirstChildWhichIsA picks the merchant NPC's accessory handle,
				-- not the counter you stand at, so take the largest structural part.
				-- (Verified: PotionBooth1 is a Model holding a rig of 24 tiny parts.)
				local bestPart, bestVol
				if booth then
					for _, p in ipairs(booth:GetDescendants()) do
						if p:IsA("BasePart") then
							local vol = p.Size.X * p.Size.Y * p.Size.Z
							if not bestVol or vol > bestVol then
								bestPart, bestVol = p, vol
							end
						end
					end
				end
				if bestPart then
					Spots.booths[def.booth] = bestPart.Position + Vector3.new(0, bestPart.Size.Y / 2 + 3, 0)
				end
			end
		end
	end

	return Spots
end

-- The door model for a door id. DoorConfig gives model names like "Door5", and
-- workspace.Doors holds those models, so the mapping is exact rather than fuzzy.
local function doorPosition(doorId)
	local def = DoorConfig and DoorConfig.BY_ID and DoorConfig.BY_ID[doorId]
	if type(def) == "table" and type(def.model) == "string" then
		local cache = refreshSpots()
		if cache.doorModels and cache.doorModels[def.model] then return cache.doorModels[def.model] end
		local doors = world("Doors")
		local model = doors and doors:FindFirstChild(def.model)
		local part = model and model:FindFirstChildWhichIsA("BasePart", true)
		if part then return part.Position end
	end
	return nil
end

-- ===================== MAIN TAB =====================

local StartedAt = os.clock()

-- declared out here because the status loop further down (outside this block)
-- drives the grid, and because the fallback labels are only built when the
-- grid is unavailable. One UI table rather than a local per widget: this chunk
-- sits on Volt's 200-locals-per-chunk ceiling, so every top-level local is a
-- real cost. Bare globals would NOT work here - an undeclared name is nil at
-- runtime and the label would silently never update, which is exactly how the
-- "Nodes bought" counter died.
local UI = { grid = nil, session = nil, gold = nil, stairs = nil, income = nil,
	errors = nil, stairCost = nil, nextDoor = nil, labels = {}, nextDoorName = nil,
	treeProgress = nil }

do
	pcall(function()
		Tabs.Main:AddPlayerInfo("LiquidBanner", {
			Title = "Welcome to <b>" .. BRAND.Name .. "</b>",
			Description = {
				GAME_NAME .. " | press <b>RightControl</b> to toggle the menu",
			},
			ThumbnailType = "HeadShot",
			Height = 84,
		})
	end)

	local Session = Tabs.Main:AddLeftGroupbox("Session", ICON.Drops, true, false)
	Session:AddLabel({ Text = GAME_NAME, DoesWrap = true })

	-- A stat grid instead of five stacked text lines: the live numbers become
	-- tiles with a caption and a value, updated in place via SetValue. This is a
	-- structural change, not a recolour -- it changes what the readout *is*.
	pcall(function()
		UI.grid = Session:AddStatGrid("SessionStats", {
			Columns   = 2,
			TileHeight = 44,
			Padding   = 6,
			Items = {
				{ Text = "Gold",     Value = "0",       ValueColor = BRAND.Azure },
				{ Text = "Stairs",   Value = "0",       Tooltip = "Stairs owned" },
				{ Text = "Gold/s",   Value = "0",       ValueColor = BRAND.Sheen, Tooltip = "Measured over a 2s window" },
				{ Text = "Rebirths", Value = "0",       Tooltip = "Completed rebirths" },
				{ Text = "Uptime",   Value = "00:00:00", ValueColor = BRAND.Sheen },
			},
		})
	end)

	-- Plain labels only as a FALLBACK. AddStatGrid exists on this library
	-- version, so in practice these never get built and the grid is the only
	-- readout -- building both duplicated every value on screen.
	if not UI.grid then
		UI.session = Session:AddLabel({ Text = "Uptime: 00:00:00", DoesWrap = true })
		UI.gold      = Session:AddLabel({ Text = "Gold: 0", DoesWrap = true })
		UI.stairs    = Session:AddLabel({ Text = "Stairs: 0", DoesWrap = true })
		UI.income    = Session:AddLabel({ Text = "Gold/s: 0", DoesWrap = true })
		UI.errors    = Session:AddLabel({ Text = "Errors: 0", DoesWrap = true })
	end

	-- Diagnostics exist because the single hardest failure mode here is a feature
	-- that flips on, ticks, and silently does nothing. The two causes are a nil
	-- remote and a reach gate, and both are readable from this panel.

end -- end of the Main tab block

-- ===================== UPGRADE BUY AMOUNT =====================
-- A single (non-Multi) Obsidian dropdown returns the SELECTED STRING, not an
-- index. Writing `tonumber(dropdown.Value)` therefore yields nil for every option
-- and silently collapses the whole dropdown to its fallback - so "Max (Spend All)"
-- bought 1 level and "10 Levels" bought 1 level, with no error anywhere.
--
-- Declared at top level, NOT inside the Farming tab's block, because both the
-- toggle wiring and the farm loop read these.
--
-- The count sent to BuyUpgrade is a LEVEL COUNT, and 0 means spend the wallet to
-- the cap (verified live: count=0 bought 30 levels and drained 50.5M gold).
local UPGRADE_AMOUNTS = { "1 Level", "10 Levels", "Max (Spend All)" }
local UPGRADE_AMOUNT_COUNT = {
	["1 Level"] = 1,
	["10 Levels"] = 10,
	["Max (Spend All)"] = 0,
}

local function amountLabelFromCount(count)
	if count == 0 then return "Max (Spend All)" end
	if count == 10 then return "10 Levels" end
	return "1 Level"
end

local function amountCountFromLabel(label)
	return UPGRADE_AMOUNT_COUNT[label] or 1
end

-- Same shape as the upgrade-amount control: a single dropdown hands back its LABEL,
-- so the order is stored as a string rather than an index.
local TREE_ORDERS = { "Cheapest First", "Best Value First" }

-- How many BuyUpgrade calls one Max-mode pass may make. Bounded so a full wallet
-- cannot turn into an unbounded fire loop against the server.
local UPGRADE_MAX_PER_TICK = 6

-- Labels driven from the status loop, declared out here because it runs after
-- this block's scope. Lives in the shared UI table (see the Session block).

-- ===================== FARMING TAB =====================

local StairsTab   = Tabs.Farming:AddSubTab("Stairs", ICON.Tower)
local UpgradesTab = Tabs.Farming:AddSubTab("Upgrades", ICON.Trend)
local TreeTab     = Tabs.Farming:AddSubTab("Tree", ICON.Layers)
local MiningTab   = Tabs.Farming:AddSubTab("Mining", ICON.Pickaxe)
local MachinesTab = Tabs.Farming:AddSubTab("Machines", ICON.Layers)

do
	local Runner = StairsTab:AddLeftGroupbox("Auto Stairs", ICON.Tower, true, false)
	Runner:AddToggle("AutoStairs", {
		Text = "Auto Buy Stairs",
		Tooltip = "Teleports to the top of your highest stair and buys the next one",
		Default = boolFlag("AutoStairsOn", false),
	})
	Runner:AddSlider("StairInterval", {
		Text = "Buy Interval",
		Min = 0.1,
		Max = 3,
		Default = numFlag("StairInterval", 0.4),
		Step = 0.05,
		Suffix = "s",
		Tooltip = "The client mirror lags the server, so going faster wastes fires",
	})
	Runner:AddToggle("StairReturnBase", {
		Text = "Return To Base",
		Tooltip = "Teleport back to spawn after each purchase instead of climbing the whole tower",
		Default = boolFlag("StairReturnBase", true),
	})

	-- Live cost of the next stair, so the toggle has visible context instead of
	-- being a mystery switch. Declared out here because the status loop further
	-- down refreshes it, outside this block's scope.
	local NextStairLabel
	do
		local box = StairsTab:AddRightGroupbox("Next Stair", ICON.Coins, true, false)
		NextStairLabel = box:AddLabel({ Text = "Cost: -", DoesWrap = true })
	end
	UI.stairCost = NextStairLabel
end

do
	local Auto = UpgradesTab:AddLeftGroupbox("Auto Buy", ICON.Bolt, true, false)
	Auto:AddToggle("AutoUpgrades", {
		Text = "Auto Buy Upgrades",
		Tooltip = "Buys enabled upgrade groups whenever you can afford the next level",
		Default = boolFlag("AutoUpgradesOn", false),
	})
Auto:AddDropdown("UpgradeCount", {
		Text = "Buy Amount",
		Values = UPGRADE_AMOUNTS,
		-- Default is the LABEL, resolved from the stored count, because a
		-- single dropdown's value is a label. Passing a number index happens to
		-- work for option 1 and nothing else.
		Default = amountLabelFromCount(numFlag("UpgradeCount", 1)),
		Tooltip = "Sent as the count argument. Max drains the wallet into one upgrade.",
	})
	Auto:AddSlider("UpgradeInterval", {
		Text = "Check Interval",
		Min = 0.1,
		Max = 5,
		Default = numFlag("UpgradeInterval", 0.6),
		Step = 0.1,
		Suffix = "s",
	})

	-- One dropdown carrying every group, rather than 12 separate toggles. A
	-- multi-select dropdown keeps the panel readable and the flag one string.
	local Groups = UpgradesTab:AddRightGroupbox("Groups", ICON.Layers, true, false)
	local GroupNames = {}
	for _, group in ipairs(UPGRADE_GROUPS) do GroupNames[#GroupNames + 1] = group.id end
	Groups:AddDropdown("UpgradeGroups", {
		Text = "Buy These",
		Values = GroupNames,
		Default = asList(getFlag("UpgradeGroups")),
		Multi = true,
		Searchable = true,
		Tooltip = "Empty = buy nothing",
	})


end

-- ===================== TREE TAB =====================
-- 274 nodes across six sections, each gated on the node before it plus the floor
-- you have climbed to. Buying needs no position: the server does not check
-- proximity for BuyTreeNode, verified by buying GoldLeft1 from spawn. So this loop
-- never moves the character.
do
	local Branch = TreeTab:AddLeftGroupbox("Auto Tree", ICON.Layers, true, false)
	Branch:AddToggle("AutoTree", {
		Text = "Auto Buy Tree Upgrades",
		Tooltip = "Buys every unlocked upgrade-tree node you can afford",
		Default = boolFlag("AutoTreeOn", false),
	})
	Branch:AddDropdown("TreeOrder", {
		Text = "Buy Order",
		Values = TREE_ORDERS,
		Default = stringFlag("TreeOrder", "Cheapest First"),
		Tooltip = "Cheapest spreads the cost out; Best Value buys the biggest effect first",
	})
	Branch:AddSlider("TreeInterval", {
		Text = "Check Interval",
		Min = 0.3,
		Max = 15,
		Default = numFlag("TreeInterval", 1.5),
		Step = 0.5,
		Suffix = "s",
	})

	-- Capture the LABEL, not the groupbox. Assigning the result of AddRightGroupbox
	-- to TreeProgress and then discarding AddLabel's return value means every later
	-- `TreeProgress.Text = ...` writes a property onto a GuiGroupBox, which has no
	-- Text field - so the counter silently never updated.
	UI.treeProgress = TreeTab:AddRightGroupbox("Progress", ICON.Trend, true, false)
		:AddLabel({ Text = "Nodes bought: 0", DoesWrap = true })
end

do
	local Mine = MiningTab:AddLeftGroupbox("Auto Mine", ICON.Pickaxe, true, false)
	Mine:AddToggle("AutoMine", {
		Text = "Auto Mine Ore",
		Tooltip = "Teleports to each ore block and mines it",
		Default = boolFlag("AutoMineOn", false),
	})
	-- A SINGLE dropdown's Default is its label, not an array. Passing asList here
	-- made the widget resolve to nothing, and the mirror immediately overwrote the
	-- saved value with "" - the same trap the Multi-selects hit, in mirror image.
	-- Anything unrecognised falls back to "Both".
	Mine:AddDropdown("MineOre", {
		Text = "Ore To Mine",
		Values = { "Silver Ore", "Iron Ore", "Both" },
		Default = (function()
			local v = getFlag("MineOre")
			if v == "Silver Ore" or v == "Iron Ore" or v == "Both" then return v end
			return "Both"
		end)(),
		Tooltip = "Silver and iron are the only two mineable ores. Stone is skipped either way",
	})
	Mine:AddSlider("MineInterval", {
		Text = "Mine Interval",
		Min = 0.1,
		Max = 3,
		Default = numFlag("MineInterval", 0.35),
		Step = 0.05,
		Suffix = "s",
	})

	local Feed = MiningTab:AddRightGroupbox("Smelting", ICON.Flask, true, false)
	Feed:AddToggle("AutoSmelt", {
		Text = "Auto Deposit Iron",
		Tooltip = "Walks to the smelter room and deposits your iron",
		Default = boolFlag("AutoSmeltOn", false),
	})
	Feed:AddToggle("AutoCollectIngots", {
		Text = "Auto Collect Ingots",
		Tooltip = "Collects finished ingots",
		Default = boolFlag("AutoCollectOn", false),
	})

	-- There is NO crystal remote. CrystalClient is purely visual - it never fires
	-- anything - and the server harvests by proximity over time, so this is a
	-- "stand here and wait" loop rather than a fire loop. Measured: idle 20s gave
	-- 0 crystals, parked on one ready spot gave 200 -> 275 -> 350 -> 425.
	local Garden = MiningTab:AddRightGroupbox("Crystal Garden", ICON.Gem, true, false)
	Garden:AddToggle("AutoCrystals", {
		Text = "Auto Mine Crystals",
		Tooltip = "Stands on a grown crystal until it is harvested, then moves to the next one. Uses the same body as Auto Mine, so only run one of the two at a time",
		Default = boolFlag("AutoCrystalsOn", false),
	})
	UI.labels.Crystal = Garden:AddLabel({
		Text = "Crystal: idle",
		Tooltip = "What Auto Mine Crystals is doing right now",
	})
	Garden:AddSlider("CrystalDelay", {
		Text = "Time Per Crystal",
		Min = 0.1,
		Max = 5,
		Default = numFlag("CrystalDelay", 0.6),
		Step = 0.05,
		Suffix = "s",
		Tooltip = "Lower is faster. Too low and the teleport has not landed before it moves on",
	})

	local Grove2 = MiningTab:AddRightGroupbox("Wood Grove", ICON.Tree, true, false)
	Grove2:AddToggle("AutoWood", {
		Text = "Auto Farm Wood",
		Tooltip = "Stands on a finished tree until it is chopped, then moves to the next one. Same character-stealing caveat as Auto Mine Crystals",
		Default = boolFlag("AutoWoodOn", false),
	})
	Grove2:AddSlider("WoodDelay", {
		Text = "Time Per Tree",
		Min = 0.1,
		Max = 5,
		Default = numFlag("WoodDelay", 0.6),
		Step = 0.05,
		Suffix = "s",
		Tooltip = "Lower is faster. Too low and the teleport has not landed before it moves on",
	})
	UI.labels.Wood = Grove2:AddLabel({
		Text = "Wood: idle",
		Tooltip = "What Auto Farm Wood is doing right now",
	})


end
do
	local Star = MachinesTab:AddLeftGroupbox("Starforge", ICON.Rocket, true, false)
	Star:AddToggle("AutoStarforge", {
		Text = "Auto Deposit Star Metal",
		Tooltip = "Walks to the starforge room and deposits",
		Default = boolFlag("AutoStarforgeOn", false),
	})

	local Ref = MachinesTab:AddLeftGroupbox("Refractor", ICON.Gem, true, false)
	Ref:AddToggle("AutoRefract", {
		Text = "Auto Deposit Prisms",
		Tooltip = "Walks to the refractor room and deposits",
		Default = boolFlag("AutoRefractOn", false),
	})

	local Extra = MachinesTab:AddRightGroupbox("Other", ICON.Spark, true, false)
	Extra:AddToggle("AutoEquipTrail", {
		Text = "Auto Equip Best Trail",
		Tooltip = "Equips the highest-tier trail you own",
		Default = boolFlag("AutoEquipTrailOn", false),
	})
	Extra:AddToggle("AutoBuyTrails", {
		Text = "Auto Buy Trails",
		Tooltip = "Buys the cheapest trail you can afford, in tier order",
		Default = boolFlag("AutoBuyTrailsOn", false),
	})
	Extra:AddSlider("TrailInterval", {
		Text = "Trail Interval",
		Min = 0.5,
		Max = 30,
		Default = numFlag("TrailInterval", 3),
		Step = 0.5,
		Suffix = "s",
	})
end

-- ===================== PROGRESSION TAB =====================

local DoorsTab    = Tabs.Progression:AddSubTab("Doors", ICON.House)
local RebirthTab  = Tabs.Progression:AddSubTab("Rebirths", ICON.Rocket)
local PotionsTab  = Tabs.Progression:AddSubTab("Potions", ICON.Flask)
local RewardsTab  = Tabs.Progression:AddSubTab("Extras", ICON.Gift)

do
	local Unlock = DoorsTab:AddLeftGroupbox("Auto Unlock", ICON.House, true, false)
	Unlock:AddToggle("AutoDoors", {
		Text = "Auto Unlock Doors",
		Tooltip = "Walks to each affordable door and unlocks it, lowest floor first",
		Default = boolFlag("AutoDoorsOn", false),
	})
	Unlock:AddSlider("DoorInterval", {
		Text = "Door Interval",
		Min = 0.5,
		Max = 8,
		Default = numFlag("DoorInterval", 2),
		Step = 0.5,
		Suffix = "s",
	})
	Unlock:AddDropdown("DoorList", {
		Text = "Doors",
		Values = DoorList,
		Default = asList(getFlag("DoorList")),
		Multi = true,
		Searchable = true,
		Tooltip = "Empty = none",
	})

		local Next = DoorsTab:AddRightGroupbox("Next Door", ICON.Coins, true, false)
	UI.nextDoor = Next:AddLabel({ Text = "-", DoesWrap = true })
	UI.nextDoorName = Next:AddLabel({ Text = "", DoesWrap = true })

do
	local Auto = RebirthTab:AddLeftGroupbox("Auto Rebirth", ICON.Rocket, true, false)
	Auto:AddToggle("AutoRebirth", {
		Text = "Auto Rebirth",
		Tooltip = "OFF BY DEFAULT. Rebirth resets your run - only enable it once your keeper upgrades are bought",
		Default = false,
	})
	Auto:AddToggle("RebirthKeepUpgrades", {
		Text = "Only Rebirth With Keepers",
		Tooltip = "Refuses to rebirth until every keeper upgrade on your list is owned",
		Default = boolFlag("RebirthGuard", true),
	})
	Auto:AddSlider("RebirthDelay", {
		Text = "Delay After Rebirth",
		Min = 2,
		Max = 60,
		Default = numFlag("RebirthDelay", 8),
		Step = 1,
		Suffix = "s",
		Tooltip = "Time to re-buy stairs and upgrades before the next rebirth",
	})

		-- The full ladder, so the player can see what they are working towards rather
	-- than a single opaque toggle.
	local list = RebirthTab:AddRightGroupbox("Ladder", ICON.Layers, true, false)
	if #RebirthList == 0 then
		list:AddLabel("RebirthConfig did not load", true)
	else
		for _, entry in ipairs(RebirthList) do
			local def = entry.def
			list:AddLabel({
				Text = string.format("#%d  %s gold", entry.index, abbreviate(def.cost)),
				DoesWrap = true,
			})
		end
	end
end

do
	local Pot = PotionsTab:AddLeftGroupbox("Auto Potions", ICON.Flask, true, false)
	Pot:AddToggle("AutoPotions", {
		Text = "Auto Buy Potions",
		Tooltip = "Walks to the booth and keeps your chosen potions topped up",
		Default = boolFlag("AutoPotionsOn", false),
	})
	Pot:AddDropdown("PotionList", {
		Text = "Potions",
		Values = #PotionNames > 0 and PotionNames or { "gold", "iron", "silver" },
		-- Fall back to EVERYTHING when there is no saved selection. A Multi
		-- dropdown whose Default is an empty array resolves to nothing, and the
		-- OnChanged mirror immediately writes "" back - so a fresh install ended
		-- up with AutoPotions on and an empty list, buying nothing, which looks
		-- exactly like a broken feature. Deselecting by hand still gives "none".
		Default = (function()
			local sel = asList(getFlag("PotionList"))
			if #sel == 0 then sel = asList(packSet(PotionNames)) end
			return sel
		end)(),
		Multi = true,
		Searchable = true,
		Tooltip = "Every potion the shops currently sell, newest merchant included. Deselect all = buy nothing",
	})
	Pot:AddSlider("PotionCheck", {
		Text = "Sweep Interval",
		Min = 3,
		Max = 120,
		Default = numFlag("PotionCheck", 10),
		Step = 1,
		Suffix = "s",
		Tooltip = "Each sweep buys EVERY selected potion that has expired, so this only decides how quickly a buff is topped up after it runs out - not how many get bought",
	})
	Pot:AddToggle("PotionReturnHome", {
		Text = "Return To Where I Was",
		Tooltip = "Puts you back on the spot you were standing before the purchase",
		Default = getFlag("PotionReturnHome") ~= false,
	})
	UI.labels.Potion = Pot:AddLabel({
		Text = "Potion: idle",
		Tooltip = "What Auto Potions decided on its last pass",
	})
end
do
	local Wheel = RewardsTab:AddLeftGroupbox("Prize Wheel", ICON.Gift, true, false)
	Wheel:AddToggle("AutoWheel", {
		Text = "Auto Spin Wheel",
		Tooltip = "Walks to the wheel and spins whenever a free spin is available",
		Default = boolFlag("AutoWheelOn", false),
	})
	Wheel:AddToggle("WheelSpendGold", {
		Text = "Spend Gold On Spins",
		Tooltip = "Off = only free spins. On = pay 100k gold per spin.",
		Default = boolFlag("WheelSpendGold", false),
	})

	local Misc = RewardsTab:AddLeftGroupbox("Codes", ICON.Key, true, false)
	Misc:AddInput("RedeemCode", {
		Text = "Redeem Code",
		Placeholder = "paste code",
	})
	Misc:AddButton("RedeemNow", {
		Text = "Redeem",
		Callback = function()
			local text = Options.RedeemCode and Options.RedeemCode.Value
			if type(text) ~= "string" or text:match("^%s*$") then
				Library:Notify({ Title = BRAND.Name, Description = "Type a code first.", Type = "Error", Time = 3 })
				return
			end
			local clean = text:gsub("%s+", "")
			local ok = fire(RedeemCodeRemote, "RedeemCode", clean)
			Library:Notify({
				Title = BRAND.Name,
				Description = ok and ("Redeemed: " .. clean) or "Redeem failed to send",
				Type = ok and "Info" or "Error",
				Time = 4,
			})
		end,
	})


end
end -- end of the Progression tab block
do
-- ===================== MISC TAB =====================

-- Movement and utilities. Standard executor features, kept in their own block so
-- a player who only wants the farm does not have to read them.
local AntiAfkOn = boolFlag("AntiAfkOn", true)
local NoclipOn  = boolFlag("NoclipOn", false)
local HideNameOn = boolFlag("HideNameOn", false)
local FlyOn     = boolFlag("FlyOn", false)

local flySpeed = numFlag("FlySpeed", 60)
local defaultWalkSpeed, defaultJumpHeight = 16, 7.2
pcall(function()
	local h = getHumanoid()
	if h then
		defaultWalkSpeed = h.WalkSpeed
		defaultJumpHeight = h.UseJumpPower and h.JumpPower or h.JumpHeight
	end
end)

local currentWalkSpeed = getFlag("WalkSpeed")
if type(currentWalkSpeed) ~= "number" then currentWalkSpeed = defaultWalkSpeed end

local currentJump = getFlag("JumpHeight")
if type(currentJump) ~= "number" then currentJump = defaultJumpHeight end

local noclipRunning = false
local flyOn = FlyOn
local flyBV, flyBG, flyConn
local flyKeys = { W = false, A = false, S = false, D = false, Space = false, Ctrl = false }

local function setNoclip(on)
	pcall(function()
		local char = LocalPlayer.Character
		if not char then return end
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = not on end
		end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.CanCollide = not on end
	end)
end

local function applyHideName(on)
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.NameDisplayDistance = on and 0 or 100
		hum.DisplayName = on and "" or LocalPlayer.DisplayName
	end
	for _, gui in ipairs(char:GetDescendants()) do
		if gui:IsA("BillboardGui") then
			gui.Enabled = not on
			for _, lbl in ipairs(gui:GetDescendants()) do
				if lbl:IsA("TextLabel") then
					lbl.Visible = not on
					lbl.TextTransparency = on and 1 or 0
				end
			end
		end
	end
end

local function noclipLoop()
	noclipRunning = true
	while getFlag("NoclipOn") == true and isCurrentGen() do
		pcall(function() setNoclip(true) end)
		task.wait(0.2)
	end
	pcall(function() setNoclip(false) end)
	noclipRunning = false
end

-- Walkspeed and jump each get an on/off switch, matching Fly. Dragging a slider
-- while the switch is off stores the value but leaves the humanoid alone, so the
-- character is never silently left at 200 speed with no way to see why.
local function applyWalkSpeed(v)
	currentWalkSpeed = math.clamp(tonumber(v) or defaultWalkSpeed, 8, 200)
	setFlag("WalkSpeed", currentWalkSpeed)
	if getFlag("SpeedOn") ~= true then return end
	local hum = getHumanoid()
	if hum then pcall(function() hum.WalkSpeed = currentWalkSpeed end) end
end

local function applyJump(v)
	currentJump = math.clamp(tonumber(v) or defaultJumpHeight, 0, 200)
	setFlag("JumpHeight", currentJump)
	if getFlag("JumpOn") ~= true then return end
	local hum = getHumanoid()
	if hum then
		pcall(function()
			if hum.UseJumpPower then hum.JumpPower = currentJump else hum.JumpHeight = currentJump end
		end)
	end
end

local function stopFly()
	flyOn = false
	setFlag("FlyOn", false)
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if flyBV then flyBV:Destroy() flyBV = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end
	local hum = getHumanoid()
	if hum then pcall(function() hum.PlatformStand = false end) end
	pcall(function() setNoclip(getFlag("NoclipOn") == true) end)
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
	flyBV.velocity = Vector3.zero
	flyBV.maxForce = Vector3.new(9e9, 9e9, 9e9)
	flyBV.Parent = hrp

	setNoclip(true)

	flyConn = RunService.Heartbeat:Connect(function()
		if not flyOn or not isCurrentGen() then stopFly() return end
		local char2 = LocalPlayer.Character
		local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")
		local cam = workspace.CurrentCamera
		if not hrp2 or not flyBV or not flyBG or not cam then return end

		local move = Vector3.zero
		if flyKeys.W then move += cam.CFrame.LookVector end
		if flyKeys.S then move -= cam.CFrame.LookVector end
		if flyKeys.A then move -= cam.CFrame.RightVector end
		if flyKeys.D then move += cam.CFrame.RightVector end
		if flyKeys.Space then move += Vector3.new(0, 1, 0) end
		if flyKeys.Ctrl then move -= Vector3.new(0, 1, 0) end
		if move.Magnitude > 0 then move = move.Unit * flySpeed end

		flyBV.velocity = move
		flyBG.cframe = cam.CFrame
	end)
end

-- Flight keys are ignored while a menu is open, or typing W in a config field
-- would fly the character sideways.
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	local k = input.KeyCode
	if k == Enum.KeyCode.W then flyKeys.W = true
	elseif k == Enum.KeyCode.A then flyKeys.A = true
	elseif k == Enum.KeyCode.S then flyKeys.S = true
	elseif k == Enum.KeyCode.D then flyKeys.D = true
	elseif k == Enum.KeyCode.Space then flyKeys.Space = true
	elseif k == Enum.KeyCode.LeftControl or k == Enum.KeyCode.LeftShift then flyKeys.Ctrl = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	local k = input.KeyCode
	if k == Enum.KeyCode.W then flyKeys.W = false
	elseif k == Enum.KeyCode.A then flyKeys.A = false
	elseif k == Enum.KeyCode.S then flyKeys.S = false
	elseif k == Enum.KeyCode.D then flyKeys.D = false
	elseif k == Enum.KeyCode.Space then flyKeys.Space = false
	elseif k == Enum.KeyCode.LeftControl or k == Enum.KeyCode.LeftShift then flyKeys.Ctrl = false
	end
end)

-- re-apply on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.6)
	local hum = char:WaitForChild("Humanoid", 6)
	if hum then
		pcall(function()
			if getFlag("SpeedOn") == true then hum.WalkSpeed = currentWalkSpeed end
		end)
		pcall(function()
			if getFlag("JumpOn") ~= true then return end
			if hum.UseJumpPower then hum.JumpPower = currentJump else hum.JumpHeight = currentJump end
		end)
	end
	if getFlag("HideNameOn") == true then task.wait(0.2) applyHideName(true) end
	if flyOn then task.wait(0.2) startFly() end
end)

-- keep walkspeed / jump from being reset by the game
task.spawn(function()
	while isCurrentGen() do
		task.wait(0.5)
		local hum = getHumanoid()
		if hum then
			if getFlag("SpeedOn") == true and math.abs(hum.WalkSpeed - currentWalkSpeed) > 0.5 then
				pcall(function() hum.WalkSpeed = currentWalkSpeed end)
			end
			if getFlag("JumpOn") == true then
				local cur = hum.UseJumpPower and hum.JumpPower or hum.JumpHeight
				if math.abs(cur - currentJump) > 0.5 then
					pcall(function()
						if hum.UseJumpPower then hum.JumpPower = currentJump else hum.JumpHeight = currentJump end
					end)
				end
			end
			if getFlag("HideNameOn") == true then pcall(function() applyHideName(true) end) end
		end
		if getFlag("NoclipOn") == true and not noclipRunning then task.spawn(noclipLoop) end
	end
end)

do
	local Utilities = Tabs.Misc:AddLeftGroupbox("Utilities", ICON.Shield, true, false)
	Utilities:AddToggle("AntiAFK", {
		Text = "Anti-AFK",
		Tooltip = "Jumps and clicks every 5 minutes so Roblox never kicks you",
		Default = getFlag("AntiAfkOn") ~= false,
	})
	Utilities:AddToggle("HideName", {
		Text = "Hide Name",
		Tooltip = "Hides your nametag and overhead billboard",
		Default = getFlag("HideNameOn") == true,
	})
	Utilities:AddToggle("Noclip", {
		Text = "Noclip",
		Tooltip = "Walk through walls",
		Default = getFlag("NoclipOn") == true,
	})

	local Movement = Tabs.Misc:AddRightGroupbox("Movement", ICON.Move, true, false)
	Movement:AddToggle("SpeedToggle", {
		Text = "Walkspeed",
		Tooltip = "Off leaves the game's own speed alone. The slider still remembers your value",
		Default = getFlag("SpeedOn") == true,
	})
	Movement:AddSlider("Walkspeed", {
		Text = "Walkspeed",
		Min = 8,
		Max = 200,
		Default = currentWalkSpeed,
		Step = 1,
		Tooltip = "Default 16 - max 200",
	})
	Movement:AddToggle("JumpToggle", {
		Text = "Jump Height",
		Tooltip = "Off restores the game's own jump. The slider still remembers your value",
		Default = getFlag("JumpOn") == true,
	})
	Movement:AddSlider("Jumpheight", {
		Text = "Jump Height",
		Min = 0,
		Max = 200,
		Default = currentJump,
		Step = 1,
		Tooltip = "JumpHeight / JumpPower, whichever the game uses",
	})

	local Flight = Tabs.Misc:AddRightGroupbox("Flight", ICON.Rocket, true, false)
	Flight:AddToggle("Fly", {
		Text = "Fly",
		Tooltip = "Enable flight (noclip while flying)",
		Default = flyOn,
	})
	Flight:AddSlider("FlySpeed", {
		Text = "Fly Speed",
		Min = 10,
		Max = 250,
		Default = flySpeed,
		Step = 5,
		Suffix = " studs/s",
	})

end
-- ===================== TOGGLE WIRING =====================
-- Every toggle writes straight back to an LH_ attribute. The loops read the
-- ATTRIBUTE, not Library.Toggles, so a toggle that failed to bind (or a config
-- that set the value before the loop existed) still has a single source of truth.

local function bindToggle(name, apply)
	if Toggles[name] then
		Toggles[name]:OnChanged(function(v) apply(v) end)
		return true
	end
	return false
end

-- Which toggles actually bound, published as LH_Bound / LH_Unbound.
--
-- A toggle that fails to bind looks IDENTICAL to a working one from the outside:
-- it flips, the loop runs, the flag never changes. Listing the misses turns that
-- from a guess into a readable fact.
local BoundList, UnboundList = {}, {}
local function bind(name, apply)
	if bindToggle(name, apply) then
		table.insert(BoundList, name)
		return
	end

	-- Sliders and dropdowns live in Options, not Toggles, and carry their own
	-- OnChanged. Handing one to bindToggle silently did nothing at all: no error,
	-- no entry in LH_Unbound at the time, and the flag simply never changed. That
	-- is how the Walkspeed, Jump Height and Fly Speed sliders ended up dead - drag
	-- them and nothing happened, which reads exactly like a game-side problem.
	if Options[name] and type(Options[name].OnChanged) == "function" then
		Options[name]:OnChanged(function(v) apply(v) end)
		table.insert(BoundList, name)
		return
	end

	table.insert(UnboundList, name)
end

bind("AutoStairs",   function(v) setFlag("AutoStairsOn", v == true) end)
bind("AutoUpgrades", function(v) setFlag("AutoUpgradesOn", v == true) end)
bind("AutoMine",     function(v) setFlag("AutoMineOn", v == true) end)
bind("AutoSmelt",    function(v) setFlag("AutoSmeltOn", v == true) end)
bind("AutoCrystals", function(v) setFlag("AutoCrystalsOn", v == true) end)
bind("CrystalDelay", function(v) setFlag("CrystalDelay", tonumber(v) or 0.6) end)
bind("AutoWood", function(v) setFlag("AutoWoodOn", v == true) end)
bind("WoodDelay", function(v) setFlag("WoodDelay", tonumber(v) or 0.6) end)
bind("AutoCollectIngots", function(v) setFlag("AutoCollectOn", v == true) end)
bind("AutoStarforge", function(v) setFlag("AutoStarforgeOn", v == true) end)
bind("AutoRefract",  function(v) setFlag("AutoRefractOn", v == true) end)
bind("AutoEquipTrail", function(v) setFlag("AutoEquipTrailOn", v == true) end)
bind("AutoDoors",    function(v) setFlag("AutoDoorsOn", v == true) end)
bind("AutoRebirth",  function(v) setFlag("AutoRebirthOn", v == true) end)
bind("RebirthKeepUpgrades", function(v) setFlag("RebirthGuard", v == true) end)
bind("AutoPotions",  function(v) setFlag("AutoPotionsOn", v == true) end)
bind("PotionReturnHome", function(v) setFlag("PotionReturnHome", v == true) end)
bind("AutoWheel",    function(v) setFlag("AutoWheelOn", v == true) end)
bind("WheelSpendGold", function(v) setFlag("WheelSpendGold", v == true) end)
bind("StairReturnBase", function(v) setFlag("StairReturnBase", v == true) end)

bind("AutoTree",       function(v) setFlag("AutoTreeOn", v == true) end)
bind("AutoBuyTrails",  function(v) setFlag("AutoBuyTrailsOn", v == true) end)

if Options.TreeOrder then
	Options.TreeOrder:OnChanged(function(v) setFlag("TreeOrder", tostring(v)) end)
	setFlag("TreeOrder", tostring(Options.TreeOrder.Value))
end
if Options.TreeInterval then
	Options.TreeInterval:OnChanged(function(v) setFlag("TreeInterval", tonumber(v) or 1.5) end)
	setFlag("TreeInterval", tonumber(Options.TreeInterval.Value) or 1.5)
end
if Options.TrailInterval then
	Options.TrailInterval:OnChanged(function(v) setFlag("TrailInterval", tonumber(v) or 3) end)
	setFlag("TrailInterval", tonumber(Options.TrailInterval.Value) or 3)
end

-- Published so a failed bind is a readable fact rather than a mystery:
--   ReplicatedStorage:GetAttribute("LH_Unbound")   -- names that did NOT attach
--   ReplicatedStorage:GetAttribute("LH_Bound")     -- names that did
setFlag("Bound", table.concat(BoundList, ","))
setFlag("Unbound", table.concat(UnboundList, ","))
if #UnboundList > 0 then
	warn("[SpecreWare] toggles that did NOT bind: " .. table.concat(UnboundList, ", ")
		.. " - those toggles will flip but do nothing")
end

-- ===================== CALLBACK CHAIN SELF-TEST =====================
-- Binding is not the same as working. A toggle can be attached, the loop can be
-- live, and the link between the click and the flag can still be dead - and that
-- looks exactly like a feature that does nothing.
--
-- So the chain is walked once, at load, and the result published as
-- ReplicatedStorage:GetAttribute("LH_SelfTest"):
--   1  not attached at all
--   2  OnChanged did not stick
--   3  callback -> attribute link is dead
--   4  SetValue -> RunChanged -> callback -> attribute is dead
--   5  chain is intact
-- Only the final hop (a real mouse click reaching the button) is not covered here;
-- that one is the library's own widget wiring.
do
	local report = {}
	local function probe(toggleName, flagName)
		local toggle = Toggles[toggleName]
		if not toggle then
			table.insert(report, toggleName .. "=1notAttached")
			return
		end
		if type(toggle.Changed) ~= "function" then
			table.insert(report, toggleName .. "=2onChangedMissing")
			return
		end

		-- direct callback invocation with the value a click would deliver.
		-- NOTE: pass TRUE explicitly - passing toggle.Value would pass the current
		-- (off) state and the callback would correctly write false, which reads as
		-- a dead link when it is not.
		setFlag(flagName, false)
		local ok = pcall(toggle.Changed, true)
		if not ok or getFlag(flagName) ~= true then
			table.insert(report, toggleName .. "=3callbackToFlagDead")
			return
		end

		-- full path: SetValue flips the value, Display repaints, RunChanged fires
		-- both Callback and Changed
		setFlag(flagName, false)
		local okSet = pcall(toggle.SetValue, toggle, true)
		if not okSet or getFlag(flagName) ~= true then
			table.insert(report, toggleName .. "=4setValueToFlagDead")
			return
		end

		-- put it back the way the player had it
		pcall(toggle.SetValue, toggle, false)
		setFlag(flagName, false)
		table.insert(report, toggleName .. "=5ok")
	end

	probe("AutoStairs", "AutoStairsOn")
	probe("AutoUpgrades", "AutoUpgradesOn")
	probe("AutoMine", "AutoMineOn")
	probe("AutoDoors", "AutoDoorsOn")

	setFlag("SelfTest", table.concat(report, " "))
	local bad = 0
	for _, entry in ipairs(report) do
		if not entry:find("=5ok") then bad += 1 end
	end
	if bad > 0 then
		warn("[SpecreWare] toggle callback chain FAILED: " .. table.concat(report, " "))
	end
end

-- Sliders and dropdowns write through the same path. Rounding matters here: the
-- library's Rounding is DECIMAL PLACES, while the old paste's increment was a
-- STEP, so a 0.05 step slider returns 0.4 and not 8.

if Options.StairInterval then
	Options.StairInterval:OnChanged(function(v) setFlag("StairInterval", tonumber(v) or 0.4) end)
	setFlag("StairInterval", tonumber(Options.StairInterval.Value) or 0.4)
end
if Options.UpgradeInterval then
	Options.UpgradeInterval:OnChanged(function(v) setFlag("UpgradeInterval", tonumber(v) or 0.6) end)
	setFlag("UpgradeInterval", tonumber(Options.UpgradeInterval.Value) or 0.6)
end
if Options.UpgradeCount then
	Options.UpgradeCount:OnChanged(function(v)
		setFlag("UpgradeCount", amountCountFromLabel(v))
	end)
	setFlag("UpgradeCount", amountCountFromLabel(Options.UpgradeCount.Value))
end
if Options.MineInterval then
	Options.MineInterval:OnChanged(function(v) setFlag("MineInterval", tonumber(v) or 0.35) end)
	setFlag("MineInterval", tonumber(Options.MineInterval.Value) or 0.35)
end
if Options.MineOre then
	Options.MineOre:OnChanged(function(v) setFlag("MineOre", tostring(v)) end)
	setFlag("MineOre", tostring(Options.MineOre.Value))
end
if Options.DoorInterval then
	Options.DoorInterval:OnChanged(function(v) setFlag("DoorInterval", tonumber(v) or 2) end)
	setFlag("DoorInterval", tonumber(Options.DoorInterval.Value) or 2)
end
if Options.PotionCheck then
	Options.PotionCheck:OnChanged(function(v) setFlag("PotionCheck", tonumber(v) or 20) end)
	setFlag("PotionCheck", tonumber(Options.PotionCheck.Value) or 20)
end
if Options.RebirthDelay then
	Options.RebirthDelay:OnChanged(function(v) setFlag("RebirthDelay", tonumber(v) or 8) end)
	setFlag("RebirthDelay", tonumber(Options.RebirthDelay.Value) or 8)
end

-- The three multi-selects mirror into string flags the loops can read.
if Options.UpgradeGroups then
	Options.UpgradeGroups:OnChanged(function(v) setFlag("UpgradeGroups", packSet(v)) end)
	setFlag("UpgradeGroups", packSet(Options.UpgradeGroups.Value))
end
if Options.DoorList then
	Options.DoorList:OnChanged(function(v) setFlag("DoorList", packSet(v)) end)
	setFlag("DoorList", packSet(Options.DoorList.Value))
end
if Options.PotionList then
	Options.PotionList:OnChanged(function(v) setFlag("PotionList", packSet(v)) end)
	setFlag("PotionList", packSet(Options.PotionList.Value))
end

-- Movement, back inside the Misc scope that owns its state. These live here
-- rather than above because they are the only consumers of startFly / stopFly /
-- applyWalkSpeed / applyJump, and keeping them in the same block keeps ~20 locals
-- off the top-level register budget.
do
	bind("AntiAFK",  function(v) setFlag("AntiAfkOn", v == true) end)
	bind("HideName", function(v) setFlag("HideNameOn", v == true) end)
	bind("Noclip",   function(v) setFlag("NoclipOn", v == true) end)
	bind("Fly",      function(v) if v then startFly() else stopFly() end end)
bind("SpeedToggle", function(v)
	setFlag("SpeedOn", v == true)
	-- Turning it on applies whatever the slider already holds; turning it off puts
	-- the game's own value back rather than leaving the character at 200.
	if v == true then applyWalkSpeed(currentWalkSpeed) else
		local hum = getHumanoid()
		if hum then pcall(function() hum.WalkSpeed = defaultWalkSpeed end) end
	end
end)
bind("JumpToggle", function(v)
	setFlag("JumpOn", v == true)
	if v == true then applyJump(currentJump) else
		local hum = getHumanoid()
		if hum then pcall(function()
			if hum.UseJumpPower then hum.JumpPower = defaultJumpHeight else hum.JumpHeight = defaultJumpHeight end
		end) end
	end
end)
	bind("Walkspeed", function(v) applyWalkSpeed(v) end)
	bind("Jumpheight", function(v) applyJump(v) end)
	bind("FlySpeed", function(v)
		flySpeed = math.clamp(tonumber(v) or 60, 10, 250)
		setFlag("FlySpeed", flySpeed)
	end)

	if HideNameOn == true then applyHideName(true) end
	if getFlag("NoclipOn") == true and not noclipRunning then task.spawn(noclipLoop) end
	if flyOn then task.defer(function() task.wait(0.8) if getFlag("FlyOn") == true then startFly() end end) end
end

end -- end of the Misc scope (movement state is local to it)

do
-- ===================== FARM LOGIC =====================
-- Each step returns immediately when its toggle is off, so one tick drives the
-- lot. isCurrentGen() is what stops a previous execution's copy of these loops.

local BasePosition = Vector3.new(-7.9, 8, -20.5)

local function basePosition()
	local spawn = workspace:FindFirstChild("Map")
	spawn = spawn and spawn:FindFirstChild("SpawnLocation", true)
	if spawn and spawn:IsA("BasePart") then return spawn.Position end
	return BasePosition
end

-- One table instead of nine chunk locals. This file sits against Volt's
-- 200-locals-per-chunk cap, and these timestamps only ever hand os.clock()
-- values between the loops below - a table field does the same job for one
-- register instead of nine. (LastMachineFire was never read; gone.)
local Fire = {
	Stair = 0, Upgrade = 0, Mine = 0, Door = 0, Potion = 0,
	Wheel = 0, Rebirth = 0, NextRebirth = 0,
}

-- ===================== AUTO STAIRS =====================
-- PROVEN: the server only accepts BuyStair when the player is near the stair.
-- A/B test at the top of the last stair: 61 -> 64 in 12s. At spawn: 30 fires,
-- zero bought. So this teleports to the top, fires, and (optionally) walks back.
local function doAutoStairs()
	if getFlag("AutoStairsOn") ~= true then return end
	if not BuyStairRemote then return end

	local interval = numFlag("StairInterval", 0.4)
	if os.clock() - Fire.Stair < interval then return end

	local owned = getStairs()
	local target = owned + 1
	local cost = nextStairCost(target)
	if cost > 0 and getGold() < cost then return end

	local spot = stairTop(owned)
	if not spot then return end

	Fire.Stair = os.clock()
	if not gotoAndHold(spot, 0.28) then return end

	fire(BuyStairRemote, "BuyStair", target)

	-- The mirror lags the server, so waiting here is what stops a double-buy
	-- against the same index. Without it the loop fires the same index twice.
	task.wait(0.35)

	if getFlag("StairReturnBase") == true then
		teleportTo(basePosition(), Vector3.new(0, 6, 0))
	end
end

-- ===================== AUTO UPGRADES =====================
-- PROVEN: BuyUpgrade has no proximity check at all. It fired from spawn and
-- bought. This is the highest-value loop in the game, so it runs on the fastest
-- tick and never touches the player's position.
--
-- The order matters: the cheapest affordable upgrade is bought first, so the
-- money goes into the thing with the best ratio rather than whatever happens to
-- be first in pairs() order.
local function doAutoUpgrades()
	-- Every early return records WHY it returned, published as LH_UpgStatus.
	-- "Enabled, loop running, nothing happens" is the single hardest state to
	-- debug from the outside, and this is the difference between guessing and
	-- reading the answer. Read it with:
	--   ReplicatedStorage:GetAttribute("LH_UpgStatus")
	local why = ""
	local function bail(reason)
		why = reason
		setFlag("UpgStatus", reason)
	end

	if getFlag("AutoUpgradesOn") ~= true then return end
	if not BuyUpgradeRemote then bail("BuyUpgrade remote missing") return end
	if not UpgradeConfig then bail("UpgradeConfig missing") return end

	local interval = numFlag("UpgradeInterval", 0.6)
	if os.clock() - Fire.Upgrade < interval then bail("waiting on interval") return end

	local selection = unpackSet(getFlag("UpgradeGroups"))
	if next(selection) == nil then bail("no groups selected") return end

	local quantity = numFlag("UpgradeCount", 1)
	local bestId, bestCost
	local considered, buyableCount = 0, 0

	-- The selection holds GROUP ids ("goldIncome"), but UpgradeDefs is keyed by
	-- UPGRADE ids ("moreMoney"). The group has to be expanded to its members
	-- before any lookup - passing the group id straight to upgradeDef() returns
	-- nil for every entry, which is why this loop used to consider nothing at all.
	for groupId in pairs(selection) do
		for _, id in ipairs(groupIds(groupId)) do
			local def = upgradeDef(id)
			if def then
				considered += 1
				local ok = upgradeBuyable(id, quantity)
				if ok then
					buyableCount += 1
					-- Rank by the cost of the NEXT level, in EVERY mode.
					--
					-- Max mode used to rank by def.baseCost instead, which is the
					-- cost of the FIRST level. That is a constant per upgrade, so the
					-- "cheapest" pick was really "whichever upgrade started cheapest"
					-- and never changed as levels were bought - the loop funnelled the
					-- entire wallet into one upgrade and left the rest of the board
					-- untouched. Observed with the Glyph Board: More Glyphs sat at
					-- 10/25 with 256M affordable because the whole wallet was going
					-- into Glyph Luck instead.
					local cost = upgradeNextCost(id, quantity)
						or upgradeNextCost(id, 1)
						or (tonumber(def.baseCost) or 0)
					if not bestCost or cost < bestCost then
						bestId, bestCost = id, cost
					end
				end
			end
		end
	end

	if not bestId then
		bail(string.format("nothing affordable (checked %d, buyable %d)", considered, buyableCount))
		return
	end

	Fire.Upgrade = os.clock()
	why = string.format("fired %s x%s @ %s (%s)", tostring(bestId),
		quantity == 0 and "MAX" or tostring(quantity),
		tostring(bestCost), amountLabelFromCount(quantity))
	fire(BuyUpgradeRemote, "BuyUpgrade", bestId, quantity)
	setFlag("UpgStatus", why)

	-- In Max mode, keep buying on the SAME tick. The client mirror lags the server
	-- by roughly a second, so re-reading cost here would re-pick the same upgrade
	-- and fire it again anyway; instead the loop just continues through the
	-- selection a bounded number of times per pass.
	--
	-- Without this the Glyph Board filled one upgrade per interval and the rest of
	-- the board looked frozen even with the wallet full and everything affordable.
	if quantity == 0 then
		local budget = UPGRADE_MAX_PER_TICK
		while budget > 0 do
			budget -= 1
			local nextId, nextCost
			for groupId in pairs(selection) do
				for _, id in ipairs(groupIds(groupId)) do
					if upgradeBuyable(id, quantity) then
						local cost = upgradeNextCost(id, quantity)
							or upgradeNextCost(id, 1)
							or (tonumber((upgradeDef(id) or {}).baseCost) or 0)
						if not nextCost or cost < nextCost then
							nextId, nextCost = id, cost
						end
					end
				end
			end
			if not nextId then break end
			fire(BuyUpgradeRemote, "BuyUpgrade", nextId, quantity)
			task.wait(0.12)
		end
		setFlag("UpgStatus", why .. " +max sweep")
	end
end

-- ===================== AUTO TREE =====================
-- BuyTreeNode takes node.id (a string like "GoldLeft1") and has NO proximity
-- check - verified by buying a node from spawn, where a reach-gated remote would
-- have been ignored.
--
-- The gates, copied from the game's own TreeClient tryBuy, in the same order:
--   1. already owned            tree[node.id]
--   2. unlocked                 TreeConfig.available(node, tree, floor, rebirths)
--   3. wallet >= cost           node.currency / node.cost
--   4. optional second currency node.extra (98 of the 274 nodes have one)
--
-- 0.4s per node is the client's own cooldown on the same node.
local LastTreeFire = 0

local function treeNodeBuyable(node, tree, floor, rebirths)
	if type(node) ~= "table" or type(node.id) ~= "string" then return false end
	if tree[node.id] then return false end

	local ok, available = pcall(TreeConfig.available, node, tree, floor, rebirths)
	if not ok or not available then return false end

	if (tonumber(node.cost) or 0) > wallet(node.currency) then return false end

	local extra = node.extra
	if type(extra) == "table" then
		if (tonumber(extra.amount) or 0) > wallet(extra.currency) then return false end
	end

	return true
end

local function doAutoTree()
	if getFlag("AutoTreeOn") ~= true then return end
	if not BuyTreeNodeRemote or not TreeConfig then return end

	local interval = numFlag("TreeInterval", 1.5)
	if os.clock() - LastTreeFire < interval then return end

	local tree = tblAt("tree")
	local floor = stairFloor()
	local rebirths = getRebirths()
	local preferValue = getFlag("TreeOrder") == "Best Value First"

	local best, bestKey
	for _, node in ipairs(TreeConfig.NODES) do
		if treeNodeBuyable(node, tree, floor, rebirths) then
			local cost = math.max(tonumber(node.cost) or 1, 1)
			local key
			if preferValue then
				-- biggest effect per unit cost, so a cheap strong node beats an
				-- expensive weak one instead of always draining on the latter
				key = cost / math.max(tonumber(node.value) or 1, 0.0001)
			else
				key = cost
			end
			if not best or key < bestKey then
				best, bestKey = node, key
			end
		end
	end

	if not best then return end

	LastTreeFire = os.clock()
	setFlag("TreeStatus", string.format("bought %s (%s %s, tier %s)",
		tostring(best.id), abbreviate(best.cost), walletName(best.currency), tostring(best.tier)))
	fire(BuyTreeNodeRemote, "BuyTreeNode", best.id)
end

-- ===================== AUTO BUY TRAILS =====================
-- BuyTrail(id) also has NO proximity check - verified by buying "ember" from the
-- base while standing next to the vendor booth bought "brick" first. So no
-- teleport either.
--
-- Gates: not owned, the vendor's door must be unlocked, the floor you have reached
-- must cover the trail's floor, and the wallet must cover its cost. Bought in
-- `order` so the cheapest tier comes first.
local LastTrailFire = 0

local TrailShopDoors = nil

-- Read straight off TrailConfig.VENDORS, never a hardcoded booth list. The game
-- has six trail booths now (Booth..Booth6, shops 1-6) and the list is expected to
-- grow again; a hardcoded table would keep buying from the first merchant only.
-- Verified: VENDORS[k] = { booth, shop, door } with doors trails2/door28/door37/
-- door43/door51, and every trail def carries the `shop` that selects one.
local function trailShopDoors()
	if TrailShopDoors then return TrailShopDoors end
	TrailShopDoors = {}
	if TrailConfig and type(TrailConfig.VENDORS) == "table" then
		for _, vendor in ipairs(TrailConfig.VENDORS) do
			if type(vendor) == "table" and type(vendor.shop) == "number"
				and type(vendor.door) == "string" then
				TrailShopDoors[vendor.shop] = vendor.door
			end
		end
	end
	return TrailShopDoors
end

local function doAutoBuyTrails()
	if getFlag("AutoBuyTrailsOn") ~= true then return end
	if not BuyTrailRemote or not TrailConfig then return end
	if type(TrailConfig.LIST) ~= "table" then return end

	local interval = numFlag("TrailInterval", 3)
	if os.clock() - LastTrailFire < interval then return end

	local owned = tblAt("trails")
	local doors = tblAt("doors")
	local floor = stairFloor()
	local shopDoors = trailShopDoors()

	local best, bestOrder
	-- Closest-to-affordable miss, so the status can say WHY nothing was bought.
	-- Without this a vendor whose door is still locked looks identical to a wallet
	-- that is too small, and the new merchants read as "not working".
	local miss, missOrder, missWhy
	for _, def in ipairs(TrailConfig.LIST) do
		if type(def) == "table" and type(def.id) == "string" and owned[def.id] ~= true then
			local door = shopDoors[def.shop]
			local doorOk = (door == nil) or doors[door] == true
			local floorOk = tonumber(def.floor) == nil or floor >= (tonumber(def.floor) or 0)
			local cost = tonumber(def.cost) or math.huge
			local ok = doorOk and floorOk and wallet(def.currency) >= cost
			local order = tonumber(def.order) or math.huge
			if ok then
				if not best or order < bestOrder then
					best, bestOrder = def, order
				end
			elseif not miss or order < missOrder then
				miss, missOrder = def, order
				if not doorOk then
					missWhy = string.format("%s needs door '%s'", tostring(def.id), tostring(door))
				elseif not floorOk then
					missWhy = string.format("%s needs floor %s (you are on %s)",
						tostring(def.id), tostring(def.floor), tostring(floor))
				else
					missWhy = string.format("%s costs %s %s", tostring(def.id),
						abbreviate(cost), walletName(def.currency))
				end
			end
		end
	end

	if not best then
		if miss then
			setFlag("TrailStatus", "waiting: " .. (missWhy or "nothing available"))
		else
			setFlag("TrailStatus", "every trail owned")
		end
		return
	end

	LastTrailFire = os.clock()
	setFlag("TrailStatus", string.format("bought %s (%s %s, tier %s)",
		tostring(best.id), abbreviate(best.cost), walletName(best.currency), tostring(best.tier)))
	fire(BuyTrailRemote, "BuyTrail", best.id)
end

-- ===================== AUTO MINE =====================
-- PROVEN: the server checks the distance from the CHARACTER to the BLOCK, not
-- to the mine entrance. From the middle of the generation area: 10+ fires, no
-- silver. From 4.5 studs of the block: silver 9 -> 144.
local MineCursor = 0

-- MINE COLLISION
-- Auto Mine drops the character onto a block, mines it, then drops onto the next
-- one. The generation area is a solid grid of stone and ore, so without this the
-- character ends up embedded in a block with the collision solver shoving it back
-- out every frame - which is what "stuck inside the rock" looks like from outside.
--
-- Only ever touched while Auto Mine is on, and every value it changes is recorded
-- first, so turning the toggle off restores the mine exactly as it found it.
-- Only ever touched while Auto Mine is on, and every value it changes is recorded
-- first, so turning the toggle off restores the mine exactly as it found it.
-- One table rather than five locals: the script sits near Luau's 200-register cap
-- for a chunk this size, so each extra top-level local is a real cost.
local MineClip = { on = false, saved = {}, conns = {} }

function MineClip.sweep(root)
	if not root then return end
	if root:IsA("BasePart") then
		if MineClip.on then
			if MineClip.saved[root] == nil then
				local ok, prev = pcall(function() return root.CanCollide end)
				if ok then
					MineClip.saved[root] = prev
					pcall(function() root.CanCollide = false end)
				end
			end
		else
			local prev = MineClip.saved[root]
			if prev ~= nil then
				pcall(function() root.CanCollide = prev end)
				MineClip.saved[root] = nil
			end
		end
	else
		for _, d in ipairs(root:GetDescendants()) do
			if d:IsA("BasePart") then MineClip.sweep(d) end
		end
	end
end

function MineClip.set(on)
	if MineClip.on == on then return end
	MineClip.on = on

	if on then
		MineClip.sweep(workspace:FindFirstChild("Mine"))
		-- MineClient rebuilds MineBlocks continuously as blocks are destroyed and
		-- new ones stream in, and those arrive collidable. A ChildAdded listener on
		-- workspace.Mine never sees them, because they are added INSIDE MineBlocks
		-- rather than to Mine. So the folder gets re-swept on a timer instead.
		local mine = workspace:FindFirstChild("Mine")
		if mine then
			table.insert(MineClip.conns, mine.ChildAdded:Connect(function(child)
				task.defer(function() if MineClip.on then MineClip.sweep(child) end end)
			end))
		end
		task.spawn(function()
			-- Re-fetch the character every pass rather than capturing it once: the
			-- toggle can be flipped mid-death, and a captured nil would silently
			-- leave every respawned rig fully collidable.
			while MineClip.on and isCurrentGen() do
				MineClip.sweep(LocalPlayer.Character)
				if os.clock() - (MineClip.sweptAt or 0) >= 1 then
					MineClip.sweptAt = os.clock()
					MineClip.sweep(workspace:FindFirstChild("Mine"))
				end
				task.wait(0.2)
			end
		end)
	else
		for _, c in ipairs(MineClip.conns) do
			pcall(function() c:Disconnect() end)
		end
		table.clear(MineClip.conns)
		for part in pairs(MineClip.saved) do
			local prev = MineClip.saved[part]
			pcall(function() part.CanCollide = prev end)
		end
		table.clear(MineClip.saved)
		MineClip.sweptAt = 0
	end
end

local function doAutoMine()
	if getFlag("AutoMineOn") ~= true then
		MineClip.set(false)
		return
	end
	if not MineBlockRemote then return end

	MineClip.set(true)

	local interval = numFlag("MineInterval", 0.35)
	if os.clock() - Fire.Mine < interval then return end

	-- "Ore To Mine": silver, iron, or both. Stone is never a target. The value is
	-- the dropdown LABEL, so read it as a plain string rather than a packed set.
	local ore = getFlag("MineOre")
	if ore ~= "Silver Ore" and ore ~= "Iron Ore" then ore = "Both" end
	local wantSilver = ore ~= "Iron Ore"
	local wantIron = ore ~= "Silver Ore"

	local cache = refreshSpots()
	local pool = {}
	for _, b in ipairs(cache.oreBlocks) do if wantSilver then pool[#pool + 1] = b end end
	for _, b in ipairs(cache.ironBlocks) do if wantIron then pool[#pool + 1] = b end end
	if #pool == 0 then return end

	-- Round-robin rather than always-first: always-first hammers one block that
	-- is already gone and starves.
	MineCursor = (MineCursor % #pool) + 1
	local target = pool[MineCursor]
	if not target then return end

	Fire.Mine = os.clock()
	if not gotoAndHold(target.pos, 0.3) then return end

	fire(MineBlockRemote, "MineBlock", target.cell)
	task.wait(0.2)
end

-- ===================== AUTO CRYSTALS =====================
-- No remote exists for this. CrystalClient never fires anything; it only reads
-- client:get("crystalGarden") and animates. The server grants crystals from
-- proximity + time, so the whole job is choosing a spot whose crystal is grown and
-- then standing still on it.
--
-- data.crystalGarden[spotName] is an ABSOLUTE ready-at timestamp, same shape as
-- the potion table. A missing key means fully grown, which is why progress()
-- returns exactly 1 for it.
--
-- One table for the config, the cursor, the parked spot and both bodies: the
-- chunk is at the register ceiling and this is 1 local instead of 5.
--
-- The bodies take NO self and reach back to Crystals by name. Written as methods
-- they took an implicit `self`, and every call route available here failed to
-- supply one - farmLoop's pcall(step) passes no arguments, and a wrapper closure
-- calling Crystals.run() behaved the same way. The failure was invisible because
-- "attempt to index nil with 'ticks'" was swallowed by the loop's own pcall.
-- Depending on a name that is in scope costs nothing and cannot be nil.
local Crystals = { cfg = requireShared("CrystalConfig"), cursor = 0, parked = nil }

function Crystals.readySpots()
	local out = {}
	local cfg = Crystals.cfg
	if not cfg or type(cfg.spots) ~= "function" then return out end
	local ok, spots = pcall(cfg.spots)
	if not ok or type(spots) ~= "table" then return out end

	local garden = tblAt("crystalGarden")
	local ups = tblAt("upgrades")
	local now = os.clock()
	pcall(function() now = workspace:GetServerTimeNow() end)

	for _, spot in ipairs(spots) do
		local key = spot.Name
		local ready = false
		pcall(function()
			local p = tonumber(cfg.progress(garden[key], now, ups))
			ready = (p ~= nil and p >= 1)
		end)
		if ready then out[#out + 1] = spot end
	end
	return out
end

function Crystals.run()
	-- Liveness stamp, set before every early return. Without it a loop that is
	-- never reached, or that always returns at the top, is indistinguishable from
	-- one that simply has nothing to do right now.
	Crystals.ticks = (Crystals.ticks or 0) + 1
	setFlag("CrystalTicks", Crystals.ticks)
	if getFlag("AutoCrystalsOn") ~= true then
		Crystals.parked = nil
		return
	end
	local cfg = Crystals.cfg
	if not cfg or type(cfg.base) ~= "function" then return end
	if (tblAt("doors") or {}).crystals ~= true then
		Crystals.parked = nil
		setFlag("CrystalStatus", "crystals door not unlocked")
		return
	end

	local spots = Crystals.readySpots()
	if #spots == 0 then
		Crystals.parked = nil
		setFlag("CrystalStatus", "no spot grown yet")
		return
	end

	-- Time spent standing on one crystal. This IS the cadence: the loop no longer
	-- adds its own delay on top, it just holds the position for this long and
	-- moves to the next grown spot. Lower = faster.
	local hold = math.clamp(tonumber(getFlag("CrystalDelay")) or 0.6, 0.1, 5)

	-- Stay put while the parked crystal is still harvestable. A payout lands
	-- roughly every 10s of contact, but the spot drops off readySpots as soon as
	-- the server takes it, so the common case is one hold then a move on.
	if Crystals.parked then
		for _, s in ipairs(spots) do
			if s.Name == Crystals.parked then
				local base = cfg.base(s)
				if base then gotoAndHold(base + Vector3.new(0, 3, 0), hold) end
				setFlag("CrystalStatus", string.format("harvesting %s (%.2fs each)", tostring(Crystals.parked), hold))
				return
			end
		end
		Crystals.parked = nil
	end

	Crystals.cursor = (Crystals.cursor % #spots) + 1
	local spot = spots[Crystals.cursor]
	if not spot then return end
	local base = cfg.base(spot)
	if not base then return end

	Crystals.parked = spot.Name
	setFlag("CrystalStatus", string.format("moving to %s (%.2fs each)", tostring(spot.Name), hold))
	gotoAndHold(base + Vector3.new(0, 3, 0), hold)
end

-- ===================== AUTO FARM WOOD =====================
-- Structurally identical to the crystal garden, which is the point: the grove has
-- no remote either. WoodClient never fires anything, the server chops from
-- proximity over time, and the payout lands while the character stands there.
--   spots        workspace.TreeSpots, 16 parts Tree01..Tree16
--   state        data.woodGrove[spotName] = ABSOLUTE ready-at timestamp; a MISSING
--                key means fully grown, exactly like crystalGarden
--   stand at     WoodConfig.base(spot) = spot.Position + (0, Size.Y/2, 0)
--   gate         WoodConfig.inReach(spot, HRP.Position, WoodConfig.reach(upgrades)),
--                HARVEST_RADIUS 5 and HARVEST_HEIGHT 8, scaled by upgrades
--   door         WoodConfig.DOOR = "door23"
-- Verified: stood on Tree01's base, wood 40 -> 50 (+10) and Tree01's key appeared
-- in data.woodGrove, i.e. the server took the hit and started it regrowing.
--
-- One table for the config, cursor, parked spot and both bodies: the chunk is at
-- the 200-register ceiling, so this is 1 local rather than 5. The bodies take no
-- `self` - see the note on Crystals.run for why an implicit self is not safe here.
local Grove = { cfg = requireShared("WoodConfig"), cursor = 0, parked = nil }

function Grove.readySpots()
	local out = {}
	local cfg = Grove.cfg
	if not cfg or type(cfg.spots) ~= "function" then return out end
	local ok, spots = pcall(cfg.spots)
	if not ok or type(spots) ~= "table" then return out end

	local grove = tblAt("woodGrove")
	local ups = tblAt("upgrades")
	local now = os.clock()
	pcall(function() now = workspace:GetServerTimeNow() end)

	for _, spot in ipairs(spots) do
		local key = spot.Name
		local ready = false
		pcall(function()
			local p = tonumber(cfg.progress(grove[key], now, ups))
			ready = (p ~= nil and p >= 1)
		end)
		if ready then out[#out + 1] = spot end
	end
	return out
end

function Grove.run()
	Grove.ticks = (Grove.ticks or 0) + 1
	if getFlag("AutoWoodOn") ~= true then
		Grove.parked = nil
		return
	end
	local cfg = Grove.cfg
	if not cfg or type(cfg.base) ~= "function" then return end
	if (tblAt("doors") or {})[cfg.DOOR] ~= true then
		Grove.parked = nil
		setFlag("WoodStatus", string.format("%s door not unlocked", tostring(cfg.DOOR)))
		return
	end

	local spots = Grove.readySpots()
	if #spots == 0 then
		Grove.parked = nil
		setFlag("WoodStatus", "no tree finished growing")
		return
	end

	-- Time per tree. This IS the cadence - the loop adds nothing on top, it holds
	-- the position for this long and moves to the next grown tree.
	local hold = math.clamp(tonumber(getFlag("WoodDelay")) or 0.6, 0.1, 5)

	if Grove.parked then
		for _, s in ipairs(spots) do
			if s.Name == Grove.parked then
				local base = cfg.base(s)
				if base then gotoAndHold(base + Vector3.new(0, 3, 0), hold) end
				setFlag("WoodStatus", string.format("chopping %s (%.2fs each)", tostring(Grove.parked), hold))
				return
			end
		end
		Grove.parked = nil
	end

	Grove.cursor = (Grove.cursor % #spots) + 1
	local spot = spots[Grove.cursor]
	if not spot then return end
	local base = cfg.base(spot)
	if not base then return end

	Grove.parked = spot.Name
	setFlag("WoodStatus", string.format("moving to %s (%.2fs each)", tostring(spot.Name), hold))
	gotoAndHold(base + Vector3.new(0, 3, 0), hold)
end

-- ===================== MACHINES =====================
-- Smelter, starforge and refractor all gate on being inside their room, so each
-- of these walks there first. They share one tick because they share one body.
local function doAutoSmelt()
	if getFlag("AutoSmeltOn") ~= true then return end
	if not SmelterDepositRemote then return end
	if getIron() <= 0 then return end

	local cache = refreshSpots()
	if not cache.smelter then return end

	if not gotoAndHold(cache.smelter, 0.4) then return end
	fire(SmelterDepositRemote, "SmelterDeposit")
	task.wait(0.35)
end

local function doAutoCollect()
	if getFlag("AutoCollectOn") ~= true then return end
	if not SmelterCollectRemote then return end

	local smelter = tblAt("smelter")
	if (tonumber(smelter.ready) or 0) <= 0 then return end

	local cache = refreshSpots()
	if not cache.smelter then return end

	if not gotoAndHold(cache.smelter, 0.4) then return end
	fire(SmelterCollectRemote, "SmelterCollect")
	task.wait(0.35)
end

local function doAutoStarforge()
	if getFlag("AutoStarforgeOn") ~= true then return end
	if not StarforgeDepositRemote then return end
	if getStarmetal() <= 0 then return end

	local cache = refreshSpots()
	if not cache.starforge then return end

	if not gotoAndHold(cache.starforge, 0.4) then return end
	fire(StarforgeDepositRemote, "StarforgeDeposit")
	task.wait(0.35)
end

local function doAutoRefract()
	if getFlag("AutoRefractOn") ~= true then return end
	if not RefractorDepositRemote then return end
	if getPrisms() <= 0 then return end

	local cache = refreshSpots()
	if not cache.refractor then return end

	if not gotoAndHold(cache.refractor, 0.4) then return end
	fire(RefractorDepositRemote, "RefractorDeposit")
	task.wait(0.35)
end

-- Equip the highest-tier trail actually owned. TrailConfig.totals() is the game's
-- own ranking, so "best" means best by the game's rules, not by our guess.
local function doAutoEquipTrail()
	if getFlag("AutoEquipTrailOn") ~= true then return end
	if not EquipTrailRemote or not TrailConfig then return end

	local owned = tblAt("trails")
	local current = nil
	pcall(function() current = DS:get("equippedTrail") end)

	-- "Best" means strongest multipliers, not the alphabetically largest tier.
	--
	-- The old ranking read def.tier first, and def.tier is a STRING
	-- ("uncommon", "legendary", ...). Comparing those with > is alphabetical, so
	-- "uncommon" beat "legendary" and the hub sat on a Silver Trail (silver 1.3x)
	-- while owning Prism (1.5x on gold, silver, iron and luck). Verified:
	-- data.equippedTrail was "silver" with prism and crown both owned.
	--
	-- Score = the sum of (buff - 1) across every currency the trail touches, so a
	-- four-way 1.5x outranks a single 1.5x. Ties break on tier rank from
	-- TrailConfig.TIER_BY_ID (common=1 .. prismatic=12) and then on the trail's own
	-- list order, which is the game's own cheapest-to-bestest progression.
	local function scoreOf(def)
		local total = 0
		if type(def.buffs) == "table" then
			for _, v in pairs(def.buffs) do
				local n = tonumber(v)
				if n and n > 1 then total = total + (n - 1) end
			end
		end
		return total
	end

	local function tierRank(def)
		local byId = TrailConfig.TIER_BY_ID
		local row = type(byId) == "table" and byId[def.tier] or nil
		return (type(row) == "table" and tonumber(row.order)) or 0
	end

	local bestId, bestScore, bestTier, bestOrder
	for id, has in pairs(owned) do
		if has == true then
			local def = TrailConfig.BY_ID and TrailConfig.BY_ID[id]
			if type(def) == "table" then
				local score = scoreOf(def)
				local tier = tierRank(def)
				local order = tonumber(def.order) or 0
				local better = false
				if bestId == nil then
					better = true
				elseif score ~= bestScore then
					better = score > bestScore
				elseif tier ~= bestTier then
					better = tier > bestTier
				else
					better = order > bestOrder
				end
				if better then
					bestId, bestScore, bestTier, bestOrder = id, score, tier, order
				end
			end
		end
	end

	if not bestId or bestId == current then return end
	setFlag("TrailEquipStatus", string.format("equipped %s (buff score %.2f, tier rank %s)",
		tostring(bestId), bestScore or 0, tostring(bestTier)))
	fire(EquipTrailRemote, "EquipTrail", bestId)
	task.wait(0.3)
end

-- ===================== DOORS =====================
-- Lowest floor first, because that is the order the game expects. Doors with a
-- rebirth requirement are skipped until the player has it, rather than firing
-- into a gate and pretending it worked.
local function nextDoor()
	local selection = unpackSet(getFlag("DoorList"))
	local owned = tblAt("doors")
	local rebirths = getRebirths()

	local best
	for _, entry in ipairs(DoorOrder) do
		if selHas(selection, entry.id) then
			local have = owned[entry.id]
			if have ~= true then
				if (entry.rebirths or 0) > rebirths then
					-- gated behind a rebirth we have not done: not a candidate yet
				else
					local cost = entry.cost
					if cost <= wallet(entry.currency) then
						best = entry
						break
					elseif not best then
						best = nil
					end
				end
			end
		end
	end
	return best
end

-- The cheapest un-owned selected door, for the readout, ignoring affordability.
local function cheapestPendingDoor()
	local selection = unpackSet(getFlag("DoorList"))
	local owned = tblAt("doors")
	local rebirths = getRebirths()
	local best
	for _, entry in ipairs(DoorOrder) do
		if selHas(selection, entry.id) and owned[entry.id] ~= true
			and (entry.rebirths or 0) <= rebirths then
			if not best or entry.cost < best.cost then best = entry end
		end
	end
	return best
end

local function doAutoDoors()
	if getFlag("AutoDoorsOn") ~= true then return end
	if not UnlockDoorRemote then return end

	local interval = numFlag("DoorInterval", 2)
	if os.clock() - Fire.Door < interval then return end

	local door = nextDoor()
	if not door then return end

	local spot = doorPosition(door.id)
	if not spot then return end

	Fire.Door = os.clock()
	if not gotoAndHold(spot, 0.4) then return end
	fire(UnlockDoorRemote, "UnlockDoor", door.id)
	task.wait(0.5)
end

-- ===================== POTIONS =====================
-- The gate is PotionConfig's own, not a hand-rolled one.
--
-- The game does NOT track "how much is left" in data.potionsLeft - that table
-- stays permanently empty. data.potions[id] holds the ABSOLUTE expiry timestamp,
-- so seconds-left is expiry - serverTime, which is exactly what PotionConfig.remaining
-- computes. Reading potionsLeft made every potion look expired forever, so the hub
-- re-bought a potion it already had running, and because PotionConfig.canAdd caps a
-- stack at MAX_SECONDS those buys were then refused by the server: continuous
-- spending, zero effect. (Verified: after a manual FireServer("silver") from the booth
-- silver went 1791044982.9 -> 1791045689.9, so the remote and the reach gate are fine.)
local function doAutoPotions()
	if getFlag("AutoPotionsOn") ~= true then return end
	if not BuyPotionRemote then return end
	if not PotionConfig or not PotionConfig.LIST or not PotionConfig.remaining then return end

	local interval = numFlag("PotionCheck", 20)
	if os.clock() - Fire.Potion < interval then return end

	local selection = unpackSet(getFlag("PotionList"))
	if next(selection) == nil then return end

	-- Server clock: potion expiry stamps are stamped on it.
	local now = os.clock()
	pcall(function() now = workspace:GetServerTimeNow() end)

	local owned = tblAt("potions")
	local chosen = {}
	for _, def in ipairs(PotionList) do
		-- The dropdown stores DISPLAY NAMES ("Greater Gold Potion"), so match on
		-- the name as well as the raw id. Comparing only def.id meant nothing the
		-- UI could ever select matched, and PotionIdFor - built for exactly this -
		-- was never called, so Auto Potions silently bought nothing. The id arm
		-- keeps configs saved before the rename working.
		local label = (type(def.name) == "string" and def.name ~= "") and def.name or def.id
		local picked = selHas(selection, label) or selHas(selection, def.id)
		if picked then
			local remaining = PotionConfig.remaining(owned, def.id, now)
			-- Only buy when it is actually gone, and only if the stack has room.
			if remaining <= 1 and PotionConfig.canAdd(owned, def.id, def.duration, now) then
				chosen[#chosen+1] = def
			end
		end
	end
	if #chosen == 0 then return end

	-- Cheapest first: the early tiers are gold, the late ones crystals, and
	-- buying a 150k crystal potion when a 45M gold one is available is a waste.
	--
	-- Buy EVERY eligible potion in one sweep rather than one per tick. The old
	-- shape picked a single best and returned, so topping up six potions took six
	-- ticks - at the 20s default that is two minutes of standing still. Grouped
	-- by booth, because a booth is one walk: the character visits each booth once
	-- and fires everything it sells from there.
	--
	-- Fires are spaced 0.35s apart. Measured on the server: 0.3s gaps all landed,
	-- 0.15s gaps silently dropped everything after the first, so 0.35 has margin.
	local groups, groupOrder = {}, {}
	local doors = tblAt("doors")
	for _, def in ipairs(chosen) do
		local cost = tonumber(def.cost) or math.huge
		local doorOk = def.door == nil or doors[def.door] == true
		if cost <= wallet(def.currency) and doorOk then
			local key = tostring(def.booth)
			if not groups[key] then
				groups[key] = {}
				table.insert(groupOrder, { booth = key, firstCost = cost, items = groups[key] })
			end
			table.insert(groups[key], def)
		end
	end
	if #groupOrder == 0 then
		setFlag("PotionStatus", "nothing affordable or unlocked")
		return
	end
	table.sort(groupOrder, function(a, b)
		if a.firstCost ~= b.firstCost then return a.firstCost < b.firstCost end
		return a.booth < b.booth
	end)

	-- Remember where the player was standing before the trip, so a purchase does
	-- not leave them parked at a potion booth across the map. Auto Mine will walk
	-- them straight back to a block on its next tick anyway, but a player who has
	-- Auto Mine off should not be left standing in a merchant district they never
	-- walked to.
	local home = nil
	local hrp = getRoot()
	if hrp then home = hrp.CFrame end

	Fire.Potion = os.clock()
	local cache = refreshSpots()
	local bought = 0
	local lastLabel = ""

	for _, group in ipairs(groupOrder) do
		local spot = cache.booths and cache.booths[group.booth]
		if not spot then
			setFlag("PotionStatus", "booth not found: " .. tostring(group.booth))
		elseif not gotoAndHold(spot, 0.45) then
			-- Character went away mid-sweep; leave the rest for the next pass.
			break
		else
			for _, def in ipairs(group.items) do
				fire(BuyPotionRemote, "BuyPotion", def.id)
				bought = bought + 1
				lastLabel = string.format("%s (%s %s)", tostring(def.name or def.id),
					abbreviate(def.cost), walletName(def.currency))
				setFlag("PotionStatus", string.format("bought %s at %s (%d this sweep)",
					lastLabel, tostring(group.booth), bought))
				task.wait(0.35)
			end
		end
	end

	if bought == 0 then return end
	if home and getFlag("PotionReturnHome") ~= false then
		local back = getRoot()
		if back then pcall(function() back.CFrame = home end) end
	end
end

-- ===================== PRIZE WHEEL =====================
-- Free spins come round every FREE_COOLDOWN seconds. The gold option is off by
-- default because 100k a spin is a real cost and most players want the free ones.
local function doAutoWheel()
	if getFlag("AutoWheelOn") ~= true then return end
	if not SpinWheelRemote then return end

	local cache = refreshSpots()
	if not cache.wheelPos then return end

	local wheel = tblAt("wheel")
	local nextFree = tonumber(wheel.nextFree) or 0
	local now = os.clock()
	local freeReady = nextFree > 0 and (now >= nextFree)

	-- wheel.nextFree is on the server's clock, which is not os.clock(). So "free
	-- ready" is judged by whether nextFree has been stamped at all and we are
	-- past the local cooldown, and the gold option covers the rest.
	if not freeReady and getFlag("WheelSpendGold") ~= true then
		if os.clock() - Fire.Wheel < (WheelConfig and WheelConfig.FREE_COOLDOWN or 600) then return end
	end

	if os.clock() - Fire.Wheel < 8 then return end
	Fire.Wheel = os.clock()

	if not gotoAndHold(cache.wheelPos, 0.45) then return end
	fire(SpinWheelRemote, "SpinWheel")
	task.wait(0.5)
end

-- ===================== REBIRTH =====================
-- The most dangerous toggle in the script, so it has three guards: it only ever
-- fires the NEXT index, it only fires when the scaled cost is genuinely covered,
-- and with RebirthKeepUpgrades on it refuses until the keeper upgrades are owned.
-- A rebirth that ignores keepers throws away hours of progress.
local function keepersOwned()
	for _, groupId in ipairs({ "keepers" }) do
		for _, id in ipairs(groupIds(groupId)) do
			local def = upgradeDef(id)
			if def and type(def.cap) == "number" and upgradeLevel(id) < def.cap then
				return false, def
			end
		end
	end
	return true, nil
end

local function doAutoRebirth()
	if getFlag("AutoRebirthOn") ~= true then return end
	if not RebirthRemote then return end
	if #RebirthList == 0 then return end
	if os.clock() < Fire.NextRebirth then return end

	if os.clock() - Fire.Rebirth < 5 then return end

	if getFlag("RebirthGuard") == true then
		local owned, missing = keepersOwned()
		if not owned then return end
	end

	local done = getRebirths()
	local entry = RebirthList[done + 1]
	if not entry then return end

	local cost = entry.def.cost
	if RebirthConfig and type(RebirthConfig.scaledCost) == "function" then
		local ok, scaled = pcall(function() return RebirthConfig.scaledCost(entry.def.cost, done) end)
		if ok and type(scaled) == "number" then cost = scaled end
	end

	if wallet(entry.def.currency or "gold") < cost then return end

	Fire.Rebirth = os.clock()
	fire(RebirthRemote, "Rebirth", entry.index)

	-- Give the run time to rebuild before considering the next one.
	Fire.NextRebirth = os.clock() + numFlag("RebirthDelay", 8)
	task.wait(1.5)
end

-- ===================== LOOPS =====================
-- Each step returns immediately when its toggle is off, so one tick drives the
-- lot. Every body is pcall'd and every failure is recorded, because a loop that
-- dies silently is indistinguishable from a loop with nothing to do.

-- Cancellation seam. Set the attribute to true to stop every farm loop without
-- reloading:  ReplicatedStorage:SetAttribute("LH_Cancel", true)
-- Clear it to start them again. This exists because a reload is the only other
-- way to stop a loop, and reloading re-reads every toggle from the config file.
local function farmLoop(steps, interval)
	task.spawn(function()
		while isCurrentGen() do
			for _, step in ipairs(steps) do
				if not isCurrentGen() then return end
				if getFlag("Cancel") == true then return end
				local ok, err = pcall(step)
				if not ok and isCurrentGen() then
					logFail(step.name or "farm", err)
				end
			end
			task.wait(interval or 0.5)
		end
	end)
end

-- Ordered by how much they matter. Upgrades first: no reach gate, no teleport,
-- pure profit. Stairs next, because they are the income that funds everything.
farmLoop({
	doAutoUpgrades,
	doAutoStairs,
	doAutoMine,
	doAutoSmelt,
	doAutoCollect,
}, 0.35)

farmLoop({
	doAutoStarforge,
	doAutoRefract,
	doAutoEquipTrail,
	doAutoBuyTrails,
	doAutoTree,
	doAutoDoors,
}, 1.2)

farmLoop({
	doAutoPotions,
	doAutoWheel,
	doAutoRebirth,
}, 3)

-- Its own loop, written out rather than going through farmLoop, because farmLoop
-- calls `pcall(step)` with no arguments and Crystals.run takes none either.
-- The cadence lives entirely inside Crystals.run's hold, so the loop itself just
-- yields briefly; adding a wait here as well was what doubled the old 0.9s into a
-- ~1.9s round trip per crystal.
task.spawn(function()
	while isCurrentGen() do
		local ok, err = pcall(Crystals.run)
		if not ok and isCurrentGen() then
			logFail("AutoCrystals", err)
		end
		task.wait(0.05)
	end
end)

-- Wood gets its own loop for the same reason: it and Auto Mine both teleport the
-- character, and it and the crystal loop both hold a spot for a fixed time. Three
-- of them sharing a tick drags the character between yards and nothing completes.
task.spawn(function()
	while isCurrentGen() do
		local ok, err = pcall(Grove.run)
		if not ok and isCurrentGen() then
			logFail("AutoWood", err)
		end
		task.wait(0.05)
	end
end)

-- Anti-AFK: jump so the session is never idle-kicked. The VirtualInputManager
-- click is pcall'd because on this executor SendKeyEvent is a no-op when the
-- window is unfocused - which is exactly the case anti-AFK exists for - so the
-- jump is what actually does the work.
task.spawn(function()
	while isCurrentGen() do
		task.wait(300)
		if isCurrentGen() and getFlag("AntiAfkOn") ~= false then
			pcall(function()
				local hum = getHumanoid()
				if hum then hum.Jump = true end
				local virtualUser = game:GetService("VirtualUser")
				virtualUser:CaptureController()
				virtualUser:ClickButton2(Vector2.new())
			end)
		end
	end
end)

-- Live session readout. The three rate-tracking locals live inside the loop's
-- own do-block: nothing else reads them, and keeping them off the chunk's
-- register window matters on Volt's 200-local cap.
do
	local LastGoldSample = getGold()
	local LastGoldAt = os.clock()
	local MeasuredRate = 0

task.spawn(function()
	while isCurrentGen() do
		pcall(function()
			local elapsed = math.max(math.floor(os.clock() - StartedAt), 0)
			local uptime = string.format("%02d:%02d:%02d",
				math.floor(elapsed / 3600), math.floor((elapsed % 3600) / 60), elapsed % 60)
			local gold = getGold()
			local stairs = getStairs()

			-- measured over a real window rather than a one-shot delta, so the
			-- number does not flicker with a single payout tick
			local now = os.clock()
			if now - LastGoldAt >= 2 then
				MeasuredRate = (gold - LastGoldSample) / (now - LastGoldAt)
				LastGoldSample = gold
				LastGoldAt = now
			end

			if UI.grid and UI.grid.SetValue then
				UI.grid:SetValue("Gold", abbreviate(gold))
				UI.grid:SetValue("Stairs", tostring(math.floor(stairs)))
				UI.grid:SetValue("Gold/s", abbreviate(math.max(MeasuredRate, 0)), BRAND.Sheen)
				UI.grid:SetValue("Rebirths", tostring(math.floor(getRebirths())))
				UI.grid:SetValue("Uptime", uptime)
			end

			-- Obsidian Label objects are plain Lua tables wrapping a TextLabel.
			-- Assigning `.Text` writes a dead field on the table; only `:SetText()`
			-- pushes the string into the rendered TextLabel (and re-runs the wrap
			-- measurement). EVERY line below has to use SetText - assigning .Text
			-- looks completely correct and silently renders nothing, which is how
			-- the "Nodes bought" counter stayed frozen at 0 forever.
			if UI.session then
				UI.session:SetText("Uptime: " .. uptime)
				UI.gold:SetText("Gold: " .. abbreviate(gold))
				UI.stairs:SetText("Stairs: " .. tostring(math.floor(stairs)))
				UI.income:SetText("Gold/s: " .. abbreviate(math.max(MeasuredRate, 0)))
				UI.errors:SetText("Errors: " .. tostring(#Failures))
			end

			if UI.stairCost then
				local cost = nextStairCost(math.floor(stairs) + 1)
				UI.stairCost:SetText(string.format("Cost: %s Gold", abbreviate(cost)))
			end

			if UI.treeProgress then
				local owned, of = 0, 0
				local tree = tblAt("tree")
				if TreeConfig and type(TreeConfig.NODES) == "table" then
					of = #TreeConfig.NODES
					for _ in pairs(tree) do owned += 1 end
				end
				local line = string.format("Nodes bought: %d / %d", owned, of)
				local treeStatus = getFlag("TreeStatus")
				if type(treeStatus) == "string" and treeStatus ~= "" then
					line ..= "\n" .. treeStatus
				end
				local trailStatus = getFlag("TrailStatus")
				if type(trailStatus) == "string" and trailStatus ~= "" then
					line ..= "\n" .. trailStatus
				end
				UI.treeProgress:SetText(line)
			end

			if UI.labels.Potion then
				local ps = getFlag("PotionStatus")
				UI.labels.Potion:SetText("Potion: " .. (type(ps) == "string" and ps ~= "" and ps or "idle"))
			end

			if UI.labels.Crystal then
				local cs = getFlag("CrystalStatus")
				UI.labels.Crystal:SetText("Crystal: " .. (type(cs) == "string" and cs ~= "" and cs or "idle"))
			end

			if UI.labels.Wood then
				local ws = getFlag("WoodStatus")
				UI.labels.Wood:SetText("Wood: " .. (type(ws) == "string" and ws ~= "" and ws or "idle"))
			end

			if UI.nextDoor then
				local door = cheapestPendingDoor()
				if door then
					UI.nextDoorName:SetText(door.id)
					UI.nextDoor:SetText(string.format("%s %s", abbreviate(door.cost), walletName(door.currency)))
				else
					UI.nextDoorName:SetText("nothing selected")
					UI.nextDoor:SetText("-")
				end
			end
		end)
		task.wait(1)
	end
end)
end -- status loop scope (LastGoldSample / LastGoldAt / MeasuredRate die here)

end -- end of the Farm Logic scope: every loop above is now closed over and dead

-- ===================== CONFIGS =====================

if SaveManager then
	pcall(function()
		SaveManager:SetLibrary(Library)
		SaveManager:IgnoreThemeSettings()
		SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
		SaveManager:SetFolder("LiquidHub/TowerIncremental")

		-- BuildConfigSection hardcodes Side = "Right" for its groupbox
		-- (SaveManager.lua:1091) and exposes no way to override it, so the only
		-- lever is to wrap the tab's AddGroupbox for the duration of the call
		-- and restore it straight after.
		local addGroupbox = Tabs.Settings.AddGroupbox
		Tabs.Settings.AddGroupbox = function(self, info)
			info = info or {}
			info.Side = "Left"
			return addGroupbox(self, info)
		end

		local okBuild, buildErr = pcall(function()
			SaveManager:BuildConfigSection(Tabs.Settings)
		end)

		Tabs.Settings.AddGroupbox = addGroupbox

		if not okBuild then warn("[SpecreWare] config section failed: " .. tostring(buildErr)) end

		-- Autoload is NOT loaded on boot. The farm loops read the LH_ attributes,
		-- which a saved config would overwrite at startup - so a player who saved
		-- with Auto Rebirth on would come back to a hub that rebirths without
		-- asking. Toggles stay where the player left them in the session.
	end)
end

-- ===================== CREDITS =====================

do
	local Team = Tabs.Credits:AddLeftGroupbox("Team", ICON.ShieldOK, true, false)
	Team:AddLabel("SpecreWare Team")
	Team:AddLabel("Game: " .. GAME_NAME)
	pcall(function() Team:AddDivider() end)

	local Community = Tabs.Credits:AddLeftGroupbox("Community", ICON.Heart, true, false)
	pcall(function()
		-- purpose-built Discord card: avatar, presence dot, title / subtitle and a
		-- button row. Style = "Primary" fills with Scheme.BlueColor, which is set
		-- to the brand azure, and Copy = true copies the card's own Link, so no
		-- manual clipboard handling here.
		--
		-- Avatar matters: the card reserves an avatar overhang above the body, so
		-- with Avatar left nil it renders as a large empty box. Passing the logo
		-- asset fills that space.
		Community:AddDiscordBox("Invite", {
			Avatar   = LOGO_ICON,
			Title    = "SpecreWare",
			Subtitle = BRAND.Invite,
			Status   = "online",
			Accent   = BRAND.Azure,
			Link     = BRAND.Discord,
			Buttons  = {
				{
					Text  = "Copy Invite",
					Icon  = "copy",
					Copy  = true,
					Style = "Primary",
				},
				{
					Text  = "Copy Short",
					Icon  = "link",
					Copy  = BRAND.Invite,
					Style = "Secondary",
				},
			},
		})
	end)
	Community:AddLabel("Report bugs or request a game in Discord.", true)
end -- end of the Credits block

-- ===================== DONE =====================

splashClose()

Library:Notify({
	Title = BRAND.Name,
	Description = string.format(
		"Loaded for %s. %d/%d remotes live. RightControl toggles the menu.",
		GAME_NAME, REMOTE_COUNT, REMOTE_TOTAL),
	Time = 6,
	Type = REMOTE_COUNT == REMOTE_TOTAL and "Info" or "Error",
})


-- Create built-in THEME and SETTINGS tabs (SpectreUI official features)
pcall(function()
	Window:CreateThemeTab()
	Window:CreateSettingsTab()
end)

-- Auto-load saved player config if enabled
Window:OnLoaded(function()
	pcall(function() Library:AutoloadConfig("auto", true) end)
end)

Window:Notify({
	Title = "SpecreWare Loaded",
	Content = string.format("Tower Incremental loaded! %d/%d remotes live. RightControl to toggle.", REMOTE_COUNT, REMOTE_TOTAL),
	Kind = "Success",
	Duration = 6,
})
