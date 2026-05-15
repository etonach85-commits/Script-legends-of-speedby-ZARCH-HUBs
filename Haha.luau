--[[
 ╔══════════════════════════════════════════════════════════════════════════════╗
 ║ LEGENDS OF SPEED - LITE EDITION                                              ║
 ║ WindUI Framework                                                             ║
 ║ Version: 5.2.0 LITE                                                          ║
 ║ Features: 50% | Pets: -15 | Trails: -15                                      ║
 ╚══════════════════════════════════════════════════════════════════════════════╝
--]]

-- ============================================================================
-- SECTION 1: LIBRARY LOADING
-- ============================================================================

local WindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
))()

-- ============================================================================
-- SECTION 2: SERVICES & REFERENCES
-- ============================================================================

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local rEvents = ReplicatedStorage:WaitForChild("rEvents")
local orbEvent = rEvents:WaitForChild("orbEvent")
local cPetShopFolder = ReplicatedStorage:WaitForChild("cPetShopFolder")
local cPetShopRemote = ReplicatedStorage:WaitForChild("cPetShopRemote")

-- ============================================================================
-- SECTION 3: SETTINGS
-- ============================================================================

local Settings = {
    OrbEnabled = false,
    OrbType = "Gem",
    OrbMap = "City",
    OrbDelay = "100",
    OrbBurst = "1",
    
    AutoPet = false,
    SelectedPet = "Speedy Sensei",
    PetBuyDelay = "500",
    AutoTrail = false,
    SelectedTrail = "Red Trail",
    TrailBuyDelay = "500",
    
    NoClip = false,
    SpeedBoost = false,
    SpeedValue = "32",
    JumpBoost = false,
    JumpValue = "75",
    
    CurrentTheme = "Dark",
    Notifications = true,
}

-- ============================================================================
-- SECTION 4: LISTS (REDUCED)
-- ============================================================================

-- PetList: 37 - 15 = 22 pets
local PetList = {
    "Red Bunny", "Red Kitty", "Green Vampy", "Blue Bunny", "Dark Golem",
    "Silver Dog", "Pink Butterfly", "Purple Pegasus", "Yellow Squeak",
    "Yellow Butterfly", "Green Golem", "Golden Angel", "Orange Pegasus",
    "Golden Pheonix", "Orange Falcon", "Green Firecaster", "Blue Firecaster",
    "White Pheonix", "Red Pheonix", "Red Firecaster", "Flaming Hedgehog",
    "Speedy Sensei"
}

-- TrailList: 22 - 15 = 7 trails
local TrailList = {
    "Default Trail", "Blue Trail", "Red Trail", "Pink Sparks",
    "Purple Trail", "Orange Trail", "White Phoenix"
}

local OrbTypes = {"Gem", "Red Orb", "Yellow Orb", "Orange Orb", "Ethereal Orb"}

local Maps = {
    ["City"] = CFrame.new(-9682, 65, 3105),
    ["Magma City"] = CFrame.new(-11055, 215, 4892),
    ["Snow City"] = CFrame.new(-9672, 60, 3769),
    ["Speed Jungle"] = CFrame.new(-15261, 404, 5572),
    ["Legends Highway"] = CFrame.new(-13103, 220, 5903),
}

-- ============================================================================
-- SECTION 5: UTILITY FUNCTIONS
-- ============================================================================

local function Notify(title, content, icon, duration)
    if Settings.Notifications then
        WindUI:Notify({
            Title = title,
            Content = content,
            Icon = icon or "info",
            Duration = duration or 3,
        })
    end
end

local function ValidateNumber(str, default)
    local num = tonumber(str)
    if num and num > 0 then return num end
    return default
end

local function GetHumanoid()
    local char = LocalPlayer.Character
    if char then return char:FindFirstChildOfClass("Humanoid") end
    return nil
end

local function GetHRP()
    local char = LocalPlayer.Character
    if char then return char:FindFirstChild("HumanoidRootPart") end
    return nil
end

local function TeleportTo(cf)
    local hrp = GetHRP()
    if hrp then
        hrp.CFrame = cf
        Notify("Teleport", "Berhasil teleport!", "map", 2)
        return true
    end
    Notify("Error", "Character tidak ditemukan!", "error", 2)
    return false
end

-- ============================================================================
-- SECTION 6: ORB FARM
-- ============================================================================

local OrbFarmRunning = false

local function CollectOrb()
    pcall(function()
        local burst = ValidateNumber(Settings.OrbBurst, 1)
        for i = 1, burst do
            task.spawn(function()
                orbEvent:FireServer("collectOrb", Settings.OrbType, Settings.OrbMap)
            end)
        end
    end)
end

local function StartOrbFarm()
    if OrbFarmRunning then return end
    OrbFarmRunning = true
    Notify("Orb Farm", "Auto collect dimulai!", "play", 2)
    
    task.spawn(function()
        while OrbFarmRunning do
            if Settings.OrbEnabled then
                CollectOrb()
            end
            task.wait(ValidateNumber(Settings.OrbDelay, 100) / 1000)
        end
    end)
end

local function StopOrbFarm()
    OrbFarmRunning = false
    Notify("Orb Farm", "Auto collect dihentikan!", "pause", 2)
end

-- ============================================================================
-- SECTION 7: SHOP SYSTEM
-- ============================================================================

local function BuyPet(petName)
    local success, result = pcall(function()
        local item = cPetShopFolder:FindFirstChild(petName)
        if item then
            cPetShopRemote:InvokeServer(item)
            return true
        end
        return false
    end)
    return success and result
end

local function BuyTrail(trailName)
    local success, result = pcall(function()
        local item = cPetShopFolder:FindFirstChild(trailName)
        if item then
            cPetShopRemote:InvokeServer(item)
            return true
        end
        return false
    end)
    return success and result
end

task.spawn(function()
    while true do
        if Settings.AutoPet then
            BuyPet(Settings.SelectedPet)
            task.wait(ValidateNumber(Settings.PetBuyDelay, 500) / 1000)
        end
        if Settings.AutoTrail then
            BuyTrail(Settings.SelectedTrail)
            task.wait(ValidateNumber(Settings.TrailBuyDelay, 500) / 1000)
        end
        task.wait(0.1)
    end
end)

-- ============================================================================
-- SECTION 8: MOVEMENT HACKS
-- ============================================================================

task.spawn(function()
    while true do
        if Settings.NoClip and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        task.wait(0.03)
    end
end)

task.spawn(function()
    while true do
        if Settings.SpeedBoost then
            local hum = GetHumanoid()
            if hum then
                hum.WalkSpeed = ValidateNumber(Settings.SpeedValue, 32)
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if Settings.JumpBoost then
            local hum = GetHumanoid()
            if hum then
                hum.JumpPower = ValidateNumber(Settings.JumpValue, 75)
            end
        end
        task.wait(0.1)
    end
end)

-- ============================================================================
-- SECTION 9: UI CREATION
-- ============================================================================

local Window = WindUI:CreateWindow({
    Title = "Legends of Speed LITE",
    Icon = "zap",
    Theme = Settings.CurrentTheme,
    Folder = "LoS_Lite",
    Size = UDim2.fromOffset(600, 480),
    OpenButton = {
        Title = "LoS Lite",
        Enabled = true,
        Draggable = true,
    },
})

Window:SetToggleKey(Enum.KeyCode.RightShift)

Window:Tag({
    Title = "v5.2.0 LITE",
    Icon = "feather",
    Color = Color3.fromRGB(100, 200, 255),
})

local MainSection = Window:Section({ Title = "Main" })
local ExtraSection = Window:Section({ Title = "Extra" })
local ConfigSection = Window:Section({ Title = "Config" })

-- TAB 1: ORB FARM
local OrbTab = MainSection:Tab({
    Title = "Orb Farm",
    Icon = "circle",
    IconColor = Color3.fromRGB(0, 255, 150),
})

local OrbControl = OrbTab:Section({ Title = "⚡ Control", Box = true, Opened = true })

OrbControl:Toggle({
    Title = "Auto Collect",
    Desc = "Aktifkan farming orb",
    Flag = "OrbEnabled",
    Value = Settings.OrbEnabled,
    Callback = function(state)
        Settings.OrbEnabled = state
        if state then StartOrbFarm() else StopOrbFarm() end
    end,
})

OrbControl:Button({
    Title = "Collect Once",
    Icon = "zap",
    Justify = "Center",
    Callback = function()
        CollectOrb()
        Notify("Orb", "Collect manual berhasil!", "check", 2)
    end,
})

local OrbSettings = OrbTab:Section({ Title = "⚙️ Settings", Box = true, Opened = true })

OrbSettings:Dropdown({
    Title = "Orb Type",
    Flag = "OrbType",
    Values = OrbTypes,
    Value = Settings.OrbType,
    Callback = function(value) Settings.OrbType = value end,
})

OrbSettings:Dropdown({
    Title = "Map Location",
    Flag = "OrbMap",
    Values = {"City", "Magma City", "Snow City", "Speed Jungle", "Legends Highway"},
    Value = Settings.OrbMap,
    Callback = function(value) Settings.OrbMap = value end,
})

OrbSettings:Input({
    Title = "Delay (ms)",
    Flag = "OrbDelay",
    Value = Settings.OrbDelay,
    Numeric = true,
    Callback = function(value) Settings.OrbDelay = value end,
})

OrbSettings:Input({
    Title = "Burst Amount",
    Flag = "OrbBurst",
    Value = Settings.OrbBurst,
    Numeric = true,
    Callback = function(value) Settings.OrbBurst = value end,
})

-- TAB 2: AUTO SHOP
local ShopTab = MainSection:Tab({
    Title = "Auto Shop",
    Icon = "shopping-cart",
    IconColor = Color3.fromRGB(255, 150, 0),
})

local PetSection = ShopTab:Section({ Title = "🐾 Auto Pet", Box = true, Opened = true })

PetSection:Toggle({
    Title = "Auto Buy Pet",
    Flag = "AutoPet",
    Value = Settings.AutoPet,
    Callback = function(state)
        Settings.AutoPet = state
        if state then Notify("Auto Pet", "Auto buy aktif!", "play", 2) end
    end,
})

PetSection:Dropdown({
    Title = "Selected Pet",
    Flag = "SelectedPet",
    Values = PetList,
    Value = Settings.SelectedPet,
    Callback = function(value) Settings.SelectedPet = value end,
})

PetSection:Input({
    Title = "Buy Delay (ms)",
    Flag = "PetBuyDelay",
    Value = Settings.PetBuyDelay,
    Numeric = true,
    Callback = function(value) Settings.PetBuyDelay = value end,
})

PetSection:Button({
    Title = "Buy Pet Now",
    Icon = "shopping-bag",
    Justify = "Center",
    Callback = function()
        if BuyPet(Settings.SelectedPet) then
            Notify("Pet", Settings.SelectedPet .. " dibeli!", "check", 2)
        else
            Notify("Error", "Gagal membeli pet!", "error", 2)
        end
    end,
})

local TrailSection = ShopTab:Section({ Title = "✨ Auto Trail", Box = true, Opened = true })

TrailSection:Toggle({
    Title = "Auto Buy Trail",
    Flag = "AutoTrail",
    Value = Settings.AutoTrail,
    Callback = function(state)
        Settings.AutoTrail = state
        if state then Notify("Auto Trail", "Auto buy aktif!", "play", 2) end
    end,
})

TrailSection:Dropdown({
    Title = "Selected Trail",
    Flag = "SelectedTrail",
    Values = TrailList,
    Value = Settings.SelectedTrail,
    Callback = function(value) Settings.SelectedTrail = value end,
})

TrailSection:Input({
    Title = "Buy Delay (ms)",
    Flag = "TrailBuyDelay",
    Value = Settings.TrailBuyDelay,
    Numeric = true,
    Callback = function(value) Settings.TrailBuyDelay = value end,
})

TrailSection:Button({
    Title = "Buy Trail Now",
    Icon = "sparkles",
    Justify = "Center",
    Callback = function()
        if BuyTrail(Settings.SelectedTrail) then
            Notify("Trail", Settings.SelectedTrail .. " dibeli!", "check", 2)
        else
            Notify("Error", "Gagal membeli trail!", "error", 2)
        end
    end,
})

-- TAB 3: TELEPORT
local TeleportTab = ExtraSection:Tab({
    Title = "Teleport",
    Icon = "map",
    IconColor = Color3.fromRGB(100, 150, 255),
})

local MapSection = TeleportTab:Section({ Title = "🗺️ Maps", Box = true, Opened = true })

for name, cf in pairs(Maps) do
    MapSection:Button({
        Title = "TP: " .. name,
        Icon = "map-pin",
        Justify = "Left",
        Callback = function() TeleportTo(cf) end,
    })
    MapSection:Space({ Columns = 1 })
end

-- TAB 4: MOVEMENT
local MovementTab = ExtraSection:Tab({
    Title = "Movement",
    Icon = "move",
    IconColor = Color3.fromRGB(100, 255, 100),
})

local MoveSection = MovementTab:Section({ Title = "🏃 Hacks", Box = true, Opened = true })

MoveSection:Toggle({
    Title = "NoClip",
    Desc = "Tembus dinding",
    Flag = "NoClip",
    Value = Settings.NoClip,
    Callback = function(state)
        Settings.NoClip = state
        Notify("NoClip", state and "Aktif!" or "Nonaktif!", state and "check" or "x", 2)
    end,
})

MoveSection:Toggle({
    Title = "Speed Boost",
    Flag = "SpeedBoost",
    Value = Settings.SpeedBoost,
    Callback = function(state)
        Settings.SpeedBoost = state
        if not state then
            local hum = GetHumanoid()
            if hum then hum.WalkSpeed = 16 end
        end
    end,
})

MoveSection:Input({
    Title = "Speed Value",
    Flag = "SpeedValue",
    Value = Settings.SpeedValue,
    Numeric = true,
    Callback = function(value) Settings.SpeedValue = value end,
})

MoveSection:Toggle({
    Title = "Jump Boost",
    Flag = "JumpBoost",
    Value = Settings.JumpBoost,
    Callback = function(state)
        Settings.JumpBoost = state
        if not state then
            local hum = GetHumanoid()
            if hum then hum.JumpPower = 50 end
        end
    end,
})

MoveSection:Input({
    Title = "Jump Value",
    Flag = "JumpValue",
    Value = Settings.JumpValue,
    Numeric = true,
    Callback = function(value) Settings.JumpValue = value end,
})

-- TAB 5: CONFIG
local ConfigTab = ConfigSection:Tab({
    Title = "Config",
    Icon = "settings",
    IconColor = Color3.fromRGB(150, 150, 255),
})

local ConfigManager = Window.ConfigManager
local CurrentConfig = "default"

local ConfigSectionUI = ConfigTab:Section({ Title = "💾 Config", Box = true, Opened = true })

ConfigSectionUI:Input({
    Title = "Config Name",
    Flag = "ConfigName",
    Value = CurrentConfig,
    Callback = function(value) CurrentConfig = value end,
})

ConfigSectionUI:Button({
    Title = "Save Config",
    Icon = "save",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:Config(CurrentConfig)
        if Window.CurrentConfig:Save() then
            Notify("Config", "Disimpan: " .. CurrentConfig, "check", 2)
        end
    end,
})

ConfigSectionUI:Button({
    Title = "Load Config",
    Icon = "folder-open",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:CreateConfig(CurrentConfig)
        if Window.CurrentConfig:Load() then
            Notify("Config", "Dimuat: " .. CurrentConfig, "refresh-cw", 2)
        end
    end,
})

local UISettings = ConfigTab:Section({ Title = "🎨 UI", Box = true, Opened = true })

UISettings:Dropdown({
    Title = "Theme",
    Flag = "UITheme",
    Values = {"Dark", "Light", "Rose", "Indigo", "Sky"},
    Value = Settings.CurrentTheme,
    Callback = function(value)
        Settings.CurrentTheme = value
        Window:SetTheme(value)
    end,
})

UISettings:Toggle({
    Title = "Notifications",
    Flag = "Notifications",
    Value = Settings.Notifications,
    Callback = function(state) Settings.Notifications = state end,
})

UISettings:Button({
    Title = "Destroy UI",
    Icon = "trash",
    Color = Color3.fromRGB(255, 80, 80),
    Justify = "Center",
    Callback = function() Window:Destroy() end,
})

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

task.delay(1, function()
    Notify("Loaded!", "LoS LITE v5.2.0 Ready!", "zap", 3)
    Notify("Tips", "RightShift = Toggle UI", "info", 3)
end)

if Settings.OrbEnabled then StartOrbFarm() end

print("═══════════════════════════════════════════════════════")
print(" Legends of Speed LITE v5.2.0 - Loaded!")
print(" Features: 5 Tabs | Pets: 22 | Trails: 7")
print("═══════════════════════════════════════════════════════")

return Window
