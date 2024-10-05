local Settings = {
    Fly = "F",
    ToggleESP = "U",
    FullESP = "L",
    ESP_RADIUS = 500,
    ToggleUI = "K",
    ToggleGodMode = "G",
    ToggleUnlimitedAmmo = "H",
    IncreaseFlySpeed = "R",
    DecreaseFlySpeed = "T",
    SpectatePlayer = "Y",
    TeleportToPlayer = "P"
}
local Flying = false
local FlySpeed = 50
local FlyBodyGyro, FlyBodyVelocity
local ESPEnabled = false
local ESPBoxes = {}
local ESPNamesEnabled = false
local ESPNameLabels = {}
local ESPLinesEnabled = false
local ESPLines = {}
local spectateTarget = nil
local spectateConnection = nil
local SpeedfireEnabled = false
local fastFireRate = 0.05
local isUIVisible = true
local godModeEnabled = false

local scversion = "v1.444"
local extendedname = "DarkPulse System X"

-------------------Meine Whitelist--------------------
local allowedWeapons = {
    "AK47",
    "Makarov",
    "SniperRifle",
    "Shotgun"
}

----------------------------------MESSAGE CREATOR--------------------------
local function createmessage(title, text, icon)
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = title or "NOTITLE",
        Text = text or "NOMESSAGE",
        Icon = icon or "rbxassetid://1234567890"
    })
end

-------------STARTUP-----------------
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

if game.CoreGui:FindFirstChild("CheatUI") then
    local awdwipaoihd = extendedname
    local oahwamdkwjha = "REINJECTING! PLEASE WAIT"

    Flying = false
    RunService:UnbindFromRenderStep("Fly")
    if FlyBodyGyro then FlyBodyGyro:Destroy() end
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CanCollide = true
    end
    
    game.CoreGui.CheatUI:Destroy()
    createmessage(awdwipaoihd, oahwamdkwjha)
end

local function injector()
    createmessage(extendedname, scversion)
    createmessage(extendedname, "Please Wait 5 Seconds, it inject automatically")
    wait(5)
end

injector()

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.Enabled = true

-- Create MainFrame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Styling the MainFrame with CornerRadius and Shadow
local cornerRadius = Instance.new("UICorner")
cornerRadius.CornerRadius = UDim.new(0, 15)
cornerRadius.Parent = MainFrame

local shadow = Instance.new("Frame")
shadow.Size = MainFrame.Size + UDim2.new(0, 15, 0, 15)
shadow.Position = UDim2.new(0.5, -315, 0.5, -215)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.85
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = ScreenGui

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 15)
shadowCorner.Parent = shadow

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 15)
shadowCorner.Parent = shadow

-- Create TitleBar Frame (for Title and Logo)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)  -- Eine Höhe von 50 für den Titel und das Logo
TitleBar.Position = UDim2.new(0, 0, 0, 0)  -- Oben im MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- Styling the TitleBar with rounded corners
local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 15)
titleBarCorner.Parent = TitleBar

-- Logo hinzufügen (auf der linken Seite der Titelbar)
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 40, 0, 40)  -- Das Logo hat eine Höhe von 40 (gleich der Titelhöhe)
Logo.Position = UDim2.new(0, 5, 0.5, -20)  -- Leicht nach innen eingerückt, vertikal zentriert
Logo.BackgroundTransparency = 1  -- Keine Hintergrundfarbe für das Logo
Logo.Image = "rbxassetid://131164521981506"  -- Verwende die tatsächliche Asset-ID deines Logos
Logo.Parent = TitleBar

-- Title hinzufügen (rechts neben dem Logo)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)  -- Platz für das Logo freihalten
Title.Position = UDim2.new(0, 60, 0, 0)  -- Verschiebt den Titel, damit das Logo Platz hat
Title.BackgroundTransparency = 1  -- Kein Hintergrund für den Titeltext
Title.Text = "DarkPulse - NBTF System"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold
Title.Parent = TitleBar

-- Create Sidebar for Tabs
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 15)
sidebarCorner.Parent = Sidebar

-- Tabs in Sidebar
local Tabs = {"Main", "Visuals", "Rage", "Players", "Settings"}
local TabButtons = {}
local TabFrames = {}

local buttonYOffset = 10
for _, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.9, 0, 0, 40)
    TabButton.Position = UDim2.new(0.05, 0, 0, buttonYOffset)
    TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Font = Enum.Font.SourceSans
    TabButton.TextSize = 18
    TabButton.Parent = Sidebar
    TabButtons[tabName] = TabButton

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = TabButton

    buttonYOffset = buttonYOffset + 50

    -- Create Frame for Tab Content
    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, -150, 1, -40)
    TabFrame.Position = UDim2.new(0, 150, 0, 40)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = false
    TabFrame.Parent = MainFrame
    TabFrames[tabName] = TabFrame

    TabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        TabFrame.Visible = true

        -- Animation for button when selected
        for _, button in pairs(TabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end)
end

-- Adding Content for Main Tab
local MainContent = TabFrames["Main"]

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0.6, 0, 0, 50)
FlyButton.Position = UDim2.new(0.2, 0, 0.1, 0)
FlyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyButton.Text = "Fly: OFF"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Font = Enum.Font.SourceSans
FlyButton.TextSize = 18
FlyButton.Parent = MainContent

local flyButtonCorner = Instance.new("UICorner")
flyButtonCorner.CornerRadius = UDim.new(0, 10)
flyButtonCorner.Parent = FlyButton

local FlySpeedTextBox = Instance.new("TextBox")
FlySpeedTextBox.Size = UDim2.new(0.6, 0, 0, 50)
FlySpeedTextBox.Position = UDim2.new(0.2, 0, 0.3, 10)
FlySpeedTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlySpeedTextBox.Text = "Enter Fly Speed (5 - 400)"
FlySpeedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
FlySpeedTextBox.Font = Enum.Font.SourceSans
FlySpeedTextBox.TextSize = 18
FlySpeedTextBox.Parent = MainContent

local flySpeedCorner = Instance.new("UICorner")
flySpeedCorner.CornerRadius = UDim.new(0, 10)
flySpeedCorner.Parent = FlySpeedTextBox

-- Adding Content for Visuals Tab
local VisualsContent = TabFrames["Visuals"]

local ESPNamesButton = Instance.new("TextButton")
ESPNamesButton.Size = UDim2.new(0.6, 0, 0, 50)
ESPNamesButton.Position = UDim2.new(0.2, 0, 0.1, 0)
ESPNamesButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPNamesButton.Text = "ESP Names: OFF"
ESPNamesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPNamesButton.Font = Enum.Font.SourceSans
ESPNamesButton.TextSize = 18
ESPNamesButton.Parent = VisualsContent

local espNamesCorner = Instance.new("UICorner")
espNamesCorner.CornerRadius = UDim.new(0, 10)
espNamesCorner.Parent = ESPNamesButton

local ESPBoxButton = Instance.new("TextButton")
ESPBoxButton.Size = UDim2.new(0.6, 0, 0, 50)
ESPBoxButton.Position = UDim2.new(0.2, 0, 0.3, 10)
ESPBoxButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPBoxButton.Text = "ESP Box: OFF"
ESPBoxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBoxButton.Font = Enum.Font.SourceSans
ESPBoxButton.TextSize = 18
ESPBoxButton.Parent = VisualsContent

-- Adding corner radius for ESPBoxButton
local espBoxButtonCorner = Instance.new("UICorner")
espBoxButtonCorner.CornerRadius = UDim.new(0, 10)
espBoxButtonCorner.Parent = ESPBoxButton

local ESPLinesButton = Instance.new("TextButton")
ESPLinesButton.Size = UDim2.new(0.6, 0, 0, 50)
ESPLinesButton.Position = UDim2.new(0.2, 0, 0.5, 20)  -- Unterhalb des ESPBoxButton
ESPLinesButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPLinesButton.Text = "ESP Lines: OFF"
ESPLinesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPLinesButton.Font = Enum.Font.SourceSans
ESPLinesButton.TextSize = 18
ESPLinesButton.Parent = VisualsContent

-- Adding corner radius for ESPLinesButton
local espLinesButtonCorner = Instance.new("UICorner")
espLinesButtonCorner.CornerRadius = UDim.new(0, 10)
espLinesButtonCorner.Parent = ESPLinesButton

-- Adding Content for Rage Tab
local RageContent = TabFrames["Rage"]

local HitboxSizeSlider = Instance.new("TextBox")
HitboxSizeSlider.Size = UDim2.new(0.6, 0, 0, 50)
HitboxSizeSlider.Position = UDim2.new(0.2, 0, 0.1, 0)
HitboxSizeSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HitboxSizeSlider.Text = "Hitbox Size (1 - 20)"
HitboxSizeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
HitboxSizeSlider.Font = Enum.Font.SourceSans
HitboxSizeSlider.TextSize = 18
HitboxSizeSlider.Parent = RageContent

local hitboxSliderCorner = Instance.new("UICorner")
hitboxSliderCorner.CornerRadius = UDim.new(0, 10)
hitboxSliderCorner.Parent = HitboxSizeSlider

local UnlimitedAmmoButton = Instance.new("TextButton")
UnlimitedAmmoButton.Size = UDim2.new(0.6, 0, 0, 50)
UnlimitedAmmoButton.Position = UDim2.new(0.2, 0, 0.3, 10)
UnlimitedAmmoButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
UnlimitedAmmoButton.Text = "Unlimited Ammo: OFF"
UnlimitedAmmoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UnlimitedAmmoButton.Font = Enum.Font.SourceSans
UnlimitedAmmoButton.TextSize = 18
UnlimitedAmmoButton.Parent = RageContent

local ammoButtonCorner = Instance.new("UICorner")
ammoButtonCorner.CornerRadius = UDim.new(0, 10)
ammoButtonCorner.Parent = UnlimitedAmmoButton

local SpeedfireButton = Instance.new("TextButton")
SpeedfireButton.Size = UDim2.new(0.6, 0, 0, 50)
SpeedfireButton.Position = UDim2.new(0.2, 0, 0.5, 20) -- Position unter dem HitboxSizeSlider
SpeedfireButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedfireButton.Text = "Speedfire: OFF"
SpeedfireButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedfireButton.Font = Enum.Font.SourceSans
SpeedfireButton.TextSize = 18
SpeedfireButton.Parent = RageContent

-- Adding corner radius for SpeedfireButton
local speedfireButtonCorner = Instance.new("UICorner")
speedfireButtonCorner.CornerRadius = UDim.new(0, 10)
speedfireButtonCorner.Parent = SpeedfireButton

-- Adding Content for Players Tab
local PlayersContent = TabFrames["Players"]

local PlayersList = Instance.new("ScrollingFrame")
PlayersList.Size = UDim2.new(0.9, 0, 0.8, 0)
PlayersList.Position = UDim2.new(0.05, 0, 0.1, 0)
PlayersList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayersList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayersList.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
PlayersList.BorderSizePixel = 0
PlayersList.Parent = PlayersContent

-- ScrollFrame Abrundung
local playersListCorner = Instance.new("UICorner")
playersListCorner.CornerRadius = UDim.new(0, 10)
playersListCorner.Parent = PlayersList

-- Adding Content for Settings Tab
local SettingsContent = TabFrames["Settings"]

local GodModeButton = Instance.new("TextButton")
GodModeButton.Size = UDim2.new(0.6, 0, 0, 50)
GodModeButton.Position = UDim2.new(0.2, 0, 0.1, 0)
GodModeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GodModeButton.Text = "GodMode: OFF"
GodModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GodModeButton.Font = Enum.Font.SourceSans
GodModeButton.TextSize = 18
GodModeButton.Parent = SettingsContent

local godModeCorner = Instance.new("UICorner")
godModeCorner.CornerRadius = UDim.new(0, 10)
godModeCorner.Parent = GodModeButton

local GiveWeaponsButton = Instance.new("TextButton")
GiveWeaponsButton.Size = UDim2.new(0.6, 0, 0, 50)
GiveWeaponsButton.Position = UDim2.new(0.2, 0, 0.3, 10)
GiveWeaponsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GiveWeaponsButton.Text = "Give All Weapons"
GiveWeaponsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GiveWeaponsButton.Font = Enum.Font.SourceSans
GiveWeaponsButton.TextSize = 18
GiveWeaponsButton.Parent = SettingsContent

local giveWeaponsCorner = Instance.new("UICorner")
giveWeaponsCorner.CornerRadius = UDim.new(0, 10)
giveWeaponsCorner.Parent = GiveWeaponsButton

local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
    shadow.Position = MainFrame.Position + UDim2.new(0, 5, 0, 5)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

----------------------Animation Creator
local function resetUICorners()
    local elements = {MainFrame, shadow, TitleBar, Sidebar}
    for _, element in ipairs(elements) do
        if element:FindFirstChild("UICorner") then
            element.UICorner.CornerRadius = UDim.new(0, 15)
        end
    end
end

function fadeInUI(duration)
    resetUICorners()  -- Stelle sicher, dass die CornerRadius-Werte korrekt sind
    ScreenGui.Enabled = true
    local descendants = ScreenGui:GetDescendants()
    for _, element in ipairs(descendants) do
        if element:IsA("Frame") or element:IsA("ImageLabel") then
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local goal = {BackgroundTransparency = 0.1}
            local tween = TweenService:Create(element, tweenInfo, goal)
            tween:Play()
        elseif element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local goal = {TextTransparency = 0, BackgroundTransparency = 0.1}
            local tween = TweenService:Create(element, tweenInfo, goal)
            tween:Play()
        end
    end
end

-- Fade Out Funktion
function fadeOutUI(duration)
    local descendants = ScreenGui:GetDescendants()
    for _, element in ipairs(descendants) do
        if element:IsA("Frame") or element:IsA("ImageLabel") then
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local goal = {BackgroundTransparency = 1}  -- Komplett transparent machen
            local tween = TweenService:Create(element, tweenInfo, goal)
            tween:Play()
        elseif element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local goal = {TextTransparency = 1, BackgroundTransparency = 1}  -- Text und Hintergrund transparent machen
            local tween = TweenService:Create(element, tweenInfo, goal)
            tween:Play()
        end
    end
    -- Nach der Animation das UI deaktivieren, um sicherzustellen, dass es ausgeblendet bleibt
    delay(duration, function()
        ScreenGui.Enabled = false
    end)
end

local function resetTransparency()
    local descendants = ScreenGui:GetDescendants()
    for _, element in ipairs(descendants) do
        if element:IsA("Frame") or element:IsA("ImageLabel") then
            element.BackgroundTransparency = 0.1  -- Setze den gewünschten Ursprungswert
        elseif element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
            element.TextTransparency = 0
            element.BackgroundTransparency = 0.1
        end
    end
end
----------------------FUNKTIONEN-----------------------
------------FLY
local function toggleFly()
    if not FlyButton then
        warn("FlyButton ist nicht initialisiert.")
        return
    end
    print("Fly on")

    Flying = not Flying

    if Flying then
        FlyButton.Text = "Fly: ON"

        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end

        FlyBodyGyro = Instance.new("BodyGyro")
        FlyBodyGyro.P = 9e4
        FlyBodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
        FlyBodyGyro.CFrame = workspace.CurrentCamera.CFrame
        FlyBodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart

        FlyBodyVelocity = Instance.new("BodyVelocity")
        FlyBodyVelocity.Velocity = Vector3.zero
        FlyBodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        FlyBodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart

        local function updateFly()
            if not Flying then return end

            local cam = workspace.CurrentCamera
            local direction = Vector3.zero

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + cam.CFrame.RightVector
            end

            FlyBodyVelocity.Velocity = direction * FlySpeed
            FlyBodyGyro.CFrame = cam.CFrame

            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end

        RunService:BindToRenderStep("Fly", Enum.RenderPriority.Character.Value, updateFly)
    else
        FlyButton.Text = "Fly: OFF"

        if FlyBodyGyro then FlyBodyGyro:Destroy() end
        if FlyBodyVelocity then FlyBodyVelocity:Destroy() end

        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end

        RunService:UnbindFromRenderStep("Fly")
    end
end

function adjustFlySpeed()
    local inputSpeed = tonumber(FlySpeedTextBox.Text)
    if inputSpeed and inputSpeed >= 5 and inputSpeed <= 400 then
        FlySpeed = inputSpeed
        print("Fluggeschwindigkeit angepasst auf:", FlySpeed)
    else
        FlySpeedTextBox.Text = "Enter Fly Speed (5 - 400)" -- Ungültige Eingabe, Standardtext zurücksetzen
        print("Ungültige Eingabe. Fluggeschwindigkeit bleibt bei:", FlySpeed)
    end
end

FlyButton.MouseButton1Click:Connect(toggleFly)
    FlySpeedTextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            adjustFlySpeed()
        else
            FlySpeedTextBox.Text = "Enter Fly Speed (5 - 400)"
        end
    end)

-------------SPEEDFIRE
local function toggleSpeedfire()
    SpeedfireEnabled = not SpeedfireEnabled
    SpeedfireButton.Text = SpeedfireEnabled and "Speedfire: ON" or "Speedfire: OFF"

    if SpeedfireEnabled then
        print("Speedfire aktiviert")
        task.spawn(function()
            while SpeedfireEnabled do
                if LocalPlayer.Character then
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Handle") then  -- Sicherstellen, dass das Tool eine Waffe ist
                        -- Argumente für das Schießen vorbereiten
                        local args = {
                            [1] = tool,
                            [2] = {
                                ["id"] = 12,  -- Beispielhafte ID für die Kugel
                                ["charge"] = 0,
                                ["dir"] = Vector3.new(-0.9485447406768799, -0.18350273370742798, 0.2580493092536926),
                                ["origin"] = tool.Handle.Position  -- Ursprungsposition des Schusses
                            }
                        }

                        -- WeaponFired Event auslösen
                        game:GetService("ReplicatedStorage").WeaponsSystem.Network.WeaponFired:FireServer(unpack(args))
                    end
                end
                task.wait(fastFireRate) -- Wartezeit für die schnelle Feuerrate
            end
        end)
    else
        print("Speedfire deaktiviert")
    end
end
SpeedfireButton.MouseButton1Click:Connect(toggleSpeedfire)
--------------------------------------ESP BOXES-----------------------------
function createESPBox(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    print("Gut")
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

    local box = Instance.new("BoxHandleAdornment")
    box.Size = humanoidRootPart.Size + Vector3.new(1, 3, 1)
    box.Adornee = humanoidRootPart
    box.Color3 = Color3.fromRGB(0, 255, 0)
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Transparency = 0.5
    box.Parent = humanoidRootPart

    local glowBox = Instance.new("BoxHandleAdornment")
    glowBox.Size = humanoidRootPart.Size + Vector3.new(1.5, 3.5, 1.5) 
    glowBox.Adornee = humanoidRootPart
    glowBox.Color3 = Color3.fromRGB(0, 255, 255)
    glowBox.AlwaysOnTop = true
    glowBox.ZIndex = 9
    glowBox.Transparency = 0.8
    glowBox.Parent = humanoidRootPart

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = humanoidRootPart
    billboard.Size = UDim2.new(4, 0, 1, 0)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = humanoidRootPart

    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14

    ESPBoxes[player] = {box = box, glowBox = glowBox, billboard = billboard}

    character:WaitForChild("HumanoidRootPart").AncestryChanged:Connect(function(_, parent)
        if not parent then
            removeESPBox(player)
        end
    end)
end

function removeESPBox(player)
    print("Entfernt")
    if ESPBoxes[player] then
        for _, component in pairs(ESPBoxes[player]) do
            if component then
                component:Destroy()
            end
        end
        ESPBoxes[player] = nil
    end
end

function toggleESPBox()
    ESPEnabled = not ESPEnabled
    ESPBoxButton.Text = ESPEnabled and "ESP Box: ON" or "ESP Box: OFF"

    if ESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                createESPBox(player)
            end
        end

        Players.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(function()
                if ESPEnabled then
                    createESPBox(newPlayer)
                    print("An")
                end
            end)
        end)

    else
        for _, player in pairs(Players:GetPlayers()) do
            removeESPBox(player)
            print("Aus")
        end
    end
end
--Trigger
ESPBoxButton.MouseButton1Click:Connect(toggleESPBox)

Players.PlayerRemoving:Connect(function(leavingPlayer)
    removeESPBox(leavingPlayer)
end)

-------------------ESP NAMES----------------
function toggleESPNames()
    ESPNamesEnabled = not ESPNamesEnabled
    ESPNamesButton.Text = ESPNamesEnabled and "ESP Names: ON" or "ESP Names: OFF"

    if ESPNamesEnabled then
        -- Namen über Spielern anzeigen
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                createESPName(player)
            end
        end

        -- Spieler-Eintritt überwachen, um neuen Spielern Namen hinzuzufügen
        Players.PlayerAdded:Connect(function(newPlayer)
            if ESPNamesEnabled and newPlayer.Character and newPlayer.Character:FindFirstChild("Head") then
                createESPName(newPlayer)
            end
        end)
        
    else
        -- Namen ausschalten
        for _, nameLabel in pairs(ESPNameLabels) do
            if nameLabel then
                nameLabel:Destroy()
            end
        end
        ESPNameLabels = {}
    end
end
--Trigger
ESPNamesButton.MouseButton1Click:Connect(toggleESPNames)

function createESPName(player)
    if not player.Character or not player.Character:FindFirstChild("Head") then
        return
    end

    local head = player.Character.Head

    local nameLabel = Instance.new("BillboardGui")
    nameLabel.Adornee = head
    nameLabel.Size = UDim2.new(2, 0, 1, 0)
    nameLabel.StudsOffset = Vector3.new(0, 2, 0)
    nameLabel.AlwaysOnTop = true
    nameLabel.Parent = game.CoreGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.Name
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextScaled = true
    textLabel.Parent = nameLabel

    ESPNameLabels[player] = nameLabel

    -- Überwachen, ob der Spieler verschwindet
    player.Character.Humanoid.Died:Connect(function()
        if ESPNameLabels[player] then
            ESPNameLabels[player]:Destroy()
            ESPNameLabels[player] = nil
        end
    end)
end

--------------------------ESP LINES-----------------------
function toggleESPLines()
    ESPLinesEnabled = not ESPLinesEnabled

    if ESPLinesButton then
        ESPLinesButton.Text = ESPLinesEnabled and "ESP Lines: AN" or "ESP Lines: AUS"
    end

    if ESPLinesEnabled then
        addESPBeamsToAllPlayers()
    else
        removeAllESPBeams()
    end
end

local function createESPBeam(player)
    if player == LocalPlayer or not player.Character then
        return
    end

    local character = player.Character
    local lowerTorso = character:FindFirstChild("LowerTorso")
    local localCharacter = LocalPlayer.Character
    local localHumanoidRootPart = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

    if not lowerTorso or not localHumanoidRootPart then
        return
    end

    local startAttachment = Instance.new("Attachment")
    startAttachment.Position = Vector3.new(0, -2.5, 0)
    startAttachment.Parent = localHumanoidRootPart

    local endAttachment = Instance.new("Attachment")
    endAttachment.Position = Vector3.new(0, 0, 0)
    endAttachment.Parent = lowerTorso

    local beam = Instance.new("Beam")
    beam.Attachment0 = startAttachment
    beam.Attachment1 = endAttachment
    beam.FaceCamera = true
    beam.Width0 = 0.05
    beam.Width1 = 0.05
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    beam.Transparency = NumberSequence.new(0.2)
    beam.Parent = localHumanoidRootPart

    ESPLines[player.Name] = {beam = beam, startAttachment = startAttachment, endAttachment = endAttachment}

    local function updateBeam()
        if not player.Character or not lowerTorso:IsDescendantOf(Workspace) or not localCharacter:IsDescendantOf(Workspace) then
            beam.Enabled = false
            return
        end

        local distance = (localHumanoidRootPart.Position - lowerTorso.Position).Magnitude
        if distance > Settings.ESP_RADIUS then
            beam.Enabled = false
            return
        end

        local origin = localHumanoidRootPart.Position
        local direction = (lowerTorso.Position - origin).Unit * distance

        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {localCharacter, character} 
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.IgnoreWater = true

        local raycastResult = Workspace:Raycast(origin, direction, raycastParams)

        if raycastResult then
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
        else
            beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0))
        end

        beam.Enabled = true
    end

    RunService.RenderStepped:Connect(updateBeam)
end

ESPLinesButton.MouseButton1Click:Connect(toggleESPLines)

function addESPBeamsToAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESPBeam(player)
        end
    end

    Players.PlayerAdded:Connect(function(newPlayer)
        newPlayer.CharacterAdded:Connect(function()
            createESPBeam(newPlayer)
        end)
    end)
end

function removeAllESPBeams()
    for _, data in pairs(ESPLines) do
        if data.beam then
            data.beam:Destroy()
        end
        if data.startAttachment then
            data.startAttachment:Destroy()
        end
        if data.endAttachment then
            data.endAttachment:Destroy()
        end
    end
    ESPLines = {}
end

Players.PlayerRemoving:Connect(function(player)
    if ESPLines[player.Name] then
        local data = ESPLines[player.Name]
        if data.beam then data.beam:Destroy() end
        if data.startAttachment then data.startAttachment:Destroy() end
        if data.endAttachment then data.endAttachment:Destroy() end
        ESPLines[player.Name] = nil
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPLinesEnabled then
            createESPBeam(player)
        end
    end)
end)

-- Tasteneingabe abfangen und das UI ein- oder ausblenden
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end

    -- Toggle UI Sichtbarkeit
    if input.KeyCode == Enum.KeyCode[Settings.ToggleUI] then
        toggleUI(isUIVisible)
    end

    -- Fly aktivieren/deaktivieren
    if input.KeyCode == Enum.KeyCode[Settings.Fly] then
        toggleFly()
    end

    -- ESP ein/aus
    if input.KeyCode == Enum.KeyCode[Settings.ToggleESP] then
        toggleESPBox()
        toggleESPNames()
        toggleESPLines()
    end

    -- Alle ESP Features auf einmal aktivieren
    if input.KeyCode == Enum.KeyCode[Settings.FullESP] then
        toggleESPNames()
        toggleESPBox()
        toggleESPLines()
    end
end)

-------------------------------------------HITBOX CHANGER------------------------
HitboxSizeSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        adjustHitboxSize()
        print("Hitbox erweitert")
    else
        HitboxSizeSlider.Text = "Hitbox Size (1 - 20)" -- Setze den Standardtext zurück, wenn die Eingabe nicht abgeschlossen wurde
    end
end)

function adjustHitboxSize()
    local inputText = HitboxSizeSlider.Text
    print("Eingegebener Wert:", inputText)  -- Debugging-Ausgabe zur Überprüfung der Eingabe

    local inputSize = tonumber(inputText)  -- Versuch, die Eingabe in eine Zahl zu konvertieren

    if inputSize and inputSize >= 1 and inputSize <= 20 then
        print("Valide Eingabe erkannt. Ändere Hitbox-Größe auf:", inputSize)  -- Debugging-Ausgabe zur Überprüfung
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                adjustPlayerHitbox(player, inputSize)
            end
        end
    else
        print("Ungültige Eingabe:", inputText)  -- Debugging-Ausgabe, wenn die Eingabe nicht gültig ist
        HitboxSizeSlider.Text = "Hitbox Size (1 - 20)" -- Ungültige Eingabe, Standardtext zurücksetzen
    end
end

-- Hilfsfunktion zum Anpassen der Hitbox-Größe eines Spielers
function adjustPlayerHitbox(player, sizeMultiplier)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local character = player.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    -- Sichern der aktuellen Position und Verhindern von Umfallen
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.Anchored = true
    end

    humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    humanoid.PlatformStand = true

    -- Liste der relevanten Trefferzonen
    local hitboxParts = {"Head", "UpperTorso", "LowerTorso"}

    for _, partName in ipairs(hitboxParts) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            -- Ursprüngliche Größe speichern (wenn nicht bereits gespeichert)
            if not part:FindFirstChild("OriginalSize") then
                local originalSize = Instance.new("Vector3Value")
                originalSize.Name = "OriginalSize"
                originalSize.Value = part.Size
                originalSize.Parent = part
            end

            -- Hitbox-Größe anpassen
            part.CanCollide = false -- Deaktiviere Kollision vor der Anpassung
            part.Size = part:FindFirstChild("OriginalSize").Value * sizeMultiplier
            part.Massless = true  -- Keine physikalische Masse, damit Bewegungen nicht beeinträchtigt werden
            part.CanCollide = false -- Behalte CanCollide auf false, um Probleme zu verhindern

            -- Transparenz einstellen (z.B. 0.5 für Sichtbarkeit)
            part.Transparency = 0.5  
        end
    end

    -- Sicherstellen, dass sich der Spieler nicht verschiebt
    task.wait(0.1)

    -- Stelle sicher, dass der Charakter wieder frei beweglich ist
    if rootPart then
        rootPart.Anchored = false
    end

    humanoid.PlatformStand = false
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

    -- Setze eine angemessene Kollisionskontrolle zurück
    for _, partName in ipairs(hitboxParts) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.CanCollide = true -- Nach der Anpassung wieder auf True setzen, falls notwendig
        end
    end
end

-- Funktion zum Umschalten der Sichtbarkeit der Hitboxen (Debugging-Zwecke)
local function toggleHitboxVisibility()
    local visibilityState = false

    return function()
        visibilityState = not visibilityState
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local character = player.Character
                local hitboxParts = {"HumanoidRootPart", "Head", "Torso", "UpperTorso", "LowerTorso"}

                for _, partName in ipairs(hitboxParts) do
                    local part = character:FindFirstChild(partName)
                    if part and part:IsA("BasePart") then
                        part.Transparency = visibilityState and 0.5 or 1  -- 0.5, wenn sichtbar (für Debugging), ansonsten 1 (unsichtbar)
                    end
                end
            end
        end
    end
end

local function toggleUI()
    if isUIVisible then
        fadeOutUI(1.5)
        delay(1.5, function()
            ScreenGui.Enabled = false
            isUIVisible = false
        end)
    else
        resetTransparency()
        ScreenGui.Enabled = true
        fadeInUI(1.5)
        isUIVisible = true
    end
end

-----------------------------UNLIMITED AMMO---------------------------
local function autoReloadTool(tool)
    -- Sicherstellen, dass das Tool existiert und ein gültiges Tool ist
    if not tool or not tool:IsA("Tool") then
        return
    end

    -- Sicherstellen, dass das Tool in der Whitelist ist
    if not table.find(allowedWeapons, tool.Name) then
        return
    end

    -- Permanente Überwachung der Munition in einem separaten Thread
    task.spawn(function()
        while true do
            if tool and tool.Parent == LocalPlayer.Character then
                local currentAmmo = tool:FindFirstChild("CurrentAmmo")
                local ammoReserves = tool:FindFirstChild("AmmoReserves")

                -- Überprüfen, ob die Munition niedrig ist und ein Reload durchgeführt werden sollte
                if currentAmmo and currentAmmo.Value <= 10 then
                    -- Reload-Request an den Server senden
                    local args = {
                        [1] = tool
                    }
                    game:GetService("ReplicatedStorage").WeaponsSystem.Network.WeaponReloadRequest:FireServer(unpack(args))
                    print("Reload Request gesendet für Waffe: " .. tool.Name)

                    -- Setze Munition auf hohe Werte clientseitig für schnelleres Feedback
                    currentAmmo.Value = 100000 -- Setze Munition auf extrem hohen Wert
                    if ammoReserves then
                        ammoReserves.Value = 999999 -- Setze die Reserves ebenfalls auf hohen Wert
                    end
                end
            end
            -- Sehr kurze Pause zwischen den Überprüfungen, um die Performance nicht zu beeinträchtigen
            task.wait(0.1)
        end
    end)
end

-- Überwachung des Charakters des Spielers und Verwalten der Tools
LocalPlayer.CharacterAdded:Connect(function(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            autoReloadTool(child)
        end
    end)

    -- Eventuell existierende Tools direkt nach Character Spawn überwachen
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            autoReloadTool(tool)
        end
    end
end)

-- Überwachung des Backpacks des Spielers, falls Waffen dort abgelegt werden
LocalPlayer.Backpack.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        autoReloadTool(child)
    end
end)

-- Falls der Character des Spielers bereits existiert, direkt die Tools überwachen
if LocalPlayer.Character then
    for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") then
            autoReloadTool(tool)
        end
    end
end
--Trigger
UnlimitedAmmoButton.MouseButton1Click:Connect(autoReloadTool)

------------------------------------------------GODMODE
local function enableGodMode()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then
        warn("GodMode konnte nicht aktiviert werden, da der Charakter oder der Humanoid fehlt.")
        return
    end

    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")

    -- Wechsel des Status von God Mode
    godModeEnabled = not godModeEnabled

    if godModeEnabled then
        print("God Mode aktiviert")
        humanoid.Health = humanoid.MaxHealth
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if godModeEnabled then
                humanoid.Health = humanoid.MaxHealth  -- Setzt die Gesundheit auf Maximum, wenn sie sich ändert
            end
        end)

        -- Optional: Füge einen Label an, der dem Spieler sagt, dass der God Mode aktiv ist
        createmessage("God Mode", "God Mode ist jetzt aktiviert!")
    else
        print("God Mode deaktiviert")
        -- Möglicherweise alle Signalverbindungen entfernen, falls vorhanden
        humanoid.Health = humanoid.MaxHealth  -- Setzt die Gesundheit auf Normal zurück
        createmessage("God Mode", "God Mode ist jetzt deaktiviert!")
    end
end
--Trigger
GodModeButton.MouseButton1Click:Connect(enableGodMode)
-----------------------------------------------giveAllWeapons
local function giveAllWeapons()
    print("-- Implementierung wird später hinzugefügt")
end
--Trigger
GiveWeaponsButton.MouseButton1Click:Connect(giveAllWeapons)

--------------------------------------------PLAYER LIST FUNCTIONS--------------------
local function stopSpectate()
    if spectateConnection then
        spectateConnection:Disconnect()
        spectateConnection = nil
    end
    spectateTarget = nil
    workspace.CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
end

local function spectatePlayer(player)
    stopSpectate()  -- Beende einen eventuell bestehenden Spectate-Modus

    if player.Character and player.Character:FindFirstChild("Humanoid") then
        spectateTarget = player
        workspace.CurrentCamera.CameraSubject = player.Character.Humanoid

        spectateConnection = player.CharacterRemoving:Connect(function()
            stopSpectate()  -- Beende das Beobachten, wenn der Spielercharakter entfernt wird
        end)
    end
end

local function teleportToPlayer(player)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        stopSpectate()  -- Beende das Spectating, bevor teleportiert wird
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
        end
    end
end

-----------------------CREATE PLAYERLIST--------------------
local function updatePlayerList()
    -- Alle bestehenden Spieler-Einträge entfernen
    for _, child in ipairs(PlayersList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local yOffset = 10

    -- Für jeden Spieler eine neue Zeile erstellen
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerFrame = Instance.new("Frame")
            PlayerFrame.Size = UDim2.new(1, -20, 0, 60)
            PlayerFrame.Position = UDim2.new(0, 10, 0, yOffset)
            PlayerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            PlayerFrame.BorderSizePixel = 0
            PlayerFrame.Parent = PlayersList

            -- Abrundung für PlayerFrame
            local playerFrameCorner = Instance.new("UICorner")
            playerFrameCorner.CornerRadius = UDim.new(0, 8)
            playerFrameCorner.Parent = PlayerFrame

            -- Schatten für den PlayerFrame - Größe reduzieren für subtileres Aussehen
            local shadow = Instance.new("Frame")
            shadow.Size = PlayerFrame.Size + UDim2.new(0, 5, 0, 5)
            shadow.Position = PlayerFrame.Position + UDim2.new(0, 3, 0, 3)
            shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            shadow.BackgroundTransparency = 0.8
            shadow.BorderSizePixel = 0
            shadow.ZIndex = 0
            shadow.Parent = PlayerFrame

            -- Spielername Label
            local PlayerLabel = Instance.new("TextLabel")
            PlayerLabel.Size = UDim2.new(0.4, 0, 1, 0)
            PlayerLabel.Position = UDim2.new(0.05, 0, 0, 0)
            PlayerLabel.Text = player.Name
            PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerLabel.BackgroundTransparency = 1
            PlayerLabel.Font = Enum.Font.SourceSansBold
            PlayerLabel.TextSize = 18
            PlayerLabel.Parent = PlayerFrame

            -- Team Label
            local TeamLabel = Instance.new("TextLabel")
            TeamLabel.Size = UDim2.new(0.25, 0, 1, 0)
            TeamLabel.Position = UDim2.new(0.45, 0, 0, 0)
            TeamLabel.Text = player.Team and player.Team.Name or "No Team"
            TeamLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            TeamLabel.BackgroundTransparency = 1
            TeamLabel.Font = Enum.Font.SourceSansItalic
            TeamLabel.TextSize = 16
            TeamLabel.Parent = PlayerFrame

            -- Spectate Button
            local SpectateButton = Instance.new("TextButton")
            SpectateButton.Size = UDim2.new(0.15, -5, 0.8, 0)
            SpectateButton.Position = UDim2.new(0.7, 5, 0.1, 0)
            SpectateButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            SpectateButton.Text = "Spectate"
            SpectateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            SpectateButton.Font = Enum.Font.SourceSans
            SpectateButton.TextSize = 16
            SpectateButton.Parent = PlayerFrame

            -- Button Abrundung für den Spectate Button
            local spectateButtonCorner = Instance.new("UICorner")
            spectateButtonCorner.CornerRadius = UDim.new(0, 5)
            spectateButtonCorner.Parent = SpectateButton

            -- Teleport Button
            local TeleportButton = Instance.new("TextButton")
            TeleportButton.Size = UDim2.new(0.15, -5, 0.8, 0)
            TeleportButton.Position = UDim2.new(0.85, 5, 0.1, 0)
            TeleportButton.BackgroundColor3 = Color3.fromRGB(100, 80, 80)
            TeleportButton.Text = "Teleport"
            TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TeleportButton.Font = Enum.Font.SourceSans
            TeleportButton.TextSize = 16
            TeleportButton.Parent = PlayerFrame

            -- Button Abrundung für den Teleport Button
            local teleportButtonCorner = Instance.new("UICorner")
            teleportButtonCorner.CornerRadius = UDim.new(0, 5)
            teleportButtonCorner.Parent = TeleportButton

            -- Hover Effekt für Buttons
            local function addHoverEffect(button)
                button.MouseEnter:Connect(function()
                    button.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
                end)
                button.MouseLeave:Connect(function()
                    if button == SpectateButton then
                        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    elseif button == TeleportButton then
                        button.BackgroundColor3 = Color3.fromRGB(100, 80, 80)
                    end
                end)
            end

            addHoverEffect(SpectateButton)
            addHoverEffect(TeleportButton)

            -- Button Funktionen
            SpectateButton.MouseButton1Click:Connect(function()
                spectatePlayer(player)
            end)

            TeleportButton.MouseButton1Click:Connect(function()
                teleportToPlayer(player)
            end)

            -- Abstand zum nächsten Spieler-Eintrag
            yOffset = yOffset + 70
        end
    end

    -- Passe die CanvasSize dynamisch an die Anzahl der Spieler an
    PlayersList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-------------------Repeaters-------------
while true do
    updatePlayerList()
    wait(2) -- Aktualisiert die Liste alle 2 Sekunden
end

--Changers
FlySpeedTextBox.Focused:Connect(function()
    FlySpeedTextBox.Text = ""
end)

FlySpeedTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        adjustFlySpeed()
    else
        FlySpeedTextBox.Text = "Enter Fly Speed (5 - 400)"
    end
end)

HitboxSizeSlider.Focused:Connect(function()
    HitboxSizeSlider.Text = "" 
end)

local toggleVisibility = toggleHitboxVisibility()

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    -- GodMode ein/aus
    if input.KeyCode == Enum.KeyCode[Settings.ToggleGodMode] then
        enableGodMode()
    end

    -- Unendlich Munition ein/aus
    if input.KeyCode == Enum.KeyCode[Settings.ToggleUnlimitedAmmo] then
        autoReloadTool()  -- Eine Funktion, die unendliche Munition aktiviert
    end

    -- Fluggeschwindigkeit erhöhen
    if input.KeyCode == Enum.KeyCode[Settings.IncreaseFlySpeed] then
        FlySpeed = math.min(FlySpeed + 10, 400)  -- Erhöht die Geschwindigkeit, max. 400
        print("Fluggeschwindigkeit erhöht auf:", FlySpeed)
    end

    -- Fluggeschwindigkeit verringern
    if input.KeyCode == Enum.KeyCode[Settings.DecreaseFlySpeed] then
        FlySpeed = math.max(FlySpeed - 10, 5)  -- Verringert die Geschwindigkeit, mind. 5
        print("Fluggeschwindigkeit verringert auf:", FlySpeed)
    end

    -- Beobachten eines Spielers
    if input.KeyCode == Enum.KeyCode[Settings.SpectatePlayer] then
        if spectateTarget then
            stopSpectate()
        else
            spectatePlayer(Players:GetPlayers()[2])  -- Beispiel: Beobachte den zweiten Spieler in der Liste
        end
    end

    -- Teleportiere zu einem Spieler
    if input.KeyCode == Enum.KeyCode[Settings.TeleportToPlayer] then
        teleportToPlayer(Players:GetPlayers()[2])  -- Beispiel: Teleportiere zum zweiten Spieler in der Liste
    end
end)

--Execute Elements

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

updatePlayerList()
