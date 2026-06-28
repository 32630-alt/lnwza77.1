local Players = game:GetService("Players")
local Market = game:GetService("MarketplaceService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ล้างของเก่าและตั้งค่าเริ่มต้น
if PlayerGui:FindFirstChild("Logger") then PlayerGui.Logger:Destroy() end

local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "Logger"
Gui.ResetOnSpawn = false

-- ปุ่มเปิด/ปิด
local Btn = Instance.new("TextButton", Gui)
Btn.Size = UDim2.new(0, 60, 0, 60)
Btn.Position = UDim2.new(0, 20, 0.5, -30)
Btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
Btn.Text = "สคริปดักlnwza77"
Btn.Draggable = true

-- หน้าต่างหลัก
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Position = UDim2.new(0.5, -160, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Visible = false
Main.Draggable = true

-- หัวข้อ
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "สคริปดักโดยitlnwza77"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1

-- แถบ Reset / Kill
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.Position = UDim2.new(0, 0, 0, 30)
TopBar.BackgroundTransparency = 1

local ResetBtn = Instance.new("TextButton", TopBar)
ResetBtn.Size = UDim2.new(0, 70, 0, 30)
ResetBtn.Position = UDim2.new(0, 5, 0, 5)
ResetBtn.Text = "Reset"

local KillBtn = Instance.new("TextButton", TopBar)
KillBtn.Size = UDim2.new(0, 70, 0, 30)
KillBtn.Position = UDim2.new(1, -75, 0, 5)
KillBtn.Text = "Kill"
KillBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

-- รายการเพลง
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -70)
Scroll.Position = UDim2.new(0, 0, 0, 70)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 8
local Layout = Instance.new("UIListLayout", Scroll)
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
end)

local loggedIDs = {}
local currentSound = nil

-- ฟังก์ชันเพิ่มเพลง
local function AddSound(sound)
    if not sound:IsA("Sound") or sound.SoundId == "" then return end
    local id = sound.SoundId:match("%d+")
    if not id or loggedIDs[id] then return end
    loggedIDs[id] = true
    
    local owner = "Map/System"
    local char = sound:FindFirstAncestorWhichIsA("Model")
    if char and Players:GetPlayerFromCharacter(char) then owner = char.Name end
    
    local btn = Instance.new("Frame", Scroll)
    btn.Size = UDim2.new(1, -10, 0, 130)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    local OwnerLabel = Instance.new("TextLabel", btn)
    OwnerLabel.Size = UDim2.new(1, 0, 0.2, 0)
    OwnerLabel.Text = "Owner: " .. owner
    OwnerLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    OwnerLabel.BackgroundTransparency = 1
    
    local NameLabel = Instance.new("TextLabel", btn)
    NameLabel.Size = UDim2.new(1, 0, 0.2, 0)
    NameLabel.Position = UDim2.new(0, 0, 0.2, 0)
    NameLabel.Text = "Loading..."
    NameLabel.TextColor3 = Color3.new(1, 1, 1)
    NameLabel.BackgroundTransparency = 1
    
    task.spawn(function()
        local s, i = pcall(function() return Market:GetProductInfo(id) end)
        NameLabel.Text = (s and i) and i.Name or "Unknown"
    end)
    
    local IDLabel = Instance.new("TextLabel", btn)
    IDLabel.Size = UDim2.new(1, 0, 0.2, 0)
    IDLabel.Position = UDim2.new(0, 0, 0.4, 0)
    IDLabel.Text = id
    IDLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    IDLabel.BackgroundTransparency = 1
    
    local Copy = Instance.new("TextButton", btn)
    Copy.Size = UDim2.new(0.45, 0, 0.25, 0)
    Copy.Position = UDim2.new(0.05, 0, 0.65, 0)
    Copy.Text = "Copy ID"
    Copy.MouseButton1Click:Connect(function() setclipboard(id) end)
    
    local Play = Instance.new("TextButton", btn)
    Play.Size = UDim2.new(0.45, 0, 0.25, 0)
    Play.Position = UDim2.new(0.5, 0, 0.65, 0)
    Play.Text = "Play"
    Play.MouseButton1Click:Connect(function()
        if currentSound and currentSound.SoundId == ("rbxassetid://" .. id) then
            currentSound:Stop() currentSound:Destroy() currentSound = nil
            Play.Text = "Play"
        else
            if currentSound then currentSound:Stop() currentSound:Destroy() end
            currentSound = Instance.new("Sound", workspace)
            currentSound.SoundId = "rbxassetid://" .. id
            currentSound:Play()
            Play.Text = "Stop"
        end
    end)
end

-- Events
Btn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
KillBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)
ResetBtn.MouseButton1Click:Connect(function() 
    for _, c in pairs(Scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end 
    loggedIDs = {}
end)

game.DescendantAdded:Connect(function(d) if d:IsA("Sound") then AddSound(d) end end)
for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Sound") then AddSound(v) end end
