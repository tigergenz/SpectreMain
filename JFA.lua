--[[
	SpecreWare | Jump for Animals
	UI: SPECTREWARE UI v1.0.3 (built into this file, one line below)
	Theme: Spectre (Dark Graphite / Deep Navy Slate / Electric Cyan)
	Brand: SpecreWare
	Discord: https://discord.gg/GdKxvcHzjS
	Game: Jump for Animals
	PlaceId: 126870639873289

	Features:
	  • Built with SPECTREWARE UI v1.0.3 (menu key: Settings > Interface)
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

-- ===================== SPECTREWARE UI (built in) =====================
-- The whole UI library is the single line below (made by ui/build.py).
local SPECTREWARE_UI=(function() local KIT_VERSION="1.0.3"local Players=game:GetService("Players")local RunService=game:GetService("RunService")local UIS=game:GetService("UserInputService")if not game:IsLoaded()then game.Loaded:Wait()end local LP=Players.LocalPlayer while not LP do Players:GetPropertyChangedSignal("LocalPlayer"):Wait()LP=Players.LocalPlayer end local GEN=(getgenv().__MonoGen or 0)+1 getgenv().__MonoGen=GEN local function mine()return getgenv().__MonoGen==GEN end local SESSION_START=os.clock()local STATE do local prev=getgenv().__MonoState if prev then pcall(prev.teardown)end local conns,cleanups,living={},{},true STATE={connect=function(signal,fn)local c=signal:Connect(fn)table.insert(conns,c)return c end,onCleanup=function(fn)table.insert(cleanups,fn)end,alive=function()return living end,teardown=function()living=false for _,fn in ipairs(cleanups)do pcall(fn)end for _,c in ipairs(conns)do pcall(function()c:Disconnect()end)end table.clear(conns)table.clear(cleanups)end,}getgenv().__MonoState=STATE end local WindUI=(function()local TweenService=game:GetService("TweenService")local TextService=game:GetService("TextService")local Stats=game:GetService("Stats")local MarketplaceService=game:GetService("MarketplaceService")local TeleportService=game:GetService("TeleportService")local HttpService=game:GetService("HttpService")local ContentProvider=game:GetService("ContentProvider")local BASE_W,BASE_H=880,580 local TOUCH=UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled local DEVICE,S,VP="PC",1,Vector2.new(1920,1080)do local cam=workspace.CurrentCamera local vp=cam and cam.ViewportSize or VP if vp.Y<10 then vp=VP end VP=vp local short=math.min(vp.X,vp.Y)if TOUCH then DEVICE=short<500 and"Phone"or"Tablet"end if DEVICE=="Phone"then S=math.clamp(short/470,0.8,1)else S=math.clamp(vp.Y/1080,0.85,1.35)S=math.max(0.55,math.min(S,vp.X*0.94/BASE_W,vp.Y*0.9/BASE_H))end end local HOVER=not TOUCH local function px(n)return math.floor(n*S+0.5)end local function even(n)n=math.floor(n+0.5)return n%2==1 and n+1 or n end local WHITE=Color3.new(1,1,1)local PALETTE_KEYS={"bg","side","card","popup","field","rowHover","divider","rowLine","fieldHot","rowActive","cardLine","track","fieldLine","border","fieldLineHot","muted","subtext","text",}local MIX={bg=0,side=0.012,card=0.026,popup=0.036,field=0.046,rowHover=0.056,divider=0.068,rowLine=0.076,fieldHot=0.084,rowActive=0.094,cardLine=0.104,track=0.118,fieldLine=0.132,border=0.146,fieldLineHot=0.22,muted=0.42,subtext=0.62,}local LIGHT=Color3.fromRGB(235,238,245)local FIXED={{96,165,250},{167,139,250},{248,113,113},{251,176,80},{110,231,160},{244,114,182},{45,212,191},{255,255,255},{0,0,0},{196,202,216},{245,245,247},{170,174,184},{150,154,166},}local function makePalette(base,accent)local p={accent=accent}local tint=LIGHT:Lerp(accent,0.14)for k,a in pairs(MIX)do p[k]=base:Lerp(tint,a)end p.text=Color3.fromRGB(238,240,244):Lerp(accent,0.04)local used={}local function k3(r,g,b)return r*65536+g*256+b end local function mark(c)used[k3(math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))]=true end for _,f in ipairs(FIXED)do used[k3(f[1],f[2],f[3])]=true end mark(accent)for _,a in ipairs({0.15,0.2,0.25,0.35})do mark(accent:Lerp(Color3.new(1,1,1),a))end for _,k in ipairs(PALETTE_KEYS)do local c=p[k]local r,g,b=math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5)local step=b>=250 and-1 or 1 while used[k3(r,g,b)]do b+=step end used[k3(r,g,b)]=true p[k]=Color3.fromRGB(r,g,b)end return p end local THEMES,THEME_ORDER={},{}local function addTheme(name,base,accent)name=tostring(name)if not THEMES[name]then table.insert(THEME_ORDER,name)end THEMES[name]={name=name,palette=makePalette(base,accent)}end addTheme("Midnight",Color3.fromRGB(16,18,32),Color3.fromRGB(129,148,230))addTheme("Mono",Color3.fromRGB(12,12,13),Color3.fromRGB(228,228,232))addTheme("Ocean",Color3.fromRGB(8,22,26),Color3.fromRGB(102,178,214))addTheme("Emerald",Color3.fromRGB(11,23,18),Color3.fromRGB(98,196,156))addTheme("Crimson",Color3.fromRGB(28,12,14),Color3.fromRGB(224,104,120))addTheme("Amethyst",Color3.fromRGB(24,14,32),Color3.fromRGB(164,140,224))addTheme("Sunset",Color3.fromRGB(27,20,11),Color3.fromRGB(226,156,102))addTheme("Sakura",Color3.fromRGB(26,14,24),Color3.fromRGB(222,140,178))addTheme("Nord",Color3.fromRGB(24,28,35),Color3.fromRGB(136,176,196))local PREFS_DIR,PREFS_FILE="MonoUI","MonoUI/settings.json"local prefs={}pcall(function()if isfile and readfile and isfile(PREFS_FILE)then local data=HttpService:JSONDecode(readfile(PREFS_FILE))if type(data)=="table"then prefs=data end end end)local function savePrefs()pcall(function()if not writefile then return end if makefolder and isfolder and not isfolder(PREFS_DIR)then makefolder(PREFS_DIR)end writefile(PREFS_FILE,HttpService:JSONEncode(prefs))end)end local HEX={}function HEX.to(s)s=tostring(s or""):gsub("[#%s]","")if#s~=6 or s:find("[^%x]")then return nil end return Color3.fromRGB(tonumber(s:sub(1,2),16),tonumber(s:sub(3,4),16),tonumber(s:sub(5,6),16))end function HEX.from(c)return("#%02X%02X%02X"):format(math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))end do local cu=type(prefs.custom)=="table"and prefs.custom or{}addTheme("Custom",HEX.to(cu.base)or Color3.fromRGB(14,17,24),HEX.to(cu.accent)or Color3.fromRGB(236,72,153))end local GAME_KEY=tostring((game.GameId and game.GameId~=0)and game.GameId or game.PlaceId)local currentTheme=THEMES[prefs.theme]and prefs.theme or"Midnight"local START=THEMES[currentTheme].palette local C={accent=START.accent,blue=Color3.fromRGB(96,165,250),purple=Color3.fromRGB(167,139,250),red=Color3.fromRGB(248,113,113),amber=Color3.fromRGB(251,176,80),green=Color3.fromRGB(110,231,160),pink=Color3.fromRGB(244,114,182),teal=Color3.fromRGB(45,212,191),}local T={font=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.Medium),fontSemi=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.SemiBold),fontBold=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.Bold),mono=Font.new("rbxasset://fonts/families/RobotoMono.json",Enum.FontWeight.Medium),size=Vector2.new(even(math.min(BASE_W*S,VP.X*0.96-2)),even(math.min(BASE_H*S,VP.Y*0.92-2))),radius=px(14),toggleKey=Enum.KeyCode.Z,}local function setPalette(p)for _,k in ipairs(PALETTE_KEYS)do T[k]=p[k]end C.accent=p.accent end setPalette(START)local function lum(c)return 0.2126*c.R+0.7152*c.G+0.0722*c.B end local function onAccent()return lum(C.accent)>0.5 and T.bg or WHITE end local function knobOn()return lum(C.accent)>0.8 and T.bg or WHITE end local ICON={["axe"]="rbxassetid://132405197863294",["bed"]="rbxassetid://97726529032925",["bell"]="rbxassetid://97392696311902",["book-open"]="rbxassetid://129845326810392",["bot"]="rbxassetid://80451686744860",["briefcase"]="rbxassetid://96754188164225",["check"]="rbxassetid://93898873302694",["check-check"]="rbxassetid://95183312173858",["circle"]="rbxassetid://130359823580534",["coffee"]="rbxassetid://106864403231093",["cog"]="rbxassetid://116544501716299",["crosshair"]="rbxassetid://134242818164054",["dollar-sign"]="rbxassetid://127320961224019",["droplets"]="rbxassetid://140111846025180",["eye"]="rbxassetid://100033680381365",["flask-conical"]="rbxassetid://128406680901165",["flask-round"]="rbxassetid://127508287324940",["gamepad-2"]="rbxassetid://92483947987410",["gauge"]="rbxassetid://110273524101447",["gem"]="rbxassetid://112904952151156",["glass-water"]="rbxassetid://115526102400988",["hand"]="rbxassetid://130703864968637",["hand-coins"]="rbxassetid://126990543175462",["magnet"]="rbxassetid://135162361226972",["map"]="rbxassetid://95107167260947",["map-pin"]="rbxassetid://84279202219901",["mouse-pointer-click"]="rbxassetid://107150227368485",["move-vertical"]="rbxassetid://86234730730899",["package"]="rbxassetid://97261141732706",["package-check"]="rbxassetid://102374216055130",["package-plus"]="rbxassetid://129261988138366",["power"]="rbxassetid://96479131758775",["refresh-cw"]="rbxassetid://138133190015277",["repeat"]="rbxassetid://121886242955173",["scan"]="rbxassetid://123104789658180",["scan-eye"]="rbxassetid://99244790601968",["settings"]="rbxassetid://80758916183665",["shield"]="rbxassetid://110987169760162",["shield-check"]="rbxassetid://87354736164608",["siren"]="rbxassetid://134210267818039",["sparkles"]="rbxassetid://138635884129147",["sprout"]="rbxassetid://100091687832508",["target"]="rbxassetid://87563802520297",["trees"]="rbxassetid://121203841375919",["triangle-alert"]="rbxassetid://125920361880643",["user"]="rbxassetid://81589895647169",["user-search"]="rbxassetid://101335649828115",["users"]="rbxassetid://115398113982385",["wind"]="rbxassetid://114551690399915",["x"]="rbxassetid://110786993356448",["zap"]="rbxassetid://130551565616516",["info"]="rbxassetid://124560466474914",["search"]="rbxassetid://121018724060431",["chevron-left"]="rbxassetid://73780377692148",["chevron-right"]="rbxassetid://92473583511724",["chevron-down"]="rbxassetid://134243273101015",["trash-2"]="rbxassetid://109843431391323",["save"]="rbxassetid://126116963775616",["play"]="rbxassetid://135609604299893",["star"]="rbxassetid://136141469398409",["sword"]="rbxassetid://124448418211665",["footprints"]="rbxassetid://139192589041315",["monitor"]="rbxassetid://72664649203050",["palette"]="rbxassetid://86350350950064",["keyboard"]="rbxassetid://121474456068237",["bookmark"]="rbxassetid://121093149326239",["layers"]="rbxassetid://81973586053257",["hammer"]="rbxassetid://83545120140895",["swords"]="rbxassetid://81872698913435",["house"]="rbxassetid://98755624629571",["wifi"]="rbxassetid://104669375183960",["clock"]="rbxassetid://121808839832144",["eye-off"]="rbxassetid://135928786788378",["user-x"]="rbxassetid://139748155894754",["shuffle"]="rbxassetid://132382786975101",["copy"]="rbxassetid://78979572434545",["activity"]="rbxassetid://94212016861936",["minimize-2"]="rbxassetid://116269596042539",["cloud"]="rbxassetid://121226497050352",["layout-grid"]="rbxassetid://81344910161871",["store"]="rbxassetid://90338129673705",["cloud-lightning"]="rbxassetid://133517088924849",["crown"]="rbxassetid://127843403295538",["timer"]="rbxassetid://85473888890506",["server"]="rbxassetid://92188766517878",["trending-down"]="rbxassetid://139309232226438",["user-round"]="rbxassetid://136485052187963",["circle-check"]="rbxassetid://85262178816537",["hash"]="rbxassetid://82890331678520",["list-filter"]="rbxassetid://103321376129527",["panel-left-close"]="rbxassetid://126579818823552",["panel-left-open"]="rbxassetid://111075816195767",["move-diagonal-2"]="rbxassetid://117298577948096",["grip"]="rbxassetid://109058783556768",["pin"]="rbxassetid://120978111007514",["pin-off"]="rbxassetid://127696372451750",["star-off"]="rbxassetid://75742832732503",["rotate-ccw"]="rbxassetid://110116685948665",["ellipsis"]="rbxassetid://140019550645825",["folder-open"]="rbxassetid://76018996254888",["droplet"]="rbxassetid://100597455015098",["pipette"]="rbxassetid://133167932934404",["sliders-horizontal"]="rbxassetid://85538382643347",["blend"]="rbxassetid://111679612185257",["toggle-right"]="rbxassetid://90411952142550",["smartphone"]="rbxassetid://96623008834511",["cpu"]="rbxassetid://77549309870247",["terminal"]="rbxassetid://106783148545356",["anchor"]="rbxassetid://92181172123618",["arrow-up"]="rbxassetid://89282378235317",["backpack"]="rbxassetid://140420225386018",["bone"]="rbxassetid://111242153474115",["box"]="rbxassetid://101768155599700",["car"]="rbxassetid://121065933462582",["compass"]="rbxassetid://115123411028382",["dices"]="rbxassetid://81268120302865",["dna"]="rbxassetid://74007982981741",["egg"]="rbxassetid://117851493400222",["eraser"]="rbxassetid://133957773112410",["gift"]="rbxassetid://109855212076373",["graduation-cap"]="rbxassetid://93771896340220",["heart"]="rbxassetid://116559368303288",["key"]="rbxassetid://96510194465420",["lasso"]="rbxassetid://121072936884007",["layout-dashboard"]="rbxassetid://139929981863901",["leaf"]="rbxassetid://119951075637174",["link"]="rbxassetid://131607023382430",["list-ordered"]="rbxassetid://83212528113913",["move"]="rbxassetid://116138709011735",["navigation"]="rbxassetid://79308213542922",["paw-print"]="rbxassetid://112218825427601",["recycle"]="rbxassetid://140417023381961",["scroll"]="rbxassetid://74072101474951",["shopping-bag"]="rbxassetid://71885477293226",["shopping-cart"]="rbxassetid://128420521375441",["trending-up"]="rbxassetid://81819858538839",["utensils"]="rbxassetid://139952569804235",}ICON["knife"]=ICON["sword"]ICON["alert-triangle"]=ICON["triangle-alert"]ICON["home"]=ICON["house"]ICON["layout"]=ICON["layout-grid"]local function icon(name)if type(name)=="number"then return"rbxassetid://"..name end name=tostring(name or"")if name:find("^rbxasset")or name:find("^https?:")then return name end if name:match("^%d+$")then return"rbxassetid://"..name end name=name:gsub("^lucide:",""):lower()return ICON[name]or ICON.circle end local SHADOW_IMAGE="rbxassetid://8992230677"local SHARP=setmetatable({},{__mode="k"})local SHARP_SYNC={"Position","Size","AnchorPoint","Visible","ZIndex","LayoutOrder","Rotation","AutomaticSize"}local function carried(s,ch)return ch:IsA("GuiObject")or(s.auto and(ch:IsA("UICorner")or ch:IsA("UIStroke")))end local function uiScaleOf(inst)local f=1 while inst and not inst:IsA("LayerCollector")do local u=inst:FindFirstChildOfClass("UIScale")if u then f*=u.Scale end inst=inst.Parent end return f>0 and f or 1 end local function heightOf(inst)return math.ceil(inst.AbsoluteSize.Y/uiScaleOf(inst))end local function unrest(cg)local s=SHARP[cg]if not s or not s.resting then return end s.resting=false local twin=s.twin local size0,frozen if s.auto then size0=cg.Size frozen=UDim2.new(size0.X.Scale,size0.X.Offset,size0.Y.Scale,math.max(size0.Y.Offset,heightOf(twin)))cg.Size=frozen end for _,ch in ipairs(twin:GetChildren())do if carried(s,ch)then ch.Parent=cg end end if s.auto then cg.BackgroundTransparency=s.bt twin.BackgroundTransparency=1 task.delay(0.1,function()if cg.Parent and cg.Size==frozen then cg.Size=size0 end end)end end local function makeTwin(cg,s)local twin=Instance.new("Frame")twin.Name=cg.Name.."_Sharp"twin.BackgroundTransparency=1 twin.BorderSizePixel=0 twin.ClipsDescendants=true s.auto=cg.AutomaticSize~=Enum.AutomaticSize.None for _,p in ipairs(SHARP_SYNC)do twin[p]=cg[p]cg:GetPropertyChangedSignal(p):Connect(function()twin[p]=cg[p]end)end if s.auto then twin.BackgroundColor3=cg.BackgroundColor3 cg:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()twin.BackgroundColor3=cg.BackgroundColor3 end)cg:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()if s.resting and cg.BackgroundTransparency~=1 then s.bt=cg.BackgroundTransparency twin.BackgroundTransparency=s.bt cg.BackgroundTransparency=1 end end)end for _,ch in ipairs(cg:GetChildren())do if ch:IsA("UIGridStyleLayout")or ch:IsA("UIPadding")then ch:Clone().Parent=twin elseif ch:IsA("UIScale")then local sc=Instance.new("UIScale")sc.Scale=ch.Scale ch:GetPropertyChangedSignal("Scale"):Connect(function()sc.Scale=ch.Scale end)sc.Parent=twin end end twin.Parent=cg.Parent cg:GetPropertyChangedSignal("Parent"):Connect(function()if cg.Parent then twin.Parent=cg.Parent else unrest(cg)twin.Parent=nil end end)cg.Destroying:Connect(function()twin:Destroy()end)s.twin=twin return twin end local function rest(cg)local s=SHARP[cg]if not s or s.resting or cg.GroupTransparency~=0 or not cg.Parent then return end local focused=UIS:GetFocusedTextBox()if focused and focused:IsDescendantOf(cg)then if not s.waiting then s.waiting=true focused.FocusLost:Once(function()s.waiting=false task.defer(rest,cg)end)end return end local twin=s.twin or makeTwin(cg,s)if s.auto then local sz=cg.Size twin.Size=UDim2.new(sz.X.Scale,sz.X.Offset,sz.Y.Scale,math.max(sz.Y.Offset,heightOf(cg)))end s.resting=true if s.auto then s.bt=cg.BackgroundTransparency twin.BackgroundTransparency=s.bt cg.BackgroundTransparency=1 end for _,ch in ipairs(cg:GetChildren())do if carried(s,ch)then ch.Parent=twin end end end local function sharpen(cg)local s={resting=false}SHARP[cg]=s cg:GetPropertyChangedSignal("GroupTransparency"):Connect(function()if cg.GroupTransparency==0 then task.defer(rest,cg)else unrest(cg)end end)cg.ChildAdded:Connect(function(ch)if s.resting and ch:IsA("GuiObject")then task.defer(function()if s.resting and ch.Parent==cg then ch.Parent=s.twin end end)end end)task.defer(rest,cg)end local function hostOf(cg)local s=SHARP[cg]return(s and s.resting)and s.twin or cg end local function twinOf(cg)local s=SHARP[cg]return s and(s.twin or makeTwin(cg,s))end local function inGroup(el,cg)if el:IsDescendantOf(cg)then return true end local s=SHARP[cg]return s~=nil and s.twin~=nil and el:IsDescendantOf(s.twin)end local function tween(inst,time,goal,style,dir)if goal.GroupTransparency~=nil and SHARP[inst]then unrest(inst)end local tw=TweenService:Create(inst,TweenInfo.new(time,style or Enum.EasingStyle.Quint,dir or Enum.EasingDirection.Out),goal)tw:Play()return tw end local function new(class,props,parent)local i=Instance.new(class)for k,v in pairs(props or{})do i[k]=v end if parent then i.Parent=parent end if class=="CanvasGroup"then sharpen(i)end return i end local function corner(p,r)return new("UICorner",{CornerRadius=UDim.new(0,r)},p)end local function stroke(p,color,transparency,thickness)return new("UIStroke",{Color=color,Thickness=thickness or 1,Transparency=transparency or 0,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,},p)end local function textW(text,size,face)local w=#text*size*0.55 pcall(function()local params=Instance.new("GetTextBoundsParams")params.Text,params.Font,params.Size,params.Width=text,face or T.font,size,10000 w=TextService:GetTextBoundsAsync(params).X end)return math.ceil(w)+1 end local TAGS={Risky=C.red,Beta=C.amber,New=C.blue,Safe=C.green,["On start"]=C.amber}local function tag(parent,text,color,order)color=color or TAGS[text]or T.subtext local label=text:upper()local h=even(px(18))local pill=new("Frame",{Name="Tag",LayoutOrder=order or 1,BackgroundColor3=color,BackgroundTransparency=0.85,Size=UDim2.fromOffset(textW(label,px(10),T.fontBold)+px(14),h),},parent)corner(pill,math.floor(h/2))stroke(pill,color,0.6)new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(10),TextColor3=color:Lerp(WHITE,0.2),Text=label,},pill)return pill end local function parseTitle(title)title=tostring(title or"")local tags={}local plain=title:gsub("<[^>]+>","")if plain:find("RISKY",1,true)then table.insert(tags,"Risky")plain=plain:gsub("%s*RISKY%s*"," ")end plain=plain:gsub("^%s+",""):gsub("%s+$","")if plain:sub(1,1)=="="then plain="What RISKY means"end return plain,tags end local privacy={name=false,avatar=false}local privacyHooks={}local function onPrivacy(fn)table.insert(privacyHooks,fn)pcall(fn)end local function setPrivacy(key,on)privacy[key]=on for _,fn in ipairs(privacyHooks)do pcall(fn)end end local gameInfo={name="Loading...",creator="...",loaded=false}local gameHooks={}local function onGameInfo(fn)table.insert(gameHooks,fn)if gameInfo.loaded then pcall(fn)end end task.spawn(function()local ok,info=pcall(MarketplaceService.GetProductInfo,MarketplaceService,game.PlaceId)if ok and type(info)=="table"then gameInfo.name=tostring(info.Name or"Unknown experience")gameInfo.creator=(type(info.Creator)=="table"and info.Creator.Name)and tostring(info.Creator.Name)or"Unknown"else gameInfo.name,gameInfo.creator="Unknown experience","Unknown"end gameInfo.loaded=true for _,fn in ipairs(gameHooks)do pcall(fn)end end)local host if gethui then host=gethui()else local ok,cg=pcall(function()return game:GetService("CoreGui")end)if ok and cg and pcall(function()return cg:GetChildren()end)then host=cg elseif LP then host=LP:FindFirstChild("PlayerGui")or LP:WaitForChild("PlayerGui")end end for _,old in ipairs(host:GetChildren())do if old.Name=="MonoUI"then old:Destroy()end end local gui=new("ScreenGui",{Name="MonoUI",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=100000,},host)STATE.onCleanup(function()pcall(function()gui:Destroy()end)end)local onThemeChanged,applyTheme do(function()local themeHooks={}function onThemeChanged(fn)table.insert(themeHooks,fn)end local function ckey(c)return math.floor(c.R*255+0.5)*65536+math.floor(c.G*255+0.5)*256+math.floor(c.B*255+0.5)end local ACCENT_MIX={0.15,0.2,0.25,0.35}local THEMED_PROPS={Frame={"BackgroundColor3"},CanvasGroup={"BackgroundColor3"},UIStroke={"Color"},TextLabel={"BackgroundColor3","TextColor3"},TextButton={"BackgroundColor3","TextColor3"},TextBox={"BackgroundColor3","TextColor3","PlaceholderColor3"},ImageLabel={"BackgroundColor3","ImageColor3"},ImageButton={"BackgroundColor3","ImageColor3"},ScrollingFrame={"BackgroundColor3","ScrollBarImageColor3"},}local pendingFades={}local recentPalettes={}local lastSwitch,queued=-1,nil local function finishFades()for _,f in ipairs(pendingFades)do local st=f.tw.PlaybackState if st==Enum.PlaybackState.Playing or st==Enum.PlaybackState.Begin or st==Enum.PlaybackState.Delayed then f.tw:Cancel()pcall(function()f.inst[f.prop]=f.goal end)end end table.clear(pendingFades)end local function mapBetween(from,to)local map={}local function add(o,n)local k=ckey(o)if map[k]==nil then map[k]=n end end for _,k in ipairs(PALETTE_KEYS)do add(from[k],to[k])end add(from.accent,to.accent)for _,a in ipairs(ACCENT_MIX)do add(from.accent:Lerp(WHITE,a),to.accent:Lerp(WHITE,a))end return map end local function walkTheme(maps,skip,animate)local st,hid={gui},{false}while#st>0 do local inst,hidden=table.remove(st),table.remove(hid)if not inst:GetAttribute("MonoNoTheme")then if not hidden and inst:IsA("GuiObject")and not inst.Visible then hidden=true end local props=THEMED_PROPS[inst.ClassName]if props then for _,prop in ipairs(props)do local k=ckey(inst[prop])if not(skip and skip[k])then local n for _,m in ipairs(maps)do n=m[k]if n then break end end if n then if animate and not hidden then local tw=tween(inst,0.4,{[prop]=n},Enum.EasingStyle.Quad)table.insert(pendingFades,{tw=tw,inst=inst,prop=prop,goal=n})else inst[prop]=n end end end end end for _,c in ipairs(inst:GetChildren())do table.insert(st,c)table.insert(hid,hidden)end end end end local runTheme function applyTheme(name,animate,remember,force)name=tostring(name or"")local th=THEMES[name]if not th or(name==currentTheme and not force and not queued)then return false end local now=os.clock()if animate and(queued or now-lastSwitch<0.15)then local first=queued==nil queued={name,remember,force}if first then task.delay(math.max(0.15-(now-lastSwitch),0.03),function()local q=queued queued=nil if q and(q[1]~=currentTheme or q[3])then runTheme(q[1],true,q[2])end end)end return true end return runTheme(name,animate,remember)end function runTheme(name,animate,remember)local th=THEMES[name]if not th then return false end local now=os.clock()lastSwitch=now finishFades()local old={accent=C.accent}for _,k in ipairs(PALETTE_KEYS)do old[k]=T[k]end table.insert(recentPalettes,1,old)while#recentPalettes>4 do table.remove(recentPalettes)end local p=th.palette currentTheme=name setPalette(p)walkTheme({mapBetween(old,p)},nil,animate)local token=now task.delay(0.6,function()if lastSwitch~=token or not gui.Parent then return end local fresh={[ckey(p.accent)]=true}for _,k in ipairs(PALETTE_KEYS)do fresh[ckey(p[k])]=true end local maps={}for _,pal in ipairs(recentPalettes)do table.insert(maps,mapBetween(pal,p))end walkTheme(maps,fresh,false)end)if remember then prefs.theme=name savePrefs()end for _,fn in ipairs(themeHooks)do pcall(fn,name)end return true end end)()end local shell=new("Frame",{Name="Window",AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.fromOffset(T.size.X,T.size.Y),BackgroundTransparency=1,Visible=false,},gui)local pop=new("UIScale",{},shell)local userScale=math.clamp(tonumber(prefs.scale)or 1,0.5,2)local WIN=(function()local W={alpha=math.clamp(tonumber(prefs.opacity)and(1-tonumber(prefs.opacity))or 0,0,0.4),blur=prefs.blur==true,min=Vector2.new(math.min(even(px(720)),T.size.X),math.min(even(px(460)),T.size.Y)),}local function vp()return workspace.CurrentCamera.ViewportSize end function W.maxSize()local v=vp()return Vector2.new(math.max(W.min.X,even(v.X*0.96/userScale)),math.max(W.min.Y,even(v.Y*0.94/userScale)))end function W.fitSize(s)local mx=W.maxSize()return Vector2.new(even(math.clamp(s.X,W.min.X,mx.X)),even(math.clamp(s.Y,W.min.Y,mx.Y)))end function W.clamp(c)local v=vp()local half=Vector2.new(T.size.X,T.size.Y)*userScale/2 local function axis(x,h,len)if(h+6)*2>=len then return len/2 end return math.clamp(x,h+6,len-h-6)end return Vector2.new(math.floor(axis(c.X,half.X,v.X)+0.5),math.floor(axis(c.Y,half.Y,v.Y)+0.5))end function W.place(c,animate)c=W.clamp(c)local goal=UDim2.fromOffset(c.X,c.Y)if animate then tween(shell,0.12,{Position=goal})else shell.Position=goal end end function W.center()return Vector2.new(shell.Position.X.Offset,shell.Position.Y.Offset)end function W.setSize(s)T.size=W.fitSize(s)shell.Size=UDim2.fromOffset(T.size.X,T.size.Y)end function W.save()prefs.window={w=T.size.X,h=T.size.Y}savePrefs()end local saved=type(prefs.window)=="table"and prefs.window or{}if tonumber(saved.w)and tonumber(saved.h)then W.setSize(Vector2.new(tonumber(saved.w),tonumber(saved.h)))end do local v=vp()W.place(Vector2.new(v.X/2,v.Y/2))end local camConn local function hook()if camConn then camConn:Disconnect()end local cam=workspace.CurrentCamera if not cam then return end camConn=cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()W.setSize(T.size)W.place(W.center())end)end hook()STATE.connect(workspace:GetPropertyChangedSignal("CurrentCamera"),hook)STATE.onCleanup(function()if camConn then camConn:Disconnect()end end)local fx function W.blurTo(on)if not fx then if not on then return end fx=Instance.new("BlurEffect")fx.Name,fx.Size="MonoUIBlur",0 fx.Parent=game:GetService("Lighting")STATE.onCleanup(function()pcall(function()fx:Destroy()end)end)end tween(fx,on and 0.4 or 0.25,{Size=on and 14 or 0},Enum.EasingStyle.Quad)end return W end)()local SHADOW_REST=0.45 local shadow=new("ImageLabel",{Name="Shadow",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,px(10)),Size=UDim2.new(1,px(90),1,px(90)),BackgroundTransparency=1,Image=SHADOW_IMAGE,ImageColor3=Color3.new(0,0,0),ImageTransparency=1,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(99,99,99,99),},shell)local borderFrame=new("Frame",{Name="Border",Size=UDim2.fromScale(1,1),BackgroundTransparency=1},shell)corner(borderFrame,T.radius)local borderStroke=stroke(borderFrame,T.border,1)local window=new("CanvasGroup",{Name="Canvas",Size=UDim2.fromScale(1,1),BackgroundColor3=T.bg,BorderSizePixel=0,GroupTransparency=1,},shell)corner(window,T.radius)local function inWindow(el)local s=pop.Scale local p=(el.AbsolutePosition-window.AbsolutePosition)/s return Vector2.new(math.floor(p.X+0.5),math.floor(p.Y+0.5)),el.AbsoluteSize/s end do local dragging,startMouse,startPos local function dragStart(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging,startMouse,startPos=true,input.Position,WIN.center()end end STATE.connect(window.InputBegan,dragStart)STATE.connect(twinOf(window).InputBegan,dragStart)STATE.connect(UIS.InputChanged,function(input)if not dragging or not mine()then return end if input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch then return end local d=input.Position-startMouse WIN.place(startPos+Vector2.new(d.X,d.Y),true)end)STATE.connect(UIS.InputEnded,function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end)end local shown,opened=false,false local closePopup local paintFloat local keyEnabled=true local function setShown(on)if on==shown then return end shown=on if on then opened=true end if closePopup then closePopup()end if paintFloat then paintFloat()end if on then shell.Visible=true pop.Scale=userScale*0.92 tween(pop,0.45,{Scale=userScale},Enum.EasingStyle.Back)tween(window,0.3,{GroupTransparency=WIN.alpha},Enum.EasingStyle.Quad)tween(shadow,0.45,{ImageTransparency=SHADOW_REST})tween(borderStroke,0.3,{Transparency=0})if WIN.blur then WIN.blurTo(true)end else if WIN.blur then WIN.blurTo(false)end tween(pop,0.22,{Scale=userScale*0.95})tween(shadow,0.18,{ImageTransparency=1})tween(borderStroke,0.18,{Transparency=1})local tw=tween(window,0.18,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()if not shown then shell.Visible=false end end)end end local capture={active=false}STATE.connect(UIS.InputBegan,function(input,processed)if processed or not mine()or capture.active then return end if keyEnabled and input.KeyCode==T.toggleKey then setShown(not shown)end end)local L={side=px(216),narrow=px(72),header=px(64),navH=even(px(42)),navGap=px(4),navIcon=even(px(18)),navText=px(15),profileH=px(60),segH=even(px(36)),}local PAD=px(22)local INNER=px(14)local NAV_ICON_X=math.floor((L.narrow-INNER*2-L.navIcon)/2)local NAV_LABEL_X=NAV_ICON_X+L.navIcon+px(12)local sidebar=new("Frame",{Name="Sidebar",Size=UDim2.new(0,L.side,1,0),BackgroundColor3=T.side,BorderSizePixel=0,ClipsDescendants=true,},window)corner(sidebar,T.radius)new("Frame",{Name="SquareEdge",AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.new(0,T.radius,1,0),BackgroundColor3=T.side,BorderSizePixel=0,ZIndex=0,},sidebar)new("Frame",{Name="Divider",AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.new(0,1,1,0),BackgroundColor3=T.divider,BorderSizePixel=0,ZIndex=3,},sidebar)local brandIcon,brandTitle,brandSub,brandBadge,setBrand do local brandS=px(36)local wordH,subH=px(38),px(12)local brand=new("Frame",{Name="Brand",Position=UDim2.fromOffset(INNER,math.floor((L.header-(wordH+subH+px(2)))/2)),Size=UDim2.new(1,-INNER*2,0,wordH+subH+px(2)),BackgroundTransparency=1,},sidebar)brandBadge=new("CanvasGroup",{Name="Badge",AnchorPoint=Vector2.new(0,0.5),Position=UDim2.fromScale(0,0.5),Size=UDim2.fromOffset(brandS,brandS),BackgroundColor3=C.accent,BackgroundTransparency=0.82,GroupTransparency=1,Visible=false,},brand)corner(brandBadge,px(10))stroke(brandBadge,C.accent,1)new("UIGradient",{Rotation=90,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,0.45)}),},brandBadge)local monogram=new("TextLabel",{Name="Monogram",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,px(1)),Size=UDim2.fromScale(1,1),BackgroundTransparency=1,RichText=true,FontFace=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.ExtraBold),TextSize=px(17),TextColor3=WHITE,Text="",},brandBadge)brandIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(18)),even(px(18))),BackgroundTransparency=1,Image="",ImageColor3=C.accent:Lerp(WHITE,0.25),Visible=false,},brandBadge)brandTitle=new("TextLabel",{Name="Wordmark",Size=UDim2.new(1,0,0,wordH),BackgroundTransparency=1,RichText=true,FontFace=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.ExtraBold),TextScaled=true,TextColor3=WHITE,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Bottom,Text="",},brand)new("UITextSizeConstraint",{MaxTextSize=px(40),MinTextSize=px(12)},brandTitle)brandSub=new("TextLabel",{Position=UDim2.fromOffset(px(2),wordH+px(1)),Size=UDim2.new(1,-px(4),0,subH),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},brand)local base,accent="SPECTRE","WARE"local function esc(s)return(tostring(s):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"))end local function paint()local hex=HEX.from(C.accent)local text=esc(base)if accent~=""then text..= ('<font color="%s">%s</font>'):format(hex,esc(accent))end brandTitle.Text=text local m=esc(base:sub(1,1):upper())if accent~=""then m..= ('<font color="%s">%s</font>'):format(hex,esc(accent:sub(1,1):upper()))end monogram.Text=m monogram.Visible=not brandIcon.Visible end function setBrand(b,a)base,accent=tostring(b or""),tostring(a or"")paint()end paint()onThemeChanged(paint)end local navTop=L.header+px(4)local nav=new("ScrollingFrame",{Name="Nav",Position=UDim2.fromOffset(INNER,navTop),Size=UDim2.new(1,-INNER*2,1,-(navTop+L.profileH+INNER*2)),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,},sidebar)local navHl=new("Frame",{Name="Highlight",Size=UDim2.new(1,0,0,L.navH),BackgroundColor3=T.rowActive,Visible=false},nav)corner(navHl,px(10))stroke(navHl,T.fieldLine,0.35)local navBarH=even(px(18))local navBar=new("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(px(3),navBarH),BackgroundColor3=C.accent,BorderSizePixel=0,},navHl)corner(navBar,px(2))local navList=new("Frame",{Name="List",Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},nav)new("UIListLayout",{Padding=UDim.new(0,L.navGap),SortOrder=Enum.SortOrder.LayoutOrder},navList)local profile=new("TextButton",{Name="Profile",AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,INNER,1,-INNER),Size=UDim2.new(1,-INNER*2,0,L.profileH),BackgroundColor3=T.card,AutoButtonColor=false,Text="",},sidebar)corner(profile,px(12))local profStroke=stroke(profile,T.cardLine)local avS=even(px(36))local AV_X,AV_X_NARROW=px(12),math.floor((L.narrow-INNER*2-avS)/2)local pfp=new("ImageLabel",{Name="Avatar",Position=UDim2.fromOffset(AV_X,math.floor((L.profileH-avS)/2)),Size=UDim2.fromOffset(avS,avS),BackgroundColor3=T.field,Image="",},profile)new("UICorner",{CornerRadius=UDim.new(1,0)},pfp)local dot=new("Frame",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,px(1),1,px(1)),Size=UDim2.fromOffset(px(11),px(11)),BackgroundColor3=C.green,ZIndex=2,},pfp)new("UICorner",{CornerRadius=UDim.new(1,0)},dot)stroke(dot,T.card,0,2)task.spawn(function()local ok,img=pcall(Players.GetUserThumbnailAsync,Players,LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)if ok and pfp.Parent then pfp.Image=img end end)local ptx=AV_X+avS+px(10)local profName=new("TextLabel",{Position=UDim2.fromOffset(ptx,0),Size=UDim2.new(1,-(ptx+px(28)),0.5,-px(1)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(14),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Bottom,TextTruncate=Enum.TextTruncate.AtEnd,Text=LP.DisplayName,},profile)local profSub=new("TextLabel",{Position=UDim2.new(0,ptx,0.5,px(2)),Size=UDim2.new(1,-(ptx+px(28)),0.5,-px(2)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextTruncate=Enum.TextTruncate.AtEnd,Text="@"..LP.Name,},profile)local chevS=even(px(14))local profChev=new("ImageLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(12),0.5,0),Size=UDim2.fromOffset(chevS,chevS),BackgroundTransparency=1,Image=ICON["chevron-right"],ImageColor3=T.muted,},profile)onGameInfo(function()profSub.Text=gameInfo.name end)onPrivacy(function()profName.Text=privacy.name and"Hidden"or LP.DisplayName tween(pfp,0.25,{ImageTransparency=privacy.avatar and 1 or 0})end)STATE.connect(profile.MouseEnter,function()tween(profile,0.18,{BackgroundColor3=T.rowHover})tween(profStroke,0.18,{Color=T.fieldLineHot})tween(profChev,0.25,{Position=UDim2.new(1,-px(9),0.5,0),ImageColor3=T.text})end)STATE.connect(profile.MouseLeave,function()tween(profile,0.18,{BackgroundColor3=T.card})tween(profStroke,0.18,{Color=T.cardLine})tween(profChev,0.25,{Position=UDim2.new(1,-px(12),0.5,0),ImageColor3=T.muted})end)local content=new("Frame",{Name="Content",Position=UDim2.fromOffset(L.side,0),Size=UDim2.new(1,-L.side,1,0),BackgroundTransparency=1,ClipsDescendants=true,},window)local btnS=even(px(34))local searchW,searchH=px(250),even(px(36))local headIconS=even(px(20))local function headerButton(name,iconId,anchorX,pos)local b=new("TextButton",{Name=name,AnchorPoint=Vector2.new(anchorX,0.5),Position=pos,Size=UDim2.fromOffset(btnS,btnS),BackgroundColor3=T.field,BackgroundTransparency=1,AutoButtonColor=false,Text="",},content)corner(b,px(9))local st=stroke(b,T.fieldLine,1)local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(17)),even(px(17))),BackgroundTransparency=1,Image=iconId,ImageColor3=T.subtext,},b)STATE.connect(b.MouseEnter,function()tween(b,0.15,{BackgroundTransparency=0})tween(st,0.15,{Transparency=0})tween(ic,0.15,{ImageColor3=T.text})end)STATE.connect(b.MouseLeave,function()tween(b,0.15,{BackgroundTransparency=1})tween(st,0.15,{Transparency=1})tween(ic,0.15,{ImageColor3=T.subtext})end)return b,ic end local colBtn,colIcon=headerButton("SidebarToggle",ICON["panel-left-close"],0,UDim2.new(0,PAD-px(8),0,math.floor(L.header/2)))local HEAD_X=PAD-px(8)+btnS+px(10)local headIcon=new("ImageLabel",{Position=UDim2.fromOffset(HEAD_X,math.floor((L.header-headIconS)/2)),Size=UDim2.fromOffset(headIconS,headIconS),BackgroundTransparency=1,Image="",ImageColor3=C.accent,},content)local TITLE_POS=UDim2.fromOffset(HEAD_X+headIconS+px(10),0)local headTitle=new("TextLabel",{Position=TITLE_POS,Size=UDim2.new(1,-(HEAD_X+headIconS+px(10)+PAD+searchW+btnS+px(20)),0,L.header),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(20),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},content)local minBtn=headerButton("Minimize",ICON["minimize-2"],1,UDim2.new(1,-PAD,0,math.floor(L.header/2)))local search=new("Frame",{Name="Search",AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-(PAD+btnS+px(8)),0,math.floor(L.header/2)),Size=UDim2.fromOffset(searchW,searchH),BackgroundColor3=T.field,},content)corner(search,px(10))local searchStroke=stroke(search,T.fieldLine)local sIconS=even(px(15))local searchIcon=new("ImageLabel",{Position=UDim2.fromOffset(px(12),math.floor((searchH-sIconS)/2)),Size=UDim2.fromOffset(sIconS,sIconS),BackgroundTransparency=1,Image=ICON.search,ImageColor3=T.muted,},search)local searchBox=new("TextBox",{Name="Query",Position=UDim2.fromOffset(px(12)+sIconS+px(9),0),Size=UDim2.new(1,-(px(12)+sIconS+px(9)+px(10)),1,0),BackgroundTransparency=1,ClearTextOnFocus=false,FontFace=T.font,TextSize=px(14),TextColor3=T.text,PlaceholderText="Search everything...",PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true,},search)STATE.connect(searchBox.Focused,function()tween(searchStroke,0.2,{Color=C.accent,Transparency=0.25})tween(searchIcon,0.2,{ImageColor3=C.accent})tween(search,0.2,{BackgroundColor3=T.fieldHot})end)STATE.connect(searchBox.FocusLost,function()tween(searchStroke,0.25,{Color=T.fieldLine,Transparency=0})tween(searchIcon,0.25,{ImageColor3=T.muted})tween(search,0.25,{BackgroundColor3=T.field})end)local overlay=new("Frame",{Name="Overlay",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=20},window)do local gs=math.max(even(px(22)),TOUCH and 32 or 0)local grip=new("TextButton",{Name="ResizeGrip",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(3),1,-px(3)),Size=UDim2.fromOffset(gs,gs),BackgroundTransparency=1,AutoButtonColor=false,Text="",ZIndex=25,},window)local gi=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(13)),even(px(13))),BackgroundTransparency=1,Image=ICON["move-diagonal-2"],ImageColor3=T.muted,ImageTransparency=0.45,ZIndex=25,},grip)local active,startPos,startSize,startCenter local function lit(on)tween(gi,0.15,{ImageTransparency=on and 0 or 0.45,ImageColor3=on and T.text or T.muted})end if HOVER then STATE.connect(grip.MouseEnter,function()lit(true)end)STATE.connect(grip.MouseLeave,function()if not active then lit(false)end end)end STATE.connect(grip.InputBegan,function(input)if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end if active then return end active,startPos,startSize,startCenter=input,input.Position,T.size,WIN.center()lit(true)end)STATE.connect(UIS.InputChanged,function(input)if not active then return end local isTouch=input.UserInputType==Enum.UserInputType.Touch if isTouch and input~=active then return end if not isTouch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end local d=Vector2.new(input.Position.X-startPos.X,input.Position.Y-startPos.Y)/userScale WIN.setSize(startSize+d)WIN.place(startCenter+(T.size-startSize)*userScale/2)end)STATE.connect(UIS.InputEnded,function(input)if not active then return end if input~=active and not(active.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1)then return end active=nil lit(false)WIN.save()end)end local K={groupGap=px(16),caption=px(12),captionH=px(26),rowMin=even(px(58)),rowPad=px(16),vPad=px(13),title=px(15),desc=px(13),radius=px(12),ctrlH=even(px(34)),}local tabs,tabOrder,selectedTab={},{},nil local currentPage local function placePage(page,animate)local tab=page.tab local top=L.header+(#tab.secOrder>=2 and(L.segH+px(14))or 0)if page.tw then page.tw:Cancel()page.tw=nil end page.wrap.Size=UDim2.new(1,0,1,-top)if animate then page.wrap.Position=UDim2.fromOffset(0,top+px(16))page.wrap.GroupTransparency=1 page.tw=tween(page.wrap,0.42,{Position=UDim2.fromOffset(0,top),GroupTransparency=0})else page.wrap.Position=UDim2.fromOffset(0,top)page.wrap.GroupTransparency=0 end end local function showPage(page)if closePopup then closePopup()end if currentPage==page then if page then placePage(page,false)end return end if currentPage then currentPage.wrap.Visible=false end currentPage=page if page then page.wrap.Visible=true page.scroll.CanvasPosition=Vector2.new()placePage(page,true)if page.onShow then task.spawn(page.onShow)end end end local function paintNav(tab,t)local on=selectedTab==tab tween(tab.navIcon,t,{ImageColor3=on and C.accent or(tab.hover and T.text or T.subtext)})tween(tab.navLabel,t,{TextColor3=(on or tab.hover)and T.text or T.subtext})tween(tab.navHover,t,{BackgroundTransparency=(tab.hover and not on)and 0 or 1})end local function setHeader(tab)headIcon.Image=tab.icon headTitle.Text=tab.name headTitle.TextTransparency,headIcon.ImageTransparency=1,1 headTitle.Position=TITLE_POS+UDim2.fromOffset(px(10),0)tween(headTitle,0.35,{TextTransparency=0,Position=TITLE_POS})tween(headIcon,0.35,{ImageTransparency=0})end local function pillX(tab,sec)local x=px(3)for _,s in ipairs(tab.secOrder)do if s==sec then return x end x+=s.pillW+px(2)end return x end local function refreshSeg(tab,animate)if not tab.seg then return end local show=#tab.secOrder>=2 tab.seg.Visible=show and selectedTab==tab if show and tab.selected then local goal={Position=UDim2.fromOffset(pillX(tab,tab.selected),px(3)),Size=UDim2.fromOffset(tab.selected.pillW,L.segH-px(6)),}if animate then tween(tab.segHl,0.35,goal)else tab.segHl.Position,tab.segHl.Size=goal.Position,goal.Size end end end local function paintPill(sec,t)local on=sec.tab.selected==sec tween(sec.pillLabel,t or 0.2,{TextColor3=on and T.text or(sec.hover and T.text or T.subtext)})tween(sec.pillIcon,t or 0.2,{ImageColor3=on and C.accent or T.muted})end local function selectTab(name)local tab=tabs[name]if not tab or selectedTab==tab then return end local prev=selectedTab selectedTab=tab if prev then paintNav(prev,0.2)if prev.seg then prev.seg.Visible=false end end paintNav(tab,0.2)local rank=0 for _,t in ipairs(tabOrder)do local a,b=t.nav.LayoutOrder,tab.nav.LayoutOrder if t~=tab and(a<b or(a==b and t.index<tab.index))then rank+=1 end end local y=rank*(L.navH+L.navGap)navHl.Visible=true if prev then tween(navHl,0.38,{Position=UDim2.fromOffset(0,y)})local squeeze=tween(navBar,0.12,{Size=UDim2.fromOffset(px(3),math.floor(navBarH/2))})squeeze.Completed:Once(function()tween(navBar,0.3,{Size=UDim2.fromOffset(px(3),navBarH)},Enum.EasingStyle.Back)end)else navHl.Position=UDim2.fromOffset(0,y)end if tab.iconScale then tab.iconScale.Scale=0.8 tween(tab.iconScale,0.4,{Scale=1},Enum.EasingStyle.Back)end setHeader(tab)refreshSeg(tab,false)showPage(tab.selected and tab.selected.page)end local function selectSection(tabName,name)local tab=tabs[tabName]local sec=tab and tab.sections[name]if not sec or tab.selected==sec then return end local prev=tab.selected tab.selected=sec if prev then paintPill(prev)end paintPill(sec)refreshSeg(tab,true)if selectedTab==tab then showPage(sec.page)end end local collapsed=false local function addTab(name,iconId)local index=#tabOrder+1 local btn=new("TextButton",{Name=name,LayoutOrder=index,Size=UDim2.new(1,0,0,L.navH),BackgroundTransparency=1,AutoButtonColor=false,Text="",},navList)local hover=new("Frame",{Name="Hover",Size=UDim2.fromScale(1,1),BackgroundColor3=T.rowHover,BackgroundTransparency=1},btn)corner(hover,px(10))local img=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromOffset(NAV_ICON_X+L.navIcon/2,L.navH/2),Size=UDim2.fromOffset(L.navIcon,L.navIcon),BackgroundTransparency=1,Image=iconId,ImageColor3=T.subtext,},btn)local iconScale=new("UIScale",{},img)local label=new("TextLabel",{Position=UDim2.fromOffset(NAV_LABEL_X,0),Size=UDim2.new(1,-(NAV_LABEL_X+px(8)),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=L.navText,TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,TextTransparency=collapsed and 1 or 0,Text=name,},btn)local tab={name=name,index=index,icon=iconId,nav=btn,navIcon=img,navLabel=label,navHover=hover,iconScale=iconScale,sections={},secOrder={},}tabs[name]=tab table.insert(tabOrder,tab)STATE.connect(btn.MouseEnter,function()tab.hover=true paintNav(tab,0.15)end)STATE.connect(btn.MouseLeave,function()tab.hover=false paintNav(tab,0.2)end)STATE.connect(btn.MouseButton1Click,function()selectTab(name)end)return tab end local function ensureSeg(tab)if tab.seg then return end local seg=new("Frame",{Name="Sections",Position=UDim2.fromOffset(PAD,L.header),Size=UDim2.fromOffset(0,L.segH),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=T.field,Visible=false,},content)corner(seg,px(10))stroke(seg,T.fieldLine)local hl=new("Frame",{Name="Highlight",Position=UDim2.fromOffset(px(3),px(3)),Size=UDim2.fromOffset(0,L.segH-px(6)),BackgroundColor3=T.rowActive,},seg)corner(hl,px(8))stroke(hl,T.fieldLineHot,0.5)local list=new("Frame",{Name="List",Size=UDim2.fromOffset(0,L.segH),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,},seg)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(2)),SortOrder=Enum.SortOrder.LayoutOrder,},list)new("UIPadding",{PaddingLeft=UDim.new(0,px(3)),PaddingRight=UDim.new(0,px(3))},list)tab.seg,tab.segHl,tab.segList=seg,hl,list end local function makePage(tab,sec)local wrap=new("CanvasGroup",{Name=tab.name.."/"..sec.name,Position=UDim2.fromOffset(0,L.header),Size=UDim2.new(1,0,1,-L.header),BackgroundTransparency=1,Visible=false,},content)local scroll=new("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=px(4),ScrollBarImageColor3=T.fieldLineHot,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,},wrap)local body=new("Frame",{Name="Body",Position=UDim2.fromOffset(PAD,0),Size=UDim2.new(1,-PAD*2,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},scroll)new("UIListLayout",{Padding=UDim.new(0,K.groupGap),SortOrder=Enum.SortOrder.LayoutOrder},body)new("UIPadding",{PaddingTop=UDim.new(0,px(4)),PaddingBottom=UDim.new(0,px(24))},body)return{tab=tab,sec=sec,wrap=wrap,scroll=scroll,body=body,groups=0,rows={},groupList={}}end local function addSection(tab,name,iconId)if tab.sections[name]then return tab.sections[name]end ensureSeg(tab)local iconS=even(px(14))local labelW=textW(name,px(13),T.fontSemi)local pillW=px(12)+iconS+px(7)+labelW+px(14)local pill=new("TextButton",{Name=name,LayoutOrder=#tab.secOrder+1,Size=UDim2.fromOffset(pillW,L.segH-px(6)),BackgroundTransparency=1,AutoButtonColor=false,Text="",},tab.segList)local pIcon=new("ImageLabel",{Position=UDim2.fromOffset(px(12),math.floor((L.segH-px(6)-iconS)/2)),Size=UDim2.fromOffset(iconS,iconS),BackgroundTransparency=1,Image=iconId,ImageColor3=T.muted,},pill)local pLabel=new("TextLabel",{Position=UDim2.fromOffset(px(12)+iconS+px(7),0),Size=UDim2.new(0,labelW+px(4),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(13),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,Text=name,},pill)local sec={name=name,tab=tab,pill=pill,pillIcon=pIcon,pillLabel=pLabel,pillW=pillW}sec.icon=pIcon sec.page=makePage(tab,sec)tab.sections[name]=sec table.insert(tab.secOrder,sec)STATE.connect(pill.MouseEnter,function()sec.hover=true paintPill(sec,0.15)end)STATE.connect(pill.MouseLeave,function()sec.hover=false paintPill(sec,0.2)end)STATE.connect(pill.MouseButton1Click,function()selectSection(tab.name,name)end)if not tab.selected then tab.selected=sec end paintPill(sec,0)if selectedTab==tab then refreshSeg(tab,false)if currentPage then placePage(currentPage,false)else showPage(tab.selected.page)end end return sec end local function setCollapsed(on,remember)collapsed=on==true if remember then prefs.collapsed=collapsed savePrefs()end local swap=tween(colIcon,0.1,{ImageTransparency=1})swap.Completed:Once(function()colIcon.Image=collapsed and ICON["panel-left-open"]or ICON["panel-left-close"]tween(colIcon,0.15,{ImageTransparency=0})end)local w=collapsed and L.narrow or L.side local t=0.38 local a=collapsed and 1 or 0 tween(sidebar,t,{Size=UDim2.new(0,w,1,0)})tween(content,t,{Position=UDim2.fromOffset(w,0),Size=UDim2.new(1,-w,1,0)})tween(brandTitle,t*0.5,{TextTransparency=a})tween(brandSub,t*0.5,{TextTransparency=a})local badgeStroke=brandBadge:FindFirstChildOfClass("UIStroke")if collapsed then brandBadge.Visible=true end tween(brandBadge,t*0.6,{GroupTransparency=1-a})if badgeStroke then tween(badgeStroke,t*0.6,{Transparency=collapsed and 0.6 or 1})end if not collapsed then task.delay(t*0.6,function()if not collapsed then brandBadge.Visible=false end end)end tween(profName,t*0.5,{TextTransparency=a})tween(profSub,t*0.5,{TextTransparency=a})tween(profChev,t*0.5,{ImageTransparency=a})tween(pfp,t,{Position=UDim2.fromOffset(collapsed and AV_X_NARROW or AV_X,math.floor((L.profileH-avS)/2))})for _,tab in ipairs(tabOrder)do tween(tab.navLabel,t*0.5,{TextTransparency=a})end end STATE.connect(colBtn.MouseButton1Click,function()setCollapsed(not collapsed,true)end)if prefs.collapsed or(prefs.collapsed==nil and DEVICE=="Phone")then setCollapsed(true,false)end local CTRL={list={},byId={},hooks={},muted=false,swallow=false}do local function copy(v)return type(v)=="table"and table.clone(v)or v end function CTRL.register(kind,g,title,obj,r,o)local tab,sec=g.page.tab,g.page.sec local base=tostring(o.Flag or(tab.name.."/"..sec.name.."/"..title))local id,n=base,1 while CTRL.byId[id]do n+=1 id=base.."#"..n end local e={id=id,kind=kind,title=title,obj=obj,row=r,g=g,tab=tab,sec=sec,config=o.Config~=false and kind~="button",}e.default=copy(CTRL.get(e))CTRL.byId[id]=e table.insert(CTRL.list,e)if CTRL.attach then CTRL.attach(e)end return e end function CTRL.get(e)local v=e.obj and e.obj.Value if e.kind=="keybind"then return v or false end if e.kind=="button"then return nil end return copy(v)end function CTRL.set(e,v)if e.kind=="toggle"then e.obj:Set(v==true)elseif e.kind=="slider"then if tonumber(v)then e.obj:Set(tonumber(v))end elseif e.kind=="dropdown"then e.obj:Select(v)elseif e.kind=="keybind"then e.obj:Set(v~=false and v or nil)elseif e.kind=="input"then e.obj:Set(v)end end function CTRL.onChange(fn)table.insert(CTRL.hooks,fn)end function CTRL.changed(e)if not e then return end for _,fn in ipairs(CTRL.hooks)do pcall(fn,e,CTRL.muted)end end function CTRL.pointOf(input)if input.UserInputType==Enum.UserInputType.Touch then local inset=game:GetService("GuiService"):GetGuiInset()return Vector2.new(input.Position.X+inset.X,input.Position.Y+inset.Y)end return UIS:GetMouseLocation()end function CTRL.activeCount()local n=0 for _,e in ipairs(CTRL.list)do if e.kind=="toggle"and e.obj.Value and e.row.Parent then n+=1 end end return n end end local function group(page,caption)page.groups+=1 local holder=new("Frame",{Name=caption or"Group",LayoutOrder=page.groups,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},page.body)new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},holder)local card=new("Frame",{Name="Card",LayoutOrder=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.card,},holder)corner(card,K.radius)local cardStroke=stroke(card,T.cardLine)local cardLayout=new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},card)local g={page=page,card=card,holder=holder,rows=0,folded=false}table.insert(page.groupList,g)if caption then local key=page.tab.name.."/"..page.sec.name.."/"..caption local cap=new("TextButton",{Name="Caption",LayoutOrder=0,Size=UDim2.new(1,0,0,K.captionH),BackgroundTransparency=1,AutoButtonColor=false,Text="",},holder)local capLabel=new("TextLabel",{Size=UDim2.new(1,-px(24),1,0),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=K.caption,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Text=caption:upper(),},cap)local chevS=even(px(13))local chev=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(1,-px(10),0,-px(1)),Size=UDim2.fromOffset(chevS,chevS),BackgroundTransparency=1,Image=ICON["chevron-down"],ImageColor3=T.muted,},cap)local busy=0 function g.setFolded(on,animate)g.folded=on prefs.groups=type(prefs.groups)=="table"and prefs.groups or{}prefs.groups[key]=on or nil tween(chev,animate and 0.3 or 0,{Rotation=on and-90 or 0})busy+=1 local token=busy local s=math.max(pop.Scale,0.01)if on then local h=card.AbsoluteSize.Y/s card.AutomaticSize=Enum.AutomaticSize.None card.ClipsDescendants=true card.Size=UDim2.new(1,0,0,h)if not animate then card.Size,card.Visible=UDim2.new(1,0,0,0),false return end tween(cardStroke,0.2,{Transparency=1})local tw=tween(card,0.32,{Size=UDim2.new(1,0,0,0)})tw.Completed:Once(function()if busy==token and g.folded then card.Visible=false end end)else card.Visible=true card.ClipsDescendants=true task.spawn(function()RunService.Heartbeat:Wait()if busy~=token then return end local h=cardLayout.AbsoluteContentSize.Y/math.max(pop.Scale,0.01)cardStroke.Transparency=0 local tw=tween(card,animate and 0.36 or 0,{Size=UDim2.new(1,0,0,h)})tw.Completed:Once(function()if busy~=token or g.folded then return end card.AutomaticSize=Enum.AutomaticSize.Y card.ClipsDescendants=false end)end)end end function g.expand()if g.folded then g.setFolded(false,true)savePrefs()end end STATE.connect(cap.MouseButton1Click,function()g.setFolded(not g.folded,true)savePrefs()end)if HOVER then STATE.connect(cap.MouseEnter,function()tween(capLabel,0.15,{TextColor3=T.subtext})tween(chev,0.15,{ImageColor3=T.subtext})end)STATE.connect(cap.MouseLeave,function()tween(capLabel,0.2,{TextColor3=T.muted})tween(chev,0.2,{ImageColor3=T.muted})end)end if type(prefs.groups)=="table"and prefs.groups[key]then task.defer(function()g.setFolded(true,false)end)end end return g end local function row(g,title,desc,tags)g.rows+=1 local r=new("Frame",{Name=title,LayoutOrder=g.rows,Size=UDim2.new(1,0,0,K.rowMin),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},g.card)local hover=new("Frame",{Name="Hover",Position=UDim2.fromOffset(px(4),px(4)),Size=UDim2.new(1,-px(8),1,-px(8)),BackgroundColor3=T.rowHover,BackgroundTransparency=1,},r)corner(hover,K.radius-px(4))if g.rows>1 then new("Frame",{Name="Line",Position=UDim2.fromOffset(K.rowPad,0),Size=UDim2.new(1,-K.rowPad*2,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},r)end local slot=new("Frame",{Name="Control",AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-K.rowPad,0,0),Size=UDim2.fromOffset(0,K.ctrlH),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,ZIndex=2,},r)local col=new("Frame",{Name="Text",Position=UDim2.fromOffset(K.rowPad,0),Size=UDim2.new(1,-K.rowPad*2,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,ZIndex=2,},r)new("UIPadding",{PaddingTop=UDim.new(0,K.vPad),PaddingBottom=UDim.new(0,K.vPad)},col)new("UIListLayout",{Padding=UDim.new(0,px(3)),SortOrder=Enum.SortOrder.LayoutOrder},col)local line1=new("Frame",{Name="TitleLine",LayoutOrder=1,Size=UDim2.new(1,0,0,K.title+px(6)),BackgroundTransparency=1},col)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(7)),SortOrder=Enum.SortOrder.LayoutOrder},line1)local titleLabel=new("TextLabel",{Name="Title",LayoutOrder=0,Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=K.title,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=title,},line1)for i,t in ipairs(tags or{})do tag(line1,t,nil,i)end local descLabel if desc and desc~=""then descLabel=new("TextLabel",{Name="Desc",LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=K.desc,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text=desc,},col)end local function fit()local s=pop.Scale local cw=math.floor(slot.AbsoluteSize.X/s+0.5)col.Size=UDim2.new(1,-(K.rowPad*2+(cw>0 and cw+px(16)or 0)),0,0)local rh=math.floor(r.AbsoluteSize.Y/s+0.5)slot.Position=UDim2.new(1,-K.rowPad,0,math.floor((math.max(rh,K.rowMin)-K.ctrlH)/2))end STATE.connect(slot:GetPropertyChangedSignal("AbsoluteSize"),fit)STATE.connect(r:GetPropertyChangedSignal("AbsoluteSize"),fit)if HOVER then STATE.connect(r.MouseEnter,function()tween(hover,0.15,{BackgroundTransparency=0})end)STATE.connect(r.MouseLeave,function()tween(hover,0.25,{BackgroundTransparency=1})end)end task.defer(fit)table.insert(g.page.rows,{r=r,g=g,title=title,desc=(desc and desc:match("%S"))and desc or""})return r,slot,titleLabel,descLabel end local function rowHit(r)return new("TextButton",{Name="Hit",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,AutoButtonColor=false,Text="",ZIndex=5,},r)end local function toggle(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local tw_,th=even(px(44)),even(px(24))local inset=px(3)local ks=th-inset*2 local OFF_KNOB=Color3.fromRGB(196,202,216)local track=new("Frame",{Name="Switch",Position=UDim2.fromOffset(0,math.floor((K.ctrlH-th)/2)),Size=UDim2.fromOffset(tw_,th),BackgroundColor3=T.track,},slot)corner(track,th)local trackStroke=stroke(track,T.fieldLine)local knob=new("Frame",{Name="Knob",AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,inset,0.5,0),Size=UDim2.fromOffset(ks,ks),BackgroundColor3=OFF_KNOB,},track)corner(knob,ks)local hit=rowHit(r)local obj={Value=o.Value==true}local pressing=false local function paint(t)local on=obj.Value local goal={AnchorPoint=Vector2.new(on and 1 or 0,0.5),Position=UDim2.new(on and 1 or 0,on and-inset or inset,0.5,0),Size=UDim2.fromOffset(pressing and ks+px(6)or ks,ks),BackgroundColor3=on and knobOn()or OFF_KNOB,}if t<=0 then for k,v in pairs(goal)do knob[k]=v end track.BackgroundColor3=on and C.accent or T.track trackStroke.Color=on and C.accent or T.fieldLine return end tween(knob,t,goal)tween(track,t,{BackgroundColor3=on and C.accent or T.track})tween(trackStroke,t,{Color=on and C.accent or T.fieldLine})end function obj:Set(v)obj.Value=v==true paint(0.3)if o.Callback then task.spawn(o.Callback,obj.Value)end CTRL.changed(obj.entry)end paint(0)onThemeChanged(function()if track.Parent then paint(0.45)end end)local downAt STATE.connect(hit.InputBegan,function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then downAt=CTRL.pointOf(input)end end)STATE.connect(hit.MouseButton1Down,function()pressing=true paint(0.15)end)STATE.connect(hit.MouseLeave,function()if pressing then pressing=false paint(0.2)end end)STATE.connect(hit.MouseButton1Click,function()pressing=false if CTRL.swallow then paint(0.2)return end if CTRL.pinHit and CTRL.pinHit(obj.entry,downAt)then paint(0.2)return end obj:Set(not obj.Value)end)obj.entry=CTRL.register("toggle",g,title,obj,r,o)return obj end local function decimals(step)local s=tostring(step)local d=s:match("%.(%d+)$")return d and#d or 0 end local function slider(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local v=type(o.Value)=="table"and o.Value or{}local min,max=tonumber(v.Min)or 0,tonumber(v.Max)or 100 local step=tonumber(o.Step)or 1 local dec=decimals(step)local suffix=o.Suffix or""local obj={Value=math.clamp(tonumber(v.Default)or min,min,max)}local trackW,valueW=px(190),px(60)local holder=new("Frame",{Size=UDim2.fromOffset(trackW+px(12)+valueW,K.ctrlH),BackgroundTransparency=1},slot)local hit=new("TextButton",{Name="Track",Size=UDim2.fromOffset(trackW,K.ctrlH),BackgroundTransparency=1,AutoButtonColor=false,Text=""},holder)local trackH=even(px(6))local track=new("Frame",{Position=UDim2.fromOffset(0,math.floor((K.ctrlH-trackH)/2)),Size=UDim2.fromOffset(trackW,trackH),BackgroundColor3=T.track,BorderSizePixel=0,},hit)corner(track,trackH)local fill=new("Frame",{Name="Fill",Size=UDim2.fromScale(0,1),BackgroundColor3=C.accent,BorderSizePixel=0},track)corner(fill,trackH)local knobS=even(px(16))local knob=new("Frame",{Name="Knob",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(knobS,knobS),BackgroundColor3=WHITE,BorderSizePixel=0,ZIndex=2,},track)corner(knob,knobS)local ring=stroke(knob,C.accent,0.55,0)local pillH=even(px(26))local pill=new("Frame",{Position=UDim2.fromOffset(trackW+px(12),math.floor((K.ctrlH-pillH)/2)),Size=UDim2.fromOffset(valueW,pillH),BackgroundColor3=T.field,},holder)corner(pill,px(7))local pillStroke=stroke(pill,T.fieldLine)local valueBox=new("TextBox",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.mono,TextSize=px(12),TextColor3=T.text,ClearTextOnFocus=false,Text="",ClipsDescendants=true,},pill)local function paint(t)local a=max>min and(obj.Value-min)/(max-min)or 0 tween(fill,t,{Size=UDim2.fromScale(a,1)})tween(knob,t,{Position=UDim2.new(a,0,0.5,0)})if not valueBox:IsFocused()then valueBox.Text=string.format("%."..dec.."f",obj.Value)..suffix end end local function snap(x)x=math.clamp(tonumber(x)or min,min,max)x=min+math.floor((x-min)/step+0.5)*step return math.clamp(tonumber(string.format("%."..dec.."f",x)),min,max)end function obj:Set(x)x=snap(x)local changed=x~=obj.Value obj.Value=x paint(0.12)if changed and o.Callback then task.spawn(o.Callback,x)end if changed then CTRL.changed(obj.entry)end end paint(0)STATE.connect(valueBox.Focused,function()valueBox.Text=string.format("%."..dec.."f",obj.Value)valueBox.CursorPosition,valueBox.SelectionStart=#valueBox.Text+1,1 tween(pillStroke,0.15,{Color=C.accent})tween(pill,0.15,{BackgroundColor3=T.fieldHot})end)STATE.connect(valueBox.FocusLost,function()tween(pillStroke,0.2,{Color=T.fieldLine})tween(pill,0.2,{BackgroundColor3=T.field})local n=tonumber((valueBox.Text:gsub("[^%d%.%-]","")))if n then obj:Set(n)end paint(0.12)end)local dragging,hovering=false,false local function rest()local big=dragging or hovering tween(knob,0.2,{Size=UDim2.fromOffset(big and knobS+px(2)or knobS,big and knobS+px(2)or knobS)})tween(ring,0.2,{Thickness=dragging and px(5)or(hovering and px(3)or 0)})end local function fromMouse(x)obj:Set(min+math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)*(max-min))end STATE.connect(hit.MouseEnter,function()hovering=true rest()end)STATE.connect(hit.MouseLeave,function()hovering=false rest()end)STATE.connect(hit.InputBegan,function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true rest()fromMouse(input.Position.X)end end)STATE.connect(UIS.InputChanged,function(input)if dragging and(input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)then fromMouse(input.Position.X)end end)STATE.connect(UIS.InputEnded,function(input)if dragging and(input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch)then dragging=false rest()end end)obj.Display=function()return string.format("%."..dec.."f",obj.Value)..suffix end obj.entry=CTRL.register("slider",g,title,obj,r,o)return obj end local openPopup closePopup=function()if openPopup then local p=openPopup openPopup=nil p.close()end end STATE.connect(UIS.InputBegan,function(input)if not openPopup then return end if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end local m=UIS:GetMouseLocation()if input.UserInputType==Enum.UserInputType.Touch then local inset=game:GetService("GuiService"):GetGuiInset()m=Vector2.new(input.Position.X+inset.X,input.Position.Y+inset.Y)end local function inside(el)local a,s=el.AbsolutePosition,el.AbsoluteSize return m.X>=a.X and m.X<=a.X+s.X and m.Y>=a.Y and m.Y<=a.Y+s.Y end if not(inside(openPopup.list)or inside(openPopup.field))then closePopup()end end)local function dropdown(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local obj={Values=o.Values or{}}local multi=o.Multi==true local chosen local function setChosen(v)if multi then chosen={}if type(v)=="table"then for k,x in pairs(v)do local label=(type(k)=="string"and x==true)and k or x if label~=nil then chosen[label]=true end end elseif v~=nil then chosen[v]=true end else chosen=v end end setChosen(o.Value)if not multi and chosen==nil and not o.AllowNone then chosen=obj.Values[1]end local width=px(200)local field=new("TextButton",{Name="Dropdown",Size=UDim2.fromOffset(width,K.ctrlH),BackgroundColor3=T.field,AutoButtonColor=false,Text=""},slot)corner(field,px(9))local fieldStroke=stroke(field,T.fieldLine)local text=new("TextLabel",{Position=UDim2.fromOffset(px(12),0),Size=UDim2.new(1,-px(38),1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,},field)local chevS2=even(px(14))local chev=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(1,-px(18),0.5,0),Size=UDim2.fromOffset(chevS2,chevS2),BackgroundTransparency=1,Image=ICON["chevron-down"],ImageColor3=T.subtext,},field)local isOpen=false STATE.connect(field.MouseEnter,function()if not isOpen then tween(fieldStroke,0.15,{Color=T.fieldLineHot})end tween(field,0.15,{BackgroundColor3=T.fieldHot})end)STATE.connect(field.MouseLeave,function()if not isOpen then tween(fieldStroke,0.2,{Color=T.fieldLine})end tween(field,0.2,{BackgroundColor3=T.field})end)local function list()local out={}for _,v in ipairs(obj.Values)do if chosen[v]then table.insert(out,v)end end return out end local function refresh()if not multi then text.Text=chosen~=nil and tostring(chosen)or"None"return end local l=list()if#l>1 and#l==#obj.Values then text.Text=("All selected (%d)"):format(#l)return end text.Text=#l==0 and"None"or(#l==1 and tostring(l[1])or("%s +%d"):format(tostring(l[1]),#l-1))end refresh()obj.Value=multi and list()or chosen local function fire()obj.Value=multi and list()or chosen if o.Callback then task.spawn(o.Callback,obj.Value)end CTRL.changed(obj.entry)end obj.Display=function()return text.Text end local itemH=even(px(34))local function open()closePopup()isOpen=true local pos,size=inWindow(field)local pad=px(6)local searchable=o.Search==true or(o.Search~=false and#obj.Values>5)local sbH=even(px(34))local toolH=even(px(28))local headH=(searchable and sbH+pad or 0)+(multi and toolH+pad or 0)local listW=math.max(size.X,px(260))local want=pad+headH+math.max(1,math.min(#obj.Values,7))*itemH+pad local below=T.size.Y-px(10)-(pos.Y+size.Y+px(6))local above=pos.Y-px(6)-px(10)local up=below<want and above>below local fullH=math.min(want,math.max(up and above or below,pad*2+headH+itemH*2))local rest=UDim2.fromOffset(pos.X+size.X,up and(pos.Y-px(6))or(pos.Y+size.Y+px(6)))local shift=UDim2.fromOffset(0,up and px(6)or-px(6))local listFrame=new("CanvasGroup",{Name="DropdownList",AnchorPoint=Vector2.new(1,up and 1 or 0),Position=rest+shift,Size=UDim2.fromOffset(listW,fullH),BackgroundColor3=T.popup,GroupTransparency=1,},overlay)corner(listFrame,px(10))local listStroke=stroke(listFrame,T.fieldLineHot,1)local y0=pad local query if searchable then local sb=new("Frame",{Position=UDim2.fromOffset(pad,y0),Size=UDim2.new(1,-pad*2,0,sbH),BackgroundColor3=T.field,},listFrame)corner(sb,px(8))local sbStroke=stroke(sb,T.fieldLine)local qi=even(px(14))local qIcon=new("ImageLabel",{Position=UDim2.fromOffset(px(10),math.floor((sbH-qi)/2)),Size=UDim2.fromOffset(qi,qi),BackgroundTransparency=1,Image=ICON.search,ImageColor3=T.muted,},sb)local qx=px(10)+qi+px(8)query=new("TextBox",{Position=UDim2.fromOffset(qx,0),Size=UDim2.new(1,-(qx+sbH),1,0),BackgroundTransparency=1,ClearTextOnFocus=false,FontFace=T.font,TextSize=px(13),TextColor3=T.text,PlaceholderText=("Search %d items..."):format(#obj.Values),PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true,},sb)local clearQ=new("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(4),0.5,0),Size=UDim2.fromOffset(sbH-px(8),sbH-px(8)),BackgroundColor3=T.fieldHot,BackgroundTransparency=1,AutoButtonColor=false,Text="",Visible=false,},sb)corner(clearQ,px(6))local cx=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(12)),even(px(12))),BackgroundTransparency=1,Image=ICON.x,ImageColor3=T.muted,},clearQ)clearQ.MouseEnter:Connect(function()tween(clearQ,0.12,{BackgroundTransparency=0})tween(cx,0.12,{ImageColor3=T.text})end)clearQ.MouseLeave:Connect(function()tween(clearQ,0.15,{BackgroundTransparency=1})tween(cx,0.15,{ImageColor3=T.muted})end)clearQ.MouseButton1Click:Connect(function()query.Text=""end)query.Focused:Connect(function()tween(sbStroke,0.15,{Color=C.accent})tween(qIcon,0.15,{ImageColor3=C.accent})end)query.FocusLost:Connect(function()tween(sbStroke,0.2,{Color=T.fieldLine})tween(qIcon,0.2,{ImageColor3=T.muted})end)query:GetPropertyChangedSignal("Text"):Connect(function()clearQ.Visible=query.Text~=""end)y0+=sbH+pad end local countLabel,allBtn,noneBtn if multi then local bar=new("Frame",{Position=UDim2.fromOffset(pad,y0),Size=UDim2.new(1,-pad*2,0,toolH),BackgroundTransparency=1},listFrame)countLabel=new("TextLabel",{Position=UDim2.fromOffset(px(4),0),Size=UDim2.new(0.45,0,1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},bar)local btns=new("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.fromOffset(0,toolH),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,},bar)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(6)),SortOrder=Enum.SortOrder.LayoutOrder,},btns)local function toolButton(order,label)local b=new("TextButton",{LayoutOrder=order,Size=UDim2.fromOffset(0,toolH),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=T.field,AutoButtonColor=false,FontFace=T.fontSemi,TextSize=px(12),TextColor3=T.text,Text=label,},btns)corner(b,px(7))local st=stroke(b,T.fieldLine)new("UIPadding",{PaddingLeft=UDim.new(0,px(10)),PaddingRight=UDim.new(0,px(10))},b)local tb={btn=b,stroke=st,enabled=true}b.MouseEnter:Connect(function()if tb.enabled then tween(b,0.12,{BackgroundColor3=T.fieldHot})tween(st,0.12,{Color=T.fieldLineHot})end end)b.MouseLeave:Connect(function()tween(b,0.15,{BackgroundColor3=T.field})tween(st,0.15,{Color=T.fieldLine})end)return tb end allBtn=toolButton(1,"Select all")noneBtn=toolButton(2,"Clear")y0+=toolH+pad end if headH>0 then new("Frame",{Position=UDim2.fromOffset(0,y0-math.ceil(pad/2)),Size=UDim2.new(1,0,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},listFrame)end local top=headH>0 and y0 or 0 local scroller=new("ScrollingFrame",{Position=UDim2.fromOffset(0,top),Size=UDim2.new(1,0,1,-top),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=px(3),ScrollBarImageColor3=T.fieldLineHot,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,},listFrame)new("UIPadding",{PaddingTop=UDim.new(0,headH>0 and px(2)or pad),PaddingBottom=UDim.new(0,pad),PaddingLeft=UDim.new(0,pad),PaddingRight=UDim.new(0,pad),},scroller)new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},scroller)local emptyLabel=new("TextLabel",{LayoutOrder=#obj.Values+1,Size=UDim2.new(1,0,0,itemH*1.5),BackgroundTransparency=1,Visible=#obj.Values==0,FontFace=T.font,TextSize=px(13),TextColor3=T.muted,Text=#obj.Values==0 and"Nothing to choose"or"No matches",},scroller)local items={}local function isOn(v)if multi then return chosen[v]==true end return chosen==v end local boxS=even(px(16))for i,v in ipairs(obj.Values)do local item=new("TextButton",{Name=tostring(v),LayoutOrder=i,Size=UDim2.new(1,0,0,itemH),BackgroundColor3=T.rowActive,BackgroundTransparency=1,AutoButtonColor=false,Text="",},scroller)corner(item,px(7))local textX=multi and(px(10)+boxS+px(10))or px(10)local itemText=new("TextLabel",{Position=UDim2.fromOffset(textX,0),Size=UDim2.new(1,-(textX+px(30)),1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=isOn(v)and T.text or T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=tostring(v),TextTransparency=1,},item)local it={item=item,v=v,label=tostring(v):lower()}if multi then local box=new("Frame",{Position=UDim2.fromOffset(px(10),math.floor((itemH-boxS)/2)),Size=UDim2.fromOffset(boxS,boxS),BackgroundColor3=T.field,},item)corner(box,px(4))local bst=stroke(box,T.fieldLineHot)local tick=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(11)),even(px(11))),BackgroundTransparency=1,Image=ICON.check,ImageColor3=onAccent(),ImageTransparency=1,},box)it.paint=function(t)local on=isOn(v)tick.ImageColor3=onAccent()tween(box,t,{BackgroundColor3=on and C.accent or T.field})tween(bst,t,{Color=on and C.accent or T.fieldLineHot})tween(tick,t,{ImageTransparency=on and 0 or 1})tween(itemText,t,{TextColor3=(on or it.hover)and T.text or T.subtext})end else local markS=even(px(14))local mark=new("ImageLabel",{Size=UDim2.fromOffset(markS,markS),Position=UDim2.new(1,-px(22),0,math.floor((itemH-markS)/2)),BackgroundTransparency=1,Image=ICON.check,ImageColor3=C.accent,ImageTransparency=1,},item)it.paint=function(t)local on=isOn(v)tween(mark,t,{ImageTransparency=on and 0 or 1})tween(itemText,t,{TextColor3=(on or it.hover)and T.text or T.subtext})end end it.paint(0)task.delay(0.02*math.min(i,8),function()if itemText.Parent then tween(itemText,0.25,{TextTransparency=0})end end)items[i]=it item.MouseEnter:Connect(function()it.hover=true tween(item,0.12,{BackgroundTransparency=0})it.paint(0.12)end)item.MouseLeave:Connect(function()it.hover=false tween(item,0.18,{BackgroundTransparency=1})it.paint(0.18)end)end local function updateTools()if not multi then return end local filtered=query~=nil and query.Text~=""local shown,shownOn=0,0 for _,it in ipairs(items)do if it.item.Visible then shown+=1 if chosen[it.v]then shownOn+=1 end end end countLabel.Text=("%d / %d selected"):format(#list(),#obj.Values)allBtn.btn.Text=filtered and"Select shown"or"Select all"noneBtn.btn.Text=filtered and"Clear shown"or"Clear"allBtn.enabled=shownOn<shown noneBtn.enabled=shownOn>0 for _,tb in ipairs({allBtn,noneBtn})do tween(tb.btn,0.15,{TextColor3=tb.enabled and T.text or T.muted,BackgroundTransparency=tb.enabled and 0 or 0.5})end end local function chooseShown(on)for _,it in ipairs(items)do if it.item.Visible then chosen[it.v]=on or nil it.paint(0.18)end end refresh()fire()updateTools()end if multi then allBtn.btn.MouseButton1Click:Connect(function()if allBtn.enabled then chooseShown(true)end end)noneBtn.btn.MouseButton1Click:Connect(function()if noneBtn.enabled then chooseShown(false)end end)end for _,it in ipairs(items)do it.item.MouseButton1Click:Connect(function()if multi then chosen[it.v]=not chosen[it.v]or nil it.paint(0.15)refresh()fire()updateTools()else chosen=it.v refresh()fire()closePopup()end end)end if query then query:GetPropertyChangedSignal("Text"):Connect(function()local q=query.Text:lower():gsub("^%s+",""):gsub("%s+$","")local any=false for _,it in ipairs(items)do it.item.Visible=q==""or it.label:find(q,1,true)~=nil any=any or it.item.Visible end emptyLabel.Visible=not any scroller.CanvasPosition=Vector2.new()updateTools()end)query.FocusLost:Connect(function(enter)if not enter or multi then return end for _,it in ipairs(items)do if it.item.Visible then chosen=it.v refresh()fire()closePopup()return end end end)if UIS.KeyboardEnabled then task.defer(function()if query.Parent then query:CaptureFocus()end end)end end updateTools()tween(listFrame,0.3,{Position=rest})tween(listFrame,0.2,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(listStroke,0.2,{Transparency=0})tween(chev,0.28,{Rotation=180})tween(fieldStroke,0.15,{Color=C.accent})openPopup={list=listFrame,field=field,close=function()isOpen=false if query and query:IsFocused()then query:ReleaseFocus()end tween(chev,0.22,{Rotation=0})tween(fieldStroke,0.2,{Color=T.fieldLine})tween(listStroke,0.15,{Transparency=1})tween(listFrame,0.18,{Position=rest+shift})local tw=tween(listFrame,0.15,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()listFrame:Destroy()end)end,}end STATE.connect(field.MouseButton1Click,function()if CTRL.swallow then return end if openPopup and openPopup.field==field then closePopup()else open()end end)function obj:Select(v)setChosen(v)refresh()fire()end function obj:Refresh(values)obj.Values=values or{}if multi then local keep={}for _,x in ipairs(obj.Values)do if chosen[x]then keep[x]=true end end chosen=keep elseif not table.find(obj.Values,chosen)then chosen=obj.Values[1]end refresh()end function obj:SelectAll()if not multi then return end if openPopup and openPopup.field==field then closePopup()end for _,v in ipairs(obj.Values)do chosen[v]=true end refresh()fire()end function obj:Clear()if openPopup and openPopup.field==field then closePopup()end if multi then chosen={}else chosen=nil end refresh()fire()end obj.entry=CTRL.register("dropdown",g,title,obj,r,o)return obj end local KEYNAMES={LeftShift="LShift",RightShift="RShift",LeftControl="LCtrl",RightControl="RCtrl",LeftAlt="LAlt",RightAlt="RAlt",MouseButton2="RMB",MouseButton3="MMB"}local function keybind(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local obj={Value=typeof(o.Value)=="EnumItem"and o.Value.Name or o.Value,Picking=false}local btn=new("TextButton",{Name="Keybind",Size=UDim2.fromOffset(px(96),K.ctrlH),BackgroundColor3=T.field,AutoButtonColor=false,Text=""},slot)corner(btn,px(9))local st=stroke(btn,T.fieldLine)local label=new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.mono,TextSize=px(12),TextColor3=T.text},btn)local function paint()if obj.Picking then label.Text,label.TextColor3="...",C.accent else label.Text=obj.Value and(KEYNAMES[obj.Value]or obj.Value)or"None"label.TextColor3=obj.Value and T.text or T.muted end tween(st,0.2,{Color=obj.Picking and C.accent or T.fieldLine})tween(btn,0.2,{BackgroundColor3=obj.Picking and T.fieldHot or T.field})end function obj:Set(k)obj.Value=typeof(k)=="EnumItem"and k.Name or((type(k)=="string"and k~="")and k or nil)paint()if o.Callback then task.spawn(o.Callback,obj.Value)end CTRL.changed(obj.entry)end obj.Display=function()return label.Text end paint()STATE.connect(btn.MouseEnter,function()if not obj.Picking then tween(st,0.15,{Color=T.fieldLineHot})end end)STATE.connect(btn.MouseLeave,function()if not obj.Picking then tween(st,0.2,{Color=T.fieldLine})end end)STATE.connect(btn.MouseButton1Click,function()if obj.Picking then return end obj.Picking=true capture.active=true paint()end)STATE.connect(UIS.InputBegan,function(input)if not obj.Picking then return end local kc=input.KeyCode local mb=input.UserInputType==Enum.UserInputType.MouseButton2 or input.UserInputType==Enum.UserInputType.MouseButton3 if kc==Enum.KeyCode.Unknown and not mb then return end task.defer(function()obj.Picking=false capture.active=false paint()end)if kc==Enum.KeyCode.Escape then return end if kc==Enum.KeyCode.Backspace then obj:Set(nil)return end obj.Value=mb and input.UserInputType.Name or kc.Name if o.Callback then task.spawn(o.Callback,obj.Value)end CTRL.changed(obj.entry)end)obj.entry=CTRL.register("keybind",g,title,obj,r,o)return obj end local function paragraph(g,o)local title,tags=parseTitle(o.Title)local _,_,titleLabel,descLabel=row(g,title,(o.Desc and o.Desc~="")and o.Desc or" ",tags)local obj={}function obj:SetDesc(t)if descLabel then descLabel.Text=tostring(t or"")end end function obj:SetTitle(t)titleLabel.Text=(parseTitle(t))end return obj end local function input(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local f=new("Frame",{Name="Input",Size=UDim2.fromOffset(px(o.Width or 200),K.ctrlH),BackgroundColor3=T.field},slot)corner(f,px(9))local st=stroke(f,T.fieldLine)local box=new("TextBox",{Position=UDim2.fromOffset(px(10),0),Size=UDim2.new(1,-px(20),1,0),BackgroundTransparency=1,ClearTextOnFocus=o.ClearOnFocus==true,FontFace=T.font,TextSize=px(13),TextColor3=T.text,PlaceholderText=tostring(o.Placeholder or""),PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true,},f)local function clean(v)if o.Numeric then local n=tonumber(v)or tonumber(o.Value)or tonumber(o.Min)or 0 if tonumber(o.Min)then n=math.max(n,tonumber(o.Min))end if tonumber(o.Max)then n=math.min(n,tonumber(o.Max))end return n end v=tostring(v==nil and""or v)local m=tonumber(o.MaxLength)if m and#v>m then v=v:sub(1,m)end return v end local obj={Value=clean(o.Value)}box.Text=tostring(obj.Value)local function commit(fire)local v=clean(box.Text)local changed=v~=obj.Value obj.Value=v if not box:IsFocused()then box.Text=tostring(v)end if fire and o.Callback then task.spawn(o.Callback,v)end if changed then CTRL.changed(obj.entry)end end function obj:Set(v)box.Text=tostring(clean(v))commit(true)end function obj:Get()return obj.Value end obj.Display=function()return tostring(obj.Value)end obj.Box=box STATE.connect(box.Focused,function()tween(st,0.15,{Color=C.accent})tween(f,0.15,{BackgroundColor3=T.fieldHot})end)STATE.connect(box.FocusLost,function()tween(st,0.2,{Color=T.fieldLine})tween(f,0.2,{BackgroundColor3=T.field})if not o.Live then commit(true)end end)if o.Live then STATE.connect(box:GetPropertyChangedSignal("Text"),function()if box:IsFocused()then commit(true)end end)end obj.entry=CTRL.register("input",g,title,obj,r,o)return obj end local function keyValue(g,o)local title,tags=parseTitle(o.Title)local _,slot=row(g,title,o.Desc,tags)local val=new("TextLabel",{Size=UDim2.fromOffset(0,K.ctrlH),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,FontFace=T.mono,TextSize=px(13),TextColor3=o.Color or T.subtext,TextXAlignment=Enum.TextXAlignment.Right,Text=tostring(o.Value==nil and""or o.Value),},slot)local obj={Value=o.Value,Label=val}function obj:Set(v)obj.Value=v val.Text=tostring(v==nil and""or v)end function obj:Get()return obj.Value end function obj:SetColor(c)val.TextColor3=c end return obj end local function label(g,o)g.rows+=1 local f=new("Frame",{Name="Label",LayoutOrder=g.rows,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},g.card)if g.rows>1 then new("Frame",{Name="Line",Position=UDim2.fromOffset(K.rowPad,0),Size=UDim2.new(1,-K.rowPad*2,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},f)end new("UIPadding",{PaddingTop=UDim.new(0,px(11)),PaddingBottom=UDim.new(0,px(11)),PaddingLeft=UDim.new(0,K.rowPad),PaddingRight=UDim.new(0,K.rowPad),},f)local text=tostring(o.Text or o.Title or"")local l=new("TextLabel",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=o.Bold and T.fontSemi or T.font,TextSize=K.desc+1,TextColor3=o.Color or T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,RichText=true,Text=text,},f)table.insert(g.page.rows,{r=f,g=g,title=text:gsub("<[^>]+>",""),desc=""})local obj={Frame=f,Label=l}function obj:Set(t)l.Text=tostring(t==nil and""or t)end function obj:SetColor(c)l.TextColor3=c end return obj end local function button(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local s=K.ctrlH local b=new("Frame",{Name="Run",Size=UDim2.fromOffset(s,s),BackgroundColor3=T.field},slot)corner(b,px(9))local st=stroke(b,T.fieldLine)local icS=even(px(15))local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=icon(o.Icon or"play"),ImageColor3=T.subtext,},b)local icScale=new("UIScale",{},ic)local hit=rowHit(r)STATE.connect(hit.MouseEnter,function()tween(b,0.15,{BackgroundColor3=T.fieldHot})tween(st,0.15,{Color=C.accent,Transparency=0.4})tween(ic,0.15,{ImageColor3=C.accent})end)STATE.connect(hit.MouseLeave,function()tween(b,0.2,{BackgroundColor3=T.field})tween(st,0.2,{Color=T.fieldLine,Transparency=0})tween(ic,0.2,{ImageColor3=T.subtext})tween(icScale,0.2,{Scale=1})end)local obj={}function obj.Run()tween(icScale,0.4,{Scale=1},Enum.EasingStyle.Back)b.BackgroundColor3=C.accent:Lerp(T.field,0.55)tween(b,0.45,{BackgroundColor3=T.fieldHot})if o.Callback then task.spawn(o.Callback)end end local downAt STATE.connect(hit.InputBegan,function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then downAt=CTRL.pointOf(input)end end)STATE.connect(hit.MouseButton1Down,function()tween(icScale,0.1,{Scale=0.82})end)STATE.connect(hit.MouseButton1Click,function()if CTRL.swallow then tween(icScale,0.2,{Scale=1})return end if CTRL.pinHit and CTRL.pinHit(obj.entry,downAt)then tween(icScale,0.2,{Scale=1})return end obj.Run()end)obj.entry=CTRL.register("button",g,title,obj,r,o)return obj end local notify do local toastHolder=new("Frame",{Name="Toasts",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(20),1,-px(20)),Size=UDim2.fromOffset(px(330),0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},gui)new("UIListLayout",{Padding=UDim.new(0,px(10)),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Bottom},toastHolder)local toastN=0 local function toastColor(name)if name=="check"or name=="package-check"or name=="circle-check"then return C.green end if name=="triangle-alert"or name=="alert-triangle"then return C.amber end if name=="x"then return C.red end return C.accent end function notify(o)toastN+=1 local col=toastColor(o.Icon)local wrap=new("Frame",{LayoutOrder=toastN,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},toastHolder)local card=new("CanvasGroup",{Position=UDim2.fromOffset(px(40),0),Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.popup,GroupTransparency=1,},wrap)corner(card,px(12))local cardStroke=stroke(card,T.fieldLine,1)local inner=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},card)new("UIPadding",{PaddingTop=UDim.new(0,px(14)),PaddingBottom=UDim.new(0,px(16)),PaddingLeft=UDim.new(0,px(54)),PaddingRight=UDim.new(0,px(14))},inner)new("UIListLayout",{Padding=UDim.new(0,px(3)),SortOrder=Enum.SortOrder.LayoutOrder},inner)local badgeS=even(px(28))local badge=new("Frame",{Position=UDim2.fromOffset(px(14),px(14)),Size=UDim2.fromOffset(badgeS,badgeS),BackgroundColor3=col,BackgroundTransparency=0.82},card)corner(badge,px(8))new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(14)),even(px(14))),BackgroundTransparency=1,Image=icon(o.Icon),ImageColor3=col:Lerp(WHITE,0.2),},badge)new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,px(18)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(14),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=tostring(o.Title or"Mono"),},inner)if o.Content and o.Content~=""then new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text=tostring(o.Content),},inner)end local duration=tonumber(o.Duration)or 4 local bar=new("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.fromScale(0,1),Size=UDim2.new(1,0,0,px(2)),BackgroundColor3=col,BackgroundTransparency=0.25,BorderSizePixel=0,ZIndex=2,},card)local hit=new("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=3},card)tween(card,0.5,{Position=UDim2.fromOffset(0,0)})tween(card,0.3,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(cardStroke,0.3,{Transparency=0})tween(bar,duration,{Size=UDim2.new(0,0,0,px(2))},Enum.EasingStyle.Linear)local gone=false local function dismiss()if gone or not wrap.Parent then return end gone=true tween(cardStroke,0.2,{Transparency=1})tween(card,0.25,{GroupTransparency=1},Enum.EasingStyle.Quad)local tw=tween(card,0.3,{Position=UDim2.fromOffset(px(40),0)})tw.Completed:Once(function()local h=wrap.AbsoluteSize.Y wrap.AutomaticSize=Enum.AutomaticSize.None wrap.Size=UDim2.new(1,0,0,h)card.Visible=false local fold=tween(wrap,0.22,{Size=UDim2.new(1,0,0,0)})fold.Completed:Once(function()wrap:Destroy()end)end)end hit.MouseButton1Click:Connect(dismiss)task.delay(duration,dismiss)end end local function popup(o)local shade=new("TextButton",{Name="Popup",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,AutoButtonColor=false,Text="",ZIndex=30,},hostOf(window))corner(shade,T.radius)tween(shade,0.25,{BackgroundTransparency=0.4})local card=new("CanvasGroup",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(px(o.Width or 380),0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.popup,GroupTransparency=1,},shade)corner(card,px(14))local cardStroke=stroke(card,T.fieldLineHot,1)local sc=new("UIScale",{Scale=0.9},card)new("UIPadding",{PaddingTop=UDim.new(0,px(22)),PaddingBottom=UDim.new(0,px(18)),PaddingLeft=UDim.new(0,px(22)),PaddingRight=UDim.new(0,px(22))},card)new("UIListLayout",{Padding=UDim.new(0,px(8)),SortOrder=Enum.SortOrder.LayoutOrder},card)new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,px(22)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(18),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=tostring(o.Title or""),},card)if o.Content and o.Content~=""then new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=px(14),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text=tostring(o.Content),},card)end if type(o.Build)=="function"then local extra=new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},card)new("UIPadding",{PaddingTop=UDim.new(0,px(6))},extra)local ok,err=pcall(o.Build,extra)if not ok then warn("[SPECTREWARE] popup Build failed:",err)end end local rowF=new("Frame",{LayoutOrder=4,Size=UDim2.new(1,0,0,px(46)),BackgroundTransparency=1},card)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=Enum.VerticalAlignment.Bottom,Padding=UDim.new(0,px(8)),SortOrder=Enum.SortOrder.LayoutOrder},rowF)tween(sc,0.4,{Scale=1},Enum.EasingStyle.Back)tween(card,0.25,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(cardStroke,0.25,{Transparency=0})local closing=false local function close()if closing then return end closing=true tween(sc,0.18,{Scale=0.95})tween(cardStroke,0.15,{Transparency=1})tween(card,0.15,{GroupTransparency=1},Enum.EasingStyle.Quad)local tw=tween(shade,0.22,{BackgroundTransparency=1})tw.Completed:Once(function()shade:Destroy()end)end for i,b in ipairs(o.Buttons or{})do local primary=b.Variant=="Primary"local label=tostring(b.Title or"OK")local rest=primary and C.accent or T.field local hot=primary and C.accent:Lerp(WHITE,0.15)or T.fieldHot local btn=new("TextButton",{LayoutOrder=i,Size=UDim2.fromOffset(textW(label,px(13),T.fontBold)+px(32),even(px(34))),BackgroundColor3=rest,AutoButtonColor=false,Text="",},rowF)corner(btn,px(9))if not primary then stroke(btn,T.fieldLine)end new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(13),TextColor3=primary and onAccent()or T.text,Text=label,},btn)btn.MouseEnter:Connect(function()tween(btn,0.15,{BackgroundColor3=hot})end)btn.MouseLeave:Connect(function()tween(btn,0.2,{BackgroundColor3=rest})end)btn.MouseButton1Click:Connect(function()close()if b.Callback then task.spawn(b.Callback)end end)end shade.MouseButton1Click:Connect(function()end)end local jumpTo local FEAT=(function()local F={}local GuiService=game:GetService("GuiService")local function store(name)prefs[name]=type(prefs[name])=="table"and prefs[name]or{}if type(prefs[name][GAME_KEY])~="table"then prefs[name][GAME_KEY]={}end return prefs[name][GAME_KEY]end local function pinList()local raw=store("pins")local out,seen={},{}for _,v in pairs(raw)do if type(v)=="string"and not seen[v]then seen[v]=true table.insert(out,v)end end if#out~=#raw then prefs.pins[GAME_KEY]=out end return prefs.pins[GAME_KEY]end local function keyLabel(k)return KEYNAMES[k]or k end local pinHooks={}function F.isPinned(e)return table.find(pinList(),e.id)~=nil end function F.bindOf(e)return store("binds")[e.id]end function F.paintTags(e)local col=e.row:FindFirstChild("Text")local line=col and col:FindFirstChild("TitleLine")if not line then return end local pinTag=line:FindFirstChild("PinTag")if not pinTag then pinTag=new("ImageButton",{Name="PinTag",LayoutOrder=50,Size=UDim2.fromOffset(even(px(15)),even(px(15))),BackgroundTransparency=1,Image=ICON.pin,ImageColor3=C.accent,Visible=false,AutoButtonColor=false,ZIndex=6,},line)pinTag.MouseEnter:Connect(function()pinTag.Image=ICON["pin-off"]tween(pinTag,0.12,{ImageColor3=C.red})end)pinTag.MouseLeave:Connect(function()pinTag.Image=ICON.pin tween(pinTag,0.15,{ImageColor3=C.accent})end)pinTag.MouseButton1Click:Connect(function()F.setPinned(e,false)end)end pinTag.Visible=F.isPinned(e)local keyTag=line:FindFirstChild("KeyTag")if not keyTag then keyTag=new("Frame",{Name="KeyTag",LayoutOrder=51,Size=UDim2.fromOffset(0,even(px(18))),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=T.field,Visible=false,},line)corner(keyTag,px(5))stroke(keyTag,T.fieldLineHot)new("UIPadding",{PaddingLeft=UDim.new(0,px(6)),PaddingRight=UDim.new(0,px(6))},keyTag)new("TextLabel",{Name="Key",Size=UDim2.fromScale(0,1),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,FontFace=T.mono,TextSize=px(10),TextColor3=T.subtext,Text="",},keyTag)end local k=F.bindOf(e)keyTag.Visible=k~=nil if k then keyTag.Key.Text=keyLabel(k)end end CTRL.attach=function(e)if F.isPinned(e)or F.bindOf(e)then F.paintTags(e)end end CTRL.pinHit=function(e,pt)if not e or not pt then return false end local col=e.row:FindFirstChild("Text")local line=col and col:FindFirstChild("TitleLine")local pin=line and line:FindFirstChild("PinTag")if not pin or not pin.Visible then return false end local a,sz=pin.AbsolutePosition,pin.AbsoluteSize local pad=4 if pt.X>=a.X-pad and pt.X<=a.X+sz.X+pad and pt.Y>=a.Y-pad and pt.Y<=a.Y+sz.Y+pad then F.setPinned(e,false)return true end return false end function F.setPinned(e,on)local pins=pinList()if on then if not table.find(pins,e.id)then table.insert(pins,e.id)end else for i=#pins,1,-1 do if pins[i]==e.id then table.remove(pins,i)end end end savePrefs()local ok,err=pcall(F.paintTags,e)if not ok then warn("[SPECTREWARE] pin mark:",err)end for _,fn in ipairs(pinHooks)do local ok2,err2=pcall(fn)if not ok2 then warn("[SPECTREWARE] Quick Toggles refresh:",err2)end end notify({Title=on and"Pinned to Home"or"Unpinned",Content=e.title,Icon=on and"check"or"info",Duration=2,})end function F.pinned()local out={}for _,id in ipairs(pinList())do local e=CTRL.byId[id]if e and e.row.Parent then table.insert(out,e)end end return out end function F.setBind(e,keyName)local binds=store("binds")if keyName then for id,k in pairs(binds)do if k==keyName and id~=e.id then binds[id]=nil if CTRL.byId[id]then F.paintTags(CTRL.byId[id])end end end end binds[e.id]=keyName savePrefs()F.paintTags(e)end local listening function F.listen(e)if listening then return end listening=e capture.active=true notify({Title="Bind a key",Content=('Press a key for "%s".  Esc cancels, Backspace removes it.'):format(e.title),Icon="keyboard",Duration=4,})end STATE.connect(UIS.InputBegan,function(input,processed)if not mine()then return end local kc=input.KeyCode if listening then if kc==Enum.KeyCode.Unknown then return end local e=listening listening=nil task.defer(function()capture.active=false end)if kc==Enum.KeyCode.Escape then return end if kc==Enum.KeyCode.Backspace then F.setBind(e,nil)notify({Title="Key removed",Content=e.title,Icon="info",Duration=2})return end if kc==T.toggleKey then notify({Title="Key in use",Content=("[%s] opens the menu. Pick another key."):format(kc.Name),Icon="triangle-alert",Duration=3})return end F.setBind(e,kc.Name)notify({Title="Key bound",Content=("[%s]  →  %s"):format(keyLabel(kc.Name),e.title),Icon="check",Duration=3})return end if processed or capture.active or kc==Enum.KeyCode.Unknown then return end if UIS:GetFocusedTextBox()then return end for id,k in pairs(store("binds"))do if k==kc.Name then local e=CTRL.byId[id]if e and e.row.Parent then if e.kind=="toggle"then e.obj:Set(not e.obj.Value)elseif e.kind=="button"then e.obj.Run()end end end end end)local quickTiles={}local function menuFor(e,at)closePopup()local items={}local pinned=F.isPinned(e)table.insert(items,{pinned and"pin-off"or"pin",pinned and"Unpin from Home"or"Pin to Home",function()F.setPinned(e,not pinned)end})if UIS.KeyboardEnabled and(e.kind=="toggle"or e.kind=="button")then local k=F.bindOf(e)table.insert(items,{"keyboard",k and("Change key  ["..keyLabel(k).."]")or"Bind a key",function()F.listen(e)end})if k then table.insert(items,{"x","Remove key",function()F.setBind(e,nil)notify({Title="Key removed",Content=e.title,Icon="info",Duration=2})end})end end if e.kind~="button"then table.insert(items,{"rotate-ccw","Reset to default",function()CTRL.set(e,e.default)end})end local pad,headH,itemH,w=px(6),px(28),even(px(36)),px(230)local h=pad*2+headH+#items*itemH local s=math.max(pop.Scale,0.01)local p=(at-window.AbsolutePosition)/s local x=math.clamp(p.X,px(6),math.max(px(6),T.size.X-w-px(6)))local y=math.clamp(p.Y,px(6),math.max(px(6),T.size.Y-h-px(6)))local frame=new("CanvasGroup",{Name="ContextMenu",Position=UDim2.fromOffset(x,y-px(6)),Size=UDim2.fromOffset(w,h),BackgroundColor3=T.popup,GroupTransparency=1,},overlay)corner(frame,px(10))local st=stroke(frame,T.fieldLineHot,1)local sc=new("UIScale",{Scale=0.96},frame)local list=new("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1},frame)new("UIPadding",{PaddingTop=UDim.new(0,pad),PaddingBottom=UDim.new(0,pad),PaddingLeft=UDim.new(0,pad),PaddingRight=UDim.new(0,pad)},list)new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},list)local head=new("TextLabel",{LayoutOrder=0,Size=UDim2.new(1,0,0,headH),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=e.title:upper(),},list)new("UIPadding",{PaddingLeft=UDim.new(0,px(10)),PaddingRight=UDim.new(0,px(10))},head)local close for i,it in ipairs(items)do local b=new("TextButton",{LayoutOrder=i,Size=UDim2.new(1,0,0,itemH),BackgroundColor3=T.rowActive,BackgroundTransparency=1,AutoButtonColor=false,Text="",},list)corner(b,px(7))local icS=even(px(15))local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(10),0.5,0),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=icon(it[1]),ImageColor3=T.subtext,},b)new("TextLabel",{Position=UDim2.fromOffset(px(10)+icS+px(10),0),Size=UDim2.new(1,-(px(20)+icS+px(10)),1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=it[2],},b)b.MouseEnter:Connect(function()tween(b,0.12,{BackgroundTransparency=0})tween(ic,0.12,{ImageColor3=C.accent})end)b.MouseLeave:Connect(function()tween(b,0.15,{BackgroundTransparency=1})tween(ic,0.15,{ImageColor3=T.subtext})end)b.MouseButton1Click:Connect(function()if CTRL.swallow then return end close()task.spawn(it[3])end)end tween(frame,0.28,{Position=UDim2.fromOffset(x,y)})tween(frame,0.18,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(st,0.18,{Transparency=0})tween(sc,0.3,{Scale=1},Enum.EasingStyle.Back)local closing=false local function shut()if closing then return end closing=true tween(st,0.12,{Transparency=1})tween(sc,0.15,{Scale=0.97})local tw=tween(frame,0.14,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()frame:Destroy()end)end openPopup={list=frame,field=frame,close=shut}close=function()if openPopup and openPopup.list==frame then closePopup()else shut()end end end local function entryAt(pt)if not shown or not currentPage then return nil end local function inside(gui_)local a,sz=gui_.AbsolutePosition,gui_.AbsoluteSize return pt.X>=a.X and pt.X<=a.X+sz.X and pt.Y>=a.Y and pt.Y<=a.Y+sz.Y end if openPopup and inside(openPopup.list)then return nil end if not inside(currentPage.wrap)then return nil end for tile,e in pairs(quickTiles)do if tile.Parent and inGroup(tile,currentPage.wrap)and inside(tile)then return e end end for _,e in ipairs(CTRL.list)do if e.sec.page==currentPage and e.row.Parent and e.row.Visible and e.g.card.Visible and inside(e.row)then return e end end return nil end STATE.connect(UIS.InputBegan,function(input)if input.UserInputType~=Enum.UserInputType.MouseButton2 or not mine()then return end local pt=UIS:GetMouseLocation()local e=entryAt(pt)if e then menuFor(e,pt)end end)do local presses={}local swallowBy,swallowToken=nil,0 local function release()swallowToken+=1 local my=swallowToken task.delay(0.2,function()if swallowToken==my then CTRL.swallow,swallowBy=false,nil end end)end STATE.connect(UIS.InputBegan,function(input)if input.UserInputType~=Enum.UserInputType.Touch or not mine()then return end local p={start=Vector2.new(input.Position.X,input.Position.Y),moved=false}presses[input]=p task.delay(0.5,function()if presses[input]~=p or p.moved or input.UserInputState==Enum.UserInputState.End then return end local inset=GuiService:GetGuiInset()local pt=p.start+Vector2.new(inset.X,inset.Y)local e=entryAt(pt)if e then CTRL.swallow,swallowBy=true,input swallowToken+=1 local my=swallowToken task.delay(1.5,function()if swallowToken==my then CTRL.swallow,swallowBy=false,nil end end)menuFor(e,pt)end end)end)STATE.connect(UIS.InputChanged,function(input)local p=presses[input]if p and(Vector2.new(input.Position.X,input.Position.Y)-p.start).Magnitude>10 then p.moved=true end end)STATE.connect(UIS.InputEnded,function(input)if not presses[input]then return end presses[input]=nil if swallowBy==input then release()end end)end local canFile=(writefile and readfile and isfile and listfiles and makefolder and isfolder)and true or false local ROOT,DIR="MonoUI/configs","MonoUI/configs/"..GAME_KEY local memory={}local function ensureDir()pcall(function()if not isfolder("MonoUI")then makefolder("MonoUI")end if not isfolder(ROOT)then makefolder(ROOT)end if not isfolder(DIR)then makefolder(DIR)end end)end local function clean(name)name=tostring(name or""):gsub('[%c\\/:%*%?"<>|%.]',""):gsub("^%s+",""):gsub("%s+$","")local len=utf8.len(name)if len and len>32 then name=name:sub(1,utf8.offset(name,33)-1)end return name end local function file(name)return DIR.."/"..name..".json"end local cfg={refresh=function()end,current=nil}local function when(t)t=tonumber(t)if not t then return nil end local d=math.max(0,os.time()-t)if d<60 then return"just now"end if d<3600 then return math.floor(d/60).." min ago"end if d<86400 then return math.floor(d/3600).." h ago"end local ok,s=pcall(function()return DateTime.fromUnixTimestamp(t):FormatLocalTime("D MMM YYYY","en-us")end)return ok and s or(math.floor(d/86400).." days ago")end function cfg.names()local out={}if canFile then pcall(function()ensureDir()for _,f in ipairs(listfiles(DIR))do local n=tostring(f):gsub("\\","/"):match("([^/]+)%.json$")if n then table.insert(out,n)end end end)else for n in pairs(memory)do table.insert(out,n)end end table.sort(out,function(a,b)return a:lower()<b:lower()end)return out end function cfg.exists(name)return table.find(cfg.names(),clean(name))~=nil end function cfg.read(name)local data if canFile then pcall(function()data=HttpService:JSONDecode(readfile(file(name)))end)else data=memory[name]end return(type(data)=="table"and type(data.values)=="table")and data or nil end function cfg.list()local out={}for _,n in ipairs(cfg.names())do local d=cfg.read(n)local count=0 if d then for _ in pairs(d.values)do count+=1 end end table.insert(out,{name=n,ok=d~=nil,count=count,savedAt=d and d.savedAt,theme=d and type(d.ui)=="table"and d.ui.theme or nil,})end return out end function cfg.save(name)name=clean(name)if name==""then notify({Title="Config",Content="Type a name first.",Icon="triangle-alert",Duration=3})return false end local values,n={},0 for _,e in ipairs(CTRL.list)do if e.config and e.row.Parent then values[e.id]=CTRL.get(e)n+=1 end end local data={version=2,name=name,savedAt=os.time(),values=values,ui={theme=currentTheme,custom=prefs.custom},}if canFile then local ok=pcall(function()ensureDir()writefile(file(name),HttpService:JSONEncode(data))end)if not ok then notify({Title="Config",Content="Could not write the file.",Icon="triangle-alert"})return false end else memory[name]=data end cfg.current=name notify({Title="Config saved",Content=('"%s"  ·  %d settings + theme'):format(name,n),Icon="check",Duration=3})cfg.refresh()return true end function cfg.load(name,quiet)local data=cfg.read(name)if not data then notify({Title="Config",Content=('Could not read "%s".'):format(name),Icon="triangle-alert"})return false end CTRL.muted=true local n=0 for id,v in pairs(data.values)do local e=CTRL.byId[id]if e and e.config then pcall(CTRL.set,e,v)n+=1 end end CTRL.muted=false local ui=type(data.ui)=="table"and data.ui or nil if ui then local cu=type(ui.custom)=="table"and ui.custom or nil if cu and HEX.to(cu.accent)then addTheme("Custom",HEX.to(cu.base)or THEMES.Custom.palette.bg,HEX.to(cu.accent))prefs.custom=cu end if ui.theme and THEMES[ui.theme]then pcall(applyTheme,ui.theme,true,true,ui.theme=="Custom")end end cfg.current=name for _,fn in ipairs(CTRL.hooks)do pcall(fn,nil,false)end if F.islandFlash then F.islandFlash("folder-open",('Loaded "%s"'):format(name),C.accent)end if not quiet then notify({Title="Config loaded",Content=('"%s"  ·  %d settings'):format(name,n),Icon="check",Duration=3})end cfg.refresh()return true end function cfg.delete(name)if canFile then pcall(function()if delfile and isfile(file(name))then delfile(file(name))end end)else memory[name]=nil end if cfg.current==name then cfg.current=nil end if cfg.autoload()==name then cfg.setAutoload(nil,true)end notify({Title="Config deleted",Content=name,Icon="info",Duration=2})cfg.refresh()end function cfg.autoload()local a=prefs.autoConfig return type(a)=="table"and a[GAME_KEY]or nil end function cfg.setAutoload(name,quiet)prefs.autoConfig=type(prefs.autoConfig)=="table"and prefs.autoConfig or{}prefs.autoConfig[GAME_KEY]=name savePrefs()cfg.refresh()if not quiet then notify({Title=name and"Auto-load on"or"Auto-load off",Content=name and('"%s" will load by itself when you join this game.'):format(name)or"Nothing loads when you join.",Icon=name and"check"or"info",Duration=3,})end end cfg.words={new="New config",desc="Saves every setting for this game under a name.",placeholder="Config name",list="Saved configs",empty="No configs yet",emptyDesc="Name one above and press Save.",auto="Loads when you join this game.",}TAGS["Auto-load"],TAGS["Loaded"]=C.green,C.blue local function actButton(parent,order,iconName,text,style)local h=K.ctrlH local w=text and(textW(text,px(12),T.fontBold)+px(38))or h local b=new("TextButton",{LayoutOrder=order,Size=UDim2.fromOffset(w,h),AutoButtonColor=false,Text=""},parent)corner(b,px(9))local st=stroke(b,T.fieldLine)local icS=even(px(13))local ic=new("ImageLabel",{AnchorPoint=Vector2.new(text and 0 or 0.5,0.5),Position=text and UDim2.new(0,px(11),0.5,0)or UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=icon(iconName),},b)local lb=text and new("TextLabel",{Position=UDim2.fromOffset(px(28),0),Size=UDim2.new(1,-px(32),1,0),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(12),TextXAlignment=Enum.TextXAlignment.Left,Text=text,},b)local function paint(hot)local bg,ink,line,lineT if style=="primary"then bg,ink,line,lineT=hot and C.accent:Lerp(WHITE,0.15)or C.accent,onAccent(),C.accent,1 elseif style=="on"then bg,ink,line,lineT=hot and T.fieldHot or T.field,C.green,C.green,0.35 else bg,ink,line,lineT=hot and T.fieldHot or T.field,(style=="danger"and hot)and C.red or T.text,hot and T.fieldLineHot or T.fieldLine,0 end tween(b,0.15,{BackgroundColor3=bg})tween(st,0.15,{Color=line,Transparency=lineT})ic.ImageColor3=ink if lb then lb.TextColor3=ink end end paint(false)b.MouseEnter:Connect(function()paint(true)end)b.MouseLeave:Connect(function()paint(false)end)return b end function F.configPage(tabObj)local page=tabObj.page local function hlist(slot)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,px(6)),VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,},slot)end local gSave=tabObj:Group("Save")local _,s1=row(gSave,"Save current settings","Every setting on every page, plus UI scale, window opacity, blur, menu key and theme.")hlist(s1)local box=new("TextBox",{LayoutOrder=1,Size=UDim2.fromOffset(px(170),K.ctrlH),ClearTextOnFocus=false,BackgroundColor3=T.field,FontFace=T.font,TextSize=px(13),TextColor3=T.text,PlaceholderText="Config name",PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,},s1)corner(box,px(9))local boxStroke=stroke(box,T.fieldLine)new("UIPadding",{PaddingLeft=UDim.new(0,px(10)),PaddingRight=UDim.new(0,px(10))},box)box.Focused:Connect(function()tween(boxStroke,0.15,{Color=C.accent})end)box.FocusLost:Connect(function()tween(boxStroke,0.2,{Color=T.fieldLine})end)local saveB=actButton(s1,2,"save","Save","primary")local function doSave()local name=clean(box.Text)if name==""then notify({Title="Config",Content="Type a name first.",Icon="triangle-alert",Duration=3})return end local function go()if cfg.save(name)then box.Text=""end end if cfg.exists(name)then popup({Title="Replace config?",Content=('"%s" already exists. Replace it with your current settings?'):format(name),Buttons={{Title="Cancel"},{Title="Replace",Variant="Primary",Callback=go}},})else go()end end saveB.MouseButton1Click:Connect(doSave)box.FocusLost:Connect(function(enter)if enter then doSave()end end)local gAuto=tabObj:Group("Auto-load")local _,s2,_,autoDesc=row(gAuto,"Load a config when you join"," ")hlist(s2)local offB=actButton(s2,1,"x","Turn off","normal")offB.MouseButton1Click:Connect(function()cfg.setAutoload(nil)end)local gList=tabObj:Group("Saved configs")local capButton=gList.holder:FindFirstChild("Caption")local capLabel=capButton and capButton:FindFirstChildWhichIsA("TextLabel")local function rebuild()for _,c in ipairs(gList.card:GetChildren())do if c:IsA("Frame")then c:Destroy()end end gList.rows=0 local keep={}for _,it in ipairs(page.rows)do if it.g~=gList then table.insert(keep,it)end end page.rows=keep local auto=cfg.autoload()autoDesc.Text=auto and('On: "%s" loads by itself every time you join this game.'):format(auto)or"Off. Press Set auto-load on a config below to load it every time you join."autoDesc.TextColor3=auto and C.green or T.muted offB.Visible=auto~=nil local list=cfg.list()if capLabel then capLabel.Text=("SAVED CONFIGS (%d)"):format(#list)end if#list==0 then row(gList,"No configs yet","Type a name above and press Save.")return end for _,it in ipairs(list)do local name=it.name local isAuto=name==auto local tags={}if isAuto then table.insert(tags,"Auto-load")end if name==cfg.current then table.insert(tags,"Loaded")end local bits={it.ok and(it.count.." settings")or"can't read this file"}local w=when(it.savedAt)if w then table.insert(bits,"saved "..w)end if it.theme then table.insert(bits,it.theme.." theme")end local _,s=row(gList,name,table.concat(bits,"  ·  "),tags)hlist(s)local loadB=actButton(s,1,"folder-open","Load","primary")local autoB=actButton(s,2,isAuto and"check"or"star",isAuto and"Auto-load on"or"Set auto-load",isAuto and"on"or"normal")local overB=actButton(s,3,"save",nil,"icon")local delB=actButton(s,4,"trash-2",nil,"danger")loadB.MouseButton1Click:Connect(function()cfg.load(name)end)autoB.MouseButton1Click:Connect(function()cfg.setAutoload((not isAuto)and name or nil)end)overB.MouseButton1Click:Connect(function()popup({Title="Update config?",Content=('Replace "%s" with your current settings?'):format(name),Buttons={{Title="Cancel"},{Title="Update",Variant="Primary",Callback=function()cfg.save(name)end}},})end)delB.MouseButton1Click:Connect(function()popup({Title="Delete config?",Content=('Delete "%s"? This cannot be undone.'):format(name)..(isAuto and" Auto-load will be turned off."or""),Buttons={{Title="Cancel"},{Title="Delete",Variant="Primary",Callback=function()cfg.delete(name)end}},})end)end end cfg.refresh=rebuild local themeToken=0 onThemeChanged(function()themeToken+=1 local my=themeToken task.delay(0.4,function()if my==themeToken then rebuild()end end)end)rebuild()end F.config,F.canFile=cfg,canFile function F.autoload()local n=cfg.autoload()if n and cfg.exists(n)then cfg.load(n,true)end end function F.quickCard(body,order,CP)local card=new("Frame",{Name="QuickToggles",LayoutOrder=order,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.card,},body)corner(card,K.radius)stroke(card,T.cardLine)local inner=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},card)new("UIPadding",{PaddingTop=UDim.new(0,CP-px(2)),PaddingBottom=UDim.new(0,CP),PaddingLeft=UDim.new(0,CP),PaddingRight=UDim.new(0,CP)},inner)new("UIListLayout",{Padding=UDim.new(0,px(12)),SortOrder=Enum.SortOrder.LayoutOrder},inner)local head=new("Frame",{LayoutOrder=1,Size=UDim2.new(1,0,0,px(16)),BackgroundTransparency=1},inner)local s13=even(px(13))new("ImageLabel",{Size=UDim2.fromOffset(s13,s13),BackgroundTransparency=1,Image=ICON.pin,ImageColor3=T.muted},head)new("TextLabel",{Position=UDim2.fromOffset(s13+px(6),0),Size=UDim2.new(0.6,0,1,0),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text="QUICK TOGGLES",},head)local count=new("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.new(0.4,0,1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Right,Text="",},head)local empty=new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text=(UIS.KeyboardEnabled and"Right-click"or"Long-press").." any setting and choose Pin to Home to keep it here.",},inner)local grid=new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},inner)local gap,cellH=px(10),px(60)new("UIGridLayout",{CellSize=UDim2.new(1/3,-math.ceil(gap*2/3),0,cellH),CellPadding=UDim2.fromOffset(gap,gap),SortOrder=Enum.SortOrder.LayoutOrder,},grid)local tiles={}local function tile(e,i)local b=new("TextButton",{Name=e.title,LayoutOrder=i,BackgroundColor3=T.field,AutoButtonColor=false,Text=""},grid)corner(b,px(10))local st=stroke(b,T.fieldLine)local icS=even(px(15))local ic=new("ImageLabel",{Position=UDim2.fromOffset(px(12),px(11)),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=e.sec.pillIcon.Image,ImageColor3=T.subtext,},b)local unS=even(px(22))new("TextLabel",{Position=UDim2.new(0,px(12),1,-px(26)),Size=UDim2.new(1,-(px(24)+unS),0,px(16)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(13),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=e.title,},b)local un=new("ImageButton",{Name="Unpin",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(6),1,-px(6)),Size=UDim2.fromOffset(unS,unS),BackgroundColor3=T.fieldHot,BackgroundTransparency=HOVER and 1 or 0.3,Image="",AutoButtonColor=false,ZIndex=3,},b)corner(un,px(6))local unIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(12)),even(px(12))),BackgroundTransparency=1,Image=ICON["pin-off"],ImageColor3=T.muted,ImageTransparency=HOVER and 1 or 0,ZIndex=4,},un)local overTile,overUn=false,false local function showUn()if not HOVER then return end local on=overTile or overUn tween(un,0.15,{BackgroundTransparency=on and 0.3 or 1})tween(unIcon,0.15,{ImageTransparency=on and 0 or 1,ImageColor3=overUn and C.red or T.muted})end b.MouseEnter:Connect(function()overTile=true showUn()end)b.MouseLeave:Connect(function()overTile=false task.defer(showUn)end)un.MouseEnter:Connect(function()overUn=true showUn()end)un.MouseLeave:Connect(function()overUn=false task.defer(showUn)end)un.MouseButton1Click:Connect(function()if CTRL.swallow then return end F.setPinned(e,false)end)local paint if e.kind=="toggle"then local sw,sh=even(px(30)),even(px(17))local track=new("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-px(10),0,px(10)),Size=UDim2.fromOffset(sw,sh),BackgroundColor3=T.track,},b)new("UICorner",{CornerRadius=UDim.new(1,0)},track)local ks=sh-px(4)local knob=new("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(2),0.5,0),Size=UDim2.fromOffset(ks,ks),BackgroundColor3=Color3.fromRGB(196,202,216),},track)new("UICorner",{CornerRadius=UDim.new(1,0)},knob)paint=function(t)local on=e.obj.Value tween(track,t,{BackgroundColor3=on and C.accent or T.track})tween(knob,t,{AnchorPoint=Vector2.new(on and 1 or 0,0.5),Position=UDim2.new(on and 1 or 0,on and-px(2)or px(2),0.5,0),BackgroundColor3=on and knobOn()or Color3.fromRGB(196,202,216),})tween(st,t,{Color=on and C.accent or T.fieldLine,Transparency=on and 0.4 or 0})tween(ic,t,{ImageColor3=on and C.accent or T.subtext})end else local right=new("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-px(10),0,px(9)),Size=UDim2.new(0.6,0,0,px(16)),BackgroundTransparency=1,FontFace=T.mono,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Right,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},b)paint=function()if e.kind=="button"then right.Text="RUN"else right.Text=e.obj.Display and e.obj.Display()or""end end end b.MouseEnter:Connect(function()tween(b,0.12,{BackgroundColor3=T.fieldHot})end)b.MouseLeave:Connect(function()tween(b,0.18,{BackgroundColor3=T.field})end)b.MouseButton1Click:Connect(function()if CTRL.swallow then return end if e.kind=="toggle"then e.obj:Set(not e.obj.Value)elseif e.kind=="button"then e.obj.Run()elseif jumpTo then jumpTo(e)end end)tiles[e]={paint=paint,frame=b}quickTiles[b]=e end local function rebuild()for b in pairs(quickTiles)do if b:IsDescendantOf(grid)then quickTiles[b]=nil end end for _,c in ipairs(grid:GetChildren())do if c:IsA("GuiObject")then c:Destroy()end end table.clear(tiles)local list=F.pinned()for i,e in ipairs(list)do tile(e,i)end for _,t in pairs(tiles)do t.paint(0)end empty.Visible,grid.Visible=#list==0,#list>0 count.Text=#list>0 and(#list.." pinned")or""end table.insert(pinHooks,rebuild)CTRL.onChange(function(e)if e==nil then for _,t in pairs(tiles)do t.paint(0.2)end elseif tiles[e]then tiles[e].paint(0.2)end end)onThemeChanged(function()for _,t in pairs(tiles)do t.paint(0.3)end end)rebuild()return rebuild end return F end)()do(function()local SUG={max=7,itemH=even(px(50)),w=px(380),head=px(28),foot=px(32)}local sug local recent={}local suppressSearch=false local function esc(s)return(s:gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"))end local function hex(c)return("#%02X%02X%02X"):format(math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))end local function highlight(title,q)local i,j=title:lower():find(q,1,true)if q==""or not i then return esc(title)end return esc(title:sub(1,i-1))..('<font color="%s">'):format(hex(C.accent))..esc(title:sub(i,j)).."</font>"..esc(title:sub(j+1))end local function pageItem(tab)return{kind="Page",title=tab.name,desc="",path="Page",icon=tab.icon,tab=tab}end local function buildIndex()local out={}for _,tab in ipairs(tabOrder)do table.insert(out,pageItem(tab))local multi=#tab.secOrder>=2 for _,sec in ipairs(tab.secOrder)do if multi then table.insert(out,{kind="Section",title=sec.name,desc="",path=tab.name,icon=sec.pillIcon.Image,tab=tab,sec=sec})end for _,it in ipairs(sec.page.rows)do if it.r.Parent and it.title and it.title~=""then table.insert(out,{kind="Setting",title=it.title,desc=it.desc or"",icon=sec.pillIcon.Image,path=multi and(tab.name.."  ›  "..sec.name)or tab.name,tab=tab,sec=sec,target=it.r,group=it.g,})end end end end return out end local function fuzzy(t:string,q:string):boolean q=q:gsub("%s+","")if#q<3 then return false end local j=1 for k=1,#t do if t:sub(k,k)==q:sub(j,j)then j+=1 if j>#q then return true end end end return false end local function score(item,q)local t=item.title:lower()local s=0 if t==q then s=1000 else local i=t:find(q,1,true)if i==1 then s=700 elseif i then s=t:sub(i-1,i-1):match("[%s%p]")and 500 or 350 else local hay=t.." "..item.desc:lower().." "..item.path:lower()local all=true for w in q:gmatch("%S+")do if not hay:find(w,1,true)then all=false break end end if all then s=200 elseif fuzzy(t,q)then s=80 end end end if s==0 then return 0 end if item.kind=="Page"then s+=30 elseif item.kind=="Section"then s+=15 end return s-#t*0.5 end local function results(q)local out={}if q==""then for _,it in ipairs(recent)do if tabs[it.tab.name]==it.tab and(not it.target or it.target.Parent)then table.insert(out,it)end end if#out>0 then return out,"Recent"end for _,tab in ipairs(tabOrder)do table.insert(out,pageItem(tab))if#out>=SUG.max then break end end return out,"Jump to"end local scored={}for _,item in ipairs(buildIndex())do local s=score(item,q)if s>0 then item.score=s table.insert(scored,item)end end table.sort(scored,function(a,b)return a.score>b.score end)for i=1,math.min(#scored,SUG.max)do out[i]=scored[i]end return out,#scored>0 and(#scored==1 and"1 result"or(#scored.." results"))or nil end local function pushRecent(item)for i=#recent,1,-1 do local r=recent[i]if r.kind==item.kind and r.tab==item.tab and r.sec==item.sec and r.target==item.target then table.remove(recent,i)end end table.insert(recent,1,item)if#recent>5 then table.remove(recent)end end local function reveal(target,page)RunService.Heartbeat:Wait()RunService.Heartbeat:Wait()if not target.Parent or not page or currentPage~=page then return end local s=pop.Scale local scroll=page.scroll local y=(target.AbsolutePosition.Y-scroll.AbsolutePosition.Y)/s+scroll.CanvasPosition.Y local maxY=math.max(0,(scroll.AbsoluteCanvasSize.Y-scroll.AbsoluteWindowSize.Y)/s)tween(scroll,0.55,{CanvasPosition=Vector2.new(0,math.clamp(y-px(60),0,maxY))})local flash=new("Frame",{Name="Flash",Position=UDim2.fromOffset(px(2),px(2)),Size=UDim2.new(1,-px(4),1,-px(4)),BackgroundColor3=C.accent,BackgroundTransparency=1,ZIndex=0,},target)corner(flash,K.radius-px(2))local fs=stroke(flash,C.accent,1)tween(flash,0.3,{BackgroundTransparency=0.86})tween(fs,0.3,{Transparency=0.25})task.delay(1.1,function()tween(flash,0.7,{BackgroundTransparency=1})local tw=tween(fs,0.7,{Transparency=1})tw.Completed:Once(function()flash:Destroy()end)end)end local function paintSel()if not sug then return end for i,it in ipairs(sug.items)do local on=i==sug.sel tween(it.btn,0.15,{BackgroundTransparency=on and 0 or 1})tween(it.icon,0.15,{ImageColor3=on and C.accent or T.subtext})tween(it.arrow,0.2,{ImageTransparency=on and 0 or 1,Position=UDim2.new(1,on and-px(12)or-px(18),0.5,0)})tween(it.kind,0.15,{TextTransparency=on and 1 or 0})end end local pick local function renderSuggest()if not sug then return end local q=searchBox.Text:lower():gsub("^%s+",""):gsub("%s+$","")local list,heading=results(q)sug.results,sug.sel,sug.items=list,1,{}for _,c in ipairs(sug.list:GetChildren())do if c:IsA("GuiObject")then c:Destroy()end end local h=px(6)*2 if heading then local head=new("TextLabel",{LayoutOrder=0,Size=UDim2.new(1,0,0,SUG.head),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text=heading:upper(),},sug.list)new("UIPadding",{PaddingLeft=UDim.new(0,px(10))},head)h+=SUG.head end if#list==0 then new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,px(64)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.muted,TextWrapped=true,Text=('No results for "%s"'):format(q),},sug.list)h+=px(64)end local boxS,icS=even(px(32)),even(px(15))local tx=px(9)+boxS+px(12)for i,item in ipairs(list)do local btn=new("TextButton",{Name=item.title,LayoutOrder=i,Size=UDim2.new(1,0,0,SUG.itemH),BackgroundColor3=T.rowActive,BackgroundTransparency=1,AutoButtonColor=false,Text="",},sug.list)corner(btn,px(9))local box=new("Frame",{Position=UDim2.fromOffset(px(9),math.floor((SUG.itemH-boxS)/2)),Size=UDim2.fromOffset(boxS,boxS),BackgroundColor3=T.field,},btn)corner(box,px(8))stroke(box,T.fieldLine)local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=item.icon or ICON.circle,ImageColor3=T.subtext,},box)new("TextLabel",{Position=UDim2.fromOffset(tx,px(8)),Size=UDim2.new(1,-(tx+px(76)),0,px(18)),BackgroundTransparency=1,RichText=true,FontFace=T.fontSemi,TextSize=px(14),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=highlight(item.title,q),},btn)local sub=item.kind=="Setting"and item.path or(item.kind=="Section"and(item.path.."  ›  section")or"Open page")if item.kind=="Setting"and item.desc~=""then sub=sub.."  ·  "..item.desc end new("TextLabel",{Position=UDim2.fromOffset(tx,px(27)),Size=UDim2.new(1,-(tx+px(36)),0,px(15)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=sub,},btn)local kind=new("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-px(12),0,px(9)),Size=UDim2.fromOffset(px(60),px(16)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(10),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Right,Text=item.kind:upper(),},btn)local arrow=new("ImageLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(18),0.5,0),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=ICON["chevron-right"],ImageColor3=C.accent,ImageTransparency=1,},btn)local idx=i btn.MouseEnter:Connect(function()if sug and sug.sel~=idx then sug.sel=idx paintSel()end end)btn.MouseButton1Click:Connect(function()pick(item)end)sug.items[i]={btn=btn,icon=ic,arrow=arrow,kind=kind}h+=SUG.itemH end local foot=new("Frame",{LayoutOrder=100,Size=UDim2.new(1,0,0,SUG.foot),BackgroundTransparency=1},sug.list)new("Frame",{Position=UDim2.fromOffset(px(4),px(4)),Size=UDim2.new(1,-px(8),0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0},foot)new("TextLabel",{Position=UDim2.fromOffset(px(10),px(5)),Size=UDim2.new(1,-px(20),1,-px(5)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text=UIS.KeyboardEnabled and"Up / Down to move   ·   Enter to open   ·   Esc to close"or"Tap a result to open it",},foot)h+=SUG.foot if sug.fresh then sug.fresh=false sug.frame.Size=UDim2.fromOffset(SUG.w,h)else tween(sug.frame,0.3,{Size=UDim2.fromOffset(SUG.w,h)})end paintSel()end local function closeSuggestPanel()local s=sug sug=nil if not s then return end tween(s.stroke,0.15,{Transparency=1})tween(s.frame,0.18,{Position=s.rest-UDim2.fromOffset(0,px(6))})local tw=tween(s.frame,0.15,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()s.frame:Destroy()end)end local function openSuggest()if sug then renderSuggest()return end closePopup()local pos,size=inWindow(search)local rest=UDim2.fromOffset(pos.X+size.X,pos.Y+size.Y+px(8))local frame=new("CanvasGroup",{Name="SearchSuggest",AnchorPoint=Vector2.new(1,0),Position=rest-UDim2.fromOffset(0,px(6)),Size=UDim2.fromOffset(SUG.w,px(100)),BackgroundColor3=T.popup,GroupTransparency=1,},overlay)corner(frame,px(12))local st=stroke(frame,T.fieldLineHot,1)local list=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},frame)new("UIPadding",{PaddingTop=UDim.new(0,px(6)),PaddingBottom=UDim.new(0,px(6)),PaddingLeft=UDim.new(0,px(6)),PaddingRight=UDim.new(0,px(6)),},list)new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},list)sug={frame=frame,stroke=st,rest=rest,list=list,items={},results={},sel=1,fresh=true}openPopup={list=frame,field=search,close=closeSuggestPanel}renderSuggest()tween(frame,0.32,{Position=rest})tween(frame,0.22,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(st,0.22,{Transparency=0})end local function hideSuggest()if sug and openPopup and openPopup.list==sug.frame then closePopup()else closeSuggestPanel()end end pick=function(item)pushRecent(item)hideSuggest()suppressSearch=true searchBox.Text=""suppressSearch=false if searchBox:IsFocused()then searchBox:ReleaseFocus()end if tabs[item.tab.name]~=item.tab then return end selectTab(item.tab.name)if item.sec then selectSection(item.tab.name,item.sec.name)end if item.group and item.group.expand then item.group.expand()end if item.target then local page=item.sec and item.sec.page task.spawn(reveal,item.target,page)end end jumpTo=function(e)pick({kind="Setting",title=e.title,desc="",path=e.tab.name,icon=e.sec.pillIcon.Image,tab=e.tab,sec=e.sec,target=e.row,group=e.g,})end STATE.connect(searchBox.Focused,function()if not suppressSearch then openSuggest()end end)STATE.connect(searchBox:GetPropertyChangedSignal("Text"),function()if suppressSearch then return end if searchBox:IsFocused()or searchBox.Text~=""then openSuggest()end end)STATE.connect(searchBox.FocusLost,function(enter)if enter then local item=sug and sug.results[sug.sel]if item then pick(item)else hideSuggest()end elseif UIS:IsKeyDown(Enum.KeyCode.Escape)then hideSuggest()end end)STATE.connect(UIS.InputBegan,function(input,processed)if not mine()then return end if sug and searchBox:IsFocused()then if input.KeyCode==Enum.KeyCode.Down then sug.sel=math.min(#sug.results,sug.sel+1)paintSel()elseif input.KeyCode==Enum.KeyCode.Up then sug.sel=math.max(1,sug.sel-1)paintSel()end return end if processed or not shown or capture.active then return end if input.KeyCode==Enum.KeyCode.F and(UIS:IsKeyDown(Enum.KeyCode.LeftControl)or UIS:IsKeyDown(Enum.KeyCode.RightControl))then task.defer(function()searchBox:CaptureFocus()end)end end)end)()end local function themePicker(g)g.rows+=1 local holder=new("Frame",{Name="Themes",LayoutOrder=g.rows,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},g.card)if g.rows>1 then new("Frame",{Name="Line",Position=UDim2.fromOffset(K.rowPad,0),Size=UDim2.new(1,-K.rowPad*2,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},holder)end local inner=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},holder)new("UIPadding",{PaddingTop=UDim.new(0,K.vPad),PaddingBottom=UDim.new(0,px(16)),PaddingLeft=UDim.new(0,K.rowPad),PaddingRight=UDim.new(0,K.rowPad),},inner)new("UIListLayout",{Padding=UDim.new(0,px(3)),SortOrder=Enum.SortOrder.LayoutOrder},inner)new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,K.title+px(4)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=K.title,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text="Theme",},inner)new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=K.desc,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text="Pick a colour theme for the menu. Your choice is remembered next time.",},inner)local gridWrap=new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},inner)new("UIPadding",{PaddingTop=UDim.new(0,px(10))},gridWrap)local grid=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},gridWrap)local gap,cellH=px(10),px(96)new("UIGridLayout",{CellSize=UDim2.new(1/3,-math.ceil(gap*2/3),0,cellH),CellPadding=UDim2.fromOffset(gap,gap),SortOrder=Enum.SortOrder.LayoutOrder,},grid)local tiles={}local function paintTiles(t)for name,tl in pairs(tiles)do local on=name==currentTheme local p=THEMES[name].palette tween(tl.stroke,t,{Color=on and p.accent or(tl.hover and p.fieldLineHot or p.border),Thickness=on and 2 or 1})tween(tl.check,t,{BackgroundTransparency=on and 0 or 1})tween(tl.checkIcon,t,{ImageTransparency=on and 0 or 1})end end local pv,labelH=px(7),px(26)local function buildTile(name,i)if tiles[name]and tiles[name].frame then tiles[name].frame:Destroy()end local p=THEMES[name].palette local tile=new("TextButton",{Name=name,LayoutOrder=i,BackgroundColor3=p.bg,AutoButtonColor=false,Text=""},grid)tile:SetAttribute("MonoNoTheme",true)corner(tile,px(10))local st=stroke(tile,p.border)local sideF=new("Frame",{Position=UDim2.fromOffset(pv,pv),Size=UDim2.new(0.26,0,1,-(pv+labelH)),BackgroundColor3=p.side,},tile)corner(sideF,px(5))stroke(sideF,p.divider)for j=1,3 do local bar=new("Frame",{Position=UDim2.new(0,px(5),0,px(6)+(j-1)*px(9)),Size=UDim2.new(1,-px(10),0,px(5)),BackgroundColor3=j==1 and p.accent or p.track,BorderSizePixel=0,},sideF)corner(bar,px(2))end local mainF=new("Frame",{Position=UDim2.new(0.26,pv+px(5),0,pv),Size=UDim2.new(0.74,-(pv*2+px(5)),1,-(pv+labelH)),BackgroundColor3=p.card,},tile)corner(mainF,px(5))stroke(mainF,p.cardLine)for j,w in ipairs({0.6,0.38})do local line=new("Frame",{Position=UDim2.fromOffset(px(7),px(7)+(j-1)*px(9)),Size=UDim2.new(w,0,0,px(5)),BackgroundColor3=j==1 and p.fieldLineHot or p.fieldLine,BorderSizePixel=0,},mainF)corner(line,px(2))end local sw=new("Frame",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(6),1,-px(6)),Size=UDim2.fromOffset(px(20),px(11)),BackgroundColor3=p.accent,},mainF)new("UICorner",{CornerRadius=UDim.new(1,0)},sw)local kn=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(2),0.5,0),Size=UDim2.fromOffset(px(7),px(7)),BackgroundColor3=lum(p.accent)>0.8 and p.bg or WHITE,},sw)new("UICorner",{CornerRadius=UDim.new(1,0)},kn)new("TextLabel",{Position=UDim2.new(0,px(10),1,-labelH),Size=UDim2.new(1,-px(36),0,labelH-px(2)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(13),TextColor3=p.text,TextXAlignment=Enum.TextXAlignment.Left,Text=name,},tile)local checkS=even(px(16))local check=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(9),1,-math.floor(labelH/2)-px(1)),Size=UDim2.fromOffset(checkS,checkS),BackgroundColor3=p.accent,BackgroundTransparency=1,},tile)new("UICorner",{CornerRadius=UDim.new(1,0)},check)local checkIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(10)),even(px(10))),BackgroundTransparency=1,Image=ICON.check,ImageColor3=p.bg,ImageTransparency=1,},check)local tl={stroke=st,check=check,checkIcon=checkIcon,frame=tile}tiles[name]=tl tile.MouseEnter:Connect(function()tl.hover=true paintTiles(0.18)end)tile.MouseLeave:Connect(function()tl.hover=false paintTiles(0.22)end)tile.MouseButton1Click:Connect(function()applyTheme(name,true,true)end)end for i,name in ipairs(THEME_ORDER)do buildTile(name,i)end paintTiles(0)onThemeChanged(function()paintTiles(0.35)end)table.insert(g.page.rows,{r=holder,g=g,title="Theme",desc="Colour theme, appearance, colors"})local cr=new("Frame",{LayoutOrder=4,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},inner)new("UIPadding",{PaddingTop=UDim.new(0,px(14))},cr)new("UIListLayout",{Padding=UDim.new(0,px(4)),SortOrder=Enum.SortOrder.LayoutOrder},cr)new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,K.title+px(4)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=K.title,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text="Custom accent",},cr)new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=K.desc,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text="Drag the colour bar or type a hex code. It becomes the Custom theme.",},cr)local barRow=new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,px(40)),BackgroundTransparency=1},cr)local hexW=px(118)local hue=new("TextButton",{Name="Hue",AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(8),0.5,0),Size=UDim2.new(1,-(hexW+px(24)),0,even(px(14))),BackgroundColor3=WHITE,AutoButtonColor=false,Text="",},barRow)hue:SetAttribute("MonoNoTheme",true)new("UICorner",{CornerRadius=UDim.new(1,0)},hue)do local keys={}for k=0,6 do table.insert(keys,ColorSequenceKeypoint.new(k/6,Color3.fromHSV((k%6)/6,0.62,1)))end new("UIGradient",{Color=ColorSequence.new(keys)},hue)end local knobS=even(px(22))local hueKnob=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0,0.5),Size=UDim2.fromOffset(knobS,knobS),BackgroundColor3=THEMES.Custom.palette.accent,},hue)new("UICorner",{CornerRadius=UDim.new(1,0)},hueKnob)stroke(hueKnob,WHITE,0,2)local hexF=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.fromScale(1,0.5),Size=UDim2.fromOffset(hexW,even(px(32))),BackgroundColor3=T.field,},barRow)corner(hexF,px(8))local hexStroke=stroke(hexF,T.fieldLine)local swS=even(px(14))local swatch=new("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(10),0.5,0),Size=UDim2.fromOffset(swS,swS),BackgroundColor3=THEMES.Custom.palette.accent,},hexF)swatch:SetAttribute("MonoNoTheme",true)new("UICorner",{CornerRadius=UDim.new(1,0)},swatch)local hexBox=new("TextBox",{Position=UDim2.fromOffset(px(10)+swS+px(8),0),Size=UDim2.new(1,-(px(18)+swS+px(8)),1,0),BackgroundTransparency=1,ClearTextOnFocus=false,FontFace=T.mono,TextSize=px(12),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=HEX.from(THEMES.Custom.palette.accent),PlaceholderText="#RRGGBB",PlaceholderColor3=T.muted,},hexF)local function preview(c)local h=c:ToHSV()hueKnob.Position=UDim2.fromScale(h,0.5)hueKnob.BackgroundColor3,swatch.BackgroundColor3=c,c if not hexBox:IsFocused()then hexBox.Text=HEX.from(c)end end preview(THEMES.Custom.palette.accent)local function commit(c)local base=(currentTheme=="Custom"and THEMES.Custom or THEMES[currentTheme]).palette.bg addTheme("Custom",base,c)prefs.custom={base=HEX.from(base),accent=HEX.from(c)}applyTheme("Custom",true,true,true)buildTile("Custom",table.find(THEME_ORDER,"Custom")or#THEME_ORDER)paintTiles(0.2)end local dragging=false local current=THEMES.Custom.palette.accent local function fromX(x)local a=math.clamp((x-hue.AbsolutePosition.X)/math.max(hue.AbsoluteSize.X,1),0,0.999)current=Color3.fromHSV(a,0.62,1)preview(current)end hue.InputBegan:Connect(function(input)if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end dragging=true tween(hueKnob,0.15,{Size=UDim2.fromOffset(knobS+px(4),knobS+px(4))})fromX(input.Position.X)end)STATE.connect(UIS.InputChanged,function(input)if dragging and(input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)then fromX(input.Position.X)end end)STATE.connect(UIS.InputEnded,function(input)if not dragging then return end if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end dragging=false tween(hueKnob,0.25,{Size=UDim2.fromOffset(knobS,knobS)},Enum.EasingStyle.Back)commit(current)end)hexBox.Focused:Connect(function()tween(hexStroke,0.15,{Color=C.accent})end)hexBox.FocusLost:Connect(function()tween(hexStroke,0.2,{Color=T.fieldLine})local c=HEX.to(hexBox.Text)if c then current=c preview(c)commit(c)else hexBox.Text=HEX.from(current)end end)onThemeChanged(function()if dragging then return end current=THEMES.Custom.palette.accent preview(current)buildTile("Custom",table.find(THEME_ORDER,"Custom")or#THEME_ORDER)paintTiles(0)end)return{}end local buildHome do(function()local HIST=24 local metrics={fps=0,ping=0,fpsHist={},pingHist={}}local metricHooks={}do local frames,last=0,os.clock()STATE.connect(RunService.RenderStepped,function()frames+=1 end)local function push(list,v)table.insert(list,v)if#list>HIST then table.remove(list,1)end end task.spawn(function()while STATE.alive()and mine()do task.wait(0.5)local now=os.clock()metrics.fps=frames/math.max(now-last,1e-3)frames,last=0,now local ok,p=pcall(function()return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()end)if not ok or type(p)~="number"then ok,p=pcall(function()return LP:GetNetworkPing()*1000 end)end metrics.ping=(ok and type(p)=="number")and p or 0 push(metrics.fpsHist,metrics.fps)push(metrics.pingHist,metrics.ping)for _,fn in ipairs(metricHooks)do pcall(fn)end end end)end local function fmtSession(s)s=math.floor(s)if s<60 then return s.."s"end if s<3600 then return("%dm %ds"):format(s//60,s%60)end return("%dh %dm"):format(s//3600,(s%3600)//60)end local function httpRequest(opts)local req=(syn and syn.request)or(http and http.request)or http_request or request if not req then return nil end local ok,res=pcall(req,opts)return(ok and type(res)=="table")and res.Body or nil end local function serverList(sortOrder)local url=("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100&excludeFullGames=true"):format(game.PlaceId,sortOrder)local ok,res=pcall(function()return game:HttpGet(url)end)if not ok or type(res)~="string"then res=httpRequest({Url=url,Method="GET"})ok=type(res)=="string"end if not ok or type(res)~="string"then return nil end local ok2,data=pcall(HttpService.JSONDecode,HttpService,res)return(ok2 and type(data)=="table")and data.data or nil end local function joinServer(jobId)notify({Title="Teleporting",Content="Joining the server...",Icon="refresh-cw",Duration=4})local ok,err=pcall(function()TeleportService:TeleportToPlaceInstance(game.PlaceId,jobId,LP)end)if not ok then notify({Title="Teleport failed",Content=tostring(err),Icon="triangle-alert",Duration=5})end end local avatarCache={}local function headshots(tokens,onImage)if#tokens==0 then return end task.spawn(function()local body={}for i,tk in ipairs(tokens)do body[i]={requestId=tostring(i),token=tk,type="AvatarHeadShot",size="60x60",format="png",isCircular=false}end local res=httpRequest({Url="https://thumbnails.roblox.com/v1/batch",Method="POST",Headers={["Content-Type"]="application/json"},Body=HttpService:JSONEncode(body),})local ok,data=pcall(HttpService.JSONDecode,HttpService,res or"")if not ok or type(data)~="table"or type(data.data)~="table"then return end local getAsset=getcustomasset or getsynasset for _,item in ipairs(data.data)do local i=tonumber(item.requestId)local uid,url=tonumber(item.targetId),item.imageUrl if i and uid and uid>0 then onImage(i,("rbxthumb://type=AvatarHeadShot&id=%d&w=60&h=60"):format(uid))elseif i and getAsset and writefile and type(url)=="string"and url~=""then task.spawn(function()if avatarCache[url]then onImage(i,avatarCache[url])return end local okGet,bytes=pcall(function()return game:HttpGet(url)end)if not okGet or type(bytes)~="string"or#bytes<64 then return end local path="MonoUI/avatars/"..url:gsub("[^%w]",""):sub(-40)..".png"pcall(function()if not isfolder("MonoUI")then makefolder("MonoUI")end if not isfolder("MonoUI/avatars")then makefolder("MonoUI/avatars")end end)if not pcall(writefile,path,bytes)then return end local okA,asset=pcall(getAsset,path)if okA and asset then avatarCache[url]=asset onImage(i,asset)end end)end end end)end local function serverPreview(s)return function(box)new("UIListLayout",{Padding=UDim.new(0,px(10)),SortOrder=Enum.SortOrder.LayoutOrder},box)local playing,maxP=tonumber(s.playing)or 0,tonumber(s.maxPlayers)or 0 local chips=new("Frame",{LayoutOrder=1,Size=UDim2.new(1,0,0,even(px(28))),BackgroundTransparency=1},box)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(6)),SortOrder=Enum.SortOrder.LayoutOrder,},chips)local function chip(order,iconName,text,color)local h=even(px(28))local c=new("Frame",{LayoutOrder=order,Size=UDim2.fromOffset(px(28)+textW(text,px(12),T.fontSemi)+px(10),h),BackgroundColor3=T.field,},chips)corner(c,px(8))stroke(c,T.fieldLine)local s13=even(px(13))new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(9),0.5,0),Size=UDim2.fromOffset(s13,s13),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=color or T.subtext,},c)new("TextLabel",{Position=UDim2.fromOffset(px(28),0),Size=UDim2.new(1,-px(28),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=text,},c)end chip(1,"users",("%d / %d players"):format(playing,maxP),C.accent)local ping=tonumber(s.ping)if ping then chip(2,"wifi",("%d ms"):format(ping),ping<=90 and C.green or(ping<=180 and C.amber or C.red))end local fps=tonumber(s.fps)if fps then chip(3,"gauge",("%d fps"):format(math.floor(fps+0.5)),fps>=50 and C.green or(fps>=30 and C.amber or C.red))end local bar=new("Frame",{LayoutOrder=2,Size=UDim2.new(1,0,0,even(px(6))),BackgroundColor3=T.track,BorderSizePixel=0},box)new("UICorner",{CornerRadius=UDim.new(1,0)},bar)local fill=new("Frame",{Size=UDim2.fromScale(0,1),BackgroundColor3=C.accent,BorderSizePixel=0},bar)new("UICorner",{CornerRadius=UDim.new(1,0)},fill)task.delay(0.15,function()tween(fill,0.6,{Size=UDim2.fromScale(maxP>0 and playing/maxP or 0,1)})end)local tokens=type(s.playerTokens)=="table"and s.playerTokens or{}if#tokens==0 then if playing>0 then new("TextLabel",{LayoutOrder=3,Size=UDim2.new(1,0,0,px(16)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text="Player pictures aren't available for this server.",},box)end return end new("TextLabel",{LayoutOrder=3,Size=UDim2.new(1,0,0,px(14)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text="IN THIS SERVER",},box)local faces=new("Frame",{LayoutOrder=4,Size=UDim2.new(1,0,0,even(px(38))),BackgroundTransparency=1},box)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,-px(9)),SortOrder=Enum.SortOrder.LayoutOrder,},faces)local MAX=8 local fs=even(px(38))local imgs={}for i=1,math.min(#tokens,MAX)do local ring=new("Frame",{LayoutOrder=i,Size=UDim2.fromOffset(fs,fs),BackgroundColor3=T.field,ZIndex=MAX-i+2},faces)new("UICorner",{CornerRadius=UDim.new(1,0)},ring)stroke(ring,T.popup,0,2)local ph=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(0.5,0.5),BackgroundTransparency=1,Image=ICON.user,ImageColor3=T.muted,ZIndex=MAX-i+2,},ring)local img=new("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image="",ImageTransparency=1,ZIndex=MAX-i+3,},ring)new("UICorner",{CornerRadius=UDim.new(1,0)},img)imgs[i]={img=img,ph=ph}local sc=new("UIScale",{Scale=0.6},ring)task.delay(0.04*i,function()tween(sc,0.4,{Scale=1},Enum.EasingStyle.Back)end)end local more=math.max(playing,#tokens)-math.min(#tokens,MAX)if more>0 then local ring=new("Frame",{LayoutOrder=MAX+1,Size=UDim2.fromOffset(fs,fs),BackgroundColor3=T.fieldHot,ZIndex=1},faces)new("UICorner",{CornerRadius=UDim.new(1,0)},ring)stroke(ring,T.popup,0,2)new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(12),TextColor3=T.subtext,Text="+"..more,ZIndex=1,},ring)end local first={}for i=1,math.min(#tokens,MAX)do first[i]=tokens[i]end headshots(first,function(i,image)local f=imgs[i]if not f or not f.img.Parent then return end f.img.Image=image tween(f.img,0.35,{ImageTransparency=0})tween(f.ph,0.2,{ImageTransparency=1})end)end end local function offerServers(kind,list,i)local s=list[i]if not s then notify({Title=kind=="lowest"and"Lowest server"or"Server hop",Content="No more servers to show.",Icon="info",Duration=3})return end local buttons={{Title="Cancel"}}if list[i+1]then table.insert(buttons,{Title=kind=="lowest"and"Next lowest"or"Another",Callback=function()offerServers(kind,list,i+1)end})end table.insert(buttons,{Title="Join",Variant="Primary",Callback=function()joinServer(s.id)end})popup({Title=kind=="lowest"and"Join the emptiest server?"or"Hop to this server?",Content=kind=="lowest"and"The public server with the fewest players right now."or"A random public server with free slots.",Build=serverPreview(s),Buttons=buttons,})end local function candidates(servers)local out={}for _,s in ipairs(servers)do if s.id~=game.JobId and tonumber(s.playing)and tonumber(s.maxPlayers)and s.playing<s.maxPlayers then table.insert(out,s)end end return out end local ACTIONS={rejoin=function()popup({Title="Rejoin this server?",Content=#Players:GetPlayers()<=1 and"You're alone here, so you'll join a fresh server of this game."or"You'll leave and come straight back into this same server.",Buttons={{Title="Cancel"},{Title="Rejoin",Variant="Primary",Callback=function()notify({Title="Rejoining",Content="Teleporting back...",Icon="refresh-cw",Duration=4})local ok,err=pcall(function()if#Players:GetPlayers()<=1 then TeleportService:Teleport(game.PlaceId,LP)else TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP)end end)if not ok then notify({Title="Teleport failed",Content=tostring(err),Icon="triangle-alert",Duration=5})end end},},})end,hop=function()local servers=serverList("Desc")if not servers then notify({Title="Server hop",Content="Could not load the server list.",Icon="triangle-alert"})return end local list=candidates(servers)if#list==0 then notify({Title="Server hop",Content="No other open servers found.",Icon="triangle-alert"})return end for k=#list,2,-1 do local j=math.random(1,k)list[k],list[j]=list[j],list[k]end offerServers("hop",list,1)end,lowest=function()local servers=serverList("Asc")if not servers then notify({Title="Lowest server",Content="Could not load the server list.",Icon="triangle-alert"})return end local list=candidates(servers)if#list==0 then notify({Title="Lowest server",Content="No other servers found.",Icon="triangle-alert"})return end table.sort(list,function(a,b)return a.playing<b.playing end)offerServers("lowest",list,1)end,jobid=function()local set=setclipboard or toclipboard or(Clipboard and Clipboard.set)if set then set(game.JobId)notify({Title="Job ID copied",Content=game.JobId,Icon="check",Duration=3})else notify({Title="Job ID",Content=game.JobId.."\n(clipboard not supported here)",Icon="info",Duration=6})end end,}function buildHome(page,o)o=o or{}local body=page.body local CP=px(20)local n=0 local function homeVisible()return shown and currentPage==page end local function card(h,name)n+=1 local c=new("Frame",{Name=name,LayoutOrder=n,Size=UDim2.new(1,0,0,h),BackgroundColor3=T.card},body)corner(c,K.radius)stroke(c,T.cardLine)return c end local function caps(parent,text,pos,size,color)return new("TextLabel",{Position=pos,Size=size,BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=color or T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text=text:upper(),},parent)end local function counter(label,fmt)local nv=new("NumberValue",{},label)nv.Changed:Connect(function(v)label.Text=fmt(v)end)return function(target,instant)if instant then nv.Value=target else tween(nv,0.45,{Value=target},Enum.EasingStyle.Quad)end end end local wh=px(160)local wc=card(wh,"Welcome")wc.ClipsDescendants=true local glow=new("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.fromScale(0.6,1),BackgroundColor3=C.accent,BorderSizePixel=0,},wc)corner(glow,K.radius)new("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0.86)})},glow)local avatarS=px(156)local textRight=avatarS+px(34)local avatar=new("ImageLabel",{Name="Avatar",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(24),1,px(26)),Size=UDim2.fromOffset(avatarS,avatarS),BackgroundTransparency=1,Image="",ImageTransparency=1,},wc)task.spawn(function()local ok,img=pcall(Players.GetUserThumbnailAsync,Players,LP.UserId,Enum.ThumbnailType.AvatarBust,Enum.ThumbnailSize.Size420x420)if ok and avatar.Parent then avatar.Image=img tween(avatar,0.7,{ImageTransparency=privacy.avatar and 1 or 0,Position=UDim2.new(1,-px(24),1,px(8))})end end)local welcomeCap=caps(wc,"Welcome back",UDim2.fromOffset(CP,px(20)),UDim2.new(1,-(CP+textRight),0,px(14)))local nameL=new("TextLabel",{Position=UDim2.fromOffset(CP,px(36)),Size=UDim2.new(1,-(CP+textRight),0,px(34)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(28),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=LP.DisplayName,},wc)local userL=new("TextLabel",{Position=UDim2.fromOffset(CP,px(70)),Size=UDim2.new(1,-(CP+textRight),0,px(18)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="@"..LP.Name,},wc)local chipH=even(px(30))local chips=new("Frame",{Position=UDim2.fromOffset(CP,wh-CP-chipH),Size=UDim2.new(1,-(CP+avatarS+px(24)),0,chipH),BackgroundTransparency=1,},wc)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(8)),SortOrder=Enum.SortOrder.LayoutOrder,},chips)local chipIcon=even(px(14))local function chip(order,iconName,text,color,clickable)local w=textW(text,px(12),T.fontSemi)local b=new(clickable and"TextButton"or"Frame",{Name=text,LayoutOrder=order,Size=UDim2.fromOffset(px(30)+w+px(12),chipH),BackgroundColor3=color or T.field,BackgroundTransparency=color and 0.86 or 0,},chips)if clickable then b.AutoButtonColor=false b.Text=""end corner(b,px(8))local st=stroke(b,color or T.fieldLine,color and 0.55 or 0)local ic=new("ImageLabel",{Position=UDim2.fromOffset(px(10),math.floor((chipH-chipIcon)/2)),Size=UDim2.fromOffset(chipIcon,chipIcon),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=color and color:Lerp(WHITE,0.2)or T.subtext,},b)local lb=new("TextLabel",{Position=UDim2.fromOffset(px(30),0),Size=UDim2.new(1,-px(30),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=color and color:Lerp(WHITE,0.35)or T.subtext,TextXAlignment=Enum.TextXAlignment.Left,Text=text,},b)local c={frame=b,icon=ic,label=lb,stroke=st}function c.setText(t)if lb.Text==t then return end lb.Text=t tween(b,0.25,{Size=UDim2.fromOffset(px(30)+textW(t,px(12),T.fontSemi)+px(12),chipH)})end return c end local function paintChip(c,on)tween(c.frame,0.22,{BackgroundColor3=on and C.accent or T.field,BackgroundTransparency=on and 0.84 or 0})tween(c.stroke,0.22,{Color=on and C.accent or T.fieldLine,Transparency=on and 0.45 or 0})tween(c.icon,0.22,{ImageColor3=on and C.accent:Lerp(WHITE,0.2)or T.subtext})tween(c.label,0.22,{TextColor3=on and T.text or T.subtext})end local function timeLeft()if o.TimeLeft then return tostring(o.TimeLeft)end local exp=tonumber(o.ExpiresAt)if not exp then return"Lifetime"end local s=exp-os.time()if s<=0 then return"Expired"end local d,h,m=s//86400,(s%86400)//3600,(s%3600)//60 if d>0 then return("%dd %dh left"):format(d,h)end if h>0 then return("%dh %dm left"):format(h,m)end return("%dm left"):format(math.max(m,1))end chip(1,o.PlanIcon or"gem",tostring(o.Plan or"Free"),C.accent,false)local timeChip=chip(2,"clock",timeLeft(),nil,false)local nameChip=chip(3,"eye-off","Name",nil,true)local avatarChip=chip(4,"user-x","Avatar",nil,true)for key,c in pairs({name=nameChip,avatar=avatarChip})do STATE.connect(c.frame.MouseEnter,function()if not privacy[key]then tween(c.stroke,0.15,{Color=T.fieldLineHot})tween(c.label,0.15,{TextColor3=T.text})end end)STATE.connect(c.frame.MouseLeave,function()if not privacy[key]then tween(c.stroke,0.2,{Color=T.fieldLine})tween(c.label,0.2,{TextColor3=T.subtext})end end)STATE.connect(c.frame.MouseButton1Click,function()setPrivacy(key,not privacy[key])end)end onPrivacy(function()nameL.Text=privacy.name and"Hidden"or LP.DisplayName userL.Text=privacy.name and"@hidden"or("@"..LP.Name)if avatar.Image~=""then tween(avatar,0.3,{ImageTransparency=privacy.avatar and 1 or 0})end paintChip(nameChip,privacy.name)paintChip(avatarChip,privacy.avatar)nameChip.icon.Image=privacy.name and ICON.eye or ICON["eye-off"]end)local wide=true local function fitWelcome()local w=wc.AbsoluteSize.X/math.max(pop.Scale,0.01)if w<=0 then return end local nowWide=w>=px(560)if nowWide==wide then return end wide=nowWide local right=wide and(CP+textRight)or CP*2 welcomeCap.Size=UDim2.new(1,-right,0,px(14))nameL.Size=UDim2.new(1,-right,0,px(34))userL.Size=UDim2.new(1,-right,0,px(18))chips.Size=UDim2.new(1,-(wide and(CP+avatarS+px(24))or CP*2),0,chipH)avatar.Visible=wide end STATE.connect(wc:GetPropertyChangedSignal("AbsoluteSize"),fitWelcome)task.defer(fitWelcome)n+=1 local quickRebuild=FEAT.quickCard(body,n,CP)local sh=px(180)local sc=card(sh,"Stats")local function metric(xScale,xOff,iconName,label)local holder=new("Frame",{Position=UDim2.new(xScale,xOff,0,px(18)),Size=UDim2.new(0.5,-(CP+px(12)),0,px(96)),BackgroundTransparency=1,},sc)local s13=even(px(13))new("ImageLabel",{Size=UDim2.fromOffset(s13,s13),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=T.muted},holder)caps(holder,label,UDim2.fromOffset(s13+px(6),0),UDim2.new(1,-(s13+px(6)),0,s13))local value=new("TextLabel",{Position=UDim2.fromOffset(0,px(18)),Size=UDim2.new(1,0,0,px(30)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(26),TextColor3=C.green,TextXAlignment=Enum.TextXAlignment.Left,Text="--",},holder)local graph=new("Frame",{Position=UDim2.fromOffset(0,px(56)),Size=UDim2.new(1,0,0,px(38)),BackgroundTransparency=1,ClipsDescendants=true,},holder)local bars={}for i=1,HIST do local bar=new("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new((i-1)/HIST,0,1,0),Size=UDim2.new(1/HIST,-px(3),0.06,0),BackgroundColor3=T.track,BackgroundTransparency=0.4,BorderSizePixel=0,},graph)corner(bar,px(2))bars[i]=bar end return value,bars end local fpsValue,fpsBars=metric(0,CP,"gauge","FPS")local pingValue,pingBars=metric(0.5,px(12),"wifi","Ping")local setFps=counter(fpsValue,function(v)return tostring(math.floor(v+0.5))end)local setPing=counter(pingValue,function(v)return math.floor(v+0.5).."ms"end)new("Frame",{Position=UDim2.fromOffset(CP,px(124)),Size=UDim2.new(1,-CP*2,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},sc)local statRow=new("Frame",{Position=UDim2.fromOffset(CP,px(136)),Size=UDim2.new(1,-CP*2,0,px(32)),BackgroundTransparency=1},sc)local function stat(i,label)local holder=new("Frame",{Position=UDim2.fromScale((i-1)/3,0),Size=UDim2.fromScale(1/3,1),BackgroundTransparency=1},statRow)local v=new("TextLabel",{Size=UDim2.new(1,0,0,px(18)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(16),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text="--",},holder)caps(holder,label,UDim2.fromOffset(0,px(20)),UDim2.new(1,0,0,px(12)))return v end local playersL=stat(1,"Players")local execsL=stat(2,"Execs")local sessionL=stat(3,"Session")execsL.Text=tostring(o.Execs or GEN)for _,e in ipairs({{"FPS","Frames per second"},{"Ping","Network latency"},{"Players","Players in this server"},{"Session","Time since the script started"},})do table.insert(page.rows,{r=sc,title=e[1],desc=e[2]})end table.insert(page.rows,{r=wc,title="Hide name",desc="Streamer mode: hide your name"})table.insert(page.rows,{r=wc,title="Hide avatar",desc="Streamer mode: hide your avatar"})local function grade(v,good,okay,lowerIsBetter)if lowerIsBetter then return v<=good and C.green or(v<=okay and C.amber or C.red)end return v>=good and C.green or(v>=okay and C.amber or C.red)end local function setBars(bars,hist,scaleMax,color,t)local N=#bars for i=1,N do local v=hist[#hist-N+i]local h=v and math.clamp(v/scaleMax,0.06,1)or 0.06 local last=i==N local goal={Size=UDim2.new(1/N,-px(3),h,0),BackgroundColor3=(last and v)and color or T.track,BackgroundTransparency=v and(last and 0 or 0.65*(1-i/N))or 0.6,}if t then tween(bars[i],t,goal)else for k,x in pairs(goal)do bars[i][k]=x end end end end local function updateMetrics(instant)local fc=grade(metrics.fps,50,30,false)local pc=grade(metrics.ping,90,180,true)setFps(metrics.fps,instant)setPing(metrics.ping,instant)tween(fpsValue,0.3,{TextColor3=fc})tween(pingValue,0.3,{TextColor3=pc})local fMax,pMax=60,150 for _,v in ipairs(metrics.fpsHist)do fMax=math.max(fMax,v)end for _,v in ipairs(metrics.pingHist)do pMax=math.max(pMax,v)end setBars(fpsBars,metrics.fpsHist,fMax*1.1,fc,not instant and 0.35 or nil)setBars(pingBars,metrics.pingHist,pMax*1.1,pc,not instant and 0.35 or nil)end table.insert(metricHooks,function()if homeVisible()then updateMetrics(false)end end)local iconS=even(px(50))local btnH=px(64)local gap=px(8)local srvH=CP+iconS+px(16)+btnH+px(14)+px(14)+CP local svc=card(srvH,"Server")local gIcon=new("ImageLabel",{Position=UDim2.fromOffset(CP,CP),Size=UDim2.fromOffset(iconS,iconS),BackgroundColor3=T.field,Image="",ImageTransparency=1,ScaleType=Enum.ScaleType.Crop,},svc)corner(gIcon,px(10))stroke(gIcon,T.fieldLine)task.spawn(function()local cands={("rbxthumb://type=GameIcon&id=%d&w=150&h=150"):format(game.PlaceId),("rbxthumb://type=GameIcon&id=%d&w=150&h=150"):format(game.GameId),("rbxthumb://type=Asset&id=%d&w=150&h=150"):format(game.PlaceId),}local chosenUrl=cands[1]for _,url in ipairs(cands)do local good=false pcall(function()ContentProvider:PreloadAsync({url},function(_,status)good=status==Enum.AssetFetchStatus.Success end)end)if good then chosenUrl=url break end end if gIcon.Parent then gIcon.Image=chosenUrl tween(gIcon,0.5,{ImageTransparency=0})end end)local gx=CP+iconS+px(14)local gName=new("TextLabel",{Position=UDim2.fromOffset(gx,CP+px(6)),Size=UDim2.new(1,-(gx+CP),0,px(20)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(16),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=gameInfo.name,},svc)local gSub=new("TextLabel",{Position=UDim2.fromOffset(gx,CP+px(29)),Size=UDim2.new(1,-(gx+CP),0,px(16)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},svc)local function playerCount()return("%d/%d"):format(#Players:GetPlayers(),Players.MaxPlayers)end local function refreshServer()gName.Text=gameInfo.name gSub.Text=("by %s  ·  %s players"):format(gameInfo.creator,playerCount())playersL.Text=playerCount()end onGameInfo(refreshServer)refreshServer()STATE.connect(Players.PlayerAdded,refreshServer)STATE.connect(Players.PlayerRemoving,function()task.defer(refreshServer)end)local grid=new("Frame",{Position=UDim2.fromOffset(CP,CP+iconS+px(16)),Size=UDim2.new(1,-CP*2,0,btnH),BackgroundTransparency=1,},svc)new("UIGridLayout",{CellSize=UDim2.new(0.25,-math.ceil(gap*3/4),0,btnH),CellPadding=UDim2.fromOffset(gap,0),SortOrder=Enum.SortOrder.LayoutOrder,},grid)local aIcon=even(px(18))local function action(order,iconName,label,fn)local b=new("TextButton",{Name=label,LayoutOrder=order,BackgroundColor3=T.field,AutoButtonColor=false,Text=""},grid)corner(b,px(10))local st=stroke(b,T.fieldLine)local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,px(14)),Size=UDim2.fromOffset(aIcon,aIcon),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=T.subtext,},b)local lb=new("TextLabel",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,px(38)),Size=UDim2.new(1,-px(8),0,px(16)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=T.subtext,Text=label,},b)table.insert(page.rows,{r=b,title=label,desc="Server action"})local busy=false STATE.connect(b.MouseEnter,function()tween(b,0.15,{BackgroundColor3=T.fieldHot})tween(st,0.15,{Color=T.fieldLineHot})tween(ic,0.25,{ImageColor3=C.accent,Position=UDim2.new(0.5,0,0,px(12))})tween(lb,0.15,{TextColor3=T.text})end)STATE.connect(b.MouseLeave,function()tween(b,0.2,{BackgroundColor3=T.field})tween(st,0.2,{Color=T.fieldLine})tween(ic,0.25,{ImageColor3=T.subtext,Position=UDim2.new(0.5,0,0,px(14))})tween(lb,0.2,{TextColor3=T.subtext})end)STATE.connect(b.MouseButton1Down,function()tween(b,0.08,{BackgroundColor3=T.rowActive})end)STATE.connect(b.MouseButton1Up,function()tween(b,0.2,{BackgroundColor3=T.fieldHot})end)STATE.connect(b.MouseButton1Click,function()if busy then return end busy=true lb.Text="..."task.spawn(function()local ok,err=pcall(fn)if not ok then notify({Title=label,Content=tostring(err),Icon="triangle-alert",Duration=5})end task.wait(0.6)busy=false if lb.Parent then lb.Text=label end end)end)end action(1,"refresh-cw","Rejoin",ACTIONS.rejoin)action(2,"shuffle","Hop",ACTIONS.hop)action(3,"users","Lowest",ACTIONS.lowest)action(4,"copy","Job ID",ACTIONS.jobid)local job=tostring(game.JobId)local shortJob=#job>12 and(job:sub(1,8).."..."..job:sub(-4))or(job~=""and job or"studio")new("TextLabel",{Position=UDim2.fromOffset(CP,srvH-CP-px(14)),Size=UDim2.new(1,-CP*2,0,px(14)),BackgroundTransparency=1,FontFace=T.mono,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=("Job %s  ·  Place %d"):format(shortJob,game.PlaceId),},svc)task.spawn(function()while STATE.alive()and mine()and wc.Parent do if homeVisible()then sessionL.Text=fmtSession(os.clock()-SESSION_START)timeChip.setText(timeLeft())end task.wait(1)end end)page.onShow=function()quickRebuild()sessionL.Text=fmtSession(os.clock()-SESSION_START)timeChip.setText(timeLeft())refreshServer()updateMetrics(true)end end end)()end local floatBtn,floatIcon,CONTROL_MODES,setControlMode,getControlMode do local island=(function()local H=math.max(even(px(40)),38)local PADX=math.floor(H*0.3)local ICS=even(H*0.45)local GAP=px(8)local INK=Color3.fromRGB(245,245,247)local present,hovering=false,false local springs={}local function spring(x,k,d)local s={x=x,v=0,t=x,k=k,d=d}table.insert(springs,s)return s end local W=spring(H,380,22)local Hh=spring(H,420,22)local Sq=spring(1,520,30)local root=new("Frame",{Name="MenuIsland",AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.fromOffset(H,H),BackgroundTransparency=1,Visible=false,ZIndex=50,},gui)local rootScale=new("UIScale",{},root)local shade=new("ImageLabel",{Name="Shadow",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,px(4)),Size=UDim2.new(1,px(40),1,px(40)),BackgroundTransparency=1,Image=SHADOW_IMAGE,ImageColor3=Color3.new(0,0,0),ImageTransparency=1,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(99,99,99,99),},root)local body=new("CanvasGroup",{Name="Body",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),GroupTransparency=1,Active=true,},root)new("UICorner",{CornerRadius=UDim.new(1,0)},body)local rim=stroke(body,WHITE,1)local main=new("CanvasGroup",{Name="Main",Size=UDim2.fromScale(1,1),BackgroundTransparency=1},body)local msg=new("CanvasGroup",{Name="Alert",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,GroupTransparency=1},body)local logo=new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,PADX,0.5,0),Size=UDim2.fromOffset(ICS,ICS),BackgroundTransparency=1,Image=ICON.layers,ImageColor3=C.accent,},main)local title=new("TextLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,PADX+ICS+GAP,0.5,0),Size=UDim2.fromOffset(10,H),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(13),TextColor3=INK,TextXAlignment=Enum.TextXAlignment.Left,Text="",},main)local dotS=even(px(8))local dot=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-(PADX+px(2)),0.5,0),Size=UDim2.fromOffset(dotS,dotS),BackgroundColor3=C.green,},main)local countL=new("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-(PADX+px(2)+dotS+px(7)),0.5,0),Size=UDim2.fromOffset(0,H),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=Color3.fromRGB(170,174,184),TextXAlignment=Enum.TextXAlignment.Right,Text="",},main)local countW=0 dot:SetAttribute("MonoNoTheme",true)new("UICorner",{CornerRadius=UDim.new(1,0)},dot)local halo=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(1,1),BackgroundColor3=C.green,BackgroundTransparency=1,},dot)new("UICorner",{CornerRadius=UDim.new(1,0)},halo)local chipH=H-px(12)local chipIcon=even(px(10))local chipW=px(9)+chipIcon+px(5)+textW("Close",px(12),T.fontSemi)+px(11)local CHIP_POS=UDim2.new(1,-px(6),0.5,0)local chip=new("CanvasGroup",{AnchorPoint=Vector2.new(1,0.5),Position=CHIP_POS+UDim2.fromOffset(px(10),0),Size=UDim2.fromOffset(chipW,chipH),BackgroundColor3=WHITE,BackgroundTransparency=0.86,GroupTransparency=1,},main)local msgIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,PADX,0.5,0),Size=UDim2.fromOffset(ICS,ICS),BackgroundTransparency=1,Image="",ImageColor3=C.green,},msg)local msgText=new("TextLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,PADX+ICS+GAP,0.5,0),Size=UDim2.fromOffset(10,H),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(13),TextColor3=INK,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},msg)local badge=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(7),0.5,0),Size=UDim2.fromOffset(px(40),H-px(14)),BackgroundColor3=C.green,BackgroundTransparency=0.78,},msg)new("UICorner",{CornerRadius=UDim.new(1,0)},badge)local badgeText=new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=C.green,Text="",},badge)msg:SetAttribute("MonoNoTheme",true)new("UICorner",{CornerRadius=UDim.new(1,0)},chip)new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(9),0.5,0),Size=UDim2.fromOffset(chipIcon,chipIcon),BackgroundTransparency=1,Image=ICON.x,ImageColor3=INK,},chip)new("TextLabel",{Position=UDim2.fromOffset(px(9)+chipIcon+px(5),0),Size=UDim2.new(1,-(px(9)+chipIcon+px(5)),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=INK,TextXAlignment=Enum.TextXAlignment.Left,Text="Close",},chip)local titleW=0 local function measure()title.RichText=true title.Text=brandTitle.Text local plain=brandTitle.ContentText~=""and brandTitle.ContentText or brandTitle.Text:gsub("<[^>]+>","")titleW=plain~=""and textW(plain,px(13),T.fontBold)or 0 title.Size=UDim2.fromOffset(titleW,H)end local function lead()return PADX+ICS+(titleW>0 and GAP+titleW or 0)end local function openW()return lead()+GAP*2+chipW+px(6)end local function closedW()return lead()+GAP+(countW>0 and countW+px(7)or 0)+dotS+PADX+px(2)end local flashing,flashW=false,0 local function wantW()if not present then return H*0.6 end if flashing then return flashW end return(shown and openW()or closedW())+(hovering and px(6)or 0)end local endFlash local function tweenAfter(inst,t,delay,goal)local tw=TweenService:Create(inst,TweenInfo.new(t,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,delay),goal)tw:Play()return tw end local function paint(quiet)W.t=wantW()if present and not quiet then Hh.v+=H*5 end if shown then tween(dot,0.12,{BackgroundTransparency=1})tween(halo,0.12,{BackgroundTransparency=1})tween(countL,0.12,{TextTransparency=1})chip.Position=CHIP_POS+UDim2.fromOffset(px(10),0)tweenAfter(chip,0.4,0.08,{GroupTransparency=0,Position=CHIP_POS})else tween(chip,0.12,{GroupTransparency=1})tweenAfter(dot,0.35,0.1,{BackgroundTransparency=0})tweenAfter(countL,0.35,0.1,{TextTransparency=0})end logo.ImageColor3=C.accent tween(logo,0.55,{Rotation=shown and 90 or 0},Enum.EasingStyle.Back)tween(rim,0.3,{Transparency=present and(shown and 0.8 or 0.9)or 1})end local function settled(s)return math.abs(s.x-s.t)<0.02 and math.abs(s.v)<0.02 end STATE.connect(RunService.RenderStepped,function(dt)if not root.Visible then return end local busy=false for _,s in ipairs(springs)do if not settled(s)then busy=true break end end if not busy then return end dt=math.min(dt,1/20)local n=math.max(1,math.ceil(dt*240))local h=dt/n for _=1,n do for _,s in ipairs(springs)do s.v+=(-s.k*(s.x-s.t)-s.d*s.v)*h s.x+=s.v*h end end for _,s in ipairs(springs)do if settled(s)then s.x,s.v=s.t,0 end end root.Size=UDim2.fromOffset(math.max(1,math.floor(W.x+0.5)),math.max(1,math.floor(Hh.x+0.5)))rootScale.Scale=Sq.x end)task.spawn(function()while STATE.alive()and mine()and root.Parent do if present and not shown then halo.Size,halo.BackgroundTransparency=UDim2.fromScale(1,1),0.4 tween(halo,1.4,{Size=UDim2.fromScale(2.8,2.8),BackgroundTransparency=1},Enum.EasingStyle.Quad)end task.wait(1.8)end end)local function clampPos(x,y)local vp=workspace.CurrentCamera.ViewportSize local hw=openW()/2+px(10)local hh=H/2+4 return math.clamp(x,hw,math.max(hw,vp.X-hw)),math.clamp(y,hh,math.max(hh,vp.Y-hh))end local function place(x,y)x,y=clampPos(x,y)root.Position=UDim2.fromOffset(math.floor(x),math.floor(y))end local active,startPos,startAt,moved STATE.connect(body.InputBegan,function(input)if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end if active or not present then return end active,moved=input,false startPos=input.Position startAt=Vector2.new(root.Position.X.Offset,root.Position.Y.Offset)Sq.t=0.92 end)STATE.connect(UIS.InputChanged,function(input)if not active then return end local isTouch=input.UserInputType==Enum.UserInputType.Touch if isTouch and input~=active then return end if not isTouch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end local d=Vector2.new(input.Position.X-startPos.X,input.Position.Y-startPos.Y)if not moved and d.Magnitude<8 then return end moved=true Sq.t=1.04 place(startAt.X+d.X,startAt.Y+d.Y)end)STATE.connect(UIS.InputEnded,function(input)if not active then return end if input~=active and not(active.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1)then return end active=nil Sq.t=1 Sq.v+=1.6 if moved then prefs.button={x=root.Position.X.Offset,y=root.Position.Y.Offset}savePrefs()else if flashing and endFlash then endFlash()end setShown(not shown)end end)if HOVER then STATE.connect(body.MouseEnter,function()hovering=true W.t=wantW()end)STATE.connect(body.MouseLeave,function()hovering=false W.t=wantW()end)end local function show(on)if on==present then return end present=on if on then measure()root.Visible=true W.x,W.v,Hh.x,Hh.v,Sq.x,Sq.v=H*0.6,0,H*0.6,0,1,0 Hh.t,Sq.t=H,1 root.Size=UDim2.fromOffset(math.floor(H*0.6),math.floor(H*0.6))tween(body,0.3,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(shade,0.5,{ImageTransparency=0.55})title.TextTransparency=1 tweenAfter(title,0.4,0.12,{TextTransparency=0})paint()else W.t,Hh.t=H*0.6,H*0.6 tween(shade,0.2,{ImageTransparency=1})tween(rim,0.2,{Transparency=1})tween(title,0.12,{TextTransparency=1})local tw=tween(body,0.28,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()if not present then root.Visible=false end end)end end local flashToken=0 endFlash=function()flashing=false tween(msg,0.15,{GroupTransparency=1},Enum.EasingStyle.Quad)tweenAfter(main,0.3,0.08,{GroupTransparency=0})W.t=wantW()end local function flash(iconName,text,color,badgeLabel,hold)if not present then return end flashToken+=1 local my=flashToken msgIcon.Image,msgIcon.ImageColor3=icon(iconName),color local textWidth=math.min(textW(text,px(13),T.fontBold),px(240))msgText.Text=text msgText.Size=UDim2.fromOffset(textWidth,H)local bw=0 if badgeLabel then bw=textW(badgeLabel,px(11),T.fontBold)+px(16)badge.Size=UDim2.fromOffset(bw,H-px(14))badge.BackgroundColor3,badgeText.TextColor3,badgeText.Text=color,color,badgeLabel end badge.Visible=badgeLabel~=nil flashW=PADX+ICS+GAP+textWidth+(badgeLabel and(GAP+bw+px(7))or PADX)flashing=true W.t=flashW Hh.v+=H*4 tween(main,0.12,{GroupTransparency=1},Enum.EasingStyle.Quad)tweenAfter(msg,0.3,0.05,{GroupTransparency=0})task.delay(hold or 1.6,function()if flashToken==my and flashing then endFlash()end end)end local function setCount(n)local t=n>0 and(n.." on")or""if countL.Text==t then return end countL.Text=t countW=t~=""and textW(t,px(12),T.fontSemi)or 0 countL.Size=UDim2.fromOffset(countW,H)if not flashing then W.t=wantW()end end CTRL.onChange(function(e,muted)setCount(CTRL.activeCount())if muted or not e or e.kind~="toggle"then return end local on=e.obj.Value if present then flash(on and"circle-check"or"circle",e.title,on and C.green or Color3.fromRGB(150,154,166),on and"ON"or"OFF")elseif not shown then notify({Title=e.title,Content=on and"Turned on"or"Turned off",Icon=on and"check"or"x",Duration=1.5})end end)FEAT.islandFlash=function(iconName,text,color)flash(iconName,text,color,nil,2)end setCount(CTRL.activeCount())measure()STATE.connect(brandTitle:GetPropertyChangedSignal("Text"),function()measure()W.t=wantW()end)do local x,y=VP.X/2,H/2+px(10)if type(prefs.button)=="table"and tonumber(prefs.button.x)and tonumber(prefs.button.y)then x,y=tonumber(prefs.button.x),tonumber(prefs.button.y)end place(x,y)end return{root=root,logo=logo,paint=paint,show=show}end)()floatBtn,floatIcon=island.root,island.logo paintFloat=function()island.paint()end onThemeChanged(function()island.paint(true)end)CONTROL_MODES=TOUCH and{"Auto","Mobile","PC + Mobile"}or{"Auto","PC","Mobile","PC + Mobile"}local controlMode=table.find(CONTROL_MODES,prefs.controls)and prefs.controls or"Auto"local function effectiveMode()if controlMode=="Auto"then return DEVICE=="PC"and"PC"or"Mobile"end return controlMode end local function applyControls()local m=effectiveMode()keyEnabled=m~="Mobile"island.show(m=="Mobile"or m=="PC + Mobile")end function setControlMode(mode,remember)if not table.find(CONTROL_MODES,mode)then return false end controlMode=mode if remember then prefs.controls=mode savePrefs()end applyControls()return true end applyControls()local hintShown=false STATE.connect(minBtn.MouseButton1Click,function()setShown(false)if not hintShown then hintShown=true local how=keyEnabled and("Press [%s] to open it again."):format(T.toggleKey.Name)or"Tap the island at the top of the screen to open it again."if keyEnabled and floatBtn.Visible then how=("Press [%s] or tap the island at the top to open it again."):format(T.toggleKey.Name)end notify({Title="Menu hidden",Content=how,Icon="info",Duration=3})end end)STATE.connect(profile.MouseButton1Click,function()if tabs.Home then selectTab("Home")end end)getControlMode=function()return controlMode end end local Lib={}local SECTION_ICONS={Overview="info",Interface="monitor",Appearance="palette",Presets="bookmark",General="settings",Script="power",Hotkey="keyboard",Movement="wind",Home="house",Seeds="refresh-cw",Trees="trees",Carving="hand",Selling="store",Delivery="package",["GIGA Planter"]="zap",Events="cloud-lightning",}local function makeTab(o)local name=tostring(o.Title or"Tab")local tab=tabs[name]or addTab(name,icon(o.Icon))local tabObj={name=name,sections=0}function tabObj:Section(so)so=so or{}local title=tostring(so.Title or"Section")self.sections+=1 local named=SECTION_ICONS[title]or(so.Icon and ICON[so.Icon]and so.Icon)or nil self.sec=addSection(tab,title,icon(named or"circle"))self.secIconSet=named~=nil self.page=self.sec.page self.group=group(self.page,nil)return self end local function g(self,iconName)if not self.group then self:Section({Title="Overview"})end if iconName and not self.secIconSet and ICON[iconName]then self.sec.icon.Image=ICON[iconName]self.secIconSet=true end return self.group end function tabObj:Toggle(e)return toggle(g(self,e.Icon),e)end function tabObj:Slider(e)return slider(g(self,e.Icon),e)end function tabObj:Dropdown(e)return dropdown(g(self,e.Icon),e)end function tabObj:Keybind(e)return keybind(g(self,e.Icon),e)end function tabObj:Paragraph(e)return paragraph(g(self,e.Icon),e)end function tabObj:Button(e)return button(g(self,e.Icon),e)end function tabObj:Input(e)return input(g(self,e.Icon),e)end function tabObj:KeyValue(e)return keyValue(g(self,e.Icon),e)end function tabObj:Label(e)return label(g(self),type(e)=="table"and e or{Text=e})end function tabObj:SetOrder(n)tab.nav.LayoutOrder=tonumber(n)or tab.index end function tabObj:Select()selectTab(name)end tabObj.Tab=tab function tabObj:Current()return g(self)end function tabObj:ThemePicker()return themePicker(g(self,"palette"))end function tabObj:ConfigManager()g(self,"folder-open")FEAT.configPage(self)if not FEAT.canFile then self:Paragraph({Title="Configs last until you leave",Desc="Your executor cannot write files, so saved configs are kept for this session only.",})end return FEAT.config end function tabObj:Divider()return{}end function tabObj:Space()return{}end function tabObj:Group(caption)g(self)if self.group.rows==0 then self.group.holder:Destroy()self.page.groups-=1 local i=table.find(self.page.groupList,self.group)if i then table.remove(self.page.groupList,i)end end self.group=group(self.page,caption)return self.group end return tabObj end local started=false local function openFirstTime()if not started then started=true pcall(FEAT.autoload)for _,fn in ipairs(CTRL.hooks)do pcall(fn,nil,true)end if not prefs.tipShown then prefs.tipShown=true savePrefs()task.delay(5,function()notify({Title="Tip",Content=(UIS.KeyboardEnabled and"Right-click"or"Long-press").." any setting to pin it to Home"..(UIS.KeyboardEnabled and", bind a key to it,"or"").." or reset it.",Icon="info",Duration=6,})end)end end if not opened then setShown(true)end end local Window={}function Window:Tab(o)return makeTab(o or{})end function Window:Section()return{Tab=function(_,o)return makeTab(o or{})end}end function Window:Home(o)o=o or{}local tabObj=makeTab({Title=o.Title or"Home",Icon=o.Icon or"house"})local tab=tabs[tabObj.name]local sec=addSection(tab,tabObj.name,icon("house"))buildHome(sec.page,o)return tabObj end function Window:SelectTab(i)local t=tabOrder[tonumber(i)or 1]if t then selectTab(t.name)end openFirstTime()end function Window:SetToggleKey(code)if typeof(code)=="EnumItem"then T.toggleKey=code end end function Window:GetDevice()return DEVICE end function Window:GetControlModes()return table.clone(CONTROL_MODES)end function Window:GetControlMode()return getControlMode()end function Window:SetControlMode(mode)return setControlMode(mode,true)end function Window:UsesKeybind()return keyEnabled end function Window:UsesButton()return floatBtn.Visible end function Window:SetUIScale(v)userScale=math.clamp(tonumber(v)or 1,0.5,2)if shown then tween(pop,0.25,{Scale=userScale})else pop.Scale=userScale end WIN.setSize(T.size)WIN.place(WIN.center())prefs.scale=userScale WIN.scaleSave=(WIN.scaleSave or 0)+1 local my=WIN.scaleSave task.delay(0.6,function()if WIN.scaleSave==my then savePrefs()end end)end function Window:GetUIScale()return userScale end function Window:SetSize(w,h)w,h=tonumber(w),tonumber(h)if not w or not h then return end WIN.setSize(Vector2.new(w,h))WIN.place(WIN.center(),true)WIN.save()end function Window:GetSize()return T.size end function Window:SetTheme(name)return applyTheme(name,true,true)end function Window:GetTheme()return currentTheme end function Window:Destroy()pcall(function()gui:Destroy()end)end function Window:Toggle()setShown(not shown)end function Window:Collapse(on)setCollapsed(on)end function Window:SetBlur(on)WIN.blur=on==true prefs.blur=WIN.blur savePrefs()if shown then WIN.blurTo(WIN.blur)end end function Window:GetBlur()return WIN.blur end function Window:SetOpacity(v)v=math.clamp(tonumber(v)or 1,0.6,1)WIN.alpha=1-v prefs.opacity=v savePrefs()if shown then tween(window,0.2,{GroupTransparency=WIN.alpha})end end function Window:GetOpacity()return 1-WIN.alpha end function Lib:CreateWindow(o)o=o or{}if typeof(o.ToggleKey)=="EnumItem"then T.toggleKey=o.ToggleKey end if o.Title or o.TitleAccent then setBrand(o.Title or"",o.TitleAccent or"")end if o.Author then brandSub.Text=tostring(o.Author)end if o.Icon then floatIcon.Image=icon(o.Icon)end if o.BadgeIcon then brandIcon.Image,brandIcon.Visible=icon(o.BadgeIcon),true local m=brandBadge:FindFirstChild("Monogram")if m then m.Visible=false end end if o.Theme and not prefs.theme then applyTheme(o.Theme,false,false)end if not o.NoAutoOpen then task.delay(2,openFirstTime)end return Window end function Lib:Notify(o)pcall(notify,o or{})end function Lib:Popup(o)pcall(popup,o or{})end function Lib:AddTheme(o)o=o or{}local base=o.Base or o.Background local accent=o.Accent if o.Name and typeof(base)=="Color3"and typeof(accent)=="Color3"then addTheme(o.Name,base,accent)if prefs.theme==tostring(o.Name)and currentTheme~=prefs.theme then applyTheme(prefs.theme,false,false)end end end function Lib:SetTheme(name)return applyTheme(name,true,true)end function Lib:GetThemes()return table.clone(THEME_ORDER)end function Lib:GetTheme()return currentTheme end function Lib:PresetSheet(tabObj,api)local Wd=api.words or{}local sg=tabObj:Current()local _,slot=row(sg,Wd.new or"New preset",Wd.desc or"Saves this game's settings under a name.")new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,px(8)),VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder},slot)local box=new("TextBox",{LayoutOrder=1,Size=UDim2.fromOffset(px(160),K.ctrlH),ClearTextOnFocus=false,BackgroundColor3=T.field,FontFace=T.font,TextSize=px(13),TextColor3=T.text,PlaceholderText=Wd.placeholder or"Preset name",PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,},slot)corner(box,px(9))local boxStroke=stroke(box,T.fieldLine)new("UIPadding",{PaddingLeft=UDim.new(0,px(10)),PaddingRight=UDim.new(0,px(10))},box)box.Focused:Connect(function()tween(boxStroke,0.2,{Color=C.accent})end)box.FocusLost:Connect(function()tween(boxStroke,0.2,{Color=T.fieldLine})end)local function pillButton(parent,iconName,text,light,order)local function rest()return light and C.accent or T.field end local function hot()return light and C.accent:Lerp(WHITE,0.15)or T.fieldHot end local function ink()return light and onAccent()or T.text end local b=new("TextButton",{LayoutOrder=order,Size=UDim2.fromOffset(textW(text,px(13),T.fontBold)+px(38),K.ctrlH),BackgroundColor3=rest(),AutoButtonColor=false,Text="",},parent)corner(b,px(9))if not light then stroke(b,T.fieldLine)end local s12=even(px(12))local ic=new("ImageLabel",{Position=UDim2.fromOffset(px(11),math.floor((K.ctrlH-s12)/2)),Size=UDim2.fromOffset(s12,s12),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=ink(),},b)local lb=new("TextLabel",{Position=UDim2.fromOffset(px(28),0),Size=UDim2.new(1,-px(32),1,0),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(13),TextColor3=ink(),TextXAlignment=Enum.TextXAlignment.Left,Text=text,},b)if light then onThemeChanged(function()if b.Parent then ic.ImageColor3,lb.TextColor3=ink(),ink()end end)end b.MouseEnter:Connect(function()tween(b,0.15,{BackgroundColor3=hot()})end)b.MouseLeave:Connect(function()tween(b,0.2,{BackgroundColor3=rest()})end)return b end local saveBtn=pillButton(slot,"save","Save",true,2)local function save()local name=box.Text:gsub("^%s+",""):gsub("%s+$","")if name==""then api.save(name)return end if api.exists(name)then popup({Title="Overwrite preset",Content=("A preset called \"%s\" already exists. Replace it with the current settings?"):format(name),Buttons={{Title="Cancel"},{Title="Overwrite",Variant="Primary",Callback=function()api.save(name)end}}})else api.save(name)end box.Text=""end STATE.connect(saveBtn.MouseButton1Click,save)STATE.connect(box.FocusLost,function(enter)if enter then save()end end)local listGroup=group(tabObj.page,Wd.list or"Saved presets")local sheet={}function sheet.rebuild()for _,c in ipairs(listGroup.card:GetChildren())do if c:IsA("Frame")then c:Destroy()end end listGroup.rows=0 local keep={}for _,it in ipairs(tabObj.page.rows)do if it.g~=listGroup then table.insert(keep,it)end end tabObj.page.rows=keep local names=api.names()local auto=api.autoload()if#names==0 then row(listGroup,Wd.empty or"No presets yet",Wd.emptyDesc or"Name one above and press Save.")return end for _,name in ipairs(names)do local _,s=row(listGroup,name,auto==name and(Wd.auto or"Loads when you join this game.")or nil,auto==name and{"On start"}or nil)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,px(6)),VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder},s)local star=new("ImageButton",{LayoutOrder=1,Size=UDim2.fromOffset(K.ctrlH,K.ctrlH),BackgroundTransparency=1,Image="",AutoButtonColor=false},s)local s14=even(px(14))new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(s14,s14),BackgroundTransparency=1,Image=ICON.star,ImageColor3=auto==name and C.amber or T.muted,},star)local load=pillButton(s,"play","Load",true,2)local del=new("ImageButton",{LayoutOrder=3,Size=UDim2.fromOffset(K.ctrlH,K.ctrlH),BackgroundColor3=T.field,Image="",AutoButtonColor=false},s)corner(del,px(9))stroke(del,T.fieldLine)local delIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(s14,s14),BackgroundTransparency=1,Image=ICON["trash-2"],ImageColor3=T.subtext,},del)del.MouseEnter:Connect(function()tween(delIcon,0.15,{ImageColor3=C.red})end)del.MouseLeave:Connect(function()tween(delIcon,0.2,{ImageColor3=T.subtext})end)star.MouseButton1Click:Connect(function()api.setAutoload(auto~=name and name or nil)end)load.MouseButton1Click:Connect(function()api.load(name)end)del.MouseButton1Click:Connect(function()popup({Title="Delete preset",Content=("Delete \"%s\"? This cannot be undone."):format(name),Buttons={{Title="Cancel"},{Title="Delete",Variant="Primary",Callback=function()api.delete(name)end}}})end)end end return sheet end Lib.ScreenGui=gui Lib.window=window Lib.select=selectTab Lib.selectSection=selectSection Lib.collapse=setCollapsed Lib.show=function()setShown(true)end Lib.hide=function()setShown(false)end Lib._k={T=T,C=C,ICON=ICON,icon=icon,px=px,even=even,new=new,corner=corner,stroke=stroke,tween=tween,THEMES=THEMES,THEME_ORDER=THEME_ORDER,applyTheme=applyTheme,theme=function()return currentTheme end,onThemeChanged=onThemeChanged,CTRL=CTRL,K=K,capture=capture,prefs=prefs,savePrefs=savePrefs,group=group,row=row,toggle=toggle,slider=slider,dropdown=dropdown,keybind=keybind,paragraph=paragraph,button=button,input=input,keyValue=keyValue,label=label,notify=notify,popup=popup,closePopup=function()if closePopup then closePopup()end end,tabs=tabs,selectTab=selectTab,setShown=setShown,isShown=function()return shown end,isOpened=function()return opened end,openFirstTime=openFirstTime,shell=shell,window=window,gui=gui,STATE=STATE,mine=mine,}return Lib end)()return(function()local k=WindUI._k local T,C=k.T,k.C local NOOP=function()end local Kit={VERSION=KIT_VERSION,Lib=WindUI}local function safe(fn,... )if type(fn)~="function"then return end local ok,err=pcall(fn,... )if not ok then warn("[SPECTREWARE] callback error: "..tostring(err))end end local function soft(t)return setmetatable(t,{__index=function(_,key)if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end local function toKeyCode(v)if typeof(v)=="EnumItem"then return v end if type(v)=="string"and v~=""then local ok,code=pcall(function()return Enum.KeyCode[v]end)if ok then return code end end return nil end local unloadHooks,unloaded={},false function Kit.OnUnload(fn)if type(fn)=="function"then table.insert(unloadHooks,fn)end end local function runHooks()if unloaded then return end unloaded=true for _,fn in ipairs(unloadHooks)do safe(fn)end end function Kit.Unload()runHooks()pcall(STATE.teardown)end STATE.onCleanup(runHooks)local function notify(cfg,kind)if type(cfg)~="table"then cfg={Content=tostring(cfg)}end local kd=tostring(cfg.Kind or cfg.Type or kind or""):lower()local ic=cfg.Icon if type(ic)~="string"or ic:find("^rbxasset")then ic=(kd=="success"and"check")or((kd=="warning"or kd=="warn")and"triangle-alert")or((kd=="error"or kd=="danger")and"x")or"info"end local content=tostring(cfg.Content or cfg.Text or cfg.Description or cfg.Desc or"")if cfg.SubContent and cfg.SubContent~=""then content=content.."\n"..tostring(cfg.SubContent)end pcall(k.notify,{Title=tostring(cfg.Title or cfg.Name or"SPECTREWARE"),Content=content,Duration=tonumber(cfg.Duration)or 4,Icon=ic,})end Kit.Notify=notify local Win,menuKeyCtrl local loadedFns={}local function open()if not Win then return end if not k.isOpened()then Win:SelectTab(1)for _,fn in ipairs(loadedFns)do task.spawn(safe,fn)end table.clear(loadedFns)else k.setShown(true)end end Kit.Open=open local touchToken=0 local function touch()if k.isOpened()then return end touchToken+=1 local my=touchToken task.delay(1.5,function()if my==touchToken and not k.isOpened()then open()end end)end local keyListeners={}local function rememberKey(code)if k.prefs.menuKey~=code.Name then k.prefs.menuKey=code.Name pcall(k.savePrefs)end for _,fn in ipairs(keyListeners)do safe(fn,code)end end function Kit.SetToggleKey(code)code=toKeyCode(code)if not code or not Win then return end Win:SetToggleKey(code)if menuKeyCtrl and menuKeyCtrl.Value~=code.Name then pcall(function()menuKeyCtrl:Set(code)end)end rememberKey(code)end function Kit.GetToggleKey()return k.T.toggleKey end function Kit.OnToggleKeyChanged(fn)if type(fn)=="function"then table.insert(keyListeners,fn)end end local function buildSettings()local S=Win:Tab({Title="Settings",Icon="settings"})S:SetOrder(10000)S:Section({Title="General"})S:Group("Device")S:Dropdown({Title="Menu Controls",Desc=("Detected: %s. Auto uses the %s. PC = keybind, Mobile = island at the top, PC + Mobile = both."):format(Win:GetDevice(),Win:GetDevice()=="PC"and"keybind"or"island at the top"),Values=Win:GetControlModes(),Value=Win:GetControlMode(),Search=false,Config=false,Callback=function(mode)Win:SetControlMode(mode)notify({Title="Menu Controls: "..mode,Kind="Success",Duration=3,Content=Win:UsesButton()and"Tap the island at the top to open or close the menu. Drag it to move it."or"Use your menu key to open or close the menu.",})end,})S:Group("Interface")menuKeyCtrl=S:Keybind({Title="Menu Toggle Key",Desc="Click and press a key to change the show/hide hotkey.",Value=T.toggleKey.Name,Callback=function(name)local code=toKeyCode(name)if code then Win:SetToggleKey(code)rememberKey(code)end end,})S:Group("Appearance")S:ThemePicker()S:Toggle({Title="Blur Background",Desc="Blur the game behind the menu while it is open.",Icon="droplet",Value=Win:GetBlur(),Callback=function(on)Win:SetBlur(on)end})S:Slider({Title="Window Opacity",Desc="Lower it to see the game through the menu. Below 100% text looks a little softer on phones.",Value={Min=60,Max=100,Default=math.floor(Win:GetOpacity()*100+0.5)},Step=5,Suffix="%",Callback=function(v)Win:SetOpacity(v/100)end})S:Slider({Title="UI Scale",Desc="Adjust the size of the menu window.",Value={Min=0.7,Max=1.3,Default=Win:GetUIScale()},Step=0.05,Callback=function(v)Win:SetUIScale(v)end})S:Group("Script")S:Button({Title="Unload Script",Desc="Stop every feature and remove the menu from the game.",Icon="power",Callback=function()k.popup({Title="Unload script?",Content="The menu and everything it runs will be removed from the game. You'll need to execute the script again to get it back.",Buttons={{Title="Cancel"},{Title="Unload",Variant="Primary",Callback=function()task.defer(Kit.Unload)end}},})end,})S:Section({Title="Configs"})S:ConfigManager()return S end function Kit.Init(cfg)if Win then return Win end cfg=cfg or{}Win=WindUI:CreateWindow({Title="SPECTRE",TitleAccent="WARE",Author="v"..KIT_VERSION,Icon="layers",ToggleKey=toKeyCode(k.prefs.menuKey)or toKeyCode(cfg.ToggleKey)or Enum.KeyCode.RightShift,NoAutoOpen=true,})Win:Home({Plan=cfg.Plan or"Free",ExpiresAt=cfg.ExpiresAt,TimeLeft=cfg.TimeLeft})buildSettings()k.STATE.connect(k.shell:GetPropertyChangedSignal("Visible"),function()local v=k.shell.Visible if v==k.isShown()then return end if v then k.shell.Visible=false open()else k.setShown(false)end end)task.delay(8,function()if not k.isOpened()then open()end end)return Win end Kit.Window=function()return Win end local function gameTab(name,iconName)name=tostring(name or"Tab")local low=name:lower()if low=="settings"or low=="setting"then local tabObj=Win:Tab({Title="Settings"})tabObj:Section({Title="Game"})return tabObj,"Settings"end if low=="home"then name="Overview"end local tabObj=Win:Tab({Title=name,Icon=iconName})tabObj:Section({Title=name})touch()return tabObj,name end local THEME_FACE={Font=Enum.Font.GothamMedium,FontBold=Enum.Font.GothamBold,Text=T.text,SubText=T.subtext,Accent=C.accent,Background=T.bg,Panel=T.side,Card=T.card,Control=T.field,Border=T.border,}local function findTab(list,x)if type(x)=="number"then return list[x]end if type(x)=="string"then for _,t in ipairs(list)do if t.Name==x then return t end end return nil end return x end local function titleLabelOf(entry)local r=type(entry)=="table"and entry.row or nil local col=r and r:FindFirstChild("Text")local line=col and col:FindFirstChild("TitleLine")return line and line:FindFirstChild("Title")end local function ctrlObj(get)return setmetatable({},{__index=function(_,key)if key=="Value"then return get()end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end local function dialog(cfg)cfg=cfg or{}local buttons={}local list=cfg.Buttons or{}for i,b in ipairs(list)do buttons[i]={Title=tostring(b.Title or b.Name or"OK"),Variant=(b.Primary or b.Variant=="Primary"or i==#list)and"Primary"or nil,Callback=function()safe(b.Callback)end,}end if#buttons==0 then buttons={{Title="OK",Variant="Primary"}}end k.popup({Title=tostring(cfg.Title or""),Content=tostring(cfg.Content or cfg.Text or""),Buttons=buttons})end local function setTheme(name)name=tostring(name)if k.THEMES[name]then k.applyTheme(name,true,true)end end local SUI={Flags={},Objects={},Themes={},Version=KIT_VERSION,_flagCbs={}}local function setFlag(cfg,v)if not cfg.Flag then return end local prev=SUI.Flags[cfg.Flag]SUI.Flags[cfg.Flag]=v if prev~=v then for _,cb in ipairs(SUI._flagCbs)do safe(cb,cfg.Flag,v,prev)end end end local function reg(cfg,obj)if cfg.Flag then SUI.Objects[cfg.Flag]=obj end touch()return obj end local function nameOf(cfg,fallback)return tostring(cfg.Name or cfg.Title or cfg.Text or fallback)end local function descOf(cfg)return cfg.Tooltip or cfg.Description or cfg.Desc or cfg.Info end local SectionM={}local function newSection(g)local s={_g=g,Body=g.card,Frame=g.holder,Controls={},Window={Theme=THEME_FACE}}return setmetatable(s,{__index=function(_,key)local m=SectionM[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end function SectionM:CreateToggle(cfg)cfg=type(cfg)=="table"and cfg or{Name=cfg}local silent=false local raw=k.toggle(self._g,{Title=nameOf(cfg,"Toggle"),Desc=descOf(cfg),Value=cfg.Default==true or cfg.CurrentValue==true,Flag=cfg.Flag,Config=cfg.Config,Callback=function(v)setFlag(cfg,v)if not silent then safe(cfg.Callback,v)end end,})setFlag(cfg,raw.Value)local obj=ctrlObj(function()return raw.Value end)function obj:Set(v,s)silent=s==true raw:Set(v and true or false)silent=false end function obj:Get()return raw.Value end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end function SectionM:CreateSlider(cfg)cfg=cfg or{}local silent=false local range=type(cfg.Range)=="table"and cfg.Range or{}local mn,mx=tonumber(cfg.Min or range[1])or 0,tonumber(cfg.Max or range[2])or 100 local raw=k.slider(self._g,{Title=nameOf(cfg,"Slider"),Desc=descOf(cfg),Value={Min=mn,Max=mx,Default=tonumber(cfg.Default or cfg.CurrentValue)or mn},Step=tonumber(cfg.Increment or cfg.Step)or 1,Suffix=cfg.Suffix,Flag=cfg.Flag,Config=cfg.Config,Callback=function(v)setFlag(cfg,v)if not silent then safe(cfg.Callback,v)end end,})setFlag(cfg,raw.Value)local obj=ctrlObj(function()return raw.Value end)function obj:Set(v,s)silent=s==true raw:Set(v)silent=false end function obj:Get()return raw.Value end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end function SectionM:CreateDropdown(cfg)cfg=cfg or{}local silent=false local multi=cfg.Multi==true or cfg.MultipleOptions==true local default=cfg.Default if default==nil then default=cfg.CurrentOption end local raw=k.dropdown(self._g,{Title=nameOf(cfg,"Dropdown"),Desc=descOf(cfg),Values=cfg.Options or cfg.Values or{},Value=default,Multi=multi,AllowNone=default==nil,Search=cfg.Searchable,Flag=cfg.Flag,Config=cfg.Config,Callback=function(v)setFlag(cfg,v)if not silent then safe(cfg.Callback,v)end end,})setFlag(cfg,raw.Value)local obj=ctrlObj(function()return raw.Value end)function obj:Set(v,s)silent=s==true raw:Select(v)silent=false end function obj:Get()return raw.Value end function obj:Refresh(list)raw:Refresh(list or{})end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end function SectionM:CreateButton(cfg,cb)cfg=type(cfg)=="table"and cfg or{Name=cfg,Callback=cb}local raw=k.button(self._g,{Title=nameOf(cfg,"Button"),Desc=descOf(cfg),Icon=cfg.Icon,Callback=function()safe(cfg.Callback)end,})local obj=soft({Frame=raw.entry and raw.entry.row})function obj:SetText(t)local l=titleLabelOf(raw.entry)if l then l.Text=tostring(t)end end obj.SetTitle=obj.SetText function obj:Fire()raw.Run()end touch()return obj end function SectionM:CreateTextbox(cfg)cfg=cfg or{}local silent=false local raw=k.input(self._g,{Title=nameOf(cfg,"Text"),Desc=descOf(cfg),Value=cfg.Default or cfg.CurrentValue,Placeholder=cfg.Placeholder or cfg.PlaceholderText,Numeric=cfg.Numeric,Min=cfg.Min,Max=cfg.Max,MaxLength=cfg.MaxLength,ClearOnFocus=cfg.ClearOnFocus or cfg.ClearTextOnFocus,Live=cfg.Live==true,Flag=cfg.Flag,Config=cfg.Config,Callback=function(v)setFlag(cfg,v)if not silent then safe(cfg.Callback,v)end end,})setFlag(cfg,raw.Value)local obj=ctrlObj(function()return raw.Value end)function obj:Set(v,s)silent=s==true raw:Set(v)silent=false end function obj:Get()return raw.Value end function obj:GetText()return raw.Box.Text end function obj:Clear()raw.Box.Text=""end function obj:Focus()raw.Box:CaptureFocus()end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end SectionM.CreateInput=SectionM.CreateTextbox local function keyMatches(raw,input)local v=raw.Value if not v then return false end if input.KeyCode~=Enum.KeyCode.Unknown then return input.KeyCode.Name==v end return input.UserInputType.Name==v end function SectionM:CreateKeybind(cfg)cfg=cfg or{}local mode=cfg.Mode or"Press"local state,silent=false,false local d=toKeyCode(cfg.Default)local raw=k.keybind(self._g,{Title=nameOf(cfg,"Keybind"),Desc=descOf(cfg),Value=d and d.Name or(type(cfg.Default)=="string"and cfg.Default or nil),Flag=cfg.Flag,Config=cfg.Config,Callback=function(name)local code=toKeyCode(name)setFlag(cfg,code)state=false if not silent then safe(cfg.Changed or cfg.ChangedCallback,code)end end,})setFlag(cfg,toKeyCode(raw.Value))k.STATE.connect(UIS.InputBegan,function(input,gp)if gp or raw.Picking or k.capture.active or not k.mine()then return end if not keyMatches(raw,input)then return end if mode=="Hold"then state=true safe(cfg.Callback,true)elseif mode=="Toggle"then state=not state safe(cfg.Callback,state)else safe(cfg.Callback)end end)k.STATE.connect(UIS.InputEnded,function(input)if mode=="Hold"and state and keyMatches(raw,input)then state=false safe(cfg.Callback,false)end end)local obj=ctrlObj(function()return toKeyCode(raw.Value)end)function obj:Set(v,s)silent=s==true raw:Set(toKeyCode(v)or v)silent=false end function obj:Get()return toKeyCode(raw.Value)end function obj:GetState()return state end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end function SectionM:CreateParagraph(cfg)cfg=cfg or{}local raw=k.paragraph(self._g,{Title=tostring(cfg.Title or cfg.Name or""),Desc=tostring(cfg.Content or cfg.Desc or cfg.Text or"")})local obj=soft({})function obj:Set(t,c)if t~=nil then raw:SetTitle(t)end if c~=nil then raw:SetDesc(c)end end function obj:SetTitle(t)raw:SetTitle(t)end function obj:SetDesc(t)raw:SetDesc(t)end obj.SetContent=obj.SetDesc touch()return obj end function SectionM:CreateLabel(cfg)cfg=type(cfg)=="table"and cfg or{Text=cfg}local raw=k.label(self._g,{Text=cfg.Text or cfg.Name or"",Color=cfg.Color,Bold=cfg.Bold})local obj=soft({Frame=raw.Frame})function obj:Set(t)raw:Set(t)end function obj:SetColor(c)raw:SetColor(c)end return obj end function SectionM:CreateKeyValue(cfg)cfg=cfg or{}local raw=k.keyValue(self._g,{Title=nameOf(cfg,""),Value=cfg.Value,Color=cfg.Color})local obj=ctrlObj(function()return raw.Value end)function obj:Set(v)raw:Set(v)end function obj:Get()return raw.Value end function obj:SetColor(c)raw:SetColor(c)end return obj end function SectionM:CreateColorPicker(cfg)cfg=cfg or{}local value=cfg.Default or Color3.new(1,1,1)local obj=ctrlObj(function()return value end)function obj:Set(c,s)value=c if not s then safe(cfg.Callback,c)end end function obj:Get()return value end return reg(cfg,obj)end function SectionM:CreateDivider()return soft({})end SectionM.CreateSeparator=SectionM.CreateDivider function SectionM:SetCollapsed(on)if self._g.setFolded then self._g.setFolded(on==true,true)end end local TabM={}local function newSTab(tabObj,name)local t={_tabObj=tabObj,Name=name,Sections={},Window={Theme=THEME_FACE}}return setmetatable(t,{__index=function(_,key)local m=TabM[key]if m~=nil then return m end if type(key)=="string"and SectionM[key]then return function(self,... )return SectionM[key](self:_implicit(),... )end end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end function TabM:CreateSection(cfg)local title=type(cfg)=="table"and(cfg.Name or cfg.Title)or cfg title=(title~=nil and tostring(title)~="")and tostring(title)or nil local g=self._tabObj:Group(title)local s=newSection(g)table.insert(self.Sections,s)if type(cfg)=="table"and cfg.Collapsed and g.setFolded then task.defer(g.setFolded,true,false)end touch()return s end function TabM:_implicit()local first=rawget(self,"_first")if not first then first=self:CreateSection(nil)rawset(self,"_first",first)end return first end function TabM:Select()self._tabObj:Select()end local SWindowM={}local function newSWindow()local w={Tabs={},Conns={},Main=k.shell,Root=k.shell,Theme=THEME_FACE}return setmetatable(w,{__index=function(_,key)if key=="Visible"then return k.isShown()end if key=="ThemeName"then return k.theme()end local m=SWindowM[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end function SWindowM:CreateTab(cfg,iconName)local name=type(cfg)=="table"and(cfg.Name or cfg.Title)or cfg local tabObj,shownName=gameTab(name,type(cfg)=="table"and cfg.Icon or iconName)local t=newSTab(tabObj,shownName)table.insert(self.Tabs,t)return t end function SWindowM:SelectTab(x)if not k.isOpened()then return end local t=findTab(self.Tabs,x)if type(t)=="table"and t._tabObj then t._tabObj:Select()end end SWindowM.SetTab=SWindowM.SelectTab SWindowM.Goto=SWindowM.SelectTab function SWindowM:GetTab(name)return findTab(self.Tabs,name)end function SWindowM:Notify(cfg)notify(cfg)end function SWindowM:Toast(text,kind)notify({Title=kind and tostring(kind)or"SPECTREWARE",Content=text,Kind=kind})end function SWindowM:Info(t,c,d)notify({Title=t,Content=c,Duration=d})end function SWindowM:Success(t,c,d)notify({Title=t,Content=c,Duration=d,Kind="Success"})end function SWindowM:Warning(t,c,d)notify({Title=t,Content=c,Duration=d,Kind="Warning"})end function SWindowM:Error(t,c,d)notify({Title=t,Content=c,Duration=d,Kind="Error"})end function SWindowM:SetVisible(v)if v then open()else k.setShown(false)end end function SWindowM:Toggle()if k.isShown()then k.setShown(false)else open()end end function SWindowM:Open()open()end function SWindowM:Close()k.setShown(false)end function SWindowM:Resize(w,h)Win:SetSize(w,h)end SWindowM.SetSize=SWindowM.Resize function SWindowM:IsOpen()return k.isShown()end function SWindowM:Destroy()Kit.Unload()end SWindowM.Unload=SWindowM.Destroy function SWindowM:SetTheme(name)setTheme(name)end function SWindowM:GetThemeName()return k.theme()end function SWindowM:SetToggleKey(key)Kit.SetToggleKey(key)end function SWindowM:GetToggleKey()return T.toggleKey end function SWindowM:OnLoaded(fn)if k.isOpened()then task.spawn(safe,fn)else table.insert(loadedFns,fn)end end function SWindowM:FinishLoading()open()end function SWindowM:CreateDefaultTabs()return nil end function SWindowM:CreateSettingsTab()local tabObj=gameTab("Settings")return newSTab(tabObj,"Settings")end SWindowM.CreateThemeTab=SWindowM.CreateSettingsTab function SWindowM:Dialog(cfg)dialog(cfg)end function SWindowM:Confirm(cfg)cfg=cfg or{}k.popup({Title=tostring(cfg.Title or"Are you sure?"),Content=tostring(cfg.Content or cfg.Text or""),Buttons={{Title=tostring(cfg.No or cfg.Cancel or"Cancel"),Callback=function()safe(cfg.Callback,false)end},{Title=tostring(cfg.Yes or cfg.Confirm or"Confirm"),Variant="Primary",Callback=function()safe(cfg.Callback,true)end},},})end function SWindowM:Watermark()return soft({})end function SWindowM:KeybindList()return soft({})end local theWindow function SUI:CreateWindow(cfg)cfg=cfg or{}Kit.Init({ToggleKey=cfg.ToggleKey})theWindow=theWindow or newSWindow()return theWindow end function SUI:Notify(cfg)notify(cfg)end function SUI:Toast(text,kind)notify({Title=kind and tostring(kind)or"SPECTREWARE",Content=text,Kind=kind})end function SUI:SetTheme(name)setTheme(name)end function SUI:ListThemes()return table.clone(k.THEME_ORDER)end function SUI:GetTheme(name)return k.THEMES[tostring(name or k.theme())]end function SUI:OnFlag(cb)table.insert(SUI._flagCbs,cb)return{Disconnect=function()local i=table.find(SUI._flagCbs,cb)if i then table.remove(SUI._flagCbs,i)end end}end function SUI:SetFlag(flag,v,silent)local o=SUI.Objects[flag]if o and o.Set then o:Set(v,silent)end end function SUI:GetFlags()return table.clone(SUI.Flags)end function SUI:GetControl(flag)return SUI.Objects[flag]end function SUI:Unload()Kit.Unload()end function SUI:Copy(text)local set=setclipboard or toclipboard if set then pcall(set,tostring(text))notify({Title="Copied",Content=tostring(text),Kind="Success",Duration=2})end end function SUI:Dialog(cfg)dialog(cfg)end function SUI:Confirm(cfg)if theWindow then theWindow:Confirm(cfg)end end setmetatable(SUI,{__index=function(_,key)if key=="ThemeName"then return k.theme()end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})Kit.SpectreUI=SUI local FL={Options={},Themes=table.clone(k.THEME_ORDER),OpenFrames={},Version=KIT_VERSION}local HandleM={}local function newHandle(kind,id,get,set)local h={Type=kind,_changed={},_get=get,_set=set}setmetatable(h,{__index=function(_,key)if key=="Value"then return get()end local m=HandleM[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end,__newindex=function(t,key,v)if key=="Value"then set(v)else rawset(t,key,v)end end,})if id then FL.Options[id]=h end touch()return h end function HandleM:OnChanged(fn)if type(fn)=="function"then table.insert(self._changed,fn)end end function HandleM:SetValue(v)self._set(v)end function HandleM:GetValue()return self._get()end function HandleM:_fire(... )for _,fn in ipairs(self._changed)do safe(fn,... )end end function HandleM:Destroy()local r=rawget(self,"_row")if r then r.Visible=false end end function HandleM:SetDesc(text)local r=rawget(self,"_row")local col=r and r:FindFirstChild("Text")if not col then return end text=tostring(text or"")local d=col:FindFirstChild("Desc")if not d then if text==""then return end d=k.new("TextLabel",{Name="Desc",LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=k.K.desc,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text=text,},col)end d.Text=text end function HandleM:SetTitle(text)local lbl=titleLabelOf({row=rawget(self,"_row")})if lbl then lbl.Text=tostring(text or"")end end local function toMap(list)local m={}if type(list)=="table"then for key,v in pairs(list)do if type(key)=="number"then m[v]=true elseif v then m[key]=true end end end return m end local function hex(c)return("#%02X%02X%02X"):format(math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))end local Adders={}function Adders:AddToggle(id,cfg)cfg=cfg or{}local h local raw=k.toggle(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Value=cfg.Default==true,Flag=id,Callback=function(v)safe(cfg.Callback,v)if h then h:_fire(v)end end,})h=newHandle("Toggle",id,function()return raw.Value end,function(v)raw:Set(v==true)end)rawset(h,"_row",raw.entry and raw.entry.row)return h end function Adders:AddSlider(id,cfg)cfg=cfg or{}local h local rounding=tonumber(cfg.Rounding)or 0 local step=tonumber(cfg.Step or cfg.Increment)or(10^-math.max(rounding,0))local mn,mx=tonumber(cfg.Min)or 0,tonumber(cfg.Max)or 100 local raw=k.slider(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Value={Min=mn,Max=mx,Default=tonumber(cfg.Default)or mn},Step=step,Suffix=cfg.Suffix,Flag=id,Callback=function(v)safe(cfg.Callback,v)if h then h:_fire(v)end end,})h=newHandle("Slider",id,function()return raw.Value end,function(v)raw:Set(tonumber(v)or mn)end)rawset(h,"_row",raw.entry and raw.entry.row)return h end function Adders:AddDropdown(id,cfg)cfg=cfg or{}local h local values=cfg.Values or cfg.Options or{}local multi=cfg.Multi==true local default=cfg.Default if type(default)=="number"and values[default]~=nil then default=values[default]end local function out(v)if multi then return toMap(v)end return v end local raw=k.dropdown(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Values=values,Value=default,Multi=multi,AllowNone=cfg.AllowNull==true or default==nil,Search=cfg.Searchable,Flag=id,Callback=function(v)safe(cfg.Callback,out(v))if h then h:_fire(out(v))end end,})h=newHandle("Dropdown",id,function()return out(raw.Value)end,function(v)raw:Select(v)end)rawset(h,"_row",raw.entry and raw.entry.row)rawset(h,"Multi",multi)rawset(h,"Values",values)function h:SetValues(list)rawset(h,"Values",list or{})raw:Refresh(list or{})end return h end function Adders:AddInput(id,cfg)cfg=cfg or{}local h local raw=k.input(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Value=cfg.Default,Placeholder=cfg.Placeholder,Numeric=cfg.Numeric,MaxLength=cfg.MaxLength,Live=cfg.Finished~=true,Flag=id,Callback=function(v)safe(cfg.Callback,v)if h then h:_fire(v)end end,})h=newHandle("Input",id,function()return raw.Value end,function(v)raw:Set(v)end)rawset(h,"_row",raw.entry and raw.entry.row)return h end function Adders:AddKeybind(id,cfg)cfg=cfg or{}local mode,state=cfg.Mode or"Toggle",false local clicks={}local h local raw=k.keybind(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Value=typeof(cfg.Default)=="EnumItem"and cfg.Default.Name or cfg.Default,Flag=id,Callback=function(name)state=false safe(cfg.ChangedCallback,toKeyCode(name)or name)if h then h:_fire(name)end end,})k.STATE.connect(UIS.InputBegan,function(input,gp)if gp or raw.Picking or k.capture.active or not k.mine()or not keyMatches(raw,input)then return end if mode=="Hold"then state=true else state=not state end safe(cfg.Callback,state)for _,fn in ipairs(clicks)do safe(fn)end end)k.STATE.connect(UIS.InputEnded,function(input)if mode=="Hold"and state and keyMatches(raw,input)then state=false safe(cfg.Callback,false)end end)h=newHandle("Keybind",id,function()return raw.Value end,function(v)raw:Set(toKeyCode(v)or v)end)rawset(h,"_row",raw.entry and raw.entry.row)rawset(h,"Mode",mode)function h:GetState()if mode=="Always"then return true end return state end function h:OnClick(fn)table.insert(clicks,fn)end function h:SetValue(key,newMode)if newMode then mode=newMode rawset(h,"Mode",newMode)end raw:Set(toKeyCode(key)or key)end return h end function Adders:AddButton(cfg)cfg=cfg or{}local raw=k.button(self._g,{Title=tostring(cfg.Title or"Button"),Desc=cfg.Description or cfg.Desc,Icon=cfg.Icon,Callback=function()safe(cfg.Callback)end,})local h=newHandle("Button",nil,NOOP,NOOP)rawset(h,"_row",raw.entry and raw.entry.row)function h:SetTitle(t)local l=titleLabelOf(raw.entry)if l then l.Text=tostring(t)end end h.SetText=h.SetTitle function h:SetDesc()end return h end function Adders:AddParagraph(cfg)cfg=cfg or{}local raw=k.paragraph(self._g,{Title=tostring(cfg.Title or""),Desc=tostring(cfg.Content or cfg.Description or"")})local h=newHandle("Paragraph",nil,NOOP,NOOP)function h:SetTitle(t)raw:SetTitle(t)end function h:SetDesc(t)raw:SetDesc(t)end h.SetContent=h.SetDesc function h:SetValue(t)raw:SetDesc(t)end return h end Adders.AddBanner=Adders.AddParagraph function Adders:AddColorpicker(id,cfg)cfg=cfg or{}local value=cfg.Default or Color3.new(1,1,1)local raw=k.keyValue(self._g,{Title=tostring(cfg.Title or id),Value=hex(value)})local h=newHandle("Colorpicker",id,function()return value end,function(c)value=c raw:Set(hex(c))safe(cfg.Callback,c)end)rawset(h,"Transparency",cfg.Transparency or 0)function h:SetValueRGB(c)h:SetValue(c)end return h end Adders.AddColorPicker=Adders.AddColorpicker local function newFSection(g)local s={_g=g,Container=g.card}return setmetatable(s,{__index=function(_,key)local m=Adders[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end local FTabM={}local function newFTab(tabObj,name)local t={_tabObj=tabObj,Name=name}return setmetatable(t,{__index=function(_,key)local m=FTabM[key]if m~=nil then return m end if type(key)=="string"and Adders[key]then return function(self,... )return Adders[key](self:_implicit(),... )end end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end function FTabM:AddSection(cfg)local title=type(cfg)=="table"and(cfg.Title or cfg.Name)or cfg title=(title~=nil and tostring(title)~="")and tostring(title)or nil touch()return newFSection(self._tabObj:Group(title))end function FTabM:_AddGroup(title,desc)local s=self:AddSection(title)if desc and desc~=""then k.label(s._g,{Text=tostring(desc)})end return s end function FTabM:_implicit()local first=rawget(self,"_first")if not first then first=newFSection(self._tabObj:Group(nil))rawset(self,"_first",first)end return first end function FTabM:Select()self._tabObj:Select()end local FWindowM={}local function newFWindow()local back={Tabs={},Root=k.shell}return setmetatable({},{__index=function(_,key)if key=="Minimized"then return not k.isShown()end if key=="Destroyed"or key=="Unloaded"then return unloaded end local v=rawget(back,key)if v~=nil then return v end local m=FWindowM[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end,__newindex=function(_,key,v)if key=="Minimized"then return end if key=="MinimizeKey"then Kit.SetToggleKey(v)end back[key]=v end,})end function FWindowM:AddTab(cfg)cfg=type(cfg)=="table"and cfg or{Title=cfg}local tabObj,shownName=gameTab(cfg.Title or cfg.Name,cfg.Icon)local t=newFTab(tabObj,shownName)table.insert(self.Tabs,t)return t end function FWindowM:SelectTab(x)if not k.isOpened()then return end local t=findTab(self.Tabs,x)if type(t)=="table"and t._tabObj then t._tabObj:Select()end end function FWindowM:Minimize()if k.isShown()then k.setShown(false)else open()end end function FWindowM:Dialog(cfg)dialog(cfg)end function FWindowM:Resize(w,h)Win:SetSize(w,h)end FWindowM.SetSize=FWindowM.Resize function FWindowM:Destroy()Kit.Unload()end local fluentWindow function FL:CreateWindow(cfg)cfg=cfg or{}Kit.Init({ToggleKey=cfg.MinimizeKey})fluentWindow=fluentWindow or newFWindow()return fluentWindow end function FL:Notify(cfg)notify(cfg)end function FL:SetTheme(name)setTheme(name)end function FL:Destroy()Kit.Unload()end local fluentMinimizeKey setmetatable(FL,{__index=function(_,key)if key=="Theme"then return k.theme()end if key=="Unloaded"then return unloaded end if key=="MinimizeKey"then return fluentMinimizeKey end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end,__newindex=function(t,key,v)if key=="MinimizeKey"then fluentMinimizeKey=v Kit.SetToggleKey(v)return end rawset(t,key,v)end,})Kit.Fluent=FL return Kit end)() end)() -- SPECTREWARE UI v1.0.3 (built in by ui/build.py; edit ui/SpectreUI.lua + ui/faces.lua)
local Library = SPECTREWARE_UI.SpectreUI

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

-- Unload (Settings > Script) or running the script again stops every loop
SPECTREWARE_UI.OnUnload(function()
	if getgenv().JumpAnimalsGen == V then getgenv().JumpAnimalsAlive = false end
	pcall(function()
		if getgenv().JumpAnimals_MiniIcon then
			getgenv().JumpAnimals_MiniIcon:Destroy()
			getgenv().JumpAnimals_MiniIcon = nil
		end
	end)
end)

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

local Window
local function saveMenuKey(k)
	pcall(function()
		if makefolder and isfolder and not isfolder("SpecreWare") then makefolder("SpecreWare") end
		if writefile then writefile("SpecreWare/JFAMenuKey.txt", k.Name) end
	end)
end

-- the menu key is handled by the UI (Settings > Interface > Menu Toggle Key)
local function setMinimizeKey(k)
	if type(k) == "string" then
		local ok, ek = pcall(function() return Enum.KeyCode[k] end)
		k = ok and ek or nil
	end
	if typeof(k) == "EnumItem" and k.EnumType == Enum.KeyCode then
		currentToggleKey = k
		SPECTREWARE_UI.SetToggleKey(k)
		saveMenuKey(k)
	end
end
SPECTREWARE_UI.OnToggleKeyChanged(function(k)
	currentToggleKey = k
	saveMenuKey(k)
end)

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

Window.SetToggleKey = function(_, k) setMinimizeKey(k) end

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
