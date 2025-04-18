local StarterGui = game:GetService("StarterGui")
local bindable = Instance.new("BindableFunction")

function bindable.OnInvoke(response)
    print("")
end

StarterGui:SetCore("SendNotification", {
	Title = "Seb's Hub",
	Text = "Script loaded succesfully",
	Duration = 500,
	Callback = bindable,
	Button1 = "Close",
})

local Bracket = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Bracket/main/BracketV32.lua"))()
local Window = Bracket:Window({
    Name = "Seb's Hub",
    Enabled = true,
    Color = Color3.new(0.2, 0.6, 1),
    Size = UDim2.new(0, 600, 0, 450),
    Position = UDim2.new(0.5, -300, 0.5, -225)
})

local Tab = Window:Tab({Name = "Main"})
Tab:Divider({Text = "Combat", Side = "Left"})

local Toggle = Tab:Toggle({
    Name = "Aimbot",
    Side = "Left",
    Value = false,
    Callback = function(Bool)
        print("Feature enabled: ", Bool)
    end
})
