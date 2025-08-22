--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

--// UI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "ESP_UI"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.fromOffset(200, 50)
mainFrame.Position = UDim2.fromOffset(30, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(30, 30)
closeBtn.Position = UDim2.fromScale(0.85, 0.1)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel = 2
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = mainFrame

local icon = Instance.new("ImageLabel")
icon.Size = UDim2.fromOffset(20,20)
icon.Position = UDim2.fromOffset(5, 15)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://6031094678" -- ikon default (bisa ganti)
icon.Parent = mainFrame

local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.fromOffset(120, 30)
espBtn.Position = UDim2.fromOffset(40, 10)
espBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
espBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
espBtn.BorderSizePixel = 2
espBtn.Text = "ESP: OFF"
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 14
espBtn.Parent = mainFrame

--// ESP Logic
local espEnabled = false
local espDrawings = {}

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    
    if not espEnabled then
        for _, v in pairs(espDrawings) do
            v:Remove()
        end
        espDrawings = {}
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

--// Update ESP
RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    
    local targets = CollectionService:GetTagged("ESPTarget") -- kasih tag "ESPTarget"
    
    -- Clear lama
    for _, v in pairs(espDrawings) do
        v.Visible = false
    end
    
    for _, obj in ipairs(targets) do
        if obj:IsA("BasePart") then
            local pos, onScreen = cam:WorldToViewportPoint(obj.Position)
            if onScreen then
                local label = espDrawings[obj]
                if not label then
                    label = Drawing.new("Text")
                    label.Size = 14
                    label.Color = Color3.fromRGB(255,255,255)
                    label.Center = true
                    label.Outline = true
                    label.Text = "TARGET"
                    espDrawings[obj] = label
                end
                label.Position = Vector2.new(pos.X, pos.Y)
                label.Visible = true
            end
        end
    end
end)
