local player = game.Players.LocalPlayer
local ownerName = "unknown6789041"
local isOwner = (player.Name == ownerName)

-- CHAR SAFE
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
end)

-- STATE
local god, jump, fly, invisible = false,false,false,false
local speed = 16
local savedPos
local flyForce

-- 👻 STEALTH FUNCTION
local function setInvisible(state)
    if not char then return end

    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = state and 0.85 or 0
        end
        if v:IsA("Decal") then
            v.Transparency = state and 1 or 0
        end
    end

    if hum then
        hum.DisplayDistanceType = state and Enum.HumanoidDisplayDistanceType.None 
        or Enum.HumanoidDisplayDistanceType.Viewer
    end
end

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,380,0,320)
frame.Position = UDim2.new(0.5,-190,0.5,-160)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0.1,0)
title.Text = "ONYX FINAL 👑"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

-- MINIMIZE
local mini = Instance.new("TextButton", frame)
mini.Size = UDim2.new(0,25,0,25)
mini.Position = UDim2.new(1,-30,0,5)
mini.Text = "-"
mini.BackgroundColor3 = Color3.fromRGB(150,40,40)

local minimized = false
mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in pairs(frame:GetChildren()) do
        if v ~= title and v ~= mini then
            v.Visible = not minimized
        end
    end
end)

-- TAB
local function tabBtn(text,pos)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.25,0,0.1,0)
    b.Position = pos
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(120,30,30)
    Instance.new("UICorner", b)
    return b
end

local mainTab = tabBtn("Main",UDim2.new(0,0,0.1,0))
local funTab = tabBtn("Fun",UDim2.new(0.25,0,0.1,0))
local playerTab = tabBtn("Player",UDim2.new(0.5,0,0.1,0))
local settingsTab = tabBtn("Settings",UDim2.new(0.75,0,0.1,0))

-- CONTAINER
local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1,0,0.75,0)
container.Position = UDim2.new(0,0,0.25,0)
container.BackgroundTransparency = 1

local function clear()
    for _,v in pairs(container:GetChildren()) do v:Destroy() end
end

local function makeBtn(text,y)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(0.8,0,0.15,0)
    b.Position = UDim2.new(0.1,0,y,0)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(70,30,30)
    Instance.new("UICorner", b)
    return b
end

-- MAIN
local function loadMain()
    clear()

    local godBtn = makeBtn("God OFF",0)
    godBtn.MouseButton1Click:Connect(function()
        god = not god
        godBtn.Text = "God: "..(god and "ON" or "OFF")
    end)

    local speedBtn = makeBtn("Speed 16",0.2)
    speedBtn.MouseButton1Click:Connect(function()
        speed+=5 if speed>120 then speed=16 end
        speedBtn.Text="Speed "..speed
        if hum then hum.WalkSpeed=speed end
    end)

    local jumpBtn = makeBtn("Jump OFF",0.4)
    jumpBtn.MouseButton1Click:Connect(function()
        jump=not jump
        jumpBtn.Text="Jump "..(jump and "ON" or "OFF")
    end)

    game:GetService("UserInputService").JumpRequest:Connect(function()
        if jump and hum then hum:ChangeState("Jumping") end
    end)

    local flyBtn = makeBtn("Fly OFF",0.6)
    flyBtn.MouseButton1Click:Connect(function()
        fly=not fly
        flyBtn.Text="Fly "..(fly and "ON" or "OFF")

        if fly and root then
            flyForce = Instance.new("BodyVelocity", root)
            flyForce.MaxForce = Vector3.new(99999,99999,99999)
            flyForce.Velocity = Vector3.new(0,50,0)
        else
            if flyForce then flyForce:Destroy() end
        end
    end)

    local invisBtn = makeBtn("Invisible OFF",0.8)
    invisBtn.MouseButton1Click:Connect(function()
        invisible=not invisible
        invisBtn.Text="Invisible "..(invisible and "ON" or "OFF")
        setInvisible(invisible)
    end)
end

-- FUN
local function loadFun()
    clear()

    local save = makeBtn("Save Checkpoint",0.2)
    save.MouseButton1Click:Connect(function()
        if root then savedPos = root.CFrame end
    end)

    local load = makeBtn("Load Checkpoint",0.5)
    load.MouseButton1Click:Connect(function()
        if savedPos and root then root.CFrame = savedPos end
    end)
end

-- PLAYER
local function loadPlayer()
    clear()

    local box = Instance.new("TextBox", container)
    box.Size = UDim2.new(0.8,0,0.2,0)
    box.Position = UDim2.new(0.1,0,0,0)
    box.PlaceholderText = "Nama Player..."
    Instance.new("UICorner", box)

    local tp = makeBtn("Teleport",0.3)
    tp.MouseButton1Click:Connect(function()
        local t = game.Players:FindFirstChild(box.Text)
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            root.CFrame = t.Character.HumanoidRootPart.CFrame
        end
    end)

    local fling = makeBtn("Fling",0.6)
    fling.MouseButton1Click:Connect(function()
        root.Velocity = Vector3.new(9999,9999,9999)
    end)
end

-- SETTINGS
local function loadSettings()
    clear()

    local reset = makeBtn("RESET ALL",0.3)
    reset.MouseButton1Click:Connect(function()
        god=false jump=false fly=false invisible=false
        speed=16
        setInvisible(false)
        if hum then hum.WalkSpeed=16 end
    end)
end

-- CONNECT
mainTab.MouseButton1Click:Connect(loadMain)
funTab.MouseButton1Click:Connect(loadFun)
playerTab.MouseButton1Click:Connect(loadPlayer)
settingsTab.MouseButton1Click:Connect(loadSettings)

-- GOD LOOP
game:GetService("RunService").RenderStepped:Connect(function()
    if god and hum then hum.Health = hum.MaxHealth end
end)

-- 👑 SHADOW COMMAND
local prefix = "#onyx_"
player.Chatted:Connect(function(msg)
    if not isOwner then return end
    msg = msg:lower()

    if msg == prefix.."ui" then frame.Visible = not frame.Visible end
    if msg == prefix.."god" then god = true end
    if msg == prefix.."speed" then speed=120 if hum then hum.WalkSpeed=120 end end
    if msg == prefix.."ghost" then invisible=true setInvisible(true) end
    if msg == prefix.."reset" then
        speed=16 god=false invisible=false
        setInvisible(false)
        if hum then hum.WalkSpeed=16 end
    end
end)

loadMain()
