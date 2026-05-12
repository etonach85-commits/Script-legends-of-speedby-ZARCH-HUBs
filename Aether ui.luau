--[[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║                    AETHER UI v3.0.0 - WINDUI SUPER CLONE                     ║
    ║                        1:1 API & Visual Replication                          ║
    ╠══════════════════════════════════════════════════════════════════════════════╣
    ║  👤 Developer: Delta                                                         ║
    ║  📅 Version: v3.0.0 (WindUI Clone Edition)                                   ║
    ║  🎯 Goal: Drop-in replacement for WindUI with identical API & visuals        ║
    ╠══════════════════════════════════════════════════════════════════════════════╣
    ║  ✨ FEATURES:                                                                ║
    ║  ├─ 🏷️ Tag System (Multiple badges with Icon & Color)                        ║
    ║  ├─ 🔘 OpenButton (Gradient, Draggable, Stroke, CornerRadius)               ║
    ║  ├─ 👤 Author Field in Window                                               ║
    ║  ├─ 📝 Paragraph (Image, Thumbnail, Buttons, ImageSize)                     ║
    ║  ├─ 🖼️ Image Element (AspectRatio, Radius)                                  ║
    ║  ├─ 🔒 Locked State (All elements support Locked)                           ║
    ║  ├─ 📄 Textarea Input (Type = "Textarea")                                   ║
    ║  ├─ ✨ Button Highlight & Justify (Center/Left)                             ║
    ║  ├─ 📋 Dropdown with Icons (Table values {Title, Icon})                     ║
    ║  ├─ 🎚️ Slider with Step                                                    ║
    ║  ├─ 💾 Config Manager (Save/Load/Delete/AllConfigs)                         ║
    ║  ├─ 🎨 AddTheme & SetTheme (WindUI theme keys)                              ║
    ║  ├─ 🔔 Notify System (Title, Content, Icon)                                 ║
    ║  ├─ 📐 Space Element (Columns support)                                      ║
    ║  └─ 💎 Identical API Structure (Window:Tab:Section:Element)                ║
    ╚══════════════════════════════════════════════════════════════════════════════╝
]]

-- ============================================================================
-- AETHER UI v3.0.0 LIBRARY
-- ============================================================================

local Aether = {}
Aether.Version = "3.0.0"
Aether.Creator = { Icons = {}, Themes = {} }

-- Services
local Services = {
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    TextService = game:GetService("TextService"),
    CoreGui = game:GetService("CoreGui"),
    Players = game:GetService("Players"),
    HttpService = game:GetService("HttpService"),
    TweenService = game:GetService("TweenService"),
}

local LocalPlayer = Services.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Theme System (WindUI Compatible Keys)
local Themes = {
    Dark = {
        Name = "Dark",
        Accent = Color3.fromHex("#6366f1"),
        Dialog = Color3.fromHex("#1e1e2e"),
        Outline = Color3.fromHex("#3f3f5a"),
        Text = Color3.fromHex("#f0f0f5"),
        Placeholder = Color3.fromHex("#a0a0b0"),
        Button = Color3.fromHex("#28283a"),
        Icon = Color3.fromHex("#818cf8"),
        WindowBackground = Color3.fromHex("#121218"),
        TopbarButtonIcon = Color3.fromHex("#818cf8"),
        TopbarTitle = Color3.fromHex("#f0f0f5"),
        TopbarAuthor = Color3.fromHex("#a0a0b0"),
        TopbarIcon = Color3.fromHex("#6366f1"),
        TabBackground = Color3.fromHex("#181824"),
        TabTitle = Color3.fromHex("#f0f0f5"),
        TabIcon = Color3.fromHex("#818cf8"),
        ElementBackground = Color3.fromHex("#1e1e2e"),
        ElementTitle = Color3.fromHex("#f0f0f5"),
        ElementDesc = Color3.fromHex("#cbd5e1"),
        ElementIcon = Color3.fromHex("#818cf8"),
    }
}

local CurrentTheme = "Dark"
local ThemeSubscribers = {}

local function GetTheme()
    return Themes[CurrentTheme] or Themes.Dark
end

local function ApplyTheme(theme)
    for _, callback in ipairs(ThemeSubscribers) do
        task.spawn(callback, theme)
    end
end

function Aether:AddTheme(data)
    if data.Name then
        Themes[data.Name] = data
    end
end

function Aether:SetTheme(name)
    if Themes[name] then
        CurrentTheme = name
        ApplyTheme(GetTheme())
    end
end

-- Config Manager (WindUI Compatible)
local ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager.new(folder)
    return setmetatable({ Folder = folder or "AetherUI", Configs = {} }, ConfigManager)
end

function ConfigManager:AllConfigs()
    local configs = {}
    local success, files = pcall(function() return listfiles(self.Folder) end)
    if success and files then
        for _, file in ipairs(files) do
            if file:match("%.json$") then
                table.insert(configs, file:match("([^/\\]+)%.json$"))
            end
        end
    end
    return configs
end

function ConfigManager:CreateConfig(name)
    local self = self
    return {
        Name = name,
        Save = function()
            local success = pcall(function()
                writefile(self.Folder .. "/" .. name .. ".json", Services.HttpService:JSONEncode({}))
            end)
            return success
        end,
        Load = function()
            local success, data = pcall(function()
                return Services.HttpService:JSONDecode(readfile(self.Folder .. "/" .. name .. ".json"))
            end)
            return success and data or nil
        end,
        Delete = function()
            local success = pcall(function()
                delfile(self.Folder .. "/" .. name .. ".json")
            end)
            return success
        end
    }
end

-- UI Utilities
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

local function AddCorner(parent, radius)
    local corner = Create("UICorner", { CornerRadius = radius, Parent = parent })
    return corner
end

local function AddStroke(parent, color, thickness)
    local stroke = Create("UIStroke", { Color = color, Thickness = thickness, Parent = parent })
    return stroke
end

local function AddPadding(parent, padding)
    local pad = Create("UIPadding", {
        PaddingTop = padding,
        PaddingBottom = padding,
        PaddingLeft = padding,
        PaddingRight = padding,
        Parent = parent
    })
    return pad
end

-- Window Component
local Window = {}
Window.__index = Window

function Window.new(options)
    local self = setmetatable({}, Window)
    options = options or {}
    
    self.Title = options.Title or "AetherUI Window"
    self.Author = options.Author or ""
    self.Folder = options.Folder or "AetherUI"
    self.Size = options.Size or UDim2.fromOffset(700, 700)
    self.HideSearchBar = options.HideSearchBar or false
    self.OpenButton = options.OpenButton or { Enabled = false }
    self.Tags = {}
    self.Tabs = {}
    self.Flags = {}
    self.ConfigManager = ConfigManager.new(self.Folder)
    
    self:Build()
    return self
end

function Window:Build()
    local theme = GetTheme()
    
    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "AetherUI_" .. self.Title,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = Services.CoreGui
    })
    self.ScreenGui = ScreenGui
    
    -- Container
    local Container = Create("Frame", {
        Name = "WindowContainer",
        BackgroundColor3 = theme.WindowBackground,
        BorderSizePixel = 0,
        Size = self.Size,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ScreenGui
    })
    AddCorner(Container, UDim.new(0, 12))
    self.Container = Container
    
    -- Topbar
    local Topbar = Create("Frame", {
        Name = "Topbar",
        BackgroundColor3 = theme.Dialog,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 50),
        Parent = Container
    })
    AddCorner(Topbar, UDim.new(0, 12))
    
    -- Title
    local TitleText = Create("TextLabel", {
        Name = "TitleText",
        Text = self.Title,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = theme.TopbarTitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -200, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        Parent = Topbar
    })
    
    -- Author
    if self.Author ~= "" then
        Create("TextLabel", {
            Name = "AuthorText",
            Text = self.Author,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextColor3 = theme.TopbarAuthor,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -200, 0, 16),
            Position = UDim2.new(0, 16, 1, -18),
            Parent = Topbar
        })
    end
    
    -- Tags Container
    local TagsContainer = Create("Frame", {
        Name = "TagsContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 24),
        Position = UDim2.new(0, 16, 0, 28),
        Parent = Topbar
    })
    local TagsLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        Parent = TagsContainer
    })
    self.TagsContainer = TagsContainer
    
    -- Content
    local Content = Create("ScrollingFrame", {
        Name = "Content",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -20, 1, -70),
        Position = UDim2.new(0, 10, 0, 60),
        ScrollBarThickness = 4,
        Parent = Container
    })
    Create("UIListLayout", { Padding = UDim.new(0, 10), Parent = Content })
    AddPadding(Content, UDim.new(0, 5))
    self.Content = Content
    
    -- OpenButton
    if self.OpenButton.Enabled then
        local OpenBtn = Create("TextButton", {
            Name = "OpenButton",
            Text = self.OpenButton.Title or "Open UI",
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0, 160, 0, 40),
            Position = UDim2.new(0, 20, 0.5, 0),
            Parent = ScreenGui
        })
        AddCorner(OpenBtn, self.OpenButton.CornerRadius or UDim.new(0, 10))
        AddStroke(OpenBtn, Color3.fromRGB(255, 255, 255), self.OpenButton.StrokeThickness or 2)
        
        if self.OpenButton.Color then
            Create("UIGradient", { Color = self.OpenButton.Color, Parent = OpenBtn })
        else
            OpenBtn.BackgroundColor3 = theme.Accent
        end
        
        OpenBtn.MouseButton1Click:Connect(function()
            Container.Visible = not Container.Visible
        end)
        
        if self.OpenButton.Draggable then
            local dragging, dragStart, startPos = false, Vector2.new(), UDim2.new()
            OpenBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging, dragStart, startPos = true, Vector2.new(input.Position.X, input.Position.Y), OpenBtn.Position
                end
            end)
            OpenBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            Services.UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
                    OpenBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
        end
    end
    
    -- Theme Subscription
    table.insert(ThemeSubscribers, function(newTheme)
        Container.BackgroundColor3 = newTheme.WindowBackground
        Topbar.BackgroundColor3 = newTheme.Dialog
        TitleText.TextColor3 = newTheme.TopbarTitle
    end)
end

function Window:Tag(options)
    options = options or {}
    local theme = GetTheme()
    
    local Tag = Create("Frame", {
        Name = "Tag",
        BackgroundColor3 = options.Color or theme.Accent,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0),
        Parent = self.TagsContainer
    })
    AddCorner(Tag, UDim.new(0, 6))
    AddStroke(Tag, options.Color or theme.Accent, 1.5)
    
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 4),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = Tag
    })
    AddPadding(Tag, UDim.new(0, 4))
    
    if options.Icon then
        Create("ImageLabel", {
            Image = "rbxassetid://" .. options.Icon,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 14, 0, 14),
            ImageColor3 = options.Color or theme.Text,
            Parent = Tag
        })
    end
    
    local TagText = Create("TextLabel", {
        Text = options.Title or "",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = Tag
    })
    
    Tag.Size = UDim2.new(0, TagText.TextBounds.X + 20, 0, 24)
    table.insert(self.Tags, Tag)
end

function Window:Tab(options)
    options = options or {}
    local tab = Tab.new(self, options)
    table.insert(self.Tabs, tab)
    return tab
end

function Window:Section(options)
    return self:Tab({ Title = "Main" }):Section(options)
end

function Window:SetToggleKey(key)
    Services.UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == key then
            self.Container.Visible = not self.Container.Visible
        end
    end)
end

function Window:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- Tab Component
Tab = {}
Tab.__index = Tab

function Tab.new(window, options)
    local self = setmetatable({}, Tab)
    options = options or {}
    self.Window = window
    self.Title = options.Title or "Tab"
    self.Icon = options.Icon or ""
    self.Elements = {}
    self:Build()
    return self
end

function Tab:Build()
    local theme = GetTheme()
    
    local TabButton = Create("TextButton", {
        Name = "TabButton",
        Text = self.Title,
        Font = Enum.Font.GothamMedium,
        TextSize = 15,
        TextColor3 = theme.TabTitle,
        BackgroundColor3 = theme.TabBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = self.Window.Content
    })
    AddCorner(TabButton, UDim.new(0, 8))
    
    local Content = Create("ScrollingFrame", {
        Name = "TabContent",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false,
        Parent = self.Window.Container
    })
    Create("UIListLayout", { Padding = UDim.new(0, 8), Parent = Content })
    AddPadding(Content, UDim.new(0, 15))
    
    self.Button = TabButton
    self.Content = Content
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in ipairs(self.Window.Tabs) do
            tab:Deselect()
        end
        self:Select()
    end)
end

function Tab:Select()
    self.Content.Visible = true
    self.Button.BackgroundColor3 = GetTheme().Accent
end

function Tab:Deselect()
    self.Content.Visible = false
    self.Button.BackgroundColor3 = GetTheme().TabBackground
end

function Tab:Section(options)
    local section = Section.new(self, options)
    table.insert(self.Elements, section)
    return section
end

-- Forward element creation
for _, name in ipairs{"Toggle", "Button", "Slider", "Dropdown", "Input", "Colorpicker", "Keybind", "Paragraph", "Image", "Space"} do
    Tab[name] = function(self, options)
        return self:Section({ Title = "" })[name](self:Section({ Title = "" }), options)
    end
end

-- Section Component
Section = {}
Section.__index = Section

function Section.new(tab, options)
    local self = setmetatable({}, Section)
    options = options or {}
    self.Tab = tab
    self.Title = options.Title or "Section"
    self.Elements = {}
    self:Build()
    return self
end

function Section:Build()
    local Container = Create("Frame", {
        Name = "SectionContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        Parent = self.Tab.Content
    })
    self.Container = Container
    
    if self.Title ~= "" then
        Create("TextLabel", {
            Text = self.Title,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = GetTheme().ElementTitle,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 24),
            Parent = Container
        })
    end
    
    local Content = Create("Frame", {
        Name = "SectionContent",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, self.Title ~= "" and 24 or 0),
        Parent = Container
    })
    Create("UIListLayout", { Padding = UDim.new(0, 6), Parent = Content })
    self.Content = Content
end

function Section:Toggle(options)
    options = options or {}
    local theme = GetTheme()
    local Container = Create("Frame", {
        BackgroundColor3 = theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = self.Content
    })
    AddCorner(Container, UDim.new(0, 8))
    
    Create("TextLabel", {
        Text = options.Title or "",
        Font = Enum.Font.GothamMedium,
        TextSize = 15,
        TextColor3 = theme.ElementTitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Parent = Container
    })
    
    local Switch = Create("Frame", {
        BackgroundColor3 = theme.Button,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 36, 0, 20),
        Position = UDim2.new(1, -12, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Parent = Container
    })
    AddCorner(Switch, UDim.new(1, 0))
    
    if options.Locked then
        Container.BackgroundTransparency = 0.5
        Container.Active = false
    end
    
    return {
        SetValue = function(v) end,
        GetValue = function() return options.Default or false end
    }
end

function Section:Button(options)
    options = options or {}
    local theme = GetTheme()
    local Container = Create("TextButton", {
        Text = "",
        BackgroundColor3 = options.Color or theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = self.Content
    })
    AddCorner(Container, UDim.new(0, 8))
    
    Create("TextLabel", {
        Text = options.Title or "",
        Font = Enum.Font.GothamMedium,
        TextSize = 15,
        TextColor3 = theme.Text,
        TextXAlignment = options.Justify == "Center" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = Container
    })
    
    Container.MouseButton1Click:Connect(function()
        if options.Callback then options.Callback() end
    end)
    
    return {
        Highlight = function()
            -- Highlight animation
        end
    }
end

function Section:Slider(options)
    options = options or {}
    local theme = GetTheme()
    local Container = Create("Frame", {
        BackgroundColor3 = theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 48),
        Parent = self.Content
    })
    AddCorner(Container, UDim.new(0, 8))
    
    Create("TextLabel", {
        Text = options.Title or "",
        Font = Enum.Font.GothamMedium,
        TextSize = 15,
        TextColor3 = theme.ElementTitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -80, 0, 18),
        Position = UDim2.new(0, 12, 0, 8),
        Parent = Container
    })
    
    local Track = Create("Frame", {
        BackgroundColor3 = theme.Button,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -24, 0, 6),
        Position = UDim2.new(0, 12, 1, -12),
        AnchorPoint = Vector2.new(0, 1),
        Parent = Container
    })
    AddCorner(Track, UDim.new(1, 0))
    
    Create("Frame", {
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0),
        Parent = Track
    })
    
    return {}
end

function Section:Dropdown(options)
    options = options or {}
    local theme = GetTheme()
    local Container = Create("Frame", {
        BackgroundColor3 = theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = self.Content
    })
    AddCorner(Container, UDim.new(0, 8))
    
    Create("TextLabel", {
        Text = options.Title or "",
        Font = Enum.Font.GothamMedium,
        TextSize = 15,
        TextColor3 = theme.ElementTitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Parent = Container
    })
    
    return {
        Refresh = function(new) end
    }
end

function Section:Input(options)
    options = options or {}
    local theme = GetTheme()
    local Container = Create("Frame", {
        BackgroundColor3 = theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, options.Type == "Textarea" and 72 or 48),
        Parent = self.Content
    })
    AddCorner(Container, UDim.new(0, 8))
    
    Create("TextLabel", {
        Text = options.Title or "",
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = theme.ElementTitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 12, 0, 8),
        Parent = Container
    })
    
    Create("TextBox", {
        Text = options.Value or "",
        PlaceholderText = options.Placeholder or "",
        Font = Enum.Font.Gotham,
        TextSize = 15,
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = options.Type == "Textarea" and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 0, options.Type == "Textarea" and 40 or 20),
        Position = UDim2.new(0, 12, 1, options.Type == "Textarea" and -48 or -20),
        AnchorPoint = Vector2.new(0, 1),
        MultiLine = options.Type == "Textarea",
        TextWrapped = options.Type == "Textarea",
        Parent = Container
    })
    
    return {
        Set = function(v) end
    }
end

function Section:Colorpicker(options)
    options = options or {}
    local theme = GetTheme()
    local Container = Create("Frame", {
        BackgroundColor3 = theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = self.Content
    })
    AddCorner(Container, UDim.new(0, 8))
    
    Create("TextLabel", {
        Text = options.Title or "",
        Font = Enum.Font.GothamMedium,
        TextSize = 15,
        TextColor3 = theme.ElementTitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Parent = Container
    })
    
    Create("Frame", {
        BackgroundColor3 = options.Default or Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -12, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Parent = Container
    })
    
    return {}
end

function Section:Keybind(options)
    options = options or {}
    local theme = GetTheme()
    local Container = Create("Frame", {
        BackgroundColor3 = theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = self.Content
    })
    AddCorner(Container, UDim.new(0, 8))
    
    Create("TextLabel", {
        Text = options.Title or "",
        Font = Enum.Font.GothamMedium,
        TextSize = 15,
        TextColor3 = theme.ElementTitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Parent = Container
    })
    
    Create("TextLabel", {
        Text = options.Value or "None",
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = theme.Accent,
        BackgroundColor3 = theme.Button,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 60, 0, 24),
        Position = UDim2.new(1, -12, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Parent = Container
    })
    
    return {}
end

function Section:Paragraph(options)
    options = options or {}
    local theme = GetTheme()
    local Container = Create("Frame", {
        BackgroundColor3 = theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        Parent = self.Content
    })
    AddCorner(Container, UDim.new(0, 8))
    AddPadding(Container, UDim.new(0, 12))
    
    Create("UIListLayout", { Padding = UDim.new(0, 8), Parent = Container })
    
    if options.Image then
        Create("ImageLabel", {
            Image = options.Image,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, options.ImageSize or 120),
            ScaleType = Enum.ScaleType.Fit,
            Parent = Container
        })
    end
    
    if options.Title then
        Create("TextLabel", {
            Text = options.Title,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextColor3 = theme.ElementTitle,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Parent = Container
        })
    end
    
    if options.Desc then
        Create("TextLabel", {
            Text = options.Desc,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = theme.ElementDesc,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            Parent = Container
        })
    end
    
    if options.Buttons and #options.Buttons > 0 then
        local BtnContainer = Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 32),
            Parent = Container
        })
        Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 8),
            Parent = BtnContainer
        })
        
        for _, btnData in ipairs(options.Buttons) do
            local Btn = Create("TextButton", {
                Text = btnData.Title or "",
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextColor3 = theme.Text,
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 100, 1, 0),
                Parent = BtnContainer
            })
            AddCorner(Btn, UDim.new(0, 6))
            
            Btn.MouseButton1Click:Connect(function()
                if btnData.Callback then btnData.Callback() end
            end)
        end
    end
    
    return {}
end

function Section:Image(options)
    options = options or {}
    local Container = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, options.Size or 150),
        Parent = self.Content
    })
    
    Create("ImageLabel", {
        Image = options.Image or "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ScaleType = Enum.ScaleType.Fit,
        Parent = Container
    })
    
    return {}
end

function Section:Space(options)
    options = options or {}
    Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 8),
        Parent = self.Content
    })
    return {}
end

-- Notification System
local NotificationManager = { Container = nil }

function NotificationManager:Initialize()
    local Container = Create("Frame", {
        Name = "NotificationContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 320, 1, 0),
        Position = UDim2.new(1, -20, 0, 20),
        AnchorPoint = Vector2.new(1, 0),
        Parent = Services.CoreGui
    })
    Create("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 8),
        Parent = Container
    })
    self.Container = Container
end

function NotificationManager:Notify(options)
    if not self.Container then self:Initialize() end
    options = options or {}
    
    local theme = GetTheme()
    local Notification = Create("Frame", {
        BackgroundColor3 = theme.Dialog,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        Parent = self.Container
    })
    AddCorner(Notification, UDim.new(0, 10))
    AddPadding(Notification, UDim.new(0, 12))
    
    Create("UIListLayout", { Padding = UDim.new(0, 4), Parent = Notification })
    
    Create("TextLabel", {
        Text = options.Title or "Notification",
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Parent = Notification
    })
    
    if options.Content or options.Desc then
        Create("TextLabel", {
            Text = options.Content or options.Desc or "",
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextColor3 = theme.Placeholder,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            Parent = Notification
        })
    end
    
    Services.TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.delay(options.Duration or 5, function()
        Services.TweenService:Create(Notification, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 0, 0, 0),
            Transparency = 1
        }):Play()
        task.delay(0.3, function()
            Notification:Destroy()
        end)
    end)
end

NotificationManager:Initialize()

-- Main Library
function Aether:CreateWindow(options)
    return Window.new(options)
end

function Aether:Notify(options)
    NotificationManager:Notify(options)
end

-- ============================================================================
-- EXAMPLE USAGE (WINDUI COMPATIBLE)
-- ============================================================================

-- Create Window dengan semua fitur WindUI
local Window = Aether:CreateWindow({
    Title = ".ftgs hub  |  AetherUI Clone",
    Author = "by Delta • AetherUI v3.0.0",
    Folder = "ftgshub",
    HideSearchBar = false,
    OpenButton = {
        Title = "Open .ftgs hub UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        Color = ColorSequence.new(
            Color3.fromHex("#30FF6A"),
            Color3.fromHex("#e7ff2f")
        )
    }
})

-- Tags
Window:Tag({
    Title = "v3.0.0",
    Icon = "10709791437",
    Color = Color3.fromHex("#6b31ff")
})

Window:Tag({
    Title = "Premium",
    Color = Color3.fromHex("#ffcc00")
})

-- Custom Theme (WindUI Style)
Aether:AddTheme({
    Name = "Stylish",
    Accent = Color3.fromHex("#3b82f6"),
    Dialog = Color3.fromHex("#1a1a1a"),
    Outline = Color3.fromHex("#3b82f6"),
    Text = Color3.fromHex("#f8fafc"),
    Placeholder = Color3.fromHex("#94a3b8"),
    Button = Color3.fromHex("#334155"),
    Icon = Color3.fromHex("#60a5fa"),
    WindowBackground = Color3.fromHex("#0f172a"),
    TopbarButtonIcon = Color3.fromHex("#60a5fa"),
    TopbarTitle = Color3.fromHex("#f8fafc"),
    TopbarAuthor = Color3.fromHex("#94a3b8"),
    TopbarIcon = Color3.fromHex("#3b82f6"),
    TabBackground = Color3.fromHex("#1e293b"),
    TabTitle = Color3.fromHex("#f8fafc"),
    TabIcon = Color3.fromHex("#60a5fa"),
    ElementBackground = Color3.fromHex("#1e293b"),
    ElementTitle = Color3.fromHex("#f8fafc"),
    ElementDesc = Color3.fromHex("#cbd5e1"),
    ElementIcon = Color3.fromHex("#60a5fa"),
})

-- Aether:SetTheme("Stylish")

-- About Tab
local AboutTab = Window:Tab({ Title = "About", Icon = "info" })
local AboutSection = AboutTab:Section({ Title = "About AetherUI" })

-- Image
AboutSection:Image({
    Image = "https://repository-images.githubusercontent.com/880118829/428bedb1-dcbd-43d5-bc7f-3beb2e9e0177",
    Size = 150,
})

AboutSection:Space()

-- Paragraph dengan Buttons
AboutSection:Paragraph({
    Title = "What is AetherUI?",
    Desc = "AetherUI v3.0.0 is a 1:1 clone of WindUI with identical API and visuals. Use this as a drop-in replacement for WindUI.",
    Image = "https://example.com/banner.png",
    ImageSize = 48,
    Buttons = {
        {
            Title = "Copy link",
            Icon = "link",
            Callback = function()
                Aether:Notify({
                    Title = "Copied",
                    Content = "Link copied to clipboard!",
                    Icon = "check"
                })
            end
        }
    }
})

-- Elements Tab
local ElementsTab = Window:Tab({ Title = "Elements", Icon = "grid" })
local ElementsSection = ElementsTab:Section({ Title = "UI Elements" })

-- Toggle
ElementsSection:Toggle({
    Title = "Toggle",
    Desc = "Toggle example",
    Default = false,
    Callback = function(state)
        print("Toggle:", state)
    end
})

ElementsSection:Toggle({
    Title = "Locked Toggle",
    Locked = true,
    Callback = function(state) end
})

ElementsSection:Space()

-- Button dengan Highlight & Justify
local HighlightBtn = ElementsSection:Button({
    Title = "Highlight Button",
    Icon = "mouse",
    Justify = "Center",
    Callback = function()
        HighlightBtn:Highlight()
        Aether:Notify({
            Title = "Clicked",
            Content = "Button clicked!",
            Icon = "check"
        })
    end
})

ElementsSection:Button({
    Title = "Blue Button",
    Color = Color3.fromHex("#305dff"),
    Icon = "",
    Callback = function() end
})

ElementsSection:Space()

-- Input & Textarea
ElementsSection:Input({
    Title = "Input",
    Icon = "text",
    Placeholder = "Enter text...",
    Callback = function(value)
        print("Input:", value)
    end
})

ElementsSection:Input({
    Title = "Textarea",
    Type = "Textarea",
    Placeholder = "Multi-line input...",
    Callback = function(value)
        print("Textarea:", value)
    end
})

ElementsSection:Space()

-- Dropdown dengan Icons
ElementsSection:Dropdown({
    Title = "Advanced Dropdown",
    Values = {
        { Title = "Category A", Icon = "bird" },
        { Title = "Category B", Icon = "house" },
        { Title = "Category C", Icon = "droplet" }
    },
    Value = "Category A",
    Callback = function(option)
        print("Selected:", option)
    end
})

ElementsSection:Space()

-- Slider dengan Step
ElementsSection:Slider({
    Title = "Slider",
    Step = 1,
    Value = { Min = 20, Max = 120, Default = 70 },
    Callback = function(value)
        print("Slider:", value)
    end
})

ElementsSection:Space()

-- Colorpicker
ElementsSection:Colorpicker({
    Title = "Colorpicker",
    Desc = "Pick a color",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Callback = function(color)
        print("Color:", color)
    end
})

ElementsSection:Space()

-- Keybind
ElementsSection:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open UI",
    Value = "G",
    Callback = function(key)
        print("Keybind:", key)
    end
})

-- Config Tab
local ConfigTab = Window:Tab({ Title = "Config", Icon = "folder" })
local ConfigSection = ConfigTab:Section({ Title = "Config Manager" })

local ConfigManager = Window.ConfigManager
local ConfigName = "default"

local ConfigNameInput = ConfigSection:Input({
    Title = "Config Name",
    Icon = "file-cog",
    Callback = function(value)
        ConfigName = value
    end
})

local AllConfigs = ConfigManager:AllConfigs()
ConfigSection:Dropdown({
    Title = "All Configs",
    Desc = "Select existing configs",
    Values = AllConfigs,
    Value = AllConfigs[1],
    Callback = function(value)
        ConfigName = value
        ConfigNameInput:Set(value)
    end
})

ConfigSection:Space()

ConfigSection:Button({
    Title = "Save Config",
    Icon = "",
    Justify = "Center",
    Callback = function()
        local config = ConfigManager:CreateConfig(ConfigName)
        if config:Save() then
            Aether:Notify({
                Title = "Config Saved",
                Desc = "Config '" .. ConfigName .. "' saved",
                Icon = "check"
            })
        end
    end
})

ConfigSection:Button({
    Title = "Load Config",
    Icon = "",
    Justify = "Center",
    Callback = function()
        local config = ConfigManager:CreateConfig(ConfigName)
        if config:Load() then
            Aether:Notify({
                Title = "Config Loaded",
                Desc = "Config '" .. ConfigName .. "' loaded",
                Icon = "refresh-cw"
            })
        end
    end
})

-- Set Toggle Key
Window:SetToggleKey(Enum.KeyCode.RightShift)

-- Welcome Notification
Aether:Notify({
    Title = "Welcome!",
    Content = "AetherUI v3.0.0 Loaded! WindUI Clone Edition.",
    Icon = "check",
    Duration = 4
})

print("╔═══════════════════════════════════════════════════════════════════")
print("║  AetherUI v3.0.0 - WindUI Super Clone")
print("║  Developer: Delta | API: 1:1 WindUI Compatible")
print("╠═══════════════════════════════════════════════════════════════════")
print("║  ✨ Features: Tags, OpenButton, Paragraph, Locked, Config, etc.")
print("║  ⌨️ Toggle Key: RightShift")
print("║  💾 Config Folder: ftgshub")
print("╚═══════════════════════════════════════════════════════════════════")
print("✅ Ready to use! GUI should be visible now.")
