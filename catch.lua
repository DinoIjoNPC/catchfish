-- ============================================
-- CATCH A ANOMALI FISH v7.0
-- DRAG ANYWHERE | AUTO SELL | NO CLOSE BUTTON
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()

local giveToolEvent = ReplicatedStorage:WaitForChild("GiveTool")

-- ============================================
-- DETECT ALL REMOTES FOR SERVER MONEY
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
-- GUI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CatchAnomaliGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 280)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -140)
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
-- DRAG ANYWHERE (seluruh frame)
-- ============================================
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================
-- TITLE BAR (tanpa close, hanya min)
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
    btn.Size = UDim2.new(0, 75, 1, -4)
    btn.Position = UDim2.new(0, 6 + (i-1)*80, 0, 2)
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

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 18)
statusLabel.Position = UDim2.new(0, 5, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = tab1

local queueLabel = Instance.new("TextLabel")
queueLabel.Size = UDim2.new(1, -10, 0, 16)
queueLabel.Position = UDim2.new(0, 5, 0, 65)
queueLabel.BackgroundTransparency = 1
queueLabel.Text = "Queue: 0/5"
queueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
queueLabel.TextSize = 10
queueLabel.Font = Enum.Font.Gotham
queueLabel.TextXAlignment = Enum.TextXAlignment.Left
queueLabel.Parent = tab1

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, -10, 0, 14)
keyLabel.Position = UDim2.new(0, 5, 0, 83)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "F toggle"
keyLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
keyLabel.TextSize = 9
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = tab1

-- ============================================
-- TAB 2: AUTO SELL
-- ============================================
local tab2 = Instance.new("Frame")
tab2.Size = UDim2.new(1, 0, 1, 0)
tab2.BackgroundTransparency = 1
tab2.Visible = false
tab2.Parent = contentFrame

local sellToggle = Instance.new("TextButton")
sellToggle.Size = UDim2.new(0, 160, 0, 30)
sellToggle.Position = UDim2.new(0.5, -80, 0, 8)
sellToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
sellToggle.BorderSizePixel = 0
sellToggle.Text = "▶ AUTO SELL"
sellToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
sellToggle.TextSize = 12
sellToggle.Font = Enum.Font.GothamBold
sellToggle.Parent = tab2

local sellStatus = Instance.new("TextLabel")
sellStatus.Size = UDim2.new(1, -10, 0, 18)
sellStatus.Position = UDim2.new(0, 5, 0, 45)
sellStatus.BackgroundTransparency = 1
sellStatus.Text = "Status: OFF"
sellStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
sellStatus.TextSize = 11
sellStatus.Font = Enum.Font.GothamSemibold
sellStatus.TextXAlignment = Enum.TextXAlignment.Left
sellStatus.Parent = tab2

local toolStatus = Instance.new("TextLabel")
toolStatus.Size = UDim2.new(1, -10, 0, 16)
toolStatus.Position = UDim2.new(0, 5, 0, 65)
toolStatus.BackgroundTransparency = 1
toolStatus.Text = "Tool: None"
toolStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
toolStatus.TextSize = 10
toolStatus.Font = Enum.Font.Gotham
toolStatus.TextXAlignment = Enum.TextXAlignment.Left
toolStatus.Parent = tab2

local promptStatus = Instance.new("TextLabel")
promptStatus.Size = UDim2.new(1, -10, 0, 16)
promptStatus.Position = UDim2.new(0, 5, 0, 83)
promptStatus.BackgroundTransparency = 1
promptStatus.Text = "Prompt: None"
promptStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
promptStatus.TextSize = 10
promptStatus.Font = Enum.Font.Gotham
promptStatus.TextXAlignment = Enum.TextXAlignment.Left
promptStatus.Parent = tab2

local sellKeyLabel = Instance.new("TextLabel")
sellKeyLabel.Size = UDim2.new(1, -10, 0, 14)
sellKeyLabel.Position = UDim2.new(0, 5, 0, 102)
sellKeyLabel.BackgroundTransparency = 1
sellKeyLabel.Text = "G toggle"
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

local moneyLabel = Instance.new("TextLabel")
moneyLabel.Size = UDim2.new(1, -10, 0, 16)
moneyLabel.Position = UDim2.new(0, 5, 0, 2)
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "LEADERSTAT NAME"
moneyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
moneyLabel.TextSize = 9
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.Parent = tab3

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
nameBox.Parent = tab3

local amountLabel = Instance.new("TextLabel")
amountLabel.Size = UDim2.new(1, -10, 0, 14)
amountLabel.Position = UDim2.new(0, 5, 0, 46)
amountLabel.BackgroundTransparency = 1
amountLabel.Text = "AMOUNT"
amountLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
amountLabel.TextSize = 9
amountLabel.Font = Enum.Font.GothamBold
amountLabel.TextXAlignment = Enum.TextXAlignment.Left
amountLabel.Parent = tab3

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
amountBox.Parent = tab3

local addBtnServer = Instance.new("TextButton")
addBtnServer.Size = UDim2.new(1, -20, 0, 28)
addBtnServer.Position = UDim2.new(0, 10, 0, 90)
addBtnServer.BackgroundColor3 = Color3.fromRGB(200, 80, 0)
addBtnServer.BorderSizePixel = 0
addBtnServer.Text = "ADD MONEY (SERVER)"
addBtnServer.TextColor3 = Color3.fromRGB(255, 255, 255)
addBtnServer.TextSize = 10
addBtnServer.Font = Enum.Font.GothamBold
addBtnServer.Parent = tab3

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
moneyStatus.Parent = tab3

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
-- MINIMIZE (tanpa close)
-- ============================================
local isMinimized = false

minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 280, 0, 28)
        minBtn.Text = "+"
        contentFrame.Visible = false
        tabContainer.Visible = false
    else
        mainFrame.Size = UDim2.new(0, 280, 0, 280)
        minBtn.Text = "−"
        contentFrame.Visible = true
        tabContainer.Visible = true
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
local processInterval = 2.5

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
        queueLabel.Text = "Queue: " .. #requestQueue .. "/" .. MAX_QUEUE_SIZE
    else
        queueLabel.Text = "Queue: 0/" .. MAX_QUEUE_SIZE
    end
end)

-- ============================================
-- AUTO SELL LOGIC
-- ============================================
local autoSellRunning = false
local autoSellConnection = nil
local currentTool = nil
local currentPrompt = nil

-- Cari semua ProximityPrompt dengan ActionText mengandung "sell" / "jual"
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

-- Ambil random tool dari backpack atau character
local function getRandomTool()
    local tools = {}
    
    -- Cek character
    if character then
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Tool") then
                table.insert(tools, child)
            end
        end
    end
    
    -- Cek backpack
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

-- Equip tool
local function equipTool(tool)
    if not tool then return false end
    
    -- Jika tool sudah di character, coba pindah ke backpack dulu
    if tool.Parent == character then
        tool.Parent = player:FindFirstChild("Backpack") or player
        task.wait(0.1)
    end
    
    -- Parent ke character untuk equip
    tool.Parent = character
    return true
end

-- Get current equipped tool
local function getEquippedTool()
    if not character then return nil end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            return child
        end
    end
    return nil
end

-- Main Auto Sell Loop
local function autoSellLoop()
    if not autoSellRunning then return end
    
    -- Step 1: Cek tangan kosong
    local equipped = getEquippedTool()
    
    if not equipped then
        -- Tangan kosong, ambil random tool
        local randomTool = getRandomTool()
        if randomTool then
            equipTool(randomTool)
            currentTool = randomTool
            toolStatus.Text = "Tool: " .. randomTool.Name
            toolStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
            task.wait(0.3)
        else
            toolStatus.Text = "Tool: No tool available"
            toolStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
    else
        currentTool = equipped
        toolStatus.Text = "Tool: " .. equipped.Name
        toolStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    
    -- Step 2: Cari ProximityPrompt dengan ActionText "sell"/"jual"
    local prompts = findSellPrompts()
    
    if #prompts > 0 then
        for _, prompt in ipairs(prompts) do
            currentPrompt = prompt
            
            -- Ubah HoldDuration ke 0
            pcall(function()
                prompt.HoldDuration = 0
            end)
            
            promptStatus.Text = "Prompt: " .. prompt.ActionText .. " (HoldDuration=0)"
            promptStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            -- Spam InputHold / InputRelease
            local maxSpam = 3
            for i = 1, maxSpam do
                if not autoSellRunning then break end
                
                pcall(function()
                    prompt:InputHold()
                    task.wait(0.05)
                    prompt:InputRelease()
                end)
                
                task.wait(0.1)
            end
        end
    else
        promptStatus.Text = "Prompt: No sell prompt found"
        promptStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

local function toggleAutoSell()
    autoSellRunning = not autoSellRunning
    
    if autoSellRunning then
        sellToggle.Text = "⏹ STOP SELL"
        sellToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        sellStatus.Text = "Status: ACTIVE"
        sellStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        currentTool = nil
        currentPrompt = nil
        
        autoSellConnection = RunService.Heartbeat:Connect(function()
            if autoSellRunning then
                autoSellLoop()
                task.wait(0.5)
            end
        end)
        
        -- Jalankan sekali langsung
        task.wait(0.3)
        autoSellLoop()
    else
        sellToggle.Text = "▶ AUTO SELL"
        sellToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        sellStatus.Text = "Status: OFF"
        sellStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
        toolStatus.Text = "Tool: None"
        toolStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
        promptStatus.Text = "Prompt: None"
        promptStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
        
        if autoSellConnection then
            autoSellConnection:Disconnect()
            autoSellConnection = nil
        end
    end
end

sellToggle.MouseButton1Click:Connect(toggleAutoSell)

-- Keybind G untuk Auto Sell
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        toggleAutoSell()
    end
end)

-- ============================================
-- ADD MONEY SERVER SIDE
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

-- Auto detect remote display
task.wait(1)
local best, typ = findBestRemote()
if best then
    moneyStatus.Text = "Remote: " .. best.Name .. " (" .. typ .. ") | Ready"
    moneyStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
else
    moneyStatus.Text = "No Remote Found"
    moneyStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
end

print("Catch A Anomali Fish v7.0 - Loaded")
print("F = Auto Fish | G = Auto Sell")
