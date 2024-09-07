local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Function to create a visually enhanced button
local function createButton(name, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 150, 0, 50)
    button.Position = position
    button.Text = name
    button.Font = Enum.Font.GothamSemibold
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
    button.Parent = screenGui

    -- Add UICorner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    -- Add UIStroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = button

    -- Add TextSizeConstraint
    local constraint = Instance.new("UITextSizeConstraint")
    constraint.MaxTextSize = 18
    constraint.Parent = button

    return button
end

-- Create buttons
local scrapCollectionButton = createButton("Scrap Collection", UDim2.new(0, 10, 0, 10))
local skinnyButton = createButton("Teleport to Skinny", UDim2.new(0, 10, 0, 70))
local shopButton = createButton("Teleport Shop", UDim2.new(0, 10, 0, 130))
local fullbrightButton = createButton("Fullbright: OFF", UDim2.new(0, 10, 0, 190))

-- Create toggle button
local toggleButton = createButton("Toggle", UDim2.new(0, 10, 0, 250))
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Text = "-"

-- Make toggle button draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Function to tween player to a part and highlight it
local function tweenToPart(part)
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if part then
        -- Remove existing highlights
        for _, highlight in ipairs(workspace:GetDescendants()) do
            if highlight:IsA("Highlight") then
                highlight:Destroy()
            end
        end

        -- Add new highlight
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.new(1, 1, 0) -- Yellow
        highlight.OutlineColor = Color3.new(1, 0.5, 0) -- Orange outline
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = part

        -- Tween to the part
        local tweenInfo = TweenInfo.new(
            1, -- Time
            Enum.EasingStyle.Quad, -- EasingStyle
            Enum.EasingDirection.Out -- EasingDirection
        )
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, {
            CFrame = part.CFrame
        })
        tween:Play()
        return tween
    else
        warn("Part not found!")
    end
end

-- Function to collect all scrap
local function collectAllScrap()
    local scrapFolder = workspace:FindFirstChild("Scrap")
    if not scrapFolder then
        warn("Scrap folder not found!")
        return
    end

    local function collectNextScrap()
        local scrapPart = scrapFolder:FindFirstChild("Circle") or scrapFolder:FindFirstChild("Pipe") or scrapFolder:FindFirstChild("Sheet")
        if scrapPart then
            local tween = tweenToPart(scrapPart)
            tween.Completed:Wait()
            task.wait(0.5) -- Wait a bit before moving to the next scrap
            collectNextScrap()
        else
            print("All scrap collected!")
        end
    end

    collectNextScrap()
end

-- ... (previous code remains the same)

-- Function to tween player to Skinny model
local function tweenToSkinny()
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local skinnyModel = workspace:FindFirstChild("Skinny", true)
    if skinnyModel then
        -- Remove existing highlights
        for _, highlight in ipairs(workspace:GetDescendants()) do
            if highlight:IsA("Highlight") then
                highlight:Destroy()
            end
        end

        -- Add new highlight
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.new(1, 0, 1) -- Magenta
        highlight.OutlineColor = Color3.new(0.5, 0, 0.5) -- Dark magenta outline
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = skinnyModel

        -- Tween to the Skinny model
        local tweenInfo = TweenInfo.new(
            1, -- Time
            Enum.EasingStyle.Quad, -- EasingStyle
            Enum.EasingDirection.Out -- EasingDirection
        )
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, {
            CFrame = skinnyModel:GetPivot()
        })
        tween:Play()
    else
        warn("Skinny model not found!")
    end
end


-- Function to tween player to Shop
local function tweenToShop()
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local shopCFrame = CFrame.new(-508.009735, 19.5572147, -704.674316, 0.979112864, 1.96838812e-08, 0.203317419, -1.36631675e-08, 1, -3.10160253e-08, -0.203317419, 2.75902305e-08, 0.979112864)

    -- Tween to the Shop location
    local tweenInfo = TweenInfo.new(
        1, -- Time
        Enum.EasingStyle.Quad, -- EasingStyle
        Enum.EasingDirection.Out -- EasingDirection
    )
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {
        CFrame = shopCFrame
    })
    tween:Play()
end

-- Fullbright variables
local defaultAmbient = Lighting.Ambient
local defaultOutdoorAmbient = Lighting.OutdoorAmbient
local defaultBrightness = Lighting.Brightness
local defaultExposureCompensation = Lighting.ExposureCompensation
local isFullbright = false

-- Function to toggle Fullbright
local function toggleFullbright()
    isFullbright = not isFullbright
    if isFullbright then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.ExposureCompensation = 0.5
        fullbrightButton.Text = "Fullbright: ON"
    else
        Lighting.Ambient = defaultAmbient
        Lighting.OutdoorAmbient = defaultOutdoorAmbient
        Lighting.Brightness = defaultBrightness
        Lighting.ExposureCompensation = defaultExposureCompensation
        fullbrightButton.Text = "Fullbright: OFF"
    end
end

-- Connect buttons to their respective functions
scrapCollectionButton.MouseButton1Click:Connect(collectAllScrap)
skinnyButton.MouseButton1Click:Connect(tweenToSkinny)
shopButton.MouseButton1Click:Connect(tweenToShop)
fullbrightButton.MouseButton1Click:Connect(toggleFullbright)

-- Function to toggle button visibility
local function toggleButtonsVisibility()
    local isVisible = scrapCollectionButton.Visible
    scrapCollectionButton.Visible = not isVisible
    skinnyButton.Visible = not isVisible
    shopButton.Visible = not isVisible
    fullbrightButton.Visible = not isVisible
    toggleButton.Text = isVisible and "+" or "-"
end

-- Connect toggle button
toggleButton.MouseButton1Click:Connect(function()
    if not dragging then
        toggleButtonsVisibility()
    end
end)

-- Add hover effects
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(41, 128, 185)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(52, 152, 219)}):Play()
    end)
end

addHoverEffect(scrapCollectionButton)
addHoverEffect(skinnyButton)
addHoverEffect(shopButton)
addHoverEffect(fullbrightButton)
addHoverEffect(toggleButton)
