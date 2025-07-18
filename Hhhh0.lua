local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Buscar posibles remotes peligrosos
local Events = {"meleeEvent", "ShootEvent", "ReloadEvent"}

-- Crear botón UI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "ExploitKillAll"

local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 160, 0, 50)
Button.Position = UDim2.new(1, -170, 0, 80)
Button.Text = "☠️ KILL ALL ☠️"
Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Button.TextColor3 = Color3.new(1,1,1)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 20
Button.Draggable = true
Button.Active = true

-- Ejecutar muerte masiva
Button.MouseButton1Click:Connect(function()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			
			if humanoid then
				-- 1. Intento de remotes vulnerables
				for _, eventName in pairs(Events) do
					local event = ReplicatedStorage:FindFirstChild(eventName)
					if event and event:IsA("RemoteEvent") then
						for i = 1, 10 do
							pcall(function()
								event:FireServer(player)
							end)
						end
					end
				end
				
				-- 2. Daño directo (solo si el servidor lo permite)
				pcall(function()
					humanoid:TakeDamage(999999)
				end)
				
				-- 3. Romper los joints (si no está protegido)
				pcall(function()
					player.Character:BreakJoints()
				end)
			end
		end
	end
end)
