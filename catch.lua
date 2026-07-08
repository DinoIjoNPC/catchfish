-- ============================================
-- CATCH A ANOMALI FISH v1.0
-- WindUI Dark Edition
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- WindUI Library (pastikan terinstall)
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/windui/windui/main/source.lua"))()

-- Variabel kontrol
local autoFishRunning = false
local autoFishConnection = nil
local giveToolEvent = ReplicatedStorage:WaitForChild("GiveTool")

-- ============================================
-- MAIN UI
-- ============================================
local win = WindUI:Window({
    Title = "Catch A Anomali Fish",
    Theme = "Dark",
    Size = {400, 300},
    Position = {100, 100}
})

-- Tab: Auto Fish
local tab = win:Tab("Auto Fish")

-- Toggle Auto Fish
local toggle = tab:Toggle({
    Title = "Auto Fish (Loop GiveTool)",
    Description = "Fire GiveTool setiap 0.5 detik",
    Default = false,
    Callback = function(state)
        autoFishRunning = state
        if state then
            -- Mulai loop
            autoFishConnection = RunService.Heartbeat:Connect(function()
                if autoFishRunning then
                    pcall(function()
                        giveToolEvent:FireServer()
                    end)
                end
            end)
            -- Juga fire sekali langsung
            pcall(function()
                giveToolEvent:FireServer()
            end)
        else
            -- Hentikan loop
            if autoFishConnection then
                autoFishConnection:Disconnect()
                autoFishConnection = nil
            end
        end
    end
})

-- Label status
local statusLabel = tab:Label({
    Title = "Status: OFF",
    Description = "Toggle untuk memulai"
})

-- Update status label setiap tick
game:GetService("RunService").Stepped:Connect(function()
    if autoFishRunning then
        statusLabel:SetTitle("Status: ACTIVE (Fire setiap 0.5s)")
    else
        statusLabel:SetTitle("Status: OFF")
    end
end)

-- ============================================
-- MODIFIKASI LOOP: Versi lebih agresif (0.1s)
-- ============================================
-- Uncomment baris di bawah untuk loop lebih cepat
-- autoFishConnection = RunService.Heartbeat:Connect(function()
--     if autoFishRunning then
--         for i = 1, 5 do
--             pcall(function()
--                 giveToolEvent:FireServer()
--             end)
--         end
--     end
-- end)

-- ============================================
-- FITUR TAMBAHAN: Keybind (F untuk toggle)
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggle:Toggle()
    end
end)

-- ============================================
-- CLEANUP saat GUI ditutup
-- ============================================
win:OnClose(function()
    if autoFishConnection then
        autoFishConnection:Disconnect()
        autoFishConnection = nil
    end
    autoFishRunning = false
end)

-- ============================================
-- NOTIFIKASI AWAL
-- ============================================
WindUI:Notify({
    Title = "Catch A Anomali Fish",
    Description = "Script loaded. Tekan F untuk toggle Auto Fish.",
    Duration = 3
})

print("Catch A Anomali Fish - Loaded successfully")
