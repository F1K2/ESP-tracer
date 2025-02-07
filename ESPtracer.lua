-- TracersScript.lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Fonction pour créer un tracer
local function createTracer(targetPosition)
    local tracer = Instance.new("Part")
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.Size = Vector3.new(0.1, 0.1, (humanoidRootPart.Position - targetPosition).Magnitude)
    tracer.Material = Enum.Material.Neon
    tracer.Color = Color3.new(1, 0, 0)  -- Rouge, vous pouvez ajuster la couleur ici
    tracer.Transparency = 0.5
    tracer.Parent = workspace
    
    -- Positionner le tracer
    local midpoint = (humanoidRootPart.Position + targetPosition) / 2
    tracer.CFrame = CFrame.new(midpoint, targetPosition) * CFrame.Angles(math.pi/2, 0, 0)
    
    return tracer
end

-- Fonction pour mettre à jour les tracers
local function updateTracers(tracers, targets)
    for _, tracer in pairs(tracers) do
        tracer:Destroy()
    end
    
    local newTracers = {}
    for _, enemy in pairs(targets) do
        if enemy.Character then
            local head = enemy.Character:FindFirstChild("Head")
            if head then
                local newTracer = createTracer(head.Position)
                table.insert(newTracers, newTracer)
            end
        end
    end
    
    return newTracers
end

-- Liste des ennemis
local enemies = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then
        table.insert(enemies, p)
    end
end

local tracers = {}

-- Mise à jour des tracers à chaque frame
RunService.RenderStepped:Connect(function()
    tracers = updateTracers(tracers, enemies)
end)

-- Ajout de nouveaux joueurs en tant qu'ennemis
Players.PlayerAdded:Connect(function(newPlayer)
    if newPlayer ~= player then
        table.insert(enemies, newPlayer)
    end
end)

-- Suppression des joueurs déconnectés de la liste des ennemis
Players.PlayerRemoving:Connect(function(leftPlayer)
    for i, enemy in ipairs(enemies) do
        if enemy == leftPlayer then
            table.remove(enemies, i)
            break
        end
    end
end)
