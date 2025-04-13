-- UI_Library.lua
local UI_Library = {}
UI_Library.windowCount = 0
UI_Library.flags = {}

-- Service Shortcuts
local services = setmetatable({}, {
    __index = function(self, serviceName)
        local service = game:GetService(serviceName)
        if service then
            self[serviceName] = service
            return service
        else
            error(serviceName .. " is not a valid service.")
        end
    end
})

local mouse = services.Players.LocalPlayer:GetMouse()

-- Drag Functionality
local function dragFrame(frame, dragInput)
    local dragging
    local dragInput, mousePos, framePos

    dragInput = dragInput or frame

    dragInput.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    services.UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- Click Effect Functionality
local function clickEffect(frame)
    spawn(function()
        if frame.ClipsDescendants ~= true then
            frame.ClipsDescendants = true
        end

        local ripple = Instance.new("ImageLabel")
        ripple.Name = "Ripple"
        ripple.Parent = frame
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 1.0
        ripple.ZIndex = 8
        ripple.Image = "rbxassetid://2708891598"
        ripple.ImageTransparency = 0.8
        ripple.ScaleType = Enum.ScaleType.Fit
        ripple.ImageColor3 = Color3.fromRGB(131, 132, 255)
        ripple.Position = UDim2.new((mouse.X - ripple.AbsolutePosition.X) / frame.AbsoluteSize.X, 0, (mouse.Y - ripple.AbsolutePosition.Y) / frame.AbsoluteSize.Y, 0)

        services.TweenService:Create(ripple, TweenInfo.new(1), {Position = UDim2.new(-5.5, 0, -5.5, 0), Size = UDim2.new(12, 0, 12, 0)}):Play()
        wait(0.25)
        services.TweenService:Create(ripple, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()

        repeat wait() until ripple.ImageTransparency == 1
        ripple:Destroy()
    end)
end

-- Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = services.HttpService:GenerateGUID()
screenGui.Parent = services.RunService:IsStudio() and services.Players.LocalPlayer:WaitForChild("PlayerGui") or services.CoreGui

services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftShift and not gameProcessed then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- Window Functionality
function UI_Library:Window(title)
    local isOpen = false
    self.windowCount = self.windowCount + 1

    local topFrame = Instance.new("Frame")
    local windowLine = Instance.new("Frame")
    local windowLineGradient = Instance.new("UIGradient")
    local header = Instance.new("TextLabel")
    local windowToggle = Instance.new("TextButton")
    local windowToggleImg = Instance.new("ImageLabel")
    local bottomFrame = Instance.new("Frame")
    local bottomLayout = Instance.new("UIListLayout")
    local paddingFrame = Instance.new("Frame")

    topFrame.Name = "Top"
    topFrame.Parent = screenGui
    topFrame.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
    topFrame.BorderSizePixel = 0
    topFrame.Position = UDim2.new(0, 25, 0, -30 + 36 * self.windowCount + 6 * self.windowCount)
    topFrame.Size = UDim2.new(0, 212, 0, 36)
    dragFrame(topFrame)

    windowLine.Name = "WindowLine"
    windowLine.Parent = topFrame
    windowLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    windowLine.BorderSizePixel = 0
    windowLine.Position = UDim2.new(0, 0, 0, 34)
    windowLine.Size = UDim2.new(0, 212, 0, 2)

    windowLineGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(43, 43, 43)),
        ColorSequenceKeypoint.new(0.20, Color3.fromRGB(43, 43, 43)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(131, 132, 255)),
        ColorSequenceKeypoint.new(0.80, Color3.fromRGB(43, 43, 43)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(43, 43, 43))
    })
    windowLineGradient.Name = "WindowLineGradient"
    windowLineGradient.Parent = windowLine

    header.Name = "Header"
    header.Parent = topFrame
    header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    header.BackgroundTransparency = 1.0
    header.BorderSizePixel = 0
    header.Size = UDim2.new(0, 54, 0, 34)
    header.Font = Enum.Font.GothamSemibold
    header.Text = "   " .. tostring(title)
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextSize = 14.0
    header.TextXAlignment = Enum.TextXAlignment.Left

    windowToggle.Name = "WindowToggle"
    windowToggle.Parent = topFrame
    windowToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    windowToggle.BackgroundTransparency = 1.0
    windowToggle.BorderSizePixel = 0
    windowToggle.Position = UDim2.new(0.835, 0, 0, 0)
    windowToggle.Size = UDim2.new(0, 34, 0, 34)
    windowToggle.Font = Enum.Font.SourceSans
    windowToggle.Text = ""
    windowToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
    windowToggle.TextSize = 14.0

    windowToggleImg.Name = "WindowToggleImg"
    windowToggleImg.Parent = windowToggle
    windowToggleImg.AnchorPoint = Vector2.new(0.5, 0.5)
    windowToggleImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    windowToggleImg.BackgroundTransparency = 1.0
    windowToggleImg.BorderSizePixel = 0
    windowToggleImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    windowToggleImg.Size = UDim2.new(0, 18, 0, 18)
    windowToggleImg.Image = "rbxassetid://3926305904"
    windowToggleImg.ImageRectOffset = Vector2.new(524, 764)
    windowToggleImg.ImageRectSize = Vector2.new(36, 36)
    windowToggleImg.Rotation = 180

    bottomFrame.Name = "Bottom"
    bottomFrame.Parent = topFrame
    bottomFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    bottomFrame.BorderSizePixel = 0
    bottomFrame.ClipsDescendants = true
    bottomFrame.Position = UDim2.new(0, 0, 1, 0)
    bottomFrame.Size = UDim2.new(0, 212, 0, 0)

    bottomLayout.Name = "BottomLayout"
    bottomLayout.Parent = bottomFrame
    bottomLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    bottomLayout.SortOrder = Enum.SortOrder.LayoutOrder
    bottomLayout.Padding = UDim.new(0, 4)

    paddingFrame.Name = "PaddingThing"
    paddingFrame.Parent = bottomFrame
    paddingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    paddingFrame.BorderSizePixel = 0
    paddingFrame.Position = UDim2.new(0.263, 0, 0, 0)
    paddingFrame.Size = UDim2.new(0, 100, 0, 0)

    local function toggleWindow()
        if isOpen then
            return
        end
        isOpen = not isOpen
        local tweening = true
        services.TweenService:Create(bottomFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 212, 0, isOpen and bottomLayout.AbsoluteContentSize.Y + 4 or 0)}):Play()
        services.TweenService:Create(windowToggleImg, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = isOpen and 0 or 180}):Play()
        wait(0.25)
        tweening = false
    end

    local function adjustBottomSize()
        if tweening or not isOpen then
            return
        end
        bottomFrame.Size = UDim2.new(0, 212, 0, bottomLayout.AbsoluteContentSize.Y + 4)
    end

    bottomLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(adjustBottomSize)
    windowToggle.MouseButton1Click:Connect(toggleWindow)

    local elements = {}

    function elements:Label(text)
        local label = Instance.new("TextButton")
        label.Name = "Label"
        label.Parent = bottomFrame
        label.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
        label.BorderSizePixel = 0
        label.Size = UDim2.new(0, 203, 0, 26)
        label.AutoButtonColor = false
        label.Font = Enum.Font.GothamSemibold
        label.Text = tostring(text)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14.0
        return label
    end

    function elements:Button(text, callback)
        local buttonFrame = Instance.new("Frame")
        local button = Instance.new("TextButton")

        buttonFrame.Name = "ButtonObj"
        buttonFrame.Parent = bottomFrame
        buttonFrame.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
        buttonFrame.BorderSizePixel = 0
        buttonFrame.Size = UDim2.new(0, 203, 0, 36)

        button.Name = "Button"
        button.Parent = buttonFrame
        button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundTransparency = 1.0
        button.BorderSizePixel = 0
        button.Size = UDim2.new(0, 203, 0, 36)
        button.Font = Enum.Font.Gotham
        button.Text = "  " .. tostring(text)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14.0
        button.TextXAlignment = Enum.TextXAlignment.Left

        button.MouseEnter:Connect(function()
            services.TweenService:Create(buttonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
        end)

        button.MouseLeave:Connect(function()
            services.TweenService:Create(buttonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(43, 43, 43)}):Play()
        end)

        button.MouseButton1Click:Connect(function()
            spawn(function()
                clickEffect(button)
            end)
            callback()
        end)
    end

    function elements:Toggle(text, flag, default, callback, flagTable)
        flagTable = flagTable or self.flags
        flag = flag or services.HttpService:GenerateGUID()
        default = default or false
        flagTable[flag] = default

        local toggleFrame = Instance.new("Frame")
        local toggleText = Instance.new("TextButton")
        local toggleStatus = Instance.new("Frame")
        local toggleStatusRound = Instance.new("UICorner")

        toggleFrame.Name = "ToggleObj"
        toggleFrame.Parent = bottomFrame
        toggleFrame.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Size = UDim2.new(0, 203, 0, 36)

        toggleText.Name = "ToggleText"
        toggleText.Parent = toggleFrame
        toggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleText.BackgroundTransparency = 1.0
        toggleText.BorderSizePixel = 0
        toggleText.Size = UDim2.new(0, 203, 0, 36)
        toggleText.Font = Enum.Font.Gotham
        toggleText.Text = "  " .. tostring(text)
        toggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleText.TextSize = 14.0
        toggleText.TextXAlignment = Enum.TextXAlignment.Left

        toggleStatus.Name = "ToggleStatus"
        toggleStatus.Parent = toggleFrame
        toggleStatus.AnchorPoint = Vector2.new(0, 0.5)
        toggleStatus.BackgroundColor3 = default and Color3.fromRGB(14, 255, 110) or Color3.fromRGB(255, 44, 44)
        toggleStatus.BorderSizePixel = 0
        toggleStatus.Position = UDim2.new(0.847, 0, 0.5, 0)
        toggleStatus.Size = UDim2.new(0, 24, 0, 24)

        toggleStatusRound.CornerRadius = UDim.new(0, 4)
        toggleStatusRound.Name = "ToggleStatusRound"
        toggleStatusRound.Parent = toggleStatus

        if default then
            callback(true)
        end

        toggleText.MouseEnter:Connect(function()
            services.TweenService:Create(toggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
        end)

        toggleText.MouseLeave:Connect(function()
            services.TweenService:Create(toggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(43, 43, 43)}):Play()
        end)

        toggleText.MouseButton1Click:Connect(function()
            flagTable[flag] = not flagTable[flag]
            services.TweenService:Create(toggleStatus, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = flagTable[flag] and Color3.fromRGB(14, 255, 110) or Color3.fromRGB(255, 44, 44)}):Play()
            spawn(function()
                clickEffect(toggleText)
            end)
            callback(flagTable[flag])
        end)
    end

    function elements:Slider(text, flag, min, max, callback, default, flagTable)
        flagTable = flagTable or self.flags
        flag = flag or services.HttpService:GenerateGUID()
        default = default or min
        flagTable[flag] = default

        local sliderFrame = Instance.new("Frame")
        local sliderText = Instance.new("TextButton")
        local sliderBack = Instance.new("Frame")
        local sliderBackRound = Instance.new("UICorner")
        local sliderPart = Instance.new("Frame")
        local sliderPartRound = Instance.new("UICorner")
        local sliderValue = Instance.new("TextLabel")

        sliderFrame.Name = "SliderObj"
        sliderFrame.Parent = bottomFrame
        sliderFrame.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Size = UDim2.new(0, 203, 0, 36)

        sliderText.Name = "SliderText"
        sliderText.Parent = sliderFrame
        sliderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderText.BackgroundTransparency = 1.0
        sliderText.BorderSizePixel = 0
        sliderText.Size = UDim2.new(0, 203, 0, 36)
        sliderText.Font = Enum.Font.Gotham
        sliderText.Text = "  " .. tostring(text)
        sliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderText.TextSize = 14.0
        sliderText.TextXAlignment = Enum.TextXAlignment.Left

        sliderBack.Name = "SliderBack"
        sliderBack.Parent = sliderFrame
        sliderBack.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        sliderBack.BorderSizePixel = 0
        sliderBack.Position = UDim2.new(0.571, 0, 0.68, 0)
        sliderBack.Size = UDim2.new(0, 80, 0, 7)

        sliderBackRound.CornerRadius = UDim.new(0, 4)
        sliderBackRound.Name = "SliderBackRound"
        sliderBackRound.Parent = sliderBack

        sliderPart.Name = "SliderPart"
        sliderPart.Parent = sliderBack
        sliderPart.BackgroundColor3 = Color3.fromRGB(131, 133, 255)
        sliderPart.BorderSizePixel = 0
        sliderPart.Size = UDim2.new((default or 0) / max, 0, 1, 0)

        sliderPartRound.CornerRadius = UDim.new(0, 4)
        sliderPartRound.Name = "SliderPartRound"
        sliderPartRound.Parent = sliderPart

        sliderValue.Name = "SliderValue"
        sliderValue.Parent = sliderFrame
        sliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderValue.BackgroundTransparency = 1.0
        sliderValue.BorderSizePixel = 0
        sliderValue.Position = UDim2.new(0.571, 0, 0.167, 0)
        sliderValue.Size = UDim2.new(0, 80, 0, 16)
        sliderValue.Font = Enum.Font.Code
        sliderValue.Text = tostring(default)
        sliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderValue.TextSize = 14.0

        if default and default ~= min then
            callback(default)
        end

        local function updateSlider(input)
            local newSize = UDim2.new(math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1), 0, 1, 0)
            sliderPart:TweenSize(newSize, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.05, true)
            local newValue = math.floor(newSize.X.Scale * max / max * (max - min) + min)
            sliderValue.Text = tostring(newValue)
            flagTable[flag] = newValue
            callback(newValue)
        end

        sliderText.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                services.TweenService:Create(sliderPart, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                updateSlider(input)
                dragging = true
            end
        end)

        sliderText.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                services.TweenService:Create(sliderPart, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(131, 133, 255)}):Play()
                dragging = false
            end
        end)

        services.UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
    end

    return elements
end

return UI_Library
