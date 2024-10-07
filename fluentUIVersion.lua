local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local scrapFolder = Workspace:WaitForChild("Scrap")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local Window = Fluent:CreateWindow({
    Title = "XE Hub V2",
    SubTitle = "Last update:2024/10/08",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 360),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local success = true

local acPlayerScripts = LocalPlayer.PlayerScripts:FindFirstChild("AC")
if acPlayerScripts then
    acPlayerScripts:Destroy()
else
    success = false
end

local bug = game.ReplicatedStorage:FindFirstChild("Anticheat")
if bug then
    bug:Destroy()
else
    success = false
end

local acStarterPlayerScripts = game.StarterPlayer.StarterPlayerScripts:FindFirstChild("AC")
if acStarterPlayerScripts then
    acStarterPlayerScripts:Destroy()
else
    success = false
end

if success then
    Fluent:Notify({
        Title = "Bypassed Anticheat",
        Content = "The Anticheat has been bypassed..",
        Duration = 4
    })
else
    Fluent:Notify({
        Title = "Bypass Failed",
        Content = "The Anticheat Couldnt be bypassed.",
        Duration = 4
    })
end

-- Create Tabs
local Tabs = {
    Collect = Window:AddTab({ Title = "Collect", Icon = "coins" }),
    Main = Window:AddTab({ Title = "Main", Icon = "map-pin" }),
    Teleport = Window:AddTab({ Title = "Title TPs", Icon = "arrow-big-right" }),
    Gamepass = Window:AddTab({ Title = "Free Gamepass", Icon = "box" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Add Button to "Collect" Tab
Tabs.Collect:AddButton({
    Title = "Collect All Scrap Gui",
    Description = "Collects scrap 1 by 1",
    Callback = function()
            
        -- Create ScreenGui
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = LocalPlayer.PlayerGui
        
        -- Create Main Frame
        local MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 200, 0, 80)
        MainFrame.Position = UDim2.new(0.5, -100, 0.1, 0)
        MainFrame.BackgroundTransparency = 1
        MainFrame.Parent = ScreenGui
        
        -- Create Button
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 50)
        Button.Position = UDim2.new(0, 0, 0, 0)
        Button.Text = "Farming Scrap: OFF"
        Button.Parent = MainFrame
        
        -- Style the button
        Button.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.SourceSansBold
        Button.TextSize = 18
        
        -- Create Scrap Counter
        local ScrapCounter = Instance.new("TextLabel")
        ScrapCounter.Size = UDim2.new(1, 0, 0, 20)
        ScrapCounter.Position = UDim2.new(0, 0, 1, 0)
        ScrapCounter.Text = "0 Scraps Left"
        ScrapCounter.Parent = MainFrame
        ScrapCounter.BackgroundTransparency = 1
        ScrapCounter.TextColor3 = Color3.fromRGB(255, 255, 255)
        ScrapCounter.Font = Enum.Font.SourceSans
        ScrapCounter.TextSize = 14
        
        -- Create Close Button
        local CloseButton = Instance.new("TextButton")
        CloseButton.Size = UDim2.new(0, 20, 0, 20)
        CloseButton.Position = UDim2.new(1, -20, 0, 0)
        CloseButton.Text = "X"
        CloseButton.Parent = MainFrame
        CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.Font = Enum.Font.SourceSansBold
        CloseButton.TextSize = 14
        
        -- Create variables
        local isFarming = false
        local isDragging = false
        local dragStart = nil
        local startPos = nil
        
        -- Function to update scrap counter
        local function updateScrapCounter()
            local scrapCount = #workspace.Scrap:GetChildren()
            ScrapCounter.Text = scrapCount .. " Scraps Left"
        end
        
        -- Function to find the next available scrap
        local function findNextScrap()
            local scrapTypes = {"Circle", "Pipe", "Sheet"}
            for _, scrapType in ipairs(scrapTypes) do
                local scrap = workspace.Scrap:FindFirstChild(scrapType)
                if scrap then
                    return scrap
                end
            end
            return nil
        end
        
        -- Function to safely teleport player on top of scrap
        local function safeTeleportToScrap(scrap)
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            local rootPart = character.HumanoidRootPart
            
            -- Find the top surface of the scrap
            local scrapSize = scrap.Size
            local scrapCFrame = scrap.CFrame
            local topCenterPosition = scrapCFrame * Vector3.new(0, scrapSize.Y/2, 0)
            
            -- Set a safe height above the scrap
            local safeHeight = 5  -- Adjust this value as needed
            local safePosition = topCenterPosition + Vector3.new(0, safeHeight, 0)
            
            -- Teleport the player
            rootPart.CFrame = CFrame.new(safePosition)
        end
        
        -- Function to toggle farming
        local function toggleFarming()
            isFarming = not isFarming
            Button.Text = isFarming and "Farming Scrap: ON" or "Farming Scrap: OFF"
            Button.BackgroundColor3 = isFarming and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(52, 152, 219)
            
            if isFarming then
                spawn(function()
                    while isFarming do
                        updateScrapCounter()
                        local currentScrap = findNextScrap()
                        if currentScrap then
                            safeTeleportToScrap(currentScrap)
                            
                            -- Wait for the current scrap to disappear
                            while currentScrap.Parent == workspace.Scrap and isFarming do
                                wait(0.1)
                            end
                        else
                            -- No scrap found, wait before checking again
                            wait(0.5)
                        end
                        
                        -- Small delay before next iteration
                        wait(0.1)
                    end
                end)
            end
        end
        
        -- Button click event
        Button.MouseButton1Click:Connect(toggleFarming)
        
        -- Close button click event
        CloseButton.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)
        
        -- Dragging functionality
        MainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
            end
        end)
        
        UIS.InputChanged:Connect(function(input)
            if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                local newPosition = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale, 
                    startPos.Y.Offset + delta.Y
                )
                MainFrame.Position = newPosition
            end
        end)
        
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
            end
        end)
        
        -- Initial counter update
        updateScrapCounter()
        
        -- Set up counter to update periodically
        spawn(function()
            while wait(1) do  -- Update every second
                if ScreenGui.Parent then  -- Check if GUI still exists
                    updateScrapCounter()
                else
                    break  -- Stop updating if GUI is destroyed
                end
            end
        end)
    end
})

Tabs.Collect:AddButton({
    Title = "Bring Scraps",
    Description = "Teleports all Scraps to u",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        local function bringItemToPlayer(item)
            if item then
                local playerPosition = character.PrimaryPart.Position
                local newPosition = playerPosition - Vector3.new(0, 3, 0)
                item.Position = newPosition
            end
        end

        local children = workspace.Scrap:GetChildren()

        for i = 1, math.min(200, #children) do
            local scrapItem = children[i]
            
            if scrapItem.Name ~= "SpawnPoints" and scrapItem.Name ~= "UsedSpawns" and scrapItem.Name ~= "Candy" then
                bringItemToPlayer(scrapItem)
            end
        end
    end
})

Tabs.Collect:AddButton({
    Title = "Bring All Candies",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        local function bringItemToPlayer(item)
            if item then
                local playerPosition = character.PrimaryPart.Position
                local newPosition = playerPosition - Vector3.new(0, 3, 0)
                item.Position = newPosition
            end
        end

        local children = workspace.Scrap:GetChildren()

        for _, scrapItem in ipairs(children) do
            if scrapItem.Name == "Candy" then
                bringItemToPlayer(scrapItem)
            elseif scrapItem.Name ~= "Sheet" and scrapItem.Name ~= "Circle" and scrapItem.Name ~= "Pipe" and scrapItem.Name ~= "UsedSpawns" and scrapItem.Name ~= "SpawnPoints" then
            end
        end
    end
})

Tabs.Collect:AddButton({
    Title = "Instant Grab Candies & Scrap",
    Description = "Set all scraps and candies to be instantly grabbable, including new ones",
    Callback = function()
        local Workspace = game:GetService("Workspace")
        local scrapFolder = Workspace:WaitForChild("Scrap")

        local function setInstantGrab(item)
            local scrapTypes = {"Pipe", "Candy", "Sheet", "Circle"} -- Add other scrap names here
            
            if table.find(scrapTypes, item.Name) then
                local function setupPrompt()
                    local prompt = item:FindFirstChild("Grab")
                    
                    if prompt and prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                    else
                        -- If the prompt doesn't exist yet, wait for it to be added
                        item.ChildAdded:Connect(function(child)
                            if child.Name == "Grab" and child:IsA("ProximityPrompt") then
                                child.HoldDuration = 0
                            end
                        end)
                    end
                end
                
                setupPrompt()
                
                -- Handle case where the item might be replaced
                item.Changed:Connect(function(property)
                    if property == "Parent" and item.Parent == scrapFolder then
                        setupPrompt()
                    end
                end)
            end
        end

        -- Set instant grab for existing items
        for _, item in ipairs(scrapFolder:GetChildren()) do
            setInstantGrab(item)
        end
        
        -- Set instant grab for newly added items
        scrapFolder.ChildAdded:Connect(setInstantGrab)
            
        Fluent:Notify({
            Title = "Instant Grab Activated",
            Content = "All scraps and candies (including new ones) can now be grabbed instantly!",
            Duration = 5
        })
    end
})

Tabs.Collect:AddButton({
    Title = "Show Candy Amount",
    Description = "Display the current amount of candy for the local player",
    Callback = function()
        local player = Players.LocalPlayer
        local playerStats = player:FindFirstChild("playerstats")
        
        if playerStats then
            local candy = playerStats:FindFirstChild("Candy")
            if candy then
                local candyValue = candy.Value
                
                Fluent:Notify({
                    Title = "Candy Amount",
                    Content = "You currently have " .. tostring(candyValue) .. " candy.",
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Candy stat not found for the local player.",
                    Duration = 5
                })
            end
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Player stats not found for the local player.",
                Duration = 5
            })
        end
    end
})


-- Add Buttons to "Main" Tab
Tabs.Main:AddButton({
    Title = "Teleport to Skinny",
    Description = "Teleports player to Skinny",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local skinnyModel = workspace:FindFirstChild("Skinny", true)
        if skinnyModel then
            for _, highlight in ipairs(workspace:GetDescendants()) do
                if highlight:IsA("Highlight") then
                    highlight:Destroy()
                end
            end

            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.new(1, 0, 1)
            highlight.OutlineColor = Color3.new(0.5, 0, 0.5)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = skinnyModel

            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, { CFrame = skinnyModel:GetPivot() })
            tween:Play()
        else
            warn("Skinny model not found!")
        end
    end
})

Tabs.Main:AddButton({
    Title = "ESP Monsters",
    Description = "Supports to Skinny, Mimic, and Headless Horseman",
    Callback = function()
        local function addESP(model, color)
            if not model:FindFirstChild("Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = color
                highlight.OutlineColor = color:Lerp(Color3.new(0, 0, 0), 0.5)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = model
            end

            if not model:FindFirstChild("BillboardGui") then
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Size = UDim2.new(0, 200, 0, 50)
                billboardGui.AlwaysOnTop = true
                billboardGui.Parent = model

                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = model.Name
                textLabel.TextColor3 = color
                textLabel.TextStrokeTransparency = 0
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel.Font = Enum.Font.SourceSansBold
                textLabel.TextScaled = true
                textLabel.Parent = billboardGui

                RunService.RenderStepped:Connect(function()
                    local player = Players.LocalPlayer
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local distance = (character.HumanoidRootPart.Position - model.PrimaryPart.Position).Magnitude
                        textLabel.Text = string.format("%s [%.0fm away]", model.Name, distance)
                    end
                end)
            end
        end

        local function addTracer(model, color)
            local tracer = Drawing.new("Line")
            tracer.Visible = false
            tracer.Color = color
            tracer.Thickness = 2
            tracer.Transparency = 1

            RunService.RenderStepped:Connect(function()
                local player = Players.LocalPlayer
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") and model.PrimaryPart then
                    local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(model.PrimaryPart.Position)
                    if onScreen then
                        tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                        tracer.To = Vector2.new(vector.X, vector.Y)
                        tracer.Visible = true
                    else
                        tracer.Visible = false
                    end
                else
                    tracer.Visible = false
                end
            end)
        end

        local function checkAndAddESP()
            -- Check for Mimic in workspace
            local mimic = workspace:FindFirstChild("Mimic")
            if mimic then
                addESP(mimic, Color3.new(1, 0, 0))
                addTracer(mimic, Color3.new(1, 0, 0))
            end

            -- Check for Skinny and Headless Horseman in workspace.Alive
            local aliveFolder = workspace:FindFirstChild("Alive")
            if aliveFolder then
                local skinny = aliveFolder:FindFirstChild("Skinny")
                if skinny then
                    addESP(skinny, Color3.new(1, 0, 0))
                    addTracer(skinny, Color3.new(1, 0, 0))
                end

                local headlessHorseman = aliveFolder:FindFirstChild("Headless Horseman")
                if headlessHorseman then
                    addESP(headlessHorseman, Color3.new(1, 0.5, 0)) -- Orange color
                    addTracer(headlessHorseman, Color3.new(1, 0.5, 0))
                end
            end
        end

        checkAndAddESP()

    end
})

local weightLoopRunning = false

local function setWeight(value)
    local player = Players.LocalPlayer
    local localPlayer = Workspace.Alive:FindFirstChild(player.Name)
    if localPlayer and localPlayer:FindFirstChild("Weight") then
        localPlayer.Weight.Value = value
    end
end

local function weightLoop()
    while espEnabled do
        setWeight(0)
        task.wait(0.0001)
    end
    weightLoopRunning = false
end

local function toggleWeight(value)
    local player = Players.LocalPlayer
    espEnabled = value
    if espEnabled and not weightLoopRunning then
        weightLoopRunning = true
        weightLoop()
    elseif not espEnabled then
        setWeight(Workspace.Alive:FindFirstChild(player.Name).Weight.Value)
    end
end

local NoWeightToggle = Tabs.Main:AddToggle("NoWeight", {
    Title = "No Weight",
    Default = false,
    Callback = function(Value)
        toggleWeight(Value)
    end
})

toggleWeight(false)


Tabs.Main:AddButton({
    Title = "Teleport Shop",
    Description = "Teleports player to the shop",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local shopCFrame = CFrame.new(-508.009735, 19.5572147, -704.674316)

        humanoidRootPart.CFrame = shopCFrame
    end
})

Tabs.Main:AddButton({
    Title = "Instant Generator Switch",
    Description = "Lets you Instantly Turn on generator.",
    Callback = function()
        local generatorPrompt = workspace.MapEnvironment.Interactable.Generator:WaitForChild("ProximityPrompt")
        
        -- Wait for the prompt to be enabled
        while not generatorPrompt.Enabled do
            task.wait(0.1)
        end
        
        -- Set HoldDuration to 0 for instant activation
        generatorPrompt.HoldDuration = 0
        
        print("Generator prompt modified for instant activation!")
    end
})

Tabs.Main:AddButton({
    Title = "Delete Bear Traps",
    Callback = function()
        local hazardsFolder = game.Workspace:FindFirstChild("Hazards")

        if not hazardsFolder then
            Fluent:Notify({
                Title = "Wrong game!",
                Content = "Bear Traps path not found. You might be in the wrong game.",
                Duration = 5
            })
            return
        end

        local trapNames = {
            BearTraps = "bear trap",
            PlayerBearTraps = "PlayerBearTrap"
        }

        for folderName, trapName in pairs(trapNames) do
            local trapsFolder = hazardsFolder:FindFirstChild(folderName)
            if trapsFolder then
                for _, trap in ipairs(trapsFolder:GetChildren()) do
                    if trap.Name == trapName then
                        trap:Destroy()
                    end
                end
            end
        end

        Fluent:Notify({
            Title = "Bear Traps Deleted!",
            Content = "You have successfully deleted the Bear Traps.",
            Duration = 5
        })
    end,
})

Tabs.Main:AddButton({
    Title = "Delete Land Mines",
    Callback = function()
        local hazardsFolder = game.Workspace:FindFirstChild("Hazards")

        if not hazardsFolder then
            Fluent:Notify({
            Title = "Wrong game!",
            Content = "Mines path not found. You might be in the wrong game.",
            Duration = 6.5
        })
            return
        end

        local function deleteMines(folderName)
            local minesFolder = hazardsFolder:FindFirstChild(folderName)
            if minesFolder then
                for _, mine in ipairs(minesFolder:GetChildren()) do
                    if mine:IsA("BasePart") or mine:IsA("Model") then
                        mine:Destroy()
                    end
                end
            end
        end

        deleteMines("Mines")
        deleteMines("PlayerMines")

        Fluent:Notify({
            Title = "Land Mines Deleted!",
            Content = "All Land Mines in the game have been deleted.",
            Duration = 6.5
        })
    end,
})

-- Add "Infinite Power and Stamina" Button to Main Tab
Tabs.Main:AddButton({
    Title = "Infinite Power and Stamina",
    Description = "Locks Power and Stamina to 100",
    Callback = function()
        -- Get the LocalPlayer
        local player = game.Players.LocalPlayer

        -- Wait for the character to load, in case it's not already
        local character = player.Character or player.CharacterAdded:Wait()

        -- Get the Stamina and Power values from the character
        local staminaValue = character:WaitForChild("Stamina")
        local powerValue = character:WaitForChild("Power")

        -- Function to lock the given stat (Stamina or Power) to 100
        local function lockStat(stat)
            -- Set stat value to 100
            stat.Value = 100

            -- Whenever the stat value is changed, reset it to 100
            stat.Changed:Connect(function()
                if stat.Value ~= 100 then
                    stat.Value = 100
                end
            end)
        end

        -- Call the function to lock both Stamina and Power
        lockStat(staminaValue)
        lockStat(powerValue)
    end
})

Tabs.Main:AddButton({
    Title = "Infinite Rifle Ammo",
    Description = "Locks Ammo to 6/6",
    Callback = function()
         -- Get the LocalPlayer
        local player = game.Players.LocalPlayer
        
        -- Get the Ammo value from the Hunting Rifle in the Backpack
        local huntingRifle = player.Backpack:WaitForChild("Hunting Rifle")
        local ammoValue = huntingRifle:WaitForChild("Ammo")
        
        -- Function to lock the Ammo value to 6
        local function lockAmmo()
            -- Set ammo value to 6
            ammoValue.Value = 6
        
            -- Whenever the ammo value is changed, reset it to 100
            ammoValue.Changed:Connect(function()
                if ammoValue.Value ~= 6 then
                    ammoValue.Value = 6
                end
            end)
        end
        
        -- Call the function to lock Ammo
        lockAmmo()
    end
})

Tabs.Main:AddButton({
    Title = "Toggle Fullbright",
    Description = "Toggles Fullbright mode",
    Callback = function()
        local defaultAmbient = Lighting.Ambient
        local defaultOutdoorAmbient = Lighting.OutdoorAmbient
        local defaultBrightness = Lighting.Brightness
        local defaultExposureCompensation = Lighting.ExposureCompensation
        local isFullbright = false

        isFullbright = not isFullbright
        if isFullbright then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.Brightness = 3
            Lighting.TimeOfDay = "12:00"
        else
            Lighting.Ambient = defaultAmbient
            Lighting.OutdoorAmbient = defaultOutdoorAmbient
            Lighting.Brightness = defaultBrightness
            Lighting.ExposureCompensation = defaultExposureCompensation
        end
    end
})

Tabs.Gamepass:AddButton({
    Title = "Free Sixth Sense",
    Callback = function()
        if not game.Players.LocalPlayer then
            return
        end

        local gamepassesFolder = game.Players.LocalPlayer:FindFirstChild("Gamepasses")

        local sixthSenseFolder = Instance.new("Folder")
        sixthSenseFolder.Name = "SixthSense"
        sixthSenseFolder.Archivable = true
        sixthSenseFolder.Parent = gamepassesFolder
    end
})

Tabs.Gamepass:AddButton({
    Title = "Free VIP",
    Callback = function()
        if not game.Players.LocalPlayer then
            return
        end

        local gamepassesFolder = game.Players.LocalPlayer:FindFirstChild("Gamepasses")

        local vipFolder = Instance.new("Folder")
        vipFolder.Name = "VIP"
        vipFolder.Archivable = true
        vipFolder.Parent = gamepassesFolder
    end
})

Tabs.Gamepass:AddButton({
    Title = "Free Headlight",
    Callback = function()
        if not game.Players.LocalPlayer then
            return
        end

        local gamepassesFolder = game.Players.LocalPlayer:FindFirstChild("Gamepasses")

        local hlFolder = Instance.new("Folder")
        hlFolder.Name = "HeadLight"
        hlFolder.Archivable = true
        hlFolder.Parent = gamepassesFolder
    end
})

Tabs.Gamepass:AddButton({
    Title = "Free HP Regen",
    Callback = function()
        if not game.Players.LocalPlayer then
            return
        end
        local gpFolder = game.Players.LocalPlayer:FindFirstChild("Gamepasses")
        
        local hpRegenFolder = Instance.new("Folder")
        hpRegenFolder.Name = "HPRegen"
        hpRegenFolder.Archivable = true
        hpRegenFolder.Parent = gpFolder
    end
})

Tabs.Gamepass:AddButton({
    Title = "Notify Owned Gamepasses",
    Description = "Display a list of gamepasses owned by the local player",
    Callback = function()
        local player = Players.LocalPlayer
        local gamepassesFolder = player:FindFirstChild("Gamepasses")
        
        if gamepassesFolder then
            local ownedGamepasses = {}
            for _, gamepass in ipairs(gamepassesFolder:GetChildren()) do
                table.insert(ownedGamepasses, gamepass.Name)
            end
            
            if #ownedGamepasses > 0 then
                local gamepassList = table.concat(ownedGamepasses, ", ")
                print("You Have Gamepasses: " .. gamepassList)
                
                Fluent:Notify({
                    Title = "Owned Gamepasses",
                    Content = "You have the gamepasses: " .. gamepassList,
                    Duration = 7
                })
            else
                print("You Have Gamepasses: None")
                
                Fluent:Notify({
                    Title = "Owned Gamepasses",
                    Content = "You don't own any gamepasses.",
                    Duration = 5
                })
            end
        else
            print("Gamepasses folder not found.")
            
            Fluent:Notify({
                Title = "Error",
                Content = "Gamepasses folder not found for the local player.",
                Duration = 5
            })
        end
    end
})

-- tp tab
Tabs.Teleport:AddButton({
    Title = "Teleport to Generator",
    Callback = function()
        local player = game.Players.LocalPlayer
        local target = game.Workspace.MapEnvironment.Interactable.Generator

        local function teleportPlayer()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = target.CFrame
            end
        end

        teleportPlayer()
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Safe-House",
    Callback = function()
        Fluent:Notify({
            Title = "Successfully Teleported!",
            Content = "You have successfully teleported to the Safe House.",
            Duration = 6.5
        })
        local player = game.Players.LocalPlayer

        local function teleportPlayer()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local x = 302.7801513671875
                local y = 22.24676513671875
                local z = 428.24334716796875
                player.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
            end
        end
        
        teleportPlayer()
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Graveyard",
    Description = "Teleport the local player to the Graveyard",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        local tpFolder = Workspace:FindFirstChild("TP")
        local graveyardPart = tpFolder and tpFolder:FindFirstChild("Graveyard")
        
        if humanoidRootPart and graveyardPart then
            humanoidRootPart.CFrame = graveyardPart.CFrame
            
            Fluent:Notify({
                Title = "Teleportation Successful",
                Content = "You have been teleported to the Graveyard.",
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "Teleportation Failed",
                Content = "Could not teleport to the Graveyard. Make sure you're spawned in the game.",
                Duration = 5
            })
        end
    end
})

-- Add the "Armory" Tab with the shield icon
local ArmoryTab = Window:AddTab({ Title = "Armory", Icon = "shield" })

-- Function to teleport to a specific child of workspace.Armory.Codes
local function teleportToCode(index)
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Access the Armory and Codes folder
    local armory = workspace:FindFirstChild("Armory")
    if armory and armory:FindFirstChild("Codes") then
        local codesFolder = armory.Codes
        local targetCode = codesFolder:GetChildren()[index] -- Get the specific child by index

        if targetCode then
            -- Tween to the selected code
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, {
                CFrame = targetCode.Symbol.CFrame -- Assuming it's a part or model with a CFrame
            })
            tween:Play()

            -- Add highlight to the part
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.new(0, 1, 0) -- Green highlight
            highlight.OutlineColor = Color3.new(0, 0.5, 0) -- Dark green outline
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = targetCode

        else
            warn("Code with index " .. index .. " not found!")
        end
    else
        warn("Armory or Codes folder not found!")
    end
end

-- Add buttons to the "Armory" Tab for each code
for i = 1, 6 do
    ArmoryTab:AddButton({
        Title = "Teleport to Code 0" .. i,
        Description = "Teleports player to Code 0" .. i,
        Callback = function()
            teleportToCode(i) -- Teleport to the nth child of workspace.Armory.Codes
        end
    })
end

-- Add the "Teleport to Armory" Button
ArmoryTab:AddButton({
    Title = "Teleport inside Armory",
    Description = "Teleports player inside the Armory,Just use Infinite Yield Noclip to get out",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        -- Find the Armory in the workspace
        local armory = workspace.Armory:FindFirstChild("Armory")
        if armory then
            -- Tween to the Armory
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, {
                CFrame = armory:GetPivot() -- Assuming it's a model, using GetPivot
            })
            tween:Play()
        else
            warn("Armory not found!")
        end
    end
})

ArmoryTab:AddButton({
    Title = "Enable Hunting Rifle Prompt",
    Description = "Allows you to interact hunting rifle even if armory is closed.",
    Callback = function()
        local riflePrompt = workspace.Armory.Armory.Hitbox.Claim:WaitForChild("ProximityPrompt")
        
        riflePrompt.Enabled = true
        riflePrompt.HoldDuration = 0
        
        print("Hunting Rifle prompt enabled!")
    end
})

-- Add a button to execute Infinite Yield
Tabs.Main:AddButton({
    Title = "Execute Infinite Yield",
    Description = "Runs the Infinite Yield admin script",
    Callback = function()
        -- Load and execute the Infinite Yield script
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})

-- Add a button to execute Keyboard Script
Tabs.Main:AddButton({
    Title = "Execute Keyboard Script",
    Description = "Runs the keyboard script for mobile access. By default,Use LeftControl for Keybind.",
    Callback = function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/RedZenXYZ/4d80bfd70ee27000660e4bfa7509c667/raw/da903c570249ab3c0c1a74f3467260972c3d87e6/KeyBoard%2520From%2520Ohio%2520Fr%2520Fr"))()
    end
})

-- Add the "Shop" Tab with an icon (for example, "shopping-cart" icon)
local ShopTab = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" })

ShopTab:AddButton({
    Title = "Open Shop UI",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local Lighting = game:GetService("Lighting")
        
        local LocalPlayer = Players.LocalPlayer
        local ShopOpen = false
        local isTransitioning = false
        
        local function updatePrices(ShopGUI)
            for _, v in ShopGUI:WaitForChild("ScrollingFrame"):GetChildren() do
                if v:IsA("Frame") then
                    local Price = v:FindFirstChild("Price")
                    if Price and ReplicatedStorage.Prices:FindFirstChild(v.Name) then
                        Price.Text = ReplicatedStorage.Prices[v.Name].Value .. " CR"
                    end
                end
            end
        end
        
        local function closeShop(ShopGUIClone, ShopGUI)
            if isTransitioning then return end
            isTransitioning = true
            
            ShopGUI.Close:Play()
            TweenService:Create(Lighting.ShopBlur, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = 0}):Play()
            
            local closeTween = TweenService:Create(ShopGUI, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(1.5, 0, 0.5, 0)})
            closeTween:Play()
            closeTween.Completed:Wait()
            
            ShopGUIClone:Destroy()
            ShopOpen = false
            isTransitioning = false
        end
        
        local function openShop()
            if ShopOpen then return end
            ShopOpen = true
        
            local ShopGUIClone = ReplicatedStorage:WaitForChild("ShopGUI"):Clone()
            ShopGUIClone.Parent = LocalPlayer.PlayerGui
            local ShopGUI = ShopGUIClone:WaitForChild("ShopGUI")
        
            TweenService:Create(Lighting.ShopBlur, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = 15}):Play()
            ShopGUI.Open:Play()
            ShopGUI.Position = UDim2.new(1.5, 0, 0.5, 0)
        
            TweenService:Create(ShopGUI, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
            
            updatePrices(ShopGUI)
        
            local CloseButton = ShopGUI:WaitForChild("CloseButton")
            CloseButton.Activated:Connect(function()
                if not isTransitioning then
                    closeShop(ShopGUIClone, ShopGUI)
                end
            end)
        end
        
        local function toggleShop()
            if ShopOpen then
                closeShop(LocalPlayer.PlayerGui:FindFirstChild("ShopGUI"), LocalPlayer.PlayerGui:FindFirstChild("ShopGUI"))
            else
                openShop()
            end
        end
        
        toggleShop()
    end
})

-- Function to handle buying items
local function buyItem(itemName)
    local args = {
        [1] = itemName
    }

    game:GetService("ReplicatedStorage").ShopRemotes.Buy:FireServer(unpack(args))
end

-- Add buttons for each item in the shop

local function addBuyButtons()
    local prices = game:GetService("ReplicatedStorage"):FindFirstChild("Prices")
    if prices then
        for _, item in ipairs(prices:GetChildren()) do
            ShopTab:AddButton({
                Title = "Buy " .. item.Name,
                Description = "Purchase " .. item.Name .. " for " .. item.Value .. " coins",
                Callback = function()
                    buyItem(item.Name)
                end
            })
        end
    else
        warn("Prices folder not found in ReplicatedStorage")
    end
end

-- Call the function to add buy buttons
addBuyButtons()

-- Add Settings Tab
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("xehub")
SaveManager:SetFolder("xehub/tsw")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
    Title = "XE v2",
    Content = "Script has been loaded.",
    Duration = 8
})


SaveManager:LoadAutoloadConfig()

