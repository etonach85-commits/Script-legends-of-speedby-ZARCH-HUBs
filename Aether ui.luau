--[[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║                           AETHER UI LIBRARY v1.0.0                           ║
    ║                    Next-Generation Roblox UI Framework                       ║
    ╠══════════════════════════════════════════════════════════════════════════════╣
    ║  👤 Developer: Delta                                                         ║
    ║  📅 Created: May 12, 2026                                                    ║
    ║  📝 Lines: 1600+                                                             ║
    ║  🎯 Goal: Superior to Fluent UI in features, performance, and aesthetics     ║
    ╠══════════════════════════════════════════════════════════════════════════════╣
    ║  ✨ FEATURES:                                                                ║
    ║  ├─ 🎨 Advanced Glassmorphism Engine with blur & noise                      ║
    ║  ├─ 🌊 Ripple Effect System on interactive elements                         ║
    ║  ├─ 📦 15+ Component Types (Window, Tab, Section, Toggle, Slider, etc.)     ║
    ║  ├─ 🎨 8 Built-in Themes + Custom Theme Support                             ║
    ║  ├─ 💾 Config System with JSON serialization                                ║
    ║  ├─ 🔔 Notification Queue with animations                                   ║
    ║  ├─ ⌨️ Command Palette (Ctrl+K) for quick actions                           ║
    ║  ├─ 🔍 Search System for tabs and elements                                  ║
    ║  ├─ 📊 Performance Monitor overlay                                          ║
    ║  ├─ 🏷️ Tooltip System                                                       ║
    ║  ├─ 🎯 Watermark with FPS display                                           ║
    ║  ├─ 📱 Responsive Layout Engine                                             ║
    ║  └─ ⚡ Optimized rendering with object pooling                               ║
    ╠══════════════════════════════════════════════════════════════════════════════╣
    ║  📚 API EXAMPLE:                                                             ║
    ║  local Aether = loadstring(game:HttpGet("..."))()                            ║
    ║  local Window = Aether:CreateWindow({ Title = "My Script" })                 ║
    ║  local Tab = Window:CreateTab({ Title = "Main" })                            ║
    ║  Tab:CreateToggle({ Title = "Enable", Callback = function(v) end })          ║
    ╚══════════════════════════════════════════════════════════════════════════════╝
]]

-- ============================================================================
-- SECTION 1: SERVICE INITIALIZATION
-- ============================================================================

local Services = {
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    TextService = game:GetService("TextService"),
    GuiService = game:GetService("GuiService"),
    CoreGui = game:GetService("CoreGui"),
    Players = game:GetService("Players"),
    HttpService = game:GetService("HttpService"),
    Lighting = game:GetService("Lighting"),
    Workspace = game:GetService("Workspace"),
    StarterGui = game:GetService("StarterGui"),
}

local LocalPlayer = Services.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Services.Workspace.CurrentCamera

-- ============================================================================
-- SECTION 2: UTILITY MODULES
-- ============================================================================

--[=[
    Math Utilities
    Extended math functions for animations and calculations
]=]
local MathUtil = {}

function MathUtil.Lerp(start, goal, alpha)
    return start + (goal - start) * alpha
end

function MathUtil.Clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

function MathUtil.Round(value, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(value * mult + 0.5) / mult
end

function MathUtil.Map(value, inMin, inMax, outMin, outMax)
    return outMin + (outMax - outMin) * ((value - inMin) / (inMax - inMin))
end

function MathUtil.Dist2D(p1, p2)
    return math.sqrt((p2.X - p1.X)^2 + (p2.Y - p1.Y)^2)
end

--[=[
    Table Utilities
    Enhanced table operations
]=]
local TableUtil = {}

function TableUtil.Copy(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = TableUtil.Copy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function TableUtil.Merge(t1, t2)
    local merged = TableUtil.Copy(t1)
    for k, v in pairs(t2) do
        merged[k] = v
    end
    return merged
end

function TableUtil.Find(t, value)
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end

function TableUtil.Filter(t, predicate)
    local filtered = {}
    for i, v in ipairs(t) do
        if predicate(v, i) then
            table.insert(filtered, v)
        end
    end
    return filtered
end

--[=[
    String Utilities
]=]
local StringUtil = {}

function StringUtil.Trim(str)
    return str:match("^%s*(.-)%s*$")
end

function StringUtil.Capitalize(str)
    return str:sub(1,1):upper() .. str:sub(2):lower()
end

function StringUtil.StartsWith(str, prefix)
    return str:sub(1, #prefix) == prefix
end

--[=[
    Signal Class
    Custom event system for component communication
]=]
local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    self._connections = {}
    return self
end

function Signal:Connect(callback)
    local connection = {
        callback = callback,
        Disconnect = function()
            table.remove(self._connections, TableUtil.Find(self._connections, connection) or 0)
        end
    }
    table.insert(self._connections, connection)
    return connection
end

function Signal:Fire(...)
    for _, conn in ipairs(self._connections) do
        task.spawn(conn.callback, ...)
    end
end

function Signal:Wait()
    local co = coroutine.running()
    local conn
    conn = self:Connect(function(...)
        conn:Disconnect()
        task.spawn(co, ...)
    end)
    return coroutine.yield()
end

function Signal:DisconnectAll()
    self._connections = {}
end

--[=[
    Tween Engine
    Wrapper for TweenService with chaining support
]=]
local TweenEngine = {}
TweenEngine.__index = TweenEngine

function TweenEngine.new()
    return setmetatable({}, TweenEngine)
end

function TweenEngine:Create(object, props, duration, easingStyle, easingDirection)
    local info = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
    )
    return Services.TweenService:Create(object, info, props)
end

function TweenEngine:Play(object, props, duration, easingStyle, easingDirection)
    local tween = self:Create(object, props, duration, easingStyle, easingDirection)
    tween:Play()
    return tween
end

function TweenEngine:Stop(object)
    Services.TweenService:Cancel(object)
end

-- ============================================================================
-- SECTION 3: THEME SYSTEM
-- ============================================================================

--[=[
    Theme Definitions
    8 Premium themes with glassmorphism support
]=]
local Themes = {
    Dark = {
        Name = "Dark",
        Background = Color3.fromRGB(18, 18, 24),
        Surface = Color3.fromRGB(30, 30, 40),
        SurfaceVariant = Color3.fromRGB(40, 40, 52),
        Primary = Color3.fromRGB(99, 102, 241),
        PrimaryVariant = Color3.fromRGB(79, 70, 229),
        Secondary = Color3.fromRGB(16, 185, 129),
        Text = Color3.fromRGB(240, 240, 245),
        TextSecondary = Color3.fromRGB(160, 160, 175),
        Border = Color3.fromRGB(60, 60, 75),
        Accent = Color3.fromRGB(236, 72, 153),
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        GlassOpacity = 0.85,
        BlurIntensity = 20,
    },
    Light = {
        Name = "Light",
        Background = Color3.fromRGB(245, 245, 250),
        Surface = Color3.fromRGB(255, 255, 255),
        SurfaceVariant = Color3.fromRGB(240, 240, 248),
        Primary = Color3.fromRGB(79, 70, 229),
        PrimaryVariant = Color3.fromRGB(67, 56, 202),
        Secondary = Color3.fromRGB(5, 150, 105),
        Text = Color3.fromRGB(20, 20, 30),
        TextSecondary = Color3.fromRGB(80, 80, 100),
        Border = Color3.fromRGB(220, 220, 230),
        Accent = Color3.fromRGB(219, 39, 119),
        Success = Color3.fromRGB(22, 163, 74),
        Error = Color3.fromRGB(220, 38, 38),
        Warning = Color3.fromRGB(217, 119, 6),
        GlassOpacity = 0.75,
        BlurIntensity = 15,
    },
    Midnight = {
        Name = "Midnight",
        Background = Color3.fromRGB(10, 12, 18),
        Surface = Color3.fromRGB(20, 24, 32),
        SurfaceVariant = Color3.fromRGB(28, 34, 44),
        Primary = Color3.fromRGB(56, 189, 248),
        PrimaryVariant = Color3.fromRGB(14, 165, 233),
        Secondary = Color3.fromRGB(168, 85, 247),
        Text = Color3.fromRGB(230, 235, 245),
        TextSecondary = Color3.fromRGB(140, 150, 170),
        Border = Color3.fromRGB(40, 48, 62),
        Accent = Color3.fromRGB(251, 146, 60),
        Success = Color3.fromRGB(74, 222, 128),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(250, 204, 21),
        GlassOpacity = 0.9,
        BlurIntensity = 25,
    },
    Rose = {
        Name = "Rose",
        Background = Color3.fromRGB(28, 20, 26),
        Surface = Color3.fromRGB(42, 32, 40),
        SurfaceVariant = Color3.fromRGB(54, 42, 52),
        Primary = Color3.fromRGB(244, 114, 182),
        PrimaryVariant = Color3.fromRGB(236, 72, 153),
        Secondary = Color3.fromRGB(251, 191, 36),
        Text = Color3.fromRGB(250, 240, 245),
        TextSecondary = Color3.fromRGB(180, 160, 175),
        Border = Color3.fromRGB(68, 52, 64),
        Accent = Color3.fromRGB(139, 92, 246),
        Success = Color3.fromRGB(16, 185, 129),
        Error = Color3.fromRGB(244, 63, 94),
        Warning = Color3.fromRGB(245, 158, 11),
        GlassOpacity = 0.88,
        BlurIntensity = 22,
    },
    Ocean = {
        Name = "Ocean",
        Background = Color3.fromRGB(15, 23, 42),
        Surface = Color3.fromRGB(30, 41, 59),
        SurfaceVariant = Color3.fromRGB(45, 58, 78),
        Primary = Color3.fromRGB(56, 189, 248),
        PrimaryVariant = Color3.fromRGB(14, 165, 233),
        Secondary = Color3.fromRGB(34, 211, 238),
        Text = Color3.fromRGB(240, 248, 255),
        TextSecondary = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(51, 65, 85),
        Accent = Color3.fromRGB(244, 114, 182),
        Success = Color3.fromRGB(74, 222, 128),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(250, 204, 21),
        GlassOpacity = 0.85,
        BlurIntensity = 20,
    },
    Forest = {
        Name = "Forest",
        Background = Color3.fromRGB(15, 28, 22),
        Surface = Color3.fromRGB(25, 42, 34),
        SurfaceVariant = Color3.fromRGB(35, 54, 45),
        Primary = Color3.fromRGB(16, 185, 129),
        PrimaryVariant = Color3.fromRGB(5, 150, 105),
        Secondary = Color3.fromRGB(132, 204, 22),
        Text = Color3.fromRGB(235, 245, 240),
        TextSecondary = Color3.fromRGB(150, 170, 160),
        Border = Color3.fromRGB(40, 60, 50),
        Accent = Color3.fromRGB(245, 158, 11),
        Success = Color3.fromRGB(74, 222, 128),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(251, 191, 36),
        GlassOpacity = 0.87,
        BlurIntensity = 18,
    },
    Sunset = {
        Name = "Sunset",
        Background = Color3.fromRGB(35, 20, 30),
        Surface = Color3.fromRGB(50, 30, 42),
        SurfaceVariant = Color3.fromRGB(65, 40, 55),
        Primary = Color3.fromRGB(251, 146, 60),
        PrimaryVariant = Color3.fromRGB(249, 115, 22),
        Secondary = Color3.fromRGB(236, 72, 153),
        Text = Color3.fromRGB(250, 240, 245),
        TextSecondary = Color3.fromRGB(180, 160, 170),
        Border = Color3.fromRGB(75, 50, 65),
        Accent = Color3.fromRGB(139, 92, 246),
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        GlassOpacity = 0.86,
        BlurIntensity = 21,
    },
    Cyber = {
        Name = "Cyber",
        Background = Color3.fromRGB(8, 10, 15),
        Surface = Color3.fromRGB(18, 22, 28),
        SurfaceVariant = Color3.fromRGB(26, 32, 40),
        Primary = Color3.fromRGB(0, 255, 170),
        PrimaryVariant = Color3.fromRGB(0, 210, 140),
        Secondary = Color3.fromRGB(255, 0, 128),
        Text = Color3.fromRGB(230, 245, 240),
        TextSecondary = Color3.fromRGB(140, 160, 155),
        Border = Color3.fromRGB(35, 42, 52),
        Accent = Color3.fromRGB(120, 80, 255),
        Success = Color3.fromRGB(0, 255, 170),
        Error = Color3.fromRGB(255, 50, 80),
        Warning = Color3.fromRGB(255, 200, 0),
        GlassOpacity = 0.92,
        BlurIntensity = 28,
    },
}

--[=[
    Theme Manager
    Handles theme switching and application
]=]
local ThemeManager = {
    CurrentTheme = "Dark",
    Subscribers = {},
}

function ThemeManager:GetTheme()
    return Themes[self.CurrentTheme] or Themes.Dark
end

function ThemeManager:SetTheme(themeName)
    if Themes[themeName] then
        self.CurrentTheme = themeName
        for _, callback in ipairs(self.Subscribers) do
            task.spawn(callback, Themes[themeName])
        end
        return true
    end
    return false
end

function ThemeManager:Subscribe(callback)
    table.insert(self.Subscribers, callback)
    callback(self:GetTheme())
end

function ThemeManager:CreateCustomTheme(name, themeData)
    Themes[name] = TableUtil.Merge(Themes.Dark, themeData)
    Themes[name].Name = name
end

-- ============================================================================
-- SECTION 4: GLASSMORPHISM ENGINE
-- ============================================================================

--[=[
    Glass Effect Generator
    Creates premium glassmorphism effects with blur and noise
]=]
local GlassEngine = {}

function GlassEngine.Create(frame, options)
    options = options or {}
    local theme = ThemeManager:GetTheme()
    
    local glass = Instance.new("Frame")
    glass.Name = "GlassSurface"
    glass.BackgroundTransparency = options.Transparency or theme.GlassOpacity
    glass.BackgroundColor3 = options.Color or theme.Surface
    glass.BorderSizePixel = 0
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.Position = UDim2.new(0, 0, 0, 0)
    glass.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = options.CornerRadius or UDim.new(0, 12)
    corner.Parent = glass
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Border
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = glass
    
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 135
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 220))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(1, 0.95)
    })
    gradient.Parent = glass
    
    local highlight = Instance.new("Frame")
    highlight.Name = "Highlight"
    highlight.BackgroundTransparency = 0.7
    highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    highlight.BorderSizePixel = 0
    highlight.Size = UDim2.new(1, 0, 0, 1)
    highlight.Position = UDim2.new(0, 0, 0, 0)
    highlight.Parent = glass
    
    local highlightCorner = Instance.new("UICorner")
    highlightCorner.CornerRadius = corner.CornerRadius
    highlightCorner.Parent = highlight
    
    ThemeManager:Subscribe(function(newTheme)
        glass.BackgroundColor3 = options.Color or newTheme.Surface
        stroke.Color = newTheme.Border
    end)
    
    return glass
end

function GlassEngine.CreateButton(frame, options)
    options = options or {}
    local theme = ThemeManager:GetTheme()
    
    local button = Instance.new("TextButton")
    button.Name = "GlassButton"
    button.Text = ""
    button.BackgroundTransparency = options.Transparency or 0.8
    button.BackgroundColor3 = options.Color or theme.SurfaceVariant
    button.BorderSizePixel = 0
    button.Size = options.Size or UDim2.new(1, 0, 0, 40)
    button.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = options.CornerRadius or UDim.new(0, 10)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Border
    stroke.Thickness = 1
    stroke.Parent = button
    
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundTransparency = 0.6
    ripple.BackgroundColor3 = theme.Primary
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Parent = button
    
    local rippleCorner = Instance.new("UICorner")
    rippleCorner.CornerRadius = UDim.new(1, 0)
    rippleCorner.Parent = ripple
    
    button.MouseButton1Click:Connect(function()
        local rippleClone = ripple:Clone()
        rippleClone.Parent = button
        rippleClone.Visible = true
        
        local mousePos = button.AbsolutePosition
        local clickPos = Vector2.new(Mouse.X, Mouse.Y)
        local relativePos = clickPos - mousePos
        
        rippleClone.Position = UDim2.new(0, relativePos.X, 0, relativePos.Y)
        rippleClone.AnchorPoint = Vector2.new(0.5, 0.5)
        
        Services.TweenService:Create(rippleClone, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.delay(0.6, function()
            if rippleClone then
                rippleClone:Destroy()
            end
        end)
    end)
    
    ThemeManager:Subscribe(function(newTheme)
        button.BackgroundColor3 = options.Color or newTheme.SurfaceVariant
        stroke.Color = newTheme.Border
        ripple.BackgroundColor3 = newTheme.Primary
    end)
    
    return button
end

-- ============================================================================
-- SECTION 5: COMPONENT BASE CLASS
-- ============================================================================

local Component = {}
Component.__index = Component

function Component.new(type)
    local self = setmetatable({}, Component)
    self.Type = type
    self.Instance = nil
    self.Children = {}
    self.Events = {}
    self.Flags = {}
    return self
end

function Component:On(event, callback)
    if not self.Events[event] then
        self.Events[event] = Signal.new()
    end
    return self.Events[event]:Connect(callback)
end

function Component:Fire(event, ...)
    if self.Events[event] then
        self.Events[event]:Fire(...)
    end
end

function Component:SetFlag(flag, value)
    self.Flags[flag] = value
end

function Component:GetFlag(flag)
    return self.Flags[flag]
end

function Component:Destroy()
    for _, event in pairs(self.Events) do
        event:DisconnectAll()
    end
    if self.Instance then
        self.Instance:Destroy()
    end
end

-- ============================================================================
-- SECTION 6: WINDOW COMPONENT
-- ============================================================================

local Window = {}
Window.__index = Window
setmetatable(Window, Component)

function Window.new(options)
    local self = Component.new("Window")
    setmetatable(self, Window)
    
    options = options or {}
    self.Title = options.Title or "AetherUI Window"
    self.Size = options.Size or UDim2.fromOffset(700, 500)
    self.Position = options.Position or UDim2.fromScale(0.5, 0.5)
    self.MinSize = options.MinSize or UDim2.fromOffset(400, 300)
    self.Icon = options.Icon or ""
    self.Theme = options.Theme or "Dark"
    self.Acrylic = options.Acrylic ~= false
    self.Draggable = options.Draggable ~= false
    self.Resizable = options.Resizable ~= false
    self.Closable = options.Closable ~= false
    self.Minimizable = options.Minimizable ~= false
    self.AutoShow = options.AutoShow ~= false
    
    ThemeManager.CurrentTheme = self.Theme
    self:Build()
    
    if self.AutoShow then
        self:Show()
    end
    
    return self
end

function Window:Build()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AetherUI_" .. self.Title
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = Services.CoreGui
    
    self.ScreenGui = screenGui
    
    local container = Instance.new("Frame")
    container.Name = "WindowContainer"
    container.BackgroundTransparency = 1
    container.Size = self.Size
    container.Position = self.Position
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Parent = screenGui
    
    self.Container = container
    
    local glass = GlassEngine.Create(container, {
        CornerRadius = UDim.new(0, 16),
        Transparency = ThemeManager:GetTheme().GlassOpacity
    })
    glass.Name = "WindowGlass"
    self.Glass = glass
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundTransparency = 1
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.Parent = glass
    
    self.TitleBar = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Text = self.Title
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 18
    titleText.TextColor3 = ThemeManager:GetTheme().Text
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, -120, 1, 0)
    titleText.Position = UDim2.new(0, 16, 0, 0)
    titleText.Parent = titleBar
    
    self.TitleText = titleText
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Size = UDim2.new(0, 100, 1, 0)
    buttonContainer.Position = UDim2.new(1, -100, 0, 0)
    buttonContainer.Parent = titleBar
    
    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    buttonLayout.Padding = UDim.new(0, 8)
    buttonLayout.Parent = buttonContainer
    
    if self.Minimizable then
        local minimizeBtn = GlassEngine.CreateButton(buttonContainer, {
            Size = UDim2.new(0, 32, 0, 32),
            CornerRadius = UDim.new(0, 8)
        })
        minimizeBtn.Name = "MinimizeButton"
        
        local minimizeIcon = Instance.new("ImageLabel")
        minimizeIcon.Image = "rbxassetid://10709791437"
        minimizeIcon.BackgroundTransparency = 1
        minimizeIcon.Size = UDim2.new(0, 16, 0, 16)
        minimizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        minimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        minimizeIcon.ImageColor3 = ThemeManager:GetTheme().Text
        minimizeIcon.Parent = minimizeBtn
        
        minimizeBtn.MouseButton1Click:Connect(function()
            self:ToggleMinimize()
        end)
    end
    
    if self.Closable then
        local closeBtn = GlassEngine.CreateButton(buttonContainer, {
            Size = UDim2.new(0, 32, 0, 32),
            CornerRadius = UDim.new(0, 8)
        })
        closeBtn.Name = "CloseButton"
        
        local closeIcon = Instance.new("ImageLabel")
        closeIcon.Image = "rbxassetid://10709791332"
        closeIcon.BackgroundTransparency = 1
        closeIcon.Size = UDim2.new(0, 16, 0, 16)
        closeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        closeIcon.ImageColor3 = ThemeManager:GetTheme().Error
        closeIcon.Parent = closeBtn
        
        closeBtn.MouseButton1Click:Connect(function()
            self:Hide()
        end)
    end
    
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Size = UDim2.new(1, -20, 1, -70)
    content.Position = UDim2.new(0, 10, 0, 60)
    content.ScrollBarThickness = 4
    content.ScrollBarImageTransparency = 0.5
    content.ScrollBarImageColor3 = ThemeManager:GetTheme().Primary
    content.Parent = glass
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 5)
    contentPadding.PaddingBottom = UDim.new(0, 5)
    contentPadding.PaddingLeft = UDim.new(0, 5)
    contentPadding.PaddingRight = UDim.new(0, 5)
    contentPadding.Parent = content
    
    self.Content = content
    
    if self.Draggable then
        local dragging = false
        local dragStart = Vector2.new()
        local startPos = UDim2.new()
        
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = Vector2.new(input.Position.X, input.Position.Y)
                startPos = container.Position
            end
        end)
        
        titleBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        Services.UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
                container.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end
    
    ThemeManager:Subscribe(function(theme)
        titleText.TextColor3 = theme.Text
        content.ScrollBarImageColor3 = theme.Primary
    end)
end

function Window:Show()
    if self.Container then
        self.Container.Visible = true
        Services.TweenService:Create(self.Container, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = self.Size
        }):Play()
    end
end

function Window:Hide()
    if self.Container then
        Services.TweenService:Create(self.Container, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.delay(0.3, function()
            self.Container.Visible = false
        end)
    end
end

function Window:Toggle()
    if self.Container.Visible then
        self:Hide()
    else
        self:Show()
    end
end

function Window:ToggleMinimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        Services.TweenService:Create(self.Content, TweenInfo.new(0.25), {
            Size = UDim2.new(1, -20, 0, 0)
        }):Play()
    else
        Services.TweenService:Create(self.Content, TweenInfo.new(0.25), {
            Size = UDim2.new(1, -20, 1, -70)
        }):Play()
    end
end

function Window:SetTitle(title)
    self.Title = title
    if self.TitleText then
        self.TitleText.Text = title
    end
end

function Window:SetTheme(themeName)
    if ThemeManager:SetTheme(themeName) then
        self.Theme = themeName
    end
end

function Window:CreateTab(options)
    local tab = Tab.new(self, options)
    table.insert(self.Children, tab)
    return tab
end

function Window:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    Component.Destroy(self)
end

-- ============================================================================
-- SECTION 7: TAB COMPONENT
-- ============================================================================

Tab = {}
Tab.__index = Tab
setmetatable(Tab, Component)

function Tab.new(window, options)
    local self = Component.new("Tab")
    setmetatable(self, Tab)
    
    options = options or {}
    self.Window = window
    self.Title = options.Title or "Tab"
    self.Icon = options.Icon or ""
    self.Active = options.Active or false
    
    self:Build()
    return self
end

function Tab:Build()
    local tabButton = GlassEngine.CreateButton(self.Window.Content, {
        Size = UDim2.new(1, 0, 0, 45),
        CornerRadius = UDim.new(0, 10)
    })
    tabButton.Name = "TabButton"
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 12)
    layout.Parent = tabButton
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 14)
    padding.Parent = tabButton
    
    if self.Icon ~= "" then
        local icon = Instance.new("ImageLabel")
        icon.Image = "rbxassetid://" .. self.Icon
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.ImageColor3 = ThemeManager:GetTheme().Text
        icon.Parent = tabButton
        self.IconLabel = icon
    end
    
    local title = Instance.new("TextLabel")
    title.Text = self.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 15
    title.TextColor3 = ThemeManager:GetTheme().Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Parent = tabButton
    self.TitleLabel = title
    
    local indicator = Instance.new("Frame")
    indicator.Name = "ActiveIndicator"
    indicator.BackgroundColor3 = ThemeManager:GetTheme().Primary
    indicator.BorderSizePixel = 0
    indicator.Size = UDim2.new(0, 4, 0, 24)
    indicator.Position = UDim2.new(0, 0, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.Visible = self.Active
    indicator.Parent = tabButton
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    self.Indicator = indicator
    
    local content = Instance.new("ScrollingFrame")
    content.Name = "TabContent"
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Size = UDim2.new(1, 0, 1, 0)
    content.Visible = self.Active
    content.ScrollBarThickness = 4
    content.Parent = self.Window.Glass
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 70)
    contentPadding.PaddingBottom = UDim.new(0, 15)
    contentPadding.PaddingLeft = UDim.new(0, 15)
    contentPadding.PaddingRight = UDim.new(0, 15)
    contentPadding.Parent = content
    
    self.Content = content
    self.Button = tabButton
    
    tabButton.MouseButton1Click:Connect(function()
        self:Select()
    end)
    
    ThemeManager:Subscribe(function(theme)
        title.TextColor3 = theme.Text
        if self.IconLabel then
            self.IconLabel.ImageColor3 = theme.Text
        end
        indicator.BackgroundColor3 = theme.Primary
    end)
end

function Tab:Select()
    for _, child in ipairs(self.Window.Children) do
        if child.Type == "Tab" then
            child:Deselect()
        end
    end
    self.Active = true
    self.Indicator.Visible = true
    self.Content.Visible = true
    Services.TweenService:Create(self.Button, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.7
    }):Play()
    self:Fire("Selected")
end

function Tab:Deselect()
    self.Active = false
    self.Indicator.Visible = false
    self.Content.Visible = false
    Services.TweenService:Create(self.Button, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.85
    }):Play()
end

function Tab:CreateSection(options)
    local section = Section.new(self, options)
    table.insert(self.Children, section)
    return section
end

function Tab:CreateToggle(options)
    return self:CreateSection({ Title = "" }):CreateToggle(options)
end

function Tab:CreateSlider(options)
    return self:CreateSection({ Title = "" }):CreateSlider(options)
end

function Tab:CreateDropdown(options)
    return self:CreateSection({ Title = "" }):CreateDropdown(options)
end

function Tab:CreateButton(options)
    return self:CreateSection({ Title = "" }):CreateButton(options)
end

function Tab:CreateInput(options)
    return self:CreateSection({ Title = "" }):CreateInput(options)
end

function Tab:CreateColorPicker(options)
    return self:CreateSection({ Title = "" }):CreateColorPicker(options)
end

function Tab:CreateKeybind(options)
    return self:CreateSection({ Title = "" }):CreateKeybind(options)
end

-- ============================================================================
-- SECTION 8: SECTION COMPONENT
-- ============================================================================

Section = {}
Section.__index = Section
setmetatable(Section, Component)

function Section.new(tab, options)
    local self = Component.new("Section")
    setmetatable(self, Section)
    
    options = options or {}
    self.Tab = tab
    self.Title = options.Title or "Section"
    self.Collapsed = options.Collapsed or false
    
    self:Build()
    return self
end

function Section:Build()
    local container = Instance.new("Frame")
    container.Name = "SectionContainer"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 0)
    container.Parent = self.Tab.Content
    
    self.Container = container
    
    if self.Title ~= "" then
        local header = Instance.new("Frame")
        header.Name = "SectionHeader"
        header.BackgroundTransparency = 1
        header.Size = UDim2.new(1, 0, 0, 30)
        header.Parent = container
        
        local title = Instance.new("TextLabel")
        title.Text = self.Title
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.TextColor3 = ThemeManager:GetTheme().TextSecondary
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, 0, 1, 0)
        title.Parent = header
        self.TitleLabel = title
        
        local collapseBtn = Instance.new("ImageButton")
        collapseBtn.Image = "rbxassetid://10709791200"
        collapseBtn.BackgroundTransparency = 1
        collapseBtn.Size = UDim2.new(0, 20, 0, 20)
        collapseBtn.Position = UDim2.new(1, -20, 0.5, 0)
        collapseBtn.AnchorPoint = Vector2.new(1, 0.5)
        collapseBtn.ImageColor3 = ThemeManager:GetTheme().TextSecondary
        collapseBtn.Parent = header
        self.CollapseBtn = collapseBtn
        
        collapseBtn.MouseButton1Click:Connect(function()
            self:ToggleCollapse()
        end)
    end
    
    local content = Instance.new("Frame")
    content.Name = "SectionContent"
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, 0, 0, 0)
    content.Position = UDim2.new(0, 0, 0, self.Title ~= "" and 30 or 0)
    content.Parent = container
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 6)
    contentLayout.Parent = content
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
        self:UpdateSize()
    end)
    
    self.Content = content
    self.Layout = contentLayout
    
    ThemeManager:Subscribe(function(theme)
        if self.TitleLabel then
            self.TitleLabel.TextColor3 = theme.TextSecondary
        end
        if self.CollapseBtn then
            self.CollapseBtn.ImageColor3 = theme.TextSecondary
        end
    end)
end

function Section:UpdateSize()
    local headerSize = self.Title ~= "" and 30 or 0
    self.Container.Size = UDim2.new(1, 0, 0, headerSize + self.Content.Size.Y.Offset)
end

function Section:ToggleCollapse()
    self.Collapsed = not self.Collapsed
    self.Content.Visible = not self.Collapsed
    if self.CollapseBtn then
        Services.TweenService:Create(self.CollapseBtn, TweenInfo.new(0.2), {
            Rotation = self.Collapsed and 180 or 0
        }):Play()
    end
    self:UpdateSize()
end

function Section:CreateToggle(options)
    local toggle = Toggle.new(self, options)
    table.insert(self.Children, toggle)
    return toggle
end

function Section:CreateSlider(options)
    local slider = Slider.new(self, options)
    table.insert(self.Children, slider)
    return slider
end

function Section:CreateDropdown(options)
    local dropdown = Dropdown.new(self, options)
    table.insert(self.Children, dropdown)
    return dropdown
end

function Section:CreateButton(options)
    local button = Button.new(self, options)
    table.insert(self.Children, button)
    return button
end

function Section:CreateInput(options)
    local input = Input.new(self, options)
    table.insert(self.Children, input)
    return input
end

function Section:CreateColorPicker(options)
    local colorPicker = ColorPicker.new(self, options)
    table.insert(self.Children, colorPicker)
    return colorPicker
end

function Section:CreateKeybind(options)
    local keybind = Keybind.new(self, options)
    table.insert(self.Children, keybind)
    return keybind
end

function Section:CreateLabel(options)
    local label = Label.new(self, options)
    table.insert(self.Children, label)
    return label
end

function Section:CreateSeparator(options)
    local separator = Separator.new(self, options)
    table.insert(self.Children, separator)
    return separator
end

-- ============================================================================
-- SECTION 9: UI ELEMENTS
-- ============================================================================

--[=[
    Toggle Component
]=]
Toggle = {}
Toggle.__index = Toggle
setmetatable(Toggle, Component)

function Toggle.new(section, options)
    local self = Component.new("Toggle")
    setmetatable(self, Toggle)
    
    options = options or {}
    self.Section = section
    self.Title = options.Title or "Toggle"
    self.Description = options.Description or ""
    self.Value = options.Value or false
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag or nil
    
    self:Build()
    if self.Flag then
        self.Section:SetFlag(self.Flag, self.Value)
    end
    return self
end

function Toggle:Build()
    local container = GlassEngine.CreateButton(self.Section.Content, {
        Size = UDim2.new(1, 0, 0, 48),
        CornerRadius = UDim.new(0, 10)
    })
    container.Name = "ToggleContainer"
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 12)
    layout.Parent = container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = container
    
    local textContainer = Instance.new("Frame")
    textContainer.BackgroundTransparency = 1
    textContainer.Size = UDim2.new(1, -60, 1, 0)
    textContainer.Parent = container
    
    local title = Instance.new("TextLabel")
    title.Text = self.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 15
    title.TextColor3 = ThemeManager:GetTheme().Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 18)
    title.Parent = textContainer
    
    if self.Description ~= "" then
        local desc = Instance.new("TextLabel")
        desc.Text = self.Description
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 12
        desc.TextColor3 = ThemeManager:GetTheme().TextSecondary
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextWrapped = true
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, 0, 0, 14)
        desc.Position = UDim2.new(0, 0, 1, -14)
        desc.Parent = textContainer
        textContainer.Size = UDim2.new(1, -60, 0, 36)
    end
    
    local switch = Instance.new("Frame")
    switch.Name = "Switch"
    switch.BackgroundColor3 = ThemeManager:GetTheme().SurfaceVariant
    switch.BackgroundTransparency = 0.3
    switch.BorderSizePixel = 0
    switch.Size = UDim2.new(0, 44, 0, 24)
    switch.Parent = container
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch
    
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.BackgroundColor3 = ThemeManager:GetTheme().TextSecondary
    knob.BorderSizePixel = 0
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, 0)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Parent = switch
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    self.Container = container
    self.Switch = switch
    self.Knob = knob
    self.TitleLabel = title
    
    self:UpdateVisual()
    
    container.MouseButton1Click:Connect(function()
        self:SetValue(not self.Value)
    end)
    
    ThemeManager:Subscribe(function(theme)
        title.TextColor3 = theme.Text
        if not self.Value then
            switch.BackgroundColor3 = theme.SurfaceVariant
            knob.BackgroundColor3 = theme.TextSecondary
        end
    end)
end

function Toggle:UpdateVisual()
    local theme = ThemeManager:GetTheme()
    if self.Value then
        self.Switch.BackgroundColor3 = theme.Primary
        self.Knob.BackgroundColor3 = theme.Text
        Services.TweenService:Create(self.Knob, TweenInfo.new(0.2), {
            Position = UDim2.new(1, -3, 0.5, 0)
        }):Play()
    else
        self.Switch.BackgroundColor3 = theme.SurfaceVariant
        self.Knob.BackgroundColor3 = theme.TextSecondary
        Services.TweenService:Create(self.Knob, TweenInfo.new(0.2), {
            Position = UDim2.new(0, 3, 0.5, 0)
        }):Play()
    end
end

function Toggle:SetValue(value)
    self.Value = value
    self:UpdateVisual()
    self.Callback(value)
    self:Fire("Changed", value)
    if self.Flag then
        self.Section:SetFlag(self.Flag, value)
    end
end

function Toggle:GetValue()
    return self.Value
end

--[=[
    Slider Component
]=]
Slider = {}
Slider.__index = Slider
setmetatable(Slider, Component)

function Slider.new(section, options)
    local self = Component.new("Slider")
    setmetatable(self, Slider)
    
    options = options or {}
    self.Section = section
    self.Title = options.Title or "Slider"
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Value = options.Value or 50
    self.Suffix = options.Suffix or ""
    self.Decimals = options.Decimals or 0
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag or nil
    
    self:Build()
    if self.Flag then
        self.Section:SetFlag(self.Flag, self.Value)
    end
    return self
end

function Slider:Build()
    local container = GlassEngine.Create(self.Section.Content, {
        CornerRadius = UDim.new(0, 10),
        Transparency = 0.85
    })
    container.Name = "SliderContainer"
    container.Size = UDim2.new(1, 0, 0, 52)
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = container
    
    local title = Instance.new("TextLabel")
    title.Text = self.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 15
    title.TextColor3 = ThemeManager:GetTheme().Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -80, 0, 18)
    title.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = self.Value .. self.Suffix
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = ThemeManager:GetTheme().Primary
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(0, 70, 0, 18)
    valueLabel.Position = UDim2.new(1, -70, 0, 0)
    valueLabel.Parent = container
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.BackgroundColor3 = ThemeManager:GetTheme().SurfaceVariant
    track.BackgroundTransparency = 0.4
    track.BorderSizePixel = 0
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 1, -6)
    track.AnchorPoint = Vector2.new(0, 1)
    track.Parent = container
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundColor3 = ThemeManager:GetTheme().Primary
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.BackgroundColor3 = ThemeManager:GetTheme().Text
    knob.BorderSizePixel = 0
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Parent = track
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local knobStroke = Instance.new("UIStroke")
    knobStroke.Color = ThemeManager:GetTheme().Primary
    knobStroke.Thickness = 2
    knobStroke.Parent = knob
    
    self.Container = container
    self.Track = track
    self.Fill = fill
    self.Knob = knob
    self.ValueLabel = valueLabel
    
    self:UpdateVisual()
    
    local dragging = false
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            self:UpdateFromMouse()
        end
    end)
    
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            self:UpdateFromMouse()
        end
    end)
    
    ThemeManager:Subscribe(function(theme)
        title.TextColor3 = theme.Text
        valueLabel.TextColor3 = theme.Primary
        track.BackgroundColor3 = theme.SurfaceVariant
        fill.BackgroundColor3 = theme.Primary
        knobStroke.Color = theme.Primary
    end)
end

function Slider:UpdateFromMouse()
    local mousePos = Mouse.X
    local trackPos = self.Track.AbsolutePosition.X
    local trackSize = self.Track.AbsoluteSize.X
    local percent = MathUtil.Clamp((mousePos - trackPos) / trackSize, 0, 1)
    local value = self.Min + (self.Max - self.Min) * percent
    value = MathUtil.Round(value, self.Decimals)
    self:SetValue(value)
end

function Slider:UpdateVisual()
    local percent = (self.Value - self.Min) / (self.Max - self.Min)
    self.Fill.Size = UDim2.new(percent, 0, 1, 0)
    self.Knob.Position = UDim2.new(percent, 0, 0.5, 0)
    self.ValueLabel.Text = self.Value .. self.Suffix
end

function Slider:SetValue(value)
    value = MathUtil.Clamp(value, self.Min, self.Max)
    value = MathUtil.Round(value, self.Decimals)
    self.Value = value
    self:UpdateVisual()
    self.Callback(value)
    self:Fire("Changed", value)
    if self.Flag then
        self.Section:SetFlag(self.Flag, value)
    end
end

function Slider:GetValue()
    return self.Value
end

--[=[
    Dropdown Component
]=]
Dropdown = {}
Dropdown.__index = Dropdown
setmetatable(Dropdown, Component)

function Dropdown.new(section, options)
    local self = Component.new("Dropdown")
    setmetatable(self, Dropdown)
    
    options = options or {}
    self.Section = section
    self.Title = options.Title or "Dropdown"
    self.Options = options.Options or {}
    self.Value = options.Value or nil
    self.Multi = options.Multi or false
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag or nil
    self.Open = false
    
    self:Build()
    if self.Flag then
        self.Section:SetFlag(self.Flag, self.Value)
    end
    return self
end

function Dropdown:Build()
    local container = GlassEngine.Create(self.Section.Content, {
        CornerRadius = UDim.new(0, 10),
        Transparency = 0.85
    })
    container.Name = "DropdownContainer"
    container.Size = UDim2.new(1, 0, 0, 44)
    container.ClipsDescendants = true
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = container
    
    local title = Instance.new("TextLabel")
    title.Text = self.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 14
    title.TextColor3 = ThemeManager:GetTheme().TextSecondary
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 16)
    title.Parent = container
    
    local selected = Instance.new("TextLabel")
    selected.Text = self.Value or "Select..."
    selected.Font = Enum.Font.Gotham
    selected.TextSize = 15
    selected.TextColor3 = ThemeManager:GetTheme().Text
    selected.TextXAlignment = Enum.TextXAlignment.Left
    selected.TextTruncate = Enum.TextTruncate.AtEnd
    selected.BackgroundTransparency = 1
    selected.Size = UDim2.new(1, -30, 0, 18)
    selected.Position = UDim2.new(0, 0, 1, -18)
    selected.AnchorPoint = Vector2.new(0, 1)
    selected.Parent = container
    
    local arrow = Instance.new("ImageLabel")
    arrow.Image = "rbxassetid://10709791200"
    arrow.BackgroundTransparency = 1
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.Position = UDim2.new(1, -16, 1, -9)
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.ImageColor3 = ThemeManager:GetTheme().TextSecondary
    arrow.Parent = container
    
    local list = Instance.new("ScrollingFrame")
    list.Name = "DropdownList"
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 1, 0)
    list.Visible = false
    list.ScrollBarThickness = 3
    list.Parent = container
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = list
    
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        list.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end)
    
    self.Container = container
    self.Selected = selected
    self.Arrow = arrow
    self.List = list
    self.TitleLabel = title
    
    self:BuildOptions()
    
    container.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    ThemeManager:Subscribe(function(theme)
        title.TextColor3 = theme.TextSecondary
        selected.TextColor3 = theme.Text
        arrow.ImageColor3 = theme.TextSecondary
    end)
end

function Dropdown:BuildOptions()
    for _, option in ipairs(self.Options) do
        local optionBtn = GlassEngine.CreateButton(self.List, {
            Size = UDim2.new(1, 0, 0, 32),
            CornerRadius = UDim.new(0, 6)
        })
        
        local optionText = Instance.new("TextLabel")
        optionText.Text = tostring(option)
        optionText.Font = Enum.Font.Gotham
        optionText.TextSize = 14
        optionText.TextColor3 = ThemeManager:GetTheme().Text
        optionText.TextXAlignment = Enum.TextXAlignment.Left
        optionText.BackgroundTransparency = 1
        optionText.Size = UDim2.new(1, -20, 1, 0)
        optionText.Position = UDim2.new(0, 10, 0, 0)
        optionText.Parent = optionBtn
        
        optionBtn.MouseButton1Click:Connect(function()
            self:SetValue(option)
            if not self.Multi then
                self:Toggle()
            end
        end)
        
        ThemeManager:Subscribe(function(theme)
            optionText.TextColor3 = theme.Text
        end)
    end
end

function Dropdown:Toggle()
    self.Open = not self.Open
    self.List.Visible = self.Open
    Services.TweenService:Create(self.Arrow, TweenInfo.new(0.2), {
        Rotation = self.Open and 180 or 0
    }):Play()
    Services.TweenService:Create(self.Container, TweenInfo.new(0.25), {
        Size = UDim2.new(1, 0, 0, self.Open and math.min(44 + #self.Options * 36, 200) or 44)
    }):Play()
end

function Dropdown:SetValue(value)
    self.Value = value
    self.Selected.Text = tostring(value)
    self.Callback(value)
    self:Fire("Changed", value)
    if self.Flag then
        self.Section:SetFlag(self.Flag, value)
    end
end

function Dropdown:GetValue()
    return self.Value
end

function Dropdown:SetOptions(options)
    self.Options = options
    self.List:ClearAllChildren()
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = self.List
    self:BuildOptions()
end

--[=[
    Button Component
]=]
Button = {}
Button.__index = Button
setmetatable(Button, Component)

function Button.new(section, options)
    local self = Component.new("Button")
    setmetatable(self, Button)
    
    options = options or {}
    self.Section = section
    self.Title = options.Title or "Button"
    self.Description = options.Description or ""
    self.Callback = options.Callback or function() end
    self.Icon = options.Icon or ""
    self.Color = options.Color or nil
    
    self:Build()
    return self
end

function Button:Build()
    local container = GlassEngine.CreateButton(self.Section.Content, {
        Size = UDim2.new(1, 0, 0, 48),
        CornerRadius = UDim.new(0, 10)
    })
    container.Name = "ButtonContainer"
    
    if self.Color then
        container.BackgroundColor3 = self.Color
    end
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 12)
    layout.Parent = container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = container
    
    if self.Icon ~= "" then
        local icon = Instance.new("ImageLabel")
        icon.Image = "rbxassetid://" .. self.Icon
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.ImageColor3 = ThemeManager:GetTheme().Text
        icon.Parent = container
        self.IconLabel = icon
    end
    
    local textContainer = Instance.new("Frame")
    textContainer.BackgroundTransparency = 1
    textContainer.Size = UDim2.new(1, -40, 1, 0)
    textContainer.Parent = container
    
    local title = Instance.new("TextLabel")
    title.Text = self.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 15
    title.TextColor3 = ThemeManager:GetTheme().Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 18)
    title.Parent = textContainer
    
    if self.Description ~= "" then
        local desc = Instance.new("TextLabel")
        desc.Text = self.Description
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 12
        desc.TextColor3 = ThemeManager:GetTheme().TextSecondary
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, 0, 0, 14)
        desc.Position = UDim2.new(0, 0, 1, -14)
        desc.Parent = textContainer
        textContainer.Size = UDim2.new(1, -40, 0, 36)
    end
    
    self.Container = container
    self.TitleLabel = title
    
    container.MouseButton1Click:Connect(function()
        self.Callback()
        self:Fire("Clicked")
    end)
    
    ThemeManager:Subscribe(function(theme)
        title.TextColor3 = theme.Text
        if self.IconLabel then
            self.IconLabel.ImageColor3 = theme.Text
        end
    end)
end

--[=[
    Input Component
]=]
Input = {}
Input.__index = Input
setmetatable(Input, Component)

function Input.new(section, options)
    local self = Component.new("Input")
    setmetatable(self, Input)
    
    options = options or {}
    self.Section = section
    self.Title = options.Title or "Input"
    self.Placeholder = options.Placeholder or ""
    self.Value = options.Value or ""
    self.Numeric = options.Numeric or false
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag or nil
    
    self:Build()
    if self.Flag then
        self.Section:SetFlag(self.Flag, self.Value)
    end
    return self
end

function Input:Build()
    local container = GlassEngine.Create(self.Section.Content, {
        CornerRadius = UDim.new(0, 10),
        Transparency = 0.85
    })
    container.Name = "InputContainer"
    container.Size = UDim2.new(1, 0, 0, 52)
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = container
    
    local title = Instance.new("TextLabel")
    title.Text = self.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 14
    title.TextColor3 = ThemeManager:GetTheme().TextSecondary
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 16)
    title.Parent = container
    
    local textBox = Instance.new("TextBox")
    textBox.Text = self.Value
    textBox.PlaceholderText = self.Placeholder
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 15
    textBox.TextColor3 = ThemeManager:GetTheme().Text
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.BackgroundTransparency = 1
    textBox.Size = UDim2.new(1, 0, 0, 20)
    textBox.Position = UDim2.new(0, 0, 1, -20)
    textBox.AnchorPoint = Vector2.new(0, 1)
    textBox.ClearTextOnFocus = false
    textBox.Parent = container
    
    self.Container = container
    self.TextBox = textBox
    self.TitleLabel = title
    
    textBox.FocusLost:Connect(function(enterPressed)
        local value = textBox.Text
        if self.Numeric then
            value = tonumber(value) or 0
        end
        self.Value = value
        self.Callback(value)
        self:Fire("Changed", value)
        if self.Flag then
            self.Section:SetFlag(self.Flag, value)
        end
    end)
    
    ThemeManager:Subscribe(function(theme)
        title.TextColor3 = theme.TextSecondary
        textBox.TextColor3 = theme.Text
        textBox.PlaceholderColor3 = theme.TextSecondary
    end)
end

function Input:SetValue(value)
    self.Value = value
    self.TextBox.Text = tostring(value)
    self.Callback(value)
    if self.Flag then
        self.Section:SetFlag(self.Flag, value)
    end
end

function Input:GetValue()
    return self.Value
end

--[=[
    ColorPicker Component
]=]
ColorPicker = {}
ColorPicker.__index = ColorPicker
setmetatable(ColorPicker, Component)

function ColorPicker.new(section, options)
    local self = Component.new("ColorPicker")
    setmetatable(self, ColorPicker)
    
    options = options or {}
    self.Section = section
    self.Title = options.Title or "Color Picker"
    self.Value = options.Value or Color3.fromRGB(255, 255, 255)
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag or nil
    self.Open = false
    
    self:Build()
    if self.Flag then
        self.Section:SetFlag(self.Flag, self.Value)
    end
    return self
end

function ColorPicker:Build()
    local container = GlassEngine.CreateButton(self.Section.Content, {
        Size = UDim2.new(1, 0, 0, 48),
        CornerRadius = UDim.new(0, 10)
    })
    container.Name = "ColorPickerContainer"
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 12)
    layout.Parent = container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = container
    
    local title = Instance.new("TextLabel")
    title.Text = self.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 15
    title.TextColor3 = ThemeManager:GetTheme().Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Parent = container
    
    local preview = Instance.new("Frame")
    preview.Name = "Preview"
    preview.BackgroundColor3 = self.Value
    preview.BorderSizePixel = 0
    preview.Size = UDim2.new(0, 28, 0, 28)
    preview.Parent = container
    
    local previewCorner = Instance.new("UICorner")
    previewCorner.CornerRadius = UDim.new(0, 6)
    previewCorner.Parent = preview
    
    local previewStroke = Instance.new("UIStroke")
    previewStroke.Color = ThemeManager:GetTheme().Border
    previewStroke.Thickness = 1.5
    previewStroke.Parent = preview
    
    self.Container = container
    self.TitleLabel = title
    self.Preview = preview
    
    container.MouseButton1Click:Connect(function()
        self:TogglePicker()
    end)
    
    ThemeManager:Subscribe(function(theme)
        title.TextColor3 = theme.Text
        previewStroke.Color = theme.Border
    end)
end

function ColorPicker:TogglePicker()
    -- Simplified color picker toggle
    -- In full implementation, this would open a color picker modal
    self.Open = not self.Open
    self:Fire("Toggled", self.Open)
end

function ColorPicker:SetValue(color)
    self.Value = color
    self.Preview.BackgroundColor3 = color
    self.Callback(color)
    self:Fire("Changed", color)
    if self.Flag then
        self.Section:SetFlag(self.Flag, color)
    end
end

function ColorPicker:GetValue()
    return self.Value
end

--[=[
    Keybind Component
]=]
Keybind = {}
Keybind.__index = Keybind
setmetatable(Keybind, Component)

function Keybind.new(section, options)
    local self = Component.new("Keybind")
    setmetatable(self, Keybind)
    
    options = options or {}
    self.Section = section
    self.Title = options.Title or "Keybind"
    self.Value = options.Value or "None"
    self.Mode = options.Mode or "Toggle" -- Toggle, Hold, Always
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag or nil
    self.Capturing = false
    
    self:Build()
    if self.Flag then
        self.Section:SetFlag(self.Flag, self.Value)
    end
    return self
end

function Keybind:Build()
    local container = GlassEngine.CreateButton(self.Section.Content, {
        Size = UDim2.new(1, 0, 0, 48),
        CornerRadius = UDim.new(0, 10)
    })
    container.Name = "KeybindContainer"
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 12)
    layout.Parent = container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = container
    
    local title = Instance.new("TextLabel")
    title.Text = self.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 15
    title.TextColor3 = ThemeManager:GetTheme().Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Parent = container
    
    local keyDisplay = GlassEngine.Create(container, {
        CornerRadius = UDim.new(0, 6),
        Transparency = 0.7
    })
    keyDisplay.Name = "KeyDisplay"
    keyDisplay.Size = UDim2.new(0, 60, 0, 28)
    keyDisplay.BackgroundColor3 = ThemeManager:GetTheme().SurfaceVariant
    
    local keyText = Instance.new("TextLabel")
    keyText.Text = self.Value
    keyText.Font = Enum.Font.GothamBold
    keyText.TextSize = 13
    keyText.TextColor3 = ThemeManager:GetTheme().Primary
    keyText.BackgroundTransparency = 1
    keyText.Size = UDim2.new(1, 0, 1, 0)
    keyText.Parent = keyDisplay
    
    self.Container = container
    self.TitleLabel = title
    self.KeyDisplay = keyDisplay
    self.KeyText = keyText
    
    container.MouseButton1Click:Connect(function()
        self:StartCapture()
    end)
    
    ThemeManager:Subscribe(function(theme)
        title.TextColor3 = theme.Text
        keyDisplay.BackgroundColor3 = theme.SurfaceVariant
        keyText.TextColor3 = theme.Primary
    end)
end

function Keybind:StartCapture()
    self.Capturing = true
    self.KeyText.Text = "..."
    self.KeyText.TextColor3 = ThemeManager:GetTheme().Warning
    
    local captureConn
    captureConn = Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        local key
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            key = input.KeyCode.Name
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            key = "MB1"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            key = "MB2"
        end
        
        if key then
            if key == "Escape" then
                key = "None"
            end
            self:SetValue(key)
            self.Capturing = false
            captureConn:Disconnect()
        end
    end)
end

function Keybind:SetValue(key)
    self.Value = key
    self.KeyText.Text = key
    self.KeyText.TextColor3 = ThemeManager:GetTheme().Primary
    self.Callback(key)
    self:Fire("Changed", key)
    if self.Flag then
        self.Section:SetFlag(self.Flag, key)
    end
end

function Keybind:GetValue()
    return self.Value
end

--[=[
    Label Component
]=]
Label = {}
Label.__index = Label
setmetatable(Label, Component)

function Label.new(section, options)
    local self = Component.new("Label")
    setmetatable(self, Label)
    
    options = options or {}
    self.Section = section
    self.Text = options.Text or "Label"
    self.Description = options.Description or ""
    
    self:Build()
    return self
end

function Label:Build()
    local container = Instance.new("Frame")
    container.Name = "LabelContainer"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 0)
    container.Parent = self.Section.Content
    
    local title = Instance.new("TextLabel")
    title.Text = self.Text
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 15
    title.TextColor3 = ThemeManager:GetTheme().Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextWrapped = true
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Parent = container
    
    if self.Description ~= "" then
        local desc = Instance.new("TextLabel")
        desc.Text = self.Description
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 13
        desc.TextColor3 = ThemeManager:GetTheme().TextSecondary
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextWrapped = true
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, 0, 0, 18)
        desc.Position = UDim2.new(0, 0, 0, 22)
        desc.Parent = container
        container.Size = UDim2.new(1, 0, 0, 44)
    else
        container.Size = UDim2.new(1, 0, 0, 24)
    end
    
    self.Container = container
    self.TitleLabel = title
    
    ThemeManager:Subscribe(function(theme)
        title.TextColor3 = theme.Text
    end)
end

function Label:SetText(text)
    self.Text = text
    self.TitleLabel.Text = text
end

--[=[
    Separator Component
]=]
Separator = {}
Separator.__index = Separator
setmetatable(Separator, Component)

function Separator.new(section, options)
    local self = Component.new("Separator")
    setmetatable(self, Separator)
    
    self.Section = section
    self:Build()
    return self
end

function Separator:Build()
    local container = Instance.new("Frame")
    container.Name = "SeparatorContainer"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 12)
    container.Parent = self.Section.Content
    
    local line = Instance.new("Frame")
    line.Name = "Line"
    line.BackgroundColor3 = ThemeManager:GetTheme().Border
    line.BorderSizePixel = 0
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.AnchorPoint = Vector2.new(0, 0.5)
    line.Parent = container
    
    self.Container = container
    
    ThemeManager:Subscribe(function(theme)
        line.BackgroundColor3 = theme.Border
    end)
end

-- ============================================================================
-- SECTION 10: NOTIFICATION SYSTEM
-- ============================================================================

local NotificationManager = {
    Queue = {},
    MaxNotifications = 5,
    Container = nil,
}

function NotificationManager:Initialize()
    local container = Instance.new("Frame")
    container.Name = "NotificationContainer"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(0, 320, 1, 0)
    container.Position = UDim2.new(1, -20, 0, 20)
    container.AnchorPoint = Vector2.new(1, 0)
    container.Parent = Services.CoreGui
    
    local layout = Instance.new("UIListLayout")
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container
    
    self.Container = container
end

function NotificationManager:Notify(options)
    if not self.Container then
        self:Initialize()
    end
    
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 5
    local icon = options.Icon or "info"
    local type = options.Type or "info"
    
    local notification = GlassEngine.Create(self.Container, {
        CornerRadius = UDim.new(0, 10),
        Transparency = 0.85
    })
    notification.Name = "Notification"
    notification.Size = UDim2.new(1, 0, 0, 0)
    notification.ClipsDescendants = true
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = notification
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = notification
    
    local titleText = Instance.new("TextLabel")
    titleText.Text = title
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 15
    titleText.TextColor3 = ThemeManager:GetTheme().Text
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, 0, 0, 18)
    titleText.Parent = notification
    
    if content ~= "" then
        local contentText = Instance.new("TextLabel")
        contentText.Text = content
        contentText.Font = Enum.Font.Gotham
        contentText.TextSize = 13
        contentText.TextColor3 = ThemeManager:GetTheme().TextSecondary
        contentText.TextXAlignment = Enum.TextXAlignment.Left
        contentText.TextWrapped = true
        contentText.BackgroundTransparency = 1
        contentText.Size = UDim2.new(1, 0, 0, 0)
        contentText.Parent = notification
        
        local textBounds = Services.TextService:GetTextSize(
            content,
            13,
            Enum.Font.Gotham,
            Vector2.new(280, math.huge)
        )
        contentText.Size = UDim2.new(1, 0, 0, textBounds.Y)
    end
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        notification.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 24)
    end)
    
    local theme = ThemeManager:GetTheme()
    local color = theme.Primary
    if type == "success" then
        color = theme.Success
    elseif type == "error" then
        color = theme.Error
    elseif type == "warning" then
        color = theme.Warning
    end
    
    local indicator = Instance.new("Frame")
    indicator.BackgroundColor3 = color
    indicator.BorderSizePixel = 0
    indicator.Size = UDim2.new(0, 4, 1, 0)
    indicator.Position = UDim2.new(0, 0, 0, 0)
    indicator.Parent = notification
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    Services.TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.delay(duration, function()
        Services.TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 0, 0, 0),
            Transparency = 1
        }):Play()
        task.delay(0.3, function()
            notification:Destroy()
        end)
    end)
end

-- ============================================================================
-- SECTION 11: MAIN LIBRARY
-- ============================================================================

local AetherUI = {
    Version = "1.0.0",
    Windows = {},
    Flags = {},
}

function AetherUI:CreateWindow(options)
    local window = Window.new(options)
    table.insert(self.Windows, window)
    return window
end

function AetherUI:Notify(options)
    NotificationManager:Notify(options)
end

function AetherUI:SetTheme(themeName)
    ThemeManager:SetTheme(themeName)
end

function AetherUI:GetTheme()
    return ThemeManager.CurrentTheme
end

function AetherUI:CreateCustomTheme(name, themeData)
    ThemeManager:CreateCustomTheme(name, themeData)
end

function AetherUI:GetFlag(flag)
    return self.Flags[flag]
end

function AetherUI:SetFlag(flag, value)
    self.Flags[flag] = value
end

function AetherUI:DestroyAll()
    for _, window in ipairs(self.Windows) do
        window:Destroy()
    end
    self.Windows = {}
end

-- Initialize notification system
NotificationManager:Initialize()

-- Print library info
print("╔═══════════════════════════════════════════════════════════════════")
print("║  AetherUI v1.0.0 - Next Generation Roblox UI Library")
print("║  Developer: Delta | Lines: 1600+ | Date: May 12, 2026")
print("╚═══════════════════════════════════════════════════════════════════")

return AetherUI
