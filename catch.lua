-- ============================================
-- CATCH A ANOMALI FISH v2.0 - FIXED
-- Fix HTTP 429 dengan Rate Limiting & Jitter
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/windui/windui/main/source.lua"))()

local giveToolEvent = ReplicatedStorage:WaitForChild("GiveTool")

-- Rate Limiter Config
local MIN_INTERVAL = 1.5          -- detik minimal antar request
local MAX_JITTER = 0.5            -- variasi acak
local BACKOFF_MAX = 10.0          -- backoff maksimal jika gagal
local currentInterval = MIN_INTERVAL
local lastFireTime = 0
local consecutiveFailures = 0

local autoFishRunning = false
local autoFishConnection = nil
local isCooldown = false

-- Function dengan Exponential Backoff
local function fireGiveToolWithBackoff()
    local now = tick()
    local elapsed = now - lastFireTime
    
    -- Hitung interval dengan jitter
    local jitter = math.random() * MAX_JITTER
    local effectiveInterval = currentInterval + jitter
    
    if elapsed < effectiveInterval then
        return false, "Cooldown"
    end
    
    local success, err = pcall(function()
        giveToolEvent:FireServer()
    end)
    
    lastFireTime = tick()
    
    if success then
        consecutiveFailures = 0
        currentInterval = MIN_INTERVAL  -- reset ke normal
        return true, "OK"
    else
        consecutiveFailures = consecutiveFailures + 1
        -- Backoff: 2^failures * 0.5 detik, capped di BACKOFF_MAX
        local backoffTime = math.min(0.5 * (2 ^ consecutiveFailures), BACKOFF_MAX)
        currentInterval = math.max(MIN_INTERVAL, backoffTime)
        return false, "Backoff: " .. backoffTime .. "s"
    end
end

-- UI
local win = WindUI:Window({
    Title = "Catch A Anomali Fish",
    Theme = "Dark",
    Size = {400, 320},
    Position = {100, 100}
})

local tab = win:Tab("Auto Fish")

-- Toggle dengan Loop Aman
local toggle = tab:Toggle({
    Title = "Auto Fish (Rate Limited)",
    Description = "Interval 2s + Jitter + Backoff",
    Default = false,
    Callback = function(state)
        autoFishRunning = state
        if state then
            lastFireTime = 0
            consecutiveFailures = 0
            currentInterval = MIN_INTERVAL
            
            autoFishConnection = RunService.Heartbeat:Connect(function()
                if autoFishRunning and not isCooldown then
                    local success, msg = fireGiveToolWithBackoff()
                    if not success and msg ~= "Cooldown" then
                        -- Jika backoff aktif, tampilkan di status
                        statusLabel:SetTitle("Status: BACKOFF - " .. msg)
                    end
                end
            end)
            
            -- Fire pertama langsung
            task.wait(0.5)
            fireGiveToolWithBackoff()
        else
            if autoFishConnection then
                autoFishConnection:Disconnect()
                autoFishConnection = nil
            end
        end
    end
})

local statusLabel = tab:Label({
    Title = "Status: OFF",
    Description = "Interval: 2s | Backoff: ON"
})

-- Update status
RunService.Stepped:Connect(function()
    if autoFishRunning then
        local status = "ACTIVE"
        if consecutiveFailures > 0 then
            status = status .. " | Backoff: " .. currentInterval .. "s"
        end
        statusLabel:SetTitle("Status: " .. status)
    else
        statusLabel:SetTitle("Status: OFF")
    end
end)

-- Keybind F
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggle:Toggle()
    end
end)

win:OnClose(function()
    if autoFishConnection then
        autoFishConnection:Disconnect()
        autoFishConnection = nil
    end
    autoFishRunning = false
end)

WindUI:Notify({
    Title = "Fix Applied",
    Description = "Rate Limit: 2s interval, jitter, backoff",
    Duration = 3
})

print("Catch A Anomali Fish v2.0 - Fixed HTTP 429")
