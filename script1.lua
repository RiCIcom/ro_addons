local EasyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/RiCIcom/easyrobloxui/refs/heads/main/main.lua"))()

-- Wenn das GUI bereits existiert, entfernen wir es
if game.CoreGui:FindFirstChild("RemoteSpyUI") then
    game.CoreGui.RemoteSpyUI:Destroy()
end

-- ScreenGui erstellen und unter CoreGui platzieren, damit es immer sichtbar ist
local screenGui = EasyUI:ScreenGui(game.CoreGui)
screenGui.Name = "RemoteSpyUI"

local detectedRemotes = {}

local isUIVisible = true
local function toggleUI()
    isUIVisible = not isUIVisible
    screenGui.Enabled = isUIVisible
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Period then
        toggleUI()
    end
end)

local function openRemoteSpy()
    -- Hauptfenster des Remote Spy Tools erstellen
    local spyFrame = EasyUI:Frame(screenGui, UDim2.new(0.6, 0, 0.6, 0), UDim2.new(0.2, 0, 0.2, 0), Color3.fromRGB(30, 30, 30))
    EasyUI:UICorner(spyFrame, UDim.new(0, 20))
    EasyUI:ApplyShadow(spyFrame)

    -- Header des Fensters für Titel und Bewegungsfähigkeit
    local spyHeader = EasyUI:TextButton(spyFrame, "Remote Spy - Advanced Cheat Detector", UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 0, 10), Color3.fromRGB(30, 30, 30))
    spyHeader.TextColor3 = Color3.fromRGB(230, 230, 230)
    spyHeader.TextSize = 20
    EasyUI:UIStroke(spyHeader, 1.5, Color3.fromRGB(255, 255, 255))
    spyHeader.TextXAlignment = Enum.TextXAlignment.Center
    EasyUI:UICorner(spyHeader, UDim.new(0, 10))

    -- Draggable Header
    local dragging = false
    local dragInput, mousePos, framePos

    spyHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = spyFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    spyHeader.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            spyFrame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)

    -- Frame für Remote Liste
    local listFrame = EasyUI:ScrollingFrame(spyFrame, UDim2.new(0.4, -20, 0.75, -20), UDim2.new(0, 10, 0.25, 10), UDim2.new(0, 0, 2, 0))
    EasyUI:UICorner(listFrame, UDim.new(0, 10))
    EasyUI:UIStroke(listFrame, 2, Color3.fromRGB(0, 0, 0))
    EasyUI:UIListLayout(listFrame, 10)

    -- Editor Frame für Details zu den Remotes
    local editorFrame = EasyUI:Frame(spyFrame, UDim2.new(0.55, -20, 0.75, -20), UDim2.new(0.45, 10, 0.25, 10), Color3.fromRGB(40, 40, 40))
    EasyUI:UICorner(editorFrame, UDim.new(0, 15))
    EasyUI:UIStroke(editorFrame, 3, Color3.fromRGB(0, 0, 0))

    local editorLabel = EasyUI:TextLabel(editorFrame, "Editor", UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 0, 10), Color3.fromRGB(180, 180, 180), 22)
    EasyUI:UICorner(editorLabel, UDim.new(0, 8))
    EasyUI:UIStroke(editorLabel, 2, Color3.fromRGB(255, 255, 255))

    local codeDisplay = EasyUI:TextLabel(editorFrame, "Wähle ein Remote Event aus, um Details zu sehen", UDim2.new(1, -20, 0.7, -60), UDim2.new(0, 10, 0, 60), Color3.fromRGB(60, 60, 60), 18)
    codeDisplay.TextWrapped = true
    codeDisplay.TextYAlignment = Enum.TextYAlignment.Top
    EasyUI:UICorner(codeDisplay, UDim.new(0, 10))

    -- Funktion zum Erfassen und Anzeigen von Remote Events und deren Details
    local function addRemote(remote)
        if detectedRemotes[remote] then
            return
        end
        detectedRemotes[remote] = true

        -- Button für den Remote Event erstellen
        local remoteButton = EasyUI:TextButton(listFrame, remote.Name, UDim2.new(0.9, 0, 0, 40), nil, Color3.fromRGB(90, 90, 90))
        EasyUI:UICorner(remoteButton, UDim.new(0, 6))
        EasyUI:MakeClickable(remoteButton, function()
            local argsText = "Details für Remote Event: '" .. remote.Name .. "'\n"
            argsText = argsText .. "Klassentyp: " .. remote.ClassName .. "\n"
            argsText = argsText .. "Pfad: " .. remote:GetFullName() .. "\n"
            argsText = argsText .. "Letzter Aufruf: \n"

            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                -- Erfasse den letzten Aufruf
                remote.OnClientEvent:Connect(function(...)
                    local arguments = {...}
                    argsText = argsText .. "Argumente:\n"
                    for i, arg in pairs(arguments) do
                        argsText = argsText .. "Argument " .. i .. ": " .. tostring(arg) .. "\n"
                    end
                    codeDisplay.Text = argsText
                end)
            end

            codeDisplay.Text = argsText
        end)
    end

    -- Dynamische Überwachung neuer Remote Events im Spiel
    game.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            addRemote(descendant)
        end
    end)

    -- Alle bereits vorhandenen Remote Events hinzufügen
    for _, descendant in pairs(game:GetDescendants()) do
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            addRemote(descendant)
        end
    end
end

local function startLoadingScreen()
    -- Ladebildschirm erstellen
    local loadingFrame = EasyUI:Frame(screenGui, UDim2.new(0.4, 0, 0.4, 0), UDim2.new(0.3, 0, 0.3, 0), Color3.fromRGB(50, 50, 50))
    EasyUI:UICorner(loadingFrame, UDim.new(0, 20))
    EasyUI:ApplyShadow(loadingFrame)

    local headerLabel = EasyUI:TextLabel(loadingFrame, "Scripted by RICi", UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 0, 10), Color3.fromRGB(230, 230, 230), 18)
    EasyUI:UIStroke(headerLabel, 1.5, Color3.fromRGB(255, 255, 255))
    EasyUI:UICorner(headerLabel, UDim.new(0, 10))
    headerLabel.TextXAlignment = Enum.TextXAlignment.Center

    local loadingLabel = EasyUI:TextLabel(loadingFrame, "Loading...", UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0.25, -10), Color3.fromRGB(255, 255, 255), 28)
    loadingLabel.TextXAlignment = Enum.TextXAlignment.Center
    EasyUI:UICorner(loadingLabel, UDim.new(0, 8))

    local progressLabel = EasyUI:TextLabel(loadingFrame, "0%", UDim2.new(0.15, 0, 0, 25), UDim2.new(0.425, 0, 0.45, -15), Color3.fromRGB(230, 230, 230), 18)
    progressLabel.TextXAlignment = Enum.TextXAlignment.Center
    EasyUI:UICorner(progressLabel, UDim.new(0, 8))

    local progressBarBg = EasyUI:Frame(loadingFrame, UDim2.new(0.9, 0, 0, 30), UDim2.new(0.05, 0, 0.6, 0), Color3.fromRGB(100, 100, 100))
    EasyUI:UICorner(progressBarBg, UDim.new(0, 15))
    EasyUI:UIStroke(progressBarBg, 1.5, Color3.fromRGB(0, 0, 0))

    local progressBar = EasyUI:Frame(progressBarBg, UDim2.new(0.0, 0, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 0, 0))
    EasyUI:UICorner(progressBar, UDim.new(0, 15))

    local function simulateLoading()
        for i = 1, 100 do
            wait(0.03)
            progressLabel.Text = tostring(i) .. "%"
            progressBar.Size = UDim2.new(i / 100, 0, 1, 0)
        end
        wait(1)
        loadingFrame.Visible = false
        openRemoteSpy()
    end

    simulateLoading()
end

startLoadingScreen()
