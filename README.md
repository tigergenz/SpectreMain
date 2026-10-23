# SPECTREWARE UI

UI Library สำหรับสคริปต์ Roblox (executor) ใช้ง่าย สวย ลื่น และใช้ได้ทั้ง PC / มือถือ / แท็บเล็ต
แค่โหลดไฟล์เดียว ก็ได้หน้าต่างพร้อมหน้า **Home** และหน้า **Settings** สำเร็จรูป คุณแค่ใส่แท็บกับฟังก์ชันของตัวเอง

> **English quick start** - load the library, create a window, add tabs, sections and controls:
> ```lua
> local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/tigergenz/SpectreMain/refs/heads/main/Library/SpectreUI.lua"))()
> local Window = UI.SpectreUI:CreateWindow({ Brand = { Title = "MY", Accent = "HUB" } })
> local Main = Window:CreateTab({ Name = "Main", Icon = "zap" })
> Main:CreateSection({ Name = "Farm" }):CreateToggle({ Name = "Auto Farm", Default = false, Callback = function(on) end })
> ```
> Full example: [`Library/Example.lua`](Library/Example.lua). The API is documented below (Thai, code in English).

---

## มีอะไรให้บ้าง

| | |
|---|---|
| **Home** | การ์ดต้อนรับ, กราฟ FPS / Ping, ข้อมูลเซิร์ฟเวอร์ (Rejoin / Hop / Lowest / Job ID), การ์ดลิงก์ (Discord, เว็บไซต์), รายการฟีเจอร์, สถานะ executor |
| **Settings สำเร็จรูป** | Menu Controls (PC / Mobile / ทั้งคู่), ปุ่มเปิดเมนู, ธีม 9 แบบ + Custom, Blur, Glass, Auto Size, UI Scale, Unload, ระบบ Config (เซฟ / โหลด / โหลดอัตโนมัติ แยกตามเกม) |
| **มือถือ** | ตรวจจับอุปกรณ์เอง, Dynamic Island ด้านบนจอสำหรับเปิด / ปิดเมนู, Auto Size ปรับขนาดให้พอดีจอ |
| **ใช้งานง่าย** | ค้นหาทุกหน้าพร้อมคำแนะนำ, แถบทางลัดไปแต่ละกลุ่ม, 2 คอลัมน์เมื่อหน้าต่างกว้าง, คลิกขวา / กดค้างที่ตัวเลือกเพื่อ ปักหมุดไว้หน้า Home / ตั้งปุ่มลัด / รีเซ็ต |
| **ภาพ** | ตัวหนังสือคมชัดบนมือถือ, แจ้งเตือน + popup นุ่มนวล, ธีมเปลี่ยนสด |
| **ปลอดภัย** | รันสคริปต์ซ้ำได้ (ของเก่าถูกปิดให้เอง), ปุ่ม Unload หยุดทุกอย่าง, จำค่าตั้งค่าไว้ให้ครั้งหน้า |

---

## 1. โหลด Library

```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/tigergenz/SpectreMain/refs/heads/main/Library/SpectreUI.lua"))()
local Library = UI.SpectreUI
```

`UI` มี 3 แบบให้เลือกใช้ (เลือกอย่างใดอย่างหนึ่ง):

| | ใช้เมื่อ |
|---|---|
| `UI.SpectreUI` | **แนะนำ** - API แบบ `CreateTab` / `CreateSection` / `CreateToggle` ได้ Home + Settings อัตโนมัติ |
| `UI.Fluent` | ย้ายสคริปต์ที่เขียนด้วย Fluent มาใช้ (`AddTab` / `AddSection` / `AddToggle`) - ดู [หัวข้อ 8](#8-api-แบบ-fluent) |
| `UI.Lib` | ควบคุมเองทั้งหมด (สร้าง Home / Settings เอง) - ดู [หัวข้อ 9](#9-api-ระดับลึก-uilib) |

---

## 2. สร้างหน้าต่าง

```lua
local Window = Library:CreateWindow({
    Brand = { Title = "MY", Accent = "HUB", Subtitle = "v1.0.0", Icon = "layers" },
    Theme = "Midnight",
    ToggleKey = Enum.KeyCode.RightShift,
    Home = {
        Plan = "Free",
        Links = {
            { Title = "Discord", Url = "https://discord.gg/xxxx", Icon = "message-circle" },
            { Title = "Website", Url = "https://example.com", Icon = "globe" },
        },
    },
})
```

| ตัวเลือก | ค่า | ความหมาย |
|---|---|---|
| `Brand.Title` | string | ชื่อตัวใหญ่ (สีขาว) ใน sidebar |
| `Brand.Accent` | string | ส่วนต่อท้ายชื่อ เป็นสีตามธีม (`"MY"` + `"HUB"` แสดงเป็น MYHUB โดย HUB เป็นสีธีม) |
| `Brand.Subtitle` | string | บรรทัดเล็กใต้ชื่อ (ค่าเริ่มต้น = เวอร์ชัน UI) |
| `Brand.Icon` | ชื่อไอคอน / asset id | ไอคอนบน Dynamic Island |
| `Theme` | ชื่อธีม | ธีมเริ่มต้น (ถ้าผู้เล่นเคยเลือกธีมเองแล้ว จะใช้ของผู้เล่น) |
| `ToggleKey` | `Enum.KeyCode` | ปุ่มเปิด / ปิดเมนู (ผู้เล่นเปลี่ยนได้ใน Settings และระบบจำไว้) |
| `Home.Plan` | string | ป้ายแพ็กเกจในการ์ดต้อนรับ เช่น `"Free"`, `"Premium"` |
| `Home.ExpiresAt` | unix time | วันหมดอายุคีย์ (นับถอยหลังให้เอง) |
| `Home.TimeLeft` | string | ข้อความคงที่แทนการนับ เช่น `"Lifetime"` |
| `Home.Links` | `{ {Title, Url, Icon} }` | การ์ด LINKS (กดปุ่มขวาเพื่อคัดลอก) |
| `Home.FeatureList` | `false` | ซ่อนแถว "Feature list" |

หน้าต่างจะ **เปิดขึ้นเอง** หลังจากสคริปต์สร้างแท็บ / ตัวเลือกเสร็จ (หน้าแรกคือ Home)

---

## 3. แท็บและกลุ่ม

```lua
local Main = Window:CreateTab({ Name = "Main", Icon = "zap" })
local Farm = Main:CreateSection({ Name = "Auto Farm" })         -- การ์ด 1 ใบ
local Extra = Main:CreateSection({ Name = "Extra", Collapsed = true })   -- เริ่มแบบพับไว้
```

- 1 แท็บมีได้หลาย Section (แต่ละอันเป็นการ์ดมีหัวข้อ กดหัวข้อเพื่อพับ / กาง)
- มี 3 กลุ่มขึ้นไป จะมี **แถบทางลัด** ด้านบนให้กดไปแต่ละกลุ่ม
- หน้าต่างกว้างพอ การ์ดจะเรียง **2 คอลัมน์** ให้เอง
- แท็บชื่อ `"Settings"` จะไปรวมกับหน้า Settings ของ UI (เป็นกลุ่ม "Game")
- แท็บชื่อ `"Home"` จะเปลี่ยนชื่อเป็น `"Overview"` (เพราะมี Home อยู่แล้ว)
- ใส่ตัวเลือกบนแท็บตรงๆ ได้ (`Main:CreateToggle{...}`) จะอยู่ในการ์ดแรกของแท็บ

---

## 4. ตัวเลือก (Controls)

ทุกตัวรับ `Name`, `Tooltip` (คำอธิบายใต้ชื่อ), `Flag` (ชื่อเก็บค่าใน `Library.Flags`), `Callback` และ `Config = false` (ไม่เก็บลง Config)
ทุกตัวคืน object ที่มี `:Set(value, silent)`, `:Get()` และ `.Value` (`silent = true` = ไม่เรียก Callback)

### Toggle - สวิตช์
```lua
local t = Farm:CreateToggle({
    Name = "Auto Farm", Tooltip = "Farms while it is on.", Default = false, Flag = "AutoFarm",
    Callback = function(on) end,
})
t:Set(true)
```

### Slider - ตัวเลื่อน
```lua
Farm:CreateSlider({
    Name = "Speed", Min = 1, Max = 100, Default = 16, Increment = 1, Suffix = " studs", Flag = "Speed",
    Callback = function(v) end,
})
```

### Dropdown - เลือก 1 อย่าง / หลายอย่าง
```lua
local d = Farm:CreateDropdown({
    Name = "Target", Options = { "A", "B", "C" }, Default = "A", Flag = "Target",
    Callback = function(v) end,                    -- v = "A"
})
Farm:CreateDropdown({
    Name = "Areas", Options = { "Forest", "Desert", "Snow" }, Multi = true, Default = { "Forest" },
    Callback = function(list) end,                 -- list = { "Forest", ... }
})
d:Refresh({ "X", "Y", "Z" })                       -- เปลี่ยนรายการ
```
- ตั้งแต่ 6 รายการขึ้นไปมี **ช่องค้นหา** อัตโนมัติ (`Searchable = true / false` บังคับเปิด / ปิด)
- แบบ Multi มีปุ่ม **Select all / Clear**
- ไม่ใส่ `Default` = เริ่มแบบไม่ได้เลือก

### Textbox - ช่องพิมพ์
```lua
Farm:CreateTextbox({
    Name = "Player", Placeholder = "Type a name...", Default = "",
    Numeric = false, Min = nil, Max = nil, MaxLength = nil, Live = false,   -- Live = เรียก Callback ทุกตัวอักษร
    Callback = function(text) end,
})
```
`Numeric = true` รับเฉพาะตัวเลข (Callback ได้ number) ชื่ออื่นที่ใช้ได้: `CreateInput`

### Keybind - ปุ่มลัด
```lua
Farm:CreateKeybind({
    Name = "Quick Farm", Default = Enum.KeyCode.F, Mode = "Toggle",   -- "Press" | "Toggle" | "Hold"
    Callback = function(state) end,      -- Press: () / Toggle: (on) / Hold: (true กด, false ปล่อย)
    Changed = function(newKey) end,      -- ผู้เล่นเปลี่ยนปุ่ม
})
```

### Button - ปุ่ม
```lua
local b = Farm:CreateButton({ Name = "Teleport", Icon = "map-pin", Callback = function() end })
b:SetText("Teleport now")
```

### Paragraph / Label / KeyValue - แสดงข้อความ
```lua
local p = Farm:CreateParagraph({ Title = "Status", Content = "Idle" })
p:Set(nil, "Farming...")                -- (หัวข้อ, เนื้อหา) ใส่ nil ถ้าไม่เปลี่ยน

local l = Farm:CreateLabel("Plain text")
l:Set("Changed") ; l:SetColor(Color3.fromRGB(110, 231, 160))

local kv = Farm:CreateKeyValue({ Name = "Coins", Value = "0" })
kv:Set("1,250")
```

### อื่นๆ
`CreateDivider()` (เว้นที่), `CreateColorPicker` (เก็บค่าไว้ ยังไม่วาดตัวเลือกสี), ฟังก์ชันที่ไม่รู้จักจะไม่ error

---

## 5. หน้าต่าง (Window)

```lua
Window:Notify({ Title = "Done", Content = "Teleported!", Duration = 3, Kind = "Success" })  -- Kind: Success / Warning / Error
Window:Toast("Saved!", "Success")
Window:Success("Title", "Text", 3)      -- หรือ :Info / :Warning / :Error

Window:Confirm({
    Title = "Reset?", Content = "Turn everything off.", Yes = "Reset", No = "Cancel", Icon = "rotate-ccw",
    Callback = function(ok) end,
})
Window:Dialog({ Title = "Hi", Content = "Pick one", Buttons = { { Title = "A", Callback = fn }, { Title = "B" } } })
```

| เมธอด | |
|---|---|
| `Window:SelectTab(tab or name or index)` | เปิดแท็บ (หลังเมนูเปิดครั้งแรก) |
| `Window:Toggle()` / `:Open()` / `:Close()` / `:IsOpen()` | เปิด / ปิดเมนู |
| `Window:SetTheme(name)` | เปลี่ยนธีม |
| `Window:SetToggleKey(Enum.KeyCode.X)` / `:GetToggleKey()` | ปุ่มเปิดเมนู |
| `Window:Resize(w, h)` | ขนาดหน้าต่าง |
| `Window:OnLoaded(fn)` | เรียกครั้งเดียวตอนเมนูเปิดครั้งแรก (หลังโหลด Config อัตโนมัติ) |
| `Window:Destroy()` | Unload ทั้งหมด |

แจ้งเตือนขึ้นพร้อมกันได้สูงสุด 5 อัน

---

## 6. ระดับ Library

```lua
Library.Flags.AutoFarm                      -- ค่าปัจจุบันของตัวเลือกที่มี Flag
Library:SetFlag("AutoFarm", true)           -- ตั้งค่า (เรียก Callback ด้วย)
Library:GetControl("AutoFarm")              -- object ของตัวเลือก
Library:OnFlag(function(flag, new, old) end)
Library:ListThemes()                        -- { "Midnight", "Mono", ... }
Library:SetTheme("Ocean")
Library:Copy("text")                        -- คัดลอก + แจ้งเตือน

UI.OnUnload(function() running = false end) -- หยุดลูปของคุณเมื่อกด Unload / รันสคริปต์ซ้ำ
UI.Unload()
UI.Notify({ Title = "Hi", Content = "..." })
UI.VERSION                                  -- "1.1.0"
UI.Lib:AddTheme({ Name = "Mint", Base = Color3.fromRGB(10, 20, 18), Accent = Color3.fromRGB(94, 234, 212) })  -- เรียกก่อน CreateWindow
```

**สำคัญ:** ลูป `while` ของคุณควรหยุดเมื่อ Unload:
```lua
local alive = true
UI.OnUnload(function() alive = false end)
task.spawn(function()
    while alive do
        if Library.Flags.AutoFarm then --[[ ... ]] end
        task.wait(0.5)
    end
end)
```

---

## 7. ไอคอนและธีม

**ไอคอน** ใส่ชื่อแบบ [Lucide](https://lucide.dev/icons) (`"zap"`, `"lucide:zap"`) หรือ asset id (`123456` / `"rbxassetid://123456"`) ชื่อที่มีในตัว:

`activity` `anchor` `arrow-up` `axe` `backpack` `bed` `bell` `blend` `bone` `book-open` `bookmark` `bot` `box` `briefcase` `car` `check` `check-check` `chevron-down` `chevron-left` `chevron-right` `circle` `circle-check` `clock` `cloud` `cloud-lightning` `coffee` `cog` `compass` `copy` `cpu` `crosshair` `crown` `dices` `dna` `dollar-sign` `droplet` `droplets` `egg` `ellipsis` `eraser` `eye` `eye-off` `flask-conical` `flask-round` `folder-open` `footprints` `gamepad-2` `gauge` `gem` `gift` `glass-water` `globe` `graduation-cap` `grip` `hammer` `hand` `hand-coins` `hash` `heart` `house` `info` `key` `keyboard` `lasso` `layers` `layout-dashboard` `layout-grid` `leaf` `link` `list-checks` `list-filter` `list-ordered` `magnet` `map` `map-pin` `message-circle` `minimize-2` `monitor` `mouse-pointer-click` `move` `navigation` `package` `package-check` `package-plus` `palette` `paw-print` `pin` `pin-off` `pipette` `play` `power` `recycle` `refresh-cw` `repeat` `rotate-ccw` `save` `scan` `scan-eye` `scroll` `search` `server` `settings` `shield` `shield-check` `shopping-bag` `shopping-cart` `shuffle` `siren` `sliders-horizontal` `smartphone` `sparkles` `sprout` `star` `store` `sword` `swords` `target` `terminal` `timer` `toggle-right` `trash-2` `trees` `trending-down` `trending-up` `triangle-alert` `user` `user-round` `user-search` `user-x` `users` `utensils` `wifi` `wind` `x` `zap`

(ชื่อที่ไม่มีจะแสดงเป็นวงกลม)

**ธีม** `Midnight` `Mono` `Ocean` `Emerald` `Crimson` `Amethyst` `Sunset` `Sakura` `Nord` และ `Custom` (ผู้เล่นตั้งสีเองใน Settings)

---

## 8. API แบบ Fluent

สำหรับย้ายสคริปต์ Fluent เดิม (ได้ Home + Settings อัตโนมัติเหมือนกัน):

```lua
local Fluent = UI.Fluent
local Window = Fluent:CreateWindow({ Brand = { Title = "MY", Accent = "HUB" }, MinimizeKey = Enum.KeyCode.LeftControl })
local Tab = Window:AddTab({ Title = "Main", Icon = "zap" })
local Sec = Tab:AddSection({ Title = "Farm" })

local t = Sec:AddToggle("AutoFarm", { Title = "Auto Farm", Description = "...", Default = false, Callback = function(v) end })
t:OnChanged(function(v) end)
Sec:AddSlider("Speed", { Title = "Speed", Min = 1, Max = 100, Default = 16, Rounding = 0 })
Sec:AddDropdown("Target", { Title = "Target", Values = { "A", "B" }, Default = 1, Multi = false })
Sec:AddInput("Name", { Title = "Name", Placeholder = "...", Finished = true })
Sec:AddKeybind("Key", { Title = "Key", Default = "F", Mode = "Toggle" })
Sec:AddButton({ Title = "Go", Callback = function() end })
Sec:AddParagraph({ Title = "Info", Content = "..." })

Fluent.Options.AutoFarm:SetValue(true)
Fluent:Notify({ Title = "Hi", Content = "...", Duration = 3 })
```
Multi dropdown ใช้ค่าแบบ `{ [name] = true }` เหมือน Fluent

---

## 9. API ระดับลึก (`UI.Lib`)

สร้างทุกอย่างเอง (ไม่มี Home / Settings อัตโนมัติ):

```lua
local WindUI = UI.Lib
local Window = WindUI:CreateWindow({ Title = "MY", TitleAccent = "HUB", Author = "v1.0", Icon = "layers", Theme = "Midnight", ToggleKey = Enum.KeyCode.Z })
Window:Home({ Plan = "Free", Links = { ... } })

local Tab = Window:Tab({ Title = "Main", Icon = "zap" })
Tab:Section({ Title = "General" })         -- หลาย Section = แถบสลับใต้หัวข้อ
Tab:Group("Basic")                          -- การ์ดมีหัวข้อ
Tab:Toggle({ Title = "Toggle", Desc = "...", Value = false, Callback = function(v) end })
Tab:Slider({ Title = "Slider", Value = { Min = 0, Max = 100, Default = 50 }, Step = 5, Callback = function(v) end })
Tab:Dropdown({ Title = "Pick", Values = { "A", "B" }, Value = "A", Multi = false, Callback = function(v) end })
Tab:Keybind({ Title = "Key", Value = "E", Callback = function(k) end })
Tab:Input({ Title = "Text", Placeholder = "...", Callback = function(t) end })
Tab:Button({ Title = "Button", Callback = function() end })
Tab:Paragraph({ Title = "Info", Desc = "..." })
Tab:ThemePicker()                           -- ตัวเลือกธีม
Tab:ConfigManager()                         -- ระบบ Config

WindUI:Notify({ Title = "Hi", Content = "...", Icon = "check", Duration = 3 })
WindUI:Popup({ Title = "Sure?", Content = "...", Buttons = { { Title = "No" }, { Title = "Yes", Variant = "Primary", Callback = fn } } })
```
หน้าต่าง: `Window:SetGlass(on)`, `:SetBlur(on)`, `:SetAutoSize(on)`, `:SetUIScale(n)`, `:SetControlMode("Auto"|"PC"|"Mobile"|"PC + Mobile")`, `:Collapse(on)`, `:SelectTab(i)`, `:Destroy()`
ตัวเลือกทั้งหมดของแบบนี้มีคำอธิบายอยู่ในไฟล์ [`Library/SpectreUI.lua`](Library/SpectreUI.lua) (ค้นหา `function Lib:CreateWindow` และ `function tabObj:`)

---

## 10. หมายเหตุ

- **Executor:** ต้องมี `getgenv`, `writefile` / `readfile` (เซฟค่า / Config) แนะนำ `setclipboard`, `request` (รายชื่อเซิร์ฟเวอร์) - หน้า Home บอกสถานะให้
- ค่าที่ผู้เล่นตั้ง (ธีม, ปุ่มเมนู, ขนาด, Glass ฯลฯ) เก็บใน `MonoUI/settings.json` ส่วน Config อยู่ใน `MonoUI/configs/<เกม>/`
- รันสคริปต์ซ้ำได้เลย UI เก่าและลูปที่ลงทะเบียน `UI.OnUnload` จะถูกปิดให้ก่อน
- UI ตัวเดียวต่อเกม: ถ้ารันสคริปต์อื่นที่ใช้ SPECTREWARE UI ตัวเก่าจะถูกปิด
- ผู้เล่นคลิกขวา (PC) / กดค้าง (มือถือ) ที่ตัวเลือกเพื่อปักหมุดไว้หน้า Home, ตั้งปุ่มลัด หรือรีเซ็ตค่าได้เอง ไม่ต้องเขียนเพิ่ม

## ไฟล์ใน repo

| ไฟล์ | |
|---|---|
| [`Library/SpectreUI.lua`](Library/SpectreUI.lua) | ตัว Library (อ่านได้ ไม่ย่อ) |
| [`Library/Example.lua`](Library/Example.lua) | ตัวอย่างการใช้งานครบ |
| [`MobileTest.lua`](MobileTest.lua) | สคริปต์ทดสอบบนมือถือ (อุปกรณ์, executor, console) |
| `*.lua` อื่นๆ | สคริปต์ของแต่ละเกม (ฝัง UI ไว้ในไฟล์แล้ว) |
