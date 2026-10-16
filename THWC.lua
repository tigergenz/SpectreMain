--[[
	SpectreWare | Thai Word Chain [ ต่อคำศัพท์ภาษาไทย ]
	UI: SpectreUI v3.17 (dark/cyan-navy Roblox UI library by SpectreWare)
	Theme: Spectre (Dark Graphite / Deep Navy Slate / Electric Cyan)
	Brand: SpectreWare
	Discord: https://discord.gg/GdKxvcHzjS
	Game: Thai Word Chain [ ต่อคำศัพท์ภาษาไทย ] (PlaceId: 101001957765810)

	Features:
	  • Built with SpectreUI v3.17 (Official Keyless build)
	  • Auto Answer: Auto detects your turn, retrieves 100% valid Thai words from server dictionary
	  • Word Strategy: Common Words First, Longest Word, Shortest Word, or Random Valid
	  • Realistic Typing Simulation: Simulates human typing speed with live Typing:FireServer broadcasts & in-game WordBox sync
	  • Customizable Typing: Humanized, Smooth Natural (variable pacing), Fast, or Instant modes
	  • Anti-Repeat Protection: Automatically tracks words used in the match to prevent repeating
	  • Auto Retry: If a word is rejected or timeout warning occurs, instantly submits next best word
	  • Live Suggestion HUD: Displays valid clickable word buttons right on screen for manual play
	  • Table Automation: Auto Find & Sit at Duel Tables (DuelTable 1-29), Auto Pick Mode (Easy/Hard)
	  • Rewards Automation: Auto Claim Daily Rewards, Group Rewards, Quests, and Redeem Active Codes
	  • Local Player & Visuals: WalkSpeed, JumpPower, Infinite Jump, Fullbright, Anti-AFK
]]

-- AUTO Plugin fix for Delta / Wave / Arceus / Fluxus
pcall(function()
	local set = setthreadidentity or set_thread_identity or setthreadcontext or set_identity
	if set then pcall(set, 8) pcall(set, 7) end
end)

-- ===================== GAME GUARD =====================
local EXPECTED_PLACE_ID = 101001957765810
if game.PlaceId ~= EXPECTED_PLACE_ID then
	warn(string.format("[SpectreWare] Unexpected PlaceId: %s (Expected %s)", tostring(game.PlaceId), tostring(EXPECTED_PLACE_ID)))
end

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

-- ===================== GENERATION GUARD & CLEANUP =====================
getgenv()._twc_gen = (getgenv()._twc_gen or 0) + 1
local MY_GEN = getgenv()._twc_gen
local function isCurrentGen()
	return getgenv()._twc_gen == MY_GEN
end

pcall(function()
	local function clean(parent)
		if not parent then return end
		for _, c in ipairs(parent:GetChildren()) do
			if c:IsA("ScreenGui") and (c.Name:find("SpectreUI_TWC") or c.Name == "SpectreUI_ThaiWordChain" or c.Name == "Spectre_WordSuggestions") then
				pcall(function() c:Destroy() end)
			end
		end
	end
	clean(game:GetService("CoreGui"))
	if gethui then clean(gethui()) end
	if game:GetService("Players").LocalPlayer then
		clean(game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui"))
	end
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

-- ===================== SERVICES & LOCALS =====================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 15)
local MatchRemote = Remotes and Remotes:WaitForChild("Match", 10)
local SubmitRemote = Remotes and Remotes:WaitForChild("Submit", 10)
local TypingRemote = Remotes and Remotes:WaitForChild("Typing", 10)
local DictLookup = Remotes and Remotes:WaitForChild("DictLookup", 10)
local ChooseModeRemote = Remotes and Remotes:WaitForChild("ChooseMode", 10)
local ClaimDailyRemote = Remotes and Remotes:WaitForChild("ClaimDaily", 10)
local ClaimGroupRemote = Remotes and Remotes:WaitForChild("ClaimGroup", 10)
local QuestRemote = Remotes and Remotes:WaitForChild("Quest", 10)
local RedeemCodeRemote = Remotes and Remotes:WaitForChild("RedeemCode", 10)
local RoleSpinRemote = Remotes and Remotes:WaitForChild("RoleSpin", 10)
local ChairGachaRemote = Remotes and Remotes:WaitForChild("ChairGacha", 10)

-- ===================== SPECTREUI WINDOW INITIALIZATION =====================
local Window = Library:CreateWindow({
	Title      = "SpectreWare | Thai Word Chain",
	Logo       = 84699118856259,
	ToggleKey  = Enum.KeyCode.RightShift,
	Theme      = "Spectre",
	StagedLoad = false,
	AutoCheck  = {
		Skip = { TextClip = true },
	},
	Splash     = {
		Title     = "SpectreWare",
		Subtitle  = "THAI WORD CHAIN",
		Duration  = 2.0,
		Steps     = { "Checking match remotes", "Loading Thai dictionary", "Preparing auto answer", "Ready!" },
		Logo      = 84699118856259,
		Skippable = true,
	},
})

if not Window then
	return warn("[SpectreWare] Failed to initialize SpectreUI Window.")
end

-- ===================== NOTIFICATION SHIM =====================
local function notify(title, content, dur)
	pcall(function()
		if Window and Window.Notify then
			Window:Notify({
				Title    = tostring(title or "SpectreWare"),
				Content  = tostring(content or ""),
				Duration = tonumber(dur) or 3,
			})
		end
	end)
end

-- ===================== UTF-8 STRING UTILITIES =====================
local function utf8Len(s)
	if not s or s == "" then return 0 end
	local ok, len = pcall(utf8.len, s)
	return (ok and len) or #s
end

local function utf8Sub(s, i, j)
	if not s or s == "" then return "" end
	local len = utf8Len(s)
	i = math.max(1, i or 1)
	j = (j and math.min(len, j)) or len
	if i > j then return "" end
	local startByte = utf8.offset(s, i) or 1
	local endByte
	if j < len then
		endByte = (utf8.offset(s, j + 1) or (#s + 1)) - 1
	else
		endByte = #s
	end
	return string.sub(s, startByte, endByte)
end

-- Find in-game WordBox TextBox in PlayerGui
local function getGameWordBox()
	local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local gameUI = pg and pg:FindFirstChild("GameUI")
	local root = gameUI and gameUI:FindFirstChild("Root")
	local matchFrame = root and root:FindFirstChild("Match")
	local inputBar = matchFrame and matchFrame:FindFirstChild("InputBar")
	return inputBar and inputBar:FindFirstChild("WordBox")
end

-- ===================== LOCAL THAI DICTIONARY FALLBACK =====================
local LOCAL_DICTIONARY = {
	["ก"] = { "กบ", "กา", "กาน้ำ", "กิน", "กวาง", "กรง", "กลอง", "กอด", "กะทิ", "กรรไกร", "กุ้ง", "กาก", "กล้วย", "กระดาษ", "กระจก", "กระทง", "ก้อนหิน", "กังหัน", "กัปตัน", "กุหลาบ", "กิ้งก่า", "การ์ตูน", "กังฟู", "กลางวัน", "กระเป๋าเป้", "กุหลาบมอญ", "กลางค่ำกลางคืน" },
	["ข"] = { "ขวด", "ขวาน", "ขา", "ขน", "ขิง", "ขุด", "ขีด", "ขอน", "ขัน", "ข้าว", "ขนม", "ขุน", "ขนมหวาน", "ขวดน้ำ", "ขอนไม้", "ข้าวสาร", "ขาหมู", "ขลุ่ย", "ขนมปัง", "ข้าวเหนียว", "ข้าวผัด", "ขนมครก", "ขาโต๊ะ", "ของขวัญวันเกิด", "ขบวนการกู้ภัย" },
	["ค"] = { "คน", "คาง", "ค้อน", "ควาย", "ควัน", "คำ", "ครก", "ครู", "คลอง", "คุก", "คนสวย", "คนงาน", "คำศัพท์", "ควายธนู", "คางคก", "คุกกี้", "คริสตัล", "ความสุข", "ความดี", "ควันไฟ", "ความรักแท้", "ครอบครัวอบอุ่น", "ค้อนปอนด์ใหญ่", "คอมพิวเตอร์", "คณิตศาสตร์" },
	["ฆ"] = { "ฆ้อง", "ฆ่า", "ฆราวาส", "ฆาตกรรม", "ฆาตกรต่อเนื่อง" },
	["ง"] = { "งู", "งา", "งวง", "งาน", "ง่วง", "งม", "งาดำ", "งาช้าง", "งูเห่า", "งานวัด", "งูเขียว", "งานเลี้ยง", "งานบุญ", "งดงาม", "งมงาย", "งวงช้างศึก", "งูจงอางยักษ์" },
	["จ"] = { "จาน", "จรวด", "จด", "จริง", "จูบ", "จมูก", "จอก", "จัง", "จอม", "จระเข้", "จดหมาย", "จิ้งจก", "จิ้งหรีด", "จอกแหน", "จิตรกร", "จังหัน", "จอมปลวก", "จานข้าวสวย", "จักรยานเสือภูเขา", "จันทร์เสี้ยวทอง" },
	["ฉ"] = { "ฉิ่ง", "ฉลาด", "ฉนวน", "ฉลาม", "ฉลอง", "ฉีก", "ฉัตร", "ฉมวก", "ฉายา", "ฉลามขาว", "ฉัตรทอง", "ฉลองชัย", "ฉลากกินแบ่ง", "ฉนวนกันความร้อน", "ฉลาดหลักแหลม" },
	["ช"] = { "ช้าง", "ช้อน", "ชาม", "ชวน", "ชา", "ชะนี", "ชิง", "ชิม", "ชบา", "ชาเขียว", "ชาเย็น", "ชาวนา", "ชิงช้า", "ชุมชน", "ชอล์ก", "ช่างไม้", "ชีสเค้ก", "ชานชาลา", "ช้างเอเชีย", "ช้อนส้อมเงิน" },
	["ซ"] = { "ซุป", "ซอส", "ซ่อม", "ซอย", "ซ่อน", "ซาก", "ซึม", "ซอง", "ซี่", "ซุ่ม", "ซากศพ", "ซอยตัน", "ซากุระ", "ซีอิ๊วขาว", "ซาลาเปา", "ซุ้มประตู", "ซุปเปอร์มาร์เก็ต", "ซองจดหมายขาว", "ซ่อมแซมบ้าน" },
	["ญ"] = { "ญวน", "ญาติ", "ญี่ปุ่น", "ญาติมิตร", "ญาติสนิท", "ญาติผู้ใหญ่" },
	["ฎ"] = { "ฎีกา" },
	["ฐ"] = { "ฐาน", "ฐิติ", "ฐานทัพ", "ฐานข้อมูล", "ฐานเศรษฐกิจ" },
	["ฑ"] = { "ฑัณฑสถาน", "ฑัณฑฆาต" },
	["ณ"] = { "ณัฐ", "ณรงค์", "ณัชชา" },
	["ด"] = { "ดาบ", "ดิน", "ดาว", "ดวง", "ดอก", "ดัก", "ดม", "ดี", "ด่าง", "ดอย", "ดาวเทียม", "ดนตรีไทย", "ดวงอาทิตย์", "ดวงจันทร์", "ดวงดาว", "ดักแด้", "ดอกมะลิ", "ดินน้ำมัน", "ดอกกุหลาบแดง", "ดาบซามูไรคม", "ดินสอไม้ดำ", "ดาวพลูโตน้อย" },
	["ต"] = { "ตา", "ตู้", "ต้น", "ตับ", "ตัก", "ตาก", "ตัว", "ตะปู", "ตะกร้า", "ตาล", "ตุ่ม", "ตำรวจ", "ตุ๊กตา", "ตะเกียง", "ตะหลิว", "ตัวต่อ", "ต้นตาล", "ตลาดนัด", "ต้นไม้ใหญ่", "ตะกร้าหวายสาน", "ตู้เย็นสองประตู" },
	["ถ"] = { "ถัง", "ถุง", "ถ้วย", "ถ้ำ", "ถนน", "ถั่ว", "ถาด", "ถ่าน", "ถาก", "ถาม", "ถังขยะ", "ถ้ำหลวง", "ถ้วยกาแฟ", "ถั่วเขียว", "ถ่านหิน", "ถุงมือ", "ถังน้ำ", "ถุงเท้าสั้น", "ถนนหลวงสายเอเชีย", "ถุงพลาสติกใส" },
	["ท"] = { "ทอง", "ทราย", "ทุ่ง", "ทาง", "ท่อ", "ทับ", "ทอด", "ทาย", "ท่า", "ทาส", "ทหารเรือ", "ทองคำขาว", "ทางด่วน", "ทางม้าลาย", "ทอดกรอบ", "ทัพพี", "ท่องเที่ยว", "ทะเลทรายซาฮารา", "ทุเรียนหมอนทอง", "ทุ่งหญ้าสะวันนา" },
	["ธ"] = { "ธนู", "ธง", "ธาร", "ธุระ", "ธานี", "ธาตุ", "ธรรม", "ธนบัตร", "ธนาคาร", "ธรรมชาติ", "ธงชาติไทย", "ธรรมะสอนใจ", "ธาตุแท้", "ธนาคารพาณิชย์", "ธรรมชาติสิ่งแวดล้อม" },
	["น"] = { "นก", "น้ำ", "นา", "นิ้ว", "น้อง", "น้อย", "นอน", "นิ่ม", "นวล", "นกยูง", "น้ำผึ้ง", "น้อยหน่า", "น้ำตก", "นกอินทรี", "นางเงือก", "นิ้วมือ", "นักเรียน", "นกพิราบขาว", "นาฬิกาข้อมือ", "น้ำแข็งหลอด", "นักเรียนมัธยม" },
	["บ"] = { "บ้าน", "บัว", "บึง", "บอล", "บก", "บิน", "บวบ", "บาด", "บาง", "บุญ", "บันไดลิง", "บอลลูน", "บึงบัว", "บัวหลวง", "บะหมี่เกี๊ยว", "บริวาร", "บุหงา", "บาดาล", "บันเทิง", "บ้านไม้สักทอง", "บอลลูนลมร้อน" },
	["ป"] = { "ปลา", "ปู", "ปืน", "ปาก", "ป่า", "ปีก", "ปี", "ปลาดุก", "ปูม้า", "ป่าไม้", "ปลาทู", "ปลาทอง", "ปราสาทหิน", "ปืนใหญ่", "ปากกา", "ปราบปราม", "ประตูไม้สักหรู", "ป่าดงดิบชื้น", "ปลาวาฬสีน้ำเงิน" },
	["ผ"] = { "ผึ้ง", "ผ้า", "ผัก", "ผม", "ผี", "ผอม", "ผ้าไหม", "ผัดไทย", "ผ้าห่มนวม", "ผลไม้รวม", "ผักบุ้งจีน", "ผู้ใหญ่บ้าน", "ผึ้งหลวง", "ผ้าเช็ดหน้า", "ผีเสื้อกลางคืน", "ผ้าห่มกันหนาว" },
	["ฝ"] = { "ฝน", "ฝา", "ฝั่ง", "ฝ้าย", "ฝูง", "ฝุ่น", "ฝึก", "ฝาครอบ", "ฝาชี", "ฝรั่งกิมจู", "ฝากเงิน", "ฝูงบิน", "ฝุ่นละออง", "ฝักบัว", "ฝนตกหนักมาก", "ฝากเงินธนาคาร" },
	["พ"] = { "พัด", "พาน", "พ่อ", "พี่", "พวง", "พระ", "พริก", "พู่", "พายุ", "พู่กัน", "พัดลม", "พายเรือ", "พ่อค้า", "พริกไทยดำ", "พระอาทิตย์", "พระจันทร์", "พยาบาล", "พวงมาลัยดอกไม้", "พายุหมุนทอร์นาโด" },
	["ฟ"] = { "ฟัน", "ฟ้า", "ฟาง", "ฟอง", "ฟัก", "ฟุต", "ฟูก", "ฟรี", "ฟาร์ม", "ฟิล์ม", "ฟุตบอล", "ฟันดาบ", "ฟ้าผ่า", "ฟองสบู่", "ฟักทอง", "ฟางข้าว", "ฟิล์มกระจก", "ฟุตบอลพรีเมียร์ลีก", "ฟ้าแลบฟ้าร้อง" },
	["ภ"] = { "ภู", "ภาพ", "ภาค", "ภาษา", "ภูเขา", "ภูเก็ต", "ภารกิจกู้ชีพ", "ภาพยนตร์", "ภัตตาคารหรู", "ภูเขาไฟ", "ภูเขาสูงชัน", "ภาษาไทยโบราณ", "ภาพวาดสีน้ำมัน" },
	["ม"] = { "มด", "ม้า", "มีด", "มือ", "มวย", "มาก", "มัว", "มอง", "มุก", "มดแดง", "ม้าน้ำ", "มะนาว", "มะม่วง", "มือถือ", "มดตะนอย", "มังกรทอง", "มีดปังตอ", "มหาสมุทร", "มงกุฎ", "มนุษย์", "มวยไทย", "มะละกอ", "มะพร้าวน้ำหอม", "ม้าลายแอฟริกา", "มะม่วงน้ำดอกไม้", "มะเขือเทศสด" },
	["ย"] = { "ยา", "ยุง", "ยาน", "ยาง", "ยม", "ยาม", "ยาดม", "ยมทูต", "ยักษ์", "ยิ้มแย้ม", "ยิมนาสติก", "ยาสระผม", "ยาสีฟัน", "ยอดมนุษย์", "ยักษ์ตาเดียว", "ยางลบดินสอ", "ยานอวกาศนาซา", "ยาแก้แพ้อากาศ", "ยุงก้นปล่องร้าย" },
	["ร"] = { "รถ", "ร่ม", "รัก", "รัง", "รุ้ง", "ราก", "รวง", "รถไฟ", "รังนก", "รากไม้", "รถยนต์", "ร่มกันฝน", "ระฆังทอง", "รังผึ้ง", "รองเท้าผ้าใบ", "รุ้งกินน้ำ", "รถยนต์ไฟฟ้า", "รถไฟความเร็วสูง" },
	["ล"] = { "ลิง", "ล้อ", "ลาน", "ลม", "ลูก", "ลำ", "ลอง", "ลอย", "ลึก", "ล้อรถ", "ลังไม้", "ลิงกัง", "ลูกโป่ง", "ลำธาร", "ลิ้นชักไม้", "ลานกว้าง", "ลูกชิ้น", "ละครสัตว์", "ลูกโป่งสวรรค์", "ลำธารธรรมชาติ", "ลูกอมสมุนไพร" },
	["ว"] = { "วัว", "วัน", "วัด", "วิ่ง", "ว่าว", "วาฬ", "วง", "วาด", "วันเกิด", "วัดพระแก้ว", "ว่าวจุฬา", "วิศวกร", "วงเวียน", "วาฬเพชฌฆาต", "วัวกระทิงเปลี่ยว", "วิ่งมาราธอน" },
	["ศ"] = { "ศาล", "ศพ", "ศึก", "ศอก", "ศีล", "ศาลา", "ศัตรู", "ศีรษะ", "ศาลเจ้า", "ศิลาจารึก", "ศาลาวัด", "ศาลาริมน้ำ", "ศิลปวัฒนธรรม", "ศาลเจ้าพ่อเสือ" },
	["ษ"] = { "ษัษฐี" },
	["ส"] = { "ส้ม", "สาย", "สาว", "สอง", "สวย", "สาด", "สุนัข", "สมุด", "ส้มโอ", "ส้มตำ", "สีคราม", "สะพาน", "สิงโต", "สับปะรด", "สวรรค์", "สายน้ำ", "สุนัขตำรวจ", "สะพานพระรามเก้า", "สมุดบันทึกเล่มหนา", "สิงโตเจ้าป่า", "สร้อยคอทองคำ" },
	["ห"] = { "หมา", "หมู", "หนู", "หมี", "หอย", "หญ้า", "หาง", "หู", "ห้อง", "หัว", "หน้า", "หมาป่า", "หมวกกันน็อก", "หน้าต่างไม้", "หนูบ้าน", "หนังยาง", "หญ้าหวาน", "หอยนางรมสด", "ห้องนอนใหญ่", "หมีแพนด้าน่ารัก", "หมูสามชั้นกรอบ", "หัวใจมนุษย์" },
	["อ"] = { "อก", "อ่าง", "อูฐ", "อิ่ม", "ออก", "ออม", "อ้อย", "อาย", "อวกาศ", "อึ่งอ่าง", "องุ่น", "อาหาร", "อากาศ", "อ้อมกอด", "องุ่นไร้เมล็ด", "อ่างอาบน้ำอุ่น", "อาคารพาณิชย์", "อาหารตามสั่ง", "อากาศบริสุทธิ์", "อัญมณีล้ำค่า" },
	["ฮ"] = { "ฮับ", "ฮัก", "ฮ่องกง", "ฮอร์โมน", "ฮาเซลนัท", "ฮุนได", "ฮิปโปโปเตมัส", "ฮัมมิ่งเบิร์ด" },
	["เ"] = { "เกาะ", "เงิน", "เงา", "เฉา", "เด็ก", "เต่า", "เตา", "เนย", "เป็ด", "เพลง", "เรือ", "เสือ", "เมฆ", "เวที", "เก้าอี้", "เข็มทิศ", "เขื่อนดิน", "เครื่องบิน", "เงินทอง", "เฉาก๊วย", "เชือกไนลอน", "เซียนพนัน", "เทียนพรรษา", "เทวดา", "เนยแข็ง", "เพชรน้ำหนึ่ง", "เรือรบหลวง", "เสือโคร่ง", "เบคอน", "เลมอน", "เว็บไซต์", "เงาะโรงเรียน", "เงียบสงบสงัด", "เฮลิคอปเตอร์กู้ภัย", "เมืองหลวงพระบาง" },
	["แ"] = { "แก้ว", "แกง", "แขน", "แจ", "แตง", "แพ", "แมว", "แสง", "แหวน", "แว่น", "แขนง", "แก้วน้ำ", "แจกันหรู", "แซลมอน", "แตงโม", "แปรงสีฟัน", "แผ่นดินไหว", "แผงผัง", "แว่นตากันแดด", "แอปเปิ้ล", "แพนด้า", "แชมพู", "แหวนทอง", "แบตเตอรี่", "แมวลายสลิดน่ารัก", "แสงแดดอบอุ่น" },
	["โ"] = { "โต๊ะ", "โคม", "โจ๊ก", "โอ่ง", "โบว์", "โรง", "โลมา", "โจร", "โฉนดที่ดิน", "โต๊ะทำงาน", "โทรทัศน์", "โบสถ์คริสต์", "โรงเรียน", "โลมาสีชมพู", "โคมไฟ", "โจ๊กหมู", "โอ่งมังกร", "โมเดล", "โคกระบือ", "โทรศัพท์มือถือ", "โรงเรียนนานาชาติ" },
	["ใ"] = { "ใจ", "ใบ", "ใต้", "ใส", "ใน", "ใจดี", "ใบตอง", "ใบไม้", "ใยบัว", "ใต้ดิน", "ใบขับขี่", "ใยแมงมุม", "ใส่ใจ", "ใบหน้า", "ใจกว้างขวาง", "ใบเสร็จรับเงิน" },
	["ไ"] = { "ไม้", "ไข่", "ไก่", "ไฟ", "ไผ่", "ไถ", "ไห", "ไถนา", "ไผ่ตง", "ไหว้ครู", "ไม้เท้า", "ไข่ไก่", "ไก่ย่าง", "ไฟฉาย", "ไม้บรรทัด", "ไพเราะ", "ไมโครโฟน", "ไส้กรอก", "ไกด์นำเที่ยว", "ไมโครเวฟดิจิทัล", "ไอศกรีมวานิลลา" },
}

-- ===================== STATE & FLAGS =====================
local state = {
	inMatch      = false,
	myTurn       = false,
	turnId       = nil,
	turnName     = "",
	prefix       = "",
	minLen       = 0,
	timeAllowed  = 15,
	deadline     = 0,
	hearts       = 2,
	lastWord     = "",
	usedWords    = {},
	wordCache    = {},
	serverCache  = {},
	activeTurnId = 0,
}

-- Combining vowels & tone marks in Thai (typed faster after consonant)
local COMBINING_MARKS = {
	["ั"] = true, ["ิ"] = true, ["ี"] = true, ["ึ"] = true,
	["ื"] = true, ["ุ"] = true, ["ู"] = true, ["็"] = true,
	["่"] = true, ["้"] = true, ["๊"] = true, ["๋"] = true,
	["์"] = true,
}

local function startsWith(str, prefix)
	if not str or not prefix or prefix == "" then return false end
	return string.sub(str, 1, #prefix) == prefix
end

local function shouldStripPrefixFromBox(wordBox, prefix)
	if not wordBox or not prefix or prefix == "" then return false end
	local parent = wordBox.Parent
	local prefixLabel = parent and parent:FindFirstChild("PrefixLabel")
	if prefixLabel and prefixLabel:IsA("TextLabel") and prefixLabel.Visible and prefixLabel.Text == prefix then
		return true
	end
	return false
end

local flags = {
	AutoAnswer        = true,
	TypingMode        = "Smooth Natural (Variable Speed)", -- "Realistic Human (Character-by-character)", "Smooth Natural (Variable Speed)", "Fast / Competitive", "Instant (Fastest)"
	Strategy          = "คำสั้น (Short: 2 - 4 ตัวอักษร)", -- "คำสั้น (Short: 2 - 4 ตัวอักษร)", "คำกลาง (Medium: 5 - 7 ตัวอักษร)", "คำยาว (Long: 8+ ตัวอักษร)", "คำที่ใช้บ่อย (Common Words First)", "สุ่มคำทั่วไป (Random Valid)"
	MaxWordLength     = 0,                                -- Max character limit (0 = unlimited, e.g. 4 for strict short words)
	ReactionDelay     = 0.8,                              -- Thinking delay in seconds
	TypingSpeed       = 8,                                -- Chars per second
	SubmitDelay       = 0.35,                             -- Delay after typing before hitting submit
	SyncWordBox       = true,                             -- Visually types in the in-game WordBox
	AutoRetry         = true,                             -- If server rejects, try next word
	ShowSuggestionHUD = true,
	AutoSit           = false,
	AutoPickMode      = true,
	PreferredMode     = "Easy Mode (1-2 letters)",
	AutoClaimDaily    = true,
	AutoClaimGroup    = true,
	AutoClaimQuests   = true,
	WalkSpeedEnabled  = false,
	WalkSpeedValue    = 16,
	JumpPowerEnabled  = false,
	JumpPowerValue    = 50,
	InfJump           = false,
	Fullbright        = false,
	AntiAFK           = true,
}

-- Seed local dictionary into wordCache
for prefix, words in pairs(LOCAL_DICTIONARY) do
	state.wordCache[prefix] = {}
	for _, w in ipairs(words) do
		table.insert(state.wordCache[prefix], w)
	end
end

-- ===================== DICTIONARY LOOKUP ENGINE =====================
local function queryDictionaryServer(prefix)
	if not DictLookup then return {}, {} end
	local ok, res = pcall(function()
		return DictLookup:InvokeServer(prefix, 1)
	end)
	if ok and res and res.ok and type(res.words) == "table" then
		state.serverCache[prefix] = state.serverCache[prefix] or {}
		local set = {}
		for _, w in ipairs(state.serverCache[prefix]) do set[w] = true end
		for _, w in ipairs(res.words) do
			if startsWith(w, prefix) and not set[w] then
				table.insert(state.serverCache[prefix], w)
				set[w] = true
			end
		end
		return state.serverCache[prefix], res.common or {}
	end
	return state.serverCache[prefix] or {}, {}
end

local function getWordsForPrefix(prefix)
	prefix = tostring(prefix or ""):gsub("%s+", "")
	if prefix == "" then return {}, {} end

	-- 1. Query official game dictionary server if available
	local serverWords, common = queryDictionaryServer(prefix)
	if #serverWords > 0 then
		local filtered = {}
		for _, w in ipairs(serverWords) do
			if startsWith(w, prefix) then
				table.insert(filtered, w)
			end
		end
		if #filtered > 0 then
			return filtered, common or {}
		end
	end

	-- 2. Cached server words
	if state.serverCache[prefix] and #state.serverCache[prefix] > 0 then
		local filtered = {}
		for _, w in ipairs(state.serverCache[prefix]) do
			if startsWith(w, prefix) then
				table.insert(filtered, w)
			end
		end
		if #filtered > 0 then
			return filtered, {}
		end
	end

	-- 3. Exact match in local dictionary
	if LOCAL_DICTIONARY[prefix] then
		local filtered = {}
		for _, w in ipairs(LOCAL_DICTIONARY[prefix]) do
			if startsWith(w, prefix) then
				table.insert(filtered, w)
			end
		end
		if #filtered > 0 then
			return filtered, {}
		end
	end

	-- 4. Multi-char prefix: search under first character in local dictionary
	local firstChar = utf8Sub(prefix, 1, 1)
	if LOCAL_DICTIONARY[firstChar] then
		local filtered = {}
		for _, w in ipairs(LOCAL_DICTIONARY[firstChar]) do
			if startsWith(w, prefix) then
				table.insert(filtered, w)
			end
		end
		if #filtered > 0 then
			return filtered, {}
		end
	end

	-- 5. Broad scan across all dictionary entries
	local broad = {}
	for _, wordList in pairs(LOCAL_DICTIONARY) do
		for _, w in ipairs(wordList) do
			if startsWith(w, prefix) then
				table.insert(broad, w)
			end
		end
	end
	if #broad > 0 then
		return broad, {}
	end

	return {}, {}
end

-- ===================== AUTO ANSWER CORE LOGIC =====================
local answerThread = nil

local function filterWords(wordList, minLen, prefix)
	local valid = {}
	for _, word in ipairs(wordList) do
		if not state.usedWords[word] and utf8Len(word) >= (minLen or 0) then
			if not prefix or prefix == "" or startsWith(word, prefix) then
				table.insert(valid, word)
			end
		end
	end
	return valid
end

local function selectWord(validWords, commonMap, strategy, maxLenLimit)
	if #validWords == 0 then return nil end

	-- 1. Clamp with Max Word Length if specified by user (> 0)
	if maxLenLimit and maxLenLimit > 0 then
		local clamped = {}
		for _, w in ipairs(validWords) do
			if utf8Len(w) <= maxLenLimit then
				table.insert(clamped, w)
			end
		end
		if #clamped > 0 then
			validWords = clamped
		end
	end

	-- 2. Strategy: คำสั้น (Short Words: 2 - 4 characters)
	if strategy == "คำสั้น (Short: 2 - 4 ตัวอักษร)" or strategy == "Shortest Word" then
		local shortWords = {}
		for _, w in ipairs(validWords) do
			if utf8Len(w) <= 4 then
				table.insert(shortWords, w)
			end
		end
		if #shortWords > 0 then
			return shortWords[math.random(1, #shortWords)]
		end

		-- Fallback if no words <= 4 (e.g. rare letter or high minLen on table)
		table.sort(validWords, function(a, b) return utf8Len(a) < utf8Len(b) end)
		local minL = utf8Len(validWords[1])
		local pool = {}
		for _, w in ipairs(validWords) do
			if utf8Len(w) <= minL + 1 then
				table.insert(pool, w)
			else
				break
			end
		end
		return pool[math.random(1, #pool)]

	-- 3. Strategy: คำกลาง (Medium Words: 5 - 7 characters)
	elseif strategy == "คำกลาง (Medium: 5 - 7 ตัวอักษร)" or strategy == "Medium Word" then
		local medWords = {}
		for _, w in ipairs(validWords) do
			local l = utf8Len(w)
			if l >= 5 and l <= 7 then
				table.insert(medWords, w)
			end
		end
		if #medWords > 0 then
			return medWords[math.random(1, #medWords)]
		end

		-- Fallback: words closest to length 5-7
		table.sort(validWords, function(a, b)
			local distA = math.min(math.abs(utf8Len(a) - 5), math.abs(utf8Len(a) - 7))
			local distB = math.min(math.abs(utf8Len(b) - 5), math.abs(utf8Len(b) - 7))
			return distA < distB
		end)
		return validWords[1]

	-- 4. Strategy: คำยาว (Long Words: 8+ characters)
	elseif strategy == "คำยาว (Long: 8+ ตัวอักษร)" or strategy == "Longest Word" then
		local longWords = {}
		for _, w in ipairs(validWords) do
			if utf8Len(w) >= 8 then
				table.insert(longWords, w)
			end
		end
		if #longWords > 0 then
			table.sort(longWords, function(a, b) return utf8Len(a) > utf8Len(b) end)
			local maxL = utf8Len(longWords[1])
			local topPool = {}
			for _, w in ipairs(longWords) do
				if utf8Len(w) >= maxL - 2 then
					table.insert(topPool, w)
				end
			end
			return topPool[math.random(1, #topPool)]
		end

		-- Fallback: longest available
		table.sort(validWords, function(a, b) return utf8Len(a) > utf8Len(b) end)
		return validWords[1]

	-- 5. Strategy: คำที่ใช้บ่อย (Common Words First)
	elseif strategy == "คำที่ใช้บ่อย (Common Words First)" or strategy == "Common Words First" then
		local commons = {}
		for _, w in ipairs(validWords) do
			if commonMap and commonMap[w] then
				table.insert(commons, w)
			end
		end
		if #commons > 0 then
			return commons[math.random(1, #commons)]
		end
		return validWords[math.random(1, #validWords)]

	-- 6. Strategy: สุ่มคำทั่วไป (Random Valid)
	else
		return validWords[math.random(1, #validWords)]
	end
end

local function submitWord(word)
	if not word or word == "" then return false end
	if not SubmitRemote then return false end

	state.usedWords[word] = true
	pcall(function()
		SubmitRemote:FireServer(word)
	end)
	return true
end

local function executeAutoAnswer(prefix, minLen, timeAllowed, turnToken)
	if not state.myTurn or not isCurrentGen() then return end

	-- 1. Thinking / Reaction Delay
	local reaction = math.max(0.1, flags.ReactionDelay or 0.8)
	-- Add natural human jitter (±20%)
	reaction = reaction * (0.8 + math.random() * 0.4)
	task.wait(reaction)

	if not state.myTurn or state.activeTurnId ~= turnToken or not isCurrentGen() then return end

	-- 2. Retrieve Candidate Words (strictly matching prefix)
	local words, commonMap = getWordsForPrefix(prefix)
	local validWords = filterWords(words, minLen, prefix)

	if #validWords == 0 then
		local svWords, svCommon = queryDictionaryServer(prefix)
		validWords = filterWords(svWords, minLen, prefix)
		commonMap = svCommon
	end

	if #validWords == 0 then
		notify("Auto Answer", "ไม่พบคำศัพท์ที่ขึ้นต้นด้วย: " .. prefix, 3)
		return
	end

	local chosenWord = selectWord(validWords, commonMap, flags.Strategy, flags.MaxWordLength)
	if not chosenWord then return end

	-- Mark as used immediately so retries won't re-select it
	state.usedWords[chosenWord] = true

	local wordBox = flags.SyncWordBox and getGameWordBox() or nil
	local stripPrefix = shouldStripPrefixFromBox(wordBox, prefix) and startsWith(chosenWord, prefix)

	-- If PrefixLabel is displayed in game UI, type only suffix into WordBox so [PrefixLabel: ม][WordBox: ้า] -> "ม้า"
	local textToType = chosenWord
	if stripPrefix then
		local pLen = utf8Len(prefix)
		local wLen = utf8Len(chosenWord)
		textToType = utf8Sub(chosenWord, pLen + 1, wLen)
	end

	-- 3. Typing Simulation
	local mode = flags.TypingMode
	if mode == "Instant (Fastest)" then
		if wordBox then
			pcall(function() wordBox.Text = textToType end)
		end
		pcall(function()
			if TypingRemote then TypingRemote:FireServer(chosenWord) end
		end)
	else
		local charCount = utf8Len(textToType)
		local speed = math.max(2, flags.TypingSpeed or 8)
		local baseDelay = 1 / speed

		-- Clear box before starting if it has stale content
		if wordBox and wordBox.Text ~= "" then
			pcall(function() wordBox.Text = "" end)
		end

		for i = 1, charCount do
			if not state.myTurn or state.activeTurnId ~= turnToken or not isCurrentGen() then return end

			local partialText = utf8Sub(textToType, 1, i)
			local char = utf8Sub(textToType, i, i)

			-- Visually update in-game WordBox (triggers game sound & local tile rendering cleanly)
			if wordBox then
				pcall(function() wordBox.Text = partialText end)
			end

			-- Broadcast full word so far over TypingRemote
			local fullWordSoFar = stripPrefix and (prefix .. partialText) or partialText
			pcall(function()
				if TypingRemote then TypingRemote:FireServer(fullWordSoFar) end
			end)

			-- Realistic typing rhythm per character type
			local charDelay = baseDelay
			if COMBINING_MARKS[char] then
				-- Combining vowel / tone mark is typed rapidly after consonant
				charDelay = charDelay * 0.4
			elseif mode == "Smooth Natural (Variable Speed)" then
				charDelay = baseDelay * (0.8 + math.random() * 0.4)
				-- 10% chance of a micro hesitation
				if math.random() < 0.10 then
					charDelay = charDelay + (math.random(8, 18) / 100)
				end
			elseif mode == "Fast / Competitive" then
				charDelay = math.min(0.04, baseDelay * 0.5)
			else -- "Realistic Human (Character-by-character)"
				charDelay = baseDelay * (0.9 + math.random() * 0.2)
			end

			task.wait(math.max(0.02, charDelay))
		end

		-- 4. Post-Typing Pause (simulating human pause before hitting Enter)
		local postDelay = math.max(0.05, flags.SubmitDelay or 0.3)
		task.wait(postDelay)
	end

	if not state.myTurn or state.activeTurnId ~= turnToken or not isCurrentGen() then return end

	-- 5. Submit Word
	submitWord(chosenWord)
	if wordBox then
		pcall(function() wordBox:ReleaseFocus(true) end)
	end
	notify("Auto Answer", string.format("ส่งคำตอบ: %s (โจทย์: %s)", chosenWord, prefix), 2)
end

-- ===================== LIVE SUGGESTION HUD =====================
local suggestionGui = nil
local suggestionContainer = nil

local function updateSuggestionHUD(prefix, minLen)
	if not flags.ShowSuggestionHUD then
		if suggestionGui then suggestionGui.Enabled = false end
		return
	end

	if not suggestionGui then
		local parent = nil
		pcall(function() if gethui then parent = gethui() end end)
		parent = parent or game:GetService("CoreGui") or (LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui"))
		if not parent then return end

		suggestionGui = Instance.new("ScreenGui")
		suggestionGui.Name = "Spectre_WordSuggestions"
		suggestionGui.ResetOnSpawn = false
		suggestionGui.DisplayOrder = 99999
		suggestionGui.Parent = parent

		local frame = Instance.new("Frame")
		frame.Name = "Card"
		frame.Size = UDim2.new(0, 480, 0, 80)
		frame.Position = UDim2.new(0.5, -240, 0.82, 0)
		frame.BackgroundColor3 = Color3.fromRGB(14, 19, 30)
		frame.BorderSizePixel = 0
		frame.Parent = suggestionGui

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 12)
		corner.Parent = frame

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(56, 189, 248)
		stroke.Thickness = 1.8
		stroke.Parent = frame

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -20, 0, 22)
		title.Position = UDim2.new(0, 10, 0, 4)
		title.BackgroundTransparency = 1
		title.Font = Enum.Font.GothamBold
		title.TextSize = 13
		title.TextColor3 = Color3.fromRGB(186, 230, 253)
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Text = "💡 คำศัพท์แนะนำ (กดเพื่อตอบทันที):"
		title.Parent = frame

		suggestionContainer = Instance.new("ScrollingFrame")
		suggestionContainer.Size = UDim2.new(1, -16, 0, 44)
		suggestionContainer.Position = UDim2.new(0, 8, 0, 28)
		suggestionContainer.BackgroundTransparency = 1
		suggestionContainer.BorderSizePixel = 0
		suggestionContainer.ScrollBarThickness = 3
		suggestionContainer.ScrollingDirection = Enum.ScrollingDirection.X
		suggestionContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
		suggestionContainer.Parent = frame

		local listLayout = Instance.new("UIListLayout")
		listLayout.FillDirection = Enum.FillDirection.Horizontal
		listLayout.Padding = UDim.new(0, 6)
		listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		listLayout.Parent = suggestionContainer
	end

	suggestionGui.Enabled = state.myTurn
	if not state.myTurn then return end

	for _, child in ipairs(suggestionContainer:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	local rawWords = getWordsForPrefix(prefix)
	local words = filterWords(rawWords, minLen, prefix)

	-- Sort suggestion list according to active strategy so player sees preferred word lengths first
	if flags.Strategy == "คำสั้น (Short: 2 - 4 ตัวอักษร)" or flags.Strategy == "Shortest Word" then
		table.sort(words, function(a, b) return utf8Len(a) < utf8Len(b) end)
	elseif flags.Strategy == "คำยาว (Long: 8+ ตัวอักษร)" or flags.Strategy == "Longest Word" then
		table.sort(words, function(a, b) return utf8Len(a) > utf8Len(b) end)
	elseif flags.Strategy == "คำกลาง (Medium: 5 - 7 ตัวอักษร)" or flags.Strategy == "Medium Word" then
		table.sort(words, function(a, b)
			local distA = math.min(math.abs(utf8Len(a) - 5), math.abs(utf8Len(a) - 7))
			local distB = math.min(math.abs(utf8Len(b) - 5), math.abs(utf8Len(b) - 7))
			return distA < distB
		end)
	end

	for i = 1, math.min(10, #words) do
		local word = words[i]
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 0, 0, 34)
		btn.AutomaticSize = Enum.AutomaticSize.X
		btn.BackgroundColor3 = Color3.fromRGB(24, 34, 52)
		btn.Text = "  " .. word .. "  "
		btn.Font = Enum.Font.GothamMedium
		btn.TextSize = 14
		btn.TextColor3 = Color3.fromRGB(240, 246, 255)
		btn.Parent = suggestionContainer

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = btn

		local btnStroke = Instance.new("UIStroke")
		btnStroke.Color = Color3.fromRGB(56, 189, 248)
		btnStroke.Thickness = 1
		btnStroke.Parent = btn

		btn.MouseButton1Click:Connect(function()
			local wordBox = flags.SyncWordBox and getGameWordBox() or nil
			if wordBox then
				if shouldStripPrefixFromBox(wordBox, state.prefix) and startsWith(word, state.prefix) then
					local pLen = utf8Len(state.prefix)
					local wLen = utf8Len(word)
					pcall(function() wordBox.Text = utf8Sub(word, pLen + 1, wLen) end)
				else
					pcall(function() wordBox.Text = word end)
				end
			end
			submitWord(word)
			notify("Manual Submit", "ส่งคำตอบ: " .. word, 2)
		end)
	end
end

-- ===================== MATCH EVENT HOOKS =====================
if MatchRemote then
	MatchRemote.OnClientEvent:Connect(function(data)
		if type(data) ~= "table" or not data.t or not isCurrentGen() then return end
		local t = data.t

		if t == "start" then
			state.inMatch   = true
			state.myTurn    = false
			state.usedWords = {}
			state.hearts    = data.hearts or 2
			notify("Match", "เริ่มเกมการแข่งต่อคำแล้ว!", 2)

		elseif t == "turn" then
			state.turnId      = data.userId
			state.turnName    = data.name or ""
			state.prefix      = data.prefix or ""
			state.minLen      = data.minLen or 0
			state.timeAllowed = data.time or 15
			state.deadline    = os.clock() + state.timeAllowed
			state.myTurn      = (data.userId == LocalPlayer.UserId)
			state.activeTurnId = state.activeTurnId + 1

			local turnToken = state.activeTurnId
			updateSuggestionHUD(state.prefix, state.minLen)

			if state.myTurn then
				if flags.AutoAnswer then
					if answerThread then pcall(task.cancel, answerThread) end
					answerThread = task.spawn(executeAutoAnswer, state.prefix, state.minLen, state.timeAllowed, turnToken)
				end
			end

		elseif t == "correct" then
			if data.word then
				state.usedWords[data.word] = true
				state.lastWord = data.word
			end
			if data.userId == LocalPlayer.UserId then
				state.myTurn = false
				updateSuggestionHUD("", 0)
			end

		elseif t == "wrong" then
			if data.userId == LocalPlayer.UserId and state.myTurn and flags.AutoAnswer and flags.AutoRetry then
				local turnToken = state.activeTurnId
				task.spawn(function()
					task.wait(0.2)
					executeAutoAnswer(state.prefix, state.minLen, state.timeAllowed, turnToken)
				end)
			end

		elseif t == "end" or t == "left" then
			state.inMatch = false
			state.myTurn  = false
			updateSuggestionHUD("", 0)
			if t == "end" and data.winName then
				notify("Game Over", "ผู้ชนะ: " .. tostring(data.winName), 3)
			end
		end
	end)
end

-- ===================== PROMPT & MODE LISTENER =====================
if ChooseModeRemote then
	task.spawn(function()
		while isCurrentGen() do
			task.wait(0.5)
			if flags.AutoPickMode then
				local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
				local modeGui = pg and pg:FindFirstChild("ModeChoice")
				if modeGui and modeGui.Enabled then
					local chosen = (flags.PreferredMode:find("Hard") and "hard") or "easy"
					pcall(function() ChooseModeRemote:FireServer(chosen) end)
					task.wait(1)
				end
			end
		end
	end)
end

-- ===================== TABLE FINDER & AUTO SIT =====================
local function findAvailableSeat()
	local map = workspace:FindFirstChild("Map")
	if not map then return nil end

	for i = 1, 29 do
		local tableName = "DuelTable" .. tostring(i)
		local tbl = map:FindFirstChild(tableName)
		if tbl then
			for s = 1, 4 do
				local seat = tbl:FindFirstChild("Seat" .. tostring(s))
				if seat and seat:IsA("Seat") and not seat.Occupant then
					return seat, tbl
				end
			end
		end
	end
	return nil
end

local function sitAtSeat(seat)
	if not seat then return false end
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return false end

	pcall(function()
		hrp.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
		task.wait(0.15)
		seat:Sit(hum)
	end)
	return true
end

task.spawn(function()
	while isCurrentGen() do
		task.wait(2)
		if flags.AutoSit and not state.inMatch then
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum and not hum.SeatPart then
				local seat = findAvailableSeat()
				if seat then
					sitAtSeat(seat)
				end
			end
		end
	end
end)

-- ===================== UI TABS & CONTROLS =====================
local MainTab   = Window:CreateTab({ Name = "Auto Answer", Icon = "sparkles" })
local DuelTab   = Window:CreateTab({ Name = "Duel Tables", Icon = "swords" })
local DictTab   = Window:CreateTab({ Name = "Dictionary", Icon = "book-open" })
local RewardTab = Window:CreateTab({ Name = "Rewards", Icon = "gift" })
local PlayerTab = Window:CreateTab({ Name = "Player & Visuals", Icon = "user" })

-- ─────────────────────────────────────────────────────────────
-- TAB 1: AUTO ANSWER
-- ─────────────────────────────────────────────────────────────
local AnswerSec = MainTab:CreateSection({ Name = "⚡ Auto Answer Settings" })

AnswerSec:CreateToggle({
	Name = "Enable Auto Answer",
	Default = flags.AutoAnswer,
	Callback = function(v)
		flags.AutoAnswer = v
		notify("Auto Answer", v and "เปิดใช้งานตอบคำอัตโนมัติ" or "ปิดใช้งานตอบคำอัตโนมัติ", 2)
	end,
})

AnswerSec:CreateDropdown({
	Name = "Typing Style & Animation Mode",
	Options = {
		"Smooth Natural (Variable Speed)",
		"Realistic Human (Character-by-character)",
		"Fast / Competitive",
		"Instant (Fastest)",
	},
	Default = flags.TypingMode,
	Callback = function(v)
		flags.TypingMode = v
	end,
})

AnswerSec:CreateDropdown({
	Name = "Word Strategy / ชนิดความยาวคำ",
	Options = {
		"คำสั้น (Short: 2 - 4 ตัวอักษร)",
		"คำกลาง (Medium: 5 - 7 ตัวอักษร)",
		"คำยาว (Long: 8+ ตัวอักษร)",
		"คำที่ใช้บ่อย (Common Words First)",
		"สุ่มคำทั่วไป (Random Valid)",
	},
	Default = flags.Strategy,
	Tooltip = "เลือกประเภทความยาวคำที่ต้องการให้บอทตอบ (คำสั้น 2-4 ตัว, คำกลาง 5-7 ตัว, คำยาว 8+ ตัว)",
	Callback = function(v)
		flags.Strategy = v
	end,
})

AnswerSec:CreateSlider({
	Name = "Max Word Length / ความยาวคำสูงสุด",
	Min = 0,
	Max = 20,
	Default = flags.MaxWordLength,
	Increment = 1,
	Tooltip = "จำกัดความยาวตัวอักษรสูงสุดของคำตอบ (ตั้ง 0 เพื่อปิดไม่จำกัด เช่น ตั้ง 4 จะไม่มีคำยาวหลุดแน่นอน)",
	Callback = function(v)
		flags.MaxWordLength = v
	end,
})

AnswerSec:CreateSlider({
	Name = "Thinking / Reaction Delay (s)",
	Min = 0.2,
	Max = 3.5,
	Default = flags.ReactionDelay,
	Increment = 0.1,
	Tooltip = "เวลาที่บอทใช้คิดก่อนเริ่มเคาะแป้นพิมพ์",
	Callback = function(v)
		flags.ReactionDelay = v
	end,
})

AnswerSec:CreateSlider({
	Name = "Typing Speed (Chars/sec)",
	Min = 3,
	Max = 25,
	Default = flags.TypingSpeed,
	Increment = 1,
	Tooltip = "ความเร็วในการพิมพ์ตัวอักษรลงกล่องข้อความ",
	Callback = function(v)
		flags.TypingSpeed = v
	end,
})

AnswerSec:CreateSlider({
	Name = "Post-Typing Submit Delay (s)",
	Min = 0.05,
	Max = 1.5,
	Default = flags.SubmitDelay,
	Increment = 0.05,
	Tooltip = "ระยะเวลาหยุดรอหลังจากพิมพ์เสร็จ ก่อนกด Enter ส่งคำตอบ",
	Callback = function(v)
		flags.SubmitDelay = v
	end,
})

AnswerSec:CreateToggle({
	Name = "Sync In-Game Text Box (Visual Typing)",
	Default = flags.SyncWordBox,
	Tooltip = "แสดงตัวหนังสือพิมพ์ลงในกล่องข้อความเกมแบบสดๆ ให้ดูเป็นธรรมชาติ",
	Callback = function(v)
		flags.SyncWordBox = v
	end,
})

AnswerSec:CreateToggle({
	Name = "Auto Retry on Reject",
	Default = flags.AutoRetry,
	Tooltip = "หากคำซ้ำหรือเซิร์ฟเวอร์ปฏิเสธ จะเลือกคำถัดไปส่งทันที",
	Callback = function(v)
		flags.AutoRetry = v
	end,
})

AnswerSec:CreateToggle({
	Name = "Show Clickable Suggestion Bar on Screen",
	Default = flags.ShowSuggestionHUD,
	Tooltip = "แสดงกล่องคำศัพท์แนะนำบนหน้าจอสำหรับกดตอบเอง",
	Callback = function(v)
		flags.ShowSuggestionHUD = v
		if not v and suggestionGui then suggestionGui.Enabled = false end
	end,
})

local ManualSec = MainTab:CreateSection({ Name = "✍️ Manual Word Input" })
local manualWordInput = ""
ManualSec:CreateTextbox({
	Name = "Custom Word",
	Placeholder = "พิมพ์คำภาษาไทยที่ต้องการส่ง...",
	Default = "",
	Callback = function(t)
		manualWordInput = t
	end,
})

ManualSec:CreateButton({
	Name = "Submit Custom Word Now",
	Callback = function()
		if manualWordInput ~= "" then
			local wb = flags.SyncWordBox and getGameWordBox() or nil
			if wb then
				if shouldStripPrefixFromBox(wb, state.prefix) and startsWith(manualWordInput, state.prefix) then
					local pLen = utf8Len(state.prefix)
					local wLen = utf8Len(manualWordInput)
					pcall(function() wb.Text = utf8Sub(manualWordInput, pLen + 1, wLen) end)
				else
					pcall(function() wb.Text = manualWordInput end)
				end
			end
			submitWord(manualWordInput)
			notify("Submit", "ส่งคำศัพท์: " .. manualWordInput, 2)
		end
	end,
})

-- ─────────────────────────────────────────────────────────────
-- TAB 2: DUEL TABLES
-- ─────────────────────────────────────────────────────────────
local TableSec = DuelTab:CreateSection({ Name = "🪑 Table Automation" })

TableSec:CreateToggle({
	Name = "Auto Sit at Available Table",
	Default = flags.AutoSit,
	Tooltip = "ค้นหาเก้าอี้โต๊ะที่ว่างแล้ววาร์ปไปนั่งเล่นอัตโนมัติ",
	Callback = function(v)
		flags.AutoSit = v
	end,
})

TableSec:CreateToggle({
	Name = "Auto Select Table Mode",
	Default = flags.AutoPickMode,
	Tooltip = "เมื่อนั่งเป็นคนแรกจะเลือกโหมดโต๊ะให้อัตโนมัติ",
	Callback = function(v)
		flags.AutoPickMode = v
	end,
})

TableSec:CreateDropdown({
	Name = "Preferred Mode",
	Options = { "Easy Mode (1-2 letters)", "Hard Mode (5+ letters)" },
	Default = flags.PreferredMode,
	Callback = function(v)
		flags.PreferredMode = v
	end,
})

TableSec:CreateButton({
	Name = "Stand Up / Leave Seat",
	Callback = function()
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum and hum.SeatPart then
			hum.Sit = false
			notify("Table", "ลุกออกจากเก้าอี้เรียบร้อย", 2)
		end
	end,
})

local TpTableSec = DuelTab:CreateSection({ Name = "🚀 Teleport to Tables" })
local tableList = {}
for i = 1, 29 do table.insert(tableList, "DuelTable" .. tostring(i)) end
local selectedTable = "DuelTable1"

TpTableSec:CreateDropdown({
	Name = "Select Table",
	Options = tableList,
	Default = selectedTable,
	Callback = function(v)
		selectedTable = v
	end,
})

TpTableSec:CreateButton({
	Name = "Teleport to Selected Table",
	Callback = function()
		local map = workspace:FindFirstChild("Map")
		local tbl = map and map:FindFirstChild(selectedTable)
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if tbl and hrp then
			local primary = tbl:FindFirstChild("Table") or tbl:FindFirstChildWhichIsA("BasePart")
			if primary then
				hrp.CFrame = primary.CFrame + Vector3.new(0, 4, 0)
				notify("Teleport", "วาร์ปมาที่ " .. selectedTable, 2)
			end
		end
	end,
})

-- ─────────────────────────────────────────────────────────────
-- TAB 3: DICTIONARY LOOKUP
-- ─────────────────────────────────────────────────────────────
local DictSec = DictTab:CreateSection({ Name = "📖 Word Search & Pre-Caching" })
local searchPrefix = "ก"

DictSec:CreateTextbox({
	Name = "Search Prefix",
	Placeholder = "ใส่ตัวอักษรนำ เช่น ก, ข, กร, ปลา...",
	Default = "ก",
	Callback = function(t)
		searchPrefix = t
	end,
})

DictSec:CreateButton({
	Name = "Lookup Words in Server Dictionary",
	Callback = function()
		if searchPrefix == "" then return end
		notify("Dictionary", "กำลังค้นหาคำศัพท์สำหรับ: " .. searchPrefix .. " ...", 2)
		local words, common = queryDictionaryServer(searchPrefix)
		notify("Dictionary", string.format("พบ %d คำในพจนานุกรม", #words), 3)
	end,
})

DictSec:CreateButton({
	Name = "Pre-Cache Common Thai Letters (Faster Answers)",
	Callback = function()
		notify("Dictionary", "กำลังดาวน์โหลดคำศัพท์หลัก...", 2)
		local letters = { "ก", "ข", "ค", "ง", "จ", "ช", "ด", "ต", "ท", "น", "บ", "ป", "ผ", "พ", "ฟ", "ม", "ย", "ร", "ล", "ว", "ส", "ห", "อ" }
		task.spawn(function()
			for _, l in ipairs(letters) do
				queryDictionaryServer(l)
				task.wait(0.08)
			end
			notify("Dictionary", "ดาวน์โหลดคำศัพท์หลักเข้าหน่วยความจำเรียบร้อย!", 3)
		end)
	end,
})

-- ─────────────────────────────────────────────────────────────
-- TAB 4: REWARDS & CODES
-- ─────────────────────────────────────────────────────────────
local RewardSec = RewardTab:CreateSection({ Name = "🎁 Automated Claims" })

RewardSec:CreateButton({
	Name = "Claim Daily Reward",
	Callback = function()
		if ClaimDailyRemote then
			pcall(function() ClaimDailyRemote:InvokeServer() end)
			notify("Reward", "กดรับของขวัญรายวันเรียบร้อย", 2)
		end
	end,
})

RewardSec:CreateButton({
	Name = "Claim Group Reward",
	Callback = function()
		if ClaimGroupRemote then
			pcall(function() ClaimGroupRemote:InvokeServer() end)
			notify("Reward", "กดรับของขวัญกลุ่มเรียบร้อย", 2)
		end
	end,
})

RewardSec:CreateButton({
	Name = "Claim Quests",
	Callback = function()
		if QuestRemote then
			pcall(function() QuestRemote:InvokeServer("claimAll") end)
			notify("Reward", "กดรับรางวัลเควสเรียบร้อย", 2)
		end
	end,
})

local CodeSec = RewardTab:CreateSection({ Name = "🎟️ Redeem Active Codes" })
CodeSec:CreateButton({
	Name = "Redeem Known Codes",
	Callback = function()
		if not RedeemCodeRemote then return end
		local codes = { "RELEASE", "THAI", "UPDATE", "WORD", "CHAIN", "500LIKES", "1000LIKES", "FREEGEMS", "COINS" }
		task.spawn(function()
			for _, code in ipairs(codes) do
				pcall(function() RedeemCodeRemote:InvokeServer(code) end)
				task.wait(0.3)
			end
			notify("Codes", "แลกโค้ดทั้งหมดเรียบร้อยแล้ว!", 3)
		end)
	end,
})

-- ─────────────────────────────────────────────────────────────
-- TAB 5: LOCAL PLAYER & VISUALS
-- ─────────────────────────────────────────────────────────────
local PlayerSec = PlayerTab:CreateSection({ Name = "🏃 Movement & Enhancements" })

PlayerSec:CreateToggle({
	Name = "Enable Custom WalkSpeed",
	Default = flags.WalkSpeedEnabled,
	Callback = function(v)
		flags.WalkSpeedEnabled = v
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = v and flags.WalkSpeedValue or 16
		end
	end,
})

PlayerSec:CreateSlider({
	Name = "WalkSpeed Value",
	Min = 16,
	Max = 100,
	Default = flags.WalkSpeedValue,
	Increment = 1,
	Callback = function(v)
		flags.WalkSpeedValue = v
		if flags.WalkSpeedEnabled then
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = v end
		end
	end,
})

PlayerSec:CreateToggle({
	Name = "Enable Custom JumpPower",
	Default = flags.JumpPowerEnabled,
	Callback = function(v)
		flags.JumpPowerEnabled = v
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.UseJumpPower = true
			hum.JumpPower = v and flags.JumpPowerValue or 50
		end
	end,
})

PlayerSec:CreateSlider({
	Name = "JumpPower Value",
	Min = 50,
	Max = 250,
	Default = flags.JumpPowerValue,
	Increment = 5,
	Callback = function(v)
		flags.JumpPowerValue = v
		if flags.JumpPowerEnabled then
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then hum.JumpPower = v end
		end
	end,
})

PlayerSec:CreateToggle({
	Name = "Infinite Jump",
	Default = flags.InfJump,
	Callback = function(v)
		flags.InfJump = v
	end,
})

UserInputService.JumpRequest:Connect(function()
	if flags.InfJump and isCurrentGen() then
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

PlayerSec:CreateToggle({
	Name = "Fullbright (Max Visibility)",
	Default = flags.Fullbright,
	Callback = function(v)
		flags.Fullbright = v
		if v then
			Lighting.Brightness = 2
			Lighting.ClockTime = 14
			Lighting.FogEnd = 100000
			Lighting.GlobalShadows = false
		else
			Lighting.Brightness = 1
			Lighting.ClockTime = 14
			Lighting.FogEnd = 1000
			Lighting.GlobalShadows = true
		end
	end,
})

PlayerSec:CreateToggle({
	Name = "Anti-AFK",
	Default = flags.AntiAFK,
	Callback = function(v)
		flags.AntiAFK = v
	end,
})

LocalPlayer.Idled:Connect(function()
	if flags.AntiAFK and isCurrentGen() then
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
		task.wait(0.1)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
	end
end)

-- Character respawn keeper
LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	local hum = char:WaitForChild("Humanoid", 5)
	if hum then
		if flags.WalkSpeedEnabled then hum.WalkSpeed = flags.WalkSpeedValue end
		if flags.JumpPowerEnabled then
			hum.UseJumpPower = true
			hum.JumpPower = flags.JumpPowerValue
		end
	end
end)

-- ===================== SPECTREUI DEFAULT TABS =====================
pcall(function()
	if Window.CreateDefaultTabs then
		Window:CreateDefaultTabs()
	end
end)

notify("SpectreWare", "Thai Word Chain Script Loaded Successfully!", 3)
