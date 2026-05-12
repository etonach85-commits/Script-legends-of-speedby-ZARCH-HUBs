--[[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║                           AETHER UI LIBRARY v2.0.0                           ║
    ║                    WindUI Inspired • Next-Gen Framework                      ║
    ╠══════════════════════════════════════════════════════════════════════════════╣
    ║  👤 Developer: Delta                                                         ║
    ║  📅 Version: v2.0.0 (May 12, 2026)                                           ║
    ║  📝 Lines: 2000+                                                             ║
    ║  🎯 Goal: Superior UI with WindUI features + Aether aesthetics               ║
    ╠══════════════════════════════════════════════════════════════════════════════╣
    ║  ✨ NEW FEATURES v2.0.0:                                                     ║
    ║  ├─ 🏷️ Tag System with multiple badges                                       ║
    ║  ├─ 🔘 OpenButton with gradient, draggable, customizable                     ║
    ║  ├─ 👤 Author field in window                                               ║
    ║  ├─ 📝 Paragraph element with image, thumbnail, buttons                      ║
    ║  ├─ 🖼️ Image element in sections                                            ║
    ║  ├─ 🔒 Locked state for all elements                                        ║
    ║  ├─ 📄 Textarea input type                                                  ║
    ║  ├─ ✨ Button highlight & justify options                                    ║
    ║  ├─ 📋 Dropdown with icon support (table values)                            ║
    ║  ├─ 🎚️ Slider with step support                                             ║
    ║  ├─ 💾 Full Config Manager (Save/Load/Delete/AllConfigs)                    ║
    ║  ├─ 🔍 Search bar toggle                                                    ║
    ║  ├─ 🎨 AddTheme method for custom themes                                    ║
    ║  ├─ 📐 Space element                                                        ║
    ║  └─ 💎 Retained: Glassmorphism, Ripple, 8 Themes, Animations                ║
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

local MathUtil = {}
function MathUtil.Lerp(start, goal, alpha) return start + (goal - start) * alpha end
function MathUtil.Clamp(value, min, max) return math.min(math.max(value, min), max) end
function MathUtil.Round(value, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(value * mult + 0.5) / mult
end

local TableUtil = {}
function TableUtil.Copy(t)
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = type(v) == "table" and TableUtil.Copy(v) or v
    end
    return copy
end
function TableUtil.Merge(t1, t2)
    local merged = TableUtil.Copy(t1)
    for k, v in pairs(t2) do merged[k] = v end
    return merged
end

local Signal = {}
Signal.__index = Signal
function Signal.new()
    return setmetatable({_connections = {}}, Signal)
end
function Signal:Connect(callback)
    local conn = {callback = callback, Disconnect = function()
        local idx = table.find(self._connections, conn)
        if idx then table.remove(self._connections, idx) end
    end}
    table.insert(self._connections, conn)
    return conn
end
function Signal:Fire(...) for _, c in ipairs(self._connections) do task.spawn(c.callback, ...) end end

-- ============================================================================
-- SECTION 3: THEME SYSTEM
-- ============================================================================

local Themes = {
    Dark = {
        Name = "Dark", Background = Color3.fromRGB(18, 18, 24), Surface = Color3.fromRGB(30, 30, 40),
        SurfaceVariant = Color3.fromRGB(40, 40, 52), Primary = Color3.fromRGB(99, 102, 241),
        PrimaryVariant = Color3.fromRGB(79, 70, 229), Secondary = Color3.fromRGB(16, 185, 129),
        Text = Color3.fromRGB(240, 240, 245), TextSecondary = Color3.fromRGB(160, 160, 175),
        Border = Color3.fromRGB(60, 60, 75), Accent = Color3.fromRGB(236, 72, 153),
        Success = Color3.fromRGB(34, 197, 94), Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11), GlassOpacity = 0.85, BlurIntensity = 20,
    },
    Light = {
        Name = "Light", Background = Color3.fromRGB(245, 245, 250), Surface = Color3.fromRGB(255, 255, 255),
        SurfaceVariant = Color3.fromRGB(240, 240, 248), Primary = Color3.fromRGB(79, 70, 229),
        PrimaryVariant = Color3.fromRGB(67, 56, 202), Secondary = Color3.fromRGB(5, 150, 105),
        Text = Color3.fromRGB(20, 20, 30), TextSecondary = Color3.fromRGB(80, 80, 100),
        Border = Color3.fromRGB(220, 220, 230), Accent = Color3.fromRGB(219, 39, 119),
        Success = Color3.fromRGB(22, 163, 74), Error = Color3.fromRGB(220, 38, 38),
        Warning = Color3.fromRGB(217, 119, 6), GlassOpacity = 0.75, BlurIntensity = 15,
    },
    Midnight = {
        Name = "Midnight", Background = Color3.fromRGB(10, 12, 18), Surface = Color3.fromRGB(20, 24, 32),
        SurfaceVariant = Color3.fromRGB(28, 34, 44), Primary = Color3.fromRGB(56, 189, 248),
        PrimaryVariant = Color3.fromRGB(14, 165, 233), Secondary = Color3.fromRGB(168, 85, 247),
        Text = Color3.fromRGB(230, 235, 245), TextSecondary = Color3.fromRGB(140, 150, 170),
        Border = Color3.fromRGB(40, 48, 62), Accent = Color3.fromRGB(251, 146, 60),
        Success = Color3.fromRGB(74, 222, 128), Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(250, 204, 21), GlassOpacity = 0.9, BlurIntensity = 25,
    },
    Rose = {
        Name = "Rose", Background = Color3.fromRGB(28, 20, 26), Surface = Color3.fromRGB(42, 32, 40),
        SurfaceVariant = Color3.fromRGB(54, 42, 52), Primary = Color3.fromRGB(244, 114, 182),
        PrimaryVariant = Color3.fromRGB(236, 72, 153), Secondary = Color3.fromRGB(251, 191, 36),
        Text = Color3.fromRGB(250, 240, 245), TextSecondary = Color3.fromRGB(180, 160, 175),
        Border = Color3.fromRGB(68, 52, 64), Accent = Color3.fromRGB(139, 92, 246),
        Success = Color3.fromRGB(16, 185, 129), Error = Color3.fromRGB(244, 63, 94),
        Warning = Color3.fromRGB(245, 158, 11), GlassOpacity = 0.88, BlurIntensity = 22,
    },
    Ocean = {
        Name = "Ocean", Background = Color3.fromRGB(15, 23, 42), Surface = Color3.fromRGB(30, 41, 59),
        SurfaceVariant = Color3.fromRGB(45, 58, 78), Primary = Color3.fromRGB(56, 189, 248),
        PrimaryVariant = Color3.fromRGB(14, 165, 233), Secondary = Color3.fromRGB(34, 211, 238),
        Text = Color3.fromRGB(240, 248, 255), TextSecondary = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(51, 65, 85), Accent = Color3.fromRGB(244, 114, 182),
        Success = Color3.fromRGB(74, 222, 128), Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(250, 204, 21), GlassOpacity = 0.85, BlurIntensity = 20,
    },
    Forest = {
        Name = "Forest", Background = Color3.fromRGB(15, 28, 22), Surface = Color3.fromRGB(25, 42, 34),
        SurfaceVariant = Color3.fromRGB(35, 54, 45), Primary = Color3.fromRGB(16, 185, 129),
        PrimaryVariant = Color3.fromRGB(5, 150, 105), Secondary = Color3.fromRGB(132, 204, 22),
        Text = Color3.fromRGB(235, 245, 240), TextSecondary = Color3.fromRGB(150, 170, 160),
        Border = Color3.fromRGB(40, 60, 50), Accent = Color3.fromRGB(245, 158, 11),
        Success = Color3.fromRGB(74, 222, 128), Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(251, 191, 36), GlassOpacity = 0.87, BlurIntensity = 18,
    },
    Sunset = {
        Name = "Sunset", Background = Color3.fromRGB(35, 20, 30), Surface = Color3.fromRGB(50, 30, 42),
        SurfaceVariant = Color3.fromRGB(65, 40, 55), Primary = Color3.fromRGB(251, 146, 60),
        PrimaryVariant = Color3.fromRGB(249, 115, 22), Secondary = Color3.fromRGB(236, 72, 153),
        Text = Color3.fromRGB(250, 240, 245), TextSecondary = Color3.fromRGB(180, 160, 170),
        Border = Color3.fromRGB(75, 50, 65), Accent = Color3.fromRGB(139, 92, 246),
        Success = Color3.fromRGB(34, 197, 94), Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11), GlassOpacity = 0.86, BlurIntensity = 21,
    },
    Cyber = {
        Name = "Cyber", Background = Color3.fromRGB(8, 10, 15), Surface = Color3.fromRGB(18, 22, 28),
        SurfaceVariant = Color3.fromRGB(26, 32, 40), Primary = Color3.fromRGB(0, 255, 170),
        PrimaryVariant = Color3.fromRGB(0, 210, 140), Secondary = Color3.fromRGB(255, 0, 128),
        Text = Color3.fromRGB(230, 245, 240), TextSecondary = Color3.fromRGB(140, 160, 155),
        Border = Color3.fromRGB(35, 42, 52), Accent = Color3.fromRGB(120, 80, 255),
        Success = Color3.fromRGB(0, 255, 170), Error = Color3.fromRGB(255, 50, 80),
        Warning = Color3.fromRGB(255, 200, 0), GlassOpacity = 0.92, BlurIntensity = 28,
    },
}

local ThemeManager = {CurrentTheme = "Dark", Subscribers = {}}
function ThemeManager:GetTheme() return Themes[self.CurrentTheme] or Themes.Dark end
function ThemeManager:SetTheme(name)
    if Themes[name] then
        self.CurrentTheme = name
        for _, cb in ipairs(self.Subscribers) do task.spawn(cb, Themes[name]) end
        return true
    end
    return false
end
function ThemeManager:Subscribe(cb) table.insert(self.Subscribers, cb); cb(self:GetTheme()) end
function ThemeManager:AddTheme(name, data)
    Themes[name] = TableUtil.Merge(Themes.Dark, data)
    Themes[name].Name = name
end

-- ============================================================================
-- SECTION 4: GLASSMORPHISM ENGINE
-- ============================================================================

local GlassEngine = {}
function GlassEngine.Create(parent, opts)
    opts = opts or {}
    local theme = ThemeManager:GetTheme()
    local glass = Instance.new("Frame")
    glass.Name = "GlassSurface"
    glass.BackgroundTransparency = opts.Transparency or theme.GlassOpacity
    glass.BackgroundColor3 = opts.Color or theme.Surface
    glass.BorderSizePixel = 0
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = opts.CornerRadius or UDim.new(0, 12)
    corner.Parent = glass
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Border
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = glass
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 135
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(220,220,220))
    }
    gradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(1, 0.95)
    }
    gradient.Parent = glass
    ThemeManager:Subscribe(function(t)
        glass.BackgroundColor3 = opts.Color or t.Surface
        stroke.Color = t.Border
    end)
    return glass
end

function GlassEngine.CreateButton(parent, opts)
    opts = opts or {}
    local theme = ThemeManager:GetTheme()
    local btn = Instance.new("TextButton")
    btn.Name = "GlassButton"
    btn.Text = ""
    btn.BackgroundTransparency = opts.Transparency or 0.8
    btn.BackgroundColor3 = opts.Color or theme.SurfaceVariant
    btn.BorderSizePixel = 0
    btn.Size = opts.Size or UDim2.new(1, 0, 0, 40)
    btn.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = opts.CornerRadius or UDim.new(0, 10)
    corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Border
    stroke.Thickness = 1
    stroke.Parent = btn
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundTransparency = 0.6
    ripple.BackgroundColor3 = theme.Primary
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Parent = btn
    Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
    btn.MouseButton1Click:Connect(function()
        if btn.Active == false then return end
        local clone = ripple:Clone()
        clone.Parent = btn
        clone.Visible = true
        local pos = Vector2.new(Mouse.X, Mouse.Y) - btn.AbsolutePosition
        clone.Position = UDim2.new(0, pos.X, 0, pos.Y)
        clone.AnchorPoint = Vector2.new(0.5, 0.5)
        Services.TweenService:Create(clone, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1
        }):Play()
        task.delay(0.6, function() if clone then clone:Destroy() end end)
    end)
    ThemeManager:Subscribe(function(t)
        btn.BackgroundColor3 = opts.Color or t.SurfaceVariant
        stroke.Color = t.Border
        ripple.BackgroundColor3 = t.Primary
    end)
    return btn
end

-- ============================================================================
-- SECTION 5: CONFIG MANAGER
-- ============================================================================

local ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager.new(folder)
    local self = setmetatable({Folder = folder or "AetherUI", Configs = {}}, ConfigManager)
    self:LoadConfigs()
    return self
end

function ConfigManager:LoadConfigs()
    local success, res = pcall(function() return listfiles(self.Folder) end)
    if success and res then
        for _, file in ipairs(res) do
            if file:match("%.json$") then
                local name = file:match("([^/\\]+)%.json$")
                table.insert(self.Configs, name)
            end
        end
    end
end

function ConfigManager:AllConfigs()
    return TableUtil.Copy(self.Configs)
end

function ConfigManager:CreateConfig(name)
    return {
        Name = name,
        Save = function(data)
            local success = pcall(function()
                writefile(self.Folder .. "/" .. name .. ".json", game:GetService("HttpService"):JSONEncode(data))
            end)
            return success
        end,
        Load = function()
            local success, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(readfile(self.Folder .. "/" .. name .. ".json"))
            end)
            return success and data or nil
        end,
        Delete = function()
            local success = pcall(function()
                delfile(self.Folder .. "/" .. name .. ".json")
            end)
            if success then
                local idx = table.find(self.Configs, name)
                if idx then table.remove(self.Configs, idx) end
            end
            return success
        end
    }
end

-- ============================================================================
-- SECTION 6: WINDOW COMPONENT
-- ============================================================================

local Window = {}
Window.__index = Window

function Window.new(opts)
    local self = setmetatable({}, Window)
    opts = opts or {}
    self.Title = opts.Title or "AetherUI Window"
    self.Author = opts.Author or ""
    self.Size = opts.Size or UDim2.fromOffset(700, 520)
    self.Theme = opts.Theme or "Dark"
    self.Folder = opts.Folder or "AetherUI"
    self.Acrylic = opts.Acrylic ~= false
    self.Draggable = opts.Draggable ~= false
    self.Closable = opts.Closable ~= false
    self.Minimizable = opts.Minimizable ~= false
    self.HideSearchBar = opts.HideSearchBar or false
    self.OpenButton = opts.OpenButton or {Enabled = false}
    self.Tags = {}
    self.Tabs = {}
    self.Flags = {}
    self.ConfigManager = ConfigManager.new(self.Folder)
    ThemeManager.CurrentTheme = self.Theme
    self:Build()
    if self.OpenButton.Enabled then self:BuildOpenButton() end
    return self
end

function Window:Build()
    local sg = Instance.new("ScreenGui")
    sg.Name = "AetherUI_" .. self.Title
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = Services.CoreGui
    self.ScreenGui = sg
    
    local container = Instance.new("Frame")
    container.Name = "WindowContainer"
    container.BackgroundTransparency = 1
    container.Size = self.Size
    container.Position = UDim2.fromScale(0.5, 0.5)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Parent = sg
    self.Container = container
    
    local glass = GlassEngine.Create(container, {CornerRadius = UDim.new(0, 16)})
    glass.Name = "WindowGlass"
    self.Glass = glass
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundTransparency = 1
    titleBar.Size = UDim2.new(1, 0, 0, 55)
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
    titleText.Size = UDim2.new(1, -200, 1, 0)
    titleText.Position = UDim2.new(0, 16, 0, 0)
    titleText.Parent = titleBar
    self.TitleText = titleText
    
    if self.Author ~= "" then
        local authorText = Instance.new("TextLabel")
        authorText.Name = "AuthorText"
        authorText.Text = self.Author
        authorText.Font = Enum.Font.Gotham
        authorText.TextSize = 13
        authorText.TextColor3 = ThemeManager:GetTheme().TextSecondary
        authorText.TextXAlignment = Enum.TextXAlignment.Left
        authorText.BackgroundTransparency = 1
        authorText.Size = UDim2.new(1, -200, 0, 16)
        authorText.Position = UDim2.new(0, 16, 1, -18)
        authorText.Parent = titleBar
        self.AuthorText = authorText
    end
    
    -- Tags Container
    local tagsContainer = Instance.new("Frame")
    tagsContainer.Name = "TagsContainer"
    tagsContainer.BackgroundTransparency = 1
    tagsContainer.Size = UDim2.new(0, 0, 0, 24)
    tagsContainer.Position = UDim2.new(0, 16, 0, 28)
    tagsContainer.Parent = titleBar
    local tagsLayout = Instance.new("UIListLayout")
    tagsLayout.FillDirection = Enum.FillDirection.Horizontal
    tagsLayout.Padding = UDim.new(0, 6)
    tagsLayout.Parent = tagsContainer
    self.TagsContainer = tagsContainer
    
    -- Buttons
    local btnContainer = Instance.new("Frame")
    btnContainer.Name = "ButtonContainer"
    btnContainer.BackgroundTransparency = 1
    btnContainer.Size = UDim2.new(0, 100, 1, 0)
    btnContainer.Position = UDim2.new(1, -100, 0, 0)
    btnContainer.Parent = titleBar
    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    btnLayout.Padding = UDim.new(0, 8)
    btnLayout.Parent = btnContainer
    
    if self.Minimizable then
        local minBtn = GlassEngine.CreateButton(btnContainer, {Size = UDim2.new(0, 32, 0, 32), CornerRadius = UDim.new(0, 8)})
        minBtn.Name = "MinimizeButton"
        local minIcon = Instance.new("ImageLabel")
        minIcon.Image = "rbxassetid://10709791437"
        minIcon.BackgroundTransparency = 1
        minIcon.Size = UDim2.new(0, 16, 0, 16)
        minIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        minIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        minIcon.ImageColor3 = ThemeManager:GetTheme().Text
        minIcon.Parent = minBtn
        minBtn.MouseButton1Click:Connect(function() self:ToggleMinimize() end)
    end
    
    if self.Closable then
        local closeBtn = GlassEngine.CreateButton(btnContainer, {Size = UDim2.new(0, 32, 0, 32), CornerRadius = UDim.new(0, 8)})
        closeBtn.Name = "CloseButton"
        local closeIcon = Instance.new("ImageLabel")
        closeIcon.Image = "rbxassetid://10709791332"
        closeIcon.BackgroundTransparency = 1
        closeIcon.Size = UDim2.new(0, 16, 0, 16)
        closeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        closeIcon.ImageColor3 = ThemeManager:GetTheme().Error
        closeIcon.Parent = closeBtn
        closeBtn.MouseButton1Click:Connect(function() self:Hide() end)
    end
    
    -- Content
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Size = UDim2.new(1, -20, 1, -75)
    content.Position = UDim2.new(0, 10, 0, 65)
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
    
    -- Dragging
    if self.Draggable then
        local dragging, dragStart, startPos = false, Vector2.new(), UDim2.new()
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging, dragStart, startPos = true, Vector2.new(input.Position.X, input.Position.Y), container.Position
            end
        end)
        titleBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        Services.UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
                container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    
    ThemeManager:Subscribe(function(t)
        titleText.TextColor3 = t.Text
        if self.AuthorText then self.AuthorText.TextColor3 = t.TextSecondary end
        content.ScrollBarImageColor3 = t.Primary
    end)
end

function Window:BuildOpenButton()
    local opts = self.OpenButton
    local btn = Instance.new("TextButton")
    btn.Name = "OpenButton"
    btn.Text = opts.Title or "Open UI"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Size = UDim2.new(0, 140, 0, 40)
    btn.Position = UDim2.new(0, 20, 0.5, 0)
    btn.Parent = self.ScreenGui
    btn.ZIndex = 100
    local corner = Instance.new("UICorner")
    corner.CornerRadius = opts.CornerRadius or UDim.new(0, 10)
    corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = opts.StrokeThickness or 2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Parent = btn
    if opts.Color then
        local gradient = Instance.new("UIGradient")
        gradient.Color = opts.Color
        gradient.Parent = btn
    else
        btn.BackgroundColor3 = ThemeManager:GetTheme().Primary
    end
    btn.MouseButton1Click:Connect(function() self:Toggle() end)
    if opts.Draggable then
        local dragging, dragStart, startPos = false, Vector2.new(), UDim2.new()
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging, dragStart, startPos = true, Vector2.new(input.Position.X, input.Position.Y), btn.Position
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        Services.UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
                btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    self.OpenButtonInstance = btn
end

function Window:Tag(opts)
    opts = opts or {}
    local tag = Instance.new("Frame")
    tag.Name = "Tag"
    tag.BackgroundColor3 = opts.Color or ThemeManager:GetTheme().Primary
    tag.BackgroundTransparency = 0.1
    tag.BorderSizePixel = 0
    tag.Size = UDim2.new(0, 0, 1, 0)
    tag.Parent = self.TagsContainer
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tag
    local stroke = Instance.new("UIStroke")
    stroke.Color = opts.Color or ThemeManager:GetTheme().Primary
    stroke.Thickness = 1.5
    stroke.Parent = tag
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 4)
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Parent = tag
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 4)
    padding.Parent = tag
    if opts.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Image = "rbxassetid://" .. opts.Icon
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0, 14, 0, 14)
        icon.ImageColor3 = opts.Color or ThemeManager:GetTheme().Text
        icon.Parent = tag
    end
    local text = Instance.new("TextLabel")
    text.Text = opts.Title or ""
    text.Font = Enum.Font.GothamMedium
    text.TextSize = 12
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(0, 0, 1, 0)
    text.AutomaticSize = Enum.AutomaticSize.X
    text.Parent = tag
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tag.Size = UDim2.new(0, layout.AbsoluteContentSize.X + 16, 0, 24)
    end)
    table.insert(self.Tags, tag)
end

function Window:Show()
    if self.Container then
        self.Container.Visible = true
        Services.TweenService:Create(self.Container, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = self.Size}):Play()
    end
end

function Window:Hide()
    if self.Container then
        Services.TweenService:Create(self.Container, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(0.3, function() self.Container.Visible = false end)
    end
end

function Window:Toggle()
    if self.Container.Visible then self:Hide() else self:Show() end
end

function Window:ToggleMinimize()
    self.Minimized = not self.Minimized
    Services.TweenService:Create(self.Content, TweenInfo.new(0.25), {
        Size = self.Minimized and UDim2.new(1, -20, 0, 0) or UDim2.new(1, -20, 1, -75)
    }):Play()
end

function Window:SetToggleKey(key)
    Services.UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == key then self:Toggle() end
    end)
end

function Window:Tab(opts)
    local tab = Tab.new(self, opts)
    table.insert(self.Tabs, tab)
    return tab
end

function Window:Destroy()
    if self.ScreenGui then self.ScreenGui:Destroy() end
    if self.OpenButtonInstance then self.OpenButtonInstance:Destroy() end
end

-- ============================================================================
-- SECTION 7: TAB COMPONENT
-- ============================================================================

Tab = {}
Tab.__index = Tab

function Tab.new(window, opts)
    local self = setmetatable({}, Tab)
    opts = opts or {}
    self.Window = window
    self.Title = opts.Title or "Tab"
    self.Icon = opts.Icon or ""
    self.Active = #window.Tabs == 0
    self.Elements = {}
    self:Build()
    return self
end

function Tab:Build()
    local btn = GlassEngine.CreateButton(self.Window.Content, {Size = UDim2.new(1, 0, 0, 45), CornerRadius = UDim.new(0, 10)})
    btn.Name = "TabButton"
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 12)
    layout.Parent = btn
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 14)
    padding.Parent = btn
    if self.Icon ~= "" then
        local icon = Instance.new("ImageLabel")
        icon.Image = "rbxassetid://" .. self.Icon
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.ImageColor3 = ThemeManager:GetTheme().Text
        icon.Parent = btn
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
    title.Parent = btn
    self.TitleLabel = title
    local indicator = Instance.new("Frame")
    indicator.Name = "ActiveIndicator"
    indicator.BackgroundColor3 = ThemeManager:GetTheme().Primary
    indicator.BorderSizePixel = 0
    indicator.Size = UDim2.new(0, 4, 0, 24)
    indicator.Position = UDim2.new(0, 0, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.Visible = self.Active
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    indicator.Parent = btn
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
    self.Button = btn
    btn.MouseButton1Click:Connect(function() self:Select() end)
    ThemeManager:Subscribe(function(t)
        title.TextColor3 = t.Text
        if self.IconLabel then self.IconLabel.ImageColor3 = t.Text end
        indicator.BackgroundColor3 = t.Primary
    end)
end

function Tab:Select()
    for _, tab in ipairs(self.Window.Tabs) do
        if tab ~= self then tab:Deselect() end
    end
    self.Active = true
    self.Indicator.Visible = true
    self.Content.Visible = true
    Services.TweenService:Create(self.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
end

function Tab:Deselect()
    self.Active = false
    self.Indicator.Visible = false
    self.Content.Visible = false
    Services.TweenService:Create(self.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play()
end

function Tab:Section(opts)
    local section = Section.new(self, opts)
    table.insert(self.Elements, section)
    return section
end

function Tab:Space(opts)
    opts = opts or {}
    local space = Instance.new("Frame")
    space.Name = "Space"
    space.BackgroundTransparency = 1
    space.Size = UDim2.new(1, 0, 0, opts.Size or 8)
    space.Parent = self.Content
    return space
end

-- Forward element creation to section
for _, name in ipairs{"Toggle", "Slider", "Dropdown", "Button", "Input", "Colorpicker", "Keybind", "Paragraph", "Image", "Label"} do
    Tab[name] = function(self, opts)
        local section = self:Section({Title = ""})
        return section[name](section, opts)
    end
end

-- ============================================================================
-- SECTION 8: SECTION COMPONENT
-- ============================================================================

Section = {}
Section.__index = Section

function Section.new(tab, opts)
    local self = setmetatable({}, Section)
    opts = opts or {}
    self.Tab = tab
    self.Title = opts.Title or "Section"
    self.Collapsed = opts.Collapsed or false
    self.Elements = {}
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
        collapseBtn.MouseButton1Click:Connect(function() self:ToggleCollapse() end)
        self.CollapseBtn = collapseBtn
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
    ThemeManager:Subscribe(function(t)
        if self.TitleLabel then self.TitleLabel.TextColor3 = t.TextSecondary end
        if self.CollapseBtn then self.CollapseBtn.ImageColor3 = t.TextSecondary end
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
        Services.TweenService:Create(self.CollapseBtn, TweenInfo.new(0.2), {Rotation = self.Collapsed and 180 or 0}):Play()
    end
    self:UpdateSize()
end

function Section:Space(opts)
    opts = opts or {}
    local space = Instance.new("Frame")
    space.Name = "Space"
    space.BackgroundTransparency = 1
    space.Size = UDim2.new(1, 0, 0, opts.Size or 6)
    space.Parent = self.Content
    return space
end

-- ============================================================================
-- SECTION 9: UI ELEMENTS
-- ============================================================================

-- Base Element
local Element = {}
Element.__index = Element
function Element.new(section, type, opts)
    local self = setmetatable({}, Element)
    self.Section = section
    self.Type = type
    self.Title = opts.Title or ""
    self.Desc = opts.Desc or ""
    self.Flag = opts.Flag or nil
    self.Locked = opts.Locked or false
    self.Callback = opts.Callback or function() end
    self.Container = nil
    return self
end
function Element:SetLocked(locked)
    self.Locked = locked
    if self.Container then
        self.Container.Active = not locked
        Services.TweenService:Create(self.Container, TweenInfo.new(0.2), {
            BackgroundTransparency = locked and 0.95 or 0.85
        }):Play()
        if self.LockedOverlay then
            self.LockedOverlay.Visible = locked
        end
    end
end
function Element:AddLockedOverlay()
    if not self.Container then return end
    local overlay = Instance.new("Frame")
    overlay.Name = "LockedOverlay"
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Visible = self.Locked
    overlay.Parent = self.Container
    overlay.ZIndex = 10
    local icon = Instance.new("ImageLabel")
    icon.Image = "rbxassetid://10709791380"
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(1, -10, 0.5, 0)
    icon.AnchorPoint = Vector2.new(1, 0.5)
    icon.ImageColor3 = ThemeManager:GetTheme().Warning
    icon.Parent = overlay
    self.LockedOverlay = overlay
end

-- Toggle
function Section:Toggle(opts)
    opts = opts or {}
    local el = Element.new(self, "Toggle", opts)
    el.Value = opts.Value or opts.Default or false
    local container = GlassEngine.CreateButton(self.Content, {Size = UDim2.new(1, 0, 0, 48), CornerRadius = UDim.new(0, 10)})
    container.Name = "ToggleContainer"
    el.Container = container
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
    title.Text = el.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 15
    title.TextColor3 = ThemeManager:GetTheme().Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 18)
    title.Parent = textContainer
    if el.Desc ~= "" then
        local desc = Instance.new("TextLabel")
        desc.Text = el.Desc
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
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.BackgroundColor3 = ThemeManager:GetTheme().TextSecondary
    knob.BorderSizePixel = 0
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, 0)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Parent = switch
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    el.Container = container
    el.Switch = switch
    el.Knob = knob
    el:UpdateVisual()
    el:AddLockedOverlay()
    container.MouseButton1Click:Connect(function()
        if el.Locked then return end
        el:SetValue(not el.Value)
    end)
    ThemeManager:Subscribe(function(t)
        title.TextColor3 = t.Text
        if el.Desc ~= "" then textContainer:GetChildren()[2].TextColor3 = t.TextSecondary end
        if not el.Value then
            switch.BackgroundColor3 = t.SurfaceVariant
            knob.BackgroundColor3 = t.TextSecondary
        end
    end)
    if el.Flag then el.Section.Tab.Window.Flags[el.Flag] = el.Value end
    function el:SetValue(value)
        el.Value = value
        el:UpdateVisual()
        el.Callback(value)
        if el.Flag then el.Section.Tab.Window.Flags[el.Flag] = value end
    end
    function el:UpdateVisual()
        local t = ThemeManager:GetTheme()
        if el.Value then
            el.Switch.BackgroundColor3 = t.Primary
            el.Knob.BackgroundColor3 = t.Text
            Services.TweenService:Create(el.Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -3, 0.5, 0)}):Play()
        else
            el.Switch.BackgroundColor3 = t.SurfaceVariant
            el.Knob.BackgroundColor3 = t.TextSecondary
            Services.TweenService:Create(el.Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
        end
    end
    return el
end

-- Slider
function Section:Slider(opts)
    opts = opts or {}
    local el = Element.new(self, "Slider", opts)
    el.Min = opts.Min or 0
    el.Max = opts.Max or 100
    el.Value = opts.Value or opts.Default or 50
    el.Step = opts.Step or 1
    el.Suffix = opts.Suffix or ""
    el.Decimals = opts.Decimals or 0
    local container = GlassEngine.Create(self.Content, {CornerRadius = UDim.new(0, 10), Transparency = 0.85})
    container.Name = "SliderContainer"
    container.Size = UDim2.new(1, 0, 0, 52)
    el.Container = container
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = container
    local title = Instance.new("TextLabel")
    title.Text = el.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 15
    title.TextColor3 = ThemeManager:GetTheme().Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -80, 0, 18)
    title.Parent = container
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = el.Value .. el.Suffix
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
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundColor3 = ThemeManager:GetTheme().Primary
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.BackgroundColor3 = ThemeManager:GetTheme().Text
    knob.BorderSizePixel = 0
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local knobStroke = Instance.new("UIStroke")
    knobStroke.Color = ThemeManager:GetTheme().Primary
    knobStroke.Thickness = 2
    knobStroke.Parent = knob
    el.Track = track
    el.Fill = fill
    el.Knob = knob
    el.ValueLabel = valueLabel
    el:UpdateVisual()
    el:AddLockedOverlay()
    local dragging = false
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not el.Locked then
            dragging = true
            el:UpdateFromMouse()
        end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            el:UpdateFromMouse()
        end
    end)
    ThemeManager:Subscribe(function(t)
        title.TextColor3 = t.Text
        valueLabel.TextColor3 = t.Primary
        track.BackgroundColor3 = t.SurfaceVariant
        fill.BackgroundColor3 = t.Primary
        knobStroke.Color = t.Primary
    end)
    if el.Flag then el.Section.Tab.Window.Flags[el.Flag] = el.Value end
    function el:UpdateFromMouse()
        local mousePos = Mouse.X
        local trackPos = el.Track.AbsolutePosition.X
        local trackSize = el.Track.AbsoluteSize.X
        local percent = MathUtil.Clamp((mousePos - trackPos) / trackSize, 0, 1)
        local value = el.Min + (el.Max - el.Min) * percent
        value = MathUtil.Round(value / el.Step) * el.Step
        value = MathUtil.Round(value, el.Decimals)
        el:SetValue(value)
    end
    function el:UpdateVisual()
        local percent = (el.Value - el.Min) / (el.Max - el.Min)
        el.Fill.Size = UDim2.new(percent, 0, 1, 0)
        el.Knob.Position = UDim2.new(percent, 0, 0.5, 0)
        el.ValueLabel.Text = el.Value .. el.Suffix
    end
    function el:SetValue(value)
        value = MathUtil.Clamp(value, el.Min, el.Max)
        value = MathUtil.Round(value / el.Step) * el.Step
        value = MathUtil.Round(value, el.Decimals)
        el.Value = value
        el:UpdateVisual()
        el.Callback(value)
        if el.Flag then el.Section.Tab.Window.Flags[el.Flag] = value end
    end
    return el
end

-- Dropdown
function Section:Dropdown(opts)
    opts = opts or {}
    local el = Element.new(self, "Dropdown", opts)
    el.Options = opts.Values or opts.Options or {}
    el.Value = opts.Value or nil
    el.Multi = opts.Multi or false
    el.Open = false
    local container = GlassEngine.Create(self.Content, {CornerRadius = UDim.new(0, 10), Transparency = 0.85})
    container.Name = "DropdownContainer"
    container.Size = UDim2.new(1, 0, 0, 44)
    container.ClipsDescendants = true
    el.Container = container
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = container
    local title = Instance.new("TextLabel")
    title.Text = el.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 14
    title.TextColor3 = ThemeManager:GetTheme().TextSecondary
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 16)
    title.Parent = container
    local selected = Instance.new("TextLabel")
    selected.Text = el.Value or "Select..."
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
    el.Selected = selected
    el.Arrow = arrow
    el.List = list
    el:BuildOptions()
    el:AddLockedOverlay()
    container.MouseButton1Click:Connect(function()
        if el.Locked then return end
        el:Toggle()
    end)
    ThemeManager:Subscribe(function(t)
        title.TextColor3 = t.TextSecondary
        selected.TextColor3 = t.Text
        arrow.ImageColor3 = t.TextSecondary
    end)
    if el.Flag then el.Section.Tab.Window.Flags[el.Flag] = el.Value end
    function el:BuildOptions()
        for _, opt in ipairs(el.Options) do
            local optData = type(opt) == "table" and opt or {Title = tostring(opt)}
            local optBtn = GlassEngine.CreateButton(list, {Size = UDim2.new(1, 0, 0, 32), CornerRadius = UDim.new(0, 6)})
            local optLayout = Instance.new("UIListLayout")
            optLayout.FillDirection = Enum.FillDirection.Horizontal
            optLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            optLayout.Padding = UDim.new(0, 8)
            optLayout.Parent = optBtn
            local optPadding = Instance.new("UIPadding")
            optPadding.PaddingLeft = UDim.new(0, 10)
            optPadding.Parent = optBtn
            if optData.Icon then
                local icon = Instance.new("ImageLabel")
                icon.Image = "rbxassetid://" .. optData.Icon
                icon.BackgroundTransparency = 1
                icon.Size = UDim2.new(0, 16, 0, 16)
                icon.ImageColor3 = ThemeManager:GetTheme().Text
                icon.Parent = optBtn
            end
            local optText = Instance.new("TextLabel")
            optText.Text = optData.Title or tostring(opt)
            optText.Font = Enum.Font.Gotham
            optText.TextSize = 14
            optText.TextColor3 = ThemeManager:GetTheme().Text
            optText.TextXAlignment = Enum.TextXAlignment.Left
            optText.BackgroundTransparency = 1
            optText.Size = UDim2.new(1, -20, 1, 0)
            optText.Parent = optBtn
            optBtn.MouseButton1Click:Connect(function()
                el:SetValue(optData.Title or opt)
                if not el.Multi then el:Toggle() end
            end)
            ThemeManager:Subscribe(function(t)
                optText.TextColor3 = t.Text
                if icon then icon.ImageColor3 = t.Text end
            end)
        end
    end
    function el:Toggle()
        el.Open = not el.Open
        el.List.Visible = el.Open
        Services.TweenService:Create(el.Arrow, TweenInfo.new(0.2), {Rotation = el.Open and 180 or 0}):Play()
        Services.TweenService:Create(el.Container, TweenInfo.new(0.25), {
            Size = UDim2.new(1, 0, 0, el.Open and math.min(44 + #el.Options * 36, 200) or 44)
        }):Play()
    end
    function el:SetValue(value)
        el.Value = value
        el.Selected.Text = tostring(value)
        el.Callback(value)
        if el.Flag then el.Section.Tab.Window.Flags[el.Flag] = value end
    end
    function el:Refresh(newOptions)
        el.Options = newOptions
        el.List:ClearAllChildren()
        local ll = Instance.new("UIListLayout")
        ll.Padding = UDim.new(0, 4)
        ll.Parent = el.List
        el:BuildOptions()
    end
    return el
end

-- Button
function Section:Button(opts)
    opts = opts or {}
    local el = Element.new(self, "Button", opts)
    el.Color = opts.Color or nil
    el.Justify = opts.Justify or "Left"
    local container = GlassEngine.CreateButton(self.Content, {Size = UDim2.new(1, 0, 0, 48), CornerRadius = UDim.new(0, 10)})
    container.Name = "ButtonContainer"
    el.Container = container
    if el.Color then container.BackgroundColor3 = el.Color end
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 12)
    layout.Parent = container
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = container
    if opts.Icon and opts.Icon ~= "" then
        local icon = Instance.new("ImageLabel")
        icon.Image = "rbxassetid://" .. opts.Icon
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.ImageColor3 = ThemeManager:GetTheme().Text
        icon.Parent = container
        el.IconLabel = icon
    end
    local textContainer = Instance.new("Frame")
    textContainer.BackgroundTransparency = 1
    textContainer.Size = UDim2.new(1, -40, 1, 0)
    textContainer.Parent = container
    local title = Instance.new("TextLabel")
    title.Text = el.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 15
    title.TextColor3 = ThemeManager:GetTheme().Text
    title.TextXAlignment = el.Justify == "Center" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 18)
    title.Parent = textContainer
    if el.Desc ~= "" then
        local desc = Instance.new("TextLabel")
        desc.Text = el.Desc
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 12
        desc.TextColor3 = ThemeManager:GetTheme().TextSecondary
        desc.TextXAlignment = el.Justify == "Center" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, 0, 0, 14)
        desc.Position = UDim2.new(0, 0, 1, -14)
        desc.Parent = textContainer
        textContainer.Size = UDim2.new(1, -40, 0, 36)
    end
    el:AddLockedOverlay()
    container.MouseButton1Click:Connect(function()
        if el.Locked then return end
        el.Callback()
    end)
    ThemeManager:Subscribe(function(t)
        title.TextColor3 = t.Text
        if el.Desc ~= "" then textContainer:GetChildren()[2].TextColor3 = t.TextSecondary end
        if el.IconLabel then el.IconLabel.ImageColor3 = t.Text end
    end)
    function el:Highlight()
        local highlight = Instance.new("Frame")
        highlight.BackgroundTransparency = 0.8
        highlight.BackgroundColor3 = ThemeManager:GetTheme().Primary
        highlight.BorderSizePixel = 0
        highlight.Size = UDim2.new(1, 0, 1, 0)
        highlight.Parent = container
        Instance.new("UICorner", highlight).CornerRadius = UDim.new(0, 10)
        Services.TweenService:Create(highlight, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.delay(0.3, function() highlight:Destroy() end)
    end
    return el
end

-- Input
function Section:Input(opts)
    opts = opts or {}
    local el = Element.new(self, "Input", opts)
    el.Placeholder = opts.Placeholder or ""
    el.Value = opts.Value or ""
    el.Numeric = opts.Numeric or false
    el.Type = opts.Type or "Input"
    local container = GlassEngine.Create(self.Content, {CornerRadius = UDim.new(0, 10), Transparency = 0.85})
    container.Name = "InputContainer"
    container.Size = UDim2.new(1, 0, 0, el.Type == "Textarea" and 72 or 52)
    el.Container = container
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = container
    local title = Instance.new("TextLabel")
    title.Text = el.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 14
    title.TextColor3 = ThemeManager:GetTheme().TextSecondary
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 16)
    title.Parent = container
    local textBox = Instance.new("TextBox")
    textBox.Text = el.Value
    textBox.PlaceholderText = el.Placeholder
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 15
    textBox.TextColor3 = ThemeManager:GetTheme().Text
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.TextYAlignment = el.Type == "Textarea" and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
    textBox.BackgroundTransparency = 1
    textBox.Size = UDim2.new(1, 0, 0, el.Type == "Textarea" and 40 or 20)
    textBox.Position = UDim2.new(0, 0, 1, el.Type == "Textarea" and -40 or -20)
    textBox.AnchorPoint = Vector2.new(0, 1)
    textBox.ClearTextOnFocus = false
    textBox.MultiLine = el.Type == "Textarea"
    textBox.TextWrapped = el.Type == "Textarea"
    textBox.Parent = container
    el.TextBox = textBox
    el:AddLockedOverlay()
    textBox.FocusLost:Connect(function()
        if el.Locked then return end
        local value = textBox.Text
        if el.Numeric then value = tonumber(value) or 0 end
        el.Value = value
        el.Callback(value)
        if el.Flag then el.Section.Tab.Window.Flags[el.Flag] = value end
    end)
    ThemeManager:Subscribe(function(t)
        title.TextColor3 = t.TextSecondary
        textBox.TextColor3 = t.Text
        textBox.PlaceholderColor3 = t.TextSecondary
    end)
    function el:SetValue(value)
        el.Value = value
        textBox.Text = tostring(value)
        el.Callback(value)
        if el.Flag then el.Section.Tab.Window.Flags[el.Flag] = value end
    end
    return el
end

-- Colorpicker
function Section:Colorpicker(opts)
    opts = opts or {}
    local el = Element.new(self, "Colorpicker", opts)
    el.Value = opts.Default or opts.Value or Color3.fromRGB(255, 255, 255)
    el.Transparency = opts.Transparency or 0
    el.Open = false
    local container = GlassEngine.CreateButton(self.Content, {Size = UDim2.new(1, 0, 0, 48), CornerRadius = UDim.new(0, 10)})
    container.Name = "ColorPickerContainer"
    el.Container = container
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
    title.Text = el.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 15
    title.TextColor3 = ThemeManager:GetTheme().Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Parent = container
    local preview = Instance.new("Frame")
    preview.Name = "Preview"
    preview.BackgroundColor3 = el.Value
    preview.BorderSizePixel = 0
    preview.Size = UDim2.new(0, 28, 0, 28)
    preview.Parent = container
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 6)
    local previewStroke = Instance.new("UIStroke")
    previewStroke.Color = ThemeManager:GetTheme().Border
    previewStroke.Thickness = 1.5
    previewStroke.Parent = preview
    el.Preview = preview
    el:AddLockedOverlay()
    container.MouseButton1Click:Connect(function()
        if el.Locked then return end
        el:TogglePicker()
    end)
    ThemeManager:Subscribe(function(t)
        title.TextColor3 = t.Text
        previewStroke.Color = t.Border
    end)
    function el:TogglePicker()
        el.Open = not el.Open
        -- Simplified color picker toggle
    end
    function el:SetValue(color)
        el.Value = color
        el.Preview.BackgroundColor3 = color
        el.Callback(color)
        if el.Flag then el.Section.Tab.Window.Flags[el.Flag] = color end
    end
    return el
end

-- Keybind
function Section:Keybind(opts)
    opts = opts or {}
    local el = Element.new(self, "Keybind", opts)
    el.Value = opts.Value or "None"
    el.Mode = opts.Mode or "Toggle"
    el.Capturing = false
    local container = GlassEngine.CreateButton(self.Content, {Size = UDim2.new(1, 0, 0, 48), CornerRadius = UDim.new(0, 10)})
    container.Name = "KeybindContainer"
    el.Container = container
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
    title.Text = el.Title
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 15
    title.TextColor3 = ThemeManager:GetTheme().Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Parent = container
    local keyDisplay = GlassEngine.Create(container, {CornerRadius = UDim.new(0, 6), Transparency = 0.7})
    keyDisplay.Name = "KeyDisplay"
    keyDisplay.Size = UDim2.new(0, 60, 0, 28)
    keyDisplay.BackgroundColor3 = ThemeManager:GetTheme().SurfaceVariant
    local keyText = Instance.new("TextLabel")
    keyText.Text = el.Value
    keyText.Font = Enum.Font.GothamBold
    keyText.TextSize = 13
    keyText.TextColor3 = ThemeManager:GetTheme().Primary
    keyText.BackgroundTransparency = 1
    keyText.Size = UDim2.new(1, 0, 1, 0)
    keyText.Parent = keyDisplay
    el.KeyDisplay = keyDisplay
    el.KeyText = keyText
    el:AddLockedOverlay()
    container.MouseButton1Click:Connect(function()
        if el.Locked then return end
        el:StartCapture()
    end)
    ThemeManager:Subscribe(function(t)
        title.TextColor3 = t.Text
        keyDisplay.BackgroundColor3 = t.SurfaceVariant
        keyText.TextColor3 = t.Primary
    end)
    function el:StartCapture()
        el.Capturing = true
        el.KeyText.Text = "..."
        el.KeyText.TextColor3 = ThemeManager:GetTheme().Warning
        local conn
        conn = Services.UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            local key
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                key = input.KeyCode.Name
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                key = "MB1"
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                key = "MB2"
            end
            if key then
                if key == "Escape" then key = "None" end
                el:SetValue(key)
                el.Capturing = false
                conn:Disconnect()
            end
        end)
    end
    function el:SetValue(key)
        el.Value = key
        el.KeyText.Text = key
        el.KeyText.TextColor3 = ThemeManager:GetTheme().Primary
        el.Callback(key)
        if el.Flag then el.Section.Tab.Window.Flags[el.Flag] = key end
    end
    return el
end

-- Paragraph
function Section:Paragraph(opts)
    opts = opts or {}
    local el = Element.new(self, "Paragraph", opts)
    local container = GlassEngine.Create(self.Content, {CornerRadius = UDim.new(0, 10), Transparency = 0.85})
    container.Name = "ParagraphContainer"
    container.Size = UDim2.new(1, 0, 0, 0)
    el.Container = container
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = container
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container
    if opts.Image then
        local img = Instance.new("ImageLabel")
        img.Image = opts.Image
        img.BackgroundTransparency = 1
        img.Size = UDim2.new(1, 0, 0, opts.ImageSize or 120)
        img.ScaleType = Enum.ScaleType.Fit
        img.Parent = container
    end
    if opts.Title then
        local title = Instance.new("TextLabel")
        title.Text = opts.Title
        title.Font = Enum.Font.GothamBold
        title.TextSize = 16
        title.TextColor3 = ThemeManager:GetTheme().Text
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextWrapped = true
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, 0, 0, 20)
        title.Parent = container
    end
    if opts.Desc then
        local desc = Instance.new("TextLabel")
        desc.Text = opts.Desc
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 14
        desc.TextColor3 = ThemeManager:GetTheme().TextSecondary
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextWrapped = true
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, 0, 0, 0)
        desc.Parent = container
        local bounds = Services.TextService:GetTextSize(opts.Desc, 14, Enum.Font.Gotham, Vector2.new(container.AbsoluteSize.X - 28, math.huge))
        desc.Size = UDim2.new(1, 0, 0, bounds.Y)
    end
    if opts.Buttons and #opts.Buttons > 0 then
        local btnContainer = Instance.new("Frame")
        btnContainer.BackgroundTransparency = 1
        btnContainer.Size = UDim2.new(1, 0, 0, 36)
        btnContainer.Parent = container
        local btnLayout = Instance.new("UIListLayout")
        btnLayout.FillDirection = Enum.FillDirection.Horizontal
        btnLayout.Padding = UDim.new(0, 8)
        btnLayout.Parent = btnContainer
        for _, btnData in ipairs(opts.Buttons) do
            local btn = GlassEngine.CreateButton(btnContainer, {Size = UDim2.new(0, 100, 0, 32), CornerRadius = UDim.new(0, 8)})
            local btnText = Instance.new("TextLabel")
            btnText.Text = btnData.Title or ""
            btnText.Font = Enum.Font.GothamMedium
            btnText.TextSize = 13
            btnText.TextColor3 = ThemeManager:GetTheme().Text
            btnText.BackgroundTransparency = 1
            btnText.Size = UDim2.new(1, 0, 1, 0)
            btnText.Parent = btn
            if btnData.Icon then
                local icon = Instance.new("ImageLabel")
                icon.Image = "rbxassetid://" .. btnData.Icon
                icon.BackgroundTransparency = 1
                icon.Size = UDim2.new(0, 14, 0, 14)
                icon.Position = UDim2.new(0, 8, 0.5, 0)
                icon.AnchorPoint = Vector2.new(0, 0.5)
                icon.ImageColor3 = ThemeManager:GetTheme().Text
                icon.Parent = btn
                btnText.Position = UDim2.new(0, 26, 0, 0)
                btnText.Size = UDim2.new(1, -30, 1, 0)
            end
            btn.MouseButton1Click:Connect(function()
                if btnData.Callback then btnData.Callback() end
            end)
        end
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 24)
    end)
    ThemeManager:Subscribe(function(t)
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("TextLabel") then
                if child.Font == Enum.Font.GothamBold then
                    child.TextColor3 = t.Text
                else
                    child.TextColor3 = t.TextSecondary
                end
            end
        end
    end)
    return el
end

-- Image
function Section:Image(opts)
    opts = opts or {}
    local el = Element.new(self, "Image", opts)
    local container = Instance.new("Frame")
    container.Name = "ImageContainer"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, opts.Size or 150)
    container.Parent = self.Content
    el.Container = container
    local img = Instance.new("ImageLabel")
    img.Image = opts.Image or ""
    img.BackgroundTransparency = 1
    img.Size = UDim2.new(1, 0, 1, 0)
    img.ScaleType = opts.ScaleType or Enum.ScaleType.Fit
    img.Parent = container
    local corner = Instance.new("UICorner")
    corner.CornerRadius = opts.CornerRadius or UDim.new(0, 8)
    corner.Parent = img
    return el
end

-- Label
function Section:Label(opts)
    opts = opts or {}
    local el = Element.new(self, "Label", opts)
    local container = Instance.new("Frame")
    container.Name = "LabelContainer"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 0)
    container.Parent = self.Content
    el.Container = container
    local title = Instance.new("TextLabel")
    title.Text = opts.Title or opts.Text or ""
    title.Font = Enum.Font.GothamMedium
    title.TextSize = opts.TextSize or 15
    title.TextColor3 = ThemeManager:GetTheme().Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextWrapped = true
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Parent = container
    if opts.Desc then
        local desc = Instance.new("TextLabel")
        desc.Text = opts.Desc
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
    ThemeManager:Subscribe(function(t)
        title.TextColor3 = t.Text
    end)
    return el
end

-- ============================================================================
-- SECTION 10: NOTIFICATION SYSTEM
-- ============================================================================

local NotificationManager = {Queue = {}, MaxNotifications = 5, Container = nil}
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
function NotificationManager:Notify(opts)
    if not self.Container then self:Initialize() end
    opts = opts or {}
    local title = opts.Title or "Notification"
    local content = opts.Desc or opts.Content or ""
    local duration = opts.Duration or 5
    local type = opts.Type or "info"
    local notification = GlassEngine.Create(self.Container, {CornerRadius = UDim.new(0, 10), Transparency = 0.85})
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
        local bounds = Services.TextService:GetTextSize(content, 13, Enum.Font.Gotham, Vector2.new(280, math.huge))
        contentText.Size = UDim2.new(1, 0, 0, bounds.Y)
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        notification.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 24)
    end)
    local theme = ThemeManager:GetTheme()
    local color = theme.Primary
    if type == "success" then color = theme.Success
    elseif type == "error" then color = theme.Error
    elseif type == "warning" then color = theme.Warning end
    local indicator = Instance.new("Frame")
    indicator.BackgroundColor3 = color
    indicator.BorderSizePixel = 0
    indicator.Size = UDim2.new(0, 4, 1, 0)
    indicator.Position = UDim2.new(0, 0, 0, 0)
    indicator.Parent = notification
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    Services.TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(duration, function()
        Services.TweenService:Create(notification, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 0, 0), Transparency = 1}):Play()
        task.delay(0.3, function() notification:Destroy() end)
    end)
end
NotificationManager:Initialize()

-- ============================================================================
-- SECTION 11: MAIN LIBRARY
-- ============================================================================

local AetherUI = {Version = "2.0.0", Windows = {}, Flags = {}}
function AetherUI:CreateWindow(opts)
    local window = Window.new(opts)
    table.insert(self.Windows, window)
    return window
end
function AetherUI:Notify(opts) NotificationManager:Notify(opts) end
function AetherUI:SetTheme(name) ThemeManager:SetTheme(name) end
function AetherUI:AddTheme(name, data) ThemeManager:AddTheme(name, data) end
function AetherUI:GetTheme() return ThemeManager.CurrentTheme end
function AetherUI:GetFlag(flag) return self.Flags[flag] end
function AetherUI:SetFlag(flag, value) self.Flags[flag] = value end
function AetherUI:DestroyAll()
    for _, w in ipairs(self.Windows) do w:Destroy() end
    self.Windows = {}
end

print("╔═══════════════════════════════════════════════════════════════════")
print("║  AetherUI v2.0.0 - WindUI Inspired Upgrade")
print("║  Developer: Delta | Lines: 2000+ | Date: May 12, 2026")
print("╠═══════════════════════════════════════════════════════════════════")
print("║  ✨ New: Tags, OpenButton, Author, Paragraph, Image, Locked")
print("║  ✨ New: Textarea, Button Highlight/Justify, Dropdown Icons")
print("║  ✨ New: Full Config Manager, Search Bar Toggle, AddTheme")
print("║  💎 Retained: Glassmorphism, Ripple, 8 Themes, Animations")
print("╚═══════════════════════════════════════════════════════════════════")

return AetherUI
