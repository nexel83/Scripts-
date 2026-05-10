-- ============================================
-- BRBOX HUB - Auto Giver Edition v2
-- Script para Delta Executor / Synapse X / KRNL / Fluxus
-- Features: Auto All + Kill Aura + Steal All + Delete Security
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ============================================
-- VARIAVEIS DE CONTROLE
-- ============================================
local autoAllActive = false
local killAuraActive = false
local auraTool = nil
local auraConnection = nil
local auraMode = "none"
local whitelist = {}
local playerButtons = {}
local totalMoney = 0
local itemsBought = 0
local currentScreen = "aura"

-- ============================================
-- CRIAR A GUI PRINCIPAL
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BRBOXHUB_AutoGiver"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal (arrastavel)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 440)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -220)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = mainFrame

-- Borda RGB colorida
local glow = Instance.new("UIStroke")
glow.Color = Color3.fromRGB(255, 0, 0)
glow.Thickness = 3
glow.Parent = mainFrame

-- Animacao RGB na borda
spawn(function()
    while screenGui and screenGui.Parent do
        local tween1 = TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(0, 255, 0)})
        tween1:Play()
        wait(1)
        local tween2 = TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(0, 0, 255)})
        tween2:Play()
        wait(1)
        local tween3 = TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(255, 0, 255)})
        tween3:Play()
        wait(1)
        local tween4 = TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(255, 0, 0)})
        tween4:Play()
        wait(1)
    end
end)

-- Barra de titulo (arrastavel)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

-- ICONE
local iconLabel = Instance.new("TextLabel")
iconLabel.Name = "Icon"
iconLabel.Size = UDim2.new(0, 28, 0, 28)
iconLabel.Position = UDim2.new(0, 8, 0, 6)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "⚡"
iconLabel.TextSize = 20
iconLabel.Font = Enum.Font.GothamBold
iconLabel.Parent = titleBar

-- Titulo
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 40, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "BRBOX HUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Subtitulo
local subTitle = Instance.new("TextLabel")
subTitle.Name = "SubTitle"
subTitle.Size = UDim2.new(1, -120, 0, 14)
subTitle.Position = UDim2.new(0, 40, 0, 24)
subTitle.BackgroundTransparency = 1
subTitle.Text = "Auto Giver Edition v2"
subTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subTitle.TextSize = 10
subTitle.Font = Enum.Font.Gotham
subTitle.TextXAlignment = Enum.TextXAlignment.Left
subTitle.Parent = titleBar

-- Botao minimizar
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -75, 0, 5)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 22
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = titleBar

-- Botao fechar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -38, 0, 5)
closeButton.BackgroundTransparency = 1
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 80, 80)
closeButton.TextSize = 22
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

-- ============================================
-- TELA 1: KILL AURA
-- ============================================
local auraFrame = Instance.new("Frame")
auraFrame.Name = "AuraFrame"
auraFrame.Size = UDim2.new(1, 0, 0, 360)
auraFrame.Position = UDim2.new(0, 0, 0, 48)
auraFrame.BackgroundTransparency = 1
auraFrame.Visible = true
auraFrame.Parent = mainFrame

local auraToggle = Instance.new("TextButton")
auraToggle.Name = "AuraToggle"
auraToggle.Size = UDim2.new(0.9, 0, 0, 45)
auraToggle.Position = UDim2.new(0.05, 0, 0, 10)
auraToggle.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
auraToggle.Text = "OFF"
auraToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
auraToggle.TextSize = 16
auraToggle.Font = Enum.Font.GothamBold
auraToggle.Parent = auraFrame

local auraToggleCorner = Instance.new("UICorner")
auraToggleCorner.CornerRadius = UDim.new(0, 12)
auraToggleCorner.Parent = auraToggle

local auraModeLabel = Instance.new("TextLabel")
auraModeLabel.Name = "ModeLabel"
auraModeLabel.Size = UDim2.new(0.9, 0, 0, 16)
auraModeLabel.Position = UDim2.new(0.05, 0, 0, 60)
auraModeLabel.BackgroundTransparency = 1
auraModeLabel.Text = "Mode: None"
auraModeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
auraModeLabel.TextSize = 10
auraModeLabel.Font = Enum.Font.Gotham
auraModeLabel.TextXAlignment = Enum.TextXAlignment.Center
auraModeLabel.Parent = auraFrame

local auraStatus = Instance.new("TextLabel")
auraStatus.Name = "Status"
auraStatus.Size = UDim2.new(0.9, 0, 0, 16)
auraStatus.Position = UDim2.new(0.05, 0, 0, 78)
auraStatus.BackgroundTransparency = 1
auraStatus.Text = "Waiting..."
auraStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
auraStatus.TextSize = 10
auraStatus.Font = Enum.Font.Gotham
auraStatus.TextXAlignment = Enum.TextXAlignment.Center
auraStatus.Parent = auraFrame

local whitelistLabel = Instance.new("TextLabel")
whitelistLabel.Name = "WhitelistLabel"
whitelistLabel.Size = UDim2.new(0.9, 0, 0, 18)
whitelistLabel.Position = UDim2.new(0.05, 0, 0, 100)
whitelistLabel.BackgroundTransparency = 1
whitelistLabel.Text = "Protected Players:"
whitelistLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
whitelistLabel.TextSize = 12
whitelistLabel.Font = Enum.Font.GothamBold
whitelistLabel.TextXAlignment = Enum.TextXAlignment.Left
whitelistLabel.Parent = auraFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "PlayerList"
scrollFrame.Size = UDim2.new(0.9, 0, 0, 160)
scrollFrame.Position = UDim2.new(0.05, 0, 0, 122)
scrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = auraFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scrollFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 3)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

local auraInfo = Instance.new("TextLabel")
auraInfo.Name = "Info"
auraInfo.Size = UDim2.new(0.9, 0, 0, 20)
auraInfo.Position = UDim2.new(0.05, 0, 0, 290)
auraInfo.BackgroundTransparency = 1
auraInfo.Text = "Enable and equip a weapon"
auraInfo.TextColor3 = Color3.fromRGB(120, 120, 120)
auraInfo.TextSize = 10
auraInfo.Font = Enum.Font.Gotham
auraInfo.TextXAlignment = Enum.TextXAlignment.Center
auraInfo.TextWrapped = true
auraInfo.Parent = auraFrame

-- ============================================
-- TELA 2: AUTO ALL (1 botao faz tudo)
-- ============================================
local farmFrame = Instance.new("Frame")
farmFrame.Name = "FarmFrame"
farmFrame.Size = UDim2.new(1, 0, 0, 360)
farmFrame.Position = UDim2.new(0, 0, 0, 48)
farmFrame.BackgroundTransparency = 1
farmFrame.Visible = false
farmFrame.Parent = mainFrame

local farmTitle = Instance.new("TextLabel")
farmTitle.Name = "FarmTitle"
farmTitle.Size = UDim2.new(0.9, 0, 0, 30)
farmTitle.Position = UDim2.new(0.05, 0, 0, 5)
farmTitle.BackgroundTransparency = 1
farmTitle.Text = "Auto All"
farmTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
farmTitle.TextSize = 20
farmTitle.Font = Enum.Font.GothamBold
farmTitle.TextXAlignment = Enum.TextXAlignment.Center
farmTitle.Parent = farmFrame

-- Um botao so que faz TUDO
local autoAllToggle = Instance.new("TextButton")
autoAllToggle.Name = "AutoAllToggle"
autoAllToggle.Size = UDim2.new(0.9, 0, 0, 50)
autoAllToggle.Position = UDim2.new(0.05, 0, 0, 45)
autoAllToggle.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
autoAllToggle.Text = "AUTO ALL: OFF"
autoAllToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoAllToggle.TextSize = 16
autoAllToggle.Font = Enum.Font.GothamBold
autoAllToggle.Parent = farmFrame

local autoAllCorner = Instance.new("UICorner")
autoAllCorner.CornerRadius = UDim.new(0, 12)
autoAllCorner.Parent = autoAllToggle

-- Status
local autoAllStatus = Instance.new("TextLabel")
autoAllStatus.Size = UDim2.new(0.9, 0, 0, 20)
autoAllStatus.Position = UDim2.new(0.05, 0, 0, 105)
autoAllStatus.BackgroundTransparency = 1
autoAllStatus.Text = "Money: 0 | Items: 0"
autoAllStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
autoAllStatus.TextSize = 12
autoAllStatus.Font = Enum.Font.Gotham
autoAllStatus.TextXAlignment = Enum.TextXAlignment.Center
autoAllStatus.Parent = farmFrame

local farmInfo = Instance.new("TextLabel")
farmInfo.Size = UDim2.new(0.9, 0, 0, 80)
farmInfo.Position = UDim2.new(0.05, 0, 0, 140)
farmInfo.BackgroundTransparency = 1
farmInfo.Text = "This button does EVERYTHING:\n• Collects money from Giver\n• Clicks miner (ClickDetector)\n• Buys red buttons (ignores green)\nAll automatically in one loop!"
farmInfo.TextColor3 = Color3.fromRGB(120, 120, 120)
farmInfo.TextSize = 10
farmInfo.Font = Enum.Font.Gotham
farmInfo.TextWrapped = true
farmInfo.TextXAlignment = Enum.TextXAlignment.Center
farmInfo.Parent = farmFrame

-- ============================================
-- TELA 3: STEAL ALL + DELETE SECURITY
-- ============================================
local stealFrame = Instance.new("Frame")
stealFrame.Name = "StealFrame"
stealFrame.Size = UDim2.new(1, 0, 0, 360)
stealFrame.Position = UDim2.new(0, 0, 0, 48)
stealFrame.BackgroundTransparency = 1
stealFrame.Visible = false
stealFrame.Parent = mainFrame

local stealTitle = Instance.new("TextLabel")
stealTitle.Name = "StealTitle"
stealTitle.Size = UDim2.new(0.9, 0, 0, 30)
stealTitle.Position = UDim2.new(0.05, 0, 0, 10)
stealTitle.BackgroundTransparency = 1
stealTitle.Text = "Steal & Destroy"
stealTitle.TextColor3 = Color3.fromRGB(255, 150, 0)
stealTitle.TextSize = 20
stealTitle.Font = Enum.Font.GothamBold
stealTitle.TextXAlignment = Enum.TextXAlignment.Center
stealTitle.Parent = stealFrame

-- Botao Steal All
local stealButton = Instance.new("TextButton")
stealButton.Name = "StealButton"
stealButton.Size = UDim2.new(0.8, 0, 0, 50)
stealButton.Position = UDim2.new(0.1, 0, 0, 55)
stealButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stealButton.Text = "STEAL ALL SWORDS"
stealButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stealButton.TextSize = 15
stealButton.Font = Enum.Font.GothamBold
stealButton.Parent = stealFrame

local stealBtnCorner = Instance.new("UICorner")
stealBtnCorner.CornerRadius = UDim.new(0, 12)
stealBtnCorner.Parent = stealButton

-- Botao Delete Security
local deleteSecurityButton = Instance.new("TextButton")
deleteSecurityButton.Name = "DeleteSecurity"
deleteSecurityButton.Size = UDim2.new(0.8, 0, 0, 50)
deleteSecurityButton.Position = UDim2.new(0.1, 0, 0, 120)
deleteSecurityButton.BackgroundColor3 = Color3.fromRGB(180, 30, 180)
deleteSecurityButton.Text = "DELETE ALL SECURITY"
deleteSecurityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
deleteSecurityButton.TextSize = 15
deleteSecurityButton.Font = Enum.Font.GothamBold
deleteSecurityButton.Parent = stealFrame

local deleteSecCorner = Instance.new("UICorner")
deleteSecCorner.CornerRadius = UDim.new(0, 12)
deleteSecCorner.Parent = deleteSecurityButton

-- Resultados
local stealResult = Instance.new("TextLabel")
stealResult.Size = UDim2.new(0.9, 0, 0, 40)
stealResult.Position = UDim2.new(0.05, 0, 0, 185)
stealResult.BackgroundTransparency = 1
stealResult.Text = "Click buttons above to execute"
stealResult.TextColor3 = Color3.fromRGB(150, 150, 150)
stealResult.TextSize = 11
stealResult.Font = Enum.Font.Gotham
stealResult.TextWrapped = true
stealResult.TextXAlignment = Enum.TextXAlignment.Center
stealResult.Parent = stealFrame

local stealInfo = Instance.new("TextLabel")
stealInfo.Size = UDim2.new(0.9, 0, 0, 60)
stealInfo.Position = UDim2.new(0.05, 0, 0, 240)
stealInfo.BackgroundTransparency = 1
stealInfo.Text = "Steal All: Activates all Giver parts from every base\nDelete Security: Removes all Lasers from OwnerOnlyDoor in every base"
stealInfo.TextColor3 = Color3.fromRGB(100, 100, 100)
stealInfo.TextSize = 10
stealInfo.Font = Enum.Font.Gotham
stealInfo.TextWrapped = true
stealInfo.TextXAlignment = Enum.TextXAlignment.Center
stealInfo.Parent = stealFrame

-- ============================================
-- BOTAO CASINHA (CASA) NO RODAPE
-- ============================================
local homeButton = Instance.new("TextButton")
homeButton.Name = "HomeButton"
homeButton.Size = UDim2.new(0, 32, 0, 32)
homeButton.Position = UDim2.new(0.5, -16, 1, -38)
homeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
homeButton.Text = "⌂"
homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
homeButton.TextSize = 20
homeButton.Font = Enum.Font.GothamBold
homeButton.Parent = mainFrame

local homeCorner = Instance.new("UICorner")
homeCorner.CornerRadius = UDim.new(0, 8)
homeCorner.Parent = homeButton

local homeGlow = Instance.new("UIStroke")
homeGlow.Color = Color3.fromRGB(255, 0, 0)
homeGlow.Thickness = 2
homeGlow.Parent = homeButton

spawn(function()
    while screenGui and screenGui.Parent do
        local t1 = TweenService:Create(homeGlow, TweenInfo.new(0.8, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(0, 255, 0)})
        t1:Play()
        wait(0.8)
        local t2 = TweenService:Create(homeGlow, TweenInfo.new(0.8, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(0, 0, 255)})
        t2:Play()
        wait(0.8)
        local t3 = TweenService:Create(homeGlow, TweenInfo.new(0.8, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(255, 0, 255)})
        t3:Play()
        wait(0.8)
        local t4 = TweenService:Create(homeGlow, TweenInfo.new(0.8, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(255, 0, 0)})
        t4:Play()
        wait(0.8)
    end
end)

-- ============================================
-- FUNCOES AUXILIARES
-- ============================================
local function fireTouch(part)
    if not part then return false end
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local success = pcall(function()
        firetouchinterest(hrp, part, 0)
        task.wait(0.05)
        firetouchinterest(hrp, part, 1)
    end)
    if success then return true end

    pcall(function()
        for _, connection in pairs(getconnections(part.Touched)) do
            connection:Fire(hrp)
        end
    end)
    return true
end

local function fireClick(clickDetector)
    if not clickDetector then return false end
    pcall(function()
        fireclickdetector(clickDetector)
    end)
    return true
end

local function isRedButton(part)
    if not part or not part:IsA("BasePart") then return false end
    local color = part.Color
    return color.R > 0.6 and color.G < 0.4 and color.B < 0.4
end

local function getTycoonsSub()
    local tycoonsFolder = workspace:FindFirstChild("Tycoons")
    if not tycoonsFolder then return nil end
    return tycoonsFolder:FindFirstChild("Tycoons") or tycoonsFolder
end

-- ============================================
-- FUNCAO AUTO ALL (FAZ TUDO EM 1)
-- ============================================
local function autoAll()
    if not autoAllActive then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local tycoonsSub = getTycoonsSub()
    if not tycoonsSub then return end

    for _, base in pairs(tycoonsSub:GetChildren()) do
        if not autoAllActive then break end

        -- 1. COLETAR DINHEIRO (Giver)
        local essentials = base:FindFirstChild("Essentials")
        if essentials then
            local giver = essentials:FindFirstChild("Giver")
            if giver then
                local giverPart = giver:FindFirstChild("Giver") or giver
                if giverPart and giverPart:IsA("BasePart") then
                    fireTouch(giverPart)
                    totalMoney = totalMoney + 1
                end
            end
        end
        task.wait(0.05)

        -- 2. MINERAR (Clicker via ClickDetector)
        local purchasedObjects = base:FindFirstChild("PurchasedObjects")
        if purchasedObjects then
            local mine = purchasedObjects:FindFirstChild("Mine")
            if mine then
                local model = mine:FindFirstChild("Model")
                if model then
                    local clicker = model:FindFirstChild("Clicker")
                    if clicker then
                        local clickDetector = clicker:FindFirstChildOfClass("ClickDetector")
                        if clickDetector then
                            fireClick(clickDetector)
                        end
                    end
                end
            end
        end
        task.wait(0.05)

        -- 3. CONSTRUIR (Botões vermelhos Head)
        local buttons = base:FindFirstChild("Buttons")
        if buttons then
            for _, btnFolder in pairs(buttons:GetChildren()) do
                if not autoAllActive then break end
                local head = btnFolder:FindFirstChild("Head")
                if head and head:IsA("BasePart") then
                    if isRedButton(head) then
                        fireTouch(head)
                        itemsBought = itemsBought + 1
                    end
                end
                task.wait(0.03)
            end
        end
        task.wait(0.1)
    end

    autoAllStatus.Text = "Money: " .. totalMoney .. " | Items: " .. itemsBought
end

-- ============================================
-- FUNCAO STEAL ALL
-- ============================================
local function stealAll()
    local char = player.Character
    if not char then return 0, 0, 0 end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return 0, 0, 0 end

    local tycoonsSub = getTycoonsSub()
    if not tycoonsSub then return 0, 0, 0 end

    local totalSwords = 0
    local activated = 0
    local totalBases = 0

    for _, base in pairs(tycoonsSub:GetChildren()) do
        totalBases = totalBases + 1
        local purchasedObjects = base:FindFirstChild("PurchasedObjects")
        if purchasedObjects then
            for _, giverFolder in pairs(purchasedObjects:GetChildren()) do
                if giverFolder.Name:lower():find("giver") then
                    local giverPart = giverFolder:FindFirstChild("Giver")
                    if giverPart and giverPart:IsA("BasePart") then
                        totalSwords = totalSwords + 1
                        if fireTouch(giverPart) then
                            activated = activated + 1
                        end
                        task.wait(0.1)
                    end
                end
            end
        end
    end

    return totalSwords, activated, totalBases
end

-- ============================================
-- FUNCAO DELETE ALL SECURITY (LASERS)
-- ============================================
local function deleteAllSecurity()
    local tycoonsSub = getTycoonsSub()
    if not tycoonsSub then return 0 end

    local deletedCount = 0

    for _, base in pairs(tycoonsSub:GetChildren()) do
        local purchasedObjects = base:FindFirstChild("PurchasedObjects")
        if purchasedObjects then
            local ownerOnlyDoor = purchasedObjects:FindFirstChild("OwnerOnlyDoor")
            if ownerOnlyDoor then
                local lasers = ownerOnlyDoor:FindFirstChild("Lasers")
                if lasers then
                    pcall(function()
                        lasers:Destroy()
                        deletedCount = deletedCount + 1
                    end)
                end
            end
        end
    end

    return deletedCount
end

-- ============================================
-- FUNCAO KILL AURA
-- ============================================
local function detectAttackType(tool)
    if not tool then return "none", nil end
    local handle = tool:FindFirstChild("Handle")
    if handle then
        local touchInterest = handle:FindFirstChild("TouchInterest")
        if touchInterest then return "touch", handle end
        local touchTransmitter = handle:FindFirstChildOfClass("TouchTransmitter")
        if touchTransmitter then return "touch", handle end
    end
    for _, child in pairs(tool:GetDescendants()) do
        if child:IsA("RemoteEvent") then
            local name = child.Name:lower()
            if name:find("attack") or name:find("damage") or name:find("kill") or 
               name:find("hit") or name:find("swing") or name:find("slash") or name:find("fire") then
                return "event", child
            end
        end
    end
    for _, child in pairs(tool:GetDescendants()) do
        if child:IsA("RemoteEvent") then return "event", child end
    end
    return "none", nil
end

local function isWhitelisted(targetPlayer)
    if not targetPlayer then return false end
    return whitelist[targetPlayer.Name] == true
end

local function attackWithTouch(handle)
    if not handle then return end
    if not killAuraActive then return end
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player and not isWhitelisted(target) then
            local tChar = target.Character
            if tChar then
                local tHRP = tChar:FindFirstChild("HumanoidRootPart")
                if tHRP then
                    pcall(function()
                        firetouchinterest(tHRP, handle, 0)
                        task.wait(0.02)
                        firetouchinterest(tHRP, handle, 1)
                    end)
                end
            end
        end
    end
end

local function attackWithEvent(event)
    if not event then return end
    if not killAuraActive then return end
    if event:IsA("RemoteEvent") then
        pcall(function() event:FireServer() end)
        for _, target in pairs(Players:GetPlayers()) do
            if target ~= player and not isWhitelisted(target) then
                pcall(function() event:FireServer(target) end)
                pcall(function()
                    local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then event:FireServer(hrp.Position) end
                end)
            end
        end
    end
end

local function startAura(tool)
    if not tool then return end
    local attackType, attackObj = detectAttackType(tool)
    if attackType == "none" then
        auraStatus.Text = "No attack system detected"
        auraStatus.TextColor3 = Color3.fromRGB(255, 150, 0)
        auraModeLabel.Text = "Mode: None"
        return
    end
    auraTool = tool
    auraMode = attackType
    if attackType == "touch" then
        auraModeLabel.Text = "Mode: Touch"
        auraStatus.Text = "Aura Active!"
        auraStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
        auraInfo.Text = "Attacking: " .. tool.Name
        if auraConnection then auraConnection:Disconnect() end
        auraConnection = RunService.Heartbeat:Connect(function()
            if killAuraActive and auraTool then
                local char = player.Character
                if char then
                    local equipped = char:FindFirstChild(auraTool.Name)
                    if equipped then
                        local h = equipped:FindFirstChild("Handle")
                        if h then attackWithTouch(h) end
                    else
                        auraTool = nil
                        auraStatus.Text = "Weapon unequipped"
                        auraStatus.TextColor3 = Color3.fromRGB(255, 150, 0)
                        if auraConnection then auraConnection:Disconnect() auraConnection = nil end
                    end
                end
            end
        end)
    elseif attackType == "event" then
        auraModeLabel.Text = "Mode: Event (" .. attackObj.Name .. ")"
        auraStatus.Text = "Event detected!"
        auraStatus.TextColor3 = Color3.fromRGB(0, 200, 255)
        auraInfo.Text = "Use weapon click to attack"
        if auraConnection then auraConnection:Disconnect() end
        auraConnection = RunService.Heartbeat:Connect(function()
            if killAuraActive and auraTool and auraMode == "event" then
                local char = player.Character
                if char then
                    local equipped = char:FindFirstChild(auraTool.Name)
                    if not equipped then
                        auraTool = nil
                        auraMode = "none"
                        auraStatus.Text = "Weapon unequipped"
                        auraStatus.TextColor3 = Color3.fromRGB(255, 150, 0)
                        auraModeLabel.Text = "Mode: None"
                        if auraConnection then auraConnection:Disconnect() auraConnection = nil end
                    end
                end
            end
        end)
    end
    auraToggle.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
    auraToggle.Text = "ON"
    glow.Color = Color3.fromRGB(0, 255, 100)
end

local function deactivateAura()
    killAuraActive = false
    auraTool = nil
    auraMode = "none"
    if auraConnection then auraConnection:Disconnect() auraConnection = nil end
    auraToggle.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    auraToggle.Text = "OFF"
    glow.Color = Color3.fromRGB(255, 50, 50)
    auraStatus.Text = "Waiting..."
    auraStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
    auraModeLabel.Text = "Mode: None"
    auraInfo.Text = "Enable and equip a weapon"
end

local function monitorCharacter()
    local char = player.Character
    if not char then return end
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and killAuraActive then
            task.wait(0.1)
            startAura(child)
        end
    end)
    for _, child in pairs(char:GetChildren()) do
        if child:IsA("Tool") and killAuraActive then
            startAura(child)
            return
        end
    end
end

-- ============================================
-- TROCAR TELA (BOTAO CASINHA)
-- ============================================
local function toggleScreen()
    if currentScreen == "aura" then
        currentScreen = "farm"
        auraFrame.Visible = false
        stealFrame.Visible = false
        farmFrame.Visible = true
        homeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    elseif currentScreen == "farm" then
        currentScreen = "steal"
        auraFrame.Visible = false
        farmFrame.Visible = false
        stealFrame.Visible = true
        homeButton.BackgroundColor3 = Color3.fromRGB(100, 80, 120)
    else
        currentScreen = "aura"
        farmFrame.Visible = false
        stealFrame.Visible = false
        auraFrame.Visible = true
        homeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end
end

homeButton.MouseButton1Click:Connect(toggleScreen)

-- ============================================
-- CONEXOES DOS BOTOES - AUTO ALL
-- ============================================
local autoAllConnection = nil

autoAllToggle.MouseButton1Click:Connect(function()
    autoAllActive = not autoAllActive
    if autoAllActive then
        autoAllToggle.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
        autoAllToggle.Text = "AUTO ALL: ON"
        autoAllStatus.Text = "Running..."
        autoAllStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
        if autoAllConnection then autoAllConnection:Disconnect() end
        autoAllConnection = RunService.Heartbeat:Connect(function()
            if autoAllActive then
                autoAll()
                task.wait(0.3)
            end
        end)
    else
        autoAllToggle.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        autoAllToggle.Text = "AUTO ALL: OFF"
        autoAllStatus.Text = "Money: " .. totalMoney .. " | Items: " .. itemsBought
        autoAllStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
        if autoAllConnection then autoAllConnection:Disconnect() autoAllConnection = nil end
    end
end)

-- ============================================
-- CONEXAO - STEAL ALL
-- ============================================
stealButton.MouseButton1Click:Connect(function()
    stealButton.BackgroundColor3 = Color3.fromRGB(100, 40, 100)
    stealResult.Text = "Stealing..."
    stealResult.TextColor3 = Color3.fromRGB(255, 200, 0)

    local total, activated, bases = stealAll()

    if total > 0 then
        stealResult.Text = "Swords: " .. total .. " | Activated: " .. activated .. " | Bases: " .. bases
        stealResult.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        stealResult.Text = "No swords found!"
        stealResult.TextColor3 = Color3.fromRGB(255, 100, 100)
    end

    task.wait(0.3)
    stealButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

-- ============================================
-- CONEXAO - DELETE SECURITY
-- ============================================
deleteSecurityButton.MouseButton1Click:Connect(function()
    deleteSecurityButton.BackgroundColor3 = Color3.fromRGB(100, 40, 100)
    stealResult.Text = "Deleting security..."
    stealResult.TextColor3 = Color3.fromRGB(255, 200, 0)

    local deleted = deleteAllSecurity()

    if deleted > 0 then
        stealResult.Text = "Deleted " .. deleted .. " laser security systems!"
        stealResult.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        stealResult.Text = "No laser security found!"
        stealResult.TextColor3 = Color3.fromRGB(255, 100, 100)
    end

    task.wait(0.3)
    deleteSecurityButton.BackgroundColor3 = Color3.fromRGB(180, 30, 180)
end)

-- ============================================
-- CONEXAO - KILL AURA
-- ============================================
auraToggle.MouseButton1Click:Connect(function()
    killAuraActive = not killAuraActive
    if killAuraActive then
        auraToggle.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        auraToggle.Text = "WAITING..."
        auraStatus.Text = "Active! Equip a weapon..."
        auraStatus.TextColor3 = Color3.fromRGB(255, 200, 0)
        auraInfo.Text = "Equip a weapon to start"
        monitorCharacter()
        player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if killAuraActive then monitorCharacter() end
        end)
    else
        deactivateAura()
    end
end)

-- ============================================
-- ATUALIZAR LISTA DE PLAYERS
-- ============================================
local function updatePlayerList()
    for _, btn in pairs(playerButtons) do
        btn:Destroy()
    end
    playerButtons = {}

    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            local playerFrame = Instance.new("Frame")
            playerFrame.Name = targetPlayer.Name .. "_Frame"
            playerFrame.Size = UDim2.new(1, -8, 0, 28)
            playerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            playerFrame.BorderSizePixel = 0
            playerFrame.Parent = scrollFrame

            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = playerFrame

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
            nameLabel.Position = UDim2.new(0, 8, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = targetPlayer.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 12
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            nameLabel.Parent = playerFrame

            local isWl = whitelist[targetPlayer.Name] == true
            local wlBtn = Instance.new("TextButton")
            wlBtn.Size = UDim2.new(0.35, -4, 0, 22)
            wlBtn.Position = UDim2.new(0.63, 0, 0.5, -11)
            wlBtn.BackgroundColor3 = isWl and Color3.fromRGB(0, 180, 60) or Color3.fromRGB(180, 30, 30)
            wlBtn.Text = isWl and "Protected" or "Protect"
            wlBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            wlBtn.TextSize = 10
            wlBtn.Font = Enum.Font.GothamBold
            wlBtn.Parent = playerFrame

            local wlCorner = Instance.new("UICorner")
            wlCorner.CornerRadius = UDim.new(0, 6)
            wlCorner.Parent = wlBtn

            wlBtn.MouseButton1Click:Connect(function()
                if whitelist[targetPlayer.Name] then
                    whitelist[targetPlayer.Name] = nil
                    wlBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
                    wlBtn.Text = "Protect"
                else
                    whitelist[targetPlayer.Name] = true
                    wlBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
                    wlBtn.Text = "Protected"
                end
            end)

            table.insert(playerButtons, playerFrame)
        end
    end
end

Players.PlayerAdded:Connect(function()
    task.wait(0.3)
    updatePlayerList()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.3)
    updatePlayerList()
end)

spawn(function()
    while true do
        task.wait(3)
        if screenGui and screenGui.Parent then
            updatePlayerList()
        else
            break
        end
    end
end)

-- ============================================
-- FUNCIONALIDADE DE ARRASTAR A GUI
-- ============================================
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================
-- FUNCIONALIDADE MINIMIZAR
-- ============================================
local minimized = false
local originalSize = mainFrame.Size

minimizeButton.MouseButton1Click:Connect(function()
    if minimized then
        mainFrame.Size = originalSize
        minimizeButton.Text = "−"
        if currentScreen == "aura" then
            auraFrame.Visible = true
            farmFrame.Visible = false
            stealFrame.Visible = false
        elseif currentScreen == "farm" then
            auraFrame.Visible = false
            farmFrame.Visible = true
            stealFrame.Visible = false
        else
            auraFrame.Visible = false
            farmFrame.Visible = false
            stealFrame.Visible = true
        end
        homeButton.Visible = true
    else
        mainFrame.Size = UDim2.new(0, 340, 0, 42)
        minimizeButton.Text = "+"
        auraFrame.Visible = false
        farmFrame.Visible = false
        stealFrame.Visible = false
        homeButton.Visible = false
    end
    minimized = not minimized
end)

-- ============================================
-- FECHAR GUI
-- ============================================
closeButton.MouseButton1Click:Connect(function()
    autoAllActive = false
    killAuraActive = false
    if autoAllConnection then autoAllConnection:Disconnect() end
    if auraConnection then auraConnection:Disconnect() end
    screenGui:Destroy()
end)

-- ============================================
-- INICIALIZAR
-- ============================================
updatePlayerList()
print("BRBOX HUB - Auto Giver Edition v2 loaded!")
print("Screens: Kill Aura -> Auto All -> Steal & Destroy")
print("Auto All: 1 button does Giver + Clicker + Build")
print("Delete Security: Removes Lasers from OwnerOnlyDoor")
