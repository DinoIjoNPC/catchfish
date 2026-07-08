-- ============================================
-- CATCH A ANOMALI FISH v8.0 ULTIMATE
-- STYLE V8 + SETTINGS + NOCLIP + AUTO RESIZE
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local giveToolEvent = ReplicatedStorage:WaitForChild("GiveTool")

-- ============================================
-- AUTO RESIZE (Mobile/PC)
-- ============================================
local viewport = Workspace.CurrentCamera.ViewportSize
local isMobile = UserInputService.TouchEnabled
local isTablet = viewport.X < 800 and viewport.X > 400
local isPhone = viewport.X <= 400

local GUI_W, GUI_H
local FONT_MAIN, FONT_SMALL, FONT_TITLE

if isPhone then
    GUI_W, GUI_H = 300, 370
    FONT_MAIN, FONT_SMALL, FONT_TITLE = 10, 8, 11
elseif isTablet then
    GUI_W, GUI_H = 340, 400
    FONT_MAIN, FONT_SMALL, FONT_TITLE = 12, 10, 13
else
    GUI_W, GUI_H = 320, 390
    FONT_MAIN, FONT_SMALL, FONT_TITLE = 11, 9, 12
end

local function scale(val)
    local base = isPhone and 0.7 or (isTablet and 0.85 or 1)
    return math.floor(val * base)
end

-- ============================================
-- DETECT REMOTES FOR MONEY
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
-- NOCLIP
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
mainFrame.Size = UDim2.new(0, GUI_W, 0, GUI_H)
mainFrame.Position = UDim2.new(0.5, -GUI_W/2, 0.5, -GUI_H/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
mainFrame.Active = true

-- UIStroke
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Thickness = 1
uiStroke.Transparency = 0.4
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = mainFrame

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = mainFrame

-- Shadow
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
-- TITLE BAR
-- ============================================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, scale(28))
titleBar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 8, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "ANOMALI FISH"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = FONT_TITLE
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, scale(24), 0, scale(24))
minBtn.Position = UDim2.new(1, -scale(28), 0, scale(2))
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minBtn.BorderSizePixel = 0
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = FONT_TITLE
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar

-- ============================================
-- TAB BUTTONS (5 Tab)
-- ============================================
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, scale(28))
tabContainer.Position = UDim2.new(0, 0, 0, scale(28))
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
    btn.Size = UDim2.new(0, scale(56), 1, -scale(4))
    btn.Position = UDim2.new(0, scale(4) + (i-1) * scale(60), 0, scale(2))
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 0
    btn.Text = data.name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = FONT_SMALL
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = tabContainer
    
    local line = Instance.new("Frame")
    line.Name = "Indicator"
    line.Size = UDim2.new(0.6, 0, 0, 2)
    line.Position = UDim2.new(0.2, 0, 1, -2)
    line.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    line.BackgroundTransparency = 1
    line.Parent = btn
    
    tabs[data.id] = {btn = btn, line = line}
end

-- ============================================
-- CONTENT FRAME
-- ============================================
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -scale(12), 1, -scale(68))
contentFrame.Position = UDim2.new(0, scale(6), 0, scale(60))
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ============================================
-- TAB 1: AUTO FISH (Dengan Speed Settings)
-- ============================================
local tab1 = Instance.new("Frame")
tab1.Size = UDim2.new(1, 0, 1, 0)
tab1.BackgroundTransparency = 1
tab1.Visible = false
tab1.Parent = contentFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, scale(160), 0, scale(30))
toggleBtn.Position = UDim2.new(0.5, -scale(80), 0, scale(4))
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "▶ START FISH"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = FONT_MAIN
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = tab1

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -scale(10), 0, scale(18))
statusLabel.Position = UDim2.new(0, scale(5), 0, scale(40))
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = FONT_MAIN
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = tab1

local queueLabel = Instance.new("TextLabel")
queueLabel.Size = UDim2.new(1, -scale(10), 0, scale(16))
queueLabel.Position = UDim2.new(0, scale(5), 0, scale(60))
queueLabel.BackgroundTransparency = 1
queueLabel.Text = "Queue: 0/5 | Speed: 0.5s"
queueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
queueLabel.TextSize = FONT_SMALL
queueLabel.Font = Enum.Font.Gotham
queueLabel.TextXAlignment = Enum.TextXAlignment.Left
queueLabel.Parent = tab1

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, -scale(10), 0, scale(14))
keyLabel.Position = UDim2.new(0, scale(5), 0, scale(78))
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "F toggle"
keyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
keyLabel.TextSize = FONT_SMALL
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = tab1

-- Speed Settings
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -scale(10), 0, scale(16))
speedLabel.Position = UDim2.new(0, scale(5), 0, scale(100))
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "LOOP SPEED"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
speedLabel.TextSize = FONT_SMALL
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = tab1

local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(1, -scale(10), 0, scale(28))
speedContainer.Position = UDim2.new(0, scale(5), 0, scale(118))
speedContainer.BackgroundTransparency = 1
speedContainer.Parent = tab1

local speedOptions = {0.5, 1, 1.5}
local selectedSpeed = 0.5
local speedButtons = {}

for i, val in ipairs(speedOptions) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, scale(70), 1, 0)
    btn.Position = UDim2.new(0, (i-1) * scale(78), 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BorderSizePixel = 0
    btn.Text = val .. "s"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = FONT_MAIN
    btn.Font = Enum.Font.GothamBold
    btn.Parent = speedContainer
    
    if val == selectedSpeed then
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    speedButtons[val] = btn
    
    btn.MouseButton1Click:Connect(function()
        selectedSpeed = val
        for s, b in pairs(speedButtons) do
            if s == val then
                b.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                b.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        queueLabel.Text = "Queue: 0/5 | Speed: " .. val .. "s"
        if autoFishRunning then
            processInterval = val
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
pickToggle.Size = UDim2.new(0, scale(160), 0, scale(30))
pickToggle.Position = UDim2.new(0.5, -scale(80), 0, scale(8))
pickToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
pickToggle.BorderSizePixel = 0
pickToggle.Text = "▶ AUTO PICK"
pickToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
pickToggle.TextSize = FONT_MAIN
pickToggle.Font = Enum.Font.GothamBold
pickToggle.Parent = tab2

local pickStatus = Instance.new("TextLabel")
pickStatus.Size = UDim2.new(1, -scale(10), 0, scale(18))
pickStatus.Position = UDim2.new(0, scale(5), 0, scale(45))
pickStatus.BackgroundTransparency = 1
pickStatus.Text = "Status: OFF"
pickStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
pickStatus.TextSize = FONT_MAIN
pickStatus.Font = Enum.Font.GothamSemibold
pickStatus.TextXAlignment = Enum.TextXAlignment.Left
pickStatus.Parent = tab2

local pickToolLabel = Instance.new("TextLabel")
pickToolLabel.Size = UDim2.new(1, -scale(10), 0, scale(16))
pickToolLabel.Position = UDim2.new(0, scale(5), 0, scale(65))
pickToolLabel.BackgroundTransparency = 1
pickToolLabel.Text = "Tool: None"
pickToolLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
pickToolLabel.TextSize = FONT_SMALL
pickToolLabel.Font = Enum.Font.Gotham
pickToolLabel.TextXAlignment = Enum.TextXAlignment.Left
pickToolLabel.Parent = tab2

local pickKeyLabel = Instance.new("TextLabel")
pickKeyLabel.Size = UDim2.new(1, -scale(10), 0, scale(14))
pickKeyLabel.Position = UDim2.new(0, scale(5), 0, scale(83))
pickKeyLabel.BackgroundTransparency = 1
pickKeyLabel.Text = "Z toggle"
pickKeyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
pickKeyLabel.TextSize = FONT_SMALL
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
sellToggle.Size = UDim2.new(0, scale(160), 0, scale(30))
sellToggle.Position = UDim2.new(0.5, -scale(80), 0, scale(8))
sellToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
sellToggle.BorderSizePixel = 0
sellToggle.Text = "▶ AUTO SELL"
sellToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
sellToggle.TextSize = FONT_MAIN
sellToggle.Font = Enum.Font.GothamBold
sellToggle.Parent = tab3

local sellStatus = Instance.new("TextLabel")
sellStatus.Size = UDim2.new(1, -scale(10), 0, scale(18))
sellStatus.Position = UDim2.new(0, scale(5), 0, scale(45))
sellStatus.BackgroundTransparency = 1
sellStatus.Text = "Status: OFF"
sellStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
sellStatus.TextSize = FONT_MAIN
sellStatus.Font = Enum.Font.GothamSemibold
sellStatus.TextXAlignment = Enum.TextXAlignment.Left
sellStatus.Parent = tab3

local sellPromptLabel = Instance.new("TextLabel")
sellPromptLabel.Size = UDim2.new(1, -scale(10), 0, scale(16))
sellPromptLabel.Position = UDim2.new(0, scale(5), 0, scale(65))
sellPromptLabel.BackgroundTransparency = 1
sellPromptLabel.Text = "Prompt: None"
sellPromptLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
sellPromptLabel.TextSize = FONT_SMALL
sellPromptLabel.Font = Enum.Font.Gotham
sellPromptLabel.TextXAlignment = Enum.TextXAlignment.Left
sellPromptLabel.Parent = tab3

local sellCountLabel = Instance.new("TextLabel")
sellCountLabel.Size = UDim2.new(1, -scale(10), 0, scale(16))
sellCountLabel.Position = UDim2.new(0, scale(5), 0, scale(83))
sellCountLabel.BackgroundTransparency = 1
sellCountLabel.Text = "Spam: 0x"
sellCountLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
sellCountLabel.TextSize = FONT_SMALL
sellCountLabel.Font = Enum.Font.Gotham
sellCountLabel.TextXAlignment = Enum.TextXAlignment.Left
sellCountLabel.Parent = tab3

local sellKeyLabel = Instance.new("TextLabel")
sellKeyLabel.Size = UDim2.new(1, -scale(10), 0, scale(14))
sellKeyLabel.Position = UDim2.new(0, scale(5), 0, scale(102))
sellKeyLabel.BackgroundTransparency = 1
sellKeyLabel.Text = "X toggle"
sellKeyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
sellKeyLabel.TextSize = FONT_SMALL
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
moneyLabel.Size = UDim2.new(1, -scale(10), 0, scale(16))
moneyLabel.Position = UDim2.new(0, scale(5), 0, scale(2))
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "LEADERSTAT NAME"
moneyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
moneyLabel.TextSize = FONT_SMALL
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.Parent = tab4

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -scale(10), 0, scale(22))
nameBox.Position = UDim2.new(0, scale(5), 0, scale(20))
nameBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
nameBox.BorderSizePixel = 0
nameBox.Text = "Cash"
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.TextSize = FONT_MAIN
nameBox.Font = Enum.Font.Gotham
nameBox.TextXAlignment = Enum.TextXAlignment.Left
nameBox.PlaceholderText = "Nama Leaderstat"
nameBox.Parent = tab4

local amountLabel = Instance.new("TextLabel")
amountLabel.Size = UDim2.new(1, -scale(10), 0, scale(14))
amountLabel.Position = UDim2.new(0, scale(5), 0, scale(46))
amountLabel.BackgroundTransparency = 1
amountLabel.Text = "AMOUNT"
amountLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
amountLabel.TextSize = FONT_SMALL
amountLabel.Font = Enum.Font.GothamBold
amountLabel.TextXAlignment = Enum.TextXAlignment.Left
amountLabel.Parent = tab4

local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(1, -scale(10), 0, scale(22))
amountBox.Position = UDim2.new(0, scale(5), 0, scale(62))
amountBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
amountBox.BorderSizePixel = 0
amountBox.Text = "1000"
amountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
amountBox.TextSize = FONT_MAIN
amountBox.Font = Enum.Font.Gotham
amountBox.TextXAlignment = Enum.TextXAlignment.Left
amountBox.PlaceholderText = "Jumlah"
amountBox.Parent = tab4

local addBtnServer = Instance.new("TextButton")
addBtnServer.Size = UDim2.new(1, -scale(20), 0, scale(28))
addBtnServer.Position = UDim2.new(0, scale(10), 0, scale(90))
addBtnServer.BackgroundColor3 = Color3.fromRGB(200, 80, 0)
addBtnServer.BorderSizePixel = 0
addBtnServer.Text = "ADD MONEY (SERVER)"
addBtnServer.TextColor3 = Color3.fromRGB(255, 255, 255)
addBtnServer.TextSize = FONT_SMALL
addBtnServer.Font = Enum.Font.GothamBold
addBtnServer.Parent = tab4

local moneyStatus = Instance.new("TextLabel")
moneyStatus.Size = UDim2.new(1, -scale(10), 0, scale(40))
moneyStatus.Position = UDim2.new(0, scale(5), 0, scale(124))
moneyStatus.BackgroundTransparency = 1
moneyStatus.Text = "Ready"
moneyStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
moneyStatus.TextSize = FONT_SMALL
moneyStatus.Font = Enum.Font.Gotham
moneyStatus.TextXAlignment = Enum.TextXAlignment.Left
moneyStatus.TextWrapped = true
moneyStatus.Parent = tab4

-- ============================================
-- TAB 5: SETTINGS (Noclip)
-- ============================================
local tab5 = Instance.new("Frame")
tab5.Size = UDim2.new(1, 0, 1, 0)
tab5.BackgroundTransparency = 1
tab5.Visible = false
tab5.Parent = contentFrame

local bypassLabel = Instance.new("TextLabel")
bypassLabel.Size = UDim2.new(1, -scale(10), 0, scale(20))
bypassLabel.Position = UDim2.new(0, scale(5), 0, scale(5))
bypassLabel.BackgroundTransparency = 1
bypassLabel.Text = "BYPASS"
bypassLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
bypassLabel.TextSize = FONT_MAIN
bypassLabel.Font = Enum.Font.GothamBold
bypassLabel.TextXAlignment = Enum.TextXAlignment.Left
bypassLabel.Parent = tab5

local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(0, scale(180), 0, scale(30))
noclipToggle.Position = UDim2.new(0.5, -scale(90), 0, scale(35))
noclipToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
noclipToggle.BorderSizePixel = 0
noclipToggle.Text = "▶ NOCLIP BODY (OFF)"
noclipToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
noclipToggle.TextSize = FONT_MAIN
noclipToggle.Font = Enum.Font.GothamBold
noclipToggle.Parent = tab5

local noclipStatus = Instance.new("TextLabel")
noclipStatus.Size = UDim2.new(1, -scale(10), 0, scale(16))
noclipStatus.Position = UDim2.new(0, scale(5), 0, scale(72))
noclipStatus.BackgroundTransparency = 1
noclipStatus.Text = "Status: OFF (Only affects other players)"
noclipStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
noclipStatus.TextSize = FONT_SMALL
noclipStatus.Font = Enum.Font.Gotham
noclipStatus.TextXAlignment = Enum.TextXAlignment.Left
noclipStatus.Parent = tab5

local noclipInfo = Instance.new("TextLabel")
noclipInfo.Size = UDim2.new(1, -scale(10), 0, scale(30))
noclipInfo.Position = UDim2.new(0, scale(5), 0, scale(92))
noclipInfo.BackgroundTransparency = 1
noclipInfo.Text = "Mencegah body player lain menyentuh body kita\nTidak berpengaruh pada Basepart/Environment"
noclipInfo.TextColor3 = Color3.fromRGB(100, 100, 100)
noclipInfo.TextSize = FONT_SMALL
noclipInfo.Font = Enum.Font.Gotham
noclipInfo.TextXAlignment = Enum.TextXAlignment.Left
noclipInfo.TextWrapped = true
noclipInfo.Parent = tab5

local noclipKey = Instance.new("TextLabel")
noclipKey.Size = UDim2.new(1, -scale(10), 0, scale(14))
noclipKey.Position = UDim2.new(0, scale(5), 0, scale(126))
noclipKey.BackgroundTransparency = 1
noclipKey.Text = "Numpad0 toggle"
noclipKey.TextColor3 = Color3.fromRGB(80, 80, 80)
noclipKey.TextSize = FONT_SMALL
noclipKey.Font = Enum.Font.Gotham
noclipKey.TextXAlignment = Enum.TextXAlignment.Left
noclipKey.Parent = tab5

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
        mainFrame.Size = UDim2.new(0, GUI_W, 0, scale(28))
        minBtn.Text = "+"
        contentFrame.Visible = false
        tabContainer.Visible = false
    else
        mainFrame.Size = UDim2.new(0, GUI_W, 0, GUI_H)
        minBtn.Text = "−"
        contentFrame.Visible = true
        tabContainer.Visible = true
    end
end)

-- ============================================
-- NOCLIP LOGIC
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
                                for _, ourPart in ipairs(char:GetDescendants()) do
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
        
        processInterval = selectedSpeed
        
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

print("Catch A Anomali Fish v8.0 Ultimate - Loaded")
print("F = Auto Fish | Z = Auto Pick | X = Auto Sell | Numpad0 = Noclip")
