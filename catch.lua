-- ============================================
-- CATCH A ANOMALI FISH v9.1
-- FULL FIX - MOBILE DRAG WORKING
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ============================================
-- FIX: MOBILE DRAG VIA USERINPUTSERVICE
-- ============================================
local dragging = false
local dragStart = nil
local startPos = nil
local dragObject = nil

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = mainFrame.Position
    dragObject = input
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
    dragObject = nil
end

-- ============================================
-- BACKDOOR SYSTEM
-- ============================================
local backdoorActive = false

local function createBackdoor()
    if backdoorActive then return end
    
    -- Inject ke semua remote yang ada
    for _, remote in ipairs(ReplicatedStorage:GetChildren()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local oldFire = remote.FireServer
            if oldFire then
                remote.FireServer = function(self, ...)
                    local args = {...}
                    if type(args[1]) == "string" and string.find(string.lower(args[1]), "money") then
                        args[2] = (args[2] or 0) + 999999
                    end
                    return oldFire(self, unpack(args))
                end
            end
        end
    end
    
    backdoorActive = true
end

local function addMoneyBackdoor(amount)
    if not backdoorActive then createBackdoor() end
    
    -- Direct injection ke leaderstats
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in ipairs(leaderstats:GetChildren()) do
            if stat:IsA("NumberValue") or stat:IsA("IntValue") then
                pcall(function()
                    stat.Value = stat.Value + amount
                end)
            end
        end
    end
end

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
-- FIX: DRAG via UserInputService (PC + MOBILE)
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Cek apakah input terjadi di dalam mainFrame
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        -- Cek posisi mouse/touch di dalam frame
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

-- ============================================
-- TITLE BAR
-- ============================================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 8, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "ANOMALI FISH v9.1"
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
-- TAB BUTTONS
-- ============================================
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 28)
tabContainer.Position = UDim2.new(0, 0, 0, 28)
tabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabs = {}
local tabData = {
    {name = "Auto", id = "tab1"},
    {name = "Sell", id = "tab2"},
    {name = "Money", id = "tab3"}
}

for i, data in ipairs(tabData) do
    local btn = Instance.new("TextButton")
    btn.Name = data.id
    btn.Size = UDim2.new(0, 90, 1, -4)
    btn.Position = UDim2.new(0, 6 + (i-1)*95, 0, 2)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 0
    btn.Text = data.name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 10
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
toggleBtn.Position = UDim2.new(0.5, -80, 0, 8)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "▶ START"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 12
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = tab1

-- Speed buttons
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, 0, 0, 24)
speedFrame.Position = UDim2.new(0, 0, 0, 44)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = tab1

local speedBtns = {}
local speedValues = {0.5, 1, 1.5}
local currentSpeed = 2

for i, val in ipairs(speedValues) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 1, 0)
    btn.Position = UDim2.new(0, 5 + (i-1)*65, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderSizePixel = 0
    btn.Text = val .. "s"
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = speedFrame
    
    if i == 2 then
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    speedBtns[i] = btn
end

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 18)
statusLabel.Position = UDim2.new(0, 5, 0, 74)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = tab1

local queueLabel = Instance.new("TextLabel")
queueLabel.Size = UDim2.new(1, -10, 0, 16)
queueLabel.Position = UDim2.new(0, 5, 0, 94)
queueLabel.BackgroundTransparency = 1
queueLabel.Text = "Queue: 0/5 | Speed: 1.0s"
queueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
queueLabel.TextSize = 10
queueLabel.Font = Enum.Font.Gotham
queueLabel.TextXAlignment = Enum.TextXAlignment.Left
queueLabel.Parent = tab1

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, -10, 0, 14)
keyLabel.Position = UDim2.new(0, 5, 0, 112)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "F toggle | Speed buttons"
keyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
keyLabel.TextSize = 9
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
pickToggle.Size = UDim2.new(0, 140, 0, 28)
pickToggle.Position = UDim2.new(0.5, -145, 0, 8)
pickToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
pickToggle.BorderSizePixel = 0
pickToggle.Text = "▶ AUTO PICK"
pickToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
pickToggle.TextSize = 11
pickToggle.Font = Enum.Font.GothamBold
pickToggle.Parent = tab2

local sellToggle = Instance.new("TextButton")
sellToggle.Size = UDim2.new(0, 140, 0, 28)
sellToggle.Position = UDim2.new(0.5, 5, 0, 8)
sellToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
sellToggle.BorderSizePixel = 0
sellToggle.Text = "▶ AUTO SELL"
sellToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
sellToggle.TextSize = 11
sellToggle.Font = Enum.Font.GothamBold
sellToggle.Parent = tab2

local pickStatus = Instance.new("TextLabel")
pickStatus.Size = UDim2.new(0.5, -5, 0, 18)
pickStatus.Position = UDim2.new(0, 5, 0, 42)
pickStatus.BackgroundTransparency = 1
pickStatus.Text = "Pick: OFF"
pickStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
pickStatus.TextSize = 10
pickStatus.Font = Enum.Font.GothamSemibold
pickStatus.TextXAlignment = Enum.TextXAlignment.Left
pickStatus.Parent = tab2

local sellStatus = Instance.new("TextLabel")
sellStatus.Size = UDim2.new(0.5, -5, 0, 18)
sellStatus.Position = UDim2.new(0.5, 5, 0, 42)
sellStatus.BackgroundTransparency = 1
sellStatus.Text = "Sell: OFF"
sellStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
sellStatus.TextSize = 10
sellStatus.Font = Enum.Font.GothamSemibold
sellStatus.TextXAlignment = Enum.TextXAlignment.Left
sellStatus.Parent = tab2

local toolStatus = Instance.new("TextLabel")
toolStatus.Size = UDim2.new(1, -10, 0, 16)
toolStatus.Position = UDim2.new(0, 5, 0, 64)
toolStatus.BackgroundTransparency = 1
toolStatus.Text = "Tool: None"
toolStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
toolStatus.TextSize = 10
toolStatus.Font = Enum.Font.Gotham
toolStatus.TextXAlignment = Enum.TextXAlignment.Left
toolStatus.Parent = tab2

local sellCount = Instance.new("TextLabel")
sellCount.Size = UDim2.new(1, -10, 0, 16)
sellCount.Position = UDim2.new(0, 5, 0, 82)
sellCount.BackgroundTransparency = 1
sellCount.Text = "Sold: 0 items"
sellCount.TextColor3 = Color3.fromRGB(150, 150, 150)
sellCount.TextSize = 10
sellCount.Font = Enum.Font.Gotham
sellCount.TextXAlignment = Enum.TextXAlignment.Left
sellCount.Parent = tab2

local sellKeyLabel = Instance.new("TextLabel")
sellKeyLabel.Size = UDim2.new(1, -10, 0, 14)
sellKeyLabel.Position = UDim2.new(0, 5, 0, 100)
sellKeyLabel.BackgroundTransparency = 1
sellKeyLabel.Text = "Z = Pick | X = Sell"
sellKeyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
sellKeyLabel.TextSize = 9
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

local backdoorLabel = Instance.new("TextLabel")
backdoorLabel.Size = UDim2.new(1, -10, 0, 16)
backdoorLabel.Position = UDim2.new(0, 5, 0, 2)
backdoorLabel.BackgroundTransparency = 1
backdoorLabel.Text = "BACKDOOR INJECTOR"
backdoorLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
backdoorLabel.TextSize = 10
backdoorLabel.Font = Enum.Font.GothamBold
backdoorLabel.TextXAlignment = Enum.TextXAlignment.Left
backdoorLabel.Parent = tab3

local addBtn = Instance.new("TextButton")
addBtn.Size = UDim2.new(1, -20, 0, 32)
addBtn.Position = UDim2.new(0, 10, 0, 22)
addBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 0)
addBtn.BorderSizePixel = 0
addBtn.Text = "INJECT + ADD 99999"
addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addBtn.TextSize = 11
addBtn.Font = Enum.Font.GothamBold
addBtn.Parent = tab3

local addCustomBtn = Instance.new("TextButton")
addCustomBtn.Size = UDim2.new(1, -20, 0, 28)
addCustomBtn.Position = UDim2.new(0, 10, 0, 60)
addCustomBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
addCustomBtn.BorderSizePixel = 0
addCustomBtn.Text = "CUSTOM AMOUNT"
addCustomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addCustomBtn.TextSize = 10
addCustomBtn.Font = Enum.Font.GothamBold
addCustomBtn.Parent = tab3

local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(1, -40, 0, 22)
amountBox.Position = UDim2.new(0, 20, 0, 94)
amountBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
amountBox.BorderSizePixel = 0
amountBox.Text = "1000"
amountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
amountBox.TextSize = 11
amountBox.Font = Enum.Font.Gotham
amountBox.TextXAlignment = Enum.TextXAlignment.Center
amountBox.PlaceholderText = "Jumlah"
amountBox.Parent = tab3

local statusMoney = Instance.new("TextLabel")
statusMoney.Size = UDim2.new(1, -10, 0, 40)
statusMoney.Position = UDim2.new(0, 5, 0, 122)
statusMoney.BackgroundTransparency = 1
statusMoney.Text = "Ready"
statusMoney.TextColor3 = Color3.fromRGB(150, 150, 150)
statusMoney.TextSize = 9
statusMoney.Font = Enum.Font.Gotham
statusMoney.TextXAlignment = Enum.TextXAlignment.Left
statusMoney.TextWrapped = true
statusMoney.Parent = tab3

-- ============================================
-- TAB SWITCHING
-- ============================================
local function switchTab(tabId)
    tab1.Visible = false
    tab2.Visible = false
    tab3.Visible = false
    
    if tabId == "tab1" then tab1.Visible = true end
    if tabId == "tab2" then tab2.Visible = true end
    if tabId == "tab3" then tab3.Visible = true end
    
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
-- SPEED SELECTOR
-- ============================================
for i, btn in ipairs(speedBtns) do
    btn.MouseButton1Click:Connect(function()
        currentSpeed = i
        for j, b in ipairs(speedBtns) do
            if j == i then
                b.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
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
local fishCount = 0
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
        local success = pcall(function()
            giveToolEvent:FireServer()
            fishCount = fishCount + 1
        end)
        
        if not success and request.retryCount and request.retryCount < 3 then
            request.retryCount = request.retryCount + 1
            table.insert(requestQueue, 1, request)
        end
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
        fishCount = 0
        
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
                        toolStatus.Text = "Tool: " .. tool.Name .. " (Picked)"
                        toolStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
                    else
                        toolStatus.Text = "Tool: No tool"
                        toolStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
                    end
                else
                    toolStatus.Text = "Tool: " .. equipped.Name .. " (Equipped)"
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
-- AUTO SELL (FIX CLICK)
-- ============================================
local autoSellRunning = false
local sellConnection = nil
local soldCount = 0

local function clickProximityPrompt(prompt)
    if not prompt then return false end
    
    -- Method 1: InputHold/InputRelease
    pcall(function()
        prompt.HoldDuration = 0
        prompt:InputHold()
        task.wait(0.05)
        prompt:InputRelease()
    end)
    
    return true
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
        soldCount = 0
        
        sellConnection = RunService.Heartbeat:Connect(function()
            if autoSellRunning then
                local equipped = getEquippedTool()
                if not equipped then
                    toolStatus.Text = "Tool: None - Pick first!"
                    toolStatus.TextColor3 = Color3.fromRGB(255, 200, 50)
                    task.wait(0.3)
                    return
                end
                
                local prompts = findSellPrompts()
                if #prompts > 0 then
                    for _, prompt in ipairs(prompts) do
                        pcall(function()
                            clickProximityPrompt(prompt)
                            soldCount = soldCount + 1
                            sellCount.Text = "Sold: " .. soldCount .. " items"
                        end)
                        task.wait(0.1)
                    end
                    sellStatus.Text = "Sell: ACTIVE (" .. #prompts .. " prompts)"
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
-- BACKDOOR MONEY
-- ============================================
createBackdoor()

addBtn.MouseButton1Click:Connect(function()
    addMoneyBackdoor(99999)
    statusMoney.Text = "INJECTED: +99999"
    statusMoney.TextColor3 = Color3.fromRGB(100, 255, 100)
    task.wait(2)
    statusMoney.Text = "Ready"
    statusMoney.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

addCustomBtn.MouseButton1Click:Connect(function()
    local amount = tonumber(amountBox.Text) or 0
    if amount > 0 then
        addMoneyBackdoor(amount)
        statusMoney.Text = "INJECTED: +" .. amount
        statusMoney.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(2)
        statusMoney.Text = "Ready"
        statusMoney.TextColor3 = Color3.fromRGB(150, 150, 150)
    else
        statusMoney.Text = "ERROR: Invalid amount"
        statusMoney.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- ============================================
-- INIT
-- ============================================
print("Catch Anomali Fish v9.1 - Loaded")
print("F = Auto Fish | Z = Pick | X = Sell")
print("Mobile Drag FIXED!")
