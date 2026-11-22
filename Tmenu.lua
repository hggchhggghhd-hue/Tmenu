-- T MENU | Roblox LocalScript
-- Đặt trong StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui")
gui.Name = "T_RGB_Menu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local settings = {
    Aim = false,
    ESP = false,
    Noclip = false,
    FOV = 120,
    MaxDistance = 200
}

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function stroke(obj)
    local s = Instance.new("UIStroke")
    s.Thickness = 2
    s.Parent = obj
    return s
end

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromOffset(58, 58)
toggle.Position = UDim2.new(0, 20, 0.35, 0)
toggle.Text = "T"
toggle.TextScaled = true
toggle.Font = Enum.Font.GothamBlack
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Parent = gui
corner(toggle, 18)
local toggleStroke = stroke(toggle)

local menu = Instance.new("Frame")
menu.Size = UDim2.fromOffset(280, 320)
menu.Position = UDim2.new(0.5, -140, 0.5, -160)
menu.BackgroundColor3 = Color3.fromRGB(25,25,35)
menu.Parent = gui
corner(menu, 16)
local menuStroke = stroke(menu)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 45)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "T | RGB MENU"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 21
title.Parent = menu

local function makeButton(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -30, 0, 42)
    b.Position = UDim2.fromOffset(15, y)
    b.BackgroundColor3 = Color3.fromRGB(45,45,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 15
    b.Font = Enum.Font.GothamBold
    b.Text = text .. " : OFF"
    b.Parent = menu
    corner(b, 10)

    b.MouseButton1Click:Connect(function()
        local enabled = callback()
        b.Text = text .. (enabled and " : ON" or " : OFF")
        b.BackgroundColor3 = enabled
            and Color3.fromRGB(35,125,85)
            or Color3.fromRGB(45,45,60)
    end)
    return b
end

makeButton("FOV AIM", 55, function()
    settings.Aim = not settings.Aim
    return settings.Aim
end)

makeButton("PLAYER ESP", 105, function()
    settings.ESP = not settings.ESP
    return settings.ESP
end)

makeButton("NOCLIP", 155, function()
    settings.Noclip = not settings.Noclip
    return settings.Noclip
end)

local fovText = Instance.new("TextLabel")
fovText.Size = UDim2.new(1, -30, 0, 28)
fovText.Position = UDim2.fromOffset(15, 207)
fovText.BackgroundTransparency = 1
fovText.TextColor3 = Color3.new(1,1,1)
fovText.TextSize = 15
fovText.Font = Enum.Font.GothamBold
fovText.Text = "FOV: 120"
fovText.Parent = menu

local slider = Instance.new("Frame")
slider.Size = UDim2.new(1, -40, 0, 12)
slider.Position = UDim2.fromOffset(20, 245)
slider.BackgroundColor3 = Color3.fromRGB(65,65,75)
slider.Parent = menu
corner(slider, 6)

local fill = Instance.new("Frame")
fill.Size = UDim2.fromScale(0.5, 1)
fill.BackgroundColor3 = Color3.fromRGB(0,200,255)
fill.Parent = slider
corner(fill, 6)

local draggingSlider = false

local function updateSlider(x)
    local ratio = math.clamp(
        (x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X,
        0, 1
    )
    settings.FOV = math.floor(40 + ratio * 160)
    fill.Size = UDim2.fromScale(ratio, 1)
    fovText.Text = "FOV: " .. settings.FOV
end

slider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
        updateSlider(input.Position.X)
    end
end)

UIS.InputChanged:Connect(function(input)
    if draggingSlider and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        updateSlider(input.Position.X)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

local distanceText = Instance.new("TextLabel")
distanceText.Size = UDim2.new(1, -20, 0, 30)
distanceText.Position = UDim2.fromOffset(10, 275)
distanceText.BackgroundTransparency = 1
distanceText.Text = "MAX DISTANCE: 200 STUDS"
distanceText.TextColor3 = Color3.new(1,1,1)
distanceText.TextSize = 13
distanceText.Font = Enum.Font.Gotham
distanceText.Parent = menu

-- Kéo menu và nút T trên điện thoại / PC
local function makeDraggable(object, handle)
    local active = false
    local startInput
    local startPosition
    local dragInput

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            active = true
            startInput = input.Position
            startPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    active = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if active and input == dragInput then
            local delta = input.Position - startInput
            object.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(menu, title)
makeDraggable(toggle, toggle)

toggle.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- Vòng FOV ở giữa màn hình
local circle = Instance.new("Frame")
circle.Name = "FOVCircle"
circle.AnchorPoint = Vector2.new(0.5,0.5)
circle.BackgroundTransparency = 1
circle.Parent = gui
corner(circle, 999)

local circleStroke = stroke(circle)
circleStroke.Thickness = 2

-- ESP chỉ dùng Players, không quét NPC
local highlights = {}

local function clearESP(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character

            if settings.ESP and character then
                if not highlights[player]
                    or highlights[player].Parent ~= character then

                    clearESP(player)

                    local h = Instance.new("Highlight")
                    h.Name = "T_PlayerESP"
                    h.FillTransparency = 0.65
                    h.OutlineTransparency = 0
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Adornee = character
                    h.Parent = character
                    highlights[player] = h
                end
            else
                clearESP(player)
            end
        end
    end
end

Players.PlayerRemoving:Connect(clearESP)

-- Khôi phục va chạm khi tắt Noclip
local originalCollision = {}

local function restoreCollision()
    for part, original in pairs(originalCollision) do
        if part and part.Parent then
            part.CanCollide = original
        end
    end
    table.clear(originalCollision)
end

-- Chọn người chơi thật gần tâm nhất trong FOV
local function getTarget()
    Camera = workspace.CurrentCamera
    if not Camera then return nil end

    local center = Camera.ViewportSize / 2
    local bestTarget = nil
    local bestScreenDistance = settings.FOV

    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter
        and myCharacter:FindFirstChild("HumanoidRootPart")

    if not myRoot then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local humanoid = character
                and character:FindFirstChildOfClass("Humanoid")
            local root = character
                and character:FindFirstChild("HumanoidRootPart")
            local head = character
                and character:FindFirstChild("Head")

            if humanoid and humanoid.Health > 0 and root and head then
                local worldDistance = (myRoot.Position - root.Position).Magnitude

                if worldDistance <= settings.MaxDistance then
                    local screenPos, visible = Camera:WorldToViewportPoint(head.Position)

                    if visible then
                        local screenDistance = (
                            Vector2.new(screenPos.X, screenPos.Y) - center
                        ).Magnitude

                        if screenDistance <= bestScreenDistance then
                            bestScreenDistance = screenDistance
                            bestTarget = head
                        end
                    end
                end
            end
        end
    end

    return bestTarget
end

local elapsed = 0
local lastNoclip = false

RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera
    if not Camera then return end

    elapsed += 1/60

    -- 7 màu RGB chuyển mượt
    local hue = (os.clock() / 8) % 1
    local rgb = Color3.fromHSV(hue, 1, 1)

    toggle.BackgroundColor3 = rgb
    toggle.TextColor3 = Color3.fromHSV((hue + 0.5) % 1, 1, 1)
    toggleStroke.Color = rgb
    menuStroke.Color = rgb
    title.TextColor3 = rgb
    fill.BackgroundColor3 = rgb
    circleStroke.Color = rgb

    circle.Visible = settings.Aim
    circle.Size = UDim2.fromOffset(settings.FOV * 2, settings.FOV * 2)
    circle.Position = UDim2.fromOffset(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    if settings.Aim then
        local target = getTarget()
        if target then
            Camera.CFrame = CFrame.lookAt(
                Camera.CFrame.Position,
                target.Position
            )
        end
    end

    if settings.Noclip then
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if originalCollision[part] == nil then
                        originalCollision[part] = part.CanCollide
                    end
                    part.CanCollide = false
                end
            end
        end
    elseif lastNoclip then
        restoreCollision()
    end

    lastNoclip = settings.Noclip
end)

task.spawn(function()
    while gui.Parent do
        updateESP()
        task.wait(0.25)
    end
end)