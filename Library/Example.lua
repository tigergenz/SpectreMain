--[[
    SPECTREWARE UI - example script
    Run it in any game with your executor. Read README.md for every option.
]]

local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/tigergenz/SpectreMain/refs/heads/main/Library/SpectreUI.lua"))()
local Library = UI.SpectreUI

-- (optional) your own theme: add it BEFORE CreateWindow so it shows in Settings > Theme
UI.Lib:AddTheme({ Name = "Mint", Base = Color3.fromRGB(10, 20, 18), Accent = Color3.fromRGB(94, 234, 212) })

local Window = Library:CreateWindow({
    Brand = { Title = "MY", Accent = "HUB", Subtitle = "v1.0.0", Icon = "layers" },   -- "MYHUB" in the sidebar
    Theme = "Midnight",                         -- default theme (a theme the player picked wins)
    ToggleKey = Enum.KeyCode.RightShift,        -- menu key (the player can change it in Settings)
    Home = {
        Plan = "Free",
        Links = {
            { Title = "Discord", Url = "https://discord.gg/your-invite", Icon = "message-circle" },
            { Title = "Website", Url = "https://example.com", Icon = "globe" },
        },
    },
})

-- everything your script runs should stop when the player presses Unload (Settings > Script)
local alive = true
UI.OnUnload(function() alive = false end)

--------------------------------------------------------------------------- Main tab
local Main = Window:CreateTab({ Name = "Main", Icon = "zap" })

local Farm = Main:CreateSection({ Name = "Auto Farm" })
Farm:CreateToggle({
    Name = "Auto Farm", Tooltip = "Farms while it is on.", Default = false, Flag = "AutoFarm",
    Callback = function(on) print("Auto Farm:", on) end,
})
Farm:CreateSlider({
    Name = "Farm Delay", Min = 0.1, Max = 3, Default = 1, Increment = 0.1, Suffix = "s", Flag = "FarmDelay",
    Callback = function(v) print("Delay:", v) end,
})
Farm:CreateDropdown({
    Name = "Target", Options = { "Nearest", "Strongest", "Weakest" }, Default = "Nearest", Flag = "Target",
    Callback = function(v) print("Target:", v) end,
})
Farm:CreateDropdown({
    Name = "Areas", Options = { "Forest", "Desert", "Snow", "Volcano", "Ocean", "Sky" }, Multi = true,
    Default = { "Forest" }, Flag = "Areas",
    Callback = function(list) print("Areas:", table.concat(list, ", ")) end,
})

local Misc = Main:CreateSection({ Name = "Extras" })
Misc:CreateTextbox({
    Name = "Player Name", Placeholder = "Type a name...",
    Callback = function(text) print("Name:", text) end,
})
Misc:CreateKeybind({
    Name = "Toggle Farm Key", Default = Enum.KeyCode.F, Mode = "Press",
    Callback = function()
        Library:SetFlag("AutoFarm", not Library.Flags.AutoFarm)     -- flip the toggle from a key
    end,
})
Misc:CreateButton({
    Name = "Say Hello",
    Callback = function()
        Window:Notify({ Title = "Hello!", Content = "Buttons can do anything.", Kind = "Success", Duration = 3 })
    end,
})
Misc:CreateButton({
    Name = "Reset Everything",
    Callback = function()
        Window:Confirm({
            Title = "Reset?", Content = "Turn every feature off.", Yes = "Reset", No = "Cancel", Icon = "rotate-ccw",
            Callback = function(ok)
                if ok then Library:SetFlag("AutoFarm", false) end
            end,
        })
    end,
})

--------------------------------------------------------------------------- Stats tab
local Stats = Window:CreateTab({ Name = "Stats", Icon = "activity" })
local Live = Stats:CreateSection({ Name = "Live" })
local status = Live:CreateParagraph({ Title = "Status", Content = "Idle" })
local timer = Live:CreateKeyValue({ Name = "Running for", Value = "0s" })

local started = os.clock()
task.spawn(function()
    while alive do
        timer:Set(("%ds"):format(math.floor(os.clock() - started)))
        status:Set(nil, Library.Flags.AutoFarm and "Farming..." or "Idle")
        task.wait(1)
    end
end)

-- a tab called "Settings" joins the built-in Settings tab (as a "Game" section)
local Settings = Window:CreateTab({ Name = "Settings" })
Settings:CreateSection({ Name = "Game" }):CreateToggle({ Name = "Hide Damage Numbers", Default = false })
