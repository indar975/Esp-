-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Data penyimpanan ESP
local ESPEnabled = false
local ESPObjects = {}

-- Fungsi untuk membuat ESP per pemain
local function createESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local highlight = Instance.new("Highlight")
    highlight.Parent = char
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.new(1, 0, 0)

    ESPObjects[player] = highlight

    player.CharacterRemoving:Connect(function()
        if ESPObjects[player] then
            ESPObjects[player]:Destroy()
            ESPObjects[player] = nil
        end
    end)
end

-- Mengaktifkan atau menonaktifkan ESP
local function toggleESP(enabled)
    ESPEnabled = enabled
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            createESP(player)
        end
    else
        for _, obj in pairs(ESPObjects) do
            if obj then obj:Destroy() end
        end
        ESPObjects = {}
    end
end

-- Tambahkan ESP untuk pemain baru
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then
            createESP(player)
        end
    end)
end)

-- UI Draggable dengan tombol Toggle dan Close
do
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local Frame = Instance.new("Frame")
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 100, 0, 50)
    Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Frame.BackgroundTransparency = 0.5

    local DragFrame = Instance.new("Frame")
    DragFrame.Parent = Frame
    DragFrame.Size = UDim2.new(1, 0, 0, 18)
    DragFrame.BackgroundTransparency = 0.7
    DragFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DragFrame.Active = true

    local dragging, dragInput, dragStart, startPos
    DragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    DragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = Frame
    ToggleButton.Size = UDim2.new(1, -20, 1, -18)
    ToggleButton.Position = UDim2.new(0, 0, 0, 18)
    ToggleButton.Text = "ESP: OFF"
    ToggleButton.BackgroundTransparency = 0.6
    ToggleButton.BackgroundColor3 = Color3.new(0, 0, 0)
    ToggleButton.TextColor3 = Color3.new(1, 1, 1)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.TextSize = 14

    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = Frame
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(1, -20, 0, 0)
    CloseButton.Text = "X"
    CloseButton.BackgroundTransparency = 1
    CloseButton.TextColor3 = Color3.new(1, 0, 0)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.TextSize = 16

    ToggleButton.MouseButton1Click:Connect(function()
        ESPEnabled = not ESPEnabled
        toggleESP(ESPEnabled)
        ToggleButton.Text = ESPEnabled and "ESP: ON" or "ESP: OFF"
    end)

    CloseButton.MouseButton1Click:Connect(function()
        toggleESP(false)
        Frame:Destroy()
    end)
end
