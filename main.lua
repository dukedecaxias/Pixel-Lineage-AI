-- Pixel Lineage AI v2 | Painel de personagem
-- Le apenas valores replicados ao cliente; nao inventa dados.
local Players=game:GetService("Players")
local Tween=game:GetService("TweenService")
local Input=game:GetService("UserInputService")
local Run=game:GetService("RunService")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")
local prev=pg:FindFirstChild("PixelLineageAI")
if prev then prev:Destroy() end
local gui=Instance.new("ScreenGui")
gui.Name="PixelLineageAI";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true
gui.DisplayOrder=1000000;gui.ZIndexBehavior=Enum.ZIndexBehavior.Global;gui.Parent=pg
local col={base=Color3.fromRGB(12,16,27),panel=Color3.fromRGB(21,28,43),side=Color3.fromRGB(16,22,35),blue=Color3.fromRGB(77,148,255),white=Color3.fromRGB(242,246,255),gray=Color3.fromRGB(151,168,195)}
local function mk(typ,parent,props)
 local x=Instance.new(typ)
 for k,v in pairs(props or {}) do x[k]=v end
 x.Parent=parent
 return x
end
local function corner(x,r) mk("UICorner",x,{CornerRadius=UDim.new(0,r or 10)}) end
local function tween(x,props,d) Tween:Create(x,TweenInfo.new(d or .25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),props):Play() end
local root=mk("Frame",gui,{Name="Janela",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(690,430),BackgroundColor3=col.base,BorderSizePixel=0,ClipsDescendants=true})
corner(root,15);mk("UIStroke",root,{Color=Color3.fromRGB(52,72,104),Thickness=1})
local sidebar=mk("Frame",root,{Size=UDim2.new(0,162,1,0),BackgroundColor3=col.side,BorderSizePixel=0})
local function label(parent,txt,pos,size,ts,color,bold)
 return mk("TextLabel",parent,{Position=pos,Size=size,BackgroundTransparency=1,Text=txt,TextColor3=color or col.white,Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham,TextSize=ts or 13,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true})
end
label(sidebar,"PIXEL  AI",UDim2.fromOffset(17,20),UDim2.fromOffset(140,30),22,col.white,true)
label(sidebar,"LINEAGE  •  V3",UDim2.fromOffset(18,52),UDim2.fromOffset(140,20),11,col.blue,true)
local header=mk("Frame",root,{Position=UDim2.fromOffset(162,0),Size=UDim2.new(1,-162,0,55),BackgroundColor3=col.panel,BorderSizePixel=0})
local title=label(header,"Personagem",UDim2.fromOffset(20,12),UDim2.new(1,-140,0,31),18,col.white,true)
local function button(parent,text,pos,size,fn)
 local b=mk("TextButton",parent,{Position=pos,Size=size,BackgroundColor3=Color3.fromRGB(36,48,69),BorderSizePixel=0,Text=text,TextColor3=col.white,Font=Enum.Font.GothamSemibold,TextSize=12,AutoButtonColor=false})
 corner(b,8)
 b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=col.blue},.15) end)
 b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=Color3.fromRGB(36,48,69)},.15) end)
 b.MouseButton1Click:Connect(fn)
 return b
end
local minimized=false
local floating=button(gui,"PIXEL AI",UDim2.new(1,-116,0,150),UDim2.fromOffset(100,42),function() end)
floating.Visible=true
local function minimize(state)
 minimized=state
 root.Visible=not state
 floating.Text=state and "ABRIR PIXEL AI" or "PIXEL AI"
end
floating.MouseButton1Click:Connect(function() minimize(not minimized) end)
button(header,"—",UDim2.new(1,-83,0,10),UDim2.fromOffset(31,34),function() minimize(true) end)
button(header,"X",UDim2.new(1,-44,0,10),UDim2.fromOffset(31,34),function() gui:Destroy() end)
local body=mk("ScrollingFrame",root,{Position=UDim2.fromOffset(180,70),Size=UDim2.new(1,-197,1,-85),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new()})
local layout=mk("UIListLayout",body,{Padding=UDim.new(0,9),SortOrder=Enum.SortOrder.LayoutOrder})
local function clear()
 for _,child in ipairs(body:GetChildren()) do if child~=layout then child:Destroy() end end
end
local function line(a,b)
 local card=mk("Frame",body,{Size=UDim2.new(1,-7,0,42),BackgroundColor3=col.panel,BorderSizePixel=0})
 corner(card,8)
 label(card,a,UDim2.fromOffset(13,9),UDim2.new(.43,-13,0,24),13,col.gray)
 label(card,tostring(b),UDim2.new(.43,0,0,9),UDim2.new(.57,-14,0,24),13,col.white,true)
end
local function paragraph(t)
 local l=label(body,t,UDim2.new(),UDim2.new(1,-8,0,65),13,col.gray)
 l.TextYAlignment=Enum.TextYAlignment.Center
 return l
end
local function action(t,fn) return button(body,t,UDim2.new(),UDim2.new(1,-8,0,39),fn) end
local aliases={
 classe={"Class","Classe","Job","Profession"},
 ouro={"Gold","Ouro","Coins","Money"},
 candy={"Candy","Candies","Doces"},
 nivel={"Level","Nivel","Nível","Lvl"},
 vida={"Health","HP","Vida"},
 poder={"Power","Poder","Strength"}
}
local function getValue(names)
 local containers={player:FindFirstChild("leaderstats"),player:FindFirstChild("Stats"),player:FindFirstChild("Data"),player,player.Character}
 for _,obj in ipairs(containers) do
  if obj then
   for _,name in ipairs(names) do
    local a=obj:GetAttribute(name)
    if a~=nil then return tostring(a) end
    local v=obj:FindFirstChild(name)
    if v and v:IsA("ValueBase") then return tostring(v.Value) end
   end
  end
 end
 return "Não disponível"
end
local toggles={farm=false,heal=true,defend=true,skills=true,combo=true,quest=false,boss=false,loot=true,safe=true}
local settings={world="Automático",difficulty="Normal",event="Automático",goal="Experiência",minLevel=1,maxLevel=100,healAt=45,defendAt=30,bossAttempts=3,stopGold=0,stopCandy=0,skillPriority="Maior dano",profile="Equilibrado"}
local worldOptions={"Automático","Ato 1","Ato 2","Ato 3","Personalizado"}
local diffOptions={"Normal","Hard","Nightmare"}
local eventOptions={"Automático","Camp","Scout","Trainer's Shrine","Mini-Boss","Ignorar eventos"}
local goalOptions={"Experiência","Ouro","Candy","Itens","Progressão","Chefes"}
local profiles={
 ["Equilibrado"]={healAt=45,defendAt=30,goal="Experiência"},
 ["Farm XP"]={healAt=55,defendAt=40,goal="Experiência"},
 ["Farm Ouro"]={healAt=50,defendAt=35,goal="Ouro"},
 ["Chefes"]={healAt=70,defendAt=55,goal="Chefes"},
 ["Eventos"]={healAt=60,defendAt=40,goal="Progressão"}
}
local pages={}
local show
local function cycle(key,options)
 local current=settings[key]
 local index=1
 for i,v in ipairs(options) do if v==current then index=i break end end
 settings[key]=options[index%#options+1]
 show(title.Text)
end
local function numberOption(key,labelText,increment,min,max)
 action(labelText..": "..tostring(settings[key]).."  [+]",function()
  settings[key]=settings[key]+increment
  if settings[key]>max then settings[key]=min end
  show(title.Text)
 end)
end
local function toggleOption(key,name)
 action((toggles[key] and "● " or "○ ")..name..(toggles[key] and "  [ATIVO NO PERFIL]" or "  [DESLIGADO]"),function()
  toggles[key]=not toggles[key];show(title.Text)
 end)
end
local function note()
 paragraph("CONFIGURAÇÃO SOMENTE: os controles abaixo salvam escolhas nesta sessão, mas ainda não comandam o jogo. Não há AutoFarm funcional nesta versão.")
end
pages["Personagem"]=function()
 line("Jogador",player.DisplayName)
 line("Usuário Roblox","@"..player.Name)
 line("Personagem",getValue({"CharacterName","Nick","Nickname","HeroName","Name"}))
 line("Classe",getValue(aliases.classe))
 line("Nível",getValue(aliases.nivel))
 line("Ouro",getValue(aliases.ouro))
 line("Candy",getValue(aliases.candy))
 line("Poder",getValue(aliases.poder))
 local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
 line("Vida",hum and (math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)) or getValue(aliases.vida))
 action("ATUALIZAR DADOS",function() show("Personagem") end)
 paragraph("Dados lidos de atributos e valores replicados ao jogador. Campos não disponíveis não são estimados.")
end
pages["AutoFarm"]=function()
 note()
 action("Mundo: "..settings.world,function() cycle("world",worldOptions) end)
 action("Dificuldade: "..settings.difficulty,function() cycle("difficulty",diffOptions) end)
 action("Evento: "..settings.event,function() cycle("event",eventOptions) end)
 action("Objetivo: "..settings.goal,function() cycle("goal",goalOptions) end)
 numberOption("minLevel","Level mínimo",5,1,500)
 numberOption("maxLevel","Level máximo",5,1,500)
 toggleOption("farm","AutoFarm")
 toggleOption("loot","Priorizar recompensas")
 toggleOption("safe","Parar em situação insegura")
end
pages["Combate"]=function()
 note()
 numberOption("healAt","Curar abaixo de % HP",5,5,95)
 numberOption("defendAt","Defender abaixo de % HP",5,5,95)
 action("Prioridade de skills: "..settings.skillPriority,function() cycle("skillPriority",{"Maior dano","Menor custo","Suporte primeiro","Equilibrado"}) end)
 toggleOption("heal","Autocura")
 toggleOption("defend","Autodefesa")
 toggleOption("skills","Skills automáticas")
 toggleOption("combo","Combos")
end
pages["Progressão"]=function()
 note()
 toggleOption("quest","AutoQuest")
 toggleOption("boss","AutoBoss")
 numberOption("bossAttempts","Limite de tentativas em chefes",1,1,20)
 numberOption("stopGold","Meta de ouro (0 = sem meta)",1000,0,100000)
 numberOption("stopCandy","Meta de Candy (0 = sem meta)",100,0,10000)
end
pages["Perfis"]=function()
 paragraph("Escolha um perfil predefinido. As preferências ficam ativas somente enquanto este painel estiver aberto.")
 action("Perfil: "..settings.profile,function()
  cycle("profile",{"Equilibrado","Farm XP","Farm Ouro","Chefes","Eventos"})
  local p=profiles[settings.profile]
  if p then for k,v in pairs(p) do settings[k]=v end end
  show("Perfis")
 end)
 line("Objetivo atual",settings.goal)
 line("Cura",settings.healAt.."% HP")
 line("Defesa",settings.defendAt.."% HP")
 action("COPIAR CONFIGURAÇÃO",function()
  local parts={}
  for k,v in pairs(settings) do table.insert(parts,k.."="..tostring(v)) end
  table.sort(parts)
  if setclipboard then setclipboard(table.concat(parts,"\n")) end
 end)
end
pages["Histórico"]=function()
 paragraph("Sessão iniciada: "..os.date("%H:%M:%S")..". O histórico de farm, ouro ganho, vitórias e drops exigirá integração real com eventos do jogo.")
 line("AutoFarm operacional","Não integrado")
 line("Combate operacional","Não integrado")
 line("Dados do personagem","Leitura parcial")
end
pages["Configurações"]=function()
 paragraph("Tecla de minimizar: RightShift. Use o botão flutuante PIXEL AI para recuperar a janela.")
 action("CENTRALIZAR JANELA",function() root.Position=UDim2.fromScale(.5,.5) end)
 action("MINIMIZAR",function() minimize(true) end)
end
pages["Créditos"]=function()
 paragraph("PIXEL LINEAGE AI V2\nInterface em português criada com ChatGPT para o projeto Pixel-Lineage-AI.")
 paragraph("Projeto independente, sem afiliação com Roblox ou os criadores do jogo.")
end
local nav={}
show=function(page)
 title.Text=page;clear()
 for n,b in pairs(nav) do tween(b,{BackgroundColor3=n==page and col.blue or Color3.fromRGB(36,48,69)},.15) end
 pages[page]()
end
for i,name in ipairs({"Personagem","AutoFarm","Combate","Progressão","Perfis","Histórico","Configurações","Créditos"}) do
 nav[name]=button(sidebar,name,UDim2.fromOffset(11,85+(i-1)*39),UDim2.fromOffset(141,33),function() show(name) end)
end
label(sidebar,"RIGHTSHIFT  •  MINIMIZAR",UDim2.new(0,12,1,-36),UDim2.fromOffset(145,23),10,col.gray)
local dragging,startMouse,startPosition=false,nil,nil
header.InputBegan:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;startMouse=input.Position;startPosition=root.Position end
end)
Input.InputEnded:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)
Input.InputChanged:Connect(function(input)
 if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
  local d=input.Position-startMouse
  root.Position=UDim2.new(startPosition.X.Scale,startPosition.X.Offset+d.X,startPosition.Y.Scale,startPosition.Y.Offset+d.Y)
 end
end)
Input.InputBegan:Connect(function(input,processed)
 if not processed and input.KeyCode==Enum.KeyCode.RightShift then minimize(not minimized) end
end)
show("Personagem")
root.Size=UDim2.fromOffset(660,405)
tween(root,{Size=UDim2.fromOffset(690,430)},.45)
