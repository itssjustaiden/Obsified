local plr = game:GetService("Players")
local lp = plr.LocalPlayer
local uis = game:GetService("UserInputService")
-- // Variable Setup \\ --
local CommandPrompt = Instance.new("ScreenGui")
local TopFrame = Instance.new("Frame")
local HideFrame = Instance.new("Frame")
local Header = Instance.new("TextLabel")
local Prompt = Instance.new("TextLabel")
local TextBox = Instance.new("TextBox")
local Icon = Instance.new("ImageLabel")
local Title = Instance.new("TextLabel")
local Close = Instance.new("TextButton")
local Hide = Instance.new("TextButton")
local Open = Instance.new("TextButton")
local dragging = false
local dragStart, startPos

-- // UI Setup \\ --
CommandPrompt.Name = "Command Prompt"
CommandPrompt.Parent = game.CoreGui
TopFrame.Name = "TopFrame"
TopFrame.Parent = CommandPrompt
TopFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopFrame.BorderSizePixel = 0
TopFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
TopFrame.Size = UDim2.new(0, 500, 0, 25)
HideFrame.Name = "HideFrame"
HideFrame.Parent = TopFrame
HideFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
HideFrame.BorderSizePixel = 0
HideFrame.Position = UDim2.new(0, 0, 1, 0)
HideFrame.Size = UDim2.new(0, 500, 0, 300)
Header.Parent = HideFrame
Header.BackgroundTransparency = 1
Header.Position = UDim2.new(0.006, 0, -0.03, 0)
Header.Size = UDim2.new(0, 375, 0, 50)
Header.Font = Enum.Font.Code
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextSize = 15
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Text = "Cats.lol [Version 1.0]\n© 2025 Cats.lol, All rights reserved."
Prompt.Parent = HideFrame
Prompt.BackgroundTransparency = 1
Prompt.Position = UDim2.new(0.006, 0, 0.133, 0)
Prompt.Size = UDim2.new(0, 155, 0, 15)
Prompt.Font = Enum.Font.Code
Prompt.TextColor3 = Color3.fromRGB(255, 255, 255)
Prompt.TextSize = 15
Prompt.TextXAlignment = Enum.TextXAlignment.Left
Prompt.Text = "C:\\Users\\" ..lp.Name.. ">"
TextBox.Parent = HideFrame
TextBox.BackgroundTransparency = 1
TextBox.Position = UDim2.new(0.316, 0, 0.133, 0)
TextBox.Size = UDim2.new(0, 341, 0, 260)
TextBox.Font = Enum.Font.Code
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 15
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top
TextBox.ClearTextOnFocus = false
TextBox.Text = ""
Icon.Parent = TopFrame
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0.006, 0, 0.12, 0)
Icon.Size = UDim2.new(0, 18, 0, 18)
Icon.Image = "http://www.roblox.com/asset/?id=5040009517"
Title.Parent = TopFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.048, 0, 0, 0)
Title.Size = UDim2.new(0, 100, 0, 24)
Title.Font = Enum.Font.SourceSans
Title.Text = "Command Prompt"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Close.Parent = TopFrame
Close.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(0.952, 0, 0, 0)
Close.Size = UDim2.new(0, 24, 0, 24)
Close.Font = Enum.Font.SourceSans
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 20
Close.TextYAlignment = Enum.TextYAlignment.Top
Close.MouseButton1Down:Connect(function() CommandPrompt:Destroy() end)
Hide.Parent = TopFrame
Hide.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Hide.BorderSizePixel = 0
Hide.Position = UDim2.new(0.856, 0, 0, 0)
Hide.Size = UDim2.new(0, 24, 0, 24)
Hide.Font = Enum.Font.SourceSans
Hide.Text = "-"
Hide.TextColor3 = Color3.fromRGB(255, 255, 255)
Hide.TextSize = 20
Hide.TextYAlignment = Enum.TextYAlignment.Top
Hide.MouseButton1Down:Connect(function() HideFrame.Visible = false Header.Visible = false Prompt.Visible = false end)
Open.Parent = TopFrame
Open.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Open.BorderSizePixel = 0
Open.Position = UDim2.new(0.904, 0, 0, 0)
Open.Size = UDim2.new(0, 24, 0, 24)
Open.Font = Enum.Font.SourceSans
Open.Text = "M"
Open.TextColor3 = Color3.fromRGB(255, 255, 255)
Open.TextSize = 20
Open.TextYAlignment = Enum.TextYAlignment.Top
Open.MouseButton1Down:Connect(function() HideFrame.Visible = true Header.Visible = true Prompt.Visible = true end)

TopFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = TopFrame.Position end
end)
uis.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		TopFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
uis.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)