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
