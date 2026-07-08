-- ============================================
-- CATCH A ANOMALI FISH v9.0
-- SETTINGS FISH: 0s | 1s | 1.5s
-- NOCLIP BODY (Player Only)
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
local originalCanCollide = {}

-- ============================================
-- GUI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CatchAnomaliGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 380)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
mainFrame.Active = true

-- ============================================
-- DRAG SYSTEM (MOBILE + PC)
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
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 8, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "ANOMALI FISH"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 12
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -28, 0, 2)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minBtn.BorderSizePixel = 0
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 14
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar

-- ============================================
-- TAB BUTTONS (5 Tab)
-- ============================================
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 28)
tabContainer.Position = UDim2.new(0, 0, 0, 28)
tabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabs = {}
local tabData = {
    {name = "Fish", id = "tab1"},
    {name = "Pick", id = "tab2"},
    {name = "Sell", id = "tab3"},
    {name = "Money", id = "tab4"},
    {name = "Setting", id = "tab5"}
}

for i, data in ipairs(tabData) do
    local btn = Instance.new("TextButton")
    btn.Name = data.id
    btn.Size = UDim2.new(0, 56, 1, -4)
    btn.Position = UDim2.new(0, 4 + (i-1)*60, 0, 2)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 0
    btn.Text = data.name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 8
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
contentFrame.Size = UDim2.new(1, -12, 1, -68)
contentFrame.Position = UDim2.new(0, 6, 0, 60)
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
toggleBtn.Size = UDim2.new(0, 160, 0, 30)
toggleBtn.Position = UDim2.new(0.5, -80, 0, 4)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "▶ START FISH"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 11
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = tab1

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 18)
statusLabel.Position = UDim2.new(0, 5, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = tab1

local queueLabel = Instance.new("TextLabel")
queueLabel.Size = UDim2.new(1, -10, 0, 16)
queueLabel.Position = UDim2.new(0, 5, 0, 60)
queueLabel.BackgroundTransparency = 1
queueLabel.Text = "Queue: 0/5 | Speed: 0s"
queueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
queueLabel.TextSize = 10
queueLabel.Font = Enum.Font.Gotham
queueLabel.TextXAlignment = Enum.TextXAlignment.Left
queueLabel.Parent = tab1

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, -10, 0, 14)
keyLabel.Position = UDim2.new(0, 5, 0, 78)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "F toggle"
keyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
keyLabel.TextSize = 9
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = tab1

-- Speed Settings di dalam Tab Fish
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -10, 0, 16)
speedLabel.Position = UDim2.new(0, 5, 0, 100)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "LOOP SPEED"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
speedLabel.TextSize = 10
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = tab1

local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(1, -10, 0, 28)
speedContainer.Position = UDim2.new(0, 5, 0, 118)
speedContainer.BackgroundTransparency = 1
speedContainer.Parent = tab1

local speedOptions = {0, 1, 1.5}
local selectedSpeed = 0
local speedButtons = {}

for i, val in ipairs(speedOptions) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*75, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BorderSizePixel = 0
    btn.Text = val .. "s"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = speedContainer
    
    if val == selectedSpeed then
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    speedButtons[val] = btn
    
    btn.MouseButton1Click:Connect(function()
        selectedSpeed = val
        -- Update semua button
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
        
        -- Update interval jika auto fish running
        if autoFishRunning then
            processInterval = val + 0.5 -- Minimum 0.5s delay
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
pickToggle.Size = UDim2.new(0, 160, 0, 30)
pickToggle.Position = UDim2.new(0.5, -80, 0, 8)
pickToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
pickToggle.BorderSizePixel = 0
pickToggle.Text = "▶ AUTO PICK"
pickToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
pickToggle.TextSize = 11
pickToggle.Font = Enum.Font.GothamBold
pickToggle.Parent = tab2

local pickStatus = Instance.new("TextLabel")
pickStatus.Size = UDim2.new(1, -10, 0, 18)
pickStatus.Position = UDim2.new(0, 5, 0, 45)
pickStatus.BackgroundTransparency = 1
pickStatus.Text = "Status: OFF"
pickStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
pickStatus.TextSize = 11
pickStatus.Font = Enum.Font.GothamSemibold
pickStatus.TextXAlignment = Enum.TextXAlignment.Left
pickStatus.Parent = tab2

local pickToolLabel = Instance.new("TextLabel")
pickToolLabel.Size = UDim2.new(1, -10, 0, 16)
pickToolLabel.Position = UDim2.new(0, 5, 0, 65)
pickToolLabel.BackgroundTransparency = 1
pickToolLabel.Text = "Tool: None"
pickToolLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
pickToolLabel.TextSize = 10
pickToolLabel.Font = Enum.Font.Gotham
pickToolLabel.TextXAlignment = Enum.TextXAlignment.Left
pickToolLabel.Parent = tab2

local pickKeyLabel = Instance.new("TextLabel")
pickKeyLabel.Size = UDim2.new(1, -10, 0, 14)
pickKeyLabel.Position = UDim2.new(0, 5, 0, 83)
pickKeyLabel.BackgroundTransparency = 1
pickKeyLabel.Text = "Z toggle"
pickKeyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
pickKeyLabel.TextSize = 9
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
sellToggle.Size = UDim2.new(0, 160, 0, 30)
sellToggle.Position = UDim2.new(0.5, -80, 0, 8)
sellToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
sellToggle.BorderSizePixel = 0
sellToggle.Text = "▶ AUTO SELL"
sellToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
sellToggle.TextSize = 11
sellToggle.Font = Enum.Font.GothamBold
sellToggle.Parent = tab3

local sellStatus = Instance.new("TextLabel")
sellStatus.Size = UDim2.new(1, -10, 0, 18)
sellStatus.Position = UDim2.new(0, 5, 0, 45)
sellStatus.BackgroundTransparency = 1
sellStatus.Text = "Status: OFF"
sellStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
sellStatus.TextSize = 11
sellStatus.Font = Enum.Font.GothamSemibold
sellStatus.TextXAlignment = Enum.TextXAlignment.Left
sellStatus.Parent = tab3

local sellPromptLabel = Instance.new("TextLabel")
sellPromptLabel.Size = UDim2.new(1, -10, 0, 16)
sellPromptLabel.Position = UDim2.new(0, 5, 0, 65)
sellPromptLabel.BackgroundTransparency = 1
sellPromptLabel.Text = "Prompt: None"
sellPromptLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
sellPromptLabel.TextSize = 10
sellPromptLabel.Font = Enum.Font.Gotham
sellPromptLabel.TextXAlignment = Enum.TextXAlignment.Left
sellPromptLabel.Parent = tab3

local sellCountLabel = Instance.new("TextLabel")
sellCountLabel.Size = UDim2.new(1, -10, 0, 16)
sellCountLabel.Position = UDim2.new(0, 5, 0, 83)
sellCountLabel.BackgroundTransparency = 1
sellCountLabel.Text = "Spam: 0x"
sellCountLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
sellCountLabel.TextSize = 10
sellCountLabel.Font = Enum.Font.Gotham
sellCountLabel.TextXAlignment = Enum.TextXAlignment.Left
sellCountLabel.Parent = tab3

local sellKeyLabel = Instance.new("TextLabel")
sellKeyLabel.Size = UDim2.new(1, -10, 0, 14)
sellKeyLabel.Position = UDim2.new(0, 5, 0, 102)
sellKeyLabel.BackgroundTransparency = 1
sellKeyLabel.Text = "X toggle"
sellKeyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
sellKeyLabel.TextSize = 9
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
moneyLabel.Size = UDim2.new(1, -10, 0, 16)
moneyLabel.Position = UDim2.new(0, 5, 0, 2)
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "LEADERSTAT NAME"
moneyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
moneyLabel.TextSize = 9
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.Parent = tab4

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -10, 0, 22)
nameBox.Position = UDim2.new(0, 5, 0, 20)
nameBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
nameBox.BorderSizePixel = 0
nameBox.Text = "Cash"
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.TextSize = 11
nameBox.Font = Enum.Font.Gotham
nameBox.TextXAlignment = Enum.TextXAlignment.Left
nameBox.PlaceholderText = "Nama Leaderstat"
nameBox.Parent = tab4

local amountLabel = Instance.new("TextLabel")
amountLabel.Size = UDim2.new(1, -10, 0, 14)
amountLabel.Position = UDim2.new(0, 5, 0, 46)
amountLabel.BackgroundTransparency = 1
amountLabel.Text = "AMOUNT"
amountLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
amountLabel.TextSize = 9
amountLabel.Font = Enum.Font.GothamBold
amountLabel.TextXAlignment = Enum.TextXAlignment.Left
amountLabel.Parent = tab4

local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(1, -10, 0, 22)
amountBox.Position = UDim2.new(0, 5, 0, 62)
amountBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
amountBox.BorderSizePixel = 0
amountBox.Text = "1000"
amountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
amountBox.TextSize = 11
amountBox.Font = Enum.Font.Gotham
amountBox.TextXAlignment = Enum.TextXAlignment.Left
amountBox.PlaceholderText = "Jumlah"
amountBox.Parent = tab4

local addBtnServer = Instance.new("TextButton")
addBtnServer.Size = UDim2.new(1, -20, 0, 28)
addBtnServer.Position = UDim2.new(0, 10, 0, 90)
addBtnServer.BackgroundColor3 = Color3.fromRGB(200, 80, 0)
addBtnServer.BorderSizePixel = 0
addBtnServer.Text = "ADD MONEY (SERVER)"
addBtnServer.TextColor3 = Color3.fromRGB(255, 255, 255)
addBtnServer.TextSize = 10
addBtnServer.Font = Enum.Font.GothamBold
addBtnServer.Parent = tab4

local moneyStatus = Instance.new("TextLabel")
moneyStatus.Size = UDim2.new(1, -10, 0, 40)
moneyStatus.Position = UDim2.new(0, 5, 0, 124)
moneyStatus.BackgroundTransparency = 1
moneyStatus.Text = "Ready"
moneyStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
moneyStatus.TextSize = 9
moneyStatus.Font = Enum.Font.Gotham
moneyStatus.TextXAlignment = Enum.TextXAlignment.Left
moneyStatus.TextWrapped = true
moneyStatus.Parent = tab4

-- ============================================
-- TAB 5: SETTINGS / BYPASS
-- ============================================
local tab5 = Instance.new("Frame")
tab5.Size = UDim2.new(1, 0, 1, 0)
tab5.BackgroundTransparency = 1
tab5.Visible = false
tab5.Parent = contentFrame

local bypassLabel = Instance.new("TextLabel")
bypassLabel.Size = UDim2.new(1, -10, 0, 20)
bypassLabel.Position = UDim2.new(0, 5, 0, 5)
bypassLabel.BackgroundTransparency = 1
bypassLabel.Text = "BYPASS"
bypassLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
bypassLabel.TextSize = 13
bypassLabel.Font = Enum.Font.GothamBold
bypassLabel.TextXAlignment = Enum.TextXAlignment.Left
bypassLabel.Parent = tab5

-- Noclip Body Toggle
local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(0, 180, 0, 30)
noclipToggle.Position = UDim2.new(0.5, -90, 0, 35)
noclipToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
noclipToggle.BorderSizePixel = 0
noclipToggle.Text = "▶ NOCLIP BODY (OFF)"
noclipToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
noclipToggle.TextSize = 11
noclipToggle.Font = Enum.Font.GothamBold
noclipToggle.Parent = tab5

local noclipStatus = Instance.new("TextLabel")
noclipStatus.Size = UDim2.new(1, -10, 0, 16)
noclipStatus.Position = UDim2.new(0, 5, 0, 72)
noclipStatus.BackgroundTransparency = 1
noclipStatus.Text = "Status: OFF (Only affects other players)"
noclipStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
noclipStatus.TextSize = 10
noclipStatus.Font = Enum.Font.Gotham
noclipStatus.TextXAlignment = Enum.TextXAlignment.Left
noclipStatus.Parent = tab5

local noclipInfo = Instance.new("TextLabel")
noclipInfo.Size = UDim2.new(1, -10, 0, 30)
noclipInfo.Position = UDim2.new(0, 5, 0, 92)
noclipInfo.BackgroundTransparency = 1
noclipInfo.Text = "Mencegah body player lain menyentuh body kita\nTidak berpengaruh pada Basepart/Environment"
noclipInfo.TextColor3 = Color3.fromRGB(100, 100, 100)
noclipInfo.TextSize = 9
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
        mainFrame.Size = UDim2.new(0, 320, 0, 28)
        minBtn.Text = "+"
        contentFrame.Visible = false
        tabContainer.Visible = false
    else
        mainFrame.Size = UDim2.new(0, 320, 0, 380)
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
        
        -- Start Noclip
        noclipConnection = RunService.Heartbeat:Connect(function()
            if not noclipActive then return end
            
            local char = player.Character
            if not char then return end
            
            -- Cari semua player lain
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= player then
                    local otherChar = otherPlayer.Character
                    if otherChar then
                        -- Loop semua part di karakter lain
                        for _, part in ipairs(otherChar:GetDescendants()) do
                            if part:IsA("BasePart") then
                                -- Set CanCollide false hanya untuk part yang bersentuhan dengan kita
                                -- Dan hanya jika part tersebut adalah bagian dari karakter
                                if part.Parent == otherChar or part:IsDescendantOf(otherChar) then
                                    -- Cek apakah part bertabrakan dengan character kita
                                    local ourParts = char:GetDescendants()
                                    for _, ourPart in ipairs(ourParts) do
                                        if ourPart:IsA("BasePart") and ourPart.Parent == char then
                                            -- Disable collision antara part kita dan part mereka
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
        
        -- Reset CanCollide
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

-- Keybind Numpad 0 untuk Noclip
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.KeypadZero then
        toggleNoclip()
    end
end)

-- ============================================
-- AUTO FISH LOGIC (Dengan Speed Settings)
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
        
        -- Set interval based on selected speed
        processInterval = selectedSpeed + 0.5
        if processInterval < 0.5 then processInterval = 0.5 end
        
        autoFishConnection = RunService.Heartbeat:Connect(function()
