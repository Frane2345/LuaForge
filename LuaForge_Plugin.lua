-- LuaForge Plugin for Roblox Studio
-- Install this as a Plugin in Roblox Studio
-- Version 1.0.0

local toolbar = plugin:CreateToolbar("LuaForge")
local toggleButton = toolbar:CreateButton(
	"LuaForge",
	"Open LuaForge AI Code Generator",
	"rbxassetid://0" -- replace with your icon asset ID
)

local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Right,
	true,
	false,
	280,
	420,
	220,
	320
)

local widget = plugin:CreateDockWidgetPluginGui("LuaForgeWidget", widgetInfo)
widget.Title = "LuaForge"

-- ========== UI ==========

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
bg.BorderSizePixel = 0
bg.Parent = widget

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingLeft = UDim.new(0, 12)
uiPadding.PaddingRight = UDim.new(0, 12)
uiPadding.PaddingTop = UDim.new(0, 12)
uiPadding.PaddingBottom = UDim.new(0, 12)
uiPadding.Parent = bg

local uiLayout = Instance.new("UIListLayout")
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Padding = UDim.new(0, 10)
uiLayout.Parent = bg

-- Header row
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 40)
headerFrame.BackgroundTransparency = 1
headerFrame.LayoutOrder = 1
headerFrame.Parent = bg

local headerLayout = Instance.new("UIListLayout")
headerLayout.FillDirection = Enum.FillDirection.Horizontal
headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
headerLayout.Padding = UDim.new(0, 8)
headerLayout.Parent = headerFrame

local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(0, 30, 0, 30)
iconLabel.Text = "🍋"
iconLabel.TextScaled = true
iconLabel.BackgroundColor3 = Color3.fromRGB(245, 200, 66)
iconLabel.BackgroundTransparency = 0
iconLabel.BorderSizePixel = 0
iconLabel.LayoutOrder = 1
iconLabel.Parent = headerFrame
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 6)
iconCorner.Parent = iconLabel

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 60, 0, 20)
versionLabel.Text = "v1.0.0"
versionLabel.TextColor3 = Color3.fromRGB(136, 136, 153)
versionLabel.TextSize = 11
versionLabel.BackgroundTransparency = 1
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.LayoutOrder = 2
versionLabel.Parent = headerFrame

-- Connect / Status buttons
local btnFrame = Instance.new("Frame")
btnFrame.Size = UDim2.new(1, 0, 0, 34)
btnFrame.BackgroundTransparency = 1
btnFrame.LayoutOrder = 2
btnFrame.Parent = bg

local btnLayout = Instance.new("UIListLayout")
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.SortOrder = Enum.SortOrder.LayoutOrder
btnLayout.Padding = UDim.new(0, 8)
btnLayout.Parent = btnFrame

local connectBtn = Instance.new("TextButton")
connectBtn.Size = UDim2.new(0.55, 0, 1, 0)
connectBtn.Text = "Connect"
connectBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
connectBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
connectBtn.TextSize = 13
connectBtn.Font = Enum.Font.GothamBold
connectBtn.BorderSizePixel = 0
connectBtn.LayoutOrder = 1
connectBtn.Parent = btnFrame
local connectCorner = Instance.new("UICorner")
connectCorner.CornerRadius = UDim.new(0, 6)
connectCorner.Parent = connectBtn

local statusBtn = Instance.new("TextButton")
statusBtn.Size = UDim2.new(0.44, 0, 1, 0)
statusBtn.Text = "Status ●"
statusBtn.TextColor3 = Color3.fromRGB(136, 136, 153)
statusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
statusBtn.TextSize = 12
statusBtn.Font = Enum.Font.Gotham
statusBtn.BorderSizePixel = 0
statusBtn.LayoutOrder = 2
statusBtn.Parent = btnFrame
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusBtn

-- Info message
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 40)
infoLabel.Text = "Open a project in the browser\nthen press Connect"
infoLabel.TextColor3 = Color3.fromRGB(136, 136, 153)
infoLabel.TextSize = 12
infoLabel.BackgroundTransparency = 1
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.LayoutOrder = 3
infoLabel.Parent = bg

-- Separator
local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, 0, 0, 1)
sep.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
sep.BorderSizePixel = 0
sep.LayoutOrder = 4
sep.Parent = bg

-- Code output area
local outputLabel = Instance.new("TextLabel")
outputLabel.Size = UDim2.new(1, 0, 0, 16)
outputLabel.Text = "Generated Code"
outputLabel.TextColor3 = Color3.fromRGB(245, 200, 66)
outputLabel.TextSize = 11
outputLabel.Font = Enum.Font.GothamBold
outputLabel.BackgroundTransparency = 1
outputLabel.TextXAlignment = Enum.TextXAlignment.Left
outputLabel.LayoutOrder = 5
outputLabel.Parent = bg

local codeBox = Instance.new("ScrollingFrame")
codeBox.Size = UDim2.new(1, 0, 0, 160)
codeBox.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
codeBox.BorderSizePixel = 0
codeBox.ScrollBarThickness = 4
codeBox.LayoutOrder = 6
codeBox.Parent = bg
local codeCorner = Instance.new("UICorner")
codeCorner.CornerRadius = UDim.new(0, 6)
codeCorner.Parent = codeBox

local codeText = Instance.new("TextLabel")
codeText.Size = UDim2.new(1, -12, 0, 0)
codeText.AutomaticSize = Enum.AutomaticSize.Y
codeText.Position = UDim2.new(0, 6, 0, 6)
codeText.Text = "-- Code will appear here\n-- after AI generates it"
codeText.TextColor3 = Color3.fromRGB(150, 150, 180)
codeText.TextSize = 11
codeText.Font = Enum.Font.Code
codeText.BackgroundTransparency = 1
codeText.TextWrapped = true
codeText.TextXAlignment = Enum.TextXAlignment.Left
codeText.TextYAlignment = Enum.TextYAlignment.Top
codeText.RichText = false
codeText.Parent = codeBox

-- Inject button
local injectBtn = Instance.new("TextButton")
injectBtn.Size = UDim2.new(1, 0, 0, 34)
injectBtn.Text = "⚡  Inject into Studio"
injectBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
injectBtn.BackgroundColor3 = Color3.fromRGB(245, 200, 66)
injectBtn.TextSize = 13
injectBtn.Font = Enum.Font.GothamBold
injectBtn.BorderSizePixel = 0
injectBtn.LayoutOrder = 7
injectBtn.Parent = bg
local injectCorner = Instance.new("UICorner")
injectCorner.CornerRadius = UDim.new(0, 6)
injectCorner.Parent = injectBtn

-- Logs button
local logsBtn = Instance.new("TextButton")
logsBtn.Size = UDim2.new(1, 0, 0, 28)
logsBtn.Text = "Logs Off"
logsBtn.TextColor3 = Color3.fromRGB(136, 136, 153)
logsBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
logsBtn.TextSize = 11
logsBtn.Font = Enum.Font.Gotham
logsBtn.BorderSizePixel = 0
logsBtn.LayoutOrder = 8
logsBtn.Parent = bg
local logsCorner = Instance.new("UICorner")
logsCorner.CornerRadius = UDim.new(0, 5)
logsCorner.Parent = logsBtn

-- ========== STATE ==========

local isConnected = false
local logsEnabled = false
local pendingCode = nil

-- ========== POLLING ==========
-- In a real deployment, replace DASHBOARD_URL with your actual hosted URL
-- The dashboard sends code to a relay endpoint which the plugin polls
local DASHBOARD_URL = "https://YOUR_DOMAIN.com/api/plugin"
local SESSION_TOKEN = "" -- set after connect

local HttpService = game:GetService("HttpService")
local Selection = game:GetService("Selection")

local function log(msg)
	if logsEnabled then
		print("[LuaForge] " .. msg)
	end
end

local function setStatus(connected)
	isConnected = connected
	if connected then
		statusBtn.Text = "Status 🟢"
		statusBtn.TextColor3 = Color3.fromRGB(74, 222, 128)
		infoLabel.Text = "Connected! AI code will inject automatically."
		connectBtn.Text = "Disconnect"
		connectBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
		connectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	else
		statusBtn.Text = "Status 🔴"
		statusBtn.TextColor3 = Color3.fromRGB(239, 68, 68)
		infoLabel.Text = "Open a project in the browser\nthen press Connect"
		connectBtn.Text = "Connect"
		connectBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
		connectBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
	end
end

local function injectCode(code, scriptName)
	scriptName = scriptName or "LuaForge_Generated"
	log("Injecting: " .. scriptName)

	-- Create a new LocalScript in StarterPlayerScripts
	local StarterPlayer = game:GetService("StarterPlayer")
	local target = StarterPlayer:FindFirstChild("StarterPlayerScripts")
		or game:GetService("StarterGui")

	local newScript = Instance.new("LocalScript")
	newScript.Name = scriptName
	newScript.Source = code
	newScript.Parent = target

	-- Select it in Studio explorer
	Selection:Set({newScript})

	codeText.Text = code
	codeBox.CanvasSize = UDim2.new(0, 0, 0, codeText.AbsoluteSize.Y + 12)

	injectBtn.Text = "✓ Injected!"
	injectBtn.BackgroundColor3 = Color3.fromRGB(74, 222, 128)
	task.delay(2.5, function()
		injectBtn.Text = "⚡  Inject into Studio"
		injectBtn.BackgroundColor3 = Color3.fromRGB(245, 200, 66)
	end)
	log("Script injected: " .. scriptName)
end

-- Poll the relay server for new code
local function startPolling()
	task.spawn(function()
		while isConnected do
			task.wait(2) -- poll every 2 seconds
			local ok, result = pcall(function()
				return HttpService:GetAsync(DASHBOARD_URL .. "/poll?token=" .. SESSION_TOKEN, true)
			end)
			if ok and result then
				local data = HttpService:JSONDecode(result)
				if data and data.code and data.code ~= "" then
					pendingCode = data.code
					codeText.Text = data.code
					codeBox.CanvasSize = UDim2.new(0, 0, 0, codeText.AbsoluteSize.Y + 12)
					log("New code received from dashboard")
				end
			end
		end
	end)
end

-- ========== BUTTON HANDLERS ==========

connectBtn.MouseButton1Click:Connect(function()
	if not isConnected then
		-- Try to connect
		local ok, result = pcall(function()
			return HttpService:GetAsync(DASHBOARD_URL .. "/status", true)
		end)
		if ok then
			local data = HttpService:JSONDecode(result)
			SESSION_TOKEN = data.token or ""
			setStatus(true)
			startPolling()
			log("Connected to LuaForge dashboard")
		else
			infoLabel.Text = "Could not connect.\nMake sure HTTP requests are enabled\nin Game Settings > Security."
			log("Connection failed: " .. tostring(result))
		end
	else
		setStatus(false)
		log("Disconnected")
	end
end)

injectBtn.MouseButton1Click:Connect(function()
	if pendingCode then
		injectCode(pendingCode, "LuaForge_" .. os.date("%H%M%S"))
	else
		infoLabel.Text = "No code to inject yet.\nGenerate code from the dashboard first."
	end
end)

logsBtn.MouseButton1Click:Connect(function()
	logsEnabled = not logsEnabled
	logsBtn.Text = logsEnabled and "Logs On" or "Logs Off"
	logsBtn.TextColor3 = logsEnabled
		and Color3.fromRGB(74, 222, 128)
		or Color3.fromRGB(136, 136, 153)
end)

toggleButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

-- ========== INIT ==========
setStatus(false)
widget.Enabled = true
print("[LuaForge] Plugin loaded. Open the LuaForge panel to get started.")

--[[
SETUP NOTES:
1. Enable HTTP Requests: Game Settings > Security > Allow HTTP Requests = ON
2. Replace DASHBOARD_URL with your actual backend URL
3. The backend needs two endpoints:
   GET /api/plugin/status  → returns { token: "..." }
   GET /api/plugin/poll?token=xxx → returns { code: "..." } or { code: "" }
4. When user clicks "Inject" on the dashboard, store the code in a DB keyed by token
   so the plugin can fetch it on the next poll
--]]
