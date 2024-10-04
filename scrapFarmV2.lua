-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Constants
local BUTTON_COLOR_ON = Color3.fromRGB(46, 204, 113)
local BUTTON_COLOR_OFF = Color3.fromRGB(52, 152, 219)
local BACKGROUND_COLOR = Color3.fromRGB(45, 45, 45)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local ITEM_TYPES = {"Circle", "Pipe", "Sheet", "Candy"}
local TELEPORT_HEIGHT = 3 -- Studs above the scrap to teleport

-- Variables
local LocalPlayer = Players.LocalPlayer
local isFarming = false
local isDragging = false
local dragStart, startPos
local debugMode = false
local characterFrozen = false

-- Debug Function
local function debugPrint(message)
    if debugMode then
        print("[DEBUG] " .. message)
    end
end

-- Helper Functions
local function createInstance(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function roundCorners(instance, radius)
    local uiCorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = instance
    })
end

-- GUI Creation
local ScreenGui = createInstance("ScreenGui", {
    Parent = LocalPlayer.PlayerGui
})

local MainFrame = createInstance("Frame", {
    Size = UDim2.new(0, 240, 0, 140),
    Position = UDim2.new(0.5, -120, 0.1, 0),
    BackgroundColor3 = BACKGROUND_COLOR,
    BorderSizePixel = 0,
    Parent = ScreenGui
})
roundCorners(MainFrame, 12)

local Title = createInstance("TextLabel", {
    Size = UDim2.new(1, -10, 0, 30),
    Position = UDim2.new(0, 5, 0, 5),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "Scrap Farmer",
    TextColor3 = TEXT_COLOR,
    TextSize = 18,
    Parent = MainFrame
})

local Button = createInstance("TextButton", {
    Size = UDim2.new(0.9, 0, 0, 40),
    Position = UDim2.new(0.05, 0, 0.25, 0),
    BackgroundColor3 = BUTTON_COLOR_OFF,
    Font = Enum.Font.GothamSemibold,
    Text = "Start Farming",
    TextColor3 = TEXT_COLOR,
    TextSize = 16,
    Parent = MainFrame
})
roundCorners(Button, 8)

local Counter = createInstance("TextLabel", {
    Size = UDim2.new(0.9, 0, 0, 25),
    Position = UDim2.new(0.05, 0, 0.6, 0),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamMedium,
    Text = "0 Items Remaining",
    TextColor3 = TEXT_COLOR,
    TextSize = 14,
    Parent = MainFrame
})

local DebugButton = createInstance("TextButton", {
    Size = UDim2.new(0.9, 0, 0, 30),
    Position = UDim2.new(0.05, 0, 0.8, 0),
    BackgroundColor3 = BUTTON_COLOR_OFF,
    Font = Enum.Font.GothamMedium,
    Text = "Debug: OFF",
    TextColor3 = TEXT_COLOR,
    TextSize = 14,
    Parent = MainFrame
})
roundCorners(DebugButton, 8)

local CloseButton = createInstance("TextButton", {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -30, 0, 5),
    BackgroundColor3 = Color3.fromRGB(200, 0, 0),
    Font = Enum.Font.GothamBold,
    Text = "X",
    TextColor3 = TEXT_COLOR,
    TextSize = 14,
    Parent = MainFrame
})
roundCorners(CloseButton, 8)

-- Character Freezing Functions
local function freezeCharacter()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.Anchored = true
        characterFrozen = true
        debugPrint("Character frozen")
    end
end

local function unfreezeCharacter()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.Anchored = false
        characterFrozen = false
        debugPrint("Character unfrozen")
    end
end

-- Farming Functions
local function updateCounter()
    local count = #workspace.Scrap:GetChildren()
    Counter.Text = count .. " Items Remaining"
    debugPrint("Counter updated: " .. count .. " items remaining")
end

local function findNextItem(itemTypes)
    for _, itemType in ipairs(itemTypes) do
        local item = workspace.Scrap:FindFirstChild(itemType)
        if item then
            debugPrint("Found item: " .. item.Name)
            return item
        end
    end
    debugPrint("No items found")
    return nil
end

-- ... (previous code remains the same)

-- ... (previous code remains the same)

local function triggerProximityPrompt(item)
    local proximityPrompt = item:FindFirstChildWhichIsA("ProximityPrompt")
    if proximityPrompt then
        debugPrint("Found ProximityPrompt, attempting to trigger")
        local maxAttempts = 5
        for _ = 1, maxAttempts do
            if proximityPrompt.Enabled then
                proximityPrompt:InputHoldBegin()
                if proximityPrompt.HoldDuration > 0 then
                    task.wait(proximityPrompt.HoldDuration)
                end
                proximityPrompt:InputHoldEnd()
                debugPrint("ProximityPrompt triggered")
                return true
            end
            task.wait(0.05)  -- Reduced wait time
        end
        debugPrint("Failed to trigger ProximityPrompt after " .. maxAttempts .. " attempts")
        return false
    else
        debugPrint("No ProximityPrompt found on the item")
        return false
    end
end

local function teleportToItem(item)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        debugPrint("Character or HumanoidRootPart not found")
        return false
    end
    
    local rootPart = character.HumanoidRootPart
    local itemPosition = item.Position
    local safePosition = itemPosition + Vector3.new(0, TELEPORT_HEIGHT, 0)
    
    debugPrint("Teleporting to: " .. tostring(safePosition))
    rootPart.CFrame = CFrame.new(safePosition)
    freezeCharacter()
    
    -- Trigger the ProximityPrompt immediately after teleporting
    return triggerProximityPrompt(item)
end

local function toggleFarming()
    isFarming = not isFarming
    Button.Text = isFarming and "Stop Farming" or "Start Farming"
    Button.BackgroundColor3 = isFarming and BUTTON_COLOR_ON or BUTTON_COLOR_OFF
    debugPrint("Farming toggled: " .. tostring(isFarming))
    
    if isFarming then
        task.spawn(function()
            while isFarming do
                updateCounter()
                local currentItem = findNextItem(ITEM_TYPES)
                if currentItem then
                    local success = teleportToItem(currentItem)
                    if success then
                        -- Wait for the item to be collected or a short timeout
                        local startTime = tick()
                        while currentItem.Parent and isFarming and tick() - startTime < 0.5 do
                            task.wait()
                        end
                    else
                        task.wait(0.1)  -- Short wait if teleport or prompt trigger failed
                    end
                else
                    task.wait(0.1)  -- Short wait if no item found
                end
            end
        end)
    else
        unfreezeCharacter()
    end
end

-- ... (rest of the code remains the same)

local function toggleDebug()
    debugMode = not debugMode
    DebugButton.Text = debugMode and "Debug: ON" or "Debug: OFF"
    DebugButton.BackgroundColor3 = debugMode and BUTTON_COLOR_ON or BUTTON_COLOR_OFF
    debugPrint("Debug mode toggled: " .. tostring(debugMode))
end

-- GUI Functionality
Button.MouseButton1Click:Connect(toggleFarming)
DebugButton.MouseButton1Click:Connect(toggleDebug)

CloseButton.MouseButton1Click:Connect(function()
    debugPrint("GUI closed")
    unfreezeCharacter()
    ScreenGui:Destroy()
end)

-- Dragging Functionality
local function updateDrag(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        debugPrint("Dragging started")
    end
end)

UserInputService.InputChanged:Connect(updateDrag)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
        debugPrint("Dragging ended")
    end
end)

-- Initial Setup
updateCounter()

-- Periodic Counter Update
task.spawn(function()
    while ScreenGui.Parent do
        updateCounter()
        task.wait(1)
    end
end)

-- Ensure character is unfrozen when the script ends
game.Players.LocalPlayer.CharacterRemoving:Connect(function()
    unfreezeCharacter()
end)

debugPrint("Script initialized")
