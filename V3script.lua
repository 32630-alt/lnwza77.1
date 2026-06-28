-- 1. ประกาศตัวแปรและตั้งค่าหลัก
local Players, Market, UIS = game:GetService("Players"), game:GetService("MarketplaceService"), game:GetService("UserInputService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local CurrentSound, CurrentSoundID, LoggedIDs = nil, nil, {}

if PlayerGui:FindFirstChild("Logger") then PlayerGui.Logger:Destroy() end

local Gui = Instance.new("ScreenGui", PlayerGui); Gui.Name = "Logger"; Gui.ResetOnSpawn = false

-- 2. ฟังก์ชันระบบลาก
local function MakeDraggable(obj)
    local dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position; startPos = obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragStart and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragStart = nil end end)
end

-- 3. สร้างปุ่มเมนูหลัก (ปรับเส้นขอบเป็นสีเทาเข้ม)
local ToggleBtn = Instance.new("TextButton", Gui)
ToggleBtn.Position = UDim2.new(0, 10, 0, 20)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- ดำมืด
ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200) -- เทาสว่าง
ToggleBtn.Text = "สคริปดักเพลงitlnwza77💀"
ToggleBtn.AutomaticSize = Enum.AutomaticSize.XY
ToggleBtn.Size = UDim2.new(0, 0, 0, 40)
ToggleBtn.BorderSizePixel = 0
local Stroke = Instance.new("UIStroke", ToggleBtn); Stroke.Color = Color3.fromRGB(80, 80, 80); Stroke.Thickness = 2 -- เส้นขอบเทาเข้ม
local Padding = Instance.new("UIPadding", ToggleBtn); Padding.PaddingLeft = UDim.new(0, 10); Padding.PaddingRight = UDim.new(0, 10)
MakeDraggable(ToggleBtn)

-- 4. สร้างหน้าต่างหลัก (ปรับสีพื้นหลังให้มืดลงอีก)
local Main = Instance.new("Frame", Gui); Main.Size = UDim2.new(0, 280, 0, 350); Main.Position = UDim2.new(0.5, -140, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderSizePixel = 0; Main.Visible = false; MakeDraggable(Main)

local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1, 0, 0, 30); Top.BackgroundTransparency = 1
local ResetBtn = Instance.new("TextButton", Top); ResetBtn.Size = UDim2.new(0.5, 0, 1, 0); ResetBtn.Text = "Reset"; ResetBtn.TextColor3 = Color3.fromRGB(200,200,200)
local CloseBtn = Instance.new("TextButton", Top); CloseBtn.Size = UDim2.new(0.5, 0, 1, 0); CloseBtn.Position = UDim2.new(0.5, 0, 0, 0); CloseBtn.Text = "Close"; CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 30); CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)

local Scroll = Instance.new("ScrollingFrame", Main); Scroll.Size = UDim2.new(1, 0, 1, -30); Scroll.Position = UDim2.new(0, 0, 0, 30); Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 6
local ListLayout = Instance.new("UIListLayout", Scroll)
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y) end)

-- 5. การจัดการอีเวนต์
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
CloseBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)
ResetBtn.MouseButton1Click:Connect(function() 
    for _,c in pairs(Scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    LoggedIDs = {}; Scroll.CanvasPosition = Vector2.new(0, 0) 
end)

-- 6. ฟังก์ชันสร้างช่องเพลง (ปรับสีให้ซอฟต์ลง)
local function AddSound(id, name)
    local btn = Instance.new("Frame", Scroll); btn.Size = UDim2.new(1, -10, 0, 90); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    local NameLabel = Instance.new("TextLabel", btn); NameLabel.Size = UDim2.new(1, -5, 0.25, 0); NameLabel.Position = UDim2.new(0, 5, 0, 0); NameLabel.Text = "Name: " .. name; NameLabel.TextColor3 = Color3.new(0.9,0.9,0.9); NameLabel.BackgroundTransparency = 1; NameLabel.TextScaled = true; NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    local IDLabel = Instance.new("TextLabel", btn); IDLabel.Size = UDim2.new(1, -5, 0.25, 0); IDLabel.Position = UDim2.new(0, 5, 0.25, 0); IDLabel.Text = "ID: " .. id; IDLabel.TextColor3 = Color3.fromRGB(200, 200, 50); IDLabel.BackgroundTransparency = 1; IDLabel.TextScaled = true; IDLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local PlayBtn = Instance.new("TextButton", btn); PlayBtn.Size = UDim2.new(0.5, 0, 0.4, 0); PlayBtn.Position = UDim2.new(0, 0, 0.6, 0); PlayBtn.Text = "Play"; PlayBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
    local Del = Instance.new("TextButton", btn); Del.Size = UDim2.new(0.5, 0, 0.4, 0); Del.Position = UDim2.new(0.5, 0, 0.6, 0); Del.Text = "Remove"; Del.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
    
    PlayBtn.MouseButton1Click:Connect(function()
        if CurrentSound and CurrentSoundID == id then
            CurrentSound:Stop(); CurrentSound:Destroy(); CurrentSound = nil; CurrentSoundID = nil
            PlayBtn.Text = "Play"; PlayBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
        else
            if CurrentSound then CurrentSound:Stop(); CurrentSound:Destroy() end
            CurrentSound = Instance.new("Sound", workspace); CurrentSound.SoundId = "rbxassetid://" .. id; CurrentSound:Play()
            CurrentSoundID = id
            PlayBtn.Text = "หยุด"; PlayBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        end
    end)
    Del.MouseButton1Click:Connect(function() LoggedIDs[id] = nil; btn:Destroy() end)
end

-- 7. ระบบตรวจจับ
game.DescendantAdded:Connect(function(s)
    if s:IsA("Sound") and s.SoundId ~= "" then
        local id = s.SoundId:match("%d+")
        if id and not LoggedIDs[id] then
            LoggedIDs[id] = true
            local name = "Unknown"
            pcall(function() name = Market:GetProductInfo(id).Name end)
            AddSound(id, name)
        end
    end
end)
