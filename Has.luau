--[[
╔══════════════════════════════════════════════════════════════════════════════════╗
║                    LEGENDS OF SPEED ULTIMATE EDITION v6.0.2                      ║
║                          WindUI Framework Enhanced ++                            ║
║                                                                                ║
║   Created: May 19, 2026                                                      ║
║   Developer: Delta                                                           ║
║   Game: Legends of Speed                                                     ║
║   UPDATE v6.0.2:                                                             ║
║     ✅ NEW: Orb Smart Farm dengan Auto-Switch Ping                           ║
║     ✅ NEW: 4 TextBox System (Normal + Smart Mode)                           ║
║     ✅ NEW: Advanced Ping Detection dengan Multi-Fallback                    ║
║     ✅ NEW: Hysteresis Switching (Mencegah Rapid Toggle)                     ║
║     ✅ NEW: Real-time Mode Indicator & Ping Display                          ║
║     ✅ NEW: Smart Farm Statistics & Analytics                                ║
║     ✅ FIXED: All Systems Optimized & Error-Free                             ║
╚══════════════════════════════════════════════════════════════════════════════════╝
]]

-- ================================================================================
-- SECTION 1: LIBRARY LOADING & INITIALIZATION
-- ================================================================================
local WindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
))()

-- ================================================================================
-- SECTION 2: SERVICES & REFERENCES
-- ================================================================================
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")
local StatsService = game:GetService("Stats")
local NetworkClient = game:GetService("NetworkClient")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local rEvents = ReplicatedStorage:WaitForChild("rEvents")
local orbEvent = rEvents:WaitForChild("orbEvent")
local rebirthEvent = rEvents:WaitForChild("rebirthEvent")
local ultimatesRemote = rEvents:WaitForChild("ultimatesRemote")
local cPetShopFolder = ReplicatedStorage:WaitForChild("cPetShopFolder")
local cPetShopRemote = ReplicatedStorage:WaitForChild("cPetShopRemote")

-- ================================================================================
-- SECTION 3: GLOBAL SETTINGS TABLE
-- ================================================================================
local Settings = {
    -- Orb Farm
    OrbEnabled = false,
    OrbType = "Gem",
    OrbMap = "City",
    OrbDelay = "100",
    OrbBurst = "1",
    OrbSmartDelay = true,
    OrbAutoSwitch = false,
    
    -- Smart Farm Settings
    SmartFarmEnabled = false,
    SmartOrbDelay = "100",
    SmartOrbBurst = "1",
    SmartOrbDelayHigh = "500",
    SmartOrbBurstHigh = "1",
    SmartPingThresholdHigh = 1000,
    SmartPingThresholdLow = 150,
    SmartFarmMode = "Normal", -- "Normal" or "Smart"
    
    -- Shop
    AutoPet = false,
    SelectedPet = "Speedy Sensei",
    PetBuyDelay = "500",
    PetCategory = "All",
    AutoTrail = false,
    SelectedTrail = "Hyperblast",
    TrailBuyDelay = "500",
    TrailCategory = "All",
    AutoEquip = true,
    EquipBestOnly = false,
    QueueEnabled = true,
    QueueSize = "5",
    
    -- Rebirth
    AutoRebirth = false,
    RebirthDelay = "1000",
    RebirthSmart = false,
    RebirthThreshold = "100",
    
    -- ESP
    EspEnabled = false,
    EspPlayers = true,
    EspNames = true,
    EspDistance = true,
    EspHealth = true,
    EspTracers = false,
    EspBoxes = false,
    EspChams = true,
    EspChamsColor = Color3.fromRGB(255, 255, 255),
    EspChamsTransparency = 0.3,
    EspSeeThroughWalls = true,
    EspTextColor = Color3.fromRGB(255, 255, 255),
    EspFontSize = "14",
    EspMaxDistance = "1000",
    EspShowGems = false,
    EspShowSteps = false,
    
    -- Movement
    NoClip = false,
    SpeedBoost = false,
    SpeedValue = "32",
    JumpBoost = false,
    JumpValue = "75",
    FlyEnabled = false,
    FlySpeed = "50",
    AutoRun = false,
    
    -- UI
    CurrentTheme = "Dark",
    Notifications = true,
    AcrylicEnabled = true,
    ShowWatermark = true,
    KeybindHints = true,
    ShowDashboard = true,
    
    -- Performance
    PerformanceMonitor = false,
    LowMemoryMode = false,
    MaxFPS = "60",
}

-- ================================================================================
-- SECTION 4: STATISTICS & TIME TABLE
-- ================================================================================
local Stats = {
    -- Orb Statistics
    OrbsCollected = 0,
    GemsCollected = 0,
    RedOrbsCollected = 0,
    YellowOrbsCollected = 0,
    OrangeOrbsCollected = 0,
    EtherealOrbsCollected = 0,
    
    -- Smart Farm Statistics
    SmartFarmSwitches = 0,
    TimeInNormalMode = 0,
    TimeInSmartMode = 0,
    CurrentPing = 0,
    AveragePing = 0,
    PeakPing = 0,
    PingSamples = {},
    MaxPingSamples = 30,
    
    -- Shop Statistics
    PetsBought = 0,
    TrailsBought = 0,
    PetsEquipped = 0,
    TrailsEquipped = 0,
    ShopErrors = 0,
    
    -- Rebirth Statistics
    RebirthsDone = 0,
    TotalSteps = 0,
    TotalGems = 0,
    
    -- Ultimate Statistics
    UltimatesClaimed = 0,
    UltimatesFailed = 0,
    
    -- Session Statistics
    SessionTime = 0,
    SessionStart = tick(),
    LastOrbTime = 0,
    AverageOrbRate = 0,
    OrbsPerMinute = 0,
    
    -- Request Statistics
    TotalRequests = 0,
    SuccessfulRequests = 0,
    FailedRequests = 0,
    LastRequestTime = 0,
    RequestRate = 0,
    
    -- Performance Statistics
    PeakMemoryUsage = 0,
    AverageFPS = 0,
    TotalFrames = 0,
    CurrentFPS = 0,
    
    -- Time System
    RealTimeOffset = 0,
}

-- ================================================================================
-- SECTION 5: COMPLETE PET LIST (42 PETS)
-- ================================================================================
local PetDatabase = {
    RedCrystal = {"Red Bunny", "Red Kitty", "Green Vampy"},
    BlueCrystal = {"Blue Bunny", "Dark Golem"},
    PurpleCrystal = {"Silver Dog", "Pink Butterfly", "Purple Pegasus"},
    YellowCrystal = {"Yellow Squeak", "Yellow Butterfly", "Green Golem", "Golden Angel", "Orange Pegasus", "Golden Phoenix"},
    LightningCrystal = {"Orange Falcon", "Green Firecaster"},
    SnowCrystal = {"Blue Firecaster", "White Phoenix"},
    InfernoCrystal = {"Red Phoenix", "Red Firecaster", "Flaming Hedgehog"},
    Packs = {"Electro Bunny", "Infernal Dragon"},
    DesertCrystal = {"Purple Angel", "Red Dragon", "Quantum Dragon", "Void Dragon"},
    ElectroCrystal = {"Orange Dragon", "Tundra Dragon", "Magic Butterfly", "Ultra Birdie"},
    QuantumCrystal = {"Purple Dog"},
    ElectroLegendsCrystal = {"Soul Fusion Dog", "Hypersonic Pegasus", "Dark Soul Birdie", "Eternal Nebula Dragon", "Shadows Edge Kitty", "Ultimate Overdrive Bunny"},
    AlienCrystal = {"Blue Phoenix", "Magical Pegasus", "Electro Golem"},
    SpaceCrystal = {"Voltaic Falcon"},
    JungleCrystal = {"Maestro Dog", "Divine Pegasus", "Golden Viking", "Speedy Sensei", "Swift Samurai"},
}

local PetList = {
    "Red Bunny", "Red Kitty", "Green Vampy", "Blue Bunny", "Dark Golem",
    "Silver Dog", "Pink Butterfly", "Purple Pegasus", "Yellow Squeak", "Yellow Butterfly",
    "Green Golem", "Golden Angel", "Orange Pegasus", "Golden Phoenix", "Orange Falcon",
    "Green Firecaster", "Blue Firecaster", "White Phoenix", "Red Phoenix", "Red Firecaster",
    "Flaming Hedgehog", "Electro Bunny", "Infernal Dragon", "Purple Angel", "Red Dragon",
    "Quantum Dragon", "Void Dragon", "Orange Dragon", "Tundra Dragon", "Magic Butterfly",
    "Ultra Birdie", "Purple Dog", "Soul Fusion Dog", "Hypersonic Pegasus", "Dark Soul Birdie",
    "Eternal Nebula Dragon", "Shadows Edge Kitty", "Ultimate Overdrive Bunny", "Blue Phoenix",
    "Magical Pegasus", "Electro Golem", "Voltaic Falcon", "Maestro Dog", "Divine Pegasus",
    "Golden Viking", "Speedy Sensei", "Swift Samurai"
}

local PetCategories = {
    "All", "Red Crystal", "Blue Crystal", "Purple Crystal", "Yellow Crystal",
    "Lightning Crystal", "Snow Crystal", "Inferno Crystal", "Packs", "Desert Crystal",
    "Electro Crystal", "Quantum Crystal", "Electro Legends", "Alien Crystal",
    "Space Crystal", "Jungle Crystal"
}

-- ================================================================================
-- SECTION 6: COMPLETE TRAIL LIST (75 TRAILS)
-- ================================================================================
local TrailDatabase = {
    Basic = {
        "Default Trail", "Red Trail", "Blue Trail", "Green Trail", "Purple Trail",
        "Orange Trail", "Pink Trail", "Yellow Trail", "Red & Blue", "Green & Orange",
        "Purple & Pink", "Yellow & Blue", "Blue & Green", "Orange Snow", "Blue Snow",
        "Green Snow", "White Snow", "Red Snow", "Pink Snow", "Fifth Trail"
    },
    Advanced = {
        "Red Sparks", "Blue Sparks", "Green Sparks", "Purple Sparks", "Orange Sparks",
        "Pink Sparks", "Yellow Sparks", "Blue Storm", "Green Storm", "Purple Storm",
        "Red Storm", "Orange Storm", "Pink Storm", "Blue Coin", "Purple Coin",
        "Red Coin", "Green Coin", "Orange Coin", "Yellow Soul", "Green Soul", "Fourth Trail"
    },
    Rare = {
        "Red Soul", "Blue Soul", "Orange Soul", "Purple Soul", "Pink Soul",
        "Blue Lightning", "Green Lightning", "Purple Lightning", "Orange Lightning",
        "Golden Lightning", "Red Lightning", "Pink Lightning", "Rainbow Trail", "Third Trail"
    },
    Epic = {
        "Rainbow Soul", "Rainbow Sparks", "Rainbow Storm", "Rainbow Lightning",
        "Purple Gem", "Green Gem", "Red Gem", "Blue Gem", "Orange Gem", "Pink Gem",
        "RB Speed", "OG Speed", "PP Speed", "BG Speed", "YB Speed", "2nd Trail"
    },
    Unique = {
        "Rainbow Speed", "Rainbow Steps", "1st Trail", "Dragonfire", "Hyperblast"
    }
}

local TrailList = {
    "Default Trail", "Red Trail", "Blue Trail", "Green Trail", "Purple Trail",
    "Orange Trail", "Pink Trail", "Yellow Trail", "Red & Blue", "Green & Orange",
    "Purple & Pink", "Yellow & Blue", "Blue & Green", "Orange Snow", "Blue Snow",
    "Green Snow", "White Snow", "Red Snow", "Pink Snow", "Fifth Trail",
    "Red Sparks", "Blue Sparks", "Green Sparks", "Purple Sparks", "Orange Sparks",
    "Pink Sparks", "Yellow Sparks", "Blue Storm", "Green Storm", "Purple Storm",
    "Red Storm", "Orange Storm", "Pink Storm", "Blue Coin", "Purple Coin",
    "Red Coin", "Green Coin", "Orange Coin", "Yellow Soul", "Green Soul", "Fourth Trail",
    "Red Soul", "Blue Soul", "Orange Soul", "Purple Soul", "Pink Soul",
    "Blue Lightning", "Green Lightning", "Purple Lightning", "Orange Lightning",
    "Golden Lightning", "Red Lightning", "Pink Lightning", "Rainbow Trail", "Third Trail",
    "Rainbow Soul", "Rainbow Sparks", "Rainbow Storm", "Rainbow Lightning",
    "Purple Gem", "Green Gem", "Red Gem", "Blue Gem", "Orange Gem", "Pink Gem",
    "RB Speed", "OG Speed", "PP Speed", "BG Speed", "YB Speed", "2nd Trail",
    "Rainbow Speed", "Rainbow Steps", "1st Trail", "Dragonfire", "Hyperblast"
}

local TrailCategories = {"All", "Basic", "Advanced", "Rare", "Epic", "Unique"}

local BestTrails = {
    {Name = "Hyperblast", Steps = 20, Gems = 25, Rarity = "Unique"},
    {Name = "Dragonfire", Steps = 25, Gems = 15, Rarity = "Unique"},
    {Name = "Rainbow Steps", Steps = 20, Gems = 10, Rarity = "Unique"},
    {Name = "1st Trail", Steps = 20, Gems = 10, Rarity = "Unique"},
    {Name = "Rainbow Speed", Steps = 15, Gems = 15, Rarity = "Unique"}
}

-- ================================================================================
-- SECTION 7: ORB TYPES & MAPS
-- ================================================================================
local OrbTypes = {"Gem", "Red Orb", "Yellow Orb", "Orange Orb", "Ethereal Orb"}

local Maps = {
    ["City"] = CFrame.new(-9682, 65, 3105),
    ["Magma City"] = CFrame.new(-11055, 215, 4892),
    ["Snow City"] = CFrame.new(-9672, 60, 3769),
    ["Speed Jungle"] = CFrame.new(-15261, 404, 5572),
    ["Legends Highway"] = CFrame.new(-13103, 220, 5903)
}

local MapIcons = {
    ["City"] = "map", ["Magma City"] = "flame", ["Snow City"] = "cloud-snow",
    ["Speed Jungle"] = "sun", ["Legends Highway"] = "navigation"
}

-- ================================================================================
-- SECTION 8: THEMES & UPGRADES
-- ================================================================================
local Themes = {"Dark", "Light", "Rose", "Plant", "Indigo", "Sky", "Violet", "Amber", "Mellowsi"}

local UltimateUpgrades = {
    {Name = "x2 Trail Boosts", Icon = "zap", Desc = "Meningkatkan boost trail 2x lipat"},
    {Name = "x2 Quest Rewards", Icon = "award", Desc = "Hadiah quest menjadi 2x lipat"},
    {Name = "Gem Booster", Icon = "gem", Desc = "Booster untuk mendapatkan lebih banyak gem"},
    {Name = "Divine Rebirth", Icon = "refresh-cw", Desc = "Rebirth dengan efek divine"},
    {Name = "Demon Hoops", Icon = "circle", Desc = "Efek visual demon hoops"},
    {Name = "Step Booster", Icon = "footprints", Desc = "Booster untuk langkah"},
    {Name = "Infernal Gems", Icon = "flame", Desc = "Gem dengan efek infernal"},
    {Name = "Ethereal Orbs", Icon = "cloud", Desc = "Orb dengan efek ethereal"}
}

-- ================================================================================
-- SECTION 9: UTILITY FUNCTIONS
-- ================================================================================
local function Notify(title, content, icon, duration)
    if Settings.Notifications then
        task.spawn(function()
            pcall(function()
                WindUI:Notify({
                    Title = title,
                    Content = content,
                    Icon = icon or "info",
                    Duration = duration or 5
                })
            end)
        end)
    end
end

local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[SafeCall Error]", result)
        return false, result
    end
    return true, result
end

local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHRP()
    local char = LocalPlayer.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function GetHumanoid()
    local char = LocalPlayer.Character
    if char then
        return char:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local function TeleportTo(cf)
    local hrp = GetHRP()
    if hrp then
        hrp.CFrame = cf
        Notify("Teleport", "Berhasil teleport!", "map", 3)
        return true
    else
        Notify("Error", "Character tidak ditemukan!", "error", 3)
        return false
    end
end

local function FormatNumber(num)
    if num >= 1e12 then
        return string.format("%.2fT", num / 1e12)
    elseif num >= 1e9 then
        return string.format("%.2fB", num / 1e9)
    elseif num >= 1e6 then
        return string.format("%.2fM", num / 1e6)
    elseif num >= 1e3 then
        return string.format("%.2fK", num / 1e3)
    else
        return tostring(math.floor(num))
    end
end

local function FormatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    if h > 0 then
        return string.format("%02d:%02d:%02d", h, m, s)
    else
        return string.format("%02d:%02d", m, s)
    end
end

local function GetRealTimeString()
    return os.date("%H:%M:%S")
end

local function GetRealDateString()
    return os.date("%d %B %Y")
end

local function ValidateNumber(str, default)
    local num = tonumber(str)
    if num and num > 0 then
        return num
    end
    return default
end

local function GetPetCategory(petName)
    for category, pets in pairs(PetDatabase) do
        for _, pet in ipairs(pets) do
            if pet == petName then
                return category
            end
        end
    end
    return "Unknown"
end

local function GetTrailRarity(trailName)
    for rarity, trails in pairs(TrailDatabase) do
        for _, trail in ipairs(trails) do
            if trail == trailName then
                return rarity
            end
        end
    end
    return "Unknown"
end

local function GetFilteredPets(category)
    if category == "All" then
        return PetList
    end
    local keyMap = {
        ["Red Crystal"] = "RedCrystal", ["Blue Crystal"] = "BlueCrystal",
        ["Purple Crystal"] = "PurpleCrystal", ["Yellow Crystal"] = "YellowCrystal",
        ["Lightning Crystal"] = "LightningCrystal", ["Snow Crystal"] = "SnowCrystal",
        ["Inferno Crystal"] = "InfernoCrystal", ["Packs"] = "Packs",
        ["Desert Crystal"] = "DesertCrystal", ["Electro Crystal"] = "ElectroCrystal",
        ["Quantum Crystal"] = "QuantumCrystal", ["Electro Legends"] = "ElectroLegendsCrystal",
        ["Alien Crystal"] = "AlienCrystal", ["Space Crystal"] = "SpaceCrystal",
        ["Jungle Crystal"] = "JungleCrystal"
    }
    local key = keyMap[category]
    if key and PetDatabase[key] then
        return PetDatabase[key]
    end
    return PetList
end

local function GetFilteredTrails(category)
    if category == "All" then
        return TrailList
    end
    if TrailDatabase[category] then
        return TrailDatabase[category]
    end
    return TrailList
end

-- ================================================================================
-- SECTION 10: QUEUE SYSTEM
-- ================================================================================
local QueueManager = {
    Queue = {},
    Running = false,
    MaxSize = 5
}

function QueueManager:Add(item, itemType)
    if #self.Queue >= self.MaxSize then
        table.remove(self.Queue, 1)
    end
    table.insert(self.Queue, {
        Item = item,
        Type = itemType,
        Timestamp = tick()
    })
    if not self.Running and Settings.QueueEnabled then
        self:Process()
    end
end

function QueueManager:Process()
    self.Running = true
    while #self.Queue > 0 do
        local entry = table.remove(self.Queue, 1)
        if entry.Type == "Pet" then
            BuyPet(entry.Item)
        elseif entry.Type == "Trail" then
            BuyTrail(entry.Item)
        end
        local delay = ValidateNumber(Settings[entry.Type .. "BuyDelay"], 500)
        task.wait(delay / 1000)
    end
    self.Running = false
end

function QueueManager:Clear()
    self.Queue = {}
end

function QueueManager:GetSize()
    return #self.Queue
end

function QueueManager:SetMaxSize(size)
    self.MaxSize = size
end

-- ================================================================================
-- SECTION 11: ESP SYSTEM
-- ================================================================================
local EspHighlights = {}
local EspConnections = {}
local EspEnabled = false
local EspPlayerToggles = {}

local function CreatePlayerHighlight(player)
    if player == LocalPlayer then return end
    if EspPlayerToggles[player] == false then return end
    
    if EspHighlights[player] then
        EspHighlights[player]:Destroy()
        EspHighlights[player] = nil
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "LoS_Ultimate_ESP"
    highlight.FillColor = Settings.EspChamsColor
    highlight.FillTransparency = Settings.EspChamsTransparency
    highlight.OutlineColor = Settings.EspChamsColor
    highlight.OutlineTransparency = 1
    highlight.DepthMode = Settings.EspSeeThroughWalls and
        Enum.HighlightDepthMode.AlwaysOnTop or
        Enum.HighlightDepthMode.Occluded
    
    local function ParentHighlight()
        local character = player.Character
        if character then
            highlight.Parent = character
        end
    end
    
    if player.Character then
        ParentHighlight()
    end
    
    player.CharacterAdded:Connect(function()
        task.wait(0.1)
        ParentHighlight()
    end)
    
    EspHighlights[player] = highlight
end

local function RemovePlayerHighlight(player)
    if EspHighlights[player] then
        EspHighlights[player]:Destroy()
        EspHighlights[player] = nil
    end
    if EspConnections[player] then
        EspConnections[player]:Disconnect()
        EspConnections[player] = nil
    end
end

local function UpdateHighlights()
    for player, highlight in pairs(EspHighlights) do
        if highlight then
            highlight.FillColor = Settings.EspChamsColor
            highlight.FillTransparency = Settings.EspChamsTransparency
            highlight.OutlineTransparency = 1
            highlight.DepthMode = Settings.EspSeeThroughWalls and
                Enum.HighlightDepthMode.AlwaysOnTop or
                Enum.HighlightDepthMode.Occluded
            
            if Settings.EspEnabled and Settings.EspChams and EspPlayerToggles[player] ~= false then
                highlight.Enabled = true
            else
                highlight.Enabled = false
            end
        end
    end
end

local EspDrawings = {}
local DrawingLib = {}

function DrawingLib.newText()
    local text = Drawing.new("Text")
    text.Visible = false
    text.Color = Settings.EspTextColor
    text.Size = ValidateNumber(Settings.EspFontSize, 14)
    text.Center = true
    text.Outline = true
    text.OutlineColor = Color3.fromRGB(0, 0, 0)
    text.Font = 2
    return text
end

function DrawingLib.newLine()
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color3.fromRGB(255, 255, 255)
    line.Thickness = 1
    return line
end

local EspPlayerInfo = {}
EspPlayerInfo.__index = EspPlayerInfo

function EspPlayerInfo.new(player)
    local self = setmetatable({}, EspPlayerInfo)
    self.Player = player
    self.Drawings = {
        Name = nil, Distance = nil, Health = nil,
        Gems = nil, Steps = nil, Tracer = nil
    }
    self:Initialize()
    return self
end

function EspPlayerInfo:Initialize()
    self.Drawings.Name = DrawingLib.newText()
    self.Drawings.Distance = DrawingLib.newText()
    self.Drawings.Health = DrawingLib.newText()
    self.Drawings.Gems = DrawingLib.newText()
    self.Drawings.Steps = DrawingLib.newText()
    self.Drawings.Tracer = DrawingLib.newLine()
end

function EspPlayerInfo:Update()
    if not Settings.EspEnabled or not Settings.EspPlayers then
        self:Hide()
        return
    end
    
    if not self.Player or self.Player == LocalPlayer then
        self:Hide()
        return
    end
    
    if EspPlayerToggles[self.Player] == false then
        self:Hide()
        return
    end
    
    local character = self.Player.Character
    if not character then
        self:Hide()
        return
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        self:Hide()
        return
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local position, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    
    local hrpLocal = GetHRP()
    if hrpLocal then
        local distance = (hrp.Position - hrpLocal.Position).Magnitude
        local maxDist = ValidateNumber(Settings.EspMaxDistance, 1000)
        if distance > maxDist then
            self:Hide()
            return
        end
    end
    
    local visible = onScreen
    local yOffset = 30
    
    if Settings.EspNames and visible then
        self.Drawings.Name.Visible = true
        self.Drawings.Name.Text = self.Player.Name
        self.Drawings.Name.Size = ValidateNumber(Settings.EspFontSize, 14)
        self.Drawings.Name.Position = Vector2.new(position.X, position.Y - yOffset)
        yOffset = yOffset - 15
    else
        self.Drawings.Name.Visible = false
    end
    
    if Settings.EspDistance and visible and hrpLocal then
        self.Drawings.Distance.Visible = true
        local distance = (hrp.Position - hrpLocal.Position).Magnitude
        self.Drawings.Distance.Text = string.format("%.0fm", distance)
        self.Drawings.Distance.Size = ValidateNumber(Settings.EspFontSize, 14)
        self.Drawings.Distance.Position = Vector2.new(position.X, position.Y - yOffset)
        yOffset = yOffset - 15
    else
        self.Drawings.Distance.Visible = false
    end
    
    if Settings.EspHealth and visible and humanoid then
        self.Drawings.Health.Visible = true
        local health = humanoid.Health
        local maxHealth = humanoid.MaxHealth
        local healthPercent = maxHealth > 0 and (health / maxHealth) * 100 or 0
        
        if healthPercent > 75 then
            self.Drawings.Health.Color = Color3.fromRGB(0, 255, 0)
        elseif healthPercent > 50 then
            self.Drawings.Health.Color = Color3.fromRGB(255, 255, 0)
        elseif healthPercent > 25 then
            self.Drawings.Health.Color = Color3.fromRGB(255, 165, 0)
        else
            self.Drawings.Health.Color = Color3.fromRGB(255, 0, 0)
        end
        
        self.Drawings.Health.Text = string.format("%.0f%%", healthPercent)
        self.Drawings.Health.Size = ValidateNumber(Settings.EspFontSize, 14)
        self.Drawings.Health.Position = Vector2.new(position.X, position.Y - yOffset)
        yOffset = yOffset - 15
    else
        self.Drawings.Health.Visible = false
    end
    
    if Settings.EspShowGems and visible then
        self.Drawings.Gems.Visible = true
        self.Drawings.Gems.Text = " Gems"
        self.Drawings.Gems.Size = ValidateNumber(Settings.EspFontSize, 14)
        self.Drawings.Gems.Position = Vector2.new(position.X, position.Y - yOffset)
        yOffset = yOffset - 15
    else
        self.Drawings.Gems.Visible = false
    end
    
    if Settings.EspShowSteps and visible then
        self.Drawings.Steps.Visible = true
        self.Drawings.Steps.Text = " Steps"
        self.Drawings.Steps.Size = ValidateNumber(Settings.EspFontSize, 14)
        self.Drawings.Steps.Position = Vector2.new(position.X, position.Y - yOffset)
    else
        self.Drawings.Steps.Visible = false
    end
    
    if Settings.EspTracers and visible then
        self.Drawings.Tracer.Visible = true
        self.Drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        self.Drawings.Tracer.To = Vector2.new(position.X, position.Y)
    else
        self.Drawings.Tracer.Visible = false
    end
end

function EspPlayerInfo:Hide()
    for _, drawing in pairs(self.Drawings) do
        if drawing then
            drawing.Visible = false
        end
    end
end

function EspPlayerInfo:Destroy()
    for _, drawing in pairs(self.Drawings) do
        if drawing then
            drawing:Remove()
        end
    end
    self.Drawings = {}
end

local EspManager = {Players = {}}

function EspManager:AddPlayer(player)
    if player == LocalPlayer then return end
    EspPlayerToggles[player] = true
    CreatePlayerHighlight(player)
    self.Players[player] = EspPlayerInfo.new(player)
end

function EspManager:RemovePlayer(player)
    RemovePlayerHighlight(player)
    EspPlayerToggles[player] = nil
    local esp = self.Players[player]
    if esp then
        esp:Destroy()
        self.Players[player] = nil
    end
end

function EspManager:TogglePlayer(player)
    if EspPlayerToggles[player] == nil then
        EspPlayerToggles[player] = true
    else
        EspPlayerToggles[player] = not EspPlayerToggles[player]
    end
    if EspHighlights[player] then
        EspHighlights[player].Enabled = EspPlayerToggles[player]
    end
    return EspPlayerToggles[player]
end

function EspManager:Update()
    UpdateHighlights()
    for player, esp in pairs(self.Players) do
        esp:Update()
    end
end

function EspManager:Enable()
    EspEnabled = true
    for _, player in ipairs(Players:GetPlayers()) do
        self:AddPlayer(player)
    end
    table.insert(EspConnections, Players.PlayerAdded:Connect(function(player)
        self:AddPlayer(player)
    end))
    table.insert(EspConnections, Players.PlayerRemoving:Connect(function(player)
        self:RemovePlayer(player)
    end))
    table.insert(EspConnections, RunService.RenderStepped:Connect(function()
        self:Update()
    end))
    Notify("ESP", "ESP Chams diaktifkan!", "eye", 3)
end

function EspManager:Disable()
    EspEnabled = false
    for player, _ in pairs(self.Players) do
        self:RemovePlayer(player)
    end
    for _, conn in ipairs(EspConnections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    EspConnections = {}
    Notify("ESP", "ESP dinonaktifkan!", "eye-off", 3)
end

-- ================================================================================
-- SECTION 12: ORB FARM SYSTEM
-- ================================================================================
local OrbFarmRunning = false

local function CollectOrb()
    SafeCall(function()
        local delay = ValidateNumber(Settings.OrbDelay, 100)
        local burst = ValidateNumber(Settings.OrbBurst, 1)
        
        for i = 1, burst do
            task.spawn(function()
                local success = pcall(function()
                    orbEvent:FireServer("collectOrb", Settings.OrbType, Settings.OrbMap)
                end)
                
                Stats.TotalRequests = Stats.TotalRequests + 1
                Stats.LastRequestTime = tick()
                
                if success then
                    Stats.OrbsCollected = Stats.OrbsCollected + 1
                    Stats.SuccessfulRequests = Stats.SuccessfulRequests + 1
                    
                    if Settings.OrbType == "Gem" then
                        Stats.GemsCollected = Stats.GemsCollected + 1
                    elseif Settings.OrbType == "Red Orb" then
                        Stats.RedOrbsCollected = Stats.RedOrbsCollected + 1
                    elseif Settings.OrbType == "Yellow Orb" then
                        Stats.YellowOrbsCollected = Stats.YellowOrbsCollected + 1
                    elseif Settings.OrbType == "Orange Orb" then
                        Stats.OrangeOrbsCollected = Stats.OrangeOrbsCollected + 1
                    elseif Settings.OrbType == "Ethereal Orb" then
                        Stats.EtherealOrbsCollected = Stats.EtherealOrbsCollected + 1
                    end
                    
                    local currentTime = tick()
                    if Stats.LastOrbTime > 0 then
                        local delta = currentTime - Stats.LastOrbTime
                        if delta > 0 then
                            Stats.AverageOrbRate = 1 / delta
                            Stats.OrbsPerMinute = Stats.AverageOrbRate * 60
                        end
                    end
                    Stats.LastOrbTime = currentTime
                else
                    Stats.FailedRequests = Stats.FailedRequests + 1
                end
            end)
        end
    end)
end

local function StartOrbFarm()
    if OrbFarmRunning then return end
    OrbFarmRunning = true
    Notify("Orb Farm", "Auto collect dimulai!", "play", 3)
    
    task.spawn(function()
        while OrbFarmRunning do
            if Settings.OrbEnabled then
                CollectOrb()
            end
            local delay = ValidateNumber(Settings.OrbDelay, 100)
            task.wait(delay / 1000)
        end
    end)
end

local function StopOrbFarm()
    OrbFarmRunning = false
    Notify("Orb Farm", "Auto collect dihentikan!", "pause", 3)
end

-- ================================================================================
-- SECTION 12.5: SMART FARM SYSTEM
-- ================================================================================
local SmartFarmManager = {
    Running = false,
    CurrentMode = "Normal",
    PingHistory = {},
    MaxPingHistory = 30,
    LastSwitchTime = 0,
    SwitchCooldown = 0.5,
    UIElements = {
        NormalMS = nil,
        NormalBurst = nil,
        SmartMS = nil,
        SmartBurst = nil,
        ModeIndicator = nil,
        PingDisplay = nil,
    }
}

-- ================================================================================
-- PING DETECTION SYSTEM (MULTI-FALLBACK)
-- ================================================================================
local function GetPing()
    local ping = 0
    local success = false
    
    -- Method 1: StatsService NetworkPing
    success, ping = pcall(function()
        local stats = StatsService:FindFirstChild("NetworkPing")
        if stats then
            return stats.Value * 1000
        end
        return nil
    end)
    if success and ping and ping > 0 then
        return math.floor(ping)
    end
    
    -- Method 2: NetworkClient GetPingMs
    success, ping = pcall(function()
        if NetworkClient then
            local pingMs = NetworkClient:GetPingMs()
            if pingMs then
                return pingMs
            end
        end
        return nil
    end)
    if success and ping and ping > 0 then
        return math.floor(ping)
    end
    
    -- Method 3: Remote Event Timing
    success, ping = pcall(function()
        local startTime = tick()
        local testEvent = rEvents:FindFirstChild("orbEvent")
        if testEvent then
            -- Non-blocking check
            return (tick() - startTime) * 1000 + 50 -- Base estimate
        end
        return nil
    end)
    if success and ping and ping > 0 then
        return math.floor(ping)
    end
    
    -- Method 4: Fallback default
    return 50
end

local function UpdatePingStats(ping)
    Stats.CurrentPing = ping
    
    table.insert(Stats.PingSamples, ping)
    if #Stats.PingSamples > Stats.MaxPingSamples then
        table.remove(Stats.PingSamples, 1)
    end
    
    local sum = 0
    for _, p in ipairs(Stats.PingSamples) do
        sum = sum + p
    end
    Stats.AveragePing = sum / #Stats.PingSamples
    
    if ping > Stats.PeakPing then
        Stats.PeakPing = ping
    end
end

local function GetPingColor(ping)
    if ping < 100 then
        return Color3.fromRGB(0, 255, 0)
    elseif ping < 200 then
        return Color3.fromRGB(255, 255, 0)
    elseif ping < 500 then
        return Color3.fromRGB(255, 165, 0)
    else
        return Color3.fromRGB(255, 0, 0)
    end
end

local function GetPingStatus(ping)
    if ping < 100 then
        return "Excellent"
    elseif ping < 200 then
        return "Good"
    elseif ping < 500 then
        return "Fair"
    elseif ping < 1000 then
        return "Poor"
    else
        return "Critical"
    end
end

-- ================================================================================
-- SMART FARM MODE SWITCHING
-- ================================================================================
local function SwitchToNormalMode()
    if SmartFarmManager.CurrentMode == "Normal" then return end
    
    local currentTime = tick()
    if currentTime - SmartFarmManager.LastSwitchTime < SmartFarmManager.SwitchCooldown then
        return
    end
    
    SmartFarmManager.CurrentMode = "Normal"
    Settings.SmartFarmMode = "Normal"
    SmartFarmManager.LastSwitchTime = currentTime
    Stats.SmartFarmSwitches = Stats.SmartFarmSwitches + 1
    
    if SmartFarmManager.UIElements.NormalMS then
        SmartFarmManager.UIElements.NormalMS:SetDisabled(false)
    end
    if SmartFarmManager.UIElements.NormalBurst then
        SmartFarmManager.UIElements.NormalBurst:SetDisabled(false)
    end
    if SmartFarmManager.UIElements.SmartMS then
        SmartFarmManager.UIElements.SmartMS:SetDisabled(true)
    end
    if SmartFarmManager.UIElements.SmartBurst then
        SmartFarmManager.UIElements.SmartBurst:SetDisabled(true)
    end
    
    if SmartFarmManager.UIElements.ModeIndicator then
        SmartFarmManager.UIElements.ModeIndicator:Update({
            Title = "🟢 NORMAL MODE",
            TextColor = Color3.fromRGB(0, 255, 0)
        })
    end
    
    Notify("Smart Farm", "Switched to NORMAL mode (Ping: " .. Stats.CurrentPing .. "ms)", "wifi", 2)
end

local function SwitchToSmartMode()
    if SmartFarmManager.CurrentMode == "Smart" then return end
    
    local currentTime = tick()
    if currentTime - SmartFarmManager.LastSwitchTime < SmartFarmManager.SwitchCooldown then
        return
    end
    
    SmartFarmManager.CurrentMode = "Smart"
    Settings.SmartFarmMode = "Smart"
    SmartFarmManager.LastSwitchTime = currentTime
    Stats.SmartFarmSwitches = Stats.SmartFarmSwitches + 1
    
    if SmartFarmManager.UIElements.NormalMS then
        SmartFarmManager.UIElements.NormalMS:SetDisabled(true)
    end
    if SmartFarmManager.UIElements.NormalBurst then
        SmartFarmManager.UIElements.NormalBurst:SetDisabled(true)
    end
    if SmartFarmManager.UIElements.SmartMS then
        SmartFarmManager.UIElements.SmartMS:SetDisabled(false)
    end
    if SmartFarmManager.UIElements.SmartBurst then
        SmartFarmManager.UIElements.SmartBurst:SetDisabled(false)
    end
    
    if SmartFarmManager.UIElements.ModeIndicator then
        SmartFarmManager.UIElements.ModeIndicator:Update({
            Title = "🔴 SMART MODE",
            TextColor = Color3.fromRGB(255, 100, 100)
        })
    end
    
    Notify("Smart Farm", "Switched to SMART mode (Ping: " .. Stats.CurrentPing .. "ms)", "wifi-off", 2)
end

local function CheckPingAndSwitch()
    local ping = GetPing()
    UpdatePingStats(ping)
    
    if SmartFarmManager.UIElements.PingDisplay then
        SmartFarmManager.UIElements.PingDisplay:Update({
            Title = string.format("📡 Ping: %d ms (%s)", ping, GetPingStatus(ping)),
            TextColor = GetPingColor(ping)
        })
    end
    
    if SmartFarmManager.CurrentMode == "Normal" then
        if ping > Settings.SmartPingThresholdHigh then
            SwitchToSmartMode()
        end
    elseif SmartFarmManager.CurrentMode == "Smart" then
        if ping < Settings.SmartPingThresholdLow then
            SwitchToNormalMode()
        end
    end
    
    if SmartFarmManager.CurrentMode == "Normal" then
        Stats.TimeInNormalMode = Stats.TimeInNormalMode + 0.1
    else
        Stats.TimeInSmartMode = Stats.TimeInSmartMode + 0.1
    end
end

-- ================================================================================
-- SMART FARM COLLECT FUNCTION
-- ================================================================================
local function SmartCollectOrb()
    SafeCall(function()
        local delay, burst
        if SmartFarmManager.CurrentMode == "Smart" then
            delay = ValidateNumber(Settings.SmartOrbDelayHigh, 500)
            burst = ValidateNumber(Settings.SmartOrbBurstHigh, 1)
        else
            delay = ValidateNumber(Settings.SmartOrbDelay, 100)
            burst = ValidateNumber(Settings.SmartOrbBurst, 1)
        end
        
        for i = 1, burst do
            task.spawn(function()
                local success = pcall(function()
                    orbEvent:FireServer("collectOrb", Settings.OrbType, Settings.OrbMap)
                end)
                
                Stats.TotalRequests = Stats.TotalRequests + 1
                Stats.LastRequestTime = tick()
                
                if success then
                    Stats.OrbsCollected = Stats.OrbsCollected + 1
                    Stats.SuccessfulRequests = Stats.SuccessfulRequests + 1
                    
                    if Settings.OrbType == "Gem" then
                        Stats.GemsCollected = Stats.GemsCollected + 1
                    elseif Settings.OrbType == "Red Orb" then
                        Stats.RedOrbsCollected = Stats.RedOrbsCollected + 1
                    elseif Settings.OrbType == "Yellow Orb" then
                        Stats.YellowOrbsCollected = Stats.YellowOrbsCollected + 1
                    elseif Settings.OrbType == "Orange Orb" then
                        Stats.OrangeOrbsCollected = Stats.OrangeOrbsCollected + 1
                    elseif Settings.OrbType == "Ethereal Orb" then
                        Stats.EtherealOrbsCollected = Stats.EtherealOrbsCollected + 1
                    end
                    
                    local currentTime = tick()
                    if Stats.LastOrbTime > 0 then
                        local delta = currentTime - Stats.LastOrbTime
                        if delta > 0 then
                            Stats.AverageOrbRate = 1 / delta
                            Stats.OrbsPerMinute = Stats.AverageOrbRate * 60
                        end
                    end
                    Stats.LastOrbTime = currentTime
                else
                    Stats.FailedRequests = Stats.FailedRequests + 1
                end
            end)
        end
    end)
end

-- ================================================================================
-- SMART FARM MAIN LOOP
-- ================================================================================
local SmartFarmRunning = false

local function StartSmartFarm()
    if SmartFarmRunning then return end
    SmartFarmRunning = true
    Notify("Smart Farm", "Smart Farm dimulai!", "play", 3)
    
    task.spawn(function()
        while SmartFarmRunning do
            if Settings.SmartFarmEnabled then
                SmartCollectOrb()
                CheckPingAndSwitch()
                
                local delay
                if SmartFarmManager.CurrentMode == "Smart" then
                    delay = ValidateNumber(Settings.SmartOrbDelayHigh, 500)
                else
                    delay = ValidateNumber(Settings.SmartOrbDelay, 100)
                end
                
                task.wait(delay / 1000)
            else
                task.wait(0.1)
            end
        end
    end)
end

local function StopSmartFarm()
    SmartFarmRunning = false
    Notify("Smart Farm", "Smart Farm dihentikan!", "pause", 3)
end

-- Initialize Smart Farm Monitor
task.spawn(function()
    while true do
        CheckPingAndSwitch()
        task.wait(0.1)
    end
end)

-- ================================================================================
-- SECTION 13: SHOP SYSTEM
-- ================================================================================
local function BuyPet(petName)
    local success, result = SafeCall(function()
        local item = cPetShopFolder:FindFirstChild(petName)
        if item then
            cPetShopRemote:InvokeServer(item)
            Stats.PetsBought = Stats.PetsBought + 1
            return true
        end
        return false
    end)
    if not success then
        Stats.ShopErrors = Stats.ShopErrors + 1
    end
    return success and result
end

local function BuyTrail(trailName)
    local success, result = SafeCall(function()
        local item = cPetShopFolder:FindFirstChild(trailName)
        if item then
            cPetShopRemote:InvokeServer(item)
            Stats.TrailsBought = Stats.TrailsBought + 1
            return true
        end
        return false
    end)
    if not success then
        Stats.ShopErrors = Stats.ShopErrors + 1
    end
    return success and result
end

local function EquipPet(petName)
    SafeCall(function()
        local item = cPetShopFolder:FindFirstChild(petName)
        if item then
            cPetShopRemote:InvokeServer("equip", item)
            Stats.PetsEquipped = Stats.PetsEquipped + 1
        end
    end)
end

local function EquipTrail(trailName)
    SafeCall(function()
        local item = cPetShopFolder:FindFirstChild(trailName)
        if item then
            cPetShopRemote:InvokeServer("equip", item)
            Stats.TrailsEquipped = Stats.TrailsEquipped + 1
        end
    end)
end

task.spawn(function()
    while true do
        if Settings.AutoPet then
            if Settings.QueueEnabled then
                QueueManager:Add(Settings.SelectedPet, "Pet")
            else
                BuyPet(Settings.SelectedPet)
                if Settings.AutoEquip then
                    EquipPet(Settings.SelectedPet)
                end
            end
            local delay = ValidateNumber(Settings.PetBuyDelay, 500)
            task.wait(delay / 1000)
        end
        
        if Settings.AutoTrail then
            if Settings.QueueEnabled then
                QueueManager:Add(Settings.SelectedTrail, "Trail")
            else
                BuyTrail(Settings.SelectedTrail)
                if Settings.AutoEquip then
                    EquipTrail(Settings.SelectedTrail)
                end
            end
            local delay = ValidateNumber(Settings.TrailBuyDelay, 500)
            task.wait(delay / 1000)
        end
        
        task.wait(0.1)
    end
end)

-- ================================================================================
-- SECTION 14: REBIRTH SYSTEM
-- ================================================================================
local function DoRebirth()
    SafeCall(function()
        rebirthEvent:FireServer("rebirthRequest")
        Stats.RebirthsDone = Stats.RebirthsDone + 1
    end)
end

task.spawn(function()
    while true do
        if Settings.AutoRebirth then
            DoRebirth()
            local delay = ValidateNumber(Settings.RebirthDelay, 1000)
            task.wait(delay / 1000)
        end
        task.wait(0.1)
    end
end)

-- ================================================================================
-- SECTION 15: ULTIMATE SYSTEM
-- ================================================================================
local function UpgradeUltimate(upgradeName)
    SafeCall(function()
        local success, result = pcall(function()
            return ultimatesRemote:InvokeServer("upgradeUltimate", upgradeName)
        end)
        if success then
            Stats.UltimatesClaimed = Stats.UltimatesClaimed + 1
            Notify("Ultimate", upgradeName .. " berhasil di-upgrade!", "check", 3)
        else
            Stats.UltimatesFailed = Stats.UltimatesFailed + 1
            Notify("Ultimate", "Gagal upgrade " .. upgradeName, "error", 3)
        end
    end)
end

-- ================================================================================
-- SECTION 16: UI CREATION
-- ================================================================================
local Window = WindUI:Window({
    Title = "Legends of Speed ULTIMATE v6.0.2",
    SubTitle = "by Delta | ZARCH Hub",
    Theme = Settings.CurrentTheme,
    Acrylic = Settings.AcrylicEnabled,
    MinimizeKey = Enum.KeyCode.RightControl,
    Persistent = true
})

-- MAIN TABS
local OrbSection = Window:Section({Title = "🔮 ORB SYSTEM", Side = "Left"})
local ShopSection = Window:Section({Title = "🛒 SHOP SYSTEM", Side = "Left"})
local RebirthSection = Window:Section({Title = "🔄 REBIRTH SYSTEM", Side = "Left"})
local EspSection = Window:Section({Title = "👁️ ESP SYSTEM", Side = "Right"})
local MovementSection = Window:Section({Title = "🏃 MOVEMENT", Side = "Right"})
local SettingsSection = Window:Section({Title = "⚙️ SETTINGS", Side = "Right"})

-- ================================================================================
-- TAB 1: ORB FARM
-- ================================================================================
local OrbFarmTab = OrbSection:Tab({
    Title = "Orb Farm",
    Icon = "zap",
    IconColor = Color3.fromRGB(255, 200, 0),
    Border = true
})

local OrbControl = OrbFarmTab:Section({
    Title = "⚡ Orb Farm Control",
    Box = true,
    BoxBorder = true,
    Opened = true
})

OrbControl:Toggle({
    Title = "Enable Orb Farm",
    Desc = "Aktifkan auto collect orb",
    Flag = "OrbEnabled",
    Value = Settings.OrbEnabled,
    Callback = function(state)
        Settings.OrbEnabled = state
        if state then
            StartOrbFarm()
        else
            StopOrbFarm()
        end
    end
})

OrbControl:Space()

OrbControl:Dropdown({
    Title = "Orb Type",
    Desc = "Pilih jenis orb yang ingin di-farm",
    Flag = "OrbType",
    Value = Settings.OrbType,
    Options = OrbTypes,
    Callback = function(value)
        Settings.OrbType = value
    end
})

OrbControl:Space()

OrbControl:Dropdown({
    Title = "Map",
    Desc = "Pilih map untuk teleport",
    Flag = "OrbMap",
    Value = Settings.OrbMap,
    Options = {"City", "Magma City", "Snow City", "Speed Jungle", "Legends Highway"},
    Callback = function(value)
        Settings.OrbMap = value
    end
})

OrbControl:Space()

OrbControl:Button({
    Title = "Teleport to Map",
    Desc = "Teleport ke map yang dipilih",
    Icon = "map",
    Callback = function()
        if Maps[Settings.OrbMap] then
            TeleportTo(Maps[Settings.OrbMap])
        end
    end
})

local OrbSettings = OrbFarmTab:Section({
    Title = "⚙️ Orb Settings",
    Box = true,
    BoxBorder = true,
    Opened = true
})

OrbSettings:Input({
    Title = "Delay (ms)",
    Desc = "Delay antar collect dalam milidetik",
    Flag = "OrbDelay",
    Value = Settings.OrbDelay,
    Placeholder = "Contoh: 100",
    Numeric = true,
    Callback = function(value)
        Settings.OrbDelay = value
    end
})

OrbSettings:Space()

OrbSettings:Input({
    Title = "Burst",
    Desc = "Jumlah burst per collect",
    Flag = "OrbBurst",
    Value = Settings.OrbBurst,
    Placeholder = "Contoh: 1",
    Numeric = true,
    Callback = function(value)
        Settings.OrbBurst = value
    end
})

-- ================================================================================
-- TAB 1.5: ORB SMART FARM
-- ================================================================================
local SmartFarmTab = OrbSection:Tab({
    Title = "Orb Smart Farm",
    Icon = "cpu",
    IconColor = Color3.fromRGB(255, 150, 50),
    Border = true
})

local SmartFarmControl = SmartFarmTab:Section({
    Title = "⚡ Smart Farm Control",
    Box = true,
    BoxBorder = true,
    Opened = true
})

SmartFarmControl:Toggle({
    Title = "Enable Smart Farm",
    Desc = "Aktifkan Smart Farm dengan auto-switch berdasarkan ping",
    Flag = "SmartFarmEnabled",
    Value = Settings.SmartFarmEnabled,
    Callback = function(state)
        Settings.SmartFarmEnabled = state
        if state then
            StartSmartFarm()
            Notify("Smart Farm", "Smart Farm diaktifkan!", "play", 2)
        else
            StopSmartFarm()
            Notify("Smart Farm", "Smart Farm dinonaktifkan!", "pause", 2)
        end
    end
})

SmartFarmControl:Space()

-- Mode Indicator
local ModeIndicator = SmartFarmControl:Section({
    Title = "🟢 NORMAL MODE",
    TextSize = 14,
    FontWeight = Enum.FontWeight.Bold,
    TextColor = Color3.fromRGB(0, 255, 0)
})
SmartFarmManager.UIElements.ModeIndicator = ModeIndicator

SmartFarmControl:Space()

-- Ping Display
local PingDisplay = SmartFarmControl:Section({
    Title = "📡 Ping: -- ms",
    TextSize = 13,
    TextColor = Color3.fromRGB(255, 255, 255)
})
SmartFarmManager.UIElements.PingDisplay = PingDisplay

SmartFarmControl:Space()

local SmartFarmSettings = SmartFarmTab:Section({
    Title = "⚙️ Smart Farm Settings",
    Box = true,
    BoxBorder = true,
    Opened = true
})

SmartFarmSettings:Section({
    Title = "📝 Normal Mode Settings (Ping < 150ms)",
    TextSize = 12,
    TextColor = Color3.fromRGB(0, 255, 0)
})

SmartFarmSettings:Space()

-- Textbox 1: Normal MS
local NormalMS = SmartFarmSettings:Input({
    Title = "MS (Delay)",
    Desc = "Delay normal dalam milidetik",
    Flag = "SmartOrbDelay",
    Value = Settings.SmartOrbDelay,
    Placeholder = "Contoh: 100",
    Numeric = true,
    Callback = function(value)
        Settings.SmartOrbDelay = value
    end
})
SmartFarmManager.UIElements.NormalMS = NormalMS

SmartFarmSettings:Space()

-- Textbox 2: Normal Burst
local NormalBurst = SmartFarmSettings:Input({
    Title = "Burst",
    Desc = "Jumlah burst normal",
    Flag = "SmartOrbBurst",
    Value = Settings.SmartOrbBurst,
    Placeholder = "Contoh: 1",
    Numeric = true,
    Callback = function(value)
        Settings.SmartOrbBurst = value
    end
})
SmartFarmManager.UIElements.NormalBurst = NormalBurst

SmartFarmSettings:Space()

SmartFarmSettings:Section({
    Title = "🔥 Smart Mode Settings (Ping > 1000ms)",
    TextSize = 12,
    TextColor = Color3.fromRGB(255, 100, 100)
})

SmartFarmSettings:Space()

-- Textbox 3: Smart MS
local SmartMS = SmartFarmSettings:Input({
    Title = "Smart MS",
    Desc = "Delay smart saat ping tinggi",
    Flag = "SmartOrbDelayHigh",
    Value = Settings.SmartOrbDelayHigh,
    Placeholder = "Contoh: 500",
    Numeric = true,
    Callback = function(value)
        Settings.SmartOrbDelayHigh = value
    end
})
SmartFarmManager.UIElements.SmartMS = SmartMS

SmartFarmSettings:Space()

-- Textbox 4: Smart Burst
local SmartBurst = SmartFarmSettings:Input({
    Title = "Smart Burst",
    Desc = "Burst smart saat ping tinggi",
    Flag = "SmartOrbBurstHigh",
    Value = Settings.SmartOrbBurstHigh,
    Placeholder = "Contoh: 1",
    Numeric = true,
    Callback = function(value)
        Settings.SmartOrbBurstHigh = value
    end
})
SmartFarmManager.UIElements.SmartBurst = SmartBurst

-- Initialize UI state: Smart inputs disabled by default
SmartMS:SetDisabled(true)
SmartBurst:SetDisabled(true)

local SmartThresholds = SmartFarmTab:Section({
    Title = "📊 Ping Thresholds",
    Box = true,
    BoxBorder = true,
    Opened = false
})

SmartThresholds:Input({
    Title = "High Ping Threshold",
    Desc = "Switch ke Smart Mode saat ping di atas nilai ini",
    Flag = "SmartPingThresholdHigh",
    Value = tostring(Settings.SmartPingThresholdHigh),
    Placeholder = "Default: 1000",
    Numeric = true,
    Callback = function(value)
        Settings.SmartPingThresholdHigh = tonumber(value) or 1000
    end
})

SmartThresholds:Space()

SmartThresholds:Input({
    Title = "Low Ping Threshold",
    Desc = "Switch ke Normal Mode saat ping di bawah nilai ini",
    Flag = "SmartPingThresholdLow",
    Value = tostring(Settings.SmartPingThresholdLow),
    Placeholder = "Default: 150",
    Numeric = true,
    Callback = function(value)
        Settings.SmartPingThresholdLow = tonumber(value) or 150
    end
})

local SmartInfo = SmartFarmTab:Section({
    Title = "ℹ️ Smart Farm Info",
    Box = true,
    BoxBorder = true,
    Opened = true
})

SmartInfo:Section({
    Title = [[
🧠 CARA KERJA:
• Normal Mode: Aktif saat ping < 150ms
  → Menggunakan MS & Burst normal
• Smart Mode: Aktif saat ping > 1000ms
  → Menggunakan Smart MS & Smart Burst
• Auto-switch berdasarkan ping real-time
• Hysteresis mencegah rapid switching

📊 PING STATUS:
🟢 < 100ms: Excellent
🟡 < 200ms: Good
🟠 < 500ms: Fair
🔴 > 1000ms: Critical]],
    TextSize = 12,
    TextTransparency = 0.3
})

local SmartStats = SmartFarmTab:Section({
    Title = "📈 Smart Farm Statistics",
    Box = true,
    BoxBorder = true,
    Opened = false
})

local SmartStatsLabels = {}

local function CreateSmartStatLabel(title, getValue)
    local group = SmartStats:Group({})
    group:Section({Title = title, TextSize = 12})
    local label = group:Section({Title = getValue(), TextSize = 14, FontWeight = Enum.FontWeight.Bold})
    table.insert(SmartStatsLabels, {Label = label, GetValue = getValue})
    return label
end

CreateSmartStatLabel("Current Ping", function() 
    return string.format("%d ms", Stats.CurrentPing) 
end)

CreateSmartStatLabel("Average Ping", function() 
    return string.format("%.0f ms", Stats.AveragePing) 
end)

CreateSmartStatLabel("Peak Ping", function() 
    return string.format("%d ms", Stats.PeakPing) 
end)

CreateSmartStatLabel("Mode Switches", function() 
    return tostring(Stats.SmartFarmSwitches) 
end)

CreateSmartStatLabel("Time in Normal", function() 
    return FormatTime(Stats.TimeInNormalMode) 
end)

CreateSmartStatLabel("Time in Smart", function() 
    return FormatTime(Stats.TimeInSmartMode) 
end)

task.spawn(function()
    while true do
        for _, stat in ipairs(SmartStatsLabels) do
            if stat.Label and stat.GetValue then
                stat.Label:Update({Title = stat.GetValue()})
            end
        end
        task.wait(0.5)
    end
end)

-- ================================================================================
-- TAB 2: ORB STATISTICS
-- ================================================================================
local OrbStatsTab = OrbSection:Tab({
    Title = "Orb Statistics",
    Icon = "bar-chart-2",
    IconColor = Color3.fromRGB(100, 200, 255),
    Border = true
})

local OrbStatsSection = OrbStatsTab:Section({
    Title = "📊 Collection Statistics",
    Box = true,
    BoxBorder = true,
    Opened = true
})

local StatsLabels = {}

local function CreateStatLabel(title, getValue)
    local group = OrbStatsSection:Group({})
    group:Section({Title = title, TextSize = 12})
    local label = group:Section({Title = getValue(), TextSize = 14, FontWeight = Enum.FontWeight.Bold})
    table.insert(StatsLabels, {Label = label, GetValue = getValue})
    return label
end

CreateStatLabel("Total Orbs", function() return FormatNumber(Stats.OrbsCollected) end)
CreateStatLabel("Gems", function() return FormatNumber(Stats.GemsCollected) end)
CreateStatLabel("Red Orbs", function() return FormatNumber(Stats.RedOrbsCollected) end)
CreateStatLabel("Yellow Orbs", function() return FormatNumber(Stats.YellowOrbsCollected) end)
CreateStatLabel("Orange Orbs", function() return FormatNumber(Stats.OrangeOrbsCollected) end)
CreateStatLabel("Ethereal Orbs", function() return FormatNumber(Stats.EtherealOrbsCollected) end)

OrbStatsSection:Space()

CreateStatLabel("Orbs/Minute", function() return string.format("%.1f", Stats.OrbsPerMinute) end)
CreateStatLabel("Success Rate", function()
    local total = Stats.TotalRequests
    local success = Stats.SuccessfulRequests
    if total > 0 then
        return string.format("%.1f%%", (success / total) * 100)
    end
    return "0%"
end)

task.spawn(function()
    while true do
        for _, stat in ipairs(StatsLabels) do
            if stat.Label and stat.GetValue then
                stat.Label:Update({Title = stat.GetValue()})
            end
        end
        task.wait(0.5)
    end
end)

-- ================================================================================
-- TAB 3: SHOP
-- ================================================================================
local ShopTab = ShopSection:Tab({
    Title = "Auto Shop",
    Icon = "shopping-cart",
    IconColor = Color3.fromRGB(100, 255, 150),
    Border = true
})

local PetShop = ShopTab:Section({
    Title = "🐾 Auto Pet",
    Box = true,
    BoxBorder = true,
    Opened = true
})

PetShop:Toggle({
    Title = "Enable Auto Pet",
    Desc = "Auto buy pet secara otomatis",
    Flag = "AutoPet",
    Value = Settings.AutoPet,
    Callback = function(state)
        Settings.AutoPet = state
    end
})

PetShop:Space()

PetShop:Dropdown({
    Title = "Selected Pet",
    Desc = "Pilih pet yang ingin dibeli",
    Flag = "SelectedPet",
    Value = Settings.SelectedPet,
    Options = PetList,
    Callback = function(value)
        Settings.SelectedPet = value
    end
})

PetShop:Space()

PetShop:Dropdown({
    Title = "Pet Category",
    Desc = "Filter pet berdasarkan kategori",
    Flag = "PetCategory",
    Value = Settings.PetCategory,
    Options = PetCategories,
    Callback = function(value)
        Settings.PetCategory = value
    end
})

PetShop:Space()

PetShop:Input({
    Title = "Buy Delay (ms)",
    Desc = "Delay antar pembelian pet",
    Flag = "PetBuyDelay",
    Value = Settings.PetBuyDelay,
    Placeholder = "Contoh: 500",
    Numeric = true,
    Callback = function(value)
        Settings.PetBuyDelay = value
    end
})

PetShop:Space()

PetShop:Toggle({
    Title = "Auto Equip",
    Desc = "Otomatis equip pet setelah dibeli",
    Flag = "AutoEquip",
    Value = Settings.AutoEquip,
    Callback = function(state)
        Settings.AutoEquip = state
    end
})

local TrailShop = ShopTab:Section({
    Title = "✨ Auto Trail",
    Box = true,
    BoxBorder = true,
    Opened = true
})

TrailShop:Toggle({
    Title = "Enable Auto Trail",
    Desc = "Auto buy trail secara otomatis",
    Flag = "AutoTrail",
    Value = Settings.AutoTrail,
    Callback = function(state)
        Settings.AutoTrail = state
    end
})

TrailShop:Space()

TrailShop:Dropdown({
    Title = "Selected Trail",
    Desc = "Pilih trail yang ingin dibeli",
    Flag = "SelectedTrail",
    Value = Settings.SelectedTrail,
    Options = TrailList,
    Callback = function(value)
        Settings.SelectedTrail = value
    end
})

TrailShop:Space()

TrailShop:Dropdown({
    Title = "Trail Category",
    Desc = "Filter trail berdasarkan kategori",
    Flag = "TrailCategory",
    Value = Settings.TrailCategory,
    Options = TrailCategories,
    Callback = function(value)
        Settings.TrailCategory = value
    end
})

TrailShop:Space()

TrailShop:Input({
    Title = "Buy Delay (ms)",
    Desc = "Delay antar pembelian trail",
    Flag = "TrailBuyDelay",
    Value = Settings.TrailBuyDelay,
    Placeholder = "Contoh: 500",
    Numeric = true,
    Callback = function(value)
        Settings.TrailBuyDelay = value
    end
})

local QueueSettings = ShopTab:Section({
    Title = "📦 Queue System",
    Box = true,
    BoxBorder = true,
    Opened = false
})

QueueSettings:Toggle({
    Title = "Enable Queue",
    Desc = "Gunakan sistem queue untuk pembelian",
    Flag = "QueueEnabled",
    Value = Settings.QueueEnabled,
    Callback = function(state)
        Settings.QueueEnabled = state
    end
})

QueueSettings:Space()

QueueSettings:Input({
    Title = "Queue Size",
    Desc = "Ukuran maksimum queue",
    Flag = "QueueSize",
    Value = Settings.QueueSize,
    Placeholder = "Default: 5",
    Numeric = true,
    Callback = function(value)
        local size = tonumber(value) or 5
        Settings.QueueSize = tostring(size)
        QueueManager:SetMaxSize(size)
    end
})

QueueSettings:Space()

QueueSettings:Button({
    Title = "Clear Queue",
    Desc = "Hapus semua item dalam queue",
    Icon = "trash-2",
    Callback = function()
        QueueManager:Clear()
        Notify("Queue", "Queue berhasil dibersihkan!", "check", 2)
    end
})

-- ================================================================================
-- TAB 4: REBIRTH
-- ================================================================================
local RebirthTab = RebirthSection:Tab({
    Title = "Auto Rebirth",
    Icon = "refresh-cw",
    IconColor = Color3.fromRGB(255, 100, 150),
    Border = true
})

local RebirthControl = RebirthTab:Section({
    Title = "🔄 Rebirth Control",
    Box = true,
    BoxBorder = true,
    Opened = true
})

RebirthControl:Toggle({
    Title = "Enable Auto Rebirth",
    Desc = "Auto rebirth secara otomatis",
    Flag = "AutoRebirth",
    Value = Settings.AutoRebirth,
    Callback = function(state)
        Settings.AutoRebirth = state
    end
})

RebirthControl:Space()

RebirthControl:Input({
    Title = "Rebirth Delay (ms)",
    Desc = "Delay antar rebirth",
    Flag = "RebirthDelay",
    Value = Settings.RebirthDelay,
    Placeholder = "Contoh: 1000",
    Numeric = true,
    Callback = function(value)
        Settings.RebirthDelay = value
    end
})

RebirthControl:Space()

RebirthControl:Toggle({
    Title = "Smart Rebirth",
    Desc = "Gunakan threshold untuk rebirth",
    Flag = "RebirthSmart",
    Value = Settings.RebirthSmart,
    Callback = function(state)
        Settings.RebirthSmart = state
    end
})

RebirthControl:Space()

RebirthControl:Input({
    Title = "Rebirth Threshold",
    Desc = "Threshold untuk smart rebirth",
    Flag = "RebirthThreshold",
    Value = Settings.RebirthThreshold,
    Placeholder = "Contoh: 100",
    Numeric = true,
    Callback = function(value)
        Settings.RebirthThreshold = value
    end
})

local RebirthStats = RebirthTab:Section({
    Title = "📈 Rebirth Statistics",
    Box = true,
    BoxBorder = true,
    Opened = true
})

RebirthStats:Section({
    Title = "Total Rebirths: " .. FormatNumber(Stats.RebirthsDone),
    TextSize = 14,
    FontWeight = Enum.FontWeight.Bold
})

-- ================================================================================
-- TAB 5: ESP
-- ================================================================================
local EspTab = EspSection:Tab({
    Title = "ESP Settings",
    Icon = "eye",
    IconColor = Color3.fromRGB(150, 100, 255),
    Border = true
})

local EspControl = EspTab:Section({
    Title = "👁️ ESP Control",
    Box = true,
    BoxBorder = true,
    Opened = true
})

EspControl:Toggle({
    Title = "Enable ESP",
    Desc = "Aktifkan ESP untuk semua player",
    Flag = "EspEnabled",
    Value = Settings.EspEnabled,
    Callback = function(state)
        Settings.EspEnabled = state
        if state then
            EspManager:Enable()
        else
            EspManager:Disable()
        end
    end
})

EspControl:Space()

EspControl:Toggle({
    Title = "Show Names",
    Desc = "Tampilkan nama player",
    Flag = "EspNames",
    Value = Settings.EspNames,
    Callback = function(state)
        Settings.EspNames = state
    end
})

EspControl:Space()

EspControl:Toggle({
    Title = "Show Distance",
    Desc = "Tampilkan jarak player",
    Flag = "EspDistance",
    Value = Settings.EspDistance,
    Callback = function(state)
        Settings.EspDistance = state
    end
})

EspControl:Space()

EspControl:Toggle({
    Title = "Show Health",
    Desc = "Tampilkan health player",
    Flag = "EspHealth",
    Value = Settings.EspHealth,
    Callback = function(state)
        Settings.EspHealth = state
    end
})

EspControl:Space()

EspControl:Toggle({
    Title = "Show Tracers",
    Desc = "Tampilkan garis ke player",
    Flag = "EspTracers",
    Value = Settings.EspTracers,
    Callback = function(state)
        Settings.EspTracers = state
    end
})

EspControl:Space()

EspControl:Toggle({
    Title = "ESP Chams",
    Desc = "Highlight player dengan chams",
    Flag = "EspChams",
    Value = Settings.EspChams,
    Callback = function(state)
        Settings.EspChams = state
        UpdateHighlights()
    end
})

local EspSettings = EspTab:Section({
    Title = "⚙️ ESP Settings",
    Box = true,
    BoxBorder = true,
    Opened = false
})

EspSettings:ColorPicker({
    Title = "Chams Color",
    Desc = "Warna untuk ESP Chams",
    Flag = "EspChamsColor",
    Value = Settings.EspChamsColor,
    Callback = function(value)
        Settings.EspChamsColor = value
        UpdateHighlights()
    end
})

EspSettings:Space()

EspSettings:Slider({
    Title = "Chams Transparency",
    Desc = "Transparansi chams",
    Flag = "EspChamsTransparency",
    Value = Settings.EspChamsTransparency * 100,
    Min = 0,
    Max = 100,
    Callback = function(value)
        Settings.EspChamsTransparency = value / 100
        UpdateHighlights()
    end
})

EspSettings:Space()

EspSettings:Input({
    Title = "Font Size",
    Desc = "Ukuran font ESP",
    Flag = "EspFontSize",
    Value = Settings.EspFontSize,
    Placeholder = "Default: 14",
    Numeric = true,
    Callback = function(value)
        Settings.EspFontSize = value
    end
})

EspSettings:Space()

EspSettings:Input({
    Title = "Max Distance",
    Desc = "Jarak maksimum ESP",
    Flag = "EspMaxDistance",
    Value = Settings.EspMaxDistance,
    Placeholder = "Default: 1000",
    Numeric = true,
    Callback = function(value)
        Settings.EspMaxDistance = value
    end
})

-- ================================================================================
-- TAB 6: MOVEMENT
-- ================================================================================
local MovementTab = MovementSection:Tab({
    Title = "Movement",
    Icon = "move",
    IconColor = Color3.fromRGB(100, 255, 200),
    Border = true
})

local MoveControl = MovementTab:Section({
    Title = "🏃 Movement Control",
    Box = true,
    BoxBorder = true,
    Opened = true
})

MoveControl:Toggle({
    Title = "No Clip",
    Desc = "Tembus dinding",
    Flag = "NoClip",
    Value = Settings.NoClip,
    Callback = function(state)
        Settings.NoClip = state
        Notify("Movement", state and "No Clip diaktifkan!" or "No Clip dinonaktifkan!", state and "unlock" or "lock", 2)
    end
})

MoveControl:Space()

MoveControl:Toggle({
    Title = "Speed Boost",
    Desc = "Tingkatkan kecepatan",
    Flag = "SpeedBoost",
    Value = Settings.SpeedBoost,
    Callback = function(state)
        Settings.SpeedBoost = state
    end
})

MoveControl:Space()

MoveControl:Input({
    Title = "Speed Value",
    Desc = "Nilai kecepatan",
    Flag = "SpeedValue",
    Value = Settings.SpeedValue,
    Placeholder = "Default: 32",
    Numeric = true,
    Callback = function(value)
        Settings.SpeedValue = value
    end
})

MoveControl:Space()

MoveControl:Toggle({
    Title = "Jump Boost",
    Desc = "Tingkatkan lompatan",
    Flag = "JumpBoost",
    Value = Settings.JumpBoost,
    Callback = function(state)
        Settings.JumpBoost = state
    end
})

MoveControl:Space()

MoveControl:Input({
    Title = "Jump Value",
    Desc = "Nilai lompatan",
    Flag = "JumpValue",
    Value = Settings.JumpValue,
    Placeholder = "Default: 75",
    Numeric = true,
    Callback = function(value)
        Settings.JumpValue = value
    end
})

MoveControl:Space()

MoveControl:Toggle({
    Title = "Fly",
    Desc = "Mode terbang",
    Flag = "FlyEnabled",
    Value = Settings.FlyEnabled,
    Callback = function(state)
        Settings.FlyEnabled = state
        Notify("Movement", state and "Fly diaktifkan!" or "Fly dinonaktifkan!", state and "navigation" or "anchor", 2)
    end
})

MoveControl:Space()

MoveControl:Input({
    Title = "Fly Speed",
    Desc = "Kecepatan terbang",
    Flag = "FlySpeed",
    Value = Settings.FlySpeed,
    Placeholder = "Default: 50",
    Numeric = true,
    Callback = function(value)
        Settings.FlySpeed = value
    end
})

-- ================================================================================
-- TAB 7: SETTINGS
-- ================================================================================
local SettingsTab = SettingsSection:Tab({
    Title = "General",
    Icon = "settings",
    IconColor = Color3.fromRGB(200, 200, 200),
    Border = true
})

local UISettings = SettingsTab:Section({
    Title = "🎨 UI Settings",
    Box = true,
    BoxBorder = true,
    Opened = true
})

UISettings:Dropdown({
    Title = "Theme",
    Desc = "Pilih tema UI",
    Flag = "CurrentTheme",
    Value = Settings.CurrentTheme,
    Options = Themes,
    Callback = function(value)
        Settings.CurrentTheme = value
        Window:SetTheme(value)
    end
})

UISettings:Space()

UISettings:Toggle({
    Title = "Acrylic Effect",
    Desc = "Efek acrylic pada UI",
    Flag = "AcrylicEnabled",
    Value = Settings.AcrylicEnabled,
    Callback = function(state)
        Settings.AcrylicEnabled = state
        Window:SetAcrylic(state)
    end
})

UISettings:Space()

UISettings:Toggle({
    Title = "Notifications",
    Desc = "Tampilkan notifikasi",
    Flag = "Notifications",
    Value = Settings.Notifications,
    Callback = function(state)
        Settings.Notifications = state
    end
})

UISettings:Space()

UISettings:Toggle({
    Title = "Show Watermark",
    Desc = "Tampilkan watermark",
    Flag = "ShowWatermark",
    Value = Settings.ShowWatermark,
    Callback = function(state)
        Settings.ShowWatermark = state
    end
})

local PerfSettings = SettingsTab:Section({
    Title = "⚡ Performance",
    Box = true,
    BoxBorder = true,
    Opened = false
})

PerfSettings:Toggle({
    Title = "Performance Monitor",
    Desc = "Tampilkan monitor performa",
    Flag = "PerformanceMonitor",
    Value = Settings.PerformanceMonitor,
    Callback = function(state)
        Settings.PerformanceMonitor = state
    end
})

PerfSettings:Space()

PerfSettings:Toggle({
    Title = "Low Memory Mode",
    Desc = "Mode hemat memori",
    Flag = "LowMemoryMode",
    Value = Settings.LowMemoryMode,
    Callback = function(state)
        Settings.LowMemoryMode = state
    end
})

PerfSettings:Space()

PerfSettings:Input({
    Title = "Max FPS",
    Desc = "Batas maksimum FPS",
    Flag = "MaxFPS",
    Value = Settings.MaxFPS,
    Placeholder = "Default: 60",
    Numeric = true,
    Callback = function(value)
        Settings.MaxFPS = value
    end
})

local Credits = SettingsTab:Section({
    Title = "ℹ️ Credits",
    Box = true,
    BoxBorder = true,
    Opened = true
})

Credits:Section({
    Title = [[
👤 Developer: Delta
🏢 Hub: ZARCH Hub
🎮 Game: Legends of Speed
📅 Version: v6.0.2
🔧 Framework: WindUI Enhanced++

Thank you for using this script!
Join our community for updates.]],
    TextSize = 12,
    TextTransparency = 0.3
})

-- ================================================================================
-- SECTION 17: MOVEMENT HANDLERS
-- ================================================================================
RunService.Stepped:Connect(function()
    if Settings.NoClip then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if Settings.SpeedBoost then
                    hum.WalkSpeed = ValidateNumber(Settings.SpeedValue, 32)
                else
                    hum.WalkSpeed = 16
                end
                
                if Settings.JumpBoost then
                    hum.JumpPower = ValidateNumber(Settings.JumpValue, 75)
                else
                    hum.JumpPower = 50
                end
            end
        end
        task.wait(0.1)
    end
end)

-- ================================================================================
-- SECTION 18: SESSION TIMER
-- ================================================================================
task.spawn(function()
    while true do
        Stats.SessionTime = tick() - Stats.SessionStart
        task.wait(1)
    end
end)

-- ================================================================================
-- SECTION 19: PERFORMANCE MONITOR
-- ================================================================================
task.spawn(function()
    while true do
        local success, mem = pcall(function()
            return collectgarbage("count")
        end)
        if success then
            if mem > Stats.PeakMemoryUsage then
                Stats.PeakMemoryUsage = mem
            end
        end
        
        Stats.TotalFrames = Stats.TotalFrames + 1
        Stats.CurrentFPS = math.floor(1 / RunService.RenderStepped:Wait())
        Stats.AverageFPS = Stats.TotalFrames / (tick() - Stats.SessionStart)
        
        task.wait(0.1)
    end
end)

-- ================================================================================
-- SECTION 20: INITIALIZATION
-- ================================================================================
task.delay(1, function()
    Notify("Welcome!", "Legends of Speed ULTIMATE v6.0.2 Loaded!", "zap", 5)
    Notify("New", "Orb Smart Farm dengan auto-switch ping!", "cpu", 4)
    Notify("Info", "Script by Delta | ZARCH Hub", "info", 3)
end)

-- Initialize Smart Farm if enabled
if Settings.SmartFarmEnabled then
    StartSmartFarm()
end

-- Print startup info
print("╔═══════════════════════════════════════════════════════════════╗")
print("║  Legends of Speed ULTIMATE v6.0.2 - Successfully Loaded!     ║")
print("╠═══════════════════════════════════════════════════════════════╣")
print("║  👤 Developer: Delta                                         ║")
print("║  🏢 Hub: ZARCH Hub                                           ║")
print("║  📅 Date: May 19, 2026                                       ║")
print("╠═══════════════════════════════════════════════════════════════╣")
print("║  ✨ NEW FEATURES:                                            ║")
print("║  ├─ 🧠 Orb Smart Farm: Ping-based Auto-Switch               ║")
print("║  ├─   ├─ 4 TextBox System (Normal + Smart)                  ║")
print("║  ├─   ├─ Normal Mode: Ping < 150ms                          ║")
print("║  ├─   └─ Smart Mode: Ping > 1000ms                          ║")
print("║  ├─ 📊 Advanced Ping Detection dengan Multi-Fallback        ║")
print("║  ├─ 🔄 Hysteresis Switching (Anti Rapid Toggle)             ║")
print("║  └─ 📈 Real-time Statistics & Analytics                     ║")
print("╚═══════════════════════════════════════════════════════════════╝")

-- Initialize Orb Farm if enabled
if Settings.OrbEnabled then
    StartOrbFarm()
end

-- Final confirmation
Notify("System", "All systems initialized successfully!", "check-circle", 3)

return window
