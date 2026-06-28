-- [1. INITIALIZATION]
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local previewSound = Instance.new("Sound", game.SoundService)

-- [2. CORE LOGIC: ดึง ID จากลำโพง]
local function getSongID(plr)
    if not plr.Character then return nil end
    local character = plr.Character
    local boombox = character:FindFirstChildOfClass("Tool") or character:FindFirstChild("Boombox", true)
    if boombox then
        local sound = boombox:FindFirstChild("Handle") and boombox.Handle:FindFirstChildOfClass("Sound")
        if sound and sound.SoundId then return string.match(sound.SoundId, "%d+") end
    end
    return nil
end

-- [3. GUI SETUP]
if playerGui:FindFirstChild("HonkukiScanner") then playerGui.HonkukiScanner:Destroy() end
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "HonkukiScanner"

-- Toggle Button (สี่เหลี่ยมดำขอบขาว)
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 180, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0, 20)
toggleBtn.Text = "สคริปดักเพลงlnwxa77💀"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
toggleBtn.BorderSizePixel = 2
toggleBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 240, 0, 420)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
toggleBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

-- [4. UI ELEMENTS]
-- Title
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "lnwza77 ค้าบบ อ้วนน"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20

-- Scroll List
local scrollList = Instance.new("ScrollingFrame", mainFrame)
scrollList.Size = UDim2.new(0.9, 0, 0.35, 0)
scrollList.Position = UDim2.new(0.05, 0, 0.1, 0)
scrollList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scrollList.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", scrollList).Padding = UDim.new(0, 2)

-- ID Display
local idLabel = Instance.new("TextLabel", mainFrame)
idLabel.Size = UDim2.new(0.9, 0, 0, 30)
idLabel.Position = UDim2.new(0.05, 0, 0.48, 0)
idLabel.Text = "เลือกผู้เล่น"
idLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
idLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- [5. FUNCTIONS]
local selectedPlayer = nil

local function updateList()
    selectedPlayer = nil
    for _, v in pairs(scrollList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local btn = Instance.new("TextButton", scrollList)
        btn.Size = UDim2.new(1, -5, 0, 30)
        btn.Text = p.DisplayName .. " (@" .. p.Name .. ")"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.MouseButton1Click:Connect(function()
            selectedPlayer = p
            for _, c in pairs(scrollList:GetChildren()) do if c:IsA("TextButton") then c.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end end
            btn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            idLabel.Text = getSongID(p) or "ไม่พบเพลง"
        end)
    end
end

local function createButton(text, pos, callback)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(callback)
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
end

-- [6. BUTTON ASSIGNMENTS]
createButton("คัดลอกไอดี", UDim2.new(0.05, 0, 0.58, 0), function()
    local id = selectedPlayer and getSongID(selectedPlayer)
    if id then setclipboard(id) idLabel.Text = "คัดลอก: " .. id end
end)
createButton("เล่นเพลง (ลองฟัง)", UDim2.new(0.05, 0, 0.68, 0), function()
    local id = selectedPlayer and getSongID(selectedPlayer)
    if id then previewSound.SoundId = "rbxassetid://" .. id; previewSound:Play(); idLabel.Text = "กำลังเล่น: " .. id end
end)
createButton("หยุดเพลง", UDim2.new(0.05, 0, 0.78, 0), function() previewSound:Stop(); idLabel.Text = "หยุดเล่นแล้ว" end)
createButton("รีเซ็ต/อัปเดต", UDim2.new(0.05, 0, 0.88, 0), updateList)

updateList()
