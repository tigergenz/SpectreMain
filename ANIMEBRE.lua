--[[
   SPECTREWARE — ANIME BREAKER
   Interface: SPECTREWARE UI v1.0.6 (built into this file; see the SPECTREWARE_UI line)
   Gameplay functions: cook45 x clack, latest supplied source (213712)
   Target Place: 109928390521457
]]

if getgenv and type(getgenv()._AnimeBreakerCleanup) == "function" then
    pcall(getgenv()._AnimeBreakerCleanup)
    getgenv()._AnimeBreakerCleanup = nil
end

if _G.AnimeBreaker_HeartbeatConnection then
    pcall(function() _G.AnimeBreaker_HeartbeatConnection:Disconnect() end)
    _G.AnimeBreaker_HeartbeatConnection = nil
end
if _G.AnimeBreaker_NoClipConn then
    pcall(function() _G.AnimeBreaker_NoClipConn:Disconnect() end)
    _G.AnimeBreaker_NoClipConn = nil
end
for _, key in ipairs({ "AnimeBreaker_AntiAFKConnection", "AnimeBreaker_RejoinConnection" }) do
    if _G[key] then pcall(function() _G[key]:Disconnect() end); _G[key] = nil end
end
if _G.AnimeBreaker_Connections then
    for _, connection in ipairs(_G.AnimeBreaker_Connections) do
        pcall(function() connection:Disconnect() end)
    end
end
_G.AnimeBreaker_Connections = {}

pcall(function()
    local CoreGui = game:GetService("CoreGui")
    local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    local function purge(p)
        if not p then return end
        for _, c in ipairs(p:GetChildren()) do
            if c.Name == "SpectreWareAnimeBreaker" or c.Name:find("WindUI") or c.Name:find("AngelHub") or c.Name:find("AnimeBreaker") or c.Name:find("AxelHub") or c.Name:find("Fluent") then
                pcall(function() c:Destroy() end)
            end
        end
    end
    if type(gethui) == "function" then
        pcall(function() purge(gethui()) end)
    end
    purge(CoreGui)
    if CoreGui:FindFirstChild("RobloxGui") then
        purge(CoreGui.RobloxGui)
    end
    purge(PlayerGui)
end)

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local Lighting          = game:GetService("Lighting")
local SoundService      = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService   = game:GetService("TeleportService")
local HttpService       = game:GetService("HttpService")
local lp                = Players.LocalPlayer

-- Framework Detection
local Library = nil
pcall(function()
    Library = require(ReplicatedStorage:WaitForChild("Framework", 5):WaitForChild("Library", 5))
end)
if not Library and type(filtergc) == "function" then
    Library = filtergc("table", { Keys = { "Remote", "PlayerData" } }, true)
end

-- ══════════════════════════════════════════════════════════
-- CONSTANTS & LOOKUPS
-- ══════════════════════════════════════════════════════════
-- ══════════════════════════════════════════════════════════
-- AUTO-UPDATE: DYNAMIC DATA LOADER
-- Pulls all lists from game's own data modules at runtime.
-- Fallback to hardcode if module unavailable.
-- ══════════════════════════════════════════════════════════

local _RS2 = game:GetService("ReplicatedStorage")
local _FW2 = _RS2:FindFirstChild("Framework")
local function _safeReq(mod) if not mod then return nil end; local ok,r=pcall(require,mod); return ok and r or nil end
local function _modPath(name)
    return _FW2 and _FW2:FindFirstChild("Modules") and
           _FW2.Modules:FindFirstChild("Data") and
           _FW2.Modules.Data:FindFirstChild(name)
end

-- MAP_LIST — key ภายใน (DBZ, AOT...) เรียง Order จาก MapData
local MAP_LIST do
    local MapData = _safeReq(_modPath("MapData"))
    local built = {}
    if MapData and type(MapData) == "table" then
        local t = {}
        for k, v in pairs(MapData) do
            if type(k) == "string" then
                table.insert(t, {Key=k, Ord=(type(v)=="table" and tonumber(v.Order)) or 99})
            end
        end
        table.sort(t, function(a,b) return a.Ord < b.Ord end)
        for _, e in ipairs(t) do table.insert(built, e.Key) end
    end
    MAP_LIST = #built > 0 and built or
        {"Lobby","DBZ","AOT","Naruto","Nanatsu","SoloLeveling","OnePiece","BlackClover"}
end

-- ALL_RARITY_NAMES + RARITY_LEVEL — จาก RarityData เรียง Order
local ALL_RARITY_NAMES, RARITY_LEVEL do
    local RarityData = _safeReq(_modPath("RarityData"))
    local order = {}
    if RarityData and type(RarityData) == "table" then
        local t = {}
        for k, v in pairs(RarityData) do
            if type(k)=="string" then
                table.insert(t, {Name=k, Ord=(type(v)=="table" and tonumber(v.Order)) or 99})
            end
        end
        table.sort(t, function(a,b) return a.Ord < b.Ord end)
        for _, e in ipairs(t) do table.insert(order, e.Name) end
    end
    if #order == 0 then
        order = {"Common","Rare","Epic","Legendary","Mythical","Secret","Broken","Portal","Loot Box","Exclusive","RGB"}
    end
    ALL_RARITY_NAMES = order
    RARITY_LEVEL = {}
    for i, r in ipairs(order) do RARITY_LEVEL[r] = i end
end

-- RARITY_LEVEL ถูก define ข้างบนแล้ว (แยก block เดิมออก)

-- TT_POTIONS — scan ShopData หา Potion
local TT_POTIONS do
    local ShopData = _safeReq(_modPath("ShopData"))
    local found = {}
    if ShopData then
        local function scan(t)
            for _, item in pairs(t) do
                local id = (type(item)=="table" and (item.Id or item.Name)) or (type(item)=="string" and item) or nil
                if id and id:find("Potion") and not table.find(found,id) then table.insert(found,id) end
            end
        end
        local ttS = ShopData["TimeTrial"] or ShopData["TT"] or ShopData["TimeTrialShop"]
        if ttS then scan(ttS) else for _,s in pairs(ShopData) do if type(s)=="table" then scan(s) end end end
    end
    TT_POTIONS = #found > 0 and found or {
        "EnergyPotion1","DamagePotion1","GoldPotion1","LuckPotion1","DropPotion1",
        "EnergyPotion2","DamagePotion2","GoldPotion2","LuckPotion2","DropPotion2"
    }
end

-- PIRATE_JUICES — scan ShopData หา Juice
local PIRATE_JUICES do
    local ShopData = _safeReq(_modPath("ShopData"))
    local found = {}
    if ShopData then
        local function scan(t)
            for _, item in pairs(t) do
                local id = (type(item)=="table" and (item.Id or item.Name)) or (type(item)=="string" and item) or nil
                if id and id:find("Juice") and not table.find(found,id) then table.insert(found,id) end
            end
        end
        local pS = ShopData["Pirate"] or ShopData["PirateShop"] or ShopData["OnePiece"]
        if pS then scan(pS) else for _,s in pairs(ShopData) do if type(s)=="table" then scan(s) end end end
    end
    PIRATE_JUICES = #found > 0 and found or {
        "EnergyJuice1","DamageJuice1","GoldJuice1","DropJuice1","LuckJuice1"
    }
end

-- TT_TARGETS — จาก UpgradeData
local TT_TARGETS do
    local UpgradeData = _safeReq(_modPath("UpgradeData"))
    local found = {}
    local km = {Energy="Relentless",Damage="Breaker",Gold="Scavenger",AtkSPD="Overdrive"}
    if UpgradeData then
        local ttU = UpgradeData["TimeTrial"] or UpgradeData["TT"]
        if ttU then
            for k, v in pairs(ttU) do
                local sk = (type(v)=="table" and (v.Stat or v.Key or k)) or k
                local nm = (type(v)=="table" and (v.Name or v.DisplayName)) or (km[sk] and km[sk].." ("..sk..")") or sk
                table.insert(found, {Key=sk, Name=nm})
            end
        end
    end
    TT_TARGETS = #found > 0 and found or {
        {Key="Energy",Name="Relentless (Energy)"},{Key="Damage",Name="Breaker (Damage)"},
        {Key="Gold",Name="Scavenger (Gold)"},{Key="AtkSPD",Name="Overdrive (AtkSPD)"},
    }
end

-- CRAFT_ITEMS — scan CraftData/ItemData หา Ring/Collar/Earring
local CRAFT_ITEMS do
    local CraftData = _safeReq(_modPath("CraftData")) or _safeReq(_modPath("ItemData"))
    local found = {Ring={}, Collar={}, Earring={}}
    if CraftData then
        local function tryAdd(id)
            if not id or type(id)~="string" then return end
            local l = id:lower()
            if l:find("ring")    and not table.find(found.Ring,id)    then table.insert(found.Ring,id)    end
            if l:find("collar")  and not table.find(found.Collar,id)  then table.insert(found.Collar,id)  end
            if l:find("earring") and not table.find(found.Earring,id) then table.insert(found.Earring,id) end
        end
        for k, v in pairs(CraftData) do
            if type(v)=="table" then tryAdd(v.Id or v.Name)
                for _, item in pairs(v) do tryAdd((type(item)=="table" and (item.Id or item.Name)) or (type(item)=="string" and item)) end
            else tryAdd(type(k)=="string" and k or nil) end
        end
    end
    local any = false; for _, t in pairs(found) do if #t>0 then any=true; break end end
    CRAFT_ITEMS = any and found or {
        Ring    = {"EnergyRing1","EnergyRing2","EnergyRing3","EnergyRing4","EnergyRing5","EnergyRing6"},
        Collar  = {"GoldCollar1","GoldCollar2","GoldCollar3","GoldCollar4","GoldCollar5","GoldCollar6"},
        Earring = {"DamageEarring1","DamageEarring2","DamageEarring3","DamageEarring4","DamageEarring5","DamageEarring6"}
    }
end

-- PROMO_CODES — จาก CodeData/Codes module
local PROMO_CODES do
    local CodeData = _safeReq(_modPath("CodeData")) or _safeReq(_modPath("PromoCodes")) or _safeReq(_modPath("Codes"))
    local found = {}
    if CodeData then
        for k, v in pairs(CodeData) do
            local code = (type(v)=="table" and (v.Code or v.Id or k)) or (type(k)=="string" and k) or nil
            if code and type(code)=="string" and #code>0 then
                local up = code:upper(); if not table.find(found,up) then table.insert(found,up) end
            end
        end
    end
    PROMO_CODES = #found > 0 and found or {
        "RELEASE","UPDATE1","UPDATE2","CRAFT","LIKES10K","LIKES20K","SORRYFORSHUTDOWN"
    }
end

-- ALL_ENEMY_OPTIONS — ดึงจาก EnemyData (flat: each entry มี .Name + .Map)
-- Format: "Enemy Name [ MapKey ]" ตรงกับ internal key
local function buildEnemyOptions()
    local opts, seen = {"All"}, {}
    local ok, EnemyData = pcall(function()
        return require(game:GetService("ReplicatedStorage").Framework.Modules.Data.EnemyData)
    end)
    if ok and EnemyData then
        local entries = {}
        for _, v in pairs(EnemyData) do
            if type(v)=="table" and v.Name and v.Map then
                table.insert(entries, {Name=tostring(v.Name), Map=tostring(v.Map), Order=tonumber(v.Order) or 99})
            end
        end
        -- sort ตาม MAP_LIST order (เหมือนลำดับแมพในเกม) แล้ว sub-sort ด้วย enemy Order
        local mapIdx = {}; for i, m in ipairs(MAP_LIST) do mapIdx[m] = i end
        table.sort(entries, function(a,b)
            local ia = mapIdx[a.Map] or 999; local ib = mapIdx[b.Map] or 999
            if ia ~= ib then return ia < ib end
            return a.Order < b.Order
        end)
        for _, e in ipairs(entries) do
            local d = e.Name.." [ "..e.Map.." ]"
            if not seen[d] then seen[d]=true; table.insert(opts, d) end
        end
    end
    -- fallback: workspace scan
    if #opts <= 1 then
        local srv = workspace:FindFirstChild("_ENEMIES") and workspace._ENEMIES:FindFirstChild("Server")
        if srv then
            local function scan(f, tag)
                for _, c in ipairs(f:GetChildren()) do
                    if c:IsA("Folder") then scan(c, tag or c.Name)
                    else
                        local d = (c:GetAttribute("Name") or c.Name)..(tag and " [ "..tag.." ]" or "")
                        if not seen[d] then seen[d]=true; table.insert(opts, d) end
                    end
                end
            end
            for _, mf in ipairs(srv:GetChildren()) do if mf:IsA("Folder") then scan(mf,mf.Name) end end
        end
    end
    -- hardcode fallback (ข้อมูลจริงจากเกม update ล่าสุด)
    if #opts <= 1 then opts = {"All",
        "Master Inventor [ DBZ ]","Namekian Healer [ DBZ ]","Namekian Warrior [ DBZ ]","Strongest Human [ DBZ ]","Hidden Potential [ DBZ ]","Saiyan Prince [ DBZ ]",
        "Ace Captain [ AOT ]","Ace Scout [ AOT ]","Buzzcut Scout [ AOT ]","Scout Potato [ AOT ]","Scout Scientist [ AOT ]","Tactical Scout [ AOT ]",
        "Destructive Fist [ Naruto ]","Shadow Tactician [ Naruto ]","Copy Ninja [ Naruto ]","Gentle Fist [ Naruto ]","Slug Sannin [ Naruto ]","Akimichi Titan [ Naruto ]",
        "Boar Sin [ Nanatsu ]","Fox Sin [ Nanatsu ]","Goat Sin [ Nanatsu ]","Grizzly Sin [ Nanatsu ]","Lion Sin [ Nanatsu ]","Serpent Sin [ Nanatsu ]",
        "Stealth Assassin [ SoloLeveling ]","Surveillance Chief [ SoloLeveling ]","Sword Dancer [ SoloLeveling ]","The Goliath [ SoloLeveling ]","Veteran Hunter [ SoloLeveling ]","Weakest Hunter [ SoloLeveling ]",
        "Black Leg [ OnePiece ]","Cat Burglar [ OnePiece ]","Fire Fist [ OnePiece ]","Pirate Hunter [ OnePiece ]","Sniper King [ OnePiece ]","Straw Hat [ OnePiece ]",
        "Anti Magic [ BlackClover ]","Crimson Lion [ BlackClover ]","Dark Captain [ BlackClover ]","Sea Dragon [ BlackClover ]","Undefeated Lioness [ BlackClover ]","Wind Spirit [ BlackClover ]",
    } end
    return opts
end
local ALL_ENEMY_OPTIONS = buildEnemyOptions()
_G._AnimeBreakerRefreshEnemies = buildEnemyOptions

-- ══════════════════════════════════════════════════════════
-- GACHA DYNAMIC DROPDOWNS: ดึง stop-tier options จาก GachaData
-- Format ที่ใช้: "Name (Rarity+)" เรียงตาม Order
-- ══════════════════════════════════════════════════════════
local GACHA = {}
do
    local _GachaCache = nil
    local function getGachaData()
        if _GachaCache then return _GachaCache end
        local ok, data = pcall(function()
            return require(game:GetService("ReplicatedStorage").Framework.Modules.Data.GachaData)
        end)
        _GachaCache = (ok and data) or {}
        return _GachaCache
    end

    local function buildGachaStops(gachaType, rarityMap)
        local GD = getGachaData()
        local entries = {}
        for _, v in pairs(GD) do
            if type(v)=="table" and v.Type==gachaType and v.Name and v.Rarity then
                table.insert(entries, {
                    Name   = tostring(v.Name),
                    Rarity = tostring(v.Rarity),
                    Order  = tonumber(v.Order) or 99
                })
            end
        end
        table.sort(entries, function(a,b) return a.Order < b.Order end)
        local result = {"Any"}
        local seenR = {}
        for _, e in ipairs(entries) do
            if not seenR[e.Rarity] then
                seenR[e.Rarity] = true
                local suffix = (rarityMap and rarityMap[e.Rarity]) or (e.Rarity.."+")
                table.insert(result, e.Name.." ("..suffix..")")
            end
        end
        return #result > 1 and result or {"Any"}
    end

    do
        local GD = getGachaData()
        local types, seen = {}, {}
        for _, v in pairs(GD) do
            if type(v)=="table" and v.Type and not seen[v.Type] then
                seen[v.Type] = true; table.insert(types, tostring(v.Type))
            end
        end
        table.sort(types)
        GACHA.SUMMON_TYPES = #types > 0 and types or {"Pet","Race","Eye Technique"}
    end

    do
        local r = {"Any"}
        for _, rn in ipairs(ALL_RARITY_NAMES) do
            if rn ~= "Common" then table.insert(r, rn.."+") end
        end
        GACHA.SUMMON_STOP_RARITIES = r
    end

    GACHA.TITAN_STOPS     = buildGachaStops("Titan",          {Rare="Rare+",Epic="Epic+",Legendary="Legendary+",Mythical="Mythical+",Secret="Secret"})
    GACHA.EYE_STOPS       = buildGachaStops("Eye Technique",  {Rare="Rare+",Epic="Epic+",Legendary="Legendary+",Mythical="Mythical+",Secret="Secret"})
    GACHA.SIN_STOPS       = buildGachaStops("Sin",            {Rare="Rare+",Epic="Epic+",Legendary="Legendary+",Mythical="Mythical+",Secret="Secret"})
    GACHA.HUNTER_STOPS    = buildGachaStops("Hunter Rank",    {Rare="Rare+",Epic="Epic+",Legendary="Legendary+",Mythical="Mythical+",Secret="Secret"})
    GACHA.SHADOW_STOPS    = buildGachaStops("Shadow Passive", {Rare="Rare+",Epic="Epic+",Legendary="Legendary+",Mythical="Mythical+",Secret="Secret"})
    GACHA.HERO_STOPS      = buildGachaStops("Hero Passive",   {Rare="Rare+",Epic="Epic+",Legendary="Legendary+",Mythical="Mythical+",Secret="Secret"})
    GACHA.WEAPON_P_STOPS  = buildGachaStops("Weapon Passive", {Rare="Rare+",Epic="Epic+",Legendary="Legendary+",Mythical="Mythical+",Secret="Secret"})
    GACHA.HAKI_STOPS      = buildGachaStops("Haki",           {Rare="Rare+",Epic="Epic+",Legendary="Legendary+",Mythical="Mythical+",Secret="Secret"})
    GACHA.AMULET_STOPS    = buildGachaStops("Amulet Building",{Rare="Rare+",Epic="Epic+",Legendary="Legendary+",Mythical="Mythical+",Secret="Secret"})

    do
        local r = {"Any"}
        for _, rn in ipairs(ALL_RARITY_NAMES) do
            if rn ~= "Common" then table.insert(r, rn.."+") end
        end
        GACHA.WEAPON_T1_STOPS = r
    end

    do
        local GD = getGachaData()
        local cats, seen = {}, {}
        for _, v in pairs(GD) do
            if type(v)=="table" and v.Type=="Amulet Building" and v.Boost then
                local b = tostring(v.Boost)
                if not seen[b] then seen[b]=true; table.insert(cats, b) end
            end
        end
        table.sort(cats)
        GACHA.AMULET_CATEGORIES = #cats > 0 and cats or {"Energy","Gold","Damage"}
    end
end


-- CONFIGURATION
-- ══════════════════════════════════════════════════════════
local TIMERS = {
    wallAttackStartTime     = 0,
    wallCooldownStartTime   = 0,
    isAttackingWall         = false,
    lastClick = 0,
    lastSkill = 0,
    lastCraft = 0,
    lastClaim = 0,
    lastLikeClaim = 0,
    lastUpgrade = 0,
    lastMerge = 0,
    lastEquipBest = 0,
    lastSell = 0,
    lastRankUp = 0,
    lastRaceSpin = 0,
    lastWarriorUp = 0,
    lastWeaponSpin = 0,
    lastHeroPassive = 0,
    lastOfflineUp = 0,
    lastUnlockStep = 0,
    lastQuestTick = 0,
    lastPortalTick = 0,
    lastTTUpgrade = 0,
    lastTTShopBuy = 0,
    lastPirateShopBuy = 0,
    lastRaidStartAttempt = 0,
    lastNewAreaTeleport = 0,
    lastIndexMapTeleport = 0,
    lastTeleportTick = 0,
    lastQuestGachaSpin = 0,
    lastQuestConsumableUse = 0,
    lastSummonTick = 0,
    lastGamemodeExitAttempt = 0,
    lastTimeTrialJoinAttempt = 0,
    lastInvasionJoinAttempt = 0,
    lastRaidCreateAttempt = 0,
    lastTitanSpin = 0,
    lastHarborTick = 0,
    lastCommandmentTick = 0,
    lastJewelTick = 0,
    lastPortalUp = 0,
    lastClassTreeUp = 0,
    lastNinjaUp = 0,
    lastAntUp = 0,
}
local Window, SpectreUI, AxelHubUI

local CFG = {
    AutoIndexFarm = false,
    IndexFarmWorld = "Current Map",
    TargetMonsterFilterMulti = {"All"},
    AutoMarineInvasion = false,
    InvasionDifficulty = "Easy",
    InvasionAutoLeave = false,

    -- Combat
    AutoClick           = false,
    ClickDelay          = 0.05,
    AutoTarget          = false,
    TargetMonsterFilter = "All",
    AutoFarm            = false,
    AutoCastSkill       = false,

    -- Smart Area Progression & Wall Breaking
    AutoBreakWall       = false,
    WallBreakMode       = "Timed",
    WallAttackDuration  = 30,
    WallFarmCooldown    = 180,
    AutoGoNewArea       = false,

    -- Auto Quests
    AutoQuests          = false,

    -- Priority 1: Time Trial Dungeon (The Hallway)
    AutoTimeTrialDungeon  = false,
    TTDifficulty          = {"Easy"},
    TTDifficulties        = {"Easy"},
    TTCustomExitStage     = false,
    TTExitStage           = 25,
    AutoUpgradeTT         = false,
    TTUpgradePriority     = "Upgrade All",
    AutoBuyTTShop         = false,
    TTShopSelection       = {},
    AutoBuyPirateShop     = false,
    PirateShopSelection   = {},

    -- Priority 2: Auto Raid (Safe Entry + Exit Room + No Teleport Bug)
    AutoRaid              = false,
    RaidTargetMap         = "DBZ",
    AutoFarmTicketIfNone  = false,
    AutoReturnHome        = false,
    RaidCustomExitRoom    = false,
    RaidExitRoom          = 5,

    -- Priority 3: Auto Join Portal (According to Tier)
    AutoPortal            = false,
    PortalSelectedTier    = "All",

    -- Auto Summon (Banners)
    AutoSummon            = false,
    SummonEgg             = "DBZ",
    SummonType            = "Pet",
    SummonStopRarity      = "Mythical+",

    -- Auto Race Spin
    AutoRaceSpin          = false,
    AutoUnlockRace        = false,
    RaceStopRarity        = "Mythical",

    -- Auto Titan Banner
    AutoTitanSpin         = false,
    AutoUnlockTitan       = false,
    TitanStopRarity       = "Founding Titan (Secret)",

    -- Auto Weapon & Passives
    AutoWeaponSummon      = false,
    AutoUnlockWeapon      = false,
    WeaponT1StopRarity    = "Mythical+",
    AutoWeaponPassive     = false,
    AutoUnlockWeaponPassive = false,
    TargetWeaponPassive   = "Supreme Grade (Mythical+)",

    -- Auto Hero Passive
    AutoHeroPassive       = false,
    AutoUnlockHeroPassive = false,
    TargetHeroPassive     = "Soul Breaker (Mythical+)",

    -- Auto Eye Technique (Naruto)
    AutoEyeSpin           = false,
    AutoUnlockEye         = false,
    EyeStopRarity         = "Rinnegan (Mythical+)",

    -- Auto Sin Gacha (Nanatsu)
    AutoSinSpin           = false,
    AutoUnlockSin         = false,
    SinStopRarity         = "Pride (Mythical+)",

    -- Auto Hunter Rank (SoloLeveling)
    AutoHunterRankSpin    = false,
    AutoUnlockHunter      = false,
    HunterRankStopRarity  = "A-Rank (Mythical+)",

    -- Auto Shadow Passive (SoloLeveling)
    AutoShadowPassiveSpin = false,
    AutoUnlockShadow      = false,
    ShadowPassiveStopRarity = "Marshal (Mythical+)",

    -- Auto Haki (OnePiece)
    AutoHakiSpin          = false,
    AutoUnlockHaki        = false,
    HakiStopRarity        = "Conqueror (Mythical+)",

    -- Auto Amulet Building (Nanatsu)
    AutoAmuletSpin        = false,
    AutoUnlockAmulet      = false,
    AmuletCategory        = "Energy",
    AmuletStopRarity      = "Tier V (Mythical+)",

    -- Balanced System Unlocker (Round-Robin) & Map Unlocks
    BalancedUnlocker        = false,
    AutoUnlockAllMapSystems = false,

    -- Auto Equip Best (Global Boost + Individual + Title + Multi-systems)
    AutoEquipBest         = false,
    AutoEquipBoost        = "Energy",
    EquipBestCategories   = {"Weapon", "Warrior", "Avatar", "Accessory", "Mount", "Jewel", "Wing", "DevilFruit", "Crewmate", "Amulet"},
    EquipBestAvatar       = false,
    EquipBestAccessory    = false,
    EquipBestWeapon       = false,
    EquipBestWarrior      = false,
    EquipBestMount        = false,
    EquipBestJewel        = false,
    EquipBestWing         = false,
    EquipBestTitle        = false,
    TTSelectedPotionNames = {},
    TTSelectedUpgradeNames = {"Breaker (Damage +5%)", "Relentless (Energy +5%)", "Scavenger (Gold +5%)", "Overdrive (AtkSPD +2.5%)"},
    TTShopBuyAmountStr    = "1x",
    TTShopBuyAmount       = 1,
    PirateSelectedJuiceNames = {},
    PirateShopBuyAmountStr = "1x",
    PirateShopBuyAmount   = 1,
    DeleteSelectedRarities = {"Common", "Rare", "Epic"},
    SellSelectedRarities  = {"Common", "Rare"},
    DeleteTargetCategories = {"Pets", "Weapons", "Wings", "Avatars", "Accessories", "Warriors", "Mounts", "Jewels"},

    -- Auto Upgrades & Progression (Multi-Select & Balance Modes)
    AutoRankUp            = false,
    AutoUpgradeWarrior    = false,
    AutoUnlockWarrior     = false,
    WarriorSelectedUpgradeNames = {"Energy", "Damage", "Gold", "AttackRange"},
    BalanceWarriorUpgrades = false,
    WarriorUpgradePriority= "All (Balanced)",
    AutoOfflineUpgrades   = false,
    AutoUnlockOffline     = false,
    OfflineSelectedUpgradeNames = {"Dreamer (Offline Energy)", "Hoarder (Offline Gold)", "Hibernation (Offline Max Time)"},
    BalanceOfflineUpgrades= false,
    AutoUpgradeTT         = false,
    BalanceTTUpgrades     = false,
    AutoUpgradePortal     = false,
    AutoUnlockPortal      = false,
    BalancePortalUpgrades = false,
    PortalSelectedUpgradeNames = {"Energy", "Damage", "MaxEnemy", "WarriorDropChance"},
    AutoUpgradeClassTree  = false,
    AutoUnlockClassTree   = false,
    BalanceClassTreeUpgrades = false,
    ClassTreeSelectedUpgradeNames = {"Start", "Energy", "Damage", "Gold", "CritChance", "CritDMG", "WalkSPD"},
    AutoUpgradeNinja      = false,
    AutoUnlockNinja       = false,
    AutoUpgradeAnt        = false,
    AutoUnlockAnt         = false,
    AutoUpgradeTotems     = false,
    AutoUpgrade           = false,
    BalanceGlobalUpgrades = false,
    SelectedGlobalUpgrades= {"Warrior Upgrades", "Offline Upgrades", "Time Trial Upgrades", "Portal Upgrades", "Class Tree", "Ninja Progression", "Ant Progression"},

    -- Merge & Crafting
    AutoMergeAll          = false,
    AutoCraft             = false,
    CraftMaxTier          = 6,
    CraftSelection        = { Ring = false, Collar = false, Earring = false },

    -- Auto Claim
    AutoClaimAll          = false,
    AutoClaimLikeRewards  = false,

    -- Auto Delete / Auto Sell (Thresholds)
    AutoDeletePets        = false,
    DeletePetsBelow       = "Rare",
    AutoDeleteWeapons     = false,
    DeleteWeaponsBelow    = "Rare",
    AutoDeleteWings       = false,
    DeleteWingsBelow      = "Rare",
    AutoDeleteAvatars     = false,
    DeleteAvatarsBelow    = "Rare",
    AutoDeleteAccessories = false,
    DeleteAccessoriesBelow= "Rare",
    AutoDeleteWarriors    = false,
    DeleteWarriorsBelow   = "Rare",
    AutoDeleteMounts      = false,
    DeleteMountsBelow     = "Rare",
    AutoDeleteJewels      = false,
    DeleteJewelsBelow     = "Rare",

    -- Player Movement & Hacks (Dash Speed & Hack)
    DashHack              = false,
    DashSpeed             = 150,
    JumpPower             = 100,
    InfHealth             = false,
    NoClip                = false,

    -- Profiles & category cleanup
    AutoLoadConfig = false,
    SelectedConfigName = "default",
    DeleteRaritySelection = {
        Pet = {"Common", "Rare"}, Weapon = {"Common", "Rare"},
        Wing = {"Common", "Rare"}, Avatar = {"Common", "Rare"},
        Accessory = {"Common", "Rare"}, Warrior = {"Common", "Rare"},
        Mount = {"Common", "Rare"}, Jewel = {"Common", "Rare"}
    },

    -- Anti-AFK & Rejoin
    AntiAFK               = false,
    AutoRejoin            = false,
}

local RarityToggles = {
    Pet       = { Common = true, Rare = true, Epic = false, Legendary = false, Mythical = false, Secret = false, Broken = false },
    Weapon    = { Common = true, Rare = true, Epic = false, Legendary = false, Mythical = false, Secret = false, Broken = false },
    Wing      = { Common = true, Rare = true, Epic = false, Legendary = false, Mythical = false, Secret = false, Broken = false },
    Avatar    = { Common = true, Rare = true, Epic = false, Legendary = false, Mythical = false, Secret = false, Broken = false },
    Accessory = { Common = true, Rare = true, Epic = false, Legendary = false, Mythical = false, Secret = false, Broken = false },
    Warrior   = { Common = true, Rare = true, Epic = false, Legendary = false, Mythical = false, Secret = false, Broken = false },
    Mount     = { Common = true, Rare = true, Epic = false, Legendary = false, Mythical = false, Secret = false, Broken = false },
    Jewel     = { Common = true, Rare = true, Epic = false, Legendary = false, Mythical = false, Secret = false, Broken = false },
}

-- ══════════════════════════════════════════════════════════
-- SYSTEM TIMERS & STICKY TARGET LOCKING STATE
-- ══════════════════════════════════════════════════════════





















local raidEnteringTime = 0

local wallAttackStartTime = 0
local wallCooldownStartTime = 0
local isAttackingWall = false

local function resetWallBreakTimers()
    isAttackingWall = false
    wallAttackStartTime = 0
    wallCooldownStartTime = 0
end

-- STICKY TARGET LOCK & COMBAT CIRCLE MULTI-TARGET COVERAGE
local currentLockedTargetUID = nil
local currentCoveredTargetUIDs = {}

local unlockSystemQueue = {
    { Id = "Gacha_Race", Name = "Race", CostKey = "Gold", CostAmt = 10000 },
    { Id = "Upgrade_Warrior Upgrades", Name = "Warrior Upgrades", CostKey = "Gold", CostAmt = 15000 },
    { Id = "Upgrade_Offline Upgrades", Name = "Offline Upgrades", CostKey = "Gold", CostAmt = 45000 },
    { Id = "Gacha_Weapon_T1", Name = "Weapon T1", CostKey = "Gold", CostAmt = 10935000 },
    { Id = "Gacha_Hero Passive", Name = "Hero Passive", CostKey = "Gold", CostAmt = 87480000 },
}
local unlockQueueIndex = 1

local noClipConn = nil

local function getChar() return lp.Character end
local function getRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local noClipOriginal = setmetatable({}, { __mode = "k" })
local function disableNoClip()
    if noClipConn then noClipConn:Disconnect(); noClipConn = nil end
    _G.AnimeBreaker_NoClipConn = nil
    for part, original in pairs(noClipOriginal) do
        if part.Parent then part.CanCollide = original end
    end
    table.clear(noClipOriginal)
end

local function enableNoClip()
    if noClipConn then return end
    noClipConn = RunService.Stepped:Connect(function()
        local character = getChar()
        if not (CFG.NoClip and character) then return end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if noClipOriginal[part] == nil then noClipOriginal[part] = part.CanCollide end
                part.CanCollide = false
            end
        end
    end)
    _G.AnimeBreaker_NoClipConn = noClipConn
end


-- Unified Rarity Lookup across all game data modules
local _ItemRarityCache = {}
local _GachaDataRef = nil
local _PetDataRef = nil
local _WeaponDataRef = nil
local _WarriorDataRef = nil
local _AvatarDataRef = nil
local _AccessoryDataRef = nil

local function loadDataModules()
    pcall(function()
        local RS = game:GetService("ReplicatedStorage")
        local Data = RS:FindFirstChild("Framework") and RS.Framework:FindFirstChild("Modules") and RS.Framework.Modules:FindFirstChild("Data")
        if Data then
            if not _GachaDataRef and Data:FindFirstChild("GachaData") then _GachaDataRef = require(Data.GachaData) end
            if not _PetDataRef and Data:FindFirstChild("PetData") then _PetDataRef = require(Data.PetData) end
            if not _WeaponDataRef and Data:FindFirstChild("WeaponData") then _WeaponDataRef = require(Data.WeaponData) end
            if not _WarriorDataRef and Data:FindFirstChild("WarriorData") then _WarriorDataRef = require(Data.WarriorData) end
            if not _AvatarDataRef and Data:FindFirstChild("AvatarData") then _AvatarDataRef = require(Data.AvatarData) end
            if not _AccessoryDataRef and Data:FindFirstChild("AccessoryData") then _AccessoryDataRef = require(Data.AccessoryData) end
        end
    end)
end

local function getItemRarity(id)
    if not id then return "Common", 1 end
    if _ItemRarityCache[id] then
        return _ItemRarityCache[id].Rarity, _ItemRarityCache[id].Order
    end

    loadDataModules()

    local rarity = nil
    local orderNum = nil

    -- 1. Direct dictionary lookups by Id
    if _PetDataRef and _PetDataRef[id] then
        rarity = _PetDataRef[id].Rarity
    elseif _WeaponDataRef and _WeaponDataRef[id] then
        rarity = _WeaponDataRef[id].Rarity
    elseif _GachaDataRef and _GachaDataRef[id] then
        rarity = _GachaDataRef[id].Rarity
        orderNum = _GachaDataRef[id].Order
    elseif _WarriorDataRef and _WarriorDataRef[id] then
        rarity = _WarriorDataRef[id].Rarity
    elseif _AvatarDataRef and _AvatarDataRef[id] then
        rarity = _AvatarDataRef[id].Rarity
    elseif _AccessoryDataRef and _AccessoryDataRef[id] then
        rarity = _AccessoryDataRef[id].Rarity
    end

    -- 2. Lookup by Name in GachaData, WeaponData, or PetData
    if not rarity and _GachaDataRef then
        for gId, gData in pairs(_GachaDataRef) do
            if gData.Name == id or gId == id or gId:lower():find(tostring(id):lower()) or (gData.Name and gData.Name:lower():find(tostring(id):lower())) then
                rarity = gData.Rarity
                orderNum = gData.Order
                break
            end
        end
    end

    if not rarity and _WeaponDataRef then
        for wId, wData in pairs(_WeaponDataRef) do
            if wData.Name == id or (wData.Name and wData.Name:lower():find(tostring(id):lower())) then
                rarity = wData.Rarity
                break
            end
        end
    end

    if not rarity and _PetDataRef then
        for pId, pData in pairs(_PetDataRef) do
            if pData.Name == id or (pData.Name and pData.Name:lower():find(tostring(id):lower())) then
                rarity = pData.Rarity
                break
            end
        end
    end

    rarity = rarity or "Common"
    local order = RARITY_LEVEL[rarity] or 1
    if orderNum and orderNum > 1000 then
        local extractedRank = math.floor(orderNum / 1000)
        if extractedRank > order then
            order = extractedRank
        end
    end

    _ItemRarityCache[id] = { Rarity = rarity, Order = order }
    return rarity, order
end

local function getRarityOrder(id)
    local _, order = getItemRarity(id)
    return order
end

local _UI_TOGGLES = {}
local function stopSpinToggle(key, sysName, itemName, itemRarity)
    CFG[key] = false
    if _UI_TOGGLES[key] then pcall(function() _UI_TOGGLES[key]:Set(false, true) end) end
    if Window then
        Window:Notify({
            Title = (sysName or "Spin") .. " · Target Reached",
            Description = tostring(itemName or "Target") .. (itemRarity and (" · " .. tostring(itemRarity)) or "") .. ". Auto spin stopped.",
            Duration = 6
        })
    end
end

local function parseTargetRank(str, targetMap)
    if not str or str == "Any" then return 0 end
    if targetMap and targetMap[str] then return targetMap[str] end
    local clean = tostring(str):gsub("%+", ""):gsub("%s*%(.-%)", ""):gsub("^%s+", ""):gsub("%s+$", "")
    if RARITY_LEVEL[clean] then return RARITY_LEVEL[clean] end
    local lower = tostring(str):lower()
    if lower:find("exclusive") or lower:find("rgb") or lower:find("broken") then return 7 end
    if lower:find("secret") or lower:find("tier vi") or lower:find("rank 6") then return 6 end
    if lower:find("mythical") or lower:find("tier v") or lower:find("rank 5") then return 5 end
    if lower:find("legendary") or lower:find("tier iv") or lower:find("rank 4") then return 4 end
    if lower:find("epic") or lower:find("tier iii") or lower:find("rank 3") then return 3 end
    if lower:find("rare") or lower:find("tier ii") or lower:find("rank 2") then return 2 end
    if lower:find("common") or lower:find("tier i") or lower:find("rank 1") then return 1 end

    loadDataModules()
    if _GachaDataRef then
        for gId, gData in pairs(_GachaDataRef) do
            if gData.Name and (gData.Name:lower() == lower or gData.Name:lower():find(lower, 1, true)) then
                if gData.Order and gData.Order > 1000 then
                    return math.floor(gData.Order / 1000)
                end
                if gData.Rarity and RARITY_LEVEL[gData.Rarity] then
                    return RARITY_LEVEL[gData.Rarity]
                end
            end
        end
    end

    return 0
end

local function checkGachaStopCondition(gachaType, targetThresholdStr, specificCategory, targetMap)
    local reqRank = parseTargetRank(targetThresholdStr, targetMap)
    if reqRank <= 0 then return false end
    local pd = Library and Library.PlayerData
    if not pd then return false end

    loadDataModules()

    -- 1. Check PlayerData.Gacha
    if pd.Gacha then
        for id, v in pairs(pd.Gacha) do
            local idStr = tostring(id)
            if idStr:lower():find(gachaType:lower(), 1, true) then
                if not specificCategory or idStr:lower():find(specificCategory:lower(), 1, true) then
                    local rank = tonumber(idStr:match("(%d+)$")) or 0
                    local gInfo = _GachaDataRef and _GachaDataRef[id]
                    if (not rank or rank == 0) and gInfo and gInfo.Order then
                        rank = math.floor(gInfo.Order / 1000)
                    end
                    if rank >= reqRank then
                        local name = (gInfo and gInfo.Name) or (type(v) == "table" and (v.Name or v.Id)) or idStr
                        local rarity = (gInfo and gInfo.Rarity) or ALL_RARITY_NAMES[rank] or ("Rank " .. rank)
                        return true, name, rarity, rank
                    end
                end
            end
        end
    end

    -- 2. Check PlayerData.GachaEquipped (array of ID strings)
    if pd.GachaEquipped then
        for _, id in pairs(pd.GachaEquipped) do
            local idStr = tostring(id)
            if idStr:lower():find(gachaType:lower(), 1, true) then
                if not specificCategory or idStr:lower():find(specificCategory:lower(), 1, true) then
                    local rank = tonumber(idStr:match("(%d+)$")) or 0
                    local gInfo = _GachaDataRef and _GachaDataRef[id]
                    if (not rank or rank == 0) and gInfo and gInfo.Order then
                        rank = math.floor(gInfo.Order / 1000)
                    end
                    if rank >= reqRank then
                        local name = (gInfo and gInfo.Name) or idStr
                        local rarity = (gInfo and gInfo.Rarity) or ALL_RARITY_NAMES[rank] or ("Rank " .. rank)
                        return true, name, rarity, rank
                    end
                end
            end
        end
    end

    -- 3. If Amulet, also check PlayerData.Amulets
    if gachaType:lower():find("amulet") and pd.Amulets then
        for aId, aData in pairs(pd.Amulets) do
            local aStr = tostring(aId)
            if not specificCategory or aStr:lower():find(specificCategory:lower(), 1, true) then
                local rank = tonumber(aStr:match("(%d+)$")) or 0
                if rank >= reqRank then
                    local gInfo = _GachaDataRef and _GachaDataRef[aId]
                    local name = (gInfo and gInfo.Name) or aStr
                    local rarity = (gInfo and gInfo.Rarity) or ALL_RARITY_NAMES[rank] or ("Tier " .. rank)
                    return true, name, rarity, rank
                end
            end
        end
    end

    -- 4. If Weapon Passive, also check equipped weapon in pd.Weapons
    if gachaType:lower():find("weapon") and pd.Equipped and pd.Equipped.Weapon and pd.Weapons then
        local eqWep = pd.Weapons[pd.Equipped.Weapon]
        local curPassive = eqWep and (eqWep.Passive or eqWep.WeaponPassive or eqWep.Skill)
        if curPassive then
            local rName, rOrder = getItemRarity(tostring(curPassive))
            if rOrder >= reqRank then
                return true, tostring(curPassive), rName, rOrder
            end
        end
    end

    -- 5. If Hero Passive, also check pd.HeroPassive
    if gachaType:lower():find("hero") and pd.HeroPassive then
        local rName, rOrder = getItemRarity(tostring(pd.HeroPassive))
        if rOrder >= reqRank then
            return true, tostring(pd.HeroPassive), rName, rOrder
        end
    end

    return false
end

local function isItemInList(list, item)
    if type(list) ~= "table" then return false end
    for k, v in pairs(list) do
        if v == item or (k == item and v == true) then
            return true
        end
    end
    return false
end

local function getCurrentMap()
    if Library and Library.PlayerData and Library.PlayerData.CurrentMap then
        return Library.PlayerData.CurrentMap
    end
    local attr = lp:GetAttribute("Map")
    if attr and attr ~= "" then return attr end
    return "DBZ"
end


local function getHighestUnlockedMap()
    local pd = Library and Library.PlayerData
    local unlocked = pd and (pd.UnlockedMap or pd.Maps) or {}
    local highest = "DBZ"
    local highestIdx = 2
    for idx, mapKey in ipairs(MAP_LIST) do
        if unlocked[mapKey] == true and idx >= highestIdx then
            highest = mapKey
            highestIdx = idx
        end
    end
    return highest
end

local function isNextMapUnlocked(curMap)
    local curIdx = table.find(MAP_LIST, curMap)
    if not curIdx or curIdx >= #MAP_LIST then return false end
    local nextMap = MAP_LIST[curIdx + 1]
    local pd = Library and Library.PlayerData
    local unlocked = pd and (pd.UnlockedMap or pd.Maps) or {}
    return unlocked[nextMap] == true
end

-- Gamemode Detectors
-- ROBUST EVENT & GAMEMODE DETECTION (InMode Attribute + Folder + Hierarchy)
local function getActiveGamemode()
    local mode = lp:GetAttribute("Mode")
    local inMode = lp:GetAttribute("InMode")
    if inMode and inMode ~= "" then
        return mode or "Gamemode", inMode
    end

    local gm = workspace:FindFirstChild("_GAMEMODE")
    if gm then
        for _, child in ipairs(gm:GetChildren()) do
            local cName = child.Name:lower()
            if cName:find("raid") then
                return "Raid", child.Name
            elseif cName:find("time") or cName:find("trial") then
                return "Time Trial", child.Name
            elseif cName:find("portal") then
                return "Portal", child.Name
            elseif cName:find("invasion") then
                return "Invasion", child.Name
            end
        end
    end

    local char = getChar()
    if char then
        if char:GetAttribute("InRaid") or char:GetAttribute("Raid") then return "Raid", "Raid" end
        if char:GetAttribute("InTimeTrial") or char:GetAttribute("TimeTrial") then return "Time Trial", "Time Trial" end
        if char:GetAttribute("InPortal") or char:GetAttribute("Portal") then return "Portal", "Portal" end
        if char:GetAttribute("InInvasion") or char:GetAttribute("Invasion") then return "Invasion", "Invasion" end
    end
    return nil, nil
end

local function getRaidStatus()
    local lp = game:GetService("Players").LocalPlayer
    local inMode = lp:GetAttribute("InMode")
    local mode = lp:GetAttribute("Mode")
    if not (mode == "Raid" or (inMode and tostring(inMode):lower():find("raid"))) then
        return "None", nil
    end

    local rep = game:GetService("ReplicatedStorage")
    local gmRep = rep:FindFirstChild("Server") and rep.Server:FindFirstChild("Gamemode")
    local room = inMode and gmRep and gmRep:FindFirstChild(inMode)
    local status = room and room:GetAttribute("Status")
    if status == "Running" then
        return "Running", inMode
    elseif status == "Opened" then
        return "Opened", inMode
    end

    -- Fallback check: if server enemies folder has active enemies, it is Running
    local sEnemies = workspace:FindFirstChild("_ENEMIES") and workspace._ENEMIES:FindFirstChild("Server")
    local gmFolder = sEnemies and sEnemies:FindFirstChild("Gamemode")
    local rEnemies = inMode and gmFolder and gmFolder:FindFirstChild(inMode)
    if rEnemies and #rEnemies:GetChildren() > 0 then
        return "Running", inMode
    end

    return "Opened", inMode
end

local function isPlayerInRaid()
    local status, inMode = getRaidStatus()
    if status == "Running" or status == "Opened" then
        return true, inMode
    end
    return false, nil
end

local function isPlayerInTimeTrial()
    local mode, inMode = getActiveGamemode()
    if mode == "Time Trial" or (inMode and (inMode:lower():find("time") or inMode:lower():find("trial"))) then
        local gm = workspace:FindFirstChild("_GAMEMODE")
        local ttFolder = gm and (gm:FindFirstChild("Time Trial") or gm:FindFirstChild(inMode))
        return true, ttFolder or inMode
    end
    return false, nil
end

local function isPlayerInPortal()
    local mode, inMode = getActiveGamemode()
    if mode == "Portal" or (inMode and inMode:lower():find("portal")) then
        local gm = workspace:FindFirstChild("_GAMEMODE")
        local pFolder = gm and (gm:FindFirstChild("Portal") or gm:FindFirstChild(inMode))
        return true, pFolder or inMode
    end
    return false, nil
end

local function isPlayerInGamemode(name)
    local mode, inMode = getActiveGamemode()
    if not name then
        return (mode ~= nil), (inMode or mode)
    end
    local targetName = tostring(name):lower()
    if mode and tostring(mode):lower():find(targetName) then
        return true, inMode or mode
    end
    if inMode and tostring(inMode):lower():find(targetName) then
        return true, inMode
    end
    local gm = workspace:FindFirstChild("_GAMEMODE")
    if gm then
        for _, child in ipairs(gm:GetChildren()) do
            if child.Name:lower():find(targetName) then
                return true, child
            end
        end
    end
    local char = getChar()
    if char then
        for _, attr in ipairs({"InRaid", "InTimeTrial", "InPortal", "InInvasion", "InMode", "Mode", "InGamemode"}) do
            local val = char:GetAttribute(attr)
            if val and tostring(val):lower():find(targetName) then
                return true, val
            end
        end
    end
    return false, nil
end

local function isPlayerInInvasion()
    return isPlayerInGamemode("Invasion")
end

-- RECURSIVE & ROBUST ENEMY SCANNER (Normal Maps + Gamemodes + Bosses + Nested Folders)
local function getMapEnemies(mapName)
    local list = {}
    local serverEnemies = workspace:FindFirstChild("_ENEMIES") and workspace._ENEMIES:FindFirstChild("Server")
    local clientEnemies = workspace:FindFirstChild("_ENEMIES") and workspace._ENEMIES:FindFirstChild("Client")
    if not (serverEnemies and clientEnemies) then return list end

    local function scanFolder(folder)
        if not folder then return end
        for _, sEnemy in ipairs(folder:GetChildren()) do
            -- If it's a subfolder (like Portal_4012060006 or Gamemode room), scan recursively!
            if sEnemy:IsA("Folder") or sEnemy:IsA("Model") and not sEnemy:GetAttribute("HP") then
                scanFolder(sEnemy)
            else
                local uid = sEnemy.Name
                local hp = sEnemy:GetAttribute("HP") or 0
                local dead = sEnemy:GetAttribute("Dead")
                if hp > 0 and dead ~= true then
                    local cEnemy = clientEnemies:FindFirstChild(uid)
                    local root = cEnemy and (cEnemy:FindFirstChild("HumanoidRootPart") or cEnemy:FindFirstChildWhichIsA("BasePart"))
                    -- Fallback: check workspace._MAP or sEnemy itself if client root is nil
                    if not root and sEnemy:IsA("BasePart") then
                        root = sEnemy
                    end
                    if root then
                        table.insert(list, {
                            UID   = uid,
                            Name  = sEnemy:GetAttribute("Name") or sEnemy.Name,
                            HP    = hp,
                            MaxHP = sEnemy:GetAttribute("MaxHP") or hp,
                            Order = sEnemy:GetAttribute("Order") or 1,
                            Part  = root,
                            Model = cEnemy or sEnemy
                        })
                    end
                end
            end
        end
    end

    if mapName and mapName ~= "All" then
        local mapFolder = serverEnemies:FindFirstChild(mapName)
        if mapFolder then
            scanFolder(mapFolder)
        end
    else
        -- Scan all map folders
        for _, f in ipairs(serverEnemies:GetChildren()) do
            scanFolder(f)
        end
    end

    -- If searching for Gamemode and list is empty, scan ALL folders in serverEnemies as fallback!
    if #list == 0 and (mapName == "Gamemode" or mapName == "Raid" or mapName == "Time Trial" or mapName == "Portal") then
        local gmFolder = serverEnemies:FindFirstChild("Gamemode")
        if gmFolder then scanFolder(gmFolder) end
        -- Fallback check in case gamemode monsters spawn in a named map folder (e.g. DBZ, OnePiece)
        for _, f in ipairs(serverEnemies:GetChildren()) do
            if f.Name:lower():find("gamemode") or f.Name:lower():find("raid") or f.Name:lower():find("portal") or f.Name:lower():find("boss") then
                scanFolder(f)
            end
        end
    end

    return list
end

-- STICKY TARGET VALIDATION (Deep Search Across Server and Client with Cluster Support)
local function isCurrentTargetStillAlive()
    local serverEnemies = workspace:FindFirstChild("_ENEMIES") and workspace._ENEMIES:FindFirstChild("Server")
    local clientEnemies = workspace:FindFirstChild("_ENEMIES") and workspace._ENEMIES:FindFirstChild("Client")
    if not (serverEnemies and clientEnemies) then return false end

    local function getAliveEnemy(uid)
        if not uid then return nil end
        local sObj = serverEnemies:FindFirstChild(uid, true)
        if not sObj then return nil end
        local hp = sObj:GetAttribute("HP") or 0
        local dead = sObj:GetAttribute("Dead")
        if hp <= 0 or dead == true then return nil end

        -- VALIDATE GAMEMODE vs OVERWORLD CONTEXT:
        local mode, inMode = getActiveGamemode()
        local gmFolder = serverEnemies:FindFirstChild("Gamemode")
        local isGamemodeMob = gmFolder and sObj:IsDescendantOf(gmFolder)
        if (not mode and not inMode) and isGamemodeMob then
            return nil
        end
        if (mode or inMode) and not isGamemodeMob then
            return nil
        end

        local cObj = clientEnemies:FindFirstChild(uid)
        local root = cObj and (cObj:FindFirstChild("HumanoidRootPart") or cObj:FindFirstChildWhichIsA("BasePart"))
        if not root and sObj:IsA("BasePart") then root = sObj end
        if not root then return nil end
        return { UID = uid, Part = root, Model = cObj or sObj }
    end

    -- Clean up dead enemies from currentCoveredTargetUIDs
    local aliveCovered = {}
    if currentCoveredTargetUIDs and #currentCoveredTargetUIDs > 0 then
        for _, uid in ipairs(currentCoveredTargetUIDs) do
            if getAliveEnemy(uid) then
                table.insert(aliveCovered, uid)
            end
        end
        currentCoveredTargetUIDs = aliveCovered
    end

    if currentLockedTargetUID then
        local primary = getAliveEnemy(currentLockedTargetUID)
        if primary then
            if #currentCoveredTargetUIDs == 0 then
                currentCoveredTargetUIDs = { currentLockedTargetUID }
            end
            return true, primary.UID, primary.Part, primary.Model
        end
    end

    -- If primary died, check if any remaining member of cluster is alive!
    if #currentCoveredTargetUIDs > 0 then
        for _, uid in ipairs(currentCoveredTargetUIDs) do
            local nextAlive = getAliveEnemy(uid)
            if nextAlive then
                currentLockedTargetUID = nextAlive.UID
                if getgenv then getgenv()._CurrentLockedUID = nextAlive.UID end
                return true, nextAlive.UID, nextAlive.Part, nextAlive.Model
            end
        end
    end

    currentLockedTargetUID = nil
    currentCoveredTargetUIDs = {}
    if getgenv then
        getgenv()._CurrentLockedUID = nil
        getgenv()._CurrentCoveredUIDs = {}
    end
    return false
end



local AvatarData = nil
pcall(function()
    AvatarData = require(game:GetService("ReplicatedStorage").Framework.Modules.Data.AvatarData)
end)

local AVATAR_MAP_FALLBACK = {
    DBZ = {
        { Id = "Dende", Monster = "Namekian Healer" },
        { Id = "Bulma", Monster = "Master Inventor" },
        { Id = "Kuririn", Monster = "Strongest Human" },
        { Id = "Piccolo", Monster = "Namekian Warrior" },
        { Id = "Gohan", Monster = "Hidden Potential" },
        { Id = "Vegeta", Monster = "Saiyan Prince" }
    },
    AOT = {
        { Id = "Sasha", Monster = "Scout Potato" },
        { Id = "Connie", Monster = "Buzzcut Scout" },
        { Id = "Hange", Monster = "Scout Scientist" },
        { Id = "Armin", Monster = "Tactical Scout" },
        { Id = "Mikasa", Monster = "Ace Scout" },
        { Id = "Levi", Monster = "Ace Captain" }
    },
    Naruto = {
        { Id = "Shikamaru", Monster = "Shadow Tactician" },
        { Id = "Sakura", Monster = "Destructive Fist" },
        { Id = "Hinata", Monster = "Gentle Fist" },
        { Id = "Choji", Monster = "Akimichi Titan" },
        { Id = "Tsunade", Monster = "Slug Sannin" },
        { Id = "Kakashi", Monster = "Copy Ninja" }
    },
    Nanatsu = {
        { Id = "Gowther", Monster = "Goat Sin" },
        { Id = "Diane", Monster = "Serpent Sin" },
        { Id = "King", Monster = "Grizzly Sin" },
        { Id = "Ban", Monster = "Fox Sin" },
        { Id = "Merlin", Monster = "Boar Sin" },
        { Id = "Escanor", Monster = "Lion Sin" }
    },
    SoloLeveling = {
        { Id = "SungJinWoo", Monster = "Weakest Hunter" },
        { Id = "TaeShik", Monster = "Stealth Assassin" },
        { Id = "SongChiyul", Monster = "Veteran Hunter" },
        { Id = "WooJinChul", Monster = "Surveillance Chief" },
        { Id = "ChaHaeIn", Monster = "Sword Dancer" },
        { Id = "ThomasAndre", Monster = "The Goliath" }
    },
    OnePiece = {
        { Id = "Nami", Monster = "Cat Burglar" },
        { Id = "Usopp", Monster = "Sniper King" },
        { Id = "Sanji", Monster = "Black Leg" },
        { Id = "Zoro", Monster = "Pirate Hunter" },
        { Id = "Luffy", Monster = "Straw Hat" },
        { Id = "Ace", Monster = "Fire Fist" }
    }
}

local function getMissingAvatarMonstersForMap(targetMap)
    local missing = {}
    local pd = Library and Library.PlayerData
    local avIndex = pd and (pd.AvatarIndex or {}) or {}

    if AvatarData then
        for avId, data in pairs(AvatarData) do
            if data.Map == targetMap and data.Name then
                if not avIndex[avId] then
                    missing[data.Name:lower()] = avId
                end
            end
        end
    else
        local mapList = AVATAR_MAP_FALLBACK[targetMap] or {}
        for _, entry in ipairs(mapList) do
            if not avIndex[entry.Id] then
                missing[entry.Monster:lower()] = entry.Id
            end
        end
    end
    return missing
end

-- Verified Game Data: EXACT monsters that drop Raid Tickets in each world
-- Filtered strictly to mid-range sub-bosses (รอง Secret Boss)
local RAID_TICKET_DROPPERS = {
    DBZ = {
        Preferred = "Hidden Potential", -- Order 5 (Gohan, 1% drop chance) - รอง Secret Boss เลือดกลางๆ พอดี
        Allowed = { "Hidden Potential", "Namekian Warrior", "Strongest Human" } -- Order 3, 4, 5 all drop DBZRaidTicket!
    },
    AOT = {
        Preferred = "Ace Scout", -- Order 5 (Mikasa, 1% drop chance) - รอง Secret Boss เลือดกลางๆ พอดี
        Allowed = { "Ace Scout", "Tactical Scout", "Scout Scientist" } -- Order 3, 4, 5 all drop AOTRaidTicket!
    },
    Naruto = {
        Preferred = "Slug Sannin", -- Order 5 (Tsunade, 1% drop chance) - รอง Secret Boss
        Allowed = { "Slug Sannin", "Akimichi Titan", "Gentle Fist" } -- Order 3, 4, 5 all drop NarutoRaidTicket!
    },
    Nanatsu = {
        Preferred = "Boar Sin", -- Order 5 (Merlin, 1% drop chance) - รอง Secret Boss
        Allowed = { "Boar Sin", "Fox Sin", "Grizzly Sin" } -- Order 3, 4, 5 all drop NanatsuRaidTicket!
    },
    SoloLeveling = {
        Preferred = "Sword Dancer", -- Order 5 (ChaHaeIn, 1% drop chance) - รอง Secret Boss
        Allowed = { "Sword Dancer", "Surveillance Chief", "Veteran Hunter" } -- Order 3, 4, 5 all drop SoloLevelingRaidTicket!
    },
    OnePiece = {
        Preferred = "Straw Hat", -- Order 5 (Luffy, 1% drop chance) - รอง Secret Boss
        Allowed = { "Straw Hat", "Pirate Hunter", "Black Leg" } -- Order 3, 4, 5 all drop OnePieceRaidTicket!
    }
}

local function getRaidTicketsCount(targetMap)
    local pd = Library and Library.PlayerData
    local items = pd and pd.Items or {}
    local tMap = targetMap or "DBZ"
    local ticketName = tMap .. "RaidTicket"
    return items[ticketName] or items["RaidTicket"] or 0
end

local function isRaidTicketDropper(monsterName, mapName)
    local cfg = RAID_TICKET_DROPPERS[mapName]
    if not cfg then return false end
    local mLower = string.lower(monsterName or "")
    for _, allowed in ipairs(cfg.Allowed) do
        local aLower = string.lower(allowed)
        if mLower == aLower or string.find(mLower, aLower, 1, true) or string.find(aLower, mLower, 1, true) then
            return true
        end
    end
    return false
end

-- Selects ONLY monsters confirmed to drop Raid Tickets (เน้นตัวเลือดกลางๆ รอง Secret Boss)
local function getMidTierRaidTicketMonster(targetMap)
    local curMap = getCurrentMap()
    local enemies = getMapEnemies(targetMap)
    if #enemies == 0 then enemies = getMapEnemies(curMap) end
    if #enemies == 0 then enemies = getMapEnemies("All") end
    if #enemies == 0 then return nil end

    local cfg = RAID_TICKET_DROPPERS[targetMap] or RAID_TICKET_DROPPERS[curMap]
    if cfg then
        -- 1. Try to find the exact preferred sub-boss first (รอง Secret Boss)
        local prefName = string.lower(cfg.Preferred)
        for _, e in ipairs(enemies) do
            local eName = string.lower(e.Name)
            if eName == prefName or string.find(eName, prefName, 1, true) or string.find(prefName, eName, 1, true) then
                return e
            end
        end

        -- 2. Otherwise find ANY monster in the confirmed ticket-dropping list
        for _, allowed in ipairs(cfg.Allowed) do
            local aName = string.lower(allowed)
            for _, e in ipairs(enemies) do
                local eName = string.lower(e.Name)
                if eName == aName or string.find(eName, aName, 1, true) or string.find(aName, eName, 1, true) then
                    return e
                end
            end
        end
    end

    return nil
end

-- ══════════════════════════════════════════════════════════
-- COMBAT RANGE & OPTIMAL CENTROID COVERAGE ENGINE
-- ══════════════════════════════════════════════════════════
local lastTeleportedUID = nil

local function getPlayerAttackRadius()
    local radius = 18.0
    pcall(function()
        local ar = workspace:FindFirstChild("_IGNORE") and workspace._IGNORE:FindFirstChild("AttackRange")
        if ar then
            local hb = ar:FindFirstChild("Hitbox")
            if hb and hb:IsA("BasePart") then
                radius = hb.Size.X / 2
            end
        end
    end)
    -- Safe buffer of 1.2 studs so enemies near the edge are 100% within the circle hitbox
    return math.max(8.0, radius - 1.2)
end

local floorRayParams = RaycastParams.new()
floorRayParams.FilterType = Enum.RaycastFilterType.Include
floorRayParams.CollisionGroup = "Default"

local function getCombatFloorY(x, z, fallbackY)
    pcall(function()
        local mapFolder = workspace:FindFirstChild("_MAP")
        floorRayParams.FilterDescendantsInstances = { mapFolder or workspace }
    end)
    local origin = Vector3.new(x, fallbackY + 12, z)
    local result = workspace:Raycast(origin, Vector3.new(0, -45, 0), floorRayParams)
    if result and result.Position then
        return result.Position.Y
    end
    return fallbackY
end

local function findOptimalCombatCluster(enemyList)
    if not enemyList or #enemyList == 0 then
        return nil, nil, {}
    end

    local valid = {}
    for _, e in ipairs(enemyList) do
        if e and e.Part and e.UID and (e.HP or 0) > 0 then
            table.insert(valid, e)
        end
    end

    local count = #valid
    if count == 0 then
        return nil, nil, {}
    end

    if count == 1 then
        local e = valid[1]
        local pos = e.Part.Position
        local groundY = getCombatFloorY(pos.X, pos.Z, pos.Y)
        return Vector3.new(pos.X, groundY + 2.5, pos.Z), e.UID, { e.UID }
    end

    -- If too many enemies, limit candidate search to nearest 30 to preserve 60+ FPS
    local root = getRoot()
    local playerPos = root and root.Position or Vector3.zero
    if count > 30 then
        table.sort(valid, function(a, b)
            local da = (a.Part.Position - playerPos).Magnitude
            local db = (b.Part.Position - playerPos).Magnitude
            return da < db
        end)
        local trimmed = {}
        for i = 1, 30 do table.insert(trimmed, valid[i]) end
        valid = trimmed
        count = #valid
    end

    local R = getPlayerAttackRadius()
    local R2 = R * R

    -- Build quick lookup for current targets to give sticky preference
    local currentCoveredMap = {}
    if currentCoveredTargetUIDs then
        for _, u in ipairs(currentCoveredTargetUIDs) do
            currentCoveredMap[u] = true
        end
    end

    local bestCount = 0
    local bestScore = -1e9
    local bestCandX = valid[1].Part.Position.X
    local bestCandZ = valid[1].Part.Position.Z
    local bestCluster = {}

    local function evaluateCand(cx, cz)
        local covered = {}
        local totalHP = 0
        local hasCurrentLock = false

        for i = 1, count do
            local e = valid[i]
            local pos = e.Part.Position
            local dx = pos.X - cx
            local dz = pos.Z - cz
            if (dx * dx + dz * dz) <= R2 then
                table.insert(covered, e)
                totalHP = totalHP + (e.HP or 0)
                if currentCoveredMap[e.UID] or (currentLockedTargetUID and e.UID == currentLockedTargetUID) then
                    hasCurrentLock = true
                end
            end
        end

        local num = #covered
        if num == 0 then return end

        local distP = math.sqrt((cx - playerPos.X)^2 + (cz - playerPos.Z)^2)
        -- Scoring priority:
        -- 1. Number of enemies inside circle (1,000,000 pts each) -> e.g. 4 > 3 > 2 > 1
        -- 2. Sticky lock bonus (+800,000 pts) -> finish current group before switching away
        -- 3. Distance penalty -> prefer closest cluster
        -- 4. HP penalty -> prefer lower HP group
        local score = (num * 1000000)
            + (hasCurrentLock and 800000 or 0)
            - (distP * 10)
            - (totalHP * 0.001)

        if score > bestScore then
            bestScore = score
            bestCount = num
            bestCandX = cx
            bestCandZ = cz
            bestCluster = covered
        end
    end

    -- 1. Test single enemy positions
    for i = 1, count do
        local p = valid[i].Part.Position
        evaluateCand(p.X, p.Z)
    end

    -- 2. Test 2-point circumcircles (intersection of two circles of radius R)
    local doubleR = 2 * R
    for i = 1, count do
        local p1 = valid[i].Part.Position
        for j = i + 1, count do
            local p2 = valid[j].Part.Position
            local dx = p2.X - p1.X
            local dz = p2.Z - p1.Z
            local d = math.sqrt(dx * dx + dz * dz)
            if d <= doubleR and d > 0.05 then
                local mx = (p1.X + p2.X) * 0.5
                local mz = (p1.Z + p2.Z) * 0.5
                local h = math.sqrt(math.max(0, R2 - (d * 0.5) * (d * 0.5)))
                local ux = -dz / d
                local uz = dx / d
                evaluateCand(mx, mz)
                evaluateCand(mx + h * ux, mz + h * uz)
                evaluateCand(mx - h * ux, mz - h * uz)
            end
        end
    end

    if #bestCluster == 0 then
        local e = valid[1]
        local pos = e.Part.Position
        local gy = getCombatFloorY(pos.X, pos.Z, pos.Y)
        return Vector3.new(pos.X, gy + 2.5, pos.Z), e.UID, { e.UID }
    end

    -- 3. Centroid calculation: center of mass of covered enemies
    local sumX, sumY, sumZ = 0, 0, 0
    local coveredUIDs = {}
    local primaryUID = bestCluster[1].UID

    for _, e in ipairs(bestCluster) do
        local pos = e.Part.Position
        sumX = sumX + pos.X
        sumY = sumY + pos.Y
        sumZ = sumZ + pos.Z
        table.insert(coveredUIDs, e.UID)
        if currentLockedTargetUID and e.UID == currentLockedTargetUID then
            primaryUID = e.UID
        end
    end

    local numBest = #bestCluster
    local cX = sumX / numBest
    local cY = sumY / numBest
    local cZ = sumZ / numBest

    -- If all enemies in the cluster fit inside radius R from the centroid,
    -- the centroid places the player perfectly in the center between all mobs!
    local isCentroidEnclosed = true
    for _, e in ipairs(bestCluster) do
        local pos = e.Part.Position
        local dx = pos.X - cX
        local dz = pos.Z - cZ
        if (dx * dx + dz * dz) > R2 then
            isCentroidEnclosed = false
            break
        end
    end

    local finalX = isCentroidEnclosed and cX or bestCandX
    local finalZ = isCentroidEnclosed and cZ or bestCandZ
    local floorY = getCombatFloorY(finalX, finalZ, cY)
    local optPos = Vector3.new(finalX, floorY + 2.5, finalZ)

    return optPos, primaryUID, coveredUIDs
end

local function teleportToCombat(targetPos, coveredUIDs, primaryUID)
    local root = getRoot()
    if not (targetPos and root) then return end

    currentLockedTargetUID = primaryUID
    currentCoveredTargetUIDs = (coveredUIDs and #coveredUIDs > 0) and coveredUIDs or { primaryUID }
    if getgenv then
        getgenv()._CurrentLockedUID = primaryUID
        getgenv()._CurrentCoveredUIDs = currentCoveredTargetUIDs
    end

    -- Keep game's attack zone targets synchronized
    Library.Target = currentCoveredTargetUIDs

    local currentDist = (root.Position - targetPos).Magnitude
    local targetChanged = (primaryUID ~= lastTeleportedUID)

    if targetChanged or currentDist > 3.0 then
        lastTeleportedUID = primaryUID
        TIMERS.lastTeleportTick = os.clock()
        root.CFrame = CFrame.new(targetPos)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end

local function teleportToTarget(part, uid)
    if not (part and uid) then return end
    local pos = part.Position
    local floorY = getCombatFloorY(pos.X, pos.Z, pos.Y)
    local combatPos = Vector3.new(pos.X, floorY + 2.5, pos.Z)
    teleportToCombat(combatPos, { uid }, uid)
end

local function selectTargetEnemy()
    -- 0. TOP PRIORITY: AUTO FARM MISSING AVATAR INDEX
    if CFG.AutoIndexFarm then
        local curMap = getCurrentMap()
        local chosenMap = CFG.IndexFarmWorld or "Current Map"
        local targetIndexMap = (chosenMap ~= "Current Map") and chosenMap or (curMap ~= "Lobby" and curMap or "DBZ")

        -- If target map is specified and we are not in that map, WARP IMMEDIATELY!
        if targetIndexMap and targetIndexMap ~= "Current Map" and curMap ~= targetIndexMap then
            if os.clock() - TIMERS.lastIndexMapTeleport >= 2.0 then
                TIMERS.lastIndexMapTeleport = os.clock()
                currentLockedTargetUID = nil
                currentCoveredTargetUIDs = {}
                pcall(function()
                    Library.Remote:Fire("TeleportSystem", "To", targetIndexMap)
                end)
            end
        end

        local missingAvatars = getMissingAvatarMonstersForMap(targetIndexMap)
        local hasAnyMissing = false
        for _ in pairs(missingAvatars) do
            hasAnyMissing = true
            break
        end

        if hasAnyMissing then
            -- Check if current locked target is already one of the missing avatar monsters and still alive
            if currentLockedTargetUID then
                local stillAlive, lUID, lPart, lModel = isCurrentTargetStillAlive()
                if stillAlive then
                    local sName = (lModel:GetAttribute("Name") or lModel.Name):lower()
                    for monsterNameLower, avId in pairs(missingAvatars) do
                        if sName == monsterNameLower or sName:find(monsterNameLower) or monsterNameLower:find(sName) then
                            if getgenv then getgenv()._CurrentLockedUID = lUID end
                            return lUID, lPart, lModel, nil, currentCoveredTargetUIDs
                        end
                    end
                end
            end

            -- Find enemies belonging to targetIndexMap (or all current active map enemies)
            local targetEnemies = getMapEnemies(targetIndexMap)
            if #targetEnemies == 0 then
                targetEnemies = getMapEnemies(curMap)
            end
            if #targetEnemies == 0 then
                targetEnemies = getMapEnemies("All")
            end

            local matchingEnemies = {}
            for _, e in ipairs(targetEnemies) do
                local eNameLower = e.Name:lower()
                for monsterNameLower, avId in pairs(missingAvatars) do
                    if eNameLower == monsterNameLower or eNameLower:find(monsterNameLower) or monsterNameLower:find(eNameLower) then
                        table.insert(matchingEnemies, e)
                        break
                    end
                end
            end

            if #matchingEnemies > 0 then
                local optPos, primaryUID, coveredUIDs = findOptimalCombatCluster(matchingEnemies)
                if optPos and primaryUID then
                    local chosen = matchingEnemies[1]
                    for _, e in ipairs(matchingEnemies) do
                        if e.UID == primaryUID then chosen = e break end
                    end
                    currentLockedTargetUID = primaryUID
                    currentCoveredTargetUIDs = coveredUIDs
                    if getgenv then
                        getgenv()._CurrentLockedUID = primaryUID
                        getgenv()._CurrentCoveredUIDs = coveredUIDs
                    end
                    return primaryUID, chosen.Part, chosen.Model, optPos, coveredUIDs
                end
            end
        end
    end

    -- 0.5. RAID TICKET FARMING (Strictly Mid-Tier Sub-Boss Droppers ONLY)
    if CFG.AutoRaid and CFG.AutoFarmTicketIfNone then
        local raidMap = CFG.RaidTargetMap or "DBZ"
        local tickets = getRaidTicketsCount(raidMap)
        if tickets <= 0 then
            -- Verify sticky target: MUST be in confirmed ticket-dropping list of raidMap!
            local stillAlive, lockedUID, lockedPart, lockedModel = isCurrentTargetStillAlive()
            if stillAlive and lockedModel then
                local mName = lockedModel:GetAttribute("Name") or lockedModel.Name
                if isRaidTicketDropper(mName, raidMap) then
                    if getgenv then getgenv()._CurrentLockedUID = lockedUID end
                    return lockedUID, lockedPart, lockedModel, nil, currentCoveredTargetUIDs
                else
                    currentLockedTargetUID = nil -- Drop the lock on non-ticket mob
                    currentCoveredTargetUIDs = {}
                end
            end

            -- Target preferred or allowed sub-boss in raidMap only
            local subBoss = getMidTierRaidTicketMonster(raidMap)
            if subBoss then
                currentLockedTargetUID = subBoss.UID
                currentCoveredTargetUIDs = { subBoss.UID }
                if getgenv then getgenv()._CurrentLockedUID = currentLockedTargetUID end
                return subBoss.UID, subBoss.Part, subBoss.Model, nil, currentCoveredTargetUIDs
            end

            -- If ticket sub-boss is temporarily dead, DO NOT FALL THROUGH to weak mobs!
            currentLockedTargetUID = nil
            currentCoveredTargetUIDs = {}
            if getgenv then getgenv()._CurrentLockedUID = nil end
            return nil, nil, nil, nil, {}
        end
    end

    -- 0.8. AUTO GO NEW AREA: If we unlocked a newer area, warp IMMEDIATELY and drop old map target lock!
    local curMap = getCurrentMap()
    local highestUnlocked = getHighestUnlockedMap()
    if CFG.AutoGoNewArea and highestUnlocked and highestUnlocked ~= "Lobby" and curMap ~= highestUnlocked then
        currentLockedTargetUID = nil
        currentCoveredTargetUIDs = {}
        if os.clock() - TIMERS.lastNewAreaTeleport >= 1.0 then
            TIMERS.lastNewAreaTeleport = os.clock()
            pcall(function()
                Library.Remote:Fire("TeleportSystem", "To", highestUnlocked)
            end)
        end
        -- Do not attack old map mob while waiting for warp!
        return nil, nil, nil, nil, {}
    end

    -- 1. STICKY TARGET CHECK: If locked target is still alive, KEEP IT!
    local stillAlive, lockedUID, lockedPart, lockedModel = isCurrentTargetStillAlive()
    if stillAlive then
        if getgenv then getgenv()._CurrentLockedUID = lockedUID end
        return lockedUID, lockedPart, lockedModel, nil, currentCoveredTargetUIDs
    end

    -- Target died or no target locked: unlock and find NEW target
    currentLockedTargetUID = nil
    currentCoveredTargetUIDs = {}
    if getgenv then getgenv()._CurrentLockedUID = nil end

    -- 2. GAMEMODE TARGETS (Raid / Time Trial / Portal / InMode Events)
    local mode, inMode = getActiveGamemode()
    if mode or inMode then
        local gmEnemies = getMapEnemies("Gamemode")
        if #gmEnemies == 0 then
            -- Fallback scan: check all monsters currently alive in entire server enemies
            local allEnemies = getMapEnemies("All")
            if #allEnemies > 0 then
                gmEnemies = allEnemies
            end
        end

        if #gmEnemies > 0 then
            local optPos, primaryUID, coveredUIDs = findOptimalCombatCluster(gmEnemies)
            if optPos and primaryUID then
                local chosen = gmEnemies[1]
                for _, e in ipairs(gmEnemies) do
                    if e.UID == primaryUID then chosen = e break end
                end
                currentLockedTargetUID = primaryUID
                currentCoveredTargetUIDs = coveredUIDs
                if getgenv then
                    getgenv()._CurrentLockedUID = primaryUID
                    getgenv()._CurrentCoveredUIDs = coveredUIDs
                end
                return primaryUID, chosen.Part, chosen.Model, optPos, coveredUIDs
            end
        end
    end

    -- 3. NORMAL ZONE SELECTION
    local curMap = getCurrentMap()
    local highestUnlocked = getHighestUnlockedMap()
    local targetMap = curMap

    -- Check if we have a pending unlock that needs gold!
    local pd = Library and Library.PlayerData
    local playerGold = pd and (pd.Gold or (pd.Items and pd.Items.Gold) or 0) or 0
    if currentPendingUnlock and playerGold < currentPendingUnlock.Cost then
        -- Farm gold in the target map or highest unlocked map
        targetMap = currentPendingUnlock.Map or highestUnlocked
        if curMap ~= targetMap and (os.clock() - TIMERS.lastNewAreaTeleport >= 3.0) then
            TIMERS.lastNewAreaTeleport = os.clock()
            pcall(function()
                Library.Remote:Fire("TeleportSystem", "To", targetMap)
            end)
        end
    elseif CFG.AutoGoNewArea and highestUnlocked and highestUnlocked ~= "Lobby" then
        targetMap = highestUnlocked
        -- Proactively travel to the latest unlocked map if not already there!
        if curMap ~= highestUnlocked and (os.clock() - TIMERS.lastNewAreaTeleport >= 3.0) then
            TIMERS.lastNewAreaTeleport = os.clock()
            pcall(function()
                Library.Remote:Fire("TeleportSystem", "To", highestUnlocked)
            end)
        end
    end

    local enemies = getMapEnemies(targetMap)
    -- If AutoGoNewArea is on and we are in targetMap, DO NOT fallback to old maps!
    if #enemies == 0 and not CFG.AutoGoNewArea then
        if targetMap ~= curMap then
            targetMap = curMap
            enemies = getMapEnemies(targetMap)
        end
        if #enemies == 0 then
            for _, m in ipairs(MAP_LIST) do
                local eList = getMapEnemies(m)
                if #eList > 0 then
                    enemies = eList
                    break
                end
            end
        end
        if #enemies == 0 then
            enemies = getMapEnemies("All")
        end
    end
    if #enemies == 0 then return nil, nil, nil, nil, {} end

    -- 2. Filter by monster multi-selection (Matches both raw name and [ Map ] suffix)
    local selectedMonsters = CFG.TargetMonsterFilterMulti or (CFG.TargetMonsterFilter and { CFG.TargetMonsterFilter }) or {"All"}
    local isAll = isItemInList(selectedMonsters, "All")
    if not isAll and #selectedMonsters > 0 then
        local filtered = {}
        for _, e in ipairs(enemies) do
            for _, sel in pairs(selectedMonsters) do
                local rawSel = sel:gsub("%s*%[.-%]%s*", ""):lower()
                if e.Name:lower() == rawSel or e.Name:lower():find(rawSel) or (sel:lower():find(e.Name:lower())) then
                    table.insert(filtered, e)
                    break
                end
            end
        end
        if #filtered > 0 then
            local optPos, primaryUID, coveredUIDs = findOptimalCombatCluster(filtered)
            if optPos and primaryUID then
                local chosen = filtered[1]
                for _, e in ipairs(filtered) do
                    if e.UID == primaryUID then chosen = e break end
                end
                currentLockedTargetUID = primaryUID
                currentCoveredTargetUIDs = coveredUIDs
                if getgenv then
                    getgenv()._CurrentLockedUID = primaryUID
                    getgenv()._CurrentCoveredUIDs = coveredUIDs
                end
                return primaryUID, chosen.Part, chosen.Model, optPos, coveredUIDs
            end
        end
    end

    local optPos, primaryUID, coveredUIDs = findOptimalCombatCluster(enemies)
    if optPos and primaryUID then
        local chosen = enemies[1]
        for _, e in ipairs(enemies) do
            if e.UID == primaryUID then chosen = e break end
        end
        currentLockedTargetUID = primaryUID
        currentCoveredTargetUIDs = coveredUIDs
        if getgenv then
            getgenv()._CurrentLockedUID = primaryUID
            getgenv()._CurrentCoveredUIDs = coveredUIDs
        end
        return primaryUID, chosen.Part, chosen.Model, optPos, coveredUIDs
    end

    currentLockedTargetUID = enemies[1].UID
    currentCoveredTargetUIDs = { enemies[1].UID }
    if getgenv then
        getgenv()._CurrentLockedUID = currentLockedTargetUID
        getgenv()._CurrentCoveredUIDs = currentCoveredTargetUIDs
    end
    return enemies[1].UID, enemies[1].Part, enemies[1].Model, nil, { enemies[1].UID }
end

local function setupDashListener()
    local function track(connection)
        table.insert(_G.AnimeBreaker_Connections, connection)
    end
    local function hookRoot(character)
        local root = character:WaitForChild("HumanoidRootPart", 5)
        if not root then return end
        track(root.ChildAdded:Connect(function(child)
            if not CFG.DashHack then return end
            local hum = getHum()
            local direction = (hum and hum.MoveDirection.Magnitude > 0) and hum.MoveDirection or root.CFrame.LookVector
            if child:IsA("LinearVelocity") then
                child.VectorVelocity = direction * (CFG.DashSpeed or 150)
            elseif child:IsA("BodyVelocity") then
                child.Velocity = direction * (CFG.DashSpeed or 150)
                child.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            end
        end))
    end
    if lp.Character then hookRoot(lp.Character) end
    track(lp.CharacterAdded:Connect(hookRoot))
end
task.spawn(setupDashListener)

-- WALL BREAKING, QUESTS, UNLOCKS & MODES
-- ══════════════════════════════════════════════════════════
local function getMapWall(mapName)
    local mapFolder = workspace:FindFirstChild("_MAP") and workspace._MAP:FindFirstChild(mapName)
    local wall = mapFolder and mapFolder:FindFirstChild("Wall")
    local wallRoot = wall and (wall:FindFirstChild("Root") or wall:FindFirstChildWhichIsA("BasePart"))
    return wall, wallRoot
end

local function doAutoBreakWall()
    local curMap = getCurrentMap()
    local highestUnlocked = getHighestUnlockedMap()
    if highestUnlocked and highestUnlocked ~= "Lobby" and highestUnlocked ~= curMap then
        pcall(function()
            Library.Remote:Fire("TeleportSystem", "To", highestUnlocked)
        end)
        return
    end

    if isNextMapUnlocked(curMap) then
        local nextHighest = getHighestUnlockedMap()
        if nextHighest and nextHighest ~= "Lobby" and nextHighest ~= curMap then
            pcall(function()
                Library.Remote:Fire("TeleportSystem", "To", nextHighest)
            end)
            return
        end
    end

    local wall, wallRoot = getMapWall(curMap)
    local root = getRoot()

    if wallRoot and root then
        root.CFrame = wallRoot.CFrame * CFrame.new(0, 0, 8) * CFrame.Angles(0, math.pi, 0)
    end
    pcall(function()
        Library.Remote:Fire("WallSystem", "Click", curMap)
        Library.Remote:Fire("ClickSystem", "Execute", {})
    end)
end

local function handleSmartWallBreaking(now)
    if not CFG.AutoBreakWall then return false end
    local inRaid = isPlayerInRaid()
    local inTT = isPlayerInTimeTrial()
    local inPortal = isPlayerInPortal()
    if inRaid or inTT or inPortal then return false end

    local curMap = getCurrentMap()
    local highestUnlocked = getHighestUnlockedMap()

    -- 1. If we are not in the latest unlocked area, warp to latest area first!
    if highestUnlocked and highestUnlocked ~= "Lobby" and highestUnlocked ~= curMap then
        resetWallBreakTimers()
        currentLockedTargetUID = nil
        currentCoveredTargetUIDs = {}
        if now - TIMERS.lastNewAreaTeleport >= 1.0 then
            TIMERS.lastNewAreaTeleport = now
            pcall(function()
                Library.Remote:Fire("TeleportSystem", "To", highestUnlocked)
            end)
        end
        return true
    end

    -- 2. If the next map is already unlocked (wall broken), warp to the new latest area immediately!
    if isNextMapUnlocked(curMap) then
        resetWallBreakTimers()
        currentLockedTargetUID = nil
        currentCoveredTargetUIDs = {}
        local nextHighest = getHighestUnlockedMap()
        if nextHighest and nextHighest ~= "Lobby" and nextHighest ~= curMap then
            if now - TIMERS.lastNewAreaTeleport >= 1.0 then
                TIMERS.lastNewAreaTeleport = now
                pcall(function()
                    Library.Remote:Fire("TeleportSystem", "To", nextHighest)
                end)
            end
            return true
        end
    end

    -- 3. We are in the latest area and the wall is locked: break it!
    local wall, wallRoot = getMapWall(curMap)
    if not (wall and wallRoot) then return false end

    local function hitWall()
        local root = getRoot()
        if root then
            root.CFrame = wallRoot.CFrame * CFrame.new(0, 0, 6) * CFrame.Angles(0, math.pi, 0)
        end
        pcall(function()
            Library.Remote:Fire("WallSystem", "Click", curMap)
            Library.Remote:Fire("ClickSystem", "Execute", {})
            Library.Remote:Fire("ClickSystem", "CastSkill", {})
        end)
    end

    if CFG.WallBreakMode == "Continuous" then
        hitWall()
        return true
    elseif CFG.WallBreakMode == "Timed" then
        if not TIMERS.isAttackingWall and (now - TIMERS.wallCooldownStartTime >= CFG.WallFarmCooldown) then
            TIMERS.isAttackingWall = true
            TIMERS.wallAttackStartTime = now
        end

        if TIMERS.isAttackingWall then
            if (now - TIMERS.wallAttackStartTime <= CFG.WallAttackDuration) then
                hitWall()
                return true
            else
                TIMERS.isAttackingWall = false
                TIMERS.wallCooldownStartTime = now
            end
        end
    end
    return false
end

local function cleanupDuplicateCards()
    local pd = Library and Library.PlayerData
    if not (pd and pd.Cards) then return end

    local cardCounts = {}
    for uid, card in pairs(pd.Cards) do
        local id = card.Id or uid
        cardCounts[id] = cardCounts[id] or {}
        table.insert(cardCounts[id], { UID = uid, Card = card })
    end

    local toDelete = {}
    for id, list in pairs(cardCounts) do
        if #list > 1 then
            for i = 2, #list do
                local entry = list[i]
                if not entry.Card.Equipped and not entry.Card.Locked then
                    table.insert(toDelete, entry.UID)
                end
            end
        end
    end

    if #toDelete > 0 then
        Library.Remote:Fire("InventorySystem", "Delete", "Card", Library:Encode(toDelete))
    end
end




local function shouldStopSummon(pd)
    local target = CFG.SummonStopRarity or "Any"
    if target == "Any" then return false end
    local reqRank = parseTargetRank(target)
    if reqRank <= 0 then return false end
    local summonType = CFG.SummonType or "Pet"

    if summonType == "Race" then
        return checkGachaStopCondition("Race", target)
    elseif summonType == "Eye Technique" then
        return checkGachaStopCondition("Eye Technique", target)
    else
        local catKey = summonType .. "s"
        local inventory = pd and (pd[catKey] or pd[summonType] or pd.Pets or pd.Cards)
        if type(inventory) == "table" then
            for uid, item in pairs(inventory) do
                local itemId = (type(item) == "table" and (item.Id or uid)) or uid
                local rName, rOrder = getItemRarity(itemId)
                if rOrder >= reqRank then
                    return true, itemId, rName, rOrder
                end
            end
        end
    end
    return false
end

local function doAutoSummon()
    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end

    local shouldStop, itemId, rName = shouldStopSummon(pd)
    if shouldStop then
        stopSpinToggle("AutoSummon", "Card/Pet Summon", itemId, rName)
        return
    end

    local eggMap = CFG.SummonEgg or getCurrentMap()
    if eggMap == "Lobby" or not eggMap or eggMap == "" then eggMap = "DBZ" end
    local summonType = CFG.SummonType or "Pet"

    if summonType == "Race" then
        pcall(function()
            Library.Remote:Fire("GachaSystem", "Spin", "Race", "Default", {})
        end)
    elseif summonType == "Eye Technique" then
        pcall(function()
            Library.Remote:Fire("GachaSystem", "Spin", "Eye Technique", "Naruto", {})
        end)
    else
        pcall(function()
            Library.Remote:Fire("GachaSystem", "Spin", summonType, eggMap, {})
        end)
    end
end

local function handleAutoQuests(now)
    if not (CFG.AutoQuest or CFG.AutoQuests) then return end
    if now - TIMERS.lastQuestTick < 1.0 then return end
    TIMERS.lastQuestTick = now

    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end

    -- 1. Check & Claim Active Quest
    local active = pd.ActiveQuest
    if active and active.Type and active.Id then
        pcall(function()
            Library.Remote:Fire("QuestSystem", "Check", active.Type, active.Id)
            Library.Remote:Fire("QuestSystem", "Claim", active.Type, active.Id)
        end)
    end

    -- 2. Inspect Quests for Objectives (Global, Main, Daily, Stage)
    local allQuestCategories = { "Global", "Main", "Daily", "Event" }
    local quests = pd.Quests or {}
    
    for _, cat in ipairs(allQuestCategories) do
        local qList = quests[cat]
        if type(qList) == "table" then
            for qId, qData in pairs(qList) do
                if type(qData) == "table" and qData.Objectives then
                    for _, obj in ipairs(qData.Objectives) do
                        local oType = tostring(obj.Type or "")
                        local goal = tonumber(obj.Goal) or 1
                        local prog = tonumber(obj.Progress) or 0

                        if prog < goal then
                            -- Gacha / Card Spin Quest
                            if oType == "SpinGacha" or oType:find("Gacha") or oType:find("Card") then
                                if now - TIMERS.lastQuestGachaSpin >= 0.5 then
                                    TIMERS.lastQuestGachaSpin = now
                                    local curMap = getCurrentMap()
                                    if curMap == "Lobby" or not curMap or curMap == "" then curMap = "DBZ" end
                                    pcall(function()
                                        Library.Remote:Fire("GachaSystem", "Spin", "Pet", curMap, {})
                                    end)
                                end
                            -- Consumable Quests (e.g. "Use Consumable")
                            elseif oType == "UseConsumable" or oType:find("Consumable") then
                                if now - TIMERS.lastQuestConsumableUse >= 0.5 then
                                    TIMERS.lastQuestConsumableUse = now
                                    if pd.Items then
                                        for itemId, count in pairs(pd.Items) do
                                            if count > 0 and (itemId:find("Potion") or itemId:find("Juice")) then
                                                pcall(function()
                                                    Library.Remote:Fire("ItemSystem", "Use", itemId, 1, false, true)
                                                end)
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- 3. Stage-based Quests sequential checking
    for stageNum = 1, 50 do
        local q = quests[tostring(stageNum)] or quests[stageNum]
        if q then
            if q.Completed and not q.Claimed then
                pcall(function()
                    Library.Remote:Fire("QuestSystem", "Claim", stageNum)
                end)
            end
        else
            pcall(function()
                Library.Remote:Fire("QuestSystem", "Accept", stageNum)
            end)
            break
        end
    end
end

local currentPendingUnlock = nil

local UNLOCK_SYSTEMS_CONFIG = {
    { Id = "Gacha_Race",                 Name = "Race",              Map = "DBZ",          Cost = 10000,                  SettingKey = "AutoUnlockRace",           CostStr = "10k Gold" },
    { Id = "Upgrade_Warrior Upgrades",   Name = "Warrior Upgrades",  Map = "DBZ",          Cost = 15000,                  SettingKey = "AutoUnlockWarrior",        CostStr = "15k Gold" },
    { Id = "Upgrade_Offline Upgrades",   Name = "Offline Upgrades",  Map = "DBZ",          Cost = 45000,                  SettingKey = "AutoUnlockOffline",        CostStr = "45k Gold" },
    { Id = "Gacha_Titan",                Name = "Titan",             Map = "AOT",          Cost = 10000000,               SettingKey = "AutoUnlockTitan",          CostStr = "10M Gold" },
    { Id = "Gacha_Weapon_T1",            Name = "Weapon T1",         Map = "AOT",          Cost = 10935000,               SettingKey = "AutoUnlockWeapon",         CostStr = "10.93M Gold" },
    { Id = "Gacha_Hero Passive",         Name = "Hero Passive",      Map = "AOT",          Cost = 87480000,               SettingKey = "AutoUnlockHeroPassive",    CostStr = "87.48M Gold" },
    { Id = "Gacha_Eye Technique",        Name = "Eye Technique",     Map = "Naruto",       Cost = 2361960000,             SettingKey = "AutoUnlockEye",            CostStr = "2.36B Gold" },
    { Id = "Upgrade_Ninja Progression",  Name = "Ninja Progression", Map = "Naruto",       Cost = 3542940000,             SettingKey = "AutoUnlockNinja",          CostStr = "3.54B Gold" },
    { Id = "Upgrade_Red Cloud Totem",    Name = "Red Cloud Totem",   Map = "Naruto",       Cost = 10628820000,            SettingKey = "AutoUnlockRedCloud",       CostStr = "10.6B Gold" },
    { Id = "Gacha_Sin",                  Name = "Sin",               Map = "Nanatsu",      Cost = 5165606520000,          SettingKey = "AutoUnlockSin",            CostStr = "5.16T Gold" },
    { Id = "Gacha_Amulet Building",      Name = "Amulet Building",   Map = "Nanatsu",      Cost = 20662426080000,         SettingKey = "AutoUnlockAmulet",         CostStr = "20.6T Gold" },
    { Id = "Upgrade_Commandment Totem",  Name = "Commandment Totem", Map = "Nanatsu",      Cost = 41324852160000,         SettingKey = "AutoUnlockCommandment",    CostStr = "41.3T Gold" },
    { Id = "Gacha_Hunter Rank",          Name = "Hunter Rank",       Map = "SoloLeveling", Cost = 135566177510880000,     SettingKey = "AutoUnlockHunter",         CostStr = "135.5Qn Gold" },
    { Id = "Upgrade_Portal Upgrades",    Name = "Portal Upgrades",   Map = "SoloLeveling", Cost = 271132355021760000,     SettingKey = "AutoUnlockPortal",         CostStr = "271.1Qn Gold" },
    { Id = "Gacha_Shadow Passive",       Name = "Shadow Passive",    Map = "SoloLeveling", Cost = 542264710043520000,     SettingKey = "AutoUnlockShadow",         CostStr = "542.2Qn Gold" },
    { Id = "Upgrade_Ant Progression",    Name = "Ant Progression",   Map = "SoloLeveling", Cost = 813397065065280000,     SettingKey = "AutoUnlockAnt",            CostStr = "813.3Qn Gold" },
    { Id = "Upgrade_Class Tree",         Name = "Class Tree",        Map = "SoloLeveling", Cost = 1084529420087000000,    SettingKey = "AutoUnlockClassTree",      CostStr = "1.08Sx Gold" },
    { Id = "Gacha_Weapon Passive",       Name = "Weapon Passive",    Map = "OnePiece",     Cost = 26028706082088960000,   SettingKey = "AutoUnlockWeaponPassive",  CostStr = "26.0Sx Gold" },
    { Id = "Gacha_Haki",                 Name = "Haki",              Map = "OnePiece",     Cost = 65885162270288000000,   SettingKey = "AutoUnlockHaki",           CostStr = "65.8Sx Gold" },
}

local function doAutoQuests()
    local prior = CFG.AutoQuests
    CFG.AutoQuests = true
    TIMERS.lastQuestTick = 0
    local ok, reason = pcall(handleAutoQuests, os.clock())
    CFG.AutoQuests = prior
    if not ok then warn("[SpectreWare Quests] " .. tostring(reason)) end
end

local function handleIndividualSystemUnlocks(now)
    if now - TIMERS.lastUnlockStep < 0.75 then return end
    TIMERS.lastUnlockStep = now

    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end
    local unlocked = pd.Unlocked or {}
    local playerGold = pd.Gold or (pd.Items and pd.Items.Gold) or 0
    local unlockedMaps = pd.UnlockedMap or {}

    for _, sys in ipairs(UNLOCK_SYSTEMS_CONFIG) do
        if CFG[sys.SettingKey] and not unlocked[sys.Id] then
            if unlockedMaps[sys.Map] == true or sys.Map == "DBZ" or getCurrentMap() == sys.Map then
                if playerGold >= sys.Cost then
                    pcall(function()
                        Library.Remote:Fire("UnlockSystem", "Validate", sys.Id)
                    end)
                end
            end
        end
    end
end

-- Hook Character Spawn & Map Change to check enabled system unlocks
pcall(function()
    table.insert(_G.AnimeBreaker_Connections, lp.CharacterAdded:Connect(function()
        task.wait(1.5)
        pcall(function() handleIndividualSystemUnlocks(os.clock()) end)
    end))
    table.insert(_G.AnimeBreaker_Connections, lp:GetAttributeChangedSignal("Map"):Connect(function()
        task.wait(1.5)
        pcall(function() handleIndividualSystemUnlocks(os.clock()) end)
    end))
end)


local function getCurrentGamemodeStage()
    local lp = game:GetService("Players").LocalPlayer
    local inMode = lp:GetAttribute("InMode")

    -- 1. Check ReplicatedStorage.Server.Gamemode[inMode] attribute directly
    local srv = game:GetService("ReplicatedStorage"):FindFirstChild("Server")
    local gm = srv and srv:FindFirstChild("Gamemode")
    local roomInst = gm and inMode and gm:FindFirstChild(inMode)
    if roomInst then
        local stage = roomInst:GetAttribute("Stage") or roomInst:GetAttribute("StageSpawned")
        if tonumber(stage) then return tonumber(stage) end
    end

    -- 2. Check Workspace _GAMEMODE
    local gmFolder = workspace:FindFirstChild("_GAMEMODE")
    if gmFolder and inMode then
        local target = gmFolder:FindFirstChild(inMode) or gmFolder:FindFirstChild("Raid") or gmFolder:FindFirstChild("Time Trial")
        if target then
            local stage = target:GetAttribute("Stage") or target:GetAttribute("Room") or target:GetAttribute("Wave")
            if tonumber(stage) then return tonumber(stage) end
        end
    end

    -- 3. Check UI Gamemode screen ONLY if actively in mode
    if inMode then
        local gmScreen = Library and Library.GetScreen and Library:GetScreen("Gamemode")
        local startLabel = gmScreen and gmScreen:FindFirstChild("Content") and gmScreen.Content:FindFirstChild("Start") and gmScreen.Content.Start:FindFirstChild("Label")
        if startLabel and startLabel.Text and (startLabel.Text:find("Room") or startLabel.Text:find("Stage")) then
            local clean = string.gsub(startLabel.Text, "<[^>]+>", "")
            local num = string.match(clean, "%d+")
            if tonumber(num) then return tonumber(num) end
        end
    end

    return 1
end

local function executeGamemodeQuit()
    currentLockedTargetUID = nil
    currentCoveredTargetUIDs = {}
    if getgenv then
        getgenv()._CurrentLockedUID = nil
        getgenv()._CurrentCoveredUIDs = {}
    end
    pcall(function()
        Library.Remote:Fire("GamemodeSystem", "Quit")
    end)
    task.delay(0.5, function()
        local highest = getHighestUnlockedMap()
        if highest and highest ~= "Lobby" and highest ~= getCurrentMap() then
            pcall(function() Library.Remote:Fire("TeleportSystem", "To", highest) end)
        end
    end)
    pcall(function()
        local gmScreen = Library and Library.GetScreen and Library:GetScreen("Gamemode")
        local leaveBtn = gmScreen and gmScreen:FindFirstChild("Content") and gmScreen.Content:FindFirstChild("Leave")
        if leaveBtn and getconnections then
            for _, conn in ipairs(getconnections(leaveBtn.MouseButton1Click)) do
                conn:Fire()
            end
        end
    end)
end


local function getGamemodeEnemies()
    local list = {}
    local serverEnemies = workspace:FindFirstChild("_ENEMIES") and workspace._ENEMIES:FindFirstChild("Server")
    local clientEnemies = workspace:FindFirstChild("_ENEMIES") and workspace._ENEMIES:FindFirstChild("Client")
    if not serverEnemies then return list end

    local lp = game:GetService("Players").LocalPlayer
    local inMode = lp:GetAttribute("InMode")

    local function checkAndAdd(obj)
        if not obj then return end
        local hp = obj:GetAttribute("HP")
        local dead = obj:GetAttribute("Dead")
        if hp and hp > 0 and dead ~= true then
            local uid = obj.Name
            local cEnemy = clientEnemies and clientEnemies:FindFirstChild(uid)
            local root = nil
            if cEnemy then
                root = cEnemy.PrimaryPart or cEnemy:FindFirstChild("HumanoidRootPart") or cEnemy:FindFirstChildWhichIsA("BasePart")
            end
            if not root then
                if obj:IsA("BasePart") then
                    root = obj
                elseif obj:IsA("Model") then
                    root = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                end
            end
            if root then
                table.insert(list, {
                    UID   = uid,
                    Name  = obj:GetAttribute("Name") or obj.Name,
                    HP    = hp,
                    MaxHP = obj:GetAttribute("MaxHP") or hp,
                    Part  = root,
                    Model = cEnemy or obj
                })
            end
        end
    end

    -- 1. Scan Server.Gamemode (and room subfolders)
    local gmFolder = serverEnemies:FindFirstChild("Gamemode")
    if gmFolder then
        if inMode and gmFolder:FindFirstChild(inMode) then
            for _, child in ipairs(gmFolder[inMode]:GetDescendants()) do
                checkAndAdd(child)
            end
        end
        for _, child in ipairs(gmFolder:GetDescendants()) do
            checkAndAdd(child)
        end
    end

    -- 2. Scan workspace._MAP.Gamemode
    local mapGm = workspace:FindFirstChild("_MAP") and workspace._MAP:FindFirstChild("Gamemode")
    if mapGm then
        for _, child in ipairs(mapGm:GetDescendants()) do
            checkAndAdd(child)
        end
    end

    -- 3. Scan matching subfolders
    for _, f in ipairs(serverEnemies:GetChildren()) do
        local fn = f.Name:lower()
        if fn:find("time") or fn:find("trial") or fn:find("hallway") or (inMode and fn:find(inMode:lower())) then
            for _, child in ipairs(f:GetDescendants()) do
                checkAndAdd(child)
            end
        end
    end

    return list
end

local function handleAutoReturnHome()
    local pg = lp and lp:FindFirstChild("PlayerGui")
    local results = pg and pg:FindFirstChild("Results")
    if results and results.Enabled then
        local content = results:FindFirstChild("Content")
        local buttons = content and content:FindFirstChild("Buttons")
        local returnBtn = buttons and buttons:FindFirstChild("Return")
        if returnBtn then
            returnBtn.Visible = true
            pcall(function()
                if firesignal then
                    firesignal(returnBtn.MouseButton1Click)
                    firesignal(returnBtn.Activated)
                end
                if getconnections then
                    for _, conn in ipairs(getconnections(returnBtn.MouseButton1Click)) do
                        conn:Fire()
                    end
                    for _, conn in ipairs(getconnections(returnBtn.Activated)) do
                        conn:Fire()
                    end
                end
            end)
            pcall(function()
                local GuiService = Library and Library:GetService("GuiService")
                if GuiService then
                    GuiService.SetScreens(true, { "SideGUI", "Utils" }, true)
                end
            end)
            results.Enabled = false
        end
    end
end

local function normalizeTTDiff(d)
    if not d then return "Easy" end
    d = tostring(d)
    if d == "Normal" then return "Medium" end
    return d
end

local function doJoinTimeTrial(diff)
    if not (Library and Library.Remote) then return false end
    diff = normalizeTTDiff(diff)
    local ok = pcall(function()
        Library.Remote:Fire("GamemodeSystem", "Enter", "Time Trial", "The Hallway", diff)
        Library.Remote:Fire("GamemodeSystem", "Enter", "Time Trial", "The Hallway", diff, true)
    end)
    return ok
end

local ttCurrentActiveDiff = nil
local ttLastJoinedWindowId = nil

local function getSelectedTTDiffs()
    local diffs = CFG.TTDifficulties or CFG.TTDifficulty
    if type(diffs) == "string" and diffs ~= "" then return { normalizeTTDiff(diffs) } end
    if type(diffs) == "table" then
        local list = {}
        for _, d in pairs(diffs) do
            if type(d) == "string" and d ~= "" then table.insert(list, normalizeTTDiff(d)) end
        end
        return #list > 0 and list or { "Easy" }
    end
    return { "Easy" }
end

-- Require GamemodeService
local _GamemodeSvc = nil
pcall(function()
    _GamemodeSvc = require(game:GetService("ReplicatedStorage").Framework.Modules.Services.GamemodeService)
end)

-- คืนค่า diff + windowId ถ้า TT เปิดจริง (IsOpen = true + ไม่มี server CD)
local function getTTOpenWindow()
    local gms = _GamemodeSvc
    local nowTick = os.time()
    local pd = Library and Library.PlayerData

    for _, rawDiff in ipairs(getSelectedTTDiffs()) do
        local diff = normalizeTTDiff(rawDiff)
        local isOpen = false
        local win = nil

        if gms and gms.IsOpen then
            local ok, openRes, winRes = pcall(function()
                return gms.IsOpen("Time Trial", "The Hallway", diff)
            end)
            if ok then
                isOpen = (openRes == true)
                win = winRes
            end
        else
            isOpen = true
        end

        if isOpen then
            local onCooldown = false
            if pd and pd.Gamemodes and pd.Gamemodes["Time Trial"] then
                local cd = pd.Gamemodes["Time Trial"].Cooldown
                if cd and nowTick < cd then
                    onCooldown = true
                end
            end

            if not onCooldown then
                local windowId = (win and win.OpensAt and (tostring(win.OpensAt) .. "_" .. diff))
                                 or (tostring(math.floor(nowTick / 60)) .. "_" .. diff)
                return diff, windowId
            end
        end
    end
    return nil, nil
end

local function handleTimeTrialLoop(now)
    if not CFG.AutoTimeTrialDungeon then
        ttCurrentActiveDiff = nil
        ttLastJoinedWindowId = nil
        return false
    end

    -- Shared Instant Return setting for Time Trial and Raid results.
    if CFG.AutoReturnHome ~= false then handleAutoReturnHome() end

    local inTT = isPlayerInTimeTrial()

    if not inTT then
        -- หลุด/ออก มาจาก Time Trial เคลียร์เป้าหมายทันที
        if ttWasInsideLast then
            ttWasInsideLast = false
            currentLockedTargetUID = nil
            currentCoveredTargetUIDs = {}
            if getgenv then
                getgenv()._CurrentLockedUID = nil
                getgenv()._CurrentCoveredUIDs = {}
            end
            local highest = getHighestUnlockedMap()
            if highest and highest ~= "Lobby" and highest ~= getCurrentMap() then
                pcall(function() Library.Remote:Fire("TeleportSystem", "To", highest) end)
            end
        end

        -- ตรวจว่ามี Time Trial ห้องใหม่เปิดอยู่หรือไม่ (winId ไม่ซ้ำรอบที่เพิ่งเข้า)
        local diff, winId = getTTOpenWindow()
        if diff and winId and winId ~= ttLastJoinedWindowId then
            if now - TIMERS.lastTimeTrialJoinAttempt >= 2.0 then
                TIMERS.lastTimeTrialJoinAttempt = now
                ttLastJoinedWindowId = winId
                ttCurrentActiveDiff = diff
                doJoinTimeTrial(diff)
            end
        end
        return false
    end

    -- ผู้เล่นอยู่ใน Time Trial แล้ว
    ttWasInsideLast = true

    -- Exit เมื่อถึง Target Exit Stage (slider)
    if CFG.TTCustomExitStage then
        local currentStage = getCurrentGamemodeStage()
        if currentStage >= tonumber(CFG.TTExitStage or 25) then
            if now - TIMERS.lastGamemodeExitAttempt >= 1.0 then
                TIMERS.lastGamemodeExitAttempt = now
                executeGamemodeQuit()
            end
            return true
        end
    end

    -- ฆ่า monster ด้วย Smart Cluster TP (multi-hit AOE)
    local gmEnemies = getGamemodeEnemies()
    if #gmEnemies > 0 then
        local optPos, primaryUID, coveredUIDs = findOptimalCombatCluster(gmEnemies)
        if optPos and #coveredUIDs > 0 then
            teleportToCombat(optPos, coveredUIDs, primaryUID)
            Library.Remote:Fire("ClickSystem", "Execute", coveredUIDs)
            Library.Remote:Fire("ClickSystem", "CastSkill", coveredUIDs)
        else
            table.sort(gmEnemies, function(a, b) return a.HP < b.HP end)
            local target = gmEnemies[1]
            teleportToTarget(target.Part, target.UID)
            Library.Remote:Fire("ClickSystem", "Execute", { target.UID })
            Library.Remote:Fire("ClickSystem", "CastSkill", { target.UID })
        end
    else
        -- รอ wave ถัดไป — ห้าม hit overworld!
        currentLockedTargetUID = nil
        currentCoveredTargetUIDs = {}
    end
    return true
end


local function handleAutoMarineInvasion(now)
    if not CFG.AutoMarineInvasion then return false end
    local inInv = isPlayerInGamemode("Invasion") or isPlayerInGamemode("Marine Invasion")
    if not inInv then
        local gms = Library and Library.GamemodeService
        if gms and gms.GetWindow then
            local success, win = pcall(function()
                return gms.GetWindow("Invasion", "Marine Invasion", CFG.InvasionDifficulty or "Easy")
            end)
            if success and win and not win.Open then return false end
        end
        if now - TIMERS.lastInvasionJoinAttempt >= 5.0 then
            TIMERS.lastInvasionJoinAttempt = now
            pcall(function()
                Library.Remote:Fire("GamemodeSystem", "Enter", "Invasion", "Marine Invasion", CFG.InvasionDifficulty or "Easy", true)
            end)
        end
        return false
    end

    local gmEnemies = getGamemodeEnemies()
    if #gmEnemies > 0 then
        local optPos, primaryUID, coveredUIDs = findOptimalCombatCluster(gmEnemies)
        if optPos and #coveredUIDs > 0 then
            teleportToCombat(optPos, coveredUIDs, primaryUID)
            Library.Remote:Fire("ClickSystem", "Execute", coveredUIDs)
            Library.Remote:Fire("ClickSystem", "CastSkill", coveredUIDs)
        else
            table.sort(gmEnemies, function(a, b) return a.HP < b.HP end)
            local target = gmEnemies[1]
            teleportToTarget(target.Part, target.UID)
            Library.Remote:Fire("ClickSystem", "Execute", { target.UID })
            Library.Remote:Fire("ClickSystem", "CastSkill", { target.UID })
        end
    end
    return true
end



local function handleAutoRaidLoop(now)
    if not CFG.AutoRaid then return false end

    -- Check and auto click Return on Results screen when not fighting inside raid
    if CFG.AutoReturnHome ~= false then
        handleAutoReturnHome()
    end

    local raidStatus, inMode = getRaidStatus()

    -- Case 1: Room is Created & Waiting to Start (Status == "Opened")
    if raidStatus == "Opened" then
        currentLockedTargetUID = nil -- Strictly DO NOT attack any overworld monster!
        if now - TIMERS.lastRaidStartAttempt >= 1.0 then
            TIMERS.lastRaidStartAttempt = now
            pcall(function()
                Library.Remote:Fire("GamemodeSystem", "Start", "Raid", true)
            end)
        end
        return true -- HANDLED! Room is starting, do not fall through!
    end

    -- Case 2: Room is Actively Running in Battle (Status == "Running")
    if raidStatus == "Running" then
        if CFG.RaidCustomExitRoom then
            local currentRoom = getCurrentGamemodeStage()
            local exitTarget = tonumber(CFG.RaidExitRoom) or 5
            if currentRoom >= exitTarget and currentRoom > 1 then
                if now - TIMERS.lastGamemodeExitAttempt >= 1.0 then
                    TIMERS.lastGamemodeExitAttempt = now
                    executeGamemodeQuit()
                end
                return true
            end
        end

        -- Target monsters inside Raid room directly (Multi-Target Combat Circle)
        local gmEnemies = getGamemodeEnemies()
        if #gmEnemies > 0 then
            local optPos, primaryUID, coveredUIDs = findOptimalCombatCluster(gmEnemies)
            if optPos and #coveredUIDs > 0 then
                teleportToCombat(optPos, coveredUIDs, primaryUID)
                if CFG.AutoClick then
                    Library.Remote:Fire("ClickSystem", "Execute", coveredUIDs)
                end
                if CFG.AutoCastSkill then
                    Library.Remote:Fire("ClickSystem", "CastSkill", coveredUIDs)
                end
            else
                table.sort(gmEnemies, function(a, b) return a.HP < b.HP end)
                local target = gmEnemies[1]
                currentLockedTargetUID = target.UID
                teleportToTarget(target.Part, target.UID)
                if CFG.AutoClick then
                    Library.Remote:Fire("ClickSystem", "Execute", { target.UID })
                end
                if CFG.AutoCastSkill then
                    Library.Remote:Fire("ClickSystem", "CastSkill", { target.UID })
                end
            end
        else
            -- Waiting for next room / wave to spawn inside raid
            -- DO NOT target overworld monsters!
            currentLockedTargetUID = nil
            currentCoveredTargetUIDs = {}
        end
        return true
    end

    -- Case 3: Outside Raid (raidStatus == "None")
    -- If a room was just created, wait for server to teleport us into raid! Do not interrupt with ticket checks!
    if now - TIMERS.lastRaidCreateAttempt < 4.0 then
        currentLockedTargetUID = nil
        return true
    end

    -- เพิ่งออกจาก raid → reset target lock ให้ fresh TP ทำงานได้ทันที
    if lastTeleportedUID ~= nil and raidStatus == "None" and (now - TIMERS.lastRaidCreateAttempt >= 4.0) then
        lastTeleportedUID = nil
    end

    local targetMap = CFG.RaidTargetMap or "DBZ"
    local tickets = getRaidTicketsCount(targetMap)

    -- 3A. Out of tickets!
    if tickets <= 0 then
        -- ไม่ได้เปิด AutoFarmTicketIfNone → ปล่อยให้ฟาร์ม normal world ได้เลย (ไม่ block)
        if not CFG.AutoFarmTicketIfNone then
            currentLockedTargetUID = nil
            lastTeleportedUID = nil  -- force re-TP ใน normal farm
            return false -- ให้ heartbeat ตกลงไปทำ normal farm
        end

        local curMap = getCurrentMap()
        if curMap ~= targetMap then
            currentLockedTargetUID = nil
            if now - lastTeleportAttempt >= 2.5 then
                lastTeleportAttempt = now
                pcall(function()
                    Library.Remote:Fire("TeleportSystem", "To", targetMap)
                end)
            end
            return true -- Yield frame while teleporting into targetMap
        end

        -- Farm mid-tier sub-boss monster ONLY (รอง Secret Boss) for ticket drops in targetMap
        local target = getMidTierRaidTicketMonster(targetMap)
        if target then
            local optPos, primaryUID, coveredUIDs = findOptimalCombatCluster({ target })
            if optPos and #coveredUIDs > 0 then
                teleportToCombat(optPos, coveredUIDs, primaryUID)
                if CFG.AutoClick then
                    Library.Remote:Fire("ClickSystem", "Execute", coveredUIDs)
                end
                if CFG.AutoCastSkill then
                    Library.Remote:Fire("ClickSystem", "CastSkill", coveredUIDs)
                end
            end
        else
            -- Sub-boss is temporarily dead (respawning) - DO NOT TOUCH WEAK MOBS!
            currentLockedTargetUID = nil
            currentCoveredTargetUIDs = {}
        end
        return true
    end

    -- 3B. We have tickets! Create the raid room
    if now - TIMERS.lastRaidStartAttempt >= 3.0 then
        TIMERS.lastRaidStartAttempt = now
        TIMERS.lastRaidCreateAttempt = now
        pcall(function()
            Library.Remote:Fire("GamemodeSystem", "Create", "Raid", targetMap, "Easy", false, true)
        end)
    end
    return true
end

local function handleAutoPortalLoop(now)
    if not CFG.AutoPortal then return false end
    local inPortal, portalFolder = isPlayerInPortal()

    if inPortal then
        local pEnemies = getGamemodeEnemies()
        if #pEnemies == 0 then pEnemies = getMapEnemies("All") end
        if #pEnemies > 0 then
            local optPos, primaryUID, coveredUIDs = findOptimalCombatCluster(pEnemies)
            if optPos and #coveredUIDs > 0 then
                teleportToCombat(optPos, coveredUIDs, primaryUID)
                Library.Remote:Fire("ClickSystem", "Execute", coveredUIDs)
                Library.Remote:Fire("ClickSystem", "CastSkill", coveredUIDs)
            else
                local uid, part = selectTargetEnemy()
                if part and uid then
                    teleportToTarget(part, uid)
                    Library.Remote:Fire("ClickSystem", "Execute", { uid })
                    Library.Remote:Fire("ClickSystem", "CastSkill", { uid })
                end
            end
        end
        return true
    end

    if now - TIMERS.lastPortalTick < 5.0 then return false end
    TIMERS.lastPortalTick = now

    local pd = Library and Library.PlayerData
    local items = pd and pd.Items or {}

    local tierOrder = {"Rank S", "Rank A", "Rank B", "Rank C"}
    if CFG.PortalSelectedTier and CFG.PortalSelectedTier ~= "All" then
        tierOrder = { CFG.PortalSelectedTier }
    end

    for _, tierName in ipairs(tierOrder) do
        local itemName = "Portal" .. tierName:gsub(" ", "")
        if (items[itemName] or 0) > 0 then
            Library.Remote:Fire("GamemodeSystem", "Enter", "Portal", tierName, "Easy", true)
            return true
        end
    end
    return false
end

local function handleAutoRankUp(now)
    if not CFG.AutoRankUp then return end
    if now - TIMERS.lastRankUp < 1.0 then return end
    TIMERS.lastRankUp = now

    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end

    local shouldRebirth = true
    pcall(function()
        local rData = Library.GetData and Library:GetData("RebirthData")
        if rData and rData.Rank and rData.Rank.Types and rData.Rank.Types.Energy then
            local curLvl = (pd.Rebirth and pd.Rebirth.Rank_Energy) or 0
            local nextLvl = rData.Rank.Types.Energy.Levels[curLvl + 1]
            if nextLvl and nextLvl.Price then
                local currentEnergy = pd.Energy or (pd.Items and pd.Items.Energy) or 0
                if currentEnergy < nextLvl.Price then
                    shouldRebirth = false
                end
            elseif curLvl >= (rData.Rank.Types.Energy.MaxLevel or 20) then
                shouldRebirth = false
            end
        end
    end)

    if shouldRebirth then
        pcall(function()
            Library.Remote:Fire("RebirthSystem", "Release", "Rank", "Energy")
        end)
    end
end

local function getEquippedRaceInfo()
    local pd = Library and Library.PlayerData
    if not pd then return "Earthling", 1 end
    local equippedGacha = pd.GachaEquipped and pd.GachaEquipped[1]
    if not equippedGacha and pd.Gacha then
        for id, data in pairs(pd.Gacha) do
            if data.Equipped and id:find("Race") then
                equippedGacha = id
                break
            end
        end
    end

    local orderNum = 1
    if equippedGacha then
        local match = string.match(equippedGacha, "(%d+)$")
        if match then orderNum = tonumber(match) end
    end

    local raceNames = {
        [1] = "Earthling",
        [2] = "Namekian",
        [3] = "Majin",
        [4] = "Saiyan",
        [5] = "Frieza",
        [6] = "Angel"
    }
    local raceRarities = {
        [1] = 1, -- Common
        [2] = 2, -- Rare
        [3] = 3, -- Epic
        [4] = 4, -- Legendary
        [5] = 5, -- Mythical
        [6] = 6  -- Secret
    }
    return raceNames[orderNum] or "Earthling", raceRarities[orderNum] or 1
end

local function shouldStopRace(pd)
    local target = CFG.RaceStopRarity or "Any"
    if target == "Any" then return false end
    local shouldStop, name, rarity = checkGachaStopCondition("Race", target)
    if shouldStop then return true, name, rarity end

    local reqRank = parseTargetRank(target)
    if reqRank > 0 then
        local raceName, raceRarity = getEquippedRaceInfo()
        if raceRarity >= reqRank then
            return true, raceName, ALL_RARITY_NAMES[raceRarity] or "Rare+"
        end
    end

    return false
end

local function handleAutoRaceSpin(now)
    if not CFG.AutoRaceSpin then return end
    if now - TIMERS.lastRaceSpin < 0.5 then return end
    TIMERS.lastRaceSpin = now

    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end

    local shouldStop, name, rarity = shouldStopRace(pd)
    if shouldStop then
        stopSpinToggle("AutoRaceSpin", "Race", name, rarity)
        return
    end

    if CFG.AutoUnlockRace and not (pd.Unlocked and pd.Unlocked["Gacha_Race"]) then
        local playerGold = pd.Gold or (pd.Items and pd.Items.Gold) or 0
        if playerGold >= 10000 then
            Library.Remote:Fire("UnlockSystem", "Validate", "Gacha_Race")
        end
    end

    local items = pd.Items or {}
    local raceCoins = items["RaceCoins"] or 0
    if raceCoins >= 20 then
        Library.Remote:Fire("GachaSystem", "Spin", "Race", "Default", {}, nil)
    end
end

-- ══════════════════════════════════════════════════════════
-- UPGRADE SYSTEMS & BALANCED ENGINE
-- ══════════════════════════════════════════════════════════
local UPGRADE_SYSTEM_DATA = {
    ["Warrior Upgrades"] = {
        Currency = "WarriorCoins",
        Targets = {
            Energy      = { MaxLevel = 20 },
            Damage      = { MaxLevel = 20 },
            Gold        = { MaxLevel = 20 },
            AttackRange = { MaxLevel = 12 }
        }
    },
    ["Offline Upgrades"] = {
        Currency = "OfflineCoins",
        Targets = {
            Energy  = { MaxLevel = 20 },
            Gold    = { MaxLevel = 20 },
            MaxTime = { MaxLevel = 20 }
        }
    },
    ["Time Trial Upgrades"] = {
        Currency = "TrialShards",
        Targets = {
            Energy = { MaxLevel = 20 },
            Damage = { MaxLevel = 20 },
            Gold   = { MaxLevel = 20 },
            AtkSPD = { MaxLevel = 10 }
        }
    },
    ["Portal Upgrades"] = {
        Currency = "PortalCoins",
        Targets = {
            Energy            = { MaxLevel = 10 },
            Damage            = { MaxLevel = 10 },
            MaxEnemy          = { MaxLevel = 5 },
            WarriorDropChance = { MaxLevel = 5 }
        }
    },
    ["Class Tree"] = {
        Currency = "ClassCoins",
        Targets = {
            Start      = { MaxLevel = 1 },
            Energy     = { MaxLevel = 15 },
            Damage     = { MaxLevel = 15 },
            Gold       = { MaxLevel = 15 },
            CritChance = { MaxLevel = 10 },
            CritDMG    = { MaxLevel = 10 },
            WalkSPD    = { MaxLevel = 10 }
        }
    },
    ["Ninja Progression"] = {
        Currency = "NinjaCoins",
        Targets = {
            Energy = { MaxLevel = 100 }
        }
    },
    ["Ant Progression"] = {
        Currency = "AntCoins",
        Targets = {
            Energy = { MaxLevel = 100 }
        }
    }
}

-- Shared upgrade requests: one pending purchase per system.
local UPGRADE_SYSTEM_NAMES = {
    "Warrior Upgrades", "Offline Upgrades", "Time Trial Upgrades",
    "Portal Upgrades", "Class Tree", "Ninja Progression", "Ant Progression"
}

local UpgradeServiceRef = nil
if Library and type(Library.GetService) == "function" then
    local ok, service = pcall(function() return Library:GetService("UpgradeService") end)
    if ok then UpgradeServiceRef = service end
end

-- Try the module separately: an unavailable Library:GetService must not
-- prevent the module fallback or the live UpgradeData overrides.
pcall(function()
    local framework = ReplicatedStorage:FindFirstChild("Framework")
    local modules = framework and framework:FindFirstChild("Modules")
    local services = modules and modules:FindFirstChild("Services")
    local serviceModule = services and services:FindFirstChild("UpgradeService")
    if not UpgradeServiceRef and serviceModule then
        UpgradeServiceRef = require(serviceModule)
    end
end)

pcall(function()
    local framework = ReplicatedStorage:FindFirstChild("Framework")
    local modules = framework and framework:FindFirstChild("Modules")
    local dataDir = modules and modules:FindFirstChild("Data")
    local dataModule = dataDir and dataDir:FindFirstChild("UpgradeData")
    if not dataModule then return end
    local rawData = require(dataModule)
    if type(rawData) ~= "table" then return end
    for systemName, systemData in pairs(rawData) do
        if type(systemData) == "table" and type(systemData.Targets) == "table" then
            local config = UPGRADE_SYSTEM_DATA[systemName] or { Targets = {} }
            config.Currency = systemData.Currency or config.Currency
            for stat, targetData in pairs(systemData.Targets) do
                if type(targetData) == "table" then
                    local fallback = config.Targets[stat] or {}
                    config.Targets[stat] = {
                        MaxLevel = tonumber(targetData.MaxLevel) or fallback.MaxLevel or 999,
                        Currency = targetData.Currency or systemData.Currency or fallback.Currency
                    }
                end
            end
            UPGRADE_SYSTEM_DATA[systemName] = config
        end
    end
end)

local UpgradeRequestState = {}

local function getUpgradeLevel(upgrades, systemName, stat)
    local entry = upgrades[systemName .. "_" .. stat]
    if type(entry) == "table" then entry = entry.Level end
    return tonumber(entry) or 0
end

local function normalizeUpgradeSystems()
    local selected = CFG.SelectedGlobalUpgrades
    if type(selected) ~= "table" then selected = UPGRADE_SYSTEM_NAMES end
    local normalized = {}
    for _, systemName in ipairs(UPGRADE_SYSTEM_NAMES) do
        if table.find(selected, systemName) then
            table.insert(normalized, systemName)
        end
    end
    -- src 1 saved stat names here; src 2 selects named upgrade systems.
    -- Migrate old, non-empty stat selections to the all-systems selection.
    if #normalized == 0 and #selected > 0 then
        for _, stat in ipairs(selected) do
            if stat == "Energy" or stat == "Damage" or stat == "CritChance"
                or stat == "CritDamage" or stat == "CritDMG" then
                for _, systemName in ipairs(UPGRADE_SYSTEM_NAMES) do
                    table.insert(normalized, systemName)
                end
                break
            end
        end
    end
    CFG.SelectedGlobalUpgrades = normalized
    if CFG.BalanceGlobalUpgrades == nil then CFG.BalanceGlobalUpgrades = true end
    return normalized
end

local function buyBalancedUpgrade(systemName, targetList, now, buyMax)
    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return false end
    local upgrades, items = pd.Upgrades, pd.Items
    if type(upgrades) ~= "table" or type(items) ~= "table" then return false end
    local config = UPGRADE_SYSTEM_DATA[systemName]
    if not (config and config.Targets) then return false end
    now = type(now) == "number" and now or os.clock()

    local targets, seen = {}, {}
    if targetList == nil then
        for stat in pairs(config.Targets) do table.insert(targets, stat) end
        table.sort(targets)
    elseif type(targetList) == "table" then
        for _, stat in ipairs(targetList) do
            if config.Targets[stat] and not seen[stat] then
                seen[stat] = true
                table.insert(targets, stat)
            end
        end
    end
    if #targets == 0 then return false end

    local state = UpgradeRequestState[systemName]
    if not state then
        state = { NextIndex = 1 }
        UpgradeRequestState[systemName] = state
    end
    -- Warrior/Offline/TT and the global toggle can request the same system.
    -- Give it one request slot, even when the server updates immediately.
    if state.LastSentAt and now - state.LastSentAt < 0.35 then return false end
    if state.PendingStat then
        local current = getUpgradeLevel(upgrades, systemName, state.PendingStat)
        if current == state.PendingLevel and now - state.PendingAt < 1.5 then
            return false
        end
        -- A changed level confirms completion. An unconfirmed request may be
        -- retried after the timeout; the tie cursor lets other equal stats try.
        state.PendingStat = nil
    end

    local candidateStat, candidateIndex = nil, nil
    local minLevel = math.huge
    local start = ((state.NextIndex or 1) - 1) % #targets + 1
    for offset = 0, #targets - 1 do
        local index = (start + offset - 1) % #targets + 1
        local stat = targets[index]
        local target = config.Targets[stat]
        local level = getUpgradeLevel(upgrades, systemName, stat)
        local maxLevel = tonumber(target.MaxLevel) or 999
        if level < maxLevel then
            local unlocked = true
            if UpgradeServiceRef and type(UpgradeServiceRef.IsUnlocked) == "function" then
                local ok, value = pcall(function()
                    return UpgradeServiceRef.IsUnlocked(pd, systemName, stat)
                end)
                if ok then unlocked = value end
            end
            if unlocked then
                local price = nil
                if UpgradeServiceRef and type(UpgradeServiceRef.CalculatePrice) == "function" then
                    local ok, value = pcall(function()
                        return UpgradeServiceRef.CalculatePrice(systemName, stat, level)
                    end)
                    if ok then price = tonumber(value) end
                end
                local currency = target.Currency or config.Currency
                local balance = tonumber(items[currency]) or 0
                if (price == nil or balance >= price) and level < minLevel then
                    minLevel = level
                    candidateStat, candidateIndex = stat, index
                end
            end
        end
    end
    if not candidateStat then return false end

    state.PendingStat = candidateStat
    state.PendingLevel = minLevel
    state.PendingAt = now
    state.LastSentAt = now
    state.NextIndex = candidateIndex % #targets + 1
    local ok = pcall(function()
        if buyMax == true then
            -- Disabling Balance permits a max purchase for the chosen stat.
            Library.Remote:Fire("UpgradeSystem", "Buy", systemName, candidateStat, true)
        else
            Library.Remote:Fire("UpgradeSystem", "Buy", systemName, candidateStat)
        end
    end)
    if not ok then state.PendingStat = nil end
    return ok
end

local function handleAutoGlobalUpgrades(now)
    if not CFG.AutoUpgrade or now - TIMERS.lastUpgrade < 0.4 then return end
    TIMERS.lastUpgrade = now
    for _, systemName in ipairs(normalizeUpgradeSystems()) do
        buyBalancedUpgrade(systemName, nil, now, CFG.BalanceGlobalUpgrades == false)
    end
end

-- Passive Ranks & Stop Threshold Engine
local GACHA_TARGET_MAPS = {
    Titan = {
        ["Any"] = 0, ["Armored Titan (Rare+)"] = 2, ["Beast Titan (Epic+)"] = 3,
        ["Colossal Titan (Legendary+)"] = 4, ["Attack Titan (Mythical+)"] = 5, ["Founding Titan (Secret)"] = 6,
    },
    Eye = {
        ["Any"] = 0, ["Sharingan (Rare+)"] = 2, ["Mangekyou Sharingan (Epic+)"] = 3,
        ["Eternal Mangekyou Sharingan (Legendary+)"] = 4, ["Rinnegan (Mythical+)"] = 5, ["Rinne Sharingan (Secret)"] = 6,
    },
    Sin = {
        ["Any"] = 0, ["Greed (Rare+)"] = 2, ["Sloth (Epic+)"] = 3,
        ["Gluttony (Legendary+)"] = 4, ["Pride (Mythical+)"] = 5, ["Wrath (Secret)"] = 6,
    },
    Hunter = {
        ["Any"] = 0, ["D-Rank (Rare+)"] = 2, ["C-Rank (Epic+)"] = 3,
        ["B-Rank (Legendary+)"] = 4, ["A-Rank (Mythical+)"] = 5, ["S-Rank (Secret)"] = 6,
    },
    Shadow = {
        ["Any"] = 0, ["Elite (Rare+)"] = 2, ["Knight (Epic+)"] = 3,
        ["Commander (Legendary+)"] = 4, ["Marshal (Mythical+)"] = 5, ["Monarch (Secret)"] = 6,
    },
    Haki = {
        ["Any"] = 0, ["Armament (Rare+)"] = 2, ["Future Sight (Epic+)"] = 3,
        ["Emission (Legendary+)"] = 4, ["Conqueror (Mythical+)"] = 5, ["Supreme King (Secret)"] = 6,
    },
    Amulet = {
        ["Any"] = 0, ["Tier II (Rare+)"] = 2, ["Tier III (Epic+)"] = 3,
        ["Tier IV (Legendary+)"] = 4, ["Tier V (Mythical+)"] = 5, ["Tier VI (Secret)"] = 6,
    },
    WeaponPassive = {
        ["Any"] = 0, ["Fine Grade (Rare+)"] = 2, ["Skillful Grade (Epic+)"] = 3,
        ["Great Grade (Legendary+)"] = 4, ["Supreme Grade (Mythical+)"] = 5, ["Black Blade (Secret)"] = 6,
    },
    HeroPassive = {
        ["Any"] = 0, ["Bone Breaker (Rare+)"] = 2, ["Wall Breaker (Epic+)"] = 3,
        ["Limit Breaker (Legendary+)"] = 4, ["Soul Breaker (Mythical+)"] = 5, ["World Breaker (Secret)"] = 6,
    }
}
local _SPIN_TIMERS = {}

local OFFLINE_UPGRADE_MAP = {
    ["Dreamer (Offline Energy)"]       = "Energy",
    ["Hoarder (Offline Gold)"]         = "Gold",
    ["Hibernation (Offline Max Time)"] = "MaxTime"
}
local OFFLINE_UPGRADE_NAMES = {
    "Dreamer (Offline Energy)",
    "Hoarder (Offline Gold)",
    "Hibernation (Offline Max Time)"
}

local WARRIOR_UPGRADE_NAMES = {"Energy", "Damage", "Gold", "AttackRange"}



local function handleAutoWarriorUpgrade(now)
    if not CFG.AutoUpgradeWarrior or now - TIMERS.lastWarriorUp < 0.4 then return end
    TIMERS.lastWarriorUp = now
    local selected = CFG.WarriorSelectedUpgradeNames or WARRIOR_UPGRADE_NAMES
    local targets = {}
    for _, stat in ipairs(WARRIOR_UPGRADE_NAMES) do
        if isItemInList(selected, stat) then table.insert(targets, stat) end
    end
    buyBalancedUpgrade("Warrior Upgrades", targets, now, CFG.BalanceWarriorUpgrades == false)
end





local function shouldStopTitan(pd)
    local target = CFG.TitanStopRarity or "Any"
    return checkGachaStopCondition("Titan", target, nil, GACHA_TARGET_MAPS.Titan)
end

local function shouldStopWeaponT1(pd)
    local target = CFG.WeaponT1StopRarity or "Any"
    local reqRank = parseTargetRank(target)
    if reqRank <= 0 then return false end
    if not (pd and pd.Weapons) then return false end
    for uid, wep in pairs(pd.Weapons) do
        local wepId = (type(wep) == "table" and (wep.Id or uid)) or uid
        local rName, rOrder = getItemRarity(wepId)
        if rOrder >= reqRank then
            return true, wepId, rName, rOrder
        end
    end
    return false
end

local function shouldStopWeaponPassive(pd)
    local target = CFG.TargetWeaponPassive or "Any"
    return checkGachaStopCondition("Weapon Passive", target, nil, GACHA_TARGET_MAPS.WeaponPassive)
end

local function shouldStopHeroPassive(pd)
    local target = CFG.TargetHeroPassive or "Any"
    return checkGachaStopCondition("Hero Passive", target, nil, GACHA_TARGET_MAPS.HeroPassive)
end

local function handleAutoTitanSpin(now)
    if not CFG.AutoTitanSpin then return end
    if now - (_SPIN_TIMERS.Titan or 0) < 0.6 then return end
    _SPIN_TIMERS.Titan = now

    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end

    -- Auto unlock Titan via remote before spinning if affordable
    if CFG.AutoUnlockTitan and not (pd.Unlocked and pd.Unlocked["Gacha_Titan"]) then
        local playerGold = pd.Gold or (pd.Items and pd.Items.Gold) or 0
        if playerGold >= 4860000 then
            Library.Remote:Fire("UnlockSystem", "Validate", "Gacha_Titan")
        end
    end

    -- Stop condition check (Stop at or above target tier)
    local shouldStop, name, r = shouldStopTitan(pd)
    if shouldStop then
        stopSpinToggle("AutoTitanSpin", "Titan Banner", name, r)
        return
    end

    pcall(function()
        Library.Remote:Fire("GachaSystem", "Spin", "Titan", "Default", {}, nil)
    end)
end

local function handleAutoWeaponSpins(now)
    if not CFG.AutoWeaponSummon and not CFG.AutoWeaponPassive then return end
    if now - TIMERS.lastWeaponSpin < 0.8 then return end
    TIMERS.lastWeaponSpin = now

    local pd = Library and Library.PlayerData
    local items = pd and pd.Items or {}

    -- Auto Weapon T1 Summon
    if CFG.AutoWeaponSummon and (items["WeaponCoinsT1"] or 0) > 0 then
        if not (pd and pd.Unlocked and pd.Unlocked["Gacha_Weapon_T1"]) and CFG.AutoUnlockWeapon then
            Library.Remote:Fire("UnlockSystem", "Validate", "Gacha_Weapon_T1")
        end

        -- Stop condition check (Stop at or above target rarity)
        local shouldStop, name, r = shouldStopWeaponT1(pd)
        if shouldStop then
            stopSpinToggle("AutoWeaponSummon", "Weapon T1", name, r)
        else
            Library.Remote:Fire("GachaSystem", "Spin", "Weapon", "T1", {}, nil)
        end
    end

    -- Auto Weapon Passive Spin
    if CFG.AutoWeaponPassive and (items["WeaponPassiveCoins"] or 0) > 0 then
        -- Auto unlock Weapon Passive via remote before spinning if not yet unlocked
        if not (pd and pd.Unlocked and pd.Unlocked["Gacha_Weapon Passive"]) then
            Library.Remote:Fire("UnlockSystem", "Validate", "Gacha_Weapon Passive")
        end

        -- Check target tier stop condition (Stop at or above)
        local shouldStop, name, r = shouldStopWeaponPassive(pd)
        if shouldStop then
            stopSpinToggle("AutoWeaponPassive", "Weapon Passive", name, r)
            return
        end

        Library.Remote:Fire("GachaSystem", "Spin", "WeaponPassive", "OnePiece", {}, nil)
    end
end

local function handleAutoHeroPassive(now)
    if not CFG.AutoHeroPassive then return end
    if now - TIMERS.lastHeroPassive < 0.8 then return end
    TIMERS.lastHeroPassive = now

    local pd = Library and Library.PlayerData
    local items = pd and pd.Items or {}

    -- Auto unlock Hero Passive via remote before spinning if not yet unlocked
    if not (pd and pd.Unlocked and pd.Unlocked["Gacha_Hero Passive"]) then
        Library.Remote:Fire("UnlockSystem", "Validate", "Gacha_Hero Passive")
    end

    if (items["HeroPassiveCoins"] or 0) > 0 then
        -- Check target tier stop condition (Stop at or above)
        local shouldStop, name, r = shouldStopHeroPassive(pd)
        if shouldStop then
            stopSpinToggle("AutoHeroPassive", "Hero Passive", name, r)
            return
        end

        Library.Remote:Fire("GachaSystem", "Spin", "Hero Passive", "AOT", {}, nil)
    end
end

local function handleAutoEyeSpin(now)
    if not CFG.AutoEyeSpin then return end
    if now - (_SPIN_TIMERS.Eye or 0) < 0.6 then return end
    _SPIN_TIMERS.Eye = now

    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end
    local items = pd.Items or {}

    if CFG.AutoUnlockEye and not (pd.Unlocked and pd.Unlocked["Gacha_Eye Technique"]) then
        local playerGold = pd.Gold or items.Gold or 0
        if playerGold >= 2361960000 then
            Library.Remote:Fire("UnlockSystem", "Validate", "Gacha_Eye Technique")
        end
    end

    local shouldStop, name, r = checkGachaStopCondition("Eye Technique", CFG.EyeStopRarity or "Any", nil, GACHA_TARGET_MAPS.Eye)
    if shouldStop then
        stopSpinToggle("AutoEyeSpin", "Eye Technique", name, r)
        return
    end

    if (items["EyeCoins"] or items["EyeTechniqueCoins"] or 0) > 0 or true then
        Library.Remote:Fire("GachaSystem", "Spin", "Eye Technique", "Naruto", {}, nil)
    end
end

local function handleAutoSinSpin(now)
    if not CFG.AutoSinSpin then return end
    if now - (_SPIN_TIMERS.Sin or 0) < 0.6 then return end
    _SPIN_TIMERS.Sin = now

    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end
    local items = pd.Items or {}

    if CFG.AutoUnlockSin and not (pd.Unlocked and pd.Unlocked["Gacha_Sin"]) then
        local playerGold = pd.Gold or items.Gold or 0
        if playerGold >= 5165606520000 then
            Library.Remote:Fire("UnlockSystem", "Validate", "Gacha_Sin")
        end
    end

    local shouldStop, name, r = checkGachaStopCondition("Sin", CFG.SinStopRarity or "Any", nil, GACHA_TARGET_MAPS.Sin)
    if shouldStop then
        stopSpinToggle("AutoSinSpin", "Sin", name, r)
        return
    end

    Library.Remote:Fire("GachaSystem", "Spin", "Sin", "Default", {}, nil)
end

local function handleAutoHunterRankSpin(now)
    if not CFG.AutoHunterRankSpin then return end
    if now - (_SPIN_TIMERS.Hunter or 0) < 0.6 then return end
    _SPIN_TIMERS.Hunter = now

    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end
    local items = pd.Items or {}

    if CFG.AutoUnlockHunter and not (pd.Unlocked and pd.Unlocked["Gacha_Hunter Rank"]) then
        local playerGold = pd.Gold or items.Gold or 0
        if playerGold >= 135566177510880000 then
            Library.Remote:Fire("UnlockSystem", "Validate", "Gacha_Hunter Rank")
        end
    end

    local shouldStop, name, r = checkGachaStopCondition("Hunter Rank", CFG.HunterRankStopRarity or "Any", nil, GACHA_TARGET_MAPS.Hunter)
    if shouldStop then
        stopSpinToggle("AutoHunterRankSpin", "Hunter Rank", name, r)
        return
    end

    Library.Remote:Fire("GachaSystem", "Spin", "Hunter Rank", "SoloLeveling", {}, nil)
end

local function handleAutoShadowPassiveSpin(now)
    if not CFG.AutoShadowPassiveSpin then return end
    if now - (_SPIN_TIMERS.Shadow or 0) < 0.6 then return end
    _SPIN_TIMERS.Shadow = now

    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end
    local items = pd.Items or {}

    if CFG.AutoUnlockShadow and not (pd.Unlocked and pd.Unlocked["Gacha_Shadow Passive"]) then
        local playerGold = pd.Gold or items.Gold or 0
        if playerGold >= 542264710043520000 then
            Library.Remote:Fire("UnlockSystem", "Validate", "Gacha_Shadow Passive")
        end
    end

    local shouldStop, name, r = checkGachaStopCondition("Shadow Passive", CFG.ShadowPassiveStopRarity or "Any", nil, GACHA_TARGET_MAPS.Shadow)
    if shouldStop then
        stopSpinToggle("AutoShadowPassiveSpin", "Shadow Passive", name, r)
        return
    end

    Library.Remote:Fire("GachaSystem", "Spin", "Shadow Passive", "SoloLeveling", {}, nil)
end

local function handleAutoHakiSpin(now)
    if not CFG.AutoHakiSpin then return end
    if now - (_SPIN_TIMERS.Haki or 0) < 0.6 then return end
    _SPIN_TIMERS.Haki = now

    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end
    local items = pd.Items or {}

    if CFG.AutoUnlockHaki and not (pd.Unlocked and pd.Unlocked["Gacha_Haki"]) then
        local playerGold = pd.Gold or items.Gold or 0
        if playerGold >= 65885162270288000000 then
            Library.Remote:Fire("UnlockSystem", "Validate", "Gacha_Haki")
        end
    end

    local shouldStop, name, r = checkGachaStopCondition("Haki", CFG.HakiStopRarity or "Any", nil, GACHA_TARGET_MAPS.Haki)
    if shouldStop then
        stopSpinToggle("AutoHakiSpin", "Haki", name, r)
        return
    end

    Library.Remote:Fire("GachaSystem", "Spin", "Haki", "OnePiece", {}, nil)
end

local function handleAutoAmuletSpin(now)
    if not CFG.AutoAmuletSpin then return end
    if now - (_SPIN_TIMERS.Amulet or 0) < 0.6 then return end
    _SPIN_TIMERS.Amulet = now

    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end
    local items = pd.Items or {}

    if CFG.AutoUnlockAmulet and not (pd.Unlocked and pd.Unlocked["Gacha_Amulet Building"]) then
        local playerGold = pd.Gold or items.Gold or 0
        if playerGold >= 20662426080000 then
            Library.Remote:Fire("UnlockSystem", "Validate", "Gacha_Amulet Building")
        end
    end

    local cat = CFG.AmuletCategory or "Energy"
    local shouldStop, name, r = checkGachaStopCondition("Amulet Building", CFG.AmuletStopRarity or "Any", cat, GACHA_TARGET_MAPS.Amulet)
    if shouldStop then
        stopSpinToggle("AutoAmuletSpin", "Amulet (" .. cat .. ")", name, r)
        return
    end

    Library.Remote:Fire("GachaSystem", "Spin", "Amulet Building", cat, {}, nil)
end


local function handleAutoOfflineUpgrades(now)
    if not CFG.AutoOfflineUpgrades or now - TIMERS.lastOfflineUp < 0.45 then return end
    TIMERS.lastOfflineUp = now
    local selected = CFG.OfflineSelectedUpgradeNames or OFFLINE_UPGRADE_NAMES
    local targets = {}
    for _, name in ipairs(OFFLINE_UPGRADE_NAMES) do
        local key = OFFLINE_UPGRADE_MAP[name]
        if isItemInList(selected, name) or isItemInList(selected, key) then
            table.insert(targets, key)
        end
    end
    buyBalancedUpgrade("Offline Upgrades", targets, now, CFG.BalanceOfflineUpgrades == false)
end


local function handleAutoPortalUpgrades(now)
    if not CFG.AutoUpgradePortal then return end
    if now - TIMERS.lastPortalUp < 0.45 then return end
    TIMERS.lastPortalUp = now

    local targets = CFG.PortalSelectedUpgradeNames or {"Energy", "Damage", "MaxEnemy", "WarriorDropChance"}
    if #targets > 0 then
        buyBalancedUpgrade("Portal Upgrades", targets, now, CFG.BalancePortalUpgrades == false)
    end
end


local function handleAutoClassTreeUpgrades(now)
    if not CFG.AutoUpgradeClassTree then return end
    if now - TIMERS.lastClassTreeUp < 0.45 then return end
    TIMERS.lastClassTreeUp = now

    local targets = CFG.ClassTreeSelectedUpgradeNames or {"Start", "Energy", "Damage", "Gold", "CritChance", "CritDMG", "WalkSPD"}
    if #targets > 0 then
        buyBalancedUpgrade("Class Tree", targets, now, CFG.BalanceClassTreeUpgrades == false)
    end
end


local function handleAutoNinjaUpgrades(now)
    if not CFG.AutoUpgradeNinja then return end
    if now - TIMERS.lastNinjaUp < 0.45 then return end
    TIMERS.lastNinjaUp = now

    buyBalancedUpgrade("Ninja Progression", {"Energy"}, now)
end


local function handleAutoAntUpgrades(now)
    if not CFG.AutoUpgradeAnt then return end
    if now - TIMERS.lastAntUp < 0.45 then return end
    TIMERS.lastAntUp = now

    buyBalancedUpgrade("Ant Progression", {"Energy"}, now)
end

local function doEquipBestTitle()
    local pd = Library and Library.PlayerData
    if not (pd and pd.Titles) then return end
    local bestId = nil
    local bestOrder = -1
    for titleId, val in pairs(pd.Titles) do
        if val == true or type(val) == "table" then
            local order = tonumber(tostring(titleId):match("%d+")) or 1
            if order > bestOrder then
                bestOrder = order
                bestId = titleId
            end
        end
    end
    if bestId then
        Library.Remote:Fire("TitleSystem", "Equip", "Boost", bestId)
        Library.Remote:Fire("TitleSystem", "Equip", "Visual", bestId)
    end
end

-- isItemInList defined earlier

local lastInventoryCounts = {}

-- Checks if a category's item count or contents changed before re-equipping
local function hasCategoryChanged(cat, force)
    if force then return true end
    local pd = Library and Library.PlayerData
    if not pd then return false end
    local list = pd[cat .. "s"] or pd[cat]
    if not list or type(list) ~= "table" then return false end

    local count = 0
    for _ in pairs(list) do
        count = count + 1
    end

    if lastInventoryCounts[cat] ~= count then
        lastInventoryCounts[cat] = count
        return true -- New item acquired or inventory changed!
    end
    return false -- Same inventory, do not spam remote!
end

local hasEquippedAccessoryOnce = false

local function doEquipBestCategories(force)
    if not (Library and Library.Remote) then return end

    if CFG.AutoEquipBest and (force or hasCategoryChanged("GlobalBoost", force)) then
        pcall(function()
            Library.Remote:Fire("EquipBestSystem", "Apply", CFG.AutoEquipBoost or "Energy")
        end)
    end

    local cats = { "Weapon", "Warrior", "Avatar", "Accessory", "Mount", "Jewel", "Wing", "DevilFruit", "Crewmate", "Amulet" }
    for _, cat in ipairs(cats) do
        if isItemInList(CFG.EquipBestCategories, cat) then
            if cat == "Accessory" then
                -- Accessory only equips once unless a new accessory is obtained in inventory
                if not hasEquippedAccessoryOnce or hasCategoryChanged("Accessory", force) then
                    hasEquippedAccessoryOnce = true
                    pcall(function()
                        Library.Remote:Fire("InventorySystem", "EquipBest", "Accessory")
                    end)
                end
            else
                if hasCategoryChanged(cat, force) then
                    pcall(function()
                        Library.Remote:Fire("InventorySystem", "EquipBest", cat)
                    end)
                end
            end
        end
    end

    if CFG.EquipBestTitle and (force or hasCategoryChanged("Title", force)) then
        pcall(doEquipBestTitle)
    end
end

local TT_POTION_MAP = {
    ["Energy Potion I (200)"] = "EnergyPotion1",
    ["Damage Potion I (200)"] = "DamagePotion1",
    ["Gold Potion I (200)"]   = "GoldPotion1",
    ["Luck Potion I (300)"]   = "LuckPotion1",
    ["Drop Potion I (400)"]   = "DropPotion1",
    ["Energy Potion II (500)"] = "EnergyPotion2",
    ["Damage Potion II (500)"] = "DamagePotion2",
    ["Gold Potion II (500)"]   = "GoldPotion2",
    ["Luck Potion II (600)"]   = "LuckPotion2",
    ["Drop Potion II (1000)"]  = "DropPotion2"
}

local TT_UPGRADE_MAP = {
    ["Breaker (Damage +5%)"]    = "Damage",
    ["Relentless (Energy +5%)"]  = "Energy",
    ["Scavenger (Gold +5%)"]     = "Gold",
    ["Overdrive (AtkSPD +2.5%)"] = "AtkSPD"
}

local PIRATE_JUICE_MAP = {
    ["Energy Juice I (1000)"] = "EnergyJuice1",
    ["Damage Juice I (1000)"] = "DamageJuice1",
    ["Gold Juice I (1000)"]   = "GoldJuice1",
    ["Drop Juice I (1000)"]   = "DropJuice1",
    ["Luck Juice I (1000)"]   = "LuckJuice1"
}

local function doTimeTrialShopBuy()
    if not (Library and Library.Remote) then return end
    local selected = CFG.TTSelectedPotionNames
    if not selected or type(selected) ~= "table" then return end
    local amt = CFG.TTShopBuyAmount or 1
    for name, id in pairs(TT_POTION_MAP) do
        if isItemInList(selected, name) then
            pcall(function()
                Library.Remote:Fire("StockShopSystem", "Buy", "Time Trial", id, amt)
            end)
        end
    end
end

local function doPirateShopBuy()
    if not (Library and Library.Remote) then return end
    local selected = CFG.PirateSelectedJuiceNames
    if not selected or type(selected) ~= "table" then return end
    local amt = CFG.PirateShopBuyAmount or 1
    for name, id in pairs(PIRATE_JUICE_MAP) do
        if isItemInList(selected, name) then
            pcall(function()
                Library.Remote:Fire("StockShopSystem", "Buy", "Pirate", id, amt)
            end)
        end
    end
end

local function doTimeTrialUpgrade()
    if not (Library and Library.Remote) then return end
    local selected = CFG.TTSelectedUpgradeNames or {}
    local targets = {}
    for _, name in ipairs({"Relentless (Energy +5%)", "Breaker (Damage +5%)", "Scavenger (Gold +5%)", "Overdrive (AtkSPD +2.5%)"}) do
        local key = TT_UPGRADE_MAP[name]
        if isItemInList(selected, name) or isItemInList(selected, key) then
            table.insert(targets, key)
        end
    end
    buyBalancedUpgrade("Time Trial Upgrades", targets, nil, CFG.BalanceTTUpgrades == false)
end



local function doMergeAll()
    pcall(function()
        if not (Library and Library.Remote) then return end
        for _, category in ipairs({"Weapon", "Wing", "Pet", "Warrior", "Avatar"}) do
            Library.Remote:Fire("MergeSystem", "MakeAll", category)
        end
    end)
end

local function doAutoCraft()
    pcall(function()
        if not (Library and Library.Remote) then return end
        for cat, list in pairs(CRAFT_ITEMS) do
            if CFG.CraftSelection and CFG.CraftSelection[cat] then
                for tier = 1, math.min(#list, CFG.CraftMaxTier or 6) do
                    Library.Remote:Fire("ExchangeSystem", "Make", "Crafting", cat, list[tier], 1)
                end
            end
        end
        Library.Remote:Fire("JewelSystem", "ClaimAll")
    end)
end

local function doClaimLikeRewards()
    pcall(function()
        Library.Remote:Fire("LikeRewardSystem", "ClaimAll", true)
        for i = 1, 20 do
            Library.Remote:Fire("LikeRewardSystem", "Claim", i, true)
        end
    end)
end

local function doClaimAll()
    pcall(function()
        doClaimLikeRewards()
        Library.Remote:Fire("AchievementSystem", "ClaimAll", true)
        Library.Remote:Fire("DailyRewardSystem", "ClaimAll", true)
        Library.Remote:Fire("IndexSystem", "ClaimAll", true)
        for _, chest in ipairs({"VIPChest","PremiumChest","GroupChest"}) do
            Library.Remote:Fire("ChestSystem", "Claim", chest, true)
        end
        for _, bp in ipairs({"Release","BloodRed"}) do
            Library.Remote:Fire("BattlepassSystem", "ClaimAll", bp, true)
        end
    end)
end

local function doRedeemAllCodes()
    if not (Library and Library.Remote) then return end
    for _, code in ipairs(PROMO_CODES) do
        local ok, reason = pcall(function()
            Library.Remote:Fire("CodeSystem", "Redeem", code)
        end)
        if not ok then warn("[SpectreWare Codes] " .. tostring(reason)) end
        task.wait(0.15)
    end
end

local function doRejoinCurrent()
    local ok, reason = pcall(function()
        if tostring(game.JobId or "") ~= "" then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
        else
            TeleportService:Teleport(game.PlaceId, lp)
        end
    end)
    if not ok then warn("[SpectreWare Rejoin] " .. tostring(reason)) end
end

local function doServerHop()
    local cursor = nil
    for _ = 1, 3 do
        local url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId)
            .. "/servers/Public?sortOrder=Asc&limit=100"
            .. (cursor and ("&cursor=" .. HttpService:UrlEncode(cursor)) or "")
        local ok, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if not ok or type(response) ~= "table" then break end
        for _, server in ipairs(response.data or {}) do
            if server.id and server.id ~= game.JobId
                and (tonumber(server.playing) or math.huge) < (tonumber(server.maxPlayers) or 0) then
                local moved, reason = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, lp)
                end)
                if not moved then warn("[SpectreWare Server Hop] " .. tostring(reason)) end
                return
            end
        end
        cursor = response.nextPageCursor
        if not cursor then break end
    end
    warn("[SpectreWare Server Hop] No different public server was found.")
end

local function doAutoSell()
    if not CFG.AutoSell then return end
    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end
    local sellRarities = CFG.SellSelectedRarities or {}
    local categories = {
        { Key = "Pet",       Plural = "Pets",        List = pd.Pets },
        { Key = "Weapon",    Plural = "Weapons",     List = pd.Weapons },
        { Key = "Wing",      Plural = "Wings",       List = pd.Wings },
        { Key = "Avatar",    Plural = "Avatars",     List = pd.Avatars },
        { Key = "Accessory", Plural = "Accessories", List = pd.Accessories },
        { Key = "Warrior",   Plural = "Warriors",    List = pd.Warriors },
        { Key = "Mount",     Plural = "Mounts",      List = pd.Mounts },
        { Key = "Jewel",     Plural = "Jewels",      List = pd.Jewels }
    }
    for _, cat in ipairs(categories) do
        if cat.List and (CFG.AutoSell or isItemInList(CFG.DeleteTargetCategories, cat.Plural)) then
            local toUnlock = {}
            local toSell = {}
            for uid, v in pairs(cat.List) do
                if not v.Equipped then
                    local rOrder = getRarityOrder(v.Id or uid)
                    local rName = ALL_RARITY_NAMES[rOrder] or "Common"
                    if isItemInList(sellRarities, rName) then
                        -- High rarity items are auto-locked by the game; unlock first!
                        if v.Locked then
                            table.insert(toUnlock, uid)
                        end
                        table.insert(toSell, uid)
                    end
                end
            end

            -- 1. Unlock locked items first
            if #toUnlock > 0 then
                pcall(function()
                    Library.Remote:Fire("InventorySystem", "Lock", cat.Key, Library:Encode(toUnlock))
                end)
            end

            -- 2. Execute sell and delete
            if #toSell > 0 then
                task.spawn(function()
                    if #toUnlock > 0 then task.wait(0.15) end
                    pcall(function()
                        Library.Remote:Fire("InventorySystem", "Sell", cat.Key, Library:Encode(toSell))
                    end)
                    pcall(function()
                        Library.Remote:Fire("InventorySystem", "Delete", cat.Key, Library:Encode(toSell))
                    end)
                end)
            end
        end
    end
end

local function doAutoDelete()
    local pd = Library and Library.PlayerData
    if not (pd and Library.Remote) then return end

    local categories = {
        { Key = "Pet",       Plural = "Pets",        Data = pd.Pets,        TKey = "AutoDeletePets",        RMap = RarityToggles.Pet },
        { Key = "Weapon",    Plural = "Weapons",     Data = pd.Weapons,     TKey = "AutoDeleteWeapons",     RMap = RarityToggles.Weapon },
        { Key = "Wing",      Plural = "Wings",       Data = pd.Wings,       TKey = "AutoDeleteWings",       RMap = RarityToggles.Wing },
        { Key = "Avatar",    Plural = "Avatars",     Data = pd.Avatars,     TKey = "AutoDeleteAvatars",     RMap = RarityToggles.Avatar },
        { Key = "Accessory", Plural = "Accessories", Data = pd.Accessories, TKey = "AutoDeleteAccessories", RMap = RarityToggles.Accessory },
        { Key = "Warrior",   Plural = "Warriors",    Data = pd.Warriors,    TKey = "AutoDeleteWarriors",    RMap = RarityToggles.Warrior },
        { Key = "Mount",     Plural = "Mounts",      Data = pd.Mounts,      TKey = "AutoDeleteMounts",      RMap = RarityToggles.Mount },
        { Key = "Jewel",     Plural = "Jewels",      Data = pd.Jewels,      TKey = "AutoDeleteJewels",      RMap = RarityToggles.Jewel }
    }

    for _, c in ipairs(categories) do
        -- Strictly check if this category's toggle is enabled
        if c.Data and (CFG[c.TKey] == true) then
            local toUnlock = {}
            local toDelete = {}
            for uid, v in pairs(c.Data) do
                if not v.Equipped then
                    local rOrder = getRarityOrder(v.Id or uid)
                    local rName = ALL_RARITY_NAMES[rOrder] or "Common"
                    -- Only delete if the user specifically checked this rarity in the category's multi-dropdown
                    local shouldDelete = (c.RMap and c.RMap[rName] == true)
                    if shouldDelete then
                        if v.Locked then
                            table.insert(toUnlock, uid)
                        end
                        table.insert(toDelete, uid)
                    end
                end
            end

            -- 1. Unlock locked items first
            if #toUnlock > 0 then
                pcall(function()
                    Library.Remote:Fire("InventorySystem", "Lock", c.Key, Library:Encode(toUnlock))
                end)
            end

            -- 2. Execute deletion
            if #toDelete > 0 then
                task.spawn(function()
                    if #toUnlock > 0 then task.wait(0.15) end
                    pcall(function()
                        Library.Remote:Fire("InventorySystem", "Delete", c.Key, Library:Encode(toDelete))
                    end)
                end)
            end
        end
    end
end

-- ══════════════════════════════════════════════════════════
-- MAIN HEARTBEAT LOOP (STRICT PRIORITY HIERARCHY)
-- ══════════════════════════════════════════════════════════
_G.AnimeBreaker_HeartbeatConnection = RunService.Heartbeat:Connect(function()
    local now = os.clock()

    -- 0. Instant Return on Results Screen (Skip Game Result countdown)
    if CFG.AutoReturnHome ~= false then
        handleAutoReturnHome()
    end

    -- 1. Player Movement & Hacks (Dash Hack & Infinite Health)
    local hum = getHum()
    local root = getRoot()
    if hum and root then
        hum.UseJumpPower = true
        hum.JumpPower = CFG.JumpPower or 100
        if CFG.DashHack then
            local lv = root:FindFirstChildOfClass("LinearVelocity") or root:FindFirstChild("DashVelocity")
            if lv then
                local dir = (hum.MoveDirection.Magnitude > 0) and hum.MoveDirection or root.CFrame.LookVector
                if lv:IsA("LinearVelocity") then
                    lv.VectorVelocity = dir * (CFG.DashSpeed or 150)
                elseif lv:IsA("BodyVelocity") then
                    lv.Velocity = dir * (CFG.DashSpeed or 150)
                end
            end
        end
        if CFG.InfHealth then
            hum.Health = hum.MaxHealth
        end
    end

    -- 2. PRIORITY 1: TIME TRIAL DUNGEON
    if handleTimeTrialLoop(now) then
        return
    end

    -- 3. PRIORITY 2: AUTO RAID
    if handleAutoRaidLoop(now) then
        return
    end

    -- 4. PRIORITY 3: AUTO PORTAL
    if handleAutoPortalLoop(now) then
        return
    end

    -- 5. PRIORITY 4: NORMAL ZONE FARMING, WALL & QUESTS
    local wallHandled = handleSmartWallBreaking(now)

    if not wallHandled and CFG.AutoFarm then
        local uid, part, model, optPos, coveredUIDs = selectTargetEnemy()
        if optPos and coveredUIDs and #coveredUIDs > 0 then
            teleportToCombat(optPos, coveredUIDs, uid)
        elseif part and uid then
            teleportToTarget(part, uid)
        end
    end

    -- Auto Click
    if CFG.AutoClick and (now - TIMERS.lastClick >= CFG.ClickDelay) then
        TIMERS.lastClick = now
        local clickTgt = (#currentCoveredTargetUIDs > 0 and currentCoveredTargetUIDs) or (currentLockedTargetUID and { currentLockedTargetUID }) or Library.Target
        Library.Remote:Fire("ClickSystem", "Execute", clickTgt)
    end

    -- Auto Cast Skill
    if CFG.AutoCastSkill and (now - TIMERS.lastSkill >= 0.2) then
        TIMERS.lastSkill = now
        local skillTgt = (#currentCoveredTargetUIDs > 0 and currentCoveredTargetUIDs) or (currentLockedTargetUID and { currentLockedTargetUID }) or Library.Target
        Library.Remote:Fire("ClickSystem", "CastSkill", skillTgt)
    end

    -- Auto Quests
    handleAutoQuests(now)

    -- Auto Unlock Individual Systems via Remote when affordable
    handleIndividualSystemUnlocks(now)

    -- Automated Background Systems
    handleAutoRankUp(now)
    handleAutoRaceSpin(now)
    handleAutoWarriorUpgrade(now)
    handleAutoWeaponSpins(now)
    handleAutoHeroPassive(now)
    handleAutoEyeSpin(now)
    handleAutoSinSpin(now)
    handleAutoHunterRankSpin(now)
    handleAutoShadowPassiveSpin(now)
    handleAutoHakiSpin(now)
    handleAutoAmuletSpin(now)
    handleAutoOfflineUpgrades(now)
    handleAutoPortalUpgrades(now)
    handleAutoClassTreeUpgrades(now)
    handleAutoNinjaUpgrades(now)
    handleAutoAntUpgrades(now)

    -- Auto Summon
    if CFG.AutoSummon and (now - TIMERS.lastSummonTick >= 0.5) then
        TIMERS.lastSummonTick = now
        doAutoSummon()
    end

    -- Auto Titan
    handleAutoTitanSpin(now)

    -- Auto Harbor (Expedition)
    if CFG.AutoHarbor and (now - TIMERS.lastHarborTick >= 5.0) then
        TIMERS.lastHarborTick = now
        pcall(function()
            Library.Remote:Fire("ExpeditionSystem", "Claim", "Harbor")
            Library.Remote:Fire("ExpeditionSystem", "Start", "Harbor")
        end)
    end

    -- Auto Collect Commandments
    if CFG.AutoCommandments and (now - TIMERS.lastCommandmentTick >= 2.0) then
        TIMERS.lastCommandmentTick = now
        pcall(function()
            Library.Remote:Fire("SpawnItemSystem", "CollectAll")
        end)
    end

    -- Auto Marine Invasion
    if CFG.AutoMarineInvasion then
        handleAutoMarineInvasion(now)
    end

    -- Shared global upgrade scheduler
    handleAutoGlobalUpgrades(now)

    -- Time Trial Upgrades & Shop
    if CFG.AutoUpgradeTT and (now - TIMERS.lastTTUpgrade >= 0.45) then
        TIMERS.lastTTUpgrade = now
        doTimeTrialUpgrade()
    end
    if CFG.AutoBuyTTShop and (now - TIMERS.lastTTShopBuy >= 3.0) then
        TIMERS.lastTTShopBuy = now
        doTimeTrialShopBuy()
    end
    if CFG.AutoBuyPirateShop and (now - TIMERS.lastPirateShopBuy >= 3.0) then
        TIMERS.lastPirateShopBuy = now
        doPirateShopBuy()
    end

    -- Merge & Crafting
    if CFG.AutoMergeAll and (now - TIMERS.lastMerge >= 2.0) then
        TIMERS.lastMerge = now
        doMergeAll()
    end
    if CFG.AutoCraft and (now - TIMERS.lastCraft >= 3.0) then
        TIMERS.lastCraft = now
        doAutoCraft()
    end

    -- Equip Best
    if (CFG.AutoEquipBest or CFG.EquipBestAvatar or CFG.EquipBestWeapon or CFG.EquipBestTitle) and (now - TIMERS.lastEquipBest >= 3.0) then
        TIMERS.lastEquipBest = now
        doEquipBestCategories()
    end

    -- Auto Claims
    if CFG.AutoClaimAll and (now - TIMERS.lastClaim >= 5.0) then
        TIMERS.lastClaim = now
        doClaimAll()
    end
    if CFG.AutoClaimLikeRewards and (now - TIMERS.lastLikeClaim >= 10.0) then
        TIMERS.lastLikeClaim = now
        doClaimLikeRewards()
    end

    -- Auto Delete / Clean (Only runs if a category clean toggle is enabled)
    local anyCleanEnabled = CFG.AutoDeletePets or CFG.AutoDeleteWeapons or CFG.AutoDeleteWings
        or CFG.AutoDeleteAvatars or CFG.AutoDeleteAccessories or CFG.AutoDeleteWarriors
        or CFG.AutoDeleteMounts or CFG.AutoDeleteJewels or CFG.AutoSell

    if anyCleanEnabled and (now - TIMERS.lastSell >= 2.0) then
        TIMERS.lastSell = now
        doAutoDelete()
    end
end)

-- ══════════════════════════════════════════════════════════

-- Profiles and runtime synchronization
local CONFIG_FOLDER = "SpectreWare_AnimeBreaker"
if makefolder and isfolder and not isfolder(CONFIG_FOLDER) then
    pcall(makefolder, CONFIG_FOLDER)
end

local function syncRuntimeSettings()
    normalizeUpgradeSystems()
    table.clear(UpgradeRequestState)
    CFG.DeleteRaritySelection = CFG.DeleteRaritySelection or {}
    for category, rarities in pairs(RarityToggles) do
        local selected = CFG.DeleteRaritySelection[category]
        if type(selected) ~= "table" then
            selected = {"Common", "Rare"}
            CFG.DeleteRaritySelection[category] = selected
        end
        for _, rarity in ipairs(ALL_RARITY_NAMES) do
            rarities[rarity] = isItemInList(selected, rarity)
        end
    end
    if CFG.NoClip then enableNoClip() else disableNoClip() end
    if SpectreUI then SpectreUI:SyncConfig() elseif AxelHubUI then AxelHubUI:SyncConfig() end
end

local function getSavedConfigsList()
    local list = { "default" }
    if listfiles and isfolder and isfolder(CONFIG_FOLDER) then
        local files = listfiles(CONFIG_FOLDER)
        for _, file in ipairs(files) do
            local name = file:match("([^/\\?*%%:]+)%.json$")
            if name and not table.find(list, name) then
                table.insert(list, name)
            end
        end
    end
    return list
end

local function saveConfigFile(name)
    name = (name and name ~= "") and name or (CFG.SelectedConfigName or "default")
    if not writefile then return end
    if isfolder and not isfolder(CONFIG_FOLDER) then pcall(makefolder, CONFIG_FOLDER) end
    local filePath = CONFIG_FOLDER .. "/" .. name .. ".json"
    local ok, data = pcall(function() return HttpService:JSONEncode(CFG) end)
    if ok and data then
        pcall(writefile, filePath, data)
        print("[SpectreWare] Config successfully saved to " .. filePath)
    end
end

local function loadConfigFile(name)
    name = (name and name ~= "") and name or (CFG.SelectedConfigName or "default")
    if not (readfile and isfile) then return end
    local filePath = CONFIG_FOLDER .. "/" .. name .. ".json"
    if not isfile(filePath) then return end
    local ok, content = pcall(readfile, filePath)
    if not ok or not content then return end
    local okJson, decoded = pcall(function() return HttpService:JSONDecode(content) end)
    if okJson and type(decoded) == "table" then
        for k, v in pairs(decoded) do
            CFG[k] = v
        end
        syncRuntimeSettings()
        print("[SpectreWare] Config loaded from " .. filePath)
    end
end

local function deleteConfigFile(name)
    name = (name and name ~= "") and name or (CFG.SelectedConfigName or "default")
    if not delfile then return end
    local filePath = CONFIG_FOLDER .. "/" .. name .. ".json"
    if isfile and isfile(filePath) then
        pcall(delfile, filePath)
        print("[SpectreWare] Config deleted: " .. filePath)
    end
end

local function checkAutoLoadConfig()
    if not (readfile and isfile) then return end
    local autoFile = CONFIG_FOLDER .. "/_autoload.txt"
    if isfile(autoFile) then
        local ok, name = pcall(readfile, autoFile)
        if ok and name and name ~= "" then
            loadConfigFile(name)
            CFG.SelectedConfigName = name
            CFG.AutoLoadConfig = true
            return
        end
    end
    if CFG.AutoLoadConfig then loadConfigFile("default") end
end
local function disableStartupToggles()
    for key, value in pairs(CFG) do
        if type(value) == "boolean" then CFG[key] = false end
    end
    if type(CFG.CraftSelection) == "table" then
        for _, category in ipairs({"Ring", "Collar", "Earring"}) do
            CFG.CraftSelection[category] = false
        end
    end
    disableNoClip()
end

pcall(checkAutoLoadConfig)
disableStartupToggles()


-- UI Library: SpectreUI (Fluent Fork)


-- =========================================================================
-- SPECTREUI (FLUENT) LOADER & SPECTREWARE ADAPTER
-- =========================================================================
-- The whole UI library is the single line below (made by ui/build.py).
local SPECTREWARE_UI=(function() local KIT_VERSION="1.0.6"local Players=game:GetService("Players")local RunService=game:GetService("RunService")local UIS=game:GetService("UserInputService")if not game:IsLoaded()then game.Loaded:Wait()end local LP=Players.LocalPlayer while not LP do Players:GetPropertyChangedSignal("LocalPlayer"):Wait()LP=Players.LocalPlayer end local GEN=(getgenv().__MonoGen or 0)+1 getgenv().__MonoGen=GEN local function mine()return getgenv().__MonoGen==GEN end local SESSION_START=os.clock()local STATE do local prev=getgenv().__MonoState if prev then pcall(prev.teardown)end local conns,cleanups,living={},{},true STATE={connect=function(signal,fn)local c=signal:Connect(fn)table.insert(conns,c)return c end,onCleanup=function(fn)table.insert(cleanups,fn)end,alive=function()return living end,teardown=function()living=false for _,fn in ipairs(cleanups)do pcall(fn)end for _,c in ipairs(conns)do pcall(function()c:Disconnect()end)end table.clear(conns)table.clear(cleanups)end,}getgenv().__MonoState=STATE end local WindUI=(function()local TweenService=game:GetService("TweenService")local TextService=game:GetService("TextService")local Stats=game:GetService("Stats")local MarketplaceService=game:GetService("MarketplaceService")local TeleportService=game:GetService("TeleportService")local HttpService=game:GetService("HttpService")local ContentProvider=game:GetService("ContentProvider")local BASE_W,BASE_H=880,580 local TOUCH=UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled local DEVICE,S,VP="PC",1,Vector2.new(1920,1080)do local cam=workspace.CurrentCamera local vp=cam and cam.ViewportSize or VP if vp.Y<10 then vp=VP end VP=vp local short=math.min(vp.X,vp.Y)if TOUCH then DEVICE=short<500 and"Phone"or"Tablet"end if DEVICE=="Phone"then S=math.clamp(short/470,0.8,1)else S=math.clamp(vp.Y/1080,0.85,1.35)S=math.max(0.55,math.min(S,vp.X*0.94/BASE_W,vp.Y*0.9/BASE_H))end end local HOVER=not TOUCH local function px(n)return math.floor(n*S+0.5)end local function even(n)n=math.floor(n+0.5)return n%2==1 and n+1 or n end local WHITE=Color3.new(1,1,1)local PALETTE_KEYS={"bg","side","card","popup","field","rowHover","divider","rowLine","fieldHot","rowActive","cardLine","track","fieldLine","border","fieldLineHot","muted","subtext","text",}local MIX={bg=0,side=0.012,card=0.026,popup=0.036,field=0.046,rowHover=0.056,divider=0.068,rowLine=0.076,fieldHot=0.084,rowActive=0.094,cardLine=0.104,track=0.118,fieldLine=0.132,border=0.146,fieldLineHot=0.22,muted=0.42,subtext=0.62,}local LIGHT=Color3.fromRGB(235,238,245)local FIXED={{96,165,250},{167,139,250},{248,113,113},{251,176,80},{110,231,160},{244,114,182},{45,212,191},{255,255,255},{0,0,0},{196,202,216},{245,245,247},{170,174,184},{150,154,166},}local function makePalette(base,accent)local p={accent=accent}local tint=LIGHT:Lerp(accent,0.14)for k,a in pairs(MIX)do p[k]=base:Lerp(tint,a)end p.text=Color3.fromRGB(238,240,244):Lerp(accent,0.04)local used={}local function k3(r,g,b)return r*65536+g*256+b end local function mark(c)used[k3(math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))]=true end for _,f in ipairs(FIXED)do used[k3(f[1],f[2],f[3])]=true end mark(accent)for _,a in ipairs({0.15,0.2,0.25,0.35})do mark(accent:Lerp(Color3.new(1,1,1),a))end for _,k in ipairs(PALETTE_KEYS)do local c=p[k]local r,g,b=math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5)local step=b>=250 and-1 or 1 while used[k3(r,g,b)]do b+=step end used[k3(r,g,b)]=true p[k]=Color3.fromRGB(r,g,b)end return p end local THEMES,THEME_ORDER={},{}local function addTheme(name,base,accent)name=tostring(name)if not THEMES[name]then table.insert(THEME_ORDER,name)end THEMES[name]={name=name,palette=makePalette(base,accent)}end addTheme("Midnight",Color3.fromRGB(16,18,32),Color3.fromRGB(129,148,230))addTheme("Mono",Color3.fromRGB(12,12,13),Color3.fromRGB(228,228,232))addTheme("Ocean",Color3.fromRGB(8,22,26),Color3.fromRGB(102,178,214))addTheme("Emerald",Color3.fromRGB(11,23,18),Color3.fromRGB(98,196,156))addTheme("Crimson",Color3.fromRGB(28,12,14),Color3.fromRGB(224,104,120))addTheme("Amethyst",Color3.fromRGB(24,14,32),Color3.fromRGB(164,140,224))addTheme("Sunset",Color3.fromRGB(27,20,11),Color3.fromRGB(226,156,102))addTheme("Sakura",Color3.fromRGB(26,14,24),Color3.fromRGB(222,140,178))addTheme("Nord",Color3.fromRGB(24,28,35),Color3.fromRGB(136,176,196))local PREFS_DIR,PREFS_FILE="MonoUI","MonoUI/settings.json"local prefs={}pcall(function()if isfile and readfile and isfile(PREFS_FILE)then local data=HttpService:JSONDecode(readfile(PREFS_FILE))if type(data)=="table"then prefs=data end end end)local function savePrefs()pcall(function()if not writefile then return end if makefolder and isfolder and not isfolder(PREFS_DIR)then makefolder(PREFS_DIR)end writefile(PREFS_FILE,HttpService:JSONEncode(prefs))end)end local HEX={}function HEX.to(s)s=tostring(s or""):gsub("[#%s]","")if#s~=6 or s:find("[^%x]")then return nil end return Color3.fromRGB(tonumber(s:sub(1,2),16),tonumber(s:sub(3,4),16),tonumber(s:sub(5,6),16))end function HEX.from(c)return("#%02X%02X%02X"):format(math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))end do local cu=type(prefs.custom)=="table"and prefs.custom or{}addTheme("Custom",HEX.to(cu.base)or Color3.fromRGB(14,17,24),HEX.to(cu.accent)or Color3.fromRGB(236,72,153))end local GAME_KEY=tostring((game.GameId and game.GameId~=0)and game.GameId or game.PlaceId)local currentTheme=THEMES[prefs.theme]and prefs.theme or"Midnight"local START=THEMES[currentTheme].palette local C={accent=START.accent,blue=Color3.fromRGB(96,165,250),purple=Color3.fromRGB(167,139,250),red=Color3.fromRGB(248,113,113),amber=Color3.fromRGB(251,176,80),green=Color3.fromRGB(110,231,160),pink=Color3.fromRGB(244,114,182),teal=Color3.fromRGB(45,212,191),}local T={font=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.Medium),fontSemi=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.SemiBold),fontBold=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.Bold),mono=Font.new("rbxasset://fonts/families/RobotoMono.json",Enum.FontWeight.Medium),size=Vector2.new(even(math.min(BASE_W*S,VP.X*0.96-2)),even(math.min(BASE_H*S,VP.Y*0.92-2))),radius=px(14),toggleKey=Enum.KeyCode.Z,}local function setPalette(p)for _,k in ipairs(PALETTE_KEYS)do T[k]=p[k]end C.accent=p.accent end setPalette(START)local function lum(c)return 0.2126*c.R+0.7152*c.G+0.0722*c.B end local function onAccent()return lum(C.accent)>0.5 and T.bg or WHITE end local function knobOn()return lum(C.accent)>0.8 and T.bg or WHITE end local ICON={["axe"]="rbxassetid://132405197863294",["bed"]="rbxassetid://97726529032925",["bell"]="rbxassetid://97392696311902",["book-open"]="rbxassetid://129845326810392",["bot"]="rbxassetid://80451686744860",["briefcase"]="rbxassetid://96754188164225",["check"]="rbxassetid://93898873302694",["check-check"]="rbxassetid://95183312173858",["circle"]="rbxassetid://130359823580534",["coffee"]="rbxassetid://106864403231093",["cog"]="rbxassetid://116544501716299",["crosshair"]="rbxassetid://134242818164054",["dollar-sign"]="rbxassetid://127320961224019",["droplets"]="rbxassetid://140111846025180",["eye"]="rbxassetid://100033680381365",["flask-conical"]="rbxassetid://128406680901165",["flask-round"]="rbxassetid://127508287324940",["gamepad-2"]="rbxassetid://92483947987410",["gauge"]="rbxassetid://110273524101447",["gem"]="rbxassetid://112904952151156",["glass-water"]="rbxassetid://115526102400988",["hand"]="rbxassetid://130703864968637",["hand-coins"]="rbxassetid://126990543175462",["magnet"]="rbxassetid://135162361226972",["map"]="rbxassetid://95107167260947",["map-pin"]="rbxassetid://84279202219901",["mouse-pointer-click"]="rbxassetid://107150227368485",["move-vertical"]="rbxassetid://86234730730899",["package"]="rbxassetid://97261141732706",["package-check"]="rbxassetid://102374216055130",["package-plus"]="rbxassetid://129261988138366",["power"]="rbxassetid://96479131758775",["refresh-cw"]="rbxassetid://138133190015277",["repeat"]="rbxassetid://121886242955173",["scan"]="rbxassetid://123104789658180",["scan-eye"]="rbxassetid://99244790601968",["settings"]="rbxassetid://80758916183665",["shield"]="rbxassetid://110987169760162",["shield-check"]="rbxassetid://87354736164608",["siren"]="rbxassetid://134210267818039",["sparkles"]="rbxassetid://138635884129147",["sprout"]="rbxassetid://100091687832508",["target"]="rbxassetid://87563802520297",["trees"]="rbxassetid://121203841375919",["triangle-alert"]="rbxassetid://125920361880643",["user"]="rbxassetid://81589895647169",["user-search"]="rbxassetid://101335649828115",["users"]="rbxassetid://115398113982385",["wind"]="rbxassetid://114551690399915",["x"]="rbxassetid://110786993356448",["zap"]="rbxassetid://130551565616516",["info"]="rbxassetid://124560466474914",["search"]="rbxassetid://121018724060431",["chevron-left"]="rbxassetid://73780377692148",["chevron-right"]="rbxassetid://92473583511724",["chevron-down"]="rbxassetid://134243273101015",["trash-2"]="rbxassetid://109843431391323",["save"]="rbxassetid://126116963775616",["play"]="rbxassetid://135609604299893",["star"]="rbxassetid://136141469398409",["sword"]="rbxassetid://124448418211665",["footprints"]="rbxassetid://139192589041315",["monitor"]="rbxassetid://72664649203050",["palette"]="rbxassetid://86350350950064",["keyboard"]="rbxassetid://121474456068237",["bookmark"]="rbxassetid://121093149326239",["layers"]="rbxassetid://81973586053257",["hammer"]="rbxassetid://83545120140895",["swords"]="rbxassetid://81872698913435",["house"]="rbxassetid://98755624629571",["wifi"]="rbxassetid://104669375183960",["clock"]="rbxassetid://121808839832144",["eye-off"]="rbxassetid://135928786788378",["user-x"]="rbxassetid://139748155894754",["shuffle"]="rbxassetid://132382786975101",["copy"]="rbxassetid://78979572434545",["activity"]="rbxassetid://94212016861936",["minimize-2"]="rbxassetid://116269596042539",["cloud"]="rbxassetid://121226497050352",["layout-grid"]="rbxassetid://81344910161871",["store"]="rbxassetid://90338129673705",["cloud-lightning"]="rbxassetid://133517088924849",["crown"]="rbxassetid://127843403295538",["timer"]="rbxassetid://85473888890506",["server"]="rbxassetid://92188766517878",["trending-down"]="rbxassetid://139309232226438",["user-round"]="rbxassetid://136485052187963",["circle-check"]="rbxassetid://85262178816537",["hash"]="rbxassetid://82890331678520",["list-filter"]="rbxassetid://103321376129527",["panel-left-close"]="rbxassetid://126579818823552",["panel-left-open"]="rbxassetid://111075816195767",["move-diagonal-2"]="rbxassetid://117298577948096",["grip"]="rbxassetid://109058783556768",["pin"]="rbxassetid://120978111007514",["pin-off"]="rbxassetid://127696372451750",["star-off"]="rbxassetid://75742832732503",["rotate-ccw"]="rbxassetid://110116685948665",["ellipsis"]="rbxassetid://140019550645825",["folder-open"]="rbxassetid://76018996254888",["droplet"]="rbxassetid://100597455015098",["pipette"]="rbxassetid://133167932934404",["sliders-horizontal"]="rbxassetid://85538382643347",["blend"]="rbxassetid://111679612185257",["toggle-right"]="rbxassetid://90411952142550",["smartphone"]="rbxassetid://96623008834511",["cpu"]="rbxassetid://77549309870247",["terminal"]="rbxassetid://106783148545356",["anchor"]="rbxassetid://92181172123618",["arrow-up"]="rbxassetid://89282378235317",["backpack"]="rbxassetid://140420225386018",["bone"]="rbxassetid://111242153474115",["box"]="rbxassetid://101768155599700",["car"]="rbxassetid://121065933462582",["compass"]="rbxassetid://115123411028382",["dices"]="rbxassetid://81268120302865",["dna"]="rbxassetid://74007982981741",["egg"]="rbxassetid://117851493400222",["eraser"]="rbxassetid://133957773112410",["gift"]="rbxassetid://109855212076373",["graduation-cap"]="rbxassetid://93771896340220",["heart"]="rbxassetid://116559368303288",["key"]="rbxassetid://96510194465420",["lasso"]="rbxassetid://121072936884007",["layout-dashboard"]="rbxassetid://139929981863901",["leaf"]="rbxassetid://119951075637174",["link"]="rbxassetid://131607023382430",["list-ordered"]="rbxassetid://83212528113913",["move"]="rbxassetid://116138709011735",["navigation"]="rbxassetid://79308213542922",["paw-print"]="rbxassetid://112218825427601",["recycle"]="rbxassetid://140417023381961",["scroll"]="rbxassetid://74072101474951",["shopping-bag"]="rbxassetid://71885477293226",["shopping-cart"]="rbxassetid://128420521375441",["trending-up"]="rbxassetid://81819858538839",["utensils"]="rbxassetid://139952569804235",}ICON["knife"]=ICON["sword"]ICON["alert-triangle"]=ICON["triangle-alert"]ICON["home"]=ICON["house"]ICON["layout"]=ICON["layout-grid"]local function icon(name)if type(name)=="number"then return"rbxassetid://"..name end name=tostring(name or"")if name:find("^rbxasset")or name:find("^https?:")then return name end if name:match("^%d+$")then return"rbxassetid://"..name end name=name:gsub("^lucide:",""):lower()return ICON[name]or ICON.circle end local SHADOW_IMAGE="rbxassetid://8992230677"local SHARP=setmetatable({},{__mode="k"})local SHARP_SYNC={"Position","Size","AnchorPoint","Visible","ZIndex","LayoutOrder","Rotation","AutomaticSize"}local function carried(s,ch)return ch:IsA("GuiObject")or(s.auto and(ch:IsA("UICorner")or ch:IsA("UIStroke")))end local function uiScaleOf(inst)local f=1 while inst and not inst:IsA("LayerCollector")do local u=inst:FindFirstChildOfClass("UIScale")if u then f*=u.Scale end inst=inst.Parent end return f>0 and f or 1 end local function heightOf(inst)return math.ceil(inst.AbsoluteSize.Y/uiScaleOf(inst))end local function unrest(cg)local s=SHARP[cg]if not s or not s.resting then return end s.resting=false local twin=s.twin local size0,frozen if s.auto then size0=cg.Size frozen=UDim2.new(size0.X.Scale,size0.X.Offset,size0.Y.Scale,math.max(size0.Y.Offset,heightOf(twin)))cg.Size=frozen end for _,ch in ipairs(twin:GetChildren())do if carried(s,ch)then ch.Parent=cg end end if s.auto then cg.BackgroundTransparency=s.bt twin.BackgroundTransparency=1 task.delay(0.1,function()if cg.Parent and cg.Size==frozen then cg.Size=size0 end end)end end local function makeTwin(cg,s)local twin=Instance.new("Frame")twin.Name=cg.Name.."_Sharp"twin.BackgroundTransparency=1 twin.BorderSizePixel=0 twin.ClipsDescendants=true s.auto=cg.AutomaticSize~=Enum.AutomaticSize.None for _,p in ipairs(SHARP_SYNC)do twin[p]=cg[p]cg:GetPropertyChangedSignal(p):Connect(function()twin[p]=cg[p]end)end if s.auto then twin.BackgroundColor3=cg.BackgroundColor3 cg:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()twin.BackgroundColor3=cg.BackgroundColor3 end)cg:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()if s.resting and cg.BackgroundTransparency~=1 then s.bt=cg.BackgroundTransparency twin.BackgroundTransparency=s.bt cg.BackgroundTransparency=1 end end)end for _,ch in ipairs(cg:GetChildren())do if ch:IsA("UIGridStyleLayout")or ch:IsA("UIPadding")then ch:Clone().Parent=twin elseif ch:IsA("UIScale")then local sc=Instance.new("UIScale")sc.Scale=ch.Scale ch:GetPropertyChangedSignal("Scale"):Connect(function()sc.Scale=ch.Scale end)sc.Parent=twin end end twin.Parent=cg.Parent cg:GetPropertyChangedSignal("Parent"):Connect(function()if cg.Parent then twin.Parent=cg.Parent else unrest(cg)twin.Parent=nil end end)cg.Destroying:Connect(function()twin:Destroy()end)s.twin=twin return twin end local function rest(cg)local s=SHARP[cg]if not s or s.resting or cg.GroupTransparency~=0 or not cg.Parent then return end local focused=UIS:GetFocusedTextBox()if focused and focused:IsDescendantOf(cg)then if not s.waiting then s.waiting=true focused.FocusLost:Once(function()s.waiting=false task.defer(rest,cg)end)end return end local twin=s.twin or makeTwin(cg,s)if s.auto then local sz=cg.Size twin.Size=UDim2.new(sz.X.Scale,sz.X.Offset,sz.Y.Scale,math.max(sz.Y.Offset,heightOf(cg)))end s.resting=true if s.auto then s.bt=cg.BackgroundTransparency twin.BackgroundTransparency=s.bt cg.BackgroundTransparency=1 end for _,ch in ipairs(cg:GetChildren())do if carried(s,ch)then ch.Parent=twin end end end local function sharpen(cg)local s={resting=false}SHARP[cg]=s cg:GetPropertyChangedSignal("GroupTransparency"):Connect(function()if cg.GroupTransparency==0 then task.defer(rest,cg)else unrest(cg)end end)cg.ChildAdded:Connect(function(ch)if s.resting and ch:IsA("GuiObject")then task.defer(function()if s.resting and ch.Parent==cg then ch.Parent=s.twin end end)end end)task.defer(rest,cg)end local function hostOf(cg)local s=SHARP[cg]return(s and s.resting)and s.twin or cg end local function twinOf(cg)local s=SHARP[cg]return s and(s.twin or makeTwin(cg,s))end local function tween(inst,time,goal,style,dir)if goal.GroupTransparency~=nil and SHARP[inst]then unrest(inst)end local tw=TweenService:Create(inst,TweenInfo.new(time,style or Enum.EasingStyle.Quint,dir or Enum.EasingDirection.Out),goal)tw:Play()return tw end local function new(class,props,parent)local i=Instance.new(class)for k,v in pairs(props or{})do i[k]=v end if parent then i.Parent=parent end if class=="CanvasGroup"then sharpen(i)end return i end local function corner(p,r)return new("UICorner",{CornerRadius=UDim.new(0,r)},p)end local function stroke(p,color,transparency,thickness)return new("UIStroke",{Color=color,Thickness=thickness or 1,Transparency=transparency or 0,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,},p)end local function textW(text,size,face)local w=#text*size*0.55 pcall(function()local params=Instance.new("GetTextBoundsParams")params.Text,params.Font,params.Size,params.Width=text,face or T.font,size,10000 w=TextService:GetTextBoundsAsync(params).X end)return math.ceil(w)+1 end local TAGS={Risky=C.red,Beta=C.amber,New=C.blue,Safe=C.green,["On start"]=C.amber}local function tag(parent,text,color,order)color=color or TAGS[text]or T.subtext local label=text:upper()local h=even(px(18))local pill=new("Frame",{Name="Tag",LayoutOrder=order or 1,BackgroundColor3=color,BackgroundTransparency=0.85,Size=UDim2.fromOffset(textW(label,px(10),T.fontBold)+px(14),h),},parent)corner(pill,math.floor(h/2))stroke(pill,color,0.6)new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(10),TextColor3=color:Lerp(WHITE,0.2),Text=label,},pill)return pill end local function parseTitle(title)title=tostring(title or"")local tags={}local plain=title:gsub("<[^>]+>","")if plain:find("RISKY",1,true)then table.insert(tags,"Risky")plain=plain:gsub("%s*RISKY%s*"," ")end plain=plain:gsub("^%s+",""):gsub("%s+$","")if plain:sub(1,1)=="="then plain="What RISKY means"end return plain,tags end local privacy={name=false,avatar=false}local privacyHooks={}local function onPrivacy(fn)table.insert(privacyHooks,fn)pcall(fn)end local function setPrivacy(key,on)privacy[key]=on for _,fn in ipairs(privacyHooks)do pcall(fn)end end local gameInfo={name="Loading...",creator="...",loaded=false}local gameHooks={}local function onGameInfo(fn)table.insert(gameHooks,fn)if gameInfo.loaded then pcall(fn)end end task.spawn(function()local ok,info=pcall(MarketplaceService.GetProductInfo,MarketplaceService,game.PlaceId)if ok and type(info)=="table"then gameInfo.name=tostring(info.Name or"Unknown experience")gameInfo.creator=(type(info.Creator)=="table"and info.Creator.Name)and tostring(info.Creator.Name)or"Unknown"else gameInfo.name,gameInfo.creator="Unknown experience","Unknown"end gameInfo.loaded=true for _,fn in ipairs(gameHooks)do pcall(fn)end end)local host if gethui then host=gethui()else local ok,cg=pcall(function()return game:GetService("CoreGui")end)if ok and cg and pcall(function()return cg:GetChildren()end)then host=cg elseif LP then host=LP:FindFirstChild("PlayerGui")or LP:WaitForChild("PlayerGui")end end for _,old in ipairs(host:GetChildren())do if old.Name=="MonoUI"then old:Destroy()end end local gui=new("ScreenGui",{Name="MonoUI",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=100000,},host)STATE.onCleanup(function()pcall(function()gui:Destroy()end)end)local onThemeChanged,applyTheme do(function()local themeHooks={}function onThemeChanged(fn)table.insert(themeHooks,fn)end local function ckey(c)return math.floor(c.R*255+0.5)*65536+math.floor(c.G*255+0.5)*256+math.floor(c.B*255+0.5)end local ACCENT_MIX={0.15,0.2,0.25,0.35}local THEMED_PROPS={Frame={"BackgroundColor3"},CanvasGroup={"BackgroundColor3"},UIStroke={"Color"},TextLabel={"BackgroundColor3","TextColor3"},TextButton={"BackgroundColor3","TextColor3"},TextBox={"BackgroundColor3","TextColor3","PlaceholderColor3"},ImageLabel={"BackgroundColor3","ImageColor3"},ImageButton={"BackgroundColor3","ImageColor3"},ScrollingFrame={"BackgroundColor3","ScrollBarImageColor3"},}local pendingFades={}local recentPalettes={}local lastSwitch,queued=-1,nil local function finishFades()for _,f in ipairs(pendingFades)do local st=f.tw.PlaybackState if st==Enum.PlaybackState.Playing or st==Enum.PlaybackState.Begin or st==Enum.PlaybackState.Delayed then f.tw:Cancel()pcall(function()f.inst[f.prop]=f.goal end)end end table.clear(pendingFades)end local function mapBetween(from,to)local map={}local function add(o,n)local k=ckey(o)if map[k]==nil then map[k]=n end end for _,k in ipairs(PALETTE_KEYS)do add(from[k],to[k])end add(from.accent,to.accent)for _,a in ipairs(ACCENT_MIX)do add(from.accent:Lerp(WHITE,a),to.accent:Lerp(WHITE,a))end return map end local function walkTheme(maps,skip,animate)local st,hid={gui},{false}while#st>0 do local inst,hidden=table.remove(st),table.remove(hid)if not inst:GetAttribute("MonoNoTheme")then if not hidden and inst:IsA("GuiObject")and not inst.Visible then hidden=true end local props=THEMED_PROPS[inst.ClassName]if props then for _,prop in ipairs(props)do local k=ckey(inst[prop])if not(skip and skip[k])then local n for _,m in ipairs(maps)do n=m[k]if n then break end end if n then if animate and not hidden then local tw=tween(inst,0.4,{[prop]=n},Enum.EasingStyle.Quad)table.insert(pendingFades,{tw=tw,inst=inst,prop=prop,goal=n})else inst[prop]=n end end end end end for _,c in ipairs(inst:GetChildren())do table.insert(st,c)table.insert(hid,hidden)end end end end local runTheme function applyTheme(name,animate,remember,force)name=tostring(name or"")local th=THEMES[name]if not th or(name==currentTheme and not force and not queued)then return false end local now=os.clock()if animate and(queued or now-lastSwitch<0.15)then local first=queued==nil queued={name,remember,force}if first then task.delay(math.max(0.15-(now-lastSwitch),0.03),function()local q=queued queued=nil if q and(q[1]~=currentTheme or q[3])then runTheme(q[1],true,q[2])end end)end return true end return runTheme(name,animate,remember)end function runTheme(name,animate,remember)local th=THEMES[name]if not th then return false end local now=os.clock()lastSwitch=now finishFades()local old={accent=C.accent}for _,k in ipairs(PALETTE_KEYS)do old[k]=T[k]end table.insert(recentPalettes,1,old)while#recentPalettes>4 do table.remove(recentPalettes)end local p=th.palette currentTheme=name setPalette(p)walkTheme({mapBetween(old,p)},nil,animate)local token=now task.delay(0.6,function()if lastSwitch~=token or not gui.Parent then return end local fresh={[ckey(p.accent)]=true}for _,k in ipairs(PALETTE_KEYS)do fresh[ckey(p[k])]=true end local maps={}for _,pal in ipairs(recentPalettes)do table.insert(maps,mapBetween(pal,p))end walkTheme(maps,fresh,false)end)if remember then prefs.theme=name savePrefs()end for _,fn in ipairs(themeHooks)do pcall(fn,name)end return true end end)()end local shell=new("Frame",{Name="Window",AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.fromOffset(T.size.X,T.size.Y),BackgroundTransparency=1,Visible=false,},gui)local pop=new("UIScale",{},shell)local userScale=math.clamp(tonumber(prefs.scale)or 1,0.5,2)local WIN=(function()local W={alpha=math.clamp(tonumber(prefs.opacity)and(1-tonumber(prefs.opacity))or 0,0,0.4),blur=prefs.blur==true,min=Vector2.new(math.min(even(px(720)),T.size.X),math.min(even(px(460)),T.size.Y)),}local function vp()return workspace.CurrentCamera.ViewportSize end function W.maxSize()local v=vp()return Vector2.new(math.max(W.min.X,even(v.X*0.96/userScale)),math.max(W.min.Y,even(v.Y*0.94/userScale)))end function W.fitSize(s)local mx=W.maxSize()return Vector2.new(even(math.clamp(s.X,W.min.X,mx.X)),even(math.clamp(s.Y,W.min.Y,mx.Y)))end function W.clamp(c)local v=vp()local half=Vector2.new(T.size.X,T.size.Y)*userScale/2 local function axis(x,h,len)if(h+6)*2>=len then return len/2 end return math.clamp(x,h+6,len-h-6)end return Vector2.new(math.floor(axis(c.X,half.X,v.X)+0.5),math.floor(axis(c.Y,half.Y,v.Y)+0.5))end function W.place(c,animate)c=W.clamp(c)local goal=UDim2.fromOffset(c.X,c.Y)if animate then tween(shell,0.12,{Position=goal})else shell.Position=goal end end function W.center()return Vector2.new(shell.Position.X.Offset,shell.Position.Y.Offset)end function W.setSize(s)T.size=W.fitSize(s)shell.Size=UDim2.fromOffset(T.size.X,T.size.Y)end function W.save()prefs.window={w=T.size.X,h=T.size.Y}savePrefs()end local saved=type(prefs.window)=="table"and prefs.window or{}if tonumber(saved.w)and tonumber(saved.h)then W.setSize(Vector2.new(tonumber(saved.w),tonumber(saved.h)))end do local v=vp()W.place(Vector2.new(v.X/2,v.Y/2))end local camConn local function hook()if camConn then camConn:Disconnect()end local cam=workspace.CurrentCamera if not cam then return end camConn=cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()W.setSize(T.size)W.place(W.center())end)end hook()STATE.connect(workspace:GetPropertyChangedSignal("CurrentCamera"),hook)STATE.onCleanup(function()if camConn then camConn:Disconnect()end end)local fx function W.blurTo(on)if not fx then if not on then return end fx=Instance.new("BlurEffect")fx.Name,fx.Size="MonoUIBlur",0 fx.Parent=game:GetService("Lighting")STATE.onCleanup(function()pcall(function()fx:Destroy()end)end)end tween(fx,on and 0.4 or 0.25,{Size=on and 14 or 0},Enum.EasingStyle.Quad)end return W end)()local SHADOW_REST=0.45 local shadow=new("ImageLabel",{Name="Shadow",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,px(10)),Size=UDim2.new(1,px(90),1,px(90)),BackgroundTransparency=1,Image=SHADOW_IMAGE,ImageColor3=Color3.new(0,0,0),ImageTransparency=1,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(99,99,99,99),},shell)local borderFrame=new("Frame",{Name="Border",Size=UDim2.fromScale(1,1),BackgroundTransparency=1},shell)corner(borderFrame,T.radius)local borderStroke=stroke(borderFrame,T.border,1)local window=new("CanvasGroup",{Name="Canvas",Size=UDim2.fromScale(1,1),BackgroundColor3=T.bg,BorderSizePixel=0,GroupTransparency=1,},shell)corner(window,T.radius)local function inWindow(el)local s=pop.Scale local p=(el.AbsolutePosition-window.AbsolutePosition)/s return Vector2.new(math.floor(p.X+0.5),math.floor(p.Y+0.5)),el.AbsoluteSize/s end do local dragging,startMouse,startPos local function dragStart(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging,startMouse,startPos=true,input.Position,WIN.center()end end STATE.connect(window.InputBegan,dragStart)STATE.connect(twinOf(window).InputBegan,dragStart)STATE.connect(UIS.InputChanged,function(input)if not dragging or not mine()then return end if input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch then return end local d=input.Position-startMouse WIN.place(startPos+Vector2.new(d.X,d.Y),true)end)STATE.connect(UIS.InputEnded,function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end)end local shown,opened=false,false local closePopup local paintFloat local keyEnabled=true local function setShown(on)if on==shown then return end shown=on if on then opened=true end if closePopup then closePopup()end if paintFloat then paintFloat()end if on then shell.Visible=true pop.Scale=userScale*0.92 tween(pop,0.45,{Scale=userScale},Enum.EasingStyle.Back)tween(window,0.3,{GroupTransparency=WIN.alpha},Enum.EasingStyle.Quad)tween(shadow,0.45,{ImageTransparency=SHADOW_REST})tween(borderStroke,0.3,{Transparency=0})if WIN.blur then WIN.blurTo(true)end else if WIN.blur then WIN.blurTo(false)end tween(pop,0.22,{Scale=userScale*0.95})tween(shadow,0.18,{ImageTransparency=1})tween(borderStroke,0.18,{Transparency=1})local tw=tween(window,0.18,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()if not shown then shell.Visible=false end end)end end local capture={active=false}STATE.connect(UIS.InputBegan,function(input,processed)if processed or not mine()or capture.active then return end if keyEnabled and input.KeyCode==T.toggleKey then setShown(not shown)end end)local L={side=px(216),narrow=px(72),header=px(64),navH=even(px(42)),navGap=px(4),navIcon=even(px(18)),navText=px(15),profileH=px(60),segH=even(px(36)),}local PAD=px(22)local INNER=px(14)local NAV_ICON_X=math.floor((L.narrow-INNER*2-L.navIcon)/2)local NAV_LABEL_X=NAV_ICON_X+L.navIcon+px(12)local sidebar=new("Frame",{Name="Sidebar",Size=UDim2.new(0,L.side,1,0),BackgroundColor3=T.side,BorderSizePixel=0,ClipsDescendants=true,},window)corner(sidebar,T.radius)new("Frame",{Name="SquareEdge",AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.new(0,T.radius,1,0),BackgroundColor3=T.side,BorderSizePixel=0,ZIndex=0,},sidebar)new("Frame",{Name="Divider",AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.new(0,1,1,0),BackgroundColor3=T.divider,BorderSizePixel=0,ZIndex=3,},sidebar)local brandIcon,brandTitle,brandSub,brandBadge,setBrand do local brandS=px(36)local wordH,subH=px(38),px(12)local brand=new("Frame",{Name="Brand",Position=UDim2.fromOffset(INNER,math.floor((L.header-(wordH+subH+px(2)))/2)),Size=UDim2.new(1,-INNER*2,0,wordH+subH+px(2)),BackgroundTransparency=1,},sidebar)brandBadge=new("CanvasGroup",{Name="Badge",AnchorPoint=Vector2.new(0,0.5),Position=UDim2.fromScale(0,0.5),Size=UDim2.fromOffset(brandS,brandS),BackgroundColor3=C.accent,BackgroundTransparency=0.82,GroupTransparency=1,Visible=false,},brand)corner(brandBadge,px(10))stroke(brandBadge,C.accent,1)new("UIGradient",{Rotation=90,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,0.45)}),},brandBadge)local monogram=new("TextLabel",{Name="Monogram",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,px(1)),Size=UDim2.fromScale(1,1),BackgroundTransparency=1,RichText=true,FontFace=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.ExtraBold),TextSize=px(17),TextColor3=WHITE,Text="",},brandBadge)brandIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(18)),even(px(18))),BackgroundTransparency=1,Image="",ImageColor3=C.accent:Lerp(WHITE,0.25),Visible=false,},brandBadge)brandTitle=new("TextLabel",{Name="Wordmark",Size=UDim2.new(1,0,0,wordH),BackgroundTransparency=1,RichText=true,FontFace=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.ExtraBold),TextScaled=true,TextColor3=WHITE,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Bottom,Text="",},brand)new("UITextSizeConstraint",{MaxTextSize=px(40),MinTextSize=px(12)},brandTitle)brandSub=new("TextLabel",{Position=UDim2.fromOffset(px(2),wordH+px(1)),Size=UDim2.new(1,-px(4),0,subH),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},brand)local base,accent="SPECTRE","WARE"local function esc(s)return(tostring(s):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"))end local function paint()local hex=HEX.from(C.accent)local text=esc(base)if accent~=""then text..= ('<font color="%s">%s</font>'):format(hex,esc(accent))end brandTitle.Text=text local m=esc(base:sub(1,1):upper())if accent~=""then m..= ('<font color="%s">%s</font>'):format(hex,esc(accent:sub(1,1):upper()))end monogram.Text=m monogram.Visible=not brandIcon.Visible end function setBrand(b,a)base,accent=tostring(b or""),tostring(a or"")paint()end paint()onThemeChanged(paint)end local navTop=L.header+px(4)local nav=new("ScrollingFrame",{Name="Nav",Position=UDim2.fromOffset(INNER,navTop),Size=UDim2.new(1,-INNER*2,1,-(navTop+L.profileH+INNER*2)),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,},sidebar)local navHl=new("Frame",{Name="Highlight",Size=UDim2.new(1,0,0,L.navH),BackgroundColor3=T.rowActive,Visible=false},nav)corner(navHl,px(10))stroke(navHl,T.fieldLine,0.35)local navBarH=even(px(18))local navBar=new("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(px(3),navBarH),BackgroundColor3=C.accent,BorderSizePixel=0,},navHl)corner(navBar,px(2))local navList=new("Frame",{Name="List",Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},nav)new("UIListLayout",{Padding=UDim.new(0,L.navGap),SortOrder=Enum.SortOrder.LayoutOrder},navList)local profile=new("TextButton",{Name="Profile",AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,INNER,1,-INNER),Size=UDim2.new(1,-INNER*2,0,L.profileH),BackgroundColor3=T.card,AutoButtonColor=false,Text="",},sidebar)corner(profile,px(12))local profStroke=stroke(profile,T.cardLine)local avS=even(px(36))local AV_X,AV_X_NARROW=px(12),math.floor((L.narrow-INNER*2-avS)/2)local pfp=new("ImageLabel",{Name="Avatar",Position=UDim2.fromOffset(AV_X,math.floor((L.profileH-avS)/2)),Size=UDim2.fromOffset(avS,avS),BackgroundColor3=T.field,Image="",},profile)new("UICorner",{CornerRadius=UDim.new(1,0)},pfp)local dot=new("Frame",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,px(1),1,px(1)),Size=UDim2.fromOffset(px(11),px(11)),BackgroundColor3=C.green,ZIndex=2,},pfp)new("UICorner",{CornerRadius=UDim.new(1,0)},dot)stroke(dot,T.card,0,2)task.spawn(function()local ok,img=pcall(Players.GetUserThumbnailAsync,Players,LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)if ok and pfp.Parent then pfp.Image=img end end)local ptx=AV_X+avS+px(10)local profName=new("TextLabel",{Position=UDim2.fromOffset(ptx,0),Size=UDim2.new(1,-(ptx+px(28)),0.5,-px(1)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(14),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Bottom,TextTruncate=Enum.TextTruncate.AtEnd,Text=LP.DisplayName,},profile)local profSub=new("TextLabel",{Position=UDim2.new(0,ptx,0.5,px(2)),Size=UDim2.new(1,-(ptx+px(28)),0.5,-px(2)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextTruncate=Enum.TextTruncate.AtEnd,Text="@"..LP.Name,},profile)local chevS=even(px(14))local profChev=new("ImageLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(12),0.5,0),Size=UDim2.fromOffset(chevS,chevS),BackgroundTransparency=1,Image=ICON["chevron-right"],ImageColor3=T.muted,},profile)onGameInfo(function()profSub.Text=gameInfo.name end)onPrivacy(function()profName.Text=privacy.name and"Hidden"or LP.DisplayName tween(pfp,0.25,{ImageTransparency=privacy.avatar and 1 or 0})end)STATE.connect(profile.MouseEnter,function()tween(profile,0.18,{BackgroundColor3=T.rowHover})tween(profStroke,0.18,{Color=T.fieldLineHot})tween(profChev,0.25,{Position=UDim2.new(1,-px(9),0.5,0),ImageColor3=T.text})end)STATE.connect(profile.MouseLeave,function()tween(profile,0.18,{BackgroundColor3=T.card})tween(profStroke,0.18,{Color=T.cardLine})tween(profChev,0.25,{Position=UDim2.new(1,-px(12),0.5,0),ImageColor3=T.muted})end)local content=new("Frame",{Name="Content",Position=UDim2.fromOffset(L.side,0),Size=UDim2.new(1,-L.side,1,0),BackgroundTransparency=1,ClipsDescendants=true,},window)local btnS=even(px(34))local searchW,searchH=px(250),even(px(36))local headIconS=even(px(20))local function headerButton(name,iconId,anchorX,pos)local b=new("TextButton",{Name=name,AnchorPoint=Vector2.new(anchorX,0.5),Position=pos,Size=UDim2.fromOffset(btnS,btnS),BackgroundColor3=T.field,BackgroundTransparency=1,AutoButtonColor=false,Text="",},content)corner(b,px(9))local st=stroke(b,T.fieldLine,1)local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(17)),even(px(17))),BackgroundTransparency=1,Image=iconId,ImageColor3=T.subtext,},b)STATE.connect(b.MouseEnter,function()tween(b,0.15,{BackgroundTransparency=0})tween(st,0.15,{Transparency=0})tween(ic,0.15,{ImageColor3=T.text})end)STATE.connect(b.MouseLeave,function()tween(b,0.15,{BackgroundTransparency=1})tween(st,0.15,{Transparency=1})tween(ic,0.15,{ImageColor3=T.subtext})end)return b,ic end local colBtn,colIcon=headerButton("SidebarToggle",ICON["panel-left-close"],0,UDim2.new(0,PAD-px(8),0,math.floor(L.header/2)))local HEAD_X=PAD-px(8)+btnS+px(10)local headIcon=new("ImageLabel",{Position=UDim2.fromOffset(HEAD_X,math.floor((L.header-headIconS)/2)),Size=UDim2.fromOffset(headIconS,headIconS),BackgroundTransparency=1,Image="",ImageColor3=C.accent,},content)local TITLE_POS=UDim2.fromOffset(HEAD_X+headIconS+px(10),0)local headTitle=new("TextLabel",{Position=TITLE_POS,Size=UDim2.new(1,-(HEAD_X+headIconS+px(10)+PAD+searchW+btnS+px(20)),0,L.header),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(20),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},content)local minBtn=headerButton("Minimize",ICON["minimize-2"],1,UDim2.new(1,-PAD,0,math.floor(L.header/2)))local search=new("Frame",{Name="Search",AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-(PAD+btnS+px(8)),0,math.floor(L.header/2)),Size=UDim2.fromOffset(searchW,searchH),BackgroundColor3=T.field,},content)corner(search,px(10))local searchStroke=stroke(search,T.fieldLine)local sIconS=even(px(15))local searchIcon=new("ImageLabel",{Position=UDim2.fromOffset(px(12),math.floor((searchH-sIconS)/2)),Size=UDim2.fromOffset(sIconS,sIconS),BackgroundTransparency=1,Image=ICON.search,ImageColor3=T.muted,},search)local searchBox=new("TextBox",{Name="Query",Position=UDim2.fromOffset(px(12)+sIconS+px(9),0),Size=UDim2.new(1,-(px(12)+sIconS+px(9)+px(10)),1,0),BackgroundTransparency=1,ClearTextOnFocus=false,FontFace=T.font,TextSize=px(14),TextColor3=T.text,PlaceholderText="Search everything...",PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true,},search)STATE.connect(searchBox.Focused,function()tween(searchStroke,0.2,{Color=C.accent,Transparency=0.25})tween(searchIcon,0.2,{ImageColor3=C.accent})tween(search,0.2,{BackgroundColor3=T.fieldHot})end)STATE.connect(searchBox.FocusLost,function()tween(searchStroke,0.25,{Color=T.fieldLine,Transparency=0})tween(searchIcon,0.25,{ImageColor3=T.muted})tween(search,0.25,{BackgroundColor3=T.field})end)local overlay=new("Frame",{Name="Overlay",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=20},window)do local gs=math.max(even(px(22)),TOUCH and 32 or 0)local grip=new("TextButton",{Name="ResizeGrip",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(3),1,-px(3)),Size=UDim2.fromOffset(gs,gs),BackgroundTransparency=1,AutoButtonColor=false,Text="",ZIndex=25,},window)local gi=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(13)),even(px(13))),BackgroundTransparency=1,Image=ICON["move-diagonal-2"],ImageColor3=T.muted,ImageTransparency=0.45,ZIndex=25,},grip)local active,startPos,startSize,startCenter local function lit(on)tween(gi,0.15,{ImageTransparency=on and 0 or 0.45,ImageColor3=on and T.text or T.muted})end if HOVER then STATE.connect(grip.MouseEnter,function()lit(true)end)STATE.connect(grip.MouseLeave,function()if not active then lit(false)end end)end STATE.connect(grip.InputBegan,function(input)if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end if active then return end active,startPos,startSize,startCenter=input,input.Position,T.size,WIN.center()lit(true)end)STATE.connect(UIS.InputChanged,function(input)if not active then return end local isTouch=input.UserInputType==Enum.UserInputType.Touch if isTouch and input~=active then return end if not isTouch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end local d=Vector2.new(input.Position.X-startPos.X,input.Position.Y-startPos.Y)/userScale WIN.setSize(startSize+d)WIN.place(startCenter+(T.size-startSize)*userScale/2)end)STATE.connect(UIS.InputEnded,function(input)if not active then return end if input~=active and not(active.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1)then return end active=nil lit(false)WIN.save()end)end local K={groupGap=px(16),caption=px(12),captionH=px(26),rowMin=even(px(58)),rowPad=px(16),vPad=px(13),title=px(15),desc=px(13),radius=px(12),ctrlH=even(px(34)),}local tabs,tabOrder,selectedTab={},{},nil local currentPage local function placePage(page,animate)local tab=page.tab local top=L.header+(#tab.secOrder>=2 and(L.segH+px(14))or 0)if page.tw then page.tw:Cancel()page.tw=nil end page.wrap.Size=UDim2.new(1,0,1,-top)if animate then page.wrap.Position=UDim2.fromOffset(0,top+px(16))page.wrap.GroupTransparency=1 page.tw=tween(page.wrap,0.42,{Position=UDim2.fromOffset(0,top),GroupTransparency=0})else page.wrap.Position=UDim2.fromOffset(0,top)page.wrap.GroupTransparency=0 end end local function showPage(page)if closePopup then closePopup()end if currentPage==page then if page then placePage(page,false)end return end if currentPage then currentPage.wrap.Visible=false end currentPage=page if page then page.wrap.Visible=true page.scroll.CanvasPosition=Vector2.new()placePage(page,true)if page.onShow then task.spawn(page.onShow)end end end local function paintNav(tab,t)local on=selectedTab==tab tween(tab.navIcon,t,{ImageColor3=on and C.accent or(tab.hover and T.text or T.subtext)})tween(tab.navLabel,t,{TextColor3=(on or tab.hover)and T.text or T.subtext})tween(tab.navHover,t,{BackgroundTransparency=(tab.hover and not on)and 0 or 1})end local function setHeader(tab)headIcon.Image=tab.icon headTitle.Text=tab.name headTitle.TextTransparency,headIcon.ImageTransparency=1,1 headTitle.Position=TITLE_POS+UDim2.fromOffset(px(10),0)tween(headTitle,0.35,{TextTransparency=0,Position=TITLE_POS})tween(headIcon,0.35,{ImageTransparency=0})end local function pillX(tab,sec)local x=px(3)for _,s in ipairs(tab.secOrder)do if s==sec then return x end x+=s.pillW+px(2)end return x end local function refreshSeg(tab,animate)if not tab.seg then return end local show=#tab.secOrder>=2 tab.seg.Visible=show and selectedTab==tab if show and tab.selected then local goal={Position=UDim2.fromOffset(pillX(tab,tab.selected),px(3)),Size=UDim2.fromOffset(tab.selected.pillW,L.segH-px(6)),}if animate then tween(tab.segHl,0.35,goal)else tab.segHl.Position,tab.segHl.Size=goal.Position,goal.Size end end end local function paintPill(sec,t)local on=sec.tab.selected==sec tween(sec.pillLabel,t or 0.2,{TextColor3=on and T.text or(sec.hover and T.text or T.subtext)})tween(sec.pillIcon,t or 0.2,{ImageColor3=on and C.accent or T.muted})end local function selectTab(name)local tab=tabs[name]if not tab or selectedTab==tab then return end local prev=selectedTab selectedTab=tab if prev then paintNav(prev,0.2)if prev.seg then prev.seg.Visible=false end end paintNav(tab,0.2)local rank=0 for _,t in ipairs(tabOrder)do local a,b=t.nav.LayoutOrder,tab.nav.LayoutOrder if t~=tab and(a<b or(a==b and t.index<tab.index))then rank+=1 end end local y=rank*(L.navH+L.navGap)navHl.Visible=true if prev then tween(navHl,0.38,{Position=UDim2.fromOffset(0,y)})local squeeze=tween(navBar,0.12,{Size=UDim2.fromOffset(px(3),math.floor(navBarH/2))})squeeze.Completed:Once(function()tween(navBar,0.3,{Size=UDim2.fromOffset(px(3),navBarH)},Enum.EasingStyle.Back)end)else navHl.Position=UDim2.fromOffset(0,y)end if tab.iconScale then tab.iconScale.Scale=0.8 tween(tab.iconScale,0.4,{Scale=1},Enum.EasingStyle.Back)end setHeader(tab)refreshSeg(tab,false)showPage(tab.selected and tab.selected.page)end local function selectSection(tabName,name)local tab=tabs[tabName]local sec=tab and tab.sections[name]if not sec or tab.selected==sec then return end local prev=tab.selected tab.selected=sec if prev then paintPill(prev)end paintPill(sec)refreshSeg(tab,true)if selectedTab==tab then showPage(sec.page)end end local collapsed=false local function addTab(name,iconId)local index=#tabOrder+1 local btn=new("TextButton",{Name=name,LayoutOrder=index,Size=UDim2.new(1,0,0,L.navH),BackgroundTransparency=1,AutoButtonColor=false,Text="",},navList)local hover=new("Frame",{Name="Hover",Size=UDim2.fromScale(1,1),BackgroundColor3=T.rowHover,BackgroundTransparency=1},btn)corner(hover,px(10))local img=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromOffset(NAV_ICON_X+L.navIcon/2,L.navH/2),Size=UDim2.fromOffset(L.navIcon,L.navIcon),BackgroundTransparency=1,Image=iconId,ImageColor3=T.subtext,},btn)local iconScale=new("UIScale",{},img)local label=new("TextLabel",{Position=UDim2.fromOffset(NAV_LABEL_X,0),Size=UDim2.new(1,-(NAV_LABEL_X+px(8)),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=L.navText,TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,TextTransparency=collapsed and 1 or 0,Text=name,},btn)local tab={name=name,index=index,icon=iconId,nav=btn,navIcon=img,navLabel=label,navHover=hover,iconScale=iconScale,sections={},secOrder={},}tabs[name]=tab table.insert(tabOrder,tab)STATE.connect(btn.MouseEnter,function()tab.hover=true paintNav(tab,0.15)end)STATE.connect(btn.MouseLeave,function()tab.hover=false paintNav(tab,0.2)end)STATE.connect(btn.MouseButton1Click,function()selectTab(name)end)return tab end local function ensureSeg(tab)if tab.seg then return end local seg=new("Frame",{Name="Sections",Position=UDim2.fromOffset(PAD,L.header),Size=UDim2.fromOffset(0,L.segH),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=T.field,Visible=false,},content)corner(seg,px(10))stroke(seg,T.fieldLine)local hl=new("Frame",{Name="Highlight",Position=UDim2.fromOffset(px(3),px(3)),Size=UDim2.fromOffset(0,L.segH-px(6)),BackgroundColor3=T.rowActive,},seg)corner(hl,px(8))stroke(hl,T.fieldLineHot,0.5)local list=new("Frame",{Name="List",Size=UDim2.fromOffset(0,L.segH),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,},seg)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(2)),SortOrder=Enum.SortOrder.LayoutOrder,},list)new("UIPadding",{PaddingLeft=UDim.new(0,px(3)),PaddingRight=UDim.new(0,px(3))},list)tab.seg,tab.segHl,tab.segList=seg,hl,list end local function makePage(tab,sec)local wrap=new("CanvasGroup",{Name=tab.name.."/"..sec.name,Position=UDim2.fromOffset(0,L.header),Size=UDim2.new(1,0,1,-L.header),BackgroundTransparency=1,Visible=false,},content)local scroll=new("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=px(4),ScrollBarImageColor3=T.fieldLineHot,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,},wrap)local body=new("Frame",{Name="Body",Position=UDim2.fromOffset(PAD,0),Size=UDim2.new(1,-PAD*2,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},scroll)new("UIListLayout",{Padding=UDim.new(0,K.groupGap),SortOrder=Enum.SortOrder.LayoutOrder},body)new("UIPadding",{PaddingTop=UDim.new(0,px(4)),PaddingBottom=UDim.new(0,px(24))},body)return{tab=tab,sec=sec,wrap=wrap,scroll=scroll,body=body,groups=0,rows={},groupList={}}end local function addSection(tab,name,iconId)if tab.sections[name]then return tab.sections[name]end ensureSeg(tab)local iconS=even(px(14))local labelW=textW(name,px(13),T.fontSemi)local pillW=px(12)+iconS+px(7)+labelW+px(14)local pill=new("TextButton",{Name=name,LayoutOrder=#tab.secOrder+1,Size=UDim2.fromOffset(pillW,L.segH-px(6)),BackgroundTransparency=1,AutoButtonColor=false,Text="",},tab.segList)local pIcon=new("ImageLabel",{Position=UDim2.fromOffset(px(12),math.floor((L.segH-px(6)-iconS)/2)),Size=UDim2.fromOffset(iconS,iconS),BackgroundTransparency=1,Image=iconId,ImageColor3=T.muted,},pill)local pLabel=new("TextLabel",{Position=UDim2.fromOffset(px(12)+iconS+px(7),0),Size=UDim2.new(0,labelW+px(4),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(13),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,Text=name,},pill)local sec={name=name,tab=tab,pill=pill,pillIcon=pIcon,pillLabel=pLabel,pillW=pillW}sec.icon=pIcon sec.page=makePage(tab,sec)tab.sections[name]=sec table.insert(tab.secOrder,sec)STATE.connect(pill.MouseEnter,function()sec.hover=true paintPill(sec,0.15)end)STATE.connect(pill.MouseLeave,function()sec.hover=false paintPill(sec,0.2)end)STATE.connect(pill.MouseButton1Click,function()selectSection(tab.name,name)end)if not tab.selected then tab.selected=sec end paintPill(sec,0)if selectedTab==tab then refreshSeg(tab,false)if currentPage then placePage(currentPage,false)else showPage(tab.selected.page)end end return sec end local function setCollapsed(on,remember)collapsed=on==true if remember then prefs.collapsed=collapsed savePrefs()end local swap=tween(colIcon,0.1,{ImageTransparency=1})swap.Completed:Once(function()colIcon.Image=collapsed and ICON["panel-left-open"]or ICON["panel-left-close"]tween(colIcon,0.15,{ImageTransparency=0})end)local w=collapsed and L.narrow or L.side local t=0.38 local a=collapsed and 1 or 0 tween(sidebar,t,{Size=UDim2.new(0,w,1,0)})tween(content,t,{Position=UDim2.fromOffset(w,0),Size=UDim2.new(1,-w,1,0)})tween(brandTitle,t*0.5,{TextTransparency=a})tween(brandSub,t*0.5,{TextTransparency=a})local badgeStroke=brandBadge:FindFirstChildOfClass("UIStroke")if collapsed then brandBadge.Visible=true end tween(brandBadge,t*0.6,{GroupTransparency=1-a})if badgeStroke then tween(badgeStroke,t*0.6,{Transparency=collapsed and 0.6 or 1})end if not collapsed then task.delay(t*0.6,function()if not collapsed then brandBadge.Visible=false end end)end tween(profName,t*0.5,{TextTransparency=a})tween(profSub,t*0.5,{TextTransparency=a})tween(profChev,t*0.5,{ImageTransparency=a})tween(pfp,t,{Position=UDim2.fromOffset(collapsed and AV_X_NARROW or AV_X,math.floor((L.profileH-avS)/2))})for _,tab in ipairs(tabOrder)do tween(tab.navLabel,t*0.5,{TextTransparency=a})end end STATE.connect(colBtn.MouseButton1Click,function()setCollapsed(not collapsed,true)end)if prefs.collapsed or(prefs.collapsed==nil and DEVICE=="Phone")then setCollapsed(true,false)end local CTRL={list={},byId={},hooks={},muted=false,swallow=false}do local function copy(v)return type(v)=="table"and table.clone(v)or v end function CTRL.register(kind,g,title,obj,r,o)local tab,sec=g.page.tab,g.page.sec local base=tostring(o.Flag or(tab.name.."/"..sec.name.."/"..title))local id,n=base,1 while CTRL.byId[id]do n+=1 id=base.."#"..n end local e={id=id,kind=kind,title=title,obj=obj,row=r,g=g,tab=tab,sec=sec,config=o.Config~=false and kind~="button",}e.default=copy(CTRL.get(e))CTRL.byId[id]=e table.insert(CTRL.list,e)if CTRL.attach then CTRL.attach(e)end return e end function CTRL.get(e)local v=e.obj and e.obj.Value if e.kind=="keybind"then return v or false end if e.kind=="button"then return nil end return copy(v)end function CTRL.set(e,v)if e.kind=="toggle"then e.obj:Set(v==true)elseif e.kind=="slider"then if tonumber(v)then e.obj:Set(tonumber(v))end elseif e.kind=="dropdown"then e.obj:Select(v)elseif e.kind=="keybind"then e.obj:Set(v~=false and v or nil)elseif e.kind=="input"then e.obj:Set(v)end end function CTRL.onChange(fn)table.insert(CTRL.hooks,fn)end function CTRL.changed(e)if not e then return end for _,fn in ipairs(CTRL.hooks)do pcall(fn,e,CTRL.muted)end end function CTRL.pointOf(input)if input.UserInputType==Enum.UserInputType.Touch then local inset=game:GetService("GuiService"):GetGuiInset()return Vector2.new(input.Position.X+inset.X,input.Position.Y+inset.Y)end return UIS:GetMouseLocation()end function CTRL.activeCount()local n=0 for _,e in ipairs(CTRL.list)do if e.kind=="toggle"and e.obj.Value and e.row.Parent then n+=1 end end return n end end local function group(page,caption)page.groups+=1 local holder=new("Frame",{Name=caption or"Group",LayoutOrder=page.groups,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},page.body)new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},holder)local card=new("Frame",{Name="Card",LayoutOrder=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.card,},holder)corner(card,K.radius)local cardStroke=stroke(card,T.cardLine)local cardLayout=new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},card)local g={page=page,card=card,holder=holder,rows=0,folded=false}table.insert(page.groupList,g)if caption then local key=page.tab.name.."/"..page.sec.name.."/"..caption local cap=new("TextButton",{Name="Caption",LayoutOrder=0,Size=UDim2.new(1,0,0,K.captionH),BackgroundTransparency=1,AutoButtonColor=false,Text="",},holder)local capLabel=new("TextLabel",{Size=UDim2.new(1,-px(24),1,0),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=K.caption,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Text=caption:upper(),},cap)local chevS=even(px(13))local chev=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(1,-px(10),0,-px(1)),Size=UDim2.fromOffset(chevS,chevS),BackgroundTransparency=1,Image=ICON["chevron-down"],ImageColor3=T.muted,},cap)local busy=0 function g.setFolded(on,animate)g.folded=on prefs.groups=type(prefs.groups)=="table"and prefs.groups or{}prefs.groups[key]=on or nil tween(chev,animate and 0.3 or 0,{Rotation=on and-90 or 0})busy+=1 local token=busy local s=math.max(pop.Scale,0.01)if on then local h=card.AbsoluteSize.Y/s card.AutomaticSize=Enum.AutomaticSize.None card.ClipsDescendants=true card.Size=UDim2.new(1,0,0,h)if not animate then card.Size,card.Visible=UDim2.new(1,0,0,0),false return end tween(cardStroke,0.2,{Transparency=1})local tw=tween(card,0.32,{Size=UDim2.new(1,0,0,0)})tw.Completed:Once(function()if busy==token and g.folded then card.Visible=false end end)else card.Visible=true card.ClipsDescendants=true task.spawn(function()RunService.Heartbeat:Wait()if busy~=token then return end local h=cardLayout.AbsoluteContentSize.Y/math.max(pop.Scale,0.01)cardStroke.Transparency=0 local tw=tween(card,animate and 0.36 or 0,{Size=UDim2.new(1,0,0,h)})tw.Completed:Once(function()if busy~=token or g.folded then return end card.AutomaticSize=Enum.AutomaticSize.Y card.ClipsDescendants=false end)end)end end function g.expand()if g.folded then g.setFolded(false,true)savePrefs()end end STATE.connect(cap.MouseButton1Click,function()g.setFolded(not g.folded,true)savePrefs()end)if HOVER then STATE.connect(cap.MouseEnter,function()tween(capLabel,0.15,{TextColor3=T.subtext})tween(chev,0.15,{ImageColor3=T.subtext})end)STATE.connect(cap.MouseLeave,function()tween(capLabel,0.2,{TextColor3=T.muted})tween(chev,0.2,{ImageColor3=T.muted})end)end if type(prefs.groups)=="table"and prefs.groups[key]then task.defer(function()g.setFolded(true,false)end)end end return g end local function row(g,title,desc,tags)g.rows+=1 local r=new("Frame",{Name=title,LayoutOrder=g.rows,Size=UDim2.new(1,0,0,K.rowMin),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},g.card)local hover=new("Frame",{Name="Hover",Position=UDim2.fromOffset(px(4),px(4)),Size=UDim2.new(1,-px(8),1,-px(8)),BackgroundColor3=T.rowHover,BackgroundTransparency=1,},r)corner(hover,K.radius-px(4))if g.rows>1 then new("Frame",{Name="Line",Position=UDim2.fromOffset(K.rowPad,0),Size=UDim2.new(1,-K.rowPad*2,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},r)end local slot=new("Frame",{Name="Control",AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-K.rowPad,0,0),Size=UDim2.fromOffset(0,K.ctrlH),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,ZIndex=2,},r)local col=new("Frame",{Name="Text",Position=UDim2.fromOffset(K.rowPad,0),Size=UDim2.new(1,-K.rowPad*2,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,ZIndex=6,},r)new("UIPadding",{PaddingTop=UDim.new(0,K.vPad),PaddingBottom=UDim.new(0,K.vPad)},col)new("UIListLayout",{Padding=UDim.new(0,px(3)),SortOrder=Enum.SortOrder.LayoutOrder},col)local line1=new("Frame",{Name="TitleLine",LayoutOrder=1,Size=UDim2.new(1,0,0,K.title+px(6)),BackgroundTransparency=1},col)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(7)),SortOrder=Enum.SortOrder.LayoutOrder},line1)local titleLabel=new("TextLabel",{Name="Title",LayoutOrder=0,Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=K.title,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=title,},line1)for i,t in ipairs(tags or{})do tag(line1,t,nil,i)end local descLabel if desc and desc~=""then descLabel=new("TextLabel",{Name="Desc",LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=K.desc,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text=desc,},col)end local function fit()local s=pop.Scale local cw=math.floor(slot.AbsoluteSize.X/s+0.5)col.Size=UDim2.new(1,-(K.rowPad*2+(cw>0 and cw+px(16)or 0)),0,0)local rh=math.floor(r.AbsoluteSize.Y/s+0.5)slot.Position=UDim2.new(1,-K.rowPad,0,math.floor((math.max(rh,K.rowMin)-K.ctrlH)/2))end STATE.connect(slot:GetPropertyChangedSignal("AbsoluteSize"),fit)STATE.connect(r:GetPropertyChangedSignal("AbsoluteSize"),fit)if HOVER then STATE.connect(r.MouseEnter,function()tween(hover,0.15,{BackgroundTransparency=0})end)STATE.connect(r.MouseLeave,function()tween(hover,0.25,{BackgroundTransparency=1})end)end task.defer(fit)table.insert(g.page.rows,{r=r,g=g,title=title,desc=(desc and desc:match("%S"))and desc or""})return r,slot,titleLabel,descLabel end local function rowHit(r)return new("TextButton",{Name="Hit",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,AutoButtonColor=false,Text="",ZIndex=5,},r)end local function toggle(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local tw_,th=even(px(44)),even(px(24))local inset=px(3)local ks=th-inset*2 local OFF_KNOB=Color3.fromRGB(196,202,216)local track=new("Frame",{Name="Switch",Position=UDim2.fromOffset(0,math.floor((K.ctrlH-th)/2)),Size=UDim2.fromOffset(tw_,th),BackgroundColor3=T.track,},slot)corner(track,th)local trackStroke=stroke(track,T.fieldLine)local knob=new("Frame",{Name="Knob",AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,inset,0.5,0),Size=UDim2.fromOffset(ks,ks),BackgroundColor3=OFF_KNOB,},track)corner(knob,ks)local hit=rowHit(r)local obj={Value=o.Value==true}local pressing=false local function paint(t)local on=obj.Value local goal={AnchorPoint=Vector2.new(on and 1 or 0,0.5),Position=UDim2.new(on and 1 or 0,on and-inset or inset,0.5,0),Size=UDim2.fromOffset(pressing and ks+px(6)or ks,ks),BackgroundColor3=on and knobOn()or OFF_KNOB,}if t<=0 then for k,v in pairs(goal)do knob[k]=v end track.BackgroundColor3=on and C.accent or T.track trackStroke.Color=on and C.accent or T.fieldLine return end tween(knob,t,goal)tween(track,t,{BackgroundColor3=on and C.accent or T.track})tween(trackStroke,t,{Color=on and C.accent or T.fieldLine})end function obj:Set(v)obj.Value=v==true paint(0.3)if o.Callback then task.spawn(o.Callback,obj.Value)end CTRL.changed(obj.entry)end paint(0)onThemeChanged(function()if track.Parent then paint(0.45)end end)STATE.connect(hit.MouseButton1Down,function()pressing=true paint(0.15)end)STATE.connect(hit.MouseLeave,function()if pressing then pressing=false paint(0.2)end end)STATE.connect(hit.MouseButton1Click,function()pressing=false if CTRL.swallow then paint(0.2)return end obj:Set(not obj.Value)end)obj.entry=CTRL.register("toggle",g,title,obj,r,o)return obj end local function decimals(step)local s=tostring(step)local d=s:match("%.(%d+)$")return d and#d or 0 end local function slider(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local v=type(o.Value)=="table"and o.Value or{}local min,max=tonumber(v.Min)or 0,tonumber(v.Max)or 100 local step=tonumber(o.Step)or 1 local dec=decimals(step)local suffix=o.Suffix or""local obj={Value=math.clamp(tonumber(v.Default)or min,min,max)}local trackW,valueW=px(190),px(60)local holder=new("Frame",{Size=UDim2.fromOffset(trackW+px(12)+valueW,K.ctrlH),BackgroundTransparency=1},slot)local hit=new("TextButton",{Name="Track",Size=UDim2.fromOffset(trackW,K.ctrlH),BackgroundTransparency=1,AutoButtonColor=false,Text=""},holder)local trackH=even(px(6))local track=new("Frame",{Position=UDim2.fromOffset(0,math.floor((K.ctrlH-trackH)/2)),Size=UDim2.fromOffset(trackW,trackH),BackgroundColor3=T.track,BorderSizePixel=0,},hit)corner(track,trackH)local fill=new("Frame",{Name="Fill",Size=UDim2.fromScale(0,1),BackgroundColor3=C.accent,BorderSizePixel=0},track)corner(fill,trackH)local knobS=even(px(16))local knob=new("Frame",{Name="Knob",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(knobS,knobS),BackgroundColor3=WHITE,BorderSizePixel=0,ZIndex=2,},track)corner(knob,knobS)local ring=stroke(knob,C.accent,0.55,0)local pillH=even(px(26))local pill=new("Frame",{Position=UDim2.fromOffset(trackW+px(12),math.floor((K.ctrlH-pillH)/2)),Size=UDim2.fromOffset(valueW,pillH),BackgroundColor3=T.field,},holder)corner(pill,px(7))local pillStroke=stroke(pill,T.fieldLine)local valueBox=new("TextBox",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.mono,TextSize=px(12),TextColor3=T.text,ClearTextOnFocus=false,Text="",ClipsDescendants=true,},pill)local function paint(t)local a=max>min and(obj.Value-min)/(max-min)or 0 tween(fill,t,{Size=UDim2.fromScale(a,1)})tween(knob,t,{Position=UDim2.new(a,0,0.5,0)})if not valueBox:IsFocused()then valueBox.Text=string.format("%."..dec.."f",obj.Value)..suffix end end local function snap(x)x=math.clamp(tonumber(x)or min,min,max)x=min+math.floor((x-min)/step+0.5)*step return math.clamp(tonumber(string.format("%."..dec.."f",x)),min,max)end function obj:Set(x)x=snap(x)local changed=x~=obj.Value obj.Value=x paint(0.12)if changed and o.Callback then task.spawn(o.Callback,x)end if changed then CTRL.changed(obj.entry)end end paint(0)STATE.connect(valueBox.Focused,function()valueBox.Text=string.format("%."..dec.."f",obj.Value)valueBox.CursorPosition,valueBox.SelectionStart=#valueBox.Text+1,1 tween(pillStroke,0.15,{Color=C.accent})tween(pill,0.15,{BackgroundColor3=T.fieldHot})end)STATE.connect(valueBox.FocusLost,function()tween(pillStroke,0.2,{Color=T.fieldLine})tween(pill,0.2,{BackgroundColor3=T.field})local n=tonumber((valueBox.Text:gsub("[^%d%.%-]","")))if n then obj:Set(n)end paint(0.12)end)local dragging,hovering=false,false local function rest()local big=dragging or hovering tween(knob,0.2,{Size=UDim2.fromOffset(big and knobS+px(2)or knobS,big and knobS+px(2)or knobS)})tween(ring,0.2,{Thickness=dragging and px(5)or(hovering and px(3)or 0)})end local function fromMouse(x)obj:Set(min+math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)*(max-min))end STATE.connect(hit.MouseEnter,function()hovering=true rest()end)STATE.connect(hit.MouseLeave,function()hovering=false rest()end)STATE.connect(hit.InputBegan,function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true rest()fromMouse(input.Position.X)end end)STATE.connect(UIS.InputChanged,function(input)if dragging and(input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)then fromMouse(input.Position.X)end end)STATE.connect(UIS.InputEnded,function(input)if dragging and(input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch)then dragging=false rest()end end)obj.Display=function()return string.format("%."..dec.."f",obj.Value)..suffix end obj.entry=CTRL.register("slider",g,title,obj,r,o)return obj end local openPopup closePopup=function()if openPopup then local p=openPopup openPopup=nil p.close()end end STATE.connect(UIS.InputBegan,function(input)if not openPopup then return end if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end local m=UIS:GetMouseLocation()if input.UserInputType==Enum.UserInputType.Touch then local inset=game:GetService("GuiService"):GetGuiInset()m=Vector2.new(input.Position.X+inset.X,input.Position.Y+inset.Y)end local function inside(el)local a,s=el.AbsolutePosition,el.AbsoluteSize return m.X>=a.X and m.X<=a.X+s.X and m.Y>=a.Y and m.Y<=a.Y+s.Y end if not(inside(openPopup.list)or inside(openPopup.field))then closePopup()end end)local function dropdown(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local obj={Values=o.Values or{}}local multi=o.Multi==true local chosen local function setChosen(v)if multi then chosen={}if type(v)=="table"then for k,x in pairs(v)do local label=(type(k)=="string"and x==true)and k or x if label~=nil then chosen[label]=true end end elseif v~=nil then chosen[v]=true end else chosen=v end end setChosen(o.Value)if not multi and chosen==nil and not o.AllowNone then chosen=obj.Values[1]end local width=px(200)local field=new("TextButton",{Name="Dropdown",Size=UDim2.fromOffset(width,K.ctrlH),BackgroundColor3=T.field,AutoButtonColor=false,Text=""},slot)corner(field,px(9))local fieldStroke=stroke(field,T.fieldLine)local text=new("TextLabel",{Position=UDim2.fromOffset(px(12),0),Size=UDim2.new(1,-px(38),1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,},field)local chevS2=even(px(14))local chev=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(1,-px(18),0.5,0),Size=UDim2.fromOffset(chevS2,chevS2),BackgroundTransparency=1,Image=ICON["chevron-down"],ImageColor3=T.subtext,},field)local isOpen=false STATE.connect(field.MouseEnter,function()if not isOpen then tween(fieldStroke,0.15,{Color=T.fieldLineHot})end tween(field,0.15,{BackgroundColor3=T.fieldHot})end)STATE.connect(field.MouseLeave,function()if not isOpen then tween(fieldStroke,0.2,{Color=T.fieldLine})end tween(field,0.2,{BackgroundColor3=T.field})end)local function list()local out={}for _,v in ipairs(obj.Values)do if chosen[v]then table.insert(out,v)end end return out end local function refresh()if not multi then text.Text=chosen~=nil and tostring(chosen)or"None"return end local l=list()if#l>1 and#l==#obj.Values then text.Text=("All selected (%d)"):format(#l)return end text.Text=#l==0 and"None"or(#l==1 and tostring(l[1])or("%s +%d"):format(tostring(l[1]),#l-1))end refresh()obj.Value=multi and list()or chosen local function fire()obj.Value=multi and list()or chosen if o.Callback then task.spawn(o.Callback,obj.Value)end CTRL.changed(obj.entry)end obj.Display=function()return text.Text end local itemH=even(px(34))local function open()closePopup()isOpen=true local pos,size=inWindow(field)local pad=px(6)local searchable=o.Search==true or(o.Search~=false and#obj.Values>5)local sbH=even(px(34))local toolH=even(px(28))local headH=(searchable and sbH+pad or 0)+(multi and toolH+pad or 0)local listW=math.max(size.X,px(260))local want=pad+headH+math.max(1,math.min(#obj.Values,7))*itemH+pad local below=T.size.Y-px(10)-(pos.Y+size.Y+px(6))local above=pos.Y-px(6)-px(10)local up=below<want and above>below local fullH=math.min(want,math.max(up and above or below,pad*2+headH+itemH*2))local rest=UDim2.fromOffset(pos.X+size.X,up and(pos.Y-px(6))or(pos.Y+size.Y+px(6)))local shift=UDim2.fromOffset(0,up and px(6)or-px(6))local listFrame=new("CanvasGroup",{Name="DropdownList",AnchorPoint=Vector2.new(1,up and 1 or 0),Position=rest+shift,Size=UDim2.fromOffset(listW,fullH),BackgroundColor3=T.popup,GroupTransparency=1,},overlay)corner(listFrame,px(10))local listStroke=stroke(listFrame,T.fieldLineHot,1)local y0=pad local query if searchable then local sb=new("Frame",{Position=UDim2.fromOffset(pad,y0),Size=UDim2.new(1,-pad*2,0,sbH),BackgroundColor3=T.field,},listFrame)corner(sb,px(8))local sbStroke=stroke(sb,T.fieldLine)local qi=even(px(14))local qIcon=new("ImageLabel",{Position=UDim2.fromOffset(px(10),math.floor((sbH-qi)/2)),Size=UDim2.fromOffset(qi,qi),BackgroundTransparency=1,Image=ICON.search,ImageColor3=T.muted,},sb)local qx=px(10)+qi+px(8)query=new("TextBox",{Position=UDim2.fromOffset(qx,0),Size=UDim2.new(1,-(qx+sbH),1,0),BackgroundTransparency=1,ClearTextOnFocus=false,FontFace=T.font,TextSize=px(13),TextColor3=T.text,PlaceholderText=("Search %d items..."):format(#obj.Values),PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true,},sb)local clearQ=new("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(4),0.5,0),Size=UDim2.fromOffset(sbH-px(8),sbH-px(8)),BackgroundColor3=T.fieldHot,BackgroundTransparency=1,AutoButtonColor=false,Text="",Visible=false,},sb)corner(clearQ,px(6))local cx=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(12)),even(px(12))),BackgroundTransparency=1,Image=ICON.x,ImageColor3=T.muted,},clearQ)clearQ.MouseEnter:Connect(function()tween(clearQ,0.12,{BackgroundTransparency=0})tween(cx,0.12,{ImageColor3=T.text})end)clearQ.MouseLeave:Connect(function()tween(clearQ,0.15,{BackgroundTransparency=1})tween(cx,0.15,{ImageColor3=T.muted})end)clearQ.MouseButton1Click:Connect(function()query.Text=""end)query.Focused:Connect(function()tween(sbStroke,0.15,{Color=C.accent})tween(qIcon,0.15,{ImageColor3=C.accent})end)query.FocusLost:Connect(function()tween(sbStroke,0.2,{Color=T.fieldLine})tween(qIcon,0.2,{ImageColor3=T.muted})end)query:GetPropertyChangedSignal("Text"):Connect(function()clearQ.Visible=query.Text~=""end)y0+=sbH+pad end local countLabel,allBtn,noneBtn if multi then local bar=new("Frame",{Position=UDim2.fromOffset(pad,y0),Size=UDim2.new(1,-pad*2,0,toolH),BackgroundTransparency=1},listFrame)countLabel=new("TextLabel",{Position=UDim2.fromOffset(px(4),0),Size=UDim2.new(0.45,0,1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},bar)local btns=new("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.fromOffset(0,toolH),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,},bar)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(6)),SortOrder=Enum.SortOrder.LayoutOrder,},btns)local function toolButton(order,label)local b=new("TextButton",{LayoutOrder=order,Size=UDim2.fromOffset(0,toolH),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=T.field,AutoButtonColor=false,FontFace=T.fontSemi,TextSize=px(12),TextColor3=T.text,Text=label,},btns)corner(b,px(7))local st=stroke(b,T.fieldLine)new("UIPadding",{PaddingLeft=UDim.new(0,px(10)),PaddingRight=UDim.new(0,px(10))},b)local tb={btn=b,stroke=st,enabled=true}b.MouseEnter:Connect(function()if tb.enabled then tween(b,0.12,{BackgroundColor3=T.fieldHot})tween(st,0.12,{Color=T.fieldLineHot})end end)b.MouseLeave:Connect(function()tween(b,0.15,{BackgroundColor3=T.field})tween(st,0.15,{Color=T.fieldLine})end)return tb end allBtn=toolButton(1,"Select all")noneBtn=toolButton(2,"Clear")y0+=toolH+pad end if headH>0 then new("Frame",{Position=UDim2.fromOffset(0,y0-math.ceil(pad/2)),Size=UDim2.new(1,0,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},listFrame)end local top=headH>0 and y0 or 0 local scroller=new("ScrollingFrame",{Position=UDim2.fromOffset(0,top),Size=UDim2.new(1,0,1,-top),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=px(3),ScrollBarImageColor3=T.fieldLineHot,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,},listFrame)new("UIPadding",{PaddingTop=UDim.new(0,headH>0 and px(2)or pad),PaddingBottom=UDim.new(0,pad),PaddingLeft=UDim.new(0,pad),PaddingRight=UDim.new(0,pad),},scroller)new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},scroller)local emptyLabel=new("TextLabel",{LayoutOrder=#obj.Values+1,Size=UDim2.new(1,0,0,itemH*1.5),BackgroundTransparency=1,Visible=#obj.Values==0,FontFace=T.font,TextSize=px(13),TextColor3=T.muted,Text=#obj.Values==0 and"Nothing to choose"or"No matches",},scroller)local items={}local function isOn(v)if multi then return chosen[v]==true end return chosen==v end local boxS=even(px(16))for i,v in ipairs(obj.Values)do local item=new("TextButton",{Name=tostring(v),LayoutOrder=i,Size=UDim2.new(1,0,0,itemH),BackgroundColor3=T.rowActive,BackgroundTransparency=1,AutoButtonColor=false,Text="",},scroller)corner(item,px(7))local textX=multi and(px(10)+boxS+px(10))or px(10)local itemText=new("TextLabel",{Position=UDim2.fromOffset(textX,0),Size=UDim2.new(1,-(textX+px(30)),1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=isOn(v)and T.text or T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=tostring(v),TextTransparency=1,},item)local it={item=item,v=v,label=tostring(v):lower()}if multi then local box=new("Frame",{Position=UDim2.fromOffset(px(10),math.floor((itemH-boxS)/2)),Size=UDim2.fromOffset(boxS,boxS),BackgroundColor3=T.field,},item)corner(box,px(4))local bst=stroke(box,T.fieldLineHot)local tick=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(11)),even(px(11))),BackgroundTransparency=1,Image=ICON.check,ImageColor3=onAccent(),ImageTransparency=1,},box)it.paint=function(t)local on=isOn(v)tick.ImageColor3=onAccent()tween(box,t,{BackgroundColor3=on and C.accent or T.field})tween(bst,t,{Color=on and C.accent or T.fieldLineHot})tween(tick,t,{ImageTransparency=on and 0 or 1})tween(itemText,t,{TextColor3=(on or it.hover)and T.text or T.subtext})end else local markS=even(px(14))local mark=new("ImageLabel",{Size=UDim2.fromOffset(markS,markS),Position=UDim2.new(1,-px(22),0,math.floor((itemH-markS)/2)),BackgroundTransparency=1,Image=ICON.check,ImageColor3=C.accent,ImageTransparency=1,},item)it.paint=function(t)local on=isOn(v)tween(mark,t,{ImageTransparency=on and 0 or 1})tween(itemText,t,{TextColor3=(on or it.hover)and T.text or T.subtext})end end it.paint(0)task.delay(0.02*math.min(i,8),function()if itemText.Parent then tween(itemText,0.25,{TextTransparency=0})end end)items[i]=it item.MouseEnter:Connect(function()it.hover=true tween(item,0.12,{BackgroundTransparency=0})it.paint(0.12)end)item.MouseLeave:Connect(function()it.hover=false tween(item,0.18,{BackgroundTransparency=1})it.paint(0.18)end)end local function updateTools()if not multi then return end local filtered=query~=nil and query.Text~=""local shown,shownOn=0,0 for _,it in ipairs(items)do if it.item.Visible then shown+=1 if chosen[it.v]then shownOn+=1 end end end countLabel.Text=("%d / %d selected"):format(#list(),#obj.Values)allBtn.btn.Text=filtered and"Select shown"or"Select all"noneBtn.btn.Text=filtered and"Clear shown"or"Clear"allBtn.enabled=shownOn<shown noneBtn.enabled=shownOn>0 for _,tb in ipairs({allBtn,noneBtn})do tween(tb.btn,0.15,{TextColor3=tb.enabled and T.text or T.muted,BackgroundTransparency=tb.enabled and 0 or 0.5})end end local function chooseShown(on)for _,it in ipairs(items)do if it.item.Visible then chosen[it.v]=on or nil it.paint(0.18)end end refresh()fire()updateTools()end if multi then allBtn.btn.MouseButton1Click:Connect(function()if allBtn.enabled then chooseShown(true)end end)noneBtn.btn.MouseButton1Click:Connect(function()if noneBtn.enabled then chooseShown(false)end end)end for _,it in ipairs(items)do it.item.MouseButton1Click:Connect(function()if multi then chosen[it.v]=not chosen[it.v]or nil it.paint(0.15)refresh()fire()updateTools()else chosen=it.v refresh()fire()closePopup()end end)end if query then query:GetPropertyChangedSignal("Text"):Connect(function()local q=query.Text:lower():gsub("^%s+",""):gsub("%s+$","")local any=false for _,it in ipairs(items)do it.item.Visible=q==""or it.label:find(q,1,true)~=nil any=any or it.item.Visible end emptyLabel.Visible=not any scroller.CanvasPosition=Vector2.new()updateTools()end)query.FocusLost:Connect(function(enter)if not enter or multi then return end for _,it in ipairs(items)do if it.item.Visible then chosen=it.v refresh()fire()closePopup()return end end end)if UIS.KeyboardEnabled then task.defer(function()if query.Parent then query:CaptureFocus()end end)end end updateTools()tween(listFrame,0.3,{Position=rest})tween(listFrame,0.2,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(listStroke,0.2,{Transparency=0})tween(chev,0.28,{Rotation=180})tween(fieldStroke,0.15,{Color=C.accent})openPopup={list=listFrame,field=field,close=function()isOpen=false if query and query:IsFocused()then query:ReleaseFocus()end tween(chev,0.22,{Rotation=0})tween(fieldStroke,0.2,{Color=T.fieldLine})tween(listStroke,0.15,{Transparency=1})tween(listFrame,0.18,{Position=rest+shift})local tw=tween(listFrame,0.15,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()listFrame:Destroy()end)end,}end STATE.connect(field.MouseButton1Click,function()if CTRL.swallow then return end if openPopup and openPopup.field==field then closePopup()else open()end end)function obj:Select(v)setChosen(v)refresh()fire()end function obj:Refresh(values)obj.Values=values or{}if multi then local keep={}for _,x in ipairs(obj.Values)do if chosen[x]then keep[x]=true end end chosen=keep elseif not table.find(obj.Values,chosen)then chosen=obj.Values[1]end refresh()end function obj:SelectAll()if not multi then return end if openPopup and openPopup.field==field then closePopup()end for _,v in ipairs(obj.Values)do chosen[v]=true end refresh()fire()end function obj:Clear()if openPopup and openPopup.field==field then closePopup()end if multi then chosen={}else chosen=nil end refresh()fire()end obj.entry=CTRL.register("dropdown",g,title,obj,r,o)return obj end local KEYNAMES={LeftShift="LShift",RightShift="RShift",LeftControl="LCtrl",RightControl="RCtrl",LeftAlt="LAlt",RightAlt="RAlt",MouseButton2="RMB",MouseButton3="MMB"}local function keybind(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local obj={Value=typeof(o.Value)=="EnumItem"and o.Value.Name or o.Value,Picking=false}local btn=new("TextButton",{Name="Keybind",Size=UDim2.fromOffset(px(96),K.ctrlH),BackgroundColor3=T.field,AutoButtonColor=false,Text=""},slot)corner(btn,px(9))local st=stroke(btn,T.fieldLine)local label=new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.mono,TextSize=px(12),TextColor3=T.text},btn)local function paint()if obj.Picking then label.Text,label.TextColor3="...",C.accent else label.Text=obj.Value and(KEYNAMES[obj.Value]or obj.Value)or"None"label.TextColor3=obj.Value and T.text or T.muted end tween(st,0.2,{Color=obj.Picking and C.accent or T.fieldLine})tween(btn,0.2,{BackgroundColor3=obj.Picking and T.fieldHot or T.field})end function obj:Set(k)obj.Value=typeof(k)=="EnumItem"and k.Name or((type(k)=="string"and k~="")and k or nil)paint()if o.Callback then task.spawn(o.Callback,obj.Value)end CTRL.changed(obj.entry)end obj.Display=function()return label.Text end paint()STATE.connect(btn.MouseEnter,function()if not obj.Picking then tween(st,0.15,{Color=T.fieldLineHot})end end)STATE.connect(btn.MouseLeave,function()if not obj.Picking then tween(st,0.2,{Color=T.fieldLine})end end)STATE.connect(btn.MouseButton1Click,function()if obj.Picking then return end obj.Picking=true capture.active=true paint()end)STATE.connect(UIS.InputBegan,function(input)if not obj.Picking then return end local kc=input.KeyCode local mb=input.UserInputType==Enum.UserInputType.MouseButton2 or input.UserInputType==Enum.UserInputType.MouseButton3 if kc==Enum.KeyCode.Unknown and not mb then return end task.defer(function()obj.Picking=false capture.active=false paint()end)if kc==Enum.KeyCode.Escape then return end if kc==Enum.KeyCode.Backspace then obj:Set(nil)return end obj.Value=mb and input.UserInputType.Name or kc.Name if o.Callback then task.spawn(o.Callback,obj.Value)end CTRL.changed(obj.entry)end)obj.entry=CTRL.register("keybind",g,title,obj,r,o)return obj end local function paragraph(g,o)local title,tags=parseTitle(o.Title)local _,_,titleLabel,descLabel=row(g,title,(o.Desc and o.Desc~="")and o.Desc or" ",tags)local obj={}function obj:SetDesc(t)if descLabel then descLabel.Text=tostring(t or"")end end function obj:SetTitle(t)titleLabel.Text=(parseTitle(t))end return obj end local function input(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local f=new("Frame",{Name="Input",Size=UDim2.fromOffset(px(o.Width or 200),K.ctrlH),BackgroundColor3=T.field},slot)corner(f,px(9))local st=stroke(f,T.fieldLine)local box=new("TextBox",{Position=UDim2.fromOffset(px(10),0),Size=UDim2.new(1,-px(20),1,0),BackgroundTransparency=1,ClearTextOnFocus=o.ClearOnFocus==true,FontFace=T.font,TextSize=px(13),TextColor3=T.text,PlaceholderText=tostring(o.Placeholder or""),PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true,},f)local function clean(v)if o.Numeric then local n=tonumber(v)or tonumber(o.Value)or tonumber(o.Min)or 0 if tonumber(o.Min)then n=math.max(n,tonumber(o.Min))end if tonumber(o.Max)then n=math.min(n,tonumber(o.Max))end return n end v=tostring(v==nil and""or v)local m=tonumber(o.MaxLength)if m and#v>m then v=v:sub(1,m)end return v end local obj={Value=clean(o.Value)}box.Text=tostring(obj.Value)local function commit(fire)local v=clean(box.Text)local changed=v~=obj.Value obj.Value=v if not box:IsFocused()then box.Text=tostring(v)end if fire and o.Callback then task.spawn(o.Callback,v)end if changed then CTRL.changed(obj.entry)end end function obj:Set(v)box.Text=tostring(clean(v))commit(true)end function obj:Get()return obj.Value end obj.Display=function()return tostring(obj.Value)end obj.Box=box STATE.connect(box.Focused,function()tween(st,0.15,{Color=C.accent})tween(f,0.15,{BackgroundColor3=T.fieldHot})end)STATE.connect(box.FocusLost,function()tween(st,0.2,{Color=T.fieldLine})tween(f,0.2,{BackgroundColor3=T.field})if not o.Live then commit(true)end end)if o.Live then STATE.connect(box:GetPropertyChangedSignal("Text"),function()if box:IsFocused()then commit(true)end end)end obj.entry=CTRL.register("input",g,title,obj,r,o)return obj end local function keyValue(g,o)local title,tags=parseTitle(o.Title)local _,slot=row(g,title,o.Desc,tags)local val=new("TextLabel",{Size=UDim2.fromOffset(0,K.ctrlH),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,FontFace=T.mono,TextSize=px(13),TextColor3=o.Color or T.subtext,TextXAlignment=Enum.TextXAlignment.Right,Text=tostring(o.Value==nil and""or o.Value),},slot)local obj={Value=o.Value,Label=val}function obj:Set(v)obj.Value=v val.Text=tostring(v==nil and""or v)end function obj:Get()return obj.Value end function obj:SetColor(c)val.TextColor3=c end return obj end local function label(g,o)g.rows+=1 local f=new("Frame",{Name="Label",LayoutOrder=g.rows,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},g.card)if g.rows>1 then new("Frame",{Name="Line",Position=UDim2.fromOffset(K.rowPad,0),Size=UDim2.new(1,-K.rowPad*2,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},f)end new("UIPadding",{PaddingTop=UDim.new(0,px(11)),PaddingBottom=UDim.new(0,px(11)),PaddingLeft=UDim.new(0,K.rowPad),PaddingRight=UDim.new(0,K.rowPad),},f)local text=tostring(o.Text or o.Title or"")local l=new("TextLabel",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=o.Bold and T.fontSemi or T.font,TextSize=K.desc+1,TextColor3=o.Color or T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,RichText=true,Text=text,},f)table.insert(g.page.rows,{r=f,g=g,title=text:gsub("<[^>]+>",""),desc=""})local obj={Frame=f,Label=l}function obj:Set(t)l.Text=tostring(t==nil and""or t)end function obj:SetColor(c)l.TextColor3=c end return obj end local function button(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local s=K.ctrlH local b=new("Frame",{Name="Run",Size=UDim2.fromOffset(s,s),BackgroundColor3=T.field},slot)corner(b,px(9))local st=stroke(b,T.fieldLine)local icS=even(px(15))local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=icon(o.Icon or"play"),ImageColor3=T.subtext,},b)local icScale=new("UIScale",{},ic)local hit=rowHit(r)STATE.connect(hit.MouseEnter,function()tween(b,0.15,{BackgroundColor3=T.fieldHot})tween(st,0.15,{Color=C.accent,Transparency=0.4})tween(ic,0.15,{ImageColor3=C.accent})end)STATE.connect(hit.MouseLeave,function()tween(b,0.2,{BackgroundColor3=T.field})tween(st,0.2,{Color=T.fieldLine,Transparency=0})tween(ic,0.2,{ImageColor3=T.subtext})tween(icScale,0.2,{Scale=1})end)local obj={}function obj.Run()tween(icScale,0.4,{Scale=1},Enum.EasingStyle.Back)b.BackgroundColor3=C.accent:Lerp(T.field,0.55)tween(b,0.45,{BackgroundColor3=T.fieldHot})if o.Callback then task.spawn(o.Callback)end end STATE.connect(hit.MouseButton1Down,function()tween(icScale,0.1,{Scale=0.82})end)STATE.connect(hit.MouseButton1Click,function()if CTRL.swallow then tween(icScale,0.2,{Scale=1})return end obj.Run()end)obj.entry=CTRL.register("button",g,title,obj,r,o)return obj end local FADE={}do local TEXT={"BackgroundTransparency","TextTransparency","TextStrokeTransparency"}local IMAGE={"BackgroundTransparency","ImageTransparency"}local PROPS={Frame={"BackgroundTransparency"},TextLabel=TEXT,TextButton=TEXT,TextBox=TEXT,ImageLabel=IMAGE,ImageButton=IMAGE,UIStroke={"Transparency"},ScrollingFrame={"BackgroundTransparency","ScrollBarImageTransparency"},}local base=setmetatable({},{__mode="k"})local function each(root,fn)local list=root:GetDescendants()table.insert(list,root)for _,inst in ipairs(list)do local ps=PROPS[inst.ClassName]if ps then local b=base[inst]if not b then b={}for _,p in ipairs(ps)do local ok,v=pcall(function()return inst[p]end)if ok and type(v)=="number"then b[p]=v end end base[inst]=b end fn(inst,b)end end end function FADE.hide(root)each(root,function(inst,b)for p in pairs(b)do inst[p]=1 end end)end function FADE.show(root,t,style)each(root,function(inst,b)local goal,any={},false for p,v in pairs(b)do if v<1 then goal[p],any=v,true end end if any then tween(inst,t,goal,style)end end)end function FADE.out(root,t,style)each(root,function(inst,b)local goal,any={},false for p in pairs(b)do if inst[p]<1 then goal[p],any=1,true end end if any then tween(inst,t,goal,style)end end)end end local notify do local toastHolder=new("Frame",{Name="Toasts",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(20),1,-px(20)),Size=UDim2.fromOffset(px(330),0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},gui)new("UIListLayout",{Padding=UDim.new(0,px(10)),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Bottom},toastHolder)local toastN=0 local function toastColor(name)if name=="check"or name=="package-check"or name=="circle-check"then return C.green end if name=="triangle-alert"or name=="alert-triangle"then return C.amber end if name=="x"then return C.red end return C.accent end function notify(o)toastN+=1 local col=toastColor(o.Icon)local wrap=new("Frame",{LayoutOrder=toastN,Size=UDim2.new(1,0,0,0),BackgroundTransparency=1},toastHolder)local box=new("Frame",{Position=UDim2.fromOffset(px(36),0),Size=UDim2.fromScale(1,1),BackgroundTransparency=1},wrap)new("ImageLabel",{Name="Shadow",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,px(6)),Size=UDim2.new(1,px(54),1,px(54)),BackgroundTransparency=1,Image=SHADOW_IMAGE,ImageColor3=Color3.new(0,0,0),ImageTransparency=0.5,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(99,99,99,99),},box)local card=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.popup},box)corner(card,px(14))stroke(card,T.fieldLine,0)local inner=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},card)new("UIPadding",{PaddingTop=UDim.new(0,px(14)),PaddingBottom=UDim.new(0,px(20)),PaddingLeft=UDim.new(0,px(56)),PaddingRight=UDim.new(0,px(16))},inner)new("UIListLayout",{Padding=UDim.new(0,px(3)),SortOrder=Enum.SortOrder.LayoutOrder},inner)local badgeS=even(px(30))local badge=new("Frame",{Position=UDim2.fromOffset(px(14),px(14)),Size=UDim2.fromOffset(badgeS,badgeS),BackgroundColor3=col,BackgroundTransparency=0.84},card)corner(badge,px(9))new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(15)),even(px(15))),BackgroundTransparency=1,Image=icon(o.Icon),ImageColor3=col:Lerp(WHITE,0.15),},badge)new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,px(18)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(14),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=tostring(o.Title or"SPECTREWARE"),},inner)if o.Content and o.Content~=""then new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,LineHeight=1.08,Text=tostring(o.Content),},inner)end local duration=tonumber(o.Duration)or 4 local track=new("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,px(14),1,-px(8)),Size=UDim2.new(1,-px(28),0,px(3)),BackgroundColor3=col,BackgroundTransparency=0.85,BorderSizePixel=0,},card)new("UICorner",{CornerRadius=UDim.new(1,0)},track)local bar=new("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=col,BackgroundTransparency=0.1,BorderSizePixel=0},track)new("UICorner",{CornerRadius=UDim.new(1,0)},bar)local hit=new("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=3},card)local gone=false local function fit()if not gone then wrap.Size=UDim2.new(1,0,0,heightOf(card))end end card:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)fit()FADE.hide(box)FADE.show(box,0.3,Enum.EasingStyle.Quad)tween(box,0.55,{Position=UDim2.fromOffset(0,0)})tween(bar,duration,{Size=UDim2.fromScale(0,1)},Enum.EasingStyle.Linear)local function dismiss()if gone or not wrap.Parent then return end gone=true FADE.out(box,0.22,Enum.EasingStyle.Quad)local tw=tween(box,0.3,{Position=UDim2.fromOffset(px(36),0)})tw.Completed:Once(function()box.Visible=false local fold=tween(wrap,0.22,{Size=UDim2.new(1,0,0,0)})fold.Completed:Once(function()wrap:Destroy()end)end)end hit.MouseButton1Click:Connect(dismiss)task.delay(duration,dismiss)end end local function popup(o)local shade=new("TextButton",{Name="Popup",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,AutoButtonColor=false,Text="",ZIndex=30,},hostOf(window))corner(shade,T.radius)tween(shade,0.3,{BackgroundTransparency=0.45},Enum.EasingStyle.Quad)local danger=false for _,b in ipairs(o.Buttons or{})do if b.Variant=="Danger"then danger=true end end local tone=danger and C.red or C.accent local w=px(o.Width or 380)local box=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,px(12)),Size=UDim2.fromOffset(w,0),BackgroundTransparency=1,},shade)local sc=new("UIScale",{Scale=0.95},box)new("ImageLabel",{Name="Shadow",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,px(10)),Size=UDim2.new(1,px(80),1,px(80)),BackgroundTransparency=1,Image=SHADOW_IMAGE,ImageColor3=Color3.new(0,0,0),ImageTransparency=0.3,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(99,99,99,99),},box)local card=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.popup},box)corner(card,px(16))stroke(card,T.fieldLine,0)new("UIPadding",{PaddingTop=UDim.new(0,px(22)),PaddingBottom=UDim.new(0,px(20)),PaddingLeft=UDim.new(0,px(22)),PaddingRight=UDim.new(0,px(22))},card)new("UIListLayout",{Padding=UDim.new(0,px(10)),SortOrder=Enum.SortOrder.LayoutOrder},card)local iconName=o.Icon or(danger and"triangle-alert"or nil)local headH=iconName and even(px(36))or px(24)local head=new("Frame",{LayoutOrder=1,Size=UDim2.new(1,0,0,headH),BackgroundTransparency=1},card)local tx=0 if iconName then local badge=new("Frame",{Size=UDim2.fromOffset(headH,headH),BackgroundColor3=tone,BackgroundTransparency=0.84},head)corner(badge,px(10))new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(18)),even(px(18))),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=tone:Lerp(WHITE,0.15),},badge)tx=headH+px(12)end new("TextLabel",{Position=UDim2.fromOffset(tx,0),Size=UDim2.new(1,-tx,1,0),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(18),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=tostring(o.Title or""),},head)if o.Content and o.Content~=""then new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=px(14),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,LineHeight=1.1,Text=tostring(o.Content),},card)end if type(o.Build)=="function"then local extra=new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},card)new("UIPadding",{PaddingTop=UDim.new(0,px(6))},extra)local ok,err=pcall(o.Build,extra)if not ok then warn("[SPECTREWARE] popup Build failed:",err)end end local rowF=new("Frame",{LayoutOrder=4,Size=UDim2.new(1,0,0,px(46)),BackgroundTransparency=1},card)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=Enum.VerticalAlignment.Bottom,Padding=UDim.new(0,px(8)),SortOrder=Enum.SortOrder.LayoutOrder},rowF)local closing=false local function close()if closing then return end closing=true FADE.out(box,0.16,Enum.EasingStyle.Quad)tween(sc,0.2,{Scale=0.97})tween(box,0.2,{Position=UDim2.new(0.5,0,0.5,px(6))})local tw=tween(shade,0.24,{BackgroundTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()shade:Destroy()end)end for i,b in ipairs(o.Buttons or{})do local label=tostring(b.Title or"OK")local filled=b.Variant=="Primary"or b.Variant=="Danger"local fill=b.Variant=="Danger"and C.red or C.accent local rest=filled and fill or T.field local hot=filled and fill:Lerp(WHITE,0.15)or T.fieldHot local btn=new("TextButton",{LayoutOrder=i,Size=UDim2.fromOffset(textW(label,px(13),T.fontBold)+px(36),even(px(36))),BackgroundColor3=rest,AutoButtonColor=false,Text="",},rowF)corner(btn,px(10))if not filled then stroke(btn,T.fieldLine)end new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(13),TextColor3=(b.Variant=="Danger"and WHITE)or(filled and onAccent())or T.text,Text=label,},btn)btn.MouseEnter:Connect(function()tween(btn,0.15,{BackgroundColor3=hot})end)btn.MouseLeave:Connect(function()tween(btn,0.2,{BackgroundColor3=rest})end)btn.MouseButton1Click:Connect(function()close()if b.Callback then task.spawn(b.Callback)end end)end local function fit()box.Size=UDim2.fromOffset(w,heightOf(card))end card:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)fit()FADE.hide(box)FADE.show(box,0.26,Enum.EasingStyle.Quad)tween(sc,0.38,{Scale=1})tween(box,0.38,{Position=UDim2.fromScale(0.5,0.5)})shade.MouseButton1Click:Connect(function()end)end local jumpTo local FEAT=(function()local F={}local GuiService=game:GetService("GuiService")local function store(name)prefs[name]=type(prefs[name])=="table"and prefs[name]or{}if type(prefs[name][GAME_KEY])~="table"then prefs[name][GAME_KEY]={}end return prefs[name][GAME_KEY]end local function pinList()local raw=store("pins")local out,seen={},{}for _,v in pairs(raw)do if type(v)=="string"and not seen[v]then seen[v]=true table.insert(out,v)end end if#out~=#raw then prefs.pins[GAME_KEY]=out end return prefs.pins[GAME_KEY]end local function keyLabel(k)return KEYNAMES[k]or k end local pinHooks={}function F.isPinned(e)return table.find(pinList(),e.id)~=nil end function F.bindOf(e)return store("binds")[e.id]end function F.paintTags(e)local col=e.row:FindFirstChild("Text")local line=col and col:FindFirstChild("TitleLine")if not line then return end local pinTag=line:FindFirstChild("PinTag")if not pinTag then pinTag=new("ImageButton",{Name="PinTag",LayoutOrder=50,Size=UDim2.fromOffset(even(px(15)),even(px(15))),BackgroundTransparency=1,Image=ICON.pin,ImageColor3=C.accent,Visible=false,AutoButtonColor=false,ZIndex=6,},line)pinTag.MouseEnter:Connect(function()pinTag.Image=ICON["pin-off"]tween(pinTag,0.12,{ImageColor3=C.red})end)pinTag.MouseLeave:Connect(function()pinTag.Image=ICON.pin tween(pinTag,0.15,{ImageColor3=C.accent})end)pinTag.MouseButton1Click:Connect(function()if CTRL.swallow then return end F.setPinned(e,false)end)end pinTag.Visible=F.isPinned(e)local keyTag=line:FindFirstChild("KeyTag")if not keyTag then keyTag=new("Frame",{Name="KeyTag",LayoutOrder=51,Size=UDim2.fromOffset(0,even(px(18))),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=T.field,Visible=false,},line)corner(keyTag,px(5))stroke(keyTag,T.fieldLineHot)new("UIPadding",{PaddingLeft=UDim.new(0,px(6)),PaddingRight=UDim.new(0,px(6))},keyTag)new("TextLabel",{Name="Key",Size=UDim2.fromScale(0,1),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,FontFace=T.mono,TextSize=px(10),TextColor3=T.subtext,Text="",},keyTag)end local k=F.bindOf(e)keyTag.Visible=k~=nil if k then keyTag.Key.Text=keyLabel(k)end end local hookPress CTRL.attach=function(e)if F.isPinned(e)or F.bindOf(e)then F.paintTags(e)end if hookPress then hookPress(e,e.row)end end function F.setPinned(e,on)local pins=pinList()if on then if not table.find(pins,e.id)then table.insert(pins,e.id)end else for i=#pins,1,-1 do if pins[i]==e.id then table.remove(pins,i)end end end savePrefs()local ok,err=pcall(F.paintTags,e)if not ok then warn("[SPECTREWARE] pin mark:",err)end for _,fn in ipairs(pinHooks)do local ok2,err2=pcall(fn)if not ok2 then warn("[SPECTREWARE] Quick Toggles refresh:",err2)end end notify({Title=on and"Pinned to Home"or"Unpinned",Content=e.title,Icon=on and"check"or"info",Duration=2,})end function F.pinned()local out={}for _,id in ipairs(pinList())do local e=CTRL.byId[id]if e and e.row.Parent then table.insert(out,e)end end return out end function F.setBind(e,keyName)local binds=store("binds")if keyName then for id,k in pairs(binds)do if k==keyName and id~=e.id then binds[id]=nil if CTRL.byId[id]then F.paintTags(CTRL.byId[id])end end end end binds[e.id]=keyName savePrefs()F.paintTags(e)end local listening function F.listen(e)if listening then return end listening=e capture.active=true notify({Title="Bind a key",Content=('Press a key for "%s".  Esc cancels, Backspace removes it.'):format(e.title),Icon="keyboard",Duration=4,})end STATE.connect(UIS.InputBegan,function(input,processed)if not mine()then return end local kc=input.KeyCode if listening then if kc==Enum.KeyCode.Unknown then return end local e=listening listening=nil task.defer(function()capture.active=false end)if kc==Enum.KeyCode.Escape then return end if kc==Enum.KeyCode.Backspace then F.setBind(e,nil)notify({Title="Key removed",Content=e.title,Icon="info",Duration=2})return end if kc==T.toggleKey then notify({Title="Key in use",Content=("[%s] opens the menu. Pick another key."):format(kc.Name),Icon="triangle-alert",Duration=3})return end F.setBind(e,kc.Name)notify({Title="Key bound",Content=("[%s]  →  %s"):format(keyLabel(kc.Name),e.title),Icon="check",Duration=3})return end if processed or capture.active or kc==Enum.KeyCode.Unknown then return end if UIS:GetFocusedTextBox()then return end for id,k in pairs(store("binds"))do if k==kc.Name then local e=CTRL.byId[id]if e and e.row.Parent then if e.kind=="toggle"then e.obj:Set(not e.obj.Value)elseif e.kind=="button"then e.obj.Run()end end end end end)local quickTiles={}local function menuFor(e,at)closePopup()local items={}local pinned=F.isPinned(e)table.insert(items,{pinned and"pin-off"or"pin",pinned and"Unpin from Home"or"Pin to Home",function()F.setPinned(e,not pinned)end})if UIS.KeyboardEnabled and(e.kind=="toggle"or e.kind=="button")then local k=F.bindOf(e)table.insert(items,{"keyboard",k and("Change key  ["..keyLabel(k).."]")or"Bind a key",function()F.listen(e)end})if k then table.insert(items,{"x","Remove key",function()F.setBind(e,nil)notify({Title="Key removed",Content=e.title,Icon="info",Duration=2})end})end end if e.kind~="button"then table.insert(items,{"rotate-ccw","Reset to default",function()CTRL.set(e,e.default)end})end local pad,headH,itemH,w=px(6),px(28),even(px(36)),px(230)local h=pad*2+headH+#items*itemH local s=math.max(pop.Scale,0.01)local p=(at-window.AbsolutePosition)/s local x=math.clamp(p.X,px(6),math.max(px(6),T.size.X-w-px(6)))local y=math.clamp(p.Y,px(6),math.max(px(6),T.size.Y-h-px(6)))local frame=new("CanvasGroup",{Name="ContextMenu",Position=UDim2.fromOffset(x,y-px(6)),Size=UDim2.fromOffset(w,h),BackgroundColor3=T.popup,GroupTransparency=1,},overlay)corner(frame,px(10))local st=stroke(frame,T.fieldLineHot,1)local sc=new("UIScale",{Scale=0.96},frame)local list=new("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1},frame)new("UIPadding",{PaddingTop=UDim.new(0,pad),PaddingBottom=UDim.new(0,pad),PaddingLeft=UDim.new(0,pad),PaddingRight=UDim.new(0,pad)},list)new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},list)local head=new("TextLabel",{LayoutOrder=0,Size=UDim2.new(1,0,0,headH),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=e.title:upper(),},list)new("UIPadding",{PaddingLeft=UDim.new(0,px(10)),PaddingRight=UDim.new(0,px(10))},head)local close for i,it in ipairs(items)do local b=new("TextButton",{LayoutOrder=i,Size=UDim2.new(1,0,0,itemH),BackgroundColor3=T.rowActive,BackgroundTransparency=1,AutoButtonColor=false,Text="",},list)corner(b,px(7))local icS=even(px(15))local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(10),0.5,0),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=icon(it[1]),ImageColor3=T.subtext,},b)new("TextLabel",{Position=UDim2.fromOffset(px(10)+icS+px(10),0),Size=UDim2.new(1,-(px(20)+icS+px(10)),1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=it[2],},b)b.MouseEnter:Connect(function()tween(b,0.12,{BackgroundTransparency=0})tween(ic,0.12,{ImageColor3=C.accent})end)b.MouseLeave:Connect(function()tween(b,0.15,{BackgroundTransparency=1})tween(ic,0.15,{ImageColor3=T.subtext})end)b.MouseButton1Click:Connect(function()if CTRL.swallow then return end close()task.spawn(it[3])end)end tween(frame,0.28,{Position=UDim2.fromOffset(x,y)})tween(frame,0.18,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(st,0.18,{Transparency=0})tween(sc,0.3,{Scale=1},Enum.EasingStyle.Back)local closing=false local function shut()if closing then return end closing=true tween(st,0.12,{Transparency=1})tween(sc,0.15,{Scale=0.97})local tw=tween(frame,0.14,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()frame:Destroy()end)end openPopup={list=frame,field=frame,close=shut}close=function()if openPopup and openPopup.list==frame then closePopup()else shut()end end end do local presses={}local swallowBy,swallowToken=nil,0 local lastInput,lastAt=nil,0 local function release()swallowToken+=1 local my=swallowToken task.delay(0.2,function()if swallowToken==my then CTRL.swallow,swallowBy=false,nil end end)end local function under(anchor,x)return Vector2.new(x,anchor.AbsolutePosition.Y+anchor.AbsoluteSize.Y-px(4))end local function pressOn(e,anchor,input)if not mine()or not shown then return end local kind=input.UserInputType if kind~=Enum.UserInputType.MouseButton2 and kind~=Enum.UserInputType.Touch then return end if input==lastInput and os.clock()-lastAt<0.05 then return end lastInput,lastAt=input,os.clock()if kind==Enum.UserInputType.MouseButton2 then menuFor(e,under(anchor,UIS:GetMouseLocation().X))return end local p={start=Vector2.new(input.Position.X,input.Position.Y),moved=false}presses[input]=p task.delay(0.5,function()if presses[input]~=p or p.moved or input.UserInputState==Enum.UserInputState.End then return end if not anchor.Parent or not shown then return end CTRL.swallow,swallowBy=true,input swallowToken+=1 local my=swallowToken task.delay(1.5,function()if swallowToken==my then CTRL.swallow,swallowBy=false,nil end end)menuFor(e,under(anchor,input.Position.X))end)end hookPress=function(e,root)local function hook(obj)if obj==root or obj:IsA("GuiButton")or obj:IsA("TextBox")or(obj:IsA("GuiObject")and obj.Active)then obj.InputBegan:Connect(function(input)pressOn(e,root,input)end)end end hook(root)for _,desc in ipairs(root:GetDescendants())do hook(desc)end root.DescendantAdded:Connect(hook)end for _,e in ipairs(CTRL.list)do hookPress(e,e.row)end STATE.connect(UIS.InputChanged,function(input)local p=presses[input]if p and(Vector2.new(input.Position.X,input.Position.Y)-p.start).Magnitude>10 then p.moved=true end end)STATE.connect(UIS.InputEnded,function(input)if not presses[input]then return end presses[input]=nil if swallowBy==input then release()end end)end local canFile=(writefile and readfile and isfile and listfiles and makefolder and isfolder)and true or false local ROOT,DIR="MonoUI/configs","MonoUI/configs/"..GAME_KEY local memory={}local function ensureDir()pcall(function()if not isfolder("MonoUI")then makefolder("MonoUI")end if not isfolder(ROOT)then makefolder(ROOT)end if not isfolder(DIR)then makefolder(DIR)end end)end local function clean(name)name=tostring(name or""):gsub('[%c\\/:%*%?"<>|%.]',""):gsub("^%s+",""):gsub("%s+$","")local len=utf8.len(name)if len and len>32 then name=name:sub(1,utf8.offset(name,33)-1)end return name end local function file(name)return DIR.."/"..name..".json"end local cfg={refresh=function()end,current=nil}local function when(t)t=tonumber(t)if not t then return nil end local d=math.max(0,os.time()-t)if d<60 then return"just now"end if d<3600 then return math.floor(d/60).." min ago"end if d<86400 then return math.floor(d/3600).." h ago"end local ok,s=pcall(function()return DateTime.fromUnixTimestamp(t):FormatLocalTime("D MMM YYYY","en-us")end)return ok and s or(math.floor(d/86400).." days ago")end function cfg.names()local out={}if canFile then pcall(function()ensureDir()for _,f in ipairs(listfiles(DIR))do local n=tostring(f):gsub("\\","/"):match("([^/]+)%.json$")if n then table.insert(out,n)end end end)else for n in pairs(memory)do table.insert(out,n)end end table.sort(out,function(a,b)return a:lower()<b:lower()end)return out end function cfg.exists(name)return table.find(cfg.names(),clean(name))~=nil end function cfg.read(name)local data if canFile then pcall(function()data=HttpService:JSONDecode(readfile(file(name)))end)else data=memory[name]end return(type(data)=="table"and type(data.values)=="table")and data or nil end function cfg.list()local out={}for _,n in ipairs(cfg.names())do local d=cfg.read(n)local count=0 if d then for _ in pairs(d.values)do count+=1 end end table.insert(out,{name=n,ok=d~=nil,count=count,savedAt=d and d.savedAt,theme=d and type(d.ui)=="table"and d.ui.theme or nil,})end return out end function cfg.save(name)name=clean(name)if name==""then notify({Title="Config",Content="Type a name first.",Icon="triangle-alert",Duration=3})return false end local values,n={},0 for _,e in ipairs(CTRL.list)do if e.config and e.row.Parent then values[e.id]=CTRL.get(e)n+=1 end end local data={version=2,name=name,savedAt=os.time(),values=values,ui={theme=currentTheme,custom=prefs.custom},}if canFile then local ok=pcall(function()ensureDir()writefile(file(name),HttpService:JSONEncode(data))end)if not ok then notify({Title="Config",Content="Could not write the file.",Icon="triangle-alert"})return false end else memory[name]=data end cfg.current=name notify({Title="Config saved",Content=('"%s"  ·  %d settings + theme'):format(name,n),Icon="check",Duration=3})cfg.refresh()return true end function cfg.load(name,quiet)local data=cfg.read(name)if not data then notify({Title="Config",Content=('Could not read "%s".'):format(name),Icon="triangle-alert"})return false end CTRL.muted=true local n=0 for id,v in pairs(data.values)do local e=CTRL.byId[id]if e and e.config then pcall(CTRL.set,e,v)n+=1 end end CTRL.muted=false local ui=type(data.ui)=="table"and data.ui or nil if ui then local cu=type(ui.custom)=="table"and ui.custom or nil if cu and HEX.to(cu.accent)then addTheme("Custom",HEX.to(cu.base)or THEMES.Custom.palette.bg,HEX.to(cu.accent))prefs.custom=cu end if ui.theme and THEMES[ui.theme]then pcall(applyTheme,ui.theme,true,true,ui.theme=="Custom")end end cfg.current=name for _,fn in ipairs(CTRL.hooks)do pcall(fn,nil,false)end if F.islandFlash then F.islandFlash("folder-open",('Loaded "%s"'):format(name),C.accent)end if not quiet then notify({Title="Config loaded",Content=('"%s"  ·  %d settings'):format(name,n),Icon="check",Duration=3})end cfg.refresh()return true end function cfg.delete(name)if canFile then pcall(function()if delfile and isfile(file(name))then delfile(file(name))end end)else memory[name]=nil end if cfg.current==name then cfg.current=nil end if cfg.autoload()==name then cfg.setAutoload(nil,true)end notify({Title="Config deleted",Content=name,Icon="info",Duration=2})cfg.refresh()end function cfg.autoload()local a=prefs.autoConfig return type(a)=="table"and a[GAME_KEY]or nil end function cfg.setAutoload(name,quiet)prefs.autoConfig=type(prefs.autoConfig)=="table"and prefs.autoConfig or{}prefs.autoConfig[GAME_KEY]=name savePrefs()cfg.refresh()if not quiet then notify({Title=name and"Auto-load on"or"Auto-load off",Content=name and('"%s" will load by itself when you join this game.'):format(name)or"Nothing loads when you join.",Icon=name and"check"or"info",Duration=3,})end end cfg.words={new="New config",desc="Saves every setting for this game under a name.",placeholder="Config name",list="Saved configs",empty="No configs yet",emptyDesc="Name one above and press Save.",auto="Loads when you join this game.",}TAGS["Auto-load"],TAGS["Loaded"]=C.green,C.blue local function actButton(parent,order,iconName,text,style)local h=K.ctrlH local w=text and(textW(text,px(12),T.fontBold)+px(38))or h local b=new("TextButton",{LayoutOrder=order,Size=UDim2.fromOffset(w,h),AutoButtonColor=false,Text=""},parent)corner(b,px(9))local st=stroke(b,T.fieldLine)local icS=even(px(13))local ic=new("ImageLabel",{AnchorPoint=Vector2.new(text and 0 or 0.5,0.5),Position=text and UDim2.new(0,px(11),0.5,0)or UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=icon(iconName),},b)local lb=text and new("TextLabel",{Position=UDim2.fromOffset(px(28),0),Size=UDim2.new(1,-px(32),1,0),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(12),TextXAlignment=Enum.TextXAlignment.Left,Text=text,},b)local function paint(hot)local bg,ink,line,lineT if style=="primary"then bg,ink,line,lineT=hot and C.accent:Lerp(WHITE,0.15)or C.accent,onAccent(),C.accent,1 elseif style=="on"then bg,ink,line,lineT=hot and T.fieldHot or T.field,C.green,C.green,0.35 else bg,ink,line,lineT=hot and T.fieldHot or T.field,(style=="danger"and hot)and C.red or T.text,hot and T.fieldLineHot or T.fieldLine,0 end tween(b,0.15,{BackgroundColor3=bg})tween(st,0.15,{Color=line,Transparency=lineT})ic.ImageColor3=ink if lb then lb.TextColor3=ink end end paint(false)b.MouseEnter:Connect(function()paint(true)end)b.MouseLeave:Connect(function()paint(false)end)return b end function F.configPage(tabObj)local page=tabObj.page local function hlist(slot)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,px(6)),VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,},slot)end local gSave=tabObj:Group("Save")local _,s1=row(gSave,"Save current settings","Every setting on every page, plus UI scale, window opacity, blur, menu key and theme.")hlist(s1)local box=new("TextBox",{LayoutOrder=1,Size=UDim2.fromOffset(px(170),K.ctrlH),ClearTextOnFocus=false,BackgroundColor3=T.field,FontFace=T.font,TextSize=px(13),TextColor3=T.text,PlaceholderText="Config name",PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,},s1)corner(box,px(9))local boxStroke=stroke(box,T.fieldLine)new("UIPadding",{PaddingLeft=UDim.new(0,px(10)),PaddingRight=UDim.new(0,px(10))},box)box.Focused:Connect(function()tween(boxStroke,0.15,{Color=C.accent})end)box.FocusLost:Connect(function()tween(boxStroke,0.2,{Color=T.fieldLine})end)local saveB=actButton(s1,2,"save","Save","primary")local function doSave()local name=clean(box.Text)if name==""then notify({Title="Config",Content="Type a name first.",Icon="triangle-alert",Duration=3})return end local function go()if cfg.save(name)then box.Text=""end end if cfg.exists(name)then popup({Icon="save",Title="Replace config?",Content=('"%s" already exists. Replace it with your current settings?'):format(name),Buttons={{Title="Cancel"},{Title="Replace",Variant="Primary",Callback=go}},})else go()end end saveB.MouseButton1Click:Connect(doSave)box.FocusLost:Connect(function(enter)if enter then doSave()end end)local gAuto=tabObj:Group("Auto-load")local _,s2,_,autoDesc=row(gAuto,"Load a config when you join"," ")hlist(s2)local offB=actButton(s2,1,"x","Turn off","normal")offB.MouseButton1Click:Connect(function()cfg.setAutoload(nil)end)local gList=tabObj:Group("Saved configs")local capButton=gList.holder:FindFirstChild("Caption")local capLabel=capButton and capButton:FindFirstChildWhichIsA("TextLabel")local function rebuild()for _,c in ipairs(gList.card:GetChildren())do if c:IsA("Frame")then c:Destroy()end end gList.rows=0 local keep={}for _,it in ipairs(page.rows)do if it.g~=gList then table.insert(keep,it)end end page.rows=keep local auto=cfg.autoload()autoDesc.Text=auto and('On: "%s" loads by itself every time you join this game.'):format(auto)or"Off. Press Set auto-load on a config below to load it every time you join."autoDesc.TextColor3=auto and C.green or T.muted offB.Visible=auto~=nil local list=cfg.list()if capLabel then capLabel.Text=("SAVED CONFIGS (%d)"):format(#list)end if#list==0 then row(gList,"No configs yet","Type a name above and press Save.")return end for _,it in ipairs(list)do local name=it.name local isAuto=name==auto local tags={}if isAuto then table.insert(tags,"Auto-load")end if name==cfg.current then table.insert(tags,"Loaded")end local bits={it.ok and(it.count.." settings")or"can't read this file"}local w=when(it.savedAt)if w then table.insert(bits,"saved "..w)end if it.theme then table.insert(bits,it.theme.." theme")end local _,s=row(gList,name,table.concat(bits,"  ·  "),tags)hlist(s)local loadB=actButton(s,1,"folder-open","Load","primary")local autoB=actButton(s,2,isAuto and"check"or"star",isAuto and"Auto-load on"or"Set auto-load",isAuto and"on"or"normal")local overB=actButton(s,3,"save",nil,"icon")local delB=actButton(s,4,"trash-2",nil,"danger")loadB.MouseButton1Click:Connect(function()cfg.load(name)end)autoB.MouseButton1Click:Connect(function()cfg.setAutoload((not isAuto)and name or nil)end)overB.MouseButton1Click:Connect(function()popup({Icon="save",Title="Update config?",Content=('Replace "%s" with your current settings?'):format(name),Buttons={{Title="Cancel"},{Title="Update",Variant="Primary",Callback=function()cfg.save(name)end}},})end)delB.MouseButton1Click:Connect(function()popup({Icon="trash-2",Title="Delete config?",Content=('Delete "%s"? This cannot be undone.'):format(name)..(isAuto and" Auto-load will be turned off."or""),Buttons={{Title="Cancel"},{Title="Delete",Variant="Danger",Callback=function()cfg.delete(name)end}},})end)end end cfg.refresh=rebuild local themeToken=0 onThemeChanged(function()themeToken+=1 local my=themeToken task.delay(0.4,function()if my==themeToken then rebuild()end end)end)rebuild()end F.config,F.canFile=cfg,canFile function F.autoload()local n=cfg.autoload()if n and cfg.exists(n)then cfg.load(n,true)end end function F.quickCard(body,order,CP)local card=new("Frame",{Name="QuickToggles",LayoutOrder=order,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.card,},body)corner(card,K.radius)stroke(card,T.cardLine)local inner=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},card)new("UIPadding",{PaddingTop=UDim.new(0,CP-px(2)),PaddingBottom=UDim.new(0,CP),PaddingLeft=UDim.new(0,CP),PaddingRight=UDim.new(0,CP)},inner)new("UIListLayout",{Padding=UDim.new(0,px(12)),SortOrder=Enum.SortOrder.LayoutOrder},inner)local head=new("Frame",{LayoutOrder=1,Size=UDim2.new(1,0,0,px(16)),BackgroundTransparency=1},inner)local s13=even(px(13))new("ImageLabel",{Size=UDim2.fromOffset(s13,s13),BackgroundTransparency=1,Image=ICON.pin,ImageColor3=T.muted},head)new("TextLabel",{Position=UDim2.fromOffset(s13+px(6),0),Size=UDim2.new(0.6,0,1,0),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text="QUICK TOGGLES",},head)local count=new("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.new(0.4,0,1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Right,Text="",},head)local empty=new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text=(UIS.KeyboardEnabled and"Right-click"or"Long-press").." any setting and choose Pin to Home to keep it here.",},inner)local grid=new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},inner)local gap,cellH=px(10),px(60)new("UIGridLayout",{CellSize=UDim2.new(1/3,-math.ceil(gap*2/3),0,cellH),CellPadding=UDim2.fromOffset(gap,gap),SortOrder=Enum.SortOrder.LayoutOrder,},grid)local tiles={}local function tile(e,i)local b=new("TextButton",{Name=e.title,LayoutOrder=i,BackgroundColor3=T.field,AutoButtonColor=false,Text=""},grid)corner(b,px(10))local st=stroke(b,T.fieldLine)local icS=even(px(15))local ic=new("ImageLabel",{Position=UDim2.fromOffset(px(12),px(11)),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=e.sec.pillIcon.Image,ImageColor3=T.subtext,},b)local unS=even(px(22))new("TextLabel",{Position=UDim2.new(0,px(12),1,-px(26)),Size=UDim2.new(1,-(px(24)+unS),0,px(16)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(13),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=e.title,},b)local un=new("ImageButton",{Name="Unpin",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(6),1,-px(6)),Size=UDim2.fromOffset(unS,unS),BackgroundColor3=T.fieldHot,BackgroundTransparency=HOVER and 1 or 0.3,Image="",AutoButtonColor=false,ZIndex=3,},b)corner(un,px(6))local unIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(12)),even(px(12))),BackgroundTransparency=1,Image=ICON["pin-off"],ImageColor3=T.muted,ImageTransparency=HOVER and 1 or 0,ZIndex=4,},un)local overTile,overUn=false,false local function showUn()if not HOVER then return end local on=overTile or overUn tween(un,0.15,{BackgroundTransparency=on and 0.3 or 1})tween(unIcon,0.15,{ImageTransparency=on and 0 or 1,ImageColor3=overUn and C.red or T.muted})end b.MouseEnter:Connect(function()overTile=true showUn()end)b.MouseLeave:Connect(function()overTile=false task.defer(showUn)end)un.MouseEnter:Connect(function()overUn=true showUn()end)un.MouseLeave:Connect(function()overUn=false task.defer(showUn)end)un.MouseButton1Click:Connect(function()if CTRL.swallow then return end F.setPinned(e,false)end)local paint if e.kind=="toggle"then local sw,sh=even(px(30)),even(px(17))local track=new("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-px(10),0,px(10)),Size=UDim2.fromOffset(sw,sh),BackgroundColor3=T.track,},b)new("UICorner",{CornerRadius=UDim.new(1,0)},track)local ks=sh-px(4)local knob=new("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(2),0.5,0),Size=UDim2.fromOffset(ks,ks),BackgroundColor3=Color3.fromRGB(196,202,216),},track)new("UICorner",{CornerRadius=UDim.new(1,0)},knob)paint=function(t)local on=e.obj.Value tween(track,t,{BackgroundColor3=on and C.accent or T.track})tween(knob,t,{AnchorPoint=Vector2.new(on and 1 or 0,0.5),Position=UDim2.new(on and 1 or 0,on and-px(2)or px(2),0.5,0),BackgroundColor3=on and knobOn()or Color3.fromRGB(196,202,216),})tween(st,t,{Color=on and C.accent or T.fieldLine,Transparency=on and 0.4 or 0})tween(ic,t,{ImageColor3=on and C.accent or T.subtext})end else local right=new("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-px(10),0,px(9)),Size=UDim2.new(0.6,0,0,px(16)),BackgroundTransparency=1,FontFace=T.mono,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Right,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},b)paint=function()if e.kind=="button"then right.Text="RUN"else right.Text=e.obj.Display and e.obj.Display()or""end end end b.MouseEnter:Connect(function()tween(b,0.12,{BackgroundColor3=T.fieldHot})end)b.MouseLeave:Connect(function()tween(b,0.18,{BackgroundColor3=T.field})end)b.MouseButton1Click:Connect(function()if CTRL.swallow then return end if e.kind=="toggle"then e.obj:Set(not e.obj.Value)elseif e.kind=="button"then e.obj.Run()elseif jumpTo then jumpTo(e)end end)tiles[e]={paint=paint,frame=b}quickTiles[b]=e hookPress(e,b)end local function rebuild()for b in pairs(quickTiles)do if b:IsDescendantOf(grid)then quickTiles[b]=nil end end for _,c in ipairs(grid:GetChildren())do if c:IsA("GuiObject")then c:Destroy()end end table.clear(tiles)local list=F.pinned()for i,e in ipairs(list)do tile(e,i)end for _,t in pairs(tiles)do t.paint(0)end empty.Visible,grid.Visible=#list==0,#list>0 count.Text=#list>0 and(#list.." pinned")or""end table.insert(pinHooks,rebuild)CTRL.onChange(function(e)if e==nil then for _,t in pairs(tiles)do t.paint(0.2)end elseif tiles[e]then tiles[e].paint(0.2)end end)onThemeChanged(function()for _,t in pairs(tiles)do t.paint(0.3)end end)rebuild()return rebuild end return F end)()do(function()local SUG={max=7,itemH=even(px(50)),w=px(380),head=px(28),foot=px(32)}local sug local recent={}local suppressSearch=false local function esc(s)return(s:gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"))end local function hex(c)return("#%02X%02X%02X"):format(math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))end local function highlight(title,q)local i,j=title:lower():find(q,1,true)if q==""or not i then return esc(title)end return esc(title:sub(1,i-1))..('<font color="%s">'):format(hex(C.accent))..esc(title:sub(i,j)).."</font>"..esc(title:sub(j+1))end local function pageItem(tab)return{kind="Page",title=tab.name,desc="",path="Page",icon=tab.icon,tab=tab}end local function buildIndex()local out={}for _,tab in ipairs(tabOrder)do table.insert(out,pageItem(tab))local multi=#tab.secOrder>=2 for _,sec in ipairs(tab.secOrder)do if multi then table.insert(out,{kind="Section",title=sec.name,desc="",path=tab.name,icon=sec.pillIcon.Image,tab=tab,sec=sec})end for _,it in ipairs(sec.page.rows)do if it.r.Parent and it.title and it.title~=""then table.insert(out,{kind="Setting",title=it.title,desc=it.desc or"",icon=sec.pillIcon.Image,path=multi and(tab.name.."  ›  "..sec.name)or tab.name,tab=tab,sec=sec,target=it.r,group=it.g,})end end end end return out end local function fuzzy(t:string,q:string):boolean q=q:gsub("%s+","")if#q<3 then return false end local j=1 for k=1,#t do if t:sub(k,k)==q:sub(j,j)then j+=1 if j>#q then return true end end end return false end local function score(item,q)local t=item.title:lower()local s=0 if t==q then s=1000 else local i=t:find(q,1,true)if i==1 then s=700 elseif i then s=t:sub(i-1,i-1):match("[%s%p]")and 500 or 350 else local hay=t.." "..item.desc:lower().." "..item.path:lower()local all=true for w in q:gmatch("%S+")do if not hay:find(w,1,true)then all=false break end end if all then s=200 elseif fuzzy(t,q)then s=80 end end end if s==0 then return 0 end if item.kind=="Page"then s+=30 elseif item.kind=="Section"then s+=15 end return s-#t*0.5 end local function results(q)local out={}if q==""then for _,it in ipairs(recent)do if tabs[it.tab.name]==it.tab and(not it.target or it.target.Parent)then table.insert(out,it)end end if#out>0 then return out,"Recent"end for _,tab in ipairs(tabOrder)do table.insert(out,pageItem(tab))if#out>=SUG.max then break end end return out,"Jump to"end local scored={}for _,item in ipairs(buildIndex())do local s=score(item,q)if s>0 then item.score=s table.insert(scored,item)end end table.sort(scored,function(a,b)return a.score>b.score end)for i=1,math.min(#scored,SUG.max)do out[i]=scored[i]end return out,#scored>0 and(#scored==1 and"1 result"or(#scored.." results"))or nil end local function pushRecent(item)for i=#recent,1,-1 do local r=recent[i]if r.kind==item.kind and r.tab==item.tab and r.sec==item.sec and r.target==item.target then table.remove(recent,i)end end table.insert(recent,1,item)if#recent>5 then table.remove(recent)end end local function reveal(target,page)RunService.Heartbeat:Wait()RunService.Heartbeat:Wait()if not target.Parent or not page or currentPage~=page then return end local s=pop.Scale local scroll=page.scroll local y=(target.AbsolutePosition.Y-scroll.AbsolutePosition.Y)/s+scroll.CanvasPosition.Y local maxY=math.max(0,(scroll.AbsoluteCanvasSize.Y-scroll.AbsoluteWindowSize.Y)/s)tween(scroll,0.55,{CanvasPosition=Vector2.new(0,math.clamp(y-px(60),0,maxY))})local flash=new("Frame",{Name="Flash",Position=UDim2.fromOffset(px(2),px(2)),Size=UDim2.new(1,-px(4),1,-px(4)),BackgroundColor3=C.accent,BackgroundTransparency=1,ZIndex=0,},target)corner(flash,K.radius-px(2))local fs=stroke(flash,C.accent,1)tween(flash,0.3,{BackgroundTransparency=0.86})tween(fs,0.3,{Transparency=0.25})task.delay(1.1,function()tween(flash,0.7,{BackgroundTransparency=1})local tw=tween(fs,0.7,{Transparency=1})tw.Completed:Once(function()flash:Destroy()end)end)end local function paintSel()if not sug then return end for i,it in ipairs(sug.items)do local on=i==sug.sel tween(it.btn,0.15,{BackgroundTransparency=on and 0 or 1})tween(it.icon,0.15,{ImageColor3=on and C.accent or T.subtext})tween(it.arrow,0.2,{ImageTransparency=on and 0 or 1,Position=UDim2.new(1,on and-px(12)or-px(18),0.5,0)})tween(it.kind,0.15,{TextTransparency=on and 1 or 0})end end local pick local function renderSuggest()if not sug then return end local q=searchBox.Text:lower():gsub("^%s+",""):gsub("%s+$","")local list,heading=results(q)sug.results,sug.sel,sug.items=list,1,{}for _,c in ipairs(sug.list:GetChildren())do if c:IsA("GuiObject")then c:Destroy()end end local h=px(6)*2 if heading then local head=new("TextLabel",{LayoutOrder=0,Size=UDim2.new(1,0,0,SUG.head),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text=heading:upper(),},sug.list)new("UIPadding",{PaddingLeft=UDim.new(0,px(10))},head)h+=SUG.head end if#list==0 then new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,px(64)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.muted,TextWrapped=true,Text=('No results for "%s"'):format(q),},sug.list)h+=px(64)end local boxS,icS=even(px(32)),even(px(15))local tx=px(9)+boxS+px(12)for i,item in ipairs(list)do local btn=new("TextButton",{Name=item.title,LayoutOrder=i,Size=UDim2.new(1,0,0,SUG.itemH),BackgroundColor3=T.rowActive,BackgroundTransparency=1,AutoButtonColor=false,Text="",},sug.list)corner(btn,px(9))local box=new("Frame",{Position=UDim2.fromOffset(px(9),math.floor((SUG.itemH-boxS)/2)),Size=UDim2.fromOffset(boxS,boxS),BackgroundColor3=T.field,},btn)corner(box,px(8))stroke(box,T.fieldLine)local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=item.icon or ICON.circle,ImageColor3=T.subtext,},box)new("TextLabel",{Position=UDim2.fromOffset(tx,px(8)),Size=UDim2.new(1,-(tx+px(76)),0,px(18)),BackgroundTransparency=1,RichText=true,FontFace=T.fontSemi,TextSize=px(14),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=highlight(item.title,q),},btn)local sub=item.kind=="Setting"and item.path or(item.kind=="Section"and(item.path.."  ›  section")or"Open page")if item.kind=="Setting"and item.desc~=""then sub=sub.."  ·  "..item.desc end new("TextLabel",{Position=UDim2.fromOffset(tx,px(27)),Size=UDim2.new(1,-(tx+px(36)),0,px(15)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=sub,},btn)local kind=new("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-px(12),0,px(9)),Size=UDim2.fromOffset(px(60),px(16)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(10),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Right,Text=item.kind:upper(),},btn)local arrow=new("ImageLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(18),0.5,0),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=ICON["chevron-right"],ImageColor3=C.accent,ImageTransparency=1,},btn)local idx=i btn.MouseEnter:Connect(function()if sug and sug.sel~=idx then sug.sel=idx paintSel()end end)btn.MouseButton1Click:Connect(function()pick(item)end)sug.items[i]={btn=btn,icon=ic,arrow=arrow,kind=kind}h+=SUG.itemH end local foot=new("Frame",{LayoutOrder=100,Size=UDim2.new(1,0,0,SUG.foot),BackgroundTransparency=1},sug.list)new("Frame",{Position=UDim2.fromOffset(px(4),px(4)),Size=UDim2.new(1,-px(8),0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0},foot)new("TextLabel",{Position=UDim2.fromOffset(px(10),px(5)),Size=UDim2.new(1,-px(20),1,-px(5)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text=UIS.KeyboardEnabled and"Up / Down to move   ·   Enter to open   ·   Esc to close"or"Tap a result to open it",},foot)h+=SUG.foot if sug.fresh then sug.fresh=false sug.frame.Size=UDim2.fromOffset(SUG.w,h)else tween(sug.frame,0.3,{Size=UDim2.fromOffset(SUG.w,h)})end paintSel()end local function closeSuggestPanel()local s=sug sug=nil if not s then return end tween(s.stroke,0.15,{Transparency=1})tween(s.frame,0.18,{Position=s.rest-UDim2.fromOffset(0,px(6))})local tw=tween(s.frame,0.15,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()s.frame:Destroy()end)end local function openSuggest()if sug then renderSuggest()return end closePopup()local pos,size=inWindow(search)local rest=UDim2.fromOffset(pos.X+size.X,pos.Y+size.Y+px(8))local frame=new("CanvasGroup",{Name="SearchSuggest",AnchorPoint=Vector2.new(1,0),Position=rest-UDim2.fromOffset(0,px(6)),Size=UDim2.fromOffset(SUG.w,px(100)),BackgroundColor3=T.popup,GroupTransparency=1,},overlay)corner(frame,px(12))local st=stroke(frame,T.fieldLineHot,1)local list=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},frame)new("UIPadding",{PaddingTop=UDim.new(0,px(6)),PaddingBottom=UDim.new(0,px(6)),PaddingLeft=UDim.new(0,px(6)),PaddingRight=UDim.new(0,px(6)),},list)new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},list)sug={frame=frame,stroke=st,rest=rest,list=list,items={},results={},sel=1,fresh=true}openPopup={list=frame,field=search,close=closeSuggestPanel}renderSuggest()tween(frame,0.32,{Position=rest})tween(frame,0.22,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(st,0.22,{Transparency=0})end local function hideSuggest()if sug and openPopup and openPopup.list==sug.frame then closePopup()else closeSuggestPanel()end end pick=function(item)pushRecent(item)hideSuggest()suppressSearch=true searchBox.Text=""suppressSearch=false if searchBox:IsFocused()then searchBox:ReleaseFocus()end if tabs[item.tab.name]~=item.tab then return end selectTab(item.tab.name)if item.sec then selectSection(item.tab.name,item.sec.name)end if item.group and item.group.expand then item.group.expand()end if item.target then local page=item.sec and item.sec.page task.spawn(reveal,item.target,page)end end jumpTo=function(e)pick({kind="Setting",title=e.title,desc="",path=e.tab.name,icon=e.sec.pillIcon.Image,tab=e.tab,sec=e.sec,target=e.row,group=e.g,})end STATE.connect(searchBox.Focused,function()if not suppressSearch then openSuggest()end end)STATE.connect(searchBox:GetPropertyChangedSignal("Text"),function()if suppressSearch then return end if searchBox:IsFocused()or searchBox.Text~=""then openSuggest()end end)STATE.connect(searchBox.FocusLost,function(enter)if enter then local item=sug and sug.results[sug.sel]if item then pick(item)else hideSuggest()end elseif UIS:IsKeyDown(Enum.KeyCode.Escape)then hideSuggest()end end)STATE.connect(UIS.InputBegan,function(input,processed)if not mine()then return end if sug and searchBox:IsFocused()then if input.KeyCode==Enum.KeyCode.Down then sug.sel=math.min(#sug.results,sug.sel+1)paintSel()elseif input.KeyCode==Enum.KeyCode.Up then sug.sel=math.max(1,sug.sel-1)paintSel()end return end if processed or not shown or capture.active then return end if input.KeyCode==Enum.KeyCode.F and(UIS:IsKeyDown(Enum.KeyCode.LeftControl)or UIS:IsKeyDown(Enum.KeyCode.RightControl))then task.defer(function()searchBox:CaptureFocus()end)end end)end)()end local function themePicker(g)g.rows+=1 local holder=new("Frame",{Name="Themes",LayoutOrder=g.rows,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},g.card)if g.rows>1 then new("Frame",{Name="Line",Position=UDim2.fromOffset(K.rowPad,0),Size=UDim2.new(1,-K.rowPad*2,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},holder)end local inner=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},holder)new("UIPadding",{PaddingTop=UDim.new(0,K.vPad),PaddingBottom=UDim.new(0,px(16)),PaddingLeft=UDim.new(0,K.rowPad),PaddingRight=UDim.new(0,K.rowPad),},inner)new("UIListLayout",{Padding=UDim.new(0,px(3)),SortOrder=Enum.SortOrder.LayoutOrder},inner)new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,K.title+px(4)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=K.title,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text="Theme",},inner)new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=K.desc,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text="Pick a colour theme for the menu. Your choice is remembered next time.",},inner)local gridWrap=new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},inner)new("UIPadding",{PaddingTop=UDim.new(0,px(10))},gridWrap)local grid=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},gridWrap)local gap,cellH=px(10),px(96)new("UIGridLayout",{CellSize=UDim2.new(1/3,-math.ceil(gap*2/3),0,cellH),CellPadding=UDim2.fromOffset(gap,gap),SortOrder=Enum.SortOrder.LayoutOrder,},grid)local tiles={}local function paintTiles(t)for name,tl in pairs(tiles)do local on=name==currentTheme local p=THEMES[name].palette tween(tl.stroke,t,{Color=on and p.accent or(tl.hover and p.fieldLineHot or p.border),Thickness=on and 2 or 1})tween(tl.check,t,{BackgroundTransparency=on and 0 or 1})tween(tl.checkIcon,t,{ImageTransparency=on and 0 or 1})end end local pv,labelH=px(7),px(26)local function buildTile(name,i)if tiles[name]and tiles[name].frame then tiles[name].frame:Destroy()end local p=THEMES[name].palette local tile=new("TextButton",{Name=name,LayoutOrder=i,BackgroundColor3=p.bg,AutoButtonColor=false,Text=""},grid)tile:SetAttribute("MonoNoTheme",true)corner(tile,px(10))local st=stroke(tile,p.border)local sideF=new("Frame",{Position=UDim2.fromOffset(pv,pv),Size=UDim2.new(0.26,0,1,-(pv+labelH)),BackgroundColor3=p.side,},tile)corner(sideF,px(5))stroke(sideF,p.divider)for j=1,3 do local bar=new("Frame",{Position=UDim2.new(0,px(5),0,px(6)+(j-1)*px(9)),Size=UDim2.new(1,-px(10),0,px(5)),BackgroundColor3=j==1 and p.accent or p.track,BorderSizePixel=0,},sideF)corner(bar,px(2))end local mainF=new("Frame",{Position=UDim2.new(0.26,pv+px(5),0,pv),Size=UDim2.new(0.74,-(pv*2+px(5)),1,-(pv+labelH)),BackgroundColor3=p.card,},tile)corner(mainF,px(5))stroke(mainF,p.cardLine)for j,w in ipairs({0.6,0.38})do local line=new("Frame",{Position=UDim2.fromOffset(px(7),px(7)+(j-1)*px(9)),Size=UDim2.new(w,0,0,px(5)),BackgroundColor3=j==1 and p.fieldLineHot or p.fieldLine,BorderSizePixel=0,},mainF)corner(line,px(2))end local sw=new("Frame",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(6),1,-px(6)),Size=UDim2.fromOffset(px(20),px(11)),BackgroundColor3=p.accent,},mainF)new("UICorner",{CornerRadius=UDim.new(1,0)},sw)local kn=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(2),0.5,0),Size=UDim2.fromOffset(px(7),px(7)),BackgroundColor3=lum(p.accent)>0.8 and p.bg or WHITE,},sw)new("UICorner",{CornerRadius=UDim.new(1,0)},kn)new("TextLabel",{Position=UDim2.new(0,px(10),1,-labelH),Size=UDim2.new(1,-px(36),0,labelH-px(2)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(13),TextColor3=p.text,TextXAlignment=Enum.TextXAlignment.Left,Text=name,},tile)local checkS=even(px(16))local check=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(9),1,-math.floor(labelH/2)-px(1)),Size=UDim2.fromOffset(checkS,checkS),BackgroundColor3=p.accent,BackgroundTransparency=1,},tile)new("UICorner",{CornerRadius=UDim.new(1,0)},check)local checkIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(10)),even(px(10))),BackgroundTransparency=1,Image=ICON.check,ImageColor3=p.bg,ImageTransparency=1,},check)local tl={stroke=st,check=check,checkIcon=checkIcon,frame=tile}tiles[name]=tl tile.MouseEnter:Connect(function()tl.hover=true paintTiles(0.18)end)tile.MouseLeave:Connect(function()tl.hover=false paintTiles(0.22)end)tile.MouseButton1Click:Connect(function()applyTheme(name,true,true)end)end for i,name in ipairs(THEME_ORDER)do buildTile(name,i)end paintTiles(0)onThemeChanged(function()paintTiles(0.35)end)table.insert(g.page.rows,{r=holder,g=g,title="Theme",desc="Colour theme, appearance, colors"})local cr=new("Frame",{LayoutOrder=4,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},inner)new("UIPadding",{PaddingTop=UDim.new(0,px(14))},cr)new("UIListLayout",{Padding=UDim.new(0,px(4)),SortOrder=Enum.SortOrder.LayoutOrder},cr)new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,K.title+px(4)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=K.title,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text="Custom accent",},cr)new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=K.desc,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text="Drag the colour bar or type a hex code. It becomes the Custom theme.",},cr)local barRow=new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,px(40)),BackgroundTransparency=1},cr)local hexW=px(118)local hue=new("TextButton",{Name="Hue",AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(8),0.5,0),Size=UDim2.new(1,-(hexW+px(24)),0,even(px(14))),BackgroundColor3=WHITE,AutoButtonColor=false,Text="",},barRow)hue:SetAttribute("MonoNoTheme",true)new("UICorner",{CornerRadius=UDim.new(1,0)},hue)do local keys={}for k=0,6 do table.insert(keys,ColorSequenceKeypoint.new(k/6,Color3.fromHSV((k%6)/6,0.62,1)))end new("UIGradient",{Color=ColorSequence.new(keys)},hue)end local knobS=even(px(22))local hueKnob=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0,0.5),Size=UDim2.fromOffset(knobS,knobS),BackgroundColor3=THEMES.Custom.palette.accent,},hue)new("UICorner",{CornerRadius=UDim.new(1,0)},hueKnob)stroke(hueKnob,WHITE,0,2)local hexF=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.fromScale(1,0.5),Size=UDim2.fromOffset(hexW,even(px(32))),BackgroundColor3=T.field,},barRow)corner(hexF,px(8))local hexStroke=stroke(hexF,T.fieldLine)local swS=even(px(14))local swatch=new("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(10),0.5,0),Size=UDim2.fromOffset(swS,swS),BackgroundColor3=THEMES.Custom.palette.accent,},hexF)swatch:SetAttribute("MonoNoTheme",true)new("UICorner",{CornerRadius=UDim.new(1,0)},swatch)local hexBox=new("TextBox",{Position=UDim2.fromOffset(px(10)+swS+px(8),0),Size=UDim2.new(1,-(px(18)+swS+px(8)),1,0),BackgroundTransparency=1,ClearTextOnFocus=false,FontFace=T.mono,TextSize=px(12),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=HEX.from(THEMES.Custom.palette.accent),PlaceholderText="#RRGGBB",PlaceholderColor3=T.muted,},hexF)local function preview(c)local h=c:ToHSV()hueKnob.Position=UDim2.fromScale(h,0.5)hueKnob.BackgroundColor3,swatch.BackgroundColor3=c,c if not hexBox:IsFocused()then hexBox.Text=HEX.from(c)end end preview(THEMES.Custom.palette.accent)local function commit(c)local base=(currentTheme=="Custom"and THEMES.Custom or THEMES[currentTheme]).palette.bg addTheme("Custom",base,c)prefs.custom={base=HEX.from(base),accent=HEX.from(c)}applyTheme("Custom",true,true,true)buildTile("Custom",table.find(THEME_ORDER,"Custom")or#THEME_ORDER)paintTiles(0.2)end local dragging=false local current=THEMES.Custom.palette.accent local function fromX(x)local a=math.clamp((x-hue.AbsolutePosition.X)/math.max(hue.AbsoluteSize.X,1),0,0.999)current=Color3.fromHSV(a,0.62,1)preview(current)end hue.InputBegan:Connect(function(input)if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end dragging=true tween(hueKnob,0.15,{Size=UDim2.fromOffset(knobS+px(4),knobS+px(4))})fromX(input.Position.X)end)STATE.connect(UIS.InputChanged,function(input)if dragging and(input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)then fromX(input.Position.X)end end)STATE.connect(UIS.InputEnded,function(input)if not dragging then return end if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end dragging=false tween(hueKnob,0.25,{Size=UDim2.fromOffset(knobS,knobS)},Enum.EasingStyle.Back)commit(current)end)hexBox.Focused:Connect(function()tween(hexStroke,0.15,{Color=C.accent})end)hexBox.FocusLost:Connect(function()tween(hexStroke,0.2,{Color=T.fieldLine})local c=HEX.to(hexBox.Text)if c then current=c preview(c)commit(c)else hexBox.Text=HEX.from(current)end end)onThemeChanged(function()if dragging then return end current=THEMES.Custom.palette.accent preview(current)buildTile("Custom",table.find(THEME_ORDER,"Custom")or#THEME_ORDER)paintTiles(0)end)return{}end local buildHome do(function()local HIST=24 local metrics={fps=0,ping=0,fpsHist={},pingHist={}}local metricHooks={}do local frames,last=0,os.clock()STATE.connect(RunService.RenderStepped,function()frames+=1 end)local function push(list,v)table.insert(list,v)if#list>HIST then table.remove(list,1)end end task.spawn(function()while STATE.alive()and mine()do task.wait(0.5)local now=os.clock()metrics.fps=frames/math.max(now-last,1e-3)frames,last=0,now local ok,p=pcall(function()return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()end)if not ok or type(p)~="number"then ok,p=pcall(function()return LP:GetNetworkPing()*1000 end)end metrics.ping=(ok and type(p)=="number")and p or 0 push(metrics.fpsHist,metrics.fps)push(metrics.pingHist,metrics.ping)for _,fn in ipairs(metricHooks)do pcall(fn)end end end)end local function fmtSession(s)s=math.floor(s)if s<60 then return s.."s"end if s<3600 then return("%dm %ds"):format(s//60,s%60)end return("%dh %dm"):format(s//3600,(s%3600)//60)end local function httpRequest(opts)local req=(syn and syn.request)or(http and http.request)or http_request or request if not req then return nil end local ok,res=pcall(req,opts)return(ok and type(res)=="table")and res.Body or nil end local function serverList(sortOrder)local url=("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100&excludeFullGames=true"):format(game.PlaceId,sortOrder)local ok,res=pcall(function()return game:HttpGet(url)end)if not ok or type(res)~="string"then res=httpRequest({Url=url,Method="GET"})ok=type(res)=="string"end if not ok or type(res)~="string"then return nil end local ok2,data=pcall(HttpService.JSONDecode,HttpService,res)return(ok2 and type(data)=="table")and data.data or nil end local function joinServer(jobId)notify({Title="Teleporting",Content="Joining the server...",Icon="refresh-cw",Duration=4})local ok,err=pcall(function()TeleportService:TeleportToPlaceInstance(game.PlaceId,jobId,LP)end)if not ok then notify({Title="Teleport failed",Content=tostring(err),Icon="triangle-alert",Duration=5})end end local avatarCache={}local function headshots(tokens,onImage)if#tokens==0 then return end task.spawn(function()local body={}for i,tk in ipairs(tokens)do body[i]={requestId=tostring(i),token=tk,type="AvatarHeadShot",size="60x60",format="png",isCircular=false}end local res=httpRequest({Url="https://thumbnails.roblox.com/v1/batch",Method="POST",Headers={["Content-Type"]="application/json"},Body=HttpService:JSONEncode(body),})local ok,data=pcall(HttpService.JSONDecode,HttpService,res or"")if not ok or type(data)~="table"or type(data.data)~="table"then return end local getAsset=getcustomasset or getsynasset for _,item in ipairs(data.data)do local i=tonumber(item.requestId)local uid,url=tonumber(item.targetId),item.imageUrl if i and uid and uid>0 then onImage(i,("rbxthumb://type=AvatarHeadShot&id=%d&w=60&h=60"):format(uid))elseif i and getAsset and writefile and type(url)=="string"and url~=""then task.spawn(function()if avatarCache[url]then onImage(i,avatarCache[url])return end local okGet,bytes=pcall(function()return game:HttpGet(url)end)if not okGet or type(bytes)~="string"or#bytes<64 then return end local path="MonoUI/avatars/"..url:gsub("[^%w]",""):sub(-40)..".png"pcall(function()if not isfolder("MonoUI")then makefolder("MonoUI")end if not isfolder("MonoUI/avatars")then makefolder("MonoUI/avatars")end end)if not pcall(writefile,path,bytes)then return end local okA,asset=pcall(getAsset,path)if okA and asset then avatarCache[url]=asset onImage(i,asset)end end)end end end)end local function serverPreview(s)return function(box)new("UIListLayout",{Padding=UDim.new(0,px(10)),SortOrder=Enum.SortOrder.LayoutOrder},box)local playing,maxP=tonumber(s.playing)or 0,tonumber(s.maxPlayers)or 0 local chips=new("Frame",{LayoutOrder=1,Size=UDim2.new(1,0,0,even(px(28))),BackgroundTransparency=1},box)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(6)),SortOrder=Enum.SortOrder.LayoutOrder,},chips)local function chip(order,iconName,text,color)local h=even(px(28))local c=new("Frame",{LayoutOrder=order,Size=UDim2.fromOffset(px(28)+textW(text,px(12),T.fontSemi)+px(10),h),BackgroundColor3=T.field,},chips)corner(c,px(8))stroke(c,T.fieldLine)local s13=even(px(13))new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(9),0.5,0),Size=UDim2.fromOffset(s13,s13),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=color or T.subtext,},c)new("TextLabel",{Position=UDim2.fromOffset(px(28),0),Size=UDim2.new(1,-px(28),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=text,},c)end chip(1,"users",("%d / %d players"):format(playing,maxP),C.accent)local ping=tonumber(s.ping)if ping then chip(2,"wifi",("%d ms"):format(ping),ping<=90 and C.green or(ping<=180 and C.amber or C.red))end local fps=tonumber(s.fps)if fps then chip(3,"gauge",("%d fps"):format(math.floor(fps+0.5)),fps>=50 and C.green or(fps>=30 and C.amber or C.red))end local bar=new("Frame",{LayoutOrder=2,Size=UDim2.new(1,0,0,even(px(6))),BackgroundColor3=T.track,BorderSizePixel=0},box)new("UICorner",{CornerRadius=UDim.new(1,0)},bar)local fill=new("Frame",{Size=UDim2.fromScale(0,1),BackgroundColor3=C.accent,BorderSizePixel=0},bar)new("UICorner",{CornerRadius=UDim.new(1,0)},fill)task.delay(0.15,function()tween(fill,0.6,{Size=UDim2.fromScale(maxP>0 and playing/maxP or 0,1)})end)local tokens=type(s.playerTokens)=="table"and s.playerTokens or{}if#tokens==0 then if playing>0 then new("TextLabel",{LayoutOrder=3,Size=UDim2.new(1,0,0,px(16)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text="Player pictures aren't available for this server.",},box)end return end new("TextLabel",{LayoutOrder=3,Size=UDim2.new(1,0,0,px(14)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text="IN THIS SERVER",},box)local faces=new("Frame",{LayoutOrder=4,Size=UDim2.new(1,0,0,even(px(38))),BackgroundTransparency=1},box)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,-px(9)),SortOrder=Enum.SortOrder.LayoutOrder,},faces)local MAX=8 local fs=even(px(38))local imgs={}for i=1,math.min(#tokens,MAX)do local ring=new("Frame",{LayoutOrder=i,Size=UDim2.fromOffset(fs,fs),BackgroundColor3=T.field,ZIndex=MAX-i+2},faces)new("UICorner",{CornerRadius=UDim.new(1,0)},ring)stroke(ring,T.popup,0,2)local ph=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(0.5,0.5),BackgroundTransparency=1,Image=ICON.user,ImageColor3=T.muted,ZIndex=MAX-i+2,},ring)local img=new("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image="",ImageTransparency=1,ZIndex=MAX-i+3,},ring)new("UICorner",{CornerRadius=UDim.new(1,0)},img)imgs[i]={img=img,ph=ph}local sc=new("UIScale",{Scale=0.6},ring)task.delay(0.04*i,function()tween(sc,0.4,{Scale=1},Enum.EasingStyle.Back)end)end local more=math.max(playing,#tokens)-math.min(#tokens,MAX)if more>0 then local ring=new("Frame",{LayoutOrder=MAX+1,Size=UDim2.fromOffset(fs,fs),BackgroundColor3=T.fieldHot,ZIndex=1},faces)new("UICorner",{CornerRadius=UDim.new(1,0)},ring)stroke(ring,T.popup,0,2)new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(12),TextColor3=T.subtext,Text="+"..more,ZIndex=1,},ring)end local first={}for i=1,math.min(#tokens,MAX)do first[i]=tokens[i]end headshots(first,function(i,image)local f=imgs[i]if not f or not f.img.Parent then return end f.img.Image=image tween(f.img,0.35,{ImageTransparency=0})tween(f.ph,0.2,{ImageTransparency=1})end)end end local function offerServers(kind,list,i)local s=list[i]if not s then notify({Title=kind=="lowest"and"Lowest server"or"Server hop",Content="No more servers to show.",Icon="info",Duration=3})return end local buttons={{Title="Cancel"}}if list[i+1]then table.insert(buttons,{Title=kind=="lowest"and"Next lowest"or"Another",Callback=function()offerServers(kind,list,i+1)end})end table.insert(buttons,{Title="Join",Variant="Primary",Callback=function()joinServer(s.id)end})popup({Icon=kind=="lowest"and"users"or"shuffle",Title=kind=="lowest"and"Join the emptiest server?"or"Hop to this server?",Content=kind=="lowest"and"The public server with the fewest players right now."or"A random public server with free slots.",Build=serverPreview(s),Buttons=buttons,})end local function candidates(servers)local out={}for _,s in ipairs(servers)do if s.id~=game.JobId and tonumber(s.playing)and tonumber(s.maxPlayers)and s.playing<s.maxPlayers then table.insert(out,s)end end return out end local ACTIONS={rejoin=function()popup({Icon="rotate-ccw",Title="Rejoin this server?",Content=#Players:GetPlayers()<=1 and"You're alone here, so you'll join a fresh server of this game."or"You'll leave and come straight back into this same server.",Buttons={{Title="Cancel"},{Title="Rejoin",Variant="Primary",Callback=function()notify({Title="Rejoining",Content="Teleporting back...",Icon="refresh-cw",Duration=4})local ok,err=pcall(function()if#Players:GetPlayers()<=1 then TeleportService:Teleport(game.PlaceId,LP)else TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP)end end)if not ok then notify({Title="Teleport failed",Content=tostring(err),Icon="triangle-alert",Duration=5})end end},},})end,hop=function()local servers=serverList("Desc")if not servers then notify({Title="Server hop",Content="Could not load the server list.",Icon="triangle-alert"})return end local list=candidates(servers)if#list==0 then notify({Title="Server hop",Content="No other open servers found.",Icon="triangle-alert"})return end for k=#list,2,-1 do local j=math.random(1,k)list[k],list[j]=list[j],list[k]end offerServers("hop",list,1)end,lowest=function()local servers=serverList("Asc")if not servers then notify({Title="Lowest server",Content="Could not load the server list.",Icon="triangle-alert"})return end local list=candidates(servers)if#list==0 then notify({Title="Lowest server",Content="No other servers found.",Icon="triangle-alert"})return end table.sort(list,function(a,b)return a.playing<b.playing end)offerServers("lowest",list,1)end,jobid=function()local set=setclipboard or toclipboard or(Clipboard and Clipboard.set)if set then set(game.JobId)notify({Title="Job ID copied",Content=game.JobId,Icon="check",Duration=3})else notify({Title="Job ID",Content=game.JobId.."\n(clipboard not supported here)",Icon="info",Duration=6})end end,}function buildHome(page,o)o=o or{}local body=page.body local CP=px(20)local n=0 local function homeVisible()return shown and currentPage==page end local function card(h,name)n+=1 local c=new("Frame",{Name=name,LayoutOrder=n,Size=UDim2.new(1,0,0,h),BackgroundColor3=T.card},body)corner(c,K.radius)stroke(c,T.cardLine)return c end local function caps(parent,text,pos,size,color)return new("TextLabel",{Position=pos,Size=size,BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=color or T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text=text:upper(),},parent)end local function counter(label,fmt)local nv=new("NumberValue",{},label)nv.Changed:Connect(function(v)label.Text=fmt(v)end)return function(target,instant)if instant then nv.Value=target else tween(nv,0.45,{Value=target},Enum.EasingStyle.Quad)end end end local wh=px(160)local wc=card(wh,"Welcome")wc.ClipsDescendants=true local glow=new("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.fromScale(0.6,1),BackgroundColor3=C.accent,BorderSizePixel=0,},wc)corner(glow,K.radius)new("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0.86)})},glow)local avatarS=px(156)local textRight=avatarS+px(34)local avatar=new("ImageLabel",{Name="Avatar",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(24),1,px(26)),Size=UDim2.fromOffset(avatarS,avatarS),BackgroundTransparency=1,Image="",ImageTransparency=1,},wc)task.spawn(function()local ok,img=pcall(Players.GetUserThumbnailAsync,Players,LP.UserId,Enum.ThumbnailType.AvatarBust,Enum.ThumbnailSize.Size420x420)if ok and avatar.Parent then avatar.Image=img tween(avatar,0.7,{ImageTransparency=privacy.avatar and 1 or 0,Position=UDim2.new(1,-px(24),1,px(8))})end end)local welcomeCap=caps(wc,"Welcome back",UDim2.fromOffset(CP,px(20)),UDim2.new(1,-(CP+textRight),0,px(14)))local nameL=new("TextLabel",{Position=UDim2.fromOffset(CP,px(36)),Size=UDim2.new(1,-(CP+textRight),0,px(34)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(28),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=LP.DisplayName,},wc)local userL=new("TextLabel",{Position=UDim2.fromOffset(CP,px(70)),Size=UDim2.new(1,-(CP+textRight),0,px(18)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="@"..LP.Name,},wc)local chipH=even(px(30))local chips=new("Frame",{Position=UDim2.fromOffset(CP,wh-CP-chipH),Size=UDim2.new(1,-(CP+avatarS+px(24)),0,chipH),BackgroundTransparency=1,},wc)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(8)),SortOrder=Enum.SortOrder.LayoutOrder,},chips)local chipIcon=even(px(14))local function chip(order,iconName,text,color,clickable)local w=textW(text,px(12),T.fontSemi)local b=new(clickable and"TextButton"or"Frame",{Name=text,LayoutOrder=order,Size=UDim2.fromOffset(px(30)+w+px(12),chipH),BackgroundColor3=color or T.field,BackgroundTransparency=color and 0.86 or 0,},chips)if clickable then b.AutoButtonColor=false b.Text=""end corner(b,px(8))local st=stroke(b,color or T.fieldLine,color and 0.55 or 0)local ic=new("ImageLabel",{Position=UDim2.fromOffset(px(10),math.floor((chipH-chipIcon)/2)),Size=UDim2.fromOffset(chipIcon,chipIcon),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=color and color:Lerp(WHITE,0.2)or T.subtext,},b)local lb=new("TextLabel",{Position=UDim2.fromOffset(px(30),0),Size=UDim2.new(1,-px(30),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=color and color:Lerp(WHITE,0.35)or T.subtext,TextXAlignment=Enum.TextXAlignment.Left,Text=text,},b)local c={frame=b,icon=ic,label=lb,stroke=st}function c.setText(t)if lb.Text==t then return end lb.Text=t tween(b,0.25,{Size=UDim2.fromOffset(px(30)+textW(t,px(12),T.fontSemi)+px(12),chipH)})end return c end local function paintChip(c,on)tween(c.frame,0.22,{BackgroundColor3=on and C.accent or T.field,BackgroundTransparency=on and 0.84 or 0})tween(c.stroke,0.22,{Color=on and C.accent or T.fieldLine,Transparency=on and 0.45 or 0})tween(c.icon,0.22,{ImageColor3=on and C.accent:Lerp(WHITE,0.2)or T.subtext})tween(c.label,0.22,{TextColor3=on and T.text or T.subtext})end local function timeLeft()if o.TimeLeft then return tostring(o.TimeLeft)end local exp=tonumber(o.ExpiresAt)if not exp then return"Lifetime"end local s=exp-os.time()if s<=0 then return"Expired"end local d,h,m=s//86400,(s%86400)//3600,(s%3600)//60 if d>0 then return("%dd %dh left"):format(d,h)end if h>0 then return("%dh %dm left"):format(h,m)end return("%dm left"):format(math.max(m,1))end chip(1,o.PlanIcon or"gem",tostring(o.Plan or"Free"),C.accent,false)local timeChip=chip(2,"clock",timeLeft(),nil,false)local nameChip=chip(3,"eye-off","Name",nil,true)local avatarChip=chip(4,"user-x","Avatar",nil,true)for key,c in pairs({name=nameChip,avatar=avatarChip})do STATE.connect(c.frame.MouseEnter,function()if not privacy[key]then tween(c.stroke,0.15,{Color=T.fieldLineHot})tween(c.label,0.15,{TextColor3=T.text})end end)STATE.connect(c.frame.MouseLeave,function()if not privacy[key]then tween(c.stroke,0.2,{Color=T.fieldLine})tween(c.label,0.2,{TextColor3=T.subtext})end end)STATE.connect(c.frame.MouseButton1Click,function()setPrivacy(key,not privacy[key])end)end onPrivacy(function()nameL.Text=privacy.name and"Hidden"or LP.DisplayName userL.Text=privacy.name and"@hidden"or("@"..LP.Name)if avatar.Image~=""then tween(avatar,0.3,{ImageTransparency=privacy.avatar and 1 or 0})end paintChip(nameChip,privacy.name)paintChip(avatarChip,privacy.avatar)nameChip.icon.Image=privacy.name and ICON.eye or ICON["eye-off"]end)local wide=true local function fitWelcome()local w=wc.AbsoluteSize.X/math.max(pop.Scale,0.01)if w<=0 then return end local nowWide=w>=px(560)if nowWide==wide then return end wide=nowWide local right=wide and(CP+textRight)or CP*2 welcomeCap.Size=UDim2.new(1,-right,0,px(14))nameL.Size=UDim2.new(1,-right,0,px(34))userL.Size=UDim2.new(1,-right,0,px(18))chips.Size=UDim2.new(1,-(wide and(CP+avatarS+px(24))or CP*2),0,chipH)avatar.Visible=wide end STATE.connect(wc:GetPropertyChangedSignal("AbsoluteSize"),fitWelcome)task.defer(fitWelcome)n+=1 local quickRebuild=FEAT.quickCard(body,n,CP)local sh=px(180)local sc=card(sh,"Stats")local function metric(xScale,xOff,iconName,label)local holder=new("Frame",{Position=UDim2.new(xScale,xOff,0,px(18)),Size=UDim2.new(0.5,-(CP+px(12)),0,px(96)),BackgroundTransparency=1,},sc)local s13=even(px(13))new("ImageLabel",{Size=UDim2.fromOffset(s13,s13),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=T.muted},holder)caps(holder,label,UDim2.fromOffset(s13+px(6),0),UDim2.new(1,-(s13+px(6)),0,s13))local value=new("TextLabel",{Position=UDim2.fromOffset(0,px(18)),Size=UDim2.new(1,0,0,px(30)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(26),TextColor3=C.green,TextXAlignment=Enum.TextXAlignment.Left,Text="--",},holder)local graph=new("Frame",{Position=UDim2.fromOffset(0,px(56)),Size=UDim2.new(1,0,0,px(38)),BackgroundTransparency=1,ClipsDescendants=true,},holder)local bars={}for i=1,HIST do local bar=new("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new((i-1)/HIST,0,1,0),Size=UDim2.new(1/HIST,-px(3),0.06,0),BackgroundColor3=T.track,BackgroundTransparency=0.4,BorderSizePixel=0,},graph)corner(bar,px(2))bars[i]=bar end return value,bars end local fpsValue,fpsBars=metric(0,CP,"gauge","FPS")local pingValue,pingBars=metric(0.5,px(12),"wifi","Ping")local setFps=counter(fpsValue,function(v)return tostring(math.floor(v+0.5))end)local setPing=counter(pingValue,function(v)return math.floor(v+0.5).."ms"end)new("Frame",{Position=UDim2.fromOffset(CP,px(124)),Size=UDim2.new(1,-CP*2,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},sc)local statRow=new("Frame",{Position=UDim2.fromOffset(CP,px(136)),Size=UDim2.new(1,-CP*2,0,px(32)),BackgroundTransparency=1},sc)local function stat(i,label)local holder=new("Frame",{Position=UDim2.fromScale((i-1)/3,0),Size=UDim2.fromScale(1/3,1),BackgroundTransparency=1},statRow)local v=new("TextLabel",{Size=UDim2.new(1,0,0,px(18)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(16),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text="--",},holder)caps(holder,label,UDim2.fromOffset(0,px(20)),UDim2.new(1,0,0,px(12)))return v end local playersL=stat(1,"Players")local execsL=stat(2,"Execs")local sessionL=stat(3,"Session")execsL.Text=tostring(o.Execs or GEN)for _,e in ipairs({{"FPS","Frames per second"},{"Ping","Network latency"},{"Players","Players in this server"},{"Session","Time since the script started"},})do table.insert(page.rows,{r=sc,title=e[1],desc=e[2]})end table.insert(page.rows,{r=wc,title="Hide name",desc="Streamer mode: hide your name"})table.insert(page.rows,{r=wc,title="Hide avatar",desc="Streamer mode: hide your avatar"})local function grade(v,good,okay,lowerIsBetter)if lowerIsBetter then return v<=good and C.green or(v<=okay and C.amber or C.red)end return v>=good and C.green or(v>=okay and C.amber or C.red)end local function setBars(bars,hist,scaleMax,color,t)local N=#bars for i=1,N do local v=hist[#hist-N+i]local h=v and math.clamp(v/scaleMax,0.06,1)or 0.06 local last=i==N local goal={Size=UDim2.new(1/N,-px(3),h,0),BackgroundColor3=(last and v)and color or T.track,BackgroundTransparency=v and(last and 0 or 0.65*(1-i/N))or 0.6,}if t then tween(bars[i],t,goal)else for k,x in pairs(goal)do bars[i][k]=x end end end end local function updateMetrics(instant)local fc=grade(metrics.fps,50,30,false)local pc=grade(metrics.ping,90,180,true)setFps(metrics.fps,instant)setPing(metrics.ping,instant)tween(fpsValue,0.3,{TextColor3=fc})tween(pingValue,0.3,{TextColor3=pc})local fMax,pMax=60,150 for _,v in ipairs(metrics.fpsHist)do fMax=math.max(fMax,v)end for _,v in ipairs(metrics.pingHist)do pMax=math.max(pMax,v)end setBars(fpsBars,metrics.fpsHist,fMax*1.1,fc,not instant and 0.35 or nil)setBars(pingBars,metrics.pingHist,pMax*1.1,pc,not instant and 0.35 or nil)end table.insert(metricHooks,function()if homeVisible()then updateMetrics(false)end end)local iconS=even(px(50))local btnH=px(64)local gap=px(8)local srvH=CP+iconS+px(16)+btnH+px(14)+px(14)+CP local svc=card(srvH,"Server")local gIcon=new("ImageLabel",{Position=UDim2.fromOffset(CP,CP),Size=UDim2.fromOffset(iconS,iconS),BackgroundColor3=T.field,Image="",ImageTransparency=1,ScaleType=Enum.ScaleType.Crop,},svc)corner(gIcon,px(10))stroke(gIcon,T.fieldLine)task.spawn(function()local cands={("rbxthumb://type=GameIcon&id=%d&w=150&h=150"):format(game.PlaceId),("rbxthumb://type=GameIcon&id=%d&w=150&h=150"):format(game.GameId),("rbxthumb://type=Asset&id=%d&w=150&h=150"):format(game.PlaceId),}local chosenUrl=cands[1]for _,url in ipairs(cands)do local good=false pcall(function()ContentProvider:PreloadAsync({url},function(_,status)good=status==Enum.AssetFetchStatus.Success end)end)if good then chosenUrl=url break end end if gIcon.Parent then gIcon.Image=chosenUrl tween(gIcon,0.5,{ImageTransparency=0})end end)local gx=CP+iconS+px(14)local gName=new("TextLabel",{Position=UDim2.fromOffset(gx,CP+px(6)),Size=UDim2.new(1,-(gx+CP),0,px(20)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(16),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=gameInfo.name,},svc)local gSub=new("TextLabel",{Position=UDim2.fromOffset(gx,CP+px(29)),Size=UDim2.new(1,-(gx+CP),0,px(16)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},svc)local function playerCount()return("%d/%d"):format(#Players:GetPlayers(),Players.MaxPlayers)end local function refreshServer()gName.Text=gameInfo.name gSub.Text=("by %s  ·  %s players"):format(gameInfo.creator,playerCount())playersL.Text=playerCount()end onGameInfo(refreshServer)refreshServer()STATE.connect(Players.PlayerAdded,refreshServer)STATE.connect(Players.PlayerRemoving,function()task.defer(refreshServer)end)local grid=new("Frame",{Position=UDim2.fromOffset(CP,CP+iconS+px(16)),Size=UDim2.new(1,-CP*2,0,btnH),BackgroundTransparency=1,},svc)new("UIGridLayout",{CellSize=UDim2.new(0.25,-math.ceil(gap*3/4),0,btnH),CellPadding=UDim2.fromOffset(gap,0),SortOrder=Enum.SortOrder.LayoutOrder,},grid)local aIcon=even(px(18))local function action(order,iconName,label,fn)local b=new("TextButton",{Name=label,LayoutOrder=order,BackgroundColor3=T.field,AutoButtonColor=false,Text=""},grid)corner(b,px(10))local st=stroke(b,T.fieldLine)local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,px(14)),Size=UDim2.fromOffset(aIcon,aIcon),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=T.subtext,},b)local lb=new("TextLabel",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,px(38)),Size=UDim2.new(1,-px(8),0,px(16)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=T.subtext,Text=label,},b)table.insert(page.rows,{r=b,title=label,desc="Server action"})local busy=false STATE.connect(b.MouseEnter,function()tween(b,0.15,{BackgroundColor3=T.fieldHot})tween(st,0.15,{Color=T.fieldLineHot})tween(ic,0.25,{ImageColor3=C.accent,Position=UDim2.new(0.5,0,0,px(12))})tween(lb,0.15,{TextColor3=T.text})end)STATE.connect(b.MouseLeave,function()tween(b,0.2,{BackgroundColor3=T.field})tween(st,0.2,{Color=T.fieldLine})tween(ic,0.25,{ImageColor3=T.subtext,Position=UDim2.new(0.5,0,0,px(14))})tween(lb,0.2,{TextColor3=T.subtext})end)STATE.connect(b.MouseButton1Down,function()tween(b,0.08,{BackgroundColor3=T.rowActive})end)STATE.connect(b.MouseButton1Up,function()tween(b,0.2,{BackgroundColor3=T.fieldHot})end)STATE.connect(b.MouseButton1Click,function()if busy then return end busy=true lb.Text="..."task.spawn(function()local ok,err=pcall(fn)if not ok then notify({Title=label,Content=tostring(err),Icon="triangle-alert",Duration=5})end task.wait(0.6)busy=false if lb.Parent then lb.Text=label end end)end)end action(1,"refresh-cw","Rejoin",ACTIONS.rejoin)action(2,"shuffle","Hop",ACTIONS.hop)action(3,"users","Lowest",ACTIONS.lowest)action(4,"copy","Job ID",ACTIONS.jobid)local job=tostring(game.JobId)local shortJob=#job>12 and(job:sub(1,8).."..."..job:sub(-4))or(job~=""and job or"studio")new("TextLabel",{Position=UDim2.fromOffset(CP,srvH-CP-px(14)),Size=UDim2.new(1,-CP*2,0,px(14)),BackgroundTransparency=1,FontFace=T.mono,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=("Job %s  ·  Place %d"):format(shortJob,game.PlaceId),},svc)task.spawn(function()while STATE.alive()and mine()and wc.Parent do if homeVisible()then sessionL.Text=fmtSession(os.clock()-SESSION_START)timeChip.setText(timeLeft())end task.wait(1)end end)page.onShow=function()quickRebuild()sessionL.Text=fmtSession(os.clock()-SESSION_START)timeChip.setText(timeLeft())refreshServer()updateMetrics(true)end end end)()end local floatBtn,floatIcon,CONTROL_MODES,setControlMode,getControlMode do local island=(function()local H=math.max(even(px(40)),38)local PADX=math.floor(H*0.3)local ICS=even(H*0.45)local GAP=px(8)local INK=Color3.fromRGB(245,245,247)local present,hovering=false,false local springs={}local function spring(x,k,d)local s={x=x,v=0,t=x,k=k,d=d}table.insert(springs,s)return s end local W=spring(H,380,22)local Hh=spring(H,420,22)local Sq=spring(1,520,30)local root=new("Frame",{Name="MenuIsland",AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.fromOffset(H,H),BackgroundTransparency=1,Visible=false,ZIndex=50,},gui)local rootScale=new("UIScale",{},root)local shade=new("ImageLabel",{Name="Shadow",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,px(4)),Size=UDim2.new(1,px(40),1,px(40)),BackgroundTransparency=1,Image=SHADOW_IMAGE,ImageColor3=Color3.new(0,0,0),ImageTransparency=1,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(99,99,99,99),},root)local body=new("CanvasGroup",{Name="Body",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),GroupTransparency=1,Active=true,},root)new("UICorner",{CornerRadius=UDim.new(1,0)},body)local rim=stroke(body,WHITE,1)local main=new("CanvasGroup",{Name="Main",Size=UDim2.fromScale(1,1),BackgroundTransparency=1},body)local msg=new("CanvasGroup",{Name="Alert",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,GroupTransparency=1},body)local logo=new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,PADX,0.5,0),Size=UDim2.fromOffset(ICS,ICS),BackgroundTransparency=1,Image=ICON.layers,ImageColor3=C.accent,},main)local title=new("TextLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,PADX+ICS+GAP,0.5,0),Size=UDim2.fromOffset(10,H),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(13),TextColor3=INK,TextXAlignment=Enum.TextXAlignment.Left,Text="",},main)local dotS=even(px(8))local dot=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-(PADX+px(2)),0.5,0),Size=UDim2.fromOffset(dotS,dotS),BackgroundColor3=C.green,},main)local countL=new("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-(PADX+px(2)+dotS+px(7)),0.5,0),Size=UDim2.fromOffset(0,H),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=Color3.fromRGB(170,174,184),TextXAlignment=Enum.TextXAlignment.Right,Text="",},main)local countW=0 dot:SetAttribute("MonoNoTheme",true)new("UICorner",{CornerRadius=UDim.new(1,0)},dot)local halo=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(1,1),BackgroundColor3=C.green,BackgroundTransparency=1,},dot)new("UICorner",{CornerRadius=UDim.new(1,0)},halo)local chipH=H-px(12)local chipIcon=even(px(10))local chipW=px(9)+chipIcon+px(5)+textW("Close",px(12),T.fontSemi)+px(11)local CHIP_POS=UDim2.new(1,-px(6),0.5,0)local chip=new("CanvasGroup",{AnchorPoint=Vector2.new(1,0.5),Position=CHIP_POS+UDim2.fromOffset(px(10),0),Size=UDim2.fromOffset(chipW,chipH),BackgroundColor3=WHITE,BackgroundTransparency=0.86,GroupTransparency=1,},main)local msgIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,PADX,0.5,0),Size=UDim2.fromOffset(ICS,ICS),BackgroundTransparency=1,Image="",ImageColor3=C.green,},msg)local msgText=new("TextLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,PADX+ICS+GAP,0.5,0),Size=UDim2.fromOffset(10,H),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(13),TextColor3=INK,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},msg)local badge=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(7),0.5,0),Size=UDim2.fromOffset(px(40),H-px(14)),BackgroundColor3=C.green,BackgroundTransparency=0.78,},msg)new("UICorner",{CornerRadius=UDim.new(1,0)},badge)local badgeText=new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=C.green,Text="",},badge)msg:SetAttribute("MonoNoTheme",true)new("UICorner",{CornerRadius=UDim.new(1,0)},chip)new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(9),0.5,0),Size=UDim2.fromOffset(chipIcon,chipIcon),BackgroundTransparency=1,Image=ICON.x,ImageColor3=INK,},chip)new("TextLabel",{Position=UDim2.fromOffset(px(9)+chipIcon+px(5),0),Size=UDim2.new(1,-(px(9)+chipIcon+px(5)),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=INK,TextXAlignment=Enum.TextXAlignment.Left,Text="Close",},chip)local titleW=0 local function measure()title.RichText=true title.Text=brandTitle.Text local plain=brandTitle.ContentText~=""and brandTitle.ContentText or brandTitle.Text:gsub("<[^>]+>","")titleW=plain~=""and textW(plain,px(13),T.fontBold)or 0 title.Size=UDim2.fromOffset(titleW,H)end local function lead()return PADX+ICS+(titleW>0 and GAP+titleW or 0)end local function openW()return lead()+GAP*2+chipW+px(6)end local function closedW()return lead()+GAP+(countW>0 and countW+px(7)or 0)+dotS+PADX+px(2)end local flashing,flashW=false,0 local function wantW()if not present then return H*0.6 end if flashing then return flashW end return(shown and openW()or closedW())+(hovering and px(6)or 0)end local endFlash local function tweenAfter(inst,t,delay,goal)local tw=TweenService:Create(inst,TweenInfo.new(t,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,delay),goal)tw:Play()return tw end local function paint(quiet)W.t=wantW()if present and not quiet then Hh.v+=H*5 end if shown then tween(dot,0.12,{BackgroundTransparency=1})tween(halo,0.12,{BackgroundTransparency=1})tween(countL,0.12,{TextTransparency=1})chip.Position=CHIP_POS+UDim2.fromOffset(px(10),0)tweenAfter(chip,0.4,0.08,{GroupTransparency=0,Position=CHIP_POS})else tween(chip,0.12,{GroupTransparency=1})tweenAfter(dot,0.35,0.1,{BackgroundTransparency=0})tweenAfter(countL,0.35,0.1,{TextTransparency=0})end logo.ImageColor3=C.accent tween(logo,0.55,{Rotation=shown and 90 or 0},Enum.EasingStyle.Back)tween(rim,0.3,{Transparency=present and(shown and 0.8 or 0.9)or 1})end local function settled(s)return math.abs(s.x-s.t)<0.02 and math.abs(s.v)<0.02 end STATE.connect(RunService.RenderStepped,function(dt)if not root.Visible then return end local busy=false for _,s in ipairs(springs)do if not settled(s)then busy=true break end end if not busy then return end dt=math.min(dt,1/20)local n=math.max(1,math.ceil(dt*240))local h=dt/n for _=1,n do for _,s in ipairs(springs)do s.v+=(-s.k*(s.x-s.t)-s.d*s.v)*h s.x+=s.v*h end end for _,s in ipairs(springs)do if settled(s)then s.x,s.v=s.t,0 end end root.Size=UDim2.fromOffset(math.max(1,math.floor(W.x+0.5)),math.max(1,math.floor(Hh.x+0.5)))rootScale.Scale=Sq.x end)task.spawn(function()while STATE.alive()and mine()and root.Parent do if present and not shown then halo.Size,halo.BackgroundTransparency=UDim2.fromScale(1,1),0.4 tween(halo,1.4,{Size=UDim2.fromScale(2.8,2.8),BackgroundTransparency=1},Enum.EasingStyle.Quad)end task.wait(1.8)end end)local function clampPos(x,y)local vp=workspace.CurrentCamera.ViewportSize local hw=openW()/2+px(10)local hh=H/2+4 return math.clamp(x,hw,math.max(hw,vp.X-hw)),math.clamp(y,hh,math.max(hh,vp.Y-hh))end local function place(x,y)x,y=clampPos(x,y)root.Position=UDim2.fromOffset(math.floor(x),math.floor(y))end local active,startPos,startAt,moved STATE.connect(body.InputBegan,function(input)if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end if active or not present then return end active,moved=input,false startPos=input.Position startAt=Vector2.new(root.Position.X.Offset,root.Position.Y.Offset)Sq.t=0.92 end)STATE.connect(UIS.InputChanged,function(input)if not active then return end local isTouch=input.UserInputType==Enum.UserInputType.Touch if isTouch and input~=active then return end if not isTouch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end local d=Vector2.new(input.Position.X-startPos.X,input.Position.Y-startPos.Y)if not moved and d.Magnitude<8 then return end moved=true Sq.t=1.04 place(startAt.X+d.X,startAt.Y+d.Y)end)STATE.connect(UIS.InputEnded,function(input)if not active then return end if input~=active and not(active.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1)then return end active=nil Sq.t=1 Sq.v+=1.6 if moved then prefs.button={x=root.Position.X.Offset,y=root.Position.Y.Offset}savePrefs()else if flashing and endFlash then endFlash()end setShown(not shown)end end)if HOVER then STATE.connect(body.MouseEnter,function()hovering=true W.t=wantW()end)STATE.connect(body.MouseLeave,function()hovering=false W.t=wantW()end)end local function show(on)if on==present then return end present=on if on then measure()root.Visible=true W.x,W.v,Hh.x,Hh.v,Sq.x,Sq.v=H*0.6,0,H*0.6,0,1,0 Hh.t,Sq.t=H,1 root.Size=UDim2.fromOffset(math.floor(H*0.6),math.floor(H*0.6))tween(body,0.3,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(shade,0.5,{ImageTransparency=0.55})title.TextTransparency=1 tweenAfter(title,0.4,0.12,{TextTransparency=0})paint()else W.t,Hh.t=H*0.6,H*0.6 tween(shade,0.2,{ImageTransparency=1})tween(rim,0.2,{Transparency=1})tween(title,0.12,{TextTransparency=1})local tw=tween(body,0.28,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()if not present then root.Visible=false end end)end end local flashToken=0 endFlash=function()flashing=false tween(msg,0.15,{GroupTransparency=1},Enum.EasingStyle.Quad)tweenAfter(main,0.3,0.08,{GroupTransparency=0})W.t=wantW()end local function flash(iconName,text,color,badgeLabel,hold)if not present then return end flashToken+=1 local my=flashToken msgIcon.Image,msgIcon.ImageColor3=icon(iconName),color local textWidth=math.min(textW(text,px(13),T.fontBold),px(240))msgText.Text=text msgText.Size=UDim2.fromOffset(textWidth,H)local bw=0 if badgeLabel then bw=textW(badgeLabel,px(11),T.fontBold)+px(16)badge.Size=UDim2.fromOffset(bw,H-px(14))badge.BackgroundColor3,badgeText.TextColor3,badgeText.Text=color,color,badgeLabel end badge.Visible=badgeLabel~=nil flashW=PADX+ICS+GAP+textWidth+(badgeLabel and(GAP+bw+px(7))or PADX)flashing=true W.t=flashW Hh.v+=H*4 tween(main,0.12,{GroupTransparency=1},Enum.EasingStyle.Quad)tweenAfter(msg,0.3,0.05,{GroupTransparency=0})task.delay(hold or 1.6,function()if flashToken==my and flashing then endFlash()end end)end local function setCount(n)local t=n>0 and(n.." on")or""if countL.Text==t then return end countL.Text=t countW=t~=""and textW(t,px(12),T.fontSemi)or 0 countL.Size=UDim2.fromOffset(countW,H)if not flashing then W.t=wantW()end end CTRL.onChange(function(e,muted)setCount(CTRL.activeCount())if muted or not e or e.kind~="toggle"then return end local on=e.obj.Value if present then flash(on and"circle-check"or"circle",e.title,on and C.green or Color3.fromRGB(150,154,166),on and"ON"or"OFF")elseif not shown then notify({Title=e.title,Content=on and"Turned on"or"Turned off",Icon=on and"check"or"x",Duration=1.5})end end)FEAT.islandFlash=function(iconName,text,color)flash(iconName,text,color,nil,2)end setCount(CTRL.activeCount())measure()STATE.connect(brandTitle:GetPropertyChangedSignal("Text"),function()measure()W.t=wantW()end)do local x,y=VP.X/2,H/2+px(10)if type(prefs.button)=="table"and tonumber(prefs.button.x)and tonumber(prefs.button.y)then x,y=tonumber(prefs.button.x),tonumber(prefs.button.y)end place(x,y)end return{root=root,logo=logo,paint=paint,show=show}end)()floatBtn,floatIcon=island.root,island.logo paintFloat=function()island.paint()end onThemeChanged(function()island.paint(true)end)CONTROL_MODES=TOUCH and{"Auto","Mobile","PC + Mobile"}or{"Auto","PC","Mobile","PC + Mobile"}local controlMode=table.find(CONTROL_MODES,prefs.controls)and prefs.controls or"Auto"local function effectiveMode()if controlMode=="Auto"then return DEVICE=="PC"and"PC"or"Mobile"end return controlMode end local function applyControls()local m=effectiveMode()keyEnabled=m~="Mobile"island.show(m=="Mobile"or m=="PC + Mobile")end function setControlMode(mode,remember)if not table.find(CONTROL_MODES,mode)then return false end controlMode=mode if remember then prefs.controls=mode savePrefs()end applyControls()return true end applyControls()local hintShown=false STATE.connect(minBtn.MouseButton1Click,function()setShown(false)if not hintShown then hintShown=true local how=keyEnabled and("Press [%s] to open it again."):format(T.toggleKey.Name)or"Tap the island at the top of the screen to open it again."if keyEnabled and floatBtn.Visible then how=("Press [%s] or tap the island at the top to open it again."):format(T.toggleKey.Name)end notify({Title="Menu hidden",Content=how,Icon="info",Duration=3})end end)STATE.connect(profile.MouseButton1Click,function()if tabs.Home then selectTab("Home")end end)getControlMode=function()return controlMode end end local Lib={}local SECTION_ICONS={Overview="info",Interface="monitor",Appearance="palette",Presets="bookmark",General="settings",Script="power",Hotkey="keyboard",Movement="wind",Home="house",Seeds="refresh-cw",Trees="trees",Carving="hand",Selling="store",Delivery="package",["GIGA Planter"]="zap",Events="cloud-lightning",}local function makeTab(o)local name=tostring(o.Title or"Tab")local tab=tabs[name]or addTab(name,icon(o.Icon))local tabObj={name=name,sections=0}function tabObj:Section(so)so=so or{}local title=tostring(so.Title or"Section")self.sections+=1 local named=SECTION_ICONS[title]or(so.Icon and ICON[so.Icon]and so.Icon)or nil self.sec=addSection(tab,title,icon(named or"circle"))self.secIconSet=named~=nil self.page=self.sec.page self.group=group(self.page,nil)return self end local function g(self,iconName)if not self.group then self:Section({Title="Overview"})end if iconName and not self.secIconSet and ICON[iconName]then self.sec.icon.Image=ICON[iconName]self.secIconSet=true end return self.group end function tabObj:Toggle(e)return toggle(g(self,e.Icon),e)end function tabObj:Slider(e)return slider(g(self,e.Icon),e)end function tabObj:Dropdown(e)return dropdown(g(self,e.Icon),e)end function tabObj:Keybind(e)return keybind(g(self,e.Icon),e)end function tabObj:Paragraph(e)return paragraph(g(self,e.Icon),e)end function tabObj:Button(e)return button(g(self,e.Icon),e)end function tabObj:Input(e)return input(g(self,e.Icon),e)end function tabObj:KeyValue(e)return keyValue(g(self,e.Icon),e)end function tabObj:Label(e)return label(g(self),type(e)=="table"and e or{Text=e})end function tabObj:SetOrder(n)tab.nav.LayoutOrder=tonumber(n)or tab.index end function tabObj:Select()selectTab(name)end tabObj.Tab=tab function tabObj:Current()return g(self)end function tabObj:ThemePicker()return themePicker(g(self,"palette"))end function tabObj:ConfigManager()g(self,"folder-open")FEAT.configPage(self)if not FEAT.canFile then self:Paragraph({Title="Configs last until you leave",Desc="Your executor cannot write files, so saved configs are kept for this session only.",})end return FEAT.config end function tabObj:Divider()return{}end function tabObj:Space()return{}end function tabObj:Group(caption)g(self)if self.group.rows==0 then self.group.holder:Destroy()self.page.groups-=1 local i=table.find(self.page.groupList,self.group)if i then table.remove(self.page.groupList,i)end end self.group=group(self.page,caption)return self.group end return tabObj end local started=false local function openFirstTime()if not started then started=true pcall(FEAT.autoload)for _,fn in ipairs(CTRL.hooks)do pcall(fn,nil,true)end if not prefs.tipShown then prefs.tipShown=true savePrefs()task.delay(5,function()notify({Title="Tip",Content=(UIS.KeyboardEnabled and"Right-click"or"Long-press").." any setting to pin it to Home"..(UIS.KeyboardEnabled and", bind a key to it,"or"").." or reset it.",Icon="info",Duration=6,})end)end end if not opened then setShown(true)end end local Window={}function Window:Tab(o)return makeTab(o or{})end function Window:Section()return{Tab=function(_,o)return makeTab(o or{})end}end function Window:Home(o)o=o or{}local tabObj=makeTab({Title=o.Title or"Home",Icon=o.Icon or"house"})local tab=tabs[tabObj.name]local sec=addSection(tab,tabObj.name,icon("house"))buildHome(sec.page,o)return tabObj end function Window:SelectTab(i)local t=tabOrder[tonumber(i)or 1]if t then selectTab(t.name)end openFirstTime()end function Window:SetToggleKey(code)if typeof(code)=="EnumItem"then T.toggleKey=code end end function Window:GetDevice()return DEVICE end function Window:GetControlModes()return table.clone(CONTROL_MODES)end function Window:GetControlMode()return getControlMode()end function Window:SetControlMode(mode)return setControlMode(mode,true)end function Window:UsesKeybind()return keyEnabled end function Window:UsesButton()return floatBtn.Visible end function Window:SetUIScale(v)userScale=math.clamp(tonumber(v)or 1,0.5,2)if shown then tween(pop,0.25,{Scale=userScale})else pop.Scale=userScale end WIN.setSize(T.size)WIN.place(WIN.center())prefs.scale=userScale WIN.scaleSave=(WIN.scaleSave or 0)+1 local my=WIN.scaleSave task.delay(0.6,function()if WIN.scaleSave==my then savePrefs()end end)end function Window:GetUIScale()return userScale end function Window:SetSize(w,h)w,h=tonumber(w),tonumber(h)if not w or not h then return end WIN.setSize(Vector2.new(w,h))WIN.place(WIN.center(),true)WIN.save()end function Window:GetSize()return T.size end function Window:SetTheme(name)return applyTheme(name,true,true)end function Window:GetTheme()return currentTheme end function Window:Destroy()pcall(function()gui:Destroy()end)end function Window:Toggle()setShown(not shown)end function Window:Collapse(on)setCollapsed(on)end function Window:SetBlur(on)WIN.blur=on==true prefs.blur=WIN.blur savePrefs()if shown then WIN.blurTo(WIN.blur)end end function Window:GetBlur()return WIN.blur end function Window:SetOpacity(v)v=math.clamp(tonumber(v)or 1,0.6,1)WIN.alpha=1-v prefs.opacity=v savePrefs()if shown then tween(window,0.2,{GroupTransparency=WIN.alpha})end end function Window:GetOpacity()return 1-WIN.alpha end function Lib:CreateWindow(o)o=o or{}if typeof(o.ToggleKey)=="EnumItem"then T.toggleKey=o.ToggleKey end if o.Title or o.TitleAccent then setBrand(o.Title or"",o.TitleAccent or"")end if o.Author then brandSub.Text=tostring(o.Author)end if o.Icon then floatIcon.Image=icon(o.Icon)end if o.BadgeIcon then brandIcon.Image,brandIcon.Visible=icon(o.BadgeIcon),true local m=brandBadge:FindFirstChild("Monogram")if m then m.Visible=false end end if o.Theme and not prefs.theme then applyTheme(o.Theme,false,false)end if not o.NoAutoOpen then task.delay(2,openFirstTime)end return Window end function Lib:Notify(o)pcall(notify,o or{})end function Lib:Popup(o)pcall(popup,o or{})end function Lib:AddTheme(o)o=o or{}local base=o.Base or o.Background local accent=o.Accent if o.Name and typeof(base)=="Color3"and typeof(accent)=="Color3"then addTheme(o.Name,base,accent)if prefs.theme==tostring(o.Name)and currentTheme~=prefs.theme then applyTheme(prefs.theme,false,false)end end end function Lib:SetTheme(name)return applyTheme(name,true,true)end function Lib:GetThemes()return table.clone(THEME_ORDER)end function Lib:GetTheme()return currentTheme end function Lib:PresetSheet(tabObj,api)local Wd=api.words or{}local sg=tabObj:Current()local _,slot=row(sg,Wd.new or"New preset",Wd.desc or"Saves this game's settings under a name.")new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,px(8)),VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder},slot)local box=new("TextBox",{LayoutOrder=1,Size=UDim2.fromOffset(px(160),K.ctrlH),ClearTextOnFocus=false,BackgroundColor3=T.field,FontFace=T.font,TextSize=px(13),TextColor3=T.text,PlaceholderText=Wd.placeholder or"Preset name",PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,},slot)corner(box,px(9))local boxStroke=stroke(box,T.fieldLine)new("UIPadding",{PaddingLeft=UDim.new(0,px(10)),PaddingRight=UDim.new(0,px(10))},box)box.Focused:Connect(function()tween(boxStroke,0.2,{Color=C.accent})end)box.FocusLost:Connect(function()tween(boxStroke,0.2,{Color=T.fieldLine})end)local function pillButton(parent,iconName,text,light,order)local function rest()return light and C.accent or T.field end local function hot()return light and C.accent:Lerp(WHITE,0.15)or T.fieldHot end local function ink()return light and onAccent()or T.text end local b=new("TextButton",{LayoutOrder=order,Size=UDim2.fromOffset(textW(text,px(13),T.fontBold)+px(38),K.ctrlH),BackgroundColor3=rest(),AutoButtonColor=false,Text="",},parent)corner(b,px(9))if not light then stroke(b,T.fieldLine)end local s12=even(px(12))local ic=new("ImageLabel",{Position=UDim2.fromOffset(px(11),math.floor((K.ctrlH-s12)/2)),Size=UDim2.fromOffset(s12,s12),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=ink(),},b)local lb=new("TextLabel",{Position=UDim2.fromOffset(px(28),0),Size=UDim2.new(1,-px(32),1,0),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(13),TextColor3=ink(),TextXAlignment=Enum.TextXAlignment.Left,Text=text,},b)if light then onThemeChanged(function()if b.Parent then ic.ImageColor3,lb.TextColor3=ink(),ink()end end)end b.MouseEnter:Connect(function()tween(b,0.15,{BackgroundColor3=hot()})end)b.MouseLeave:Connect(function()tween(b,0.2,{BackgroundColor3=rest()})end)return b end local saveBtn=pillButton(slot,"save","Save",true,2)local function save()local name=box.Text:gsub("^%s+",""):gsub("%s+$","")if name==""then api.save(name)return end if api.exists(name)then popup({Title="Overwrite preset",Content=("A preset called \"%s\" already exists. Replace it with the current settings?"):format(name),Buttons={{Title="Cancel"},{Title="Overwrite",Variant="Primary",Callback=function()api.save(name)end}}})else api.save(name)end box.Text=""end STATE.connect(saveBtn.MouseButton1Click,save)STATE.connect(box.FocusLost,function(enter)if enter then save()end end)local listGroup=group(tabObj.page,Wd.list or"Saved presets")local sheet={}function sheet.rebuild()for _,c in ipairs(listGroup.card:GetChildren())do if c:IsA("Frame")then c:Destroy()end end listGroup.rows=0 local keep={}for _,it in ipairs(tabObj.page.rows)do if it.g~=listGroup then table.insert(keep,it)end end tabObj.page.rows=keep local names=api.names()local auto=api.autoload()if#names==0 then row(listGroup,Wd.empty or"No presets yet",Wd.emptyDesc or"Name one above and press Save.")return end for _,name in ipairs(names)do local _,s=row(listGroup,name,auto==name and(Wd.auto or"Loads when you join this game.")or nil,auto==name and{"On start"}or nil)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,px(6)),VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder},s)local star=new("ImageButton",{LayoutOrder=1,Size=UDim2.fromOffset(K.ctrlH,K.ctrlH),BackgroundTransparency=1,Image="",AutoButtonColor=false},s)local s14=even(px(14))new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(s14,s14),BackgroundTransparency=1,Image=ICON.star,ImageColor3=auto==name and C.amber or T.muted,},star)local load=pillButton(s,"play","Load",true,2)local del=new("ImageButton",{LayoutOrder=3,Size=UDim2.fromOffset(K.ctrlH,K.ctrlH),BackgroundColor3=T.field,Image="",AutoButtonColor=false},s)corner(del,px(9))stroke(del,T.fieldLine)local delIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(s14,s14),BackgroundTransparency=1,Image=ICON["trash-2"],ImageColor3=T.subtext,},del)del.MouseEnter:Connect(function()tween(delIcon,0.15,{ImageColor3=C.red})end)del.MouseLeave:Connect(function()tween(delIcon,0.2,{ImageColor3=T.subtext})end)star.MouseButton1Click:Connect(function()api.setAutoload(auto~=name and name or nil)end)load.MouseButton1Click:Connect(function()api.load(name)end)del.MouseButton1Click:Connect(function()popup({Title="Delete preset",Content=("Delete \"%s\"? This cannot be undone."):format(name),Buttons={{Title="Cancel"},{Title="Delete",Variant="Danger",Callback=function()api.delete(name)end}}})end)end end return sheet end Lib.ScreenGui=gui Lib.window=window Lib.select=selectTab Lib.selectSection=selectSection Lib.collapse=setCollapsed Lib.show=function()setShown(true)end Lib.hide=function()setShown(false)end Lib._k={T=T,C=C,ICON=ICON,icon=icon,px=px,even=even,new=new,corner=corner,stroke=stroke,tween=tween,THEMES=THEMES,THEME_ORDER=THEME_ORDER,applyTheme=applyTheme,theme=function()return currentTheme end,onThemeChanged=onThemeChanged,CTRL=CTRL,K=K,capture=capture,prefs=prefs,savePrefs=savePrefs,group=group,row=row,toggle=toggle,slider=slider,dropdown=dropdown,keybind=keybind,paragraph=paragraph,button=button,input=input,keyValue=keyValue,label=label,notify=notify,popup=popup,closePopup=function()if closePopup then closePopup()end end,tabs=tabs,selectTab=selectTab,setShown=setShown,isShown=function()return shown end,isOpened=function()return opened end,openFirstTime=openFirstTime,shell=shell,window=window,gui=gui,STATE=STATE,mine=mine,}return Lib end)()return(function()local k=WindUI._k local T,C=k.T,k.C local NOOP=function()end local Kit={VERSION=KIT_VERSION,Lib=WindUI}local function safe(fn,... )if type(fn)~="function"then return end local ok,err=pcall(fn,... )if not ok then warn("[SPECTREWARE] callback error: "..tostring(err))end end local function soft(t)return setmetatable(t,{__index=function(_,key)if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end local function toKeyCode(v)if typeof(v)=="EnumItem"then return v end if type(v)=="string"and v~=""then local ok,code=pcall(function()return Enum.KeyCode[v]end)if ok then return code end end return nil end local unloadHooks,unloaded={},false function Kit.OnUnload(fn)if type(fn)=="function"then table.insert(unloadHooks,fn)end end local function runHooks()if unloaded then return end unloaded=true for _,fn in ipairs(unloadHooks)do safe(fn)end end function Kit.Unload()runHooks()pcall(STATE.teardown)end STATE.onCleanup(runHooks)local function notify(cfg,kind)if type(cfg)~="table"then cfg={Content=tostring(cfg)}end local kd=tostring(cfg.Kind or cfg.Type or kind or""):lower()local ic=cfg.Icon if type(ic)~="string"or ic:find("^rbxasset")then ic=(kd=="success"and"check")or((kd=="warning"or kd=="warn")and"triangle-alert")or((kd=="error"or kd=="danger")and"x")or"info"end local content=tostring(cfg.Content or cfg.Text or cfg.Description or cfg.Desc or"")if cfg.SubContent and cfg.SubContent~=""then content=content.."\n"..tostring(cfg.SubContent)end pcall(k.notify,{Title=tostring(cfg.Title or cfg.Name or"SPECTREWARE"),Content=content,Duration=tonumber(cfg.Duration)or 4,Icon=ic,})end Kit.Notify=notify local Win,menuKeyCtrl local loadedFns={}local function open()if not Win then return end if not k.isOpened()then Win:SelectTab(1)for _,fn in ipairs(loadedFns)do task.spawn(safe,fn)end table.clear(loadedFns)else k.setShown(true)end end Kit.Open=open local touchToken=0 local function touch()if k.isOpened()then return end touchToken+=1 local my=touchToken task.delay(1.5,function()if my==touchToken and not k.isOpened()then open()end end)end local keyListeners={}local function rememberKey(code)if k.prefs.menuKey~=code.Name then k.prefs.menuKey=code.Name pcall(k.savePrefs)end for _,fn in ipairs(keyListeners)do safe(fn,code)end end function Kit.SetToggleKey(code)code=toKeyCode(code)if not code or not Win then return end Win:SetToggleKey(code)if menuKeyCtrl and menuKeyCtrl.Value~=code.Name then pcall(function()menuKeyCtrl:Set(code)end)end rememberKey(code)end function Kit.GetToggleKey()return k.T.toggleKey end function Kit.OnToggleKeyChanged(fn)if type(fn)=="function"then table.insert(keyListeners,fn)end end local function buildSettings()local S=Win:Tab({Title="Settings",Icon="settings"})S:SetOrder(10000)S:Section({Title="General"})S:Group("Device")S:Dropdown({Title="Menu Controls",Desc=("Detected: %s. Auto uses the %s. PC = keybind, Mobile = island at the top, PC + Mobile = both."):format(Win:GetDevice(),Win:GetDevice()=="PC"and"keybind"or"island at the top"),Values=Win:GetControlModes(),Value=Win:GetControlMode(),Search=false,Config=false,Callback=function(mode)Win:SetControlMode(mode)notify({Title="Menu Controls: "..mode,Kind="Success",Duration=3,Content=Win:UsesButton()and"Tap the island at the top to open or close the menu. Drag it to move it."or"Use your menu key to open or close the menu.",})end,})S:Group("Interface")menuKeyCtrl=S:Keybind({Title="Menu Toggle Key",Desc="Click and press a key to change the show/hide hotkey.",Value=T.toggleKey.Name,Callback=function(name)local code=toKeyCode(name)if code then Win:SetToggleKey(code)rememberKey(code)end end,})S:Group("Appearance")S:ThemePicker()S:Toggle({Title="Blur Background",Desc="Blur the game behind the menu while it is open.",Icon="droplet",Value=Win:GetBlur(),Callback=function(on)Win:SetBlur(on)end})S:Slider({Title="Window Opacity",Desc="Lower it to see the game through the menu. Below 100% text looks a little softer on phones.",Value={Min=60,Max=100,Default=math.floor(Win:GetOpacity()*100+0.5)},Step=5,Suffix="%",Callback=function(v)Win:SetOpacity(v/100)end})S:Slider({Title="UI Scale",Desc="Adjust the size of the menu window.",Value={Min=0.7,Max=1.3,Default=Win:GetUIScale()},Step=0.05,Callback=function(v)Win:SetUIScale(v)end})S:Group("Script")S:Button({Title="Unload Script",Desc="Stop every feature and remove the menu from the game.",Icon="power",Callback=function()k.popup({Icon="power",Title="Unload script?",Content="The menu and everything it runs will be removed from the game. You'll need to execute the script again to get it back.",Buttons={{Title="Cancel"},{Title="Unload",Variant="Danger",Callback=function()task.defer(Kit.Unload)end}},})end,})S:Section({Title="Configs"})S:ConfigManager()return S end function Kit.Init(cfg)if Win then return Win end cfg=cfg or{}Win=WindUI:CreateWindow({Title="SPECTRE",TitleAccent="WARE",Author="v"..KIT_VERSION,Icon="layers",ToggleKey=toKeyCode(k.prefs.menuKey)or toKeyCode(cfg.ToggleKey)or Enum.KeyCode.RightShift,NoAutoOpen=true,})Win:Home({Plan=cfg.Plan or"Free",ExpiresAt=cfg.ExpiresAt,TimeLeft=cfg.TimeLeft})buildSettings()k.STATE.connect(k.shell:GetPropertyChangedSignal("Visible"),function()local v=k.shell.Visible if v==k.isShown()then return end if v then k.shell.Visible=false open()else k.setShown(false)end end)task.delay(8,function()if not k.isOpened()then open()end end)return Win end Kit.Window=function()return Win end local function gameTab(name,iconName)name=tostring(name or"Tab")local low=name:lower()if low=="settings"or low=="setting"then local tabObj=Win:Tab({Title="Settings"})tabObj:Section({Title="Game"})return tabObj,"Settings"end if low=="home"then name="Overview"end local tabObj=Win:Tab({Title=name,Icon=iconName})tabObj:Section({Title=name})touch()return tabObj,name end local THEME_FACE={Font=Enum.Font.GothamMedium,FontBold=Enum.Font.GothamBold,Text=T.text,SubText=T.subtext,Accent=C.accent,Background=T.bg,Panel=T.side,Card=T.card,Control=T.field,Border=T.border,}local function findTab(list,x)if type(x)=="number"then return list[x]end if type(x)=="string"then for _,t in ipairs(list)do if t.Name==x then return t end end return nil end return x end local function titleLabelOf(entry)local r=type(entry)=="table"and entry.row or nil local col=r and r:FindFirstChild("Text")local line=col and col:FindFirstChild("TitleLine")return line and line:FindFirstChild("Title")end local function ctrlObj(get)return setmetatable({},{__index=function(_,key)if key=="Value"then return get()end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end local function dialog(cfg)cfg=cfg or{}local buttons={}local list=cfg.Buttons or{}for i,b in ipairs(list)do buttons[i]={Title=tostring(b.Title or b.Name or"OK"),Variant=(b.Primary or b.Variant=="Primary"or i==#list)and"Primary"or nil,Callback=function()safe(b.Callback)end,}end if#buttons==0 then buttons={{Title="OK",Variant="Primary"}}end k.popup({Title=tostring(cfg.Title or""),Content=tostring(cfg.Content or cfg.Text or""),Icon=cfg.Icon,Buttons=buttons})end local function setTheme(name)name=tostring(name)if k.THEMES[name]then k.applyTheme(name,true,true)end end local SUI={Flags={},Objects={},Themes={},Version=KIT_VERSION,_flagCbs={}}local function setFlag(cfg,v)if not cfg.Flag then return end local prev=SUI.Flags[cfg.Flag]SUI.Flags[cfg.Flag]=v if prev~=v then for _,cb in ipairs(SUI._flagCbs)do safe(cb,cfg.Flag,v,prev)end end end local function reg(cfg,obj)if cfg.Flag then SUI.Objects[cfg.Flag]=obj end touch()return obj end local function nameOf(cfg,fallback)return tostring(cfg.Name or cfg.Title or cfg.Text or fallback)end local function descOf(cfg)return cfg.Tooltip or cfg.Description or cfg.Desc or cfg.Info end local SectionM={}local function newSection(g)local s={_g=g,Body=g.card,Frame=g.holder,Controls={},Window={Theme=THEME_FACE}}return setmetatable(s,{__index=function(_,key)local m=SectionM[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end function SectionM:CreateToggle(cfg)cfg=type(cfg)=="table"and cfg or{Name=cfg}local silent=false local raw=k.toggle(self._g,{Title=nameOf(cfg,"Toggle"),Desc=descOf(cfg),Value=cfg.Default==true or cfg.CurrentValue==true,Flag=cfg.Flag,Config=cfg.Config,Callback=function(v)setFlag(cfg,v)if not silent then safe(cfg.Callback,v)end end,})setFlag(cfg,raw.Value)local obj=ctrlObj(function()return raw.Value end)function obj:Set(v,s)silent=s==true raw:Set(v and true or false)silent=false end function obj:Get()return raw.Value end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end function SectionM:CreateSlider(cfg)cfg=cfg or{}local silent=false local range=type(cfg.Range)=="table"and cfg.Range or{}local mn,mx=tonumber(cfg.Min or range[1])or 0,tonumber(cfg.Max or range[2])or 100 local raw=k.slider(self._g,{Title=nameOf(cfg,"Slider"),Desc=descOf(cfg),Value={Min=mn,Max=mx,Default=tonumber(cfg.Default or cfg.CurrentValue)or mn},Step=tonumber(cfg.Increment or cfg.Step)or 1,Suffix=cfg.Suffix,Flag=cfg.Flag,Config=cfg.Config,Callback=function(v)setFlag(cfg,v)if not silent then safe(cfg.Callback,v)end end,})setFlag(cfg,raw.Value)local obj=ctrlObj(function()return raw.Value end)function obj:Set(v,s)silent=s==true raw:Set(v)silent=false end function obj:Get()return raw.Value end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end function SectionM:CreateDropdown(cfg)cfg=cfg or{}local silent=false local multi=cfg.Multi==true or cfg.MultipleOptions==true local default=cfg.Default if default==nil then default=cfg.CurrentOption end local raw=k.dropdown(self._g,{Title=nameOf(cfg,"Dropdown"),Desc=descOf(cfg),Values=cfg.Options or cfg.Values or{},Value=default,Multi=multi,AllowNone=default==nil,Search=cfg.Searchable,Flag=cfg.Flag,Config=cfg.Config,Callback=function(v)setFlag(cfg,v)if not silent then safe(cfg.Callback,v)end end,})setFlag(cfg,raw.Value)local obj=ctrlObj(function()return raw.Value end)function obj:Set(v,s)silent=s==true raw:Select(v)silent=false end function obj:Get()return raw.Value end function obj:Refresh(list)raw:Refresh(list or{})end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end function SectionM:CreateButton(cfg,cb)cfg=type(cfg)=="table"and cfg or{Name=cfg,Callback=cb}local raw=k.button(self._g,{Title=nameOf(cfg,"Button"),Desc=descOf(cfg),Icon=cfg.Icon,Callback=function()safe(cfg.Callback)end,})local obj=soft({Frame=raw.entry and raw.entry.row})function obj:SetText(t)local l=titleLabelOf(raw.entry)if l then l.Text=tostring(t)end end obj.SetTitle=obj.SetText function obj:Fire()raw.Run()end touch()return obj end function SectionM:CreateTextbox(cfg)cfg=cfg or{}local silent=false local raw=k.input(self._g,{Title=nameOf(cfg,"Text"),Desc=descOf(cfg),Value=cfg.Default or cfg.CurrentValue,Placeholder=cfg.Placeholder or cfg.PlaceholderText,Numeric=cfg.Numeric,Min=cfg.Min,Max=cfg.Max,MaxLength=cfg.MaxLength,ClearOnFocus=cfg.ClearOnFocus or cfg.ClearTextOnFocus,Live=cfg.Live==true,Flag=cfg.Flag,Config=cfg.Config,Callback=function(v)setFlag(cfg,v)if not silent then safe(cfg.Callback,v)end end,})setFlag(cfg,raw.Value)local obj=ctrlObj(function()return raw.Value end)function obj:Set(v,s)silent=s==true raw:Set(v)silent=false end function obj:Get()return raw.Value end function obj:GetText()return raw.Box.Text end function obj:Clear()raw.Box.Text=""end function obj:Focus()raw.Box:CaptureFocus()end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end SectionM.CreateInput=SectionM.CreateTextbox local function keyMatches(raw,input)local v=raw.Value if not v then return false end if input.KeyCode~=Enum.KeyCode.Unknown then return input.KeyCode.Name==v end return input.UserInputType.Name==v end function SectionM:CreateKeybind(cfg)cfg=cfg or{}local mode=cfg.Mode or"Press"local state,silent=false,false local d=toKeyCode(cfg.Default)local raw=k.keybind(self._g,{Title=nameOf(cfg,"Keybind"),Desc=descOf(cfg),Value=d and d.Name or(type(cfg.Default)=="string"and cfg.Default or nil),Flag=cfg.Flag,Config=cfg.Config,Callback=function(name)local code=toKeyCode(name)setFlag(cfg,code)state=false if not silent then safe(cfg.Changed or cfg.ChangedCallback,code)end end,})setFlag(cfg,toKeyCode(raw.Value))k.STATE.connect(UIS.InputBegan,function(input,gp)if gp or raw.Picking or k.capture.active or not k.mine()then return end if not keyMatches(raw,input)then return end if mode=="Hold"then state=true safe(cfg.Callback,true)elseif mode=="Toggle"then state=not state safe(cfg.Callback,state)else safe(cfg.Callback)end end)k.STATE.connect(UIS.InputEnded,function(input)if mode=="Hold"and state and keyMatches(raw,input)then state=false safe(cfg.Callback,false)end end)local obj=ctrlObj(function()return toKeyCode(raw.Value)end)function obj:Set(v,s)silent=s==true raw:Set(toKeyCode(v)or v)silent=false end function obj:Get()return toKeyCode(raw.Value)end function obj:GetState()return state end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end function SectionM:CreateParagraph(cfg)cfg=cfg or{}local raw=k.paragraph(self._g,{Title=tostring(cfg.Title or cfg.Name or""),Desc=tostring(cfg.Content or cfg.Desc or cfg.Text or"")})local obj=soft({})function obj:Set(t,c)if t~=nil then raw:SetTitle(t)end if c~=nil then raw:SetDesc(c)end end function obj:SetTitle(t)raw:SetTitle(t)end function obj:SetDesc(t)raw:SetDesc(t)end obj.SetContent=obj.SetDesc touch()return obj end function SectionM:CreateLabel(cfg)cfg=type(cfg)=="table"and cfg or{Text=cfg}local raw=k.label(self._g,{Text=cfg.Text or cfg.Name or"",Color=cfg.Color,Bold=cfg.Bold})local obj=soft({Frame=raw.Frame})function obj:Set(t)raw:Set(t)end function obj:SetColor(c)raw:SetColor(c)end return obj end function SectionM:CreateKeyValue(cfg)cfg=cfg or{}local raw=k.keyValue(self._g,{Title=nameOf(cfg,""),Value=cfg.Value,Color=cfg.Color})local obj=ctrlObj(function()return raw.Value end)function obj:Set(v)raw:Set(v)end function obj:Get()return raw.Value end function obj:SetColor(c)raw:SetColor(c)end return obj end function SectionM:CreateColorPicker(cfg)cfg=cfg or{}local value=cfg.Default or Color3.new(1,1,1)local obj=ctrlObj(function()return value end)function obj:Set(c,s)value=c if not s then safe(cfg.Callback,c)end end function obj:Get()return value end return reg(cfg,obj)end function SectionM:CreateDivider()return soft({})end SectionM.CreateSeparator=SectionM.CreateDivider function SectionM:SetCollapsed(on)if self._g.setFolded then self._g.setFolded(on==true,true)end end local TabM={}local function newSTab(tabObj,name)local t={_tabObj=tabObj,Name=name,Sections={},Window={Theme=THEME_FACE}}return setmetatable(t,{__index=function(_,key)local m=TabM[key]if m~=nil then return m end if type(key)=="string"and SectionM[key]then return function(self,... )return SectionM[key](self:_implicit(),... )end end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end function TabM:CreateSection(cfg)local title=type(cfg)=="table"and(cfg.Name or cfg.Title)or cfg title=(title~=nil and tostring(title)~="")and tostring(title)or nil local g=self._tabObj:Group(title)local s=newSection(g)table.insert(self.Sections,s)if type(cfg)=="table"and cfg.Collapsed and g.setFolded then task.defer(g.setFolded,true,false)end touch()return s end function TabM:_implicit()local first=rawget(self,"_first")if not first then first=self:CreateSection(nil)rawset(self,"_first",first)end return first end function TabM:Select()self._tabObj:Select()end local SWindowM={}local function newSWindow()local w={Tabs={},Conns={},Main=k.shell,Root=k.shell,Theme=THEME_FACE}return setmetatable(w,{__index=function(_,key)if key=="Visible"then return k.isShown()end if key=="ThemeName"then return k.theme()end local m=SWindowM[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end function SWindowM:CreateTab(cfg,iconName)local name=type(cfg)=="table"and(cfg.Name or cfg.Title)or cfg local tabObj,shownName=gameTab(name,type(cfg)=="table"and cfg.Icon or iconName)local t=newSTab(tabObj,shownName)table.insert(self.Tabs,t)return t end function SWindowM:SelectTab(x)if not k.isOpened()then return end local t=findTab(self.Tabs,x)if type(t)=="table"and t._tabObj then t._tabObj:Select()end end SWindowM.SetTab=SWindowM.SelectTab SWindowM.Goto=SWindowM.SelectTab function SWindowM:GetTab(name)return findTab(self.Tabs,name)end function SWindowM:Notify(cfg)notify(cfg)end function SWindowM:Toast(text,kind)notify({Title=kind and tostring(kind)or"SPECTREWARE",Content=text,Kind=kind})end function SWindowM:Info(t,c,d)notify({Title=t,Content=c,Duration=d})end function SWindowM:Success(t,c,d)notify({Title=t,Content=c,Duration=d,Kind="Success"})end function SWindowM:Warning(t,c,d)notify({Title=t,Content=c,Duration=d,Kind="Warning"})end function SWindowM:Error(t,c,d)notify({Title=t,Content=c,Duration=d,Kind="Error"})end function SWindowM:SetVisible(v)if v then open()else k.setShown(false)end end function SWindowM:Toggle()if k.isShown()then k.setShown(false)else open()end end function SWindowM:Open()open()end function SWindowM:Close()k.setShown(false)end function SWindowM:Resize(w,h)Win:SetSize(w,h)end SWindowM.SetSize=SWindowM.Resize function SWindowM:IsOpen()return k.isShown()end function SWindowM:Destroy()Kit.Unload()end SWindowM.Unload=SWindowM.Destroy function SWindowM:SetTheme(name)setTheme(name)end function SWindowM:GetThemeName()return k.theme()end function SWindowM:SetToggleKey(key)Kit.SetToggleKey(key)end function SWindowM:GetToggleKey()return T.toggleKey end function SWindowM:OnLoaded(fn)if k.isOpened()then task.spawn(safe,fn)else table.insert(loadedFns,fn)end end function SWindowM:FinishLoading()open()end function SWindowM:CreateDefaultTabs()return nil end function SWindowM:CreateSettingsTab()local tabObj=gameTab("Settings")return newSTab(tabObj,"Settings")end SWindowM.CreateThemeTab=SWindowM.CreateSettingsTab function SWindowM:Dialog(cfg)dialog(cfg)end function SWindowM:Confirm(cfg)cfg=cfg or{}k.popup({Title=tostring(cfg.Title or"Are you sure?"),Content=tostring(cfg.Content or cfg.Text or""),Icon=cfg.Icon,Buttons={{Title=tostring(cfg.No or cfg.Cancel or"Cancel"),Callback=function()safe(cfg.Callback,false)end},{Title=tostring(cfg.Yes or cfg.Confirm or"Confirm"),Variant="Primary",Callback=function()safe(cfg.Callback,true)end},},})end function SWindowM:Watermark()return soft({})end function SWindowM:KeybindList()return soft({})end local theWindow function SUI:CreateWindow(cfg)cfg=cfg or{}Kit.Init({ToggleKey=cfg.ToggleKey})theWindow=theWindow or newSWindow()return theWindow end function SUI:Notify(cfg)notify(cfg)end function SUI:Toast(text,kind)notify({Title=kind and tostring(kind)or"SPECTREWARE",Content=text,Kind=kind})end function SUI:SetTheme(name)setTheme(name)end function SUI:ListThemes()return table.clone(k.THEME_ORDER)end function SUI:GetTheme(name)return k.THEMES[tostring(name or k.theme())]end function SUI:OnFlag(cb)table.insert(SUI._flagCbs,cb)return{Disconnect=function()local i=table.find(SUI._flagCbs,cb)if i then table.remove(SUI._flagCbs,i)end end}end function SUI:SetFlag(flag,v,silent)local o=SUI.Objects[flag]if o and o.Set then o:Set(v,silent)end end function SUI:GetFlags()return table.clone(SUI.Flags)end function SUI:GetControl(flag)return SUI.Objects[flag]end function SUI:Unload()Kit.Unload()end function SUI:Copy(text)local set=setclipboard or toclipboard if set then pcall(set,tostring(text))notify({Title="Copied",Content=tostring(text),Kind="Success",Duration=2})end end function SUI:Dialog(cfg)dialog(cfg)end function SUI:Confirm(cfg)if theWindow then theWindow:Confirm(cfg)end end setmetatable(SUI,{__index=function(_,key)if key=="ThemeName"then return k.theme()end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})Kit.SpectreUI=SUI local FL={Options={},Themes=table.clone(k.THEME_ORDER),OpenFrames={},Version=KIT_VERSION}local HandleM={}local function newHandle(kind,id,get,set)local h={Type=kind,_changed={},_get=get,_set=set}setmetatable(h,{__index=function(_,key)if key=="Value"then return get()end local m=HandleM[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end,__newindex=function(t,key,v)if key=="Value"then set(v)else rawset(t,key,v)end end,})if id then FL.Options[id]=h end touch()return h end function HandleM:OnChanged(fn)if type(fn)=="function"then table.insert(self._changed,fn)end end function HandleM:SetValue(v)self._set(v)end function HandleM:GetValue()return self._get()end function HandleM:_fire(... )for _,fn in ipairs(self._changed)do safe(fn,... )end end function HandleM:Destroy()local r=rawget(self,"_row")if r then r.Visible=false end end function HandleM:SetDesc(text)local r=rawget(self,"_row")local col=r and r:FindFirstChild("Text")if not col then return end text=tostring(text or"")local d=col:FindFirstChild("Desc")if not d then if text==""then return end d=k.new("TextLabel",{Name="Desc",LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=k.K.desc,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text=text,},col)end d.Text=text end function HandleM:SetTitle(text)local lbl=titleLabelOf({row=rawget(self,"_row")})if lbl then lbl.Text=tostring(text or"")end end local function toMap(list)local m={}if type(list)=="table"then for key,v in pairs(list)do if type(key)=="number"then m[v]=true elseif v then m[key]=true end end end return m end local function hex(c)return("#%02X%02X%02X"):format(math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))end local Adders={}function Adders:AddToggle(id,cfg)cfg=cfg or{}local h local raw=k.toggle(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Value=cfg.Default==true,Flag=id,Callback=function(v)safe(cfg.Callback,v)if h then h:_fire(v)end end,})h=newHandle("Toggle",id,function()return raw.Value end,function(v)raw:Set(v==true)end)rawset(h,"_row",raw.entry and raw.entry.row)return h end function Adders:AddSlider(id,cfg)cfg=cfg or{}local h local rounding=tonumber(cfg.Rounding)or 0 local step=tonumber(cfg.Step or cfg.Increment)or(10^-math.max(rounding,0))local mn,mx=tonumber(cfg.Min)or 0,tonumber(cfg.Max)or 100 local raw=k.slider(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Value={Min=mn,Max=mx,Default=tonumber(cfg.Default)or mn},Step=step,Suffix=cfg.Suffix,Flag=id,Callback=function(v)safe(cfg.Callback,v)if h then h:_fire(v)end end,})h=newHandle("Slider",id,function()return raw.Value end,function(v)raw:Set(tonumber(v)or mn)end)rawset(h,"_row",raw.entry and raw.entry.row)return h end function Adders:AddDropdown(id,cfg)cfg=cfg or{}local h local values=cfg.Values or cfg.Options or{}local multi=cfg.Multi==true local default=cfg.Default if type(default)=="number"and values[default]~=nil then default=values[default]end local function out(v)if multi then return toMap(v)end return v end local raw=k.dropdown(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Values=values,Value=default,Multi=multi,AllowNone=cfg.AllowNull==true or default==nil,Search=cfg.Searchable,Flag=id,Callback=function(v)safe(cfg.Callback,out(v))if h then h:_fire(out(v))end end,})h=newHandle("Dropdown",id,function()return out(raw.Value)end,function(v)raw:Select(v)end)rawset(h,"_row",raw.entry and raw.entry.row)rawset(h,"Multi",multi)rawset(h,"Values",values)function h:SetValues(list)rawset(h,"Values",list or{})raw:Refresh(list or{})end return h end function Adders:AddInput(id,cfg)cfg=cfg or{}local h local raw=k.input(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Value=cfg.Default,Placeholder=cfg.Placeholder,Numeric=cfg.Numeric,MaxLength=cfg.MaxLength,Live=cfg.Finished~=true,Flag=id,Callback=function(v)safe(cfg.Callback,v)if h then h:_fire(v)end end,})h=newHandle("Input",id,function()return raw.Value end,function(v)raw:Set(v)end)rawset(h,"_row",raw.entry and raw.entry.row)return h end function Adders:AddKeybind(id,cfg)cfg=cfg or{}local mode,state=cfg.Mode or"Toggle",false local clicks={}local h local raw=k.keybind(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Value=typeof(cfg.Default)=="EnumItem"and cfg.Default.Name or cfg.Default,Flag=id,Callback=function(name)state=false safe(cfg.ChangedCallback,toKeyCode(name)or name)if h then h:_fire(name)end end,})k.STATE.connect(UIS.InputBegan,function(input,gp)if gp or raw.Picking or k.capture.active or not k.mine()or not keyMatches(raw,input)then return end if mode=="Hold"then state=true else state=not state end safe(cfg.Callback,state)for _,fn in ipairs(clicks)do safe(fn)end end)k.STATE.connect(UIS.InputEnded,function(input)if mode=="Hold"and state and keyMatches(raw,input)then state=false safe(cfg.Callback,false)end end)h=newHandle("Keybind",id,function()return raw.Value end,function(v)raw:Set(toKeyCode(v)or v)end)rawset(h,"_row",raw.entry and raw.entry.row)rawset(h,"Mode",mode)function h:GetState()if mode=="Always"then return true end return state end function h:OnClick(fn)table.insert(clicks,fn)end function h:SetValue(key,newMode)if newMode then mode=newMode rawset(h,"Mode",newMode)end raw:Set(toKeyCode(key)or key)end return h end function Adders:AddButton(cfg)cfg=cfg or{}local raw=k.button(self._g,{Title=tostring(cfg.Title or"Button"),Desc=cfg.Description or cfg.Desc,Icon=cfg.Icon,Callback=function()safe(cfg.Callback)end,})local h=newHandle("Button",nil,NOOP,NOOP)rawset(h,"_row",raw.entry and raw.entry.row)function h:SetTitle(t)local l=titleLabelOf(raw.entry)if l then l.Text=tostring(t)end end h.SetText=h.SetTitle function h:SetDesc()end return h end function Adders:AddParagraph(cfg)cfg=cfg or{}local raw=k.paragraph(self._g,{Title=tostring(cfg.Title or""),Desc=tostring(cfg.Content or cfg.Description or"")})local h=newHandle("Paragraph",nil,NOOP,NOOP)function h:SetTitle(t)raw:SetTitle(t)end function h:SetDesc(t)raw:SetDesc(t)end h.SetContent=h.SetDesc function h:SetValue(t)raw:SetDesc(t)end return h end Adders.AddBanner=Adders.AddParagraph function Adders:AddColorpicker(id,cfg)cfg=cfg or{}local value=cfg.Default or Color3.new(1,1,1)local raw=k.keyValue(self._g,{Title=tostring(cfg.Title or id),Value=hex(value)})local h=newHandle("Colorpicker",id,function()return value end,function(c)value=c raw:Set(hex(c))safe(cfg.Callback,c)end)rawset(h,"Transparency",cfg.Transparency or 0)function h:SetValueRGB(c)h:SetValue(c)end return h end Adders.AddColorPicker=Adders.AddColorpicker local function newFSection(g)local s={_g=g,Container=g.card}return setmetatable(s,{__index=function(_,key)local m=Adders[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end local FTabM={}local function newFTab(tabObj,name)local t={_tabObj=tabObj,Name=name}return setmetatable(t,{__index=function(_,key)local m=FTabM[key]if m~=nil then return m end if type(key)=="string"and Adders[key]then return function(self,... )return Adders[key](self:_implicit(),... )end end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end function FTabM:AddSection(cfg)local title=type(cfg)=="table"and(cfg.Title or cfg.Name)or cfg title=(title~=nil and tostring(title)~="")and tostring(title)or nil touch()return newFSection(self._tabObj:Group(title))end function FTabM:_AddGroup(title,desc)local s=self:AddSection(title)if desc and desc~=""then k.label(s._g,{Text=tostring(desc)})end return s end function FTabM:_implicit()local first=rawget(self,"_first")if not first then first=newFSection(self._tabObj:Group(nil))rawset(self,"_first",first)end return first end function FTabM:Select()self._tabObj:Select()end local FWindowM={}local function newFWindow()local back={Tabs={},Root=k.shell}return setmetatable({},{__index=function(_,key)if key=="Minimized"then return not k.isShown()end if key=="Destroyed"or key=="Unloaded"then return unloaded end local v=rawget(back,key)if v~=nil then return v end local m=FWindowM[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end,__newindex=function(_,key,v)if key=="Minimized"then return end if key=="MinimizeKey"then Kit.SetToggleKey(v)end back[key]=v end,})end function FWindowM:AddTab(cfg)cfg=type(cfg)=="table"and cfg or{Title=cfg}local tabObj,shownName=gameTab(cfg.Title or cfg.Name,cfg.Icon)local t=newFTab(tabObj,shownName)table.insert(self.Tabs,t)return t end function FWindowM:SelectTab(x)if not k.isOpened()then return end local t=findTab(self.Tabs,x)if type(t)=="table"and t._tabObj then t._tabObj:Select()end end function FWindowM:Minimize()if k.isShown()then k.setShown(false)else open()end end function FWindowM:Dialog(cfg)dialog(cfg)end function FWindowM:Resize(w,h)Win:SetSize(w,h)end FWindowM.SetSize=FWindowM.Resize function FWindowM:Destroy()Kit.Unload()end local fluentWindow function FL:CreateWindow(cfg)cfg=cfg or{}Kit.Init({ToggleKey=cfg.MinimizeKey})fluentWindow=fluentWindow or newFWindow()return fluentWindow end function FL:Notify(cfg)notify(cfg)end function FL:SetTheme(name)setTheme(name)end function FL:Destroy()Kit.Unload()end local fluentMinimizeKey setmetatable(FL,{__index=function(_,key)if key=="Theme"then return k.theme()end if key=="Unloaded"then return unloaded end if key=="MinimizeKey"then return fluentMinimizeKey end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end,__newindex=function(t,key,v)if key=="MinimizeKey"then fluentMinimizeKey=v Kit.SetToggleKey(v)return end rawset(t,key,v)end,})Kit.Fluent=FL return Kit end)() end)() -- SPECTREWARE UI v1.0.6 (built in by ui/build.py; edit ui/SpectreUI.lua + ui/faces.lua)
local Fluent = SPECTREWARE_UI.Fluent

-- =========================================================================
-- SPECTREUI INTERFACE MANAGER (ADAPTED FOR SPECTREWARE RESKIN)
-- =========================================================================
local InterfaceManager = {}
do
    local httpService = game:GetService("HttpService")
    InterfaceManager.Folder = "SpectreWare_AnimeBreaker"
    InterfaceManager.Settings = {
        Theme = "Spectre",
        Acrylic = true,
        Transparency = true,
        MenuKeybind = "LeftControl"
    }

    function InterfaceManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end

    function InterfaceManager:SetLibrary(library)
        self.Library = library
    end

    function InterfaceManager:BuildFolderTree()
        local paths = {}
        local parts = self.Folder:split("/")
        for idx = 1, #parts do
            paths[#paths + 1] = table.concat(parts, "/", 1, idx)
        end
        table.insert(paths, self.Folder)
        table.insert(paths, self.Folder .. "/settings")

        for i = 1, #paths do
            local str = paths[i]
            local ok, exists = pcall(isfolder, str)
            if ok and not exists then
                pcall(makefolder, str)
            end
        end
    end

    local saveDebounce = false
    function InterfaceManager:SaveSettings()
        if saveDebounce then return end
        saveDebounce = true
        task.spawn(function()
            task.wait(0.1)
            saveDebounce = false
            pcall(function()
                if writefile then
                    self:BuildFolderTree()
                    writefile(self.Folder .. "/options.json", httpService:JSONEncode(self.Settings))
                end
            end)
        end)
    end

    function InterfaceManager:LoadSettings()
        local path = self.Folder .. "/options.json"
        pcall(function()
            if isfile and isfile(path) and readfile then
                local data = readfile(path)
                local success, decoded = pcall(httpService.JSONDecode, httpService, data)
                if success and type(decoded) == "table" then
                    for i, v in next, decoded do
                        self.Settings[i] = v
                    end
                end
            end
        end)
    end

    function InterfaceManager:BuildInterfaceSection(tab)
        assert(self.Library, "Must set InterfaceManager.Library")
        local Library = self.Library
        local Settings = self.Settings

        self:LoadSettings()

        local rawTab = (type(tab) == "table" and tab.Raw) or tab
        local section = rawTab:AddSection("Interface")

        -- Ensure Library.Themes has only clean string names and includes Spectre
        local themeList = {}
        if Library.Themes and type(Library.Themes) == "table" then
            for _, th in ipairs(Library.Themes) do
                if type(th) == "string" and not table.find(themeList, th) then
                    table.insert(themeList, th)
                end
            end
        end
        if #themeList == 0 then
            themeList = { "Spectre", "Dark", "Darker", "Night", "Amethyst", "Aqua", "Light", "Rose" }
        end
        if not table.find(themeList, "Spectre") then
            table.insert(themeList, "Spectre")
        end

        local defaultTheme = Settings.Theme or "Spectre"
        if not table.find(themeList, defaultTheme) then
            defaultTheme = "Spectre"
        end

        local InterfaceTheme = section:AddDropdown("InterfaceTheme", {
            Title = "Theme",
            Description = "Changes the interface theme.",
            Values = themeList,
            Default = defaultTheme,
            Callback = function(Value)
                Library:SetTheme(Value)
                Settings.Theme = Value
                InterfaceManager:SaveSettings()
            end
        })

        pcall(function() InterfaceTheme:SetValue(defaultTheme) end)

        if Library.UseAcrylic then
            local AcrylicToggle = section:AddToggle("AcrylicToggle", {
                Title = "Acrylic",
                Description = "The blurred background requires graphic quality 8+",
                Default = Settings.Acrylic,
                Callback = function(Value)
                    Library:ToggleAcrylic(Value)
                    Settings.Acrylic = Value
                    InterfaceManager:SaveSettings()
                end
            })
        end

        local TransparentToggle = section:AddToggle("TransparentToggle", {
            Title = "Transparency",
            Description = "Makes the interface transparent.",
            Default = Settings.Transparency,
            Callback = function(Value)
                Library:ToggleTransparency(Value)
                Settings.Transparency = Value
                InterfaceManager:SaveSettings()
            end
        })

        -- Apply saved settings after UI is ready
        task.defer(function()
            pcall(function() Library:ToggleTransparency(Settings.Transparency) end)
            if Library.UseAcrylic then
                pcall(function() Library:ToggleAcrylic(Settings.Acrylic) end)
            end
            if Settings.Theme then
                pcall(function() Library:SetTheme(Settings.Theme) end)
            end
        end)

        local MenuKeybind = section:AddKeybind("MenuKeybind", {
            Title = "Minimize Bind",
            Default = Settings.MenuKeybind or "LeftControl"
        })
        MenuKeybind:OnChanged(function()
            local val = MenuKeybind.Value
            Settings.MenuKeybind = val
            InterfaceManager:SaveSettings()
            if Library.Window then
                pcall(function()
                    if val == "LeftControl" then
                        Library.Window.MinimizeKey = Enum.KeyCode.RightControl
                    elseif val == "RightControl" then
                        Library.Window.MinimizeKey = Enum.KeyCode.LeftControl
                    else
                        Library.Window.MinimizeKey = Enum.KeyCode[val]
                    end
                end)
            end
        end)
        Library.MinimizeKeybind = MenuKeybind
        if Library.Window then
            pcall(function()
                local val = MenuKeybind.Value or "LeftControl"
                if val == "LeftControl" then
                    Library.Window.MinimizeKey = Enum.KeyCode.RightControl
                elseif val == "RightControl" then
                    Library.Window.MinimizeKey = Enum.KeyCode.LeftControl
                else
                    Library.Window.MinimizeKey = Enum.KeyCode[val]
                end
            end)
        end
    end
end

local function createSpectreAnimeBreakerUI(Fluent, CFG, getLibrary, getMap, getHighestMap, getTarget, cleanup)
    if not Fluent or not Fluent.CreateWindow then
        warn("[SpectreWare] Cannot create Window: Fluent library is not loaded.")
        return nil
    end

    -- Clean up previous window if any
    if _G.SpectreWare_Window then
        pcall(function() _G.SpectreWare_Window:Destroy() end)
        _G.SpectreWare_Window = nil
    end

    -- Register Custom Spectre Theme from FullFeatureExample
    pcall(function()
        Fluent:AddTheme({
            Name = "Spectre",
            Accent = Color3.fromHex("#8b5cf6"),

            AcrylicMain     = Color3.fromHex("#0f0c16"),
            AcrylicBorder   = Color3.fromHex("#2e2a36"),
            AcrylicGradient = ColorSequence.new(Color3.fromHex("#0f0c16"), Color3.fromHex("#1a1528")),

            TitleBarLine = Color3.fromHex("#2e2a36"),
            Tab          = Color3.fromHex("#94a3b8"),

            Element             = Color3.fromHex("#1e1a29"),
            ElementBorder       = Color3.fromHex("#0f0c16"),
            InElementBorder     = Color3.fromHex("#2e2a36"),
            ElementTransparency = 0.82,

            ToggleSlider  = Color3.fromHex("#2e2a36"),
            ToggleToggled = Color3.fromHex("#0f0c16"),
            SliderRail    = Color3.fromHex("#c4b5fd"),

            DropdownFrame  = Color3.fromHex("#2e2a36"),
            DropdownHolder = Color3.fromHex("#0f0c16"),
            DropdownBorder = Color3.fromHex("#1e1a29"),
            DropdownOption = Color3.fromHex("#1e1a29"),

            Dialog             = Color3.fromHex("#1a1528"),
            DialogHolder       = Color3.fromHex("#0f0c16"),
            DialogHolderLine   = Color3.fromHex("#0f0c16"),
            DialogButton       = Color3.fromHex("#1e1a29"),
            DialogButtonBorder = Color3.fromHex("#2e2a36"),
            DialogBorder       = Color3.fromHex("#2e2a36"),
            DialogInput        = Color3.fromHex("#1e1a29"),
            DialogInputLine    = Color3.fromHex("#c4b5fd"),

            Text        = Color3.fromHex("#f8fafc"),
            SubText     = Color3.fromHex("#94a3b8"),
            Hover       = Color3.fromHex("#c4b5fd"),
            HoverChange = 0.04,
        })
    end)

    -- Initialize InterfaceManager and load saved preferences
    InterfaceManager:SetLibrary(Fluent)
    InterfaceManager:SetFolder("SpectreWare_AnimeBreaker")
    InterfaceManager:LoadSettings()

    local initialKeyName = InterfaceManager.Settings.MenuKeybind or "LeftControl"
    local initialKeyCode = pcall(function() return Enum.KeyCode[initialKeyName] end) and Enum.KeyCode[initialKeyName] or Enum.KeyCode.LeftControl

    local rawWin = Fluent:CreateWindow({
        Title       = "SpectreWare",
        SubTitle    = "Anime Breaker",
        Author      = "Tiger",
        TabWidth    = 160,
        Size        = UDim2.fromOffset(680, 520),
        Acrylic     = InterfaceManager.Settings.Acrylic ~= false,
        Theme       = InterfaceManager.Settings.Theme or "Spectre",
        MinimizeKey = initialKeyCode,
        ToggleButton = false,
    })

    if not rawWin then
        warn("[SpectreWare] Fluent:CreateWindow failed to return a window instance.")
        return nil
    end

    Fluent.MinimizeKeybind = { Type = "Keybind", Value = SPECTREWARE_UI.GetToggleKey().Name }

    -- Keep window hidden initially while background modules and tabs are building
    if rawWin.Root then
        rawWin.Root.Visible = false
    end

    local ui -- Forward declaration for upvalue capture

    -- Wrap rawWin:Minimize() to ensure 100% foolproof minimization & clean state
    local origMinimize = rawWin.Minimize
    rawWin.Minimize = function(self)
        if ui and not ui.Ready then return end
        -- 1. Close open dropdown frames so they don't float orphaned
        pcall(function()
            if Fluent and Fluent.OpenFrames then
                for _, frame in ipairs(Fluent.OpenFrames) do
                    frame.Visible = false
                end
            end
        end)

        -- 2. Call original minimize logic (the UI animates open / closed)
        pcall(function()
            origMinimize(self or rawWin)
        end)
    end

    -- Universal API support (aliases for SetOpen and Toggle)
    rawWin.SetOpen = function(self, state)
        if state == nil then
            rawWin:Minimize()
        elseif state == false and not rawWin.Minimized then
            rawWin:Minimize()
        elseif state == true and rawWin.Minimized then
            rawWin:Minimize()
        end
    end
    rawWin.Toggle = function() rawWin:Minimize() end

    _G.SpectreWare_Window = rawWin

    ui = {
        Raw = rawWin,
        Closed = false,
        Ready = false,
        Controls = {},
        ToggleEntries = {},
        SetOpen = rawWin.SetOpen,
        Toggle = rawWin.Toggle,
    }

    function ui:Notify(data)
        if not Fluent then return end
        local title = (type(data) == "table" and (data.Title or data.Name)) or "SpectreWare"
        local content = (type(data) == "table" and (data.Content or data.Desc or data.Description)) or tostring(data)
        local duration = (type(data) == "table" and data.Duration) or 4
        pcall(function()
            Fluent:Notify({
                Title      = title,
                Content    = content,
                SubContent = "discord.gg/7YP43jpUfz",
                Duration   = duration,
            })
        end)
    end

    -- Notify user that background loading is in progress
    ui:Notify({
        Title      = "SpectreWare",
        Content    = "Loading Anime Breaker modules...",
        Duration   = 2,
    })

    local isSyncing = false
    function ui:SyncConfig()
        if isSyncing then return end
        isSyncing = true
        for _, entry in ipairs(self.Controls) do
            local val = CFG[entry.ConfigKey]
            if val ~= nil and entry.Handle then
                if entry.Transform then val = val * entry.Transform end
                pcall(function()
                    entry.Handle.InternalSet = true
                    entry.Handle:Set(val)
                    entry.Handle.InternalSet = nil
                end)
            end
        end
        isSyncing = false
    end

    function ui:FinishLoading()
        if self.Ready then return end
        self.Ready = true
        self:SyncConfig()
        pcall(function() rawWin:SelectTab(1) end)
        if rawWin.Root then
            rawWin.Root.Visible = true
        end
        rawWin.Minimized = false
        self:Notify({
            Title   = "SpectreWare",
            Content = "Anime Breaker loaded successfully!",
            Duration = 4,
        })
    end

    local function controlCallback(uiInstance, callback, handleRef)
        if type(callback) ~= "function" then return function() end end
        return function(...)
            if isSyncing then return end
            if handleRef and handleRef.InternalSet then return end
            local ok, err = pcall(callback, ...)
            if not ok then
                warn("[SpectreWare] Callback error: " .. tostring(err))
            end
        end
    end

    local function titleFor(data)
        return (type(data) == "table" and (data.Title or data.Name)) or tostring(data or "Element")
    end

    local function descFor(data)
        return (type(data) == "table" and (data.Desc or data.Description)) or nil
    end

    -- Tab wrapper methods for all 11 feature tabs
    local tabMethods = {}

    function tabMethods:Section(data)
        local title = titleFor(data)
        local sec = self.Raw:AddSection({ Title = title, Opened = true })
        self.Current = sec
        return sec
    end

    function tabMethods:AddSection(...)
        return self.Raw:AddSection(...)
    end

    function tabMethods:CurrentSection()
        if not self.Current then
            self.Current = self.Raw:AddSection({ Title = "Features", Opened = true })
        end
        return self.Current
    end

    function tabMethods:Paragraph(data)
        local title = titleFor(data)
        local desc = (type(data) == "table" and (data.Desc or data.Content)) or ""
        local p = self:CurrentSection():AddParagraph({
            Title   = title,
            Content = desc,
        })
        local handle = { Raw = p }
        function handle:SetDesc(txt)
            pcall(function() p:SetDesc(tostring(txt or "")) end)
        end
        function handle:SetTitle(txt)
            pcall(function() p:SetTitle(tostring(txt or "")) end)
        end
        function handle:Set(txt)
            pcall(function() p:SetDesc(tostring(txt or "")) end)
        end
        return handle
    end

    function tabMethods:Button(data)
        return self:CurrentSection():AddButton({
            Title       = titleFor(data),
            Description = descFor(data),
            Callback    = controlCallback(self.UI, data.Callback)
        })
    end

    function tabMethods:Toggle(data)
        local flagName = data.ConfigKey or ("Toggle_" .. tostring(data.Title or data.Name or math.random(1000, 9999)):gsub("%W+", "_"))
        local defaultVal = (data.Value == true) or (data.ConfigKey and CFG[data.ConfigKey] == true) or false
        local handleRef = {}
        local t = self:CurrentSection():AddToggle(flagName, {
            Title       = titleFor(data),
            Description = descFor(data),
            Default     = defaultVal,
            Callback    = controlCallback(self.UI, data.Callback, handleRef)
        })
        local handle = { Raw = t, ConfigKey = data.ConfigKey }
        handleRef.Handle = handle
        function handle:Set(val)
            pcall(function() t:SetValue(val == true) end)
        end
        function handle:Get()
            return t.Value
        end
        if data.ConfigKey then
            table.insert(self.UI.ToggleEntries, { Handle = handle, ConfigKey = data.ConfigKey })
            table.insert(self.UI.Controls, { Handle = handle, ConfigKey = data.ConfigKey })
        end
        return handle
    end

    function tabMethods:Slider(data)
        local range = data.Value or {}
        local flagName = data.ConfigKey or ("Slider_" .. tostring(data.Title or data.Name or math.random(1000, 9999)):gsub("%W+", "_"))
        local defaultVal = range.Default or (data.ConfigKey and CFG[data.ConfigKey]) or range.Min or 0
        if data.ConfigKey == "ClickDelay" and defaultVal < 1 then
            defaultVal = defaultVal * 100
        end
        local handleRef = {}
        local s = self:CurrentSection():AddSlider(flagName, {
            Title       = titleFor(data),
            Description = descFor(data),
            Min         = range.Min or 0,
            Max         = range.Max or 100,
            Default     = defaultVal,
            Rounding    = (data.Step and data.Step < 1) and 2 or 0,
            Callback    = controlCallback(self.UI, function(val)
                if data.ConfigKey then
                    if data.ConfigKey == "ClickDelay" then
                        CFG[data.ConfigKey] = val / 100
                    else
                        CFG[data.ConfigKey] = val
                    end
                end
                if type(data.Callback) == "function" then
                    pcall(data.Callback, val)
                end
            end, handleRef)
        })
        local handle = { Raw = s, ConfigKey = data.ConfigKey }
        handleRef.Handle = handle
        function handle:Set(val)
            if data.ConfigKey == "ClickDelay" and val < 1 then val = val * 100 end
            pcall(function() s:SetValue(val) end)
        end
        function handle:Get()
            return s.Value
        end
        if data.ConfigKey then
            table.insert(self.UI.Controls, {
                Handle = handle,
                ConfigKey = data.ConfigKey,
                Transform = (data.ConfigKey == "ClickDelay" and 100) or nil
            })
        end
        return handle
    end

    function tabMethods:Dropdown(data)
        local flagName = data.ConfigKey or ("Dropdown_" .. tostring(data.Title or data.Name or math.random(1000, 9999)):gsub("%W+", "_"))
        local handleRef = {}
        local d = self:CurrentSection():AddDropdown(flagName, {
            Title       = titleFor(data),
            Description = descFor(data),
            Values      = data.Values or {},
            Default     = data.Value or (data.Multi and {} or (data.Values and data.Values[1])),
            Multi       = data.Multi == true,
            Callback    = controlCallback(self.UI, function(val)
                if data.ConfigKey then
                    CFG[data.ConfigKey] = val
                end
                if type(data.Callback) == "function" then
                    pcall(data.Callback, val)
                end
            end, handleRef)
        })
        local handle = { Raw = d, ConfigKey = data.ConfigKey }
        handleRef.Handle = handle
        function handle:Refresh(newVals)
            pcall(function() d:SetValues(newVals) end)
        end
        function handle:Set(val)
            pcall(function() d:SetValue(val) end)
        end
        function handle:Get()
            return d.Value
        end
        if data.ConfigKey then
            table.insert(self.UI.Controls, { Handle = handle, ConfigKey = data.ConfigKey })
        end
        return handle
    end

    function tabMethods:Input(data)
        local flagName = data.ConfigKey or ("Input_" .. tostring(data.Title or data.Name or math.random(1000, 9999)):gsub("%W+", "_"))
        local handleRef = {}
        local inp = self:CurrentSection():AddInput(flagName, {
            Title       = titleFor(data),
            Description = descFor(data),
            Default     = tostring(data.Default or (data.ConfigKey and CFG[data.ConfigKey]) or ""),
            Placeholder = data.Placeholder or "Type here...",
            Callback    = controlCallback(self.UI, function(val)
                if data.ConfigKey then
                    CFG[data.ConfigKey] = val
                end
                if type(data.Callback) == "function" then
                    pcall(data.Callback, val)
                end
            end, handleRef)
        })
        local handle = { Raw = inp, ConfigKey = data.ConfigKey }
        handleRef.Handle = handle
        function handle:Set(val)
            pcall(function() inp:SetValue(val) end)
        end
        function handle:Get()
            return inp.Value
        end
        if data.ConfigKey then
            table.insert(self.UI.Controls, { Handle = handle, ConfigKey = data.ConfigKey })
        end
        return handle
    end

    function tabMethods:Keybind(data)
        local flagName = data.ConfigKey or ("Keybind_" .. tostring(data.Title or data.Name or math.random(1000, 9999)):gsub("%W+", "_"))
        local defaultKey = data.Default or data.Value or "RightControl"
        local handle = self:CurrentSection():AddKeybind(flagName, {
            Title       = titleFor(data),
            Description = descFor(data),
            Default     = defaultKey,
            Mode        = data.Mode or "Toggle",
            Callback    = controlCallback(self.UI, data.Callback),
            ChangedCallback = data.ChangedCallback
        })
        return handle
    end

    -- Home / Overview Tab
    local HomeTab = rawWin:AddTab({ Title = "Home", Icon = "home" })
    local BannerSec = HomeTab:AddSection({ Title = "SpectreWare Network", Opened = true })

    BannerSec:AddBanner({
        Title   = "SpectreWare · Anime Breaker",
        Content = "Premium high-speed automation engine for Anime Breaker.\nOfficial Discord: https://discord.gg/7YP43jpUfz",
        Style   = "info"
    })

    local discordInvite = "https://discord.gg/7YP43jpUfz"
    BannerSec:AddButton({
        Title       = "Join Discord Server",
        Description = "https://discord.gg/7YP43jpUfz (Click to copy)",
        Callback    = function()
            local copied = false
            pcall(function()
                if setclipboard then setclipboard(discordInvite); copied = true
                elseif toclipboard then toclipboard(discordInvite); copied = true
                end
            end)
            Fluent:Notify({
                Title      = "Discord",
                Content    = copied and "Invite link copied to clipboard!" or discordInvite,
                SubContent = "discord.gg/7YP43jpUfz",
                Duration   = 4
            })
        end
    })

    BannerSec:AddButton({
        Title       = "Copy Server Job ID",
        Description = "Copy current Roblox Job ID to clipboard",
        Callback    = function()
            local jid = tostring(game.JobId or "")
            pcall(function()
                if setclipboard then setclipboard(jid)
                elseif toclipboard then toclipboard(jid) end
            end)
            Fluent:Notify({
                Title   = "Server Job ID",
                Content = jid ~= "" and "Job ID copied!" or "Unavailable",
                Duration = 3
            })
        end
    })

    local LiveSec = HomeTab:AddSection({ Title = "Real-Time Telemetry", Opened = true })
    local perfPara = LiveSec:AddParagraph({
        Title   = "System Performance",
        Content = "FPS: -- | Ping: -- ms | Uptime: 00:00:00"
    })
    local statusPara = LiveSec:AddParagraph({
        Title   = "Player & World Progress",
        Content = "Current Map: --\nGold: -- | Energy: --\nLocked Target: Searching"
    })
    local featPara = LiveSec:AddParagraph({
        Title   = "Automation Engine",
        Content = "Active Features: 0 / 0"
    })

    local startedAt = os.clock()
    local lastUpdate = 0
    ui.OverviewConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
        if rawWin.Destroyed or ui.Closed then return end
        lastUpdate = lastUpdate + dt
        if lastUpdate < 0.75 then return end
        lastUpdate = 0

        local pd = getLibrary and getLibrary() and getLibrary().PlayerData
        local items = pd and pd.Items or {}
        local gold = tostring(pd and pd.Gold or items.Gold or 0)
        local energy = tostring(pd and pd.Energy or items.Energy or 0)
        local curMap = tostring(getMap and getMap() or "--")
        local highMap = tostring(getHighestMap and getHighestMap() or "--")
        local target = tostring(getTarget and getTarget() or "Searching...")

        local fps = "--"
        pcall(function()
            local ws = game:GetService("Workspace")
            fps = tostring(math.floor(1 / math.max(dt, 0.001)))
        end)

        local ping = "--"
        pcall(function()
            local lplayer = game:GetService("Players").LocalPlayer
            if lplayer then
                local p = lplayer:GetNetworkPing()
                ping = tostring(math.max(0, math.floor(p * 1000 + 0.5)))
            end
        end)

        local uptimeSec = math.floor(os.clock() - startedAt)
        local uptime = string.format("%02d:%02d:%02d", math.floor(uptimeSec / 3600), math.floor((uptimeSec % 3600) / 60), uptimeSec % 60)

        perfPara:SetDesc(string.format("FPS: %s | Ping: %s ms | Session Uptime: %s", fps, ping, uptime))
        statusPara:SetDesc(string.format("Map: %s (Highest: %s)\nGold: %s | Energy: %s\nTarget: %s", curMap, highMap, gold, energy, target))

        local active = 0
        for _, entry in ipairs(ui.ToggleEntries) do
            local val = CFG[entry.ConfigKey]
            if val == nil and entry.Handle and entry.Handle.Get then val = entry.Handle:Get() end
            if val == true then active = active + 1 end
        end
        featPara:SetDesc(string.format("Active Features: %d / %d", active, #ui.ToggleEntries))
    end)

    local MgtSec = HomeTab:AddSection({ Title = "Interface Management", Opened = true })
    MgtSec:AddButton({
        Title       = "Hide Interface (Minimize)",
        Description = "Hides the window. Press your menu key or tap the island at the top to bring it back.",
        Callback    = function()
            pcall(function() rawWin:Minimize() end)
        end
    })
    MgtSec:AddButton({
        Title       = "Unload SpectreWare",
        Description = "Closes GUI and cleans up all active scripts.",
        Callback    = function()
            if ui.Closed then return end
            ui.Closed = true
            if ui.OverviewConnection then ui.OverviewConnection:Disconnect() end
            if type(cleanup) == "function" then pcall(cleanup) end
            pcall(function() rawWin:Destroy() end)
        end
    })

    function ui:Tab(data)
        local rawTab = rawWin:AddTab({
            Title = titleFor(data),
            Icon  = data.Icon or "star"
        })
        return setmetatable({ Raw = rawTab, UI = self, Current = nil }, { __index = tabMethods })
    end

    rawWin.Unload = function()
        if ui.Closed then return end
        ui.Closed = true
        if ui.OverviewConnection then ui.OverviewConnection:Disconnect() end
        if type(cleanup) == "function" then pcall(cleanup) end
        pcall(function() rawWin:Destroy() end)
    end
    ui.Unload = rawWin.Unload

    -- Unload from Settings > Script (or running the script again) stops everything too
    SPECTREWARE_UI.OnUnload(function()
        if ui.Closed then return end
        ui.Closed = true
        if ui.OverviewConnection then pcall(function() ui.OverviewConnection:Disconnect() end) end
        if type(cleanup) == "function" then pcall(cleanup) end
    end)

    return ui
end

Window = createSpectreAnimeBreakerUI(
    Fluent, CFG, function() return Library end, getCurrentMap, getHighestUnlockedMap,
    function() return currentLockedTargetUID end,
    function()
        if _G.AnimeBreaker_HeartbeatConnection then
            _G.AnimeBreaker_HeartbeatConnection:Disconnect()
            _G.AnimeBreaker_HeartbeatConnection = nil
        end
        disableNoClip()
        for _, connection in ipairs(_G.AnimeBreaker_Connections or {}) do
            pcall(function() connection:Disconnect() end)
        end
        _G.AnimeBreaker_Connections = {}
        for _, key in ipairs({ "AnimeBreaker_AntiAFKConnection", "AnimeBreaker_RejoinConnection" }) do
            if _G[key] then _G[key]:Disconnect(); _G[key] = nil end
        end
    end
)
SpectreUI = Window
AxelHubUI = Window
if getgenv then
    getgenv()._AnimeBreakerCleanup = function() if Window and Window.Raw then pcall(function() Window.Raw:Destroy() end) end end
end
syncRuntimeSettings()

if lp then
    _G.AnimeBreaker_AntiAFKConnection = lp.Idled:Connect(function()
        if not CFG.AntiAFK then return end
        pcall(function()
            local virtualUser = game:GetService("VirtualUser")
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end)
    local coreGui = game:GetService("CoreGui")
    _G.AnimeBreaker_RejoinConnection = coreGui.DescendantAdded:Connect(function(item)
        if not CFG.AutoRejoin or item.Name ~= "ErrorPrompt" then return end
        task.delay(3, function()
            if CFG.AutoRejoin and item.Parent then doRejoinCurrent() end
        end)
    end)
end

local Tabs = {}

local function executorName()
    local scopes = {}
    pcall(function()
        if type(getgenv) == "function" then table.insert(scopes, getgenv()) end
    end)
    table.insert(scopes, _G)
    for _, scope in ipairs(scopes) do
        if type(scope) == "table" then
            for _, key in ipairs({ "identifyexecutor", "getexecutorname", "identify_executor" }) do
                if type(scope[key]) == "function" then
                    local ok, name, version = pcall(scope[key])
                    if ok and name and tostring(name) ~= "" then
                        return tostring(name) .. (version and tostring(version) ~= "" and (" " .. tostring(version)) or "")
                    end
                end
            end
        end
    end
    return "Unknown Executor"
end

Tabs.Dash = function(win)
    local TabDash = win:Tab({ Title = "Dashboard", Icon = "layout-dashboard" })

    TabDash:Section({ Title = "System & Environment" })
    local detectedExec = executorName()
    TabDash:Paragraph({
        Title = "Roblox Executor",
        Desc = "Active Executor: " .. detectedExec .. "\nAnti-AFK: " .. (CFG.AntiAFK and "Enabled" or "Disabled") .. " | Auto-Rejoin: " .. (CFG.AutoRejoin and "Enabled" or "Disabled")
    })

    TabDash:Section({ Title = "Player Overview" })
    local statPara = TabDash:Paragraph({
        Title = "Live Player Stats",
        Desc = "Loading player metrics..."
    })

    task.spawn(function()
        while not win.Closed and task.wait(0.5) do
            local pd = Library and Library.PlayerData
            local items = pd and pd.Items or {}
            local gold = pd and pd.Gold or items["Gold"] or 0
            local energy = pd and pd.Energy or items["Energy"] or 0
            local curMap = getCurrentMap()
            local rank = (pd and pd.Rebirth and pd.Rebirth.Rank_Energy) or (pd and pd.Rank) or 1
            local coveredStr = (#currentCoveredTargetUIDs > 0) and string.format(" (%d Covered)", #currentCoveredTargetUIDs) or ""
            statPara:SetDesc(string.format(
                "Player: %s  |  Map: %s\nGold: %s  |  Energy: %s  |  Rank: %s\nHighest Map: %s  |  Locked Target: %s%s",
                lp.Name, curMap, tostring(gold), tostring(energy), tostring(rank),
                getHighestUnlockedMap(),
                tostring(currentLockedTargetUID or "None (Searching...)"),
                coveredStr
            ))
        end
    end)

    TabDash:Section({ Title = "Quest Progress" })
    local qPara = TabDash:Paragraph({
        Title = "Current Quest",
        Desc = "Tracking quests..."
    })

    task.spawn(function()
        while task.wait(1.0) do
            local pd = Library and Library.PlayerData
            if pd then
                local active = pd.ActiveQuest
                local quests = pd.Quests or {}
                local text = nil
                if active and active.Id and active.Type then
                    local cat = quests[active.Type]
                    local qData = cat and cat[active.Id]
                    if qData and qData.Objectives then
                        local parts = {}
                        for _, obj in ipairs(qData.Objectives) do
                            local oType = tostring(obj.Type or "")
                            local goal = tonumber(obj.Goal) or 1
                            local prog = tonumber(obj.Progress) or 0
                            table.insert(parts, string.format("%s: %d/%d (%d%%)", oType, prog, goal, math.floor(prog / goal * 100)))
                        end
                        text = string.format("[%s] %s\n%s", active.Type, active.Id, table.concat(parts, " | "))
                    else
                        text = string.format("[%s] %s [In Progress]", active.Type, active.Id)
                    end
                end
                if not text then
                    for catName, catList in pairs(quests) do
                        if type(catList) == "table" then
                            for qId, qData in pairs(catList) do
                                if type(qData) == "table" and qData.Objectives then
                                    for _, obj in ipairs(qData.Objectives) do
                                        local goal = tonumber(obj.Goal) or 1
                                        local prog = tonumber(obj.Progress) or 0
                                        if prog < goal then
                                            text = string.format("[%s] %s\n%s: %d/%d (%d%%)", catName, qId, tostring(obj.Type or ""), prog, goal, math.floor(prog / goal * 100))
                                            break
                                        end
                                    end
                                end
                                if text then break end
                            end
                        end
                        if text then break end
                    end
                end
                qPara:SetDesc(text or "All current quests completed!")
            else
                qPara:SetDesc("Tracking quests...")
            end
        end
    end)

    TabDash:Button({
        Title = "Process Quests",
        Desc = "Checks quests, processes available objectives and claims completed rewards once.",
        Callback = doAutoQuests
    })

    TabDash:Section({ Title = "Quick Actions" })
    TabDash:Button({
        Title = "Teleport to Target",
        Desc = "Moves to the selected enemy or the best attack position for a group.",
        Callback = function()
            local uid, part, model, optPos, coveredUIDs = selectTargetEnemy()
            if optPos and coveredUIDs and #coveredUIDs > 0 then
                teleportToCombat(optPos, coveredUIDs, uid)
            elseif part and uid then
                teleportToTarget(part, uid)
            end
        end
    })
    TabDash:Button({
        Title = "Cast Skill",
        Desc = "Uses the equipped skill on the current target or group.",
        Callback = function()
            local skillTgt = (#currentCoveredTargetUIDs > 0 and currentCoveredTargetUIDs) or (currentLockedTargetUID and { currentLockedTargetUID }) or Library.Target
            Library.Remote:Fire("ClickSystem", "CastSkill", skillTgt)
        end
    })
    TabDash:Button({
        Title = "Attack World Gate",
        Desc = "Moves to the current world gate and attacks it once.",
        Callback = doAutoBreakWall
    })
    TabDash:Button({
        Title = "Claim Available Rewards",
        Desc = "Claims available rewards from the supported reward systems.",
        Callback = doClaimAll
    })
    TabDash:Button({
        Title = "Redeem Saved Codes",
        Desc = "Attempts each promo code included in this script. Expired codes may be rejected.",
        Callback = doRedeemAllCodes
    })
end

-- ══════════════════════════════════════════════════════════
-- TAB 2: 🔀 ACTIVITY ORDER (PRIORITY HIERARCHY)
-- ══════════════════════════════════════════════════════════
Tabs.Order = function(win)
    local TabOrder = win:Tab({ Title = "Activity Order", Icon = "list-ordered" })
    TabOrder:Section({ Title = "Activity Priority" })
    TabOrder:Paragraph({
        Title = "Automation Order",
        Desc = "1. Time Trial\n2. Raid\n3. Portal\n4. World farming, gates and quests\nHigher priority activities pause normal world farming."
    })
end

-- ══════════════════════════════════════════════════════════
-- TAB 3: ⚔️ FARMING (STICKY TARGET LOCKING + INTERACTIVE SLIDERS)
-- ══════════════════════════════════════════════════════════
Tabs.Farm = function(win)
    local TabFarm = win:Tab({ Title = "Farming", Icon = "swords" })
    TabFarm:Section({ Title = "Combat Controls" })
    TabFarm:Toggle({
        ConfigKey = "AutoFarm",
        Title = "Auto Farm Enemies",
        Desc = "Moves into attack range and keeps enemies targeted until defeated.",
        Value = CFG.AutoFarm,
        Callback = function(v)
            CFG.AutoFarm = v
            if not v then currentLockedTargetUID = nil end
        end
    })
    TabFarm:Toggle({
        ConfigKey = "AutoClick",
        Title = "Auto Attack",
        Desc = "Attacks the current target or group at the selected interval.",
        Value = CFG.AutoClick,
        Callback = function(v) CFG.AutoClick = v end
    })
    TabFarm:Slider({
        ConfigKey = "ClickDelay",
        Title = "Attack Interval (× 0.01s)",
        Desc = "5 = 0.05 seconds between attacks. A higher value attacks less often.",
        Step = 1,
        Value = { Min = 1, Max = 50, Default = math.floor(CFG.ClickDelay * 100) },
        Callback = function(v) CFG.ClickDelay = v / 100 end
    })
    TabFarm:Toggle({
        ConfigKey = "AutoTarget",
        Title = "Auto Target Enemies",
        Desc = "Selects available enemies in your farming area.",
        Value = CFG.AutoTarget,
        Callback = function(v) CFG.AutoTarget = v end
    })
    TabFarm:Toggle({
        ConfigKey = "AutoCastSkill",
        Title = "Auto Cast Skill",
        Desc = "Casts the equipped skill on the current target or group.",
        Value = CFG.AutoCastSkill,
        Callback = function(v) CFG.AutoCastSkill = v end
    })
    TabFarm:Dropdown({
        ConfigKey = "TargetMonsterFilterMulti",
        Title = "Target Enemies",
        Desc = "Choose one or more enemies. Select All to include every enemy.",
        Multi = true,
        Values = ALL_ENEMY_OPTIONS,
        Value = CFG.TargetMonsterFilterMulti or {"All"},
        Callback = function(v)
            CFG.TargetMonsterFilterMulti = v
            currentLockedTargetUID = nil
        end
    })

    TabFarm:Section({ Title = "Avatar Index" })
    TabFarm:Toggle({
        ConfigKey = "AutoIndexFarm",
        Title = "Auto Complete Avatar Index",
        Desc = "On: farms missing avatars. Off: stops farming and attacks, then clears Index targets.",
        Value = CFG.AutoIndexFarm,
        Callback = function(v)
            CFG.AutoIndexFarm = v
            if getgenv then
                getgenv()._CurrentLockedUID = nil
                getgenv()._CurrentCoveredUIDs = {}
            end
            if not v then
                -- ปิด → หยุดฟาร์มทุกอย่างทันที
                CFG.AutoFarm = false
                CFG.AutoClick = false
                currentLockedTargetUID = nil
                currentCoveredTargetUIDs = {}
                lastTeleportedUID = nil
                if Library then Library.Target = {} end
            else
                -- เปิด → เริ่มฟาร์ม index
                currentLockedTargetUID = nil
                currentCoveredTargetUIDs = {}
                lastTeleportedUID = nil
                CFG.AutoFarm = true
                CFG.AutoClick = true
                local targetMap = CFG.IndexFarmWorld or "Current Map"
                if targetMap ~= "Current Map" and getCurrentMap() ~= targetMap then
                    pcall(function()
                        Library.Remote:Fire("TeleportSystem", "To", targetMap)
                    end)
                end
            end
        end
    })
    TabFarm:Dropdown({
        ConfigKey = "IndexFarmWorld",
        Title = "Avatar Index World",
        Desc = "Choose the world to visit and farm for missing avatars.",
        Values = (function() local v={"Current Map"}; for _,m in ipairs(MAP_LIST) do if m~="Lobby" then table.insert(v,m) end end; return v end)(),
        Value = CFG.IndexFarmWorld or "Current Map",
        Callback = function(v)
            CFG.IndexFarmWorld = v
            currentLockedTargetUID = nil
            if CFG.AutoIndexFarm and v ~= "Current Map" and getCurrentMap() ~= v then
                pcall(function()
                    Library.Remote:Fire("TeleportSystem", "To", v)
                end)
            end
        end
    })

    TabFarm:Section({ Title = "World Progression" })
    TabFarm:Toggle({
        ConfigKey = "AutoGoNewArea",
        Title = "Follow New Areas",
        Desc = "On: farm the newest unlocked area. Off: stay in the current area.",
        Value = CFG.AutoGoNewArea,
        Callback = function(v)
            CFG.AutoGoNewArea = v
            currentLockedTargetUID = nil
            currentCoveredTargetUIDs = {}
            if v then
                local highest = getHighestUnlockedMap()
                if highest and highest ~= "Lobby" and highest ~= getCurrentMap() then
                    TIMERS.lastNewAreaTeleport = os.clock()
                    pcall(function()
                        Library.Remote:Fire("TeleportSystem", "To", highest)
                    end)
                end
            end
        end
    })
    TabFarm:Toggle({
        ConfigKey = "AutoBreakWall",
        Title = "Auto Break World Gates",
        Desc = "Attacks the next gate and moves to the newly unlocked world.",
        Value = CFG.AutoBreakWall,
        Callback = function(v)
            CFG.AutoBreakWall = v
            resetWallBreakTimers()
            if v then
                local highest = getHighestUnlockedMap()
                if highest and highest ~= "Lobby" and highest ~= getCurrentMap() then
                    pcall(function()
                        Library.Remote:Fire("TeleportSystem", "To", highest)
                    end)
                end
            end
        end
    })
    TabFarm:Dropdown({
        ConfigKey = "WallBreakMode",
        Title = "Gate Attack Mode",
        Desc = "Timed alternates gate attacks with farming. Continuous keeps attacking the gate.",
        Values = {"Timed", "Continuous"},
        Value = CFG.WallBreakMode,
        Callback = function(v)
            CFG.WallBreakMode = v
            resetWallBreakTimers()
        end
    })
    TabFarm:Slider({
        ConfigKey = "WallAttackDuration",
        Title = "Gate Attack Duration (s)",
        Desc = "How long to attack the gate before returning to farm in Timed mode.",
        Step = 5,
        Value = { Min = 5, Max = 180, Default = CFG.WallAttackDuration },
        Callback = function(v)
            CFG.WallAttackDuration = v
            resetWallBreakTimers()
        end
    })
    TabFarm:Slider({
        ConfigKey = "WallFarmCooldown",
        Title = "Farm Duration (s)",
        Desc = "How long to farm between gate attacks in Timed mode.",
        Step = 10,
        Value = { Min = 10, Max = 600, Default = CFG.WallFarmCooldown },
        Callback = function(v)
            CFG.WallFarmCooldown = v
            resetWallBreakTimers()
        end
    })

    TabFarm:Section({ Title = "Auto Quests" })
    TabFarm:Toggle({
        ConfigKey = "AutoQuests",
        Title = "Auto Complete Quests",
        Desc = "Accepts quests, progresses objectives and claims completed rewards.",
        Value = CFG.AutoQuests,
        Callback = function(v) CFG.AutoQuests = v end
    })
end

-- ══════════════════════════════════════════════════════════
-- TAB 4: ⏱️ EVENTS & RAIDS
-- ══════════════════════════════════════════════════════════
Tabs.Events = function(win)
    local TabEvents = win:Tab({ Title = "Events & Raids", Icon = "clock" })
    TabEvents:Section({ Title = "Time Trial" })
    TabEvents:Toggle({
        ConfigKey = "AutoTimeTrialDungeon",
        Title = "Auto Time Trial",
        Desc = "Joins available trials, clears enemies and repeats using the selected difficulties.",
        Value = CFG.AutoTimeTrialDungeon,
        Callback = function(v)
            CFG.AutoTimeTrialDungeon = v
            if not v then
                currentLockedTargetUID = nil
            end
        end
    })
    TabEvents:Toggle({
        ConfigKey = "AutoReturnHome",
        Title = "Instant Return",
        Desc = "Returns immediately after Time Trial results. This setting also controls Raid result return.",
        Value = CFG.AutoReturnHome,
        Callback = function(v) CFG.AutoReturnHome = v end
    })
    TabEvents:Dropdown({
        ConfigKey = "TTDifficulties",
        Title = "Trial Difficulties",
        Desc = "Choose which difficulties to enter when their trial window opens.",
        Multi = true,
        Values = {"Easy", "Medium", "Hard"},
        Value = (function() local raw = CFG.TTDifficulties or (type(CFG.TTDifficulty) == "table" and CFG.TTDifficulty) or { "Easy" }; local clean = {}; for _, v in ipairs(type(raw) == "table" and raw or { raw }) do table.insert(clean, (v == "Normal" and "Medium") or v) end; return #clean > 0 and clean or { "Easy" } end)(),
        Callback = function(v)
            local clean = {}; for _, d in ipairs(type(v) == "table" and v or { v }) do table.insert(clean, (d == "Normal" and "Medium") or d) end; CFG.TTDifficulties = clean; CFG.TTDifficulty = clean
            CFG.TTDifficulty = v
        end
    })
    TabEvents:Toggle({
        ConfigKey = "TTCustomExitStage",
        Title = "Exit at Selected Stage",
        Desc = "Leaves the trial when the chosen exit stage is reached.",
        Value = CFG.TTCustomExitStage,
        Callback = function(v) CFG.TTCustomExitStage = v end
    })
    TabEvents:Slider({
        ConfigKey = "TTExitStage",
        Title = "Trial Exit Stage",
        Desc = "Choose the stage at which Auto Time Trial should leave.",
        Step = 1,
        Value = { Min = 1, Max = 50, Default = CFG.TTExitStage },
        Callback = function(v) CFG.TTExitStage = v end
    })
    TabEvents:Button({
        Title = "Enter Time Trial",
        Desc = "Joins a trial using the first selected difficulty.",
        Callback = function()
            local openDiff = getTTOpenWindow() or getSelectedTTDiffs()[1] or "Easy"
            if not doJoinTimeTrial(openDiff) then return end
            CFG.AutoTimeTrialDungeon = true
            CFG.AutoFarm = true
            CFG.AutoClick = true
        end
    })
    TabEvents:Button({
        Title = "Leave Time Trial",
        Desc = "Exits the current trial.",
        Callback = function()
            currentLockedTargetUID = nil
            currentCoveredTargetUIDs = {}
            if getgenv then
                getgenv()._CurrentLockedUID = nil
                getgenv()._CurrentCoveredUIDs = {}
            end
            local gms = _GamemodeSvc
            if gms and gms.GetWindow then
                for _, d in ipairs({"Easy", "Medium", "Hard"}) do
                    local _, win = gms.IsOpen("Time Trial", "The Hallway", d)
                    if win and win.OpensAt then
                        ttLastJoinedWindowId = tostring(win.OpensAt) .. "_" .. d
                    end
                end
            end
            executeGamemodeQuit()
        end
    })

    TabEvents:Section({ Title = "Raids" })
    TabEvents:Toggle({
        ConfigKey = "AutoRaid",
        Title = "Auto Raid",
        Desc = "Creates raids, clears rooms and repeats in the chosen world.",
        Value = CFG.AutoRaid,
        Callback = function(v)
            CFG.AutoRaid = v
            if v then
                local targetMap = CFG.RaidTargetMap or "DBZ"
                if getCurrentMap() ~= targetMap then
                    pcall(function()
                        Library.Remote:Fire("TeleportSystem", "To", targetMap)
                    end)
                end
            else
                currentLockedTargetUID = nil
            end
        end
    })
    TabEvents:Dropdown({
        ConfigKey = "RaidTargetMap",
        Title = "Raid World",
        Desc = "Choose the world used for raid entry and ticket farming.",
        Values = (function() local v={}; for _,m in ipairs(MAP_LIST) do if m~="Lobby" then table.insert(v,m) end end; return v end)(),
        Value = CFG.RaidTargetMap,
        Callback = function(v)
            CFG.RaidTargetMap = v
            if CFG.AutoRaid and getCurrentMap() ~= v then
                currentLockedTargetUID = nil
                pcall(function()
                    Library.Remote:Fire("TeleportSystem", "To", v)
                end)
            end
        end
    })
    TabEvents:Toggle({
        ConfigKey = "AutoFarmTicketIfNone",
        Title = "Auto Farm Raid Tickets",
        Desc = "Farms ticket enemies when you run out. Off: normal farming continues while raids wait.",
        Value = CFG.AutoFarmTicketIfNone,
        Callback = function(v)
            CFG.AutoFarmTicketIfNone = v
            if not v then
                currentLockedTargetUID = nil
                local root = getRoot()
                if root then
                    local bv = root:FindFirstChild("CombatVelocity")
                    if bv then bv:Destroy() end
                end
            else
                local targetMap = CFG.RaidTargetMap or "DBZ"
                if getCurrentMap() ~= targetMap then
                    pcall(function()
                        Library.Remote:Fire("TeleportSystem", "To", targetMap)
                    end)
                end
            end
        end
    })
    TabEvents:Toggle({
        ConfigKey = "AutoReturnHome",
        Title = "Return After Results",
        Desc = "Returns to the world when a raid or trial result screen appears.",
        Value = CFG.AutoReturnHome,
        Callback = function(v) CFG.AutoReturnHome = v end
    })
    TabEvents:Toggle({
        ConfigKey = "RaidCustomExitRoom",
        Title = "Exit at Selected Room",
        Desc = "Leaves the raid when the chosen exit room is reached.",
        Value = CFG.RaidCustomExitRoom,
        Callback = function(v) CFG.RaidCustomExitRoom = v end
    })
    TabEvents:Slider({
        ConfigKey = "RaidExitRoom",
        Title = "Raid Exit Room",
        Desc = "Choose the room at which Auto Raid should leave.",
        Step = 1,
        Value = { Min = 1, Max = 30, Default = CFG.RaidExitRoom },
        Callback = function(v) CFG.RaidExitRoom = v end
    })
    TabEvents:Button({
        Title = "Start Raid",
        Desc = "Enables farming and attacks, then creates and starts a raid in the selected world.",
        Callback = function()
            CFG.AutoRaid = true
            CFG.AutoFarm = true
            CFG.AutoClick = true
            local mapName = CFG.RaidTargetMap or "DBZ"
            pcall(function()
                Library.Remote:Fire("GamemodeSystem", "Create", "Raid", mapName, "Easy", true)
                task.wait(0.5)
                Library.Remote:Fire("GamemodeSystem", "Start", "Raid")
            end)
        end
    })
    TabEvents:Button({
        Title = "Leave Raid",
        Desc = "Exits the current raid.",
        Callback = function()
            Library.Remote:Fire("GamemodeSystem", "Quit", true)
        end
    })

    TabEvents:Section({ Title = "Portals" })
    TabEvents:Toggle({
        ConfigKey = "AutoPortal",
        Title = "Auto Portal Dungeons",
        Desc = "Uses available portal items that match the selected tier.",
        Value = CFG.AutoPortal,
        Callback = function(v) CFG.AutoPortal = v end
    })
    TabEvents:Dropdown({
        ConfigKey = "PortalSelectedTier",
        Title = "Portal Tier",
        Desc = "Choose a portal tier, or All to use any available tier.",
        Values = {"All", "Rank C", "Rank B", "Rank A", "Rank S"},
        Value = CFG.PortalSelectedTier,
        Callback = function(v) CFG.PortalSelectedTier = v end
    })
    TabEvents:Section({ Title = "Marine Invasion" })
    TabEvents:Toggle({
        ConfigKey = "AutoMarineInvasion",
        Title = "Auto Marine Invasion",
        Desc = "Enters available invasions and farms their enemies.",
        Value = CFG.AutoMarineInvasion,
        Callback = function(v) CFG.AutoMarineInvasion = v end
    })
    TabEvents:Dropdown({
        ConfigKey = "InvasionDifficulty",
        Title = "Invasion Difficulty",
        Desc = "Choose the difficulty used when entering Marine Invasion.",
        Values = {"Easy", "Medium", "Hard", "Nightmare"},
        Value = CFG.InvasionDifficulty or "Easy",
        Callback = function(v) CFG.InvasionDifficulty = v end
    })
    TabEvents:Toggle({
        ConfigKey = "InvasionAutoLeave",
        Title = "Leave Completed Invasions",
        Desc = "Leaves Marine Invasion after its completion condition is reached.",
        Value = CFG.InvasionAutoLeave,
        Callback = function(v) CFG.InvasionAutoLeave = v end
    })
    TabEvents:Button({
        Title = "Enter Marine Invasion",
        Desc = "Enters Marine Invasion using the selected difficulty.",
        Callback = function()
            Library.Remote:Fire("GamemodeSystem", "Enter", "Invasion", "Marine Invasion", CFG.InvasionDifficulty or "Easy", true)
        end
    })
end

-- ══════════════════════════════════════════════════════════
-- TAB 5: 🎲 SPINS & GACHA
-- ══════════════════════════════════════════════════════════
Tabs.Spins = function(win)
    local TabSpins = win:Tab({ Title = "Spins & Gacha", Icon = "dices" })
    TabSpins:Section({ Title = "World Summons" })
    _UI_TOGGLES["AutoSummon"] = TabSpins:Toggle({
        ConfigKey = "AutoSummon",
        Title = "Auto Summon",
        Desc = "Summons from the selected world and stops at the chosen rarity or higher.",
        Value = CFG.AutoSummon,
        Callback = function(v) CFG.AutoSummon = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "SummonEgg",
        Title = "Summon World",
        Desc = "Choose the world banner to use for summons.",
        Values = (function() local v={}; for _,m in ipairs(MAP_LIST) do if m~="Lobby" then table.insert(v,m) end end; return v end)(),
        Value = CFG.SummonEgg,
        Callback = function(v) CFG.SummonEgg = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "SummonType",
        Title = "Summon Category",
        Desc = "Choose the item category to summon.",
        Values = GACHA.SUMMON_TYPES,
        Value = CFG.SummonType,
        Callback = function(v) CFG.SummonType = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "SummonStopRarity",
        Title = "Summon Stop Rarity",
        Desc = "Stops Auto Summon at this rarity or higher. Any keeps summoning.",
        Values = GACHA.SUMMON_STOP_RARITIES,
        Value = CFG.SummonStopRarity or "Mythical+",
        Callback = function(v) CFG.SummonStopRarity = v end
    })
    TabSpins:Button({
        Title = "Summon Once",
        Desc = "Requests one summon from the selected world and category.",
        Callback = doAutoSummon
    })
    TabSpins:Button({
        Title = "Summon Ten Times",
        Desc = "Requests ten summons from the selected world and category.",
        Callback = function()
            for i = 1, 10 do
                doAutoSummon()
                task.wait(0.1)
            end
        end
    })

    TabSpins:Section({ Title = "Race Banner" })
    _UI_TOGGLES["AutoRaceSpin"] = TabSpins:Toggle({
        ConfigKey = "AutoRaceSpin",
        Title = "Auto Race Spin",
        Desc = "Rolls Race until the selected tier or higher is obtained.",
        Value = CFG.AutoRaceSpin,
        Callback = function(v) CFG.AutoRaceSpin = v end
    })
    TabSpins:Toggle({
        ConfigKey = "AutoUnlockRace",
        Title = "Auto Unlock Race",
        Desc = "Unlocks the Race system when its gold and world requirements are met.",
        Value = CFG.AutoUnlockRace,
        Callback = function(v) CFG.AutoUnlockRace = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "RaceStopRarity",
        Title = "Race Stop Tier",
        Desc = "Stops auto spin at this tier or higher. Any keeps rolling.",
        Values = ALL_RARITY_NAMES,
        Value = CFG.RaceStopRarity,
        Callback = function(v) CFG.RaceStopRarity = v end
    })

    TabSpins:Section({ Title = "Titan Banner" })
    _UI_TOGGLES["AutoTitanSpin"] = TabSpins:Toggle({
        ConfigKey = "AutoTitanSpin",
        Title = "Auto Titan Spin",
        Desc = "Rolls Titan until the selected tier or higher is obtained.",
        Value = CFG.AutoTitanSpin,
        Callback = function(v) CFG.AutoTitanSpin = v end
    })
    TabSpins:Toggle({
        ConfigKey = "AutoUnlockTitan",
        Title = "Auto Unlock Titan",
        Desc = "Unlocks the Titan system when its gold and world requirements are met.",
        Value = CFG.AutoUnlockTitan,
        Callback = function(v) CFG.AutoUnlockTitan = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "TitanStopRarity",
        Title = "Titan Stop Tier",
        Desc = "Stops auto spin at this tier or higher. Any keeps rolling.",
        Values = GACHA.TITAN_STOPS,
        Value = CFG.TitanStopRarity or "Founding Titan (Secret)",
        Callback = function(v) CFG.TitanStopRarity = v end
    })

    TabSpins:Section({ Title = "Weapon T1 Banner" })
    _UI_TOGGLES["AutoWeaponSummon"] = TabSpins:Toggle({
        ConfigKey = "AutoWeaponSummon",
        Title = "Auto Weapon T1 Spin",
        Desc = "Rolls Weapon T1 until the selected tier or higher is obtained.",
        Value = CFG.AutoWeaponSummon,
        Callback = function(v) CFG.AutoWeaponSummon = v end
    })
    TabSpins:Toggle({
        ConfigKey = "AutoUnlockWeapon",
        Title = "Auto Unlock Weapon T1",
        Desc = "Unlocks the Weapon T1 system when its gold and world requirements are met.",
        Value = CFG.AutoUnlockWeapon,
        Callback = function(v) CFG.AutoUnlockWeapon = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "WeaponT1StopRarity",
        Title = "Weapon T1 Stop Tier",
        Desc = "Stops auto spin at this tier or higher. Any keeps rolling.",
        Values = GACHA.WEAPON_T1_STOPS,
        Value = CFG.WeaponT1StopRarity or "Mythical+",
        Callback = function(v) CFG.WeaponT1StopRarity = v end
    })

    TabSpins:Section({ Title = "Hero Passive Banner" })
    _UI_TOGGLES["AutoHeroPassive"] = TabSpins:Toggle({
        ConfigKey = "AutoHeroPassive",
        Title = "Auto Hero Passive Spin",
        Desc = "Rolls Hero Passive until the selected tier or higher is obtained.",
        Value = CFG.AutoHeroPassive,
        Callback = function(v) CFG.AutoHeroPassive = v end
    })
    TabSpins:Toggle({
        ConfigKey = "AutoUnlockHeroPassive",
        Title = "Auto Unlock Hero Passive",
        Desc = "Unlocks the Hero Passive system when its gold and world requirements are met.",
        Value = CFG.AutoUnlockHeroPassive,
        Callback = function(v) CFG.AutoUnlockHeroPassive = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "TargetHeroPassive",
        Title = "Hero Passive Stop Tier",
        Desc = "Stops auto spin at this tier or higher. Any keeps rolling.",
        Values = GACHA.HERO_STOPS,
        Value = CFG.TargetHeroPassive or "Soul Breaker (Mythical+)",
        Callback = function(v) CFG.TargetHeroPassive = v end
    })

    TabSpins:Section({ Title = "Eye Technique Banner" })
    _UI_TOGGLES["AutoEyeSpin"] = TabSpins:Toggle({
        ConfigKey = "AutoEyeSpin",
        Title = "Auto Eye Technique Spin",
        Desc = "Rolls Eye Technique until the selected tier or higher is obtained.",
        Value = CFG.AutoEyeSpin,
        Callback = function(v) CFG.AutoEyeSpin = v end
    })
    TabSpins:Toggle({
        ConfigKey = "AutoUnlockEye",
        Title = "Auto Unlock Eye Technique",
        Desc = "Unlocks the Eye Technique system when its gold and world requirements are met.",
        Value = CFG.AutoUnlockEye,
        Callback = function(v) CFG.AutoUnlockEye = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "EyeStopRarity",
        Title = "Eye Technique Stop Tier",
        Desc = "Stops auto spin at this tier or higher. Any keeps rolling.",
        Values = GACHA.EYE_STOPS,
        Value = CFG.EyeStopRarity or "Rinnegan (Mythical+)",
        Callback = function(v) CFG.EyeStopRarity = v end
    })

    TabSpins:Section({ Title = "Sin Banner" })
    _UI_TOGGLES["AutoSinSpin"] = TabSpins:Toggle({
        ConfigKey = "AutoSinSpin",
        Title = "Auto Sin Spin",
        Desc = "Rolls Sin until the selected tier or higher is obtained.",
        Value = CFG.AutoSinSpin,
        Callback = function(v) CFG.AutoSinSpin = v end
    })
    TabSpins:Toggle({
        ConfigKey = "AutoUnlockSin",
        Title = "Auto Unlock Sin",
        Desc = "Unlocks the Sin system when its gold and world requirements are met.",
        Value = CFG.AutoUnlockSin,
        Callback = function(v) CFG.AutoUnlockSin = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "SinStopRarity",
        Title = "Sin Stop Tier",
        Desc = "Stops auto spin at this tier or higher. Any keeps rolling.",
        Values = GACHA.SIN_STOPS,
        Value = CFG.SinStopRarity or "Pride (Mythical+)",
        Callback = function(v) CFG.SinStopRarity = v end
    })

    TabSpins:Section({ Title = "Hunter Rank Banner" })
    _UI_TOGGLES["AutoHunterRankSpin"] = TabSpins:Toggle({
        ConfigKey = "AutoHunterRankSpin",
        Title = "Auto Hunter Rank Spin",
        Desc = "Rolls Hunter Rank until the selected tier or higher is obtained.",
        Value = CFG.AutoHunterRankSpin,
        Callback = function(v) CFG.AutoHunterRankSpin = v end
    })
    TabSpins:Toggle({
        ConfigKey = "AutoUnlockHunter",
        Title = "Auto Unlock Hunter Rank",
        Desc = "Unlocks the Hunter Rank system when its gold and world requirements are met.",
        Value = CFG.AutoUnlockHunter,
        Callback = function(v) CFG.AutoUnlockHunter = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "HunterRankStopRarity",
        Title = "Hunter Rank Stop Tier",
        Desc = "Stops auto spin at this tier or higher. Any keeps rolling.",
        Values = GACHA.HUNTER_STOPS,
        Value = CFG.HunterRankStopRarity or "A-Rank (Mythical+)",
        Callback = function(v) CFG.HunterRankStopRarity = v end
    })

    TabSpins:Section({ Title = "Shadow Passive Banner" })
    _UI_TOGGLES["AutoShadowPassiveSpin"] = TabSpins:Toggle({
        ConfigKey = "AutoShadowPassiveSpin",
        Title = "Auto Shadow Passive Spin",
        Desc = "Rolls Shadow Passive until the selected tier or higher is obtained.",
        Value = CFG.AutoShadowPassiveSpin,
        Callback = function(v) CFG.AutoShadowPassiveSpin = v end
    })
    TabSpins:Toggle({
        ConfigKey = "AutoUnlockShadow",
        Title = "Auto Unlock Shadow Passive",
        Desc = "Unlocks the Shadow Passive system when its gold and world requirements are met.",
        Value = CFG.AutoUnlockShadow,
        Callback = function(v) CFG.AutoUnlockShadow = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "ShadowPassiveStopRarity",
        Title = "Shadow Passive Stop Tier",
        Desc = "Stops auto spin at this tier or higher. Any keeps rolling.",
        Values = GACHA.SHADOW_STOPS,
        Value = CFG.ShadowPassiveStopRarity or "Marshal (Mythical+)",
        Callback = function(v) CFG.ShadowPassiveStopRarity = v end
    })

    TabSpins:Section({ Title = "Weapon Passive Banner" })
    _UI_TOGGLES["AutoWeaponPassive"] = TabSpins:Toggle({
        ConfigKey = "AutoWeaponPassive",
        Title = "Auto Weapon Passive Spin",
        Desc = "Rolls Weapon Passive until the selected tier or higher is obtained.",
        Value = CFG.AutoWeaponPassive,
        Callback = function(v) CFG.AutoWeaponPassive = v end
    })
    TabSpins:Toggle({
        ConfigKey = "AutoUnlockWeaponPassive",
        Title = "Auto Unlock Weapon Passive",
        Desc = "Unlocks the Weapon Passive system when its gold and world requirements are met.",
        Value = CFG.AutoUnlockWeaponPassive,
        Callback = function(v) CFG.AutoUnlockWeaponPassive = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "TargetWeaponPassive",
        Title = "Weapon Passive Stop Tier",
        Desc = "Stops auto spin at this tier or higher. Any keeps rolling.",
        Values = GACHA.WEAPON_P_STOPS,
        Value = CFG.TargetWeaponPassive or "Supreme Grade (Mythical+)",
        Callback = function(v) CFG.TargetWeaponPassive = v end
    })

    TabSpins:Section({ Title = "Haki Banner" })
    _UI_TOGGLES["AutoHakiSpin"] = TabSpins:Toggle({
        ConfigKey = "AutoHakiSpin",
        Title = "Auto Haki Spin",
        Desc = "Rolls Haki until the selected tier or higher is obtained.",
        Value = CFG.AutoHakiSpin,
        Callback = function(v) CFG.AutoHakiSpin = v end
    })
    TabSpins:Toggle({
        ConfigKey = "AutoUnlockHaki",
        Title = "Auto Unlock Haki",
        Desc = "Unlocks the Haki system when its gold and world requirements are met.",
        Value = CFG.AutoUnlockHaki,
        Callback = function(v) CFG.AutoUnlockHaki = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "HakiStopRarity",
        Title = "Haki Stop Tier",
        Desc = "Stops auto spin at this tier or higher. Any keeps rolling.",
        Values = GACHA.HAKI_STOPS,
        Value = CFG.HakiStopRarity or "Conqueror (Mythical+)",
        Callback = function(v) CFG.HakiStopRarity = v end
    })

    TabSpins:Section({ Title = "Amulet Banner" })
    _UI_TOGGLES["AutoAmuletSpin"] = TabSpins:Toggle({
        ConfigKey = "AutoAmuletSpin",
        Title = "Auto Amulet Spin",
        Desc = "Rolls Amulet until the selected tier or higher is obtained.",
        Value = CFG.AutoAmuletSpin,
        Callback = function(v) CFG.AutoAmuletSpin = v end
    })
    TabSpins:Toggle({
        ConfigKey = "AutoUnlockAmulet",
        Title = "Auto Unlock Amulet",
        Desc = "Unlocks the Amulet system when its gold and world requirements are met.",
        Value = CFG.AutoUnlockAmulet,
        Callback = function(v) CFG.AutoUnlockAmulet = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "AmuletCategory",
        Title = "Amulet Boost",
        Desc = "Choose the amulet boost to roll and check against the stop tier.",
        Values = GACHA.AMULET_CATEGORIES,
        Value = CFG.AmuletCategory or "Energy",
        Callback = function(v) CFG.AmuletCategory = v end
    })
    TabSpins:Dropdown({
        ConfigKey = "AmuletStopRarity",
        Title = "Amulet Stop Tier",
        Desc = "Stops auto spin at this tier or higher. Any keeps rolling.",
        Values = GACHA.AMULET_STOPS,
        Value = CFG.AmuletStopRarity or "Tier V (Mythical+)",
        Callback = function(v) CFG.AmuletStopRarity = v end
    })
end

-- ══════════════════════════════════════════════════════════
-- TAB 6: 🎒 EQUIPMENT & UPGRADES
-- ══════════════════════════════════════════════════════════
Tabs.Equip = function(win)
    local TabEquip = win:Tab({ Title = "Equip & Upgrade", Icon = "backpack" })
    TabEquip:Section({ Title = "Best Equipment" })
    TabEquip:Toggle({
        ConfigKey = "AutoEquipBest",
        Title = "Auto Equip Best",
        Desc = "Applies the selected global boost and equips the chosen inventory categories.",
        Value = CFG.AutoEquipBest,
        Callback = function(v) CFG.AutoEquipBest = v end
    })
    TabEquip:Dropdown({
        ConfigKey = "AutoEquipBoost",
        Title = "Preferred Boost",
        Desc = "Choose the boost used by the global Equip Best system.",
        Values = {"Energy","Gold","Damage","Drop","GachaLuck","GachaSpins","AtkSPD","CritDMG","CritChance"},
        Value = CFG.AutoEquipBoost,
        Callback = function(v) CFG.AutoEquipBoost = v end
    })
    TabEquip:Toggle({
        ConfigKey = "EquipBestTitle",
        Title = "Auto Equip Best Title",
        Desc = "Equips the highest numbered unlocked title for boost and appearance.",
        Value = CFG.EquipBestTitle,
        Callback = function(v) CFG.EquipBestTitle = v end
    })
    TabEquip:Dropdown({
        ConfigKey = "EquipBestCategories",
        Title = "Equipment Categories",
        Desc = "Choose which categories Auto Equip Best should update.",
        Multi = true,
        Values = { "Weapon", "Warrior", "Avatar", "Accessory", "Mount", "Jewel", "Wing", "DevilFruit", "Crewmate", "Amulet" },
        Value = CFG.EquipBestCategories or { "Weapon", "Warrior", "Avatar", "Accessory", "Mount", "Jewel", "Wing", "DevilFruit", "Crewmate", "Amulet" },
        Callback = function(v)
            CFG.EquipBestCategories = v
        end
    })
    TabEquip:Button({
        Title = "Equip Selected Categories",
        Desc = "Updates the chosen inventory categories now. The title option is respected.",
        Callback = function() doEquipBestCategories(true) end
    })

    TabEquip:Section({ Title = "Rank & Progression" })
    TabEquip:Toggle({
        ConfigKey = "AutoRankUp",
        Title = "Auto Rebirth",
        Desc = "Ranks up when the energy requirement is met and no dungeon is active.",
        Value = CFG.AutoRankUp,
        Callback = function(v)
            CFG.AutoRankUp = v
            if v then
                task.spawn(function()
                    handleAutoRankUp(os.clock() + 2)
                end)
            end
        end
    })

    TabEquip:Section({ Title = "Warrior Upgrades" })
    TabEquip:Toggle({
        ConfigKey = "AutoUpgradeWarrior",
        Title = "Auto Warrior Upgrades",
        Desc = "Buys selected warrior upgrades with the system currency.",
        Value = CFG.AutoUpgradeWarrior,
        Callback = function(v) CFG.AutoUpgradeWarrior = v end
    })
    TabEquip:Toggle({
        ConfigKey = "AutoUnlockWarrior",
        Title = "Auto Unlock Warrior",
        Desc = "Unlocks Warrior when its gold and world requirements are met.",
        Value = CFG.AutoUnlockWarrior,
        Callback = function(v) CFG.AutoUnlockWarrior = v end
    })
    TabEquip:Dropdown({
        ConfigKey = "WarriorSelectedUpgradeNames",
        Title = "Warrior Upgrade Stats",
        Desc = "Choose the stats to upgrade. An empty list buys nothing.",
        Multi = true,
        Values = {"Energy", "Damage", "Gold", "AttackRange"},
        Value = CFG.WarriorSelectedUpgradeNames or {"Energy", "Damage", "Gold", "AttackRange"},
        Callback = function(v) CFG.WarriorSelectedUpgradeNames = v end
    })
    TabEquip:Toggle({
        ConfigKey = "BalanceWarriorUpgrades",
        Title = "Balance Warrior Upgrades",
        Desc = "On: raises the lowest eligible stat by one level. Off: requests max for the chosen stat.",
        Value = CFG.BalanceWarriorUpgrades,
        Callback = function(v) CFG.BalanceWarriorUpgrades = v end
    })

    TabEquip:Section({ Title = "Offline Upgrades" })
    TabEquip:Toggle({
        ConfigKey = "AutoOfflineUpgrades",
        Title = "Auto Offline Upgrades",
        Desc = "Buys selected offline upgrades with the system currency.",
        Value = CFG.AutoOfflineUpgrades,
        Callback = function(v) CFG.AutoOfflineUpgrades = v end
    })
    TabEquip:Toggle({
        ConfigKey = "AutoUnlockOffline",
        Title = "Auto Unlock Offline",
        Desc = "Unlocks Offline when its gold and world requirements are met.",
        Value = CFG.AutoUnlockOffline,
        Callback = function(v) CFG.AutoUnlockOffline = v end
    })
    TabEquip:Dropdown({
        ConfigKey = "OfflineSelectedUpgradeNames",
        Title = "Offline Upgrade Stats",
        Desc = "Choose the stats to upgrade. An empty list buys nothing.",
        Multi = true,
        Values = OFFLINE_UPGRADE_NAMES,
        Value = CFG.OfflineSelectedUpgradeNames or OFFLINE_UPGRADE_NAMES,
        Callback = function(v) CFG.OfflineSelectedUpgradeNames = v end
    })
    TabEquip:Toggle({
        ConfigKey = "BalanceOfflineUpgrades",
        Title = "Balance Offline Upgrades",
        Desc = "On: raises the lowest eligible stat by one level. Off: requests max for the chosen stat.",
        Value = CFG.BalanceOfflineUpgrades,
        Callback = function(v) CFG.BalanceOfflineUpgrades = v end
    })

    TabEquip:Section({ Title = "Portal Upgrades" })
    TabEquip:Toggle({
        ConfigKey = "AutoUpgradePortal",
        Title = "Auto Portal Upgrades",
        Desc = "Buys selected portal upgrades with the system currency.",
        Value = CFG.AutoUpgradePortal,
        Callback = function(v) CFG.AutoUpgradePortal = v end
    })
    TabEquip:Toggle({
        ConfigKey = "AutoUnlockPortal",
        Title = "Auto Unlock Portal",
        Desc = "Unlocks Portal when its gold and world requirements are met.",
        Value = CFG.AutoUnlockPortal,
        Callback = function(v) CFG.AutoUnlockPortal = v end
    })
    TabEquip:Dropdown({
        ConfigKey = "PortalSelectedUpgradeNames",
        Title = "Portal Upgrade Stats",
        Desc = "Choose the stats to upgrade. An empty list buys nothing.",
        Multi = true,
        Values = {"Energy", "Damage", "MaxEnemy", "WarriorDropChance"},
        Value = CFG.PortalSelectedUpgradeNames or {"Energy", "Damage", "MaxEnemy", "WarriorDropChance"},
        Callback = function(v) CFG.PortalSelectedUpgradeNames = v end
    })
    TabEquip:Toggle({
        ConfigKey = "BalancePortalUpgrades",
        Title = "Balance Portal Upgrades",
        Desc = "On: raises the lowest eligible stat by one level. Off: requests max for the chosen stat.",
        Value = CFG.BalancePortalUpgrades,
        Callback = function(v) CFG.BalancePortalUpgrades = v end
    })

    TabEquip:Section({ Title = "Class Tree Upgrades" })
    TabEquip:Toggle({
        ConfigKey = "AutoUpgradeClassTree",
        Title = "Auto Class Tree Upgrades",
        Desc = "Buys selected class tree upgrades with the system currency.",
        Value = CFG.AutoUpgradeClassTree,
        Callback = function(v) CFG.AutoUpgradeClassTree = v end
    })
    TabEquip:Toggle({
        ConfigKey = "AutoUnlockClassTree",
        Title = "Auto Unlock Class Tree",
        Desc = "Unlocks Class Tree when its gold and world requirements are met.",
        Value = CFG.AutoUnlockClassTree,
        Callback = function(v) CFG.AutoUnlockClassTree = v end
    })
    TabEquip:Dropdown({
        ConfigKey = "ClassTreeSelectedUpgradeNames",
        Title = "Class Tree Upgrade Stats",
        Desc = "Choose the stats to upgrade. An empty list buys nothing.",
        Multi = true,
        Values = {"Start", "Energy", "Damage", "Gold", "CritChance", "CritDMG", "WalkSPD"},
        Value = CFG.ClassTreeSelectedUpgradeNames or {"Start", "Energy", "Damage", "Gold", "CritChance", "CritDMG", "WalkSPD"},
        Callback = function(v) CFG.ClassTreeSelectedUpgradeNames = v end
    })
    TabEquip:Toggle({
        ConfigKey = "BalanceClassTreeUpgrades",
        Title = "Balance Class Tree Upgrades",
        Desc = "On: raises the lowest eligible stat by one level. Off: requests max for the chosen stat.",
        Value = CFG.BalanceClassTreeUpgrades,
        Callback = function(v) CFG.BalanceClassTreeUpgrades = v end
    })

    TabEquip:Section({ Title = "Ninja Progression" })
    TabEquip:Toggle({
        ConfigKey = "AutoUpgradeNinja",
        Title = "Auto Ninja Upgrades",
        Desc = "Upgrades Ninja Progression energy with NinjaCoins, one level at a time.",
        Value = CFG.AutoUpgradeNinja,
        Callback = function(v) CFG.AutoUpgradeNinja = v end
    })
    TabEquip:Toggle({
        ConfigKey = "AutoUnlockNinja",
        Title = "Auto Unlock Ninja Progression",
        Desc = "Unlocks Ninja Progression when its gold and world requirements are met.",
        Value = CFG.AutoUnlockNinja,
        Callback = function(v) CFG.AutoUnlockNinja = v end
    })

    TabEquip:Section({ Title = "Ant Progression" })
    TabEquip:Toggle({
        ConfigKey = "AutoUpgradeAnt",
        Title = "Auto Ant Upgrades",
        Desc = "Upgrades Ant Progression energy with AntCoins, one level at a time.",
        Value = CFG.AutoUpgradeAnt,
        Callback = function(v) CFG.AutoUpgradeAnt = v end
    })
    TabEquip:Toggle({
        ConfigKey = "AutoUnlockAnt",
        Title = "Auto Unlock Ant Progression",
        Desc = "Unlocks Ant Progression when its gold and world requirements are met.",
        Value = CFG.AutoUnlockAnt,
        Callback = function(v) CFG.AutoUnlockAnt = v end
    })

    TabEquip:Section({ Title = "Global Upgrades" })
    TabEquip:Toggle({
        ConfigKey = "AutoUpgrade",
        Title = "Auto Upgrade Selected Systems",
        Desc = "Upgrades the chosen systems using their available currencies.",
        Value = CFG.AutoUpgrade,
        Callback = function(v) CFG.AutoUpgrade = v end
    })
    TabEquip:Dropdown({
        ConfigKey = "SelectedGlobalUpgrades",
        Title = "Global Upgrade Systems",
        Desc = "Choose the systems to upgrade. Clear the list to pause global purchases.",
        Multi = true,
        Values = {"Warrior Upgrades", "Offline Upgrades", "Time Trial Upgrades", "Portal Upgrades", "Class Tree", "Ninja Progression", "Ant Progression"},
        Value = CFG.SelectedGlobalUpgrades or {"Warrior Upgrades", "Offline Upgrades", "Time Trial Upgrades", "Portal Upgrades", "Class Tree", "Ninja Progression", "Ant Progression"},
        Callback = function(v) CFG.SelectedGlobalUpgrades = v end
    })
    TabEquip:Toggle({
        ConfigKey = "BalanceGlobalUpgrades",
        Title = "Balance Global Upgrades",
        Desc = "On: raises the lowest eligible stat by one level. Off: requests max for the chosen stat.",
        Value = CFG.BalanceGlobalUpgrades,
        Callback = function(v) CFG.BalanceGlobalUpgrades = v end
    })

    TabEquip:Section({ Title = "Merge & Crafting" })
    TabEquip:Toggle({
        ConfigKey = "AutoMergeAll",
        Title = "Auto Merge Items",
        Desc = "Merges available weapons, wings, pets, warriors and avatars.",
        Value = CFG.AutoMergeAll,
        Callback = function(v) CFG.AutoMergeAll = v end
    })
    TabEquip:Button({
        Title = "Merge Available Items",
        Desc = "Merges available weapons, wings, pets, warriors and avatars once.",
        Callback = doMergeAll
    })
    TabEquip:Toggle({
        ConfigKey = "AutoCraft",
        Title = "Auto Craft Jewelry",
        Desc = "Crafts selected jewelry up to the tier limit and claims jewel rewards.",
        Value = CFG.AutoCraft,
        Callback = function(v) CFG.AutoCraft = v end
    })
    TabEquip:Slider({
        ConfigKey = "CraftMaxTier",
        Title = "Maximum Craft Tier",
        Desc = "Limits crafting to this tier and below.",
        Step = 1,
        Value = { Min = 1, Max = 6, Default = CFG.CraftMaxTier },
        Callback = function(v) CFG.CraftMaxTier = v end
    })
    TabEquip:Toggle({
        Desc = "Includes energy rings in automatic and manual crafting.",
        ConfigKey = "CraftSelection.Ring", Title = "Craft Rings", Value = CFG.CraftSelection.Ring, Callback = function(v) CFG.CraftSelection.Ring = v end })
    TabEquip:Toggle({
        Desc = "Includes gold collars in automatic and manual crafting.",
        ConfigKey = "CraftSelection.Collar", Title = "Craft Collars", Value = CFG.CraftSelection.Collar, Callback = function(v) CFG.CraftSelection.Collar = v end })
    TabEquip:Toggle({
        Desc = "Includes damage earrings in automatic and manual crafting.",
        ConfigKey = "CraftSelection.Earring", Title = "Craft Earrings", Value = CFG.CraftSelection.Earring, Callback = function(v) CFG.CraftSelection.Earring = v end })
    TabEquip:Button({
        Title = "Craft Selected Jewelry",
        Desc = "Crafts chosen jewelry categories up to the tier limit once.",
        Callback = doAutoCraft
    })
end

-- ══════════════════════════════════════════════════════════
-- TAB 7: 🧪 CONSUMABLES & SHOPS (MULTI-BUY SHOPS RESTORED!)
-- ══════════════════════════════════════════════════════════
Tabs.Cons = function(win)
    local TabCons = win:Tab({ Title = "Consumables & Shops", Icon = "flask-conical" })


    TabCons:Section({ Title = "Trial Potion Shop" })
    TabCons:Toggle({
        ConfigKey = "AutoBuyTTShop",
        Title = "Auto Buy Trial Potions",
        Desc = "Buys only the selected potions. An empty selection buys nothing.",
        Value = CFG.AutoBuyTTShop,
        Callback = function(v) CFG.AutoBuyTTShop = v end
    })

    local TT_POTION_NAMES = {
        "Energy Potion I (200)",
        "Damage Potion I (200)",
        "Gold Potion I (200)",
        "Luck Potion I (300)",
        "Drop Potion I (400)",
        "Energy Potion II (500)",
        "Damage Potion II (500)",
        "Gold Potion II (500)",
        "Luck Potion II (600)",
        "Drop Potion II (1000)"
    }
    TabCons:Dropdown({
        ConfigKey = "TTSelectedPotionNames",
        Title = "Trial Potions",
        Desc = "Choose the potions to buy with TrialShards. Clear the list to stop purchases.",
        Multi = true,
        Values = TT_POTION_NAMES,
        Value = CFG.TTSelectedPotionNames or {},
        Callback = function(v)
            CFG.TTSelectedPotionNames = v
        end
    })
    TabCons:Dropdown({
        ConfigKey = "TTShopBuyAmountStr",
        Title = "Potions per Purchase",
        Desc = "Choose how many of each selected potion to request per purchase.",
        Values = {"1x", "5x", "10x", "Max"},
        Value = CFG.TTShopBuyAmountStr or "1x",
        Callback = function(v)
            CFG.TTShopBuyAmountStr = v
            if v == "1x" then CFG.TTShopBuyAmount = 1
            elseif v == "5x" then CFG.TTShopBuyAmount = 5
            elseif v == "10x" then CFG.TTShopBuyAmount = 10
            elseif v == "Max" then CFG.TTShopBuyAmount = 999 end
        end
    })
    TabCons:Button({
        Title = "Buy Selected Trial Potions",
        Desc = "Buys only the selected potions using the chosen quantity.",
        Callback = doTimeTrialShopBuy
    })

    TabCons:Section({ Title = "Trial Stat Upgrades" })
    TabCons:Toggle({
        ConfigKey = "AutoUpgradeTT",
        Title = "Auto Trial Upgrades",
        Desc = "Uses TrialShards to buy the selected trial stat upgrades.",
        Value = CFG.AutoUpgradeTT,
        Callback = function(v) CFG.AutoUpgradeTT = v end
    })
    local TT_UPGRADE_NAMES = {
        "Breaker (Damage +5%)",
        "Relentless (Energy +5%)",
        "Scavenger (Gold +5%)",
        "Overdrive (AtkSPD +2.5%)"
    }
    TabCons:Dropdown({
        ConfigKey = "TTSelectedUpgradeNames",
        Title = "Trial Upgrade Stats",
        Desc = "Choose which trial stats to upgrade. An empty list buys nothing.",
        Multi = true,
        Values = TT_UPGRADE_NAMES,
        Value = CFG.TTSelectedUpgradeNames or TT_UPGRADE_NAMES,
        Callback = function(v)
            CFG.TTSelectedUpgradeNames = v
        end
    })
    TabCons:Toggle({
        ConfigKey = "BalanceTTUpgrades",
        Title = "Balance Trial Upgrades",
        Desc = "On: raises the lowest eligible stat by one level. Off: requests max for the chosen stat.",
        Value = CFG.BalanceTTUpgrades,
        Callback = function(v) CFG.BalanceTTUpgrades = v end
    })
    TabCons:Button({
        Title = "Buy Trial Upgrade",
        Desc = "Purchases an eligible selected stat using the current Balance setting.",
        Callback = doTimeTrialUpgrade
    })

    TabCons:Section({ Title = "Pirate Juice Shop" })
    TabCons:Toggle({
        ConfigKey = "AutoBuyPirateShop",
        Title = "Auto Buy Pirate Juices",
        Desc = "Buys only the selected juices. An empty selection buys nothing.",
        Value = CFG.AutoBuyPirateShop,
        Callback = function(v) CFG.AutoBuyPirateShop = v end
    })

    local PIRATE_JUICE_NAMES = {
        "Energy Juice I (1000)",
        "Damage Juice I (1000)",
        "Gold Juice I (1000)",
        "Drop Juice I (1000)",
        "Luck Juice I (1000)"
    }
    TabCons:Dropdown({
        ConfigKey = "PirateSelectedJuiceNames",
        Title = "Pirate Juices",
        Desc = "Choose the juices to buy. Clear the list to stop purchases.",
        Multi = true,
        Values = PIRATE_JUICE_NAMES,
        Value = CFG.PirateSelectedJuiceNames or {},
        Callback = function(v)
            CFG.PirateSelectedJuiceNames = v
        end
    })
    TabCons:Dropdown({
        ConfigKey = "PirateShopBuyAmountStr",
        Title = "Juices per Purchase",
        Desc = "Choose how many of each selected juice to request per purchase.",
        Values = {"1x", "5x", "10x", "Max"},
        Value = CFG.PirateShopBuyAmountStr or "1x",
        Callback = function(v)
            CFG.PirateShopBuyAmountStr = v
            if v == "1x" then CFG.PirateShopBuyAmount = 1
            elseif v == "5x" then CFG.PirateShopBuyAmount = 5
            elseif v == "10x" then CFG.PirateShopBuyAmount = 10
            elseif v == "Max" then CFG.PirateShopBuyAmount = 999 end
        end
    })
    TabCons:Button({
        Title = "Buy Selected Pirate Juices",
        Desc = "Buys only the selected juices using the chosen quantity.",
        Callback = doPirateShopBuy
    })
end

-- ══════════════════════════════════════════════════════════
-- TAB 8: 🏛️ HARBOR & MAPS
-- ══════════════════════════════════════════════════════════
Tabs.Harbor = function(win)
    local TabHarbor = win:Tab({ Title = "Harbor & Maps", Icon = "compass" })
    TabHarbor:Section({ Title = "Rewards" })
    TabHarbor:Toggle({
        ConfigKey = "AutoClaimAll",
        Title = "Auto Claim Rewards",
        Desc = "Claims available achievements, daily rewards, index rewards, passes and chests.",
        Value = CFG.AutoClaimAll,
        Callback = function(v) CFG.AutoClaimAll = v end
    })
    TabHarbor:Toggle({
        ConfigKey = "AutoClaimLikeRewards",
        Title = "Auto Claim Like Rewards",
        Desc = "Claims available rewards from the game's like milestones.",
        Value = CFG.AutoClaimLikeRewards,
        Callback = function(v) CFG.AutoClaimLikeRewards = v end
    })
    TabHarbor:Button({
        Title = "Claim Available Rewards",
        Desc = "Claims available rewards from the supported reward systems.",
        Callback = doClaimAll
    })
    TabHarbor:Button({
        Title = "Redeem Saved Codes",
        Desc = "Attempts each promo code included in this script. Expired codes may be rejected.",
        Callback = doRedeemAllCodes
    })

    TabHarbor:Section({ Title = "Expeditions & Collectibles" })
    TabHarbor:Toggle({
        ConfigKey = "AutoHarbor",
        Title = "Auto Harbor Expeditions",
        Desc = "Claims harbor rewards and starts the next expedition.",
        Value = CFG.AutoHarbor,
        Callback = function(v) CFG.AutoHarbor = v end
    })
    TabHarbor:Toggle({
        ConfigKey = "AutoCommandments",
        Title = "Auto Collect Commandments",
        Desc = "Collects available commandments and spawned items.",
        Value = CFG.AutoCommandments,
        Callback = function(v) CFG.AutoCommandments = v end
    })


    TabHarbor:Section({ Title = "World Teleports" })
    for _, mapKey in ipairs(MAP_LIST) do
        local mk = mapKey
        TabHarbor:Button({
            Title = "Teleport to " .. mk,
            Desc = "Instantly teleports to world " .. mk,
            Callback = function()
                Library.Remote:Fire("TeleportSystem", "To", mk)
            end
        })
    end
    TabHarbor:Button({
        Title = "Unlock Available Worlds",
        Desc = "Attempts world purchases in order. Each purchase still requires enough gold.",
        Callback = function()
            for _, mk in ipairs(MAP_LIST) do
                Library.Remote:Fire("TeleportSystem", "Buy", mk)
                task.wait(0.4)
            end
        end
    })
end

-- ══════════════════════════════════════════════════════════
-- TAB 9: ⚙️ AUTO DELETE & SELL (ALL 11 RARITY LEVELS)
-- ══════════════════════════════════════════════════════════
Tabs.Delete = function(win)
    local TabDelete = win:Tab({ Title = "Auto Delete & Clean", Icon = "trash-2" })
    TabDelete:Section({ Title = "Auto Delete by Category" })
    local deleteCategories = {
        { Key = "Pet",       Label = "Pets",        TKey = "AutoDeletePets",        DKey = "DeletePetsBelow" },
        { Key = "Weapon",    Label = "Weapons",     TKey = "AutoDeleteWeapons",     DKey = "DeleteWeaponsBelow" },
        { Key = "Wing",      Label = "Wings",       TKey = "AutoDeleteWings",       DKey = "DeleteWingsBelow" },
        { Key = "Avatar",    Label = "Avatars",     TKey = "AutoDeleteAvatars",     DKey = "DeleteAvatarsBelow" },
        { Key = "Accessory", Label = "Accessories", TKey = "AutoDeleteAccessories", DKey = "DeleteAccessoriesBelow" },
        { Key = "Warrior",   Label = "Warriors",    TKey = "AutoDeleteWarriors",    DKey = "DeleteWarriorsBelow" },
        { Key = "Mount",     Label = "Mounts",      TKey = "AutoDeleteMounts",      DKey = "DeleteMountsBelow" },
        { Key = "Jewel",     Label = "Jewels",      TKey = "AutoDeleteJewels",      DKey = "DeleteJewelsBelow" },
    }
    for _, c in ipairs(deleteCategories) do
        TabDelete:Toggle({
            Title = "Auto Delete " .. c.Label,
            Desc = "Deletes unequipped items of the selected rarities, including locked items.",
            ConfigKey = c.TKey,
            Value = CFG[c.TKey],
            Callback = function(v) CFG[c.TKey] = v end
        })
        TabDelete:Dropdown({
            Title = c.Label .. " · Delete Rarities",
            Desc = "Choose rarities to delete. Clear the list to keep every item.",
            Multi = true,
            Values = ALL_RARITY_NAMES,
            ConfigKey = "DeleteRaritySelection." .. c.Key,
            Value = CFG.DeleteRaritySelection[c.Key] or {"Common", "Rare"},
            Callback = function(v)
                CFG.DeleteRaritySelection[c.Key] = v
                for _, r in ipairs(ALL_RARITY_NAMES) do
                    RarityToggles[c.Key][r] = isItemInList(v, r)
                end
            end
        })
    end
end

-- ══════════════════════════════════════════════════════════
-- TAB 10: ℹ️ PLAYER & SERVER
-- ══════════════════════════════════════════════════════════
Tabs.Player = function(win)
    local TabPlayer = win:Tab({ Title = "Player & Server", Icon = "user" })
    TabPlayer:Section({ Title = "Character Settings" })
    TabPlayer:Toggle({
        ConfigKey = "DashHack",
        Title = "Enhanced Dash",
        Desc = "Applies the chosen speed while a character dash is active.",
        Value = CFG.DashHack,
        Callback = function(v) CFG.DashHack = v end
    })
    TabPlayer:Slider({
        ConfigKey = "DashSpeed",
        Title = "Dash Speed",
        Desc = "Choose the movement speed applied by Enhanced Dash.",
        Step = 10,
        Value = { Min = 50, Max = 500, Default = CFG.DashSpeed or 150 },
        Callback = function(v) CFG.DashSpeed = v end
    })
    TabPlayer:Slider({
        ConfigKey = "JumpPower",
        Title = "Jump Power",
        Desc = "Sets the character's local jump power.",
        Step = 5,
        Value = { Min = 50, Max = 500, Default = CFG.JumpPower },
        Callback = function(v) CFG.JumpPower = v end
    })
    TabPlayer:Toggle({
        ConfigKey = "InfHealth",
        Title = "Maintain Local Health",
        Desc = "Sets the character's displayed local health to its maximum.",
        Value = CFG.InfHealth,
        Callback = function(v) CFG.InfHealth = v end
    })
    TabPlayer:Toggle({
        ConfigKey = "NoClip",
        Title = "No Collision",
        Desc = "Disables character collisions while enabled and restores them when turned off.",
        Value = CFG.NoClip,
        Callback = function(v)
            CFG.NoClip = v
            if v then enableNoClip() else disableNoClip() end
        end
    })
    TabPlayer:Button({
        Title = "Teleport to Origin",
        Desc = "Moves the character to coordinates 0, 10, 0.",
        Callback = function()
            local root = getRoot()
            if root then root.CFrame = CFrame.new(0, 10, 0) end
        end
    })

    TabPlayer:Section({ Title = "Session Controls" })
    TabPlayer:Toggle({
        ConfigKey = "AntiAFK",
        Title = "Anti Idle",
        Desc = "Keeps the session active when the game detects inactivity.",
        Value = CFG.AntiAFK,
        Callback = function(v) CFG.AntiAFK = v end
    })
    TabPlayer:Toggle({
        ConfigKey = "AutoRejoin",
        Title = "Auto Rejoin",
        Desc = "Attempts to reconnect when a disconnect prompt appears.",
        Value = CFG.AutoRejoin,
        Callback = function(v) CFG.AutoRejoin = v end
    })
    TabPlayer:Button({
        Title = "Rejoin Current Server",
        Desc = "Reconnects to the current server instance when it is available.",
        Callback = doRejoinCurrent
    })
    TabPlayer:Button({
        Title = "Find Another Server",
        Desc = "Searches for a different public server with a free slot, then joins it.",
        Callback = doServerHop
    })

    local pingVal = 50
    pcall(function()
        if lp and lp.GetNetworkPing then
            pingVal = math.floor((lp:GetNetworkPing() or 0.05) * 1000)
        end
    end)
    TabPlayer:Section({ Title = "Session Details" })
    TabPlayer:Paragraph({
        Title = "Session Information",
        Desc = string.format("Place ID: %s\nJob ID: %s\nPing: ~%d ms\nInterface: SpectreUI (Fluent) — Automation: SpectreWare x clack x clack",
            tostring(game.PlaceId),
            tostring(game.JobId):sub(1, 16) .. "...",
            pingVal
        )
    })
end

-- ══════════════════════════════════════════════════════════
-- TAB 11: ⚙️ CONFIGURATION MANAGER
-- ══════════════════════════════════════════════════════════
Tabs.Config = function(win)
    local TabConfig = win:Tab({ Title = "Configuration", Icon = "settings" })
    TabConfig:Section({ Title = "Profile Management" })

    local configList = getSavedConfigsList()
    local DropdownConfig = TabConfig:Dropdown({
        ConfigKey = "SelectedConfigName",
        Title = "Selected Profile",
        Desc = "Choose the profile to save, load or delete.",
        Values = configList,
        Value = CFG.SelectedConfigName or "default",
        Callback = function(v)
            CFG.SelectedConfigName = v
            if CFG.AutoLoadConfig and writefile then
                pcall(writefile, CONFIG_FOLDER .. "/_autoload.txt", v)
            end
        end
    })

    TabConfig:Toggle({
        ConfigKey = "AutoLoadConfig",
        Title = "Load Profile at Startup",
        Desc = "Restores saved selections at startup. Every switch still starts off.",
        Value = CFG.AutoLoadConfig,
        Callback = function(v)
            CFG.AutoLoadConfig = v
            if writefile then
                pcall(writefile, CONFIG_FOLDER .. "/_autoload.txt", v and (CFG.SelectedConfigName or "default") or "")
            end
        end
    })

    TabConfig:Button({
        Title = "Save Profile",
        Desc = "Saves the current settings to the selected profile.",
        Callback = function()
            saveConfigFile(CFG.SelectedConfigName or "default")
        end
    })

    TabConfig:Button({
        Title = "Load Profile",
        Desc = "Loads saved settings and updates the controls to match.",
        Callback = function()
            loadConfigFile(CFG.SelectedConfigName or "default")
        end
    })

    TabConfig:Section({ Title = "Profile Tools" })

    local newNameInput = ""
    TabConfig:Input({
        Title = "New Profile Name",
        Desc = "Enter a name for the new settings profile.",
        Default = "",
        Placeholder = "e.g. SpeedFarming",
        Callback = function(txt)
            newNameInput = txt
        end
    })

    TabConfig:Button({
        Title = "Create Profile",
        Desc = "Saves current settings as a new profile.",
        Callback = function()
            if newNameInput and newNameInput ~= "" then
                CFG.SelectedConfigName = newNameInput
                saveConfigFile(newNameInput)
                local updatedList = getSavedConfigsList()
                pcall(function() DropdownConfig:Refresh(updatedList) end)
            end
        end
    })

    TabConfig:Button({
        Title = "Delete Profile",
        Desc = "Permanently deletes the selected profile. The default profile is protected.",
        Callback = function()
            if CFG.SelectedConfigName and CFG.SelectedConfigName ~= "default" then
                deleteConfigFile(CFG.SelectedConfigName)
                CFG.SelectedConfigName = "default"
                local updatedList = getSavedConfigsList()
                pcall(function() DropdownConfig:Refresh(updatedList) end)
            end
        end
    })

    TabConfig:Button({
        Title = "Refresh Profiles",
        Desc = "Updates the list of saved profiles.",
        Callback = function()
            local updatedList = getSavedConfigsList()
            pcall(function() DropdownConfig:Refresh(updatedList) end)
        end
    })


end



-- Initialize all tabs synchronously so Real Executor / all environments load instantly without thread death
local tabOrder = { "Dash", "Order", "Farm", "Events", "Spins", "Equip", "Cons", "Harbor", "Delete", "Player", "Config" }
for _, tabName in ipairs(tabOrder) do
    if Tabs[tabName] then
        local ok, err = pcall(function()
            Tabs[tabName](Window)
        end)
        if not ok then
            warn("[SpectreWare] Failed initializing tab " .. tostring(tabName) .. ": " .. tostring(err))
        end
    end
end

-- Immediately finish loading and ensure UI is fully displayed
if Window then
    if Window.FinishLoading then
        pcall(function() Window:FinishLoading() end)
    end
    if Window.Raw and Window.Raw.Root then
        Window.Raw.Root.Visible = true
        Window.Raw.Minimized = false
    end
end
print("[SpectreWare] Anime Breaker ready.")
