-- SpectreWare | Run A Restaurant
-- UI: SPECTREWARE UI v1.0.0 (built into this file; see the SPECTREWARE_UI line below)
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
  -- The whole UI library is the single line below (made by ui/build.py).
  local SPECTREWARE_UI=(function() local KIT_VERSION="1.0.0"local Players=game:GetService("Players")local RunService=game:GetService("RunService")local UIS=game:GetService("UserInputService")if not game:IsLoaded()then game.Loaded:Wait()end local LP=Players.LocalPlayer while not LP do Players:GetPropertyChangedSignal("LocalPlayer"):Wait()LP=Players.LocalPlayer end local GEN=(getgenv().__MonoGen or 0)+1 getgenv().__MonoGen=GEN local function mine()return getgenv().__MonoGen==GEN end local SESSION_START=os.clock()local STATE do local prev=getgenv().__MonoState if prev then pcall(prev.teardown)end local conns,cleanups,living={},{},true STATE={connect=function(signal,fn)local c=signal:Connect(fn)table.insert(conns,c)return c end,onCleanup=function(fn)table.insert(cleanups,fn)end,alive=function()return living end,teardown=function()living=false for _,fn in ipairs(cleanups)do pcall(fn)end for _,c in ipairs(conns)do pcall(function()c:Disconnect()end)end table.clear(conns)table.clear(cleanups)end,}getgenv().__MonoState=STATE end local WindUI=(function()local TweenService=game:GetService("TweenService")local TextService=game:GetService("TextService")local Stats=game:GetService("Stats")local MarketplaceService=game:GetService("MarketplaceService")local TeleportService=game:GetService("TeleportService")local HttpService=game:GetService("HttpService")local ContentProvider=game:GetService("ContentProvider")local BASE_W,BASE_H=880,580 local TOUCH=UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled local DEVICE,S,VP="PC",1,Vector2.new(1920,1080)do local cam=workspace.CurrentCamera local vp=cam and cam.ViewportSize or VP if vp.Y<10 then vp=VP end VP=vp local short=math.min(vp.X,vp.Y)if TOUCH then DEVICE=short<500 and"Phone"or"Tablet"end if DEVICE=="Phone"then S=math.clamp(short/470,0.8,1)else S=math.clamp(vp.Y/1080,0.85,1.35)S=math.max(0.55,math.min(S,vp.X*0.94/BASE_W,vp.Y*0.9/BASE_H))end end local HOVER=not TOUCH local function px(n)return math.floor(n*S+0.5)end local function even(n)n=math.floor(n+0.5)return n%2==1 and n+1 or n end local WHITE=Color3.new(1,1,1)local PALETTE_KEYS={"bg","side","card","popup","field","rowHover","divider","rowLine","fieldHot","rowActive","cardLine","track","fieldLine","border","fieldLineHot","muted","subtext","text",}local MIX={bg=0,side=0.012,card=0.026,popup=0.036,field=0.046,rowHover=0.056,divider=0.068,rowLine=0.076,fieldHot=0.084,rowActive=0.094,cardLine=0.104,track=0.118,fieldLine=0.132,border=0.146,fieldLineHot=0.22,muted=0.42,subtext=0.62,}local LIGHT=Color3.fromRGB(235,238,245)local FIXED={{96,165,250},{167,139,250},{248,113,113},{251,176,80},{110,231,160},{244,114,182},{45,212,191},{255,255,255},{0,0,0},{196,202,216},{245,245,247},{170,174,184},{150,154,166},}local function makePalette(base,accent)local p={accent=accent}local tint=LIGHT:Lerp(accent,0.14)for k,a in pairs(MIX)do p[k]=base:Lerp(tint,a)end p.text=Color3.fromRGB(238,240,244):Lerp(accent,0.04)local used={}local function k3(r,g,b)return r*65536+g*256+b end local function mark(c)used[k3(math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))]=true end for _,f in ipairs(FIXED)do used[k3(f[1],f[2],f[3])]=true end mark(accent)for _,a in ipairs({0.15,0.2,0.25,0.35})do mark(accent:Lerp(Color3.new(1,1,1),a))end for _,k in ipairs(PALETTE_KEYS)do local c=p[k]local r,g,b=math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5)local step=b>=250 and-1 or 1 while used[k3(r,g,b)]do b+=step end used[k3(r,g,b)]=true p[k]=Color3.fromRGB(r,g,b)end return p end local THEMES,THEME_ORDER={},{}local function addTheme(name,base,accent)name=tostring(name)if not THEMES[name]then table.insert(THEME_ORDER,name)end THEMES[name]={name=name,palette=makePalette(base,accent)}end addTheme("Midnight",Color3.fromRGB(16,18,32),Color3.fromRGB(129,148,230))addTheme("Mono",Color3.fromRGB(12,12,13),Color3.fromRGB(228,228,232))addTheme("Ocean",Color3.fromRGB(8,22,26),Color3.fromRGB(102,178,214))addTheme("Emerald",Color3.fromRGB(11,23,18),Color3.fromRGB(98,196,156))addTheme("Crimson",Color3.fromRGB(28,12,14),Color3.fromRGB(224,104,120))addTheme("Amethyst",Color3.fromRGB(24,14,32),Color3.fromRGB(164,140,224))addTheme("Sunset",Color3.fromRGB(27,20,11),Color3.fromRGB(226,156,102))addTheme("Sakura",Color3.fromRGB(26,14,24),Color3.fromRGB(222,140,178))addTheme("Nord",Color3.fromRGB(24,28,35),Color3.fromRGB(136,176,196))local PREFS_DIR,PREFS_FILE="MonoUI","MonoUI/settings.json"local prefs={}pcall(function()if isfile and readfile and isfile(PREFS_FILE)then local data=HttpService:JSONDecode(readfile(PREFS_FILE))if type(data)=="table"then prefs=data end end end)local function savePrefs()pcall(function()if not writefile then return end if makefolder and isfolder and not isfolder(PREFS_DIR)then makefolder(PREFS_DIR)end writefile(PREFS_FILE,HttpService:JSONEncode(prefs))end)end local HEX={}function HEX.to(s)s=tostring(s or""):gsub("[#%s]","")if#s~=6 or s:find("[^%x]")then return nil end return Color3.fromRGB(tonumber(s:sub(1,2),16),tonumber(s:sub(3,4),16),tonumber(s:sub(5,6),16))end function HEX.from(c)return("#%02X%02X%02X"):format(math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))end do local cu=type(prefs.custom)=="table"and prefs.custom or{}addTheme("Custom",HEX.to(cu.base)or Color3.fromRGB(14,17,24),HEX.to(cu.accent)or Color3.fromRGB(236,72,153))end local GAME_KEY=tostring((game.GameId and game.GameId~=0)and game.GameId or game.PlaceId)local currentTheme=THEMES[prefs.theme]and prefs.theme or"Midnight"local START=THEMES[currentTheme].palette local C={accent=START.accent,blue=Color3.fromRGB(96,165,250),purple=Color3.fromRGB(167,139,250),red=Color3.fromRGB(248,113,113),amber=Color3.fromRGB(251,176,80),green=Color3.fromRGB(110,231,160),pink=Color3.fromRGB(244,114,182),teal=Color3.fromRGB(45,212,191),}local T={font=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.Medium),fontSemi=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.SemiBold),fontBold=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.Bold),mono=Font.new("rbxasset://fonts/families/RobotoMono.json",Enum.FontWeight.Medium),size=Vector2.new(even(math.min(BASE_W*S,VP.X*0.96-2)),even(math.min(BASE_H*S,VP.Y*0.92-2))),radius=px(14),toggleKey=Enum.KeyCode.Z,}local function setPalette(p)for _,k in ipairs(PALETTE_KEYS)do T[k]=p[k]end C.accent=p.accent end setPalette(START)local function lum(c)return 0.2126*c.R+0.7152*c.G+0.0722*c.B end local function onAccent()return lum(C.accent)>0.5 and T.bg or WHITE end local function knobOn()return lum(C.accent)>0.8 and T.bg or WHITE end local ICON={["axe"]="rbxassetid://132405197863294",["bed"]="rbxassetid://97726529032925",["bell"]="rbxassetid://97392696311902",["book-open"]="rbxassetid://129845326810392",["bot"]="rbxassetid://80451686744860",["briefcase"]="rbxassetid://96754188164225",["check"]="rbxassetid://93898873302694",["check-check"]="rbxassetid://95183312173858",["circle"]="rbxassetid://130359823580534",["coffee"]="rbxassetid://106864403231093",["cog"]="rbxassetid://116544501716299",["crosshair"]="rbxassetid://134242818164054",["dollar-sign"]="rbxassetid://127320961224019",["droplets"]="rbxassetid://140111846025180",["eye"]="rbxassetid://100033680381365",["flask-conical"]="rbxassetid://128406680901165",["flask-round"]="rbxassetid://127508287324940",["gamepad-2"]="rbxassetid://92483947987410",["gauge"]="rbxassetid://110273524101447",["gem"]="rbxassetid://112904952151156",["glass-water"]="rbxassetid://115526102400988",["hand"]="rbxassetid://130703864968637",["hand-coins"]="rbxassetid://126990543175462",["magnet"]="rbxassetid://135162361226972",["map"]="rbxassetid://95107167260947",["map-pin"]="rbxassetid://84279202219901",["mouse-pointer-click"]="rbxassetid://107150227368485",["move-vertical"]="rbxassetid://86234730730899",["package"]="rbxassetid://97261141732706",["package-check"]="rbxassetid://102374216055130",["package-plus"]="rbxassetid://129261988138366",["power"]="rbxassetid://96479131758775",["refresh-cw"]="rbxassetid://138133190015277",["repeat"]="rbxassetid://121886242955173",["scan"]="rbxassetid://123104789658180",["scan-eye"]="rbxassetid://99244790601968",["settings"]="rbxassetid://80758916183665",["shield"]="rbxassetid://110987169760162",["shield-check"]="rbxassetid://87354736164608",["siren"]="rbxassetid://134210267818039",["sparkles"]="rbxassetid://138635884129147",["sprout"]="rbxassetid://100091687832508",["target"]="rbxassetid://87563802520297",["trees"]="rbxassetid://121203841375919",["triangle-alert"]="rbxassetid://125920361880643",["user"]="rbxassetid://81589895647169",["user-search"]="rbxassetid://101335649828115",["users"]="rbxassetid://115398113982385",["wind"]="rbxassetid://114551690399915",["x"]="rbxassetid://110786993356448",["zap"]="rbxassetid://130551565616516",["info"]="rbxassetid://124560466474914",["search"]="rbxassetid://121018724060431",["chevron-left"]="rbxassetid://73780377692148",["chevron-right"]="rbxassetid://92473583511724",["chevron-down"]="rbxassetid://134243273101015",["trash-2"]="rbxassetid://109843431391323",["save"]="rbxassetid://126116963775616",["play"]="rbxassetid://135609604299893",["star"]="rbxassetid://136141469398409",["sword"]="rbxassetid://124448418211665",["footprints"]="rbxassetid://139192589041315",["monitor"]="rbxassetid://72664649203050",["palette"]="rbxassetid://86350350950064",["keyboard"]="rbxassetid://121474456068237",["bookmark"]="rbxassetid://121093149326239",["layers"]="rbxassetid://81973586053257",["hammer"]="rbxassetid://83545120140895",["swords"]="rbxassetid://81872698913435",["house"]="rbxassetid://98755624629571",["wifi"]="rbxassetid://104669375183960",["clock"]="rbxassetid://121808839832144",["eye-off"]="rbxassetid://135928786788378",["user-x"]="rbxassetid://139748155894754",["shuffle"]="rbxassetid://132382786975101",["copy"]="rbxassetid://78979572434545",["activity"]="rbxassetid://94212016861936",["minimize-2"]="rbxassetid://116269596042539",["cloud"]="rbxassetid://121226497050352",["layout-grid"]="rbxassetid://81344910161871",["store"]="rbxassetid://90338129673705",["cloud-lightning"]="rbxassetid://133517088924849",["crown"]="rbxassetid://127843403295538",["timer"]="rbxassetid://85473888890506",["server"]="rbxassetid://92188766517878",["trending-down"]="rbxassetid://139309232226438",["user-round"]="rbxassetid://136485052187963",["circle-check"]="rbxassetid://85262178816537",["hash"]="rbxassetid://82890331678520",["list-filter"]="rbxassetid://103321376129527",["panel-left-close"]="rbxassetid://126579818823552",["panel-left-open"]="rbxassetid://111075816195767",["move-diagonal-2"]="rbxassetid://117298577948096",["grip"]="rbxassetid://109058783556768",["pin"]="rbxassetid://120978111007514",["pin-off"]="rbxassetid://127696372451750",["star-off"]="rbxassetid://75742832732503",["rotate-ccw"]="rbxassetid://110116685948665",["ellipsis"]="rbxassetid://140019550645825",["folder-open"]="rbxassetid://76018996254888",["droplet"]="rbxassetid://100597455015098",["pipette"]="rbxassetid://133167932934404",["sliders-horizontal"]="rbxassetid://85538382643347",["blend"]="rbxassetid://111679612185257",["toggle-right"]="rbxassetid://90411952142550",["anchor"]="rbxassetid://92181172123618",["arrow-up"]="rbxassetid://89282378235317",["backpack"]="rbxassetid://140420225386018",["bone"]="rbxassetid://111242153474115",["box"]="rbxassetid://101768155599700",["car"]="rbxassetid://121065933462582",["compass"]="rbxassetid://115123411028382",["dices"]="rbxassetid://81268120302865",["dna"]="rbxassetid://74007982981741",["egg"]="rbxassetid://117851493400222",["eraser"]="rbxassetid://133957773112410",["gift"]="rbxassetid://109855212076373",["graduation-cap"]="rbxassetid://93771896340220",["heart"]="rbxassetid://116559368303288",["key"]="rbxassetid://96510194465420",["lasso"]="rbxassetid://121072936884007",["layout-dashboard"]="rbxassetid://139929981863901",["leaf"]="rbxassetid://119951075637174",["link"]="rbxassetid://131607023382430",["list-ordered"]="rbxassetid://83212528113913",["move"]="rbxassetid://116138709011735",["navigation"]="rbxassetid://79308213542922",["paw-print"]="rbxassetid://112218825427601",["recycle"]="rbxassetid://140417023381961",["scroll"]="rbxassetid://74072101474951",["shopping-bag"]="rbxassetid://71885477293226",["shopping-cart"]="rbxassetid://128420521375441",["trending-up"]="rbxassetid://81819858538839",["utensils"]="rbxassetid://139952569804235",}ICON["knife"]=ICON["sword"]ICON["alert-triangle"]=ICON["triangle-alert"]ICON["home"]=ICON["house"]ICON["layout"]=ICON["layout-grid"]local function icon(name)if type(name)=="number"then return"rbxassetid://"..name end name=tostring(name or"")if name:find("^rbxasset")or name:find("^https?:")then return name end if name:match("^%d+$")then return"rbxassetid://"..name end name=name:gsub("^lucide:",""):lower()return ICON[name]or ICON.circle end local SHADOW_IMAGE="rbxassetid://8992230677"local function tween(inst,time,goal,style,dir)local tw=TweenService:Create(inst,TweenInfo.new(time,style or Enum.EasingStyle.Quint,dir or Enum.EasingDirection.Out),goal)tw:Play()return tw end local function new(class,props,parent)local i=Instance.new(class)for k,v in pairs(props or{})do i[k]=v end if parent then i.Parent=parent end return i end local function corner(p,r)return new("UICorner",{CornerRadius=UDim.new(0,r)},p)end local function stroke(p,color,transparency,thickness)return new("UIStroke",{Color=color,Thickness=thickness or 1,Transparency=transparency or 0,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,},p)end local function textW(text,size,face)local w=#text*size*0.55 pcall(function()local params=Instance.new("GetTextBoundsParams")params.Text,params.Font,params.Size,params.Width=text,face or T.font,size,10000 w=TextService:GetTextBoundsAsync(params).X end)return math.ceil(w)+1 end local TAGS={Risky=C.red,Beta=C.amber,New=C.blue,Safe=C.green,["On start"]=C.amber}local function tag(parent,text,color,order)color=color or TAGS[text]or T.subtext local label=text:upper()local h=even(px(18))local pill=new("Frame",{Name="Tag",LayoutOrder=order or 1,BackgroundColor3=color,BackgroundTransparency=0.85,Size=UDim2.fromOffset(textW(label,px(10),T.fontBold)+px(14),h),},parent)corner(pill,math.floor(h/2))stroke(pill,color,0.6)new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(10),TextColor3=color:Lerp(WHITE,0.2),Text=label,},pill)return pill end local function parseTitle(title)title=tostring(title or"")local tags={}local plain=title:gsub("<[^>]+>","")if plain:find("RISKY",1,true)then table.insert(tags,"Risky")plain=plain:gsub("%s*RISKY%s*"," ")end plain=plain:gsub("^%s+",""):gsub("%s+$","")if plain:sub(1,1)=="="then plain="What RISKY means"end return plain,tags end local privacy={name=false,avatar=false}local privacyHooks={}local function onPrivacy(fn)table.insert(privacyHooks,fn)pcall(fn)end local function setPrivacy(key,on)privacy[key]=on for _,fn in ipairs(privacyHooks)do pcall(fn)end end local gameInfo={name="Loading...",creator="...",loaded=false}local gameHooks={}local function onGameInfo(fn)table.insert(gameHooks,fn)if gameInfo.loaded then pcall(fn)end end task.spawn(function()local ok,info=pcall(MarketplaceService.GetProductInfo,MarketplaceService,game.PlaceId)if ok and type(info)=="table"then gameInfo.name=tostring(info.Name or"Unknown experience")gameInfo.creator=(type(info.Creator)=="table"and info.Creator.Name)and tostring(info.Creator.Name)or"Unknown"else gameInfo.name,gameInfo.creator="Unknown experience","Unknown"end gameInfo.loaded=true for _,fn in ipairs(gameHooks)do pcall(fn)end end)local host if gethui then host=gethui()else local ok,cg=pcall(function()return game:GetService("CoreGui")end)if ok and cg and pcall(function()return cg:GetChildren()end)then host=cg elseif LP then host=LP:FindFirstChild("PlayerGui")or LP:WaitForChild("PlayerGui")end end for _,old in ipairs(host:GetChildren())do if old.Name=="MonoUI"then old:Destroy()end end local gui=new("ScreenGui",{Name="MonoUI",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=100000,},host)STATE.onCleanup(function()pcall(function()gui:Destroy()end)end)local onThemeChanged,applyTheme do(function()local themeHooks={}function onThemeChanged(fn)table.insert(themeHooks,fn)end local function ckey(c)return math.floor(c.R*255+0.5)*65536+math.floor(c.G*255+0.5)*256+math.floor(c.B*255+0.5)end local ACCENT_MIX={0.15,0.2,0.25,0.35}local THEMED_PROPS={Frame={"BackgroundColor3"},CanvasGroup={"BackgroundColor3"},UIStroke={"Color"},TextLabel={"BackgroundColor3","TextColor3"},TextButton={"BackgroundColor3","TextColor3"},TextBox={"BackgroundColor3","TextColor3","PlaceholderColor3"},ImageLabel={"BackgroundColor3","ImageColor3"},ImageButton={"BackgroundColor3","ImageColor3"},ScrollingFrame={"BackgroundColor3","ScrollBarImageColor3"},}local pendingFades={}local recentPalettes={}local lastSwitch,queued=-1,nil local function finishFades()for _,f in ipairs(pendingFades)do local st=f.tw.PlaybackState if st==Enum.PlaybackState.Playing or st==Enum.PlaybackState.Begin or st==Enum.PlaybackState.Delayed then f.tw:Cancel()pcall(function()f.inst[f.prop]=f.goal end)end end table.clear(pendingFades)end local function mapBetween(from,to)local map={}local function add(o,n)local k=ckey(o)if map[k]==nil then map[k]=n end end for _,k in ipairs(PALETTE_KEYS)do add(from[k],to[k])end add(from.accent,to.accent)for _,a in ipairs(ACCENT_MIX)do add(from.accent:Lerp(WHITE,a),to.accent:Lerp(WHITE,a))end return map end local function walkTheme(maps,skip,animate)local st,hid={gui},{false}while#st>0 do local inst,hidden=table.remove(st),table.remove(hid)if not inst:GetAttribute("MonoNoTheme")then if not hidden and inst:IsA("GuiObject")and not inst.Visible then hidden=true end local props=THEMED_PROPS[inst.ClassName]if props then for _,prop in ipairs(props)do local k=ckey(inst[prop])if not(skip and skip[k])then local n for _,m in ipairs(maps)do n=m[k]if n then break end end if n then if animate and not hidden then local tw=tween(inst,0.4,{[prop]=n},Enum.EasingStyle.Quad)table.insert(pendingFades,{tw=tw,inst=inst,prop=prop,goal=n})else inst[prop]=n end end end end end for _,c in ipairs(inst:GetChildren())do table.insert(st,c)table.insert(hid,hidden)end end end end local runTheme function applyTheme(name,animate,remember,force)name=tostring(name or"")local th=THEMES[name]if not th or(name==currentTheme and not force and not queued)then return false end local now=os.clock()if animate and(queued or now-lastSwitch<0.15)then local first=queued==nil queued={name,remember,force}if first then task.delay(math.max(0.15-(now-lastSwitch),0.03),function()local q=queued queued=nil if q and(q[1]~=currentTheme or q[3])then runTheme(q[1],true,q[2])end end)end return true end return runTheme(name,animate,remember)end function runTheme(name,animate,remember)local th=THEMES[name]if not th then return false end local now=os.clock()lastSwitch=now finishFades()local old={accent=C.accent}for _,k in ipairs(PALETTE_KEYS)do old[k]=T[k]end table.insert(recentPalettes,1,old)while#recentPalettes>4 do table.remove(recentPalettes)end local p=th.palette currentTheme=name setPalette(p)walkTheme({mapBetween(old,p)},nil,animate)local token=now task.delay(0.6,function()if lastSwitch~=token or not gui.Parent then return end local fresh={[ckey(p.accent)]=true}for _,k in ipairs(PALETTE_KEYS)do fresh[ckey(p[k])]=true end local maps={}for _,pal in ipairs(recentPalettes)do table.insert(maps,mapBetween(pal,p))end walkTheme(maps,fresh,false)end)if remember then prefs.theme=name savePrefs()end for _,fn in ipairs(themeHooks)do pcall(fn,name)end return true end end)()end local shell=new("Frame",{Name="Window",AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.fromOffset(T.size.X,T.size.Y),BackgroundTransparency=1,Visible=false,},gui)local pop=new("UIScale",{},shell)local userScale=math.clamp(tonumber(prefs.scale)or 1,0.5,2)local WIN=(function()local W={alpha=math.clamp(tonumber(prefs.opacity)and(1-tonumber(prefs.opacity))or 0,0,0.4),blur=prefs.blur==true,min=Vector2.new(math.min(even(px(720)),T.size.X),math.min(even(px(460)),T.size.Y)),}local function vp()return workspace.CurrentCamera.ViewportSize end function W.maxSize()local v=vp()return Vector2.new(math.max(W.min.X,even(v.X*0.96/userScale)),math.max(W.min.Y,even(v.Y*0.94/userScale)))end function W.fitSize(s)local mx=W.maxSize()return Vector2.new(even(math.clamp(s.X,W.min.X,mx.X)),even(math.clamp(s.Y,W.min.Y,mx.Y)))end function W.clamp(c)local v=vp()local half=Vector2.new(T.size.X,T.size.Y)*userScale/2 local function axis(x,h,len)if(h+6)*2>=len then return len/2 end return math.clamp(x,h+6,len-h-6)end return Vector2.new(math.floor(axis(c.X,half.X,v.X)+0.5),math.floor(axis(c.Y,half.Y,v.Y)+0.5))end function W.place(c,animate)c=W.clamp(c)local goal=UDim2.fromOffset(c.X,c.Y)if animate then tween(shell,0.12,{Position=goal})else shell.Position=goal end end function W.center()return Vector2.new(shell.Position.X.Offset,shell.Position.Y.Offset)end function W.setSize(s)T.size=W.fitSize(s)shell.Size=UDim2.fromOffset(T.size.X,T.size.Y)end function W.save()prefs.window={w=T.size.X,h=T.size.Y}savePrefs()end local saved=type(prefs.window)=="table"and prefs.window or{}if tonumber(saved.w)and tonumber(saved.h)then W.setSize(Vector2.new(tonumber(saved.w),tonumber(saved.h)))end do local v=vp()W.place(Vector2.new(v.X/2,v.Y/2))end local camConn local function hook()if camConn then camConn:Disconnect()end local cam=workspace.CurrentCamera if not cam then return end camConn=cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()W.setSize(T.size)W.place(W.center())end)end hook()STATE.connect(workspace:GetPropertyChangedSignal("CurrentCamera"),hook)STATE.onCleanup(function()if camConn then camConn:Disconnect()end end)local fx function W.blurTo(on)if not fx then if not on then return end fx=Instance.new("BlurEffect")fx.Name,fx.Size="MonoUIBlur",0 fx.Parent=game:GetService("Lighting")STATE.onCleanup(function()pcall(function()fx:Destroy()end)end)end tween(fx,on and 0.4 or 0.25,{Size=on and 14 or 0},Enum.EasingStyle.Quad)end return W end)()local SHADOW_REST=0.45 local shadow=new("ImageLabel",{Name="Shadow",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,px(10)),Size=UDim2.new(1,px(90),1,px(90)),BackgroundTransparency=1,Image=SHADOW_IMAGE,ImageColor3=Color3.new(0,0,0),ImageTransparency=1,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(99,99,99,99),},shell)local borderFrame=new("Frame",{Name="Border",Size=UDim2.fromScale(1,1),BackgroundTransparency=1},shell)corner(borderFrame,T.radius)local borderStroke=stroke(borderFrame,T.border,1)local window=new("CanvasGroup",{Name="Canvas",Size=UDim2.fromScale(1,1),BackgroundColor3=T.bg,BorderSizePixel=0,GroupTransparency=1,},shell)corner(window,T.radius)local function inWindow(el)local s=pop.Scale local p=(el.AbsolutePosition-window.AbsolutePosition)/s return Vector2.new(math.floor(p.X+0.5),math.floor(p.Y+0.5)),el.AbsoluteSize/s end do local dragging,startMouse,startPos STATE.connect(window.InputBegan,function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging,startMouse,startPos=true,input.Position,WIN.center()end end)STATE.connect(UIS.InputChanged,function(input)if not dragging or not mine()then return end if input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch then return end local d=input.Position-startMouse WIN.place(startPos+Vector2.new(d.X,d.Y),true)end)STATE.connect(UIS.InputEnded,function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end)end local shown,opened=false,false local closePopup local paintFloat local keyEnabled=true local function setShown(on)if on==shown then return end shown=on if on then opened=true end if closePopup then closePopup()end if paintFloat then paintFloat()end if on then shell.Visible=true pop.Scale=userScale*0.92 tween(pop,0.45,{Scale=userScale},Enum.EasingStyle.Back)tween(window,0.3,{GroupTransparency=WIN.alpha},Enum.EasingStyle.Quad)tween(shadow,0.45,{ImageTransparency=SHADOW_REST})tween(borderStroke,0.3,{Transparency=0})if WIN.blur then WIN.blurTo(true)end else if WIN.blur then WIN.blurTo(false)end tween(pop,0.22,{Scale=userScale*0.95})tween(shadow,0.18,{ImageTransparency=1})tween(borderStroke,0.18,{Transparency=1})local tw=tween(window,0.18,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()if not shown then shell.Visible=false end end)end end local capture={active=false}STATE.connect(UIS.InputBegan,function(input,processed)if processed or not mine()or capture.active then return end if keyEnabled and input.KeyCode==T.toggleKey then setShown(not shown)end end)local L={side=px(216),narrow=px(72),header=px(64),navH=even(px(42)),navGap=px(4),navIcon=even(px(18)),navText=px(15),profileH=px(60),segH=even(px(36)),}local PAD=px(22)local INNER=px(14)local NAV_ICON_X=math.floor((L.narrow-INNER*2-L.navIcon)/2)local NAV_LABEL_X=NAV_ICON_X+L.navIcon+px(12)local sidebar=new("Frame",{Name="Sidebar",Size=UDim2.new(0,L.side,1,0),BackgroundColor3=T.side,BorderSizePixel=0,ClipsDescendants=true,},window)new("Frame",{Name="Divider",AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.new(0,1,1,0),BackgroundColor3=T.divider,BorderSizePixel=0,ZIndex=3,},sidebar)local brandIcon,brandTitle,brandSub,brandBadge,setBrand do local brandS=px(36)local wordH,subH=px(38),px(12)local brand=new("Frame",{Name="Brand",Position=UDim2.fromOffset(INNER,math.floor((L.header-(wordH+subH+px(2)))/2)),Size=UDim2.new(1,-INNER*2,0,wordH+subH+px(2)),BackgroundTransparency=1,},sidebar)brandBadge=new("CanvasGroup",{Name="Badge",AnchorPoint=Vector2.new(0,0.5),Position=UDim2.fromScale(0,0.5),Size=UDim2.fromOffset(brandS,brandS),BackgroundColor3=C.accent,BackgroundTransparency=0.82,GroupTransparency=1,Visible=false,},brand)corner(brandBadge,px(10))stroke(brandBadge,C.accent,1)new("UIGradient",{Rotation=90,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,0.45)}),},brandBadge)local monogram=new("TextLabel",{Name="Monogram",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,px(1)),Size=UDim2.fromScale(1,1),BackgroundTransparency=1,RichText=true,FontFace=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.ExtraBold),TextSize=px(17),TextColor3=WHITE,Text="",},brandBadge)brandIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(18)),even(px(18))),BackgroundTransparency=1,Image="",ImageColor3=C.accent:Lerp(WHITE,0.25),Visible=false,},brandBadge)brandTitle=new("TextLabel",{Name="Wordmark",Size=UDim2.new(1,0,0,wordH),BackgroundTransparency=1,RichText=true,FontFace=Font.new("rbxasset://fonts/families/BuilderSans.json",Enum.FontWeight.ExtraBold),TextScaled=true,TextColor3=WHITE,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Bottom,Text="",},brand)new("UITextSizeConstraint",{MaxTextSize=px(40),MinTextSize=px(12)},brandTitle)brandSub=new("TextLabel",{Position=UDim2.fromOffset(px(2),wordH+px(1)),Size=UDim2.new(1,-px(4),0,subH),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},brand)local base,accent="SPECTRE","WARE"local function esc(s)return(tostring(s):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"))end local function paint()local hex=HEX.from(C.accent)local text=esc(base)if accent~=""then text..= ('<font color="%s">%s</font>'):format(hex,esc(accent))end brandTitle.Text=text local m=esc(base:sub(1,1):upper())if accent~=""then m..= ('<font color="%s">%s</font>'):format(hex,esc(accent:sub(1,1):upper()))end monogram.Text=m monogram.Visible=not brandIcon.Visible end function setBrand(b,a)base,accent=tostring(b or""),tostring(a or"")paint()end paint()onThemeChanged(paint)end local navTop=L.header+px(4)local nav=new("ScrollingFrame",{Name="Nav",Position=UDim2.fromOffset(INNER,navTop),Size=UDim2.new(1,-INNER*2,1,-(navTop+L.profileH+INNER*2)),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,},sidebar)local navHl=new("Frame",{Name="Highlight",Size=UDim2.new(1,0,0,L.navH),BackgroundColor3=T.rowActive,Visible=false},nav)corner(navHl,px(10))stroke(navHl,T.fieldLine,0.35)local navBarH=even(px(18))local navBar=new("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(px(3),navBarH),BackgroundColor3=C.accent,BorderSizePixel=0,},navHl)corner(navBar,px(2))local navList=new("Frame",{Name="List",Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},nav)new("UIListLayout",{Padding=UDim.new(0,L.navGap),SortOrder=Enum.SortOrder.LayoutOrder},navList)local profile=new("TextButton",{Name="Profile",AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,INNER,1,-INNER),Size=UDim2.new(1,-INNER*2,0,L.profileH),BackgroundColor3=T.card,AutoButtonColor=false,Text="",},sidebar)corner(profile,px(12))local profStroke=stroke(profile,T.cardLine)local avS=even(px(36))local AV_X,AV_X_NARROW=px(12),math.floor((L.narrow-INNER*2-avS)/2)local pfp=new("ImageLabel",{Name="Avatar",Position=UDim2.fromOffset(AV_X,math.floor((L.profileH-avS)/2)),Size=UDim2.fromOffset(avS,avS),BackgroundColor3=T.field,Image="",},profile)new("UICorner",{CornerRadius=UDim.new(1,0)},pfp)local dot=new("Frame",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,px(1),1,px(1)),Size=UDim2.fromOffset(px(11),px(11)),BackgroundColor3=C.green,ZIndex=2,},pfp)new("UICorner",{CornerRadius=UDim.new(1,0)},dot)stroke(dot,T.card,0,2)task.spawn(function()local ok,img=pcall(Players.GetUserThumbnailAsync,Players,LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)if ok and pfp.Parent then pfp.Image=img end end)local ptx=AV_X+avS+px(10)local profName=new("TextLabel",{Position=UDim2.fromOffset(ptx,0),Size=UDim2.new(1,-(ptx+px(28)),0.5,-px(1)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(14),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Bottom,TextTruncate=Enum.TextTruncate.AtEnd,Text=LP.DisplayName,},profile)local profSub=new("TextLabel",{Position=UDim2.new(0,ptx,0.5,px(2)),Size=UDim2.new(1,-(ptx+px(28)),0.5,-px(2)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextTruncate=Enum.TextTruncate.AtEnd,Text="@"..LP.Name,},profile)local chevS=even(px(14))local profChev=new("ImageLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(12),0.5,0),Size=UDim2.fromOffset(chevS,chevS),BackgroundTransparency=1,Image=ICON["chevron-right"],ImageColor3=T.muted,},profile)onGameInfo(function()profSub.Text=gameInfo.name end)onPrivacy(function()profName.Text=privacy.name and"Hidden"or LP.DisplayName tween(pfp,0.25,{ImageTransparency=privacy.avatar and 1 or 0})end)STATE.connect(profile.MouseEnter,function()tween(profile,0.18,{BackgroundColor3=T.rowHover})tween(profStroke,0.18,{Color=T.fieldLineHot})tween(profChev,0.25,{Position=UDim2.new(1,-px(9),0.5,0),ImageColor3=T.text})end)STATE.connect(profile.MouseLeave,function()tween(profile,0.18,{BackgroundColor3=T.card})tween(profStroke,0.18,{Color=T.cardLine})tween(profChev,0.25,{Position=UDim2.new(1,-px(12),0.5,0),ImageColor3=T.muted})end)local content=new("Frame",{Name="Content",Position=UDim2.fromOffset(L.side,0),Size=UDim2.new(1,-L.side,1,0),BackgroundTransparency=1,ClipsDescendants=true,},window)local btnS=even(px(34))local searchW,searchH=px(250),even(px(36))local headIconS=even(px(20))local function headerButton(name,iconId,anchorX,pos)local b=new("TextButton",{Name=name,AnchorPoint=Vector2.new(anchorX,0.5),Position=pos,Size=UDim2.fromOffset(btnS,btnS),BackgroundColor3=T.field,BackgroundTransparency=1,AutoButtonColor=false,Text="",},content)corner(b,px(9))local st=stroke(b,T.fieldLine,1)local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(17)),even(px(17))),BackgroundTransparency=1,Image=iconId,ImageColor3=T.subtext,},b)STATE.connect(b.MouseEnter,function()tween(b,0.15,{BackgroundTransparency=0})tween(st,0.15,{Transparency=0})tween(ic,0.15,{ImageColor3=T.text})end)STATE.connect(b.MouseLeave,function()tween(b,0.15,{BackgroundTransparency=1})tween(st,0.15,{Transparency=1})tween(ic,0.15,{ImageColor3=T.subtext})end)return b,ic end local colBtn,colIcon=headerButton("SidebarToggle",ICON["panel-left-close"],0,UDim2.new(0,PAD-px(8),0,math.floor(L.header/2)))local HEAD_X=PAD-px(8)+btnS+px(10)local headIcon=new("ImageLabel",{Position=UDim2.fromOffset(HEAD_X,math.floor((L.header-headIconS)/2)),Size=UDim2.fromOffset(headIconS,headIconS),BackgroundTransparency=1,Image="",ImageColor3=C.accent,},content)local TITLE_POS=UDim2.fromOffset(HEAD_X+headIconS+px(10),0)local headTitle=new("TextLabel",{Position=TITLE_POS,Size=UDim2.new(1,-(HEAD_X+headIconS+px(10)+PAD+searchW+btnS+px(20)),0,L.header),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(20),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},content)local minBtn=headerButton("Minimize",ICON["minimize-2"],1,UDim2.new(1,-PAD,0,math.floor(L.header/2)))local search=new("Frame",{Name="Search",AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-(PAD+btnS+px(8)),0,math.floor(L.header/2)),Size=UDim2.fromOffset(searchW,searchH),BackgroundColor3=T.field,},content)corner(search,px(10))local searchStroke=stroke(search,T.fieldLine)local sIconS=even(px(15))local searchIcon=new("ImageLabel",{Position=UDim2.fromOffset(px(12),math.floor((searchH-sIconS)/2)),Size=UDim2.fromOffset(sIconS,sIconS),BackgroundTransparency=1,Image=ICON.search,ImageColor3=T.muted,},search)local searchBox=new("TextBox",{Name="Query",Position=UDim2.fromOffset(px(12)+sIconS+px(9),0),Size=UDim2.new(1,-(px(12)+sIconS+px(9)+px(10)),1,0),BackgroundTransparency=1,ClearTextOnFocus=false,FontFace=T.font,TextSize=px(14),TextColor3=T.text,PlaceholderText="Search everything...",PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true,},search)STATE.connect(searchBox.Focused,function()tween(searchStroke,0.2,{Color=C.accent,Transparency=0.25})tween(searchIcon,0.2,{ImageColor3=C.accent})tween(search,0.2,{BackgroundColor3=T.fieldHot})end)STATE.connect(searchBox.FocusLost,function()tween(searchStroke,0.25,{Color=T.fieldLine,Transparency=0})tween(searchIcon,0.25,{ImageColor3=T.muted})tween(search,0.25,{BackgroundColor3=T.field})end)local overlay=new("Frame",{Name="Overlay",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=20},window)do local gs=math.max(even(px(22)),TOUCH and 32 or 0)local grip=new("TextButton",{Name="ResizeGrip",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(3),1,-px(3)),Size=UDim2.fromOffset(gs,gs),BackgroundTransparency=1,AutoButtonColor=false,Text="",ZIndex=25,},window)local gi=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(13)),even(px(13))),BackgroundTransparency=1,Image=ICON["move-diagonal-2"],ImageColor3=T.muted,ImageTransparency=0.45,ZIndex=25,},grip)local active,startPos,startSize,startCenter local function lit(on)tween(gi,0.15,{ImageTransparency=on and 0 or 0.45,ImageColor3=on and T.text or T.muted})end if HOVER then STATE.connect(grip.MouseEnter,function()lit(true)end)STATE.connect(grip.MouseLeave,function()if not active then lit(false)end end)end STATE.connect(grip.InputBegan,function(input)if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end if active then return end active,startPos,startSize,startCenter=input,input.Position,T.size,WIN.center()lit(true)end)STATE.connect(UIS.InputChanged,function(input)if not active then return end local isTouch=input.UserInputType==Enum.UserInputType.Touch if isTouch and input~=active then return end if not isTouch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end local d=Vector2.new(input.Position.X-startPos.X,input.Position.Y-startPos.Y)/userScale WIN.setSize(startSize+d)WIN.place(startCenter+(T.size-startSize)*userScale/2)end)STATE.connect(UIS.InputEnded,function(input)if not active then return end if input~=active and not(active.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1)then return end active=nil lit(false)WIN.save()end)end local K={groupGap=px(16),caption=px(12),captionH=px(26),rowMin=even(px(58)),rowPad=px(16),vPad=px(13),title=px(15),desc=px(13),radius=px(12),ctrlH=even(px(34)),}local tabs,tabOrder,selectedTab={},{},nil local currentPage local function placePage(page,animate)local tab=page.tab local top=L.header+(#tab.secOrder>=2 and(L.segH+px(14))or 0)if page.tw then page.tw:Cancel()page.tw=nil end page.wrap.Size=UDim2.new(1,0,1,-top)if animate then page.wrap.Position=UDim2.fromOffset(0,top+px(16))page.wrap.GroupTransparency=1 page.tw=tween(page.wrap,0.42,{Position=UDim2.fromOffset(0,top),GroupTransparency=0})else page.wrap.Position=UDim2.fromOffset(0,top)page.wrap.GroupTransparency=0 end end local function showPage(page)if closePopup then closePopup()end if currentPage==page then if page then placePage(page,false)end return end if currentPage then currentPage.wrap.Visible=false end currentPage=page if page then page.wrap.Visible=true page.scroll.CanvasPosition=Vector2.new()placePage(page,true)if page.onShow then task.spawn(page.onShow)end end end local function paintNav(tab,t)local on=selectedTab==tab tween(tab.navIcon,t,{ImageColor3=on and C.accent or(tab.hover and T.text or T.subtext)})tween(tab.navLabel,t,{TextColor3=(on or tab.hover)and T.text or T.subtext})tween(tab.navHover,t,{BackgroundTransparency=(tab.hover and not on)and 0 or 1})end local function setHeader(tab)headIcon.Image=tab.icon headTitle.Text=tab.name headTitle.TextTransparency,headIcon.ImageTransparency=1,1 headTitle.Position=TITLE_POS+UDim2.fromOffset(px(10),0)tween(headTitle,0.35,{TextTransparency=0,Position=TITLE_POS})tween(headIcon,0.35,{ImageTransparency=0})end local function pillX(tab,sec)local x=px(3)for _,s in ipairs(tab.secOrder)do if s==sec then return x end x+=s.pillW+px(2)end return x end local function refreshSeg(tab,animate)if not tab.seg then return end local show=#tab.secOrder>=2 tab.seg.Visible=show and selectedTab==tab if show and tab.selected then local goal={Position=UDim2.fromOffset(pillX(tab,tab.selected),px(3)),Size=UDim2.fromOffset(tab.selected.pillW,L.segH-px(6)),}if animate then tween(tab.segHl,0.35,goal)else tab.segHl.Position,tab.segHl.Size=goal.Position,goal.Size end end end local function paintPill(sec,t)local on=sec.tab.selected==sec tween(sec.pillLabel,t or 0.2,{TextColor3=on and T.text or(sec.hover and T.text or T.subtext)})tween(sec.pillIcon,t or 0.2,{ImageColor3=on and C.accent or T.muted})end local function selectTab(name)local tab=tabs[name]if not tab or selectedTab==tab then return end local prev=selectedTab selectedTab=tab if prev then paintNav(prev,0.2)if prev.seg then prev.seg.Visible=false end end paintNav(tab,0.2)local rank=0 for _,t in ipairs(tabOrder)do local a,b=t.nav.LayoutOrder,tab.nav.LayoutOrder if t~=tab and(a<b or(a==b and t.index<tab.index))then rank+=1 end end local y=rank*(L.navH+L.navGap)navHl.Visible=true if prev then tween(navHl,0.38,{Position=UDim2.fromOffset(0,y)})local squeeze=tween(navBar,0.12,{Size=UDim2.fromOffset(px(3),math.floor(navBarH/2))})squeeze.Completed:Once(function()tween(navBar,0.3,{Size=UDim2.fromOffset(px(3),navBarH)},Enum.EasingStyle.Back)end)else navHl.Position=UDim2.fromOffset(0,y)end if tab.iconScale then tab.iconScale.Scale=0.8 tween(tab.iconScale,0.4,{Scale=1},Enum.EasingStyle.Back)end setHeader(tab)refreshSeg(tab,false)showPage(tab.selected and tab.selected.page)end local function selectSection(tabName,name)local tab=tabs[tabName]local sec=tab and tab.sections[name]if not sec or tab.selected==sec then return end local prev=tab.selected tab.selected=sec if prev then paintPill(prev)end paintPill(sec)refreshSeg(tab,true)if selectedTab==tab then showPage(sec.page)end end local collapsed=false local function addTab(name,iconId)local index=#tabOrder+1 local btn=new("TextButton",{Name=name,LayoutOrder=index,Size=UDim2.new(1,0,0,L.navH),BackgroundTransparency=1,AutoButtonColor=false,Text="",},navList)local hover=new("Frame",{Name="Hover",Size=UDim2.fromScale(1,1),BackgroundColor3=T.rowHover,BackgroundTransparency=1},btn)corner(hover,px(10))local img=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromOffset(NAV_ICON_X+L.navIcon/2,L.navH/2),Size=UDim2.fromOffset(L.navIcon,L.navIcon),BackgroundTransparency=1,Image=iconId,ImageColor3=T.subtext,},btn)local iconScale=new("UIScale",{},img)local label=new("TextLabel",{Position=UDim2.fromOffset(NAV_LABEL_X,0),Size=UDim2.new(1,-(NAV_LABEL_X+px(8)),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=L.navText,TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,TextTransparency=collapsed and 1 or 0,Text=name,},btn)local tab={name=name,index=index,icon=iconId,nav=btn,navIcon=img,navLabel=label,navHover=hover,iconScale=iconScale,sections={},secOrder={},}tabs[name]=tab table.insert(tabOrder,tab)STATE.connect(btn.MouseEnter,function()tab.hover=true paintNav(tab,0.15)end)STATE.connect(btn.MouseLeave,function()tab.hover=false paintNav(tab,0.2)end)STATE.connect(btn.MouseButton1Click,function()selectTab(name)end)return tab end local function ensureSeg(tab)if tab.seg then return end local seg=new("Frame",{Name="Sections",Position=UDim2.fromOffset(PAD,L.header),Size=UDim2.fromOffset(0,L.segH),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=T.field,Visible=false,},content)corner(seg,px(10))stroke(seg,T.fieldLine)local hl=new("Frame",{Name="Highlight",Position=UDim2.fromOffset(px(3),px(3)),Size=UDim2.fromOffset(0,L.segH-px(6)),BackgroundColor3=T.rowActive,},seg)corner(hl,px(8))stroke(hl,T.fieldLineHot,0.5)local list=new("Frame",{Name="List",Size=UDim2.fromOffset(0,L.segH),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,},seg)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(2)),SortOrder=Enum.SortOrder.LayoutOrder,},list)new("UIPadding",{PaddingLeft=UDim.new(0,px(3)),PaddingRight=UDim.new(0,px(3))},list)tab.seg,tab.segHl,tab.segList=seg,hl,list end local function makePage(tab,sec)local wrap=new("CanvasGroup",{Name=tab.name.."/"..sec.name,Position=UDim2.fromOffset(0,L.header),Size=UDim2.new(1,0,1,-L.header),BackgroundTransparency=1,Visible=false,},content)local scroll=new("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=px(4),ScrollBarImageColor3=T.fieldLineHot,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,},wrap)local body=new("Frame",{Name="Body",Position=UDim2.fromOffset(PAD,0),Size=UDim2.new(1,-PAD*2,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},scroll)new("UIListLayout",{Padding=UDim.new(0,K.groupGap),SortOrder=Enum.SortOrder.LayoutOrder},body)new("UIPadding",{PaddingTop=UDim.new(0,px(4)),PaddingBottom=UDim.new(0,px(24))},body)return{tab=tab,sec=sec,wrap=wrap,scroll=scroll,body=body,groups=0,rows={},groupList={}}end local function addSection(tab,name,iconId)if tab.sections[name]then return tab.sections[name]end ensureSeg(tab)local iconS=even(px(14))local labelW=textW(name,px(13),T.fontSemi)local pillW=px(12)+iconS+px(7)+labelW+px(14)local pill=new("TextButton",{Name=name,LayoutOrder=#tab.secOrder+1,Size=UDim2.fromOffset(pillW,L.segH-px(6)),BackgroundTransparency=1,AutoButtonColor=false,Text="",},tab.segList)local pIcon=new("ImageLabel",{Position=UDim2.fromOffset(px(12),math.floor((L.segH-px(6)-iconS)/2)),Size=UDim2.fromOffset(iconS,iconS),BackgroundTransparency=1,Image=iconId,ImageColor3=T.muted,},pill)local pLabel=new("TextLabel",{Position=UDim2.fromOffset(px(12)+iconS+px(7),0),Size=UDim2.new(0,labelW+px(4),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(13),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,Text=name,},pill)local sec={name=name,tab=tab,pill=pill,pillIcon=pIcon,pillLabel=pLabel,pillW=pillW}sec.icon=pIcon sec.page=makePage(tab,sec)tab.sections[name]=sec table.insert(tab.secOrder,sec)STATE.connect(pill.MouseEnter,function()sec.hover=true paintPill(sec,0.15)end)STATE.connect(pill.MouseLeave,function()sec.hover=false paintPill(sec,0.2)end)STATE.connect(pill.MouseButton1Click,function()selectSection(tab.name,name)end)if not tab.selected then tab.selected=sec end paintPill(sec,0)if selectedTab==tab then refreshSeg(tab,false)if currentPage then placePage(currentPage,false)else showPage(tab.selected.page)end end return sec end local function setCollapsed(on,remember)collapsed=on==true if remember then prefs.collapsed=collapsed savePrefs()end local swap=tween(colIcon,0.1,{ImageTransparency=1})swap.Completed:Once(function()colIcon.Image=collapsed and ICON["panel-left-open"]or ICON["panel-left-close"]tween(colIcon,0.15,{ImageTransparency=0})end)local w=collapsed and L.narrow or L.side local t=0.38 local a=collapsed and 1 or 0 tween(sidebar,t,{Size=UDim2.new(0,w,1,0)})tween(content,t,{Position=UDim2.fromOffset(w,0),Size=UDim2.new(1,-w,1,0)})tween(brandTitle,t*0.5,{TextTransparency=a})tween(brandSub,t*0.5,{TextTransparency=a})local badgeStroke=brandBadge:FindFirstChildOfClass("UIStroke")if collapsed then brandBadge.Visible=true end tween(brandBadge,t*0.6,{GroupTransparency=1-a})if badgeStroke then tween(badgeStroke,t*0.6,{Transparency=collapsed and 0.6 or 1})end if not collapsed then task.delay(t*0.6,function()if not collapsed then brandBadge.Visible=false end end)end tween(profName,t*0.5,{TextTransparency=a})tween(profSub,t*0.5,{TextTransparency=a})tween(profChev,t*0.5,{ImageTransparency=a})tween(pfp,t,{Position=UDim2.fromOffset(collapsed and AV_X_NARROW or AV_X,math.floor((L.profileH-avS)/2))})for _,tab in ipairs(tabOrder)do tween(tab.navLabel,t*0.5,{TextTransparency=a})end end STATE.connect(colBtn.MouseButton1Click,function()setCollapsed(not collapsed,true)end)if prefs.collapsed or(prefs.collapsed==nil and DEVICE=="Phone")then setCollapsed(true,false)end local CTRL={list={},byId={},hooks={},muted=false,swallow=false}do local function copy(v)return type(v)=="table"and table.clone(v)or v end function CTRL.register(kind,g,title,obj,r,o)local tab,sec=g.page.tab,g.page.sec local base=tostring(o.Flag or(tab.name.."/"..sec.name.."/"..title))local id,n=base,1 while CTRL.byId[id]do n+=1 id=base.."#"..n end local e={id=id,kind=kind,title=title,obj=obj,row=r,g=g,tab=tab,sec=sec,config=o.Config~=false and kind~="button",}e.default=copy(CTRL.get(e))CTRL.byId[id]=e table.insert(CTRL.list,e)if CTRL.attach then CTRL.attach(e)end return e end function CTRL.get(e)local v=e.obj and e.obj.Value if e.kind=="keybind"then return v or false end if e.kind=="button"then return nil end return copy(v)end function CTRL.set(e,v)if e.kind=="toggle"then e.obj:Set(v==true)elseif e.kind=="slider"then if tonumber(v)then e.obj:Set(tonumber(v))end elseif e.kind=="dropdown"then e.obj:Select(v)elseif e.kind=="keybind"then e.obj:Set(v~=false and v or nil)elseif e.kind=="input"then e.obj:Set(v)end end function CTRL.onChange(fn)table.insert(CTRL.hooks,fn)end function CTRL.changed(e)if not e then return end for _,fn in ipairs(CTRL.hooks)do pcall(fn,e,CTRL.muted)end end function CTRL.pointOf(input)if input.UserInputType==Enum.UserInputType.Touch then local inset=game:GetService("GuiService"):GetGuiInset()return Vector2.new(input.Position.X+inset.X,input.Position.Y+inset.Y)end return UIS:GetMouseLocation()end function CTRL.activeCount()local n=0 for _,e in ipairs(CTRL.list)do if e.kind=="toggle"and e.obj.Value and e.row.Parent then n+=1 end end return n end end local function group(page,caption)page.groups+=1 local holder=new("Frame",{Name=caption or"Group",LayoutOrder=page.groups,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},page.body)new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},holder)local card=new("Frame",{Name="Card",LayoutOrder=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.card,},holder)corner(card,K.radius)local cardStroke=stroke(card,T.cardLine)local cardLayout=new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},card)local g={page=page,card=card,holder=holder,rows=0,folded=false}table.insert(page.groupList,g)if caption then local key=page.tab.name.."/"..page.sec.name.."/"..caption local cap=new("TextButton",{Name="Caption",LayoutOrder=0,Size=UDim2.new(1,0,0,K.captionH),BackgroundTransparency=1,AutoButtonColor=false,Text="",},holder)local capLabel=new("TextLabel",{Size=UDim2.new(1,-px(24),1,0),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=K.caption,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Text=caption:upper(),},cap)local chevS=even(px(13))local chev=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(1,-px(10),0,-px(1)),Size=UDim2.fromOffset(chevS,chevS),BackgroundTransparency=1,Image=ICON["chevron-down"],ImageColor3=T.muted,},cap)local busy=0 function g.setFolded(on,animate)g.folded=on prefs.groups=type(prefs.groups)=="table"and prefs.groups or{}prefs.groups[key]=on or nil tween(chev,animate and 0.3 or 0,{Rotation=on and-90 or 0})busy+=1 local token=busy local s=math.max(pop.Scale,0.01)if on then local h=card.AbsoluteSize.Y/s card.AutomaticSize=Enum.AutomaticSize.None card.ClipsDescendants=true card.Size=UDim2.new(1,0,0,h)if not animate then card.Size,card.Visible=UDim2.new(1,0,0,0),false return end tween(cardStroke,0.2,{Transparency=1})local tw=tween(card,0.32,{Size=UDim2.new(1,0,0,0)})tw.Completed:Once(function()if busy==token and g.folded then card.Visible=false end end)else card.Visible=true card.ClipsDescendants=true task.spawn(function()RunService.Heartbeat:Wait()if busy~=token then return end local h=cardLayout.AbsoluteContentSize.Y/math.max(pop.Scale,0.01)cardStroke.Transparency=0 local tw=tween(card,animate and 0.36 or 0,{Size=UDim2.new(1,0,0,h)})tw.Completed:Once(function()if busy~=token or g.folded then return end card.AutomaticSize=Enum.AutomaticSize.Y card.ClipsDescendants=false end)end)end end function g.expand()if g.folded then g.setFolded(false,true)savePrefs()end end STATE.connect(cap.MouseButton1Click,function()g.setFolded(not g.folded,true)savePrefs()end)if HOVER then STATE.connect(cap.MouseEnter,function()tween(capLabel,0.15,{TextColor3=T.subtext})tween(chev,0.15,{ImageColor3=T.subtext})end)STATE.connect(cap.MouseLeave,function()tween(capLabel,0.2,{TextColor3=T.muted})tween(chev,0.2,{ImageColor3=T.muted})end)end if type(prefs.groups)=="table"and prefs.groups[key]then task.defer(function()g.setFolded(true,false)end)end end return g end local function row(g,title,desc,tags)g.rows+=1 local r=new("Frame",{Name=title,LayoutOrder=g.rows,Size=UDim2.new(1,0,0,K.rowMin),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},g.card)local hover=new("Frame",{Name="Hover",Position=UDim2.fromOffset(px(4),px(4)),Size=UDim2.new(1,-px(8),1,-px(8)),BackgroundColor3=T.rowHover,BackgroundTransparency=1,},r)corner(hover,K.radius-px(4))if g.rows>1 then new("Frame",{Name="Line",Position=UDim2.fromOffset(K.rowPad,0),Size=UDim2.new(1,-K.rowPad*2,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},r)end local slot=new("Frame",{Name="Control",AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-K.rowPad,0,0),Size=UDim2.fromOffset(0,K.ctrlH),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,ZIndex=2,},r)local col=new("Frame",{Name="Text",Position=UDim2.fromOffset(K.rowPad,0),Size=UDim2.new(1,-K.rowPad*2,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,ZIndex=2,},r)new("UIPadding",{PaddingTop=UDim.new(0,K.vPad),PaddingBottom=UDim.new(0,K.vPad)},col)new("UIListLayout",{Padding=UDim.new(0,px(3)),SortOrder=Enum.SortOrder.LayoutOrder},col)local line1=new("Frame",{Name="TitleLine",LayoutOrder=1,Size=UDim2.new(1,0,0,K.title+px(6)),BackgroundTransparency=1},col)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(7)),SortOrder=Enum.SortOrder.LayoutOrder},line1)local titleLabel=new("TextLabel",{Name="Title",LayoutOrder=0,Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=K.title,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=title,},line1)for i,t in ipairs(tags or{})do tag(line1,t,nil,i)end local descLabel if desc and desc~=""then descLabel=new("TextLabel",{Name="Desc",LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=K.desc,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text=desc,},col)end local function fit()local s=pop.Scale local cw=math.floor(slot.AbsoluteSize.X/s+0.5)col.Size=UDim2.new(1,-(K.rowPad*2+(cw>0 and cw+px(16)or 0)),0,0)local rh=math.floor(r.AbsoluteSize.Y/s+0.5)slot.Position=UDim2.new(1,-K.rowPad,0,math.floor((math.max(rh,K.rowMin)-K.ctrlH)/2))end STATE.connect(slot:GetPropertyChangedSignal("AbsoluteSize"),fit)STATE.connect(r:GetPropertyChangedSignal("AbsoluteSize"),fit)if HOVER then STATE.connect(r.MouseEnter,function()tween(hover,0.15,{BackgroundTransparency=0})end)STATE.connect(r.MouseLeave,function()tween(hover,0.25,{BackgroundTransparency=1})end)end task.defer(fit)table.insert(g.page.rows,{r=r,g=g,title=title,desc=(desc and desc:match("%S"))and desc or""})return r,slot,titleLabel,descLabel end local function rowHit(r)return new("TextButton",{Name="Hit",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,AutoButtonColor=false,Text="",ZIndex=5,},r)end local function toggle(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local tw_,th=even(px(44)),even(px(24))local inset=px(3)local ks=th-inset*2 local OFF_KNOB=Color3.fromRGB(196,202,216)local track=new("Frame",{Name="Switch",Position=UDim2.fromOffset(0,math.floor((K.ctrlH-th)/2)),Size=UDim2.fromOffset(tw_,th),BackgroundColor3=T.track,},slot)corner(track,th)local trackStroke=stroke(track,T.fieldLine)local knob=new("Frame",{Name="Knob",AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,inset,0.5,0),Size=UDim2.fromOffset(ks,ks),BackgroundColor3=OFF_KNOB,},track)corner(knob,ks)local hit=rowHit(r)local obj={Value=o.Value==true}local pressing=false local function paint(t)local on=obj.Value local goal={AnchorPoint=Vector2.new(on and 1 or 0,0.5),Position=UDim2.new(on and 1 or 0,on and-inset or inset,0.5,0),Size=UDim2.fromOffset(pressing and ks+px(6)or ks,ks),BackgroundColor3=on and knobOn()or OFF_KNOB,}if t<=0 then for k,v in pairs(goal)do knob[k]=v end track.BackgroundColor3=on and C.accent or T.track trackStroke.Color=on and C.accent or T.fieldLine return end tween(knob,t,goal)tween(track,t,{BackgroundColor3=on and C.accent or T.track})tween(trackStroke,t,{Color=on and C.accent or T.fieldLine})end function obj:Set(v)obj.Value=v==true paint(0.3)if o.Callback then task.spawn(o.Callback,obj.Value)end CTRL.changed(obj.entry)end paint(0)onThemeChanged(function()if track.Parent then paint(0.45)end end)local downAt STATE.connect(hit.InputBegan,function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then downAt=CTRL.pointOf(input)end end)STATE.connect(hit.MouseButton1Down,function()pressing=true paint(0.15)end)STATE.connect(hit.MouseLeave,function()if pressing then pressing=false paint(0.2)end end)STATE.connect(hit.MouseButton1Click,function()pressing=false if CTRL.swallow then paint(0.2)return end if CTRL.pinHit and CTRL.pinHit(obj.entry,downAt)then paint(0.2)return end obj:Set(not obj.Value)end)obj.entry=CTRL.register("toggle",g,title,obj,r,o)return obj end local function decimals(step)local s=tostring(step)local d=s:match("%.(%d+)$")return d and#d or 0 end local function slider(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local v=type(o.Value)=="table"and o.Value or{}local min,max=tonumber(v.Min)or 0,tonumber(v.Max)or 100 local step=tonumber(o.Step)or 1 local dec=decimals(step)local suffix=o.Suffix or""local obj={Value=math.clamp(tonumber(v.Default)or min,min,max)}local trackW,valueW=px(190),px(60)local holder=new("Frame",{Size=UDim2.fromOffset(trackW+px(12)+valueW,K.ctrlH),BackgroundTransparency=1},slot)local hit=new("TextButton",{Name="Track",Size=UDim2.fromOffset(trackW,K.ctrlH),BackgroundTransparency=1,AutoButtonColor=false,Text=""},holder)local trackH=even(px(6))local track=new("Frame",{Position=UDim2.fromOffset(0,math.floor((K.ctrlH-trackH)/2)),Size=UDim2.fromOffset(trackW,trackH),BackgroundColor3=T.track,BorderSizePixel=0,},hit)corner(track,trackH)local fill=new("Frame",{Name="Fill",Size=UDim2.fromScale(0,1),BackgroundColor3=C.accent,BorderSizePixel=0},track)corner(fill,trackH)local knobS=even(px(16))local knob=new("Frame",{Name="Knob",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(knobS,knobS),BackgroundColor3=WHITE,BorderSizePixel=0,ZIndex=2,},track)corner(knob,knobS)local ring=stroke(knob,C.accent,0.55,0)local pillH=even(px(26))local pill=new("Frame",{Position=UDim2.fromOffset(trackW+px(12),math.floor((K.ctrlH-pillH)/2)),Size=UDim2.fromOffset(valueW,pillH),BackgroundColor3=T.field,},holder)corner(pill,px(7))local pillStroke=stroke(pill,T.fieldLine)local valueBox=new("TextBox",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.mono,TextSize=px(12),TextColor3=T.text,ClearTextOnFocus=false,Text="",ClipsDescendants=true,},pill)local function paint(t)local a=max>min and(obj.Value-min)/(max-min)or 0 tween(fill,t,{Size=UDim2.fromScale(a,1)})tween(knob,t,{Position=UDim2.new(a,0,0.5,0)})if not valueBox:IsFocused()then valueBox.Text=string.format("%."..dec.."f",obj.Value)..suffix end end local function snap(x)x=math.clamp(tonumber(x)or min,min,max)x=min+math.floor((x-min)/step+0.5)*step return math.clamp(tonumber(string.format("%."..dec.."f",x)),min,max)end function obj:Set(x)x=snap(x)local changed=x~=obj.Value obj.Value=x paint(0.12)if changed and o.Callback then task.spawn(o.Callback,x)end if changed then CTRL.changed(obj.entry)end end paint(0)STATE.connect(valueBox.Focused,function()valueBox.Text=string.format("%."..dec.."f",obj.Value)valueBox.CursorPosition,valueBox.SelectionStart=#valueBox.Text+1,1 tween(pillStroke,0.15,{Color=C.accent})tween(pill,0.15,{BackgroundColor3=T.fieldHot})end)STATE.connect(valueBox.FocusLost,function()tween(pillStroke,0.2,{Color=T.fieldLine})tween(pill,0.2,{BackgroundColor3=T.field})local n=tonumber((valueBox.Text:gsub("[^%d%.%-]","")))if n then obj:Set(n)end paint(0.12)end)local dragging,hovering=false,false local function rest()local big=dragging or hovering tween(knob,0.2,{Size=UDim2.fromOffset(big and knobS+px(2)or knobS,big and knobS+px(2)or knobS)})tween(ring,0.2,{Thickness=dragging and px(5)or(hovering and px(3)or 0)})end local function fromMouse(x)obj:Set(min+math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)*(max-min))end STATE.connect(hit.MouseEnter,function()hovering=true rest()end)STATE.connect(hit.MouseLeave,function()hovering=false rest()end)STATE.connect(hit.InputBegan,function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true rest()fromMouse(input.Position.X)end end)STATE.connect(UIS.InputChanged,function(input)if dragging and(input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)then fromMouse(input.Position.X)end end)STATE.connect(UIS.InputEnded,function(input)if dragging and(input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch)then dragging=false rest()end end)obj.Display=function()return string.format("%."..dec.."f",obj.Value)..suffix end obj.entry=CTRL.register("slider",g,title,obj,r,o)return obj end local openPopup closePopup=function()if openPopup then local p=openPopup openPopup=nil p.close()end end STATE.connect(UIS.InputBegan,function(input)if not openPopup then return end if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end local m=UIS:GetMouseLocation()if input.UserInputType==Enum.UserInputType.Touch then local inset=game:GetService("GuiService"):GetGuiInset()m=Vector2.new(input.Position.X+inset.X,input.Position.Y+inset.Y)end local function inside(el)local a,s=el.AbsolutePosition,el.AbsoluteSize return m.X>=a.X and m.X<=a.X+s.X and m.Y>=a.Y and m.Y<=a.Y+s.Y end if not(inside(openPopup.list)or inside(openPopup.field))then closePopup()end end)local function dropdown(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local obj={Values=o.Values or{}}local multi=o.Multi==true local chosen local function setChosen(v)if multi then chosen={}if type(v)=="table"then for k,x in pairs(v)do local label=(type(k)=="string"and x==true)and k or x if label~=nil then chosen[label]=true end end elseif v~=nil then chosen[v]=true end else chosen=v end end setChosen(o.Value)if not multi and chosen==nil and not o.AllowNone then chosen=obj.Values[1]end local width=px(200)local field=new("TextButton",{Name="Dropdown",Size=UDim2.fromOffset(width,K.ctrlH),BackgroundColor3=T.field,AutoButtonColor=false,Text=""},slot)corner(field,px(9))local fieldStroke=stroke(field,T.fieldLine)local text=new("TextLabel",{Position=UDim2.fromOffset(px(12),0),Size=UDim2.new(1,-px(38),1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,},field)local chevS2=even(px(14))local chev=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(1,-px(18),0.5,0),Size=UDim2.fromOffset(chevS2,chevS2),BackgroundTransparency=1,Image=ICON["chevron-down"],ImageColor3=T.subtext,},field)local isOpen=false STATE.connect(field.MouseEnter,function()if not isOpen then tween(fieldStroke,0.15,{Color=T.fieldLineHot})end tween(field,0.15,{BackgroundColor3=T.fieldHot})end)STATE.connect(field.MouseLeave,function()if not isOpen then tween(fieldStroke,0.2,{Color=T.fieldLine})end tween(field,0.2,{BackgroundColor3=T.field})end)local function list()local out={}for _,v in ipairs(obj.Values)do if chosen[v]then table.insert(out,v)end end return out end local function refresh()if not multi then text.Text=chosen~=nil and tostring(chosen)or"None"return end local l=list()if#l>1 and#l==#obj.Values then text.Text=("All selected (%d)"):format(#l)return end text.Text=#l==0 and"None"or(#l==1 and tostring(l[1])or("%s +%d"):format(tostring(l[1]),#l-1))end refresh()obj.Value=multi and list()or chosen local function fire()obj.Value=multi and list()or chosen if o.Callback then task.spawn(o.Callback,obj.Value)end CTRL.changed(obj.entry)end obj.Display=function()return text.Text end local itemH=even(px(34))local function open()closePopup()isOpen=true local pos,size=inWindow(field)local pad=px(6)local searchable=o.Search==true or(o.Search~=false and#obj.Values>5)local sbH=even(px(34))local toolH=even(px(28))local headH=(searchable and sbH+pad or 0)+(multi and toolH+pad or 0)local listW=math.max(size.X,px(260))local want=pad+headH+math.max(1,math.min(#obj.Values,7))*itemH+pad local below=T.size.Y-px(10)-(pos.Y+size.Y+px(6))local above=pos.Y-px(6)-px(10)local up=below<want and above>below local fullH=math.min(want,math.max(up and above or below,pad*2+headH+itemH*2))local rest=UDim2.fromOffset(pos.X+size.X,up and(pos.Y-px(6))or(pos.Y+size.Y+px(6)))local shift=UDim2.fromOffset(0,up and px(6)or-px(6))local listFrame=new("CanvasGroup",{Name="DropdownList",AnchorPoint=Vector2.new(1,up and 1 or 0),Position=rest+shift,Size=UDim2.fromOffset(listW,fullH),BackgroundColor3=T.popup,GroupTransparency=1,},overlay)corner(listFrame,px(10))local listStroke=stroke(listFrame,T.fieldLineHot,1)local y0=pad local query if searchable then local sb=new("Frame",{Position=UDim2.fromOffset(pad,y0),Size=UDim2.new(1,-pad*2,0,sbH),BackgroundColor3=T.field,},listFrame)corner(sb,px(8))local sbStroke=stroke(sb,T.fieldLine)local qi=even(px(14))local qIcon=new("ImageLabel",{Position=UDim2.fromOffset(px(10),math.floor((sbH-qi)/2)),Size=UDim2.fromOffset(qi,qi),BackgroundTransparency=1,Image=ICON.search,ImageColor3=T.muted,},sb)local qx=px(10)+qi+px(8)query=new("TextBox",{Position=UDim2.fromOffset(qx,0),Size=UDim2.new(1,-(qx+sbH),1,0),BackgroundTransparency=1,ClearTextOnFocus=false,FontFace=T.font,TextSize=px(13),TextColor3=T.text,PlaceholderText=("Search %d items..."):format(#obj.Values),PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true,},sb)local clearQ=new("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(4),0.5,0),Size=UDim2.fromOffset(sbH-px(8),sbH-px(8)),BackgroundColor3=T.fieldHot,BackgroundTransparency=1,AutoButtonColor=false,Text="",Visible=false,},sb)corner(clearQ,px(6))local cx=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(12)),even(px(12))),BackgroundTransparency=1,Image=ICON.x,ImageColor3=T.muted,},clearQ)clearQ.MouseEnter:Connect(function()tween(clearQ,0.12,{BackgroundTransparency=0})tween(cx,0.12,{ImageColor3=T.text})end)clearQ.MouseLeave:Connect(function()tween(clearQ,0.15,{BackgroundTransparency=1})tween(cx,0.15,{ImageColor3=T.muted})end)clearQ.MouseButton1Click:Connect(function()query.Text=""end)query.Focused:Connect(function()tween(sbStroke,0.15,{Color=C.accent})tween(qIcon,0.15,{ImageColor3=C.accent})end)query.FocusLost:Connect(function()tween(sbStroke,0.2,{Color=T.fieldLine})tween(qIcon,0.2,{ImageColor3=T.muted})end)query:GetPropertyChangedSignal("Text"):Connect(function()clearQ.Visible=query.Text~=""end)y0+=sbH+pad end local countLabel,allBtn,noneBtn if multi then local bar=new("Frame",{Position=UDim2.fromOffset(pad,y0),Size=UDim2.new(1,-pad*2,0,toolH),BackgroundTransparency=1},listFrame)countLabel=new("TextLabel",{Position=UDim2.fromOffset(px(4),0),Size=UDim2.new(0.45,0,1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},bar)local btns=new("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.fromOffset(0,toolH),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,},bar)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(6)),SortOrder=Enum.SortOrder.LayoutOrder,},btns)local function toolButton(order,label)local b=new("TextButton",{LayoutOrder=order,Size=UDim2.fromOffset(0,toolH),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=T.field,AutoButtonColor=false,FontFace=T.fontSemi,TextSize=px(12),TextColor3=T.text,Text=label,},btns)corner(b,px(7))local st=stroke(b,T.fieldLine)new("UIPadding",{PaddingLeft=UDim.new(0,px(10)),PaddingRight=UDim.new(0,px(10))},b)local tb={btn=b,stroke=st,enabled=true}b.MouseEnter:Connect(function()if tb.enabled then tween(b,0.12,{BackgroundColor3=T.fieldHot})tween(st,0.12,{Color=T.fieldLineHot})end end)b.MouseLeave:Connect(function()tween(b,0.15,{BackgroundColor3=T.field})tween(st,0.15,{Color=T.fieldLine})end)return tb end allBtn=toolButton(1,"Select all")noneBtn=toolButton(2,"Clear")y0+=toolH+pad end if headH>0 then new("Frame",{Position=UDim2.fromOffset(0,y0-math.ceil(pad/2)),Size=UDim2.new(1,0,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},listFrame)end local top=headH>0 and y0 or 0 local scroller=new("ScrollingFrame",{Position=UDim2.fromOffset(0,top),Size=UDim2.new(1,0,1,-top),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=px(3),ScrollBarImageColor3=T.fieldLineHot,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,},listFrame)new("UIPadding",{PaddingTop=UDim.new(0,headH>0 and px(2)or pad),PaddingBottom=UDim.new(0,pad),PaddingLeft=UDim.new(0,pad),PaddingRight=UDim.new(0,pad),},scroller)new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},scroller)local emptyLabel=new("TextLabel",{LayoutOrder=#obj.Values+1,Size=UDim2.new(1,0,0,itemH*1.5),BackgroundTransparency=1,Visible=#obj.Values==0,FontFace=T.font,TextSize=px(13),TextColor3=T.muted,Text=#obj.Values==0 and"Nothing to choose"or"No matches",},scroller)local items={}local function isOn(v)if multi then return chosen[v]==true end return chosen==v end local boxS=even(px(16))for i,v in ipairs(obj.Values)do local item=new("TextButton",{Name=tostring(v),LayoutOrder=i,Size=UDim2.new(1,0,0,itemH),BackgroundColor3=T.rowActive,BackgroundTransparency=1,AutoButtonColor=false,Text="",},scroller)corner(item,px(7))local textX=multi and(px(10)+boxS+px(10))or px(10)local itemText=new("TextLabel",{Position=UDim2.fromOffset(textX,0),Size=UDim2.new(1,-(textX+px(30)),1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=isOn(v)and T.text or T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=tostring(v),TextTransparency=1,},item)local it={item=item,v=v,label=tostring(v):lower()}if multi then local box=new("Frame",{Position=UDim2.fromOffset(px(10),math.floor((itemH-boxS)/2)),Size=UDim2.fromOffset(boxS,boxS),BackgroundColor3=T.field,},item)corner(box,px(4))local bst=stroke(box,T.fieldLineHot)local tick=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(11)),even(px(11))),BackgroundTransparency=1,Image=ICON.check,ImageColor3=onAccent(),ImageTransparency=1,},box)it.paint=function(t)local on=isOn(v)tick.ImageColor3=onAccent()tween(box,t,{BackgroundColor3=on and C.accent or T.field})tween(bst,t,{Color=on and C.accent or T.fieldLineHot})tween(tick,t,{ImageTransparency=on and 0 or 1})tween(itemText,t,{TextColor3=(on or it.hover)and T.text or T.subtext})end else local markS=even(px(14))local mark=new("ImageLabel",{Size=UDim2.fromOffset(markS,markS),Position=UDim2.new(1,-px(22),0,math.floor((itemH-markS)/2)),BackgroundTransparency=1,Image=ICON.check,ImageColor3=C.accent,ImageTransparency=1,},item)it.paint=function(t)local on=isOn(v)tween(mark,t,{ImageTransparency=on and 0 or 1})tween(itemText,t,{TextColor3=(on or it.hover)and T.text or T.subtext})end end it.paint(0)task.delay(0.02*math.min(i,8),function()if itemText.Parent then tween(itemText,0.25,{TextTransparency=0})end end)items[i]=it item.MouseEnter:Connect(function()it.hover=true tween(item,0.12,{BackgroundTransparency=0})it.paint(0.12)end)item.MouseLeave:Connect(function()it.hover=false tween(item,0.18,{BackgroundTransparency=1})it.paint(0.18)end)end local function updateTools()if not multi then return end local filtered=query~=nil and query.Text~=""local shown,shownOn=0,0 for _,it in ipairs(items)do if it.item.Visible then shown+=1 if chosen[it.v]then shownOn+=1 end end end countLabel.Text=("%d / %d selected"):format(#list(),#obj.Values)allBtn.btn.Text=filtered and"Select shown"or"Select all"noneBtn.btn.Text=filtered and"Clear shown"or"Clear"allBtn.enabled=shownOn<shown noneBtn.enabled=shownOn>0 for _,tb in ipairs({allBtn,noneBtn})do tween(tb.btn,0.15,{TextColor3=tb.enabled and T.text or T.muted,BackgroundTransparency=tb.enabled and 0 or 0.5})end end local function chooseShown(on)for _,it in ipairs(items)do if it.item.Visible then chosen[it.v]=on or nil it.paint(0.18)end end refresh()fire()updateTools()end if multi then allBtn.btn.MouseButton1Click:Connect(function()if allBtn.enabled then chooseShown(true)end end)noneBtn.btn.MouseButton1Click:Connect(function()if noneBtn.enabled then chooseShown(false)end end)end for _,it in ipairs(items)do it.item.MouseButton1Click:Connect(function()if multi then chosen[it.v]=not chosen[it.v]or nil it.paint(0.15)refresh()fire()updateTools()else chosen=it.v refresh()fire()closePopup()end end)end if query then query:GetPropertyChangedSignal("Text"):Connect(function()local q=query.Text:lower():gsub("^%s+",""):gsub("%s+$","")local any=false for _,it in ipairs(items)do it.item.Visible=q==""or it.label:find(q,1,true)~=nil any=any or it.item.Visible end emptyLabel.Visible=not any scroller.CanvasPosition=Vector2.new()updateTools()end)query.FocusLost:Connect(function(enter)if not enter or multi then return end for _,it in ipairs(items)do if it.item.Visible then chosen=it.v refresh()fire()closePopup()return end end end)if UIS.KeyboardEnabled then task.defer(function()if query.Parent then query:CaptureFocus()end end)end end updateTools()tween(listFrame,0.3,{Position=rest})tween(listFrame,0.2,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(listStroke,0.2,{Transparency=0})tween(chev,0.28,{Rotation=180})tween(fieldStroke,0.15,{Color=C.accent})openPopup={list=listFrame,field=field,close=function()isOpen=false if query and query:IsFocused()then query:ReleaseFocus()end tween(chev,0.22,{Rotation=0})tween(fieldStroke,0.2,{Color=T.fieldLine})tween(listStroke,0.15,{Transparency=1})tween(listFrame,0.18,{Position=rest+shift})local tw=tween(listFrame,0.15,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()listFrame:Destroy()end)end,}end STATE.connect(field.MouseButton1Click,function()if CTRL.swallow then return end if openPopup and openPopup.field==field then closePopup()else open()end end)function obj:Select(v)setChosen(v)refresh()fire()end function obj:Refresh(values)obj.Values=values or{}if multi then local keep={}for _,x in ipairs(obj.Values)do if chosen[x]then keep[x]=true end end chosen=keep elseif not table.find(obj.Values,chosen)then chosen=obj.Values[1]end refresh()end function obj:SelectAll()if not multi then return end if openPopup and openPopup.field==field then closePopup()end for _,v in ipairs(obj.Values)do chosen[v]=true end refresh()fire()end function obj:Clear()if openPopup and openPopup.field==field then closePopup()end if multi then chosen={}else chosen=nil end refresh()fire()end obj.entry=CTRL.register("dropdown",g,title,obj,r,o)return obj end local KEYNAMES={LeftShift="LShift",RightShift="RShift",LeftControl="LCtrl",RightControl="RCtrl",LeftAlt="LAlt",RightAlt="RAlt",MouseButton2="RMB",MouseButton3="MMB"}local function keybind(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local obj={Value=typeof(o.Value)=="EnumItem"and o.Value.Name or o.Value,Picking=false}local btn=new("TextButton",{Name="Keybind",Size=UDim2.fromOffset(px(96),K.ctrlH),BackgroundColor3=T.field,AutoButtonColor=false,Text=""},slot)corner(btn,px(9))local st=stroke(btn,T.fieldLine)local label=new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.mono,TextSize=px(12),TextColor3=T.text},btn)local function paint()if obj.Picking then label.Text,label.TextColor3="...",C.accent else label.Text=obj.Value and(KEYNAMES[obj.Value]or obj.Value)or"None"label.TextColor3=obj.Value and T.text or T.muted end tween(st,0.2,{Color=obj.Picking and C.accent or T.fieldLine})tween(btn,0.2,{BackgroundColor3=obj.Picking and T.fieldHot or T.field})end function obj:Set(k)obj.Value=typeof(k)=="EnumItem"and k.Name or((type(k)=="string"and k~="")and k or nil)paint()if o.Callback then task.spawn(o.Callback,obj.Value)end CTRL.changed(obj.entry)end obj.Display=function()return label.Text end paint()STATE.connect(btn.MouseEnter,function()if not obj.Picking then tween(st,0.15,{Color=T.fieldLineHot})end end)STATE.connect(btn.MouseLeave,function()if not obj.Picking then tween(st,0.2,{Color=T.fieldLine})end end)STATE.connect(btn.MouseButton1Click,function()if obj.Picking then return end obj.Picking=true capture.active=true paint()end)STATE.connect(UIS.InputBegan,function(input)if not obj.Picking then return end local kc=input.KeyCode local mb=input.UserInputType==Enum.UserInputType.MouseButton2 or input.UserInputType==Enum.UserInputType.MouseButton3 if kc==Enum.KeyCode.Unknown and not mb then return end task.defer(function()obj.Picking=false capture.active=false paint()end)if kc==Enum.KeyCode.Escape then return end if kc==Enum.KeyCode.Backspace then obj:Set(nil)return end obj.Value=mb and input.UserInputType.Name or kc.Name if o.Callback then task.spawn(o.Callback,obj.Value)end CTRL.changed(obj.entry)end)obj.entry=CTRL.register("keybind",g,title,obj,r,o)return obj end local function paragraph(g,o)local title,tags=parseTitle(o.Title)local _,_,titleLabel,descLabel=row(g,title,(o.Desc and o.Desc~="")and o.Desc or" ",tags)local obj={}function obj:SetDesc(t)if descLabel then descLabel.Text=tostring(t or"")end end function obj:SetTitle(t)titleLabel.Text=(parseTitle(t))end return obj end local function input(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local f=new("Frame",{Name="Input",Size=UDim2.fromOffset(px(o.Width or 200),K.ctrlH),BackgroundColor3=T.field},slot)corner(f,px(9))local st=stroke(f,T.fieldLine)local box=new("TextBox",{Position=UDim2.fromOffset(px(10),0),Size=UDim2.new(1,-px(20),1,0),BackgroundTransparency=1,ClearTextOnFocus=o.ClearOnFocus==true,FontFace=T.font,TextSize=px(13),TextColor3=T.text,PlaceholderText=tostring(o.Placeholder or""),PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true,},f)local function clean(v)if o.Numeric then local n=tonumber(v)or tonumber(o.Value)or tonumber(o.Min)or 0 if tonumber(o.Min)then n=math.max(n,tonumber(o.Min))end if tonumber(o.Max)then n=math.min(n,tonumber(o.Max))end return n end v=tostring(v==nil and""or v)local m=tonumber(o.MaxLength)if m and#v>m then v=v:sub(1,m)end return v end local obj={Value=clean(o.Value)}box.Text=tostring(obj.Value)local function commit(fire)local v=clean(box.Text)local changed=v~=obj.Value obj.Value=v if not box:IsFocused()then box.Text=tostring(v)end if fire and o.Callback then task.spawn(o.Callback,v)end if changed then CTRL.changed(obj.entry)end end function obj:Set(v)box.Text=tostring(clean(v))commit(true)end function obj:Get()return obj.Value end obj.Display=function()return tostring(obj.Value)end obj.Box=box STATE.connect(box.Focused,function()tween(st,0.15,{Color=C.accent})tween(f,0.15,{BackgroundColor3=T.fieldHot})end)STATE.connect(box.FocusLost,function()tween(st,0.2,{Color=T.fieldLine})tween(f,0.2,{BackgroundColor3=T.field})if not o.Live then commit(true)end end)if o.Live then STATE.connect(box:GetPropertyChangedSignal("Text"),function()if box:IsFocused()then commit(true)end end)end obj.entry=CTRL.register("input",g,title,obj,r,o)return obj end local function keyValue(g,o)local title,tags=parseTitle(o.Title)local _,slot=row(g,title,o.Desc,tags)local val=new("TextLabel",{Size=UDim2.fromOffset(0,K.ctrlH),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,FontFace=T.mono,TextSize=px(13),TextColor3=o.Color or T.subtext,TextXAlignment=Enum.TextXAlignment.Right,Text=tostring(o.Value==nil and""or o.Value),},slot)local obj={Value=o.Value,Label=val}function obj:Set(v)obj.Value=v val.Text=tostring(v==nil and""or v)end function obj:Get()return obj.Value end function obj:SetColor(c)val.TextColor3=c end return obj end local function label(g,o)g.rows+=1 local f=new("Frame",{Name="Label",LayoutOrder=g.rows,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},g.card)if g.rows>1 then new("Frame",{Name="Line",Position=UDim2.fromOffset(K.rowPad,0),Size=UDim2.new(1,-K.rowPad*2,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},f)end new("UIPadding",{PaddingTop=UDim.new(0,px(11)),PaddingBottom=UDim.new(0,px(11)),PaddingLeft=UDim.new(0,K.rowPad),PaddingRight=UDim.new(0,K.rowPad),},f)local text=tostring(o.Text or o.Title or"")local l=new("TextLabel",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=o.Bold and T.fontSemi or T.font,TextSize=K.desc+1,TextColor3=o.Color or T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,RichText=true,Text=text,},f)table.insert(g.page.rows,{r=f,g=g,title=text:gsub("<[^>]+>",""),desc=""})local obj={Frame=f,Label=l}function obj:Set(t)l.Text=tostring(t==nil and""or t)end function obj:SetColor(c)l.TextColor3=c end return obj end local function button(g,o)local title,tags=parseTitle(o.Title)local r,slot=row(g,title,o.Desc,tags)local s=K.ctrlH local b=new("Frame",{Name="Run",Size=UDim2.fromOffset(s,s),BackgroundColor3=T.field},slot)corner(b,px(9))local st=stroke(b,T.fieldLine)local icS=even(px(15))local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=icon(o.Icon or"play"),ImageColor3=T.subtext,},b)local icScale=new("UIScale",{},ic)local hit=rowHit(r)STATE.connect(hit.MouseEnter,function()tween(b,0.15,{BackgroundColor3=T.fieldHot})tween(st,0.15,{Color=C.accent,Transparency=0.4})tween(ic,0.15,{ImageColor3=C.accent})end)STATE.connect(hit.MouseLeave,function()tween(b,0.2,{BackgroundColor3=T.field})tween(st,0.2,{Color=T.fieldLine,Transparency=0})tween(ic,0.2,{ImageColor3=T.subtext})tween(icScale,0.2,{Scale=1})end)local obj={}function obj.Run()tween(icScale,0.4,{Scale=1},Enum.EasingStyle.Back)b.BackgroundColor3=C.accent:Lerp(T.field,0.55)tween(b,0.45,{BackgroundColor3=T.fieldHot})if o.Callback then task.spawn(o.Callback)end end local downAt STATE.connect(hit.InputBegan,function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then downAt=CTRL.pointOf(input)end end)STATE.connect(hit.MouseButton1Down,function()tween(icScale,0.1,{Scale=0.82})end)STATE.connect(hit.MouseButton1Click,function()if CTRL.swallow then tween(icScale,0.2,{Scale=1})return end if CTRL.pinHit and CTRL.pinHit(obj.entry,downAt)then tween(icScale,0.2,{Scale=1})return end obj.Run()end)obj.entry=CTRL.register("button",g,title,obj,r,o)return obj end local notify do local toastHolder=new("Frame",{Name="Toasts",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(20),1,-px(20)),Size=UDim2.fromOffset(px(330),0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},gui)new("UIListLayout",{Padding=UDim.new(0,px(10)),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Bottom},toastHolder)local toastN=0 local function toastColor(name)if name=="check"or name=="package-check"or name=="circle-check"then return C.green end if name=="triangle-alert"or name=="alert-triangle"then return C.amber end if name=="x"then return C.red end return C.accent end function notify(o)toastN+=1 local col=toastColor(o.Icon)local wrap=new("Frame",{LayoutOrder=toastN,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},toastHolder)local card=new("CanvasGroup",{Position=UDim2.fromOffset(px(40),0),Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.popup,GroupTransparency=1,},wrap)corner(card,px(12))local cardStroke=stroke(card,T.fieldLine,1)local inner=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},card)new("UIPadding",{PaddingTop=UDim.new(0,px(14)),PaddingBottom=UDim.new(0,px(16)),PaddingLeft=UDim.new(0,px(54)),PaddingRight=UDim.new(0,px(14))},inner)new("UIListLayout",{Padding=UDim.new(0,px(3)),SortOrder=Enum.SortOrder.LayoutOrder},inner)local badgeS=even(px(28))local badge=new("Frame",{Position=UDim2.fromOffset(px(14),px(14)),Size=UDim2.fromOffset(badgeS,badgeS),BackgroundColor3=col,BackgroundTransparency=0.82},card)corner(badge,px(8))new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(14)),even(px(14))),BackgroundTransparency=1,Image=icon(o.Icon),ImageColor3=col:Lerp(WHITE,0.2),},badge)new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,px(18)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(14),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=tostring(o.Title or"Mono"),},inner)if o.Content and o.Content~=""then new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text=tostring(o.Content),},inner)end local duration=tonumber(o.Duration)or 4 local bar=new("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.fromScale(0,1),Size=UDim2.new(1,0,0,px(2)),BackgroundColor3=col,BackgroundTransparency=0.25,BorderSizePixel=0,ZIndex=2,},card)local hit=new("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=3},card)tween(card,0.5,{Position=UDim2.fromOffset(0,0)})tween(card,0.3,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(cardStroke,0.3,{Transparency=0})tween(bar,duration,{Size=UDim2.new(0,0,0,px(2))},Enum.EasingStyle.Linear)local gone=false local function dismiss()if gone or not wrap.Parent then return end gone=true tween(cardStroke,0.2,{Transparency=1})tween(card,0.25,{GroupTransparency=1},Enum.EasingStyle.Quad)local tw=tween(card,0.3,{Position=UDim2.fromOffset(px(40),0)})tw.Completed:Once(function()local h=wrap.AbsoluteSize.Y wrap.AutomaticSize=Enum.AutomaticSize.None wrap.Size=UDim2.new(1,0,0,h)card.Visible=false local fold=tween(wrap,0.22,{Size=UDim2.new(1,0,0,0)})fold.Completed:Once(function()wrap:Destroy()end)end)end hit.MouseButton1Click:Connect(dismiss)task.delay(duration,dismiss)end end local function popup(o)local shade=new("TextButton",{Name="Popup",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,AutoButtonColor=false,Text="",ZIndex=30,},window)tween(shade,0.25,{BackgroundTransparency=0.4})local card=new("CanvasGroup",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(px(o.Width or 380),0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.popup,GroupTransparency=1,},shade)corner(card,px(14))local cardStroke=stroke(card,T.fieldLineHot,1)local sc=new("UIScale",{Scale=0.9},card)new("UIPadding",{PaddingTop=UDim.new(0,px(22)),PaddingBottom=UDim.new(0,px(18)),PaddingLeft=UDim.new(0,px(22)),PaddingRight=UDim.new(0,px(22))},card)new("UIListLayout",{Padding=UDim.new(0,px(8)),SortOrder=Enum.SortOrder.LayoutOrder},card)new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,px(22)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(18),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=tostring(o.Title or""),},card)if o.Content and o.Content~=""then new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=px(14),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text=tostring(o.Content),},card)end if type(o.Build)=="function"then local extra=new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},card)new("UIPadding",{PaddingTop=UDim.new(0,px(6))},extra)local ok,err=pcall(o.Build,extra)if not ok then warn("[SPECTREWARE] popup Build failed:",err)end end local rowF=new("Frame",{LayoutOrder=4,Size=UDim2.new(1,0,0,px(46)),BackgroundTransparency=1},card)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=Enum.VerticalAlignment.Bottom,Padding=UDim.new(0,px(8)),SortOrder=Enum.SortOrder.LayoutOrder},rowF)tween(sc,0.4,{Scale=1},Enum.EasingStyle.Back)tween(card,0.25,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(cardStroke,0.25,{Transparency=0})local closing=false local function close()if closing then return end closing=true tween(sc,0.18,{Scale=0.95})tween(cardStroke,0.15,{Transparency=1})tween(card,0.15,{GroupTransparency=1},Enum.EasingStyle.Quad)local tw=tween(shade,0.22,{BackgroundTransparency=1})tw.Completed:Once(function()shade:Destroy()end)end for i,b in ipairs(o.Buttons or{})do local primary=b.Variant=="Primary"local label=tostring(b.Title or"OK")local rest=primary and C.accent or T.field local hot=primary and C.accent:Lerp(WHITE,0.15)or T.fieldHot local btn=new("TextButton",{LayoutOrder=i,Size=UDim2.fromOffset(textW(label,px(13),T.fontBold)+px(32),even(px(34))),BackgroundColor3=rest,AutoButtonColor=false,Text="",},rowF)corner(btn,px(9))if not primary then stroke(btn,T.fieldLine)end new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(13),TextColor3=primary and onAccent()or T.text,Text=label,},btn)btn.MouseEnter:Connect(function()tween(btn,0.15,{BackgroundColor3=hot})end)btn.MouseLeave:Connect(function()tween(btn,0.2,{BackgroundColor3=rest})end)btn.MouseButton1Click:Connect(function()close()if b.Callback then task.spawn(b.Callback)end end)end shade.MouseButton1Click:Connect(function()end)end local jumpTo local FEAT=(function()local F={}local GuiService=game:GetService("GuiService")local function store(name)prefs[name]=type(prefs[name])=="table"and prefs[name]or{}if type(prefs[name][GAME_KEY])~="table"then prefs[name][GAME_KEY]={}end return prefs[name][GAME_KEY]end local function pinList()local raw=store("pins")local out,seen={},{}for _,v in pairs(raw)do if type(v)=="string"and not seen[v]then seen[v]=true table.insert(out,v)end end if#out~=#raw then prefs.pins[GAME_KEY]=out end return prefs.pins[GAME_KEY]end local function keyLabel(k)return KEYNAMES[k]or k end local pinHooks={}function F.isPinned(e)return table.find(pinList(),e.id)~=nil end function F.bindOf(e)return store("binds")[e.id]end function F.paintTags(e)local col=e.row:FindFirstChild("Text")local line=col and col:FindFirstChild("TitleLine")if not line then return end local pinTag=line:FindFirstChild("PinTag")if not pinTag then pinTag=new("ImageButton",{Name="PinTag",LayoutOrder=50,Size=UDim2.fromOffset(even(px(15)),even(px(15))),BackgroundTransparency=1,Image=ICON.pin,ImageColor3=C.accent,Visible=false,AutoButtonColor=false,ZIndex=6,},line)pinTag.MouseEnter:Connect(function()pinTag.Image=ICON["pin-off"]tween(pinTag,0.12,{ImageColor3=C.red})end)pinTag.MouseLeave:Connect(function()pinTag.Image=ICON.pin tween(pinTag,0.15,{ImageColor3=C.accent})end)pinTag.MouseButton1Click:Connect(function()F.setPinned(e,false)end)end pinTag.Visible=F.isPinned(e)local keyTag=line:FindFirstChild("KeyTag")if not keyTag then keyTag=new("Frame",{Name="KeyTag",LayoutOrder=51,Size=UDim2.fromOffset(0,even(px(18))),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=T.field,Visible=false,},line)corner(keyTag,px(5))stroke(keyTag,T.fieldLineHot)new("UIPadding",{PaddingLeft=UDim.new(0,px(6)),PaddingRight=UDim.new(0,px(6))},keyTag)new("TextLabel",{Name="Key",Size=UDim2.fromScale(0,1),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,FontFace=T.mono,TextSize=px(10),TextColor3=T.subtext,Text="",},keyTag)end local k=F.bindOf(e)keyTag.Visible=k~=nil if k then keyTag.Key.Text=keyLabel(k)end end CTRL.attach=function(e)if F.isPinned(e)or F.bindOf(e)then F.paintTags(e)end end CTRL.pinHit=function(e,pt)if not e or not pt then return false end local col=e.row:FindFirstChild("Text")local line=col and col:FindFirstChild("TitleLine")local pin=line and line:FindFirstChild("PinTag")if not pin or not pin.Visible then return false end local a,sz=pin.AbsolutePosition,pin.AbsoluteSize local pad=4 if pt.X>=a.X-pad and pt.X<=a.X+sz.X+pad and pt.Y>=a.Y-pad and pt.Y<=a.Y+sz.Y+pad then F.setPinned(e,false)return true end return false end function F.setPinned(e,on)local pins=pinList()if on then if not table.find(pins,e.id)then table.insert(pins,e.id)end else for i=#pins,1,-1 do if pins[i]==e.id then table.remove(pins,i)end end end savePrefs()local ok,err=pcall(F.paintTags,e)if not ok then warn("[SPECTREWARE] pin mark:",err)end for _,fn in ipairs(pinHooks)do local ok2,err2=pcall(fn)if not ok2 then warn("[SPECTREWARE] Quick Toggles refresh:",err2)end end notify({Title=on and"Pinned to Home"or"Unpinned",Content=e.title,Icon=on and"check"or"info",Duration=2,})end function F.pinned()local out={}for _,id in ipairs(pinList())do local e=CTRL.byId[id]if e and e.row.Parent then table.insert(out,e)end end return out end function F.setBind(e,keyName)local binds=store("binds")if keyName then for id,k in pairs(binds)do if k==keyName and id~=e.id then binds[id]=nil if CTRL.byId[id]then F.paintTags(CTRL.byId[id])end end end end binds[e.id]=keyName savePrefs()F.paintTags(e)end local listening function F.listen(e)if listening then return end listening=e capture.active=true notify({Title="Bind a key",Content=('Press a key for "%s".  Esc cancels, Backspace removes it.'):format(e.title),Icon="keyboard",Duration=4,})end STATE.connect(UIS.InputBegan,function(input,processed)if not mine()then return end local kc=input.KeyCode if listening then if kc==Enum.KeyCode.Unknown then return end local e=listening listening=nil task.defer(function()capture.active=false end)if kc==Enum.KeyCode.Escape then return end if kc==Enum.KeyCode.Backspace then F.setBind(e,nil)notify({Title="Key removed",Content=e.title,Icon="info",Duration=2})return end if kc==T.toggleKey then notify({Title="Key in use",Content=("[%s] opens the menu. Pick another key."):format(kc.Name),Icon="triangle-alert",Duration=3})return end F.setBind(e,kc.Name)notify({Title="Key bound",Content=("[%s]  →  %s"):format(keyLabel(kc.Name),e.title),Icon="check",Duration=3})return end if processed or capture.active or kc==Enum.KeyCode.Unknown then return end if UIS:GetFocusedTextBox()then return end for id,k in pairs(store("binds"))do if k==kc.Name then local e=CTRL.byId[id]if e and e.row.Parent then if e.kind=="toggle"then e.obj:Set(not e.obj.Value)elseif e.kind=="button"then e.obj.Run()end end end end end)local quickTiles={}local function menuFor(e,at)closePopup()local items={}local pinned=F.isPinned(e)table.insert(items,{pinned and"pin-off"or"pin",pinned and"Unpin from Home"or"Pin to Home",function()F.setPinned(e,not pinned)end})if UIS.KeyboardEnabled and(e.kind=="toggle"or e.kind=="button")then local k=F.bindOf(e)table.insert(items,{"keyboard",k and("Change key  ["..keyLabel(k).."]")or"Bind a key",function()F.listen(e)end})if k then table.insert(items,{"x","Remove key",function()F.setBind(e,nil)notify({Title="Key removed",Content=e.title,Icon="info",Duration=2})end})end end if e.kind~="button"then table.insert(items,{"rotate-ccw","Reset to default",function()CTRL.set(e,e.default)end})end local pad,headH,itemH,w=px(6),px(28),even(px(36)),px(230)local h=pad*2+headH+#items*itemH local s=math.max(pop.Scale,0.01)local p=(at-window.AbsolutePosition)/s local x=math.clamp(p.X,px(6),math.max(px(6),T.size.X-w-px(6)))local y=math.clamp(p.Y,px(6),math.max(px(6),T.size.Y-h-px(6)))local frame=new("CanvasGroup",{Name="ContextMenu",Position=UDim2.fromOffset(x,y-px(6)),Size=UDim2.fromOffset(w,h),BackgroundColor3=T.popup,GroupTransparency=1,},overlay)corner(frame,px(10))local st=stroke(frame,T.fieldLineHot,1)local sc=new("UIScale",{Scale=0.96},frame)local list=new("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1},frame)new("UIPadding",{PaddingTop=UDim.new(0,pad),PaddingBottom=UDim.new(0,pad),PaddingLeft=UDim.new(0,pad),PaddingRight=UDim.new(0,pad)},list)new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},list)local head=new("TextLabel",{LayoutOrder=0,Size=UDim2.new(1,0,0,headH),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=e.title:upper(),},list)new("UIPadding",{PaddingLeft=UDim.new(0,px(10)),PaddingRight=UDim.new(0,px(10))},head)local close for i,it in ipairs(items)do local b=new("TextButton",{LayoutOrder=i,Size=UDim2.new(1,0,0,itemH),BackgroundColor3=T.rowActive,BackgroundTransparency=1,AutoButtonColor=false,Text="",},list)corner(b,px(7))local icS=even(px(15))local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(10),0.5,0),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=icon(it[1]),ImageColor3=T.subtext,},b)new("TextLabel",{Position=UDim2.fromOffset(px(10)+icS+px(10),0),Size=UDim2.new(1,-(px(20)+icS+px(10)),1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=it[2],},b)b.MouseEnter:Connect(function()tween(b,0.12,{BackgroundTransparency=0})tween(ic,0.12,{ImageColor3=C.accent})end)b.MouseLeave:Connect(function()tween(b,0.15,{BackgroundTransparency=1})tween(ic,0.15,{ImageColor3=T.subtext})end)b.MouseButton1Click:Connect(function()if CTRL.swallow then return end close()task.spawn(it[3])end)end tween(frame,0.28,{Position=UDim2.fromOffset(x,y)})tween(frame,0.18,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(st,0.18,{Transparency=0})tween(sc,0.3,{Scale=1},Enum.EasingStyle.Back)local closing=false local function shut()if closing then return end closing=true tween(st,0.12,{Transparency=1})tween(sc,0.15,{Scale=0.97})local tw=tween(frame,0.14,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()frame:Destroy()end)end openPopup={list=frame,field=frame,close=shut}close=function()if openPopup and openPopup.list==frame then closePopup()else shut()end end end local function entryAt(pt)if not shown or not currentPage then return nil end local function inside(gui_)local a,sz=gui_.AbsolutePosition,gui_.AbsoluteSize return pt.X>=a.X and pt.X<=a.X+sz.X and pt.Y>=a.Y and pt.Y<=a.Y+sz.Y end if openPopup and inside(openPopup.list)then return nil end if not inside(currentPage.wrap)then return nil end for tile,e in pairs(quickTiles)do if tile.Parent and tile:IsDescendantOf(currentPage.wrap)and inside(tile)then return e end end for _,e in ipairs(CTRL.list)do if e.sec.page==currentPage and e.row.Parent and e.row.Visible and e.g.card.Visible and inside(e.row)then return e end end return nil end STATE.connect(UIS.InputBegan,function(input)if input.UserInputType~=Enum.UserInputType.MouseButton2 or not mine()then return end local pt=UIS:GetMouseLocation()local e=entryAt(pt)if e then menuFor(e,pt)end end)do local presses={}local swallowBy,swallowToken=nil,0 local function release()swallowToken+=1 local my=swallowToken task.delay(0.2,function()if swallowToken==my then CTRL.swallow,swallowBy=false,nil end end)end STATE.connect(UIS.InputBegan,function(input)if input.UserInputType~=Enum.UserInputType.Touch or not mine()then return end local p={start=Vector2.new(input.Position.X,input.Position.Y),moved=false}presses[input]=p task.delay(0.5,function()if presses[input]~=p or p.moved or input.UserInputState==Enum.UserInputState.End then return end local inset=GuiService:GetGuiInset()local pt=p.start+Vector2.new(inset.X,inset.Y)local e=entryAt(pt)if e then CTRL.swallow,swallowBy=true,input swallowToken+=1 local my=swallowToken task.delay(1.5,function()if swallowToken==my then CTRL.swallow,swallowBy=false,nil end end)menuFor(e,pt)end end)end)STATE.connect(UIS.InputChanged,function(input)local p=presses[input]if p and(Vector2.new(input.Position.X,input.Position.Y)-p.start).Magnitude>10 then p.moved=true end end)STATE.connect(UIS.InputEnded,function(input)if not presses[input]then return end presses[input]=nil if swallowBy==input then release()end end)end local canFile=(writefile and readfile and isfile and listfiles and makefolder and isfolder)and true or false local ROOT,DIR="MonoUI/configs","MonoUI/configs/"..GAME_KEY local memory={}local function ensureDir()pcall(function()if not isfolder("MonoUI")then makefolder("MonoUI")end if not isfolder(ROOT)then makefolder(ROOT)end if not isfolder(DIR)then makefolder(DIR)end end)end local function clean(name)name=tostring(name or""):gsub('[%c\\/:%*%?"<>|%.]',""):gsub("^%s+",""):gsub("%s+$","")local len=utf8.len(name)if len and len>32 then name=name:sub(1,utf8.offset(name,33)-1)end return name end local function file(name)return DIR.."/"..name..".json"end local cfg={refresh=function()end,current=nil}local function when(t)t=tonumber(t)if not t then return nil end local d=math.max(0,os.time()-t)if d<60 then return"just now"end if d<3600 then return math.floor(d/60).." min ago"end if d<86400 then return math.floor(d/3600).." h ago"end local ok,s=pcall(function()return DateTime.fromUnixTimestamp(t):FormatLocalTime("D MMM YYYY","en-us")end)return ok and s or(math.floor(d/86400).." days ago")end function cfg.names()local out={}if canFile then pcall(function()ensureDir()for _,f in ipairs(listfiles(DIR))do local n=tostring(f):gsub("\\","/"):match("([^/]+)%.json$")if n then table.insert(out,n)end end end)else for n in pairs(memory)do table.insert(out,n)end end table.sort(out,function(a,b)return a:lower()<b:lower()end)return out end function cfg.exists(name)return table.find(cfg.names(),clean(name))~=nil end function cfg.read(name)local data if canFile then pcall(function()data=HttpService:JSONDecode(readfile(file(name)))end)else data=memory[name]end return(type(data)=="table"and type(data.values)=="table")and data or nil end function cfg.list()local out={}for _,n in ipairs(cfg.names())do local d=cfg.read(n)local count=0 if d then for _ in pairs(d.values)do count+=1 end end table.insert(out,{name=n,ok=d~=nil,count=count,savedAt=d and d.savedAt,theme=d and type(d.ui)=="table"and d.ui.theme or nil,})end return out end function cfg.save(name)name=clean(name)if name==""then notify({Title="Config",Content="Type a name first.",Icon="triangle-alert",Duration=3})return false end local values,n={},0 for _,e in ipairs(CTRL.list)do if e.config and e.row.Parent then values[e.id]=CTRL.get(e)n+=1 end end local data={version=2,name=name,savedAt=os.time(),values=values,ui={theme=currentTheme,custom=prefs.custom},}if canFile then local ok=pcall(function()ensureDir()writefile(file(name),HttpService:JSONEncode(data))end)if not ok then notify({Title="Config",Content="Could not write the file.",Icon="triangle-alert"})return false end else memory[name]=data end cfg.current=name notify({Title="Config saved",Content=('"%s"  ·  %d settings + theme'):format(name,n),Icon="check",Duration=3})cfg.refresh()return true end function cfg.load(name,quiet)local data=cfg.read(name)if not data then notify({Title="Config",Content=('Could not read "%s".'):format(name),Icon="triangle-alert"})return false end CTRL.muted=true local n=0 for id,v in pairs(data.values)do local e=CTRL.byId[id]if e and e.config then pcall(CTRL.set,e,v)n+=1 end end CTRL.muted=false local ui=type(data.ui)=="table"and data.ui or nil if ui then local cu=type(ui.custom)=="table"and ui.custom or nil if cu and HEX.to(cu.accent)then addTheme("Custom",HEX.to(cu.base)or THEMES.Custom.palette.bg,HEX.to(cu.accent))prefs.custom=cu end if ui.theme and THEMES[ui.theme]then pcall(applyTheme,ui.theme,true,true,ui.theme=="Custom")end end cfg.current=name for _,fn in ipairs(CTRL.hooks)do pcall(fn,nil,false)end if F.islandFlash then F.islandFlash("folder-open",('Loaded "%s"'):format(name),C.accent)end if not quiet then notify({Title="Config loaded",Content=('"%s"  ·  %d settings'):format(name,n),Icon="check",Duration=3})end cfg.refresh()return true end function cfg.delete(name)if canFile then pcall(function()if delfile and isfile(file(name))then delfile(file(name))end end)else memory[name]=nil end if cfg.current==name then cfg.current=nil end if cfg.autoload()==name then cfg.setAutoload(nil,true)end notify({Title="Config deleted",Content=name,Icon="info",Duration=2})cfg.refresh()end function cfg.autoload()local a=prefs.autoConfig return type(a)=="table"and a[GAME_KEY]or nil end function cfg.setAutoload(name,quiet)prefs.autoConfig=type(prefs.autoConfig)=="table"and prefs.autoConfig or{}prefs.autoConfig[GAME_KEY]=name savePrefs()cfg.refresh()if not quiet then notify({Title=name and"Auto-load on"or"Auto-load off",Content=name and('"%s" will load by itself when you join this game.'):format(name)or"Nothing loads when you join.",Icon=name and"check"or"info",Duration=3,})end end cfg.words={new="New config",desc="Saves every setting for this game under a name.",placeholder="Config name",list="Saved configs",empty="No configs yet",emptyDesc="Name one above and press Save.",auto="Loads when you join this game.",}TAGS["Auto-load"],TAGS["Loaded"]=C.green,C.blue local function actButton(parent,order,iconName,text,style)local h=K.ctrlH local w=text and(textW(text,px(12),T.fontBold)+px(38))or h local b=new("TextButton",{LayoutOrder=order,Size=UDim2.fromOffset(w,h),AutoButtonColor=false,Text=""},parent)corner(b,px(9))local st=stroke(b,T.fieldLine)local icS=even(px(13))local ic=new("ImageLabel",{AnchorPoint=Vector2.new(text and 0 or 0.5,0.5),Position=text and UDim2.new(0,px(11),0.5,0)or UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=icon(iconName),},b)local lb=text and new("TextLabel",{Position=UDim2.fromOffset(px(28),0),Size=UDim2.new(1,-px(32),1,0),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(12),TextXAlignment=Enum.TextXAlignment.Left,Text=text,},b)local function paint(hot)local bg,ink,line,lineT if style=="primary"then bg,ink,line,lineT=hot and C.accent:Lerp(WHITE,0.15)or C.accent,onAccent(),C.accent,1 elseif style=="on"then bg,ink,line,lineT=hot and T.fieldHot or T.field,C.green,C.green,0.35 else bg,ink,line,lineT=hot and T.fieldHot or T.field,(style=="danger"and hot)and C.red or T.text,hot and T.fieldLineHot or T.fieldLine,0 end tween(b,0.15,{BackgroundColor3=bg})tween(st,0.15,{Color=line,Transparency=lineT})ic.ImageColor3=ink if lb then lb.TextColor3=ink end end paint(false)b.MouseEnter:Connect(function()paint(true)end)b.MouseLeave:Connect(function()paint(false)end)return b end function F.configPage(tabObj)local page=tabObj.page local function hlist(slot)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,px(6)),VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,},slot)end local gSave=tabObj:Group("Save")local _,s1=row(gSave,"Save current settings","Every setting on every page, plus UI scale, window opacity, blur, menu key and theme.")hlist(s1)local box=new("TextBox",{LayoutOrder=1,Size=UDim2.fromOffset(px(170),K.ctrlH),ClearTextOnFocus=false,BackgroundColor3=T.field,FontFace=T.font,TextSize=px(13),TextColor3=T.text,PlaceholderText="Config name",PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,},s1)corner(box,px(9))local boxStroke=stroke(box,T.fieldLine)new("UIPadding",{PaddingLeft=UDim.new(0,px(10)),PaddingRight=UDim.new(0,px(10))},box)box.Focused:Connect(function()tween(boxStroke,0.15,{Color=C.accent})end)box.FocusLost:Connect(function()tween(boxStroke,0.2,{Color=T.fieldLine})end)local saveB=actButton(s1,2,"save","Save","primary")local function doSave()local name=clean(box.Text)if name==""then notify({Title="Config",Content="Type a name first.",Icon="triangle-alert",Duration=3})return end local function go()if cfg.save(name)then box.Text=""end end if cfg.exists(name)then popup({Title="Replace config?",Content=('"%s" already exists. Replace it with your current settings?'):format(name),Buttons={{Title="Cancel"},{Title="Replace",Variant="Primary",Callback=go}},})else go()end end saveB.MouseButton1Click:Connect(doSave)box.FocusLost:Connect(function(enter)if enter then doSave()end end)local gAuto=tabObj:Group("Auto-load")local _,s2,_,autoDesc=row(gAuto,"Load a config when you join"," ")hlist(s2)local offB=actButton(s2,1,"x","Turn off","normal")offB.MouseButton1Click:Connect(function()cfg.setAutoload(nil)end)local gList=tabObj:Group("Saved configs")local capButton=gList.holder:FindFirstChild("Caption")local capLabel=capButton and capButton:FindFirstChildWhichIsA("TextLabel")local function rebuild()for _,c in ipairs(gList.card:GetChildren())do if c:IsA("Frame")then c:Destroy()end end gList.rows=0 local keep={}for _,it in ipairs(page.rows)do if it.g~=gList then table.insert(keep,it)end end page.rows=keep local auto=cfg.autoload()autoDesc.Text=auto and('On: "%s" loads by itself every time you join this game.'):format(auto)or"Off. Press Set auto-load on a config below to load it every time you join."autoDesc.TextColor3=auto and C.green or T.muted offB.Visible=auto~=nil local list=cfg.list()if capLabel then capLabel.Text=("SAVED CONFIGS (%d)"):format(#list)end if#list==0 then row(gList,"No configs yet","Type a name above and press Save.")return end for _,it in ipairs(list)do local name=it.name local isAuto=name==auto local tags={}if isAuto then table.insert(tags,"Auto-load")end if name==cfg.current then table.insert(tags,"Loaded")end local bits={it.ok and(it.count.." settings")or"can't read this file"}local w=when(it.savedAt)if w then table.insert(bits,"saved "..w)end if it.theme then table.insert(bits,it.theme.." theme")end local _,s=row(gList,name,table.concat(bits,"  ·  "),tags)hlist(s)local loadB=actButton(s,1,"folder-open","Load","primary")local autoB=actButton(s,2,isAuto and"check"or"star",isAuto and"Auto-load on"or"Set auto-load",isAuto and"on"or"normal")local overB=actButton(s,3,"save",nil,"icon")local delB=actButton(s,4,"trash-2",nil,"danger")loadB.MouseButton1Click:Connect(function()cfg.load(name)end)autoB.MouseButton1Click:Connect(function()cfg.setAutoload((not isAuto)and name or nil)end)overB.MouseButton1Click:Connect(function()popup({Title="Update config?",Content=('Replace "%s" with your current settings?'):format(name),Buttons={{Title="Cancel"},{Title="Update",Variant="Primary",Callback=function()cfg.save(name)end}},})end)delB.MouseButton1Click:Connect(function()popup({Title="Delete config?",Content=('Delete "%s"? This cannot be undone.'):format(name)..(isAuto and" Auto-load will be turned off."or""),Buttons={{Title="Cancel"},{Title="Delete",Variant="Primary",Callback=function()cfg.delete(name)end}},})end)end end cfg.refresh=rebuild local themeToken=0 onThemeChanged(function()themeToken+=1 local my=themeToken task.delay(0.4,function()if my==themeToken then rebuild()end end)end)rebuild()end F.config,F.canFile=cfg,canFile function F.autoload()local n=cfg.autoload()if n and cfg.exists(n)then cfg.load(n,true)end end function F.quickCard(body,order,CP)local card=new("Frame",{Name="QuickToggles",LayoutOrder=order,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.card,},body)corner(card,K.radius)stroke(card,T.cardLine)local inner=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},card)new("UIPadding",{PaddingTop=UDim.new(0,CP-px(2)),PaddingBottom=UDim.new(0,CP),PaddingLeft=UDim.new(0,CP),PaddingRight=UDim.new(0,CP)},inner)new("UIListLayout",{Padding=UDim.new(0,px(12)),SortOrder=Enum.SortOrder.LayoutOrder},inner)local head=new("Frame",{LayoutOrder=1,Size=UDim2.new(1,0,0,px(16)),BackgroundTransparency=1},inner)local s13=even(px(13))new("ImageLabel",{Size=UDim2.fromOffset(s13,s13),BackgroundTransparency=1,Image=ICON.pin,ImageColor3=T.muted},head)new("TextLabel",{Position=UDim2.fromOffset(s13+px(6),0),Size=UDim2.new(0.6,0,1,0),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text="QUICK TOGGLES",},head)local count=new("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.new(0.4,0,1,0),BackgroundTransparency=1,FontFace=T.font,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Right,Text="",},head)local empty=new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text=(UIS.KeyboardEnabled and"Right-click"or"Long-press").." any setting and choose Pin to Home to keep it here.",},inner)local grid=new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},inner)local gap,cellH=px(10),px(60)new("UIGridLayout",{CellSize=UDim2.new(1/3,-math.ceil(gap*2/3),0,cellH),CellPadding=UDim2.fromOffset(gap,gap),SortOrder=Enum.SortOrder.LayoutOrder,},grid)local tiles={}local function tile(e,i)local b=new("TextButton",{Name=e.title,LayoutOrder=i,BackgroundColor3=T.field,AutoButtonColor=false,Text=""},grid)corner(b,px(10))local st=stroke(b,T.fieldLine)local icS=even(px(15))local ic=new("ImageLabel",{Position=UDim2.fromOffset(px(12),px(11)),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=e.sec.pillIcon.Image,ImageColor3=T.subtext,},b)local unS=even(px(22))new("TextLabel",{Position=UDim2.new(0,px(12),1,-px(26)),Size=UDim2.new(1,-(px(24)+unS),0,px(16)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(13),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=e.title,},b)local un=new("ImageButton",{Name="Unpin",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(6),1,-px(6)),Size=UDim2.fromOffset(unS,unS),BackgroundColor3=T.fieldHot,BackgroundTransparency=HOVER and 1 or 0.3,Image="",AutoButtonColor=false,ZIndex=3,},b)corner(un,px(6))local unIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(12)),even(px(12))),BackgroundTransparency=1,Image=ICON["pin-off"],ImageColor3=T.muted,ImageTransparency=HOVER and 1 or 0,ZIndex=4,},un)local overTile,overUn=false,false local function showUn()if not HOVER then return end local on=overTile or overUn tween(un,0.15,{BackgroundTransparency=on and 0.3 or 1})tween(unIcon,0.15,{ImageTransparency=on and 0 or 1,ImageColor3=overUn and C.red or T.muted})end b.MouseEnter:Connect(function()overTile=true showUn()end)b.MouseLeave:Connect(function()overTile=false task.defer(showUn)end)un.MouseEnter:Connect(function()overUn=true showUn()end)un.MouseLeave:Connect(function()overUn=false task.defer(showUn)end)un.MouseButton1Click:Connect(function()if CTRL.swallow then return end F.setPinned(e,false)end)local paint if e.kind=="toggle"then local sw,sh=even(px(30)),even(px(17))local track=new("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-px(10),0,px(10)),Size=UDim2.fromOffset(sw,sh),BackgroundColor3=T.track,},b)new("UICorner",{CornerRadius=UDim.new(1,0)},track)local ks=sh-px(4)local knob=new("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(2),0.5,0),Size=UDim2.fromOffset(ks,ks),BackgroundColor3=Color3.fromRGB(196,202,216),},track)new("UICorner",{CornerRadius=UDim.new(1,0)},knob)paint=function(t)local on=e.obj.Value tween(track,t,{BackgroundColor3=on and C.accent or T.track})tween(knob,t,{AnchorPoint=Vector2.new(on and 1 or 0,0.5),Position=UDim2.new(on and 1 or 0,on and-px(2)or px(2),0.5,0),BackgroundColor3=on and knobOn()or Color3.fromRGB(196,202,216),})tween(st,t,{Color=on and C.accent or T.fieldLine,Transparency=on and 0.4 or 0})tween(ic,t,{ImageColor3=on and C.accent or T.subtext})end else local right=new("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-px(10),0,px(9)),Size=UDim2.new(0.6,0,0,px(16)),BackgroundTransparency=1,FontFace=T.mono,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Right,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},b)paint=function()if e.kind=="button"then right.Text="RUN"else right.Text=e.obj.Display and e.obj.Display()or""end end end b.MouseEnter:Connect(function()tween(b,0.12,{BackgroundColor3=T.fieldHot})end)b.MouseLeave:Connect(function()tween(b,0.18,{BackgroundColor3=T.field})end)b.MouseButton1Click:Connect(function()if CTRL.swallow then return end if e.kind=="toggle"then e.obj:Set(not e.obj.Value)elseif e.kind=="button"then e.obj.Run()elseif jumpTo then jumpTo(e)end end)tiles[e]={paint=paint,frame=b}quickTiles[b]=e end local function rebuild()for b in pairs(quickTiles)do if b:IsDescendantOf(grid)then quickTiles[b]=nil end end for _,c in ipairs(grid:GetChildren())do if c:IsA("GuiObject")then c:Destroy()end end table.clear(tiles)local list=F.pinned()for i,e in ipairs(list)do tile(e,i)end for _,t in pairs(tiles)do t.paint(0)end empty.Visible,grid.Visible=#list==0,#list>0 count.Text=#list>0 and(#list.." pinned")or""end table.insert(pinHooks,rebuild)CTRL.onChange(function(e)if e==nil then for _,t in pairs(tiles)do t.paint(0.2)end elseif tiles[e]then tiles[e].paint(0.2)end end)onThemeChanged(function()for _,t in pairs(tiles)do t.paint(0.3)end end)rebuild()return rebuild end return F end)()do(function()local SUG={max=7,itemH=even(px(50)),w=px(380),head=px(28),foot=px(32)}local sug local recent={}local suppressSearch=false local function esc(s)return(s:gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"))end local function hex(c)return("#%02X%02X%02X"):format(math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))end local function highlight(title,q)local i,j=title:lower():find(q,1,true)if q==""or not i then return esc(title)end return esc(title:sub(1,i-1))..('<font color="%s">'):format(hex(C.accent))..esc(title:sub(i,j)).."</font>"..esc(title:sub(j+1))end local function pageItem(tab)return{kind="Page",title=tab.name,desc="",path="Page",icon=tab.icon,tab=tab}end local function buildIndex()local out={}for _,tab in ipairs(tabOrder)do table.insert(out,pageItem(tab))local multi=#tab.secOrder>=2 for _,sec in ipairs(tab.secOrder)do if multi then table.insert(out,{kind="Section",title=sec.name,desc="",path=tab.name,icon=sec.pillIcon.Image,tab=tab,sec=sec})end for _,it in ipairs(sec.page.rows)do if it.r.Parent and it.title and it.title~=""then table.insert(out,{kind="Setting",title=it.title,desc=it.desc or"",icon=sec.pillIcon.Image,path=multi and(tab.name.."  ›  "..sec.name)or tab.name,tab=tab,sec=sec,target=it.r,group=it.g,})end end end end return out end local function fuzzy(t:string,q:string):boolean q=q:gsub("%s+","")if#q<3 then return false end local j=1 for k=1,#t do if t:sub(k,k)==q:sub(j,j)then j+=1 if j>#q then return true end end end return false end local function score(item,q)local t=item.title:lower()local s=0 if t==q then s=1000 else local i=t:find(q,1,true)if i==1 then s=700 elseif i then s=t:sub(i-1,i-1):match("[%s%p]")and 500 or 350 else local hay=t.." "..item.desc:lower().." "..item.path:lower()local all=true for w in q:gmatch("%S+")do if not hay:find(w,1,true)then all=false break end end if all then s=200 elseif fuzzy(t,q)then s=80 end end end if s==0 then return 0 end if item.kind=="Page"then s+=30 elseif item.kind=="Section"then s+=15 end return s-#t*0.5 end local function results(q)local out={}if q==""then for _,it in ipairs(recent)do if tabs[it.tab.name]==it.tab and(not it.target or it.target.Parent)then table.insert(out,it)end end if#out>0 then return out,"Recent"end for _,tab in ipairs(tabOrder)do table.insert(out,pageItem(tab))if#out>=SUG.max then break end end return out,"Jump to"end local scored={}for _,item in ipairs(buildIndex())do local s=score(item,q)if s>0 then item.score=s table.insert(scored,item)end end table.sort(scored,function(a,b)return a.score>b.score end)for i=1,math.min(#scored,SUG.max)do out[i]=scored[i]end return out,#scored>0 and(#scored==1 and"1 result"or(#scored.." results"))or nil end local function pushRecent(item)for i=#recent,1,-1 do local r=recent[i]if r.kind==item.kind and r.tab==item.tab and r.sec==item.sec and r.target==item.target then table.remove(recent,i)end end table.insert(recent,1,item)if#recent>5 then table.remove(recent)end end local function reveal(target,page)RunService.Heartbeat:Wait()RunService.Heartbeat:Wait()if not target.Parent or not page or currentPage~=page then return end local s=pop.Scale local scroll=page.scroll local y=(target.AbsolutePosition.Y-scroll.AbsolutePosition.Y)/s+scroll.CanvasPosition.Y local maxY=math.max(0,(scroll.AbsoluteCanvasSize.Y-scroll.AbsoluteWindowSize.Y)/s)tween(scroll,0.55,{CanvasPosition=Vector2.new(0,math.clamp(y-px(60),0,maxY))})local flash=new("Frame",{Name="Flash",Position=UDim2.fromOffset(px(2),px(2)),Size=UDim2.new(1,-px(4),1,-px(4)),BackgroundColor3=C.accent,BackgroundTransparency=1,ZIndex=0,},target)corner(flash,K.radius-px(2))local fs=stroke(flash,C.accent,1)tween(flash,0.3,{BackgroundTransparency=0.86})tween(fs,0.3,{Transparency=0.25})task.delay(1.1,function()tween(flash,0.7,{BackgroundTransparency=1})local tw=tween(fs,0.7,{Transparency=1})tw.Completed:Once(function()flash:Destroy()end)end)end local function paintSel()if not sug then return end for i,it in ipairs(sug.items)do local on=i==sug.sel tween(it.btn,0.15,{BackgroundTransparency=on and 0 or 1})tween(it.icon,0.15,{ImageColor3=on and C.accent or T.subtext})tween(it.arrow,0.2,{ImageTransparency=on and 0 or 1,Position=UDim2.new(1,on and-px(12)or-px(18),0.5,0)})tween(it.kind,0.15,{TextTransparency=on and 1 or 0})end end local pick local function renderSuggest()if not sug then return end local q=searchBox.Text:lower():gsub("^%s+",""):gsub("%s+$","")local list,heading=results(q)sug.results,sug.sel,sug.items=list,1,{}for _,c in ipairs(sug.list:GetChildren())do if c:IsA("GuiObject")then c:Destroy()end end local h=px(6)*2 if heading then local head=new("TextLabel",{LayoutOrder=0,Size=UDim2.new(1,0,0,SUG.head),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text=heading:upper(),},sug.list)new("UIPadding",{PaddingLeft=UDim.new(0,px(10))},head)h+=SUG.head end if#list==0 then new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,px(64)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.muted,TextWrapped=true,Text=('No results for "%s"'):format(q),},sug.list)h+=px(64)end local boxS,icS=even(px(32)),even(px(15))local tx=px(9)+boxS+px(12)for i,item in ipairs(list)do local btn=new("TextButton",{Name=item.title,LayoutOrder=i,Size=UDim2.new(1,0,0,SUG.itemH),BackgroundColor3=T.rowActive,BackgroundTransparency=1,AutoButtonColor=false,Text="",},sug.list)corner(btn,px(9))local box=new("Frame",{Position=UDim2.fromOffset(px(9),math.floor((SUG.itemH-boxS)/2)),Size=UDim2.fromOffset(boxS,boxS),BackgroundColor3=T.field,},btn)corner(box,px(8))stroke(box,T.fieldLine)local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=item.icon or ICON.circle,ImageColor3=T.subtext,},box)new("TextLabel",{Position=UDim2.fromOffset(tx,px(8)),Size=UDim2.new(1,-(tx+px(76)),0,px(18)),BackgroundTransparency=1,RichText=true,FontFace=T.fontSemi,TextSize=px(14),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=highlight(item.title,q),},btn)local sub=item.kind=="Setting"and item.path or(item.kind=="Section"and(item.path.."  ›  section")or"Open page")if item.kind=="Setting"and item.desc~=""then sub=sub.."  ·  "..item.desc end new("TextLabel",{Position=UDim2.fromOffset(tx,px(27)),Size=UDim2.new(1,-(tx+px(36)),0,px(15)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=sub,},btn)local kind=new("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-px(12),0,px(9)),Size=UDim2.fromOffset(px(60),px(16)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(10),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Right,Text=item.kind:upper(),},btn)local arrow=new("ImageLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(18),0.5,0),Size=UDim2.fromOffset(icS,icS),BackgroundTransparency=1,Image=ICON["chevron-right"],ImageColor3=C.accent,ImageTransparency=1,},btn)local idx=i btn.MouseEnter:Connect(function()if sug and sug.sel~=idx then sug.sel=idx paintSel()end end)btn.MouseButton1Click:Connect(function()pick(item)end)sug.items[i]={btn=btn,icon=ic,arrow=arrow,kind=kind}h+=SUG.itemH end local foot=new("Frame",{LayoutOrder=100,Size=UDim2.new(1,0,0,SUG.foot),BackgroundTransparency=1},sug.list)new("Frame",{Position=UDim2.fromOffset(px(4),px(4)),Size=UDim2.new(1,-px(8),0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0},foot)new("TextLabel",{Position=UDim2.fromOffset(px(10),px(5)),Size=UDim2.new(1,-px(20),1,-px(5)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text=UIS.KeyboardEnabled and"Up / Down to move   ·   Enter to open   ·   Esc to close"or"Tap a result to open it",},foot)h+=SUG.foot if sug.fresh then sug.fresh=false sug.frame.Size=UDim2.fromOffset(SUG.w,h)else tween(sug.frame,0.3,{Size=UDim2.fromOffset(SUG.w,h)})end paintSel()end local function closeSuggestPanel()local s=sug sug=nil if not s then return end tween(s.stroke,0.15,{Transparency=1})tween(s.frame,0.18,{Position=s.rest-UDim2.fromOffset(0,px(6))})local tw=tween(s.frame,0.15,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()s.frame:Destroy()end)end local function openSuggest()if sug then renderSuggest()return end closePopup()local pos,size=inWindow(search)local rest=UDim2.fromOffset(pos.X+size.X,pos.Y+size.Y+px(8))local frame=new("CanvasGroup",{Name="SearchSuggest",AnchorPoint=Vector2.new(1,0),Position=rest-UDim2.fromOffset(0,px(6)),Size=UDim2.fromOffset(SUG.w,px(100)),BackgroundColor3=T.popup,GroupTransparency=1,},overlay)corner(frame,px(12))local st=stroke(frame,T.fieldLineHot,1)local list=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},frame)new("UIPadding",{PaddingTop=UDim.new(0,px(6)),PaddingBottom=UDim.new(0,px(6)),PaddingLeft=UDim.new(0,px(6)),PaddingRight=UDim.new(0,px(6)),},list)new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder},list)sug={frame=frame,stroke=st,rest=rest,list=list,items={},results={},sel=1,fresh=true}openPopup={list=frame,field=search,close=closeSuggestPanel}renderSuggest()tween(frame,0.32,{Position=rest})tween(frame,0.22,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(st,0.22,{Transparency=0})end local function hideSuggest()if sug and openPopup and openPopup.list==sug.frame then closePopup()else closeSuggestPanel()end end pick=function(item)pushRecent(item)hideSuggest()suppressSearch=true searchBox.Text=""suppressSearch=false if searchBox:IsFocused()then searchBox:ReleaseFocus()end if tabs[item.tab.name]~=item.tab then return end selectTab(item.tab.name)if item.sec then selectSection(item.tab.name,item.sec.name)end if item.group and item.group.expand then item.group.expand()end if item.target then local page=item.sec and item.sec.page task.spawn(reveal,item.target,page)end end jumpTo=function(e)pick({kind="Setting",title=e.title,desc="",path=e.tab.name,icon=e.sec.pillIcon.Image,tab=e.tab,sec=e.sec,target=e.row,group=e.g,})end STATE.connect(searchBox.Focused,function()if not suppressSearch then openSuggest()end end)STATE.connect(searchBox:GetPropertyChangedSignal("Text"),function()if suppressSearch then return end if searchBox:IsFocused()or searchBox.Text~=""then openSuggest()end end)STATE.connect(searchBox.FocusLost,function(enter)if enter then local item=sug and sug.results[sug.sel]if item then pick(item)else hideSuggest()end elseif UIS:IsKeyDown(Enum.KeyCode.Escape)then hideSuggest()end end)STATE.connect(UIS.InputBegan,function(input,processed)if not mine()then return end if sug and searchBox:IsFocused()then if input.KeyCode==Enum.KeyCode.Down then sug.sel=math.min(#sug.results,sug.sel+1)paintSel()elseif input.KeyCode==Enum.KeyCode.Up then sug.sel=math.max(1,sug.sel-1)paintSel()end return end if processed or not shown or capture.active then return end if input.KeyCode==Enum.KeyCode.F and(UIS:IsKeyDown(Enum.KeyCode.LeftControl)or UIS:IsKeyDown(Enum.KeyCode.RightControl))then task.defer(function()searchBox:CaptureFocus()end)end end)end)()end local function themePicker(g)g.rows+=1 local holder=new("Frame",{Name="Themes",LayoutOrder=g.rows,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,},g.card)if g.rows>1 then new("Frame",{Name="Line",Position=UDim2.fromOffset(K.rowPad,0),Size=UDim2.new(1,-K.rowPad*2,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},holder)end local inner=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},holder)new("UIPadding",{PaddingTop=UDim.new(0,K.vPad),PaddingBottom=UDim.new(0,px(16)),PaddingLeft=UDim.new(0,K.rowPad),PaddingRight=UDim.new(0,K.rowPad),},inner)new("UIListLayout",{Padding=UDim.new(0,px(3)),SortOrder=Enum.SortOrder.LayoutOrder},inner)new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,K.title+px(4)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=K.title,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text="Theme",},inner)new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=K.desc,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text="Pick a colour theme for the menu. Your choice is remembered next time.",},inner)local gridWrap=new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},inner)new("UIPadding",{PaddingTop=UDim.new(0,px(10))},gridWrap)local grid=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},gridWrap)local gap,cellH=px(10),px(96)new("UIGridLayout",{CellSize=UDim2.new(1/3,-math.ceil(gap*2/3),0,cellH),CellPadding=UDim2.fromOffset(gap,gap),SortOrder=Enum.SortOrder.LayoutOrder,},grid)local tiles={}local function paintTiles(t)for name,tl in pairs(tiles)do local on=name==currentTheme local p=THEMES[name].palette tween(tl.stroke,t,{Color=on and p.accent or(tl.hover and p.fieldLineHot or p.border),Thickness=on and 2 or 1})tween(tl.check,t,{BackgroundTransparency=on and 0 or 1})tween(tl.checkIcon,t,{ImageTransparency=on and 0 or 1})end end local pv,labelH=px(7),px(26)local function buildTile(name,i)if tiles[name]and tiles[name].frame then tiles[name].frame:Destroy()end local p=THEMES[name].palette local tile=new("TextButton",{Name=name,LayoutOrder=i,BackgroundColor3=p.bg,AutoButtonColor=false,Text=""},grid)tile:SetAttribute("MonoNoTheme",true)corner(tile,px(10))local st=stroke(tile,p.border)local sideF=new("Frame",{Position=UDim2.fromOffset(pv,pv),Size=UDim2.new(0.26,0,1,-(pv+labelH)),BackgroundColor3=p.side,},tile)corner(sideF,px(5))stroke(sideF,p.divider)for j=1,3 do local bar=new("Frame",{Position=UDim2.new(0,px(5),0,px(6)+(j-1)*px(9)),Size=UDim2.new(1,-px(10),0,px(5)),BackgroundColor3=j==1 and p.accent or p.track,BorderSizePixel=0,},sideF)corner(bar,px(2))end local mainF=new("Frame",{Position=UDim2.new(0.26,pv+px(5),0,pv),Size=UDim2.new(0.74,-(pv*2+px(5)),1,-(pv+labelH)),BackgroundColor3=p.card,},tile)corner(mainF,px(5))stroke(mainF,p.cardLine)for j,w in ipairs({0.6,0.38})do local line=new("Frame",{Position=UDim2.fromOffset(px(7),px(7)+(j-1)*px(9)),Size=UDim2.new(w,0,0,px(5)),BackgroundColor3=j==1 and p.fieldLineHot or p.fieldLine,BorderSizePixel=0,},mainF)corner(line,px(2))end local sw=new("Frame",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(6),1,-px(6)),Size=UDim2.fromOffset(px(20),px(11)),BackgroundColor3=p.accent,},mainF)new("UICorner",{CornerRadius=UDim.new(1,0)},sw)local kn=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(2),0.5,0),Size=UDim2.fromOffset(px(7),px(7)),BackgroundColor3=lum(p.accent)>0.8 and p.bg or WHITE,},sw)new("UICorner",{CornerRadius=UDim.new(1,0)},kn)new("TextLabel",{Position=UDim2.new(0,px(10),1,-labelH),Size=UDim2.new(1,-px(36),0,labelH-px(2)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(13),TextColor3=p.text,TextXAlignment=Enum.TextXAlignment.Left,Text=name,},tile)local checkS=even(px(16))local check=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(9),1,-math.floor(labelH/2)-px(1)),Size=UDim2.fromOffset(checkS,checkS),BackgroundColor3=p.accent,BackgroundTransparency=1,},tile)new("UICorner",{CornerRadius=UDim.new(1,0)},check)local checkIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(even(px(10)),even(px(10))),BackgroundTransparency=1,Image=ICON.check,ImageColor3=p.bg,ImageTransparency=1,},check)local tl={stroke=st,check=check,checkIcon=checkIcon,frame=tile}tiles[name]=tl tile.MouseEnter:Connect(function()tl.hover=true paintTiles(0.18)end)tile.MouseLeave:Connect(function()tl.hover=false paintTiles(0.22)end)tile.MouseButton1Click:Connect(function()applyTheme(name,true,true)end)end for i,name in ipairs(THEME_ORDER)do buildTile(name,i)end paintTiles(0)onThemeChanged(function()paintTiles(0.35)end)table.insert(g.page.rows,{r=holder,g=g,title="Theme",desc="Colour theme, appearance, colors"})local cr=new("Frame",{LayoutOrder=4,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},inner)new("UIPadding",{PaddingTop=UDim.new(0,px(14))},cr)new("UIListLayout",{Padding=UDim.new(0,px(4)),SortOrder=Enum.SortOrder.LayoutOrder},cr)new("TextLabel",{LayoutOrder=1,Size=UDim2.new(1,0,0,K.title+px(4)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=K.title,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text="Custom accent",},cr)new("TextLabel",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=K.desc,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text="Drag the colour bar or type a hex code. It becomes the Custom theme.",},cr)local barRow=new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,px(40)),BackgroundTransparency=1},cr)local hexW=px(118)local hue=new("TextButton",{Name="Hue",AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(8),0.5,0),Size=UDim2.new(1,-(hexW+px(24)),0,even(px(14))),BackgroundColor3=WHITE,AutoButtonColor=false,Text="",},barRow)hue:SetAttribute("MonoNoTheme",true)new("UICorner",{CornerRadius=UDim.new(1,0)},hue)do local keys={}for k=0,6 do table.insert(keys,ColorSequenceKeypoint.new(k/6,Color3.fromHSV((k%6)/6,0.62,1)))end new("UIGradient",{Color=ColorSequence.new(keys)},hue)end local knobS=even(px(22))local hueKnob=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0,0.5),Size=UDim2.fromOffset(knobS,knobS),BackgroundColor3=THEMES.Custom.palette.accent,},hue)new("UICorner",{CornerRadius=UDim.new(1,0)},hueKnob)stroke(hueKnob,WHITE,0,2)local hexF=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.fromScale(1,0.5),Size=UDim2.fromOffset(hexW,even(px(32))),BackgroundColor3=T.field,},barRow)corner(hexF,px(8))local hexStroke=stroke(hexF,T.fieldLine)local swS=even(px(14))local swatch=new("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(10),0.5,0),Size=UDim2.fromOffset(swS,swS),BackgroundColor3=THEMES.Custom.palette.accent,},hexF)swatch:SetAttribute("MonoNoTheme",true)new("UICorner",{CornerRadius=UDim.new(1,0)},swatch)local hexBox=new("TextBox",{Position=UDim2.fromOffset(px(10)+swS+px(8),0),Size=UDim2.new(1,-(px(18)+swS+px(8)),1,0),BackgroundTransparency=1,ClearTextOnFocus=false,FontFace=T.mono,TextSize=px(12),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=HEX.from(THEMES.Custom.palette.accent),PlaceholderText="#RRGGBB",PlaceholderColor3=T.muted,},hexF)local function preview(c)local h=c:ToHSV()hueKnob.Position=UDim2.fromScale(h,0.5)hueKnob.BackgroundColor3,swatch.BackgroundColor3=c,c if not hexBox:IsFocused()then hexBox.Text=HEX.from(c)end end preview(THEMES.Custom.palette.accent)local function commit(c)local base=(currentTheme=="Custom"and THEMES.Custom or THEMES[currentTheme]).palette.bg addTheme("Custom",base,c)prefs.custom={base=HEX.from(base),accent=HEX.from(c)}applyTheme("Custom",true,true,true)buildTile("Custom",table.find(THEME_ORDER,"Custom")or#THEME_ORDER)paintTiles(0.2)end local dragging=false local current=THEMES.Custom.palette.accent local function fromX(x)local a=math.clamp((x-hue.AbsolutePosition.X)/math.max(hue.AbsoluteSize.X,1),0,0.999)current=Color3.fromHSV(a,0.62,1)preview(current)end hue.InputBegan:Connect(function(input)if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end dragging=true tween(hueKnob,0.15,{Size=UDim2.fromOffset(knobS+px(4),knobS+px(4))})fromX(input.Position.X)end)STATE.connect(UIS.InputChanged,function(input)if dragging and(input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)then fromX(input.Position.X)end end)STATE.connect(UIS.InputEnded,function(input)if not dragging then return end if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end dragging=false tween(hueKnob,0.25,{Size=UDim2.fromOffset(knobS,knobS)},Enum.EasingStyle.Back)commit(current)end)hexBox.Focused:Connect(function()tween(hexStroke,0.15,{Color=C.accent})end)hexBox.FocusLost:Connect(function()tween(hexStroke,0.2,{Color=T.fieldLine})local c=HEX.to(hexBox.Text)if c then current=c preview(c)commit(c)else hexBox.Text=HEX.from(current)end end)onThemeChanged(function()if dragging then return end current=THEMES.Custom.palette.accent preview(current)buildTile("Custom",table.find(THEME_ORDER,"Custom")or#THEME_ORDER)paintTiles(0)end)return{}end local buildHome do(function()local HIST=24 local metrics={fps=0,ping=0,fpsHist={},pingHist={}}local metricHooks={}do local frames,last=0,os.clock()STATE.connect(RunService.RenderStepped,function()frames+=1 end)local function push(list,v)table.insert(list,v)if#list>HIST then table.remove(list,1)end end task.spawn(function()while STATE.alive()and mine()do task.wait(0.5)local now=os.clock()metrics.fps=frames/math.max(now-last,1e-3)frames,last=0,now local ok,p=pcall(function()return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()end)if not ok or type(p)~="number"then ok,p=pcall(function()return LP:GetNetworkPing()*1000 end)end metrics.ping=(ok and type(p)=="number")and p or 0 push(metrics.fpsHist,metrics.fps)push(metrics.pingHist,metrics.ping)for _,fn in ipairs(metricHooks)do pcall(fn)end end end)end local function fmtSession(s)s=math.floor(s)if s<60 then return s.."s"end if s<3600 then return("%dm %ds"):format(s//60,s%60)end return("%dh %dm"):format(s//3600,(s%3600)//60)end local function httpRequest(opts)local req=(syn and syn.request)or(http and http.request)or http_request or request if not req then return nil end local ok,res=pcall(req,opts)return(ok and type(res)=="table")and res.Body or nil end local function serverList(sortOrder)local url=("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100&excludeFullGames=true"):format(game.PlaceId,sortOrder)local ok,res=pcall(function()return game:HttpGet(url)end)if not ok or type(res)~="string"then res=httpRequest({Url=url,Method="GET"})ok=type(res)=="string"end if not ok or type(res)~="string"then return nil end local ok2,data=pcall(HttpService.JSONDecode,HttpService,res)return(ok2 and type(data)=="table")and data.data or nil end local function joinServer(jobId)notify({Title="Teleporting",Content="Joining the server...",Icon="refresh-cw",Duration=4})local ok,err=pcall(function()TeleportService:TeleportToPlaceInstance(game.PlaceId,jobId,LP)end)if not ok then notify({Title="Teleport failed",Content=tostring(err),Icon="triangle-alert",Duration=5})end end local avatarCache={}local function headshots(tokens,onImage)if#tokens==0 then return end task.spawn(function()local body={}for i,tk in ipairs(tokens)do body[i]={requestId=tostring(i),token=tk,type="AvatarHeadShot",size="60x60",format="png",isCircular=false}end local res=httpRequest({Url="https://thumbnails.roblox.com/v1/batch",Method="POST",Headers={["Content-Type"]="application/json"},Body=HttpService:JSONEncode(body),})local ok,data=pcall(HttpService.JSONDecode,HttpService,res or"")if not ok or type(data)~="table"or type(data.data)~="table"then return end local getAsset=getcustomasset or getsynasset for _,item in ipairs(data.data)do local i=tonumber(item.requestId)local uid,url=tonumber(item.targetId),item.imageUrl if i and uid and uid>0 then onImage(i,("rbxthumb://type=AvatarHeadShot&id=%d&w=60&h=60"):format(uid))elseif i and getAsset and writefile and type(url)=="string"and url~=""then task.spawn(function()if avatarCache[url]then onImage(i,avatarCache[url])return end local okGet,bytes=pcall(function()return game:HttpGet(url)end)if not okGet or type(bytes)~="string"or#bytes<64 then return end local path="MonoUI/avatars/"..url:gsub("[^%w]",""):sub(-40)..".png"pcall(function()if not isfolder("MonoUI")then makefolder("MonoUI")end if not isfolder("MonoUI/avatars")then makefolder("MonoUI/avatars")end end)if not pcall(writefile,path,bytes)then return end local okA,asset=pcall(getAsset,path)if okA and asset then avatarCache[url]=asset onImage(i,asset)end end)end end end)end local function serverPreview(s)return function(box)new("UIListLayout",{Padding=UDim.new(0,px(10)),SortOrder=Enum.SortOrder.LayoutOrder},box)local playing,maxP=tonumber(s.playing)or 0,tonumber(s.maxPlayers)or 0 local chips=new("Frame",{LayoutOrder=1,Size=UDim2.new(1,0,0,even(px(28))),BackgroundTransparency=1},box)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(6)),SortOrder=Enum.SortOrder.LayoutOrder,},chips)local function chip(order,iconName,text,color)local h=even(px(28))local c=new("Frame",{LayoutOrder=order,Size=UDim2.fromOffset(px(28)+textW(text,px(12),T.fontSemi)+px(10),h),BackgroundColor3=T.field,},chips)corner(c,px(8))stroke(c,T.fieldLine)local s13=even(px(13))new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(9),0.5,0),Size=UDim2.fromOffset(s13,s13),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=color or T.subtext,},c)new("TextLabel",{Position=UDim2.fromOffset(px(28),0),Size=UDim2.new(1,-px(28),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=text,},c)end chip(1,"users",("%d / %d players"):format(playing,maxP),C.accent)local ping=tonumber(s.ping)if ping then chip(2,"wifi",("%d ms"):format(ping),ping<=90 and C.green or(ping<=180 and C.amber or C.red))end local fps=tonumber(s.fps)if fps then chip(3,"gauge",("%d fps"):format(math.floor(fps+0.5)),fps>=50 and C.green or(fps>=30 and C.amber or C.red))end local bar=new("Frame",{LayoutOrder=2,Size=UDim2.new(1,0,0,even(px(6))),BackgroundColor3=T.track,BorderSizePixel=0},box)new("UICorner",{CornerRadius=UDim.new(1,0)},bar)local fill=new("Frame",{Size=UDim2.fromScale(0,1),BackgroundColor3=C.accent,BorderSizePixel=0},bar)new("UICorner",{CornerRadius=UDim.new(1,0)},fill)task.delay(0.15,function()tween(fill,0.6,{Size=UDim2.fromScale(maxP>0 and playing/maxP or 0,1)})end)local tokens=type(s.playerTokens)=="table"and s.playerTokens or{}if#tokens==0 then if playing>0 then new("TextLabel",{LayoutOrder=3,Size=UDim2.new(1,0,0,px(16)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text="Player pictures aren't available for this server.",},box)end return end new("TextLabel",{LayoutOrder=3,Size=UDim2.new(1,0,0,px(14)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text="IN THIS SERVER",},box)local faces=new("Frame",{LayoutOrder=4,Size=UDim2.new(1,0,0,even(px(38))),BackgroundTransparency=1},box)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,-px(9)),SortOrder=Enum.SortOrder.LayoutOrder,},faces)local MAX=8 local fs=even(px(38))local imgs={}for i=1,math.min(#tokens,MAX)do local ring=new("Frame",{LayoutOrder=i,Size=UDim2.fromOffset(fs,fs),BackgroundColor3=T.field,ZIndex=MAX-i+2},faces)new("UICorner",{CornerRadius=UDim.new(1,0)},ring)stroke(ring,T.popup,0,2)local ph=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(0.5,0.5),BackgroundTransparency=1,Image=ICON.user,ImageColor3=T.muted,ZIndex=MAX-i+2,},ring)local img=new("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image="",ImageTransparency=1,ZIndex=MAX-i+3,},ring)new("UICorner",{CornerRadius=UDim.new(1,0)},img)imgs[i]={img=img,ph=ph}local sc=new("UIScale",{Scale=0.6},ring)task.delay(0.04*i,function()tween(sc,0.4,{Scale=1},Enum.EasingStyle.Back)end)end local more=math.max(playing,#tokens)-math.min(#tokens,MAX)if more>0 then local ring=new("Frame",{LayoutOrder=MAX+1,Size=UDim2.fromOffset(fs,fs),BackgroundColor3=T.fieldHot,ZIndex=1},faces)new("UICorner",{CornerRadius=UDim.new(1,0)},ring)stroke(ring,T.popup,0,2)new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(12),TextColor3=T.subtext,Text="+"..more,ZIndex=1,},ring)end local first={}for i=1,math.min(#tokens,MAX)do first[i]=tokens[i]end headshots(first,function(i,image)local f=imgs[i]if not f or not f.img.Parent then return end f.img.Image=image tween(f.img,0.35,{ImageTransparency=0})tween(f.ph,0.2,{ImageTransparency=1})end)end end local function offerServers(kind,list,i)local s=list[i]if not s then notify({Title=kind=="lowest"and"Lowest server"or"Server hop",Content="No more servers to show.",Icon="info",Duration=3})return end local buttons={{Title="Cancel"}}if list[i+1]then table.insert(buttons,{Title=kind=="lowest"and"Next lowest"or"Another",Callback=function()offerServers(kind,list,i+1)end})end table.insert(buttons,{Title="Join",Variant="Primary",Callback=function()joinServer(s.id)end})popup({Title=kind=="lowest"and"Join the emptiest server?"or"Hop to this server?",Content=kind=="lowest"and"The public server with the fewest players right now."or"A random public server with free slots.",Build=serverPreview(s),Buttons=buttons,})end local function candidates(servers)local out={}for _,s in ipairs(servers)do if s.id~=game.JobId and tonumber(s.playing)and tonumber(s.maxPlayers)and s.playing<s.maxPlayers then table.insert(out,s)end end return out end local ACTIONS={rejoin=function()popup({Title="Rejoin this server?",Content=#Players:GetPlayers()<=1 and"You're alone here, so you'll join a fresh server of this game."or"You'll leave and come straight back into this same server.",Buttons={{Title="Cancel"},{Title="Rejoin",Variant="Primary",Callback=function()notify({Title="Rejoining",Content="Teleporting back...",Icon="refresh-cw",Duration=4})local ok,err=pcall(function()if#Players:GetPlayers()<=1 then TeleportService:Teleport(game.PlaceId,LP)else TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP)end end)if not ok then notify({Title="Teleport failed",Content=tostring(err),Icon="triangle-alert",Duration=5})end end},},})end,hop=function()local servers=serverList("Desc")if not servers then notify({Title="Server hop",Content="Could not load the server list.",Icon="triangle-alert"})return end local list=candidates(servers)if#list==0 then notify({Title="Server hop",Content="No other open servers found.",Icon="triangle-alert"})return end for k=#list,2,-1 do local j=math.random(1,k)list[k],list[j]=list[j],list[k]end offerServers("hop",list,1)end,lowest=function()local servers=serverList("Asc")if not servers then notify({Title="Lowest server",Content="Could not load the server list.",Icon="triangle-alert"})return end local list=candidates(servers)if#list==0 then notify({Title="Lowest server",Content="No other servers found.",Icon="triangle-alert"})return end table.sort(list,function(a,b)return a.playing<b.playing end)offerServers("lowest",list,1)end,jobid=function()local set=setclipboard or toclipboard or(Clipboard and Clipboard.set)if set then set(game.JobId)notify({Title="Job ID copied",Content=game.JobId,Icon="check",Duration=3})else notify({Title="Job ID",Content=game.JobId.."\n(clipboard not supported here)",Icon="info",Duration=6})end end,}function buildHome(page,o)o=o or{}local body=page.body local CP=px(20)local n=0 local function homeVisible()return shown and currentPage==page end local function card(h,name)n+=1 local c=new("Frame",{Name=name,LayoutOrder=n,Size=UDim2.new(1,0,0,h),BackgroundColor3=T.card},body)corner(c,K.radius)stroke(c,T.cardLine)return c end local function caps(parent,text,pos,size,color)return new("TextLabel",{Position=pos,Size=size,BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=color or T.muted,TextXAlignment=Enum.TextXAlignment.Left,Text=text:upper(),},parent)end local function counter(label,fmt)local nv=new("NumberValue",{},label)nv.Changed:Connect(function(v)label.Text=fmt(v)end)return function(target,instant)if instant then nv.Value=target else tween(nv,0.45,{Value=target},Enum.EasingStyle.Quad)end end end local wh=px(160)local wc=card(wh,"Welcome")wc.ClipsDescendants=true local glow=new("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.fromScale(0.6,1),BackgroundColor3=C.accent,BorderSizePixel=0,},wc)corner(glow,K.radius)new("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0.86)})},glow)local avatarS=px(156)local textRight=avatarS+px(34)local avatar=new("ImageLabel",{Name="Avatar",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-px(24),1,px(26)),Size=UDim2.fromOffset(avatarS,avatarS),BackgroundTransparency=1,Image="",ImageTransparency=1,},wc)task.spawn(function()local ok,img=pcall(Players.GetUserThumbnailAsync,Players,LP.UserId,Enum.ThumbnailType.AvatarBust,Enum.ThumbnailSize.Size420x420)if ok and avatar.Parent then avatar.Image=img tween(avatar,0.7,{ImageTransparency=privacy.avatar and 1 or 0,Position=UDim2.new(1,-px(24),1,px(8))})end end)local welcomeCap=caps(wc,"Welcome back",UDim2.fromOffset(CP,px(20)),UDim2.new(1,-(CP+textRight),0,px(14)))local nameL=new("TextLabel",{Position=UDim2.fromOffset(CP,px(36)),Size=UDim2.new(1,-(CP+textRight),0,px(34)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(28),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=LP.DisplayName,},wc)local userL=new("TextLabel",{Position=UDim2.fromOffset(CP,px(70)),Size=UDim2.new(1,-(CP+textRight),0,px(18)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(13),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="@"..LP.Name,},wc)local chipH=even(px(30))local chips=new("Frame",{Position=UDim2.fromOffset(CP,wh-CP-chipH),Size=UDim2.new(1,-(CP+avatarS+px(24)),0,chipH),BackgroundTransparency=1,},wc)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,px(8)),SortOrder=Enum.SortOrder.LayoutOrder,},chips)local chipIcon=even(px(14))local function chip(order,iconName,text,color,clickable)local w=textW(text,px(12),T.fontSemi)local b=new(clickable and"TextButton"or"Frame",{Name=text,LayoutOrder=order,Size=UDim2.fromOffset(px(30)+w+px(12),chipH),BackgroundColor3=color or T.field,BackgroundTransparency=color and 0.86 or 0,},chips)if clickable then b.AutoButtonColor=false b.Text=""end corner(b,px(8))local st=stroke(b,color or T.fieldLine,color and 0.55 or 0)local ic=new("ImageLabel",{Position=UDim2.fromOffset(px(10),math.floor((chipH-chipIcon)/2)),Size=UDim2.fromOffset(chipIcon,chipIcon),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=color and color:Lerp(WHITE,0.2)or T.subtext,},b)local lb=new("TextLabel",{Position=UDim2.fromOffset(px(30),0),Size=UDim2.new(1,-px(30),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=color and color:Lerp(WHITE,0.35)or T.subtext,TextXAlignment=Enum.TextXAlignment.Left,Text=text,},b)local c={frame=b,icon=ic,label=lb,stroke=st}function c.setText(t)if lb.Text==t then return end lb.Text=t tween(b,0.25,{Size=UDim2.fromOffset(px(30)+textW(t,px(12),T.fontSemi)+px(12),chipH)})end return c end local function paintChip(c,on)tween(c.frame,0.22,{BackgroundColor3=on and C.accent or T.field,BackgroundTransparency=on and 0.84 or 0})tween(c.stroke,0.22,{Color=on and C.accent or T.fieldLine,Transparency=on and 0.45 or 0})tween(c.icon,0.22,{ImageColor3=on and C.accent:Lerp(WHITE,0.2)or T.subtext})tween(c.label,0.22,{TextColor3=on and T.text or T.subtext})end local function timeLeft()if o.TimeLeft then return tostring(o.TimeLeft)end local exp=tonumber(o.ExpiresAt)if not exp then return"Lifetime"end local s=exp-os.time()if s<=0 then return"Expired"end local d,h,m=s//86400,(s%86400)//3600,(s%3600)//60 if d>0 then return("%dd %dh left"):format(d,h)end if h>0 then return("%dh %dm left"):format(h,m)end return("%dm left"):format(math.max(m,1))end chip(1,o.PlanIcon or"gem",tostring(o.Plan or"Free"),C.accent,false)local timeChip=chip(2,"clock",timeLeft(),nil,false)local nameChip=chip(3,"eye-off","Name",nil,true)local avatarChip=chip(4,"user-x","Avatar",nil,true)for key,c in pairs({name=nameChip,avatar=avatarChip})do STATE.connect(c.frame.MouseEnter,function()if not privacy[key]then tween(c.stroke,0.15,{Color=T.fieldLineHot})tween(c.label,0.15,{TextColor3=T.text})end end)STATE.connect(c.frame.MouseLeave,function()if not privacy[key]then tween(c.stroke,0.2,{Color=T.fieldLine})tween(c.label,0.2,{TextColor3=T.subtext})end end)STATE.connect(c.frame.MouseButton1Click,function()setPrivacy(key,not privacy[key])end)end onPrivacy(function()nameL.Text=privacy.name and"Hidden"or LP.DisplayName userL.Text=privacy.name and"@hidden"or("@"..LP.Name)if avatar.Image~=""then tween(avatar,0.3,{ImageTransparency=privacy.avatar and 1 or 0})end paintChip(nameChip,privacy.name)paintChip(avatarChip,privacy.avatar)nameChip.icon.Image=privacy.name and ICON.eye or ICON["eye-off"]end)local wide=true local function fitWelcome()local w=wc.AbsoluteSize.X/math.max(pop.Scale,0.01)if w<=0 then return end local nowWide=w>=px(560)if nowWide==wide then return end wide=nowWide local right=wide and(CP+textRight)or CP*2 welcomeCap.Size=UDim2.new(1,-right,0,px(14))nameL.Size=UDim2.new(1,-right,0,px(34))userL.Size=UDim2.new(1,-right,0,px(18))chips.Size=UDim2.new(1,-(wide and(CP+avatarS+px(24))or CP*2),0,chipH)avatar.Visible=wide end STATE.connect(wc:GetPropertyChangedSignal("AbsoluteSize"),fitWelcome)task.defer(fitWelcome)n+=1 local quickRebuild=FEAT.quickCard(body,n,CP)local sh=px(180)local sc=card(sh,"Stats")local function metric(xScale,xOff,iconName,label)local holder=new("Frame",{Position=UDim2.new(xScale,xOff,0,px(18)),Size=UDim2.new(0.5,-(CP+px(12)),0,px(96)),BackgroundTransparency=1,},sc)local s13=even(px(13))new("ImageLabel",{Size=UDim2.fromOffset(s13,s13),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=T.muted},holder)caps(holder,label,UDim2.fromOffset(s13+px(6),0),UDim2.new(1,-(s13+px(6)),0,s13))local value=new("TextLabel",{Position=UDim2.fromOffset(0,px(18)),Size=UDim2.new(1,0,0,px(30)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(26),TextColor3=C.green,TextXAlignment=Enum.TextXAlignment.Left,Text="--",},holder)local graph=new("Frame",{Position=UDim2.fromOffset(0,px(56)),Size=UDim2.new(1,0,0,px(38)),BackgroundTransparency=1,ClipsDescendants=true,},holder)local bars={}for i=1,HIST do local bar=new("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new((i-1)/HIST,0,1,0),Size=UDim2.new(1/HIST,-px(3),0.06,0),BackgroundColor3=T.track,BackgroundTransparency=0.4,BorderSizePixel=0,},graph)corner(bar,px(2))bars[i]=bar end return value,bars end local fpsValue,fpsBars=metric(0,CP,"gauge","FPS")local pingValue,pingBars=metric(0.5,px(12),"wifi","Ping")local setFps=counter(fpsValue,function(v)return tostring(math.floor(v+0.5))end)local setPing=counter(pingValue,function(v)return math.floor(v+0.5).."ms"end)new("Frame",{Position=UDim2.fromOffset(CP,px(124)),Size=UDim2.new(1,-CP*2,0,1),BackgroundColor3=T.rowLine,BorderSizePixel=0,},sc)local statRow=new("Frame",{Position=UDim2.fromOffset(CP,px(136)),Size=UDim2.new(1,-CP*2,0,px(32)),BackgroundTransparency=1},sc)local function stat(i,label)local holder=new("Frame",{Position=UDim2.fromScale((i-1)/3,0),Size=UDim2.fromScale(1/3,1),BackgroundTransparency=1},statRow)local v=new("TextLabel",{Size=UDim2.new(1,0,0,px(18)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(16),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text="--",},holder)caps(holder,label,UDim2.fromOffset(0,px(20)),UDim2.new(1,0,0,px(12)))return v end local playersL=stat(1,"Players")local execsL=stat(2,"Execs")local sessionL=stat(3,"Session")execsL.Text=tostring(o.Execs or GEN)for _,e in ipairs({{"FPS","Frames per second"},{"Ping","Network latency"},{"Players","Players in this server"},{"Session","Time since the script started"},})do table.insert(page.rows,{r=sc,title=e[1],desc=e[2]})end table.insert(page.rows,{r=wc,title="Hide name",desc="Streamer mode: hide your name"})table.insert(page.rows,{r=wc,title="Hide avatar",desc="Streamer mode: hide your avatar"})local function grade(v,good,okay,lowerIsBetter)if lowerIsBetter then return v<=good and C.green or(v<=okay and C.amber or C.red)end return v>=good and C.green or(v>=okay and C.amber or C.red)end local function setBars(bars,hist,scaleMax,color,t)local N=#bars for i=1,N do local v=hist[#hist-N+i]local h=v and math.clamp(v/scaleMax,0.06,1)or 0.06 local last=i==N local goal={Size=UDim2.new(1/N,-px(3),h,0),BackgroundColor3=(last and v)and color or T.track,BackgroundTransparency=v and(last and 0 or 0.65*(1-i/N))or 0.6,}if t then tween(bars[i],t,goal)else for k,x in pairs(goal)do bars[i][k]=x end end end end local function updateMetrics(instant)local fc=grade(metrics.fps,50,30,false)local pc=grade(metrics.ping,90,180,true)setFps(metrics.fps,instant)setPing(metrics.ping,instant)tween(fpsValue,0.3,{TextColor3=fc})tween(pingValue,0.3,{TextColor3=pc})local fMax,pMax=60,150 for _,v in ipairs(metrics.fpsHist)do fMax=math.max(fMax,v)end for _,v in ipairs(metrics.pingHist)do pMax=math.max(pMax,v)end setBars(fpsBars,metrics.fpsHist,fMax*1.1,fc,not instant and 0.35 or nil)setBars(pingBars,metrics.pingHist,pMax*1.1,pc,not instant and 0.35 or nil)end table.insert(metricHooks,function()if homeVisible()then updateMetrics(false)end end)local iconS=even(px(50))local btnH=px(64)local gap=px(8)local srvH=CP+iconS+px(16)+btnH+px(14)+px(14)+CP local svc=card(srvH,"Server")local gIcon=new("ImageLabel",{Position=UDim2.fromOffset(CP,CP),Size=UDim2.fromOffset(iconS,iconS),BackgroundColor3=T.field,Image="",ImageTransparency=1,ScaleType=Enum.ScaleType.Crop,},svc)corner(gIcon,px(10))stroke(gIcon,T.fieldLine)task.spawn(function()local cands={("rbxthumb://type=GameIcon&id=%d&w=150&h=150"):format(game.PlaceId),("rbxthumb://type=GameIcon&id=%d&w=150&h=150"):format(game.GameId),("rbxthumb://type=Asset&id=%d&w=150&h=150"):format(game.PlaceId),}local chosenUrl=cands[1]for _,url in ipairs(cands)do local good=false pcall(function()ContentProvider:PreloadAsync({url},function(_,status)good=status==Enum.AssetFetchStatus.Success end)end)if good then chosenUrl=url break end end if gIcon.Parent then gIcon.Image=chosenUrl tween(gIcon,0.5,{ImageTransparency=0})end end)local gx=CP+iconS+px(14)local gName=new("TextLabel",{Position=UDim2.fromOffset(gx,CP+px(6)),Size=UDim2.new(1,-(gx+CP),0,px(20)),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(16),TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=gameInfo.name,},svc)local gSub=new("TextLabel",{Position=UDim2.fromOffset(gx,CP+px(29)),Size=UDim2.new(1,-(gx+CP),0,px(16)),BackgroundTransparency=1,FontFace=T.font,TextSize=px(12),TextColor3=T.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},svc)local function playerCount()return("%d/%d"):format(#Players:GetPlayers(),Players.MaxPlayers)end local function refreshServer()gName.Text=gameInfo.name gSub.Text=("by %s  ·  %s players"):format(gameInfo.creator,playerCount())playersL.Text=playerCount()end onGameInfo(refreshServer)refreshServer()STATE.connect(Players.PlayerAdded,refreshServer)STATE.connect(Players.PlayerRemoving,function()task.defer(refreshServer)end)local grid=new("Frame",{Position=UDim2.fromOffset(CP,CP+iconS+px(16)),Size=UDim2.new(1,-CP*2,0,btnH),BackgroundTransparency=1,},svc)new("UIGridLayout",{CellSize=UDim2.new(0.25,-math.ceil(gap*3/4),0,btnH),CellPadding=UDim2.fromOffset(gap,0),SortOrder=Enum.SortOrder.LayoutOrder,},grid)local aIcon=even(px(18))local function action(order,iconName,label,fn)local b=new("TextButton",{Name=label,LayoutOrder=order,BackgroundColor3=T.field,AutoButtonColor=false,Text=""},grid)corner(b,px(10))local st=stroke(b,T.fieldLine)local ic=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,px(14)),Size=UDim2.fromOffset(aIcon,aIcon),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=T.subtext,},b)local lb=new("TextLabel",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,px(38)),Size=UDim2.new(1,-px(8),0,px(16)),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=T.subtext,Text=label,},b)table.insert(page.rows,{r=b,title=label,desc="Server action"})local busy=false STATE.connect(b.MouseEnter,function()tween(b,0.15,{BackgroundColor3=T.fieldHot})tween(st,0.15,{Color=T.fieldLineHot})tween(ic,0.25,{ImageColor3=C.accent,Position=UDim2.new(0.5,0,0,px(12))})tween(lb,0.15,{TextColor3=T.text})end)STATE.connect(b.MouseLeave,function()tween(b,0.2,{BackgroundColor3=T.field})tween(st,0.2,{Color=T.fieldLine})tween(ic,0.25,{ImageColor3=T.subtext,Position=UDim2.new(0.5,0,0,px(14))})tween(lb,0.2,{TextColor3=T.subtext})end)STATE.connect(b.MouseButton1Down,function()tween(b,0.08,{BackgroundColor3=T.rowActive})end)STATE.connect(b.MouseButton1Up,function()tween(b,0.2,{BackgroundColor3=T.fieldHot})end)STATE.connect(b.MouseButton1Click,function()if busy then return end busy=true lb.Text="..."task.spawn(function()local ok,err=pcall(fn)if not ok then notify({Title=label,Content=tostring(err),Icon="triangle-alert",Duration=5})end task.wait(0.6)busy=false if lb.Parent then lb.Text=label end end)end)end action(1,"refresh-cw","Rejoin",ACTIONS.rejoin)action(2,"shuffle","Hop",ACTIONS.hop)action(3,"users","Lowest",ACTIONS.lowest)action(4,"copy","Job ID",ACTIONS.jobid)local job=tostring(game.JobId)local shortJob=#job>12 and(job:sub(1,8).."..."..job:sub(-4))or(job~=""and job or"studio")new("TextLabel",{Position=UDim2.fromOffset(CP,srvH-CP-px(14)),Size=UDim2.new(1,-CP*2,0,px(14)),BackgroundTransparency=1,FontFace=T.mono,TextSize=px(11),TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text=("Job %s  ·  Place %d"):format(shortJob,game.PlaceId),},svc)task.spawn(function()while STATE.alive()and mine()and wc.Parent do if homeVisible()then sessionL.Text=fmtSession(os.clock()-SESSION_START)timeChip.setText(timeLeft())end task.wait(1)end end)page.onShow=function()quickRebuild()sessionL.Text=fmtSession(os.clock()-SESSION_START)timeChip.setText(timeLeft())refreshServer()updateMetrics(true)end end end)()end local floatBtn,floatIcon,CONTROL_MODES,setControlMode,getControlMode do local island=(function()local H=math.max(even(px(40)),38)local PADX=math.floor(H*0.3)local ICS=even(H*0.45)local GAP=px(8)local INK=Color3.fromRGB(245,245,247)local present,hovering=false,false local springs={}local function spring(x,k,d)local s={x=x,v=0,t=x,k=k,d=d}table.insert(springs,s)return s end local W=spring(H,380,22)local Hh=spring(H,420,22)local Sq=spring(1,520,30)local root=new("Frame",{Name="MenuIsland",AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.fromOffset(H,H),BackgroundTransparency=1,Visible=false,ZIndex=50,},gui)local rootScale=new("UIScale",{},root)local shade=new("ImageLabel",{Name="Shadow",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,px(4)),Size=UDim2.new(1,px(40),1,px(40)),BackgroundTransparency=1,Image=SHADOW_IMAGE,ImageColor3=Color3.new(0,0,0),ImageTransparency=1,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(99,99,99,99),},root)local body=new("CanvasGroup",{Name="Body",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),GroupTransparency=1,Active=true,},root)new("UICorner",{CornerRadius=UDim.new(1,0)},body)local rim=stroke(body,WHITE,1)local main=new("CanvasGroup",{Name="Main",Size=UDim2.fromScale(1,1),BackgroundTransparency=1},body)local msg=new("CanvasGroup",{Name="Alert",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,GroupTransparency=1},body)local logo=new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,PADX,0.5,0),Size=UDim2.fromOffset(ICS,ICS),BackgroundTransparency=1,Image=ICON.layers,ImageColor3=C.accent,},main)local title=new("TextLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,PADX+ICS+GAP,0.5,0),Size=UDim2.fromOffset(10,H),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(13),TextColor3=INK,TextXAlignment=Enum.TextXAlignment.Left,Text="",},main)local dotS=even(px(8))local dot=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-(PADX+px(2)),0.5,0),Size=UDim2.fromOffset(dotS,dotS),BackgroundColor3=C.green,},main)local countL=new("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-(PADX+px(2)+dotS+px(7)),0.5,0),Size=UDim2.fromOffset(0,H),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=Color3.fromRGB(170,174,184),TextXAlignment=Enum.TextXAlignment.Right,Text="",},main)local countW=0 dot:SetAttribute("MonoNoTheme",true)new("UICorner",{CornerRadius=UDim.new(1,0)},dot)local halo=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(1,1),BackgroundColor3=C.green,BackgroundTransparency=1,},dot)new("UICorner",{CornerRadius=UDim.new(1,0)},halo)local chipH=H-px(12)local chipIcon=even(px(10))local chipW=px(9)+chipIcon+px(5)+textW("Close",px(12),T.fontSemi)+px(11)local CHIP_POS=UDim2.new(1,-px(6),0.5,0)local chip=new("CanvasGroup",{AnchorPoint=Vector2.new(1,0.5),Position=CHIP_POS+UDim2.fromOffset(px(10),0),Size=UDim2.fromOffset(chipW,chipH),BackgroundColor3=WHITE,BackgroundTransparency=0.86,GroupTransparency=1,},main)local msgIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,PADX,0.5,0),Size=UDim2.fromOffset(ICS,ICS),BackgroundTransparency=1,Image="",ImageColor3=C.green,},msg)local msgText=new("TextLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,PADX+ICS+GAP,0.5,0),Size=UDim2.fromOffset(10,H),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(13),TextColor3=INK,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text="",},msg)local badge=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-px(7),0.5,0),Size=UDim2.fromOffset(px(40),H-px(14)),BackgroundColor3=C.green,BackgroundTransparency=0.78,},msg)new("UICorner",{CornerRadius=UDim.new(1,0)},badge)local badgeText=new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(11),TextColor3=C.green,Text="",},badge)msg:SetAttribute("MonoNoTheme",true)new("UICorner",{CornerRadius=UDim.new(1,0)},chip)new("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,px(9),0.5,0),Size=UDim2.fromOffset(chipIcon,chipIcon),BackgroundTransparency=1,Image=ICON.x,ImageColor3=INK,},chip)new("TextLabel",{Position=UDim2.fromOffset(px(9)+chipIcon+px(5),0),Size=UDim2.new(1,-(px(9)+chipIcon+px(5)),1,0),BackgroundTransparency=1,FontFace=T.fontSemi,TextSize=px(12),TextColor3=INK,TextXAlignment=Enum.TextXAlignment.Left,Text="Close",},chip)local titleW=0 local function measure()title.RichText=true title.Text=brandTitle.Text local plain=brandTitle.ContentText~=""and brandTitle.ContentText or brandTitle.Text:gsub("<[^>]+>","")titleW=plain~=""and textW(plain,px(13),T.fontBold)or 0 title.Size=UDim2.fromOffset(titleW,H)end local function lead()return PADX+ICS+(titleW>0 and GAP+titleW or 0)end local function openW()return lead()+GAP*2+chipW+px(6)end local function closedW()return lead()+GAP+(countW>0 and countW+px(7)or 0)+dotS+PADX+px(2)end local flashing,flashW=false,0 local function wantW()if not present then return H*0.6 end if flashing then return flashW end return(shown and openW()or closedW())+(hovering and px(6)or 0)end local endFlash local function tweenAfter(inst,t,delay,goal)local tw=TweenService:Create(inst,TweenInfo.new(t,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,delay),goal)tw:Play()return tw end local function paint(quiet)W.t=wantW()if present and not quiet then Hh.v+=H*5 end if shown then tween(dot,0.12,{BackgroundTransparency=1})tween(halo,0.12,{BackgroundTransparency=1})tween(countL,0.12,{TextTransparency=1})chip.Position=CHIP_POS+UDim2.fromOffset(px(10),0)tweenAfter(chip,0.4,0.08,{GroupTransparency=0,Position=CHIP_POS})else tween(chip,0.12,{GroupTransparency=1})tweenAfter(dot,0.35,0.1,{BackgroundTransparency=0})tweenAfter(countL,0.35,0.1,{TextTransparency=0})end logo.ImageColor3=C.accent tween(logo,0.55,{Rotation=shown and 90 or 0},Enum.EasingStyle.Back)tween(rim,0.3,{Transparency=present and(shown and 0.8 or 0.9)or 1})end local function settled(s)return math.abs(s.x-s.t)<0.02 and math.abs(s.v)<0.02 end STATE.connect(RunService.RenderStepped,function(dt)if not root.Visible then return end local busy=false for _,s in ipairs(springs)do if not settled(s)then busy=true break end end if not busy then return end dt=math.min(dt,1/20)local n=math.max(1,math.ceil(dt*240))local h=dt/n for _=1,n do for _,s in ipairs(springs)do s.v+=(-s.k*(s.x-s.t)-s.d*s.v)*h s.x+=s.v*h end end for _,s in ipairs(springs)do if settled(s)then s.x,s.v=s.t,0 end end root.Size=UDim2.fromOffset(math.max(1,math.floor(W.x+0.5)),math.max(1,math.floor(Hh.x+0.5)))rootScale.Scale=Sq.x end)task.spawn(function()while STATE.alive()and mine()and root.Parent do if present and not shown then halo.Size,halo.BackgroundTransparency=UDim2.fromScale(1,1),0.4 tween(halo,1.4,{Size=UDim2.fromScale(2.8,2.8),BackgroundTransparency=1},Enum.EasingStyle.Quad)end task.wait(1.8)end end)local function clampPos(x,y)local vp=workspace.CurrentCamera.ViewportSize local hw=openW()/2+px(10)local hh=H/2+4 return math.clamp(x,hw,math.max(hw,vp.X-hw)),math.clamp(y,hh,math.max(hh,vp.Y-hh))end local function place(x,y)x,y=clampPos(x,y)root.Position=UDim2.fromOffset(math.floor(x),math.floor(y))end local active,startPos,startAt,moved STATE.connect(body.InputBegan,function(input)if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end if active or not present then return end active,moved=input,false startPos=input.Position startAt=Vector2.new(root.Position.X.Offset,root.Position.Y.Offset)Sq.t=0.92 end)STATE.connect(UIS.InputChanged,function(input)if not active then return end local isTouch=input.UserInputType==Enum.UserInputType.Touch if isTouch and input~=active then return end if not isTouch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end local d=Vector2.new(input.Position.X-startPos.X,input.Position.Y-startPos.Y)if not moved and d.Magnitude<8 then return end moved=true Sq.t=1.04 place(startAt.X+d.X,startAt.Y+d.Y)end)STATE.connect(UIS.InputEnded,function(input)if not active then return end if input~=active and not(active.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1)then return end active=nil Sq.t=1 Sq.v+=1.6 if moved then prefs.button={x=root.Position.X.Offset,y=root.Position.Y.Offset}savePrefs()else if flashing and endFlash then endFlash()end setShown(not shown)end end)if HOVER then STATE.connect(body.MouseEnter,function()hovering=true W.t=wantW()end)STATE.connect(body.MouseLeave,function()hovering=false W.t=wantW()end)end local function show(on)if on==present then return end present=on if on then measure()root.Visible=true W.x,W.v,Hh.x,Hh.v,Sq.x,Sq.v=H*0.6,0,H*0.6,0,1,0 Hh.t,Sq.t=H,1 root.Size=UDim2.fromOffset(math.floor(H*0.6),math.floor(H*0.6))tween(body,0.3,{GroupTransparency=0},Enum.EasingStyle.Quad)tween(shade,0.5,{ImageTransparency=0.55})title.TextTransparency=1 tweenAfter(title,0.4,0.12,{TextTransparency=0})paint()else W.t,Hh.t=H*0.6,H*0.6 tween(shade,0.2,{ImageTransparency=1})tween(rim,0.2,{Transparency=1})tween(title,0.12,{TextTransparency=1})local tw=tween(body,0.28,{GroupTransparency=1},Enum.EasingStyle.Quad)tw.Completed:Once(function()if not present then root.Visible=false end end)end end local flashToken=0 endFlash=function()flashing=false tween(msg,0.15,{GroupTransparency=1},Enum.EasingStyle.Quad)tweenAfter(main,0.3,0.08,{GroupTransparency=0})W.t=wantW()end local function flash(iconName,text,color,badgeLabel,hold)if not present then return end flashToken+=1 local my=flashToken msgIcon.Image,msgIcon.ImageColor3=icon(iconName),color local textWidth=math.min(textW(text,px(13),T.fontBold),px(240))msgText.Text=text msgText.Size=UDim2.fromOffset(textWidth,H)local bw=0 if badgeLabel then bw=textW(badgeLabel,px(11),T.fontBold)+px(16)badge.Size=UDim2.fromOffset(bw,H-px(14))badge.BackgroundColor3,badgeText.TextColor3,badgeText.Text=color,color,badgeLabel end badge.Visible=badgeLabel~=nil flashW=PADX+ICS+GAP+textWidth+(badgeLabel and(GAP+bw+px(7))or PADX)flashing=true W.t=flashW Hh.v+=H*4 tween(main,0.12,{GroupTransparency=1},Enum.EasingStyle.Quad)tweenAfter(msg,0.3,0.05,{GroupTransparency=0})task.delay(hold or 1.6,function()if flashToken==my and flashing then endFlash()end end)end local function setCount(n)local t=n>0 and(n.." on")or""if countL.Text==t then return end countL.Text=t countW=t~=""and textW(t,px(12),T.fontSemi)or 0 countL.Size=UDim2.fromOffset(countW,H)if not flashing then W.t=wantW()end end CTRL.onChange(function(e,muted)setCount(CTRL.activeCount())if muted or not e or e.kind~="toggle"then return end local on=e.obj.Value if present then flash(on and"circle-check"or"circle",e.title,on and C.green or Color3.fromRGB(150,154,166),on and"ON"or"OFF")elseif not shown then notify({Title=e.title,Content=on and"Turned on"or"Turned off",Icon=on and"check"or"x",Duration=1.5})end end)FEAT.islandFlash=function(iconName,text,color)flash(iconName,text,color,nil,2)end setCount(CTRL.activeCount())measure()STATE.connect(brandTitle:GetPropertyChangedSignal("Text"),function()measure()W.t=wantW()end)do local x,y=VP.X/2,H/2+px(10)if type(prefs.button)=="table"and tonumber(prefs.button.x)and tonumber(prefs.button.y)then x,y=tonumber(prefs.button.x),tonumber(prefs.button.y)end place(x,y)end return{root=root,logo=logo,paint=paint,show=show}end)()floatBtn,floatIcon=island.root,island.logo paintFloat=function()island.paint()end onThemeChanged(function()island.paint(true)end)CONTROL_MODES=TOUCH and{"Auto","Mobile","PC + Mobile"}or{"Auto","PC","Mobile","PC + Mobile"}local controlMode=table.find(CONTROL_MODES,prefs.controls)and prefs.controls or"Auto"local function effectiveMode()if controlMode=="Auto"then return DEVICE=="PC"and"PC"or"Mobile"end return controlMode end local function applyControls()local m=effectiveMode()keyEnabled=m~="Mobile"island.show(m=="Mobile"or m=="PC + Mobile")end function setControlMode(mode,remember)if not table.find(CONTROL_MODES,mode)then return false end controlMode=mode if remember then prefs.controls=mode savePrefs()end applyControls()return true end applyControls()local hintShown=false STATE.connect(minBtn.MouseButton1Click,function()setShown(false)if not hintShown then hintShown=true local how=keyEnabled and("Press [%s] to open it again."):format(T.toggleKey.Name)or"Tap the island at the top of the screen to open it again."if keyEnabled and floatBtn.Visible then how=("Press [%s] or tap the island at the top to open it again."):format(T.toggleKey.Name)end notify({Title="Menu hidden",Content=how,Icon="info",Duration=3})end end)STATE.connect(profile.MouseButton1Click,function()if tabs.Home then selectTab("Home")end end)getControlMode=function()return controlMode end end local Lib={}local SECTION_ICONS={Overview="info",Interface="monitor",Appearance="palette",Presets="bookmark",General="settings",Script="power",Hotkey="keyboard",Movement="wind",Home="house",Seeds="refresh-cw",Trees="trees",Carving="hand",Selling="store",Delivery="package",["GIGA Planter"]="zap",Events="cloud-lightning",}local function makeTab(o)local name=tostring(o.Title or"Tab")local tab=tabs[name]or addTab(name,icon(o.Icon))local tabObj={name=name,sections=0}function tabObj:Section(so)so=so or{}local title=tostring(so.Title or"Section")self.sections+=1 local named=SECTION_ICONS[title]or(so.Icon and ICON[so.Icon]and so.Icon)or nil self.sec=addSection(tab,title,icon(named or"circle"))self.secIconSet=named~=nil self.page=self.sec.page self.group=group(self.page,nil)return self end local function g(self,iconName)if not self.group then self:Section({Title="Overview"})end if iconName and not self.secIconSet and ICON[iconName]then self.sec.icon.Image=ICON[iconName]self.secIconSet=true end return self.group end function tabObj:Toggle(e)return toggle(g(self,e.Icon),e)end function tabObj:Slider(e)return slider(g(self,e.Icon),e)end function tabObj:Dropdown(e)return dropdown(g(self,e.Icon),e)end function tabObj:Keybind(e)return keybind(g(self,e.Icon),e)end function tabObj:Paragraph(e)return paragraph(g(self,e.Icon),e)end function tabObj:Button(e)return button(g(self,e.Icon),e)end function tabObj:Input(e)return input(g(self,e.Icon),e)end function tabObj:KeyValue(e)return keyValue(g(self,e.Icon),e)end function tabObj:Label(e)return label(g(self),type(e)=="table"and e or{Text=e})end function tabObj:SetOrder(n)tab.nav.LayoutOrder=tonumber(n)or tab.index end function tabObj:Select()selectTab(name)end tabObj.Tab=tab function tabObj:Current()return g(self)end function tabObj:ThemePicker()return themePicker(g(self,"palette"))end function tabObj:ConfigManager()g(self,"folder-open")FEAT.configPage(self)if not FEAT.canFile then self:Paragraph({Title="Configs last until you leave",Desc="Your executor cannot write files, so saved configs are kept for this session only.",})end return FEAT.config end function tabObj:Divider()return{}end function tabObj:Space()return{}end function tabObj:Group(caption)g(self)if self.group.rows==0 then self.group.holder:Destroy()self.page.groups-=1 local i=table.find(self.page.groupList,self.group)if i then table.remove(self.page.groupList,i)end end self.group=group(self.page,caption)return self.group end return tabObj end local started=false local function openFirstTime()if not started then started=true pcall(FEAT.autoload)for _,fn in ipairs(CTRL.hooks)do pcall(fn,nil,true)end if not prefs.tipShown then prefs.tipShown=true savePrefs()task.delay(5,function()notify({Title="Tip",Content=(UIS.KeyboardEnabled and"Right-click"or"Long-press").." any setting to pin it to Home"..(UIS.KeyboardEnabled and", bind a key to it,"or"").." or reset it.",Icon="info",Duration=6,})end)end end if not opened then setShown(true)end end local Window={}function Window:Tab(o)return makeTab(o or{})end function Window:Section()return{Tab=function(_,o)return makeTab(o or{})end}end function Window:Home(o)o=o or{}local tabObj=makeTab({Title=o.Title or"Home",Icon=o.Icon or"house"})local tab=tabs[tabObj.name]local sec=addSection(tab,tabObj.name,icon("house"))buildHome(sec.page,o)return tabObj end function Window:SelectTab(i)local t=tabOrder[tonumber(i)or 1]if t then selectTab(t.name)end openFirstTime()end function Window:SetToggleKey(code)if typeof(code)=="EnumItem"then T.toggleKey=code end end function Window:GetDevice()return DEVICE end function Window:GetControlModes()return table.clone(CONTROL_MODES)end function Window:GetControlMode()return getControlMode()end function Window:SetControlMode(mode)return setControlMode(mode,true)end function Window:UsesKeybind()return keyEnabled end function Window:UsesButton()return floatBtn.Visible end function Window:SetUIScale(v)userScale=math.clamp(tonumber(v)or 1,0.5,2)if shown then tween(pop,0.25,{Scale=userScale})else pop.Scale=userScale end WIN.setSize(T.size)WIN.place(WIN.center())prefs.scale=userScale WIN.scaleSave=(WIN.scaleSave or 0)+1 local my=WIN.scaleSave task.delay(0.6,function()if WIN.scaleSave==my then savePrefs()end end)end function Window:GetUIScale()return userScale end function Window:SetSize(w,h)w,h=tonumber(w),tonumber(h)if not w or not h then return end WIN.setSize(Vector2.new(w,h))WIN.place(WIN.center(),true)WIN.save()end function Window:GetSize()return T.size end function Window:SetTheme(name)return applyTheme(name,true,true)end function Window:GetTheme()return currentTheme end function Window:Destroy()pcall(function()gui:Destroy()end)end function Window:Toggle()setShown(not shown)end function Window:Collapse(on)setCollapsed(on)end function Window:SetBlur(on)WIN.blur=on==true prefs.blur=WIN.blur savePrefs()if shown then WIN.blurTo(WIN.blur)end end function Window:GetBlur()return WIN.blur end function Window:SetOpacity(v)v=math.clamp(tonumber(v)or 1,0.6,1)WIN.alpha=1-v prefs.opacity=v savePrefs()if shown then tween(window,0.2,{GroupTransparency=WIN.alpha})end end function Window:GetOpacity()return 1-WIN.alpha end function Lib:CreateWindow(o)o=o or{}if typeof(o.ToggleKey)=="EnumItem"then T.toggleKey=o.ToggleKey end if o.Title or o.TitleAccent then setBrand(o.Title or"",o.TitleAccent or"")end if o.Author then brandSub.Text=tostring(o.Author)end if o.Icon then floatIcon.Image=icon(o.Icon)end if o.BadgeIcon then brandIcon.Image,brandIcon.Visible=icon(o.BadgeIcon),true local m=brandBadge:FindFirstChild("Monogram")if m then m.Visible=false end end if o.Theme and not prefs.theme then applyTheme(o.Theme,false,false)end if not o.NoAutoOpen then task.delay(2,openFirstTime)end return Window end function Lib:Notify(o)pcall(notify,o or{})end function Lib:Popup(o)pcall(popup,o or{})end function Lib:AddTheme(o)o=o or{}local base=o.Base or o.Background local accent=o.Accent if o.Name and typeof(base)=="Color3"and typeof(accent)=="Color3"then addTheme(o.Name,base,accent)if prefs.theme==tostring(o.Name)and currentTheme~=prefs.theme then applyTheme(prefs.theme,false,false)end end end function Lib:SetTheme(name)return applyTheme(name,true,true)end function Lib:GetThemes()return table.clone(THEME_ORDER)end function Lib:GetTheme()return currentTheme end function Lib:PresetSheet(tabObj,api)local Wd=api.words or{}local sg=tabObj:Current()local _,slot=row(sg,Wd.new or"New preset",Wd.desc or"Saves this game's settings under a name.")new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,px(8)),VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder},slot)local box=new("TextBox",{LayoutOrder=1,Size=UDim2.fromOffset(px(160),K.ctrlH),ClearTextOnFocus=false,BackgroundColor3=T.field,FontFace=T.font,TextSize=px(13),TextColor3=T.text,PlaceholderText=Wd.placeholder or"Preset name",PlaceholderColor3=T.muted,Text="",TextXAlignment=Enum.TextXAlignment.Left,},slot)corner(box,px(9))local boxStroke=stroke(box,T.fieldLine)new("UIPadding",{PaddingLeft=UDim.new(0,px(10)),PaddingRight=UDim.new(0,px(10))},box)box.Focused:Connect(function()tween(boxStroke,0.2,{Color=C.accent})end)box.FocusLost:Connect(function()tween(boxStroke,0.2,{Color=T.fieldLine})end)local function pillButton(parent,iconName,text,light,order)local function rest()return light and C.accent or T.field end local function hot()return light and C.accent:Lerp(WHITE,0.15)or T.fieldHot end local function ink()return light and onAccent()or T.text end local b=new("TextButton",{LayoutOrder=order,Size=UDim2.fromOffset(textW(text,px(13),T.fontBold)+px(38),K.ctrlH),BackgroundColor3=rest(),AutoButtonColor=false,Text="",},parent)corner(b,px(9))if not light then stroke(b,T.fieldLine)end local s12=even(px(12))local ic=new("ImageLabel",{Position=UDim2.fromOffset(px(11),math.floor((K.ctrlH-s12)/2)),Size=UDim2.fromOffset(s12,s12),BackgroundTransparency=1,Image=icon(iconName),ImageColor3=ink(),},b)local lb=new("TextLabel",{Position=UDim2.fromOffset(px(28),0),Size=UDim2.new(1,-px(32),1,0),BackgroundTransparency=1,FontFace=T.fontBold,TextSize=px(13),TextColor3=ink(),TextXAlignment=Enum.TextXAlignment.Left,Text=text,},b)if light then onThemeChanged(function()if b.Parent then ic.ImageColor3,lb.TextColor3=ink(),ink()end end)end b.MouseEnter:Connect(function()tween(b,0.15,{BackgroundColor3=hot()})end)b.MouseLeave:Connect(function()tween(b,0.2,{BackgroundColor3=rest()})end)return b end local saveBtn=pillButton(slot,"save","Save",true,2)local function save()local name=box.Text:gsub("^%s+",""):gsub("%s+$","")if name==""then api.save(name)return end if api.exists(name)then popup({Title="Overwrite preset",Content=("A preset called \"%s\" already exists. Replace it with the current settings?"):format(name),Buttons={{Title="Cancel"},{Title="Overwrite",Variant="Primary",Callback=function()api.save(name)end}}})else api.save(name)end box.Text=""end STATE.connect(saveBtn.MouseButton1Click,save)STATE.connect(box.FocusLost,function(enter)if enter then save()end end)local listGroup=group(tabObj.page,Wd.list or"Saved presets")local sheet={}function sheet.rebuild()for _,c in ipairs(listGroup.card:GetChildren())do if c:IsA("Frame")then c:Destroy()end end listGroup.rows=0 local keep={}for _,it in ipairs(tabObj.page.rows)do if it.g~=listGroup then table.insert(keep,it)end end tabObj.page.rows=keep local names=api.names()local auto=api.autoload()if#names==0 then row(listGroup,Wd.empty or"No presets yet",Wd.emptyDesc or"Name one above and press Save.")return end for _,name in ipairs(names)do local _,s=row(listGroup,name,auto==name and(Wd.auto or"Loads when you join this game.")or nil,auto==name and{"On start"}or nil)new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,px(6)),VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder},s)local star=new("ImageButton",{LayoutOrder=1,Size=UDim2.fromOffset(K.ctrlH,K.ctrlH),BackgroundTransparency=1,Image="",AutoButtonColor=false},s)local s14=even(px(14))new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(s14,s14),BackgroundTransparency=1,Image=ICON.star,ImageColor3=auto==name and C.amber or T.muted,},star)local load=pillButton(s,"play","Load",true,2)local del=new("ImageButton",{LayoutOrder=3,Size=UDim2.fromOffset(K.ctrlH,K.ctrlH),BackgroundColor3=T.field,Image="",AutoButtonColor=false},s)corner(del,px(9))stroke(del,T.fieldLine)local delIcon=new("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(s14,s14),BackgroundTransparency=1,Image=ICON["trash-2"],ImageColor3=T.subtext,},del)del.MouseEnter:Connect(function()tween(delIcon,0.15,{ImageColor3=C.red})end)del.MouseLeave:Connect(function()tween(delIcon,0.2,{ImageColor3=T.subtext})end)star.MouseButton1Click:Connect(function()api.setAutoload(auto~=name and name or nil)end)load.MouseButton1Click:Connect(function()api.load(name)end)del.MouseButton1Click:Connect(function()popup({Title="Delete preset",Content=("Delete \"%s\"? This cannot be undone."):format(name),Buttons={{Title="Cancel"},{Title="Delete",Variant="Primary",Callback=function()api.delete(name)end}}})end)end end return sheet end Lib.ScreenGui=gui Lib.window=window Lib.select=selectTab Lib.selectSection=selectSection Lib.collapse=setCollapsed Lib.show=function()setShown(true)end Lib.hide=function()setShown(false)end Lib._k={T=T,C=C,ICON=ICON,icon=icon,px=px,even=even,new=new,corner=corner,stroke=stroke,tween=tween,THEMES=THEMES,THEME_ORDER=THEME_ORDER,applyTheme=applyTheme,theme=function()return currentTheme end,onThemeChanged=onThemeChanged,CTRL=CTRL,K=K,capture=capture,prefs=prefs,savePrefs=savePrefs,group=group,row=row,toggle=toggle,slider=slider,dropdown=dropdown,keybind=keybind,paragraph=paragraph,button=button,input=input,keyValue=keyValue,label=label,notify=notify,popup=popup,closePopup=function()if closePopup then closePopup()end end,tabs=tabs,selectTab=selectTab,setShown=setShown,isShown=function()return shown end,isOpened=function()return opened end,openFirstTime=openFirstTime,shell=shell,window=window,gui=gui,STATE=STATE,mine=mine,}return Lib end)()return(function()local k=WindUI._k local T,C=k.T,k.C local NOOP=function()end local Kit={VERSION=KIT_VERSION,Lib=WindUI}local function safe(fn,... )if type(fn)~="function"then return end local ok,err=pcall(fn,... )if not ok then warn("[SPECTREWARE] callback error: "..tostring(err))end end local function soft(t)return setmetatable(t,{__index=function(_,key)if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end local function toKeyCode(v)if typeof(v)=="EnumItem"then return v end if type(v)=="string"and v~=""then local ok,code=pcall(function()return Enum.KeyCode[v]end)if ok then return code end end return nil end local unloadHooks,unloaded={},false function Kit.OnUnload(fn)if type(fn)=="function"then table.insert(unloadHooks,fn)end end local function runHooks()if unloaded then return end unloaded=true for _,fn in ipairs(unloadHooks)do safe(fn)end end function Kit.Unload()runHooks()pcall(STATE.teardown)end STATE.onCleanup(runHooks)local function notify(cfg,kind)if type(cfg)~="table"then cfg={Content=tostring(cfg)}end local kd=tostring(cfg.Kind or cfg.Type or kind or""):lower()local ic=cfg.Icon if type(ic)~="string"or ic:find("^rbxasset")then ic=(kd=="success"and"check")or((kd=="warning"or kd=="warn")and"triangle-alert")or((kd=="error"or kd=="danger")and"x")or"info"end local content=tostring(cfg.Content or cfg.Text or cfg.Description or cfg.Desc or"")if cfg.SubContent and cfg.SubContent~=""then content=content.."\n"..tostring(cfg.SubContent)end pcall(k.notify,{Title=tostring(cfg.Title or cfg.Name or"SPECTREWARE"),Content=content,Duration=tonumber(cfg.Duration)or 4,Icon=ic,})end Kit.Notify=notify local Win,menuKeyCtrl local loadedFns={}local function open()if not Win then return end if not k.isOpened()then Win:SelectTab(1)for _,fn in ipairs(loadedFns)do task.spawn(safe,fn)end table.clear(loadedFns)else k.setShown(true)end end Kit.Open=open local touchToken=0 local function touch()if k.isOpened()then return end touchToken+=1 local my=touchToken task.delay(1.5,function()if my==touchToken and not k.isOpened()then open()end end)end local keyListeners={}local function rememberKey(code)if k.prefs.menuKey~=code.Name then k.prefs.menuKey=code.Name pcall(k.savePrefs)end for _,fn in ipairs(keyListeners)do safe(fn,code)end end function Kit.SetToggleKey(code)code=toKeyCode(code)if not code or not Win then return end Win:SetToggleKey(code)if menuKeyCtrl and menuKeyCtrl.Value~=code.Name then pcall(function()menuKeyCtrl:Set(code)end)end rememberKey(code)end function Kit.GetToggleKey()return k.T.toggleKey end function Kit.OnToggleKeyChanged(fn)if type(fn)=="function"then table.insert(keyListeners,fn)end end local function buildSettings()local S=Win:Tab({Title="Settings",Icon="settings"})S:SetOrder(10000)S:Section({Title="General"})S:Group("Device")S:Dropdown({Title="Menu Controls",Desc=("Detected: %s. Auto uses the %s. PC = keybind, Mobile = island at the top, PC + Mobile = both."):format(Win:GetDevice(),Win:GetDevice()=="PC"and"keybind"or"island at the top"),Values=Win:GetControlModes(),Value=Win:GetControlMode(),Search=false,Config=false,Callback=function(mode)Win:SetControlMode(mode)notify({Title="Menu Controls: "..mode,Kind="Success",Duration=3,Content=Win:UsesButton()and"Tap the island at the top to open or close the menu. Drag it to move it."or"Use your menu key to open or close the menu.",})end,})S:Group("Interface")menuKeyCtrl=S:Keybind({Title="Menu Toggle Key",Desc="Click and press a key to change the show/hide hotkey.",Value=T.toggleKey.Name,Callback=function(name)local code=toKeyCode(name)if code then Win:SetToggleKey(code)rememberKey(code)end end,})S:Group("Appearance")S:ThemePicker()S:Toggle({Title="Blur Background",Desc="Blur the game behind the menu while it is open.",Icon="droplet",Value=Win:GetBlur(),Callback=function(on)Win:SetBlur(on)end})S:Slider({Title="Window Opacity",Desc="Lower it to see the game through the menu.",Value={Min=60,Max=100,Default=math.floor(Win:GetOpacity()*100+0.5)},Step=5,Suffix="%",Callback=function(v)Win:SetOpacity(v/100)end})S:Slider({Title="UI Scale",Desc="Adjust the size of the menu window.",Value={Min=0.7,Max=1.3,Default=Win:GetUIScale()},Step=0.05,Callback=function(v)Win:SetUIScale(v)end})S:Group("Script")S:Button({Title="Unload Script",Desc="Stop every feature and remove the menu from the game.",Icon="power",Callback=function()k.popup({Title="Unload script?",Content="The menu and everything it runs will be removed from the game. You'll need to execute the script again to get it back.",Buttons={{Title="Cancel"},{Title="Unload",Variant="Primary",Callback=function()task.defer(Kit.Unload)end}},})end,})S:Section({Title="Configs"})S:ConfigManager()return S end function Kit.Init(cfg)if Win then return Win end cfg=cfg or{}Win=WindUI:CreateWindow({Title="SPECTRE",TitleAccent="WARE",Author="v"..KIT_VERSION,Icon="layers",ToggleKey=toKeyCode(k.prefs.menuKey)or toKeyCode(cfg.ToggleKey)or Enum.KeyCode.RightShift,NoAutoOpen=true,})Win:Home({Plan=cfg.Plan or"Free",ExpiresAt=cfg.ExpiresAt,TimeLeft=cfg.TimeLeft})buildSettings()k.STATE.connect(k.shell:GetPropertyChangedSignal("Visible"),function()local v=k.shell.Visible if v==k.isShown()then return end if v then k.shell.Visible=false open()else k.setShown(false)end end)task.delay(8,function()if not k.isOpened()then open()end end)return Win end Kit.Window=function()return Win end local function gameTab(name,iconName)name=tostring(name or"Tab")local low=name:lower()if low=="settings"or low=="setting"then local tabObj=Win:Tab({Title="Settings"})tabObj:Section({Title="Game"})return tabObj,"Settings"end if low=="home"then name="Overview"end local tabObj=Win:Tab({Title=name,Icon=iconName})tabObj:Section({Title=name})touch()return tabObj,name end local THEME_FACE={Font=Enum.Font.GothamMedium,FontBold=Enum.Font.GothamBold,Text=T.text,SubText=T.subtext,Accent=C.accent,Background=T.bg,Panel=T.side,Card=T.card,Control=T.field,Border=T.border,}local function findTab(list,x)if type(x)=="number"then return list[x]end if type(x)=="string"then for _,t in ipairs(list)do if t.Name==x then return t end end return nil end return x end local function titleLabelOf(entry)local r=type(entry)=="table"and entry.row or nil local col=r and r:FindFirstChild("Text")local line=col and col:FindFirstChild("TitleLine")return line and line:FindFirstChild("Title")end local function ctrlObj(get)return setmetatable({},{__index=function(_,key)if key=="Value"then return get()end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end local function dialog(cfg)cfg=cfg or{}local buttons={}local list=cfg.Buttons or{}for i,b in ipairs(list)do buttons[i]={Title=tostring(b.Title or b.Name or"OK"),Variant=(b.Primary or b.Variant=="Primary"or i==#list)and"Primary"or nil,Callback=function()safe(b.Callback)end,}end if#buttons==0 then buttons={{Title="OK",Variant="Primary"}}end k.popup({Title=tostring(cfg.Title or""),Content=tostring(cfg.Content or cfg.Text or""),Buttons=buttons})end local function setTheme(name)name=tostring(name)if k.THEMES[name]then k.applyTheme(name,true,true)end end local SUI={Flags={},Objects={},Themes={},Version=KIT_VERSION,_flagCbs={}}local function setFlag(cfg,v)if not cfg.Flag then return end local prev=SUI.Flags[cfg.Flag]SUI.Flags[cfg.Flag]=v if prev~=v then for _,cb in ipairs(SUI._flagCbs)do safe(cb,cfg.Flag,v,prev)end end end local function reg(cfg,obj)if cfg.Flag then SUI.Objects[cfg.Flag]=obj end touch()return obj end local function nameOf(cfg,fallback)return tostring(cfg.Name or cfg.Title or cfg.Text or fallback)end local function descOf(cfg)return cfg.Tooltip or cfg.Description or cfg.Desc or cfg.Info end local SectionM={}local function newSection(g)local s={_g=g,Body=g.card,Frame=g.holder,Controls={},Window={Theme=THEME_FACE}}return setmetatable(s,{__index=function(_,key)local m=SectionM[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end function SectionM:CreateToggle(cfg)cfg=type(cfg)=="table"and cfg or{Name=cfg}local silent=false local raw=k.toggle(self._g,{Title=nameOf(cfg,"Toggle"),Desc=descOf(cfg),Value=cfg.Default==true or cfg.CurrentValue==true,Flag=cfg.Flag,Config=cfg.Config,Callback=function(v)setFlag(cfg,v)if not silent then safe(cfg.Callback,v)end end,})setFlag(cfg,raw.Value)local obj=ctrlObj(function()return raw.Value end)function obj:Set(v,s)silent=s==true raw:Set(v and true or false)silent=false end function obj:Get()return raw.Value end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end function SectionM:CreateSlider(cfg)cfg=cfg or{}local silent=false local range=type(cfg.Range)=="table"and cfg.Range or{}local mn,mx=tonumber(cfg.Min or range[1])or 0,tonumber(cfg.Max or range[2])or 100 local raw=k.slider(self._g,{Title=nameOf(cfg,"Slider"),Desc=descOf(cfg),Value={Min=mn,Max=mx,Default=tonumber(cfg.Default or cfg.CurrentValue)or mn},Step=tonumber(cfg.Increment or cfg.Step)or 1,Suffix=cfg.Suffix,Flag=cfg.Flag,Config=cfg.Config,Callback=function(v)setFlag(cfg,v)if not silent then safe(cfg.Callback,v)end end,})setFlag(cfg,raw.Value)local obj=ctrlObj(function()return raw.Value end)function obj:Set(v,s)silent=s==true raw:Set(v)silent=false end function obj:Get()return raw.Value end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end function SectionM:CreateDropdown(cfg)cfg=cfg or{}local silent=false local multi=cfg.Multi==true or cfg.MultipleOptions==true local default=cfg.Default if default==nil then default=cfg.CurrentOption end local raw=k.dropdown(self._g,{Title=nameOf(cfg,"Dropdown"),Desc=descOf(cfg),Values=cfg.Options or cfg.Values or{},Value=default,Multi=multi,AllowNone=default==nil,Search=cfg.Searchable,Flag=cfg.Flag,Config=cfg.Config,Callback=function(v)setFlag(cfg,v)if not silent then safe(cfg.Callback,v)end end,})setFlag(cfg,raw.Value)local obj=ctrlObj(function()return raw.Value end)function obj:Set(v,s)silent=s==true raw:Select(v)silent=false end function obj:Get()return raw.Value end function obj:Refresh(list)raw:Refresh(list or{})end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end function SectionM:CreateButton(cfg,cb)cfg=type(cfg)=="table"and cfg or{Name=cfg,Callback=cb}local raw=k.button(self._g,{Title=nameOf(cfg,"Button"),Desc=descOf(cfg),Icon=cfg.Icon,Callback=function()safe(cfg.Callback)end,})local obj=soft({Frame=raw.entry and raw.entry.row})function obj:SetText(t)local l=titleLabelOf(raw.entry)if l then l.Text=tostring(t)end end obj.SetTitle=obj.SetText function obj:Fire()raw.Run()end touch()return obj end function SectionM:CreateTextbox(cfg)cfg=cfg or{}local silent=false local raw=k.input(self._g,{Title=nameOf(cfg,"Text"),Desc=descOf(cfg),Value=cfg.Default or cfg.CurrentValue,Placeholder=cfg.Placeholder or cfg.PlaceholderText,Numeric=cfg.Numeric,Min=cfg.Min,Max=cfg.Max,MaxLength=cfg.MaxLength,ClearOnFocus=cfg.ClearOnFocus or cfg.ClearTextOnFocus,Live=cfg.Live==true,Flag=cfg.Flag,Config=cfg.Config,Callback=function(v)setFlag(cfg,v)if not silent then safe(cfg.Callback,v)end end,})setFlag(cfg,raw.Value)local obj=ctrlObj(function()return raw.Value end)function obj:Set(v,s)silent=s==true raw:Set(v)silent=false end function obj:Get()return raw.Value end function obj:GetText()return raw.Box.Text end function obj:Clear()raw.Box.Text=""end function obj:Focus()raw.Box:CaptureFocus()end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end SectionM.CreateInput=SectionM.CreateTextbox local function keyMatches(raw,input)local v=raw.Value if not v then return false end if input.KeyCode~=Enum.KeyCode.Unknown then return input.KeyCode.Name==v end return input.UserInputType.Name==v end function SectionM:CreateKeybind(cfg)cfg=cfg or{}local mode=cfg.Mode or"Press"local state,silent=false,false local d=toKeyCode(cfg.Default)local raw=k.keybind(self._g,{Title=nameOf(cfg,"Keybind"),Desc=descOf(cfg),Value=d and d.Name or(type(cfg.Default)=="string"and cfg.Default or nil),Flag=cfg.Flag,Config=cfg.Config,Callback=function(name)local code=toKeyCode(name)setFlag(cfg,code)state=false if not silent then safe(cfg.Changed or cfg.ChangedCallback,code)end end,})setFlag(cfg,toKeyCode(raw.Value))k.STATE.connect(UIS.InputBegan,function(input,gp)if gp or raw.Picking or k.capture.active or not k.mine()then return end if not keyMatches(raw,input)then return end if mode=="Hold"then state=true safe(cfg.Callback,true)elseif mode=="Toggle"then state=not state safe(cfg.Callback,state)else safe(cfg.Callback)end end)k.STATE.connect(UIS.InputEnded,function(input)if mode=="Hold"and state and keyMatches(raw,input)then state=false safe(cfg.Callback,false)end end)local obj=ctrlObj(function()return toKeyCode(raw.Value)end)function obj:Set(v,s)silent=s==true raw:Set(toKeyCode(v)or v)silent=false end function obj:Get()return toKeyCode(raw.Value)end function obj:GetState()return state end obj.Frame=raw.entry and raw.entry.row return reg(cfg,obj)end function SectionM:CreateParagraph(cfg)cfg=cfg or{}local raw=k.paragraph(self._g,{Title=tostring(cfg.Title or cfg.Name or""),Desc=tostring(cfg.Content or cfg.Desc or cfg.Text or"")})local obj=soft({})function obj:Set(t,c)if t~=nil then raw:SetTitle(t)end if c~=nil then raw:SetDesc(c)end end function obj:SetTitle(t)raw:SetTitle(t)end function obj:SetDesc(t)raw:SetDesc(t)end obj.SetContent=obj.SetDesc touch()return obj end function SectionM:CreateLabel(cfg)cfg=type(cfg)=="table"and cfg or{Text=cfg}local raw=k.label(self._g,{Text=cfg.Text or cfg.Name or"",Color=cfg.Color,Bold=cfg.Bold})local obj=soft({Frame=raw.Frame})function obj:Set(t)raw:Set(t)end function obj:SetColor(c)raw:SetColor(c)end return obj end function SectionM:CreateKeyValue(cfg)cfg=cfg or{}local raw=k.keyValue(self._g,{Title=nameOf(cfg,""),Value=cfg.Value,Color=cfg.Color})local obj=ctrlObj(function()return raw.Value end)function obj:Set(v)raw:Set(v)end function obj:Get()return raw.Value end function obj:SetColor(c)raw:SetColor(c)end return obj end function SectionM:CreateColorPicker(cfg)cfg=cfg or{}local value=cfg.Default or Color3.new(1,1,1)local obj=ctrlObj(function()return value end)function obj:Set(c,s)value=c if not s then safe(cfg.Callback,c)end end function obj:Get()return value end return reg(cfg,obj)end function SectionM:CreateDivider()return soft({})end SectionM.CreateSeparator=SectionM.CreateDivider function SectionM:SetCollapsed(on)if self._g.setFolded then self._g.setFolded(on==true,true)end end local TabM={}local function newSTab(tabObj,name)local t={_tabObj=tabObj,Name=name,Sections={},Window={Theme=THEME_FACE}}return setmetatable(t,{__index=function(_,key)local m=TabM[key]if m~=nil then return m end if type(key)=="string"and SectionM[key]then return function(self,... )return SectionM[key](self:_implicit(),... )end end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end function TabM:CreateSection(cfg)local title=type(cfg)=="table"and(cfg.Name or cfg.Title)or cfg title=(title~=nil and tostring(title)~="")and tostring(title)or nil local g=self._tabObj:Group(title)local s=newSection(g)table.insert(self.Sections,s)if type(cfg)=="table"and cfg.Collapsed and g.setFolded then task.defer(g.setFolded,true,false)end touch()return s end function TabM:_implicit()local first=rawget(self,"_first")if not first then first=self:CreateSection(nil)rawset(self,"_first",first)end return first end function TabM:Select()self._tabObj:Select()end local SWindowM={}local function newSWindow()local w={Tabs={},Conns={},Main=k.shell,Root=k.shell,Theme=THEME_FACE}return setmetatable(w,{__index=function(_,key)if key=="Visible"then return k.isShown()end if key=="ThemeName"then return k.theme()end local m=SWindowM[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end function SWindowM:CreateTab(cfg,iconName)local name=type(cfg)=="table"and(cfg.Name or cfg.Title)or cfg local tabObj,shownName=gameTab(name,type(cfg)=="table"and cfg.Icon or iconName)local t=newSTab(tabObj,shownName)table.insert(self.Tabs,t)return t end function SWindowM:SelectTab(x)if not k.isOpened()then return end local t=findTab(self.Tabs,x)if type(t)=="table"and t._tabObj then t._tabObj:Select()end end SWindowM.SetTab=SWindowM.SelectTab SWindowM.Goto=SWindowM.SelectTab function SWindowM:GetTab(name)return findTab(self.Tabs,name)end function SWindowM:Notify(cfg)notify(cfg)end function SWindowM:Toast(text,kind)notify({Title=kind and tostring(kind)or"SPECTREWARE",Content=text,Kind=kind})end function SWindowM:Info(t,c,d)notify({Title=t,Content=c,Duration=d})end function SWindowM:Success(t,c,d)notify({Title=t,Content=c,Duration=d,Kind="Success"})end function SWindowM:Warning(t,c,d)notify({Title=t,Content=c,Duration=d,Kind="Warning"})end function SWindowM:Error(t,c,d)notify({Title=t,Content=c,Duration=d,Kind="Error"})end function SWindowM:SetVisible(v)if v then open()else k.setShown(false)end end function SWindowM:Toggle()if k.isShown()then k.setShown(false)else open()end end function SWindowM:Open()open()end function SWindowM:Close()k.setShown(false)end function SWindowM:Resize(w,h)Win:SetSize(w,h)end SWindowM.SetSize=SWindowM.Resize function SWindowM:IsOpen()return k.isShown()end function SWindowM:Destroy()Kit.Unload()end SWindowM.Unload=SWindowM.Destroy function SWindowM:SetTheme(name)setTheme(name)end function SWindowM:GetThemeName()return k.theme()end function SWindowM:SetToggleKey(key)Kit.SetToggleKey(key)end function SWindowM:GetToggleKey()return T.toggleKey end function SWindowM:OnLoaded(fn)if k.isOpened()then task.spawn(safe,fn)else table.insert(loadedFns,fn)end end function SWindowM:FinishLoading()open()end function SWindowM:CreateDefaultTabs()return nil end function SWindowM:CreateSettingsTab()local tabObj=gameTab("Settings")return newSTab(tabObj,"Settings")end SWindowM.CreateThemeTab=SWindowM.CreateSettingsTab function SWindowM:Dialog(cfg)dialog(cfg)end function SWindowM:Confirm(cfg)cfg=cfg or{}k.popup({Title=tostring(cfg.Title or"Are you sure?"),Content=tostring(cfg.Content or cfg.Text or""),Buttons={{Title=tostring(cfg.No or cfg.Cancel or"Cancel"),Callback=function()safe(cfg.Callback,false)end},{Title=tostring(cfg.Yes or cfg.Confirm or"Confirm"),Variant="Primary",Callback=function()safe(cfg.Callback,true)end},},})end function SWindowM:Watermark()return soft({})end function SWindowM:KeybindList()return soft({})end local theWindow function SUI:CreateWindow(cfg)cfg=cfg or{}Kit.Init({ToggleKey=cfg.ToggleKey})theWindow=theWindow or newSWindow()return theWindow end function SUI:Notify(cfg)notify(cfg)end function SUI:Toast(text,kind)notify({Title=kind and tostring(kind)or"SPECTREWARE",Content=text,Kind=kind})end function SUI:SetTheme(name)setTheme(name)end function SUI:ListThemes()return table.clone(k.THEME_ORDER)end function SUI:GetTheme(name)return k.THEMES[tostring(name or k.theme())]end function SUI:OnFlag(cb)table.insert(SUI._flagCbs,cb)return{Disconnect=function()local i=table.find(SUI._flagCbs,cb)if i then table.remove(SUI._flagCbs,i)end end}end function SUI:SetFlag(flag,v,silent)local o=SUI.Objects[flag]if o and o.Set then o:Set(v,silent)end end function SUI:GetFlags()return table.clone(SUI.Flags)end function SUI:GetControl(flag)return SUI.Objects[flag]end function SUI:Unload()Kit.Unload()end function SUI:Copy(text)local set=setclipboard or toclipboard if set then pcall(set,tostring(text))notify({Title="Copied",Content=tostring(text),Kind="Success",Duration=2})end end function SUI:Dialog(cfg)dialog(cfg)end function SUI:Confirm(cfg)if theWindow then theWindow:Confirm(cfg)end end setmetatable(SUI,{__index=function(_,key)if key=="ThemeName"then return k.theme()end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})Kit.SpectreUI=SUI local FL={Options={},Themes=table.clone(k.THEME_ORDER),OpenFrames={},Version=KIT_VERSION}local HandleM={}local function newHandle(kind,id,get,set)local h={Type=kind,_changed={},_get=get,_set=set}setmetatable(h,{__index=function(_,key)if key=="Value"then return get()end local m=HandleM[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end,__newindex=function(t,key,v)if key=="Value"then set(v)else rawset(t,key,v)end end,})if id then FL.Options[id]=h end touch()return h end function HandleM:OnChanged(fn)if type(fn)=="function"then table.insert(self._changed,fn)end end function HandleM:SetValue(v)self._set(v)end function HandleM:GetValue()return self._get()end function HandleM:_fire(... )for _,fn in ipairs(self._changed)do safe(fn,... )end end function HandleM:Destroy()local r=rawget(self,"_row")if r then r.Visible=false end end function HandleM:SetDesc(text)local r=rawget(self,"_row")local col=r and r:FindFirstChild("Text")if not col then return end text=tostring(text or"")local d=col:FindFirstChild("Desc")if not d then if text==""then return end d=k.new("TextLabel",{Name="Desc",LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,FontFace=T.font,TextSize=k.K.desc,TextColor3=T.muted,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Text=text,},col)end d.Text=text end function HandleM:SetTitle(text)local lbl=titleLabelOf({row=rawget(self,"_row")})if lbl then lbl.Text=tostring(text or"")end end local function toMap(list)local m={}if type(list)=="table"then for key,v in pairs(list)do if type(key)=="number"then m[v]=true elseif v then m[key]=true end end end return m end local function hex(c)return("#%02X%02X%02X"):format(math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))end local Adders={}function Adders:AddToggle(id,cfg)cfg=cfg or{}local h local raw=k.toggle(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Value=cfg.Default==true,Flag=id,Callback=function(v)safe(cfg.Callback,v)if h then h:_fire(v)end end,})h=newHandle("Toggle",id,function()return raw.Value end,function(v)raw:Set(v==true)end)rawset(h,"_row",raw.entry and raw.entry.row)return h end function Adders:AddSlider(id,cfg)cfg=cfg or{}local h local rounding=tonumber(cfg.Rounding)or 0 local step=tonumber(cfg.Step or cfg.Increment)or(10^-math.max(rounding,0))local mn,mx=tonumber(cfg.Min)or 0,tonumber(cfg.Max)or 100 local raw=k.slider(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Value={Min=mn,Max=mx,Default=tonumber(cfg.Default)or mn},Step=step,Suffix=cfg.Suffix,Flag=id,Callback=function(v)safe(cfg.Callback,v)if h then h:_fire(v)end end,})h=newHandle("Slider",id,function()return raw.Value end,function(v)raw:Set(tonumber(v)or mn)end)rawset(h,"_row",raw.entry and raw.entry.row)return h end function Adders:AddDropdown(id,cfg)cfg=cfg or{}local h local values=cfg.Values or cfg.Options or{}local multi=cfg.Multi==true local default=cfg.Default if type(default)=="number"and values[default]~=nil then default=values[default]end local function out(v)if multi then return toMap(v)end return v end local raw=k.dropdown(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Values=values,Value=default,Multi=multi,AllowNone=cfg.AllowNull==true or default==nil,Search=cfg.Searchable,Flag=id,Callback=function(v)safe(cfg.Callback,out(v))if h then h:_fire(out(v))end end,})h=newHandle("Dropdown",id,function()return out(raw.Value)end,function(v)raw:Select(v)end)rawset(h,"_row",raw.entry and raw.entry.row)rawset(h,"Multi",multi)rawset(h,"Values",values)function h:SetValues(list)rawset(h,"Values",list or{})raw:Refresh(list or{})end return h end function Adders:AddInput(id,cfg)cfg=cfg or{}local h local raw=k.input(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Value=cfg.Default,Placeholder=cfg.Placeholder,Numeric=cfg.Numeric,MaxLength=cfg.MaxLength,Live=cfg.Finished~=true,Flag=id,Callback=function(v)safe(cfg.Callback,v)if h then h:_fire(v)end end,})h=newHandle("Input",id,function()return raw.Value end,function(v)raw:Set(v)end)rawset(h,"_row",raw.entry and raw.entry.row)return h end function Adders:AddKeybind(id,cfg)cfg=cfg or{}local mode,state=cfg.Mode or"Toggle",false local clicks={}local h local raw=k.keybind(self._g,{Title=tostring(cfg.Title or id),Desc=cfg.Description or cfg.Desc,Value=typeof(cfg.Default)=="EnumItem"and cfg.Default.Name or cfg.Default,Flag=id,Callback=function(name)state=false safe(cfg.ChangedCallback,toKeyCode(name)or name)if h then h:_fire(name)end end,})k.STATE.connect(UIS.InputBegan,function(input,gp)if gp or raw.Picking or k.capture.active or not k.mine()or not keyMatches(raw,input)then return end if mode=="Hold"then state=true else state=not state end safe(cfg.Callback,state)for _,fn in ipairs(clicks)do safe(fn)end end)k.STATE.connect(UIS.InputEnded,function(input)if mode=="Hold"and state and keyMatches(raw,input)then state=false safe(cfg.Callback,false)end end)h=newHandle("Keybind",id,function()return raw.Value end,function(v)raw:Set(toKeyCode(v)or v)end)rawset(h,"_row",raw.entry and raw.entry.row)rawset(h,"Mode",mode)function h:GetState()if mode=="Always"then return true end return state end function h:OnClick(fn)table.insert(clicks,fn)end function h:SetValue(key,newMode)if newMode then mode=newMode rawset(h,"Mode",newMode)end raw:Set(toKeyCode(key)or key)end return h end function Adders:AddButton(cfg)cfg=cfg or{}local raw=k.button(self._g,{Title=tostring(cfg.Title or"Button"),Desc=cfg.Description or cfg.Desc,Icon=cfg.Icon,Callback=function()safe(cfg.Callback)end,})local h=newHandle("Button",nil,NOOP,NOOP)rawset(h,"_row",raw.entry and raw.entry.row)function h:SetTitle(t)local l=titleLabelOf(raw.entry)if l then l.Text=tostring(t)end end h.SetText=h.SetTitle function h:SetDesc()end return h end function Adders:AddParagraph(cfg)cfg=cfg or{}local raw=k.paragraph(self._g,{Title=tostring(cfg.Title or""),Desc=tostring(cfg.Content or cfg.Description or"")})local h=newHandle("Paragraph",nil,NOOP,NOOP)function h:SetTitle(t)raw:SetTitle(t)end function h:SetDesc(t)raw:SetDesc(t)end h.SetContent=h.SetDesc function h:SetValue(t)raw:SetDesc(t)end return h end Adders.AddBanner=Adders.AddParagraph function Adders:AddColorpicker(id,cfg)cfg=cfg or{}local value=cfg.Default or Color3.new(1,1,1)local raw=k.keyValue(self._g,{Title=tostring(cfg.Title or id),Value=hex(value)})local h=newHandle("Colorpicker",id,function()return value end,function(c)value=c raw:Set(hex(c))safe(cfg.Callback,c)end)rawset(h,"Transparency",cfg.Transparency or 0)function h:SetValueRGB(c)h:SetValue(c)end return h end Adders.AddColorPicker=Adders.AddColorpicker local function newFSection(g)local s={_g=g,Container=g.card}return setmetatable(s,{__index=function(_,key)local m=Adders[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end local FTabM={}local function newFTab(tabObj,name)local t={_tabObj=tabObj,Name=name}return setmetatable(t,{__index=function(_,key)local m=FTabM[key]if m~=nil then return m end if type(key)=="string"and Adders[key]then return function(self,... )return Adders[key](self:_implicit(),... )end end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end})end function FTabM:AddSection(cfg)local title=type(cfg)=="table"and(cfg.Title or cfg.Name)or cfg title=(title~=nil and tostring(title)~="")and tostring(title)or nil touch()return newFSection(self._tabObj:Group(title))end function FTabM:_AddGroup(title,desc)local s=self:AddSection(title)if desc and desc~=""then k.label(s._g,{Text=tostring(desc)})end return s end function FTabM:_implicit()local first=rawget(self,"_first")if not first then first=newFSection(self._tabObj:Group(nil))rawset(self,"_first",first)end return first end function FTabM:Select()self._tabObj:Select()end local FWindowM={}local function newFWindow()local back={Tabs={},Root=k.shell}return setmetatable({},{__index=function(_,key)if key=="Minimized"then return not k.isShown()end if key=="Destroyed"or key=="Unloaded"then return unloaded end local v=rawget(back,key)if v~=nil then return v end local m=FWindowM[key]if m~=nil then return m end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end,__newindex=function(_,key,v)if key=="Minimized"then return end if key=="MinimizeKey"then Kit.SetToggleKey(v)end back[key]=v end,})end function FWindowM:AddTab(cfg)cfg=type(cfg)=="table"and cfg or{Title=cfg}local tabObj,shownName=gameTab(cfg.Title or cfg.Name,cfg.Icon)local t=newFTab(tabObj,shownName)table.insert(self.Tabs,t)return t end function FWindowM:SelectTab(x)if not k.isOpened()then return end local t=findTab(self.Tabs,x)if type(t)=="table"and t._tabObj then t._tabObj:Select()end end function FWindowM:Minimize()if k.isShown()then k.setShown(false)else open()end end function FWindowM:Dialog(cfg)dialog(cfg)end function FWindowM:Resize(w,h)Win:SetSize(w,h)end FWindowM.SetSize=FWindowM.Resize function FWindowM:Destroy()Kit.Unload()end local fluentWindow function FL:CreateWindow(cfg)cfg=cfg or{}Kit.Init({ToggleKey=cfg.MinimizeKey})fluentWindow=fluentWindow or newFWindow()return fluentWindow end function FL:Notify(cfg)notify(cfg)end function FL:SetTheme(name)setTheme(name)end function FL:Destroy()Kit.Unload()end local fluentMinimizeKey setmetatable(FL,{__index=function(_,key)if key=="Theme"then return k.theme()end if key=="Unloaded"then return unloaded end if key=="MinimizeKey"then return fluentMinimizeKey end if type(key)=="string"and key:match("^%u")then return NOOP end return nil end,__newindex=function(t,key,v)if key=="MinimizeKey"then fluentMinimizeKey=v Kit.SetToggleKey(v)return end rawset(t,key,v)end,})Kit.Fluent=FL return Kit end)() end)() -- SPECTREWARE UI v1.0.0 (built in by ui/build.py; edit ui/SpectreUI.lua + ui/faces.lua)
  getgenv()._rar_gen = ((getgenv()._rar_gen or 0)) + 1;
  getgenv()._rar_build = "rar-daily-v3";
  getgenv().rarDailyDiag = getgenv().rarDailyDiag or {}
  local X = getgenv()._rar_gen
  local function z()
    return getgenv()._rar_gen == X
  end;
  -- Unload (Settings > Script) or running the script again stops every loop
  SPECTREWARE_UI.OnUnload(function()
    if getgenv()._rar_gen == X then getgenv()._rar_gen = X + 1 end
    pcall(function()
      if getgenv().SpectreWare_MiniIcon then
        getgenv().SpectreWare_MiniIcon:Destroy()
        getgenv().SpectreWare_MiniIcon = nil
      end
    end)
  end)
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
  task.spawn(function()
    local function fixIdentity()
      local setid = setthreadidentity or set_thread_identity or setthreadcontext or set_identity or (syn and syn.set_thread_identity)
      if setid then
        pcall(setid, 8)
      end
    end
    fixIdentity()
    local s
    s = SPECTREWARE_UI.Fluent
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
              if z:IsA("TextLabel") and ((z.Text == X or z.ContentText == X)) then
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
