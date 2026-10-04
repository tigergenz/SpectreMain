--[[
   SPECTREWARE — ANIME BREAKER
   Interface: SpectreUI (Fluent) — Custom Spectre Theme
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
            if c.Name == "SpectreWareAnimeBreaker" or c.Name:find("WindUI") or c.Name:find("AngelHub") or c.Name:find("AnimeBreaker") then
                pcall(function() c:Destroy() end)
            end
        end
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
local Fluent
do
    local mirrors = {
        "https://raw.githubusercontent.com/thanyathonxyz/fluent/refs/heads/main/dist/main.lua",
        "https://raw.githubusercontent.com/thanyathonxyz/fluent/main/dist/main.lua",
        "https://cdn.jsdelivr.net/gh/thanyathonxyz/fluent@main/dist/main.lua",
    }

    local function fetchFluent()
        local cachePath = "SpectreWare_AnimeBreaker/fluent_cache.lua"
        if isfile and isfile(cachePath) and readfile then
            local cached = readfile(cachePath)
            if cached and #cached > 1000 then
                local fn = loadstring(cached)
                if fn then
                    local okRun, lib = pcall(fn)
                    if okRun and type(lib) == "table" and lib.CreateWindow then
                        return lib
                    end
                end
            end
        end

        for i, url in ipairs(mirrors) do
            local ok, res = pcall(function()
                return game:HttpGet(url, true)
            end)
            if not ok or type(res) ~= "string" or #res < 1000 then
                ok, res = pcall(function()
                    return game:HttpGet(url)
                end)
            end
            if ok and type(res) == "string" and #res > 1000 then
                if writefile then
                    pcall(function()
                        if isfolder and not isfolder("SpectreWare_AnimeBreaker") and makefolder then
                            makefolder("SpectreWare_AnimeBreaker")
                        end
                        writefile(cachePath, res)
                    end)
                end
                local fn, err = loadstring(res)
                if fn then
                    local okRun, lib = pcall(fn)
                    if okRun and type(lib) == "table" and lib.CreateWindow then
                        print(string.format("[SpectreWare] Successfully loaded Fluent from mirror #%d.", i))
                        return lib
                    end
                end
            end
        end
        return nil
    end

    local okFetch, lib = pcall(fetchFluent)
    if okFetch and lib then
        Fluent = lib
    end

    if not Fluent then
        warn("[SpectreWare] CRITICAL: Could not fetch Fluent from any mirror! Check network permissions.")
    end
end

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

    if initialKeyName == "LeftControl" then
        rawWin.MinimizeKey = Enum.KeyCode.RightControl
    elseif initialKeyName == "RightControl" then
        rawWin.MinimizeKey = Enum.KeyCode.LeftControl
    else
        rawWin.MinimizeKey = initialKeyCode
    end
    Fluent.MinimizeKey = initialKeyCode
    Fluent.MinimizeKeybind = { Type = "Keybind", Value = initialKeyName }

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

        -- 2. Call original minimize logic
        pcall(function()
            origMinimize(self or rawWin)
        end)

        -- 3. Explicitly toggle visibility of window root
        local isMinimized = rawWin.Minimized
        if rawWin.Root then
            rawWin.Root.Visible = not isMinimized
        end
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
        Description = "Hides the window. Press LeftControl / RightControl or click the floating button to restore.",
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

Tabs.Dash = function(win)
    local TabDash = win:Tab({ Title = "Dashboard", Icon = "layout-dashboard" })
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

    -- Interface & Appearance Settings via InterfaceManager
    if InterfaceManager then
        pcall(function()
            InterfaceManager:BuildInterfaceSection(TabConfig.Raw or TabConfig)
        end)
    end

end



-- Fast batch tab loader: initializes 11 tabs across ~3 frames (~0.04s total) without frame drops
task.spawn(function()
    if not Window then
        warn("[SpectreWare] Cannot initialize tabs: Window is nil!")
        return
    end
    local tabOrder = { "Dash", "Order", "Farm", "Events", "Spins", "Equip", "Cons", "Harbor", "Delete", "Player", "Config" }
    for i, tabName in ipairs(tabOrder) do
        if Window.Closed then return end
        if Tabs[tabName] then
            local ok, err = pcall(function()
                Tabs[tabName](Window)
            end)
            if not ok then
                warn("[SpectreWare] Failed initializing tab " .. tostring(tabName) .. ": " .. tostring(err))
            end
        end
        if i % 4 == 0 then
            task.wait()
        end
    end
    if Window.FinishLoading then
        pcall(function() Window:FinishLoading() end)
    end
    print("[SpectreWare] Anime Breaker ready.")
end)
