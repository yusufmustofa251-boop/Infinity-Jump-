-- ONYX CLEAN GOD 👑🔥

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- ================= CONTAINER (KIRI) =================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,140,0,220)
frame.Position = UDim2.new(0.02,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

-- ================= TITLE =================
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "ONYX 👑"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,0,80)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- ================= BUTTON FUNCTION =================
local function createBtn(text, y, callback)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.9,0,0,40)
	b.Position = UDim2.new(0.05,0,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)

	-- animasi klik
	b.MouseButton1Click:Connect(function()
		b:TweenSize(UDim2.new(0.85,0,0,35),"Out","Quad",0.05,true)
		task.wait(0.05)
		b:TweenSize(UDim2.new(0.9,0,0,40),"Out","Quad",0.05,true)
		callback()
	end)

	return b
end

-- ================= BUTTONS =================
createBtn("RUN ONYX",0.2,function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/yusufmustofa251-boop/Infinity-Jump-/main/onyx_visual_final.lua"))()
end)

createBtn("RELOAD",0.45,function()
	gui:Destroy()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/yusufmustofa251-boop/Infinity-Jump-/main/onyx_clean_loader.lua"))()
end)

createBtn("CLOSE",0.7,function()
	gui:Destroy()
end)
