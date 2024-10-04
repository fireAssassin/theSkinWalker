local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Window = Fluent:CreateWindow({
    Title = "XE Hub",
    SubTitle = "by .X.",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 360),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Create Tabs
local Tabs = {
    Collect = Window:AddTab({ Title = "Collect", Icon = "coins" }),
    Main = Window:AddTab({ Title = "Main", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Add Button to "Collect" Tab
Tabs.Collect:AddButton({
    Title = "Collect All Scrap",
    Description = "Collects scrap 1 by 1",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/jogosutora/theSkinWalker/refs/heads/main/scrapFarmV2.lua"))()
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
    Title = "Teleport Shop",
    Description = "Teleports player to the shop",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local shopCFrame = CFrame.new(-508.009735, 19.5572147, -704.674316)

        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, { CFrame = shopCFrame })
        tween:Play()
    end
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
            Lighting.Brightness = 2
            Lighting.ExposureCompensation = 0.5
        else
            Lighting.Ambient = defaultAmbient
            Lighting.OutdoorAmbient = defaultOutdoorAmbient
            Lighting.Brightness = defaultBrightness
            Lighting.ExposureCompensation = defaultExposureCompensation
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
    Title = "Teleport to Armory",
    Description = "Teleports player to the Armory,Just use Infinite Yield Noclip to get out",
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

-- Add the "Shop" tab
local ShopTab = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" })

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
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
    Title = "XE Hub",
    Content = "Script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
