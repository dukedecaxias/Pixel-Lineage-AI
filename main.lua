-- Pixel Lineage AI | Hub v1.0 | Interface e diagnostico
-- Automacao experimental: somente botoes selecionados pelo usuario.
local S=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local P=game:GetService("Players").LocalPlayer
local PG=P:WaitForChild("PlayerGui")
local old=PG:FindFirstChild("PixelLineageAI")
if old then old:Destroy() end
local C={bg=Color3.fromRGB(12,16,26),panel=Color3.fromRGB(20,26,39),side=Color3.fromRGB(15,20,32),accent=Color3.fromRGB(65,145,255),txt=Color3.fromRGB(237,243,255),muted=Color3.fromRGB(147,163,190)}
local gui=Instance.new("ScreenGui")
gui.Name="PixelLineageAI";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.DisplayOrder=1000000;gui.ZIndexBehavior=Enum.ZIndexBehavior.Global;gui.Parent=PG
local function new(k,p,props)
 local o=Instance.new(k)
 for a,v in pairs(props or {}) do o[a]=v end
 o.Parent=p
 return o
end
local function round(o,r) new("UICorner",o,{CornerRadius=UDim.new(0,r or 10)}) end
local function tw(o,t,props) S:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),props):Play() end
local root=new("Frame",gui,{Name="Hub",Size=UDim2.fromOffset(720,460),Position=UDim2.new(.5,-360,.5,-230),BackgroundColor3=C.bg,BorderSizePixel=0,ClipsDescendants=true})
round(root,15)
new("UIStroke",root,{Color=Color3.fromRGB(42,61,89),Thickness=1})
local sidebar=new("Frame",root,{Size=UDim2.new(0,170,1,0),BackgroundColor3=C.side,BorderSizePixel=0})
new("TextLabel",sidebar,{Position=UDim2.fromOffset(18,20),Size=UDim2.fromOffset(145,30),BackgroundTransparency=1,Text="PIXEL  AI",Font=Enum.Font.GothamBold,TextSize=22,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=C.txt})
new("TextLabel",sidebar,{Position=UDim2.fromOffset(18,51),Size=UDim2.fromOffset(145,18),BackgroundTransparency=1,Text="LINEAGE  |  HUB v1.0",Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=C.accent})
local top=new("Frame",root,{Position=UDim2.fromOffset(170,0),Size=UDim2.new(1,-170,0,56),BackgroundColor3=C.panel,BorderSizePixel=0})
local heading=new("TextLabel",top,{Position=UDim2.fromOffset(22,0),Size=UDim2.new(1,-145,1,0),BackgroundTransparency=1,Text="Visão geral",Font=Enum.Font.GothamBold,TextSize=18,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=C.txt})
local function btn(parent,text,pos,size,callback)
 local b=new("TextButton",parent,{Position=pos,Size=size,BackgroundColor3=Color3.fromRGB(36,48,68),TextColor3=C.txt,Text=text,Font=Enum.Font.GothamSemibold,TextSize=12,AutoButtonColor=false,BorderSizePixel=0})
 round(b,8)
 b.MouseEnter:Connect(function() tw(b,.15,{BackgroundColor3=C.accent}) end)
 b.MouseLeave:Connect(function() tw(b,.15,{BackgroundColor3=Color3.fromRGB(36,48,68)}) end)
 b.MouseButton1Click:Connect(callback)
 return b
end
local minimized=false
local floating=btn(gui,"ABRIR PIXEL AI",UDim2.new(1,-170,0,155),UDim2.fromOffset(155,44),function() end)
floating.Visible=true
local function minimize(v)
 minimized=v;root.Visible=not v;floating.Visible=true
end
floating.MouseButton1Click:Connect(function()
 root.Position=UDim2.new(.5,-360,.5,-230)
 root.Size=UDim2.fromOffset(720,460)
 root.BackgroundTransparency=0
 minimize(false)
end)
btn(top,"_",UDim2.new(1,-85,0,11),UDim2.fromOffset(32,32),function() minimize(true) end)
btn(top,"X",UDim2.new(1,-45,0,11),UDim2.fromOffset(32,32),function() gui:Destroy() end)
local content=new("ScrollingFrame",root,{Position=UDim2.fromOffset(188,73),Size=UDim2.new(1,-207,1,-91),BackgroundTransparency=1,ScrollBarThickness=3,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,BorderSizePixel=0})
local stack=new("UIListLayout",content,{Padding=UDim.new(0,10),SortOrder=Enum.SortOrder.LayoutOrder})
local logs={}
local selected=nil
local running=false
local interval=2
local function log(t)
 table.insert(logs,1,os.date("%H:%M:%S").."  "..t)
 if #logs>40 then table.remove(logs) end
 print("[Pixel AI] "..t)
end
local function clear()
 for _,o in ipairs(content:GetChildren()) do if o~=stack then o:Destroy() end end
 content.CanvasPosition=Vector2.zero
end
local function text(t,h,size,color)
 return new("TextLabel",content,{Size=UDim2.new(1,-8,0,h),BackgroundTransparency=1,Text=t,TextColor3=color or C.txt,Font=Enum.Font.Gotham,TextSize=size or 13,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center})
end
local function action(t,fn)
 local b=btn(content,t,UDim2.new(),UDim2.new(1,-8,0,39),fn)
 return b
end
local pages={}
local tabs={"Início","Combate","Habilidades","Automação","Diagnóstico","Créditos"}
local show
local function detect()
 local list={}
 for _,g in ipairs(PG:GetChildren()) do
  if g:IsA("ScreenGui") and g~=gui and g.Enabled then
   for _,o in ipairs(g:GetDescendants()) do
    if o:IsA("GuiButton") and o.Visible and o.Active then
     local textValue=o:IsA("TextButton") and o.Text or ""
     local title=(textValue~="" and textValue or o.Name)
     table.insert(list,{object=o,title=title,path=o:GetFullName()})
    end
   end
  end
 end
 table.sort(list,function(a,b) return a.title:lower()<b.title:lower() end)
 return list
end
pages["Início"]=function()
 text("Bem-vindo ao Pixel Lineage AI",36,20)
 text("Hub em português • Interface animada • Diagnóstico de controles",44,13,C.muted)
 text("STATUS: painel ativo  |  Tecla: RightShift para minimizar",35,13,C.accent)
 action("Verificar interfaces agora",function() show("Diagnóstico") end)
 action("Configurar automação experimental",function() show("Automação") end)
 text("Nota: as funções de combate dependem de identificar os controles reais do jogo.",72,12,C.muted)
end
pages["Combate"]=function()
 text("Centro de combate",38,20)
 text("Planejado: prioridade de ataque, defesa, cura e combos. Estes recursos ainda não estão conectados ao sistema de combate do jogo.",100,13,C.muted)
 action("Detectar controles de batalha",function() show("Diagnóstico") end)
end
pages["Habilidades"]=function()
 text("Habilidades detectáveis",38,20)
 text("Selecione um botão na aba Diagnóstico para definir um controle experimental. Ainda não há leitura confiável de dano, cooldown ou custo.",95,13,C.muted)
 action("Abrir detector de habilidades",function() show("Diagnóstico") end)
end
pages["Automação"]=function()
 text("Automação experimental",38,20)
 text("Somente o botão selecionado será acionado, com intervalo configurável. Não identifica turnos ou segurança da ação.",88,13,C.muted)
 text("Controle: "..(selected and selected.title or "Nenhum selecionado"),42,13,C.accent)
 action("Intervalo: "..interval.." segundos (alterar)",function()
  interval=interval==2 and 3 or interval==3 and 5 or 2
  show("Automação")
 end)
 action(running and "PARAR AUTOMAÇÃO" or "INICIAR AUTOMAÇÃO",function()
  if not selected then log("Selecione um controle no Diagnóstico");show("Automação");return end
  running=not running
  log(running and "Automação iniciada" or "Automação interrompida")
  if running then
   task.spawn(function()
    while running and gui.Parent do
     local o=selected and selected.object
     if not o or not o.Parent or not o.Visible then running=false;log("Controle indisponível; parado");break end
     local ok,err=pcall(function() o:Activate() end)
     if not ok then running=false;log("Falha ao acionar: "..tostring(err));break end
     task.wait(interval)
    end
   end)
  end
  show("Automação")
 end)
 action("Parada de emergência",function() running=false;log("Parada manual");show("Automação") end)
end
pages["Diagnóstico"]=function()
 text("Detector de interfaces",38,20)
 text("Lista botões visíveis no PlayerGui. Clique em um resultado para selecioná-lo. A detecção não garante que o botão possa ser acionado.",68,12,C.muted)
 local results=detect()
 text("Controles encontrados: "..#results,30,13,C.accent)
 if #results==0 then text("Nenhum controle encontrado. Abra uma tela de batalha e tente novamente.",70,13) end
 for i,item in ipairs(results) do
  if i>45 then break end
  action((selected and selected.object==item.object and "✓ " or "")..item.title:sub(1,48),function()
   selected=item
   log("Selecionado: "..item.title)
   show("Diagnóstico")
  end)
 end
 action("Atualizar lista",function() log("Varredura atualizada");show("Diagnóstico") end)
end
pages["Créditos"]=function()
 text("Pixel Lineage AI",48,22)
 text("Interface e código: projeto desenvolvido com ChatGPT.",50,13)
 text("Projeto independente, não afiliado ao Roblox ou aos criadores de Pixel Lineage.",78,13,C.muted)
 text("Versão 1.0 • Diagnóstico e automação experimental",45,13,C.accent)
end
local menu={}
show=function(page)
 heading.Text=page
 clear()
 for name,b in pairs(menu) do tw(b,.15,{BackgroundColor3=name==page and C.accent or Color3.fromRGB(27,36,53)}) end
 pages[page]()
end
for i,name in ipairs(tabs) do
 local b=btn(sidebar,name,UDim2.fromOffset(13,88+(i-1)*49),UDim2.fromOffset(144,39),function() show(name) end)
 menu[name]=b
end
new("TextLabel",sidebar,{Position=UDim2.new(0,14,1,-34),Size=UDim2.fromOffset(150,22),BackgroundTransparency=1,Text="RIGHT SHIFT  •  MINIMIZAR",Font=Enum.Font.Gotham,TextSize=10,TextColor3=C.muted})
local dragging=false
local dragStart,startPos
top.InputBegan:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;dragStart=input.Position;startPos=root.Position end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
UIS.InputChanged:Connect(function(input)
 if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
  local delta=input.Position-dragStart
  root.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
 end
end)
UIS.InputBegan:Connect(function(input,processed)
 if not processed and input.KeyCode==Enum.KeyCode.RightShift and gui.Parent then minimize(not minimized) end
end)
show("Início")
root.Visible=true
local finalSize=root.Size
root.Size=UDim2.fromOffset(720,460)
root.BackgroundTransparency=0
tw(root,.3,{Size=finalSize,BackgroundTransparency=0})
log("Hub carregado com sucesso")
