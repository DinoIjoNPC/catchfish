-- ============================================
-- CATCH A ANOMALI FISH v10.0
-- AUTO RESIZE (DPI Mobile) + UI FIX
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local giveToolEvent = ReplicatedStorage:WaitForChild("GiveTool")

-- ============================================
-- AUTO RESIZE berdasarkan DPI / Screen Size
-- ============================================
local screenSize = Workspace.CurrentCamera.ViewportSize
local dpi = math.min(screenSize.X, screenSize.Y)

local scale = 1
if dpi < 500 then
    scale = 0.6
elseif dpi < 700 then
    scale = 0.75
elseif dpi < 900 then
    scale = 0.9
else
    scale = 1
end

local GUI_WIDTH = math.floor(320 * scale)
local GUI_HEIGHT = math.floor(380 * scale)
local FONT_SIZE = math.floor(11 * scale)
local SMALL_FONT = math.floor(9 * scale)
local TITLE_SIZE = math.floor(12 * scale)

-- ============================================
-- DETECT REMOTES
-- ============================================
local remoteEvents = {}
local remoteFunctions = {}

for _, child in ipairs(ReplicatedStorage:GetChildren()) do
    if child:IsA("RemoteEvent") then
        table.insert(remoteEvents, child)
    elseif child:IsA("RemoteFunction") then
        table.insert(remoteFunctions, child)
    end
end

local function findBestRemote()
    local keywords = {"Money", "Add", "Give", "Set", "Update", "Stat", "Leader", "Cash", "Coin", "Gold"}
    for _, kw in ipairs(keywords) do
        for _, remote in ipairs(remoteEvents) do
            if string.find(remote.Name, kw) then
                return remote, "Event"
            end
        end
        for _, remote in ipairs(remoteFunctions) do
            if string.find(remote.Name, kw) then
                return remote, "Function"
            end
        end
    end
    if #remoteEvents > 0 then
        return remoteEvents[1], "Event"
    elseif #remoteFunctions > 0 then
        return remoteFunctions[1], "Function"
    end
    return nil, nil
end

-- ============================================
-- NOCLIP BODY VARIABLES
-- ============================================
local noclipActive = false
local noclipConnection = nil

-- ============================================
-- GUI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CatchAnomaliGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, GUI_WIDTH, 0, GUI_HEIGHT)
mainFrame.Position = UDim2.new(0.5, -(GUI_WIDTH/2), 0.5, -(GUI_HEIGHT/2))
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
mainFrame.Active = true

-- ============================================
-- DRAG SYSTEM
-- ============================================
local isDragging = false
local dragStart = nil
local dragFrameStart = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        dragFrameStart = mainFrame.Position
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

mainFrame.TouchBegan:Connect(function(touch)
    isDragging = true
    dragStart = touch.Position
    dragFrameStart = mainFrame.Position
end)

mainFrame.TouchMoved:Connect(function(touch)
    if isDragging then
        local delta = touch.Position - dragStart
        mainFrame.Position = UDim2.new(
            dragFrameStart.X.Scale,
            dragFrameStart.X.Offset + delta.X,
            dragFrameStart.Y.Scale,
            dragFrameStart.Y.Offset + delta.Y
        )
    end
end)

mainFrame.TouchEnded:Connect(function()
    isDragging = false
end)

mainFrame.TouchCanceled:Connect(function()
    isDragging = false
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                       input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            dragFrameStart.X.Scale,
            dragFrameStart.X.Offset + delta.X,
            dragFrameStart.Y.Scale,
            dragFrameStart.Y.Offset + delta.Y
        )
    end
end)

-- ============================================
-- SHADOW
-- ============================================
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316043491"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)
shadow.Parent = mainFrame

-- ============================================
-- TITLE BAR
-- ============================================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, math.floor(28 * scale))
titleBar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 8, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "ANOMALI FISH"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = TITLE_SIZE
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, math.floor(24 * scale), 0, math.floor(24 * scale))
minBtn.Position = UDim2.new(1, -math.floor(28 * scale), 0, math.floor(2 * scale))
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minBtn.BorderSizePixel = 0
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = TITLE_SIZE
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar

-- ============================================
-- TAB BUTTONS
-- ============================================
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, math.floor(28 * scale))
tabContainer.Position = UDim2.new(0, 0, 0, math.floor(28 * scale))
tabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabs = {}
local tabData = {
    {name = "Fish", id = "tab1"},
    {name = "Pick", id = "tab2"},
    {name = "Sell", id = "tab3"},
    {name = "Money", id = "tab4"},
    {name = "Set", id = "tab5"}
}

for i, data in ipairs(tabData) do
    local btn = Instance.new("TextButton")
    btn.Name = data.id
    btn.Size = UDim2.new(0, math.floor(56 * scale), 1, -math.floor(4 * scale))
    btn.Position = UDim2.new(0, math.floor(4 * scale + (i-1) * 60 * scale), 0, math.floor(2 * scale))
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 0
    btn.Text = data.name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = math.floor(8 * scale)
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = tabContainer
    
    local line = Instance.new("Frame")
    line.Name = "Indicator"
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    line.BackgroundTransparency = 1
    line.Parent = btn
    
    tabs[data.id] = {btn = btn, line = line}
end

-- ============================================
-- CONTENT FRAME
-- ============================================
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -math.floor(12 * scale), 1, -math.floor(68 * scale))
contentFrame.Position = UDim2.new(0, math.floor(6 * scale), 0, math.floor(60 * scale))
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ============================================
-- TAB 1: AUTO FISH
-- ============================================
local tab1 = Instance.new("Frame")
tab1.Size = UDim2.new(1, 0, 1, 0)
tab1.BackgroundTransparency = 1
tab1.Visible = false
tab1.Parent = contentFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, math.floor(160 * scale), 0, math.floor(30 * scale))
toggleBtn.Position = UDim2.new(0.5, -math.floor(80 * scale), 0, math.floor(4 * scale))
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "▶ START FISH"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = FONT_SIZE
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = tab1

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(18 * scale))
statusLabel.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(40 * scale))
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = FONT_SIZE
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = tab1

local queueLabel = Instance.new("TextLabel")
queueLabel.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(16 * scale))
queueLabel.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(60 * scale))
queueLabel.BackgroundTransparency = 1
queueLabel.Text = "Queue: 0/5 | Speed: 0s"
queueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
queueLabel.TextSize = SMALL_FONT
queueLabel.Font = Enum.Font.Gotham
queueLabel.TextXAlignment = Enum.TextXAlignment.Left
queueLabel.Parent = tab1

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(14 * scale))
keyLabel.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(78 * scale))
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "F toggle"
keyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
keyLabel.TextSize = math.floor(8 * scale)
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = tab1

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(16 * scale))
speedLabel.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(100 * scale))
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "LOOP SPEED"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
speedLabel.TextSize = SMALL_FONT
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = tab1

local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(28 * scale))
speedContainer.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(118 * scale))
speedContainer.BackgroundTransparency = 1
speedContainer.Parent = tab1

local speedOptions = {0, 1, 1.5}
local selectedSpeed = 0
local speedButtons = {}

for i, val in ipairs(speedOptions) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, math.floor(70 * scale), 1, 0)
    btn.Position = UDim2.new(0, (i-1) * math.floor(75 * scale), 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BorderSizePixel = 0
    btn.Text = val .. "s"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = FONT_SIZE
    btn.Font = Enum.Font.GothamBold
    btn.Parent = speedContainer
    
    if val == selectedSpeed then
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    speedButtons[val] = btn
    
    btn.MouseButton1Click:Connect(function()
        selectedSpeed = val
        for speed, button in pairs(speedButtons) do
            if speed == val then
                button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        queueLabel.Text = "Queue: 0/5 | Speed: " .. val .. "s"
        if autoFishRunning then
            processInterval = val + 0.5
            if processInterval < 0.5 then processInterval = 0.5 end
        end
    end)
end

-- ============================================
-- TAB 2: AUTO PICK
-- ============================================
local tab2 = Instance.new("Frame")
tab2.Size = UDim2.new(1, 0, 1, 0)
tab2.BackgroundTransparency = 1
tab2.Visible = false
tab2.Parent = contentFrame

local pickToggle = Instance.new("TextButton")
pickToggle.Size = UDim2.new(0, math.floor(160 * scale), 0, math.floor(30 * scale))
pickToggle.Position = UDim2.new(0.5, -math.floor(80 * scale), 0, math.floor(8 * scale))
pickToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
pickToggle.BorderSizePixel = 0
pickToggle.Text = "▶ AUTO PICK"
pickToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
pickToggle.TextSize = FONT_SIZE
pickToggle.Font = Enum.Font.GothamBold
pickToggle.Parent = tab2

local pickStatus = Instance.new("TextLabel")
pickStatus.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(18 * scale))
pickStatus.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(45 * scale))
pickStatus.BackgroundTransparency = 1
pickStatus.Text = "Status: OFF"
pickStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
pickStatus.TextSize = FONT_SIZE
pickStatus.Font = Enum.Font.GothamSemibold
pickStatus.TextXAlignment = Enum.TextXAlignment.Left
pickStatus.Parent = tab2

local pickToolLabel = Instance.new("TextLabel")
pickToolLabel.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(16 * scale))
pickToolLabel.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(65 * scale))
pickToolLabel.BackgroundTransparency = 1
pickToolLabel.Text = "Tool: None"
pickToolLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
pickToolLabel.TextSize = SMALL_FONT
pickToolLabel.Font = Enum.Font.Gotham
pickToolLabel.TextXAlignment = Enum.TextXAlignment.Left
pickToolLabel.Parent = tab2

local pickKeyLabel = Instance.new("TextLabel")
pickKeyLabel.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(14 * scale))
pickKeyLabel.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(83 * scale))
pickKeyLabel.BackgroundTransparency = 1
pickKeyLabel.Text = "Z toggle"
pickKeyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
pickKeyLabel.TextSize = math.floor(8 * scale)
pickKeyLabel.Font = Enum.Font.Gotham
pickKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
pickKeyLabel.Parent = tab2

-- ============================================
-- TAB 3: AUTO SELL
-- ============================================
local tab3 = Instance.new("Frame")
tab3.Size = UDim2.new(1, 0, 1, 0)
tab3.BackgroundTransparency = 1
tab3.Visible = false
tab3.Parent = contentFrame

local sellToggle = Instance.new("TextButton")
sellToggle.Size = UDim2.new(0, math.floor(160 * scale), 0, math.floor(30 * scale))
sellToggle.Position = UDim2.new(0.5, -math.floor(80 * scale), 0, math.floor(8 * scale))
sellToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
sellToggle.BorderSizePixel = 0
sellToggle.Text = "▶ AUTO SELL"
sellToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
sellToggle.TextSize = FONT_SIZE
sellToggle.Font = Enum.Font.GothamBold
sellToggle.Parent = tab3

local sellStatus = Instance.new("TextLabel")
sellStatus.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(18 * scale))
sellStatus.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(45 * scale))
sellStatus.BackgroundTransparency = 1
sellStatus.Text = "Status: OFF"
sellStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
sellStatus.TextSize = FONT_SIZE
sellStatus.Font = Enum.Font.GothamSemibold
sellStatus.TextXAlignment = Enum.TextXAlignment.Left
sellStatus.Parent = tab3

local sellPromptLabel = Instance.new("TextLabel")
sellPromptLabel.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(16 * scale))
sellPromptLabel.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(65 * scale))
sellPromptLabel.BackgroundTransparency = 1
sellPromptLabel.Text = "Prompt: None"
sellPromptLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
sellPromptLabel.TextSize = SMALL_FONT
sellPromptLabel.Font = Enum.Font.Gotham
sellPromptLabel.TextXAlignment = Enum.TextXAlignment.Left
sellPromptLabel.Parent = tab3

local sellCountLabel = Instance.new("TextLabel")
sellCountLabel.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(16 * scale))
sellCountLabel.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(83 * scale))
sellCountLabel.BackgroundTransparency = 1
sellCountLabel.Text = "Spam: 0x"
sellCountLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
sellCountLabel.TextSize = SMALL_FONT
sellCountLabel.Font = Enum.Font.Gotham
sellCountLabel.TextXAlignment = Enum.TextXAlignment.Left
sellCountLabel.Parent = tab3

local sellKeyLabel = Instance.new("TextLabel")
sellKeyLabel.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(14 * scale))
sellKeyLabel.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(102 * scale))
sellKeyLabel.BackgroundTransparency = 1
sellKeyLabel.Text = "X toggle"
sellKeyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
sellKeyLabel.TextSize = math.floor(8 * scale)
sellKeyLabel.Font = Enum.Font.Gotham
sellKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
sellKeyLabel.Parent = tab3

-- ============================================
-- TAB 4: MONEY
-- ============================================
local tab4 = Instance.new("Frame")
tab4.Size = UDim2.new(1, 0, 1, 0)
tab4.BackgroundTransparency = 1
tab4.Visible = false
tab4.Parent = contentFrame

local moneyLabel = Instance.new("TextLabel")
moneyLabel.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(16 * scale))
moneyLabel.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(2 * scale))
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "LEADERSTAT NAME"
moneyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
moneyLabel.TextSize = SMALL_FONT
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.Parent = tab4

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(22 * scale))
nameBox.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(20 * scale))
nameBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
nameBox.BorderSizePixel = 0
nameBox.Text = "Cash"
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.TextSize = FONT_SIZE
nameBox.Font = Enum.Font.Gotham
nameBox.TextXAlignment = Enum.TextXAlignment.Left
nameBox.PlaceholderText = "Nama Leaderstat"
nameBox.Parent = tab4

local amountLabel = Instance.new("TextLabel")
amountLabel.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(14 * scale))
amountLabel.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(46 * scale))
amountLabel.BackgroundTransparency = 1
amountLabel.Text = "AMOUNT"
amountLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
amountLabel.TextSize = SMALL_FONT
amountLabel.Font = Enum.Font.GothamBold
amountLabel.TextXAlignment = Enum.TextXAlignment.Left
amountLabel.Parent = tab4

local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(22 * scale))
amountBox.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(62 * scale))
amountBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
amountBox.BorderSizePixel = 0
amountBox.Text = "1000"
amountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
amountBox.TextSize = FONT_SIZE
amountBox.Font = Enum.Font.Gotham
amountBox.TextXAlignment = Enum.TextXAlignment.Left
amountBox.PlaceholderText = "Jumlah"
amountBox.Parent = tab4

local addBtnServer = Instance.new("TextButton")
addBtnServer.Size = UDim2.new(1, -math.floor(20 * scale), 0, math.floor(28 * scale))
addBtnServer.Position = UDim2.new(0, math.floor(10 * scale), 0, math.floor(90 * scale))
addBtnServer.BackgroundColor3 = Color3.fromRGB(200, 80, 0)
addBtnServer.BorderSizePixel = 0
addBtnServer.Text = "ADD MONEY (SERVER)"
addBtnServer.TextColor3 = Color3.fromRGB(255, 255, 255)
addBtnServer.TextSize = SMALL_FONT
addBtnServer.Font = Enum.Font.GothamBold
addBtnServer.Parent = tab4

local moneyStatus = Instance.new("TextLabel")
moneyStatus.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(40 * scale))
moneyStatus.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(124 * scale))
moneyStatus.BackgroundTransparency = 1
moneyStatus.Text = "Ready"
moneyStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
moneyStatus.TextSize = SMALL_FONT
moneyStatus.Font = Enum.Font.Gotham
moneyStatus.TextXAlignment = Enum.TextXAlignment.Left
moneyStatus.TextWrapped = true
moneyStatus.Parent = tab4

-- ============================================
-- TAB 5: SETTINGS
-- ============================================
local tab5 = Instance.new("Frame")
tab5.Size = UDim2.new(1, 0, 1, 0)
tab5.BackgroundTransparency = 1
tab5.Visible = false
tab5.Parent = contentFrame

local bypassLabel = Instance.new("TextLabel")
bypassLabel.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(20 * scale))
bypassLabel.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(5 * scale))
bypassLabel.BackgroundTransparency = 1
bypassLabel.Text = "BYPASS"
bypassLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
bypassLabel.TextSize = math.floor(13 * scale)
bypassLabel.Font = Enum.Font.GothamBold
bypassLabel.TextXAlignment = Enum.TextXAlignment.Left
bypassLabel.Parent = tab5

local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(0, math.floor(180 * scale), 0, math.floor(30 * scale))
noclipToggle.Position = UDim2.new(0.5, -math.floor(90 * scale), 0, math.floor(35 * scale))
noclipToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
noclipToggle.BorderSizePixel = 0
noclipToggle.Text = "▶ NOCLIP BODY (OFF)"
noclipToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
noclipToggle.TextSize = FONT_SIZE
noclipToggle.Font = Enum.Font.GothamBold
noclipToggle.Parent = tab5

local noclipStatus = Instance.new("TextLabel")
noclipStatus.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(16 * scale))
noclipStatus.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(72 * scale))
noclipStatus.BackgroundTransparency = 1
noclipStatus.Text = "Status: OFF (Only affects other players)"
noclipStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
noclipStatus.TextSize = SMALL_FONT
noclipStatus.Font = Enum.Font.Gotham
noclipStatus.TextXAlignment = Enum.TextXAlignment.Left
noclipStatus.Parent = tab5

local noclipInfo = Instance.new("TextLabel")
noclipInfo.Size = UDim2.new(1, -math.floor(10 * scale), 0, math.floor(30 * scale))
noclipInfo.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(92 * scale))
noclipInfo.BackgroundTransparency = 1
noclipInfo.Text = "Mencegah body player lain menyentuh body kita\nTidak berpengaruh pada Basepart/Environment"
noclipInfo.TextColor3 = Color3.fromRGB(100, 100, 100)
noclipInfo.TextSize = math.floor(8 * scale)
noclipInfo.Font = Enum.Font.Gotham
noclipInfo.TextXAlignment = Enum.TextXAlignment.Left
noclipInfo.TextWrapped = true
noclipInfo.Parent = tab5

-- ============================================
-- TAB SWITCHING
-- ============================================
local function switchTab(tabId)
    tab1.Visible = false
    tab2.Visible = false
    tab3.Visible = false
    tab4.Visible = false
    tab5.Visible = false
    
    if tabId == "tab1" then tab1.Visible = true end
    if tabId == "tab2" then tab2.Visible = true end
    if tabId == "tab3" then tab3.Visible = true end
    if tabId == "tab4" then tab4.Visible = true end
    if tabId == "tab5" then tab5.Visible = true end
    
    for id, data in pairs(tabs) do
        if id == tabId then
            data.btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            data.btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            data.line.BackgroundTransparency = 0
        else
            data.btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            data.btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            data.line.BackgroundTransparency = 1
        end
    end
end

for id, data in pairs(tabs) do
    data.btn.MouseButton1Click:Connect(function()
        switchTab(id)
    end)
end

switchTab("tab1")

-- ============================================
-- MINIMIZE
-- ============================================
local isMinimized = false

minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, GUI_WIDTH, 0, math.floor(28 * scale))
        minBtn.Text = "+"
        contentFrame.Visible = false
        tabContainer.Visible = false
    else
        mainFrame.Size = UDim2.new(0, GUI_WIDTH, 0, GUI_HEIGHT)
        minBtn.Text = "−"
        contentFrame.Visible = true
        tabContainer.Visible = true
    end
end)

-- ============================================
-- NOCLIP BODY LOGIC
-- ============================================
local function toggleNoclip()
    noclipActive = not noclipActive
    
    if noclipActive then
        noclipToggle.Text = "⏹ NOCLIP BODY (ON)"
        noclipToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        noclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        noclipStatus.Text = "Status: ACTIVE (Other players cannot touch you)"
        noclipStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        noclipConnection = RunService.Heartbeat:Connect(function()
            if not noclipActive then return end
            local char = player.Character
            if not char then return end
            
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= player then
                    local otherChar = otherPlayer.Character
                    if otherChar then
                        for _, part in ipairs(otherChar:GetDescendants()) do
                            if part:IsA("BasePart") and part.Parent == otherChar then
                                local ourParts = char:GetDescendants()
                                for _, ourPart in ipairs(ourParts) do
                                    if ourPart:IsA("BasePart") and ourPart.Parent == char then
                                        pcall(function()
                                            ourPart.CanCollide = false
                                            part.CanCollide = false
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    else
        noclipToggle.Text = "▶ NOCLIP BODY (OFF)"
        noclipToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        noclipToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        noclipStatus.Text = "Status: OFF (Only affects other players)"
        noclipStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function()
                        part.CanCollide = true
                    end)
                end
            end
        end
    end
end

noclipToggle.MouseButton1Click:Connect(toggleNoclip)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.KeypadZero then
        toggleNoclip()
    end
end)

-- ============================================
-- AUTO FISH LOGIC
-- ============================================
local autoFishRunning = false
local autoFishConnection = nil
local requestQueue = {}
local isProcessing = false
local MAX_QUEUE_SIZE = 5
local processInterval = 0.5

local function processQueue()
    if isProcessing then return end
    if #requestQueue == 0 then
        isProcessing = false
        return
    end
    
    isProcessing = true
    local request = table.remove(requestQueue, 1)
    
    local success = pcall(function()
        giveToolEvent:FireServer()
    end)
    
    if not success and request.retryCount and request.retryCount < 3 then
        request.retryCount = request.retryCount + 1
        table.insert(requestQueue, 1, request)
    end
    
    isProcessing = false
    
    if #requestQueue > 0 then
        task.wait(processInterval)
        processQueue()
    end
end

local function queueRequest()
    if #requestQueue >= MAX_QUEUE_SIZE then
        table.remove(requestQueue, 1)
    end
    
    table.insert(requestQueue, {
        timestamp = tick(),
        retryCount = 0
    })
    
    if not isProcessing then
        task.wait(0.1)
        processQueue()
    end
end

local function toggleAutoFish()
    autoFishRunning = not autoFishRunning
    
    if autoFishRunning then
        toggleBtn.Text = "⏹ STOP FISH"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "Status: ACTIVE"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        requestQueue = {}
        isProcessing = false
        
        processInterval = selectedSpeed + 0.5
        if processInterval < 0.5 then processInterval = 0.5 end
        
        autoFishConnection = RunService.Heartbeat:Connect(function()
            if autoFishRunning then
                queueRequest()
            end
        end)
        
        task.wait(0.5)
        queueRequest()
    else
        toggleBtn.Text = "▶ START FISH"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        statusLabel.Text = "Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        if autoFishConnection then
            autoFishConnection:Disconnect()
            autoFishConnection = nil
        end
        requestQueue = {}
        isProcessing = false
    end
end

toggleBtn.MouseButton1Click:Connect(toggleAutoFish)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleAutoFish()
    end
end)

RunService.Stepped:Connect(function()
    if autoFishRunning then
        queueLabel.Text = "Queue: " .. #requestQueue .. "/" .. MAX_QUEUE_SIZE .. " | Speed: " .. selectedSpeed .. "s"
    else
        queueLabel.Text = "Queue: 0/" .. MAX_QUEUE_SIZE .. " | Speed: " .. selectedSpeed .. "s"
    end
end)

-- ============================================
-- AUTO PICK LOGIC
-- ============================================
local autoPickRunning = false
local autoPickConnection = nil

local function getRandomTool()
    local tools = {}
    
    if character then
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Tool") then
                table.insert(tools, child)
            end
        end
    end
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                table.insert(tools, child)
            end
        end
    end
    
    if #tools > 0 then
        return tools[math.random(1, #tools)]
    end
    return nil
end

local function equipTool(tool)
    if not tool then return false end
    if tool.Parent == character then return true end
    tool.Parent = character
    return true
end

local function getEquippedTool()
    if not character then return nil end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            return child
        end
    end
    return nil
end

local function doPick()
    if not autoPickRunning then return end
    
    local equipped = getEquippedTool()
    
    if equipped then
        pickToolLabel.Text = "Tool: " .. equipped.Name .. " (already)"
        pickToolLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        return
    end
    
    local randomTool = getRandomTool()
    if randomTool then
        equipTool(randomTool)
        pickToolLabel.Text = "Tool: " .. randomTool.Name .. " (equipped)"
        pickToolLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        pickToolLabel.Text = "Tool: No tool available"
        pickToolLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

local function toggleAutoPick()
    autoPickRunning = not autoPickRunning
    
    if autoPickRunning then
        pickToggle.Text = "⏹ STOP PICK"
        pickToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        pickStatus.Text = "Status: ACTIVE"
        pickStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        autoPickConnection = RunService.Heartbeat:Connect(function()
            if autoPickRunning then
                doPick()
                task.wait(1)
            end
        end)
        
        task.wait(0.3)
        doPick()
    else
        pickToggle.Text = "▶ AUTO PICK"
        pickToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        pickStatus.Text = "Status: OFF"
        pickStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
        pickToolLabel.Text = "Tool: None"
        pickToolLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        
        if autoPickConnection then
            autoPickConnection:Disconnect()
            autoPickConnection = nil
        end
    end
end

pickToggle.MouseButton1Click:Connect(toggleAutoPick)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Z then
        toggleAutoPick()
    end
end)

-- ============================================
-- AUTO SELL LOGIC
-- ============================================
local autoSellRunning = false
local autoSellConnection = nil
local sellSpamCount = 0

local function findSellPrompts()
    local prompts = {}
    local function search(obj)
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("ProximityPrompt") then
                local action = child.ActionText or ""
                if string.find(string.lower(action), "sell") or 
                   string.find(string.lower(action), "jual") then
                    table.insert(prompts, child)
                end
            end
            search(child)
        end
    end
    search(Workspace)
    return prompts
end

local function doSellSpam()
    if not autoSellRunning then return end
    
    local prompts = findSellPrompts()
    
    if #prompts > 0 then
        for _, prompt in ipairs(prompts) do
            sellPromptLabel.Text = "Prompt: " .. prompt.ActionText .. " (" .. prompt.Parent.Name .. ")"
            sellPromptLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            pcall(function()
                prompt.HoldDuration = 0
            end)
            
            for i = 1, 5 do
                if not autoSellRunning then break end
                
                pcall(function()
                    prompt:InputHold()
                    task.wait(0.02)
                    prompt:InputRelease()
                end)
                
                sellSpamCount = sellSpamCount + 1
                sellCountLabel.Text = "Spam: " .. sellSpamCount .. "x"
                
                task.wait(0.05)
            end
        end
    else
        sellPromptLabel.Text = "Prompt: No sell prompt found"
        sellPromptLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

local function toggleAutoSell()
    autoSellRunning = not autoSellRunning
    
    if autoSellRunning then
        sellToggle.Text = "⏹ STOP SELL"
        sellToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        sellStatus.Text = "Status: ACTIVE"
        sellStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        sellSpamCount = 0
        
        autoSellConnection = RunService.Heartbeat:Connect(function()
            if autoSellRunning then
                doSellSpam()
                task.wait(0.8)
            end
        end)
        
        task.wait(0.3)
        doSellSpam()
    else
        sellToggle.Text = "▶ AUTO SELL"
        sellToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        sellStatus.Text = "Status: OFF"
        sellStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
        sellPromptLabel.Text = "Prompt: None"
        sellPromptLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        
        if autoSellConnection then
            autoSellConnection:Disconnect()
            autoSellConnection = nil
        end
    end
end

sellToggle.MouseButton1Click:Connect(toggleAutoSell)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.X then
        toggleAutoSell()
    end
end)

-- ============================================
-- ADD MONEY SERVER
-- ============================================
local function addMoneyServer()
    local statName = nameBox.Text
    local amount = tonumber(amountBox.Text) or 0
    
    if statName == "" or amount <= 0 then
        moneyStatus.Text = "ERROR: Nama/Jumlah tidak valid"
        moneyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    local targetRemote, remoteType = findBestRemote()
    
    if not targetRemote then
        moneyStatus.Text = "ERROR: Tidak ada Remote ditemukan"
        moneyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    local success = false
    local result = nil
    
    if remoteType == "Event" then
        success, result = pcall(function()
            targetRemote:FireServer(statName, amount, player)
        end)
    elseif remoteType == "Function" then
        success, result = pcall(function()
            return targetRemote:InvokeServer(statName, amount, player)
        end)
    else
        success, result = pcall(function()
            targetRemote:FireServer(statName, amount, player)
        end)
        if not success then
            success, result = pcall(function()
                return targetRemote:InvokeServer(statName, amount, player)
            end)
        end
    end
    
    if success then
        moneyStatus.Text = "SERVER: +" .. amount .. " " .. statName .. " via " .. targetRemote.Name
        moneyStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        moneyStatus.Text = "SERVER ERROR: " .. tostring(result)
        moneyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end

addBtnServer.MouseButton1Click:Connect(addMoneyServer)

task.wait(1)
local best, typ = findBestRemote()
if best then
    moneyStatus.Text = "Remote: " .. best.Name .. " (" .. typ .. ") | Ready"
    moneyStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
else
    moneyStatus.Text = "No Remote Found"
    moneyStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
end

print("Catch A Anomali Fish v10.0 - Auto Resize Loaded")
print("Scale: " .. scale .. " | DPI: " .. dpi)
print("F = Auto Fish | Z = Auto Pick | X = Auto Sell | Numpad0 = Noclip")
