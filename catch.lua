-- ============================================
-- CATCH A ANOMALI FISH v11.0
-- UI STROKE | AUTO RESIZE | FIXED DISPLAY
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
    GUI_W, GUI_H = 280, 340
    FONT_MAIN, FONT_SMALL, FONT_TITLE = 10, 8, 11
elseif isTablet then
    GUI_W, GUI_H = 340, 380
    FONT_MAIN, FONT_SMALL, FONT_TITLE = 12, 10, 13
else
    GUI_W, GUI_H = 380, 420
    FONT_MAIN, FONT_SMALL, FONT_TITLE = 14, 11, 15
end

local function scale(val)
    local base = isPhone and 0.7 or (isTablet and 0.85 or 1)
    return math.floor(val * base)
end

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
-- NOCLIP
-- ============================================
local noclipActive = false
local noclipConnection = nil

-- ============================================
-- CREATE GUI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnomaliGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, GUI_W, 0, GUI_H)
mainFrame.Position = UDim2.new(0.5, -GUI_W/2, 0.5, -GUI_H/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- UIStroke (Border Putih)
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Thickness = 1.5
uiStroke.Transparency = 0.3
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = mainFrame

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316043491"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)
shadow.ZIndex = 0
shadow.Parent = mainFrame

-- ============================================
-- DRAG
-- ============================================
local isDragging = false
local dragStart, dragFrameStart

local function startDrag(input)
    isDragging = true
    dragStart = input.Position
    dragFrameStart = mainFrame.Position
end

local function endDrag()
    isDragging = false
end

local function moveDrag(input)
    if isDragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            dragFrameStart.X.Scale,
            dragFrameStart.X.Offset + delta.X,
            dragFrameStart.Y.Scale,
            dragFrameStart.Y.Offset + delta.Y
        )
    end
end

mainFrame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        startDrag(i)
    end
end)

mainFrame.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        endDrag()
    end
end)

mainFrame.TouchBegan:Connect(startDrag)
mainFrame.TouchMoved:Connect(moveDrag)
mainFrame.TouchEnded:Connect(endDrag)
mainFrame.TouchCanceled:Connect(endDrag)

UserInputService.InputChanged:Connect(function(i)
    if isDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        moveDrag(i)
    end
end)

-- ============================================
-- TITLE BAR
-- ============================================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, scale(32))
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ ANOMALI FISH"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = FONT_TITLE
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

-- Glow Line
local glowLine = Instance.new("Frame")
glowLine.Size = UDim2.new(1, 0, 0, 2)
glowLine.Position = UDim2.new(0, 0, 1, -2)
glowLine.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
glowLine.BorderSizePixel = 0
glowLine.Parent = titleBar

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 4)
glowCorner.Parent = glowLine

-- Min Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, scale(26), 0, scale(26))
minBtn.Position = UDim2.new(1, -scale(32), 0, scale(3))
minBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
minBtn.BorderSizePixel = 0
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = FONT_TITLE
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minBtn

-- ============================================
-- TAB BUTTONS
-- ============================================
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, scale(32))
tabContainer.Position = UDim2.new(0, 0, 0, scale(32))
tabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
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
    btn.Size = UDim2.new(0, scale(65), 1, -scale(4))
    btn.Position = UDim2.new(0, scale(4) + (i-1) * scale(70), 0, scale(2))
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.BorderSizePixel = 0
    btn.Text = data.name
    btn.TextColor3 = Color3.fromRGB(160, 160, 170)
    btn.TextSize = FONT_SMALL
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = tabContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.6, 0, 0, 2)
    line.Position = UDim2.new(0.2, 0, 1, -2)
    line.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    line.BackgroundTransparency = 1
    line.BorderSizePixel = 0
    line.Parent = btn
    
    tabs[data.id] = {btn = btn, line = line}
end

-- ============================================
-- CONTENT
-- ============================================
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -scale(16), 1, -scale(72))
contentFrame.Position = UDim2.new(0, scale(8), 0, scale(68))
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ============================================
-- TAB 1: FISH
-- ============================================
local tab1 = Instance.new("Frame")
tab1.Size = UDim2.new(1, 0, 1, 0)
tab1.BackgroundTransparency = 1
tab1.Visible = false
tab1.Parent = contentFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, scale(170), 0, scale(34))
toggleBtn.Position = UDim2.new(0.5, -scale(85), 0, scale(4))
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "▶ START FISH"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = FONT_MAIN
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = tab1

local togCorner = Instance.new("UICorner")
togCorner.CornerRadius = UDim.new(0, 6)
togCorner.Parent = toggleBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -scale(10), 0, scale(20))
statusLabel.Position = UDim2.new(0, scale(5), 0, scale(44))
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "● Status: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
statusLabel.TextSize = FONT_MAIN
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = tab1

local queueLabel = Instance.new("TextLabel")
queueLabel.Size = UDim2.new(1, -scale(10), 0, scale(18))
queueLabel.Position = UDim2.new(0, scale(5), 0, scale(66))
queueLabel.BackgroundTransparency = 1
queueLabel.Text = "Queue: 0/5 | Speed: 0.5s"
queueLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
queueLabel.TextSize = FONT_SMALL
queueLabel.Font = Enum.Font.Gotham
queueLabel.TextXAlignment = Enum.TextXAlignment.Left
queueLabel.Parent = tab1

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, -scale(10), 0, scale(16))
keyLabel.Position = UDim2.new(0, scale(5), 0, scale(86))
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "⌨ F"
keyLabel.TextColor3 = Color3.fromRGB(80, 80, 90)
keyLabel.TextSize = FONT_SMALL
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = tab1

-- Speed
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -scale(10), 0, scale(18))
speedLabel.Position = UDim2.new(0, scale(5), 0, scale(110))
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "▸ LOOP SPEED"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
speedLabel.TextSize = FONT_SMALL
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = tab1

local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(1, -scale(10), 0, scale(32))
speedContainer.Position = UDim2.new(0, scale(5), 0, scale(130))
speedContainer.BackgroundTransparency = 1
speedContainer.Parent = tab1

local speedOptions = {0.5, 1, 1.5}
local selectedSpeed = 0.5
local speedButtons = {}

for i, val in ipairs(speedOptions) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, scale(70), 1, 0)
    btn.Position = UDim2.new(0, (i-1) * scale(78), 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    btn.BorderSizePixel = 0
    btn.Text = val .. "s"
    btn.TextColor3 = Color3.fromRGB(180, 180, 190)
    btn.TextSize = FONT_MAIN
    btn.Font = Enum.Font.GothamBold
    btn.Parent = speedContainer
    
    local btnCor = Instance.new("UICorner")
    btnCor.CornerRadius = UDim.new(0, 4)
    btnCor.Parent = btn
    
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
                b.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
                b.TextColor3 = Color3.fromRGB(180, 180, 190)
            end
        end
        queueLabel.Text = "Queue: 0/5 | Speed: " .. val .. "s"
        if autoFishRunning then
            processInterval = val
        end
    end)
end

-- ============================================
-- TAB 2: PICK
-- ============================================
local tab2 = Instance.new("Frame")
tab2.Size = UDim2.new(1, 0, 1, 0)
tab2.BackgroundTransparency = 1
tab2.Visible = false
tab2.Parent = contentFrame

local pickToggle = Instance.new("TextButton")
pickToggle.Size = UDim2.new(0, scale(170), 0, scale(34))
pickToggle.Position = UDim2.new(0.5, -scale(85), 0, scale(8))
pickToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
pickToggle.BorderSizePixel = 0
pickToggle.Text = "▶ AUTO PICK"
pickToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
pickToggle.TextSize = FONT_MAIN
pickToggle.Font = Enum.Font.GothamBold
pickToggle.Parent = tab2

local pCorner = Instance.new("UICorner")
pCorner.CornerRadius = UDim.new(0, 6)
pCorner.Parent = pickToggle

local pickStatus = Instance.new("TextLabel")
pickStatus.Size = UDim2.new(1, -scale(10), 0, scale(20))
pickStatus.Position = UDim2.new(0, scale(5), 0, scale(48))
pickStatus.BackgroundTransparency = 1
pickStatus.Text = "● Status: OFF"
pickStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
pickStatus.TextSize = FONT_MAIN
pickStatus.Font = Enum.Font.GothamSemibold
pickStatus.TextXAlignment = Enum.TextXAlignment.Left
pickStatus.Parent = tab2

local pickToolLabel = Instance.new("TextLabel")
pickToolLabel.Size = UDim2.new(1, -scale(10), 0, scale(18))
pickToolLabel.Position = UDim2.new(0, scale(5), 0, scale(70))
pickToolLabel.BackgroundTransparency = 1
pickToolLabel.Text = "Tool: None"
pickToolLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
pickToolLabel.TextSize = FONT_SMALL
pickToolLabel.Font = Enum.Font.Gotham
pickToolLabel.TextXAlignment = Enum.TextXAlignment.Left
pickToolLabel.Parent = tab2

local pickKey = Instance.new("TextLabel")
pickKey.Size = UDim2.new(1, -scale(10), 0, scale(16))
pickKey.Position = UDim2.new(0, scale(5), 0, scale(90))
pickKey.BackgroundTransparency = 1
pickKey.Text = "⌨ Z"
pickKey.TextColor3 = Color3.fromRGB(80, 80, 90)
pickKey.TextSize = FONT_SMALL
pickKey.Font = Enum.Font.Gotham
pickKey.TextXAlignment = Enum.TextXAlignment.Left
pickKey.Parent = tab2

-- ============================================
-- TAB 3: SELL
-- ============================================
local tab3 = Instance.new("Frame")
tab3.Size = UDim2.new(1, 0, 1, 0)
tab3.BackgroundTransparency = 1
tab3.Visible = false
tab3.Parent = contentFrame

local sellToggle = Instance.new("TextButton")
sellToggle.Size = UDim2.new(0, scale(170), 0, scale(34))
sellToggle.Position = UDim2.new(0.5, -scale(85), 0, scale(8))
sellToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
sellToggle.BorderSizePixel = 0
sellToggle.Text = "▶ AUTO SELL"
sellToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
sellToggle.TextSize = FONT_MAIN
sellToggle.Font = Enum.Font.GothamBold
sellToggle.Parent = tab3

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 6)
sCorner.Parent = sellToggle

local sellStatus = Instance.new("TextLabel")
sellStatus.Size = UDim2.new(1, -scale(10), 0, scale(20))
sellStatus.Position = UDim2.new(0, scale(5), 0, scale(48))
sellStatus.BackgroundTransparency = 1
sellStatus.Text = "● Status: OFF"
sellStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
sellStatus.TextSize = FONT_MAIN
sellStatus.Font = Enum.Font.GothamSemibold
sellStatus.TextXAlignment = Enum.TextXAlignment.Left
sellStatus.Parent = tab3

local sellPrompt = Instance.new("TextLabel")
sellPrompt.Size = UDim2.new(1, -scale(10), 0, scale(18))
sellPrompt.Position = UDim2.new(0, scale(5), 0, scale(70))
sellPrompt.BackgroundTransparency = 1
sellPrompt.Text = "Prompt: None"
sellPrompt.TextColor3 = Color3.fromRGB(140, 140, 150)
sellPrompt.TextSize = FONT_SMALL
sellPrompt.Font = Enum.Font.Gotham
sellPrompt.TextXAlignment = Enum.TextXAlignment.Left
sellPrompt.Parent = tab3

local sellCount = Instance.new("TextLabel")
sellCount.Size = UDim2.new(1, -scale(10), 0, scale(18))
sellCount.Position = UDim2.new(0, scale(5), 0, scale(90))
sellCount.BackgroundTransparency = 1
sellCount.Text = "Spam: 0x"
sellCount.TextColor3 = Color3.fromRGB(140, 140, 150)
sellCount.TextSize = FONT_SMALL
sellCount.Font = Enum.Font.Gotham
sellCount.TextXAlignment = Enum.TextXAlignment.Left
sellCount.Parent = tab3

local sellKey = Instance.new("TextLabel")
sellKey.Size = UDim2.new(1, -scale(10), 0, scale(16))
sellKey.Position = UDim2.new(0, scale(5), 0, scale(110))
sellKey.BackgroundTransparency = 1
sellKey.Text = "⌨ X"
sellKey.TextColor3 = Color3.fromRGB(80, 80, 90)
sellKey.TextSize = FONT_SMALL
sellKey.Font = Enum.Font.Gotham
sellKey.TextXAlignment = Enum.TextXAlignment.Left
sellKey.Parent = tab3

-- ============================================
-- TAB 4: MONEY
-- ============================================
local tab4 = Instance.new("Frame")
tab4.Size = UDim2.new(1, 0, 1, 0)
tab4.BackgroundTransparency = 1
tab4.Visible = false
tab4.Parent = contentFrame

local mTitle = Instance.new("TextLabel")
mTitle.Size = UDim2.new(1, -scale(10), 0, scale(18))
mTitle.Position = UDim2.new(0, scale(5), 0, scale(2))
mTitle.BackgroundTransparency = 1
mTitle.Text = "LEADERSTAT"
mTitle.TextColor3 = Color3.fromRGB(180, 180, 190)
mTitle.TextSize = FONT_SMALL
mTitle.Font = Enum.Font.GothamBold
mTitle.TextXAlignment = Enum.TextXAlignment.Left
mTitle.Parent = tab4

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -scale(10), 0, scale(26))
nameBox.Position = UDim2.new(0, scale(5), 0, scale(22))
nameBox.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
nameBox.BorderSizePixel = 0
nameBox.Text = "Cash"
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.TextSize = FONT_MAIN
nameBox.Font = Enum.Font.Gotham
nameBox.TextXAlignment = Enum.TextXAlignment.Left
nameBox.PlaceholderText = "Nama Leaderstat"
nameBox.Parent = tab4

local nCorner = Instance.new("UICorner")
nCorner.CornerRadius = UDim.new(0, 4)
nCorner.Parent = nameBox

local aTitle = Instance.new("TextLabel")
aTitle.Size = UDim2.new(1, -scale(10), 0, scale(16))
aTitle.Position = UDim2.new(0, scale(5), 0, scale(52))
aTitle.BackgroundTransparency = 1
aTitle.Text = "AMOUNT"
aTitle.TextColor3 = Color3.fromRGB(180, 180, 190)
aTitle.TextSize = FONT_SMALL
aTitle.Font = Enum.Font.GothamBold
aTitle.TextXAlignment = Enum.TextXAlignment.Left
aTitle.Parent = tab4

local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(1, -scale(10), 0, scale(26))
amountBox.Position = UDim2.new(0, scale(5), 0, scale(70))
amountBox.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
amountBox.BorderSizePixel = 0
amountBox.Text = "1000"
amountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
amountBox.TextSize = FONT_MAIN
amountBox.Font = Enum.Font.Gotham
amountBox.TextXAlignment = Enum.TextXAlignment.Left
amountBox.PlaceholderText = "Jumlah"
amountBox.Parent = tab4

local aCorner = Instance.new("UICorner")
aCorner.CornerRadius = UDim.new(0, 4)
aCorner.Parent = amountBox

local addBtn = Instance.new("TextButton")
addBtn.Size = UDim2.new(1, -scale(20), 0, scale(30))
addBtn.Position = UDim2.new(0, scale(10), 0, scale(102))
addBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
addBtn.BorderSizePixel = 0
addBtn.Text = "⚡ ADD MONEY"
addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addBtn.TextSize = FONT_MAIN
addBtn.Font = Enum.Font.GothamBold
addBtn.Parent = tab4

local addCorner = Instance.new("UICorner")
addCorner.CornerRadius = UDim.new(0, 6)
addCorner.Parent = addBtn

local moneyStatus = Instance.new("TextLabel")
moneyStatus.Size = UDim2.new(1, -scale(10), 0, scale(40))
moneyStatus.Position = UDim2.new(0, scale(5), 0, scale(138))
moneyStatus.BackgroundTransparency = 1
moneyStatus.Text = "Ready"
moneyStatus.TextColor3 = Color3.fromRGB(140, 140, 150)
moneyStatus.TextSize = FONT_SMALL
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

local setTitle = Instance.new("TextLabel")
setTitle.Size = UDim2.new(1, -scale(10), 0, scale(22))
setTitle.Position = UDim2.new(0, scale(5), 0, scale(4))
setTitle.BackgroundTransparency = 1
setTitle.Text = "⚙ BYPASS"
setTitle.TextColor3 = Color3.fromRGB(255, 200, 80)
setTitle.TextSize = FONT_MAIN
setTitle.Font = Enum.Font.GothamBold
setTitle.TextXAlignment = Enum.TextXAlignment.Left
setTitle.Parent = tab5

local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0, scale(190), 0, scale(34))
noclipBtn.Position = UDim2.new(0.5, -scale(95), 0, scale(34))
noclipBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
noclipBtn.BorderSizePixel = 0
noclipBtn.Text = "▶ NOCLIP BODY (OFF)"
noclipBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
noclipBtn.TextSize = FONT_MAIN
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.Parent = tab5

local ncCorner = Instance.new("UICorner")
ncCorner.CornerRadius = UDim.new(0, 6)
ncCorner.Parent = noclipBtn

local ncStatus = Instance.new("TextLabel")
ncStatus.Size = UDim2.new(1, -scale(10), 0, scale(18))
ncStatus.Position = UDim2.new(0, scale(5), 0, scale(74))
ncStatus.BackgroundTransparency = 1
ncStatus.Text = "Status: OFF"
ncStatus.TextColor3 = Color3.fromRGB(140, 140, 150)
ncStatus.TextSize = FONT_SMALL
ncStatus.Font = Enum.Font.Gotham
ncStatus.TextXAlignment = Enum.TextXAlignment.Left
ncStatus.Parent = tab5

local ncInfo = Instance.new("TextLabel")
ncInfo.Size = UDim2.new(1, -scale(10), 0, scale(32))
ncInfo.Position = UDim2.new(0, scale(5), 0, scale(96))
ncInfo.BackgroundTransparency = 1
ncInfo.Text = "Mencegah body player lain menyentuh body kita"
ncInfo.TextColor3 = Color3.fromRGB(90, 90, 100)
ncInfo.TextSize = FONT_SMALL
ncInfo.Font = Enum.Font.Gotham
ncInfo.TextXAlignment = Enum.TextXAlignment.Left
ncInfo.TextWrapped = true
ncInfo.Parent = tab5

local ncKey = Instance.new("TextLabel")
ncKey.Size = UDim2.new(1, -scale(10), 0, scale(16))
ncKey.Position = UDim2.new(0, scale(5), 0, scale(130))
ncKey.BackgroundTransparency = 1
ncKey.Text = "⌨ Numpad0"
ncKey.TextColor3 = Color3.fromRGB(80, 80, 90)
ncKey.TextSize = FONT_SMALL
ncKey.Font = Enum.Font.Gotham
ncKey.TextXAlignment = Enum.TextXAlignment.Left
ncKey.Parent = tab5

-- ============================================
-- TAB SWITCHING
-- ============================================
local function switchTab(id)
    tab1.Visible = false
    tab2.Visible = false
    tab3.Visible = false
    tab4.Visible = false
    tab5.Visible = false
    
    if id == "tab1" then tab1.Visible = true end
    if id == "tab2" then tab2.Visible = true end
    if id == "tab3" then tab3.Visible = true end
    if id == "tab4" then tab4.Visible = true end
    if id == "tab5" then tab5.Visible = true end
    
    for tid, data in pairs(tabs) do
        if tid == id then
            data.btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
            data.btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            data.line.BackgroundTransparency = 0
        else
            data.btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            data.btn.TextColor3 = Color3.fromRGB(160, 160, 170)
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
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, GUI_W, 0, scale(32))
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
-- NOCLIP
-- ============================================
local function toggleNoclip()
    noclipActive = not noclipActive
    
    if noclipActive then
        noclipBtn.Text = "⏹ NOCLIP BODY (ON)"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ncStatus.Text = "Status: ACTIVE"
        ncStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        noclipConnection = RunService.Heartbeat:Connect(function()
            if not noclipActive then return end
            local char = player.Character
            if not char then return end
            
            for _, other in ipairs(Players:GetPlayers()) do
                if other ~= player then
                    local oc = other.Character
                    if oc then
                        for _, p in ipairs(oc:GetDescendants()) do
                            if p:IsA("BasePart") and p.Parent == oc then
                                for _, op in ipairs(char:GetDescendants()) do
                                    if op:IsA("BasePart") and op.Parent == char then
                                        pcall(function()
                                            op.CanCollide = false
                                            p.CanCollide = false
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
        noclipBtn.Text = "▶ NOCLIP BODY (OFF)"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        noclipBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        ncStatus.Text = "Status: OFF"
        ncStatus.TextColor3 = Color3.fromRGB(140, 140, 150)
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        local char = player.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    pcall(function()
                        p.CanCollide = true
                    end)
                end
            end
        end
    end
end

noclipBtn.MouseButton1Click:Connect(toggleNoclip)

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.KeypadZero then
        toggleNoclip()
    end
end)

-- ============================================
-- AUTO FISH
-- ============================================
local autoFishRunning = false
local fishConnection = nil
local requestQueue = {}
local isProcessing = false
local MAX_QUEUE = 5
local processInterval = 0.5

local function processQueue()
    if isProcessing or #requestQueue == 0 then return end
    isProcessing = true
    local req = table.remove(requestQueue, 1)
    
    pcall(function()
        giveToolEvent:FireServer()
    end)
    
    isProcessing = false
    if #requestQueue > 0 then
        task.wait(processInterval)
        processQueue()
    end
end

local function queueRequest()
    if #requestQueue >= MAX_QUEUE then
        table.remove(requestQueue, 1)
    end
    table.insert(requestQueue, {retry = 0})
    if not isProcessing then
        task.wait(0.05)
        processQueue()
    end
end

local function toggleFish()
    autoFishRunning = not autoFishRunning
    
    if autoFishRunning then
        toggleBtn.Text = "⏹ STOP FISH"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "● Status: ACTIVE"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        requestQueue = {}
        isProcessing = false
        processInterval = selectedSpeed
        
        fishConnection = RunService.Heartbeat:Connect(function()
            if autoFishRunning then
                queueRequest()
            end
        end)
        task.wait(0.3)
        queueRequest()
    else
        toggleBtn.Text = "▶ START FISH"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        statusLabel.Text = "● Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        if fishConnection then
            fishConnection:Disconnect()
            fishConnection = nil
        end
        requestQueue = {}
        isProcessing = false
    end
end

toggleBtn.MouseButton1Click:Connect(toggleFish)

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.F then
        toggleFish()
    end
end)

RunService.Stepped:Connect(function()
    if autoFishRunning then
        queueLabel.Text = "Queue: " .. #requestQueue .. "/" .. MAX_QUEUE .. " | Speed: " .. selectedSpeed .. "s"
    else
        queueLabel.Text = "Queue: 0/" .. MAX_QUEUE .. " | Speed: " .. selectedSpeed .. "s"
    end
end)

-- ============================================
-- AUTO PICK
-- ============================================
local autoPickRunning = false
local pickConnection = nil

local function getRandomTool()
    local tools = {}
    if character then
        for _, c in ipairs(character:GetChildren()) do
            if c:IsA("Tool") then table.insert(tools, c) end
        end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, c in ipairs(bp:GetChildren()) do
            if c:IsA("Tool") then table.insert(tools, c) end
        end
    end
    return #tools > 0 and tools[math.random(1, #tools)] or nil
end

local function equipTool(t)
    if not t then return false end
    if t.Parent == character then return true end
    t.Parent = character
    return true
end

local function getEquipped()
    if not character then return nil end
    for _, c in ipairs(character:GetChildren()) do
        if c:IsA("Tool") then return c end
    end
    return nil
end

local function doPick()
    if not autoPickRunning then return end
    local eq = getEquipped()
    if eq then
        pickToolLabel.Text = "Tool: " .. eq.Name .. " ✓"
        pickToolLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        return
    end
    local t = getRandomTool()
    if t then
        equipTool(t)
        pickToolLabel.Text = "Tool: " .. t.Name .. " ✓"
        pickToolLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        pickToolLabel.Text = "Tool: None"
        pickToolLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end

local function togglePick()
    autoPickRunning = not autoPickRunning
    if autoPickRunning then
        pickToggle.Text = "⏹ STOP PICK"
        pickToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        pickStatus.Text = "● Status: ACTIVE"
        pickStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        pickConnection = RunService.Heartbeat:Connect(function()
            if autoPickRunning then
                doPick()
                task.wait(1)
            end
        end)
        task.wait(0.3)
        doPick()
    else
        pickToggle.Text = "▶ AUTO PICK"
        pickToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        pickStatus.Text = "● Status: OFF"
        pickStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
        pickToolLabel.Text = "Tool: None"
        pickToolLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
        if pickConnection then
            pickConnection:Disconnect()
            pickConnection = nil
        end
    end
end

pickToggle.MouseButton1Click:Connect(togglePick)

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Z then
        togglePick()
    end
end)

-- ============================================
-- AUTO SELL
-- ============================================
local autoSellRunning = false
local sellConnection = nil
local spamCount = 0

local function findSellPrompts()
    local prompts = {}
    local function search(obj)
        for _, c in ipairs(obj:GetChildren()) do
            if c:IsA("ProximityPrompt") then
                local action = c.ActionText or ""
                if string.find(string.lower(action), "sell") or string.find(string.lower(action), "jual") then
                    table.insert(prompts, c)
                end
            end
            search(c)
        end
    end
    search(Workspace)
    return prompts
end

local function doSell()
    if not autoSellRunning then return end
    local prompts = findSellPrompts()
    if #prompts > 0 then
        for _, p in ipairs(prompts) do
            sellPrompt.Text = "Prompt: " .. p.ActionText .. " ✓"
            sellPrompt.TextColor3 = Color3.fromRGB(100, 255, 100)
            pcall(function() p.HoldDuration = 0 end)
            for i = 1, 5 do
                if not autoSellRunning then break end
                pcall(function()
                    p:InputHold()
                    task.wait(0.02)
                    p:InputRelease()
                end)
                spamCount = spamCount + 1
                sellCount.Text = "Spam: " .. spamCount .. "x"
                task.wait(0.05)
            end
        end
    else
        sellPrompt.Text = "Prompt: None"
        sellPrompt.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end

local function toggleSell()
    autoSellRunning = not autoSellRunning
    if autoSellRunning then
        sellToggle.Text = "⏹ STOP SELL"
        sellToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        sellStatus.Text = "● Status: ACTIVE"
        sellStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        spamCount = 0
        sellConnection = RunService.Heartbeat:Connect(function()
            if autoSellRunning then
                doSell()
                task.wait(0.6)
            end
        end)
        task.wait(0.3)
        doSell()
    else
        sellToggle.Text = "▶ AUTO SELL"
        sellToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        sellStatus.Text = "● Status: OFF"
        sellStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
        sellPrompt.Text = "Prompt: None"
        sellPrompt.TextColor3 = Color3.fromRGB(140, 140, 150)
        if sellConnection then
            sellConnection:Disconnect()
            sellConnection = nil
        end
    end
end

sellToggle.MouseButton1Click:Connect(toggleSell)

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.X then
        toggleSell()
    end
end)

-- ============================================
-- ADD MONEY
-- ============================================
local function addMoney()
    local name = nameBox.Text
    local amt = tonumber(amountBox.Text) or 0
    if name == "" or amt <= 0 then
        moneyStatus.Text = "❌ Nama/Jumlah tidak valid"
        moneyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    local remote, typ = findBestRemote()
    if not remote then
        moneyStatus.Text = "❌ Tidak ada Remote ditemukan"
        moneyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    local success, result
    if typ == "Event" then
        success, result = pcall(function()
            remote:FireServer(name, amt, player)
        end)
    else
        success, result = pcall(function()
            return remote:InvokeServer(name, amt, player)
        end)
    end
    
    if success then
        moneyStatus.Text = "✅ +" .. amt .. " " .. name .. " via " .. remote.Name
        moneyStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        moneyStatus.Text = "❌ ERROR: " .. tostring(result)
        moneyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end

addBtn.MouseButton1Click:Connect(addMoney)

task.wait(1)
local best, t = findBestRemote()
if best then
    moneyStatus.Text = "🔗 Remote: " .. best.Name .. " (" .. t .. ") | Ready"
    moneyStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
else
    moneyStatus.Text = "❌ No Remote Found"
    moneyStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
end

-- ============================================
-- STARTUP LOG
-- ============================================
print("⚡ ANOMALI FISH v11.0 LOADED")
print("📱 Mode: " .. (isPhone and "Phone" or (isTablet and "Tablet" or "PC")))
print("📐 Size: " .. GUI_W .. "x" .. GUI_H)
print("⌨ F=Fish | Z=Pick | X=Sell | Numpad0=Noclip")
