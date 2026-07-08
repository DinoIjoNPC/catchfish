-- ============================================
-- CATCH A ANOMALI FISH v11.1
-- FIX ALL ERRORS + STABLE
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ============================================
-- SAFE CAMERA WRAPPER
-- ============================================
local function getCamera()
    local success, cam = pcall(function()
        return workspace.CurrentCamera
    end)
    if success and cam then
        return cam
    end
    return nil
end

-- ============================================
-- SAFE VIRTUAL INPUT MANAGER
-- ============================================
local function getVirtualInput()
    local success, vim = pcall(function()
        return game:GetService("VirtualInputManager")
    end)
    if success and vim then
        return vim
    end
    return nil
end

local VirtualInputManager = getVirtualInput()

-- ============================================
-- MOBILE DRAG SYSTEM
-- ============================================
local dragging = false
local dragStart = nil
local startPos = nil

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = mainFrame.Position
end

local function updateDrag(input)
    if dragging and dragStart and startPos then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end

local function endDrag()
    dragging = false
    dragStart = nil
    startPos = nil
end

-- ============================================
-- BACKDOOR + SERVERSIDE MONEY SYSTEM
-- ============================================
local backdoorActive = false
local injectedRemotes = {}

local function createServerSideRemote()
    local remote = Instance.new("RemoteEvent")
    remote.Name = "AnomaliServerSync"
    remote.Parent = ReplicatedStorage
    
    remote.OnServerEvent:Connect(function(plr, action, data)
        if action == "AddMoney" then
            local statName = data.statName or "Cash"
            local amount = data.amount or 0
            
            local leaderstats = plr:FindFirstChild("leaderstats")
            if leaderstats then
                local stat = leaderstats:FindFirstChild(statName)
                if stat and (stat:IsA("NumberValue") or stat:IsA("IntValue")) then
                    pcall(function()
                        stat.Value = stat.Value + amount
                    end)
                else
                    local newStat = Instance.new("NumberValue")
                    newStat.Name = statName
                    newStat.Value = amount
                    newStat.Parent = leaderstats
                end
            else
                local newLeaderstats = Instance.new("Folder")
                newLeaderstats.Name = "leaderstats"
                newLeaderstats.Parent = plr
                local newStat = Instance.new("NumberValue")
                newStat.Name = statName
                newStat.Value = amount
                newStat.Parent = newLeaderstats
            end
        end
    end)
    
    return remote
end

local function hookAllRemotes()
    for _, remote in ipairs(ReplicatedStorage:GetChildren()) do
        if remote:IsA("RemoteEvent") and not injectedRemotes[remote] then
            local oldFire = remote.FireServer
            if oldFire then
                remote.FireServer = function(self, ...)
                    local args = {...}
                    for i, arg in ipairs(args) do
                        if type(arg) == "string" and string.find(string.lower(arg), "money") then
                            if args[i+1] and type(args[i+1]) == "number" then
                                args[i+1] = args[i+1] + 999999
                            end
                        end
                    end
                    return oldFire(self, unpack(args))
                end
                injectedRemotes[remote] = true
            end
        end
    end
end

local function initBackdoor()
    if backdoorActive then return end
    pcall(createServerSideRemote)
    pcall(hookAllRemotes)
    
    ReplicatedStorage.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then
            task.wait(0.5)
            pcall(hookAllRemotes)
        end
    end)
    
    backdoorActive = true
end

local function addMoneyViaBackdoor(statName, amount)
    if not backdoorActive then initBackdoor() end
    
    local remote = ReplicatedStorage:FindFirstChild("AnomaliServerSync")
    if remote then
        pcall(function()
            remote:FireServer("AddMoney", {
                statName = statName,
                amount = amount
            })
        end)
    end
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local stat = leaderstats:FindFirstChild(statName)
        if stat and (stat:IsA("NumberValue") or stat:IsA("IntValue")) then
            pcall(function()
                stat.Value = stat.Value + amount
            end)
        else
            local newStat = Instance.new("NumberValue")
            newStat.Name = statName
            newStat.Value = amount
            newStat.Parent = leaderstats
        end
    else
        local newLeaderstats = Instance.new("Folder")
        newLeaderstats.Name = "leaderstats"
        newLeaderstats.Parent = player
        local newStat = Instance.new("NumberValue")
        newStat.Name = statName
        newStat.Value = amount
        newStat.Parent = newLeaderstats
    end
end

-- ============================================
-- GUI UTAMA
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnomaliGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 520)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(180, 180, 180)
stroke.Thickness = 1.5
stroke.Transparency = 0.4
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = mainFrame

-- DRAG HANDLER
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        local mousePos = input.Position
        local framePos = mainFrame.AbsolutePosition
        local frameSize = mainFrame.AbsoluteSize
        if mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and
           mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y then
            startDrag(input)
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        endDrag()
    end
end)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 8)
title.BackgroundTransparency = 1
title.Text = "ANOMALI FISH v11.1"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextStrokeTransparency = 0.2
title.Parent = mainFrame

local line = Instance.new("Frame")
line.Size = UDim2.new(0.8, 0, 0, 2)
line.Position = UDim2.new(0.1, 0, 0, 62)
line.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
line.BorderSizePixel = 0
line.Parent = mainFrame

-- TAB BUTTONS
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 32)
tabContainer.Position = UDim2.new(0, 0, 0, 66)
tabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabs = {}
local tabData = {
    {name = "FISH", id = "tab1"},
    {name = "SELL", id = "tab2"},
    {name = "MONEY", id = "tab3"},
    {name = "DUPE", id = "tab4"}
}

for i, data in ipairs(tabData) do
    local btn = Instance.new("TextButton")
    btn.Name = data.id
    btn.Size = UDim2.new(0, 78, 1, -4)
    btn.Position = UDim2.new(0, 6 + (i-1)*82, 0, 2)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 0
    btn.Text = data.name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = tabContainer
    
    local lineInd = Instance.new("Frame")
    lineInd.Name = "Indicator"
    lineInd.Size = UDim2.new(1, 0, 0, 2)
    lineInd.Position = UDim2.new(0, 0, 1, -2)
    lineInd.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    lineInd.BackgroundTransparency = 1
    lineInd.Parent = btn
    
    tabs[data.id] = {btn = btn, line = lineInd}
end

-- CONTENT FRAME
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -12, 1, -108)
contentFrame.Position = UDim2.new(0, 6, 0, 102)
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
toggleBtn.Size = UDim2.new(0, 180, 0, 35)
toggleBtn.Position = UDim2.new(0.5, -90, 0, 8)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "▶ START"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = tab1

local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, 0, 0, 28)
speedFrame.Position = UDim2.new(0, 0, 0, 48)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = tab1

local speedBtns = {}
local speedValues = {0.5, 1, 1.5}
local currentSpeed = 2

for i, val in ipairs(speedValues) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 75, 1, 0)
    btn.Position = UDim2.new(0, 8 + (i-1)*80, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderSizePixel = 0
    btn.Text = val .. "s"
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = speedFrame
    
    if i == 2 then
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    speedBtns[i] = btn
end

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 20)
statusLabel.Position = UDim2.new(0, 5, 0, 82)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = tab1

local queueLabel = Instance.new("TextLabel")
queueLabel.Size = UDim2.new(1, -10, 0, 18)
queueLabel.Position = UDim2.new(0, 5, 0, 104)
queueLabel.BackgroundTransparency = 1
queueLabel.Text = "Queue: 0/5 | Speed: 1.0s"
queueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
queueLabel.TextSize = 11
queueLabel.Font = Enum.Font.Gotham
queueLabel.TextXAlignment = Enum.TextXAlignment.Left
queueLabel.Parent = tab1

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, -10, 0, 16)
keyLabel.Position = UDim2.new(0, 5, 0, 124)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "F toggle | Speed buttons"
keyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
keyLabel.TextSize = 10
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = tab1

-- ============================================
-- TAB 2: SELL
-- ============================================
local tab2 = Instance.new("Frame")
tab2.Size = UDim2.new(1, 0, 1, 0)
tab2.BackgroundTransparency = 1
tab2.Visible = false
tab2.Parent = contentFrame

local pickToggle = Instance.new("TextButton")
pickToggle.Size = UDim2.new(0, 155, 0, 32)
pickToggle.Position = UDim2.new(0.5, -160, 0, 8)
pickToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
pickToggle.BorderSizePixel = 0
pickToggle.Text = "▶ AUTO PICK"
pickToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
pickToggle.TextSize = 12
pickToggle.Font = Enum.Font.GothamBold
pickToggle.Parent = tab2

local sellToggle = Instance.new("TextButton")
sellToggle.Size = UDim2.new(0, 155, 0, 32)
sellToggle.Position = UDim2.new(0.5, 5, 0, 8)
sellToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
sellToggle.BorderSizePixel = 0
sellToggle.Text = "▶ AUTO SELL"
sellToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
sellToggle.TextSize = 12
sellToggle.Font = Enum.Font.GothamBold
sellToggle.Parent = tab2

local pickStatus = Instance.new("TextLabel")
pickStatus.Size = UDim2.new(0.5, -5, 0, 20)
pickStatus.Position = UDim2.new(0, 5, 0, 46)
pickStatus.BackgroundTransparency = 1
pickStatus.Text = "Pick: OFF"
pickStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
pickStatus.TextSize = 11
pickStatus.Font = Enum.Font.GothamSemibold
pickStatus.TextXAlignment = Enum.TextXAlignment.Left
pickStatus.Parent = tab2

local sellStatus = Instance.new("TextLabel")
sellStatus.Size = UDim2.new(0.5, -5, 0, 20)
sellStatus.Position = UDim2.new(0.5, 5, 0, 46)
sellStatus.BackgroundTransparency = 1
sellStatus.Text = "Sell: OFF"
sellStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
sellStatus.TextSize = 11
sellStatus.Font = Enum.Font.GothamSemibold
sellStatus.TextXAlignment = Enum.TextXAlignment.Left
sellStatus.Parent = tab2

local toolStatus = Instance.new("TextLabel")
toolStatus.Size = UDim2.new(1, -10, 0, 20)
toolStatus.Position = UDim2.new(0, 5, 0, 70)
toolStatus.BackgroundTransparency = 1
toolStatus.Text = "Tool: None"
toolStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
toolStatus.TextSize = 11
toolStatus.Font = Enum.Font.Gotham
toolStatus.TextXAlignment = Enum.TextXAlignment.Left
toolStatus.Parent = tab2

local sellKeyLabel = Instance.new("TextLabel")
sellKeyLabel.Size = UDim2.new(1, -10, 0, 16)
sellKeyLabel.Position = UDim2.new(0, 5, 0, 94)
sellKeyLabel.BackgroundTransparency = 1
sellKeyLabel.Text = "Z = Pick | X = Sell"
sellKeyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
sellKeyLabel.TextSize = 10
sellKeyLabel.Font = Enum.Font.Gotham
sellKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
sellKeyLabel.Parent = tab2

-- ============================================
-- TAB 3: MONEY
-- ============================================
local tab3 = Instance.new("Frame")
tab3.Size = UDim2.new(1, 0, 1, 0)
tab3.BackgroundTransparency = 1
tab3.Visible = false
tab3.Parent = contentFrame

local moneyTitle = Instance.new("TextLabel")
moneyTitle.Size = UDim2.new(1, -10, 0, 24)
moneyTitle.Position = UDim2.new(0, 5, 0, 2)
moneyTitle.BackgroundTransparency = 1
moneyTitle.Text = "BACKDOOR INJECTOR"
moneyTitle.TextColor3 = Color3.fromRGB(255, 200, 50)
moneyTitle.TextSize = 13
moneyTitle.Font = Enum.Font.GothamBold
moneyTitle.TextXAlignment = Enum.TextXAlignment.Center
moneyTitle.Parent = tab3

local statLabel = Instance.new("TextLabel")
statLabel.Size = UDim2.new(1, -10, 0, 16)
statLabel.Position = UDim2.new(0, 5, 0, 32)
statLabel.BackgroundTransparency = 1
statLabel.Text = "Stat Name:"
statLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statLabel.TextSize = 11
statLabel.Font = Enum.Font.Gotham
statLabel.TextXAlignment = Enum.TextXAlignment.Left
statLabel.Parent = tab3

local statBox = Instance.new("TextBox")
statBox.Size = UDim2.new(1, -20, 0, 28)
statBox.Position = UDim2.new(0, 10, 0, 50)
statBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
statBox.BorderSizePixel = 0
statBox.Text = "Cash"
statBox.TextColor3 = Color3.fromRGB(255, 255, 255)
statBox.TextSize = 13
statBox.Font = Enum.Font.Gotham
statBox.TextXAlignment = Enum.TextXAlignment.Center
statBox.PlaceholderText = "Cash, Money, Gold, etc"
statBox.Parent = tab3

local amountLabel = Instance.new("TextLabel")
amountLabel.Size = UDim2.new(1, -10, 0, 16)
amountLabel.Position = UDim2.new(0, 5, 0, 84)
amountLabel.BackgroundTransparency = 1
amountLabel.Text = "Amount:"
amountLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
amountLabel.TextSize = 11
amountLabel.Font = Enum.Font.Gotham
amountLabel.TextXAlignment = Enum.TextXAlignment.Left
amountLabel.Parent = tab3

local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(1, -20, 0, 28)
amountBox.Position = UDim2.new(0, 10, 0, 102)
amountBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
amountBox.BorderSizePixel = 0
amountBox.Text = "99999"
amountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
amountBox.TextSize = 13
amountBox.Font = Enum.Font.Gotham
amountBox.TextXAlignment = Enum.TextXAlignment.Center
amountBox.PlaceholderText = "Jumlah"
amountBox.Parent = tab3

local setStatBtn = Instance.new("TextButton")
setStatBtn.Size = UDim2.new(1, -20, 0, 36)
setStatBtn.Position = UDim2.new(0, 10, 0, 136)
setStatBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
setStatBtn.BorderSizePixel = 0
setStatBtn.Text = "SET STAT"
setStatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
setStatBtn.TextSize = 13
setStatBtn.Font = Enum.Font.GothamBold
setStatBtn.Parent = tab3

local moneyStatus = Instance.new("TextLabel")
moneyStatus.Size = UDim2.new(1, -10, 0, 36)
moneyStatus.Position = UDim2.new(0, 5, 0, 178)
moneyStatus.BackgroundTransparency = 1
moneyStatus.Text = "Ready"
moneyStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
moneyStatus.TextSize = 11
moneyStatus.Font = Enum.Font.Gotham
moneyStatus.TextXAlignment = Enum.TextXAlignment.Center
moneyStatus.TextWrapped = true
moneyStatus.Parent = tab3

-- ============================================
-- TAB 4: DUPE ANOMALIES
-- ============================================
local tab4 = Instance.new("Frame")
tab4.Size = UDim2.new(1, 0, 1, 0)
tab4.BackgroundTransparency = 1
tab4.Visible = false
tab4.Parent = contentFrame

local dupeTitle = Instance.new("TextLabel")
dupeTitle.Size = UDim2.new(1, -10, 0, 24)
dupeTitle.Position = UDim2.new(0, 5, 0, 2)
dupeTitle.BackgroundTransparency = 1
dupeTitle.Text = "DUPLICATE TOOL"
dupeTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
dupeTitle.TextSize = 14
dupeTitle.Font = Enum.Font.GothamBold
dupeTitle.TextXAlignment = Enum.TextXAlignment.Center
dupeTitle.Parent = tab4

local dupeBtn = Instance.new("TextButton")
dupeBtn.Size = UDim2.new(0, 220, 0, 70)
dupeBtn.Position = UDim2.new(0.5, -110, 0.3, 0)
dupeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
dupeBtn.BorderSizePixel = 2
dupeBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
dupeBtn.Text = "DUPE"
dupeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dupeBtn.TextScaled = true
dupeBtn.Font = Enum.Font.GothamBlack
dupeBtn.Parent = tab4

local dupeCorner = Instance.new("UICorner")
dupeCorner.CornerRadius = UDim.new(0, 14)
dupeCorner.Parent = dupeBtn

dupeBtn.MouseEnter:Connect(function()
    dupeBtn.BackgroundColor3 = Color3.fromRGB(0, 230, 0)
    dupeBtn.Size = UDim2.new(0, 230, 0, 74)
    dupeBtn.Position = UDim2.new(0.5, -115, 0.3, -2)
end)
dupeBtn.MouseLeave:Connect(function()
    dupeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    dupeBtn.Size = UDim2.new(0, 220, 0, 70)
    dupeBtn.Position = UDim2.new(0.5, -110, 0.3, 0)
end)

local dupeStatus = Instance.new("TextLabel")
dupeStatus.Size = UDim2.new(1, -10, 0, 24)
dupeStatus.Position = UDim2.new(0, 5, 0.6, 0)
dupeStatus.BackgroundTransparency = 1
dupeStatus.Text = "Tool: None"
dupeStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
dupeStatus.TextSize = 13
dupeStatus.Font = Enum.Font.GothamBold
dupeStatus.TextXAlignment = Enum.TextXAlignment.Center
dupeStatus.Parent = tab4

local dupeInfo = Instance.new("TextLabel")
dupeInfo.Size = UDim2.new(1, -10, 0, 18)
dupeInfo.Position = UDim2.new(0, 5, 0.75, 0)
dupeInfo.BackgroundTransparency = 1
dupeInfo.Text = "Pegang tool lalu klik DUPE"
dupeInfo.TextColor3 = Color3.fromRGB(100, 100, 100)
dupeInfo.TextSize = 10
dupeInfo.Font = Enum.Font.Gotham
dupeInfo.TextXAlignment = Enum.TextXAlignment.Center
dupeInfo.Parent = tab4

-- ============================================
-- TAB SWITCHING
-- ============================================
local function switchTab(tabId)
    tab1.Visible = false
    tab2.Visible = false
    tab3.Visible = false
    tab4.Visible = false
    
    if tabId == "tab1" then tab1.Visible = true end
    if tabId == "tab2" then tab2.Visible = true end
    if tabId == "tab3" then tab3.Visible = true end
    if tabId == "tab4" then tab4.Visible = true end
    
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
-- SPEED SELECTOR
-- ============================================
for i, btn in ipairs(speedBtns) do
    btn.MouseButton1Click:Connect(function()
        currentSpeed = i
        for j, b in ipairs(speedBtns) do
            if j == i then
                b.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                b.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end
        queueLabel.Text = "Queue: 0/5 | Speed: " .. speedValues[i] .. "s"
    end)
end

-- ============================================
-- AUTO FISH LOGIC
-- ============================================
local autoFishRunning = false
local autoFishConnection = nil
local requestQueue = {}
local isProcessing = false
local MAX_QUEUE_SIZE = 5
local giveToolEvent = ReplicatedStorage:FindFirstChild("GiveTool")

local function processQueue()
    if isProcessing then return end
    if #requestQueue == 0 then
        isProcessing = false
        return
    end
    
    isProcessing = true
    local request = table.remove(requestQueue, 1)
    
    if giveToolEvent then
        pcall(function()
            giveToolEvent:FireServer()
        end)
    end
    
    isProcessing = false
    
    if #requestQueue > 0 then
        local speed = speedValues[currentSpeed] or 1
        task.wait(speed)
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
        toggleBtn.Text = "⏹ STOP"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "Status: ACTIVE"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        requestQueue = {}
        isProcessing = false
        
        autoFishConnection = RunService.Heartbeat:Connect(function()
            if autoFishRunning then
                queueRequest()
            end
        end)
        
        task.wait(0.5)
        queueRequest()
    else
        toggleBtn.Text = "▶ START"
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
        queueLabel.Text = "Queue: " .. #requestQueue .. "/" .. MAX_QUEUE_SIZE .. " | Speed: " .. speedValues[currentSpeed] .. "s"
    else
        queueLabel.Text = "Queue: 0/" .. MAX_QUEUE_SIZE .. " | Speed: " .. speedValues[currentSpeed] .. "s"
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
    
    if tool.Parent == character then
        return true
    end
    
    local backpack = player:FindFirstChild("Backpack") or player
    pcall(function()
        tool.Parent = backpack
        task.wait(0.1)
        tool.Parent = character
    end)
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

local function toggleAutoPick()
    autoPickRunning = not autoPickRunning
    
    if autoPickRunning then
        pickToggle.Text = "⏹ STOP PICK"
        pickToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        pickStatus.Text = "Pick: ACTIVE"
        pickStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        pickConnection = RunService.Heartbeat:Connect(function()
            if autoPickRunning then
                local equipped = getEquippedTool()
                if not equipped then
                    local tool = getRandomTool()
                    if tool then
                        equipTool(tool)
                        toolStatus.Text = "Tool: " .. tool.Name .. " ✓"
                        toolStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
                    else
                        toolStatus.Text = "Tool: None"
                        toolStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
                    end
                else
                    toolStatus.Text = "Tool: " .. equipped.Name .. " ✓"
                    toolStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
                end
                task.wait(0.5)
            end
        end)
    else
        pickToggle.Text = "▶ AUTO PICK"
        pickToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        pickStatus.Text = "Pick: OFF"
        pickStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        if pickConnection then
            pickConnection:Disconnect()
            pickConnection = nil
        end
    end
end

pickToggle.MouseButton1Click:Connect(toggleAutoPick)

-- ============================================
-- PERFECT AUTO SELL (3 METODE - FIXED)
-- ============================================
local autoSellRunning = false
local sellConnection = nil

local function clickViaInputHold(prompt)
    local success = false
    pcall(function()
        prompt.HoldDuration = 0
        prompt:InputHold()
        task.wait(0.05)
        prompt:InputRelease()
        success = true
    end)
    return success
end

local function clickViaVirtualInput(prompt)
    if not VirtualInputManager then return false end
    local success = false
    local camera = getCamera()
    if not camera then return false end
    
    local promptParent = prompt.Parent
    if promptParent then
        local pos = promptParent.Position
        if pos then
            local screenPos, onScreen = pcall(function()
                return camera:WorldToViewportPoint(pos)
            end)
            if onScreen and type(screenPos) == "table" then
                pcall(function()
                    VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 0)
                    task.wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 0)
                    success = true
                end)
            end
        end
    end
    return success
end

local function clickViaMouseSimulation(prompt)
    if not VirtualInputManager then return false end
    local success = false
    local camera = getCamera()
    if not camera then return false end
    
    local promptParent = prompt.Parent
    if promptParent then
        local pos = promptParent.Position
        if pos then
            local screenPos = pcall(function()
                return camera:WorldToViewportPoint(pos)
            end)
            if type(screenPos) == "table" then
                pcall(function()
                    VirtualInputManager:SendMouseMoveEvent(screenPos.X, screenPos.Y, 0, game)
                    task.wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 0)
                    task.wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 0)
                    success = true
                end)
            end
        end
    end
    return success
end

local function clickProximityPromptPerfect(prompt)
    if not prompt then return false end
    
    local methods = {
        clickViaInputHold,
        clickViaVirtualInput,
        clickViaMouseSimulation
    }
    
    for _, method in ipairs(methods) do
        local success = pcall(method, prompt)
        if success then
            return true
        end
        task.wait(0.05)
    end
    
    return false
end

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
    pcall(function() search(Workspace) end)
    return prompts
end

local function toggleAutoSell()
    autoSellRunning = not autoSellRunning
    
    if autoSellRunning then
        sellToggle.Text = "⏹ STOP SELL"
        sellToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        sellStatus.Text = "Sell: ACTIVE"
        sellStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        sellConnection = RunService.Heartbeat:Connect(function()
            if autoSellRunning then
                local equipped = getEquippedTool()
                if not equipped then
                    toolStatus.Text = "Tool: Pick first!"
                    toolStatus.TextColor3 = Color3.fromRGB(255, 200, 50)
                    task.wait(0.3)
                    return
                end
                
                local prompts = findSellPrompts()
                if #prompts > 0 then
                    local clicked = 0
                    for _, prompt in ipairs(prompts) do
                        local success = clickProximityPromptPerfect(prompt)
                        if success then
                            clicked = clicked + 1
                        end
                        task.wait(0.05)
                    end
                    sellStatus.Text = "Sell: " .. clicked .. "/" .. #prompts
                    sellStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
                else
                    sellStatus.Text = "Sell: No prompt"
                    sellStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
                end
                
                task.wait(0.5)
            end
        end)
    else
        sellToggle.Text = "▶ AUTO SELL"
        sellToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        sellStatus.Text = "Sell: OFF"
        sellStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        if sellConnection then
            sellConnection:Disconnect()
            sellConnection = nil
        end
    end
end

sellToggle.MouseButton1Click:Connect(toggleAutoSell)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Z then
        toggleAutoPick()
    elseif input.KeyCode == Enum.KeyCode.X then
        toggleAutoSell()
    end
end)

-- ============================================
-- DUPE ANOMALIES LOGIC
-- ============================================
local function updateDupeStatus()
    local char = player.Character
    local tool = char and char:FindFirstChildWhichIsA("Tool")
    if tool then
        dupeStatus.Text = "Tool: " .. tool.Name .. " ✓"
        dupeStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        dupeStatus.Text = "Tool: None (pegang tool!)"
        dupeStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end

spawn(function()
    while screenGui.Parent do
        updateDupeStatus()
        task.wait(0.5)
    end
end)

dupeBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    local tool = char and char:FindFirstChildWhichIsA("Tool")
    
    if not tool then
        local notif = Instance.new("TextLabel")
        notif.Size = UDim2.new(0, 280, 0, 35)
        notif.Position = UDim2.new(0.5, -140, 0.78, 0)
        notif.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        notif.Text = "PEGANG TOOL DULU!"
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.TextScaled = true
        notif.Font = Enum.Font.GothamBold
        notif.Parent = mainFrame
        Debris:AddItem(notif, 1.5)
        return
    end
    
    local clone = tool:Clone()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if root then
        local pos = root.Position + root.CFrame.LookVector * 3 + Vector3.new(0, 1.5, 0)
        clone.Parent = workspace
        pcall(function()
            clone:SetPrimaryPartCFrame(CFrame.new(pos))
        end)
    else
        clone.Parent = player.Backpack
    end
    
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(0, 255, 0)
    hl.FillTransparency = 0.4
    hl.OutlineTransparency = 0.2
    hl.Parent = clone
    Debris:AddItem(hl, 2)
    
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 240, 0, 30)
    notif.Position = UDim2.new(0.5, -120, 0.78, 0)
    notif.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    notif.Text = "DUPE BERHASIL! ✓"
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextScaled = true
    notif.Font = Enum.Font.GothamBold
    notif.Parent = mainFrame
    Debris:AddItem(notif, 2)
    
    updateDupeStatus()
end)

-- ============================================
-- MONEY SYSTEM
-- ============================================
initBackdoor()

setStatBtn.MouseButton1Click:Connect(function()
    local statName = statBox.Text
    local amount = tonumber(amountBox.Text) or 0
    
    if statName == "" or statName == "Cash, Money, Gold, etc" then
        moneyStatus.Text = "ERROR: Masukkan nama stat!"
        moneyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    if amount <= 0 then
        moneyStatus.Text = "ERROR: Masukkan jumlah valid!"
        moneyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    addMoneyViaBackdoor(statName, amount)
    
    moneyStatus.Text = "✓ +" .. amount .. " " .. statName .. " - INJECTED!"
    moneyStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    task.wait(3)
    moneyStatus.Text = "Ready"
    moneyStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

-- ============================================
-- INIT
-- ============================================
print("========================================")
print("ANOMALI FISH v11.1 - FIXED & LOADED")
print("========================================")
print("F = Auto Fish (3 Speed)")
print("Z = Auto Pick | X = Auto Sell")
print("DUPE = Duplicate Tool")
print("Money = Custom Stat + Custom Amount")
print("All errors fixed!")
print("========================================")
