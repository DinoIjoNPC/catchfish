-- ============================================
-- CATCH A ANOMALI FISH v6.0 - SERVER SIDE MONEY
-- REMOTE EVENT + REMOTE FUNCTION FULL
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

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

-- Cari remote yang paling mungkin untuk money
local function findBestRemote()
    -- Prioritaskan yang namanya mengandung keyword
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
    
    -- Fallback: ambil remote pertama
    if #remoteEvents > 0 then
        return remoteEvents[1], "Event"
    elseif #remoteFunctions > 0 then
        return remoteFunctions[1], "Function"
    end
    
    return nil, nil
end

-- ============================================
-- GUI SIZE KECIL (280x260)
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CatchAnomaliGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 260)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -130)
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
-- TITLE BAR
-- ============================================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 8, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "ANOMALI FISH"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 12
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(1, -48, 0, 3)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minBtn.BorderSizePixel = 0
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 14
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -26, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local openBtn = Instance.new("TextButton")
openBtn.Name = "OpenBtn"
openBtn.Size = UDim2.new(0, 80, 0, 30)
openBtn.Position = UDim2.new(0.5, -40, 0.5, -15)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
openBtn.BorderSizePixel = 0
openBtn.Text = "[OPEN]"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.TextSize = 14
openBtn.Font = Enum.Font.GothamBold
openBtn.Visible = false
openBtn.Parent = screenGui

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
    {name = "Money", id = "tab2"}
}

for i, data in ipairs(tabData) do
    local btn = Instance.new("TextButton")
    btn.Name = data.id
    btn.Size = UDim2.new(0, 80, 1, -4)
    btn.Position = UDim2.new(0, 8 + (i-1)*85, 0, 2)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 0
    btn.Text = data.name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 11
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
-- TAB 2: ADD MONEY (SERVER SIDE ONLY)
-- ============================================
local tab2 = Instance.new("Frame")
tab2.Size = UDim2.new(1, 0, 1, 0)
tab2.BackgroundTransparency = 1
tab2.Visible = false
tab2.Parent = contentFrame

local moneyLabel = Instance.new("TextLabel")
moneyLabel.Size = UDim2.new(1, -10, 0, 16)
moneyLabel.Position = UDim2.new(0, 5, 0, 2)
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "LEADERSTAT NAME"
moneyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
moneyLabel.TextSize = 9
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.Parent = tab2

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
nameBox.Parent = tab2

local amountLabel = Instance.new("TextLabel")
amountLabel.Size = UDim2.new(1, -10, 0, 14)
amountLabel.Position = UDim2.new(0, 5, 0, 46)
amountLabel.BackgroundTransparency = 1
amountLabel.Text = "AMOUNT"
amountLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
amountLabel.TextSize = 9
amountLabel.Font = Enum.Font.GothamBold
amountLabel.TextXAlignment = Enum.TextXAlignment.Left
amountLabel.Parent = tab2

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
amountBox.Parent = tab2

-- Remote Selector Dropdown (simulasi)
local remoteLabel = Instance.new("TextLabel")
remoteLabel.Size = UDim2.new(1, -10, 0, 14)
remoteLabel.Position = UDim2.new(0, 5, 0, 88)
remoteLabel.BackgroundTransparency = 1
remoteLabel.Text = "REMOTE TARGET"
remoteLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
remoteLabel.TextSize = 9
remoteLabel.Font = Enum.Font.GothamBold
remoteLabel.TextXAlignment = Enum.TextXAlignment.Left
remoteLabel.Parent = tab2

local remoteBox = Instance.new("TextBox")
remoteBox.Size = UDim2.new(1, -10, 0, 22)
remoteBox.Position = UDim2.new(0, 5, 0, 104)
remoteBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
remoteBox.BorderSizePixel = 0
remoteBox.Text = "Auto Detect"
remoteBox.TextColor3 = Color3.fromRGB(200, 200, 200)
remoteBox.TextSize = 10
remoteBox.Font = Enum.Font.Gotham
remoteBox.TextXAlignment = Enum.TextXAlignment.Left
remoteBox.PlaceholderText = "Nama Remote (kosongkan untuk auto)"
remoteBox.Parent = tab2

-- Tombol ADD MONEY SERVER SIDE
local addBtnServer = Instance.new("TextButton")
addBtnServer.Size = UDim2.new(1, -20, 0, 30)
addBtnServer.Position = UDim2.new(0, 10, 0, 132)
addBtnServer.BackgroundColor3 = Color3.fromRGB(200, 80, 0)
addBtnServer.BorderSizePixel = 0
addBtnServer.Text = "ADD MONEY (SERVER)"
addBtnServer.TextColor3 = Color3.fromRGB(255, 255, 255)
addBtnServer.TextSize = 12
addBtnServer.Font = Enum.Font.GothamBold
addBtnServer.Parent = tab2

local moneyStatus = Instance.new("TextLabel")
moneyStatus.Size = UDim2.new(1, -10, 0, 30)
moneyStatus.Position = UDim2.new(0, 5, 0, 168)
moneyStatus.BackgroundTransparency = 1
moneyStatus.Text = "Ready"
moneyStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
moneyStatus.TextSize = 9
moneyStatus.Font = Enum.Font.Gotham
moneyStatus.TextXAlignment = Enum.TextXAlignment.Left
moneyStatus.TextWrapped = true
moneyStatus.Parent = tab2

-- ============================================
-- TAB SWITCHING
-- ============================================
local function switchTab(tabId)
    tab1.Visible = false
    tab2.Visible = false
    
    if tabId == "tab1" then tab1.Visible = true end
    if tabId == "tab2" then tab2.Visible = true end
    
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
-- DRAG SYSTEM
-- ============================================
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
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
-- MINIMIZE / CLOSE / OPEN
-- ============================================
local isMinimized = false

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 280, 0, 28)
        minBtn.Text = "+"
        contentFrame.Visible = false
        tabContainer.Visible = false
    else
        mainFrame.Size = UDim2.new(0, 280, 0, 260)
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
-- ADD MONEY SERVER SIDE - REAL
-- ============================================
local function addMoneyServer()
    local statName = nameBox.Text
    local amount = tonumber(amountBox.Text) or 0
    local remoteName = remoteBox.Text
    
    if statName == "" or amount <= 0 then
        moneyStatus.Text = "ERROR: Nama/Jumlah tidak valid"
        moneyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    local targetRemote = nil
    local remoteType = nil
    
    -- Cari remote berdasarkan nama yang dimasukkan
    if remoteName ~= "" and remoteName ~= "Auto Detect" then
        for _, child in ipairs(ReplicatedStorage:GetChildren()) do
            if child.Name == remoteName then
                if child:IsA("RemoteEvent") then
                    targetRemote = child
                    remoteType = "Event"
                elseif child:IsA("RemoteFunction") then
                    targetRemote = child
                    remoteType = "Function"
                end
                break
            end
        end
    else
        -- Auto detect
        targetRemote, remoteType = findBestRemote()
    end
    
    if not targetRemote then
        moneyStatus.Text = "ERROR: Tidak ada Remote ditemukan"
        moneyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    -- ============================================
    -- EKSEKUSI SERVER SIDE
    -- ============================================
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
        -- Fallback: coba FireServer dulu
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

-- ============================================
-- AUTO DETECT REMOTE DI TAB MONEY
-- ============================================
local function updateRemoteList()
    local best, typ = findBestRemote()
    if best then
        remoteBox.Text = best.Name .. " (" .. typ .. ")"
        remoteBox.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        remoteBox.Text = "No Remote Found"
        remoteBox.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

task.wait(1)
updateRemoteList()

-- Refresh setiap 5 detik
game:GetService("RunService").Stepped:Connect(function()
    if tab2.Visible then
        -- Update status remote jika visible
    end
end)

print("Catch A Anomali Fish v6.0 - Server Side Money Loaded")
print("Remote Events found: " .. #remoteEvents)
print("Remote Functions found: " .. #remoteFunctions)
