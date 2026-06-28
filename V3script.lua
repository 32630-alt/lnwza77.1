-- [SCENE SCANNER - เวอร์ชั่นเสถียร]
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ฟังก์ชันดึง ID จาก Object ลำโพงในแมพ (วิธีนี้จะแม่นยำกว่าการดัก Network)
local function getSongID(plr)
    if not plr.Character then return nil end
    -- ค้นหา Sound ในตัวละครหรือในลำโพงที่ถืออยู่
    local character = plr.Character
    local boombox = character:FindFirstChildOfClass("Tool") or character:FindFirstChild("Boombox", true)
    if boombox then
        local sound = boombox:FindFirstChild("Handle") and boombox.Handle:FindFirstChildOfClass("Sound")
        if sound and sound.SoundId then
            return string.match(sound.SoundId, "%d+")
        end
    end
    return nil
end

-- [GUI SETUP]
if playerGui:FindFirstChild("HonkukiScanner") then playerGui.HonkukiScanner:Destroy() end
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "HonkukiScanner"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 240, 0, 360)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local scrollList = Instance.new("ScrollingFrame", mainFrame)
scrollList.Size = UDim2.new(0.9, 0, 0.4, 0)
scrollList.Position = UDim2.new(0.05, 0, 0.05, 0)
scrollList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scrollList.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", scrollList).Padding = UDim.new(0, 2)

local idLabel = Instance.new("TextLabel", mainFrame)
idLabel.Size = UDim2.new(0.9, 0, 0, 30)
idLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
idLabel.Text = "เลือกผู้เล่น"
idLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
idLabel.TextColor3 = Color3.new(1, 1, 1)

-- [LIST LOGIC]
local selectedPlayer = nil

local function updateList()
    selectedPlayer = nil
    for _, v in pairs(scrollList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    
    for _, p in pairs(Players:GetPlayers()) do
        local btn = Instance.new("TextButton", scrollList)
        btn.Size = UDim2.new(1, -5, 0, 30)
        btn.Text = p.DisplayName .. " (@" .. p.Name .. ")"
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        btn.MouseButton1Click:Connect(function()
            selectedPlayer = p
            -- รีเซ็ตสีปุ่ม
            for _, c in pairs(scrollList:GetChildren()) do if c:IsA("TextButton") then c.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end end
            btn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            
            -- ดึง ID สดๆ จากตัวละคร
            local foundID = getSongID(p)
            idLabel.Text = foundID or "ไม่พบเพลง"
        end)
    end
end

-- [BUTTONS]
local function createButton(text, pos, callback)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
end

createButton("คัดลอกไอดี", UDim2.new(0.05, 0, 0.62, 0), function()
    if selectedPlayer then
        local id = getSongID(selectedPlayer)
        if id then
            setclipboard(id)
            idLabel.Text = "คัดลอก: " .. id
        else
            idLabel.Text = "ไม่มีเพลง"
        end
    end
end)

createButton("รีเซ็ต/อัปเดต", UDim2.new(0.05, 0, 0.76, 0), updateList)
createButton("WHITELIST", UDim2.new(0.05, 0, 0.90, 0), function() end)

-- [TOGGLE]
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0, 100)
toggleBtn.Text = "💩"
toggleBtn.Parent = screenGui
toggleBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

updateList()
