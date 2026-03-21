-- BloxFR AI Plugin za Roblox Studio
-- Instaliraj: Plugins > Manage Plugins > Install from file

local PluginToolbar = plugin:CreateToolbar("BloxFR AI")
local PluginButton = PluginToolbar:CreateButton(
	"BloxFR AI",
	"Otvori BloxFR AI asistenta",
	"rbxassetid://7072706796"
)

local widget = plugin:CreateDockWidgetPluginGui(
	"BloxFRWidget",
	DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Right,
		true, false, 300, 500, 250, 400
	)
)
widget.Title = "BloxFR AI"

-- UI
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(13,18,30)
bg.BorderSizePixel = 0
bg.Parent = widget

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,0)
corner.Parent = bg

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,50)
header.BackgroundColor3 = Color3.fromRGB(27,111,232)
header.BorderSizePixel = 0
header.Parent = bg

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1,0,1,0)
logo.BackgroundTransparency = 1
logo.Text = "⚡ BloxFR AI"
logo.TextColor3 = Color3.fromRGB(255,255,255)
logo.TextSize = 18
logo.Font = Enum.Font.GothamBold
logo.Parent = header

-- Chat area
local chatScroll = Instance.new("ScrollingFrame")
chatScroll.Size = UDim2.new(1,-10,1,-130)
chatScroll.Position = UDim2.new(0,5,0,55)
chatScroll.BackgroundColor3 = Color3.fromRGB(10,15,25)
chatScroll.BorderSizePixel = 0
chatScroll.ScrollBarThickness = 4
chatScroll.CanvasSize = UDim2.new(0,0,0,0)
chatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
chatScroll.Parent = bg

local chatLayout = Instance.new("UIListLayout")
chatLayout.Padding = UDim.new(0,8)
chatLayout.Parent = chatScroll

local chatPad = Instance.new("UIPadding")
chatPad.PaddingAll = UDim.new(0,8)
chatPad.Parent = chatScroll

-- Input area
local inputBg = Instance.new("Frame")
inputBg.Size = UDim2.new(1,-10,0,70)
inputBg.Position = UDim2.new(0,5,1,-75)
inputBg.BackgroundColor3 = Color3.fromRGB(20,28,45)
inputBg.BorderSizePixel = 0
inputBg.Parent = bg

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0,8)
inputCorner.Parent = inputBg

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1,-80,1,-10)
inputBox.Position = UDim2.new(0,8,0,5)
inputBox.BackgroundTransparency = 1
inputBox.Text = ""
inputBox.PlaceholderText = "Napiši što želiš napraviti..."
inputBox.PlaceholderColor3 = Color3.fromRGB(100,110,130)
inputBox.TextColor3 = Color3.fromRGB(220,225,235)
inputBox.TextSize = 13
inputBox.Font = Enum.Font.Gotham
inputBox.TextWrapped = true
inputBox.MultiLine = true
inputBox.ClearTextOnFocus = false
inputBox.Parent = inputBg

local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0,60,0,40)
sendBtn.Position = UDim2.new(1,-68,0,15)
sendBtn.BackgroundColor3 = Color3.fromRGB(27,111,232)
sendBtn.Text = "Send"
sendBtn.TextColor3 = Color3.fromRGB(255,255,255)
sendBtn.TextSize = 13
sendBtn.Font = Enum.Font.GothamBold
sendBtn.BorderSizePixel = 0
sendBtn.Parent = inputBg

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0,8)
sendCorner.Parent = sendBtn

-- Helper: dodaj poruku u chat
local function addMessage(text, isUser)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,0,0)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.BackgroundTransparency = 1
	frame.Parent = chatScroll

	local bubble = Instance.new("Frame")
	bubble.Size = UDim2.new(0.85,0,0,0)
	bubble.AutomaticSize = Enum.AutomaticSize.Y
	bubble.Position = isUser and UDim2.new(0.15,0,0,0) or UDim2.new(0,0,0,0)
	bubble.BackgroundColor3 = isUser and Color3.fromRGB(27,111,232) or Color3.fromRGB(20,28,45)
	bubble.BorderSizePixel = 0
	bubble.Parent = frame

	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0,10)
	bc.Parent = bubble

	local bp = Instance.new("UIPadding")
	bp.PaddingAll = UDim.new(0,10)
	bp.Parent = bubble

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,0,0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(220,225,235)
	label.TextSize = 12
	label.Font = Enum.Font.Gotham
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = bubble

	return frame
end

-- Helper: kreiraj Part
local function createPart(name, size, position, color, shape)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size or Vector3.new(4,4,4)
	part.Position = position or Vector3.new(0,5,0)
	part.BrickColor = BrickColor.new(color or "Bright blue")
	part.Shape = shape or Enum.PartType.Block
	part.Anchored = true
	part.Parent = workspace
	return part
end

-- Helper: kreiraj Script
local function createScript(name, code, parent)
	local s = Instance.new("Script")
	s.Name = name
	s.Source = code
	s.Parent = parent or workspace
	return s
end

-- Helper: postavi lighting
local function setupLighting(preset)
	local l = game:GetService("Lighting")
	if preset == "day" then
		l.Brightness = 2
		l.ClockTime = 14
		l.Ambient = Color3.fromRGB(70,70,70)
		l.OutdoorAmbient = Color3.fromRGB(100,100,100)
	elseif preset == "night" then
		l.Brightness = 0.5
		l.ClockTime = 22
		l.Ambient = Color3.fromRGB(30,30,60)
		l.OutdoorAmbient = Color3.fromRGB(20,20,40)
	elseif preset == "sunset" then
		l.Brightness = 1.5
		l.ClockTime = 18
		l.Ambient = Color3.fromRGB(120,80,60)
		l.OutdoorAmbient = Color3.fromRGB(180,120,80)
	elseif preset == "fog" then
		l.FogEnd = 200
		l.FogStart = 50
		l.FogColor = Color3.fromRGB(180,180,200)
	end
end

-- Helper: organiziraj workspace
local function organizeWorkspace()
	local folders = {"Maps", "Models", "Scripts", "Effects", "UI"}
	for _, name in pairs(folders) do
		if not workspace:FindFirstChild(name) then
			local folder = Instance.new("Folder")
			folder.Name = name
			folder.Parent = workspace
		end
	end
	addMessage("✅ Workspace organiziran! Kreirani folderi: Maps, Models, Scripts, Effects, UI", false)
end

-- AI Parser — analizira prompt i izvršava akcije
local function parseAndExecute(prompt)
	local p = prompt:lower()
	local response = ""
	local executed = false

	-- SKRIPTE
	if p:find("script") or p:find("skrip") then
		if p:find("leaderstats") or p:find("money") or p:find("novac") or p:find("coins") then
			local code = [[
local Players = game:GetService("Players")
Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	local money = Instance.new("IntValue")
	money.Name = "Money"
	money.Value = 0
	money.Parent = leaderstats
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 0
	coins.Parent = leaderstats
end)]]
			createScript("LeaderstatsScript", code, game:GetService("ServerScriptService"))
			response = "✅ LeaderstatsScript kreiran u ServerScriptService!\nSadrži: Money i Coins za svakog igrača."
			executed = true

		elseif p:find("door") or p:find("vrata") then
			local code = [[
local door = script.Parent
local open = false
local debounce = false

door.Touched:Connect(function(hit)
	if debounce then return end
	if hit.Parent:FindFirstChild("Humanoid") then
		debounce = true
		open = not open
		door.CFrame = open and door.CFrame * CFrame.new(0, door.Size.Y, 0) or door.CFrame * CFrame.new(0, -door.Size.Y, 0)
		wait(1)
		debounce = false
	end
end)]]
			local part = createPart("Door", Vector3.new(4,8,1), Vector3.new(0,5,0), "Medium stone grey")
			createScript("DoorScript", code, part)
			response = "✅ Door kreiran s DoorScript!\nDodirni vrata da ih otvoriš/zatvoriš."
			executed = true

		elseif p:find("speed") or p:find("brzina") then
			local code = [[
local Players = game:GetService("Players")
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		local hum = char:WaitForChild("Humanoid")
		hum.WalkSpeed = 20
		hum.JumpPower = 60
	end)
end)]]
			createScript("SpeedScript", code, game:GetService("ServerScriptService"))
			response = "✅ SpeedScript kreiran!\nWalkSpeed = 20, JumpPower = 60."
			executed = true

		elseif p:find("kill") or p:find("ubij") or p:find("lava") then
			local code = [[
script.Parent.Touched:Connect(function(hit)
	local hum = hit.Parent:FindFirstChild("Humanoid")
	if hum then hum.Health = 0 end
end)]]
			local part = createPart("KillBrick", Vector3.new(10,1,10), Vector3.new(0,0.5,0), "Bright red")
			createScript("KillScript", code, part)
			response = "✅ Kill brick kreiran!\nCrveni Part s KillScript — ubija igrača na dodir."
			executed = true

		elseif p:find("shop") or p:find("kupnja") then
			local code = [[
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local GAMEPASS_ID = 000000000 -- Zamijeni s tvojim ID-om!

game:GetService("ProximityPromptService").PromptTriggered:Connect(function(prompt, player)
	if prompt.Name == "ShopPrompt" then
		MarketplaceService:PromptGamePassPurchase(player, GAMEPASS_ID)
	end
end)]]
			createScript("ShopScript", code, game:GetService("ServerScriptService"))
			response = "✅ ShopScript kreiran!\nPromijeni GAMEPASS_ID na tvoj Roblox Game Pass ID."
			executed = true

		else
			local code = [[
-- BloxFR AI Generated Script
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	print("Igrac se spojio: " .. player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
	print("Igrac je otisao: " .. player.Name)
end)]]
			createScript("BloxFR_Script", code, game:GetService("ServerScriptService"))
			response = "✅ Osnovna skripta kreirana u ServerScriptService!"
			executed = true
		end

	-- MODELI / DIJELOVI
	elseif p:find("model") or p:find("part") or p:find("dio") or p:find("napravi") or p:find("create") then
		if p:find("tower") or p:find("toranj") then
			for i = 1, 5 do
				createPart("TowerPart_"..i, Vector3.new(6,4,6), Vector3.new(0, i*4-2, 0), "Medium stone grey")
			end
			local roof = createPart("TowerRoof", Vector3.new(8,2,8), Vector3.new(0, 22, 0), "Dark stone grey")
			response = "✅ Toranj kreiran od 5 dijelova!\nPogledaj u Workspace."
			executed = true

		elseif p:find("wall") or p:find("zid") then
			for i = 1, 5 do
				createPart("Wall_"..i, Vector3.new(4,4,1), Vector3.new(i*4-10, 2, 0), "Medium stone grey")
			end
			response = "✅ Zid kreiran od 5 dijelova!"
			executed = true

		elseif p:find("floor") or p:find("pod") then
			createPart("Floor", Vector3.new(50,1,50), Vector3.new(0,0,0), "Medium stone grey")
			response = "✅ Pod kreiran (50x50)!"
			executed = true

		elseif p:find("platform") or p:find("platforma") then
			for i = 1, 3 do
				createPart("Platform_"..i, Vector3.new(10,1,10), Vector3.new(i*15-20, i*8, 0), "Bright blue")
			end
			response = "✅ 3 platforme kreirane na različitim visinama!"
			executed = true

		else
			createPart("BloxFR_Part", Vector3.new(4,4,4), Vector3.new(0,5,0), "Bright blue")
			response = "✅ Novi Part kreiran u Workspace!"
			executed = true
		end

	-- LIGHTING
	elseif p:find("light") or p:find("osvjetl") or p:find("lighting") then
		if p:find("night") or p:find("noc") or p:find("noć") then
			setupLighting("night")
			response = "✅ Night lighting postavljen!\nTamna noćna atmosfera."
			executed = true
		elseif p:find("sunset") or p:find("zalazak") then
			setupLighting("sunset")
			response = "✅ Sunset lighting postavljen!\nNarandžasti zalazak sunca."
			executed = true
		elseif p:find("fog") or p:find("magla") then
			setupLighting("fog")
			response = "✅ Fog efekt postavljen!\nGusta magla u sceni."
			executed = true
		else
			setupLighting("day")
			response = "✅ Day lighting postavljen!\nSunčano dnevno osvjetljenje."
			executed = true
		end

	-- ORGANIZACIJA
	elseif p:find("organiz") or p:find("sredi") or p:find("folder") then
		organizeWorkspace()
		executed = true
		return

	-- BRISANJE
	elseif p:find("obrisi") or p:find("delete") or p:find("clear") or p:find("ukloni") then
		for _, v in pairs(workspace:GetChildren()) do
			if v:IsA("Part") and v.Name:find("BloxFR") then
				v:Destroy()
			end
		end
		response = "✅ Svi BloxFR objekti obrisani!"
		executed = true
	end

	if not executed then
		response = "🤔 Nisam razumio. Pokušaj:\n• 'napravi toranj'\n• 'napravi kill brick'\n• 'leaderstats skripta'\n• 'door skripta'\n• 'night lighting'\n• 'organizi workspace'"
	end

	addMessage(response, false)
end

-- Send button
sendBtn.MouseButton1Click:Connect(function()
	local text = inputBox.Text
	if text == "" or text == nil then return end
	addMessage(text, true)
	inputBox.Text = ""
	addMessage("⏳ Radim na tome...", false)
	wait(0.5)
	chatScroll:FindFirstChildOfClass("Frame"):Destroy() -- remove loading
	-- remove loading msg
	local children = chatScroll:GetChildren()
	for i = #children, 1, -1 do
		if children[i]:IsA("Frame") then
			children[i]:Destroy()
			break
		end
	end
	parseAndExecute(text)
end)

inputBox.FocusLost:Connect(function(enter)
	if enter then
		local text = inputBox.Text
		if text ~= "" then
			addMessage(text, true)
			inputBox.Text = ""
			parseAndExecute(text)
		end
	end
end)

-- Toggle widget
PluginButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

-- Welcome poruka
addMessage("👋 Dobrodošao u BloxFR AI!\n\nMogu ti pomoći s:\n⚡ Lua skriptama\n🏗️ Kreiranjem modela\n💡 Lighting efektima\n📁 Organizacijom Workspace\n\nNapiši što želiš napraviti!", false)

