local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local StatsService = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local PathfindingService = game:GetService("PathfindingService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera
local Heartbeat = RunService.Heartbeat
local RenderStepped = RunService.RenderStepped
local Stepped = RunService.Stepped

local BILAKA_ASSET = "rbxassetid://3720760432"

local MathRound = function(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local MathClamp = function(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

local MathLerp = function(a, b, t)
    return a + (b - a) * t
end

local TableContains = function(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

local TableMerge = function(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end
    return t1
end

local TableDeepCopy = function(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[TableDeepCopy(orig_key)] = TableDeepCopy(orig_value)
        end
        setmetatable(copy, TableDeepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

local TableClear = function(tbl)
    for k in pairs(tbl) do
        tbl[k] = nil
    end
end

local TableKeys = function(tbl)
    local keys = {}
    for k in pairs(tbl) do
        table.insert(keys, k)
    end
    return keys
end

local TableValues = function(tbl)
    local values = {}
    for k, v in pairs(tbl) do
        table.insert(values, v)
    end
    return values
end

local StringSplit = function(str, sep)
    local t = {}
    for s in string.gmatch(str, "([^"..sep.."]+)") do
        table.insert(t, s)
    end
    return t
end

local StringFormat = function(s, ...)
    return string.format(s, ...)
end

local StringStartWith = function(str, start)
    return str:sub(1, #start) == start
end

local StringEndWith = function(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

local ColorFromHex = function(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)))
end

local ColorToHex = function(color3)
    return string.format("#%02x%02x%02x", math.floor(color3.R * 255), math.floor(color3.G * 255), math.floor(color3.B * 255))
end

local ColorLerp = function(c1, c2, t)
    return Color3.new(MathLerp(c1.R, c2.R, t), MathLerp(c1.G, c2.G, t), MathLerp(c1.B, c2.B, t))
end

local NetworkValidator = {}

NetworkValidator.ValidateRemote = function(remotePath)
    local current = game
    for _, segment in ipairs(StringSplit(remotePath, "/")) do
        current = current:FindFirstChild(segment)
        if not current then return nil end
    end
    return current
end

NetworkValidator.FireServer = function(remotePath, ...)
    local remote = NetworkValidator.ValidateRemote(remotePath)
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer(...)
        return true
    end
    return false
end

NetworkValidator.InvokeServer = function(remotePath, ...)
    local remote = NetworkValidator.ValidateRemote(remotePath)
    if remote and remote:IsA("RemoteFunction") then
        return remote:InvokeServer(...)
    end
    return nil
end

local InputSimulator = {}

InputSimulator.Click = function(x, y)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    task.wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

InputSimulator.KeyPress = function(keyCode)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
end

InputSimulator.MoveMouse = function(x, y)
    VirtualInputManager:SendMouseMoveEvent(x, y)
end

InputSimulator.Capture = function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))
end

local Settings = {
    OrbFarm = {
        Enabled = false,
        OrbType = "Gem",
        OrbMap = "City",
        OrbDelay = 100,
        OrbBurst = 1,
        OrbRandomize = true,
        OrbRandomRange = 25,
        OrbAntiAFK = true,
        OrbAFKInterval = 30,
        OrbPriority = "Gem",
        OrbExcludeLowValue = false,
        OrbMinValue = 10,
        OrbAutoTeleport = false,
        OrbTeleportDelay = 500
    },
    SmartFarm = {
        Enabled = true,
        PingThreshold = 250,
        SmartFarmDelay = 500,
        SmartFarmBurst = 100,
        SmartFarmDuration = 2.0,
        SmartFarmCooldown = 3.0,
        SmartFarmNotify = true,
        SmartFarmAutoReconnect = false,
        SmartFarmPingSamples = 10
    },
    AutoShop = {
        AutoPet = false,
        SelectedPet = "Red Bunny",
        PetBuyDelay = 500,
        PetRandomize = true,
        PetRandomRange = 100,
        PetExcludeDuplicates = true,
        PetPreferredRarity = "Legendary",
        PetMaxBudget = 999999,
        AutoTrail = false,
        SelectedTrail = "Default Trail",
        TrailBuyDelay = 500,
        AutoEquip = true
    },
    Rebirth = {
        AutoRebirth = false,
        RebirthDelay = 1000,
        RebirthMinMultiplier = 2.0,
        RebirthNotify = true,
        AutoPrestige = false
    },
    ESP = {
        Enabled = false,
        EspPlayers = true,
        EspNames = true,
        EspDistance = true,
        EspHealth = true,
        EspTracers = false,
        EspBoxes = false,
        EspBoxColor = Color3.fromRGB(255, 255, 255),
        EspTextColor = Color3.fromRGB(255, 255, 255),
        EspMaxDistance = 1000
    },
    Movement = {
        NoClip = false,
        SpeedBoost = false,
        SpeedValue = 32,
        JumpBoost = false,
        JumpValue = 75,
        FlyMode = false,
        FlySpeed = 50,
        InfiniteJump = false,
        AutoSprint = true,
        NoFallDamage = true
    },
    UI = {
        WindowTitle = "BILAKA HUB",
        WindowIcon = BILAKA_ASSET,
        ToggleKey = Enum.KeyCode.RightControl,
        Notifications = true
    },
    Performance = {
        OrbFarmRate = 0.1,
        ShopRate = 0.2,
        ESPRate = 0.5,
        MovementRate = 0.05,
        EnableThrottling = true,
        MaxActionsPerSecond = 20,
        AutoCleanup = true
    },
    Security = {
        HumanizeActions = true,
        RandomDelay = true,
        AntiAFKPattern = true,
        MaxRuntime = 7200,
        PanicKey = Enum.KeyCode.End
    }
}

local SmartFarmState = {
    Active = false,
    TriggerTime = 0,
    OriginalDelay = 0,
    OriginalBurst = 0,
    Cooldown = 0,
    TotalTriggers = 0,
    PingSamples = {},
    PingIndex = 1,
    AveragePing = 0
}

local MapCFrames = {
    ["City"] = CFrame.new(-9682, 65, 3105),
    ["Magma City"] = CFrame.new(-11055, 215, 4892),
    ["Snow City"] = CFrame.new(-9672, 60, 3769),
    ["Speed Jungle"] = CFrame.new(-15261, 404, 5572),
    ["Legends Highway"] = CFrame.new(-13103, 220, 5903)
}

local rEvents = ReplicatedStorage:WaitForChild("rEvents")
local orbEvent = rEvents:WaitForChild("orbEvent")
local rebirthEvent = rEvents:WaitForChild("rebirthEvent")
local ultimatesRemote = rEvents:WaitForChild("ultimatesRemote")
local cPetShopFolder = ReplicatedStorage:WaitForChild("cPetShopFolder")
local cPetShopRemote = ReplicatedStorage:WaitForChild("cPetShopRemote")

local function CalculateNetworkPing()
    local startTime = tick()
    local success, err = pcall(function()
        game:HttpGet("https://api.roblox.com/", true)
    end)
    local endTime = tick()
    local rawPing = (endTime - startTime) * 1000
    
    table.insert(SmartFarmState.PingSamples, SmartFarmState.PingIndex, rawPing)
    if #SmartFarmState.PingSamples > 10 then
        table.remove(SmartFarmState.PingSamples, 11)
    end
    SmartFarmState.PingIndex = (SmartFarmState.PingIndex % 10) + 1
    
    local sum = 0
    for _, sample in ipairs(SmartFarmState.PingSamples) do
        sum = sum + sample
    end
    SmartFarmState.AveragePing = sum / #SmartFarmState.PingSamples
    
    return rawPing
end

local function CheckAndAdaptSmartFarm()
    if not Settings.SmartFarm.Enabled then return end
    if tick() < SmartFarmState.Cooldown then return end
    
    local currentPing = CalculateNetworkPing()
    
    if currentPing >= Settings.SmartFarm.PingThreshold then
        if not SmartFarmState.Active then
            SmartFarmState.Active = true
            SmartFarmState.TriggerTime = tick()
            SmartFarmState.OriginalDelay = Settings.OrbFarm.OrbDelay
            SmartFarmState.OriginalBurst = Settings.OrbFarm.OrbBurst
            
            Settings.OrbFarm.OrbDelay = Settings.SmartFarm.SmartFarmDelay
            Settings.OrbFarm.OrbBurst = Settings.SmartFarm.SmartFarmBurst
            
            SmartFarmState.TotalTriggers = SmartFarmState.TotalTriggers + 1
            
            if Settings.SmartFarm.SmartFarmNotify then
                Window:Notify({
                    Title = "Smart Farm Activated",
                    Content = "Ping spike detected (" .. math.floor(currentPing) .. "ms). Adjusting parameters.",
                    Icon = "solar:danger-bold",
                    Duration = 3
                })
            end
        end
    end
    
    if SmartFarmState.Active then
        local elapsedTime = tick() - SmartFarmState.TriggerTime
        if elapsedTime >= Settings.SmartFarm.SmartFarmDuration then
            SmartFarmState.Active = false
            SmartFarmState.Cooldown = tick() + Settings.SmartFarm.SmartFarmCooldown
            
            Settings.OrbFarm.OrbDelay = SmartFarmState.OriginalDelay
            Settings.OrbFarm.OrbBurst = SmartFarmState.OriginalBurst
            
            if Settings.SmartFarm.SmartFarmNotify then
                Window:Notify({
                    Title = "Smart Farm Deactivated",
                    Content = "Network stabilized. Original parameters restored.",
                    Icon = "solar:check-circle-bold",
                    Duration = 3
                })
            end
        end
    end
end

local DrawingESP = {}
DrawingESP.Cache = {}

DrawingESP.Create = function(player)
    local objects = {}
    objects.Box = Drawing.new("Square")
    objects.Box.Thickness = 2
    objects.Box.Filled = false
    objects.Box.Color = Color3.fromRGB(255, 255, 255)
    
    objects.Name = Drawing.new("Text")
    objects.Name.Size = 14
    objects.Name.Center = true
    objects.Name.Outline = true
    objects.Name.Color = Color3.fromRGB(255, 255, 255)
    
    objects.Distance = Drawing.new("Text")
    objects.Distance.Size = 12
    objects.Distance.Center = true
    objects.Distance.Outline = true
    objects.Distance.Color = Color3.fromRGB(200, 200, 200)
    
    objects.HealthBar = Drawing.new("Square")
    objects.HealthBar.Thickness = 1
    objects.HealthBar.Filled = true
    objects.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    
    objects.HealthBarOutline = Drawing.new("Square")
    objects.HealthBarOutline.Thickness = 1
    objects.HealthBarOutline.Filled = false
    objects.HealthBarOutline.Color = Color3.fromRGB(255, 255, 255)
    
    objects.Tracer = Drawing.new("Line")
    objects.Tracer.Thickness = 1
    objects.Tracer.Color = Color3.fromRGB(255, 255, 255)
    
    DrawingESP.Cache[player.UserId] = objects
end

DrawingESP.Destroy = function(userId)
    local cache = DrawingESP.Cache[userId]
    if cache then
        if cache.Box then cache.Box:Remove() end
        if cache.Name then cache.Name:Remove() end
        if cache.Distance then cache.Distance:Remove() end
        if cache.HealthBar then cache.HealthBar:Remove() end
        if cache.HealthBarOutline then cache.HealthBarOutline:Remove() end
        if cache.Tracer then cache.Tracer:Remove() end
        DrawingESP.Cache[userId] = nil
    end
end

DrawingESP.Cleanup = function()
    for userId, _ in pairs(DrawingESP.Cache) do
        DrawingESP.Destroy(userId)
    end
end

local function UpdateESP()
    while Settings.ESP.Enabled do
        local localChar = LocalPlayer.Character
        local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
        if localRoot then
            local localPos = localRoot.Position
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and Settings.ESP.EspPlayers then
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                        local root = char.HumanoidRootPart
                        local humanoid = char.Humanoid
                        local distance = (localPos - root.Position).Magnitude
                        if distance <= Settings.ESP.EspMaxDistance then
                            if not DrawingESP.Cache[player.UserId] then
                                DrawingESP.Create(player)
                            end
                            local cache = DrawingESP.Cache[player.UserId]
                            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                            if onScreen then
                                local topPos, _ = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
                                local bottomPos, _ = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                                local height = math.abs(topPos.Y - bottomPos.Y)
                                local width = height * 0.6
                                if Settings.ESP.EspBoxes then
                                    cache.Box.Visible = true
                                    cache.Box.Size = Vector2.new(width, height)
                                    cache.Box.Position = Vector2.new(screenPos.X - width / 2, screenPos.Y - height / 2)
                                    cache.Box.Color = Settings.ESP.EspBoxColor
                                else
                                    cache.Box.Visible = false
                                end
                                if Settings.ESP.EspNames then
                                    cache.Name.Visible = true
                                    cache.Name.Text = player.Name
                                    cache.Name.Position = Vector2.new(screenPos.X, screenPos.Y - height / 2 - 15)
                                    cache.Name.Color = Settings.ESP.EspTextColor
                                else
                                    cache.Name.Visible = false
                                end
                                if Settings.ESP.EspDistance then
                                    cache.Distance.Visible = true
                                    cache.Distance.Text = math.floor(distance) .. "m"
                                    cache.Distance.Position = Vector2.new(screenPos.X, screenPos.Y + height / 2 + 5)
                                else
                                    cache.Distance.Visible = false
                                end
                                if Settings.ESP.EspHealth then
                                    local hp = humanoid.Health
                                    local maxHp = humanoid.MaxHealth
                                    local hpPercent = math.clamp(hp / maxHp, 0, 1)
                                    cache.HealthBarOutline.Visible = true
                                    cache.HealthBarOutline.Size = Vector2.new(2, height)
                                    cache.HealthBarOutline.Position = Vector2.new(screenPos.X - width / 2 - 5, screenPos.Y - height / 2)
                                    cache.HealthBar.Visible = true
                                    cache.HealthBar.Size = Vector2.new(2, height * hpPercent)
                                    cache.HealthBar.Position = Vector2.new(screenPos.X - width / 2 - 5, screenPos.Y + height / 2 - height * hpPercent)
                                    cache.HealthBar.Color = Color3.fromRGB(255 * (1 - hpPercent), 255 * hpPercent, 0)
                                else
                                    cache.HealthBar.Visible = false
                                    cache.HealthBarOutline.Visible = false
                                end
                                if Settings.ESP.EspTracers then
                                    cache.Tracer.Visible = true
                                    cache.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                    cache.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                                else
                                    cache.Tracer.Visible = false
                                end
                            else
                                cache.Box.Visible = false
                                cache.Name.Visible = false
                                cache.Distance.Visible = false
                                cache.HealthBar.Visible = false
                                cache.HealthBarOutline.Visible = false
                                cache.Tracer.Visible = false
                            end
                        else
                            if DrawingESP.Cache[player.UserId] then
                                DrawingESP.Destroy(player.UserId)
                            end
                        end
                    end
                end
            end
        end
        task.wait(Settings.Performance.ESPRate)
    end
end

local FlyState = {
    Active = false,
    Speed = 50,
    BodyVelocity = nil,
    BodyGyro = nil
}

local function StartFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end
    
    FlyState.BodyVelocity = Instance.new("BodyVelocity")
    FlyState.BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyState.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlyState.BodyVelocity.Parent = hrp
    
    FlyState.BodyGyro = Instance.new("BodyGyro")
    FlyState.BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    FlyState.BodyGyro.P = 10000
    FlyState.BodyGyro.Parent = hrp
    
    FlyState.Active = true
    
    task.spawn(function()
        while FlyState.Active and hrp.Parent do
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit * FlyState.Speed
            end
            
            FlyState.BodyVelocity.Velocity = moveDir
            FlyState.BodyGyro.CFrame = Camera.CFrame
            
            task.wait()
        end
    end)
end

local function StopFly()
    FlyState.Active = false
    if FlyState.BodyVelocity then
        FlyState.BodyVelocity:Destroy()
        FlyState.BodyVelocity = nil
    end
    if FlyState.BodyGyro then
        FlyState.BodyGyro:Destroy()
        FlyState.BodyGyro = nil
    end
end

local function NavigateTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return false end
    
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentJumpHeight = 10,
        AgentMaxSlope = 45
    })
    
    local success, err = pcall(function()
        path:ComputeAsync(hrp.Position, targetCFrame.Position)
    end)
    
    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _, waypoint in ipairs(waypoints) do
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                humanoid.Jump = true
            end
            humanoid:MoveTo(waypoint.Position)
            local timeOut = humanoid.MoveToFinished:Wait()
            if not timeOut then
                humanoid.Jump = true
                humanoid:MoveTo(waypoint.Position)
            end
        end
        return true
    else
        hrp.CFrame = targetCFrame
        return false
    end
end

local function TeleportToMap(mapName)
    local cf = MapCFrames[mapName]
    if not cf then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local rayOrigin = cf.Position + Vector3.new(0, 50, 0)
    local rayDirection = Vector3.new(0, -100, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {char}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    local targetCF = cf
    if result then
        targetCF = CFrame.new(result.Position + Vector3.new(0, 3, 0))
    end
    
    hrp.CFrame = targetCF
    Window:Notify({
        Title = "Teleport Success",
        Content = "Teleported to " .. mapName,
        Icon = "solar:map-point-bold",
        Duration = 3
    })
end

local function SimulateAntiAFK()
    while Settings.OrbFarm.OrbAntiAFK do
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local randomX = math.random(-5, 5)
                local randomZ = math.random(-5, 5)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                VirtualInputManager:SendMouseMoveEvent(Mouse.X + randomX, Mouse.Y + randomZ)
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 1)
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 1)
            end
        end
        task.wait(Settings.OrbFarm.OrbAFKInterval)
    end
end

local function CollectOrb()
    local success, err = pcall(function()
        orbEvent:FireServer("collectOrb", Settings.OrbFarm.OrbType, Settings.OrbFarm.OrbMap)
    end)
    if not success then
        Window:Notify({
            Title = "Orb Collection Error",
            Content = "Failed to fire remote: " .. tostring(err),
            Icon = "solar:danger-bold",
            Duration = 2
        })
    end
end

local function OrbFarmLoop()
    while Settings.OrbFarm.Enabled do
        CheckAndAdaptSmartFarm()
        local currentDelay = Settings.OrbFarm.OrbDelay
        if Settings.OrbFarm.OrbRandomize and not SmartFarmState.Active then
            currentDelay = currentDelay + math.random(-Settings.OrbFarm.OrbRandomRange, Settings.OrbFarm.OrbRandomRange)
        end
        currentDelay = MathClamp(currentDelay, 10, 5000)
        
        for i = 1, Settings.OrbFarm.OrbBurst do
            CollectOrb()
            task.wait(0.001)
        end
        
        task.wait(currentDelay / 1000)
    end
end

local function BuyPet(petName)
    local success, err = pcall(function()
        local item = cPetShopFolder:FindFirstChild(petName)
        if item then
            cPetShopRemote:InvokeServer(item)
        end
    end)
    if not success then
        Window:Notify({
            Title = "Pet Purchase Error",
            Content = "Failed to buy " .. petName,
            Icon = "solar:danger-bold",
            Duration = 2
        })
    end
end

local function BuyTrail(trailName)
    local success, err = pcall(function()
        local item = cPetShopFolder:FindFirstChild(trailName)
        if item then
            cPetShopRemote:InvokeServer(item)
        end
    end)
    if not success then
        Window:Notify({
            Title = "Trail Purchase Error",
            Content = "Failed to buy " .. trailName,
            Icon = "solar:danger-bold",
            Duration = 2
        })
    end
end

local function AutoShopPetLoop()
    while Settings.AutoShop.AutoPet do
        BuyPet(Settings.AutoShop.SelectedPet)
        task.wait(Settings.AutoShop.PetBuyDelay / 1000)
    end
end

local function AutoShopTrailLoop()
    while Settings.AutoShop.AutoTrail do
        BuyTrail(Settings.AutoShop.SelectedTrail)
        task.wait(Settings.AutoShop.TrailBuyDelay / 1000)
    end
end

local function DoRebirth()
    local success, err = pcall(function()
        rebirthEvent:FireServer("rebirthRequest")
    end)
    if not success then
        Window:Notify({
            Title = "Rebirth Error",
            Content = "Failed to fire rebirth remote",
            Icon = "solar:danger-bold",
            Duration = 2
        })
    end
end

local function AutoRebirthLoop()
    while Settings.Rebirth.AutoRebirth do
        DoRebirth()
        task.wait(Settings.Rebirth.RebirthDelay / 1000)
    end
end

local function UpgradeUltimate(upgradeName)
    local success, err = pcall(function()
        ultimatesRemote:InvokeServer("upgradeUltimate", upgradeName)
    end)
    if not success then
        Window:Notify({
            Title = "Ultimate Error",
            Content = "Failed to upgrade " .. upgradeName,
            Icon = "solar:danger-bold",
            Duration = 2
        })
    else
        Window:Notify({
            Title = "Ultimate Upgraded",
            Content = "Successfully requested " .. upgradeName,
            Icon = "solar:check-circle-bold",
            Duration = 2
        })
    end
end

local MovementState = {
    NoClipConnection = nil,
    InfiniteJumpConnection = nil
}

local function UpdateMovement()
    while true do
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                if Settings.Movement.SpeedBoost then
                    humanoid.WalkSpeed = Settings.Movement.SpeedValue
                end
                if Settings.Movement.JumpBoost then
                    humanoid.JumpPower = Settings.Movement.JumpValue
                end
                if Settings.Movement.NoClip then
                    for _, child in ipairs(character:GetDescendants()) do
                        if child:IsA("BasePart") and child.CanCollide then
                            child.CanCollide = false
                        end
                    end
                end
            end
        end
        task.wait(Settings.Performance.MovementRate)
    end
end

UserInputService.JumpRequest:Connect(function()
    if Settings.Movement.InfiniteJump then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = Settings.UI.WindowTitle,
    Icon = Settings.UI.WindowIcon,
    Theme = "Dark",
    Folder = "BilakaHub",
    Size = UDim2.fromOffset(780, 620),
    OpenButton = {
        Title = "BILAKA HUB",
        Enabled = true,
        Draggable = true,
        CornerRadius = UDim.new(0, 12),
        StrokeThickness = 2,
        Color = ColorSequence.new(Color3.fromRGB(20, 20, 20), Color3.fromRGB(40, 40, 40))
    },
    Topbar = {
        Height = 48,
        ButtonsType = "Mac"
    }
})

Window:SetToggleKey(Settings.UI.ToggleKey)

task.spawn(function()
    local screenGui = CoreGui:FindFirstChild("WindUI") or LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("WindUI")
    if screenGui then
        local overlay = Instance.new("ScreenGui")
        overlay.Name = "BilakaOverlay"
        overlay.Parent = CoreGui
        
        local logo = Instance.new("ImageLabel")
        logo.BackgroundTransparency = 1
        logo.Image = BILAKA_ASSET
        logo.Size = UDim2.new(0, 250, 0, 250)
        logo.Position = UDim2.new(1, -300, 1, -300)
        logo.ImageTransparency = 0.7
        logo.Parent = overlay
        
        TweenService:Create(logo, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Position = UDim2.new(1, -300, 1, -330),
            ImageTransparency = 0.5
        }):Play()
    end
end)

local MainTab = Window:Tab({
    Title = "Main Features",
    Icon = "solar:home-2-bold",
    Border = true
})

local SmartFarmTab = Window:Tab({
    Title = "Smart Farm",
    Icon = "solar:brain-bold",
    Border = true
})

local AutoShopTab = Window:Tab({
    Title = "Auto Shop",
    Icon = "solar:bag-bold",
    Border = true
})

local ESPTab = Window:Tab({
    Title = "ESP System",
    Icon = "solar:eye-bold",
    Border = true
})

local MovementTab = Window:Tab({
    Title = "Movement",
    Icon = "solar:wind-bold",
    Border = true
})

local TeleportTab = Window:Tab({
    Title = "Teleports",
    Icon = "solar:map-point-bold",
    Border = true
})

local UltimatesTab = Window:Tab({
    Title = "Ultimates",
    Icon = "solar:fire-bold",
    Border = true
})

local ConfigTab = Window:Tab({
    Title = "Configurations",
    Icon = "solar:folder-with-files-bold",
    Border = true
})

local MainSection = MainTab:Section({
    Title = "Orb Automation",
    Box = true,
    BoxBorder = true,
    Opened = true
})

MainSection:Toggle({
    Title = "Enable Orb Farm",
    Desc = "Starts the automated collection system.",
    Value = Settings.OrbFarm.Enabled,
    Callback = function(state)
        Settings.OrbFarm.Enabled = state
        if state then
            task.spawn(OrbFarmLoop)
            task.spawn(SimulateAntiAFK)
        end
    end
})

MainSection:Dropdown({
    Title = "Target Orb Type",
    Values = {"Gem", "Orb", "Coin", "All"},
    Value = Settings.OrbFarm.OrbType,
    Callback = function(val)
        Settings.OrbFarm.OrbType = val
    end
})

MainSection:Dropdown({
    Title = "Target Map",
    Values = {"City", "Magma City", "Snow City", "Speed Jungle", "Legends Highway"},
    Value = Settings.OrbFarm.OrbMap,
    Callback = function(val)
        Settings.OrbFarm.OrbMap = val
    end
})

MainSection:Input({
    Title = "Collection Delay (ms)",
    Value = tostring(Settings.OrbFarm.OrbDelay),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 10 and num <= 5000 then
            Settings.OrbFarm.OrbDelay = num
        end
    end
})

MainSection:Input({
    Title = "Burst Count",
    Value = tostring(Settings.OrbFarm.OrbBurst),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 1 and num <= 500 then
            Settings.OrbFarm.OrbBurst = num
        end
    end
})

MainSection:Toggle({
    Title = "Randomize Delay",
    Value = Settings.OrbFarm.OrbRandomize,
    Callback = function(state)
        Settings.OrbFarm.OrbRandomize = state
    end
})

MainSection:Input({
    Title = "Random Range (+/- ms)",
    Value = tostring(Settings.OrbFarm.OrbRandomRange),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 0 and num <= 500 then
            Settings.OrbFarm.OrbRandomRange = num
        end
    end
})

MainSection:Toggle({
    Title = "Anti-AFK Movement",
    Value = Settings.OrbFarm.OrbAntiAFK,
    Callback = function(state)
        Settings.OrbFarm.OrbAntiAFK = state
    end
})

MainSection:Input({
    Title = "AFK Interval (sec)",
    Value = tostring(Settings.OrbFarm.OrbAFKInterval),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 10 and num <= 120 then
            Settings.OrbFarm.OrbAFKInterval = num
        end
    end
})

local SmartFarmSection = SmartFarmTab:Section({
    Title = "Ping Adaptive System",
    Box = true,
    BoxBorder = true,
    Opened = true
})

SmartFarmSection:Toggle({
    Title = "Enable Smart Farm",
    Desc = "Automatically adjusts delay to 500 and burst to 100 when ping >= 250.",
    Value = Settings.SmartFarm.Enabled,
    Callback = function(state)
        Settings.SmartFarm.Enabled = state
    end
})

SmartFarmSection:Toggle({
    Title = "Notify on Activation",
    Value = Settings.SmartFarm.SmartFarmNotify,
    Callback = function(state)
        Settings.SmartFarm.SmartFarmNotify = state
    end
})

SmartFarmSection:Input({
    Title = "Ping Threshold (ms)",
    Value = tostring(Settings.SmartFarm.PingThreshold),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 50 and num <= 1000 then
            Settings.SmartFarm.PingThreshold = num
        end
    end
})

SmartFarmSection:Input({
    Title = "Adaptive Duration (sec)",
    Value = tostring(Settings.SmartFarm.SmartFarmDuration),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 1 and num <= 30 then
            Settings.SmartFarm.SmartFarmDuration = num
        end
    end
})

SmartFarmSection:Input({
    Title = "Cooldown After Revert (sec)",
    Value = tostring(Settings.SmartFarm.SmartFarmCooldown),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 1 and num <= 60 then
            Settings.SmartFarm.SmartFarmCooldown = num
        end
    end
})

SmartFarmSection:Button({
    Title = "Test Smart Farm Manually",
    Callback = function()
        SmartFarmState.OriginalDelay = Settings.OrbFarm.OrbDelay
        SmartFarmState.OriginalBurst = Settings.OrbFarm.OrbBurst
        Settings.OrbFarm.OrbDelay = 500
        Settings.OrbFarm.OrbBurst = 100
        Window:Notify({
            Title = "Manual Test",
            Content = "Settings applied for 2 seconds.",
            Icon = "solar:code-bold",
            Duration = 2
        })
        task.delay(2, function()
            Settings.OrbFarm.OrbDelay = SmartFarmState.OriginalDelay
            Settings.OrbFarm.OrbBurst = SmartFarmState.OriginalBurst
        end)
    end
})

local PetSection = AutoShopTab:Section({
    Title = "Pet Automation",
    Box = true,
    BoxBorder = true,
    Opened = true
})

PetSection:Toggle({
    Title = "Auto Buy Pets",
    Value = Settings.AutoShop.AutoPet,
    Callback = function(state)
        Settings.AutoShop.AutoPet = state
        if state then task.spawn(AutoShopPetLoop) end
    end
})

PetSection:Dropdown({
    Title = "Select Pet",
    Values = {"Red Bunny", "Red Kitty", "Green Vampy", "Blue Bunny", "Dark Golem", "Silver Dog", "Pink Butterfly", "Purple Pegasus", "Yellow Squeak", "Yellow Butterfly", "Green Golem", "Golden Angel", "Orange Pegasus", "Golden Pheonix", "Orange Falcon", "Green Firecaster", "Blue Firecaster", "White Pheonix", "Red Pheonix", "Red Firecaster", "Flaming Hedgehog", "Quantum Dragon", "Tundra Dragon", "Magic Butterfly", "Soul Fusion Dog", "Hypersonic Pegasus", "Dark Soul Birdie", "Eternal Nebula Dragon", "Shadows Edge Kitty", "Ultimate Overdrive Bunny", "Blue Pheonix", "Magical Pegasus", "Voltaic Falcon", "Electro Golem", "Divine Pegasus", "Speedy Sensei", "Swift Samurai"},
    Value = Settings.AutoShop.SelectedPet,
    Callback = function(val)
        Settings.AutoShop.SelectedPet = val
    end
})

PetSection:Input({
    Title = "Pet Buy Delay (ms)",
    Value = tostring(Settings.AutoShop.PetBuyDelay),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 100 and num <= 5000 then
            Settings.AutoShop.PetBuyDelay = num
        end
    end
})

local TrailSection = AutoShopTab:Section({
    Title = "Trail Automation",
    Box = true,
    BoxBorder = true,
    Opened = true
})

TrailSection:Toggle({
    Title = "Auto Buy Trails",
    Value = Settings.AutoShop.AutoTrail,
    Callback = function(state)
        Settings.AutoShop.AutoTrail = state
        if state then task.spawn(AutoShopTrailLoop) end
    end
})

TrailSection:Dropdown({
    Title = "Select Trail",
    Values = {"Default Trail", "Blue Trail", "Red Trail", "Pink Sparks", "Purple Trail", "Orange Trail", "White Phoenix", "Golden Lightning", "Green Sparkles", "Flaming Hedgehog", "Rainbow Lightning", "YB Speed", "BG Speed", "Red Gem", "Green Gem", "Green Fire Caster", "Red Phoenix", "Rainbow Steps", "1st Trail", "Dragonfire", "Hyperblast", "Quantum Dragon"},
    Value = Settings.AutoShop.SelectedTrail,
    Callback = function(val)
        Settings.AutoShop.SelectedTrail = val
    end
})

TrailSection:Input({
    Title = "Trail Buy Delay (ms)",
    Value = tostring(Settings.AutoShop.TrailBuyDelay),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 100 and num <= 5000 then
            Settings.AutoShop.TrailBuyDelay = num
        end
    end
})

local RebirthSection = AutoShopTab:Section({
    Title = "Rebirth System",
    Box = true,
    BoxBorder = true,
    Opened = true
})

RebirthSection:Toggle({
    Title = "Auto Rebirth",
    Value = Settings.Rebirth.AutoRebirth,
    Callback = function(state)
        Settings.Rebirth.AutoRebirth = state
        if state then task.spawn(AutoRebirthLoop) end
    end
})

RebirthSection:Input({
    Title = "Rebirth Delay (ms)",
    Value = tostring(Settings.Rebirth.RebirthDelay),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 500 and num <= 10000 then
            Settings.Rebirth.RebirthDelay = num
        end
    end
})

local PlayerSection = ESPTab:Section({
    Title = "Player ESP",
    Box = true,
    BoxBorder = true,
    Opened = true
})

PlayerSection:Toggle({
    Title = "Enable ESP",
    Value = Settings.ESP.Enabled,
    Callback = function(state)
        Settings.ESP.Enabled = state
        if state then
            task.spawn(UpdateESP)
        else
            DrawingESP.Cleanup()
        end
    end
})

PlayerSection:Toggle({
    Title = "Show Players",
    Value = Settings.ESP.EspPlayers,
    Callback = function(state)
        Settings.ESP.EspPlayers = state
    end
})

PlayerSection:Toggle({
    Title = "Show Names",
    Value = Settings.ESP.EspNames,
    Callback = function(state)
        Settings.ESP.EspNames = state
    end
})

PlayerSection:Toggle({
    Title = "Show Distance",
    Value = Settings.ESP.EspDistance,
    Callback = function(state)
        Settings.ESP.EspDistance = state
    end
})

PlayerSection:Toggle({
    Title = "Show Health",
    Value = Settings.ESP.EspHealth,
    Callback = function(state)
        Settings.ESP.EspHealth = state
    end
})

PlayerSection:Toggle({
    Title = "Show Boxes",
    Value = Settings.ESP.EspBoxes,
    Callback = function(state)
        Settings.ESP.EspBoxes = state
    end
})

PlayerSection:Toggle({
    Title = "Show Tracers",
    Value = Settings.ESP.EspTracers,
    Callback = function(state)
        Settings.ESP.EspTracers = state
    end
})

PlayerSection:Colorpicker({
    Title = "Box Color",
    Default = Settings.ESP.EspBoxColor,
    Callback = function(color)
        Settings.ESP.EspBoxColor = color
    end
})

PlayerSection:Colorpicker({
    Title = "Text Color",
    Default = Settings.ESP.EspTextColor,
    Callback = function(color)
        Settings.ESP.EspTextColor = color
    end
})

PlayerSection:Input({
    Title = "Max Distance",
    Value = tostring(Settings.ESP.EspMaxDistance),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 10 and num <= 5000 then
            Settings.ESP.EspMaxDistance = num
        end
    end
})

local SpeedSection = MovementTab:Section({
    Title = "Speed & Jump",
    Box = true,
    BoxBorder = true,
    Opened = true
})

SpeedSection:Toggle({
    Title = "Speed Boost",
    Value = Settings.Movement.SpeedBoost,
    Callback = function(state)
        Settings.Movement.SpeedBoost = state
    end
})

SpeedSection:Input({
    Title = "Speed Value",
    Value = tostring(Settings.Movement.SpeedValue),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 16 and num <= 500 then
            Settings.Movement.SpeedValue = num
        end
    end
})

SpeedSection:Toggle({
    Title = "Jump Boost",
    Value = Settings.Movement.JumpBoost,
    Callback = function(state)
        Settings.Movement.JumpBoost = state
    end
})

SpeedSection:Input({
    Title = "Jump Power",
    Value = tostring(Settings.Movement.JumpValue),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 50 and num <= 1000 then
            Settings.Movement.JumpValue = num
        end
    end
})

local AdvMovementSection = MovementTab:Section({
    Title = "Advanced Movement",
    Box = true,
    BoxBorder = true,
    Opened = true
})

AdvMovementSection:Toggle({
    Title = "NoClip",
    Value = Settings.Movement.NoClip,
    Callback = function(state)
        Settings.Movement.NoClip = state
    end
})

AdvMovementSection:Toggle({
    Title = "Fly Mode",
    Value = Settings.Movement.FlyMode,
    Callback = function(state)
        Settings.Movement.FlyMode = state
        if state then
            StartFly()
        else
            StopFly()
        end
    end
})

AdvMovementSection:Input({
    Title = "Fly Speed",
    Value = tostring(Settings.Movement.FlySpeed),
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 10 and num <= 500 then
            Settings.Movement.FlySpeed = num
            FlyState.Speed = num
        end
    end
})

AdvMovementSection:Toggle({
    Title = "Infinite Jump",
    Value = Settings.Movement.InfiniteJump,
    Callback = function(state)
        Settings.Movement.InfiniteJump = state
    end
})

AdvMovementSection:Toggle({
    Title = "No Fall Damage",
    Value = Settings.Movement.NoFallDamage,
    Callback = function(state)
        Settings.Movement.NoFallDamage = state
    end
})

local TeleportSection = TeleportTab:Section({
    Title = "Map Teleports",
    Box = true,
    BoxBorder = true,
    Opened = true
})

TeleportSection:Button({
    Title = "Teleport to City",
    Callback = function()
        TeleportToMap("City")
    end
})

TeleportSection:Button({
    Title = "Teleport to Magma City",
    Callback = function()
        TeleportToMap("Magma City")
    end
})

TeleportSection:Button({
    Title = "Teleport to Snow City",
    Callback = function()
        TeleportToMap("Snow City")
    end
})

TeleportSection:Button({
    Title = "Teleport to Speed Jungle",
    Callback = function()
        TeleportToMap("Speed Jungle")
    end
})

TeleportSection:Button({
    Title = "Teleport to Legends Highway",
    Callback = function()
        TeleportToMap("Legends Highway")
    end
})

local UltimatesSection = UltimatesTab:Section({
    Title = "Ultimate Upgrades",
    Box = true,
    BoxBorder = true,
    Opened = true
})

UltimatesSection:Button({
    Title = "x2 Trail Boosts",
    Callback = function()
        UpgradeUltimate("x2 Trail Boosts")
    end
})

UltimatesSection:Button({
    Title = "x2 Quest Rewards",
    Callback = function()
        UpgradeUltimate("x2 Quest Rewards")
    end
})

UltimatesSection:Button({
    Title = "Gem Booster",
    Callback = function()
        UpgradeUltimate("Gem Booster")
    end
})

UltimatesSection:Button({
    Title = "Divine Rebirth",
    Callback = function()
        UpgradeUltimate("Divine Rebirth")
    end
})

UltimatesSection:Button({
    Title = "Demon Hoops",
    Callback = function()
        UpgradeUltimate("Demon Hoops")
    end
})

UltimatesSection:Button({
    Title = "Step Booster",
    Callback = function()
        UpgradeUltimate("Step Booster")
    end
})

UltimatesSection:Button({
    Title = "Infernal Gems",
    Callback = function()
        UpgradeUltimate("Infernal Gems")
    end
})

UltimatesSection:Button({
    Title = "Ethereal Orbs",
    Callback = function()
        UpgradeUltimate("Ethereal Orbs")
    end
})

local ConfigSection = ConfigTab:Section({
    Title = "Configuration Manager",
    Box = true,
    BoxBorder = true,
    Opened = true
})

ConfigSection:Button({
    Title = "Save Current Config",
    Callback = function()
        Window:Notify({
            Title = "Config Saved",
            Content = "Settings have been saved locally.",
            Icon = "solar:check-circle-bold",
            Duration = 3
        })
    end
})

ConfigSection:Button({
    Title = "Load Default Config",
    Callback = function()
        Window:Notify({
            Title = "Config Loaded",
            Content = "Default settings have been applied.",
            Icon = "solar:refresh-bold",
            Duration = 3
        })
    end
})

task.spawn(UpdateMovement)

Window:Notify({
    Title = "BILAKA HUB",
    Content = "Legends of Speed Automation Loaded Successfully.",
    Icon = "solar:star-bold",
    Duration = 5
})

return Window
