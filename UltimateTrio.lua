-- UltimateTrio + Kill Aura (Four Separate Windows, Black Rounded)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- ========== Helper to create a window ==========
local function createWindow(title, titleColor, yOffset, toggleCallback)
    local gui = Instance.new("ScreenGui")
    gui.Name = title:gsub(" ", "") .. "Window"
    gui.Parent = game:GetService("CoreGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 80)
    frame.Position = UDim2.new(0.5, -110, 0.12 + yOffset, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.2
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = titleColor
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(1, -20, 0, 35)
    toggleBtn.Position = UDim2.new(0, 10, 0, 35)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    toggleBtn.Text = "🔴 OFF"
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextScaled = true
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

    -- Size changer
    local sizeBtn = Instance.new("TextButton", frame)
    sizeBtn.Size = UDim2.new(0.3, 0, 0, 20)
    sizeBtn.Position = UDim2.new(0.6, 0, 1, -25)
    sizeBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    sizeBtn.Text = "Size"
    sizeBtn.TextColor3 = Color3.new(1,1,1)
    sizeBtn.Font = Enum.Font.Gotham
    sizeBtn.TextSize = 12
    sizeBtn.TextScaled = true
    Instance.new("UICorner", sizeBtn).CornerRadius = UDim.new(0, 6)

    local sizes = {"Small", "Medium", "Large"}
    local sizeIdx = 2
    local function setSize(idx)
        if idx == 1 then frame.Size = UDim2.new(0,180,0,70)
        elseif idx == 2 then frame.Size = UDim2.new(0,220,0,80)
        else frame.Size = UDim2.new(0,280,0,90) end
        sizeBtn.Text = sizes[idx]
        sizeIdx = idx
    end
    setSize(2)
    sizeBtn.MouseButton1Click:Connect(function() setSize(sizeIdx % 3 + 1) end)

    local enabled = false
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggleBtn.Text = enabled and "🟢 ON" or "🔴 OFF"
        toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(0,100,0) or Color3.fromRGB(100,0,0)
        toggleCallback(enabled)
    end)

    return gui
end

-- ==================== KILL ALL ====================
local killAllEnabled = false
local lastKillAll = 0
local KILL_ALL_COOLDOWN = 0.001
local KILL_RADIUS = 1e6

local function instantKill(player)
    if not player or player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum.Health = 0 end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(0, -500, 0) end
end

RunService.RenderStepped:Connect(function()
    if not killAllEnabled then return end
    local now = tick()
    if now - lastKillAll < KILL_ALL_COOLDOWN then return end
    lastKillAll = now
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - myRoot.Position).Magnitude
                if dist <= KILL_RADIUS then instantKill(plr) end
            end
        end
    end
end)

-- ==================== GOD MODE ====================
local godEnabled = false
spawn(function()
    while true do
        task.wait(0.01)
        if godEnabled then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end
        end
    end
end)

-- ==================== TOUCH KILL ====================
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
    local player = Players:GetPlayerFromCharacter(other)
    if player then instantKill(player) end
end

local function connectTouches()
    for _, conn in ipairs(touchConnections) do conn:Disconnect() end
    touchConnections = {}
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
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

-- ==================== KILL AURA (DAMAGE 1e6, RADIUS 1e6) ====================
local killAuraEnabled = false
local lastKillAura = 0
local KILL_AURA_RADIUS = 1e6      -- radius tak terbatas
local KILL_AURA_DAMAGE = 1e6      -- damage 1.000.000
local KILL_AURA_COOLDOWN = 0.1

local function damagePlayer(player)
    if not player or player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum.Health = hum.Health - KILL_AURA_DAMAGE end
end

RunService.Heartbeat:Connect(function()
    if not killAuraEnabled then return end
    local now = tick()
    if now - lastKillAura < KILL_AURA_COOLDOWN then return end
    lastKillAura = now
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - myRoot.Position).Magnitude
                if dist <= KILL_AURA_RADIUS then
                    damagePlayer(plr)
                end
            end
        end
    end
end)

-- ==================== CREATE ALL WINDOWS ====================
createWindow("💀 KILL ALL", Color3.fromRGB(255, 0, 0), 0, function(v) killAllEnabled = v end)
createWindow("👼 GOD MODE", Color3.fromRGB(0, 255, 0), 0.1, function(v) godEnabled = v end)
createWindow("✋ TOUCH KILL", Color3.fromRGB(255, 165, 0), 0.2, function(v)
    touchEnabled = v
    if v then
        connectTouches()
    else
        for _, conn in ipairs(touchConnections) do conn:Disconnect() end
        touchConnections = {}
    end
end)
createWindow("⚔️ KILL AURA", Color3.fromRGB(128, 0, 255), 0.3, function(v)
    killAuraEnabled = v
end)

StarterGui:SetCore("SendNotification", { Title = "✅ Ultimate Pack", Text = "Four windows ready!", Duration = 3 })
