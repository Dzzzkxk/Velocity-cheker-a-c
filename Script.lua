local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local KPH_SCALE = (10 / 12) * 1.09728

local function setupSpeedGui(player)
    -- Função interna para criar e atualizar a GUI
    local function onCharacter(character)
        local root = character:WaitForChild("HumanoidRootPart", 10)
        local head = character:WaitForChild("Head", 10)
        if not root or not head then return end

        -- Criar Billboard
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "SpeedDisplay"
        billboard.Size = UDim2.new(0, 150, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Adornee = head
        billboard.Parent = head
        billboard.MaxDistance = 1000

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0 -- Borda preta para ler melhor
        label.TextScaled = true
        label.Text = "0 KM/H"
        label.Parent = billboard

        -- Loop de atualização
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if character and character.Parent and root and label then
                local vel = root.AssemblyLinearVelocity
                local speed = (Vector3.new(vel.X, 0, vel.Z).Magnitude) * KPH_SCALE
                label.Text = string.format("%.1f KM/H", speed)
            else
                connection:Disconnect()
                billboard:Destroy()
            end
        end)
    end

    -- Se o personagem já existir (comum em executores), configura agora
    if player.Character then
        task.spawn(onCharacter, player.Character)
    end
    
    -- Configura para quando ele renascer
    player.CharacterAdded:Connect(onCharacter)
end

-- Rodar para todos os jogadores atuais
for _, player in ipairs(Players:GetPlayers()) do
    setupSpeedGui(player)
end

-- Rodar para novos jogadores que entrarem
Players.PlayerAdded:Connect(setupSpeedGui)
