local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Window = Fluent:CreateWindow({
    Title = "skinwalker script",
    SubTitle = "by yharim",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
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
        local function tweenToPart(part)
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            if part then
                for _, highlight in ipairs(workspace:GetDescendants()) do
                    if highlight:IsA("Highlight") then
                        highlight:Destroy()
                    end
                end

                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.new(1, 1, 0)
                highlight.OutlineColor = Color3.new(1, 0.5, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = part

                local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = TweenService:Create(humanoidRootPart, tweenInfo, { CFrame = part.CFrame })
                tween:Play()
                return tween
            else
                warn("Part not found!")
            end
        end

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
                    task.wait(0.5)
                    collectNextScrap()
                else
                    print("All scrap collected!")
                end
            end

            collectNextScrap()
        end

        collectAllScrap()
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
    Title = "Fluent",
    Content = "Script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
