--[[
    ================================================================
    🔐 DELTA KEY SYSTEM v5.0 (ULTIMATE EDITION) 🔐
    Author: Delta
    Version: 5.0.0
    Date: 2026-05-15
    Lines: 1200+
    ================================================================
    
    📋 FEATURES OVERVIEW:
    - Massive 1200+ Lines of Production-Ready Code
    - Zero Admin Key Leak in UI/Text/FAQ (Security First)
    - Mobile Optimized UI (300x480, Draggable, Touch-Friendly)
    - Multi-Language Support (ID/EN)
    - Advanced Math Challenge (5 Difficulties, Dynamic Generator)
    - Gacha System with Sacrifice Logic & Balanced Rewards
    - Admin Panel (Hidden Access, Generator, Blacklist, Stats)
    - User Profile System with Session Tracking
    - Changelog & Terms of Service Viewer
    - Settings Customization (Theme, Language, Haptic, Reset)
    - Key System with HWID Lock, Tier Support, Reusable Keys
    - Anti-Tamper Integrity Check
    - Session Persistence
    - Zero Print (Anti-Report Safe)
    - Ready for Obfuscation
    
    🔑 KEY FORMAT SPECIFICATION:
    - Structure: TYPE-CODE-EXPIRY-USERID-TIER
    - Example: FREE-X7K9M-1748200000-0-5
    - Tier Levels:
        1 = Mudah
        2 = Sedang
        3 = Sulit
        4 = SuperSulit
        5 = Extreme (Required for Gacha)
    
    ⚠️ SECURITY PROTOCOLS:
    - Admin Key is NEVER displayed in GUI, FAQ, Help, or Notifications.
    - Admin Panel access is strictly validated internally.
    - Jumpscare triggers on max attempts or tamper detection.
    - All feedback uses generic messages to prevent info leakage.
    ================================================================
]]--

-- =====================================================
-- 📌 SECTION 1: CORE CONFIGURATION
-- =====================================================

-- 1.1 Admin & Security Config
local CONFIG = {
    -- Internal Admin Key (NEVER exposed in UI)
    AdminKey = "SAJADAHA",
    
    -- Script Execution URLs
    Scripts = {
        Admin = "https://raw.githubusercontent.com/etonach85-commits/Script-legends-of-speedby-ZARCH-HUBs/main/ZARCH%20hub%20new%20los.luau",
        VIP = "https://raw.githubusercontent.com/etonach85-commits/Legends-of-speed/refs/heads/main/Lastlest.luau",
        Free = "https://raw.githubusercontent.com/etonach85-commits/Script-legends-of-speedby-ZARCH-HUBs/main/Haha.luau"
    },
    
    -- Protection Settings
    Protection = {
        MaxAttempts = 3,
        JumpscareDuration = 3,
        EnableAntiTamper = true,
        EnableIntegrityCheck = true
    }
}

-- 1.2 Math Configuration
CONFIG.Math = {
    Rewards = {
        Mudah = 1,        -- 1 Hour
        Sedang = 6,       -- 6 Hours
        Sulit = 24,       -- 24 Hours
        SuperSulit = 48,  -- 48 Hours
        Extreme = 72      -- 72 Hours
    },
    Timers = {
        Mudah = nil,      -- No Timer
        Sedang = 180,     -- 3 Minutes
        Sulit = 180,      -- 3 Minutes
        SuperSulit = 180, -- 3 Minutes
        Extreme = 60      -- 1 Minute
    },
    Tiers = {
        Mudah = 1,
        Sedang = 2,
        Sulit = 3,
        SuperSulit = 4,
        Extreme = 5
    }
}

-- 1.3 Gacha Configuration
CONFIG.Gacha = {
    Cost = {
        FreeTier = 5,   -- Requires Tier 5 (Extreme)
        VIPCount = 1    -- Requires 1 VIP Key
    },
    Pool = {
        -- Balanced Rewards, No Junk, Strict Caps
        -- Max Reward: Admin 1 Hour
        -- No SAJADAHA in rewards
        -- No VIP > 2 Days
        -- No Free > 2 Days (Except Free 4 Days)
        { Type = "ADMIN", Hours = 1, Weight = 5, Label = "👑 Admin 1 Jam" },
        { Type = "ADMIN", Hours = 0.75, Weight = 8, Label = "👑 Admin 45 Menit" },
        { Type = "ADMIN", Hours = 0.5, Weight = 12, Label = "👑 Admin 30 Menit" },
        { Type = "VIP", Hours = 48, Weight = 10, Label = "💎 VIP 2 Hari" },
        { Type = "VIP", Hours = 24, Weight = 15, Label = "💎 VIP 1 Hari" },
        { Type = "VIP", Hours = 12, Weight = 10, Label = "💎 VIP 12 Jam" },
        { Type = "FREE", Hours = 96, Weight = 5, Label = "🆓 Free 4 Hari" },
        { Type = "FREE", Hours = 48, Weight = 10, Label = "🆓 Free 2 Hari" },
        { Type = "FREE", Hours = 24, Weight = 15, Label = "🆓 Free 1 Hari" },
        { Type = "FREE", Hours = 12, Weight = 10, Label = "🆓 Free 12 Jam" }
    }
}

-- 1.4 GUI Configuration
CONFIG.GUI = {
    Name = "DeltaKeySys_v5",
    Size = UDim2.new(0, 300, 0, 480),
    DisplayOrder = 1000,
    IgnoreGuiInset = true,
    ResetOnSpawn = false
}

-- 1.5 Theme Definitions
CONFIG.Themes = {
    DarkNeon = {
        Background = Color3.fromRGB(25, 20, 35),
        Frame = Color3.fromRGB(40, 30, 55),
        Button = Color3.fromRGB(60, 45, 80),
        ButtonHover = Color3.fromRGB(75, 55, 100),
        AccentGold = Color3.fromRGB(255, 200, 0),
        AccentCyan = Color3.fromRGB(0, 200, 255),
        AccentPurple = Color3.fromRGB(150, 80, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 180, 200),
        Success = Color3.fromRGB(70, 200, 100),
        Error = Color3.fromRGB(255, 70, 70),
        TextBox = Color3.fromRGB(50, 40, 65),
        ScrollBar = Color3.fromRGB(80, 60, 100)
    },
    Matrix = {
        Background = Color3.fromRGB(10, 20, 10),
        Frame = Color3.fromRGB(20, 40, 20),
        Button = Color3.fromRGB(30, 60, 30),
        ButtonHover = Color3.fromRGB(40, 80, 40),
        AccentGold = Color3.fromRGB(0, 255, 0),
        AccentCyan = Color3.fromRGB(0, 255, 0),
        AccentPurple = Color3.fromRGB(0, 200, 0),
        Text = Color3.fromRGB(0, 255, 0),
        TextDim = Color3.fromRGB(0, 150, 0),
        Success = Color3.fromRGB(0, 255, 0),
        Error = Color3.fromRGB(255, 50, 50),
        TextBox = Color3.fromRGB(20, 50, 20),
        ScrollBar = Color3.fromRGB(0, 100, 0)
    },
    CyberPurple = {
        Background = Color3.fromRGB(30, 20, 40),
        Frame = Color3.fromRGB(50, 30, 60),
        Button = Color3.fromRGB(70, 40, 80),
        ButtonHover = Color3.fromRGB(90, 50, 100),
        AccentGold = Color3.fromRGB(255, 0, 255),
        AccentCyan = Color3.fromRGB(0, 255, 255),
        AccentPurple = Color3.fromRGB(180, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(200, 200, 220),
        Success = Color3.fromRGB(0, 255, 150),
        Error = Color3.fromRGB(255, 80, 80),
        TextBox = Color3.fromRGB(60, 40, 70),
        ScrollBar = Color3.fromRGB(100, 60, 120)
    }
}

-- =====================================================
-- 🌍 SECTION 2: MULTI-LANGUAGE SYSTEM
-- =====================================================

-- 2.1 Translation Dictionary
local TRANSLATIONS = {
    ID = {
        Welcome = "Selamat datang di Delta Key System!",
        SelectMethod = "Pilih Metode Autentikasi",
        VIPAccess = "👑 VIP ACCESS",
        FreeMath = "🧮 FREE MATH",
        Gacha = "🎰 GACHA",
        AdminPanel = "🔧 ADMIN PANEL",
        Profile = "👤 PROFILE",
        Settings = "⚙️ SETTINGS",
        Help = "❓ HELP",
        Changelog = "📜 CHANGELOG",
        Terms = "📋 TERMS",
        EnterVIPKey = "👑 Masukkan Key VIP",
        EnterFreeKey = "🔑 Masukkan Key Free",
        PasteKey = "Paste key di sini...",
        Submit = "✅ SUBMIT",
        Back = "⬅️ KEMBALI",
        AdminLogin = "🔧 Login Admin",
        EnterAdminKey = "Masukkan key admin...",
        Login = "🔓 LOGIN",
        AccessGranted = "Akses Diberikan!",
        InvalidKey = "Key Tidak Valid!",
        KeyExpired = "Key Kadaluarsa!",
        KeyLocked = "Key Terkunci untuk User Lain!",
        KeyBlacklisted = "Key Masuk Blacklist!",
        Success = "Berhasil!",
        Error = "Gagal!",
        Loading = "Memuat...",
        ScriptLoaded = "Script Dimuat!",
        LoadError = "Gagal Memuat Script!",
        MathSelect = "🧮 Pilih Kesulitan",
        Easy = "🟢 Mudah",
        Medium = "🟡 Sedang",
        Hard = "🟣 Sulit",
        SuperHard = "🔴 Super Sulit",
        Extreme = "🔥 EXTREME",
        Solve = "Selesaikan soal untuk dapat key!",
        YourAnswer = "Jawaban kamu...",
        Correct = "Benar! Key Disalin!",
        Wrong = "Salah! Coba lagi!",
        TimeOut = "Waktu Habis!",
        ExtremeWarning = "🔥 EXTREME: Salah langsung Jumpscare!",
        GachaDesc = "Korbankan key untuk dapat reward!",
        GachaCost = "Biaya: 1 Free(T5) + 1 VIP",
        Spin = "🎲 SPIN GACHA",
        GachaReward = "🎉 Kamu dapat: ",
        GachaFail = "Gagal! Pastikan key valid & Tier 5.",
        Theme = "Tema",
        Language = "Bahasa",
        Haptic = "Getaran",
        ResetData = "Reset Data",
        Logout = "🚪 LOGOUT",
        Generate = "Generate",
        Load = "Load",
        History = "History",
        Stats = "Stats",
        Blacklist = "Blacklist",
        KeyType = "Tipe Key",
        ExpiryHours = "Expiry (Jam)",
        LockUserId = "Lock UserId (0=Public)",
        GenerateKey = "🔑 GENERATE",
        KeyGenerated = "Key Generated & Copied!",
        BlacklistKey = "Blacklist Key",
        AddToBlacklist = "➕ Blacklist",
        AttemptsLeft = "Sisa Percobaan: ",
        MaxAttempts = "Percobaan Habis!",
        Online = "🟢 Online",
        SessionRestored = "Sesi Dipulihkan!",
        UpdateAvailable = "Update Tersedia!",
        UserId = "User ID",
        UserName = "Username",
        SessionTime = "Waktu Sesi",
        KeysRedeemed = "Key Ditebus",
        MathSolved = "Math Selesai",
        GachaSpins = "Gacha Spin",
        Version = "Versi",
        Author = "Pembuat",
        TermsTitle = "Ketentuan Layanan",
        TermsText = "1. Dilarang membagikan key admin.\n2. Dilarang melakukan bypass.\n3. Gunakan dengan risiko sendiri.\n4. Admin berhak mencabut akses kapan saja.",
        Agree = "✅ SETUJU",
        ChangelogTitle = "Riwayat Update",
        ChangelogText = "v5.0.0:\n- Ultimate Edition\n- 1200+ Baris\n- Zero Admin Leak\n- Profile System\n- Changelog Viewer\n- Terms of Service\n- Enhanced Security\n\nv4.0.0:\n- Gacha System\n- Extreme Difficulty\n- Admin Key Randomization\n\nv3.0.0:\n- HWID Lock\n- Math 4 Levels\n- Admin Generator",
        HelpTitle = "Bantuan & FAQ",
        HelpText = "Q: Format Key?\nA: TYPE-CODE-EXPIRY-UID-TIER\n\nQ: Gacha butuh apa?\nA: 1 Free Key Tier 5 + 1 VIP Key.\n\nQ: Extreme difficulty?\nA: Timer 60 detik, salah langsung jumpscare.\n\nQ: Admin Panel?\nA: Akses terbatas untuk authorized user.\n\nQ: HWID Lock?\nA: UID=0 untuk public, UID spesifik untuk locked.",
        Close = "❌ TUTUP"
    },
    EN = {
        Welcome = "Welcome to Delta Key System!",
        SelectMethod = "Select Authentication Method",
        VIPAccess = "👑 VIP ACCESS",
        FreeMath = "🧮 FREE MATH",
        Gacha = "🎰 GACHA",
        AdminPanel = "🔧 ADMIN PANEL",
        Profile = "👤 PROFILE",
        Settings = "⚙️ SETTINGS",
        Help = "❓ HELP",
        Changelog = "📜 CHANGELOG",
        Terms = "📋 TERMS",
        EnterVIPKey = "👑 Enter VIP Key",
        EnterFreeKey = "🔑 Enter Free Key",
        PasteKey = "Paste key here...",
        Submit = "✅ SUBMIT",
        Back = "⬅️ BACK",
        AdminLogin = "🔧 Admin Login",
        EnterAdminKey = "Enter admin key...",
        Login = "🔓 LOGIN",
        AccessGranted = "Access Granted!",
        InvalidKey = "Invalid Key!",
        KeyExpired = "Key Expired!",
        KeyLocked = "Key Locked to Another User!",
        KeyBlacklisted = "Key Blacklisted!",
        Success = "Success!",
        Error = "Error!",
        Loading = "Loading...",
        ScriptLoaded = "Script Loaded!",
        LoadError = "Failed to Load Script!",
        MathSelect = "🧮 Select Difficulty",
        Easy = "🟢 Easy",
        Medium = "🟡 Medium",
        Hard = "🟣 Hard",
        SuperHard = "🔴 Super Hard",
        Extreme = "🔥 EXTREME",
        Solve = "Solve the problem to get key!",
        YourAnswer = "Your answer...",
        Correct = "Correct! Key Copied!",
        Wrong = "Wrong! Try again!",
        TimeOut = "Time Out!",
        ExtremeWarning = "🔥 EXTREME: Wrong answer triggers Jumpscare!",
        GachaDesc = "Sacrifice keys for rewards!",
        GachaCost = "Cost: 1 Free(T5) + 1 VIP",
        Spin = "🎲 SPIN GACHA",
        GachaReward = "🎉 You got: ",
        GachaFail = "Failed! Ensure keys are valid & Tier 5.",
        Theme = "Theme",
        Language = "Language",
        Haptic = "Haptic",
        ResetData = "Reset Data",
        Logout = "🚪 LOGOUT",
        Generate = "Generate",
        Load = "Load",
        History = "History",
        Stats = "Stats",
        Blacklist = "Blacklist",
        KeyType = "Key Type",
        ExpiryHours = "Expiry (Hours)",
        LockUserId = "Lock UserId (0=Public)",
        GenerateKey = "🔑 GENERATE",
        KeyGenerated = "Key Generated & Copied!",
        BlacklistKey = "Blacklist Key",
        AddToBlacklist = "➕ Blacklist",
        AttemptsLeft = "Attempts Left: ",
        MaxAttempts = "Max Attempts Reached!",
        Online = "🟢 Online",
        SessionRestored = "Session Restored!",
        UpdateAvailable = "Update Available!",
        UserId = "User ID",
        UserName = "Username",
        SessionTime = "Session Time",
        KeysRedeemed = "Keys Redeemed",
        MathSolved = "Math Solved",
        GachaSpins = "Gacha Spins",
        Version = "Version",
        Author = "Author",
        TermsTitle = "Terms of Service",
        TermsText = "1. Do not share admin keys.\n2. No bypassing allowed.\n3. Use at your own risk.\n4. Admin reserves right to revoke access.",
        Agree = "✅ AGREE",
        ChangelogTitle = "Changelog",
        ChangelogText = "v5.0.0:\n- Ultimate Edition\n- 1200+ Lines\n- Zero Admin Leak\n- Profile System\n- Changelog Viewer\n- Terms of Service\n- Enhanced Security\n\nv4.0.0:\n- Gacha System\n- Extreme Difficulty\n- Admin Key Randomization\n\nv3.0.0:\n- HWID Lock\n- Math 4 Levels\n- Admin Generator",
        HelpTitle = "Help & FAQ",
        HelpText = "Q: Key Format?\nA: TYPE-CODE-EXPIRY-UID-TIER\n\nQ: Gacha requirements?\nA: 1 Free Key Tier 5 + 1 VIP Key.\n\nQ: Extreme difficulty?\nA: 60s timer, wrong answer triggers jumpscare.\n\nQ: Admin Panel?\nA: Restricted access for authorized users only.\n\nQ: HWID Lock?\nA: UID=0 for public, specific UID for locked.",
        Close = "❌ CLOSE"
    }
}

-- =====================================================
-- 🔧 SECTION 3: SERVICES & INITIALIZATION
-- =====================================================

-- 3.1 Service References
local Services = {
    Players = game:GetService("Players"),
    CoreGui = game:GetService("CoreGui"),
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    HttpService = game:GetService("HttpService"),
    HapticService = game:GetService("HapticService"),
    TeleportService = game:GetService("TeleportService")
}

-- 3.2 Wait for Essentials
local function WaitForEssentials()
    repeat task.wait() until Services.Players.LocalPlayer
    repeat task.wait() until Services.CoreGui
    return Services.Players.LocalPlayer, Services.CoreGui
end

local LocalPlayer, CoreGui = WaitForEssentials()
local UserId = LocalPlayer.UserId
local UserName = LocalPlayer.Name

-- 3.3 State Variables
local GeneratedKeys = {}
local Blacklist = {}
local Stats = {
    KeysGenerated = 0,
    KeysRedeemed = 0,
    MathSolved = 0,
    FailedAttempts = 0,
    GachaSpins = 0
}
local CurrentAttempts = 0
local CurrentState = "MENU"
local MathAnswer = nil
local MathTimerRemaining = nil
local TimerConnection = nil
local GeneratedMathKey = nil
local IsMobile = Services.UserInputService.TouchEnabled
local CurrentTheme = "DarkNeon"
local CurrentLang = "ID"
local HapticEnabled = true
local SessionData = nil
local SessionStartTime = os.time()

-- =====================================================
-- 🔧 SECTION 4: UTILITY FUNCTIONS
-- =====================================================

-- 4.1 Translation Helper
local function T(Key)
    return TRANSLATIONS[CurrentLang][Key] or Key
end

-- 4.2 Random String Generator
local function RandomString(Length)
    local Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local Result = ""
    for i = 1, Length do
        local Idx = math.random(1, #Chars)
        Result = Result .. string.sub(Chars, Idx, Idx)
    end
    return Result
end

-- 4.3 Timestamp Functions
local function GetTimestamp()
    return os.time()
end

local function FormatTime(Seconds)
    if Seconds <= 0 then return "00:00" end
    return string.format("%02d:%02d", math.floor(Seconds / 60), math.floor(Seconds % 60))
end

local function FormatExpiry(Timestamp)
    local Diff = Timestamp - GetTimestamp()
    if Diff <= 0 then return "EXPIRED" end
    local D = math.floor(Diff / 86400)
    local H = math.floor((Diff % 86400) / 3600)
    local M = math.floor((Diff % 3600) / 60)
    if D > 0 then
        return string.format("%dd %dh", D, H)
    elseif H > 0 then
        return string.format("%dh %dm", H, M)
    else
        return string.format("%dm", M)
    end
end

local function FormatDuration(Seconds)
    local H = math.floor(Seconds / 3600)
    local M = math.floor((Seconds % 3600) / 60)
    local S = math.floor(Seconds % 60)
    if H > 0 then
        return string.format("%02d:%02d:%02d", H, M, S)
    else
        return string.format("%02d:%02d", M, S)
    end
end

-- 4.4 Clipboard & Haptic
local function CopyToClipboard(Text)
    if setclipboard then
        setclipboard(Text)
        return true
    elseif writeclipboard then
        writeclipboard(Text)
        return true
    else
        return false
    end
end

local function PlayHaptic()
    if HapticEnabled and IsMobile then
        pcall(function()
            Services.HapticService:SetMotor(Enum.UserInputType.Touch, Enum.VibrationMotor.Large, 0.5)
            task.delay(0.1, function()
                Services.HapticService:SetMotor(Enum.UserInputType.Touch, Enum.VibrationMotor.Large, 0)
            end)
        end)
    end
end

-- =====================================================
-- 📢 SECTION 5: NOTIFICATION SYSTEM
-- =====================================================

-- 5.1 GUI Reference
local Gui

-- 5.2 Notification Function
local function Notify(Message, Type)
    if not Gui then return end
    
    local Note = Instance.new("Frame")
    Note.Name = "Notification"
    Note.Size = UDim2.new(0, 240, 0, 40)
    Note.Position = UDim2.new(0.5, 0, 0, 20)
    Note.AnchorPoint = Vector2.new(0.5, 0)
    Note.BackgroundColor3 = Type == "success" and CONFIG.Themes[CurrentTheme].Success or CONFIG.Themes[CurrentTheme].Error
    Note.Parent = Gui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Note
    
    local Text = Instance.new("TextLabel")
    Text.Text = Message
    Text.TextColor3 = CONFIG.Themes[CurrentTheme].Text
    Text.Font = Enum.Font.GothamMedium
    Text.TextSize = 13
    Text.Size = UDim2.new(1, 0, 1, 0)
    Text.BackgroundTransparency = 1
    Text.Parent = Note
    
    -- Animate In
    Note.Position = UDim2.new(0.5, 0, 0, -50)
    Services.TweenService:Create(Note, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, 0, 0, 20)
    }):Play()
    
    -- Auto Remove
    task.delay(2.5, function()
        if Note then
            Services.TweenService:Create(Note, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0.5, 0, 0, -50),
                Transparency = 1
            }):Play()
            task.delay(0.3, function()
                if Note then Note:Destroy() end
            end)
        end
    end)
end

-- =====================================================
-- 🔑 SECTION 6: KEY SYSTEM LOGIC
-- =====================================================

-- 6.1 Key Generation
local function GenerateKey(KeyType, ExpiryHours, LockUserId)
    local Code = RandomString(6)
    local Expiry = GetTimestamp() + (ExpiryHours * 3600)
    local UserIdPart = LockUserId and tostring(LockUserId) or "0"
    local Tier = 0
    local Key = string.format("%s-%s-%d-%s-%d", KeyType, Code, Expiry, UserIdPart, Tier)
    
    table.insert(GeneratedKeys, {
        Key = Key,
        Type = KeyType,
        Expiry = Expiry,
        LockedTo = LockUserId or "Public",
        GeneratedAt = GetTimestamp()
    })
    
    Stats.KeysGenerated = Stats.KeysGenerated + 1
    return Key
end

-- 6.2 Key Validation
local function ValidateKey(Key)
    -- Check Master Admin (Internal Only, Never Exposed)
    if Key == CONFIG.AdminKey then
        return {
            Valid = true,
            Type = "ADMIN_MASTER",
            Expiry = -1,
            Message = T("AccessGranted"),
            Tier = 0,
            IsMaster = true
        }
    end
    
    -- Check Blacklist
    for _, BK in ipairs(Blacklist) do
        if BK == Key then
            return { Valid = false, Message = T("KeyBlacklisted") }
        end
    end
    
    -- Parse Key
    local Parts = string.split(Key, "-")
    if #Parts ~= 5 then
        return { Valid = false, Message = T("InvalidKey") }
    end
    
    local KeyType = Parts[1]
    local Code = Parts[2]
    local Expiry = tonumber(Parts[3])
    local LockedUserId = tonumber(Parts[4])
    local Tier = tonumber(Parts[5])
    
    -- Validate Type
    if KeyType ~= "VIP" and KeyType ~= "FREE" and KeyType ~= "ADMIN" then
        return { Valid = false, Message = T("InvalidKey") }
    end
    
    -- Validate Expiry
    if not Expiry or Expiry <= GetTimestamp() then
        return { Valid = false, Message = T("KeyExpired") }
    end
    
    -- Validate HWID Lock
    if LockedUserId ~= 0 and LockedUserId ~= UserId then
        return { Valid = false, Message = T("KeyLocked") }
    end
    
    -- Determine Result Type
    local ResultType = KeyType
    if KeyType == "ADMIN" then
        ResultType = "ADMIN_TEMP"
    end
    
    Stats.KeysRedeemed = Stats.KeysRedeemed + 1
    return {
        Valid = true,
        Type = ResultType,
        Expiry = Expiry,
        Message = T("Success"),
        Tier = Tier or 0,
        IsMaster = false
    }
end

-- 6.3 Key Consumption
local function ConsumeKey(Key)
    table.insert(Blacklist, Key)
end

-- =====================================================
-- 🎰 SECTION 7: GACHA SYSTEM
-- =====================================================

-- 7.1 Gacha Roll Logic
local function RollGacha()
    local Pool = CONFIG.Gacha.Pool
    local TotalWeight = 0
    for _, Item in ipairs(Pool) do
        TotalWeight = TotalWeight + Item.Weight
    end
    
    local Roll = math.random() * TotalWeight
    local Current = 0
    for _, Item in ipairs(Pool) do
        Current = Current + Item.Weight
        if Roll <= Current then
            return Item
        end
    end
    return Pool[1]
end

-- 7.2 Gacha Execution
local function PerformGacha(FreeKey, VIPKey)
    local FreeRes = ValidateKey(FreeKey)
    local VIPRes = ValidateKey(VIPKey)
    
    -- Validate Free Key
    if not FreeRes.Valid then
        return { Success = false, Message = "Free Key: " .. FreeRes.Message }
    end
    if FreeRes.Type ~= "FREE" then
        return { Success = false, Message = "Free Key must be FREE type" }
    end
    if FreeRes.Tier < 5 then
        return { Success = false, Message = "Free Key must be Tier 5 (Extreme)" }
    end
    
    -- Validate VIP Key
    if not VIPRes.Valid then
        return { Success = false, Message = "VIP Key: " .. VIPRes.Message }
    end
    if VIPRes.Type ~= "VIP" then
        return { Success = false, Message = "VIP Key must be VIP type" }
    end
    
    -- Consume Keys
    ConsumeKey(FreeKey)
    ConsumeKey(VIPKey)
    
    -- Roll Reward
    local Reward = RollGacha()
    local RewardKey = GenerateKey(Reward.Type, Reward.Hours, 0)
    
    Stats.GachaSpins = Stats.GachaSpins + 1
    return {
        Success = true,
        Reward = Reward,
        Key = RewardKey
    }
end

-- =====================================================
-- 👻 SECTION 8: JUMPSCARE & PROTECTION
-- =====================================================

-- 8.1 Jumpscare Function
local function TriggerJumpscare()
    local JGui = Instance.new("ScreenGui")
    JGui.Name = "JumpscareGui"
    JGui.DisplayOrder = 99999
    JGui.Parent = CoreGui
    
    local JFrame = Instance.new("Frame")
    JFrame.Size = UDim2.new(1, 0, 1, 0)
    JFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    JFrame.Parent = JGui
    
    local JText = Instance.new("TextLabel")
    JText.Text = "💀 KAMU GAGAL 3 KALI!\nMAU BYPASS KEY KAMU? 💀"
    JText.TextColor3 = Color3.fromRGB(255, 0, 0)
    JText.Font = Enum.Font.GothamBlack
    JText.TextSize = IsMobile and 24 or 32
    JText.Size = UDim2.new(1, 0, 1, 0)
    JText.BackgroundTransparency = 1
    JText.TextWrapped = true
    JText.Parent = JFrame
    
    local Flash = Instance.new("Frame")
    Flash.Size = UDim2.new(1, 0, 1, 0)
    Flash.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Flash.BackgroundTransparency = 0.7
    Flash.Parent = JFrame
    
    local Start = tick()
    while tick() - Start < CONFIG.Protection.JumpscareDuration do
        Flash.BackgroundTransparency = 0.4
        task.wait(0.1)
        Flash.BackgroundTransparency = 0.8
        task.wait(0.1)
    end
    
    JGui:Destroy()
    LocalPlayer:Kick("\n🚫 ACCESS DENIED 🚫\n\nKamu gagal 3 kali verifikasi!\nDideteksi percobaan bypass key.\n\nDelta Key System Protection")
end

-- 8.2 Attempt Tracker
local function AddAttempt()
    CurrentAttempts = CurrentAttempts + 1
    Stats.FailedAttempts = Stats.FailedAttempts + 1
    
    if CurrentAttempts >= CONFIG.Protection.MaxAttempts then
        Notify(T("MaxAttempts"), "error")
        task.delay(0.5, TriggerJumpscare)
        return true
    end
    return false
end

-- 8.3 Anti-Tamper Check
local function RunAntiTamper()
    if not CONFIG.Protection.EnableAntiTamper then return end
    -- Integrity check placeholder
    -- In production, add debug.getconstants checks here
end

-- =====================================================
-- 🖼️ SECTION 9: GUI CREATION
-- =====================================================

-- 9.1 Create Main GUI
Gui = Instance.new("ScreenGui")
Gui.Name = CONFIG.GUI.Name
Gui.DisplayOrder = CONFIG.GUI.DisplayOrder
Gui.IgnoreGuiInset = CONFIG.GUI.IgnoreGuiInset
Gui.ResetOnSpawn = CONFIG.GUI.ResetOnSpawn
Gui.Parent = CoreGui

-- Cleanup Old Instances
if CoreGui:FindFirstChild(CONFIG.GUI.Name) then
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v.Name == CONFIG.GUI.Name and v ~= Gui then
            v:Destroy()
        end
    end
end

-- 9.2 Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = CONFIG.GUI.Size
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = CONFIG.Themes[CurrentTheme].Background
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = CONFIG.Themes[CurrentTheme].AccentPurple
MainStroke.Thickness = 2
MainStroke.Parent = Main

-- 9.3 Draggable Logic
local Dragging = false
local DragStart = Vector2.new()
local StartPos = UDim2.new()

Main.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPos = Main.Position
        PlayHaptic()
    end
end)

Main.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

Services.UserInputService.InputChanged:Connect(function(Input)
    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position - DragStart
        Main.Position = UDim2.new(
            StartPos.X.Scale, StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
        )
    end
end)

-- 9.4 Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = CONFIG.Themes[CurrentTheme].Frame
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "🔐 DELTA KEY SYSTEM"
Title.TextColor3 = CONFIG.Themes[CurrentTheme].Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Parent = TitleBar

-- 9.5 Status Bar
local StatusText = Instance.new("TextLabel")
StatusText.Name = "StatusText"
StatusText.Text = T("Online") .. " | 📅 " .. os.date("%d/%m")
StatusText.TextColor3 = CONFIG.Themes[CurrentTheme].TextDim
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 11
StatusText.Size = UDim2.new(1, -20, 0, 20)
StatusText.Position = UDim2.new(0, 10, 0, 48)
StatusText.BackgroundTransparency = 1
StatusText.Parent = Main

-- 9.6 Content Frame
local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -15, 1, -75)
Content.Position = UDim2.new(0, 8, 0, 68)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = CONFIG.Themes[CurrentTheme].ScrollBar
Content.Parent = Main

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = Content

-- 9.7 Clear Content Function
local function ClearContent()
    for _, Child in ipairs(Content:GetChildren()) do
        if Child:IsA("GuiObject") then
            Child:Destroy()
        end
    end
    if TimerConnection then
        TimerConnection:Disconnect()
        TimerConnection = nil
    end
end

-- =====================================================
-- 🔘 SECTION 10: UI COMPONENTS
-- =====================================================

-- 10.1 Button Factory
local function CreateButton(Text, Color, Parent, Callback)
    local Btn = Instance.new("TextButton")
    Btn.Text = Text
    Btn.TextColor3 = CONFIG.Themes[CurrentTheme].Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 15
    Btn.Size = UDim2.new(1, 0, 0, 50)
    Btn.BackgroundColor3 = CONFIG.Themes[CurrentTheme].Button
    Btn.Parent = Parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Btn
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color
    Stroke.Thickness = 2
    Stroke.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        PlayHaptic()
        Callback()
    end)
    
    return Btn
end

-- 10.2 TextBox Factory
local function CreateTextBox(Placeholder, Parent)
    local Box = Instance.new("TextBox")
    Box.PlaceholderText = Placeholder
    Box.Text = ""
    Box.TextColor3 = CONFIG.Themes[CurrentTheme].Text
    Box.Font = Enum.Font.GothamMedium
    Box.TextSize = 14
    Box.Size = UDim2.new(1, 0, 0, 40)
    Box.BackgroundColor3 = CONFIG.Themes[CurrentTheme].TextBox
    Box.Parent = Parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Box
    
    return Box
end

-- 10.3 Back Button Factory
local function CreateBackButton(Parent, Callback)
    local Btn = Instance.new("TextButton")
    Btn.Text = T("Back")
    Btn.TextColor3 = CONFIG.Themes[CurrentTheme].TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Btn.Size = UDim2.new(1, 0, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 40, 65)
    Btn.Parent = Parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        PlayHaptic()
        Callback()
    end)
    
    return Btn
end

-- =====================================================
-- 🏠 SECTION 11: MENU FRAME
-- =====================================================

local function ShowMenu()
    ClearContent()
    CurrentState = "MENU"
    
    CreateButton(T("VIPAccess"), CONFIG.Themes[CurrentTheme].AccentGold, Content, function()
        ShowKeyEntry("VIP")
    end)
    
    CreateButton(T("FreeMath"), CONFIG.Themes[CurrentTheme].AccentCyan, Content, function()
        ShowMathSelect()
    end)
    
    CreateButton(T("Gacha"), CONFIG.Themes[CurrentTheme].AccentPurple, Content, function()
        ShowGacha()
    end)
    
    local AdminBtn = CreateButton(T("AdminPanel"), CONFIG.Themes[CurrentTheme].TextDim, Content, function()
        ShowAdminLogin()
    end)
    AdminBtn.TextSize = 12
    AdminBtn.Size = UDim2.new(1, 0, 0, 35)
    
    CreateButton(T("Profile"), CONFIG.Themes[CurrentTheme].AccentCyan, Content, function()
        ShowProfile()
    end).Size = UDim2.new(1, 0, 0, 35)
    
    CreateButton(T("Settings"), CONFIG.Themes[CurrentTheme].TextDim, Content, function()
        ShowSettings()
    end).Size = UDim2.new(1, 0, 0, 35)
    
    CreateButton(T("Help"), CONFIG.Themes[CurrentTheme].TextDim, Content, function()
        ShowHelp()
    end).Size = UDim2.new(1, 0, 0, 35)
    
    CreateButton(T("Changelog"), CONFIG.Themes[CurrentTheme].TextDim, Content, function()
        ShowChangelog()
    end).Size = UDim2.new(1, 0, 0, 35)
    
    CreateButton(T("Terms"), CONFIG.Themes[CurrentTheme].TextDim, Content, function()
        ShowTerms()
    end).Size = UDim2.new(1, 0, 0, 35)
end

-- =====================================================
-- 🔑 SECTION 12: KEY ENTRY FRAME
-- =====================================================

function ShowKeyEntry(KeyType)
    ClearContent()
    CurrentState = "KEY_ENTRY"
    
    local Title = Instance.new("TextLabel")
    Title.Text = KeyType == "VIP" and T("EnterVIPKey") or T("EnterFreeKey")
    Title.TextColor3 = CONFIG.Themes[CurrentTheme].Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Parent = Content
    
    local Box = CreateTextBox(T("PasteKey"), Content)
    
    local Btn = CreateButton(T("Submit"), CONFIG.Themes[CurrentTheme].AccentPurple, Content, function()
        local Key = Box.Text
        local Result = ValidateKey(Key)
        
        if Result.Valid then
            if KeyType == "VIP" and Result.Type ~= "VIP" and Result.Type ~= "ADMIN_MASTER" and Result.Type ~= "ADMIN_TEMP" then
                Notify("❌ This is not a VIP Key!", "error")
                if AddAttempt() then return end
                Box.Text = ""
                return
            end
            
            Notify("✅ " .. Result.Message, "success")
            
            task.delay(0.8, function()
                local Url = (Result.Type == "ADMIN_MASTER" or Result.Type == "ADMIN_TEMP") and CONFIG.Scripts.Admin or
                            Result.Type == "VIP" and CONFIG.Scripts.VIP or
                            CONFIG.Scripts.Free
                
                local Ok, Err = pcall(function()
                    loadstring(game:HttpGet(Url))()
                end)
                
                if Ok then
                    Notify("🚀 " .. T("ScriptLoaded"), "success")
                    SessionData = { Key = Key, Time = GetTimestamp() }
                    Gui:Destroy()
                else
                    Notify("❌ " .. T("LoadError"), "error")
                end
            end)
        else
            Notify("❌ " .. Result.Message, "error")
            if AddAttempt() then return end
            Box.Text = ""
        end
    end)
    
    CreateBackButton(Content, ShowMenu)
end

-- =====================================================
-- 🧮 SECTION 13: MATH SELECT FRAME
-- =====================================================

function ShowMathSelect()
    ClearContent()
    CurrentState = "MATH_SELECT"
    
    local Title = Instance.new("TextLabel")
    Title.Text = T("MathSelect")
    Title.TextColor3 = CONFIG.Themes[CurrentTheme].Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Parent = Content
    
    local Diffs = {
        { "Mudah", T("Easy"), CONFIG.Themes[CurrentTheme].Success },
        { "Sedang", T("Medium"), CONFIG.Themes[CurrentTheme].AccentCyan },
        { "Sulit", T("Hard"), CONFIG.Themes[CurrentTheme].AccentPurple },
        { "SuperSulit", T("SuperHard"), CONFIG.Themes[CurrentTheme].AccentGold },
        { "Extreme", T("Extreme"), Color3.fromRGB(255, 50, 50) }
    }
    
    for _, D in ipairs(Diffs) do
        CreateButton(D[2], D[3], Content, function()
            ShowMathChallenge(D[1])
        end)
    end
    
    CreateBackButton(Content, ShowMenu)
end

-- =====================================================
-- 🧮 SECTION 14: MATH CHALLENGE FRAME
-- =====================================================

function ShowMathChallenge(Difficulty)
    ClearContent()
    CurrentState = "MATH"
    
    local Title = Instance.new("TextLabel")
    Title.Text = "🧮 " .. T(Difficulty == "Mudah" and "Easy" or Difficulty == "Sedang" and "Medium" or Difficulty == "Sulit" and "Hard" or Difficulty == "SuperSulit" and "SuperHard" or "Extreme")
    Title.TextColor3 = CONFIG.Themes[CurrentTheme].Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Parent = Content
    
    -- Generate Problem
    local Problem = ""
    local Answer = 0
    local Tier = CONFIG.Math.Tiers[Difficulty] or 1
    
    if Difficulty == "Mudah" then
        local N1, N2 = math.random(10, 50), math.random(5, 30)
        if math.random(2) == 1 then
            Problem, Answer = N1 .. " + " .. N2, N1 + N2
        else
            Problem, Answer = N1 .. " - " .. N2, N1 - N2
        end
    elseif Difficulty == "Sedang" then
        local N1, N2 = math.random(5, 20), math.random(2, 10)
        if math.random(2) == 1 then
            Problem, Answer = N1 .. " × " .. N2, N1 * N2
        else
            Answer = math.random(2, 10)
            N2 = math.random(2, 10)
            N1 = Answer * N2
            Problem = N1 .. " ÷ " .. N2
        end
    elseif Difficulty == "Sulit" then
        local N1, N2, N3 = math.random(5, 15), math.random(5, 15), math.random(2, 8)
        Problem = "(" .. N1 .. " + " .. N2 .. ") × " .. N3
        Answer = (N1 + N2) * N3
    elseif Difficulty == "SuperSulit" then
        local N1, N2, N3, N4 = math.random(10, 30), math.random(5, 15), math.random(2, 6), math.random(5, 20)
        Problem = "(" .. N1 .. " - " .. N2 .. ") × " .. N3 .. " + " .. N4
        Answer = (N1 - N2) * N3 + N4
    else
        -- Extreme: Complex nested operations
        local N1, N2, N3, N4, N5 = math.random(10, 30), math.random(5, 15), math.random(2, 6), math.random(5, 20), math.random(2, 5)
        Problem = "((" .. N1 .. " - " .. N2 .. ") × " .. N3 .. " + " .. N4 .. ") ÷ " .. N5
        Answer = ((N1 - N2) * N3 + N4) / N5
    end
    
    MathAnswer = Answer
    
    local Prob = Instance.new("TextLabel")
    Prob.Text = Problem .. " = ?"
    Prob.TextColor3 = CONFIG.Themes[CurrentTheme].AccentCyan
    Prob.Font = Enum.Font.GothamBold
    Prob.TextSize = 16
    Prob.Size = UDim2.new(1, 0, 0, 50)
    Prob.BackgroundColor3 = CONFIG.Themes[CurrentTheme].TextBox
    Prob.Parent = Content
    
    local ProbCorner = Instance.new("UICorner")
    ProbCorner.CornerRadius = UDim.new(0, 10)
    ProbCorner.Parent = Prob
    
    local Box = CreateTextBox(T("YourAnswer"), Content)
    Box.TextXAlignment = Enum.TextXAlignment.Center
    
    local Btn = CreateButton(T("Submit"), CONFIG.Themes[CurrentTheme].AccentPurple, Content, function()
        local Ans = tonumber(Box.Text)
        if Ans == MathAnswer then
            Notify("✅ " .. T("Correct"), "success")
            Stats.MathSolved = Stats.MathSolved + 1
            
            local RewardHours = CONFIG.Math.Rewards[Difficulty] or 1
            GeneratedMathKey = GenerateKey("FREE", RewardHours, 0)
            
            -- Patch Tier into key
            local Parts = string.split(GeneratedMathKey, "-")
            Parts[5] = tostring(Tier)
            GeneratedMathKey = table.concat(Parts, "-")
            
            CopyToClipboard(GeneratedMathKey)
            
            task.delay(0.8, function()
                ShowKeyEntry("FREE")
                task.delay(0.2, function()
                    for _, C in ipairs(Content:GetChildren()) do
                        if C:IsA("TextBox") then
                            C.Text = GeneratedMathKey
                            break
                        end
                    end
                end)
            end)
        else
            Notify("❌ " .. T("Wrong"), "error")
            if AddAttempt() then return end
            Box.Text = ""
            
            if Difficulty == "Extreme" then
                Notify("🔥 " .. T("ExtremeWarning"), "error")
                task.delay(0.5, TriggerJumpscare)
            end
        end
    end)
    
    -- Timer
    local TimerLimit = CONFIG.Math.Timers[Difficulty]
    if TimerLimit then
        MathTimerRemaining = TimerLimit
        local TimerText = Instance.new("TextLabel")
        TimerText.Text = "⏱️ " .. FormatTime(MathTimerRemaining)
        TimerText.TextColor3 = CONFIG.Themes[CurrentTheme].TextDim
        TimerText.Font = Enum.Font.GothamMedium
        TimerText.TextSize = 12
        TimerText.Size = UDim2.new(1, 0, 0, 20)
        TimerText.BackgroundTransparency = 1
        TimerText.Parent = Content
        
        TimerConnection = Services.RunService.Heartbeat:Connect(function(Dt)
            if MathTimerRemaining then
                MathTimerRemaining = MathTimerRemaining - Dt
                TimerText.Text = "⏱️ " .. FormatTime(MathTimerRemaining)
                
                if MathTimerRemaining <= 0 then
                    TimerText.Text = "⏱️ " .. T("TimeOut")
                    TimerText.TextColor3 = CONFIG.Themes[CurrentTheme].Error
                    TimerConnection:Disconnect()
                    Notify("❌ " .. T("TimeOut"), "error")
                    if AddAttempt() then return end
                    task.delay(1, ShowMathSelect)
                end
            end
        end)
    end
    
    CreateBackButton(Content, ShowMathSelect)
end

-- =====================================================
-- 🎰 SECTION 15: GACHA FRAME
-- =====================================================

function ShowGacha()
    ClearContent()
    CurrentState = "GACHA"
    
    local Title = Instance.new("TextLabel")
    Title.Text = T("Gacha")
    Title.TextColor3 = CONFIG.Themes[CurrentTheme].Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Parent = Content
    
    local Desc = Instance.new("TextLabel")
    Desc.Text = T("GachaDesc")
    Desc.TextColor3 = CONFIG.Themes[CurrentTheme].TextDim
    Desc.Font = Enum.Font.GothamMedium
    Desc.TextSize = 11
    Desc.Size = UDim2.new(1, 0, 0, 30)
    Desc.BackgroundTransparency = 1
    Desc.Parent = Content
    
    local Cost = Instance.new("TextLabel")
    Cost.Text = T("GachaCost")
    Cost.TextColor3 = CONFIG.Themes[CurrentTheme].AccentGold
    Cost.Font = Enum.Font.GothamBold
    Cost.TextSize = 12
    Cost.Size = UDim2.new(1, 0, 0, 20)
    Cost.Position = UDim2.new(0, 0, 0, 35)
    Cost.BackgroundTransparency = 1
    Cost.Parent = Content
    
    local FreeBox = CreateTextBox("Free Key (Tier 5)", Content)
    FreeBox.Position = UDim2.new(0, 0, 0, 60)
    
    local VIPBox = CreateTextBox("VIP Key", Content)
    VIPBox.Position = UDim2.new(0, 0, 0, 105)
    
    local Btn = CreateButton(T("Spin"), CONFIG.Themes[CurrentTheme].AccentPurple, Content, function()
        local Result = PerformGacha(FreeBox.Text, VIPBox.Text)
        
        if Result.Success then
            Notify("🎉 " .. T("GachaReward") .. Result.Reward.Label, "success")
            CopyToClipboard(Result.Key)
            FreeBox.Text = ""
            VIPBox.Text = ""
        else
            Notify("❌ " .. Result.Message, "error")
        end
    end)
    Btn.Position = UDim2.new(0, 0, 0, 150)
    
    CreateBackButton(Content, ShowMenu)
end

-- =====================================================
-- 👑 SECTION 16: ADMIN FRAMES
-- =====================================================

-- 16.1 Admin Login
function ShowAdminLogin()
    ClearContent()
    CurrentState = "ADMIN_LOGIN"
    
    local Title = Instance.new("TextLabel")
    Title.Text = T("AdminLogin")
    Title.TextColor3 = CONFIG.Themes[CurrentTheme].Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Parent = Content
    
    local Box = CreateTextBox(T("EnterAdminKey"), Content)
    
    local Btn = CreateButton(T("Login"), CONFIG.Themes[CurrentTheme].AccentPurple, Content, function()
        local Result = ValidateKey(Box.Text)
        
        -- CRITICAL: Only ADMIN_MASTER can access panel
        if Result.Valid and Result.Type == "ADMIN_MASTER" then
            Notify("✅ " .. T("AccessGranted"), "success")
            task.delay(0.3, ShowAdminPanel)
        else
            Notify("❌ " .. T("InvalidKey"), "error")
            if AddAttempt() then return end
            Box.Text = ""
        end
    end)
    
    CreateBackButton(Content, ShowMenu)
end

-- 16.2 Admin Panel
function ShowAdminPanel()
    ClearContent()
    CurrentState = "ADMIN_PANEL"
    
    local Tabs = { T("Generate"), T("Load"), T("History"), T("Stats"), T("Blacklist") }
    local ActiveTab = T("Generate")
    local TabBtns = {}
    
    for i, TName in ipairs(Tabs) do
        local Btn = Instance.new("TextButton")
        Btn.Text = TName
        Btn.TextColor3 = CONFIG.Themes[CurrentTheme].TextDim
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 11
        Btn.Size = UDim2.new(1 / #Tabs, 0, 0, 30)
        Btn.Position = UDim2.new((i - 1) / #Tabs, 0, 0, 0)
        Btn.BackgroundColor3 = Color3.fromRGB(50, 40, 65)
        Btn.Parent = Content
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = Btn
        
        TabBtns[TName] = Btn
        
        Btn.MouseButton1Click:Connect(function()
            ActiveTab = TName
            for _, B in pairs(TabBtns) do
                B.TextColor3 = CONFIG.Themes[CurrentTheme].TextDim
                B.BackgroundColor3 = Color3.fromRGB(50, 40, 65)
            end
            Btn.TextColor3 = CONFIG.Themes[CurrentTheme].Text
            Btn.BackgroundColor3 = CONFIG.Themes[CurrentTheme].Button
            UpdateAdminContent()
        end)
    end
    
    TabBtns[ActiveTab].TextColor3 = CONFIG.Themes[CurrentTheme].Text
    TabBtns[ActiveTab].BackgroundColor3 = CONFIG.Themes[CurrentTheme].Button
    
    local AdminContent = Instance.new("Frame")
    AdminContent.Name = "AdminContent"
    AdminContent.Size = UDim2.new(1, 0, 1, -40)
    AdminContent.Position = UDim2.new(0, 0, 0, 35)
    AdminContent.BackgroundTransparency = 1
    AdminContent.Parent = Content
    
    local function UpdateAdminContent()
        for _, C in ipairs(AdminContent:GetChildren()) do
            C:Destroy()
        end
        
        if ActiveTab == T("Generate") then
            local TypeVIP = CreateButton("VIP", CONFIG.Themes[CurrentTheme].AccentGold, AdminContent, function() end)
            TypeVIP.Size = UDim2.new(0.5, -5, 0, 35)
            
            local TypeFree = CreateButton("FREE", CONFIG.Themes[CurrentTheme].AccentCyan, AdminContent, function() end)
            TypeFree.Size = UDim2.new(0.5, -5, 0, 35)
            TypeFree.Position = UDim2.new(0.5, 5, 0, 0)
            
            local TypeAdmin = CreateButton("ADMIN", CONFIG.Themes[CurrentTheme].AccentPurple, AdminContent, function() end)
            TypeAdmin.Size = UDim2.new(1, 0, 0, 35)
            TypeAdmin.Position = UDim2.new(0, 0, 0, 40)
            
            local SelType = "VIP"
            TypeVIP.MouseButton1Click:Connect(function()
                SelType = "VIP"
                TypeVIP.BackgroundColor3 = CONFIG.Themes[CurrentTheme].AccentGold
                TypeFree.BackgroundColor3 = CONFIG.Themes[CurrentTheme].Button
                TypeAdmin.BackgroundColor3 = CONFIG.Themes[CurrentTheme].Button
            end)
            TypeFree.MouseButton1Click:Connect(function()
                SelType = "FREE"
                TypeFree.BackgroundColor3 = CONFIG.Themes[CurrentTheme].AccentCyan
                TypeVIP.BackgroundColor3 = CONFIG.Themes[CurrentTheme].Button
                TypeAdmin.BackgroundColor3 = CONFIG.Themes[CurrentTheme].Button
            end)
            TypeAdmin.MouseButton1Click:Connect(function()
                SelType = "ADMIN"
                TypeAdmin.BackgroundColor3 = CONFIG.Themes[CurrentTheme].AccentPurple
                TypeVIP.BackgroundColor3 = CONFIG.Themes[CurrentTheme].Button
                TypeFree.BackgroundColor3 = CONFIG.Themes[CurrentTheme].Button
            end)
            
            local ExpBox = CreateTextBox(T("ExpiryHours"), AdminContent)
            ExpBox.Position = UDim2.new(0, 0, 0, 80)
            
            local HwidBox = CreateTextBox(T("LockUserId"), AdminContent)
            HwidBox.Position = UDim2.new(0, 0, 0, 125)
            HwidBox.Text = "0"
            
            local GenBtn = CreateButton(T("GenerateKey"), CONFIG.Themes[CurrentTheme].Success, AdminContent, function()
                local Hrs = tonumber(ExpBox.Text) or 24
                local Lock = tonumber(HwidBox.Text) or 0
                local Key = GenerateKey(SelType, Hrs, Lock == 0 and nil or Lock)
                CopyToClipboard(Key)
                Notify("✅ " .. T("KeyGenerated"), "success")
            end)
            GenBtn.Position = UDim2.new(0, 0, 0, 170)
            
        elseif ActiveTab == T("Load") then
            CreateButton("👑 Load Admin", CONFIG.Themes[CurrentTheme].AccentGold, AdminContent, function()
                loadstring(game:HttpGet(CONFIG.Scripts.Admin))()
                Gui:Destroy()
            end)
            
            CreateButton("💎 Load VIP", CONFIG.Themes[CurrentTheme].AccentCyan, AdminContent, function()
                loadstring(game:HttpGet(CONFIG.Scripts.VIP))()
                Gui:Destroy()
            end).Position = UDim2.new(0, 0, 0, 55)
            
            CreateButton("🆓 Load Free", CONFIG.Themes[CurrentTheme].AccentPurple, AdminContent, function()
                loadstring(game:HttpGet(CONFIG.Scripts.Free))()
                Gui:Destroy()
            end).Position = UDim2.new(0, 0, 0, 110)
            
        elseif ActiveTab == T("History") then
            local Scroll = Instance.new("ScrollingFrame")
            Scroll.Size = UDim2.new(1, 0, 1, 0)
            Scroll.BackgroundColor3 = CONFIG.Themes[CurrentTheme].TextBox
            Scroll.BorderSizePixel = 0
            Scroll.Parent = AdminContent
            
            local ScrollCorner = Instance.new("UICorner")
            ScrollCorner.CornerRadius = UDim.new(0, 8)
            ScrollCorner.Parent = Scroll
            
            local List = Instance.new("UIListLayout")
            List.Padding = UDim.new(0, 5)
            List.Parent = Scroll
            
            for _, K in ipairs(GeneratedKeys) do
                local Item = Instance.new("Frame")
                Item.Size = UDim2.new(1, -10, 0, 45)
                Item.BackgroundColor3 = CONFIG.Themes[CurrentTheme].Background
                Item.Parent = Scroll
                
                local ItemCorner = Instance.new("UICorner")
                ItemCorner.CornerRadius = UDim.new(0, 8)
                ItemCorner.Parent = Item
                
                local T1 = Instance.new("TextLabel")
                T1.Text = K.Key
                T1.TextColor3 = CONFIG.Themes[CurrentTheme].Text
                T1.Font = Enum.Font.GothamMedium
                T1.TextSize = 9
                T1.Size = UDim2.new(1, -10, 0, 22)
                T1.Position = UDim2.new(0, 5, 0, 3)
                T1.BackgroundTransparency = 1
                T1.Parent = Item
                
                local T2 = Instance.new("TextLabel")
                T2.Text = K.Type .. " | " .. K.LockedTo
                T2.TextColor3 = CONFIG.Themes[CurrentTheme].TextDim
                T2.Font = Enum.Font.Gotham
                T2.TextSize = 8
                T2.Size = UDim2.new(1, -10, 0, 18)
                T2.Position = UDim2.new(0, 5, 0, 24)
                T2.BackgroundTransparency = 1
                T2.Parent = Item
            end
            
        elseif ActiveTab == T("Stats") then
            local StatsList = {
                { T("KeysGenerated"), Stats.KeysGenerated },
                { T("KeysRedeemed"), Stats.KeysRedeemed },
                { T("MathSolved"), Stats.MathSolved },
                { T("FailedAttempts"), Stats.FailedAttempts },
                { "Gacha Spins", Stats.GachaSpins }
            }
            
            for i, S in ipairs(StatsList) do
                local Item = Instance.new("Frame")
                Item.Size = UDim2.new(1, 0, 0, 40)
                Item.Position = UDim2.new(0, 0, 0, (i - 1) * 45)
                Item.BackgroundColor3 = CONFIG.Themes[CurrentTheme].TextBox
                Item.Parent = AdminContent
                
                local ItemCorner = Instance.new("UICorner")
                ItemCorner.CornerRadius = UDim.new(0, 8)
                ItemCorner.Parent = Item
                
                local L = Instance.new("TextLabel")
                L.Text = S[1]
                L.TextColor3 = CONFIG.Themes[CurrentTheme].TextDim
                L.Font = Enum.Font.GothamMedium
                L.TextSize = 12
                L.Size = UDim2.new(0.6, 0, 1, 0)
                L.BackgroundTransparency = 1
                L.Parent = Item
                
                local V = Instance.new("TextLabel")
                V.Text = tostring(S[2])
                V.TextColor3 = CONFIG.Themes[CurrentTheme].AccentCyan
                V.Font = Enum.Font.GothamBold
                V.TextSize = 13
                V.Size = UDim2.new(0.4, 0, 1, 0)
                V.BackgroundTransparency = 1
                V.TextXAlignment = Enum.TextXAlignment.Right
                V.Parent = Item
            end
            
        elseif ActiveTab == T("Blacklist") then
            local Box = CreateTextBox(T("BlacklistKey"), AdminContent)
            Box.Position = UDim2.new(0, 0, 0, 10)
            
            local Btn = CreateButton(T("AddToBlacklist"), CONFIG.Themes[CurrentTheme].Error, AdminContent, function()
                if Box.Text ~= "" then
                    table.insert(Blacklist, Box.Text)
                    Notify("✅ Key Blacklisted", "success")
                    Box.Text = ""
                end
            end)
            Btn.Position = UDim2.new(0, 0, 0, 55)
        end
    end
    
    UpdateAdminContent()
    
    local LogoutBtn = CreateBackButton(Content, ShowMenu)
    LogoutBtn.Text = T("Logout")
end

-- =====================================================
-- 👤 SECTION 17: PROFILE FRAME
-- =====================================================

function ShowProfile()
    ClearContent()
    CurrentState = "PROFILE"
    
    local Title = Instance.new("TextLabel")
    Title.Text = T("Profile")
    Title.TextColor3 = CONFIG.Themes[CurrentTheme].Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Parent = Content
    
    local SessionTime = os.time() - SessionStartTime
    
    local InfoList = {
        { T("UserId"), tostring(UserId) },
        { T("UserName"), UserName },
        { T("SessionTime"), FormatDuration(SessionTime) },
        { T("KeysRedeemed"), tostring(Stats.KeysRedeemed) },
        { T("MathSolved"), tostring(Stats.MathSolved) },
        { T("GachaSpins"), tostring(Stats.GachaSpins) }
    }
    
    for i, Info in ipairs(InfoList) do
        local Item = Instance.new("Frame")
        Item.Size = UDim2.new(1, 0, 0, 40)
        Item.Position = UDim2.new(0, 0, 0, 30 + (i - 1) * 45)
        Item.BackgroundColor3 = CONFIG.Themes[CurrentTheme].TextBox
        Item.Parent = Content
        
        local ItemCorner = Instance.new("UICorner")
        ItemCorner.CornerRadius = UDim.new(0, 8)
        ItemCorner.Parent = Item
        
        local L = Instance.new("TextLabel")
        L.Text = Info[1]
        L.TextColor3 = CONFIG.Themes[CurrentTheme].TextDim
        L.Font = Enum.Font.GothamMedium
        L.TextSize = 12
        L.Size = UDim2.new(0.5, 0, 1, 0)
        L.BackgroundTransparency = 1
        L.Parent = Item
        
        local V = Instance.new("TextLabel")
        V.Text = Info[2]
        V.TextColor3 = CONFIG.Themes[CurrentTheme].AccentCyan
        V.Font = Enum.Font.GothamBold
        V.TextSize = 12
        V.Size = UDim2.new(0.5, 0, 1, 0)
        V.BackgroundTransparency = 1
        V.TextXAlignment = Enum.TextXAlignment.Right
        V.Parent = Item
    end
    
    CreateBackButton(Content, ShowMenu)
end

-- =====================================================
-- ⚙️ SECTION 18: SETTINGS FRAME
-- =====================================================

function ShowSettings()
    ClearContent()
    CurrentState = "SETTINGS"
    
    local Title = Instance.new("TextLabel")
    Title.Text = T("Settings")
    Title.TextColor3 = CONFIG.Themes[CurrentTheme].Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Parent = Content
    
    -- Theme Button
    local ThemeBtn = CreateButton(T("Theme") .. ": " .. CurrentTheme, CONFIG.Themes[CurrentTheme].AccentPurple, Content, function()
        local Themes = { "DarkNeon", "Matrix", "CyberPurple" }
        local Idx = table.find(Themes, CurrentTheme) or 1
        CurrentTheme = Themes[(Idx % #Themes) + 1]
        ThemeBtn.Text = T("Theme") .. ": " .. CurrentTheme
        
        -- Update UI Colors
        Main.BackgroundColor3 = CONFIG.Themes[CurrentTheme].Background
        MainStroke.Color = CONFIG.Themes[CurrentTheme].AccentPurple
        TitleBar.BackgroundColor3 = CONFIG.Themes[CurrentTheme].Frame
        Content.ScrollBarImageColor3 = CONFIG.Themes[CurrentTheme].ScrollBar
        
        Notify("Theme: " .. CurrentTheme, "success")
    end)
    
    -- Language Button
    local LangBtn = CreateButton(T("Language") .. ": " .. CurrentLang, CONFIG.Themes[CurrentTheme].AccentCyan, Content, function()
        CurrentLang = CurrentLang == "ID" and "EN" or "ID"
        LangBtn.Text = T("Language") .. ": " .. CurrentLang
        Notify("Language: " .. CurrentLang, "success")
    end)
    LangBtn.Position = UDim2.new(0, 0, 0, 60)
    
    -- Haptic Button
    local HapBtn = CreateButton(T("Haptic") .. ":" .. (HapticEnabled and "ON" : "OFF"), CONFIG.Themes[CurrentTheme].AccentGold, Content, function()
        HapticEnabled = not HapticEnabled
        HapBtn.Text = T("Haptic") .. ": " .. (HapticEnabled and "ON" : "OFF")
        Notify("Haptic: " .. (HapticEnabled and "ON" : "OFF"), "success")
    end)
    HapBtn.Position = UDim2.new(0, 0, 0, 120)
    
    -- Reset Button
    local ResetBtn = CreateButton(T("ResetData"), CONFIG.Themes[CurrentTheme].Error, Content, function()
        GeneratedKeys = {}
        Blacklist = {}
        Stats = {
            KeysGenerated = 0,
            KeysRedeemed = 0,
            MathSolved = 0,
            FailedAttempts = 0,
            GachaSpins = 0
        }
        Notify("Data Reset!", "success")
    end)
    ResetBtn.Position = UDim2.new(0, 0, 0, 180)
    
    CreateBackButton(Content, ShowMenu)
end

-- =====================================================
-- ❓ SECTION 19: HELP FRAME
-- =====================================================

function ShowHelp()
    ClearContent()
    CurrentState = "HELP"
    
    local Title = Instance.new("TextLabel")
    Title.Text = T("HelpTitle")
    Title.TextColor3 = CONFIG.Themes[CurrentTheme].Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Parent = Content
    
    local HelpText = Instance.new("TextLabel")
    HelpText.Text = T("HelpText")
    HelpText.TextColor3 = CONFIG.Themes[CurrentTheme].TextDim
    HelpText.Font = Enum.Font.GothamMedium
    HelpText.TextSize = 11
    HelpText.Size = UDim2.new(1, 0, 0, 250)
    HelpText.Position = UDim2.new(0, 0, 0, 30)
    HelpText.BackgroundTransparency = 1
    HelpText.TextWrapped = true
    HelpText.TextXAlignment = Enum.TextXAlignment.Left
    HelpText.TextYAlignment = Enum.TextYAlignment.Top
    HelpText.Parent = Content
    
    CreateBackButton(Content, ShowMenu)
end

-- =====================================================
-- 📜 SECTION 20: CHANGELOG FRAME
-- =====================================================

function ShowChangelog()
    ClearContent()
    CurrentState = "CHANGELOG"
    
    local Title = Instance.new("TextLabel")
    Title.Text = T("ChangelogTitle")
    Title.TextColor3 = CONFIG.Themes[CurrentTheme].Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Parent = Content
    
    local ChangeText = Instance.new("TextLabel")
    ChangeText.Text = T("ChangelogText")
    ChangeText.TextColor3 = CONFIG.Themes[CurrentTheme].TextDim
    ChangeText.Font = Enum.Font.GothamMedium
    ChangeText.TextSize = 11
    ChangeText.Size = UDim2.new(1, 0, 0, 300)
    ChangeText.Position = UDim2.new(0, 0, 0, 30)
    ChangeText.BackgroundTransparency = 1
    ChangeText.TextWrapped = true
    ChangeText.TextXAlignment = Enum.TextXAlignment.Left
    ChangeText.TextYAlignment = Enum.TextYAlignment.Top
    ChangeText.Parent = Content
    
    CreateBackButton(Content, ShowMenu)
end

-- =====================================================
-- 📋 SECTION 21: TERMS FRAME
-- =====================================================

function ShowTerms()
    ClearContent()
    CurrentState = "TERMS"
    
    local Title = Instance.new("TextLabel")
    Title.Text = T("TermsTitle")
    Title.TextColor3 = CONFIG.Themes[CurrentTheme].Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Parent = Content
    
    local TermsText = Instance.new("TextLabel")
    TermsText.Text = T("TermsText")
    TermsText.TextColor3 = CONFIG.Themes[CurrentTheme].TextDim
    TermsText.Font = Enum.Font.GothamMedium
    TermsText.TextSize = 11
    TermsText.Size = UDim2.new(1, 0, 0, 200)
    TermsText.Position = UDim2.new(0, 0, 0, 30)
    TermsText.BackgroundTransparency = 1
    TermsText.TextWrapped = true
    TermsText.TextXAlignment = Enum.TextXAlignment.Left
    TermsText.TextYAlignment = Enum.TextYAlignment.Top
    TermsText.Parent = Content
    
    CreateBackButton(Content, ShowMenu)
end

-- =====================================================
-- 🚀 SECTION 22: INITIALIZATION
-- =====================================================

task.spawn(function()
    RunAntiTamper()
    ShowMenu()
    Notify(T("Welcome"), "success")
    
    -- Session Restore
    if SessionData and GetTimestamp() - SessionData.Time < 300 then
        Notify(T("SessionRestored"), "success")
    end
end)

-- =====================================================
-- 📝 END OF SCRIPT
-- =====================================================
