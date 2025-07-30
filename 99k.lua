local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

local meleeEvent = ReplicatedStorage:FindFirstChild("meleeEvent")
local damageEvent = ReplicatedStorage:FindFirstChild("DamageEvent")

-- Variables de estado
local killOn = false
local respawnOn = false
local speedOn = false
local tpOn = false
local deathPosition = nil
local currentTargetIndex = 1
local speedVal = 70

-- GUI Principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumKillAll"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0, 20, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 100, 100)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 45)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleFrame.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚔️ PREMIUM KILLALL"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 30, 0, 30)
toggleButton.Position = UDim2.new(1, -35, 0, 7.5)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.Text = "➖"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = titleFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 15)
toggleCorner.Parent = toggleButton

local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, -10, 0, 25)
statusBar.Position = UDim2.new(0, 5, 0, 50)
statusBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
statusBar.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusBar

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🟢 Listo | Jugadores: " .. (#Players:GetPlayers() - 1)
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = statusBar

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -80)
contentFrame.Position = UDim2.new(0, 0, 0, 80)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local function createButton(texto, icono, orden, callback, colorOn, colorOff)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, orden * 50)
    button.BackgroundColor3 = colorOff or Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.Text = icono .. " " .. texto
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.SourceSansBold
    button.Parent = contentFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button

    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(100, 100, 100)
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button

    local function animateButton(targetColor, targetStroke)
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = targetColor})
        local strokeTween = TweenService:Create(buttonStroke, TweenInfo.new(0.2), {Color = targetStroke})
        tween:Play()
        strokeTween:Play()
    end

    button.MouseEnter:Connect(function()
        animateButton(Color3.fromRGB(70, 70, 70), Color3.fromRGB(150, 150, 150))
    end)

    button.MouseLeave:Connect(function()
        local currentColor = button.BackgroundColor3
        if currentColor == (colorOn or Color3.fromRGB(100, 255, 100)) then
            animateButton(colorOn or Color3.fromRGB(100, 255, 100), Color3.fromRGB(0, 255, 0))
        else
            animateButton(colorOff or Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 100, 100))
        end
    end)

    button.MouseButton1Click:Connect(function()
        callback()
        local clickTween = TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, -25, 0, 35)})
        local backTween = TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, -20, 0, 40)})
        clickTween:Play()
        clickTween.Completed:Wait()
        backTween:Play()
    end)

    if UserInputService.TouchEnabled then
        button.TouchTap:Connect(callback)
    end

    return button
end

local function updateButtonColor(button, isOn, colorOn, colorOff)
    local targetColor = isOn and (colorOn or Color3.fromRGB(100, 255, 100)) or (colorOff or Color3.fromRGB(50, 50, 50))
    local targetStroke = isOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)

    TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(button:FindFirstChild("UIStroke"), TweenInfo.new(0.3), {Color = targetStroke}):Play()
end

-- Kill Loop optimizado, sin spawn extra, para activación inmediata
local function killLoop()
    RunService.Heartbeat:Connect(function()
        if killOn and Character and Root then
            local myPos = Root.Position
            local killCount = 0

            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local target = p.Character.HumanoidRootPart
                    if (target.Position - myPos).Magnitude <= 70 then
                        for i = 1, 49 do
                            if meleeEvent then pcall(meleeEvent.FireServer, meleeEvent, p) end
                            if damageEvent then pcall(damageEvent.FireServer, damageEvent, p) end
                        end
                        killCount = killCount + 1
                    end
                end
            end

            statusLabel.Text = "⚔️ Killing... | Targets: " .. killCount
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        elseif not killOn then
            statusLabel.Text = "🟢 Listo | Jugadores: " .. (#Players:GetPlayers() - 1)
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end)
end

-- Respawn rápido en la posición guardada sin delay raro
local function setupRespawnSystem()
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        Character = newChar
        Humanoid = newChar:WaitForChild("Humanoid")
        Root = newChar:WaitForChild("HumanoidRootPart")

        if respawnOn and deathPosition then
            -- Directo sin esperar para que sea rápido
            Root.CFrame = CFrame.new(deathPosition)
            statusLabel.Text = "💀 Respawned at death position"
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        end

        -- Reactivar speed si estaba activo
        if speedOn then
            wait(0.5) -- corto wait para asegurar que Humanoid esté listo
            if Humanoid then Humanoid.WalkSpeed = speedVal end
        end
    end)

    -- Guardar posición al morir
    Humanoid.Died:Connect(function()
        if Root then
            deathPosition = Root.Position
        end
    end)
end

-- Speed function sencilla
local function activarSpeed()
    if speedOn and Humanoid then
        Humanoid.WalkSpeed = speedVal
    elseif Humanoid then
        Humanoid.WalkSpeed = 16
    end
end

-- TP Loop
local function tpLoop()
    RunService.Heartbeat:Connect(function()
        if tpOn and Root then
            local players = {}
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    table.insert(players, p)
                end
            end

            if #players > 0 then
                currentTargetIndex = (currentTargetIndex % #players) + 1
                local target = players[currentTargetIndex]

                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    Root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    statusLabel.Text = "🌀 TP to: " .. target.Name
                    statusLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
                end
            end
        end
    end)
end

-- Noclip solo paredes
local function noclipLoop()
    RunService.Stepped:Connect(function()
        if Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    if part.Name ~= "HumanoidRootPart" and part.Position.Y > Root.Position.Y - 3 then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end

-- Actualizar contador jugadores en statusLabel (cuando no mata ni tp)
RunService.Heartbeat:Connect(function()
    if not killOn and not tpOn then
        statusLabel.Text = "🟢 Listo | Jugadores: " .. (#Players:GetPlayers() - 1)
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
end)

-- Crear botones y actualizar colores
local killButton = createButton("Kill All", "⚔️", 0, function()
    killOn = not killOn
    updateButtonColor(killButton, killOn, Color3.fromRGB(255, 100, 100), Color3.fromRGB(50, 50, 50))
    if killOn then
        statusLabel.Text = "⚔️ Kill All ACTIVADO"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        statusLabel.Text = "⚔️ Kill All DESACTIVADO"
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    end
end, Color3.fromRGB(255, 100, 100))

local respawnButton = createButton("Auto Respawn", "💀", 1, function()
    respawnOn = not respawnOn
    updateButtonColor(respawnButton, respawnOn, Color3.fromRGB(255, 255, 100), Color3.fromRGB(50, 50, 50))
    if respawnOn then
        deathPosition = Root.Position
        statusLabel.Text = "💀 Auto Respawn ACTIVADO"
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    else
        statusLabel.Text = "💀 Auto Respawn DESACTIVADO"
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    end
end, Color3.fromRGB(255, 255, 100))

local speedButton = createButton("Speed x70", "💨", 2, function()
    speedOn = not speedOn
    updateButtonColor(speedButton, speedOn, Color3.fromRGB(100, 255, 255), Color3.fromRGB(50, 50, 50))
    activarSpeed()
    if speedOn then
        statusLabel.Text = "💨 Speed ACTIVADO"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 255)
    else
        statusLabel.Text = "💨 Speed DESACTIVADO"
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    end
end, Color3.fromRGB(100, 255, 255))

local tpButton = createButton("TP Players", "🌀", 3, function()
    tpOn = not tpOn
    updateButtonColor(tpButton, tpOn, Color3.fromRGB(255, 100, 255), Color3.fromRGB(50, 50, 50))
    if tpOn then
        statusLabel.Text = "🌀 TP Players ACTIVADO"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 255)
    else
        statusLabel.Text = "🌀 TP Players DESACTIVADO"
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    end
end, Color3.fromRGB(255, 100, 255))

toggleButton.MouseButton1Click:Connect(function()
    contentFrame.Visible = not contentFrame.Visible
    statusBar.Visible = not statusBar.Visible
    toggleButton.Text = contentFrame.Visible and "➖" or "➕"
    
    local newSize = contentFrame.Visible and UDim2.new(0, 220, 0, 320) or UDim2.new(0, 220, 0, 45)
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = newSize}):Play()
end)

if UserInputService.TouchEnabled then
    toggleButton.TouchTap:Connect(function()
        contentFrame.Visible = not contentFrame.Visible
        statusBar.Visible = not statusBar.Visible
        toggleButton.Text = contentFrame.Visible and "➖" or "➕"
        
        local newSize = contentFrame.Visible and UDim2.new(0, 220, 0, 320) or UDim2.new(0, 220, 0, 45)
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = newSize}):Play()
    end)
end

-- Iniciar loops y sistemas
killLoop()
tpLoop()
noclipLoop()
setupRespawnSystem()

print("⚔️ Premium KillAll cargado!")
print("📱 Compatible con móvil")
print("✨ Diseño mejorado y funcional")
