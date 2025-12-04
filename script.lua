local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "WebSearchGUI"

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 800, 0, 600)
panel.Position = UDim2.new(0.5, -400, 0.5, -300)
panel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
panel.BorderSizePixel = 0
panel.Active = true
panel.Draggable = true
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", panel).Thickness = 1.5

-- Header
local header = Instance.new("Frame", panel)
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", header).CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-90,1,0)
title.Position = UDim2.new(0,5,0,0)
title.BackgroundTransparency = 1
title.Text = "Search Words WebView"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-30,0,2)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18

local miniBtn = Instance.new("TextButton", header)
miniBtn.Size = UDim2.new(0,25,0,25)
miniBtn.Position = UDim2.new(1,-60,0,2)
miniBtn.BackgroundTransparency = 1
miniBtn.Text = "—"
miniBtn.TextColor3 = Color3.fromRGB(200,200,200)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 18

local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,50,0,50)
icon.Position = UDim2.new(0,20,1,-70)
icon.Text = "🔍"
icon.Font = Enum.Font.GothamBold
icon.TextSize = 30
icon.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", icon).CornerRadius = UDim.new(0,25)
icon.Visible = false

-- WebView (menggunakan SurfaceGui + HTMLViewer atau WebView)
-- Catatan: Roblox tidak mendukung WebView asli, tapi di simulator Roblox UWP / Studio bisa menggunakan
-- HtmlLabel atau plugin khusus WebView. Di sini hanya contoh placeholder:
local htmlFrame = Instance.new("Frame", panel)
htmlFrame.Size = UDim2.new(1, -20, 1, -40)
htmlFrame.Position = UDim2.new(0, 10, 0, 30)
htmlFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", htmlFrame).CornerRadius = UDim.new(0,4)

local htmlLabel = Instance.new("TextLabel", htmlFrame)
htmlLabel.Size = UDim2.new(1,0,1,0)
htmlLabel.BackgroundTransparency = 1
htmlLabel.Text = "WebView Placeholder: https://dylphiiee.github.io/Search-Words/"
htmlLabel.TextColor3 = Color3.fromRGB(255,255,255)
htmlLabel.TextWrapped = true
htmlLabel.TextScaled = true

-- Tombol interaksi
closeBtn.MouseButton1Click:Connect(function()
gui:Destroy()
end)

miniBtn.MouseButton1Click:Connect(function()
panel.Visible = false
icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
panel.Visible = true
icon.Visible = false
end)
