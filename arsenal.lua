--[[
.____                     .___             ____   ________ 
|    |    _________     __| _/___________  \   \ /   /_   |
|    |   /  _ \__  \   / __ |/ __ \_  __ \  \   Y   / |   |
|    |__(  <_> ) __ \_/ /_/ \  ___/|  | \/   \     /  |   |
|_______ \____(____  /\____ |\___  >__|       \___/   |___|
        \/         \/      \/    \/                        
--]]

local StarterGui = game:GetService("StarterGui")
local bindable = Instance.new("BindableFunction")

function bindable.OnInvoke(response)
    print("LOADER V1")
end

StarterGui:SetCore("SendNotification", {
	Title = "Notification",
	Text = "Script loaded succesfully",
	Duration = 500,
	Callback = bindable,
	Button1 = "Close",
})
