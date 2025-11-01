--// Services \\--
local plr = game:GetService("Players")
local lp = plr.LocalPlayer
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")
local rsc = game:GetService("RunService")
local reps = game:GetService("ReplicatedStorage")

--// Variables \\--
local Library = {}
local isMobile = uis.TouchEnabled and not uis.KeyboardEnabled

--// Functions \\--
local function hexColor(hex)
	hex = hex:gsub("#","")
	return Color3.fromRGB(tonumber(hex:sub(1,2),16), tonumber(hex:sub(3,4),16), tonumber(hex:sub(5,6),16))
end

--// Create Window \\--
function Library:CreateWindow(config)
    local Window = {}
    Window.Commands = {}
    local CommandPrompt = Instance.new("ScreenGui")
    local TopFrame, HideFrame, Header, Prompt, TextBox, Icon, Title, Close, Hide, Open = Instance.new("Frame"), Instance.new("Frame"), Instance.new("TextLabel"), Instance.new("TextLabel"), Instance.new("TextBox"), Instance.new("ImageLabel"), Instance.new("TextLabel"), Instance.new("TextButton"), Instance.new("TextButton"), Instance.new("TextButton")
    local dragging, dragStart, startPos = false, nil, nil
    local cmdFolder = cg:FindFirstChild("CMD") or Instance.new("Folder")
    cmdFolder.Name = "CMD"
    cmdFolder.Parent = cg
    CommandPrompt.Name = "Command Prompt"
    CommandPrompt.Parent = cmdFolder
    TopFrame.Name = "TopFrame"
    TopFrame.Parent = CommandPrompt
    TopFrame.BackgroundColor3 = hexColor("#ffffff")
    TopFrame.BorderSizePixel = 0
    TopFrame.Position = UDim2.new(0.3,0,0.25,0)
    TopFrame.Size = config.Size or UDim2.new(0,500,0,25)
    HideFrame.Name = "HideFrame"
    HideFrame.Parent = TopFrame
    HideFrame.BackgroundColor3 = hexColor("#121212")
    HideFrame.BorderSizePixel = 0
    HideFrame.Position = UDim2.new(0,0,1,0)
    HideFrame.Size = UDim2.new(0,500,0,300)
    Header.Parent = HideFrame
    Header.BackgroundTransparency = 1
    Header.Position = UDim2.new(0.006,0,-0.03,0)
    Header.Size = UDim2.new(0,375,0,50)
    Header.Font = Enum.Font.Code
    Header.TextColor3 = hexColor("#00c23a")
    Header.TextSize = 15
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Text = "Microsoft Windows [Version 10.0.19045.6456]\n© Microsoft Corporation. All rights reserved."
    Prompt.Parent = HideFrame
    Prompt.BackgroundTransparency = 1
    Prompt.Position = UDim2.new(0.006,0,0.133,0)
    Prompt.Size = UDim2.new(0,155,0,15)
    Prompt.Font = Enum.Font.Code
    Prompt.TextColor3 = hexColor("#00c23a")
    Prompt.TextSize = 15
    Prompt.TextXAlignment = Enum.TextXAlignment.Left
    Prompt.Text = "C:\\Users\\"..lp.Name..">"
    TextBox.Parent = HideFrame
    TextBox.BackgroundTransparency = 1
    TextBox.Position = UDim2.new(0.316,0,0.133,0)
    TextBox.Size = UDim2.new(0,341,0,260)
    TextBox.Font = Enum.Font.Code
    TextBox.TextColor3 = hexColor("#00c23a")
    TextBox.TextSize = 15
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.TextYAlignment = Enum.TextYAlignment.Top
    TextBox.ClearTextOnFocus = false
    TextBox.Text = ""
    Icon.Parent = TopFrame
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(0.006,0,0.12,0)
    Icon.Size = UDim2.new(0,18,0,18)
    Icon.Image = "http://www.roblox.com/asset/?id=5040009517"
    Title.Parent = TopFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.048,0,0,0)
    Title.Size = UDim2.new(0,100,0,24)
    Title.Font = Enum.Font.SourceSans
    Title.Text = "Command Prompt"
    Title.TextColor3 = hexColor("#000000")
    Title.TextSize = 14
    Close.Parent = TopFrame; Close.BackgroundColor3 = hexColor("#ffffff"); Close.BorderSizePixel = 0; Close.Position = UDim2.new(0.952,0,0,0); Close.Size = UDim2.new(0,24,0,24); Close.Font = Enum.Font.SourceSans; Close.Text = "X"; Close.TextColor3 = hexColor("#000000"); Close.TextSize = 20; Close.TextYAlignment = Enum.TextYAlignment.Top; Close.MouseButton1Down:Connect(function() CommandPrompt:Destroy() end)
    Hide.Parent = TopFrame; Hide.BackgroundColor3 = hexColor("#ffffff"); Hide.BorderSizePixel = 0; Hide.Position = UDim2.new(0.856,0,0,0); Hide.Size = UDim2.new(0,24,0,24); Hide.Font = Enum.Font.SourceSans; Hide.Text = "-"; Hide.TextColor3 = hexColor("#000000"); Hide.TextSize = 20; Hide.TextYAlignment = Enum.TextYAlignment.Top; Hide.MouseButton1Down:Connect(function() HideFrame.Visible=false Header.Visible=false Prompt.Visible=false end)
    Open.Parent = TopFrame; Open.BackgroundColor3 = hexColor("#ffffff"); Open.BorderSizePixel = 0; Open.Position = UDim2.new(0.904,0,0,0); Open.Size = UDim2.new(0,24,0,24); Open.Font = Enum.Font.SourceSans; Open.Text = "M"; Open.TextColor3 = hexColor("#000000"); Open.TextSize = 20; Open.TextYAlignment = Enum.TextYAlignment.Top; Open.MouseButton1Down:Connect(function() HideFrame.Visible=true Header.Visible=true Prompt.Visible=true end)
    TopFrame.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true dragStart=i.Position startPos=TopFrame.Position end end)
    uis.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-dragStart TopFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
    uis.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
    
    --// AddCommand, button-style \\--
    function Window:AddCommand(opts)
        local cmdName = opts.Name:lower()
        Window.Commands[cmdName] = opts
        return opts
    end
    Window.Commands["help"] = {
        Name = "help",
        Description = "Lists all commands",
        Callback = function(printLine)
            printLine("Commands:") 
            for name,_ in pairs(Window.Commands) do
                printLine(name)
            end
        end
    }
    Window.Commands["clear"] = {
        Name = "clear",
        Description = "Clears the screen",
        Callback = function(printLine)
            TextBox.Text = ""
            printLine("C:\\Users\\"..lp.Name..">")
        end
    }
    local function appendLine(text)
        TextBox.Text = TextBox.Text .. text .. "\n"
        TextBox.CursorPosition = #TextBox.Text + 1
    end
    TextBox.FocusLost:Connect(function(enterPressed)
        if not enterPressed then return end
        local input = TextBox.Text:lower()
        appendLine("C:\\Users\\"..lp.Name..">"..input)
        if Window.Commands[input] then
            local cmd = Window.Commands[input]
            if cmd.Callback then
                cmd.Callback(function(text)
                    appendLine(text)
                end)
            end
        else
            appendLine("'"..input.."' is not recognized as an internal or external command or any elements.")
        end
        TextBox.Text = ""
        appendLine("C:\\Users\\"..lp.Name..">")
        TextBox.CursorPosition = #TextBox.Text + 1
    end)

    return Window
end

return Library