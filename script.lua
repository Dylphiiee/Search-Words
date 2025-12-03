local RAW_JSON_URL = "https://raw.githubusercontent.com/username/repo/main/words.json"

local Http = game:GetService("HttpService")
local words = {}

local ok, result = pcall(function()
    return Http:GetAsync(RAW_JSON_URL)
end)

if ok then
    local data = Http:JSONDecode(result)
    words = data.words or {}
else
    warn("Gagal load JSON:", result)
end

local function clean(q)
    return (q or ""):lower():gsub("%s+", "")
end

local function findWords(q)
    local key = clean(q)
    local result = {}
    if key == "" then return result end
    for _, w in ipairs(words) do
        if w:lower():sub(1,#key) == key then
            table.insert(result, w)
            if #result >= 200 then break end
        end
    end
    return result
end

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0,420,0,500)
panel.Position = UDim2.new(0.5,-210,0.5,-250)
panel.BackgroundColor3 = Color3.fromRGB(17,17,17)
panel.BorderSizePixel = 0
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,16)

local header = Instance.new("Frame", panel)
header.Size = UDim2.new(1,0,0,45)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", header).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-120,1,0)
title.Position = UDim2.new(0,15,0,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamSemibold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Search Word"

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,40,0,40)
closeBtn.Position = UDim2.new(1,-45,0,2)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20

local miniBtn = Instance.new("TextButton", header)
miniBtn.Size = UDim2.new(0,40,0,40)
miniBtn.Position = UDim2.new(1,-90,0,2)
miniBtn.BackgroundTransparency = 1
miniBtn.Text = "—"
miniBtn.TextColor3 = Color3.fromRGB(200,200,200)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 24

local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0,60,0,60)
icon.Position = UDim2.new(0,20,1,-80)
icon.Text = "🔍"
icon.TextSize = 30
icon.Font = Enum.Font.GothamBold
icon.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", icon).CornerRadius = UDim.new(0,30)
icon.Visible = false
icon.Parent = gui

local search = Instance.new("TextBox", panel)
search.PlaceholderText = "Type to search..."
search.Size = UDim2.new(1,-30,0,40)
search.Position = UDim2.new(0,15,0,60)
search.Text = ""
search.Font = Enum.Font.Gotham
search.TextSize = 18
search.TextColor3 = Color3.fromRGB(255,255,255)
search.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", search).CornerRadius = UDim.new(0,14)

local scroll = Instance.new("ScrollingFrame", panel)
scroll.Position = UDim2.new(0,15,0,110)
scroll.Size = UDim2.new(1,-30,1,-130)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.BorderSizePixel = 0
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)

local function updateList()
    scroll:ClearAllChildren()
    local results = findWords(search.Text)
    for _,word in ipairs(results) do
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1,0,0,40)
        item.BackgroundColor3 = Color3.fromRGB(20,20,20)
        Instance.new("UICorner", item).CornerRadius = UDim.new(0,10)
        item.Parent = scroll

        local lbl = Instance.new("TextLabel", item)
        lbl.Size = UDim2.new(1,-50,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 18
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.Text = word

        local copy = Instance.new("TextButton", item)
        copy.Size = UDim2.new(0,40,0,40)
        copy.Position = UDim2.new(1,-45,0,0)
        copy.Text = "📄"
        copy.TextSize = 20
        copy.Font = Enum.Font.GothamBold
        copy.BackgroundTransparency = 1
        copy.MouseButton1Click:Connect(function()
            search.Text = word
        end)
    end
    scroll.CanvasSize = UDim2.new(0,0,0,#results*46)
end

search:GetPropertyChangedSignal("Text"):Connect(updateList)

local dragging = false
local dragStart, startPos
local UIS = game:GetService("UserInputService")

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
    end
end)

miniBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    icon.Visible = true
end)
icon.MouseButton1Click:Connect(function()
    panel.Visible = true
    icon.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function()
    panel:Destroy()
    icon:Destroy()
end)
