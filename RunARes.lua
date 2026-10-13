return (function(...)
  getgenv().SpectreWare_Authorized = true
  local s = "77843161404023"
  if tostring(game.PlaceId) ~= s then
    return
  end
  if not game:IsLoaded() then
    game.Loaded:Wait()
  end
  task.wait(1)
  pcall(function()
    (game:GetService("StarterGui")):SetCore("SendNotification", { Title = "SpectreWare", Text = "Loading fresh build...", Duration = 3 })
  end)
  do
    pcall(function()
      local s = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
      if s then
        for s, X in ipairs(s:GetChildren()) do
          if X.Name:find("RAR") or X.Name:find("Fluent") or X.Name:find("SpectreWare") then
            pcall(function()
              X:Destroy()
            end)
          end
        end
      end
      local X = game:GetService("CoreGui")
      if X then
        for s, X in ipairs(X:GetChildren()) do
          if X.Name:find("Fluent") or X.Name:find("SpectreWare") or X.Name:find("RAR") then
            pcall(function()
              X:Destroy()
            end)
          end
        end
      end
    end)
  end;
  getgenv()._rar_gen = ((getgenv()._rar_gen or 0)) + 1;
  getgenv()._rar_build = "rar-daily-v3";
  getgenv().rarDailyDiag = getgenv().rarDailyDiag or {}
  local X = getgenv()._rar_gen
  local function z()
    return getgenv()._rar_gen == X
  end;
  getgenv().SpectreWare_Connections = getgenv().SpectreWare_Connections or {}
  local function l(s, X)
    if getgenv().SpectreWare_Connections[s] then
      local X = getgenv().SpectreWare_Connections[s]
      if typeof(X) == "RBXScriptConnection" then
        pcall(function()
          X:Disconnect()
        end)
      elseif type(X) == "table" then
        local s = pcall(function()
          X:Disconnect()
        end)
        if not s then
          local s = pcall(function()
            X:disconnect()
          end)
          if not s then
            pcall(function()
              X:Destroy()
            end)
          end
        end
      end
    end;
    getgenv().SpectreWare_Connections[s] = X
    return X
  end
  local function x(s)
    local X = game.Players.LocalPlayer["Character"] and game.Players.LocalPlayer["Character"]:FindFirstChild("HumanoidRootPart")
    if not X then
      return
    end
    X.CFrame = s
    local z
    local l = 0
    z = (game:GetService("RunService")).Heartbeat:Connect(function()
      l = l + 1
      if X then
        X.AssemblyLinearVelocity = Vector3.zero
        X.AssemblyAngularVelocity = Vector3.zero
      end
      if l >= 5 then
        z:Disconnect()
      end
    end)
  end
  local w = game:GetService("TweenService")
  local M = game:GetService("UserInputService")
  local D = game:GetService("RunService")
  local N = game:GetService("Players")
  local H = game:GetService("HttpService")
  local t = game:GetService("VirtualUser")
  local r = game:GetService("CoreGui")
  local v = game:GetService("TeleportService")
  local b = task.wait
  local G = pcall
  local g = CFrame.new
  local j = Vector3.new
  local O = math.random
  local e = table.insert
  local L = table.remove
  local h = tick
  local i = N.LocalPlayer
  local m = i:WaitForChild("PlayerGui")
  local Q = game:GetService("ReplicatedStorage")
  local R = require(Q.Framework["Client"].Network)
  local I = require(Q.Framework["Client"].ClientRestaurant)
  local W = require(Q.Framework["Client"].ClientFishing)
  local S = require(Q.Framework["Client"].ClientDeepPool)
  local n = require(Q.Framework["Client"].ClientRestaurant)
  local Y = require(Q.Framework["Client"].DayCmds)
  local k = require(Q.Framework["Client"].ClientEntity["ClientCrop"])
  local J = require(Q.Framework["Client"].BlackMarketCmds)
  local V = require(Q.Framework["Types"].BlackMarketTypes)
  local B = require(Q.Framework["Types"].FishingTypes)
  local Z = require(Q.Framework["Client"].InventoryCmds)
  local U = require(Q.Framework["Directory"].Item)
  local f = nil
  local function F()
    if f then
      return f
    end
    G(function()
      f = require(Q.Framework["Client"].ClientRestaurant)
    end)
    return f
  end
  local function a(s)
    return s.Class
  end
  local function p(s)
    return s.Dir and s.Dir["Subclass"]
  end
  local function E(s)
    return s.DirId
  end
  local function y(s, X)
    if not s then
      return false
    end
    local z, l = G(a, s)
    local x = z and tostring(l or "") or ""
    if x == X then
      return true
    end
    local w, M = G(p, s)
    local D = w and tostring(M or "") or ""
    if D == X then
      return true
    end
    for s in D:gmatch("[^%s]+") do
      if s == X then
        return true
      end
    end
    local N, H = G(E, s)
    local t = N and tostring(H or "") or ""
    if t:lower() == X:lower() then
      return true
    end
    return false
  end
  local function o(s, X)
    if not s then
      return false
    end
    local z, l = G(E, s)
    local x = string.lower(tostring(z and l or ""))
    for s, X in ipairs(X) do
      if string.find(x, X, 1, true) then
        return true
      end
    end
    return false
  end
  local function P(s, X)
    if not s then
      return {}
    end
    local z, l = G(function()
      return s:CollectSubclass(X)
    end)
    if z and type(l) == "table" then
      return l
    end
    local x = {}
    local w, M = G(function()
      return s.Entity
    end)
    if not w or type(M) ~= "table" then
      return {}
    end
    for s, z in next, M do
      if y(z, X) then
        x[#x + 1] = z
      end
    end
    return x
  end
  local function T(s)
    return s.SaveVars
  end
  local function q(s, X)
    if not s then
      return nil, "no entity"
    end
    local z, l = G(T, s)
    if z and type(l) == "table" then
      for X, z in pairs(l) do
        if type(X) == "string" and (X:sub(1, 4) == "Pri_" and type(z) == "number") then
          local z = X:sub(5)
          local l, x = G(function()
            return s:Invoke(z)
          end)
          if l and x ~= false then
            return true, z
          end
        end
      end
    end
    if X then
      for X, z in ipairs(X) do
        local l, x = G(function()
          return s:Invoke(z)
        end)
        if l and x ~= false then
          return true, z
        end
      end
    end
    return false, "all actions rejected"
  end
  do
    if not getgenv()._rar_netHooked then
      getgenv()._rar_netHooked = true;
      getgenv()._rar_netLog = getgenv()._rar_netLog or {}
      G(function()
        local s = require(Q.Framework["Client"].Network)
        local X = s.Fire or s.FireServer
        local z = s.Fired or s.OnClientEvent
        local l = s.Invoke or s.InvokeServer
        local function x(s, X, z)
          local l = getgenv()._rar_netLog
          if #l > 400 then
            for s = 1, 100, 1 do
              table.remove(l, 1)
            end
          end
          l[#l + 1] = { dir = s; name = X; args = z }
        end
        if s.Fire then
          s.Fire = function(s, ...)
            x("fire", s, { ... })
            if X then
              return X(s, ...)
            end
          end
        elseif s.FireServer then
          s.FireServer = function(s, ...)
            x("fire", s, { ... })
            if X then
              return X(s, ...)
            end
          end
        end
        if s.Fired then
          s.Fired = function(s)
            local X = z and z(s)
            if X then
              G(function()
                X:Connect(function(...)
                  x("recv", s, { ... })
                end)
              end)
            end
            return X
          end
        elseif s.OnClientEvent then
          s.OnClientEvent = function(s)
            local X = z and z(s)
            if X then
              G(function()
                X:Connect(function(...)
                  x("recv", s, { ... })
                end)
              end)
            end
            return X
          end
        end
        if s.Invoke then
          s.Invoke = function(s, ...)
            x("invoke", s, { ... })
            if s == "Entity_Invoke" and l then
              local X = table.pack(G(l, s, ...))
              if not X[1] then
                return nil
              end
              return unpack(X, 2, X.n)
            end
            if l then
              return l(s, ...)
            end
          end
        elseif s.InvokeServer then
          s.InvokeServer = function(s, ...)
            x("invoke", s, { ... })
            if s == "Entity_Invoke" and l then
              local X = table.pack(G(l, s, ...))
              if not X[1] then
                return nil
              end
              return unpack(X, 2, X.n)
            end
            if l then
              return l(s, ...)
            end
          end
        end
      end)
    end
  end
  local d = { "fridge"; "refrig"; "storage", "pantry", "cooler"; "freezer", "cabinet" }
  local K = {
    "ingredient",
    "restock";
    "supply",
    "stock",
    "open";
    "close",
    "store",
    "deposit",
    "withdraw";
    "inventory",
    "mode",
    "setting";
    "cycle"
  }
  local function A(s, X)
    local z = s and string.lower(s.ActionText or "") or ""
    local l = s and string.lower(s.ObjectText or "") or ""
    local x = s and (s.Parent and string.lower(s.Parent["Name"] or "")) or ""
    local w = s and (s.Parent and (s.Parent["Parent"] and string.lower(s.Parent["Parent"].Name or ""))) or ""
    local M = string.lower(X and tostring(X.DirId) or "")
    if M:match("sunken crate") then
      return false
    end
    for s, X in ipairs(d) do
      if z:find(X) or l:find(X) or x:find(X) or w:find(X) or M:find(X) then
        return true
      end
    end
    for s, X in ipairs(K) do
      if z:find(X) or l:find(X) or x:find(X) then
        return true
      end
    end
    return false
  end
  local function u(s, X)
    X = X or (s * .25)
    local z = math.max(0, s - X)
    local l = s + X
    local x = z + (O() * ((l - z)))
    return b(x)
  end
  local C = {}
  local c = 0
  local function sE(s, X)
    if not s then
      return false
    end
    local z = h()
    local l = s.Id or (((s.Name or s.Class or "Entity")) .. tostring(s))
    local x = (X == "fill" or X == "take")
    local w = x and .2 or 2
    if C[l] and z - C[l] < w then
      return false
    end
    c = c + 1
    if c % 20 == 0 then
      for s, X in pairs(C) do
        if z - X > 10 then
          C[s] = nil
        end
      end
    end
    local M = s.GetModel and s:GetModel()
    if M then
      local w = nil
      local D = nil
      for z, M in ipairs(M:GetDescendants()) do
        if M:IsA("ProximityPrompt") and M.Enabled then
          if not A(M, s) then
            local s = string.lower(M.ActionText or "")
            if X and ((string.find(s, string.lower(X)) or s == string.lower(X))) then
              w = M
              break
            elseif not X then
              if s ~= "switch mode" and (s ~= "set mode" and s ~= "view") then
                D = M
                if s:find("fill") or s:find("take") then
                  x = true
                end
              end
            end
          end
        elseif M:IsA("ClickDetector") then
          u(.1, .05)
          G(function()
            fireclickdetector(M)
          end)
          C[l] = h()
          return true
        end
      end
      local N = w or D
      if N then
        local s = x and .2 or 2
        if C[l] and z - C[l] < s then
          return false
        end
        C[l] = z
        local X = N.MaxActivationDistance
        local w = N.RequiresLineOfSight
        N.MaxActivationDistance = 9999
        N.RequiresLineOfSight = false
        u(.1, .05)
        G(function()
          fireproximityprompt(N)
        end)
        N.MaxActivationDistance = X
        N.RequiresLineOfSight = w
        return true
      end
    end
    return false
  end
  G(function()
    local s = {}
    local X = gethui and gethui()
    if X then
      table.insert(s, X)
    end
    table.insert(s, game:GetService("CoreGui"))
    local z = {}
    for s, X in ipairs(s) do
      for s, X in ipairs(X:GetChildren()) do
        if X:IsA("ScreenGui") and X.Name ~= "SpectreWare_MiniIcon" then
          local s = false
          for X, z in ipairs(X:GetDescendants()) do
            if ((z:IsA("TextLabel") or z:IsA("TextButton"))) and (z.Text and (tostring(z.Text)):find("SpectreWare")) then
              s = true
              break
            end
          end
          if s then
            z[#z + 1] = X
          end
        end
      end
    end
    for s, X in ipairs(z) do
      X:Destroy()
    end
  end)
  G(function()
    if getgenv().SellOres_MiniIcon then
      getgenv().SellOres_MiniIcon:Destroy();
      getgenv().SellOres_MiniIcon = nil
    end
  end)
  local function rarBuildSpectre(Lib)
    local function fixIdentity()
      local setid = setthreadidentity or set_thread_identity or setthreadcontext or set_identity or (syn and syn.set_thread_identity)
      if setid then
        pcall(setid, 8)
      end
    end
    local F = { Options = {}, Version = "SpectreUI " .. tostring(Lib.Version) }
    local TabApi = {}
    local TabMT = {}
    local HandleApi = {}
    local HandleMT = {}
    local function dispatch(h, ...)
      if not h then
        return
      end
      if h._cb then
        local ok, err = pcall(h._cb, ...)
        if not ok then
          warn("[SpectreWare] callback error: " .. tostring(err))
        end
      end
      for _, fn in ipairs(h._changed) do
        local ok, err = pcall(fn, ...)
        if not ok then
          warn("[SpectreWare] OnChanged error: " .. tostring(err))
        end
      end
    end
    function TabApi._section(self)
      fixIdentity()
      local sec = rawget(self, "_sec")
      if sec then
        return sec
      end
      local tab = rawget(self, "_tab")
      local ok, created = pcall(function()
        return tab:CreateSection({ Name = tostring(rawget(self, "_title") or tab.Name), Collapsible = false })
      end)
      if not ok or not created then
        fixIdentity()
        created = tab:CreateSection({ Name = tostring(rawget(self, "_title") or tab.Name), Collapsible = false })
      end
      sec = created
      sec._n = 0
      for i, s in ipairs(tab.Sections) do
        if s == sec then
          table.remove(tab.Sections, i)
          break
        end
      end
      table.insert(tab.Sections, 1, sec)
      pcall(function() tab:_QueueRelayout() end)
      rawset(self, "_sec", sec)
      return sec
    end
    TabMT.__index = function(self, key)
      local m = TabApi[key]
      if m ~= nil then
        return m
      end
      if key == "Container" then
        return TabApi._section(self).Body
      end
      return nil
    end
    function TabApi:_AddGroup(title, desc)
      fixIdentity()
      local tab = rawget(self, "_tab")
      local ok, sec = pcall(function()
        return tab:CreateSection({ Name = tostring(title), Collapsed = true })
      end)
      if not ok or not sec then
        fixIdentity()
        sec = tab:CreateSection({ Name = tostring(title), Collapsed = true })
      end
      sec._n = 0
      if desc and desc ~= "" then
        local T = sec.Window.Theme
        local lbl = Instance.new("TextLabel")
        lbl.Name = "GroupDesc"
        lbl.LayoutOrder = 0
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, 0, 0, 0)
        lbl.AutomaticSize = Enum.AutomaticSize.Y
        lbl.Text = tostring(desc)
        lbl.Font = T.Font
        lbl.TextSize = 12
        lbl.TextColor3 = T.SubText
        lbl.TextWrapped = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        pcall(function() lbl.Parent = sec.Body end)
      end
      local pseudo = setmetatable({ _tab = tab, _sec = sec, _title = title, Type = "Tab" }, TabMT)
      return pseudo, sec.Frame
    end
    local function place(sec, obj, desc)
      fixIdentity()
      local T = sec.Window.Theme
      local frame = obj.Frame
      sec._n = (sec._n or 0) + 1
      local wrap = Instance.new("Frame")
      wrap.Name = "RARRow"
      wrap.BackgroundTransparency = 1
      wrap.BorderSizePixel = 0
      wrap.Size = UDim2.new(1, 0, 0, 0)
      wrap.AutomaticSize = Enum.AutomaticSize.Y
      wrap.LayoutOrder = 10 + sec._n
      local ll = Instance.new("UIListLayout")
      ll.SortOrder = Enum.SortOrder.LayoutOrder
      ll.Padding = UDim.new(0, 3)
      ll.Parent = wrap
      local d = Instance.new("TextLabel")
      d.Name = "Desc"
      d.LayoutOrder = 2
      d.BackgroundTransparency = 1
      d.Size = UDim2.new(1, 0, 0, 0)
      d.AutomaticSize = Enum.AutomaticSize.Y
      d.Font = T.Font
      d.TextSize = 12
      d.TextColor3 = T.SubText
      d.TextWrapped = true
      d.TextXAlignment = Enum.TextXAlignment.Left
      d.Text = desc and tostring(desc) or ""
      d.Visible = d.Text ~= ""
      local pad = Instance.new("UIPadding")
      pad.PaddingLeft = UDim.new(0, 8)
      pad.PaddingRight = UDim.new(0, 8)
      pad.Parent = d
      d.Parent = wrap
      local ok = pcall(function() wrap.Parent = sec.Body end)
      if not ok then
        fixIdentity()
        pcall(function() wrap.Parent = sec.Body end)
      end
      frame.LayoutOrder = 1
      pcall(function() frame.Parent = wrap end)
      for _, c in ipairs(sec.Controls) do
        if c.Frame == frame then
          c.Frame = wrap
          break
        end
      end
      return wrap, d
    end
    local function makeHandle(kind, key, sec, wrap, desc, cb, get, set)
      local h = setmetatable({
        Type = kind,
        _key = key,
        _sec = sec,
        _wrap = wrap,
        _desc = desc,
        _cb = cb,
        _changed = {},
        _get = get,
        _set = set,
      }, HandleMT)
      if key then
        F.Options[key] = h
      end
      return h
    end
    HandleMT.__index = function(h, key)
      if key == "Value" then
        return rawget(h, "_get")()
      end
      return HandleApi[key]
    end
    HandleMT.__newindex = function(h, key, v)
      if key == "Value" then
        rawget(h, "_set")(v)
      else
        rawset(h, key, v)
      end
    end
    function HandleApi:OnChanged(fn)
      if type(fn) == "function" then
        table.insert(self._changed, fn)
      end
    end
    function HandleApi:SetValue(v)
      self._set(v)
    end
    function HandleApi:GetValue()
      return self._get()
    end
    function HandleApi:SetDesc(text)
      local d = self._desc
      if d and d.Parent then
        text = text == nil and "" or tostring(text)
        if d.Text ~= text then
          d.Text = text
        end
        d.Visible = text ~= ""
      elseif self._setBody then
        self._setBody(text)
      end
    end
    function HandleApi:SetTitle(text)
      if self._setTitle then
        self._setTitle(tostring(text))
      end
    end
    function HandleApi:SetValues(list)
      if self._setValues then
        self._setValues(list)
      end
    end
    function HandleApi:Destroy()
      local w = rawget(self, "_wrap")
      local sec = rawget(self, "_sec")
      if sec and w then
        for i, c in ipairs(sec.Controls) do
          if c.Frame == w then
            table.remove(sec.Controls, i)
            break
          end
        end
      end
      if w then
        pcall(function()
          w:Destroy()
        end)
      end
      local key = rawget(self, "_key")
      if key and F.Options[key] == self then
        F.Options[key] = nil
      end
    end
    function TabApi:AddToggle(key, c)
      fixIdentity()
      c = c or {}
      local sec = TabApi._section(self)
      local h
      fixIdentity()
      local ok, obj = pcall(function()
        return sec:CreateToggle({
          Name = tostring(c.Title or key),
          Default = c.Default and true or false,
          Callback = function(v)
            dispatch(h, v)
          end,
        })
      end)
      if not ok or not obj then
        fixIdentity()
        obj = sec:CreateToggle({
          Name = tostring(c.Title or key),
          Default = c.Default and true or false,
          Callback = function(v)
            dispatch(h, v)
          end,
        })
      end
      local wrap, d = place(sec, obj, c.Description)
      h = makeHandle("Toggle", key, sec, wrap, d, c.Callback, function()
        return obj:Get()
      end, function(v)
        obj:Set(v and true or false)
      end)
      return h
    end
    function TabApi:AddButton(c)
      fixIdentity()
      c = c or {}
      local sec = TabApi._section(self)
      fixIdentity()
      local ok, obj = pcall(function()
        return sec:CreateButton({
          Name = tostring(c.Title or "Button"),
          Spin = false,
          Callback = function()
            if c.Callback then
              local ok, err = pcall(c.Callback)
              if not ok then
                warn("[SpectreWare] button error: " .. tostring(err))
              end
            end
          end,
        })
      end)
      if not ok or not obj then
        fixIdentity()
        obj = sec:CreateButton({
          Name = tostring(c.Title or "Button"),
          Spin = false,
          Callback = function()
            if c.Callback then
              local ok, err = pcall(c.Callback)
              if not ok then
                warn("[SpectreWare] button error: " .. tostring(err))
              end
            end
          end,
        })
      end
      local wrap, d = place(sec, obj, c.Description)
      local h = makeHandle("Button", nil, sec, wrap, d, nil, function()
        return nil
      end, function()
      end)
      h._setTitle = function(t)
        obj:SetText(t)
      end
      return h
    end
    function TabApi:AddParagraph(c)
      fixIdentity()
      c = c or {}
      local sec = TabApi._section(self)
      fixIdentity()
      local ok, obj = pcall(function()
        return sec:CreateParagraph({ Title = tostring(c.Title or ""), Content = tostring(c.Content or "") })
      end)
      if not ok or not obj then
        fixIdentity()
        obj = sec:CreateParagraph({ Title = tostring(c.Title or ""), Content = tostring(c.Content or "") })
      end
      sec._n = (sec._n or 0) + 1
      obj.Frame.LayoutOrder = 10 + sec._n
      local h = makeHandle("Paragraph", nil, sec, obj.Frame, nil, nil, function()
        return nil
      end, function()
      end)
      h._setBody = function(t)
        obj:Set(nil, t)
      end
      h._setTitle = function(t)
        obj:Set(t, nil)
      end
      return h
    end
    function TabApi:AddDropdown(key, c)
      c = c or {}
      local sec = TabApi._section(self)
      local multi = c.Multi and true or false
      local values = {}
      for i, v in ipairs(c.Values or {}) do
        values[i] = tostring(v)
      end
      local function names(v)
        local out = {}
        if type(v) == "table" then
          for k, x in pairs(v) do
            if x == true and type(k) == "string" then
              out[#out + 1] = k
            elseif type(x) == "number" and values[x] then
              out[#out + 1] = values[x]
            elseif type(x) == "string" then
              out[#out + 1] = x
            end
          end
        end
        return out
      end
      local function toFluent(v)
        if multi then
          local m = {}
          for _, n in ipairs(v or {}) do
            m[n] = true
          end
          return m
        end
        return v
      end
      local def = c.Default
      if multi then
        def = names(def)
      elseif type(def) == "number" then
        def = values[def]
      end
      local h
      fixIdentity()
      local ok, obj = pcall(function()
        return sec:CreateDropdown({
          Name = tostring(c.Title or key),
          Options = values,
          Multi = multi,
          Default = def,
          Callback = function(v)
            dispatch(h, toFluent(v))
          end,
        })
      end)
      if not ok or not obj then
        fixIdentity()
        obj = sec:CreateDropdown({
          Name = tostring(c.Title or key),
          Options = values,
          Multi = multi,
          Default = def,
          Callback = function(v)
            dispatch(h, toFluent(v))
          end,
        })
      end
      local wrap, d = place(sec, obj, c.Description)
      h = makeHandle("Dropdown", key, sec, wrap, d, c.Callback, function()
        return toFluent(obj:Get())
      end, function(v)
        if multi then
          obj:Set(names(v))
        else
          obj:Set(v)
        end
      end)
      h.Multi = multi
      h._setValues = function(list)
        local nv = {}
        for i, v in ipairs(list or {}) do
          nv[i] = tostring(v)
        end
        values = nv
        h.Values = nv
        obj:Refresh(nv, true)
      end
      h.Values = values
      return h
    end
    function TabApi:AddInput(key, c)
      c = c or {}
      local sec = TabApi._section(self)
      local numeric = c.Numeric and true or false
      local last = c.Default ~= nil and tostring(c.Default) or ""
      local h
      local obj
      fixIdentity()
      local ok, created = pcall(function()
        return sec:CreateTextbox({
          Name = tostring(c.Title or key),
          Default = last,
          Placeholder = c.Placeholder and tostring(c.Placeholder) or "",
          Live = not c.Finished,
          Callback = function(v)
            v = tostring(v == nil and "" or v)
            if numeric and v ~= "" and tonumber(v) == nil then
              obj:Set(last, true)
              return
            end
            last = v
            dispatch(h, v)
          end,
        })
      end)
      if not ok or not created then
        fixIdentity()
        created = sec:CreateTextbox({
          Name = tostring(c.Title or key),
          Default = last,
          Placeholder = c.Placeholder and tostring(c.Placeholder) or "",
          Live = not c.Finished,
          Callback = function(v)
            v = tostring(v == nil and "" or v)
            if numeric and v ~= "" and tonumber(v) == nil then
              obj:Set(last, true)
              return
            end
            last = v
            dispatch(h, v)
          end,
        })
      end
      obj = created
      local wrap, d = place(sec, obj, c.Description)
      h = makeHandle("Input", key, sec, wrap, d, c.Callback, function()
        return tostring(obj:Get() or "")
      end, function(v)
        obj:Set(tostring(v == nil and "" or v))
      end)
      return h
    end
    local W = {}
    W.__index = W
    function W:AddTab(c)
      fixIdentity()
      c = c or {}
      local st = self._win:CreateTab({ Name = tostring(c.Title or "Tab"), Icon = c.Icon })
      local t = setmetatable({ _tab = st, _title = c.Title, Type = "Tab" }, TabMT)
      table.insert(self._tabs, t)
      return t
    end
    function W:SelectTab(x)
      local t = type(x) == "number" and self._tabs[x] or x
      local st = type(t) == "table" and rawget(t, "_tab")
      if st then
        self._win:SelectTab(st)
      end
    end
    function W:Minimize()
      self._win:SetVisible(false)
    end
    function W:Resize(w, h)
      self._win:SetSize(w, h)
    end
    function W:AddThemeTab()
      fixIdentity()
      local ok, err = pcall(function()
        self._win:CreateThemeTab({ Name = "Theme", Icon = "lucide:palette" })
      end)
      if not ok then
        warn("[SpectreWare] theme tab: " .. tostring(err))
      end
    end
    function W:Destroy()
      self._win:Destroy()
    end
    function F:CreateWindow(c)
      c = c or {}
      local env = getgenv and getgenv() or _G
      local old = env.RAR_SpectreWindow
      if old then
        pcall(function()
          old:Destroy()
        end)
        env.RAR_SpectreWindow = nil
      end
      local sub = tostring(c.SubTitle or ""):gsub("^%s*|%s*", "")
      local title = tostring(c.Title or "SpectreWare")
      if sub ~= "" then
        title = title .. " | " .. sub
      end
      fixIdentity()
      local logo = c.Logo or 84699118856259
      local win = Lib:CreateWindow({
        Title = title,
        Logo = logo,
        Width = 780,
        Height = 500,
        MinWidth = 380,
        MinHeight = 240,
        Theme = "Violet",
        StagedLoad = false,
        AutoCheck = { Enabled = true, Delay = 4.0 },
        Splash = { Title = "SpectreWare", Subtitle = "RUN A RESTAURANT", Duration = 3, Async = true, Logo = logo },
      })
      env.RAR_SpectreWindow = win
      local w = setmetatable({ _win = win, _tabs = {}, Root = win.Main }, W)
      F._win = win
      F.Window = w
      pcall(function()
        Lib:PreloadIcons()
      end)
      return w
    end
    function F:Notify(c)
      c = c or {}
      local body = tostring(c.Content or "")
      if c.SubContent and c.SubContent ~= "" then
        body = body .. "\n" .. tostring(c.SubContent)
      end
      local win = F._win
      if win then
        pcall(function()
          win:Notify({ Title = tostring(c.Title or ""), Content = body, Duration = c.Duration })
        end)
      end
    end
    function F:Destroy()
      if F._win then
        pcall(function()
          F._win:Destroy()
        end)
      end
    end
    return F
  end
  task.spawn(function()
    local function fixIdentity()
      local setid = setthreadidentity or set_thread_identity or setthreadcontext or set_identity or (syn and syn.set_thread_identity)
      if setid then
        pcall(setid, 8)
      end
    end
    fixIdentity()
    local s
    local function loadSpectre()
      local url = "https://raw.githubusercontent.com/SpectreWareZ/SpectreWare/refs/heads/main/Tools/Ui/SpectreUI.lua"
      local cache = "spectreware_ui.lua"
      local code
      local okGet, body = pcall(function()
        return game:HttpGet(url)
      end)
      if okGet and type(body) == "string" and #body > 1000 then
        code = body
      elseif type(isfile) == "function" and type(readfile) == "function" then
        if isfile(cache) then
          code = readfile(cache)
        elseif isfile("SpectreUI.lua") then
          code = readfile("SpectreUI.lua")
        end
      end
      if type(code) ~= "string" or #code < 1000 then
        error("SpectreUI source not reachable")
      end
      code = code:gsub(
        "if parent then o%.Parent = parent end",
        "if parent then local ok = pcall(function() o.Parent = parent end) if not ok then local setid = setthreadidentity or set_thread_identity or setthreadcontext or set_identity or (syn and syn.set_thread_identity) if setid then pcall(setid, 8) end pcall(function() o.Parent = parent end) end end"
      )
      return (loadstring(code))()
    end
    local okLib, Lib = G(loadSpectre)
    if not okLib or type(Lib) ~= "table" then
      error("[SpectreWare] Failed to load SpectreUI library: " .. tostring(Lib))
    end
    s = rarBuildSpectre(Lib)
    task.wait()
    G(function()
      for s, X in ipairs((game:GetService("Workspace")):GetDescendants()) do
        if X:IsA("BasePart") and (X.Name == "Body" and (X.Material == Enum.Material.Glass and (X.Anchored and (not X.CanCollide and (X.Size["X"] == 1 and (X.Size["Y"] == 1 and (X.Size["Z"] <= .01 and X:FindFirstChildOfClass("SpecialMesh")))))))) then
          G(function()
            X:Destroy()
          end)
        end
      end
    end)
    local t = s:CreateWindow({
      Title = "SpectreWare";
      SubTitle = "| Run A Restaurant";
      Logo = 84699118856259;
      TabWidth = 160,
      Size = UDim2.fromOffset(560, 360),
      Acrylic = false;
      Theme = "Darker";
      MinimizeKey = nil
    });
    getgenv().rarWindowFrame = t
    task.wait()
    task.delay(1, function()
      G(function()
        local s = t.Root
        if s then
          s.Visible = true
          local X = s.Parent
          if X then
            X.Enabled = true
          end
          return
        end
        local X = gethui and gethui()
        if X then
          for s, X in ipairs(X:GetChildren()) do
            if X:IsA("ScreenGui") then
              for s, z in ipairs(X:GetChildren()) do
                if z:IsA("Frame") and z.AbsoluteSize["X"] > 200 then
                  X.Enabled = true
                  z.Visible = true
                  return
                end
              end
            end
          end
        end
      end)
    end)
    local r = {
      Main = t:AddTab({ Title = "Main", Icon = "house" }),
      Serve = t:AddTab({ Title = "Serve", Icon = "utensils" });
      Train = t:AddTab({ Title = "Train", Icon = "graduation-cap" });
      Quests = t:AddTab({ Title = "Quests", Icon = "scroll" });
      Ranching = t:AddTab({ Title = "Ranching"; Icon = "lasso" }),
      Shop = t:AddTab({ Title = "Shop"; Icon = "shopping-cart" }),
      Fishing = t:AddTab({ Title = "Fishing"; Icon = "anchor" }),
      PetShop = t:AddTab({ Title = "Pet Shop", Icon = "bone" }),
      Gifting = t:AddTab({ Title = "Gifting"; Icon = "gift" });
      Config = t:AddTab({ Title = "Config"; Icon = "settings" }),
      Misc = t:AddTab({ Title = "Misc"; Icon = "box" }),
      Webhook = t:AddTab({ Title = "Webhook", Icon = "link" })
    }
    local v = r.Main
    local b = r.Serve
    local g = r.Quests
    local j = r.Ranching
    local O = r.Shop
    local e = r.Fishing
    local L = r.PetShop
    local m = r.Gifting
    local k = r.Config
    local Z = r.Misc
    local U = r.Webhook
    local f = r.Train
    t:AddThemeTab()
    local function F()
      local setid = setthreadidentity or set_thread_identity or setthreadcontext or set_identity or (syn and syn.set_thread_identity)
      if setid then
        pcall(setid, 8)
      end
    end
    F()
    local function a(s)
      task.spawn(function()
        G(s)
      end)
    end
    local function p(s, X)
      if not s then
        return
      end
      a(function()
        F()
        G(function()
          s:SetValues(X)
        end)
      end)
    end
    local E = {
      bg = Color3.fromRGB(15, 18, 24),
      panel = Color3.fromRGB(22, 27, 36);
      border = Color3.fromRGB(38, 46, 60);
      text = Color3.fromRGB(240, 243, 248);
      dim = Color3.fromRGB(140, 150, 168),
      blue = Color3.fromRGB(56, 130, 246),
      green = Color3.fromRGB(44, 198, 105),
      red = Color3.fromRGB(235, 75, 75),
      gold = Color3.fromRGB(240, 185, 55);
      cyan = Color3.fromRGB(60, 195, 205)
    }
    local T = {}
    local d = {};
    getgenv().RARToggleBtns = T
    local K = {}
    local C = {}
    local c = {}
    local XE = {}
    local function lE(s, X, z)
      G(function()
        local l = XE[s]
        if not l or #l == 0 or not l[1].Parent then
          l = {}
          local z = getgenv().rarWindowFrame
          if z and z.Root then
            for s, z in ipairs(z.Root:GetDescendants()) do
              if z:IsA("TextLabel") and ((z.Text == X or z.ContentText == X or z.Name == "Title")) then
                table.insert(l, z)
              end
            end
          end
          if #l > 0 then
            XE[s] = l
          end
        end
        for s, l in ipairs(l) do
          if z then
            l.RichText = true
            l.Text = "<font color=\"#3882F6\">" .. (X .. "</font>")
          else
            l.RichText = false
            l.Text = X
            l.TextColor3 = Color3.fromRGB(240, 243, 248)
          end
        end
      end)
    end
    local function xE(s, X, z)
      if type(s) == "table" and s._key then
        local z = T[s._key]
        if z then
          local l = s._origDesc or ""
          if X and X ~= "" then
            if l == "" then
              l = "Status: " .. X
            else
              l = l .. ("\nStatus: " .. X)
            end
          end
          local x = s._key
          local w = h()
          if C[x] == l and (w - ((c[x] or 0))) < .3 then
            return
          end
          C[x] = l
          c[x] = w
          G(function()
            z:SetDesc(l)
          end)
          lE(x, s.title, z.Value)
        end
        return
      end
      if typeof(s) == "Instance" and s:IsA("TextLabel") then
        s.Text = X or ""
        if z then
          s.TextColor3 = z
        end
      end
    end
    local function wE(s)
      if r[s] then
        t:SelectTab(r[s])
      else
        t:SelectTab(1)
      end
    end
    local function ME(s, X, z)
      local l = z or r.Main
      local x = { tab = l, title = s, _el = nil }
      return nil, { title = s, desc = "", tab = l; _status = x }, x
    end
    local function DE(s, X)
      local z = { title = s; tab = X or r.Main }
      z.MouseButton1Click = {
        Connect = function(X, l)
          z.tab:AddButton({ Title = s; Description = "", Icon = "mouse-pointer-click"; Callback = l })
        end
      }
      return z
    end
    local function NE(s, X, z)
      local l = z or r.Main
      return l:_AddGroup(s, X)
    end
    local function HE(s, X)
      X = X or {}
      local z, l = {}, {}
      local x = {}
      local w = X.OnChanged
      local M = Color3.fromRGB(0, 170, 255)
      local D = Font.new("rbxasset://fonts/families/GothamSSm.json")
      local N = Instance.new("Frame")
      N.Name = "SearchList_" .. ((X.Name or "X"))
      N.Size = UDim2.new(1, 0, 0, 0)
      N.AutomaticSize = Enum.AutomaticSize.Y
      N.BackgroundTransparency = 1
      N.LayoutOrder = X.LayoutOrder or 1
      N.Parent = s
      do
        local s = Instance.new("UIListLayout")
        s.SortOrder = Enum.SortOrder.LayoutOrder
        s.Padding = UDim.new(0, 4)
        s.Parent = N
      end
      if X.Title then
        local s = Instance.new("TextLabel")
        s.Name = "ListTitle"
        s.Text = X.Title
        s.TextSize = 12
        s.FontFace = D
        s.TextColor3 = Color3.fromRGB(170, 170, 170)
        s.TextXAlignment = Enum.TextXAlignment.Left
        s.BackgroundTransparency = 1
        s.LayoutOrder = 1
        s.Parent = N
      end
      local H = false
      local t = Instance.new("TextButton")
      t.Name = "SearchBox"
      t.Size = UDim2.new(1, 0, 0, 34)
      t.LayoutOrder = 2
      t.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
      t.BackgroundTransparency = .82
      t.Text = ""
      t.AutoButtonColor = false
      t.Parent = N
      do
        local s = Instance.new("UICorner")
        s.CornerRadius = UDim.new(0, 4)
        s.Parent = t
      end
      local r = X.SearchPlaceholder or "Search items..."
      local v = Instance.new("TextBox")
      v.Size = UDim2.new(1, -56, 1, -8)
      v.Position = UDim2.fromOffset(10, 4)
      v.BackgroundTransparency = 1
      v.Text = ""
      v.PlaceholderText = "🔍  " .. r
      v.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
      v.TextColor3 = Color3.fromRGB(240, 240, 240)
      v.TextSize = 13
      v.FontFace = D
      v.TextXAlignment = Enum.TextXAlignment.Left
      v.ClearTextOnFocus = false
      v.Parent = t
      local b = Instance.new("TextButton")
      b.Name = "ChevronBtn"
      b.Size = UDim2.new(0, 36, 1, 0)
      b.AnchorPoint = Vector2.new(1, 0)
      b.Position = UDim2.new(1, 0, 0, 0)
      b.BackgroundTransparency = 1
      b.Text = ""
      b.AutoButtonColor = false
      b.Parent = t
      local g = Instance.new("ImageLabel")
      g.Name = "Chevron"
      g.Image = "rbxassetid://10709790948"
      g.Size = UDim2.fromOffset(20, 20)
      g.AnchorPoint = Vector2.new(.5, .5)
      g.Position = UDim2.new(.5, 0, .5, 0)
      g.BackgroundTransparency = 1
      g.Parent = b
      local j = Instance.new("Frame")
      j.Name = "ResultsPanel"
      j.Size = UDim2.new(1, 0, 0, X.Height or 150)
      j.LayoutOrder = 3
      j.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
      j.BackgroundTransparency = .9
      j.Visible = false
      j.Parent = N
      do
        local s = Instance.new("UICorner")
        s.CornerRadius = UDim.new(0, 4)
        s.Parent = j
      end
      local O = Instance.new("ScrollingFrame")
      O.Size = UDim2.new(1, 0, 1, 0)
      O.BackgroundTransparency = 1
      O.BorderSizePixel = 0
      O.CanvasSize = UDim2.new(0, 0, 0, 0)
      O.AutomaticCanvasSize = Enum.AutomaticSize.Y
      O.ScrollBarThickness = 3
      O.ScrollBarImageTransparency = .4
      O.Parent = j
      do
        local s = Instance.new("UIPadding")
        s.PaddingTop = UDim.new(0, 4)
        s.PaddingBottom = UDim.new(0, 4)
        s.PaddingLeft = UDim.new(0, 4)
        s.PaddingRight = UDim.new(0, 6)
        s.Parent = O
        local X = Instance.new("UIListLayout")
        X.SortOrder = Enum.SortOrder.LayoutOrder
        X.Padding = UDim.new(0, 2)
        X.Parent = O
      end
      local e = Instance.new("TextLabel")
      e.Text = "No matches"
      e.TextSize = 12
      e.FontFace = D
      e.TextColor3 = Color3.fromRGB(150, 150, 150)
      e.BackgroundTransparency = 1
      e.Visible = false
      e.Size = UDim2.new(1, 0, 0, 28)
      e.Parent = O
      local L
      local function h(s, X)
        local z = Instance.new("TextButton")
        z.Name = "Row_" .. s:gsub("[^%w_]", "_")
        z.Size = UDim2.new(1, 0, 0, 30)
        z.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        z.BackgroundTransparency = 1
        z.Text = ""
        z.AutoButtonColor = false
        z.LayoutOrder = X
        z.Parent = O
        do
          local s = Instance.new("UICorner")
          s.CornerRadius = UDim.new(0, 4)
          s.Parent = z
        end
        local l = Instance.new("Frame")
        l.Name = "Checkbox"
        l.Size = UDim2.fromOffset(16, 16)
        l.AnchorPoint = Vector2.new(0, .5)
        l.Position = UDim2.new(0, 10, .5, 0)
        l.BackgroundColor3 = M
        l.BackgroundTransparency = x[s] and 0 or 1
        l.Parent = z
        local N = Instance.new("UICorner")
        N.CornerRadius = UDim.new(0, 3)
        N.Parent = l
        local H = Instance.new("UIStroke")
        H.Color = x[s] and M or Color3.fromRGB(160, 160, 160)
        H.Transparency = .3
        H.Parent = l
        local t = Instance.new("ImageLabel")
        t.Name = "CheckIcon"
        t.Image = "rbxassetid://10747384333"
        t.Size = UDim2.fromOffset(12, 12)
        t.AnchorPoint = Vector2.new(.5, .5)
        t.Position = UDim2.new(.5, 0, .5, 0)
        t.BackgroundTransparency = 1
        t.ImageColor3 = Color3.fromRGB(255, 255, 255)
        t.Visible = x[s] and true or false
        t.Parent = l
        local r = Instance.new("TextLabel")
        r.Text = s
        r.TextSize = 13
        r.FontFace = D
        r.TextColor3 = Color3.fromRGB(240, 240, 240)
        r.TextXAlignment = Enum.TextXAlignment.Left
        r.TextTruncate = Enum.TextTruncate.AtEnd
        r.Size = UDim2.new(1, -44, 1, 0)
        r.Position = UDim2.new(0, 34, 0, 0)
        r.BackgroundTransparency = 1
        r.Parent = z
        z.MouseEnter:Connect(function()
          z.BackgroundTransparency = .92
        end)
        z.MouseLeave:Connect(function()
          z.BackgroundTransparency = 1
        end)
        z.MouseButton1Click:Connect(function()
          x[s] = not x[s] or nil
          if x[s] then
            x[s] = true
          end
          l.BackgroundTransparency = x[s] and 0 or 1
          H.Color = x[s] and M or Color3.fromRGB(160, 160, 160)
          t.Visible = x[s] and true or false
          if L then
            L()
          end
          if w then
            local s = {}
            for X, z in pairs(x) do
              if z then
                s[X] = true
              end
            end
            w(s)
          end
        end)
      end
      local function i()
        for s, X in ipairs(O:GetChildren()) do
          if X:IsA("TextButton") then
            X:Destroy()
          end
        end
        e.Visible = (#l == 0)
        for s, X in ipairs(l) do
          h(X, s)
        end
      end
      local function m(s)
        s = string.lower(s or "")
        l = {}
        for X, z in ipairs(z) do
          if s == "" or string.find(string.lower(z), s, 1, true) then
            l[#l + 1] = z
          end
        end
        i()
      end;
      (v:GetPropertyChangedSignal("Text")):Connect(function()
        m(v.Text)
      end)
      function L()
        local s = 0
        for X in pairs(x) do
          if x[X] then
            s = s + 1
          end
        end
        if s > 0 then
          v.PlaceholderText = "🔍  " .. (r .. (" (" .. (s .. " selected)")))
        else
          v.PlaceholderText = "🔍  " .. r
        end
      end
      local Q = {}
      local function R(s)
        H = s
        j.Visible = H
        g.Rotation = H and 180 or 0
        if not H and v.Text ~= "" then
          v.Text = ""
        end
        if s and X.OnOpen then
          local s = X.OnOpen
          task.spawn(function()
            G(s, Q)
          end)
        end
      end
      t.MouseButton1Click:Connect(function()
        if not H then
          R(true)
        end
      end)
      b.MouseButton1Click:Connect(function()
        R(not H)
      end)
      v.Focused:Connect(function()
        if not H then
          R(true)
        end
      end)
      R(false)
      function Q.SetValues(s)
        z = {}
        for s, X in ipairs(s or {}) do
          z[#z + 1] = tostring(X)
        end
        m(v.Text)
      end
      function Q.GetValues()
        local s = {}
        table.move(z, 1, #z, 1, s)
        return s
      end
      function Q.SetSelection(s)
        x = {}
        for s, X in pairs(s or {}) do
          if X then
            x[tostring(s)] = true
          end
        end
        i()
        L()
      end
      function Q.GetSelection()
        return x
      end
      return Q
    end
    local function tE(s, X)
      local z, l = {}, {}
      local function x(s)
        s = tostring(s)
        if s ~= "" and not z[s] then
          z[s] = true
          l[#l + 1] = s
        end
      end
      for s, X in ipairs(s.GetValues()) do
        x(X)
      end
      for s, X in ipairs(X or {}) do
        x(X)
      end
      table.sort(l)
      s.SetValues(l)
    end
    local function rE(s, X)
      for s, z in ipairs(s:GetChildren()) do
        if z:IsA("GuiObject") then
          local s = nil
          for z, l in ipairs(z:GetDescendants()) do
            if l:IsA("TextLabel") and X[l.Text] then
              s = l.Text
              break
            end
          end
          if s and X[s] then
            z.LayoutOrder = X[s]
          end
        end
      end
    end
    local function vE(s)
      if type(s) ~= "table" then
        return pairs({})
      end
      local X, z = G(pairs, s)
      if X then
        return z, s, nil
      end
      return next, s, nil
    end
    local bE = {
      bm = false;
      fish = false,
      wp = false;
      crop = false;
      webhookCrate = false;
      cashier = false,
      tipJars = false,
      evPiano = false;
      evDrum = false,
      farFish = false,
      farWp = false,
      processFish = false,
      trainStaff = false;
      moreFps = false;
      wishingWell = false;
      autoEquipPet = false;
      autoDailyQuest = false,
      autoTacoQuest = false,
      autoRodash = false;
      autoPirateQuest = false,
      autoPirateChest = false;
      cola = false;
      procStation = false,
      autoGlobalQuest = false,
      autoScavHunt = false;
      autoOrgan = false;
      autoRelic = false,
      autoKraken = false,
      autoBounty = false,
      autoTrident = false,
      gmSnipe = false;
      gmSnipePing = false
    }
    local GE = { [1] = true; [2] = true; [3] = true }
    local gE = { ["Common Bait"] = true; ["Uncommon Bait"] = true }
    local function jE(s, X, z, l)
      local x = s.tab:AddToggle(X, { Title = s.title, Description = s.desc or ""; Default = false })
      if s._status then
        s._status["_key"] = X
        s._status["_origDesc"] = s.desc or ""
      end
      T[X] = x
      d[X] = function(s)
        if s ~= nil then
          x:SetValue(s)
        else
          x:SetValue(not x.Value)
        end
      end
      x:OnChanged(function()
        local w = x.Value
        bE[X] = w
        lE(X, s.title, w)
        if K[X] then
          G(task.cancel, K[X])
          K[X] = nil
        end
        if w then
          if z then
            K[X] = task.spawn(function()
              local s = xpcall(z, function(s)
                return tostring(s) .. ("\n" .. debug.traceback())
              end)
              if not s then
                K[X] = nil
              end
            end)
          end
        else
          if l then
            K[X] = task.spawn(function()
              local s = xpcall(l, function(s)
                return tostring(s) .. ("\n" .. debug.traceback())
              end)
              if not s then
                K[X] = nil
              end
            end)
          end
        end
      end)
      return x
    end
    local function OE(s)
      if s and bE[s] then
        bE[s] = false
        local X = T[s]
        if X then
          X:SetValue(false)
        end
      end
    end
    local eE = nil
    local LE = nil
    local function hE(s)
      local X = nil
      local z = 999999
      local function l(l)
        if not l:IsA("BasePart") then
          return
        end
        local x = string.lower(l.Name)
        if x:find("collision") or x:find("invisible") or x:find("bounds") then
          return
        end
        l.CanCollide = true
        local w = l.Size
        if w.Y > 5 or w.X < 2 or w.Z < 2 then
          return
        end
        if w.X > 150 or w.Z > 150 then
          return
        end
        if l.Position["Y"] < -25 or l.Position["Y"] > 10 then
          return
        end
        local M = l.CFrame
        local D = M:PointToObjectSpace(s)
        local N = math.clamp(D.X, -w.X / 2, w.X / 2)
        local H = math.clamp(D.Z, -w.Z / 2, w.Z / 2)
        local t = M:PointToWorldSpace(Vector3.new(N, w.Y / 2, H))
        local r = ((t - s)).Magnitude
        if r < z and r < 120 then
          z = r
          X = t
        end
      end
      local x = workspace.__THINGS:FindFirstChild("Restaurants")
      if x then
        for s, X in ipairs(x:GetChildren()) do
          local z = X:FindFirstChild("PrimaryPart")
          if z then
            l(z)
          end
          for s, z in ipairs({ "EntitiesOcclude"; "Entities" }) do
            local x = X:FindFirstChild(z)
            if x then
              for s, X in ipairs(x:GetDescendants()) do
                l(X)
              end
            end
          end
        end
      end
      local w = workspace:FindFirstChild("MAP")
      if w then
        for s, X in ipairs(w:GetDescendants()) do
          l(X)
        end
      end
      local M = workspace.__THINGS:FindFirstChild("DeepFishingLocations")
      if M then
        for s, X in ipairs(M:GetChildren()) do
          l(X)
        end
      end
      if X then
        return X
      end
      return s + Vector3.new(20, 2, 0)
    end
    local function iE(s)
      if LE then
        LE:Destroy()
      end
      LE = Instance.new("Part")
      LE.Name = "RARHelperPlatform"
      LE.Size = Vector3.new(16, 1, 16)
      LE.Position = s - Vector3.new(0, .5, 0)
      LE.Anchored = true
      LE.CanCollide = true
      LE.Transparency = 1
      LE.Parent = workspace
    end
    local function mE()
      if LE then
        LE:Destroy()
        LE = nil
      end
    end
    local function QE()
      local s = i.Character
      local X = s and s:FindFirstChild("HumanoidRootPart")
      if not X or not eE then
        return
      end
      if bE.fish and fishSpotCFrame then
        x(fishSpotCFrame)
      else
        x(eE)
      end
      eE = nil
      mE()
    end
    local RE = nil
    local IE = nil
    farSpotBtn = nil
    local WE
    local SE = 0;
    getgenv().cratesOpenedSession = getgenv().cratesOpenedSession or 0;
    getgenv().webhookUrl = getgenv().webhookUrl or ""
    local function nE(s)
      local X = getgenv().webhookUrl or ""
      if X == "" then
        return
      end
      if not s and not bE.webhookCrate then
        return
      end
      local z = require(Q.Framework["Client"].Saving)
      local l = z.Get() and (z.Get()).Inventory or {}
      local x = l["Sunken Crate"] or 0
      local w = table.concat({
        "**-> Profile :**",
        ("> Username : `%s`"):format(i.Name);
        "",
        "**-> Sunken Crates :**",
        ("> Crates : `%d`"):format(x)
      }, "\n")
      local M = getgenv().webhookThumbUrl or ""
      local D = M ~= "" and { url = M } or nil
      local N = {
        title = "SpectreWare | Run A Restaurant";
        description = w,
        color = 5793266;
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ");
        thumbnail = D
      }
      local t = getgenv().webhookPingId or ""
      local r = ""
      if t ~= "" then
        r = ("<@%s>"):format(t)
      end
      local v = H:JSONEncode({ content = r ~= "" and r or nil; embeds = { N } })
      local b = type(http_request) == "function" and http_request or type(request) == "function" and request or nil
      if b then
        G(b, {
          Url = X,
          Method = "POST",
          Headers = { ["Content-Type"] = "application/json" },
          Body = v
        })
      end
    end
    local function YE(s, X)
      local z = getgenv().webhookUrl or ""
      if z == "" then
        return
      end
      if not s and not bE.webhookCrateOpened then
        return
      end
      local l = table.concat({
        "**-> Profile :**",
        ("> Username : `%s`"):format(i.Name),
        "",
        "**-> Sunken Crate Opened :**",
        ("> Reward : `%s`"):format(X or "Unknown Reward")
      }, "\n")
      local x = getgenv().webhookThumbUrl or ""
      local w = x ~= "" and { url = x } or nil
      local M = {
        title = "SpectreWare | Run A Restaurant",
        description = l,
        color = 5793266,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ");
        thumbnail = w
      }
      local D = getgenv().webhookPingId or ""
      local N = ""
      if D ~= "" then
        N = ("<@%s>"):format(D)
      end
      local t = H:JSONEncode({ content = N ~= "" and N or nil; embeds = { M } })
      local r = type(http_request) == "function" and http_request or type(request) == "function" and request or nil
      if r then
        G(r, {
          Url = z,
          Method = "POST",
          Headers = { ["Content-Type"] = "application/json" };
          Body = t
        })
      end
    end
    local function kE(s)
      local X = getgenv().webhookUrl or ""
      if X == "" then
        return
      end
      if not bE.webhookBoothSale then
        return
      end
      local z = {}
      local l = 0
      for s, X in ipairs(s) do
        z[#z + 1] = ("> Item : `%s`"):format(X.item)
        z[#z + 1] = ("> Quantity : `%d`"):format(X.qty)
        z[#z + 1] = ("> Diamond : `%d`"):format(X.earned)
        l = l + X.earned
      end
      if #s > 1 then
        z[#z + 1] = ("> Total : `$%d`"):format(l)
      end
      local x = {
        title = "SpectreWare | Run A Restaurant";
        description = table.concat(z, "\n"),
        color = 5793266,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
      }
      local w = getgenv().webhookPingId or ""
      local M = w ~= "" and ("<@%s>"):format(w) or ""
      local D = H:JSONEncode({ content = M ~= "" and M or nil, embeds = { x } })
      local N = type(http_request) == "function" and http_request or type(request) == "function" and request or nil
      if N then
        G(N, {
          Url = X;
          Method = "POST";
          Headers = { ["Content-Type"] = "application/json" },
          Body = D
        })
      end
    end
    local function JE()
      local s, X = G(function()
        return Y.GetDay()
      end)
      if s and type(X) == "number" then
        return X
      end
      return os.date("!%Y-%m-%d")
    end
    local function VE()
      local s = getgenv().rarDaily
      local X = JE()
      if type(s) ~= "table" or s.day ~= X or type(s.byRarity) ~= "table" then
        s = {
          day = X,
          cashEarned = 0;
          diamondsEarned = 0,
          customers = 0,
          waits = {};
          earnings = nil;
          bonus = nil,
          byRarity = {},
          byType = {}
        };
        getgenv().rarDaily = s
      end
      return s
    end
    local function BE(s)
      local X = {}
      if s:IsA("TextLabel") then
        X[#X + 1] = s
      end
      for s, z in ipairs(s:GetDescendants()) do
        if z:IsA("TextLabel") then
          X[#X + 1] = z
        end
      end
      for s, X in ipairs(X) do
        local z = tonumber((tostring(X.Text)):match("Day%s+(%d+)"))
        if z then
          return z
        end
      end
      return nil
    end
    local function ZE(s, X)
      local z = false
      local l = X:FindFirstChild("Stats")
      if l then
        for X, l in ipairs(l:GetChildren()) do
          if l.Name == "StatEntry" then
            local X, x
            for s, z in ipairs(l:GetDescendants()) do
              if z:IsA("TextLabel") then
                local s = tostring(z.Text)
                if s ~= "" then
                  local z = s:lower()
                  if z:find("cook") or z:find("dish") or z:find("customer") then
                    X = s
                  elseif x == nil and s ~= X then
                    x = s
                  end
                end
              end
            end
            if X and x then
              local l = X:lower()
              if l:find("cook") then
                s.waits["cook"] = x
                z = true
              elseif l:find("dish") then
                s.waits["dish"] = x
                z = true
              elseif l:find("customer") then
                s.waits["customer"] = x
                z = true
              end
            end
          end
        end
      end
      return z
    end
    local function UE(s, X)
      local z = X:FindFirstChild("Bottom")
      if z then
        local function X(s)
          for s, X in ipairs(s:GetDescendants()) do
            if X:IsA("TextLabel") then
              local s = tostring(X.Text)
              if s:match("^%$[%d%,]+$") then
                return s
              end
            end
          end
          return nil
        end
        local l = z:FindFirstChild("Earnings")
        if l then
          local z = X(l)
          if z and z ~= "$0" then
            s.earnings = z
          end
        end
        local x = z:FindFirstChild("Bonus")
        if x then
          local z = X(x)
          if z and z ~= "$0" then
            s.bonus = z
          end
        end
      end
    end
    local fE = { "Common", "Uncommon"; "Rare"; "Premium", "Gourmet"; "Secret" }
    local function FE(s, X)
      local z = X and X:FindFirstChild("Scroll")
      if not z then
        return false
      end
      local l = z:FindFirstChild("CustomersHolder")
      if not l then
        return false
      end
      local x = {}
      for s, X in ipairs(fE) do
        x[X] = true
      end
      local w, M = {}, 0
      for s, X in ipairs(l:GetChildren()) do
        if X:IsA("Frame") then
          local s, z, l
          for X, w in ipairs(X:GetDescendants()) do
            if w:IsA("TextLabel") then
              local X = tostring(w.Text)
              if X ~= "" and X ~= "Served" then
                local w = tonumber(X:match("^x(%d+)$"))
                if x[X] then
                  l = X
                elseif w and z == nil then
                  z = w
                elseif s == nil then
                  s = X
                end
              end
            end
          end
          if s and z then
            w[#w + 1] = { name = s; n = z, rar = l or "Unknown" }
            M += z
          end
        end
      end
      if #w > 0 then
        s.panelCustomers = w
        s.customersServed = M
        return true
      end
      return false
    end
    local function aE(s, X)
      G(function()
        local z = i:FindFirstChild("PlayerGui")
        local l = z and z:FindFirstChild("Days")
        if not l then
          return
        end
        local x = l:FindFirstChild("Days")
        local w = x and x:FindFirstChild("Frame")
        local M = w and w:FindFirstChild("Content")
        local D = M and M:FindFirstChild("RightSide")
        if not D then
          return
        end
        local N = false
        for s = 1, 12, 1 do
          local z = D:FindFirstChild("DayNumber")
          if z and BE(z) == X then
            N = true
            break
          end
          task.wait(.5)
        end
        local H = getgenv().rarDailyDiag
        if type(H) == "table" then
          local s = D:FindFirstChild("DayNumber")
          H.scrape = {
            startedAt = os.date("%H:%M:%S"),
            finishedDay = X;
            panelLabel = s and BE(s) or "nil";
            dayOk = N
          }
        end
        if not N then
          return
        end
        for X = 1, 120, 1 do
          local z = ZE(s, D)
          local l = FE(s, M)
          UE(s, D)
          if z and (l and s.earnings) then
            if type(H) == "table" then
              H.scrape["polls"] = X
            end
            break
          end
          task.wait(1)
        end
        if type(H) == "table" then
          H.scrape["gotStats"] = s.waits and s.waits["cook"] ~= nil
          H.scrape["holders"] = s.panelCustomers and #s.panelCustomers or 0
          H.scrape["earnings"] = s.earnings
          H.scrape["bonus"] = s.bonus
          H.scrape["doneAt"] = os.date("%H:%M:%S")
        end
      end)
    end
    local function pE(s)
      local X, z = G(function()
        local X = s.Dir and s.Dir["Rarity"]
        return tostring((X and ((X.DisplayName or X._id))) or "Unknown")
      end)
      return (X and z) or "Unknown"
    end
    local function EE(s)
      local X, z = G(function()
        local X = s.Dir
        return tostring((X and ((X.DisplayName or X._id))) or s.DirId or "Unknown")
      end)
      return (X and z) or "Unknown"
    end
    local yE = {}
    local oE = 0
    local function PE(s)
      if not s and os.clock() - oE < 120 then
        return
      end
      oE = os.clock()
      G(function()
        local s = Q.__DIRECTORY and Q.__DIRECTORY:FindFirstChild("Entity")
        local X = s and s:FindFirstChild("Customer")
        if not X then
          return
        end
        local z = {}
        for s, X in ipairs(X:GetChildren()) do
          local l, x = G(require, X)
          if l and type(x) == "table" then
            local s = tostring(x.DisplayName or "")
            local X = tostring(x._id or "")
            local l = x.Rarity
            local w = tostring((l and ((l.DisplayName or l._id))) or "Unknown")
            local M = { name = (s ~= "" and s) or X, rar = w }
            if s ~= "" then
              z[s] = M
            end
            if X ~= "" then
              z[X] = M
            end
          end
        end
        yE = z
      end)
    end
    local function TE(s)
      local X = s:find("_%x%x%x%x%x%x%x%x%-%x")
      if X then
        return s:sub(1, X - 1), s:sub(X + 1)
      end
      return nil
    end
    local function qE(s, X, z, l, x)
      if X[z] then
        return
      end
      X[z] = true
      s.customers += 1
      s.byRarity[x] = ((s.byRarity[x] or 0)) + 1
      local w = s.byType[l]
      if type(w) ~= "table" then
        w = { n = 0; rar = x }
        s.byType[l] = w
      end
      w.n += 1
      w.rar = x
    end
    local function dE(s)
      local X = getgenv().webhookUrl or ""
      if X == "" then
        return
      end
      local z = getgenv().webhookPingId or ""
      local l = H:JSONEncode({ content = z ~= "" and ("<@%s>"):format(z) or nil; embeds = { s } })
      local x = type(http_request) == "function" and http_request or type(request) == "function" and request or nil
      if x then
        G(x, {
          Url = X,
          Method = "POST";
          Headers = { ["Content-Type"] = "application/json" };
          Body = l
        })
      end
    end
    local function KE(s, X)
      local z = getgenv().webhookUrl or ""
      local l = getgenv().rarDailyDiag
      if type(l) == "table" then
        l.send = {
          at = os.date("%H:%M:%S"),
          forceTest = X and true or false;
          urlSet = z ~= "";
          dDay = type(s) == "table" and tostring(s.day) or "none";
          waits = (type(s) == "table" and (type(s.waits) == "table" and s.waits["cook"])) or "-";
          panelCust = ((type(s) == "table" and type(s.panelCustomers) == "table")) and #s.panelCustomers or 0,
          served = (type(s) == "table" and tonumber(s.customersServed)) or 0;
          cashEarned = (type(s) == "table" and tonumber(s.cashEarned)) or 0,
          earnings = type(s) == "table" and tostring(s.earnings or "nil") or "-"
        }
      end
      if z == "" then
        return
      end
      if not X and not bE.webhookDailySummary then
        return
      end
      s = (type(s) == "table" and s) or VE()
      local x = getgenv().webhookCustomersRarities
      local w = {}
      if type(x) == "table" then
        for s, X in ipairs(fE) do
          if x[X] then
            w[#w + 1] = X
          end
        end
      end
      local M = (#w == 0)
      local D = (type(s.panelCustomers) == "table" and s.panelCustomers) or {}
      local N = {}
      if #D > 0 then
        for s, X in ipairs(D) do
          if X.n > 0 and ((M or (type(x) == "table" and x[X.rar]))) then
            N[#N + 1] = { name = X.name, n = X.n; rar = X.rar }
          end
        end
      else
        for s, X in pairs(s.byType or {}) do
          local z = (type(X) == "table" and tonumber(X.n)) or 0
          local l = (type(X) == "table" and tostring(X.rar)) or "Unknown"
          if z > 0 and ((M or (type(x) == "table" and x[l]))) then
            N[#N + 1] = { name = s; n = z, rar = l }
          end
        end
      end
      table.sort(N, function(s, X)
        return s.n > X.n
      end)
      local H = 0
      if #D > 0 then
        for s, X in ipairs(D) do
          if M or (type(x) == "table" and x[X.rar]) then
            H += X.n
          end
        end
        if M then
          H = tonumber(s.customersServed) or H
        end
      elseif M then
        H = tonumber(s.customers) or 0
      else
        for X, z in ipairs(w) do
          H += tonumber(s.byRarity and s.byRarity[z]) or 0
        end
      end
      local t = (type(s.waits) == "table" and s.waits) or {}
      local r = s.earnings or ("$" .. tostring(tonumber(s.cashEarned) or 0))
      local v = {
        "**-> Profile :**",
        ("> Username : `%s`"):format(i.Name),
        "";
        "**-> Daily Summary (Day " .. (tostring(s.day or "?") .. ") :**"),
        ("> Avg Cook Time : `%s`"):format(t.cook or "n/a");
        ("> Avg Dish Wait : `%s`"):format(t.dish or "n/a");
        ("> Avg Customer Wait : `%s`"):format(t.customer or "n/a"),
        ("> Today's Earnings : `%s`"):format(r),
        ("> Bonus Cash : `%s`"):format(s.bonus or "$0"),
        ("> Diamonds Earned : `%d`"):format(tonumber(s.diamondsEarned) or 0);
        ("> Customers Served : `%d`"):format(H)
      }
      if #N > 0 then
        v[#v + 1] = ""
        v[#v + 1] = "**-> Top Types :**"
        local s = {}
        local X = {}
        for z, l in ipairs(N) do
          if l.rar == "Common" or l.rar == "Uncommon" or l.rar == "Rare" then
            s[l.rar] = ((s[l.rar] or 0)) + l.n
          else
            X[#X + 1] = l
          end
        end
        for X, z in ipairs({ "Common", "Uncommon", "Rare" }) do
          if ((s[z] or 0)) > 0 then
            v[#v + 1] = ("> %s : `%d`"):format(z, s[z])
          end
        end
        table.sort(X, function(s, X)
          return s.n > X.n
        end)
        for s = 1, math.min(15, #X), 1 do
          v[#v + 1] = ("> %s (%s) : `%d`"):format(X[s].name, X[s].rar, X[s].n)
        end
        if #X > 15 then
          v[#v + 1] = ("> ...and %d more"):format(#X - 15)
        end
      else
        v[#v + 1] = ""
        v[#v + 1] = "**-> Top Types :**"
        v[#v + 1] = "> None recorded yet"
      end
      dE({
        title = "SpectreWare | Run A Restaurant",
        description = table.concat(v, "\n");
        color = 5793266,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
      })
    end
    task.spawn(function()
      local s = {}
      local X = JE()
      local l = 0
      local x = 0
      local w = nil
      local M = 0
      while z() do
        task.wait(5)
        local z = os.time()
        local D = bE.webhookDailySummary
        M += 1
        local N = getgenv().rarDailyDiag
        if type(N) == "table" then
          N.tick = {
            n = M,
            at = os.date("%H:%M:%S");
            curDay = tostring(X),
            today = tostring(D and JE() or "-"),
            want = D
          }
        end
        if D then
          local z = JE()
          if type(X) == "number" and (type(z) == "number" and X ~= z) then
            local l = getgenv().rarDaily
            if type(N) == "table" then
              N.rollover = {
                at = os.date("%H:%M:%S");
                curDay = X;
                today = z,
                storeDay = type(l) == "table" and tostring(l.day) or "none"
              }
            end
            if type(l) == "table" and l.day == X then
              aE(l, X)
              task.spawn(KE, l, false)
            end
            s = {}
            w = nil
            X = z
            VE()
          end
        end
        if D and z - l >= 5 then
          l = z
          task.spawn(function()
            G(function()
              PE(false)
              local X = VE()
              local z = n.GetLocal()
              local l = getgenv().rarDailyDiag
              if type(l) == "table" then
                l.watcher = { at = os.date("%H:%M:%S"); rest = z and "yes" or "no", models = 0; matched = 0 }
              end
              if z then
                local x = z.Model
                local w = x and x:FindFirstChild("Entities")
                if w and type(l) == "table" then
                  l.watcher["folder"] = "yes"
                  for z, x in ipairs(w:GetChildren()) do
                    l.watcher["models"] += 1
                    local w = tostring(x.Name)
                    local M = TE(w)
                    if M then
                      local z = yE[M]
                      if z then
                        l.watcher["matched"] += 1
                        qE(X, s, w, z.name, z.rar)
                      end
                    end
                  end
                end
                for z, l in ipairs(P(z, "Customer") or {}) do
                  qE(X, s, tostring(l.Id), EE(l), pE(l))
                end
              end
            end)
          end)
        end
        if bE.webhookDailySummary and z - x >= 60 then
          x = z
          task.spawn(function()
            G(function()
              local s = R.Invoke("Currency_Get")
              local X = getgenv().rarDailyDiag
              if type(X) == "table" then
                X.sampler = {
                  at = os.date("%H:%M:%S"),
                  got = type(s) == "table" and "table" or tostring(s)
                }
              end
              if type(s) ~= "table" then
                return
              end
              local z = tonumber(s.Cash)
              local l = tonumber(s.Diamonds)
              if type(X) == "table" then
                X.sampler["cash"] = z
                X.sampler["dia"] = l
              end
              local x = VE()
              if w then
                if z and (w.cash and z > w.cash) then
                  x.cashEarned += z - w.cash
                end
                if l and (w.dia and l > w.dia) then
                  x.diamondsEarned += l - w.dia
                end
              end
              w = { cash = z, dia = l }
            end)
          end)
        end
      end
    end)
    local AE = -1
    task.spawn(function()
      while z() do
        task.wait(2)
        if not bE.webhookCrate then
          continue
        end
        local s = getgenv().webhookUrl or ""
        if s == "" then
          continue
        end
        G(function()
          local s = require(Q.Framework["Client"].Saving)
          local X = s.Get() and (s.Get()).Inventory or {}
          local z = X["Sunken Crate"] or 0
          if AE < 0 then
            AE = z
          elseif z > AE then
            local s = z - AE
            SE = SE + s
            AE = z
            task.spawn(nE)
          else
            AE = z
          end
        end)
      end
    end)
    do
      local X, w = NE("Auto Fish / Reel", "Automatically cast, catch, and reel in fish.", e)
      local M, N, H = ME("Auto Fish / Reel", "", X)
      local t, r, v = ME("Auto Whirlpool", "", X)
      local b = nil
      local g = false
      local j = false
      local O = false
      local L = X:AddButton({
        Title = "Set Fishing Spot",
        Description = "Save your current position as the spot.",
        Icon = "mouse-pointer-click",
        Callback = function()
          local X = i.Character
          local z = X and X:FindFirstChild("HumanoidRootPart")
          if not z then
            s:Notify({
              Title = "Fishing";
              Content = "⚠️ Can't set spot — character not ready",
              Duration = 3
            })
            return
          end
          RE = z.CFrame
          if WE and WE.Text then
            WE.Text = "Spot saved! (click to update)"
          end
          s:Notify({ Title = "Fishing"; Content = "🎣 Fishing spot saved!", Duration = 3 })
        end
      })
      WE = { Text = "Set Fishing Spot" }
      l("ReelHeartbeat", D.Heartbeat:Connect(function()
        if g or not b then
          return
        end
        if not ((bE.fish or bE.wp or bE.farFish or bE.farWp)) then
          return
        end
        local s = b.BobberWindows
        local X = b.BobberDuration
        if not s or not X then
          return
        end
        local z = workspace:GetServerTimeNow()
        for s, l in ipairs(s) do
          local x = math.min(.15, X * .1)
          if x >= X then
            x = 0
          end
          if z >= (l + x) and z <= (l + X) then
            g = true
            task.spawn(function()
              local s, X = G(W.Reel)
              if not s or X == false then
                task.wait(.05)
                g = false
              end
            end)
            return
          end
        end
      end))
      l("FishUpdate", (R.Fired("Fishing_Update")):Connect(function(s)
        if s.Player ~= i or s.NpcId then
          return
        end
        if not b or tostring(b.Id) ~= tostring(s.Id) then
          g = false
        end
        b = s
        fishCs = s.CastStart or (workspace:GetServerTimeNow() + .3)
      end))
      l("FishClear", (R.Fired("Fishing_Clear")):Connect(function(s)
        local X = b and (tonumber(b.Id) == tonumber(s))
        local z = bE.farFish or bE.farWp
        if X or (z and b) then
          b = nil
          g = false
          if bE.fish or bE.wp or bE.farFish or bE.farWp then
            j = true
          end
        end
      end))
      l("FishSuccess", W.SessionSuccess:Connect(function(s, X)
        local z = "fish"
        if type(X) == "table" then
          z = tostring(X.Id or X.Name or X.ItemId or X.FishId or "fish")
        elseif type(X) == "string" then
          z = X
        else
          z = tostring(X or "fish")
        end
        local l = ""
        if type(s) == "table" then
          l = tostring(s.ItemId or s.Id or s.Name or s.FishId or "")
        elseif type(s) == "string" then
          l = s
        end
        local x = string.lower(z .. (" " .. l))
        if string.find(x, "crate") or string.find(x, "sunken") then
          SE = SE + 1
          task.spawn(nE)
        end
        local w = nil
        if type(s) == "number" then
          w = s
        elseif type(s) == "string" then
          w = tonumber(s)
        elseif type(s) == "table" then
          w = s.Id
        end
        if b and (w and tonumber(b.Id) == tonumber(w)) then
          b = nil;
          getgenv()._rar_fishBusy = false
          if bE.fish or bE.wp or bE.farFish or bE.farWp then
            j = true
          end
        end
      end))
      l("PoolUpdate", (R.Fired("DeepPool_Update")):Connect(function(s)
        if not ((bE.wp or bE.farWp)) then
          return
        end
        if s.Player ~= i then
          return
        end
        O = true
        if b then
          G(W.Cancel)
          b = nil
          g = false
        end
        j = true
      end))
      l("PoolClear", (R.Fired("DeepPool_Clear")):Connect(function()
        if not ((bE.wp or bE.farWp)) then
          return
        end
        local s = S.GetLocalPool()
        O = s ~= nil and (s.Disc ~= nil and s.Disc["Parent"] ~= nil)
        if not O then
          if b then
            G(W.Cancel)
            b = nil
            g = false
          end
          if not ((bE.farWp or bE.farFish)) then
            QE()
          end
          if bE.fish or bE.farFish then
            j = true
          end
        end
      end))
      local function h()
        local s, X = G(R.Invoke, "Fishing_RequestEquipped")
        if s and X then
          for s, X in ipairs(X) do
            if X.Player == i then
              return true
            end
          end
        end
        return false
      end
      local function m()
        local s = I.GetLocal()
        if not s then
          return false
        end
        local X, z = 0, 0
        for s, l in pairs(s.Entity) do
          if l.DirId and string.find(string.lower(tostring(l.DirId)), "ice box") then
            local s = l.Dir and (l.Dir["FishingBoxComponent"] and l.Dir["FishingBoxComponent"].Capacity) or 0
            local x = l.SaveVars and l.SaveVars["Fish"]
            local w = 0
            if type(x) == "table" then
              for s in pairs(x) do
                w += 1
              end
            end
            if w > s then
              w = s
            end
            X += w
            z += s
          end
        end
        if z == 0 then
          return false
        end
        return X >= z, X, z
      end
      local function Y()
        local s, X
        if bE.wp then
          local z = S.GetLocalPool()
          if z and (z.Disc and z.Disc["Parent"]) then
            s, X = z.Disc["Position"], "wp"
          end
        end
        if not s and bE.fish then
          local z = i.Character
          local l = z and z:FindFirstChild("HumanoidRootPart")
          if l then
            local z, w
            if RE then
              z = RE.Position
              w = RE.LookVector
            else
              z = l.Position
              w = l.CFrame["LookVector"]
            end
            local M = Vector3.new(w.X, 0, w.Z)
            if M.Magnitude < .01 then
              M = Vector3.new(0, 0, -1)
            end
            M = M.Unit
            local D = B.PlayerCastDistance or 30
            local N = B.WaterProbeHeight or 5
            for l = 6, D, 2 do
              local x = B.FindWaterCast((z + M * l) + Vector3.new(0, N, 0), Vector3.new(0, -1, 0))
              if x then
                s, X = x, "water"
                break
              end
            end
            if s and RE then
              local s = ((l.Position - RE.Position)).Magnitude
              if s > 10 then
                x(RE)
                u(.15)
              end
            end
          end
        end
        if X == "wp" then
          local X = i.Character
          local z = X and X.PrimaryPart
          if z then
            local X = s + Vector3.new(15, 3, 0)
            local l = ((z.Position - X)).Magnitude
            if l > 15 then
              if not eE then
                eE = RE or z.CFrame
              end
              iE(X)
              x(CFrame.lookAt(X, Vector3.new(s.X, X.Y, s.Z)))
              u(.2)
            end
          end
        end
        if not s then
          return false
        end
        b = nil
        g = false
        G(W.Cancel)
        u(.15)
        local z, l = W.Begin(CFrame.new(s))
        if z then
          return true
        else
          return false
        end
      end
      local function k()
        local s = getgenv()._rar_ownWaterSpots
        local X = n.GetLocal()
        if type(X) ~= "table" then
          return nil
        end
        if s and s.restId == X.Id then
          return s.spots
        end
        local z, l = G(function()
          if type(X.GetWalkableVoxels) ~= "function" then
            return {}
          end
          return X:GetWalkableVoxels(1)
        end)
        if not z then
          return nil
        end
        l = type(l) == "table" and l or {}
        local x = {}
        local w, M = 0, 0
        local D, N = 0, 0
        local H = true
        for s, X in ipairs(l) do
          x[X.X .. ("," .. X.Y)] = true
          if H then
            w, M, D, N = X.X, X.X, X.Y, X.Y
            H = false
          else
            if X.X < w then
              w = X.X
            end
            if X.X > M then
              M = X.X
            end
            if X.Y < D then
              D = X.Y
            end
            if X.Y > N then
              N = X.Y
            end
          end
        end
        local t = {}
        for s = w - 1, M + 1, 1 do
          for z = D - 1, N + 1, 1 do
            if not x[s .. ("," .. z)] then
              local l, x = G(function()
                return (X:ComputeVoxelCFrame({ X = s, Y = z })).Position
              end)
              if l and x then
                local X, l = G(B.FindWaterCast, x + Vector3.new(0, 30, 0), Vector3.new(0, -1, 0))
                if X and l then
                  t[#t + 1] = { x = s, y = z; pos = l }
                end
              end
            end
          end
        end;
        getgenv()._rar_ownWaterSpots = { restId = X.Id; spots = t }
        return t
      end
      local function J()
        local s, X
        if bE.farWp then
          local z = S.GetLocalPool()
          if z and (z.Disc and z.Disc["Parent"]) then
            s, X = z.Disc["Position"], "wp"
          end
        end
        if not s then
          local X = i.Character and i.Character["PrimaryPart"]
          if not X then
            return false
          end
          local z = k()
          if not z or #z == 0 then
            return false
          end
          if IE then
            x(IE)
            u(.1)
          end
          local l = IE and IE.Position or X.Position
          local w, M = nil, math.huge
          for s, X in ipairs(z) do
            local z = ((l - X.pos)).Magnitude
            if z < M then
              M = z
              w = X
            end
          end
          if not w then
            return false
          end
          s = w.pos
        end
        b = nil
        g = false
        G(W.Cancel)
        u(.15)
        local z, l, w = G(W.Begin, CFrame.new(s))
        if not z then
          return false
        end
        return l and true or false
      end
      local V = require(Q.Framework["Client"].Saving)
      jE(N, "fish", function()
        j = true;
        getgenv()._rar_fishBusy = false
        d.farFish(false)
        while bE.fish and z() do
          if getgenv()._rar_carnivalEarnBusy then
            task.wait(1) continue
          end
          if getgenv()._rar_organBusy then
            task.wait(1) continue
          end
          if getgenv()._rar_crateBusy then
            u(1) continue
          end
          if not h() then
            u(1)
            j = true continue
          end
          if j and not O then
            local s, X, z = m()
            if s then
              G(W.Cancel)
              b = nil
              g = false
              for s = 60, 1, -1 do
                if not bE.fish then
                  break
                end
                if O then
                  break
                end
                local X = math.floor(s / 60)
                local z = s % 60
                u(1)
              end
              j = true continue
            end
          end
          if j then
            j = false;
            getgenv()._rar_fishBusy = true
            local s
            if bE.farWp and O then
              s = J()
            else
              s = Y()
            end
            if not s then
              getgenv()._rar_fishBusy = false
            end
          end
          if not b and not j then
            local s = 0
            while not b and (not j and bE.fish) do
              u(.5)
              s += .5
              if s >= 12 then
                j = true
                break
              end
            end
          else
            u(.25)
          end
        end;
        getgenv()._rar_fishBusy = false
        b = nil
        g = false
        j = false
        G(W.Cancel)
        QE()
      end, function()
        getgenv()._rar_fishBusy = false
        b = nil
        g = false
        j = false
        G(W.Cancel)
        QE()
      end)
      jE(r, "wp", function()
        d.farFish(false)
        d.farWp(false)
        local s = S.GetLocalPool()
        if s and (s.Disc and s.Disc["Parent"]) then
          O = true
          j = true
        end
        while bE.wp and z() do
          if getgenv()._rar_crateBusy then
            u(1) continue
          end
          if bE.fish then
            u(1) continue
          end
          if not h() then
            u(1)
            j = true continue
          end
          if O and j then
            j = false
            Y()
            local s = 0
            while not j and (bE.wp and not bE.fish) do
              u(.25)
              s += .25
              if s >= 15 and not b then
                j = true
                break
              end
            end
          else
            u(.5)
          end
        end
        O = false
        QE()
        if not bE.fish then
          G(W.Cancel)
          b = nil
        end
      end, function()
        O = false
        QE()
        if not bE.fish then
          G(W.Cancel)
          b = nil
        end
      end)
      rE(X.Container, { ["Auto Fish / Reel"] = 1; ["Set Fishing Spot"] = 2; ["Auto Whirlpool"] = 3 })
      local Z, U = NE("Far Auto Fish", "Reels fish from anywhere (no TP).", e)
      local f, F, a = ME("Far Auto Fish", "", Z)
      local p = Z:AddButton({
        Title = "Set Far Fishing Spot";
        Description = "Save your current position for far fishing.";
        Icon = "mouse-pointer-click",
        Callback = function()
          local X = i.Character
          local z = X and X:FindFirstChild("HumanoidRootPart")
          if not z then
            s:Notify({
              Title = "Fishing",
              Content = "⚠️ Can't set spot — character not ready";
              Duration = 3
            })
            return
          end
          IE = z.CFrame
          if farSpotBtn and farSpotBtn.Text then
            farSpotBtn.Text = "Far Spot saved!"
          end
          s:Notify({ Title = "Fishing", Content = "🎣 Far fishing spot saved!"; Duration = 3 })
        end
      })
      farSpotBtn = { Text = "Set Fishing Spot" }
      jE(F, "farFish", function()
        OE("fish")
        OE("wp");
        getgenv()._rar_fishBusy = false
        b = nil
        g = false
        while bE.farFish and z() do
          if getgenv()._rar_carnivalEarnBusy then
            task.wait(1) continue
          end
          if getgenv()._rar_organBusy then
            task.wait(1) continue
          end
          local s, X = G(function()
            if getgenv()._rar_crateBusy then
              u(1)
              return
            end
            if not h() then
              xE(a, "No rod equipped", E.gold)
              u(2)
              return
            end
            if m() then
              xE(a, "Ice boxes full — waiting", E.dim)
              G(W.Cancel)
              b = nil
              g = false
              for s = 1, 120, 1 do
                if not bE.farFish then
                  break
                end
                u(1)
              end
              return
            end
            xE(a, "Casting…", E.green)
            b = nil
            g = false;
            getgenv()._rar_fishBusy = true
            local s = J()
            if not s then
              getgenv()._rar_fishBusy = false
              xE(a, "Cast failed — retrying", E.gold)
              u(2)
              return
            end
            local X = 0
            while not b and bE.farFish do
              u(.25)
              X += .25
              if X >= 8 then
                break
              end
            end
            if not b then
              getgenv()._rar_fishBusy = false
              return
            end
            xE(a, "Waiting for bite…", E.green)
            local z = 0
            while b and (not g and bE.farFish) do
              u(.25)
              z += .25
              if z >= 20 then
                G(W.Cancel)
                b = nil
                g = false
                break
              end
            end
            if g then
              xE(a, "Reeled! Recasting…", E.green)
            end
            local l = 0
            while b and bE.farFish do
              u(.25)
              l += .25
              if l >= 10 then
                b = nil
                g = false
                break
              end
            end;
            getgenv()._rar_fishBusy = false
            u(.5)
          end)
          if not s then
            getgenv()._rar_fishBusy = false
            xE(a, "Game hiccup — retrying", E.gold)
            u(2)
          end
        end;
        getgenv()._rar_fishBusy = false
        b = nil
        g = false
        G(W.Cancel)
        xE(a, "Idle", E.dim)
      end, function()
        getgenv()._rar_fishBusy = false
        b = nil
        g = false
        G(W.Cancel)
        xE(a, "Idle", E.dim)
      end)
      local y, o, P = ME("Far Auto Whirlpool", "", Z)
      jE(o, "farWp", function()
        OE("wp")
        local s = S.GetLocalPool()
        if s and (s.Disc and s.Disc["Parent"]) then
          O = true
          j = true
        end
        while bE.farWp and z() do
          if getgenv()._rar_crateBusy then
            u(1) continue
          end
          if bE.fish or bE.farFish then
            u(1) continue
          end
          if not h() then
            u(1)
            j = true continue
          end
          if O and j then
            j = false;
            getgenv()._rar_fishBusy = true
            if not J() then
              getgenv()._rar_fishBusy = false
            end
            local s = 0
            while not j and bE.farWp do
              u(.25)
              s += .25
              if s >= 15 and not b then
                j = true
                break
              end
            end
          else
            u(.5)
          end
        end;
        getgenv()._rar_fishBusy = false
        b = nil
        g = false
        j = false
        O = false
        if not bE.fish then
          G(W.Cancel)
        end
      end, function()
        getgenv()._rar_fishBusy = false
        b = nil
        g = false
        j = false
        O = false
        if not bE.fish then
          G(W.Cancel)
        end
      end)
      rE(Z.Container, {
        ["Far Auto Fish"] = 1,
        ["Set Far Fishing Spot"] = 2;
        ["Far Auto Whirlpool"] = 3
      })
      local T, q, K = ME("Auto Equip Rod", "Automatically equips your fishing rod when unequipped.", e)
      jE(q, "autoEquipRod", function()
        while bE.autoEquipRod and z() do
          if getgenv()._rar_crateBusy then
            u(1) continue
          end
          if not h() then
            local s = false
            G(function()
              local X = require(Q.Framework["Client"].Toolbar)
              for z = 1, 9, 1 do
                if not bE.autoEquipRod then
                  break
                end
                local l = G(function()
                  return X.GetItem(z)
                end) and X.GetItem(z)
                if type(l) == "table" and ((l.ShopCategory == "Fishing" or (l.DisplayName and string.find(string.lower(tostring(l.DisplayName)), "rod")))) then
                  X.Select(z)
                  task.wait(.5)
                  if h() then
                    s = true
                    break
                  end
                end
              end
            end)
            if not s then
              G(function()
                local X = require(Q.Framework["Client"].ClientFishing)
                local z = require(Q.Framework["Directory"].FishingRod)
                for z, l in pairs(z) do
                  if not bE.autoEquipRod then
                    break
                  end
                  G(function()
                    X:Equip(z)
                  end)
                  task.wait(.5)
                  if h() then
                    s = true
                    break
                  end
                end
              end)
            end
            if not s then
            end
          else
          end
          u(5)
        end
      end, function()
      end)
      e:AddButton({
        Title = "Set Crate Spot",
        Description = "Stand on your crate tile, then click to save the spot.";
        Icon = "map-pin",
        Callback = function()
          local X = i.Character and i.Character:FindFirstChild("HumanoidRootPart")
          if not X then
            s:Notify({ Title = "Crate Spot", Content = "Character not ready.", Duration = 3 })
            return
          end
          local z = n.GetLocal()
          if not z then
            s:Notify({ Title = "Crate Spot", Content = "No restaurant found."; Duration = 3 })
            return
          end
          local l, x, w
          G(function()
            local M = nil
            local D = z:GetModel()
            if D then
              M = D:GetPivot()
            else
              M = z.CFrame
            end
            if M then
              local D = (M:ToObjectSpace(CFrame.new(X.Position))).Position
              l = math.round(((27.5 - D.X)) / 5)
              x = math.round(((D.Z + 27.5)) / 5)
              w = math.clamp(math.floor(((D.Y + 10)) / 20.5) + 1, 1, 10)
              G(function()
                local D, N, H
                for s, z in next, z.Entity do
                  local l, x = tonumber(z.X), tonumber(z.Y)
                  local t = tonumber(z.Floor)
                  if l and (x and t == w) then
                    local s = (tostring(z.DirId or "")):lower()
                    local w = (tostring(z.Class or "")):lower()
                    if s:find("floor") or s:find("dock") or w:find("floor") then
                      local s = M * CFrame.new(27.5 - 5 * l, ((t - 1)) * 20.5, 5 * x - 27.5)
                      local z = ((s.Position - X.Position)).Magnitude
                      if z < 4 and ((not D or z < D)) then
                        D, N, H = z, l, x
                      end
                    end
                  end
                end
                if D then
                  l, x = N, H
                else
                  local D, N, H
                  for s, z in next, z.Entity do
                    local l, x = tonumber(z.X), tonumber(z.Y)
                    local t = tonumber(z.Floor)
                    if l and (x and t == w) then
                      local s = (tostring(z.DirId or "")):lower()
                      local w = (tostring(z.Class or "")):lower()
                      if s:find("floor") or s:find("dock") or w:find("floor") then
                        local s = M * CFrame.new(27.5 - 5 * l, ((t - 1)) * 20.5, 5 * x - 27.5)
                        local z = ((s.Position - X.Position)).Magnitude
                        if not D or z < D then
                          D, N, H = z, l, x
                        end
                      end
                    end
                  end
                  if D then
                    l, x = N, H
                    local X = ("No floor under you — snapped to nearest floor tile (X:%d Y:%d, %d studs away)"):format(N, H, math.floor(D))
                    s:Notify({ Title = "Crate Spot", Content = X, Duration = 5 })
                  end
                end
              end)
            end
          end)
          if l and x then
            getgenv().rarCrateSpotX = l;
            getgenv().rarCrateSpotY = x;
            getgenv().rarCrateSpotFloor = w or 1
            s:Notify({
              Title = "Crate Spot",
              Content = ("Spot set to X:%d Y:%d F:%d. Save config to persist."):format(l, x, getgenv().rarCrateSpotFloor),
              Duration = 4
            })
          else
            s:Notify({ Title = "Crate Spot"; Content = "Could not calculate grid coords."; Duration = 4 })
          end
        end
      })
      local A, C, c = ME("Auto Place Sunken Crates", "Spirals from your saved spot and fills up to 3 crates.", e)
      jE(C, "autoPlaceCrate", function()
        while bE.autoPlaceCrate and z() do
          if getgenv()._rar_fishBusy then
            xE(c, "Waiting (fish busy)...", E.dim)
            u(2) continue
          end
          local s = getgenv().rarCrateSpotX
          local X = getgenv().rarCrateSpotY
          local z = getgenv().rarCrateSpotFloor or 1
          if not s or not X then
            xE(c, "Set a crate spot first", E.gold)
            u(2) continue
          end
          local l = n.GetLocal()
          if not l then
            xE(c, "Restaurant not found", E.red)
            u(3) continue
          end
          local x = {}
          local w = {}
          local M = 0
          local D = {}
          G(function()
            for s, X in next, l.Entity do
              D[#D + 1] = X
            end
          end)
          G(function()
            local s = l:CollectSubclass("SunkenCrate")
            for s, X in ipairs(s) do
              D[#D + 1] = X
            end
          end)
          local N = {}
          for s, X in ipairs(D) do
            G(function()
              if N[X] then
                return
              end
              N[X] = true
              local s = tonumber(X.Floor)
              if not s or s ~= z then
                return
              end
              local l = tonumber(X.X)
              local D = tonumber(X.Y)
              if l and D then
                local s = l .. ("," .. D)
                local z = (tostring(X.DirId or "")):lower()
                local N = (tostring(X.Class or "")):lower()
                if z:find("floor") or z:find("dock") or N:find("floor") then
                  w[s] = { x = l, y = D }
                else
                  if z:find("sunken crate") or z:find("sunkencrate") or N:find("sunken") then
                    x[s] = true
                    M = M + 1
                  end
                end
              end
            end)
          end
          xE(c, ("Crates placed: %d/3"):format(M), E.dim)
          if M >= 3 then
            xE(c, "All 3 crates placed", E.green);
            getgenv()._rar_crateBusy = false
            u(5) continue
          end
          local H = require(Q.Framework["Client"].Saving)
          local t = {}
          G(function()
            t = (H.Get()).Inventory or {}
          end)
          local r = tonumber(t["Sunken Crate"]) or 0
          if r <= 0 then
            xE(c, "No Sunken Crates in inventory", E.gold);
            getgenv()._rar_crateBusy = false
            u(5) continue
          end
          local v, b = nil, nil
          for z = 0, 25, 1 do
            if v then
              break
            end
            for l = -z, z, 1 do
              if v then
                break
              end
              for M = -z, z, 1 do
                if math.abs(l) == z or math.abs(M) == z then
                  local z = s + l
                  local D = X + M
                  local N = z .. ("," .. D)
                  if w[N] and not x[N] then
                    v, b = z, D
                    break
                  end
                end
              end
            end
          end
          if not v then
            local l, M, D
            for z, w in pairs(w) do
              local N = w.x
              local H = w.y
              local t = N - s
              local r = H - X
              local v = t < 0 and -t or t
              local b = r < 0 and -r or r
              local G = v > b and v or b
              local g = N .. ("," .. H)
              if not x[g] and ((not D or G < D)) then
                D, l, M = G, N, H
              end
            end
            if l then
              v, b = l, M
              xE(c, ("Spot not on floor — placing at nearest tile X:%d Y:%d"):format(v, b), E.gold)
            else
              xE(c, ("No free tile near X:%d Y:%d F:%d — re-save the spot standing on the tile!"):format(s, X, z), E.gold)
              u(3) continue
            end
          end;
          getgenv()._rar_crateBusy = true
          xE(c, ("Placing crate at X:%d Y:%d F:%d..."):format(v, b, z), E.cyan)
          R.Fire("Build_Place", "Sunken Crate", v, b, 0, z)
          u(2);
          getgenv()._rar_crateBusy = false
        end;
        getgenv()._rar_crateBusy = false
      end, function()
        getgenv()._rar_crateBusy = false
      end)
      local sE, XE, lE = ME("Auto Open Sunken Crates", "Claims Sunken Crates when their timer finishes.", e)
      jE(XE, "autoOpenCrate", function()
        while bE.autoOpenCrate and z() do
          if getgenv()._rar_fishBusy then
            u(1) continue
          end
          local s = n.GetLocal()
          if s then
            local X = {}
            local z, l = G(function()
              return s.Entity or {}
            end)
            if z and type(l) == "table" then
              for s, z in next, l do
                G(function()
                  if type(z.DirId) == "string" and string.find(string.lower(z.DirId), "sunken crate") then
                    table.insert(X, z)
                  end
                end)
              end
            end
            local w = false
            local M = math.huge
            local D = workspace:GetServerTimeNow()
            for s, X in ipairs(X) do
              if not bE.autoOpenCrate then
                break
              end
              local z = X.SaveVars and tonumber(X.SaveVars["CompletionTime"])
              if z then
                local s = z - D
                if s <= 0 then
                  getgenv()._rar_crateBusy = true
                  local s = require(Q.Framework["Client"].Saving)
                  local function z()
                    local X = 0
                    G(function()
                      X = (s.Get()).Diamonds
                    end)
                    if type(X) == "number" and X > 0 then
                      return X
                    end
                    G(function()
                      X = (s.Get()).Currencies["Diamonds"]
                    end)
                    if type(X) == "number" and X > 0 then
                      return X
                    end
                    G(function()
                      X = (s.Get()).Stats["Diamonds"]
                    end)
                    return type(X) == "number" and X or 0
                  end
                  local l = z()
                  local M = {}
                  G(function()
                    M = (s.Get()).Inventory or {}
                  end)
                  local D = {}
                  for s, X in pairs(M) do
                    D[s] = X
                  end
                  local N = i.Character
                  local H = N and N:FindFirstChild("HumanoidRootPart")
                  local t = H and H.CFrame
                  local r = X.GetModel and X:GetModel()
                  local v = false
                  if r and H then
                    local s = r:GetPivot()
                    local X = s.Position + Vector3.new(3, 2, 0)
                    x(CFrame.new(X, s.Position))
                    task.wait(.5)
                    G(function()
                      for s, X in ipairs(r:GetDescendants()) do
                        if X:IsA("ProximityPrompt") then
                          local s = 0
                          while not X.Enabled and s < 3 do
                            task.wait(.25)
                            s = s + .25
                          end
                          if X.Enabled then
                            for s = 1, 3, 1 do
                              fireproximityprompt(X)
                              task.wait(.2)
                            end
                            v = true
                          end
                          break
                        end
                      end
                    end)
                    task.wait(.3)
                    if t then
                      x(t)
                    end
                  end
                  w = true
                  if v then
                    getgenv().cratesOpenedSession = ((getgenv().cratesOpenedSession or 0)) + 1
                    local X = "No reward detected"
                    for x = 1, 15, 1 do
                      u(.2)
                      local w = z()
                      local M = {}
                      G(function()
                        M = (s.Get()).Inventory or {}
                      end)
                      local N = false
                      local H = {}
                      if w > l then
                        table.insert(H, ("+%d Diamonds 💎"):format(w - l))
                        N = true
                      end
                      for s, X in pairs(M) do
                        local z = D[s] or 0
                        if type(X) == "number" and X > z then
                          table.insert(H, ("+%d %s"):format(X - z, s))
                          N = true
                        end
                      end
                      if N then
                        X = table.concat(H, ", ")
                        break
                      end
                    end
                    G(function()
                      YE(false, X)
                    end)
                  else
                    u(.5)
                  end;
                  getgenv()._rar_crateBusy = false
                  break
                else
                  if s < M then
                    M = s
                  end
                end
              end
            end
            if not w then
              if M < math.huge then
                local s = math.floor(M / 60)
                local X = math.floor(M % 60)
                xE(lE, ("Next crate in %dm %02ds"):format(s, X), E.dim)
              else
                xE(lE, ("%d crates placed"):format(#X), E.dim)
              end
            end
          else
            xE(lE, "Restaurant not found", E.red)
          end
          u(2)
        end
      end, function()
      end)
    end
    do
      local s = {}
      local X = false
      local function l(s, X)
        local z = s.GetModel and s:GetModel()
        if not z then
          return false
        end
        for s, z in ipairs(z:GetDescendants()) do
          if z:IsA("ProximityPrompt") and z.Enabled then
            if not X or X == "" or string.find(string.lower(z.ActionText), string.lower(X)) then
              return true
            end
          end
        end
        return false
      end
      local function w(X, z)
        local l = n.GetLocal()
        if not l then
          return nil
        end
        local x = i.Character
        local w = x and x:FindFirstChild("HumanoidRootPart")
        if not w then
          return nil
        end
        local M, D = nil, math.huge
        local N, H = G(function()
          return l.Entity or {}
        end)
        if not N or type(H) ~= "table" then
          return nil
        end
        for l, x in next, H do
          G(function()
            local l = false
            local N = ""
            G(function()
              N = x.DirId and string.lower(tostring(x.DirId)) or ""
            end)
            local H = ""
            G(function()
              H = tostring(x.Class or "")
            end)
            local t = ""
            G(function()
              t = tostring(x.Dir and x.Dir["Subclass"] or "")
            end)
            local r = {}
            for s in t:gmatch("[^%s]+") do
              r[s] = true
            end
            if X == "Stove" then
              l = H == "Stove" or r.Stove or string.find(N, "stove") or string.find(N, "oven") or string.find(N, "grill") or string.find(N, "fryer")
            elseif X == "Dishwasher" then
              l = H == "Dishwasher" or r.Dishwasher or string.find(N, "dishwasher") or string.find(N, "sink") or string.find(N, "washer")
            else
              l = H == X or r[X]
            end
            if l then
              local X = x.Id or tostring(x)
              if not s[X] or h() - s[X] > 5 then
                if not z or z(x) then
                  local s = x.GetModel and x:GetModel()
                  if s then
                    local X = (s:GetPivot()).Position
                    local z = ((w.Position - X)).Magnitude
                    if z < D then
                      D = z
                      M = x
                    end
                  end
                end
              end
            end
          end)
        end
        return M
      end
      local function M(z, l, w)
        if not z then
          return false
        end
        local M = z.GetModel and z:GetModel()
        if not M then
          return false
        end
        if bE.fish and fishSess then
          return false
        end
        local D = 0
        while X and D < 5 do
          task.wait(.1)
          D = D + .1
        end
        if X then
          return false
        end
        local N = i.Character
        local H = N and N:FindFirstChild("HumanoidRootPart")
        if not H then
          return false
        end
        X = true
        local t = H.CFrame
        local r, v = G(function()
          local s = M:GetPivot()
          local X = (s.Position + s.LookVector * 4) + Vector3.new(0, 3, 0)
          x(CFrame.lookAt(X, s.Position))
        end)
        u(.8)
        local b = false
        G(function()
          b = sE(z, l)
        end)
        u(.25)
        if not b and not w then
          local X = z.Id or tostring(z)
          s[X] = h()
        end
        x(t)
        X = false
        return b
      end
      task.spawn(function()
        local s = {}
        while z() and u(.5) do
          local X = bE.foodServe or bE.washDishes or bE.cookFood or bE.coffee or bE.produce or bE.iceCream or bE.meat
          local z = workspace:FindFirstChild("__DEBRIS")
          if not X or not z then
            continue
          end
          for X, z in ipairs(z:GetDescendants()) do
            if not ((z:IsA("ProximityPrompt") and z.Enabled)) then
              continue
            end
            if A(z, nil) then
              continue
            end
            local l = tostring(z)
            if s[l] and h() - s[l] < 2 then
              continue
            end
            local x = string.lower(z.ActionText)
            local w = false
            if bE.foodServe and string.find(x, "serve") then
              w = true
            end
            if bE.washDishes and ((string.find(x, "clean") or string.find(x, "dish") or string.find(x, "wash") or string.find(x, "pick") or string.find(x, "grab"))) then
              w = true
            end
            if bE.cookFood and ((string.find(x, "cook") or string.find(x, "prepare"))) then
              w = true
            end
            if bE.coffee and string.find(x, "fill") then
              w = true
            end
            if bE.produce and ((string.find(x, "collect") or string.find(x, "harvest"))) then
              w = true
            end
            if w then
              s[l] = h()
              G(function()
                fireproximityprompt(z)
              end)
              u(.1)
            end
          end
          local l = h()
          for X, z in pairs(s) do
            if l - z > 10 then
              s[X] = nil
            end
          end
        end
      end)
      local D, N, H = ME("Auto Assign Seat", "Automatically assigns waiting customers to empty seats.", b)
      jE(N, "assignSeat", function()
        while bE.assignSeat and z() do
          local s = n.GetLocal()
          if s then
            local X = false
            for s, z in ipairs(P(s, "Customer") or {}) do
              if not bE.assignSeat then
                break
              end
              if sE(z, "seat") or sE(z, "assign") then
                X = true
                u(.15)
              end
            end
          else
          end
          u(acted and .25 or .5)
        end
      end, function()
      end)
      local t, r, v = ME("Auto Take Order", "Automatically takes orders from customers once they are seated.", b)
      jE(r, "takeOrder", function()
        while bE.takeOrder and z() do
          local s = n.GetLocal()
          if s then
            local X = false
            for s, z in ipairs(P(s, "Customer") or {}) do
              if not bE.takeOrder then
                break
              end
              if sE(z, "order") or sE(z, "take") then
                X = true
                u(.15)
              end
            end
          else
          end
          u(acted and .25 or .5)
        end
      end, function()
      end)
      local g, j, O = ME("Auto Food Serve", "Picks up cooked food from stoves and serves it to customers.", b)
      jE(j, "foodServe", function()
        while bE.foodServe and z() do
          local s = n.GetLocal()
          if s then
            local X = false
            local z, l = G(function()
              return s.Entity or {}
            end)
            if z and l then
              for s, z in next, l do
                if bE.foodServe and ((y(z, "Stove") or o(z, { "stove"; "oven"; "grill"; "fryer" }))) then
                  if sE(z, "take") or sE(z, "pick") or sE(z, "grab") then
                    X = true
                    u(.15)
                  end
                end
              end
            end
            for s, z in ipairs(P(s, "DrinkMachine") or {}) do
              if not bE.foodServe then
                break
              end
              if sE(z, "") then
                X = true
                u(.15)
              end
            end
            for s, z in ipairs(P(s, "Customer") or {}) do
              if not bE.foodServe then
                break
              end
              if sE(z, "serve") or sE(z, "give") then
                X = true
                u(.15)
              end
            end
          else
          end
          u(acted and .25 or .5)
        end
      end, function()
      end)
      local e, L, m = ME("Auto Wash Dishes", "Collects dirty plates from tables and teleports to the dishwasher.", b)
      jE(L, "washDishes", function()
        while bE.washDishes and z() do
          local s = n.GetLocal()
          if s then
            local X = false
            for s, z in ipairs(P(s, "Table")) do
              if not bE.washDishes then
                break
              end
              if sE(z, "pick") or sE(z, "grab") or sE(z, "clean") or sE(z, "dish") then
                X = true
                u(.15)
              end
            end
            local z = false
            local x, D = G(function()
              return s.Entity or {}
            end)
            if x and D then
              for s, X in next, D do
                G(function()
                  local s = ""
                  G(function()
                    s = X.DirId and string.lower(tostring(X.DirId)) or ""
                  end)
                  local l = ""
                  G(function()
                    l = tostring(X.Class or "")
                  end)
                  local x = ""
                  G(function()
                    x = tostring(X.Dir and X.Dir["Subclass"] or "")
                  end)
                  local w = {}
                  for s in x:gmatch("[^%s]+") do
                    w[s] = true
                  end
                  if l == "Dishwasher" or w.Dishwasher or string.find(s, "dishwasher") or string.find(s, "sink") or string.find(s, "washer") then
                    if X.SessionVars and (tonumber(X.SessionVars["ReservedCount"]) and tonumber(X.SessionVars["ReservedCount"]) > 0) then
                      z = true
                    end
                  end
                end)
                if z then
                  break
                end
              end
            end
            if z then
              local s = w("Dishwasher", function(s)
                return s.SessionVars and (tonumber(s.SessionVars["ReservedCount"]) and (tonumber(s.SessionVars["ReservedCount"]) > 0 and l(s, "")))
              end)
              if s and M(s, "", true) then
                X = true
              end
            end
          else
          end
          u(acted and .5 or 1)
        end
      end, function()
      end)
      local Q, R, I = ME("Auto Cook Food", "Collects orders from the order table and teleports to cook at the stove.", b)
      jE(R, "cookFood", function()
        while bE.cookFood and z() do
          local s = n.GetLocal()
          if s then
            local s = false
            local X = w("Stove", function(s)
              return l(s, "collect") or l(s, "take")
            end)
            if X then
              if M(X, "", true) then
                s = true
              end
            end
            if not s then
              local X = w("Stove", function(s)
                return l(s, "cook") or l(s, "prepare")
              end)
              if X then
                if M(X, "", true) then
                  s = true
                end
              end
            end
          else
          end
          u(acted and .5 or 2)
        end
      end, function()
      end)
    end
    local uE, CE = NE("Auto Harvest Crops", "Harvests fully grown crops around you (server-safe sequential Invokes).", r.Ranching)
    local cE, s_, X_ = ME("Auto Harvest Crops", "", uE)
    local z_ = {
      { name = "Wheat", col = Color3.fromRGB(238, 190, 55) },
      { name = "Tomato", col = Color3.fromRGB(210, 62, 48) },
      { name = "Potato"; col = Color3.fromRGB(172, 128, 74) };
      { name = "Carrot"; col = Color3.fromRGB(230, 115, 30) },
      { name = "Corn"; col = Color3.fromRGB(245, 210, 48) };
      { name = "Coconut", col = Color3.fromRGB(110, 80, 50) },
      { name = "Mushroom", col = Color3.fromRGB(170, 80, 180) },
      { name = "Sugar Cane", col = Color3.fromRGB(80, 195, 90) },
      { name = "Watermelon"; col = Color3.fromRGB(60, 175, 80) };
      { name = "Coffee Beans", col = Color3.fromRGB(100, 60, 30) };
      { name = "Lettuce"; col = Color3.fromRGB(90, 190, 75) },
      { name = "Pumpkin", col = Color3.fromRGB(220, 120, 40) };
      { name = "Pineapple"; col = Color3.fromRGB(220, 185, 45) },
      { name = "Lemon"; col = Color3.fromRGB(255, 220, 60) },
      { name = "Banana", col = Color3.fromRGB(255, 215, 0) }
    }
    local l_ = {}
    for s, X in ipairs(z_) do
      l_[X.name] = true
    end
    local x_ = {}
    for s, X in ipairs(z_) do
      table.insert(x_, X.name)
    end
    local w_ = uE:AddDropdown("CropSelect", { Title = "Target Crops", Values = x_; Multi = true, Default = {} })
    a(function()
      w_:SetValue(l_)
    end)
    w_:OnChanged(function(s)
      l_ = {}
      for s, X in pairs(s) do
        if X then
          l_[s] = true
        end
      end
    end);
    (coroutine.wrap(function()
      local function s()
        local s = 0
        G(function()
          local X = require(game.ReplicatedStorage["Framework"].Directory["Entity"])
          for X, z in pairs(X) do
            if type(X) == "string" and (X:sub(-5) == " Crop" and (type(z) == "table" and (z.CropComponent ~= nil and not table.find(x_, X:sub(1, #X - 5))))) then
              table.insert(x_, X:sub(1, #X - 5))
              s += 1
            end
          end
        end)
        if s > 0 then
          table.sort(x_)
          p(w_, x_)
        end
      end
      task.wait(3)
      while z() do
        s()
        task.wait(180)
      end
    end))();
    getgenv().cropStockLimit = nil
    uE:AddInput("CropLimit", {
      Title = "Stock Limit",
      Default = "",
      Placeholder = "e.g. 50 (leave empty for No Limit)";
      Numeric = true;
      Finished = true,
      Callback = function(s)
        local X = tonumber(s)
        if X then
          getgenv().cropStockLimit = X
        else
          getgenv().cropStockLimit = nil
        end
      end
    })
    jE(s_, "crop", function()
      local s = require(Q.Framework["Client"].Network)
      local X = require(Q.Framework["Client"].ClientEntity["ClientCrop"])
      local l = 26
      while bE.crop and z() do
        local z = n.GetLocal()
        if not z then
          task.wait(5) continue
        end
        local x = game.Players.LocalPlayer["Character"]
        local w = x and x:FindFirstChild("HumanoidRootPart")
        if not w then
          task.wait(1) continue
        end
        local M = w.Position
        local D = {}
        for s, z in ipairs(P(z, "Crop") or {}) do
          if not bE.crop then
            break
          end
          local x = z:GetSave("CropId")
          local w = x and tostring(x)
          if w and ((l_[w] or l_[w .. " Crop"])) then
            local s = getgenv().cropStockLimit
            if s then
              local X = require(Q.Framework["Client"].Saving)
              local z = {}
              G(function()
                z = (X.Get()).Inventory or {}
              end)
              local l = z[w] or 0
              if l >= s then
                continue
              end
            end
            local x = z:GetModel()
            if x and ((M - (x:GetPivot()).Position)).Magnitude <= l then
              local s = 1
              G(function()
                s = X.GetStageCount(z) or 1
              end)
              s = s or 1
              local l = 1
              G(function()
                l = z:GetSession("Stage") or 1
              end)
              l = l or 1
              if l >= s then
                D[#D + 1] = z
              end
            end
          end
        end
        for X, z in ipairs(D) do
          if not bE.crop then
            break
          end
          G(s.Invoke, "Entity_Invoke", z.Id, "CropHarvest")
        end
        task.wait()
      end
    end, function()
    end)
    rE(uE.Container, { ["Auto Harvest Crops"] = 1, ["Target Crops"] = 2, ["Stock Limit"] = 3 })
    do
      local s, X = NE("Auto Sell", "Automatically sells excess ingredients, keeping a specified amount.", v)
      local l, x, w = ME("Auto Sell", "", s);
      getgenv().autoSellKeepAmount = getgenv().autoSellKeepAmount or 1000
      local M = s:AddInput("AutoSellKeepAmount", {
        Title = "Keep Amount (Auto Sell)",
        Default = tostring(getgenv().autoSellKeepAmount),
        Placeholder = "e.g. 1000",
        Numeric = true,
        Finished = true;
        Callback = function(s)
          local X = tonumber(s)
          if X and X >= 0 then
            getgenv().autoSellKeepAmount = math.floor(X)
          end
        end
      });
      getgenv().RARSellKeepInput = M
      local D = {};
      getgenv().autoSellIngredientSel = getgenv().autoSellIngredientSel or {}
      local N = HE(s.Container, {
        Name = "SellIngredients";
        SearchPlaceholder = "Search ingredients to sell...",
        Height = 160,
        LayoutOrder = 2;
        OnOpen = function(s)
          local X = {}
          G(function()
            local s = require(game.ReplicatedStorage["Framework"].Directory["Currency"])
            for s, z in pairs(s) do
              if type(z) == "table" and (z.SellPrice and (z.SellPrice > 0 and (s ~= "Cash" and s ~= "Diamonds"))) then
                table.insert(X, s)
              end
            end
          end)
          if #X > 0 then
            tE(s, X)
          end
        end;
        OnChanged = function(s)
          getgenv().autoSellIngredientSel = {}
          for s, X in pairs(s) do
            if X then
              getgenv().autoSellIngredientSel[s] = true
            end
          end
        end
      });
      (coroutine.wrap(function()
        for s = 1, 15, 1 do
          local X = {}
          G(function()
            local s = require(game.ReplicatedStorage["Framework"].Directory["Currency"])
            for s, z in pairs(s) do
              if type(z) == "table" and (z.SellPrice and (z.SellPrice > 0 and (s ~= "Cash" and s ~= "Diamonds"))) then
                table.insert(X, s)
              end
            end
            table.sort(X)
          end)
          if #X > 0 then
            for s, X in ipairs(X) do
              table.insert(D, X)
            end
            N.SetValues(D)
            break
          end
          task.wait(2)
        end
      end))()
      w.Visible = false
      jE(x, "autoSellIng", function()
        local s
        G(function()
          s = require(game.ReplicatedStorage["Framework"].Client["Network"])
        end)
        while bE.autoSellIng and z() do
          G(function()
            if not s then
              return
            end
            local X, z = G(s.Invoke, "Currency_Get")
            if not X or type(z) ~= "table" then
              xE(w, "Currency_Get failed: " .. tostring(z), E.gold)
              return
            end
            local l = getgenv().autoSellKeepAmount or 0
            local x = getgenv().autoSellIngredientSel or {}
            local M, N = false, nil
            for X, D in ipairs(D) do
              if not bE.autoSellIng then
                break
              end
              if next(x) and not x[D] then
                continue
              end
              local H = tonumber(z[D]) or 0
              local t = math.floor(H - l)
              if t > 0 then
                local X, z = G(s.Invoke, "Currency_Sell", { [D] = t })
                if X and z ~= false then
                  M = true
                  xE(w, ("Sold %d %s"):format(t, D), E.green)
                else
                  N = (not X) and tostring(z) or "server refused"
                  xE(w, "Sell error (" .. (D .. ("): " .. N)), E.gold)
                end
                task.wait(.25)
              end
            end
            if not M and not N then
              xE(w, "Nothing above keep amount (" .. (tostring(l) .. ")"), E.dim)
            end
          end)
          u(5)
        end
      end, function()
      end)
      rE(s.Container, { ["Auto Sell"] = 1; ["Keep Amount (Auto Sell)"] = 2 })
    end
    local M_, D_ = NE("Auto Upgrade RoDash", "Automatically upgrades your Delivery-driver passives (Customers / Reach / Quality). RoDash Credits are earned per delivery; this buys the cheapest affordable selected track on each cycle.", v)
    rE(M_.Container, { ["Auto Upgrade RoDash"] = 1; ["Tracks to Upgrade"] = 2 })
    local N_ = require(Q.Framework["Types"].RoDashTypes)
    local H_ = {}
    do
      local s = {}
      for X, z in pairs(N_.Tracks or {}) do
        s[#s + 1] = X
      end
      table.sort(s, function(s, X)
        local z = tonumber(((N_.Tracks[s] or {})).Order) or 0
        local l = tonumber(((N_.Tracks[X] or {})).Order) or 0
        return z < l
      end)
      H_ = s
    end
    local t_ = getgenv().rodashSelected
    if type(t_) ~= "table" or not next(t_) then
      t_ = {}
      for s, X in ipairs(H_) do
        t_[X] = true
      end;
      getgenv().rodashSelected = t_
    end
    local r_ = M_:AddDropdown("RodashSelect", { Title = "Tracks to Upgrade"; Values = H_; Multi = true; Default = {} })
    G(function()
      task.spawn(function()
        u(1.5)
        if not r_ then
          return
        end
        G(function()
          r_:SetValue(t_)
        end)
      end)
    end)
    r_:OnChanged(function(s)
      t_ = {}
      for s, X in pairs(s) do
        if X then
          t_[s] = true
        end
      end;
      getgenv().rodashSelected = t_
    end)
    bE.autoRodash = false
    local v_, b_, G_ = ME("Auto Upgrade RoDash", "Upgrades selected RoDash passives when affordable.", M_)
    jE(b_, "autoRodash", function()
      local s, X = G(function()
        return require(Q.Framework["Client"].Network)
      end)
      local l, x = G(function()
        return require(Q.Framework["Client"].CurrencyCmds)
      end)
      F()
      local w, M = G(function()
        return require(Q.Framework["Client"].Saving)
      end)
      if not s or not l or not w then
        xE(G_, "Require failed", E.red)
        return
      end
      while bE.autoRodash and z() do
        local s, z = xpcall(function()
          F()
          local s = ((M.Get() or {})).RoDashUpgrades or {}
          local z = tonumber(x.Get(N_.CurrencyId)) or 0
          local l = N_.Tracks
          local w, D, N
          for X, x in ipairs(H_) do
            if t_[x] then
              local X = l[x]
              local M = tonumber(s[x]) or 0
              if M < ((tonumber(X.MaxLevel) or 0)) then
                local s = tonumber(N_.GetUpgradeCost(X, M))
                if s and (z >= s and ((not D or s < D))) then
                  w, D, N = x, s, M + 1
                end
              end
            end
          end
          if w then
            xE(G_, ("Upgrading %s -> L%d (cost %d)"):format(w, N, D), E.yellow)
            local s, z, l = G(function()
              return X.Invoke("RoDash_Upgrade", w)
            end)
            if not s then
              xE(G_, "Upgrade error: " .. tostring(z), E.red)
            elseif not z then
              xE(G_, "Rejected: " .. tostring(l or "unknown"), E.red)
            end
          else
            xE(G_, ("Credits: %d | Next affordable on selected"):format(z), E.dim)
          end
        end, function(s)
          return tostring(s) .. ("\n" .. debug.traceback())
        end)
        if not s then
          xE(G_, "Loop error: " .. tostring(z), E.red)
        end
        u(8, 2)
      end
    end, function()
      xE(G_, "Idle", E.dim)
    end)
    do
      local function s(s)
        if s >= 1000000 then
          return string.format("%.1fM", s / 1000000)
        elseif s >= 1000 then
          return string.format("%.1fk", s / 1000)
        else
          return tostring(s)
        end
      end
      local X, w, M = ME("Auto Collect Cashier", "Automatically collects cash from cash registers within range.")
      jE(w, "cashier", function()
        local s = game.Players.LocalPlayer
        local X = 32
        while bE.cashier and z() do
          local z = n.GetLocal()
          if z then
            local l = s.Character
            local x = l and l:FindFirstChild("HumanoidRootPart")
            if x then
              for s, z in ipairs(P(z, "CashRegister") or {}) do
                local l = tonumber(z.SaveVars and z.SaveVars["Cash"]) or 0
                if l > 0 then
                  local s = z.GetModel and z:GetModel()
                  if s then
                    local l = ((x.Position - (s:GetPivot()).Position)).Magnitude
                    if l <= X then
                      G(function()
                        z:Invoke("RegisterCollect")
                      end)
                    end
                  end
                end
              end
            end
          end
          task.wait(.3)
        end
      end, function()
      end)
      local D, N, H = ME("Auto Collect Tip Jars", "Automatically collects tips from tip jars within range.")
      jE(N, "tipJars", function()
        local s = game.Players.LocalPlayer
        local X = 32
        while bE.tipJars and z() do
          local z = n.GetLocal()
          if z then
            local l = s.Character
            local x = l and l:FindFirstChild("HumanoidRootPart")
            if x then
              for s, z in ipairs(P(z, "TipJar") or {}) do
                local l = tonumber(z.SaveVars and z.SaveVars["Cash"]) or 0
                if l > 0 then
                  local s = z.GetModel and z:GetModel()
                  if s then
                    local l = ((x.Position - (s:GetPivot()).Position)).Magnitude
                    if l <= X then
                      G(function()
                        z:Invoke("TipJarClaim")
                      end)
                    end
                  end
                end
              end
            end
          end
          task.wait(.3)
        end
      end, function()
      end)
      task.spawn(function()
        while z() do
          local X = n.GetLocal()
          if X then
            local z = 0
            for s, X in ipairs(P(X, "CashRegister") or {}) do
              z += tonumber(X.SaveVars and X.SaveVars["Cash"]) or 0
            end
            xE(M, "Uncollected Cash: $" .. s(z), bE.cashier and E.green or E.dim)
            local l = 0
            for s, X in ipairs(P(X, "TipJar") or {}) do
              l += tonumber(X.SaveVars and X.SaveVars["Cash"]) or 0
            end
            xE(H, "Uncollected Tips: $" .. s(l), bE.tipJars and E.green or E.dim)
          end
          task.wait(1)
        end
      end)
      local t, b, g = ME("Auto Collect Honey", "Automatically collects honey from beehives.", r.Ranching)
      jE(b, "honey", function()
        local function s()
          local s = {}
          local X = n.GetLocal()
          for z, l in ipairs({ "BeeHive"; "GiantBeehive" }) do
            local x = P(X, l)
            for X, z in ipairs(x) do
              s[#s + 1] = z
            end
          end
          return s
        end
        while bE.honey and z() do
          local X = n.GetLocal()
          if X then
            for s, X in ipairs(s()) do
              sE(X)
            end
          end
          u(2)
        end
      end, function()
      end)
      local j, O, e = ME("Auto Fill Coffee Machines", "Teleports to each coffee machine at or below the threshold, fills it, then teleports back.", r.Serve)
      jE(O, "coffee", function()
        while bE.coffee and z() do
          local s = n.GetLocal()
          if s then
            local X = tonumber(getgenv().coffeeFillBelow) or 5
            local l = {}
            for s, z in ipairs(P(s, "Appliance") or {}) do
              if z.DirId and string.find(string.lower(tostring(z.DirId)), "coffee") then
                local s = false
                local x = true
                local w = z.GetModel and z:GetModel()
                if w then
                  local z = w:FindFirstChild("Amount", true)
                  if z and z:IsA("TextLabel") then
                    local l, w = z.Text:match("(%d+)/(%d+)")
                    if l and w then
                      if tonumber(l) >= tonumber(w) then
                        s = true
                      end
                      x = tonumber(l) <= X
                    end
                  end
                end
                if not s and x then
                  l[#l + 1] = z
                end
              end
            end
            if #l > 0 then
              local s = i.Character and i.Character:FindFirstChild("HumanoidRootPart")
              if s then
                local X = s.CFrame
                local w = 0
                for s, X in ipairs(l) do
                  if not bE.coffee or not z() then
                    break
                  end
                  local l = X.GetModel and X:GetModel()
                  if l then
                    local s = (l:GetPivot()).Position
                    x(CFrame.new(s + Vector3.new(0, 2, 3)))
                    u(1.2, .2)
                    local z = G(function()
                      return X:Invoke("CoffeeMachineFill")
                    end)
                    if z then
                      w += 1
                    end
                    u(.15)
                  end
                end
                x(X)
                if w > 0 then
                  xE(e, "Filled " .. (w .. " coffee machine(s)"), E.green)
                end
              end
            end
          end
          u(2)
        end
        xE(e, "")
      end, function()
        xE(e, "")
      end);
      getgenv().coffeeFillBelow = getgenv().coffeeFillBelow or 5
      local L = r.Serve:AddInput("CoffeeFillBelow", {
        Title = "Coffee: Fill Below Level",
        Default = tostring(getgenv().coffeeFillBelow),
        Placeholder = "e.g. 5";
        Numeric = true;
        Finished = true,
        Callback = function(s)
          local X = tonumber(s)
          if X and X >= 0 then
            getgenv().coffeeFillBelow = math.floor(X)
          end
        end
      });
      getgenv().RARCoffeeFillInput = L
      local h, m, I = ME("Auto Fill Cola Machines", "Teleports to each cola machine at or below the threshold, fills it with sugar, then teleports back.", r.Serve)
      jE(m, "cola", function()
        while bE.cola and z() do
          local s = n.GetLocal()
          if s then
            local X, l = G(R.Invoke, "Currency_Get")
            local w = X and (type(l) == "table" and ((tonumber(l.Sugar) or 0))) or 0
            if w > 0 then
              local X = tonumber(getgenv().colaFillBelow) or 5
              local l = {}
              for s, z in ipairs(P(s, "ColaMachine") or {}) do
                local x = 10
                G(function()
                  local s = (z:GetDirectory()).ColaMachineComponent
                  if s and s.IngredientCapacity then
                    x = s.IngredientCapacity
                  end
                end)
                local w = 0
                G(function()
                  w = tonumber(z:GetSave("Ingredient")) or 0
                end)
                if w <= X and w < x then
                  l[#l + 1] = z
                end
              end
              if #l > 0 then
                local s = i.Character and i.Character:FindFirstChild("HumanoidRootPart")
                if s then
                  local X = s.CFrame
                  local w = 0
                  for s, X in ipairs(l) do
                    if not bE.cola or not z() then
                      break
                    end
                    local l = X.GetModel and X:GetModel()
                    if l then
                      local s = (l:GetPivot()).Position
                      x(CFrame.new(s + Vector3.new(0, 2, 3)))
                      u(1.2, .2)
                      local z = G(function()
                        return X:Invoke("ColaMachineFill")
                      end)
                      if z then
                        w += 1
                      end
                      u(.15)
                    end
                  end
                  x(X)
                  if w > 0 then
                    xE(I, "Filled " .. (w .. " cola machine(s)"), E.green)
                  else
                    xE(I, "Fill refused (check Sugar)", E.gold)
                  end
                end
              else
                xE(I, "All cola machines stocked", E.dim)
              end
            else
              xE(I, "No Sugar in inventory", E.gold)
            end
          end
          u(2)
        end
        xE(I, "")
      end, function()
        xE(I, "")
      end);
      getgenv().colaFillBelow = getgenv().colaFillBelow or 5
      local W = r.Serve:AddInput("ColaFillBelow", {
        Title = "Cola: Fill Below Level";
        Default = tostring(getgenv().colaFillBelow),
        Placeholder = "e.g. 5",
        Numeric = true;
        Finished = true;
        Callback = function(s)
          local X = tonumber(s)
          if X and X >= 0 then
            getgenv().colaFillBelow = math.floor(X)
          end
        end
      });
      getgenv().RARColaFillInput = W
      local S, Y, k = ME("Auto Fill Processing Stations", "Automatically deposits ingredients into Basic/Marble processing stations (within range).", r.Serve)
      jE(Y, "procStation", function()
        while bE.procStation and z() do
          local s = n.GetLocal()
          if s then
            local X, z = G(function()
              return require(Q.Framework["Directory"].Entity["ProcessingStationTypes"])
            end)
            if X and z then
              local X, l = G(R.Invoke, "Currency_Get")
              local x = 0
              for s, w in ipairs(P(s, "ProcessingStation") or {}) do
                if not bE.procStation then
                  break
                end
                local M = string.lower(tostring(w.DirId))
                if not M:find("fish") then
                  local s = nil
                  G(function()
                    s = w:GetSave("Mode")
                  end)
                  if s then
                    local M = 0
                    G(function()
                      M = tonumber(w:GetSave("Amount")) or 0
                    end)
                    local D = 20
                    G(function()
                      local X = z.ResolveMode(w:GetDirectory(), s)
                      if X and X.Capacity then
                        D = X.Capacity
                      end
                    end)
                    if M < D then
                      local z = X and (type(l) == "table" and ((tonumber(l[s]) or 0))) or 0
                      if z > 0 then
                        local s = G(function()
                          return w:Invoke("ProcessingStation_Fill")
                        end)
                        if s then
                          x += 1
                        end
                        u(.25)
                      end
                    end
                  end
                end
              end
              if x > 0 then
                xE(k, "Deposited into " .. (x .. " station(s)"), E.green)
              else
                xE(k, "All stations stocked", E.dim)
              end
            else
              xE(k, "ProcessingStationTypes missing", E.gold)
            end
          end
          u(.5)
        end
        xE(k, "")
      end, function()
        xE(k, "")
      end)
      local J, V, B = ME("Auto Fill Ice Cream Cart", "Automatically fills ice cream carts.", r.Serve)
      jE(V, "iceCream", function()
        while bE.iceCream and z() do
          local s = n.GetLocal()
          if s then
            for s, X in ipairs(P(s, "Appliance") or {}) do
              if X.DirId and string.find(string.lower(tostring(X.DirId)), "ice cream") then
                local s, z = 0, 15
                G(function()
                  local s = (X:GetDirectory()).IceCreamCartComponent
                  if s and s.MilkCapacity then
                    z = s.MilkCapacity
                  end
                end)
                G(function()
                  s = tonumber(X:GetSave("Milk")) or 0
                end)
                if s < z then
                  G(function()
                    return X:Invoke("IceCreamCartFill")
                  end)
                end
              end
            end
          end
          u(2)
        end
      end, function()
      end)
      local Z, U, f = ME("Auto Process Fish", "Processes fish at cutting stations without opening any GUI.", r.Fishing)
      jE(U, "processFish", function()
        while bE.processFish and z() do
          local s = n.GetLocal()
          if s then
            local X = require(Q.Framework["Client"].ClientEntity["ClientFishingBox"])
            local z = {}
            for s, l in ipairs(P(s, "FishingBox") or {}) do
              local x = X.GetFish(l) or {}
              for s, X in ipairs(x) do
                z[#z + 1] = X
              end
            end
            local l = false
            if #z > 0 then
              for s, X in ipairs(P(s, "FishCuttingStation") or {}) do
                if not bE.processFish then
                  break
                end
                if X:GetSession("CuttingFishId") == nil then
                  local s = table.remove(z, 1)
                  if s then
                    local z, x = G(function()
                      return X:Invoke("FishCuttingStation_Process", s)
                    end)
                    if z and x then
                      l = true
                    end
                    u(.25)
                  end
                end
              end
            end
            if l then
              xE(f, "Processing fish...", E.green)
            else
              xE(f, ("%d fish in boxes, %d stations idle"):format(#z, #((P(s, "FishCuttingStation") or {}))), E.dim)
            end
          end
          u(2)
        end
        xE(f, "")
      end, function()
        xE(f, "")
      end)
      do
        local s, X, x = ME("Auto Accept Influencer", "Automatically accepts the influencer's offer and pays for the post.")
        l("InfluencerAutoAccept", (R.Fired("Influencer_OfferCreated")):Connect(function()
          if not bE.influencer then
            return
          end
          G(function()
            R.Invoke("Influencer_OfferRespond", true)
          end)
        end))
        jE(X, "influencer", function()
          while bE.influencer and z() do
            local s = n.GetLocal()
            if s then
              local X = false
              for s, z in ipairs(P(s, "Customer") or {}) do
                if z.DirId and string.find(string.lower(tostring(z.DirId)), "influencer") then
                  local s = z.GetModel and z:GetModel()
                  if s then
                    for s, z in ipairs(s:GetDescendants()) do
                      if z:IsA("ProximityPrompt") and z.Enabled then
                        G(function()
                          fireproximityprompt(z)
                        end)
                        X = true
                      end
                    end
                  end
                end
              end
            else
            end
            u(2)
          end
        end, function()
        end)
      end
      do
        local s, X, l = ME("Auto Piano Play", "Plays all pianos in your restaurant every 5 seconds. No teleporting.", v)
        jE(X, "evPiano", function()
          local s = {}
          local X, x = G(require, Q.Framework["Directory"].Entity["PianoTypes"])
          if X and (type(x) == "table" and type(x.Songs) == "table") then
            for X in pairs(x.Songs) do
              s[#s + 1] = X
            end
          end
          local function w()
            if #s > 0 then
              return s[math.random(1, #s)]
            end
            return x and x.SelectedSong or nil
          end
          local function M()
            local s = {}
            local X, z = nil, nil
            G(function()
              X = require(game.ReplicatedStorage["Framework"].Client["ClientEntity"])
            end)
            G(function()
              z = require(game.ReplicatedStorage["Framework"].Client["ClientRestaurant"])
            end)
            local l = nil
            if type(z) == "table" then
              G(function()
                if type(z.GetLocal) == "function" then
                  l = z.GetLocal()
                elseif type(z.GetLocalSafe) == "function" then
                  l = z.GetLocalSafe()
                end
              end)
            end
            local x = l and l.Model
            if x then
              local z = x:FindFirstChild("Entities")
              if z then
                for z, l in ipairs(z:GetChildren()) do
                  local x, w = G(function()
                    return string.find(string.lower(l.Name), string.lower("Piano"))
                  end)
                  if x and w then
                    local z = l.Name:match("_([0-9a-f%-]+)$")
                    if z and (type(X) == "table" and type(X.GetById) == "function") then
                      local l, x = G(X.GetById, z)
                      if l and x then
                        s[#s + 1] = x
                      end
                    end
                  end
                end
              end
            end
            if #s == 0 then
              local X = l
              if X then
                for X, z in next, (X.Entity or {}) do
                  local l, x = G(function()
                    return z.IsSubclass and z:IsSubclass("Piano")
                  end)
                  if l and x then
                    s[#s + 1] = z
                  end
                end
              end
            end
            return s
          end
          while bE.evPiano and z() do
            local s = M()
            local X = 0
            local x = nil
            local D = i.Character
            local N = D and D.PrimaryPart
            for s, l in ipairs(s) do
              if not bE.evPiano or not z() then
                break
              end
              local M = w()
              if M then
                local s = nil
                local z = l.GetModel and l:GetModel()
                local w = z and ((z.PrimaryPart or z:FindFirstChildWhichIsA("BasePart", true)))
                if N and w then
                  s = N.CFrame
                  N.CFrame = w.CFrame + Vector3.new(0, 3, 0)
                  task.wait(.15)
                end
                local D, H, t = G(function()
                  return l:Invoke("PlaySong", M)
                end)
                if D and H == true then
                  X += 1
                else
                  x = D and tostring(t or "rejected") or tostring(H)
                end
                if N and s then
                  N.CFrame = s
                  task.wait(.1)
                end
              else
                x = "No song data!"
              end
            end
            if X > 0 then
              xE(l, ("Played %d piano(s)"):format(X), E.green)
            elseif #s == 0 then
              xE(l, "No pianos found", E.dim)
            else
              xE(l, x or "Failed to play", E.gold)
            end
            task.wait(5)
          end
        end, function()
        end)
      end
      do
        local s, X, l = ME("Auto Drum Beat", "Beats all ancient drums in your restaurant every 5 seconds. No teleporting.", v)
        jE(X, "evDrum", function()
          local s = 0
          local function X()
            local s = {}
            local X, z = nil, nil
            G(function()
              X = require(game.ReplicatedStorage["Framework"].Client["ClientEntity"])
            end)
            G(function()
              z = require(game.ReplicatedStorage["Framework"].Client["ClientRestaurant"])
            end)
            local l = nil
            if type(z) == "table" then
              G(function()
                if type(z.GetLocal) == "function" then
                  l = z.GetLocal()
                elseif type(z.GetLocalSafe) == "function" then
                  l = z.GetLocalSafe()
                end
              end)
            end
            local x = l and l.Model
            if x then
              local z = x:FindFirstChild("Entities")
              if z then
                for z, l in ipairs(z:GetChildren()) do
                  local x, w = G(function()
                    return string.find(string.lower(l.Name), string.lower("Ancient Drum"))
                  end)
                  if x and w then
                    local z = l.Name:match("_([0-9a-f%-]+)$")
                    if z and (type(X) == "table" and type(X.GetById) == "function") then
                      local l, x = G(X.GetById, z)
                      if l and x then
                        s[#s + 1] = x
                      end
                    end
                  end
                end
              end
            end
            if #s == 0 then
              local X = l
              if X then
                for X, z in next, (X.Entity or {}) do
                  local l, x = G(function()
                    return z.IsSubclass and z:IsSubclass("Ancient Drum")
                  end)
                  if l and x then
                    s[#s + 1] = z
                  end
                end
              end
            end
            return s
          end
          local x = nil
          if type(fireproximityprompt) == "function" then
            x = fireproximityprompt
          elseif type(fire_prompt) == "function" then
            x = fire_prompt
          elseif type(syn) == "table" and type(syn.fire_proximity_prompt) == "function" then
            x = syn.fire_proximity_prompt
          end
          local function w(s)
            local X = nil
            G(function()
              for s, z in ipairs(s:GetDescendants()) do
                if z:IsA("ProximityPrompt") then
                  X = z
                  break
                end
              end
            end)
            return X
          end
          local function M(s)
            local X = G(function()
              if x then
                x(s)
              else
                s:InputHoldBegin()
                task.wait(((s.HoldDuration or 0)) + .05)
                s:InputHoldEnd()
              end
            end)
            return X
          end
          while bE.evDrum and z() do
            G(function()
              local x = {}
              local D = {}
              local N = {}
              G(function()
                x = X()
                for s, X in ipairs(x) do
                  local z = tostring(X.Id)
                  D[z] = X
                  N[z] = true
                end
              end)
              local H = {}
              for s, X in ipairs(workspace:GetDescendants()) do
                if X:IsA("Model") and string.sub(X.Name, 1, 13) == "Ancient Drum_" then
                  local s = string.sub(X.Name, 14)
                  if N[s] then
                    H[#H + 1] = X
                  end
                end
              end
              if #H == 0 then
                G(function()
                  for s, X in ipairs(x) do
                    local z = X.GetModel and X:GetModel()
                    if z then
                      H[#H + 1] = z
                    end
                  end
                end)
              end
              if #H == 0 then
                xE(l, "No drums placed", E.dim)
                return
              end
              local t, r = nil, false
              for s, X in ipairs(H) do
                local z = nil
                G(function()
                  for s, X in ipairs(X:GetDescendants()) do
                    if X:IsA("TextLabel") and X.Name == "Timer" then
                      z = tostring(X.Text or "")
                      break
                    end
                  end
                end)
                if z then
                  local s, X, l = z:match("(%d+):(%d+):(%d+)")
                  local x = nil
                  if s then
                    x = (tonumber(s) * 3600 + tonumber(X) * 60) + tonumber(l)
                  else
                    local s, X = z:match("(%d+):(%d+)")
                    if s then
                      x = tonumber(s) * 60 + tonumber(X)
                    end
                  end
                  if x ~= nil then
                    r = true
                    if t == nil or x < t then
                      t = x
                    end
                  end
                end
              end
              if not r then
                xE(l, "No drum timer visible", E.dim)
                return
              end
              if t > 0 then
                local s = math.floor(t / 3600)
                local X = math.floor(((t % 3600)) / 60)
                xE(l, ("Next beat in %dh %02dm"):format(s, X), E.dim)
                return
              end
              local v = workspace:GetServerTimeNow()
              if v < s then
                return
              end
              local b = X()
              local g = i.Character
              local j = g and ((g.PrimaryPart or g:FindFirstChild("HumanoidRootPart")))
              if not j or #b == 0 then
                xE(l, "No drums placed", E.dim)
                return
              end
              local O = j.CFrame
              local e = 0
              for s, X in ipairs(H) do
                if not bE.evDrum or not z() then
                  break
                end
                local l = X.PrimaryPart or X:FindFirstChildWhichIsA("BasePart", true)
                if l then
                  j.CFrame = l.CFrame + Vector3.new(0, 3, 0)
                  task.wait(.8)
                  local s = w(X)
                  local z = false
                  if s then
                    z = M(s)
                  end
                  if not z then
                    local s = string.sub(X.Name, 14)
                    local z = s and D[s]
                    if z then
                      G(function()
                        q(z, { "Beat" })
                      end)
                    end
                  end
                  e += 1
                  task.wait(.15)
                end
              end
              G(function()
                j.CFrame = O
              end)
              s = v + ((e > 0 and 20 or 8))
            end)
            u(25, 5)
          end
          xE(l, "Idle", E.dim)
        end, function()
          xE(l, "Idle", E.dim)
        end)
      end
    end
    do
      local s, X, l = ME("Hide Other Restaurants", "Removes other restaurants for FPS.", Z)
      local x = Q:FindFirstChild("RAR_HiddenCache") or Instance.new("Folder")
      x.Name = "RAR_HiddenCache"
      x.Parent = Q
      jE(X, "hideOthers", function()
        while bE.hideOthers and z() do
          local s = I.GetLocal()
          local X = s and s:GetModel()
          local z = X and X.Name
          local l = workspace.__THINGS:FindFirstChild("Restaurants")
          if l and z then
            for s, X in ipairs(l:GetChildren()) do
              if X.Name ~= z then
                G(function()
                  X.Parent = x
                end)
              end
            end
          end
          u(2)
        end
        local s = workspace.__THINGS:FindFirstChild("Restaurants")
        if s then
          for X, z in ipairs(x:GetChildren()) do
            G(function()
              z.Parent = s
            end)
          end
        end
      end, function()
        local s = workspace.__THINGS:FindFirstChild("Restaurants")
        if s then
          for X, z in ipairs(x:GetChildren()) do
            G(function()
              z.Parent = s
            end)
          end
        end
      end)
    end
    do
      local s, X, l = ME("Hide Bees", "Hides the bees flying around beehives.", Z)
      local x, w, M = ME("Hide Farm Animals", "Hides chickens, cows, pigs and lambs on plots.", Z)
      local D = Q:FindFirstChild("RAR_HiddenCache")
      if not D then
        D = Instance.new("Folder")
        D.Name = "RAR_HiddenCache"
        D.Parent = Q
      end
      local N = {}
      local function H(s, X, z)
        local l = n.GetLocal()
        if not l then
          return 0
        end
        local x = 0
        for s, l in ipairs(P(l, s) or {}) do
          if z and y(l, z) then
            continue
          end
          local w, M = G(function()
            return l:GetModel()
          end)
          if not w or type(M) ~= "userdata" then
            continue
          end
          if M.Parent == D then
            if not N[M] then
              N[M] = { parent = nil, cat = X }
            end
            x = x + 1
          elseif M.Parent then
            N[M] = { parent = M.Parent; cat = X }
            G(function()
              M.Parent = D
            end)
            x = x + 1
          end
        end
        return x
      end
      local function t(s)
        for X, z in pairs(N) do
          if z.cat == s then
            G(function()
              if X and (X.Parent == D and z.parent) then
                X.Parent = z.parent
              end
            end)
            N[X] = nil
          end
        end
      end
      jE(X, "hideBees", function()
        while bE.hideBees and z() do
          local s = H("FlyingBee", "bee")
          xE(l, "Hidden: " .. (s .. " bees"), E.green)
          u(2)
        end
        t("bee")
      end, function()
        t("bee")
        xE(l, "Idle", E.dim)
      end)
      jE(w, "hideFarmAnimals", function()
        while bE.hideFarmAnimals and z() do
          local s = H("Animal", "animal", "FlyingBee")
          xE(M, "Hidden: " .. (s .. " animals"), E.green)
          u(2)
        end
        t("animal")
      end, function()
        t("animal")
        xE(M, "Idle", E.dim)
      end)
    end
    do
      local s, X, l = ME("Normal FPS Boost", "Restorable boost: disables effects, lights, decals, shadows. Toggle off to restore.", Z)
      local x, w, M = ME("More FPS", "HEAVY boost: destroys effects, textures, sky. Rejoin to get visuals back.", Z)
      local D = nil
      local N = nil
      local H = nil
      local t = nil
      local r = setmetatable({}, { __mode = "k" })
      local v = {
        ParticleEmitter = true,
        Beam = true;
        Trail = true;
        Fire = true;
        Smoke = true,
        Sparkles = true
      }
      local b = {
        ParticleEmitter = true,
        Beam = true,
        Trail = true;
        Fire = true;
        Smoke = true;
        Sparkles = true,
        Explosion = true
      }
      local function g()
        local s = {}
        for X, z in ipairs(game.Players:GetPlayers()) do
          if z.Character then
            s[z.Character] = true
          end
        end
        return s
      end
      local function j(s, X)
        local z = s.Parent
        while z and z ~= workspace do
          if X[z] then
            return true
          end
          z = z.Parent
        end
        return false
      end
      local function O(s, X)
        if X and j(s, X) then
          return
        end
        if v[s.ClassName] or s:IsA("PointLight") or s:IsA("SpotLight") or s:IsA("SurfaceLight") or s:IsA("Highlight") then
          G(function()
            if s.Enabled then
              table.insert(H.effects, { inst = s; on = s.Enabled })
              s.Enabled = false
              r[s] = true
            end
          end)
        elseif s:IsA("Texture") or s:IsA("Decal") then
          G(function()
            if s.Transparency < 1 then
              table.insert(H.decals, { inst = s, t = s.Transparency })
              s.Transparency = 1
            end
          end)
        elseif s:IsA("BasePart") and not s:IsA("Terrain") then
          G(function()
            if s.Material ~= Enum.Material.SmoothPlastic then
              table.insert(H.materials, { inst = s, m = s.Material })
              s.Material = Enum.Material.SmoothPlastic
            end
            if s.Reflectance ~= 0 then
              table.insert(H.materials, { inst = s; m = "REFLECT"; r = s.Reflectance })
              s.Reflectance = 0
            end
            if s.CastShadow then
              table.insert(H.materials, { inst = s; m = "SHADOW" })
              s.CastShadow = false
            end
          end)
        end
      end
      local function e(s, X)
        if X and j(s, X) then
          return
        end
        local z = s.ClassName
        if b[z] or s:IsA("PointLight") or s:IsA("SpotLight") or s:IsA("SurfaceLight") then
          G(function()
            s:Destroy()
          end)
        elseif s:IsA("Highlight") then
          G(function()
            s:Destroy()
          end)
        elseif s:IsA("Sky") or s:IsA("SurfaceAppearance") then
          G(function()
            s:Destroy()
          end)
        elseif s:IsA("Texture") or s:IsA("Decal") then
          G(function()
            s:Destroy()
          end)
        elseif s:IsA("MeshPart") then
          G(function()
            if s.TextureID ~= "" then
              s.TextureID = ""
            end
          end)
          G(function()
            if s.Material ~= Enum.Material.SmoothPlastic then
              s.Material = Enum.Material.SmoothPlastic
            end
            if s.Reflectance ~= 0 then
              s.Reflectance = 0
            end
            if s.CastShadow then
              s.CastShadow = false
            end
          end)
        elseif s:IsA("SpecialMesh") then
          G(function()
            if s.TextureId ~= "" then
              s.TextureId = ""
            end
          end)
        elseif s:IsA("BasePart") and not s:IsA("Terrain") then
          G(function()
            if s.Material ~= Enum.Material.SmoothPlastic then
              s.Material = Enum.Material.SmoothPlastic
            end
            if s.Reflectance ~= 0 then
              s.Reflectance = 0
            end
            if s.CastShadow then
              s.CastShadow = false
            end
          end)
        end
      end
      local function L(s, X)
        if D == "normal" then
          O(s, X)
        elseif D == "heavy" then
          e(s, X)
        end
      end
      local function h(s)
        G(function()
          if setfpscap then
            setfpscap(999)
          end
        end)
        G(function()
          s.renderQuality = (settings()).Rendering["QualityLevel"]
        end)
        G(function()
          (settings()).Rendering["QualityLevel"] = Enum.QualityLevel.Level01
        end)
        G(function()
          local X = (UserSettings()):GetService("UserGameSettings")
          s.savedQuality = X.SavedQualityLevel
          X.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
        end)
        local X = game:GetService("Lighting")
        s.lighting = { X; X.GlobalShadows; X.FogEnd; X.Brightness }
        G(function()
          X.GlobalShadows = false
        end)
        G(function()
          X.FogEnd = 9000000000.0
        end)
        G(function()
          s.env = { X.EnvironmentDiffuseScale; X.EnvironmentSpecularScale }
          X.EnvironmentDiffuseScale = 0
          X.EnvironmentSpecularScale = 0
        end)
        G(function()
          s.tech = X.Technology
          X.Technology = Enum.Technology.Compatibility
        end)
        return X
      end
      local function i(s)
        local X = workspace:FindFirstChildOfClass("Terrain")
        if not X then
          return
        end
        s.terrain = { X }
        G(function()
          local z = s.terrain
          z[2] = X.WaterWaveSize
          z[3] = X.WaterWaveSpeed
          z[4] = X.WaterReflectance
          z[5] = X.WaterTransparency
          z[6] = X.Decoration
        end)
        G(function()
          X.WaterWaveSize = 0
          X.WaterWaveSpeed = 0
          X.WaterReflectance = 0
          X.WaterTransparency = 1
          G(function()
            X.Decoration = false
          end)
        end)
      end
      local function m(s)
        if s.savedQuality then
          G(function()
            ((UserSettings()):GetService("UserGameSettings")).SavedQualityLevel = s.savedQuality
          end)
        end
        if s.renderQuality then
          G(function()
            (settings()).Rendering["QualityLevel"] = s.renderQuality
          end)
        end
        if s.lighting then
          G(function()
            s.lighting[1].GlobalShadows = s.lighting[2]
          end)
          G(function()
            s.lighting[1].FogEnd = s.lighting[3]
          end)
          G(function()
            s.lighting[1].Brightness = s.lighting[4]
          end)
          if s.tech then
            G(function()
              s.lighting[1].Technology = s.tech
            end)
          end
        end
        if s.env then
          G(function()
            s.lighting[1].EnvironmentDiffuseScale = s.env[1]
          end)
          G(function()
            s.lighting[1].EnvironmentSpecularScale = s.env[2]
          end)
        end
        if s.atmos then
          G(function()
            s.atmos[1].Density = s.atmos[2]
          end)
          G(function()
            s.atmos[1].Haze = s.atmos[3]
          end)
        end
        if s.terrain then
          G(function()
            local X = s.terrain[1]
            X.WaterWaveSize = s.terrain[2]
            X.WaterWaveSpeed = s.terrain[3]
            X.WaterReflectance = s.terrain[4]
            X.WaterTransparency = s.terrain[5]
          end)
          if s.terrain[6] ~= nil then
            G(function()
              s.terrain[1].Decoration = s.terrain[6]
            end)
          end
        end
      end
      local function Q(s, X)
        local z = workspace:GetDescendants()
        task.spawn(function()
          local l, x = 1, #z
          while l <= x and D == s do
            local s = math.min(l + 499, x)
            for s = l, s, 1 do
              L(z[s], X)
            end
            l = s + 1
            task.wait(.03)
          end
        end)
        N = workspace.DescendantAdded:Connect(function(s)
          L(s, g())
        end)
      end
      local R, I, W, S
      R = function()
        if D == "normal" then
          return
        end
        if D == "heavy" then
          S()
        end
        D = "normal"
        local s = { effects = {}, decals = {}; materials = {} }
        H = s
        local X = h(s)
        local z = X:FindFirstChildOfClass("Atmosphere")
        if z then
          s.atmos = { z; z.Density; z.Haze }
          G(function()
            z.Density = 0
          end)
          G(function()
            z.Haze = 0
          end)
        end
        local x = workspace:FindFirstChildOfClass("Clouds")
        if x then
          s.clouds = { x, x.Cover; x.Density, x.Enabled }
          G(function()
            x.Cover = 0
          end)
          G(function()
            x.Density = 0
          end)
          G(function()
            x.Enabled = false
          end)
        end
        i(s)
        Q("normal", g())
        xE(l, "on — toggle off to restore", E.green)
      end
      I = function()
        if D ~= "normal" then
          return
        end
        D = nil
        if N then
          N:Disconnect()
          N = nil
        end
        local s = H
        H = nil
        for s in pairs(r) do
          r[s] = nil
        end
        if not s then
          return
        end
        m(s)
        if s.clouds then
          G(function()
            s.clouds[1].Cover = s.clouds[2]
          end)
          G(function()
            s.clouds[1].Density = s.clouds[3]
          end)
          G(function()
            s.clouds[1].Enabled = s.clouds[4]
          end)
        end
        for s, X in ipairs(s.effects) do
          G(function()
            X.inst["Enabled"] = X.on
          end)
        end
        for s, X in ipairs(s.decals) do
          G(function()
            X.inst["Transparency"] = X.t
          end)
        end
        for s, X in ipairs(s.materials) do
          G(function()
            if X.m == "REFLECT" then
              X.inst["Reflectance"] = X.r or .3
            elseif X.m == "SHADOW" then
              X.inst["CastShadow"] = true
            else
              X.inst["Material"] = X.m
            end
          end)
        end
        xE(l, "off — visuals restored", E.dim)
      end
      W = function()
        if D == "heavy" then
          return
        end
        if D == "normal" then
          I()
        end
        D = "heavy"
        local s = {}
        t = s
        local X = h(s)
        local z = X:FindFirstChildOfClass("Atmosphere")
        if z then
          s.atmos = { z, z.Density, z.Haze }
          G(function()
            z.Density = 0
          end)
          G(function()
            z.Haze = 0
          end)
        end
        local l = workspace:FindFirstChildOfClass("Clouds")
        if l then
          G(function()
            l:Destroy()
          end)
        end
        for s, X in ipairs(X:GetChildren()) do
          if X:IsA("PostEffect") or X:IsA("Sky") then
            G(function()
              X:Destroy()
            end)
          end
        end
        i(s)
        Q("heavy", g())
        xE(M, "on (heavy) — rejoin to restore visuals", E.green)
      end
      S = function()
        if D ~= "heavy" then
          return
        end
        D = nil
        if N then
          N:Disconnect()
          N = nil
        end
        local s = t
        t = nil
        if not s then
          return
        end
        m(s)
        xE(M, "off — lighting/quality restored; rejoin for full visuals", E.dim)
      end
      jE(X, "fpsBoost", function()
        if bE.moreFps then
          G(function()
            T.moreFps:SetValue(false)
          end)
        end
        R()
      end, function()
        I()
      end)
      jE(w, "moreFps", function()
        if bE.fpsBoost then
          G(function()
            T.fpsBoost:SetValue(false)
          end)
        end
        W()
      end, function()
        S()
      end)
      task.spawn(function()
        while z() do
          if D == "normal" then
            for s in pairs(r) do
              G(function()
                if s.Enabled and s.Parent then
                  s.Enabled = false
                end
              end)
            end
          end
          task.wait(1.5)
        end
      end)
    end
    local g_ = "RARHelper"
    if type(makefolder) == "function" and not isfolder(g_) then
      G(makefolder, g_)
    end
    do
      local s = g:AddParagraph({ Title = "Summary"; Content = "Secret Gnomes: Checking...\nQuests: Checking..." })
      task.spawn(function()
        while z() do
          G(function()
            local X, z
            local l = require(game.ReplicatedStorage["Framework"].Client["Saving"])
            local x = require(game.ReplicatedStorage["Framework"].Client["QuestCmds"])
            local w = l.Get()
            local M = w and w.SecretGnomesCollected or {}
            local D = 0
            for s in pairs(M) do
              D = D + 1
            end
            local N = workspace.__THINGS:FindFirstChild("Gnomes")
            local H = N and #N:GetChildren() or 15
            if H < D then
              H = D
            end
            if D >= 15 or (H > 0 and D >= H) then
              X = "Secret Gnomes: All Collected! ✓"
            else
              X = string.format("Secret Gnomes: %d / %d Collected", D, H)
            end
            local t = x.GetActiveQuests() or {}
            if #t == 0 or x.HasCompletedAll() then
              z = "Quests: All Quests Completed & Claimed! ✓"
            else
              z = string.format("Quests: %d Active Quest(s) Remaining", #t)
            end
            s:SetDesc(X .. ("\n" .. z))
          end)
          u(2)
        end
      end)
      local X, l, w = ME("Auto Collect Secret Gnomes", "Auto collect secret gnomes from the map.", g)
      jE(l, "gnomes", function()
        local s, X = G(require, game.ReplicatedStorage["Framework"].Client["Saving"])
        while bE.gnomes and z() do
          local z = workspace.__THINGS:FindFirstChild("Gnomes")
          local l = s and (X and X.Get()) or {}
          local w = l.SecretGnomesCollected or {}
          if z then
            local s = game.Players.LocalPlayer
            local X = s.Character
            local l = X and X:FindFirstChild("HumanoidRootPart")
            local M = l and l.CFrame
            for s, X in ipairs(z:GetChildren()) do
              if not bE.gnomes then
                break
              end
              local z = X:GetAttribute("Id")
              if z and (not w[tostring(z)] and not w[tonumber(z)]) then
                local s = X:FindFirstChildOfClass("ClickDetector", true)
                if s then
                  if l then
                    x(X:GetPivot())
                    u(.05)
                  end
                  G(function()
                    fireclickdetector(s)
                  end)
                  u(.05)
                end
              end
            end
            if l and M then
              x(M)
            end
          end
          task.wait(3)
        end
      end, function()
      end)
      local M, D, N = ME("Auto Claim Playtime Rewards", "Claims playtime rewards automatically.", g)
      jE(D, "playtimeRewards", function()
        local s, X = G(require, game.ReplicatedStorage["Framework"].Client["PlaytimeCmds"])
        while bE.playtimeRewards and z() do
          if s and X then
            G(function()
              if X.HasAnyClaimableReward() then
                X.ClaimAll()
              end
            end)
          end
          u(30)
        end
      end, function()
      end)
      local H, t, r = ME("Auto Claim Wishing Fountain", "Teleports to fountain decor, makes daily wish, and teleports back.", g)
      jE(t, "wishingWell", function()
        local s, X
        G(function()
          s = require(game.ReplicatedStorage["Framework"].Client["ClientRestaurant"])
          X = require(game.ReplicatedStorage["Framework"].Client["Saving"])
        end)
        while bE.wishingWell and z() do
          if not s or not X then
            u(5) continue
          end
          G(function()
            local z = s.GetLocal()
            if not z then
              xE(r, "No restaurant", E.red)
              return
            end
            local l = tonumber((X.Get()).WishingFountainLastWish) or 0
            local w = os.time() - l
            local M = 86400
            if w < M then
              local s = M - w
              local X = math.floor(s / 3600)
              local z = math.floor(((s % 3600)) / 60)
              if X > 0 then
                xE(r, ("Wish in %dh %dm"):format(X, z), E.dim)
              else
                xE(r, ("Wish in %dm"):format(z), E.dim)
              end
              return
            end
            local D, N, H
            local t = z.GetModel and z:GetModel()
            if t then
              for s, X in ipairs(t:GetDescendants()) do
                if X:IsA("Model") and ((X.Name:find("Wishing Fountain") or X.Name:find("wishingwell"))) then
                  D = X
                  N = X:FindFirstChild("Interact") or X.PrimaryPart or X:FindFirstChildWhichIsA("BasePart", true)
                  H = X:FindFirstChildWhichIsA("ProximityPrompt", true)
                  if N then
                    break
                  end
                end
              end
            end
            if not N and z.Entity then
              for s, X in pairs(z.Entity) do
                if X.DirId == "Wishing Fountain" or (X.Dir and X.Dir["_id"] == "Wishing Fountain") then
                  local s = X.GetModel and X:GetModel()
                  if s then
                    D = s
                    N = s:FindFirstChild("Interact") or s.PrimaryPart or s:FindFirstChildWhichIsA("BasePart", true)
                    H = s:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if N then
                      break
                    end
                  end
                end
              end
            end
            if not N then
              xE(r, "No fountain placed", E.dim)
              return
            end
            local v = i.Character and i.Character:FindFirstChild("HumanoidRootPart")
            if not v then
              xE(r, "No character", E.red)
              return
            end
            local b = v.CFrame
            local g = N.Position
            local j = CFrame.lookAt(g + Vector3.new(0, 1.5, 3), g)
            xE(r, "Teleporting...", E.cyan)
            x(j)
            u(.4, .1)
            xE(r, "Wishing...", E.yellow)
            if H then
              local s = H.MaxActivationDistance
              local X = H.RequiresLineOfSight
              local z = H.HoldDuration
              local l = H.Enabled
              H.Enabled = true
              H.MaxActivationDistance = 9999
              H.RequiresLineOfSight = false
              H.HoldDuration = 0
              G(function()
                fireproximityprompt(H)
              end)
              G(function()
                fireproximityprompt(H, 0)
              end)
              u(.1)
              G(function()
                fireproximityprompt(H)
              end)
              H.MaxActivationDistance = s
              H.RequiresLineOfSight = X
              H.HoldDuration = z
              H.Enabled = l
            end
            G(function()
              if z.Entity then
                for s, X in pairs(z.Entity) do
                  if X.DirId == "Wishing Fountain" or (X.Dir and X.Dir["_id"] == "Wishing Fountain") then
                    q(X, { "WishingFountainBuy", "Claim Reward"; "Make a Wish", "Wish" })
                  end
                end
              end
            end)
            u(.5, .1)
            xE(r, "Returning...", E.cyan)
            x(b)
            xE(r, "Wish Claimed! ✓", E.green)
          end)
          u(30)
        end
      end, function()
        xE(r, "Idle", E.dim)
      end)
      local v, b, j = ME("Auto Claim Quests", "Claims all completed quests.", g)
      j.Visible = false
      jE(b, "qClaim", function()
        local s, X, l, x
        G(function()
          s = require(game.ReplicatedStorage["Framework"].Client["QuestCmds"])
          X = require(game.ReplicatedStorage["Framework"].Client["GoalCmds"])
          l = require(game.ReplicatedStorage["Framework"].Client["Saving"])
          x = require(game.ReplicatedStorage["Framework"].Client["Network"])
        end)
        while bE.qClaim and z() do
          local z = 0
          local w = 0
          if s and (X and (l and x)) then
            G(function()
              local l = X.GetGoals()
              if not l then
                return
              end
              for X, l in pairs(l) do
                if not bE.qClaim then
                  break
                end
                if l.Tag1 ~= "Milestone" and l.Completed then
                  local M = s.QuestFromGoal(l)
                  local D = false
                  if M then
                    if s.IsClaimable(M) then
                      local z, l = G(function()
                        return s.ClaimReward(M, X)
                      end)
                      D = z and (l ~= nil and l ~= false)
                    end
                  else
                    local s, z = G(function()
                      return x.Invoke("Goals_Claim", X)
                    end)
                    D = s and (z ~= nil and z ~= false)
                  end
                  if D then
                    z += 1
                    task.wait(.15)
                  else
                    w += 1
                  end
                end
              end
            end)
          end
          if z > 0 then
            xE(j, "Claimed " .. (z .. ((w > 0 and (" / " .. (w .. " failed")) or ""))), E.green)
            u(3)
          elseif w > 0 then
            xE(j, w .. " claim(s) failed", E.gold)
            u(10)
          else
            xE(j, "Nothing to claim")
            u(10)
          end
        end
      end, function()
      end)
      local O, e, L = ME("Auto Claim Milestones", "Automatically claims completed milestone rewards.", g)
      L.Visible = false
      jE(e, "mClaim", function()
        local s, X = G(require, game.ReplicatedStorage["Framework"].Client["MilestoneCmds"])
        while bE.mClaim and z() do
          local z = false
          if s and X then
            G(function()
              local s = X.GetCategories()
              for s, l in ipairs(s) do
                if not bE.mClaim then
                  break
                end
                local x = X.GetMilestonesInCategory(l)
                for s, l in ipairs(x) do
                  if not bE.mClaim then
                    break
                  end
                  if X.IsClaimable(l) then
                    local s = G(function()
                      return X.ClaimReward(l)
                    end)
                    if s then
                      z = true
                      task.wait(.1)
                    end
                  end
                end
              end
            end)
          end
          if z then
            u(3)
          else
            u(10)
          end
        end
      end, function()
      end)
      local function h(s)
        if not s then
          return false
        end
        if typeof(firesignal) == "function" then
          local X = G(function()
            firesignal(s.Activated)
          end)
          if X then
            return true
          end
        end
        local X = G(function()
          local X = game:GetService("VirtualInputManager")
          local z = s.AbsolutePosition + s.AbsoluteSize / 2
          X:SendMouseButtonEvent(z.X, z.Y, 0, true, game, 1)
          task.wait(.05)
          X:SendMouseButtonEvent(z.X, z.Y, 0, false, game, 1)
        end)
        return X
      end
      local function m(s)
        local X = game.Players.LocalPlayer
        local z = X and X:FindFirstChild("PlayerGui")
        local l = {}
        if z then
          for s, X in ipairs(z:GetDescendants()) do
            if X.Name == "Options" then
              l[X] = true
            end
          end
        end
        local function x()
          if not z then
            return nil
          end
          for s, X in ipairs(z:GetDescendants()) do
            if X.Name == "Options" and not l[X] then
              for s, z in ipairs(X:GetChildren()) do
                if z.Name:match("^Entry%d+$") and ((z:IsA("TextButton") or z:IsA("ImageButton"))) then
                  return X
                end
              end
            end
          end
          return nil
        end
        local w = x()
        local M = os.clock()
        while not w and os.clock() - M < 3 do
          task.wait(.15)
          w = x()
        end
        if not w then
          if s then
            xE(s, "No dialog opened", E.dim)
          end
          return false, "no-dialog"
        end
        local D = {}
        for s, X in ipairs(w:GetChildren()) do
          local z = X.Name:match("^Entry(%d+)$")
          if z and ((X:IsA("TextButton") or X:IsA("ImageButton"))) then
            local s = ""
            G(function()
              local z = X:FindFirstChild("Text")
              if z and z:IsA("TextLabel") then
                s = tostring(z.Text or "")
              end
            end)
            D[tonumber(z)] = { btn = X; text = s }
          end
        end
        local N = 0
        for s in pairs(D) do
          N = N + 1
        end
        if N == 0 then
          if s then
            xE(s, "Dialog empty", E.dim)
          end
          return false, "empty-dialog"
        end
        local H, t = nil, ""
        for s = 1, 12, 1 do
          local X = D[s]
          if X then
            local s = X.text:lower()
            if s:find("accept") or s:find("yes") or s:find("take") or s:find("start") then
              H, t = X.btn, X.text
              break
            end
          end
        end
        if not H and D[1] then
          H, t = D[1].btn, D[1].text
        end
        if not H then
          if s then
            xE(s, "Dialog empty", E.dim)
          end
          return false, "empty-dialog"
        end
        if s then
          xE(s, "Answering: " .. (tostring(t)):sub(1, 28), E.yellow)
        end
        h(H)
        local r = false
        local v = os.clock()
        while os.clock() - v < 3 do
          local s, X = G(function()
            return (require(game.ReplicatedStorage["Framework"].Client["GoalCmds"])).GetGoals()
          end)
          if s and X then
            for s, X in pairs(X) do
              local z = (tostring(X.Tag1 or X.Tag or "")):lower()
              if z:find("taco") or ((tostring(s)):lower()):find("taco") then
                r = true
                break
              end
            end
          end
          if r then
            break
          end
          task.wait(.25)
        end
        if not r then
          if s then
            xE(s, "Clicked '" .. ((tostring(t)):sub(1, 20) .. "' — no goal"), E.red)
          end
          return false, t
        end
        return true, t
      end
      local function Q(s, X, z, l)
        local w = i.Character or game.Players.LocalPlayer["Character"]
        local M = w and w:FindFirstChild("HumanoidRootPart")
        if not M then
          if X then
            xE(X, "No character", E.red)
          end
          return false
        end
        local D = (workspace:FindFirstChild("__DEBRIS") and workspace.__DEBRIS:FindFirstChild(s)) or workspace:FindFirstChild(s, true)
        if not D then
          if X then
            xE(X, "NPC not spawned", E.dim)
          end
          return false
        end
        local N = D:FindFirstChild("HumanoidRootPart") or D.PrimaryPart or D:FindFirstChildWhichIsA("BasePart", true)
        local H = D:FindFirstChildWhichIsA("ProximityPrompt", true)
        if not N then
          if X then
            xE(X, "NPC has no part", E.red)
          end
          return false
        end
        local t = M.CFrame
        local r = N.Position + Vector3.new(0, 0, 3.5)
        local v = Instance.new("Part")
        v.Size = Vector3.new(14, 1, 14)
        v.Position = r - Vector3.new(0, 3.5, 0)
        v.Anchored = true
        v.CanCollide = true
        v.Transparency = 1
        v.Parent = workspace;
        (game:GetService("Debris")):AddItem(v, 6)
        if X then
          xE(X, "Teleporting...", E.cyan)
        end
        x(CFrame.lookAt(r, N.Position))
        u(.4, .1)
        if X then
          xE(X, "Claiming / Interacting...", E.yellow)
        end
        local b = nil
        if H then
          local s = H.MaxActivationDistance
          local z = H.RequiresLineOfSight
          local x = H.HoldDuration
          local w = H.Enabled
          H.Enabled = true
          H.MaxActivationDistance = 9999
          H.RequiresLineOfSight = false
          H.HoldDuration = 0
          if l then
            G(function()
              fireproximityprompt(H)
            end)
          else
            G(function()
              fireproximityprompt(H)
            end)
            G(function()
              fireproximityprompt(H, 0)
            end)
            u(.1)
            G(function()
              fireproximityprompt(H)
            end)
          end
          H.MaxActivationDistance = s
          H.RequiresLineOfSight = z
          H.HoldDuration = x
          H.Enabled = w
          task.spawn(function()
            for s = 1, 20, 1 do
              task.wait(.1)
              local X = i:FindFirstChild("PlayerGui")
              local z = X and X:FindFirstChild("Message")
              local l = z and z:FindFirstChild("Message")
              if l and l.Visible then
                l.Visible = false
                l:Destroy()
                break
              end
            end
          end)
          if l then
            b = m(X)
          end
        end
        G(function()
          local s = require(game.ReplicatedStorage["Framework"].Client["GoalCmds"])
          local X = require(game.ReplicatedStorage["Framework"].Client["Network"])
          local z = s.GetGoals()
          if z then
            for s, z in pairs(z) do
              if z.Completed then
                G(function()
                  X.Invoke("Goals_Claim", s)
                end)
              end
            end
          end
        end)
        u(.5, .1)
        if X then
          xE(X, "Returning...", E.cyan)
        end
        x(t)
        if l and b ~= nil then
          if b then
            if X then
              xE(X, ((z or "Claimed")) .. "! ✓", E.green)
            end
            return true
          end
          return false
        end
        if X then
          xE(X, ((z or "Claimed")) .. "! ✓", E.green)
        end
        return true
      end
      local function R(s)
        local X = (workspace:FindFirstChild("__DEBRIS") and workspace.__DEBRIS:FindFirstChild(s)) or workspace:FindFirstChild(s, true)
        if not X then
          return false, "NPC not spawned"
        end
        local z = X:FindFirstChildWhichIsA("ProximityPrompt", true)
        if not z then
          return false, "No prompt"
        end
        if not z.Enabled then
          return false, "On Cooldown"
        end
        return true, z
      end
      local I, W, S = ME("Auto Accept Daily Quest", "Teleports to Daily Quest NPC to accept new daily quest, then returns.", g)
      local n = 0
      jE(W, "autoDailyQuest", function()
        local s = require(game.ReplicatedStorage["Framework"].Client["Saving"])
        local X = require(game.ReplicatedStorage["Framework"].Client["GoalCmds"])
        xE(S, "Waiting for data...", E.dim)
        local l = os.clock()
        repeat
          task.wait(.5)
          local z = X.GetGoals()
          local x = G(function()
            return s.Get()
          end)
          if z and next(z) ~= nil then
            break
          end
        until (os.clock() - l) > 15 or not bE.autoDailyQuest
        while bE.autoDailyQuest and z() do
          G(function()
            local z = os.time()
            local l = 86400 - (z % 86400)
            local x = X.GetGoals() or {}
            local w = false
            local M = false
            local D = ""
            for s, X in pairs(x) do
              local z = (tostring(X.Tag1 or X.Tag or "")):lower()
              local l = (tostring(s)):lower()
              if z:find("daily") or l:find("daily") then
                w = true
                if X.Completed then
                  M = true
                  break
                else
                  if X.Progress and X.MaxProgress then
                    D = (" (%d/%d)"):format(X.Progress, X.MaxProgress)
                  end
                end
              end
            end
            if not next(x) then
              xE(S, "Waiting for data...", E.dim)
              return
            end
            if M then
              xE(S, "Completed (Claiming...)", E.green)
              return
            end
            if w then
              xE(S, "In Progress" .. D, E.dim)
              return
            end
            local N, H = G(function()
              return s.Get()
            end)
            if N and H then
              local s = tonumber(H.DailyQuestNextAt) or 0
              local X = s - z
              if X > 0 then
                local s = math.floor(X / 3600)
                local z = math.floor(((X % 3600)) / 60)
                if s > 0 then
                  xE(S, ("Next daily in %dh %dm"):format(s, z), E.dim)
                else
                  xE(S, ("Next daily in %dm"):format(z), E.dim)
                end
                return
              end
            end
            if z < n then
              local s = n - z
              xE(S, ("Next daily in %dm"):format(math.floor(s / 60)), E.dim)
              return
            end
            local t = R("DailyQuestNPC")
            if not t then
              local s = math.floor(l / 3600)
              local X = math.floor(((l % 3600)) / 60)
              xE(S, ("Next daily in %dh %dm"):format(s, X), E.dim)
              return
            end
            local r = Q("DailyQuestNPC", S, "Daily Quest Accepted")
            if r then
              n = z + 300
            else
              local s = math.floor(l / 3600)
              local X = math.floor(((l % 3600)) / 60)
              xE(S, ("Next daily in %dh %dm"):format(s, X), E.dim)
            end
          end)
          u(25, 5)
        end
      end, function()
        xE(S, "Idle", E.dim)
      end)
      local Y, k, J = ME("Auto Accept Taco Quest", "Teleports to Taco Tuesday NPC to accept quest, then returns.", g)
      jE(k, "autoTacoQuest", function()
        xE(J, "Waiting for data...", E.dim)
        local s = require(game.ReplicatedStorage["Framework"].Client["GoalCmds"])
        local X, l = G(function()
          return require(game.ReplicatedStorage["Framework"].Client["Saving"])
        end)
        local x = os.clock()
        local w = false
        repeat
          task.wait(.5)
          local X = s.GetGoals()
          if X and next(X) ~= nil then
            w = true
          end
        until w or (os.clock() - x) > 15 or not bE.autoTacoQuest
        while bE.autoTacoQuest and z() do
          G(function()
            local z = os.time()
            local x = s.GetGoals() or {}
            local w = false
            local M = false
            local D = ""
            for s, X in pairs(x) do
              local z = (tostring(X.Tag1 or X.Tag or "")):lower()
              local l = (tostring(s)):lower()
              if z:find("taco") or l:find("taco") then
                w = true
                if X.Completed then
                  M = true
                  break
                else
                  if X.Progress and X.MaxProgress then
                    D = (" (%d/%d)"):format(X.Progress, X.MaxProgress)
                  end
                end
              end
            end
            if not next(x) then
              xE(J, "Waiting for data...", E.dim)
              return
            end
            if M then
              xE(J, "Completed (Claiming...)", E.green)
              return
            end
            if w then
              xE(J, "In Progress" .. D, E.dim)
              return
            end
            local N = 604800
            if X and l then
              local s, X = G(function()
                return l.Get()
              end)
              if s and X then
                local s = tonumber(X.TacoTuesdayCycle) or 0
                if s > 0 then
                  local X = s + N
                  local l = X - z
                  if l > 0 then
                    local s = math.floor(l / 86400)
                    local X = math.floor(((l % 86400)) / 3600)
                    xE(J, ("Next taco event in %dd %dh"):format(s, X), E.dim)
                    return
                  end
                end
              end
            end
            local H = R("TacoTuesdayQuestNPC")
            if not H then
              xE(J, "Event Inactive / Done", E.dim)
              return
            end
            Q("TacoTuesdayQuestNPC", J, "Taco Quest Accepted", true)
          end)
          u(30, 5)
        end
      end, function()
        xE(J, "Idle", E.dim)
      end)
      g:AddButton({
        Title = "Teleport & Interact Daily Quest";
        Description = "Instant one-click: Teleports to Daily NPC, interacts, and returns.";
        Icon = "navigation";
        Callback = function()
          task.spawn(function()
            Q("DailyQuestNPC", S, "Daily Quest Interacted")
          end)
        end
      })
      g:AddButton({
        Title = "Teleport & Interact Taco NPC",
        Description = "Instant one-click: Teleports to Taco NPC, interacts, and returns.",
        Icon = "navigation";
        Callback = function()
          task.spawn(function()
            Q("TacoTuesdayQuestNPC", J, "Taco Quest Interacted", true)
          end)
        end
      })
    end
    do
      local s, X, l = ME("Auto Collect Produce", "Automatically collects produce from animals.", j)
      jE(X, "produce", function()
        while bE.produce and z() do
          local s = n.GetLocal()
          if s then
            for s, X in ipairs(P(s, "Animal") or {}) do
              sE(X)
            end
            for s, X in ipairs(P(s, "Feeder") or {}) do
              sE(X, "take")
              sE(X, "collect")
              sE(X, "harvest")
            end
          end
          u(.25)
        end
      end, function()
      end)
      local x, w, M = ME("Auto Fill Feeders", "Automatically fills empty feeders.", j)
      jE(w, "feeders", function()
        while bE.feeders and z() do
          local s = n.GetLocal()
          if s then
            for s, X in ipairs(P(s, "Feeder") or {}) do
              local z = false
              local l = X.GetModel and X:GetModel()
              if l then
                local s = l:FindFirstChild("Amount", true)
                if s and s:IsA("TextLabel") then
                  local X, l = s.Text:match("(%d+)/(%d+)")
                  if X and (l and tonumber(X) >= tonumber(l)) then
                    z = true
                  end
                end
              end
              if not z then
                sE(X, "fill")
              end
            end
          end
          u(.25)
        end
      end, function()
      end)
      local D, N, H = ME("Auto Make Meat", "Automatically processes animals into meat.", j)
      jE(N, "meat", function()
        while bE.meat and z() do
          local s = n.GetLocal()
          if s then
            local X = {
              ["Animal Shack"] = true,
              ["Animal Barn"] = true,
              ["Animal Factory"] = true,
              ["Animal Processor"] = true
            }
            local z, l = G(function()
              return s.Entity or {}
            end)
            if z and type(l) == "table" then
              for s, z in next, l do
                G(function()
                  local s = z.GetModel and z:GetModel()
                  local l = (s and s.Name) or z.Name or z.BaseId
                  if l and X[l] then
                    sE(z)
                  end
                end)
              end
            end
          end
          u(2)
        end
      end, function()
      end)
    end
    local j_ = {}
    local O_ = {}
    do
      local s, X = NE("Auto Buy Normal Shop", "Automatically buys targeted items from normal shop.", O)
      local l = {}
      local x = HE(s.Container, {
        Name = "ShopItems",
        SearchPlaceholder = "Search normal shop to buy...";
        Height = 160,
        LayoutOrder = 1;
        OnOpen = function(s)
          local X = {}
          G(function()
            local s = require(game.ReplicatedStorage["Framework"].Universal["Shop"])
            local z = s.Get(game.Players.LocalPlayer)
            if z and z.OffersSorted then
              for s, z in ipairs(z.OffersSorted) do
                if z.ItemDir and z.ItemDir["_id"] then
                  table.insert(X, z.ItemDir["_id"])
                end
              end
            end
          end)
          if #X > 0 then
            tE(s, X)
          end
        end,
        OnChanged = function(s)
          j_ = {}
          for s, X in pairs(s) do
            if X then
              j_[s] = true
            end
          end
        end
      });
      getgenv().updateShopTargetItemsUI = function()
        local s = {}
        for X, z in pairs(j_ or {}) do
          if z then
            s[X] = true
          end
        end
        x.SetSelection(s)
      end;
      (coroutine.wrap(function()
        u(2)
        local s, X = G(function()
          return require(game.ReplicatedStorage["Framework"].Universal["Shop"])
        end)
        if s and X then
          local s = X.Get(game.Players.LocalPlayer)
          if s and s.OffersSorted then
            for s, X in ipairs(s.OffersSorted) do
              if X.ItemDir and X.ItemDir["_id"] then
                table.insert(l, X.ItemDir["_id"])
              end
            end
          end
        end
        table.sort(l)
        x.SetValues(l)
      end))()
      local w, M, D = ME("Auto Buy Selected Shop Items", "", s)
      jE(M, "shopBuy", function()
        while bE.shopBuy and z() do
          G(function()
            local s = require(game.ReplicatedStorage["Framework"].Client["ShopCmds"])
            local X = require(game.ReplicatedStorage["Framework"].Universal["Shop"])
            local z = X.Get(game.Players.LocalPlayer)
            if z and z.OffersSorted then
              for X, z in ipairs(z.OffersSorted) do
                if z.ItemDir and (z.ItemDir["_id"] and j_[z.ItemDir["_id"]]) then
                  s.Purchase(z.ItemDir["_id"])
                end
              end
            end
          end)
          u(5)
        end
      end, function()
        xE(D, "Idle", E.dim)
      end)
      rE(s.Container, { ["Auto Buy Selected Shop Items"] = 2 })
    end
    do
      local s, X = NE("Auto Buy Bait", "Automatically buys bait from the Bait Merchant.", O)
      local l, x, w = ME("Auto Buy Bait Fish", "", s)
      local M = { "Common Bait", "Uncommon Bait"; "Rare Bait"; "Premium Bait" }
      local D = s:AddDropdown("BaitTierSelect", {
        Title = "Bait Tiers to Buy",
        Values = M,
        Multi = true;
        Default = { ["Common Bait"] = true, ["Uncommon Bait"] = true }
      })
      D:OnChanged(function(s)
        for s in pairs(gE) do
          gE[s] = nil
        end
        for s, X in pairs(s) do
          if X then
            gE[s] = true
          end
        end
      end);
      getgenv().updateBaitTierUI = function()
        local s = {}
        for X, z in ipairs(M) do
          if gE[z] then
            s[z] = true
          end
        end
        D:SetValue(s)
      end
      bE.autoBuyBait = false
      jE(x, "autoBuyBait", function()
        xE(w, "", E.green)
      end, function()
        xE(w, "", E.dim)
      end)
      rE(s.Container, { ["Auto Buy Bait Fish"] = 1, ["Bait Tiers to Buy"] = 2 })
      local function N(s)
        local X = 0
        G(function()
          local z, l = G(R.Invoke, "Currency_Get")
          if z and (type(l) == "table" and tonumber(l[s])) then
            X = tonumber(l[s])
            return
          end
          local x = require(game.ReplicatedStorage["Framework"].Client["Saving"])
          local w = x.Get and (x.Get()).Inventory
          if type(w) == "table" and tonumber(w[s]) then
            X = tonumber(w[s])
          end
        end)
        return X
      end
      task.spawn(function()
        while z() do
          G(function()
            if bE.autoBuyBait then
              local s = game:GetService("ReplicatedStorage")
              local X, z = G(function()
                return require(s.Framework["Client"].MerchantsCmds)
              end)
              if not X or type(z) ~= "table" then
                xE(w, "MerchantsCmds missing", E.gold)
                return
              end
              local l, x = G(function()
                return z.GetState("Bait Merchant")
              end)
              local M = l and (x and (x.Roll and x.Roll["Offers"]))
              if type(M) ~= "table" then
                xE(w, "Merchant closed", E.dim)
                return
              end
              local D = false
              for s, X in pairs(M) do
                if not bE.autoBuyBait then
                  break
                end
                if type(X) ~= "table" then
                  continue
                end
                if not gE[X.Id] then
                  continue
                end
                local l = type(X.Price) == "table" and X.Price or {}
                local x = tonumber(l.Cash) or 0
                local M, H = 0, nil
                for s, X in pairs(l) do
                  if tostring(s) ~= "Cash" and tonumber(X) then
                    M, H = tonumber(X), tostring(s)
                  end
                end
                local t = N("Cash")
                local r = (H and N(H)) or 0
                if t < x or (H and r < M) then
                  continue
                end
                local v = 0
                G(function()
                  local s = z.GetState("Bait Merchant")
                  v = tonumber(s and (s.Purchases and s.Purchases[X.Id])) or 0
                end)
                local b = t
                G(function()
                  return z.Purchase("Bait Merchant", X.Id, 1)
                end)
                u(1)
                local g = v
                G(function()
                  local s = z.GetState("Bait Merchant")
                  g = tonumber(s and (s.Purchases and s.Purchases[X.Id])) or v
                end)
                local j = N("Cash")
                if g > v then
                  D = true
                  xE(w, "Bought " .. (tostring(X.Id) .. (" ✓ (" .. (g .. " this cycle)"))), E.green)
                elseif j <= b - x then
                  D = true
                  xE(w, "Bought " .. (tostring(X.Id) .. " ✓"), E.green)
                else
                  xE(w, "Buy refused (" .. (tostring(X.Id) .. ")"), E.gold)
                end
                break
              end
              if not D then
                local s = ""
                G(function()
                  local X = z.GetTimeUntilRestock("Bait Merchant")
                  if tonumber(X) then
                    s = " (restock " .. (math.floor(X / 60) .. ("m " .. (math.floor(X % 60) .. "s)")))
                  end
                end)
                xE(w, "Watching bait offers" .. s, E.dim)
              end
            end
          end)
          task.wait(5)
        end
      end)
    end
    do
      local s, X = NE("Auto Buy Black Market", "Select specific Black Market items to buy automatically when restocked.", O)
      local l, x, w = ME("Auto Buy Black Market", "", s)
      local M = {
        "Ski Lodge Wall";
        "Ski Lodge Window";
        "Ski Lodge Doorway";
        "String Lights";
        "Italian Cypress",
        "Basic Sprinkler",
        "Trellis",
        "Geometric Chandelier";
        "Gargoyle";
        "Ski Lodge Chair";
        "Ski Lodge Table";
        "Modern Sign";
        "Gothic Wall";
        "Gothic Window",
        "Gothic Doorway",
        "Gothic Chair";
        "Gothic Table",
        "Windmill",
        "Pool Table";
        "Large Sprinkler",
        "Prep Kitchen",
        "Giant Beehive",
        "Wishing Fountain",
        "Lucky Cat Tip Jar";
        "Gothic Streetlight";
        "Ski Lodge Fireplace",
        "Gothic Chandelier";
        "Ski Lodge Rug"
      }
      local D = HE(s.Container, {
        Name = "BlackMarketItems";
        SearchPlaceholder = "Search black market to buy...",
        Height = 160;
        LayoutOrder = 1,
        OnOpen = function(s)
          local X = {}
          G(function()
            local s = require(Q.Framework["Client"].BlackMarketCmds)
            local z, l = G(s.GetState)
            local x = (z and (l and (l.Roll and l.Roll["Items"]))) or {}
            for s, z in ipairs(x) do
              local l = z.DirId or (z.ItemDir and z.ItemDir["_id"]) or z.Name or z.Id
              if l then
                X[#X + 1] = l
              end
            end
          end)
          if #X > 0 then
            tE(s, X)
          end
        end,
        OnChanged = function(s)
          O_ = {}
          for s, X in pairs(s) do
            if X then
              O_[s] = true
            end
          end
        end
      })
      D.SetValues(M);
      getgenv().bmAdaptiveItems = M;
      getgenv().updateBmTargetItemsUI = function()
        local s = {}
        for X, z in pairs(getgenv().bmTargetItems or {}) do
          if z then
            s[X] = true
          end
        end
        D.SetSelection(s)
      end
      jE(x, "bm", function()
        while bE.bm and z() do
          local s = workspace:GetServerTimeNow()
          local X = V.GetCurrentCycle(s)
          if X then
            local s, z = G(J.GetState)
            if not s or not z then
              xE(w, "Couldn't read market state", E.red)
              u(.2) continue
            end
            local l = z.Roll and z.Roll["Items"] or {}
            local x = z.Purchases or {}
            local N = 0
            local H = 0
            for s, X in ipairs(l) do
              local z = X.DirId or (X.ItemDir and X.ItemDir["_id"]) or X.Name or X.Id
              if z and not table.find(M, z) then
                table.insert(M, z)
                table.sort(M)
                D.SetValues(M)
                if getgenv().BMPingDrop then
                  p(getgenv().BMPingDrop, M)
                end
              end
            end
            local t = false
            for s, X in pairs(O_) do
              if X then
                t = true
                break
              end
            end
            for s, X in ipairs(l) do
              local z = X.DirId or (X.ItemDir and X.ItemDir["_id"]) or X.Name or X.Id
              if not t or O_[z] or O_[X.Id] then
                local s = x[X.Id] or 0
                H += math.max(0, X.Quantity - s)
              end
            end
            if H == 0 then
              local s = math.max(0, X.Departure - workspace:GetServerTimeNow())
              xE(w, ("✓ All bought! %dm %02ds left"):format(math.floor(s / 60), s % 60), E.green)
              u(.2) continue
            end
            xE(w, ("Market open! Buying %d unit(s)..."):format(H), E.green)
            for s, X in ipairs(l) do
              if not bE.bm then
                break
              end
              local z = X.DirId or (X.ItemDir and X.ItemDir["_id"]) or X.Name or X.Id
              if not t or O_[z] or O_[X.Id] then
                local s = x[X.Id] or 0
                local z = math.max(0, X.Quantity - s)
                for s = 1, z, 1 do
                  if not bE.bm then
                    break
                  end
                  local z, l, w = G(J.Purchase, X.Id, 1)
                  if z and l == true then
                    N += 1
                    x[X.Id] = ((x[X.Id] or 0)) + 1
                  elseif z and w then
                    break
                  end
                  u(.05)
                end
              end
            end
            local r = math.max(0, X.Departure - workspace:GetServerTimeNow())
            if N > 0 then
              xE(w, ("✓ Bought %d unit(s)! %dm %02ds left"):format(N, math.floor(r / 60), r % 60), E.green)
            else
              xE(w, ("Market open! %dm %02ds left"):format(math.floor(r / 60), r % 60), E.green)
            end
            u(.2)
          else
            local X = V.GetNextArrival(s)
            if X then
              local z = math.max(0, X - s)
              xE(w, ("Next in %dm %02ds"):format(math.floor(z / 60), z % 60), E.dim)
            else
              xE(w, "No market info", E.dim)
            end
            u(.2)
          end
        end
      end, function()
        xE(w, "Idle", E.dim)
      end)
      rE(s.Container, { ["Auto Buy Black Market"] = 2 })
    end
    task.wait()
    do
      local s = table.pack(G(require, Q.Framework["Functions"].Commas))
      local function X(X)
        if s[1] and type(s[2]) == "function" then
          local z, l = G(s[2], X)
          if z then
            return tostring(l)
          end
        end
        return tostring(X)
      end;
      getgenv().gmSnipeCaps = getgenv().gmSnipeCaps or {};
      getgenv().gmSnipeTargets = getgenv().gmSnipeTargets or {}
      local l, x = NE("Auto Snipe Global Market", "Auto-buys market items the moment they are listed at or under your price. Diamonds only — pick your items, set a max price for each, then arm it.", O)
      local w, M, D = ME("Auto Snipe Global Market", "", l)
      l:AddParagraph({
        Title = "How it works";
        Content = "1. Search and tick the items you want in the list above. 2. Each ticked item gets a box below — type the MOST diamonds you will pay for one listing (example: 50). 3. Turn on Auto Snipe and it watches the market for you, buying those items the second one is listed at or under your price. 4. Untick an item or press Clear all to stop sniping it."
      })
      local N = HE(l.Container, {
        Name = "GlobalMarketTargets";
        SearchPlaceholder = "Search market items to snipe...";
        Height = 160;
        LayoutOrder = 1,
        OnOpen = function(s)
          local X = {}
          G(function()
            local s = require(Q.Framework["Client"].GlobalMarketCmds)
            G(s.GetCatalog)
            local z = s.GetCatalogSnapshot()
            for s, z in pairs(z) do
              if type(z) == "table" and type(z.MinCash) == "number" then
                X[#X + 1] = s
              end
            end
          end)
          if #X > 0 then
            tE(s, X)
          end
        end,
        OnChanged = function(s)
          local X = {}
          for s, z in pairs(s) do
            if z then
              X[s] = true
            end
          end;
          getgenv().gmSnipeTargets = X
          for s in pairs(X) do
            if not getgenv().gmSnipeCaps[s] and getgenv().ensureGmCapEntry then
              getgenv().ensureGmCapEntry(s)
            end
          end
          for s in pairs(getgenv().gmSnipeCaps or {}) do
            if not X[s] then
              getgenv().gmSnipeCaps[s] = nil
            end
          end
          if getgenv().rebuildGmCapRows then
            getgenv().rebuildGmCapRows()
          end
        end
      })
      do
        local s = {}
        local X = G(function()
          local X = require(Q.Framework["Client"].GlobalMarketCmds)
          G(X.GetCatalog)
          local z = X.GetCatalogSnapshot()
          for X, z in pairs(z) do
            if type(z) == "table" and type(z.MinCash) == "number" then
              s[#s + 1] = X
            end
          end
        end)
        if #s == 0 then
          s = {
            "Retro Booth",
            "Wooden Stool";
            "Industrial Counter",
            "Wooden Chair",
            "Barista Stool"
          }
        end
        table.sort(s)
        N.SetValues(s)
      end;
      getgenv().updateGmTargetItemsUI = function()
        local s = {}
        for X, z in pairs(getgenv().gmSnipeTargets or {}) do
          if z then
            s[X] = true
          end
        end
        N.SetSelection(s)
      end
      local function t()
        if getgenv().rebuildGmCapRows then
          G(getgenv().rebuildGmCapRows)
        end
      end;
      getgenv().refreshGmCapsUI = t
      local r, v = G(require, Q.Framework["Client"].GlobalMarketCmds)
      local b = {}
      local function g(s)
        local X = getgenv().gmSnipeCaps[s]
        if type(X) == "number" then
          X = { cap = X };
          getgenv().gmSnipeCaps[s] = X
        elseif type(X) ~= "table" then
          local z = 0
          G(function()
            local z = v and v.GetCatalogSnapshot()
            local l = z and z[s]
            local x = l and tonumber(l.MinDiamonds)
            if x and x > 0 then
              X = { cap = x }
            else
              X = { cap = 0 }
            end
          end);
          getgenv().gmSnipeCaps[s] = X or { cap = 0 }
        end
        return getgenv().gmSnipeCaps[s]
      end;
      getgenv().ensureGmCapEntry = g
      local j, e
      local function L()
        for s, X in pairs(b) do
          G(function()
            X:Destroy()
          end)
        end
        if j then
          G(function()
            j:Destroy()
          end)
          j = nil
        end
        if e then
          G(function()
            e:Destroy()
          end)
          e = nil
        end
        b = {}
        local s = {}
        for X in pairs(getgenv().gmSnipeCaps or {}) do
          table.insert(s, X)
        end
        table.sort(s)
        for s, X in ipairs(s) do
          local z = g(X)
          b[X] = l:AddInput("GMCap_" .. X, {
            Title = X;
            Placeholder = "e.g. 50";
            Default = tostring(z.cap or 0);
            Callback = function(s)
              local z = tonumber((tostring(s)):gsub("[^%d.]", "")) or 0;
              getgenv().gmSnipeCaps[X] = { cap = z }
              sweepLastResetAll()
            end
          })
        end
        if #s > 0 then
          j = l:AddButton({
            Title = "Clear all targets (" .. (#s .. ")"),
            Icon = "eraser",
            Callback = function()
              getgenv().gmSnipeCaps = {};
              getgenv().gmSnipeTargets = {};
              getgenv().updateGmTargetItemsUI()
              L()
              xE(D, "Cleared all snipe targets", E.green)
            end
          })
        else
          e = l:AddParagraph({ Title = "No targets", Content = "" })
        end
      end;
      getgenv().rebuildGmCapRows = L
      function sweepLastResetAll()
        getgenv().GM_FORCE_RESCAN = true
      end
      local function h(s, z, l, x)
        local w = getgenv().webhookUrl or ""
        if w == "" then
          return
        end
        if not bE.gmSnipePing then
          return
        end
        task.spawn(function()
          local M = table.concat({
            "**-> Profile :**";
            ("> Username : `%s`"):format(i.Name);
            "",
            "**-> Market Snipe :**",
            ("> Item : `%s`"):format(s),
            ("> Qty : `%d`"):format(z or 1);
            ("> Paid : `%s 💎`"):format(X(l or 0)),
            ("> Seller : `%s`"):format(tostring(x or "?"))
          }, "\n")
          local D = {
            title = "SpectreWare | Run A Restaurant",
            description = M;
            color = 5793266;
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
          }
          local N = getgenv().webhookPingId or ""
          local t = N ~= "" and ("<@%s>"):format(N) or ""
          local r, v = G(H.JSONEncode, H, { content = t ~= "" and t or nil; embeds = { D } })
          if not r then
            return
          end
          local b = type(http_request) == "function" and http_request or type(request) == "function" and request or nil
          if b then
            G(b, {
              Url = w,
              Method = "POST",
              Headers = { ["Content-Type"] = "application/json" },
              Body = v
            })
          end
        end)
      end
      local function m(s)
        if type(getconnections) ~= "function" or type(getupvalues) ~= "function" then
          return nil
        end
        local X, z = G(function()
          return ((getconnections(s.Activated) or {}))[1]
        end)
        if not X or not z then
          return nil
        end
        local l = z.Function or z._function
        if type(l) ~= "function" then
          return nil
        end
        local x, w = G(getupvalues, l)
        if not x or type(w) ~= "table" then
          return nil
        end
        local M = w[2]
        if type(M) == "table" and (M.ListingId and (M.Currency and type(M.Price) == "number")) then
          return M
        end
        return nil
      end
      local function R(s)
        local X = i:FindFirstChildOfClass("PlayerGui")
        local l = X and X:FindFirstChild("GlobalMarket")
        if l and l.Parent then
          return l
        end
        if s then
          local x = "Wooden Chair"
          for s in pairs(getgenv().gmSnipeTargets or {}) do
            if type(s) == "string" and s ~= "" then
              x = s
              break
            end
          end
          G(function()
            s.Browse(x)
          end)
          for s = 1, 16, 1 do
            task.wait(.5)
            if not bE.gmSnipe or not z() then
              return nil
            end
            X = i:FindFirstChildOfClass("PlayerGui")
            l = X and X:FindFirstChild("GlobalMarket")
            if l and l.Parent then
              l.Enabled = false
              break
            end
          end
        end
        X = i:FindFirstChildOfClass("PlayerGui")
        l = X and X:FindFirstChild("GlobalMarket")
        return ((l and l.Parent)) and l or nil
      end
      local function I(s, X)
        if not s then
          return
        end
        G(function()
          s.Text = X
          firesignal(s:GetPropertyChangedSignal("Text"))
        end)
      end
      local function W(s, X)
        local z = s:FindFirstChild(X)
        if z and z.Parent then
          G(function()
            firesignal(z.Activated)
          end)
          return true
        end
        return false
      end
      local function S(s, X, l)
        local x = os.clock()
        while os.clock() - x < ((l or 2.5)) do
          local l = s:FindFirstChild("Container")
          if l then
            for s, z in ipairs(l:GetChildren()) do
              if z:IsA("ImageButton") and z.Name == X then
                return true
              end
            end
          end
          task.wait(.2)
          if not bE.gmSnipe or not z() then
            return false
          end
        end
        return false
      end
      local n = 0
      jE(M, "gmSnipe", function()
        if type(firesignal) ~= "function" then
          xE(D, "Executor lacks firesignal — sniper unavailable", E.red)
          bE.gmSnipe = false
          return
        end
        local s = {}
        local X = 0
        local l = {}
        local x = require(Q.Framework["Client"].Network)
        local w, M = G(require, Q.Framework["Client"].GlobalMarketCmds)
        local N = {}
        local H = {}
        local t = {}
        while bE.gmSnipe and z() do
          local w, r = G(function()
            local w = R(M)
            if not w then
              xE(D, "Market UI unavailable (move near the boards?)", E.red)
              task.wait(3)
              return
            end
            if w.Enabled then
              xE(D, "Paused (market UI open)", E.dim)
              task.wait(1)
              return
            end
            if getgenv().GM_FORCE_RESCAN then
              N = {}
              H = {};
              getgenv().GM_FORCE_RESCAN = nil
            end
            local r, v = G(function()
              return M and M.GetCatalogSnapshot()
            end)
            local b, g = {}, 0
            for s, X in pairs(getgenv().gmSnipeCaps or {}) do
              local z = type(X) == "table" and tonumber(X.cap) or tonumber(X)
              if type(z) == "number" and (z > 0 and getgenv().gmSnipeTargets[s]) then
                local X = ((r and type(v) == "table")) and v[s]
                if type(X) ~= "table" then
                  b[#b + 1] = { s; z }
                  g += 1
                else
                  local l = tonumber(X.Count) or 0
                  local x = tonumber(X.MinDiamonds)
                  if l == 0 or not x then
                    H[s] = "clean"
                  elseif x > z and not t[s] then
                    H[s] = "clean"
                  else
                    local X = tostring(l) .. ("|" .. (tostring(x) .. ("|" .. tostring(z))))
                    if X ~= N[s] or H[s] ~= "clean" or t[s] then
                      b[#b + 1] = { s, z; X }
                      g += 1
                    end
                  end
                end
              end
            end
            if g == 0 then
              n += 1
              xE(D, ("Sweep %d — snapshot clean, nothing new"):format(n), E.dim)
              task.wait(.2)
              return
            end
            local j = w.Shop["Frame"].Content["Pages"]
            local O = j.BuySelect
            local e = O.Filter["SearchBar"].Text
            local L = O.Filter["ItemsList"]
            local i = j.BuyListings
            local Y = {}
            G(function()
              local s = {}
              for X, z in ipairs(O.Tabs:GetDescendants()) do
                if z:IsA("GuiButton") and not s[z] then
                  s[z] = true
                  Y[#Y + 1] = z
                end
              end
            end)
            local k = 0
            for r, v in ipairs(b) do
              if not bE.gmSnipe or not z() then
                break
              end
              local b, g, j = v[1], v[2], v[3]
              G(function()
                return M.Browse(b)
              end)
              task.wait(.3)
              local function O()
                G(function()
                  local s = require(Q.Framework["Client"].UI["GlobalMarketUI"])
                  s.Open()
                  w.Enabled = false
                  local X = w.Shop["Frame"].Content["Tabs"]:FindFirstChild("Buy")
                  if X then
                    firesignal(X.Activated)
                  end
                end)
                task.wait(.25)
                local s = l[b]
                if s and s.Parent then
                  G(function()
                    firesignal(s.Activated)
                  end)
                  task.wait(.25)
                  I(e, b)
                  task.wait(.3)
                  if W(L, b) then
                    return S(i, b, 2.5)
                  end
                end
                for s, X in ipairs(Y) do
                  if not bE.gmSnipe or not z() then
                    return false
                  end
                  G(function()
                    firesignal(X.Activated)
                  end)
                  task.wait(.3)
                  I(e, b)
                  task.wait(.3)
                  if W(L, b) then
                    if S(i, b, 1.2) then
                      l[b] = X
                      return true
                    end
                  end
                end
                return false
              end
              if O() then
                xE(D, ("Scanning %s..."):format(b), E.text)
                local l = i:FindFirstChild("Container")
                if l then
                  local w = {
                    rows = 0;
                    named = 0;
                    listed = 0,
                    triedSkip = 0;
                    badCur = nil;
                    badQty = 0;
                    badPrice = 0
                  }
                  local M = false
                  for l, N in ipairs(l:GetChildren()) do
                    if not bE.gmSnipe or not z() then
                      break
                    end
                    if N:IsA("ImageButton") then
                      w.rows = w.rows + 1
                      if N.Name == b then
                        w.named = w.named + 1
                        local z = m(N)
                        if not z then
                          w.noData = ((w.noData or 0)) + 1
                        elseif s[z.ListingId] then
                          w.triedSkip = w.triedSkip + 1
                        else
                          w.listed = w.listed + 1
                          if z.Currency ~= "Diamonds" then
                            w.badCur = tostring(z.Currency)
                          end
                          if ((z.Quantity or 1)) <= 0 then
                            w.badQty = w.badQty + 1
                          end
                          if ((z.Price or 0)) > g then
                            w.badPrice = w.badPrice + 1
                          end
                        end
                        if z and (z.ListingId and (not s[z.ListingId] and (z.Currency == "Diamonds" and (((z.Quantity or 1)) > 0 and z.Price <= g)))) then
                          s[z.ListingId] = true
                          local l, w = G(x.Invoke, "Currency_Get")
                          local N = l and (type(w) == "table" and tonumber(w.Diamonds)) or 0
                          if N < z.Price then
                            t[b] = true
                            H[b] = "dealt"
                            xE(D, ("Deal found (%s %s💎) — waiting for diamonds"):format(b, tostring(z.Price)), E.dim)
                          else
                            local s, l = G(x.Invoke, "GlobalMarket_Buy", z.ListingId, z.Price, "Diamonds")
                            if s and l == true then
                              X += 1
                              k += 1
                              M = true
                              t[b] = nil
                              H[b] = "bought"
                              xE(D, ("✓ Sniped %s x%d for %s💎!"):format(b, z.Quantity or 1, tostring(z.Price)), E.green)
                              h(b, z.Quantity or 1, z.Price, z.SellerName)
                            end
                          end
                          task.wait(.3)
                        end
                      end
                    end
                  end;
                  getgenv().GM_SCAN_TRACE = w
                end
                if passBought then
                  H[b] = "bought"
                elseif not t[b] then
                  H[b] = "clean"
                  if j then
                    N[b] = j
                  end
                end
              else
              end
              task.wait(.2)
            end
            n += 1
            if k == 0 then
              xE(D, ("Sweep %d done — %d target(s), no deals this pass"):format(n, g), E.dim)
            end
            task.wait(.2)
          end)
          if not w then
            xE(D, "Snipe error: " .. (tostring(r)):sub(1, 80), E.red)
            task.wait(2)
          end
        end
      end, function()
        xE(D, "Idle", E.dim)
      end)
      rE(l.Container, { ["Auto Snipe Global Market"] = 2 })
      t()
    end
    do
      local s, X, l = ME("Auto Organ Play", "Plays your Davy Jones Organ (+65% cash, 5 min) whenever its cooldown is ready. Teleport loops pause while seated.", nil)
      jE(X, "autoOrgan", function()
        local s = nil
        if type(fireproximityprompt) == "function" then
          s = fireproximityprompt
        elseif type(fire_prompt) == "function" then
          s = fire_prompt
        elseif type(syn) == "table" and type(syn.fire_proximity_prompt) == "function" then
          s = syn.fire_proximity_prompt
        end
        local function X()
          local s, X = {}, {}
          local z, l = nil, nil
          G(function()
            z = require(game.ReplicatedStorage["Framework"].Client["ClientEntity"])
          end)
          G(function()
            l = require(game.ReplicatedStorage["Framework"].Client["ClientRestaurant"])
          end)
          local function x()
            local s = nil
            if type(l) == "table" then
              G(function()
                if type(l.GetLocal) == "function" then
                  s = l.GetLocal()
                elseif type(l.GetLocalSafe) == "function" then
                  s = l.GetLocalSafe()
                end
              end)
            end
            return s
          end
          local function w(X)
            local l = x()
            local w = l and l.Model
            if w then
              local l = w:FindFirstChild("Entities")
              if l then
                for l, x in ipairs(l:GetChildren()) do
                  local w, M = G(function()
                    return string.find(string.lower(x.Name), string.lower(X))
                  end)
                  if w and M then
                    local X = x.Name:match("_([0-9a-f%-]+)$")
                    if X and (type(z) == "table" and type(z.GetById) == "function") then
                      local l, x = G(z.GetById, X)
                      if l and x then
                        s[#s + 1] = x
                      end
                    end
                  end
                end
              end
            end
            if #s == 0 then
              local z = x()
              if z then
                for z, l in next, (z.Entity or {}) do
                  local x, w = G(function()
                    return l.IsSubclass and l:IsSubclass(X)
                  end)
                  if x and w then
                    s[#s + 1] = l
                  end
                end
              end
            end
          end
          for z, l in ipairs({ "Organ", "DavyJonesOrgan" }) do
            w(l)
            for s, z in ipairs(s) do
              if not X[z] then
                local s, l = G(function()
                  return z.IsSubclass and z:IsSubclass("DavyJonesOrgan")
                end)
                if not ((s and l)) then
                  X[z] = true
                end
              end
            end
          end
          local M, D = {}, {}
          for s, z in ipairs(s) do
            if not X[z] then
              local s, X = G(function()
                return z.IsSubclass and z:IsSubclass("DavyJonesOrgan")
              end)
              if s and (X and not D[z]) then
                D[z] = true
                M[#M + 1] = z
              end
            end
          end
          return M
        end
        local function w(s, X)
          local z = nil
          G(function()
            z = s:GetSession(X)
          end)
          return z
        end
        local function M()
          local s = nil
          G(function()
            s = workspace:GetServerTimeNow()
          end)
          return tonumber(s)
        end
        local function D()
          local s = false
          G(function()
            local X = i.Character
            s = X and X:GetAttribute("PianoSeated") == true
          end)
          return s
        end
        local function N(s)
          local X, z = w(s, "OrganPlayer"), w(s, "OrganSong")
          if z ~= nil then
            return true
          end
          return tonumber(X) == i.UserId
        end
        local function H()
          local s = nil
          G(function()
            local X = i.Character
            s = X and X:FindFirstChild("HumanoidRootPart")
          end)
          return s
        end
        local function t(s)
          local X = nil
          G(function()
            for s, z in ipairs(s:GetDescendants()) do
              if z:IsA("ProximityPrompt") and z.Enabled then
                if z.ActionText == "Play" then
                  X = z
                  break
                elseif X == nil then
                  X = z
                end
              end
            end
          end)
          return X
        end
        local function r(X)
          G(function()
            if s then
              s(X)
            else
              X:InputHoldBegin()
              task.wait(((X.HoldDuration or 0)) + .05)
              X:InputHoldEnd()
            end
          end)
        end
        local function v(s, X, l)
          local x = os.clock()
          while os.clock() - x < X do
            if not bE.autoOrgan or not z() then
              return false
            end
            local X, x = G(s)
            if X and x then
              return true
            end
            task.wait(l or .5)
          end
          return false
        end
        local function b(s)
          local X = nil
          G(function()
            X = s.GetModel and s:GetModel()
          end)
          if not X then
            return nil, "no model"
          end
          local z = X.PrimaryPart
          if not z then
            G(function()
              z = X:FindFirstChildWhichIsA("BasePart", true)
            end)
          end
          if not z then
            return nil, "no part"
          end
          local l = t(X)
          if not l then
            return nil, "no Play prompt"
          end
          local w = H()
          local M = w and w.CFrame
          local function b(s)
            if not s then
              return
            end
            local X = H()
            if X then
              G(x, s)
              task.wait(.2)
            end
          end
          b(z.CFrame + Vector3.new(0, 4, 0))
          task.wait(1)
          l = t(X) or l
          r(l)
          if not v(D, 10, .25) then
            b(M)
            return nil, "seat failed"
          end;
          getgenv()._rar_organBusy = true
          if not v(function()
            return N(s)
          end, 10, .5) then
            b(M);
            getgenv()._rar_organBusy = false
            return nil, "song rejected"
          end
          b(M)
          task.wait(2)
          if D() and N(s) then
            getgenv()._rar_organBusy = false
            return "kept"
          end
          b(z.CFrame + Vector3.new(0, 4, 0))
          task.wait(1)
          l = t(X)
          if l then
            r(l)
          end
          if not v(D, 10, .25) then
            b(M);
            getgenv()._rar_organBusy = false
            return nil, "re-seat failed"
          end
          v(function()
            return not D() or not N(s)
          end, 240, 5)
          b(M);
          getgenv()._rar_organBusy = false
          return "riding"
        end
        while bE.autoOrgan and z() do
          local s, x = G(function()
            if getgenv()._rar_scavBusy then
              xE(l, "Waiting (scavenger trip)", E.dim)
              task.wait(2)
              return
            end
            if D() then
              xE(l, "Seated — song playing", E.green);
              getgenv()._rar_organBusy = true
              v(function()
                return not D()
              end, 240, 5);
              getgenv()._rar_organBusy = false
              return
            end
            local s = X()
            if #s == 0 then
              xE(l, "No organ placed", E.dim)
              u(5)
              return
            end
            local x = M()
            local N, H, t = 0, nil, nil
            for s, X in ipairs(s) do
              if not bE.autoOrgan or not z() then
                break
              end
              local M = tonumber(w(X, "OrganCooldownEnd")) or 0
              if x and x < M then
                local s = math.ceil(M - x)
                if not H or s < H then
                  H = s
                end
              else
                local s, z = b(X)
                if s then
                  N += 1
                  xE(l, ("Song %s — boost active"):format(s == "kept" and "kept while away" or "played seated"), E.green)
                else
                  t = z
                end
                task.wait(1)
              end
            end
            if N > 0 then
              u(30)
            elseif H then
              xE(l, ("Next song in %ds"):format(H), E.dim)
              task.wait(math.min(H, 10))
            else
              xE(l, t or "Failed to play", E.gold)
              u(5)
            end
          end)
          if not s then
            getgenv()._rar_organBusy = false
            xE(l, "Error: " .. tostring(x), E.gold)
            u(5)
          end
        end
      end, function()
        getgenv()._rar_organBusy = false
        G(function()
          local s = i.Character
          local X = s and s:FindFirstChildOfClass("Humanoid")
          if X then
            X.Jump = true
          end
        end)
      end)
    end
    do
      local s, X, l = ME("Auto Trident", "Summons Poseidon from each ready Trident (12h cooldown each). Teleport, summon, teleport back.", r.Fishing)
      jE(X, "autoTrident", function()
        local s = "Trident"
        local X = "Trident_"
        local w = 43200
        local M = nil
        if type(fireproximityprompt) == "function" then
          M = fireproximityprompt
        elseif type(fire_prompt) == "function" then
          M = fire_prompt
        elseif type(syn) == "table" and type(syn.fire_proximity_prompt) == "function" then
          M = syn.fire_proximity_prompt
        end
        local D = 0
        local function N()
          local s = w
          G(function()
            local X = require(Q.Framework["FFlags"])
            s = tonumber(X.GetNumber("TridentSummonCooldown")) or s
          end)
          return s
        end
        local function H()
          local s = nil
          G(function()
            s = workspace:GetServerTimeNow()
          end)
          return tonumber(s)
        end
        local function t(s)
          local X = H()
          if not X then
            return s
          end
          local z = {}
          G(function()
            local s = require(Q.Framework["Client"].Saving)
            local X = s.Get()
            local l = X and X.TridentSummonTimes
            if type(l) == "table" then
              for s, X in pairs(l) do
                X = tonumber(X)
                if X then
                  z[#z + 1] = X
                end
              end
            end
          end)
          table.sort(z)
          local l = N()
          local x = s
          for s, z in ipairs(z) do
            if X - z < l then
              x -= 1
            end
          end
          return math.max(0, x)
        end
        local function r()
          local s = H()
          if not s then
            return nil
          end
          local X = nil
          G(function()
            local z = require(Q.Framework["Client"].Saving)
            local l = z.Get()
            local x = l and l.TridentSummonTimes
            if type(x) == "table" then
              for z, l in pairs(x) do
                l = tonumber(l)
                if l then
                  local z = ((l + N())) - s
                  if z > 0 and ((not X or z < X)) then
                    X = z
                  end
                end
              end
            end
          end)
          return X
        end
        local function v()
          local X, z = {}, {}
          local l, x = nil, nil
          G(function()
            l = require(game.ReplicatedStorage["Framework"].Client["ClientEntity"])
          end)
          G(function()
            x = require(game.ReplicatedStorage["Framework"].Client["ClientRestaurant"])
          end)
          local function w()
            local s = nil
            if type(x) == "table" then
              G(function()
                if type(x.GetLocal) == "function" then
                  s = x.GetLocal()
                elseif type(x.GetLocalSafe) == "function" then
                  s = x.GetLocalSafe()
                end
              end)
            end
            return s
          end
          for s, x in ipairs({ s, "Trident", "Decor Trident" }) do
            local M = w()
            local D = M and M.Model
            if D then
              local s = D:FindFirstChild("Entities")
              if s then
                for s, z in ipairs(s:GetChildren()) do
                  local w, M = G(function()
                    return string.find(string.lower(z.Name), string.lower(x))
                  end)
                  if w and M then
                    local s = z.Name:match("_([0-9a-f%-]+)$")
                    if s and (type(l) == "table" and type(l.GetById) == "function") then
                      local z, x = G(l.GetById, s)
                      if z and x then
                        X[#X + 1] = x
                      end
                    end
                  end
                end
              end
            end
            if #X == 0 then
              local s = w()
              if s then
                for s, z in next, (s.Entity or {}) do
                  local l, w = G(function()
                    return z.IsSubclass and z:IsSubclass(x)
                  end)
                  if l and w then
                    X[#X + 1] = z
                  end
                end
              end
            end
            for s, X in ipairs(X) do
              if not z[X] then
                local s, l = G(function()
                  return X.IsSubclass and ((X:IsSubclass("Trident") or X:IsSubclass("Decor Trident")))
                end)
                if s and l then
                  z[X] = true
                end
              end
            end
          end
          local M, D = {}, {}
          for s, X in ipairs(X) do
            if z[X] and not D[X] then
              D[X] = true
              M[#M + 1] = X
            end
          end
          return M
        end
        local function b(s)
          local X = nil
          G(function()
            for s, z in ipairs(s:GetDescendants()) do
              if z:IsA("ProximityPrompt") and z.Enabled then
                if z.ActionText == "Summon Poseidon" then
                  X = z
                  break
                elseif X == nil then
                  X = z
                end
              end
            end
          end)
          return X
        end
        local function g(s)
          local X = G(function()
            if M then
              M(s)
            else
              s:InputHoldBegin()
              task.wait(((s.HoldDuration or 0)) + .05)
              s:InputHoldEnd()
            end
          end)
          return X
        end
        while bE.autoTrident and z() do
          local s, w = G(function()
            local s = v()
            local w, M = {}, {}
            for s, X in ipairs(s) do
              local z = tostring(X.Id)
              w[z] = true
              M[z] = X
            end
            local N = {}
            G(function()
              for s, z in ipairs(workspace:GetDescendants()) do
                if z:IsA("Model") and string.sub(z.Name, 1, #X) == X then
                  local s = string.sub(z.Name, #X + 1)
                  if w[s] then
                    N[#N + 1] = z
                  end
                end
              end
            end)
            if #N == 0 then
              for s, X in ipairs(s) do
                local z = nil
                G(function()
                  if X ~= nil and type(X.GetModel) == "function" then
                    z = X:GetModel()
                  end
                end)
                if z then
                  N[#N + 1] = z
                end
              end
            end
            if #N == 0 then
              xE(l, "No trident placed", E.dim)
              u(30)
              return
            end
            if t(#N) <= 0 then
              local s = r()
              if s then
                local X = math.floor(s / 3600)
                local z = math.floor(((s % 3600)) / 60)
                xE(l, ("Next summon in %dh %02dm"):format(X, z), E.dim)
              else
                xE(l, "Tridents cooling down", E.dim)
              end
              u(30)
              return
            end
            local j = H() or 0
            if j < D then
              return
            end
            local O = i.Character
            local e = O and ((O.PrimaryPart or O:FindFirstChild("HumanoidRootPart")))
            if not e then
              xE(l, "No character", E.gold)
              u(5)
              return
            end
            local L = e.CFrame
            local h = 0
            for s, l in ipairs(N) do
              if not bE.autoTrident or not z() then
                break
              end
              if t(#N) <= 0 then
                break
              end
              local w = l.PrimaryPart or l:FindFirstChildWhichIsA("BasePart", true)
              if w then
                G(x, w.CFrame + Vector3.new(0, 3, 0))
                task.wait(.8)
                local s = b(l)
                local z = s and g(s)
                if not z then
                  local s = string.sub(l.Name, #X + 1)
                  local z = s and M[s]
                  if z then
                    G(function()
                      q(z, { "Summon", "SummonPoseidon", "Activate"; "Use" })
                    end)
                  end
                end
                h += 1
                task.wait(.5)
              end
            end
            G(x, L)
            D = ((H() or j)) + ((h > 0 and 120 or 15))
            if h > 0 then
              xE(l, ("Summoned Poseidon ×%d — watch for his arrival"):format(h), E.green)
            end
          end)
          if not s then
            xE(l, "Error: " .. tostring(w), E.gold)
          end
          u(30, 5)
        end
        xE(l, "Idle", E.dim)
      end, function()
        xE(l, "Idle", E.dim)
      end)
    end
    do
      local s, X, l = ME("Auto Haunted Relic", "Rings your Haunted Ship Bell whenever its 6h cooldown is ready: teleport, ring, teleport back. Fishermen +100% speed & luck for 1h.", r.Fishing)
      jE(X, "autoRelic", function()
        local s = "Haunted Fishing Relic"
        local X = "Haunted Fishing Relic_"
        local w = 21600
        local M = nil
        if type(fireproximityprompt) == "function" then
          M = fireproximityprompt
        elseif type(fire_prompt) == "function" then
          M = fire_prompt
        elseif type(syn) == "table" and type(syn.fire_proximity_prompt) == "function" then
          M = syn.fire_proximity_prompt
        end
        local D = 0
        local function N()
          local s = w
          G(function()
            local X = require(Q.Framework["FFlags"])
            s = tonumber(X.GetNumber("HauntedRelicCooldown")) or s
          end)
          return s
        end
        local function H()
          local s = nil
          G(function()
            s = workspace:GetServerTimeNow()
          end)
          return tonumber(s)
        end
        local function t()
          local s = H()
          if not s then
            return 0
          end
          local X = nil
          G(function()
            local s = require(Q.Framework["Client"].Saving)
            local z = s.Get()
            local l = z and z.HauntedRelicUses
            if type(l) == "table" then
              for s, z in pairs(l) do
                z = tonumber(z)
                if z and ((not X or z > X)) then
                  X = z
                end
              end
            end
          end)
          if not X then
            return 0
          end
          return math.max(0, ((X + N())) - s)
        end
        local function r()
          local X, z = {}, {}
          local l, x = nil, nil
          G(function()
            l = require(game.ReplicatedStorage["Framework"].Client["ClientEntity"])
          end)
          G(function()
            x = require(game.ReplicatedStorage["Framework"].Client["ClientRestaurant"])
          end)
          local function w()
            local s = nil
            if type(x) == "table" then
              G(function()
                if type(x.GetLocal) == "function" then
                  s = x.GetLocal()
                elseif type(x.GetLocalSafe) == "function" then
                  s = x.GetLocalSafe()
                end
              end)
            end
            return s
          end
          for s, x in ipairs({ s, "HauntedRelic", "Decor HauntedRelic" }) do
            local M = w()
            local D = M and M.Model
            if D then
              local s = D:FindFirstChild("Entities")
              if s then
                for s, z in ipairs(s:GetChildren()) do
                  local w, M = G(function()
                    return string.find(string.lower(z.Name), string.lower(x))
                  end)
                  if w and M then
                    local s = z.Name:match("_([0-9a-f%-]+)$")
                    if s and (type(l) == "table" and type(l.GetById) == "function") then
                      local z, x = G(l.GetById, s)
                      if z and x then
                        X[#X + 1] = x
                      end
                    end
                  end
                end
              end
            end
            if #X == 0 then
              local s = w()
              if s then
                for s, z in next, (s.Entity or {}) do
                  local l, w = G(function()
                    return z.IsSubclass and z:IsSubclass(x)
                  end)
                  if l and w then
                    X[#X + 1] = z
                  end
                end
              end
            end
            for s, X in ipairs(X) do
              if not z[X] then
                local s, l = G(function()
                  return X.IsSubclass and ((X:IsSubclass("HauntedRelic") or X:IsSubclass("Decor HauntedRelic")))
                end)
                if s and l then
                  z[X] = true
                end
              end
            end
          end
          local M, D = {}, {}
          for s, X in ipairs(X) do
            if z[X] and not D[X] then
              D[X] = true
              M[#M + 1] = X
            end
          end
          return M
        end
        local function v(s)
          local X = nil
          G(function()
            for s, z in ipairs(s:GetDescendants()) do
              if z:IsA("ProximityPrompt") and z.Enabled then
                if z.ActionText == "Ring the Bell" then
                  X = z
                  break
                elseif X == nil then
                  X = z
                end
              end
            end
          end)
          return X
        end
        local function b(s)
          local X = G(function()
            if M then
              M(s)
            else
              s:InputHoldBegin()
              task.wait(((s.HoldDuration or 0)) + .05)
              s:InputHoldEnd()
            end
          end)
          return X
        end
        while bE.autoRelic and z() do
          local s, w = G(function()
            local s = t()
            if s > 0 then
              local X = math.floor(s / 3600)
              local z = math.floor(((s % 3600)) / 60)
              xE(l, ("Next ring in %dh %02dm"):format(X, z), E.dim)
              return
            end
            local w = H() or 0
            if w < D then
              return
            end
            local M = r()
            local N, g = {}, {}
            for s, X in ipairs(M) do
              local z = tostring(X.Id)
              N[z] = true
              g[z] = X
            end
            local j = {}
            G(function()
              for s, z in ipairs(workspace:GetDescendants()) do
                if z:IsA("Model") and string.sub(z.Name, 1, #X) == X then
                  local s = string.sub(z.Name, #X + 1)
                  if N[s] then
                    j[#j + 1] = z
                  end
                end
              end
            end)
            if #j == 0 then
              for s, X in ipairs(M) do
                local z = nil
                G(function()
                  if X ~= nil and type(X.GetModel) == "function" then
                    z = X:GetModel()
                  end
                end)
                if z then
                  j[#j + 1] = z
                end
              end
            end
            if #j == 0 then
              xE(l, "No relic placed", E.dim)
              return
            end
            local O = i.Character
            local e = O and ((O.PrimaryPart or O:FindFirstChild("HumanoidRootPart")))
            if not e then
              xE(l, "No character", E.gold)
              return
            end
            local L = e.CFrame
            local h = 0
            for s, l in ipairs(j) do
              if not bE.autoRelic or not z() then
                break
              end
              local w = l.PrimaryPart or l:FindFirstChildWhichIsA("BasePart", true)
              if w then
                G(x, w.CFrame + Vector3.new(0, 3, 0))
                task.wait(.8)
                local s = v(l)
                local z = s and b(s)
                if not z then
                  local s = string.sub(l.Name, #X + 1)
                  local z = s and g[s]
                  if z then
                    G(function()
                      q(z, { "Ring"; "Activate", "Use" })
                    end)
                  end
                end
                h += 1
                task.wait(.15)
              end
            end
            G(x, L)
            D = ((H() or w)) + ((h > 0 and 60 or 15))
            if h > 0 then
              xE(l, "Rang the bell — fishermen possessed", E.green)
            end
          end)
          if not s then
            xE(l, "Error: " .. tostring(w), E.gold)
          end
          u(30, 5)
        end
        xE(l, "Idle", E.dim)
      end, function()
        xE(l, "Idle", E.dim)
      end)
    end
    do
      local s, X, l = ME("Auto Claim Fish Farm", "Claims bred baits from your Fish Farm automatically.", r.Fishing)
      local function x(s)
        local X, z = G(function()
          return require(Q.Framework["Client"].ClientEntity["ClientFishFarm"])
        end)
        if X and (type(z) == "table" and type(z.GetCount) == "function") then
          local X, l = G(z.GetCount, s)
          if X and type(l) == "number" then
            return l
          end
        end
        local l = 0
        G(function()
          local X = s.GetSave and s:GetSave()
          local function z(s)
            if type(s) ~= "table" then
              return 0
            end
            local X = 0
            for s in pairs(s) do
              X += 1
            end
            return X
          end
          l = z(X)
          for s, x in ipairs({ "Baits"; "Bait"; "Pile", "Stored" }) do
            local w = type(X) == "table" and X[x]
            if type(w) == "table" then
              l = z(w)
              break
            end
          end
          if l == 0 and type(s.SaveVars) == "table" then
            for X, x in ipairs({ "Baits"; "Bait"; "Pile"; "Stored" }) do
              local w = s.SaveVars[x]
              if type(w) == "table" then
                l = z(w)
                break
              end
            end
          end
        end)
        return l
      end
      local function w(s)
        local X = s.Model or (s.GetModel and s:GetModel())
        local z = i.Character
        local l = z and z:FindFirstChild("HumanoidRootPart")
        if not ((X and l)) then
          return nil
        end
        local x, w = G(function()
          return (X:GetPivot()).Position
        end)
        if not x or not w then
          return nil
        end
        local M = l.CFrame
        G(function()
          l.CFrame = CFrame.new(w + Vector3.new(0, 4, 0))
        end)
        task.wait(.25)
        return M
      end
      local function M(s)
        if not s then
          return
        end
        G(function()
          local X = i.Character
          local z = X and X:FindFirstChild("HumanoidRootPart")
          if z then
            z.CFrame = s
          end
        end)
      end
      local D = {
        getgenv()._rar_farmClaimAction,
        "Claim";
        "Collect",
        "CollectBaits";
        "FishFarmClaim";
        "FishFarm_Claim",
        "Harvest",
        "FishFarmCollect"
      }
      local function N(s)
        local X = {}
        G(function()
          local z = s.Model or s._model or (s.GetModel and s:GetModel())
          if not z then
            return
          end
          local l = z:FindFirstChildWhichIsA("ProximityPrompt", true)
          if not l or type(getconnections) ~= "function" then
            return
          end
          local x, w = G(getconnections, l.Triggered)
          if not x or type(w) ~= "table" then
            return
          end
          for s, z in ipairs(w) do
            local l = (type(z) == "table" and ((z.Function or z.fn))) or nil
            if type(l) == "function" then
              local s, z = G(getconstants, l)
              if s and type(z) == "table" then
                for s, z in ipairs(z) do
                  if type(z) == "string" and (#z >= 4 and z:match("^[A-Z][A-Za-z]+$")) then
                    X[#X + 1] = z
                  end
                end
              end
            end
          end
        end)
        return X
      end
      bE.autoClaimFishFarm = false
      jE(X, "autoClaimFishFarm", function()
        while bE.autoClaimFishFarm and z() do
          local s = n.GetLocal()
          local X = s and P(s, "FishFarm")
          X = (X and X[1]) or nil
          if not X then
            xE(l, "No Fish Farm placed", E.dim)
          else
            local s = x(X)
            xE(l, ("Fish Farm: %d/10 baits"):format(s), s > 0 and E.green or E.dim)
            if s > 0 then
              local z = getgenv()._rar_farmClaimAction
              if not z and os.clock() - ((getgenv()._rar_farmClaimProbeAt or 0)) > 120 then
                getgenv()._rar_farmClaimProbeAt = os.clock()
                local s = {}
                for X, z in ipairs(N(X)) do
                  if z ~= "ProximityPrompt" and z ~= "Triggered" then
                    s[#s + 1] = z
                  end
                end
                for X, z in ipairs(D) do
                  if type(z) == "string" then
                    s[#s + 1] = z
                  end
                end
                for s, l in ipairs(s) do
                  local D = x(X)
                  local N = w(X)
                  local H = G(function()
                    return X:Invoke(l)
                  end)
                  task.wait(.5)
                  M(N)
                  local t = x(X)
                  if H and t < D then
                    z = l
                    break
                  end
                end;
                getgenv()._rar_farmClaimAction = z
              end
              if z then
                local x = w(X)
                G(function()
                  return X:Invoke(z)
                end)
                task.wait(.2)
                M(x)
                xE(l, ("Fish Farm: claimed %d baits"):format(s), E.green)
              end
            end
          end
          u(3)
        end
        xE(l, "")
      end, function()
        xE(l, "")
      end)
    end
    do
      local X = "Default"
      local z = { Text = "Default" }
      local l = k:AddInput("ConfigName", {
        Title = "Config Name",
        Default = "Default",
        Placeholder = "Config Name";
        Numeric = false,
        Finished = false;
        Callback = function(s)
          X = s
          z.Text = s
        end
      })
      local x = k:AddDropdown("SavedConfigs", { Title = "Saved Configs", Values = {}; Multi = false, Default = nil })
      x:OnChanged(function(s)
        if s and s ~= "" then
          X = s
          z.Text = s
          l:SetValue(s)
        end
      end)
      local function w()
        if type(listfiles) ~= "function" then
          return
        end
        local s, X = G(listfiles, g_)
        if s and X then
          local s = {}
          for X, z in ipairs(X) do
            local l = z:match("([^/\\]+)%.json$")
            if l then
              table.insert(s, l)
            end
          end
          p(x, s)
        end
      end
      local function M(s)
        if not s or s == "" then
          return nil
        end
        return g_ .. ("/" .. (s .. ".json"))
      end
      local D = { MouseButton1Click = {} }
      local N = { MouseButton1Click = {} }
      local r = { MouseButton1Click = {} }
      local function v(s, X)
        s.MouseButton1Click["Connect"] = function(s, z)
          k:AddButton({ Title = X; Icon = "mouse-pointer-click", Callback = z })
        end
      end
      v(D, "Save Config")
      v(N, "Load Config")
      v(r, "Delete Config")
      local b = { Text = "" }
      local function g(X, z)
        if s and s.Notify then
          s:Notify({ Title = "Config"; Content = z; Duration = 3 })
        end
      end
      D.MouseButton1Click:Connect(function()
        local s = z.Text
        local X = M(s)
        if not X then
          return
        end
        local l = {
          toggles = bE,
          crops = l_;
          rodashSelected = t_,
          cropStockLimit = getgenv().cropStockLimit;
          autoSellKeepAmount = getgenv().autoSellKeepAmount;
          coffeeFillBelow = getgenv().coffeeFillBelow;
          colaFillBelow = getgenv().colaFillBelow;
          shopTargetItems = j_;
          bmTargetItems = getgenv().bmTargetItems or O_;
          gmSnipeCaps = getgenv().gmSnipeCaps,
          gmSnipeTargets = getgenv().gmSnipeTargets;
          targetGrades = GE;
          baitTargetTiers = gE;
          webhookUrl = getgenv().webhookUrl;
          webhookPingId = getgenv().webhookPingId;
          webhookThumbUrl = getgenv().webhookThumbUrl,
          webhookBmPingItems = getgenv().webhookBmPingItems;
          webhookCustomersRarities = getgenv().webhookCustomersRarities,
          trainMaxLevel = getgenv().trainMaxLevel;
          trainSelection = getgenv().trainSelection;
          selectedPetKey = getgenv().selectedPetKey;
          carnivalEarnTarget = getgenv().carnivalEarnTarget,
          krakenFish = ((function()
            local s, X = {}, getgenv().krakenFishSet
            if type(X) == "table" then
              for z, l in ipairs({ "Tuna"; "Cod", "Salmon", "Shrimp", "Lobster" }) do
                if X[l] then
                  s[#s + 1] = l
                end
              end
            end
            return s
          end))(),
          krakenFeedCount = getgenv().krakenFeedCount,
          bountyDonateAmount = getgenv().bountyDonateAmount,
          spot = nil,
          farSpot = nil,
          crateSpot = ((getgenv().rarCrateSpotX and getgenv().rarCrateSpotY)) and {
            x = getgenv().rarCrateSpotX;
            y = getgenv().rarCrateSpotY,
            f = getgenv().rarCrateSpotFloor or 1
          } or nil;
          windowSize = ((function()
            local s = (G(function()
              return t.Root
            end) and (t.Root and (t.Root["Parent"] and t.Root))) or getgenv().rarWindowFrame
            if s and s.Parent then
              return {
                w = math.round(s.Size["X"].Offset),
                h = math.round(s.Size["Y"].Offset)
              }
            end
            return nil
          end))()
        }
        if RE then
          local s = I.GetLocal()
          local X = RE
          local z = false
          if s and s.CFrame then
            X = s.CFrame:ToObjectSpace(RE)
            z = true
          end
          local x = X.Position
          local w = X.LookVector
          l.spot = { pos = { x.X, x.Y; x.Z }; look = { w.X; w.Y, w.Z }; isRelative = z }
        end
        if IE then
          local s = I.GetLocal()
          local X = IE
          local z = false
          if s and s.CFrame then
            X = s.CFrame:ToObjectSpace(IE)
            z = true
          end
          local x = X.Position
          local w = X.LookVector
          l.farSpot = { pos = { x.X; x.Y, x.Z }, look = { w.X, w.Y, w.Z }; isRelative = z }
        end
        local x, D = G(H.JSONEncode, H, l)
        if x and type(writefile) == "function" then
          G(writefile, X, D)
          g(b, "✓ Saved " .. s)
          w()
        else
          g(b, "Failed to save! (Exploit not supported)")
        end
      end)
      local j = { [1] = "S"; [2] = "A", [3] = "B"; [4] = "C"; [5] = "D"; [6] = "F" }
      local function O(s)
        local X = M(s)
        if not X then
          return false
        end
        local z, l = G(readfile, X)
        if not z or not l then
          g(b, "Config file not found")
          return false
        end
        local x, w = G(H.JSONDecode, H, l)
        if not x or not w then
          g(b, "Failed to decode config JSON")
          return false
        end
        if w.crops then
          for s, X in pairs(w.crops) do
            l_[s] = X
          end
        end
        if w.rodashSelected then
          for s, X in pairs(w.rodashSelected) do
            t_[s] = X
          end;
          getgenv().rodashSelected = t_
        end
        if w.cropStockLimit ~= nil then
          getgenv().cropStockLimit = w.cropStockLimit
        end
        if w.shopTargetItems then
          for s, X in pairs(w.shopTargetItems) do
            j_[s] = X
          end
        end
        if w.bmTargetItems then
          O_ = w.bmTargetItems;
          getgenv().bmTargetItems = w.bmTargetItems
        end
        if type(w.gmSnipeCaps) == "table" then
          local s = {}
          for X, z in pairs(w.gmSnipeCaps) do
            if type(z) == "number" and z > 0 then
              s[X] = { cap = math.floor(z) }
            elseif type(z) == "table" and (tonumber(z.cap) and tonumber(z.cap) > 0) then
              s[X] = { cap = math.floor(tonumber(z.cap)) }
            end
          end;
          getgenv().gmSnipeCaps = s
        end
        if type(w.gmSnipeTargets) == "table" then
          getgenv().gmSnipeTargets = w.gmSnipeTargets
        end
        if type(w.webhookBmPingItems) == "table" then
          getgenv().webhookBmPingItems = w.webhookBmPingItems
        else
          getgenv().webhookBmPingItems = {}
        end
        if w.autoSellKeepAmount ~= nil then
          getgenv().autoSellKeepAmount = w.autoSellKeepAmount
        end
        if w.coffeeFillBelow ~= nil then
          getgenv().coffeeFillBelow = w.coffeeFillBelow
        end
        if w.colaFillBelow ~= nil then
          getgenv().colaFillBelow = w.colaFillBelow
        end
        if w.targetGrades then
          for s in pairs(GE) do
            GE[s] = nil
          end
          for s, X in pairs(w.targetGrades) do
            GE[tonumber(s) or s] = X
          end
        end
        if type(w.baitTargetTiers) == "table" then
          for s in pairs(gE) do
            gE[s] = nil
          end
          for s, X in pairs(w.baitTargetTiers) do
            if X and type(s) == "string" then
              gE[s] = true
            end
          end
        end
        if w.trainMaxLevel then
          getgenv().trainMaxLevel = math.clamp(tonumber(w.trainMaxLevel) or 10, 2, 10)
        end
        if w.trainSelection then
          getgenv().trainSelection = w.trainSelection
        end
        if w.selectedPetKey then
          getgenv().selectedPetKey = w.selectedPetKey
        end
        if w.carnivalEarnTarget ~= nil then
          getgenv().carnivalEarnTarget = tostring(w.carnivalEarnTarget)
        end
        if type(w.krakenFish) == "table" then
          local s = {}
          for X, z in ipairs(w.krakenFish) do
            if type(z) == "string" then
              s[z] = true
            end
          end
          if next(s) ~= nil then
            getgenv().krakenFishSet = s
          end
        end
        if tonumber(w.krakenFeedCount) then
          getgenv().krakenFeedCount = math.max(0, math.floor(tonumber(w.krakenFeedCount)))
        end
        if tonumber(w.bountyDonateAmount) then
          getgenv().bountyDonateAmount = math.max(0, math.floor(tonumber(w.bountyDonateAmount)))
        end
        if w.webhookUrl then
          getgenv().webhookUrl = w.webhookUrl
        end
        if w.webhookPingId ~= nil then
          getgenv().webhookPingId = w.webhookPingId
        end
        if w.webhookThumbUrl ~= nil then
          getgenv().webhookThumbUrl = w.webhookThumbUrl
        end
        if type(w.webhookCustomersRarities) == "table" then
          getgenv().webhookCustomersRarities = w.webhookCustomersRarities
        end
        if w.spot then
          local s, X = w.spot["pos"], w.spot["look"]
          local z, l = G(function()
            return CFrame.lookAt(Vector3.new(s[1] or 0, s[2] or 0, s[3] or 0), Vector3.new(((s[1] or 0)) + ((X[1] or 0)), ((s[2] or 0)) + ((X[2] or 0)), ((s[3] or 0)) + ((X[3] or 1))))
          end)
          if z and l then
            if w.spot["isRelative"] then
              local s = I.GetLocal()
              RE = ((s and s.CFrame)) and s.CFrame:ToWorldSpace(l) or l
            else
              RE = l
            end
          else
            RE = nil
          end
        else
          RE = nil
        end
        if w.farSpot then
          local s, X = w.farSpot["pos"], w.farSpot["look"]
          local z, l = G(function()
            return CFrame.lookAt(Vector3.new(s[1] or 0, s[2] or 0, s[3] or 0), Vector3.new(((s[1] or 0)) + ((X[1] or 0)), ((s[2] or 0)) + ((X[2] or 0)), ((s[3] or 0)) + ((X[3] or 1))))
          end)
          if z and l then
            if w.farSpot["isRelative"] then
              local s = I.GetLocal()
              IE = ((s and s.CFrame)) and s.CFrame:ToWorldSpace(l) or l
            else
              IE = l
            end
          else
            IE = nil
          end
        else
          IE = nil
        end
        if type(w.crateSpot) == "table" then
          getgenv().rarCrateSpotX = tonumber(w.crateSpot["x"]);
          getgenv().rarCrateSpotY = tonumber(w.crateSpot["y"]);
          getgenv().rarCrateSpotFloor = tonumber(w.crateSpot["f"]) or 1
        else
          getgenv().rarCrateSpotX = nil;
          getgenv().rarCrateSpotY = nil;
          getgenv().rarCrateSpotFloor = nil
        end
        if w.windowSize then
          local s, X = tonumber(w.windowSize["w"]), tonumber(w.windowSize["h"])
          if s and X then
            task.delay(.5, function()
              local z = (G(function()
                return t.Root
              end) and (t.Root and (t.Root["Parent"] and t.Root))) or getgenv().rarWindowFrame
              if z and z.Parent then
                G(function()
                  t:Resize(math.clamp(s, 480, 1400), math.clamp(X, 320, 900))
                end)
              end
            end)
          end
        end
        task.spawn(function()
          local s = .15
          if w.crops and w_ then
            task.wait(s)
            G(function()
              w_:SetValue(l_)
            end)
          end
          if w.rodashSelected and r_ then
            task.wait(s)
            G(function()
              r_:SetValue(t_)
            end)
          end
          if w.shopTargetItems and type(getgenv().updateShopTargetItemsUI) == "function" then
            task.wait(s)
            G(getgenv().updateShopTargetItemsUI)
          end
          if w.bmTargetItems and type(getgenv().updateBmTargetItemsUI) == "function" then
            task.wait(s)
            G(getgenv().updateBmTargetItemsUI)
          end
          if w.webhookBmPingItems and type(getgenv().updateBmWebhookUI) == "function" then
            task.wait(s)
            G(getgenv().updateBmWebhookUI)
          end
          if w.webhookCustomersRarities and type(getgenv().updateCustomersDailyUI) == "function" then
            task.wait(s)
            G(getgenv().updateCustomersDailyUI)
          end
          if w.targetGrades and PetGradeDrop then
            task.wait(s)
            local X = {}
            for s, z in pairs(w.targetGrades) do
              if z and j[tonumber(s) or s] then
                X[j[tonumber(s) or s]] = true
              end
            end
            G(function()
              PetGradeDrop:SetValue(X)
            end)
          end
          if w.baitTargetTiers and type(getgenv().updateBaitTierUI) == "function" then
            task.wait(s)
            G(getgenv().updateBaitTierUI)
          end
          if w.carnivalEarnTarget ~= nil and getgenv().RAREarnTargetDrop then
            task.wait(s)
            G(function()
              getgenv().RAREarnTargetDrop:SetValue((getgenv().carnivalEarnTarget == "TipJar") and "Tip Jar" or "Cashier")
            end)
          end
          if type(w.krakenFish) == "table" and getgenv().RARKrakenFishDrop then
            task.wait(s)
            G(function()
              local s = {}
              for X, z in ipairs(w.krakenFish) do
                if type(z) == "string" then
                  s[#s + 1] = z
                end
              end
              if #s > 0 then
                getgenv().RARKrakenFishDrop:SetValue(s)
              end
            end)
          end
          if tonumber(w.krakenFeedCount) and getgenv().RARKrakenFeedCountInput then
            task.wait(s)
            G(function()
              local s = math.max(0, math.floor(tonumber(w.krakenFeedCount)));
              getgenv().RARKrakenFeedCountInput:SetValue(s > 0 and tostring(s) or "")
            end)
          end
          if tonumber(w.bountyDonateAmount) and getgenv().RARBountyDonateInput then
            task.wait(s)
            G(function()
              local s = math.max(0, math.floor(tonumber(w.bountyDonateAmount)));
              getgenv().RARBountyDonateInput:SetValue(s > 0 and tostring(s) or "")
            end)
          end
          if w.autoSellKeepAmount ~= nil and getgenv().RARSellKeepInput then
            task.wait(s)
            G(function()
              getgenv().RARSellKeepInput:SetValue(tostring(getgenv().autoSellKeepAmount))
            end)
          end
          if w.coffeeFillBelow ~= nil and getgenv().RARCoffeeFillInput then
            task.wait(s)
            G(function()
              getgenv().RARCoffeeFillInput:SetValue(tostring(getgenv().coffeeFillBelow))
            end)
          end
          if w.colaFillBelow ~= nil and getgenv().RARColaFillInput then
            task.wait(s)
            G(function()
              getgenv().RARColaFillInput:SetValue(tostring(getgenv().colaFillBelow))
            end)
          end
          if w.trainSelection and type(getgenv().refreshTrainList) == "function" then
            task.wait(s)
            G(getgenv().refreshTrainList)
          end
          if ((w.gmSnipeTargets or w.gmSnipeCaps)) and type(getgenv().updateGmTargetItemsUI) == "function" then
            task.wait(s)
            G(getgenv().updateGmTargetItemsUI)
            if type(getgenv().refreshGmCapsUI) == "function" then
              G(getgenv().refreshGmCapsUI)
            end
          end
          if w.selectedPetKey and type(getgenv().updateAutoEquipPetUI) == "function" then
            task.wait(s)
            G(getgenv().updateAutoEquipPetUI)
          end
          if w.toggles then
            task.wait(s)
            for s, X in pairs(w.toggles) do
              if d[s] and bE[s] ~= X then
                F()
                G(d[s], X)
                task.wait(.04)
              end
            end
          end
        end)
        g(b, "✓ Loaded " .. s)
        return true
      end
      N.MouseButton1Click:Connect(function()
        local s = z.Text
        local X = M(s)
        if not X then
          return
        end
        if type(readfile) ~= "function" then
          g(b, "Filesystem not supported by exploit")
          return
        end
        O(s)
      end)
      r.MouseButton1Click:Connect(function()
        local s = z.Text
        local X = M(s)
        if not X then
          return
        end
        if type(delfile) == "function" then
          G(delfile, X)
          g(b, "✓ Deleted " .. s)
          w()
        else
          g(b, "Filesystem not supported")
        end
      end)
      w()
      local e = g_ .. "/_autoload.txt"
      local function L()
        if type(readfile) ~= "function" then
          return nil
        end
        local s, X = G(readfile, e)
        if s and (X and X ~= "") then
          return X
        end
        return nil
      end
      k:AddToggle("AutoLoadToggle", {
        Title = "Auto Load on Execute",
        Default = (L() ~= nil),
        Callback = function(s)
          lE("AutoLoadToggle", "Auto Load on Execute", s)
          if s then
            local s = z.Text
            if not s or s == "" then
              g(nil, "Enter a config name first!")
              return
            end
            local X = M(s)
            if not X then
              return
            end
            local l = G(readfile, X)
            if not l then
              g(nil, "Config '" .. (s .. "' not found! Save it first."))
              return
            end
            G(writefile, e, s)
            g(nil, "✓ Will auto-load '" .. (s .. "' on start"))
          else
            if type(delfile) == "function" then
              G(delfile, e)
            elseif type(writefile) == "function" then
              G(writefile, e, "")
            end
            g(nil, "Auto-load disabled")
          end
        end
      })
      local h = L()
      if h then
        task.spawn(function()
          task.wait(3)
          z.Text = h
          local s = xpcall(function()
            return O(h)
          end, function(s)
            return tostring(s) .. ("\n" .. debug.traceback())
          end)
          if not s then
          end
        end)
      end
    end
    do
      local X = { [1] = "S"; [2] = "A", [3] = "B", [4] = "C", [5] = "D", [6] = "F" }
      local l = L:AddParagraph({ Title = "Summary"; Content = "Loading..." })
      task.spawn(function()
        while z() do
          G(function()
            local s = require(Q.Framework["Client"].ClientPetMerchant)
            local z = s.GetState()
            local x = {}
            if z and (z.Offers and #z.Offers > 0) then
              for s, z in ipairs(z.Offers) do
                if type(z) ~= "table" then
                  continue
                end
                local l = z.DirId or z.Name or "Unknown Pet"
                local w = z.Name or ""
                local M = z.Price and ("$" .. tostring(z.Price)) or "$?"
                local D = {}
                if z.Perks then
                  for s, z in pairs(z.Perks) do
                    local l = "F"
                    if z.Grade then
                      l = X[z.Grade] or tostring(z.Grade)
                    end
                    table.insert(D, s .. (" [" .. (l .. "]")))
                  end
                end
                local N = #D > 0 and table.concat(D, ", ") or "No Perks"
                table.insert(x, string.format("• %s \"%s\" (%s)\n   %s", l, w, M, N))
              end
            else
              table.insert(x, "No pets currently in stock or loading...")
            end
            l:SetDesc(table.concat(x, "\n\n"))
          end)
          u(5)
        end
      end)
      L:AddButton({
        Title = "Teleport to Pet Merchant";
        Description = "Teleports your character to the Pet Merchant";
        Icon = "mouse-pointer-click";
        Callback = function()
          local s = workspace:FindFirstChild("__THINGS") and workspace.__THINGS:FindFirstChild("PetMerchant")
          if s then
            local X = 9999
            local z, l = 0, 0
            local w = 0
            for s, x in ipairs(s:GetDescendants()) do
              if x:IsA("BasePart") then
                w = w + 1
                z = z + x.Position["X"]
                l = l + x.Position["Z"]
                if x.Position["Y"] < X then
                  X = x.Position["Y"]
                end
              end
            end
            if w > 0 then
              local s = z / w
              local M = l / w
              local D = game.Players.LocalPlayer["Character"]
              local N = D and D:FindFirstChild("HumanoidRootPart")
              if N then
                local z = Vector3.new(s, X + 4, M + 12)
                x(CFrame.lookAt(z, Vector3.new(s, X + 4, M)))
              end
            end
          end
        end
      })
      do
        local s, X = NE("Auto Buy Pet", "Automatically buys pets from the merchant that meet your target grades.", L)
        local l, x, w = ME("Auto Buy Pet", "", s)
        local M = { "S"; "A"; "B", "C", "D", "F" }
        local D = { S = 1, A = 2; B = 3; C = 4, D = 5; F = 6 }
        local N = { [1] = "S"; [2] = "A", [3] = "B", [4] = "C", [5] = "D"; [6] = "F" }
        local H = s:AddDropdown("PetGradeSelect", { Title = "Target Grades to Keep", Values = M, Multi = true, Default = {} })
        H:OnChanged(function(s)
          GE = {}
          for s, X in pairs(s) do
            if X and D[s] then
              GE[D[s]] = true
            end
          end
        end);
        getgenv().updateTargetGradesUI = function()
          local s = {}
          for X, z in pairs(GE) do
            if z and N[X] then
              s[N[X]] = true
            end
          end
          H:SetValue(s)
        end
        bE.autoBuyPet = false
        jE(x, "autoBuyPet", function()
          xE(w, "", E.green)
        end, function()
          xE(w, "", E.dim)
        end)
        rE(s.Container, { ["Auto Buy Pet"] = 1; ["Target Grades to Keep"] = 2 })
        task.spawn(function()
          while z() do
            G(function()
              if bE.autoBuyPet then
                local s = game:GetService("ReplicatedStorage")
                local X = require(s.Framework["Client"].ClientPetMerchant)
                local z = X.GetState()
                if z and z.Offers then
                  for s, z in ipairs(z.Offers) do
                    if type(z) ~= "table" then
                      continue
                    end
                    if z.Perks then
                      local s = false
                      for X, z in pairs(z.Perks) do
                        if z.Grade and GE[z.Grade] then
                          s = true
                          break
                        end
                      end
                      if s and not z.Purchased then
                        local s, l = G(function()
                          X.Purchase(z.Slot)
                        end)
                        u(1)
                      end
                    end
                  end
                end
              end
            end)
            task.wait(3)
          end
        end)
      end
      do
        local X, l = NE("Auto Equip Pet", "Automatically equips and maintains your selected pet.", L)
        local x, w, M = ME("Auto Equip Pet", "", X)
        local D, N = {}, {}
        local function H()
          local s, X, z = G(function()
            local s = require(game.ReplicatedStorage["Framework"].Client["Saving"])
            local X = s.Get()
            local z = X and X.PetInventory or {}
            local l = {}
            local x = {}
            for s, X in pairs(z) do
              local z = X.DirId or "Pet"
              local w = X.Name or z
              local M = (tostring(s)):sub(1, 6)
              local D = string.format("%s '%s' [%s]", z, w, M)
              table.insert(l, D)
              x[D] = s
            end
            table.sort(l)
            if #l == 0 then
              table.insert(l, "No pets found in inventory")
            end
            return l, x
          end)
          if s and X then
            D = X
            N = z
          end
        end
        H()
        local t = X:AddDropdown("AutoEquipPetSelect", {
          Title = "Target Pet to Equip",
          Values = #D > 0 and D or { "Loading..." };
          Multi = false;
          Default = getgenv().selectedPetKey or nil
        })
        t:OnChanged(function(s)
          if s and (s ~= "No pets found in inventory" and s ~= "Loading...") then
            getgenv().selectedPetKey = s
          end
        end);
        getgenv().updateAutoEquipPetUI = function()
          if getgenv().selectedPetKey then
            t:SetValue(getgenv().selectedPetKey)
          end
        end
        X:AddButton({
          Title = "Refresh Pet List";
          Description = "Updates the dropdown with newly bought.";
          Icon = "refresh-cw";
          Callback = function()
            H()
            p(t, D)
            if s and s.Notify then
              s:Notify({ Title = "Pet List", Content = "Refreshed " .. (#D .. " pets!"); Duration = 2 })
            end
          end
        })
        bE.autoEquipPet = false
        jE(w, "autoEquipPet", function()
          while bE.autoEquipPet and z() do
            G(function()
              local s = getgenv().selectedPetKey
              if not s or s == "" or s == "No pets found in inventory" then
                xE(M, "No pet selected", E.dim)
                return
              end
              local X = N and N[s]
              if not X then
                local z = s:match("%[(%w+)%]$")
                if z then
                  local l = require(game.ReplicatedStorage["Framework"].Client["Saving"])
                  local x = (l.Get()).PetInventory or {}
                  for l, x in pairs(x) do
                    if (tostring(l)):sub(1, 6) == z then
                      X = l
                      N[s] = l
                      break
                    end
                  end
                end
              end
              if not X then
                xE(M, "Pet not found in bag", E.red)
                return
              end
              local z = require(game.ReplicatedStorage["Framework"].Client["ClientPet"])
              local l = z.IsEquipped(X)
              if not l then
                xE(M, "Equipping...", E.yellow)
                local s = require(game.ReplicatedStorage["Framework"].Client["Network"])
                s.Invoke("Pets_Equip", X)
                u(1)
                if z.IsEquipped(X) then
                  xE(M, "Equipped ✓", E.green)
                end
              else
                xE(M, "Active", E.green)
              end
            end)
            u(3)
          end
        end, function()
          xE(M, "Idle", E.dim)
        end)
        rE(X.Container, { ["Auto Equip Pet"] = 1, ["Target Pet to Equip"] = 2; ["Refresh Pet List"] = 3 })
      end
    end
    do
      local X, l = NE("Auto Gifting", "Automatically send and receive gifts.", m)
      local function x(s)
        task.spawn(function()
          for X = 1, 30, 1 do
            task.wait(.1)
            local z = i:FindFirstChild("PlayerGui")
            local l = z and z:FindFirstChild("Message")
            local x = l and l:FindFirstChild("Message")
            if x and x.Visible then
              local X = false
              if s then
                for z, l in ipairs(x:GetDescendants()) do
                  if l:IsA("TextLabel") and l.Text:find(s) then
                    X = true
                    break
                  end
                end
              else
                X = true
              end
              if X then
                x.Visible = false
                x:Destroy()
                break
              end
            end
          end
        end)
      end
      local w, M, D = ME("Auto Accept Gifts", "Automatically accepts all incoming gift requests.", X)
      bE.autoAcceptGifts = false
      local N = nil
      jE(M, "autoAcceptGifts", function()
        local s = require(Q.Framework["Client"].Network)
        N = (s.Fired("Gifting_Broadcast")):Connect(function(X)
          if not bE.autoAcceptGifts then
            return
          end
          if X and (type(X) == "table" and X.TxId) then
            if X.TargetPlayerId == i.UserId and (not X.Canceled and not X.Completed) then
              xE(D, "Accepting from " .. tostring(X.SourceName or "Player"), E.yellow)
              task.spawn(function()
                local z = s.Invoke("Gifting_AcceptRequest", X.TxId)
                if z then
                  xE(D, "Accepted!", E.green)
                end
              end)
              x(X.SourceName)
            end
          end
        end)
        xE(D, "Listening for gifts...", E.green)
      end, function()
        if N then
          N:Disconnect()
          N = nil
        end
        xE(D, "Idle", E.dim)
      end)
      local H, t, r = ME("Auto Send Gifts", "Continuously sends selected gift to selected player.", X)
      local v = { "Loading..." }
      local b = {}
      local g = { "Loading..." }
      local j = {}
      local O = X:AddDropdown("GiftingTargetPlayer", { Title = "Target Player"; Values = v; Multi = false; Default = nil })
      local e = X:AddDropdown("GiftingTargetItem", { Title = "Target Item", Values = g, Multi = false, Default = nil })
      local L = X:AddInput("GiftingQuantity", {
        Title = "Quantity",
        Description = "Number of items to send",
        Default = "1",
        Numeric = true,
        Finished = false,
        Callback = function(s)
          getgenv().giftingQuantity = tonumber(s) or 1
        end
      });
      getgenv().giftingQuantity = 1
      local function h()
        local s = {}
        local X = {}
        for z, l in ipairs(game.Players:GetPlayers()) do
          if l ~= i then
            local z = l.DisplayName
            if l.Name ~= z then
              z = l.Name .. (" (@" .. (z .. ")"))
            else
              z = l.Name
            end
            table.insert(s, z)
            X[z] = l.UserId
          end
        end
        if #s == 0 then
          table.insert(s, "No other players found")
        end
        table.sort(s)
        v = s
        b = X
        p(O, s)
      end
      local function R()
        local s, X, z = G(function()
          local s = {}
          local X = {}
          local z = require(Q.Framework["Universal"].GiftingUtil)
          local l = require(Q.Framework["Directory"].Item)
          local x = require(Q.Framework["Client"].Saving)
          local w = (x.Get()).Inventory or {}
          for x, w in pairs(w) do
            local M = l[x]
            if w > 0 and (M and z.IsGiftable(x)) then
              local z = M.DisplayName or x
              local l = string.format("%s (x%d)", z, w)
              table.insert(s, l)
              X[l] = x
            end
          end
          table.sort(s)
          if #s == 0 then
            table.insert(s, "No giftable items found")
          end
          return s, X
        end)
        if s and X then
          g = X
          j = z
          p(e, X)
        end
      end
      X:AddButton({
        Title = "Refresh Players & Inventory";
        Description = "Updates the dropdown lists.";
        Icon = "refresh-cw";
        Callback = function()
          h()
          R()
          if s and s.Notify then
            s:Notify({ Title = "Gifting", Content = "Refreshed lists!", Duration = 2 })
          end
        end
      })
      O:OnChanged(function(s)
        if s and b[s] then
          getgenv().giftingTargetUserId = b[s]
        end
      end)
      e:OnChanged(function(s)
        if s and j[s] then
          getgenv().giftingTargetItemId = j[s]
        end
      end)
      task.spawn(function()
        task.wait(2)
        h()
        R()
      end)
      bE.autoSendGifts = false
      jE(t, "autoSendGifts", function()
        while bE.autoSendGifts and z() do
          G(function()
            local s = getgenv().giftingTargetUserId
            local X = getgenv().giftingTargetItemId
            local z = getgenv().giftingQuantity or 1
            if not s or not X then
              xE(r, "Missing player or item selection", E.red)
              return
            end
            xE(r, "Sending...", E.yellow)
            local l = require(Q.Framework["Client"].Network)
            l.Fire("Gifting_StartHolding", X)
            task.wait(.2)
            task.spawn(function()
              local X = l.Invoke("Gifting_SendRequest", s, z)
              if X then
                x()
              end
            end)
            xE(r, "Gift request sent!", E.green)
            u(1)
            l.Fire("Gifting_StopHolding")
          end)
          u(3)
        end
      end, function()
        xE(r, "Idle", E.dim)
      end)
      rE(X.Container, {
        ["Auto Accept Gifts"] = 1,
        ["Auto Send Gifts"] = 2,
        ["Target Player"] = 3;
        ["Target Item"] = 4;
        Quantity = 5,
        ["Refresh Players & Inventory"] = 6
      })
    end
    do
      local X, x, w = ME("Auto Reconnect", "Automatically rejoin the game and re-execute the script when you get disconnected or kicked.", Z)
      bE.autoReconnect = false
      jE(x, "autoReconnect", function()
        local X = false
        local function x()
          if X then
            return
          end
          X = true
          s:Notify({ Title = "Reconnect", Content = "⚠️ Auto Reconnect triggered!", Duration = 4 })
          local l = "getgenv().SpectreWare_Authorized = true\nrepeat task.wait(1) until game:IsLoaded()\ntask.wait(2)"
          if type(queue_on_teleport) == "function" then
            G(queue_on_teleport, l)
          elseif type(syn) == "table" and syn.queue_on_teleport then
            G(syn.queue_on_teleport, l)
          elseif type(fluxus) == "table" and fluxus.queue_on_teleport then
            G(fluxus.queue_on_teleport, l)
          end
          u(2)
          G(function()
            (game:GetService("TeleportService")):Teleport(game.PlaceId, game.Players.LocalPlayer)
          end)
          task.wait(10)
          X = false
        end
        local w = game:GetService("CoreGui")
        if w then
          l("AutoReconnect", w.DescendantAdded:Connect(function(s)
            if not bE.autoReconnect or not z() then
              return
            end
            local X = (game:GetService("CoreGui")):FindFirstChild("RobloxPromptGui")
            if not X or not s:IsDescendantOf(X) then
              return
            end
            if s:IsA("TextLabel") or s:IsA("TextButton") then
              local X = string.lower(s.Text)
              if X:find("reconnect") or X:find("leave") or X:find("lost connection") or X:find("disconnected") or X:find("kicked") or X:find("error") or X:find("teleport failed") or X:find("unexpected") then
                task.spawn(x)
              end
            end
          end))
        end
        local M = game:GetService("TeleportService")
        if M and M.TeleportInitFailed then
          l("AutoReconnectTeleport", M.TeleportInitFailed:Connect(function()
            if not bE.autoReconnect or not z() then
              return
            end
            task.spawn(x)
          end))
        end
      end, function()
        l("AutoReconnect", nil)
        l("AutoReconnectTeleport", nil)
      end)
      do
        local function X()
          local s, X = G(function()
            return t.Root
          end)
          if s and (X and X.Parent) then
            return X
          end
          local z = getgenv().rarWindowFrame
          if z and z.Parent then
            return z
          end
          local l, x = nil, 0
          G(function()
            for s, X in ipairs((game:GetService("CoreGui")):GetDescendants()) do
              if X:IsA("Frame") then
                local s = X.AbsoluteSize["X"] * X.AbsoluteSize["Y"]
                if s > x and (X.AbsoluteSize["X"] > 350 and X.AbsoluteSize["Y"] > 250) then
                  x = s
                  l = X
                end
              end
            end
          end)
          return l
        end
        local z, l = NE("Window Size", "Resize the SpectreWare window to a preset size.", Z)
        local x = {
          { label = "XS", w = 400; h = 260 },
          { label = "Small"; w = 560; h = 360 },
          { label = "Medium", w = 750, h = 500 };
          { label = "Large", w = 1000, h = 680 }
        }
        for l, x in ipairs(x) do
          z:AddButton({
            Title = x.label .. (" - " .. (x.w .. (" x " .. x.h)));
            Icon = "layout",
            Callback = function()
              local z = X()
              if z then
                G(function()
                  t:Resize(x.w, x.h)
                end);
                getgenv().rarWindowFrame = z
                s:Notify({
                  Title = "Window Size";
                  Content = x.label .. ("  (" .. (x.w .. ("x" .. (x.h .. ")")))),
                  Duration = 2
                })
              else
                s:Notify({ Title = "Window Size", Content = "Could not find window frame.", Duration = 3 })
              end
            end
          })
        end
      end
      local M, D, N = ME("Anti AFK", "Prevents you from being kicked for being idle for 20 minutes.", Z)
      jE(D, "antiAfk", function()
        local s = game:GetService("VirtualUser")
        l("AntiAFK", i.Idled:Connect(function()
          if not bE.antiAfk or not z() then
            return
          end
          G(function()
            s:CaptureController()
            s:ClickButton2(Vector2.new())
          end)
        end))
      end, function()
        l("AntiAFK", nil)
      end)
    end
    do
      local function s(s)
        local X = {}
        setmetatable(X, {
          __newindex = function(X, z, l)
            if z == "Text" then
              s:SetValue(l)
            end
          end
        })
        return X
      end
      local X = U:AddInput("WebhookURL", {
        Title = "Webhook URL",
        Description = "Paste your Discord webhook URL",
        Default = getgenv().webhookUrl or "";
        Placeholder = "https://discord.com/api/webhooks/...";
        Numeric = false,
        Finished = false;
        Callback = function(s)
          getgenv().webhookUrl = s
        end
      });
      getgenv().webhookUrlBox = s(X)
      U:AddButton({
        Title = "Test Webhook",
        Description = "Send a test message to verify your URL.",
        Icon = "mouse-pointer-click",
        Callback = function()
          task.spawn(function()
            nE(true)
          end)
        end
      })
      local x = U:AddInput("WebhookPing", {
        Title = "Webhook Ping ID";
        Description = "Discord User ID",
        Default = getgenv().webhookPingId or "";
        Placeholder = "123456789012345678";
        Numeric = false,
        Finished = false;
        Callback = function(s)
          getgenv().webhookPingId = s
        end
      });
      getgenv().webhookPingBox = s(x);
      getgenv().webhookPingId = getgenv().webhookPingId or "";
      getgenv().webhookThumbUrl = getgenv().webhookThumbUrl or "https://i.imgur.com/B31LD8G.png"
      local w, M, D = ME("Webhook on Crate Catch", "Sends a webhook when a crate is caught.", U)
      bE.webhookCrate = false
      jE(M, "webhookCrate", function()
        xE(D, "", E.green)
      end, function()
        xE(D, "", E.dim)
      end)
      local N, H, t = ME("Webhook on Crate Opened", "Sends a webhook when a crate is opened.", U)
      bE.webhookCrateOpened = false
      jE(H, "webhookCrateOpened", function()
        xE(t, "", E.green)
      end, function()
        xE(t, "", E.dim)
      end)
      local r, v, b = ME("Webhook on Pet Purchase", "Sends a webhook when a pet is bought.", U)
      bE.webhookPet = false
      jE(v, "webhookPet", function()
        xE(b, "", E.green)
      end, function()
        xE(b, "", E.dim)
      end)
      local g, j, O = ME("Webhook on BM Purchase", "Sends a webhook when buying from the Black Market.", U)
      bE.webhookBm = false
      jE(j, "webhookBm", function()
        xE(O, "", E.green)
      end, function()
        xE(O, "", E.dim)
      end);
      getgenv().webhookBmPingItems = getgenv().webhookBmPingItems or {}
      local e = {
        "Ski Lodge Wall";
        "Ski Lodge Window";
        "Ski Lodge Doorway",
        "String Lights",
        "Italian Cypress",
        "Basic Sprinkler",
        "Trellis";
        "Geometric Chandelier";
        "Gargoyle",
        "Ski Lodge Chair";
        "Ski Lodge Table",
        "Modern Sign",
        "Gothic Wall";
        "Gothic Window";
        "Gothic Doorway";
        "Gothic Chair",
        "Gothic Table";
        "Windmill";
        "Pool Table",
        "Large Sprinkler",
        "Prep Kitchen",
        "Giant Beehive";
        "Wishing Fountain";
        "Lucky Cat Tip Jar"
      }
      local L = U:AddDropdown("BMPingItems", { Title = "Black Market Items to Ping"; Values = e; Multi = true; Default = {} });
      getgenv().BMPingDrop = L
      do
        local s, X = {}, {}
        local function z(z)
          z = tostring(z)
          if z ~= "" and not s[z] then
            s[z] = true
            X[#X + 1] = z
          end
        end
        for s, X in ipairs(e) do
          z(X)
        end
        for s, X in ipairs(getgenv().bmAdaptiveItems or {}) do
          z(X)
        end
        table.sort(X)
        if #X > #e then
          L:SetValues(X)
        end
      end
      L:OnChanged(function(s)
        getgenv().webhookBmPingItems = {}
        for s, X in pairs(s) do
          if X then
            getgenv().webhookBmPingItems[s] = true
          end
        end
      end);
      getgenv().updateBmWebhookUI = function()
        local s = {}
        for X, z in pairs(getgenv().webhookBmPingItems or {}) do
          if z then
            s[X] = true
          end
        end
        L:SetValue(s)
      end
      local h, m, Q = ME("Webhook on Booth Sale", "", U)
      bE.webhookBoothSale = false
      jE(m, "webhookBoothSale", function()
        xE(Q, "", E.green)
      end, function()
        xE(Q, "", E.dim)
      end)
      local R, I, W = ME("Webhook on Market Snipe", "Pings when the global-market sniper buys a listing.", U)
      bE.gmSnipePing = false
      jE(I, "gmSnipePing", function()
        xE(W, "", E.green)
      end, function()
        xE(W, "", E.dim)
      end)
      do
        local s = 0
        local function X()
          s = os.clock()
        end
        G(function()
          local s = require(game.ReplicatedStorage["Framework"].Client["TradingBoothCmds"])
          if s.CreateListing then
            local z = s.CreateListing
            s.CreateListing = function(...)
              X()
              return z(...)
            end
          end
          if s.CreatePetListing then
            local z = s.CreatePetListing
            s.CreatePetListing = function(...)
              X()
              return z(...)
            end
          end
          if s.DeleteListing then
            local z = s.DeleteListing
            s.DeleteListing = function(...)
              X()
              return z(...)
            end
          end
        end)
        G(function()
          local s = require(game.ReplicatedStorage["Framework"].Client["Network"])
          if type(s.Invoke) == "function" then
            local z = s.Invoke
            s.Invoke = function(s, l, ...)
              local x = type(s) == "string" and s or type(l) == "string" and l or ""
              if x == "TradingBooth_Create" or x == "TradingBooth_CreatePet" or x == "TradingBooth_Delete" then
                X()
              end
              return z(s, l, ...)
            end
          end
        end)
        task.spawn(function()
          local X = require(game.ReplicatedStorage["Framework"].Client["TradingBoothCmds"])
          local z = {}
          local function x()
            local s = {}
            local l, x = G(X.GetListings, i)
            if l and type(x) == "table" then
              for X, z in ipairs(x) do
                if type(z) == "table" and z.ListingId then
                  s[tostring(z.ListingId)] = {
                    item = tostring(z.ItemId or "?");
                    price = tonumber(z.Price) or 0;
                    qty = tonumber(z.Quantity) or 0
                  }
                end
              end
            end
            z = s
          end
          local function w()
            local l = {}
            local x, w = G(X.GetListings, i)
            if x and type(w) == "table" then
              for s, X in ipairs(w) do
                if type(X) == "table" and X.ListingId then
                  l[tostring(X.ListingId)] = {
                    item = tostring(X.ItemId or "?"),
                    price = tonumber(X.Price) or 0,
                    qty = tonumber(X.Quantity) or 0
                  }
                end
              end
            end
            if os.clock() - s < 3 then
              z = l
              return
            end
            local M = {}
            for s, X in pairs(z) do
              local z = l[s]
              local x = z and z.qty or 0
              if x < X.qty then
                local s = X.qty - x
                M[#M + 1] = {
                  item = X.item;
                  qty = s,
                  earned = math.floor(((z and z.price or X.price)) * s)
                }
              end
            end
            z = l
            if #M > 0 and bE.webhookBoothSale then
              kE(M)
            end
          end
          task.wait(3)
          x()
          local M, D = G(function()
            return X.OnChanged(i, w)
          end)
          if M and D then
            l("boothSaleWatcher", D)
          end
        end)
      end
      local S, n, Y = ME("Webhook on Disconnect", "Sends a webhook when you get disconnected or kicked.", U)
      bE.webhookDisconnect = false
      jE(n, "webhookDisconnect", function()
        local function s()
          local s = getgenv().webhookUrl or ""
          if s == "" then
            return
          end
          local X = ""
          local z = getgenv().webhookPingId or ""
          if z ~= "" then
            X = "<@" .. (z .. "> ")
          end
          local l = (type(request) == "function" and request) or (type(http_request) == "function" and http_request) or (type(syn) == "table" and syn.request) or (type(fluxus) == "table" and fluxus.request)
          if l then
            local z = {
              content = X .. ("⚠️ **" .. (game.Players.LocalPlayer["Name"] .. "** disconnected/kicked from the game!")),
              embeds = {
                {
                  title = "Disconnected",
                  color = 16711680,
                  fields = {
                    { name = "Account", value = game.Players.LocalPlayer["Name"]; inline = true },
                    { name = "Time", value = os.date("%X"); inline = true }
                  }
                }
              }
            }
            G(function()
              l({
                Url = s,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = (game:GetService("HttpService")):JSONEncode(z)
              })
            end)
          end
        end
        local X = game:GetService("CoreGui")
        if X then
          l("WebhookDisconnectCoreGui", X.DescendantAdded:Connect(function(X)
            if not bE.webhookDisconnect or not z() then
              return
            end
            local x = (game:GetService("CoreGui")):FindFirstChild("RobloxPromptGui")
            if not x or not X:IsDescendantOf(x) then
              return
            end
            if X:IsA("TextLabel") or X:IsA("TextButton") then
              local z = string.lower(X.Text)
              if z:find("reconnect") or z:find("leave") or z:find("lost connection") or z:find("disconnected") or z:find("kicked") or z:find("error") or z:find("teleport failed") or z:find("unexpected") then
                task.spawn(s)
                l("WebhookDisconnectCoreGui", nil)
                l("WebhookDisconnectTeleport", nil)
              end
            end
          end))
        end
        local x = game:GetService("TeleportService")
        if x and x.TeleportInitFailed then
          l("WebhookDisconnectTeleport", x.TeleportInitFailed:Connect(function()
            if not bE.webhookDisconnect or not z() then
              return
            end
            task.spawn(s)
            l("WebhookDisconnectCoreGui", nil)
            l("WebhookDisconnectTeleport", nil)
          end))
        end
      end, function()
        l("WebhookDisconnectCoreGui", nil)
        l("WebhookDisconnectTeleport", nil)
      end)
      local k, J, V = ME("Webhook on Milestone", "Sends a webhook when you claim a milestone reward.", U)
      bE.webhookMilestone = false
      jE(J, "webhookMilestone", function()
        local s, X = G(require, game.ReplicatedStorage["Framework"].Client["MilestoneCmds"])
        local l = {}
        while bE.webhookMilestone and z() do
          if s and X then
            G(function()
              local s = X.GetCategories()
              for s, z in ipairs(s) do
                local x = X.GetMilestonesInCategory(z)
                for s, z in ipairs(x) do
                  if not bE.webhookMilestone then
                    break
                  end
                  if X.IsClaimable(z) then
                    local s = tostring(z._id or z.Id or tostring(z))
                    if not l[s] then
                      l[s] = true
                      local X = "Unknown Reward"
                      G(function()
                        local s = z.Reward or z.rewards or z.Rewards
                        if type(s) == "table" then
                          local z = {}
                          for s, X in pairs(s) do
                            if type(X) == "table" then
                              local s = {}
                              for X, z in pairs(X) do
                                s[#s + 1] = tostring(z)
                              end
                              z[#z + 1] = table.concat(s, " ")
                            else
                              z[#z + 1] = tostring(s) .. (": " .. tostring(X))
                            end
                          end
                          if #z > 0 then
                            X = table.concat(z, ", ")
                          end
                        elseif type(s) == "string" then
                          X = s
                        end
                      end)
                      task.spawn(function()
                        local l = getgenv().webhookUrl or ""
                        if l == "" then
                          return
                        end
                        local x = table.concat({
                          "**-> Profile :**";
                          ("> Username : `%s`"):format(i.Name),
                          "";
                          "**-> Milestone :**";
                          ("> %s"):format(tostring(z.Name or z.DisplayName or s)),
                          "",
                          "**-> Rewards :**";
                          ("> %s"):format(X)
                        }, "\n")
                        local w = ""
                        if ((getgenv().webhookPingId or "")) ~= "" then
                          w = "<@" .. (getgenv().webhookPingId .. "> ")
                        end
                        local M = (game:GetService("HttpService")):JSONEncode({
                          content = (w ~= "" and w or nil);
                          embeds = {
                            {
                              title = "SpectreWare | Run A Restaurant";
                              description = x;
                              color = 5793266,
                              timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                            }
                          }
                        })
                        G(function()
                          local s = (type(request) == "function" and request) or (type(http_request) == "function" and http_request) or (type(syn) == "table" and syn.request) or (type(fluxus) == "table" and fluxus.request)
                          if s then
                            s({
                              Url = l;
                              Method = "POST";
                              Headers = { ["Content-Type"] = "application/json" },
                              Body = M
                            })
                          end
                        end)
                      end)
                    end
                  end
                end
              end
            end)
          end
          u(10)
        end
      end, function()
        xE(V, "", E.dim)
      end)
      local B, Z, f = ME("Webhook Daily Summary", "Every game day (~20 min): waits, earnings, bonus, diamonds, customers.", U)
      bE.webhookDailySummary = false
      jE(Z, "webhookDailySummary", function()
        xE(f, "", E.green)
      end, function()
        xE(f, "", E.dim)
      end);
      getgenv().webhookCustomersRarities = getgenv().webhookCustomersRarities or {}
      local F = U:AddDropdown("CustomersDailyRarity", { Title = "Customer Rarity", Values = fE, Multi = true; Default = {} })
      F:OnChanged(function(s)
        local X = {}
        for s, z in pairs(s or {}) do
          if z then
            X[tostring(s)] = true
          end
        end;
        getgenv().webhookCustomersRarities = X
      end);
      getgenv().updateCustomersDailyUI = function()
        local s = {}
        for X, z in pairs(getgenv().webhookCustomersRarities or {}) do
          if z then
            s[X] = true
          end
        end
        F:SetValue(s)
      end
      do
        local s = false
        for X, z in ipairs(fE) do
          if getgenv().webhookCustomersRarities and getgenv().webhookCustomersRarities[z] then
            s = true
            break
          end
        end
        if not s then
          local s = {}
          for X, z in ipairs(fE) do
            s[z] = true
          end;
          getgenv().webhookCustomersRarities = s
          G(function()
            F:SetValue(s)
          end)
        end
      end
    end
    local function e_(s)
      local X = getgenv().webhookUrl or ""
      if X == "" then
        return
      end
      if not bE.webhookPet then
        return
      end
      local z = G(function()
        local z = require(Q.Framework["Directory"].PetPerk)
        local l = require(Q.Framework["Types"].PetTypes)
        local x = s.PetData or {}
        local w = x.Name or "Unknown"
        local M = x.DirId or (s.PetDir and s.PetDir["_id"]) or "Unknown"
        local function D(s)
          return l.GradesInv[s] or ("G" .. tostring(s))
        end
        local N = {}
        for s, X in pairs(x.Perks or {}) do
          local l = z[s]
          local x = l and l.DisplayName or s
          table.insert(N, string.format("> %s : `%s` (Lv %d)", x, D(X.Grade), X.CurrentLevel or 1))
        end
        table.sort(N)
        local t = table.concat({
          "**-> Profile :**",
          ("> Username : `%s`"):format(i.Name);
          "";
          "**-> Pet Purchased :**";
          ("> Pet Name  : `%s`"):format(w);
          ("> Pet Type  : `%s`"):format(M);
          "";
          "**-> Perks :**",
          #N > 0 and table.concat(N, "\n") or "> None"
        }, "\n")
        local r = {
          title = "SpectreWare | Pet Purchased";
          description = t,
          color = 16766720;
          timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
        local v = getgenv().webhookPingId or ""
        local b = v ~= "" and ("<@%s>"):format(v) or nil
        local g = H:JSONEncode({ content = b, embeds = { r } })
        local j = type(http_request) == "function" and http_request or type(request) == "function" and request or nil
        if j then
          G(j, {
            Url = X,
            Method = "POST";
            Headers = { ["Content-Type"] = "application/json" };
            Body = g
          })
        end
      end)
    end
    task.spawn(function()
      local s = require(Q.Framework["Client"].ClientPet)
      local X = {}
      for s, z in ipairs(s.GetAll()) do
        X[z.PetId] = true
      end
      s.Created:Connect(function(s)
        if not z() then
          return
        end
        if X[s.PetId] then
          return
        end
        X[s.PetId] = true
        if getgenv()._rar_expectPetPurchase and h() - getgenv()._rar_expectPetPurchase < 10 then
          getgenv()._rar_expectPetPurchase = nil
          task.wait(.5)
          task.spawn(e_, s)
        end
      end)
      if not getgenv()._rarPetMerchantHooked then
        getgenv()._rarPetMerchantHooked = true
        task.spawn(function()
          local s = require(Q.Framework["Client"].ClientPetMerchant)
          local X = s.Purchase
          s.Purchase = function(s, ...)
            getgenv()._rar_expectPetPurchase = h()
            return X(s, ...)
          end
        end)
      end
    end)
    local function L_(s, X)
      local z = getgenv().webhookUrl or ""
      if z == "" then
        return
      end
      local l = G(function()
        local l = (require(Q.Framework["Directory"].Item))[s] or {}
        local x = l.DisplayName or s
        local w = tonumber(X) or 1
        local M = table.concat({
          "**-> Profile :**",
          ("> Username : `%s`"):format(i.Name);
          "",
          "**-> Black Market Item Purchased :**",
          ("> Item Name : `%s`"):format(x),
          ("> Quantity  : `%d`"):format(w)
        }, "\n")
        local D = getgenv().webhookThumbUrl or ""
        local N = D ~= "" and { url = D } or nil
        local t = {
          title = "SpectreWare | Black Market Purchased",
          description = M;
          color = 16711680,
          timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ");
          thumbnail = N
        }
        local r = getgenv().webhookPingId or ""
        local v = r ~= "" and ("<@%s>"):format(r) or nil
        local b = H:JSONEncode({ content = v; embeds = { t } })
        local g = type(http_request) == "function" and http_request or type(request) == "function" and request or nil
        if g then
          G(g, {
            Url = z,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = b
          })
        end
      end)
    end
    if not getgenv()._rarBmHooked then
      getgenv()._rarBmHooked = true
      task.spawn(function()
        local s = require(Q.Framework["Client"].BlackMarketCmds)
        local X = s.Purchase
        s.Purchase = function(s, z)
          local l = { X(s, z) }
          local x = s
          local w = z or 1
          if l[1] and (bE.webhookBm and (getgenv().webhookBmPingItems and getgenv().webhookBmPingItems[x])) then
            task.spawn(L_, x, w)
          end
          return unpack(l)
        end
      end)
    end
    do
      local s = require(Q.Framework["Client"].StaffLevelingCmds)
      local X = require(Q.Framework["Types"].StaffLevelingTypes)
      local x = table.pack(G(require, Q.Framework["Functions"].Commas));
      getgenv().trainSelection = getgenv().trainSelection or {};
      getgenv().trainMaxLevel = math.clamp(tonumber(getgenv().trainMaxLevel) or 10, 2, 10);
      getgenv()._rar_trainWake = false
      local function w(s)
        if x[1] and type(x[2]) == "function" then
          local X, z = G(x[2], s)
          if X then
            return tostring(z)
          end
        end
        return tostring(s)
      end
      local M = {
        Cook = "Cook";
        Waiter = "Waiter",
        Cashier = "Cashier",
        Host = "Host",
        Janitor = "Janitor";
        Security = "Security",
        Entertainer = "Entertainer";
        Gardener = "Gardener";
        Chef = "Chef",
        Bartender = "Bartender"
      }
      local function N()
        local s = {}
        local z = I.GetLocal()
        if not z then
          return s
        end
        local l = {}
        if X and type(X.Config) == "table" then
          for s in pairs(X.Config) do
            l[s] = true
          end
        end
        if next(l) == nil then
          for s, X in pairs(M) do
            l[X] = true
          end
        end
        for l in pairs(l) do
          if l == "Manager" then
            _G.__c = _G.__c
          end
          for z, x in ipairs(P(z, l) or {}) do
            local w, M = false, nil
            G(function()
              w = (x:GetOwner() == i)
              M = x:GetDirectory()
            end)
            if w then
              s[#s + 1] = {
                e = x;
                sub = l;
                name = M and M.DisplayName or "?";
                lvl = ((function()
                  local s = X and X.LevelKey
                  if not s then
                    return 1
                  end
                  local z, l = G(function()
                    return x:GetSave(s)
                  end)
                  return tonumber(z and l) or 1
                end))()
              }
            end
          end
        end
        table.sort(s, function(s, X)
          local z = tostring(s.sub)
          local l = tostring(X.sub)
          if z == l then
            return ((tonumber(s.lvl) or 1)) > ((tonumber(X.lvl) or 1))
          end
          return z < l
        end)
        return s
      end
      local H, t, r = ME("Auto Train Staff", "Automatically trains selected staff up to the max level.", f)
      local function v(s)
        local X = {}
        setmetatable(X, {
          __newindex = function(X, z, l)
            if z == "Text" then
              s:SetValue((tostring(l)):match("%d+") or "10")
            end
          end
        })
        return X
      end
      local b = f:AddDropdown("TrainSelect", { Title = "Staff to Train"; Values = {}, Multi = true, Default = {} })
      b:OnChanged(function(s)
        getgenv().trainSelection = {}
        for s, X in pairs(s) do
          if X and s ~= "No staff found. Hire employees first." then
            local X = s:match("^(.-)%s*%[Lvl %d+%]$") or s;
            getgenv().trainSelection[X] = true
          end
        end
      end)
      local function g()
        local s = N()
        local X = {}
        for s, z in ipairs(s) do
          local l = z.sub .. ("|" .. z.name)
          local x = l .. (" [Lvl " .. (z.lvl .. "]"))
          table.insert(X, x)
        end
        if #X == 0 then
          table.insert(X, "No staff found. Hire employees first.")
        end
        return X
      end
      local function j()
        local s = g()
        F()
        local X, z = G(function()
          b:SetValues(s)
        end)
        if not X then
          G(function()
            if b and type(b.Destroy) == "function" then
              b:Destroy()
            end
          end)
          b = f:AddDropdown("TrainSelect", { Title = "Staff to Train"; Values = s; Multi = true, Default = {} })
          b:OnChanged(function(s)
            getgenv().trainSelection = {}
            for s, X in pairs(s) do
              if X and s ~= "No staff found. Hire employees first." then
                local X = s:match("^(.-)%s*%[Lvl %d+%]$") or s;
                getgenv().trainSelection[X] = true
              end
            end
          end)
        else
          local s = {}
          local X = N()
          for X, z in ipairs(X) do
            local l = z.sub .. ("|" .. z.name)
            if getgenv().trainSelection and getgenv().trainSelection[l] then
              local X = l .. (" [Lvl " .. (z.lvl .. "]"))
              s[X] = true
            end
          end
          G(function()
            b:SetValue(s)
          end)
        end
      end;
      getgenv().refreshTrainList = j
      local O = f:AddInput("TrainLvl", {
        Title = "Max Training Level",
        Description = "Level 2 - 10 (default 10)",
        Default = tostring(getgenv().trainMaxLevel),
        Numeric = true,
        Finished = false;
        Callback = function(s)
          local X = tonumber(s)
          if X then
            getgenv().trainMaxLevel = math.clamp(math.floor(X), 2, 10)
            xE(r, "Training capped at level " .. getgenv().trainMaxLevel, E.blue)
          end
        end
      });
      getgenv().trainLevelBox = v(O)
      f:AddButton({
        Title = "Refresh Staff List",
        Description = "Updates the list of staff you currently own.",
        Icon = "mouse-pointer-click";
        Callback = function()
          G(j)
        end
      })
      local e = 0
      jE(t, "trainStaff", function()
        getgenv()._rar_trainWake = false
        while bE.trainStaff and z() do
          local z = I.GetLocal()
          if not z then
            u(1) continue
          end
          if h() - e > 5 then
            e = h()
          end
          local l, x = G(N)
          if not l then
            x = {}
          end
          local M = math.huge
          local D = 0
          for X, z in ipairs(x) do
            local l, x = G(function()
              return s.IsTraining(z.e)
            end)
            if l and x then
              D += 1
            end
          end
          if D < M then
            local z = {}
            for l, x in ipairs(x) do
              local w = x.sub .. ("|" .. x.name)
              if not getgenv().trainSelection[w] then
                continue
              end
              if x.lvl >= getgenv().trainMaxLevel then
                continue
              end
              local M, D = G(function()
                return s.IsTraining(x.e)
              end)
              if M and D then
                continue
              end
              local N = X.GetTier(x.sub, x.lvl + 1)
              z[#z + 1] = { key = w; s = x, cost = N and N.Cost or math.huge }
            end
            table.sort(z, function(s, X)
              return s.cost < X.cost
            end)
            for z, l in ipairs(z) do
              if not bE.trainStaff then
                break
              end
              if D >= M then
                break
              end
              local x = l.s
              local N, H = G(function()
                return s.CanTrain(x.e)
              end)
              if N and H then
                local z, l, M = G(s.StartTraining, x.e:GetId())
                if z and l == true then
                  D += 1
                  local s = X.GetTier(x.sub, x.lvl + 1)
                  xE(r, ("✓ %s (%s) training → Lv %d (%s $)"):format(x.name, x.sub, x.lvl + 1, s and w(s.Cost) or "?"), E.green)
                else
                  local s = tostring(l or "err")
                  if z and type(l) == "string" then
                    s = l
                  end
                  xE(r, "Train failed: " .. s, E.gold)
                end
              end
              u(.4)
            end
          end
          if D > 0 then
            local z = {}
            local l = nil
            for x, w in ipairs(x) do
              local M, D = G(function()
                return s.IsTraining(w.e)
              end)
              if M and D then
                z[#z + 1] = w.name
                local s = tonumber(w.e:GetSave(X.TrainingKey)) or 0
                local x = s - workspace:GetServerTimeNow()
                if not l or (x < l.left) then
                  l = { name = w.name; left = x, endT = s }
                end
              end
            end
            local w = 0
            while bE.trainStaff and (not getgenv()._rar_trainWake and w < 60) do
              if l and l.endT then
                local s = l.endT - workspace:GetServerTimeNow()
                if s > 0 then
                  local X = math.floor(s / 60)
                  local z = math.floor(s % 60)
                  xE(r, ("Training %s · %d active (%dm %02ds to next)"):format(l.name, D, X, z), E.blue)
                else
                  xE(r, ("Training %s · %d active (0m 00s to next)"):format(l.name, D), E.blue)
                end
              end
              u(1)
              w += 1
            end;
            getgenv()._rar_trainWake = false continue
          end
        end
        xE(r, "Idle");
        getgenv()._rar_trainWake = false
      end, function()
      end)
      l("TrainChanged", (R.Fired("StaffLeveling_Changed")):Connect(function()
        if bE.trainStaff then
          getgenv()._rar_trainWake = true
        end
      end))
      local L = 0
      local m = 0
      l("TrainListTicker", D.Heartbeat:Connect(function(z)
        if not bE.trainStaff then
          L = L + z
          if L >= 5 then
            L = 0
          end
          m = m + z
          if m >= 2 then
            m = 0
            local z, l = G(N)
            if not z then
              l = {}
            end
            local x = 0
            local w = nil
            for z, l in ipairs(l) do
              local M, D = G(function()
                return s.IsTraining(l.e)
              end)
              if M and D then
                x += 1
                local s = tonumber(l.e:GetSave(X.TrainingKey)) or 0
                local z = s - workspace:GetServerTimeNow()
                if not w or (z < w.left) then
                  w = { name = l.name, left = z, endT = s }
                end
              end
            end
            if x > 0 and (w and w.endT) then
              local s = w.endT - workspace:GetServerTimeNow()
              if s > 0 then
                local X = math.floor(s / 60)
                local z = math.floor(s % 60)
                xE(r, ("Training %s · %d active (%dm %02ds to next)"):format(w.name, x, X, z), E.dim)
              else
                xE(r, ("Training %s · %d active (0m 00s to next)"):format(w.name, x), E.dim)
              end
            else
              xE(r, "Idle")
            end
          end
        end
      end))
      a(j)
    end
    wE("Main")
    if getgenv().SpectreWare_MiniIcon then
      G(function()
        getgenv().SpectreWare_MiniIcon:Destroy()
      end)
    end
    local h_ = Instance.new("ScreenGui")
    h_.Name = "SpectreWare_MiniIcon"
    h_.ResetOnSpawn = false
    h_.DisplayOrder = 1000
    local i_ = G(function()
      h_.Parent = game:GetService("CoreGui")
    end)
    if not i_ then
      h_.Parent = (game:GetService("Players")).LocalPlayer["PlayerGui"]
    end;
    getgenv().SpectreWare_MiniIcon = h_
    local m_ = Instance.new("TextButton")
    m_.Name = "MiniBtn"
    m_.Size = UDim2.new(0, 50, 0, 50)
    m_.Position = UDim2.new(.5, -25, 0, 5)
    m_.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    m_.BackgroundTransparency = .2
    m_.Text = "J"
    m_.TextColor3 = Color3.fromRGB(60, 195, 205)
    m_.Font = Enum.Font.GothamBold
    m_.TextSize = 24
    m_.Parent = h_
    local Q_ = Instance.new("UICorner")
    Q_.CornerRadius = UDim.new(.3, 0)
    Q_.Parent = m_
    local R_ = Instance.new("UIStroke")
    R_.Color = Color3.fromRGB(60, 195, 205)
    R_.Thickness = 2
    R_.Parent = m_
    local I_ = false
    local W_, S_
    m_.InputBegan:Connect(function(s)
      if s.UserInputType == Enum.UserInputType.MouseButton1 or s.UserInputType == Enum.UserInputType.Touch then
        I_ = true
        W_ = s.Position
        S_ = m_.Position
        s.Changed:Connect(function()
          if s.UserInputState == Enum.UserInputState.End then
            I_ = false
          end
        end)
      end
    end);
    (game:GetService("UserInputService")).InputChanged:Connect(function(s)
      if I_ and ((s.UserInputType == Enum.UserInputType.MouseMovement or s.UserInputType == Enum.UserInputType.Touch)) then
        local X = s.Position - W_
        m_.Position = UDim2.new(S_.X["Scale"], S_.X["Offset"] + X.X, S_.Y["Scale"], S_.Y["Offset"] + X.Y)
      end
    end)
    local n_ = 0
    local Y_ = 0
    m_.Visible = false
    local k_ = t.Root and t.Root["Parent"]
    local J_ = t.Root
    G(function()
      local X = t.TitleBar
      if X and X.Frame then
        if X.MaxButton and X.MaxButton["Frame"] then
          X.MaxButton["Frame"].Visible = false
        end
        t.Minimize = function(X)
          G(function()
            if s and s.ToggleAcrylic then
              s:ToggleAcrylic(false)
            end
          end)
          if k_ then
            k_.Enabled = false
          end
          m_.Visible = true
        end
        if X.MinButton and X.MinButton["Frame"] then
          X.MinButton["Frame"].MouseButton1Click:Connect(function()
            t:Minimize()
          end)
        end
      end
    end)
    m_.InputEnded:Connect(function(X)
      if X.UserInputType == Enum.UserInputType.MouseButton1 or X.UserInputType == Enum.UserInputType.Touch then
        if W_ then
          Y_ = ((X.Position - W_)).Magnitude
        end
        if Y_ < 5 and h() - n_ > .2 then
          n_ = h()
          m_.Visible = false
          if k_ then
            k_.Enabled = true
          end
          G(function()
            if s and s.ToggleAcrylic then
              s:ToggleAcrylic(true)
            end
          end)
        end
      end
    end)
  end)
end)(...)
