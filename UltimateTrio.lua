-- UltimateTrio.lua (Kill All + God Mode + Touch Kill)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "UltimateTrio"
gui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1,0,0,35)
titleBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1,-50,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "ULTIMATE TRIO"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", titleBar)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0.5,-15)
close.BackgroundColor3 = Color3.fromRGB(200,0,0)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.TextSize = 16
Instance.new("UICorner", close).CornerRadius = UDim.new(0,8)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Tab buttons
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(1,0,0,35)
tabFrame.Position = UDim2.new(0,0,0,35)
tabFrame.BackgroundTransparency = 1

local tabs = {}
local currentTab = "KillAll"

local function setTab(name)
    for k, v in pairs(tabs) do v.Visible = (k == name) end
    currentTab = name
end

local function addTab(name, x)
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(0.333,0,1,0)
    btn.Position = UDim2.new(x,0,0,0)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    btn.MouseButton1Click:Connect(function() setTab(name) end)
end

addTab("💀 Kill All", 0)
addTab("👼 God Mode", 0.333)
addTab("✋ Touch Kill", 0.666)

local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1,-20,1,-85)
content.Position = UDim2.new(0,10,0,75)
content.BackgroundTransparency = 1

-- ========== KILL ALL ==========
local killAllFrame = Instance.new("Frame", content)
killAllFrame.Size = UDim2.new(1,0,1,0)
killAllFrame.BackgroundTransparency = 1
killAllFrame.Visible = true
tabs["KillAll"] = killAllFrame

local killAllEnabled = false
local killAllLastTime = 0
local KILL_COOLDOWN = 0.001
local KILL_RADIUS = 1e6

local function killPlayer(p)
    if not p or p == LocalPlayer then return end
    local c = p.Character
    if not c then return end
    local h = c:FindFirstChild("Humanoid")
    if h then h.Health = 0 end
    local r = c:FindFirstChild("HumanoidRootPart")
    if r then r.CFrame = CFrame.new(0,-500,0) end
end

RunService.RenderStepped:Connect(function()
    if not killAllEnabled then return end
    local now = tick()
    if now - killAllLastTime < KILL_COOLDOWN then return end
    killAllLastTime = now
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - myRoot.Position).Magnitude
                if dist <= KILL_RADIUS then killPlayer(plr) end
            end
        end
    end
end)

local killToggle = Instance.new("TextButton", killAllFrame)
killToggle.Size = UDim2.new(1,0,0,45)
killToggle.Position = UDim2.new(0,0,0,20)
killToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
killToggle.Text = "🔴 KILL ALL: OFF"
killToggle.TextColor3 = Color3.new(1,1,1)
killToggle.Font = Enum.Font.GothamBold
killToggle.TextScaled = true
Instance.new("UICorner", killToggle).CornerRadius = UDim.new(0,8)
killToggle.MouseButton1Click:Connect(function()
    killAllEnabled = not killAllEnabled
    killToggle.Text = killAllEnabled and "🟢 KILL ALL: ON" or "🔴 KILL ALL: OFF"
    killToggle.BackgroundColor3 = killAllEnabled and Color3.fromRGB(0,100,0) or Color3.fromRGB(100,0,0)
end)

local radiusLabel = Instance.new("TextLabel", killAllFrame)
radiusLabel.Size = UDim2.new(1,0,0,20)
radiusLabel.Position = UDim2.new(0,0,0,80)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Text = "Radius: Unlimited"
radiusLabel.TextColor3 = Color3.new(1,1,1)
radiusLabel.Font = Enum.Font.Gotham
radiusLabel.TextSize = 14

-- ========== GOD MODE ==========
local godFrame = Instance.new("Frame", content)
godFrame.Size = UDim2.new(1,0,1,0)
godFrame.BackgroundTransparency = 1
godFrame.Visible = false
tabs["God Mode"] = godFrame

local godEnabled = false
spawn(function()
    while true do
        task.wait(0.01)
        if godEnabled then
            local c = LocalPlayer.Character
            if c then
                local h = c:FindFirstChild("Humanoid")
                if h and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
            end
        end
    end
end)

local godToggle = Instance.new("TextButton", godFrame)
godToggle.Size = UDim2.new(1,0,0,45)
godToggle.Position = UDim2.new(0,0,0,20)
godToggle.BackgroundColor3 = Color3.fromRGB(100,0,100)
godToggle.Text = "🔴 GOD MODE: OFF"
godToggle.TextColor3 = Color3.new(1,1,1)
godToggle.Font = Enum.Font.GothamBold
godToggle.TextScaled = true
Instance.new("UICorner", godToggle).CornerRadius = UDim.new(0,8)
godToggle.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    godToggle.Text = godEnabled and "🟢 GOD MODE: ON" or "🔴 GOD MODE: OFF"
    godToggle.BackgroundColor3 = godEnabled and Color3.fromRGB(0,100,0) or Color3.fromRGB(100,0,100)
end)

-- ========== TOUCH KILL ==========
local touchFrame = Instance.new("Frame", content)
touchFrame.Size = UDim2.new(1,0,1,0)
touchFrame.BackgroundTransparency = 1
touchFrame.Visible = false
tabs["Touch Kill"] = touchFrame

local touchEnabled = false
local lastTouch = 0
local TOUCH_COOLDOWN = 0.01
local touchConnections = {}

local function onTouch(part)
    if not touchEnabled then return end
    local now = tick()
    if now - lastTouch < TOUCH_COOLDOWN then return end
    lastTouch = now
    local other = part:FindFirstAncestorOfClass("Model")
    if not other then return end
    local p = Players:GetPlayerFromCharacter(other)
    if p then killPlayer(p) end
end

local function connectTouches()
    for _, c in ipairs(touchConnections) do c:Disconnect() end
    touchConnections = {}
    local c = LocalPlayer.Character
    if not c then return end
    for _, part in ipairs(c:GetDescendants()) do
        if part:IsA("BasePart") then
            local conn = part.Touched:Connect(onTouch)
            table.insert(touchConnections, conn)
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    if touchEnabled then
        task.wait(0.5)
        connectTouches()
    end
end)

local touchToggle = Instance.new("TextButton", touchFrame)
touchToggle.Size = UDim2.new(1,0,0,45)
touchToggle.Position = UDim2.new(0,0,0,20)
touchToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
touchToggle.Text = "🔴 TOUCH KILL: OFF"
touchToggle.TextColor3 = Color3.new(1,1,1)
touchToggle.Font = Enum.Font.GothamBold
touchToggle.TextScaled = true
Instance.new("UICorner", touchToggle).CornerRadius = UDim.new(0,8)
touchToggle.MouseButton1Click:Connect(function()
    touchEnabled = not touchEnabled
    touchToggle.Text = touchEnabled and "🟢 TOUCH KILL: ON" or "🔴 TOUCH KILL: OFF"
    touchToggle.BackgroundColor3 = touchEnabled and Color3.fromRGB(0,100,0) or Color3.fromRGB(100,0,0)
    if touchEnabled then
        connectTouches()
    else
        for _, c in ipairs(touchConnections) do c:Disconnect() end
        touchConnections = {}
    end
end)

-- Selesai
StarterGui:SetCore("SendNotification", { Title = "✅ UltimateTrio", Text = "Loaded!", Duration = 3 })
