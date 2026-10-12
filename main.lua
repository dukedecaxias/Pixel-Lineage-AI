-- Pixel Lineage AI | Diagnostico de interface v0.1
-- Este prototipo NAO executa farm, ataques ou cliques automaticos.
local Players = game:GetService("Players")
local player = Players.LocalPlayer
if not player then error("Jogador local nao encontrado") end
local gui = Instance.new("ScreenGui")
gui.Name = "PixelLineageAI_Diagnostico"
gui.ResetOnSpawn = false
local parent = player:WaitForChild("PlayerGui")
local old = parent:FindFirstChild(gui.Name)
if old then old:Destroy() end
gui.Parent = parent
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(390,330)
frame.Position = UDim2.new(0.5,-195,0.5,-165)
frame.BackgroundColor3 = Color3.fromRGB(25,29,39)
frame.Parent = gui
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)
local function label(text,y,h)
 local l=Instance.new("TextLabel")
 l.BackgroundTransparency=1
 l.Position=UDim2.fromOffset(15,y)
 l.Size=UDim2.new(1,-30,0,h)
 l.TextColor3=Color3.fromRGB(240,243,250)
 l.Font=Enum.Font.Gotham
 l.TextSize=14
 l.TextWrapped=true
 l.TextXAlignment=Enum.TextXAlignment.Left
 l.TextYAlignment=Enum.TextYAlignment.Top
 l.Text=text
 l.Parent=frame
 return l
end
label("PIXEL LINEAGE AI | DIAGNOSTICO",16,28)
local status=label("Aguardando varredura...",54,185)
local button=Instance.new("TextButton")
button.Size=UDim2.new(1,-30,0,42)
button.Position=UDim2.fromOffset(15,245)
button.Text="IDENTIFICAR INTERFACES"
button.TextColor3=Color3.new(1,1,1)
button.BackgroundColor3=Color3.fromRGB(51,115,210)
button.Font=Enum.Font.GothamBold
button.TextSize=14
button.Parent=frame
Instance.new("UICorner",button).CornerRadius=UDim.new(0,8)
local close=Instance.new("TextButton")
close.Size=UDim2.fromOffset(34,28)
close.Position=UDim2.new(1,-40,0,8)
close.Text="X"
close.TextColor3=Color3.new(1,1,1)
close.BackgroundTransparency=1
close.Parent=frame
close.MouseButton1Click:Connect(function() gui:Destroy() end)
local keywords={"skill","attack","defend","guard","heal","potion","battle","combo","habilidade","ataque","cura","defesa"}
button.MouseButton1Click:Connect(function()
 local total,found=0,{}
 for _,root in ipairs(parent:GetChildren()) do
  if root:IsA("ScreenGui") and root~=gui then
   for _,obj in ipairs(root:GetDescendants()) do
    if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Visible then
     total=total+1
     local name=obj.Name
     local txt=obj:IsA("TextButton") and obj.Text or ""
     local candidate=string.lower(name.." "..txt)
     for _,word in ipairs(keywords) do
      if string.find(candidate,word,1,true) then
       table.insert(found,(txt~="" and txt or name))
       break
      end
     end
    end
   end
  end
 end
 local shown={}
 for i=1,math.min(#found,6) do shown[#shown+1]=found[i] end
 status.Text="Botoes visiveis: "..total.."\nPossiveis controles de combate: "..#found.."\n\n"..table.concat(shown,"\n").."\n\nNenhuma acao automatica sera executada."
 print("[Pixel Lineage AI] Botoes:",total,"Possiveis controles:",table.concat(found,", "))
end)
print("[Pixel Lineage AI] Diagnostico iniciado.")
