-- ======= Services =======
local Players = game:GetService("Players")
local Http = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ======= Load Words from JSON =======
local Words = {}
pcall(function()
    local res = Http:GetAsync("https://raw.githubusercontent.com/Dylphiiee/Search-Words/refs/heads/main/words.json")
    local data = Http:JSONDecode(res)
    Words = data.words or {}
    print("Words loaded:", #Words)
end)

-- ======= Search Function =======
local function searchWords(query, limit)
    query = query:lower():gsub("^%s*(.-)%s*$","%1")
    local result = {}
    for _, w in ipairs(Words) do
        local word = w:lower():gsub("^%s*(.-)%s*$","%1")
        if word:sub(1,#query) == query then
            table.insert(result, w)
            if limit and #result >= limit then break end
        end
    end
    return result
end

-- ======= GUI =======
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SearchWordsGUI"

-- Panel
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 300, 0, 400)
panel.Position = UDim2.new(0.5, -150, 0.5, -200)
panel.BackgroundColor3 = Color3.fromRGB(35,35,35)
panel.Active = true
panel.BorderSizePixel = 0
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,8)

-- Header
local header = Instance.new("Frame", panel)
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", header).CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-60,1,0)
title.Position = UDim2.new(0,5,0,0)
title.BackgroundTransparency = 1
title.Text = "Search Words"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close & Minimize
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

-- Minimized icon
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,50,0,50)
icon.Position = UDim2.new(0,20,1,-70)
icon.Text = "🔍"
icon.Font = Enum.Font.GothamBold
icon.TextSize = 30
icon.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", icon).CornerRadius = UDim.new(0,25)
icon.Visible = false

-- Search box
local search = Instance.new("TextBox", panel)
search.PlaceholderText = "Cari kata..."
search.Size = UDim2.new(1,-20,0,25)
search.Position = UDim2.new(0,10,0,35)
search.BackgroundColor3 = Color3.fromRGB(50,50,50)
search.TextColor3 = Color3.fromRGB(255,255,255)
search.Font = Enum.Font.Gotham
search.TextSize = 13
search.ClearTextOnFocus = false
Instance.new("UICorner", search).CornerRadius = UDim.new(0,4)

-- Results list
local list = Instance.new("ScrollingFrame", panel)
list.Size = UDim2.new(1,-20,0,330)
list.Position = UDim2.new(0,10,0,65)
list.BackgroundTransparency = 1
list.ScrollBarThickness = 6
list.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0,2)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- ======= Update Results =======
local function UpdateResults()
    for _, c in ipairs(list:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local query = search.Text:lower():gsub("^%s*(.-)%s*$","%1")
    if #query < 1 then return end
    local results = searchWords(query,200)
    if #results == 0 then
        local none = Instance.new("TextLabel", list)
        none.Size = UDim2.new(1,0,0,25)
        none.BackgroundColor3 = Color3.fromRGB(50,50,50)
        none.Text = "Tidak ada hasil"
        none.TextColor3 = Color3.fromRGB(255,255,255)
        none.Font = Enum.Font.Gotham
        none.TextSize = 12
        Instance.new("UICorner", none).CornerRadius = UDim.new(0,4)
        return
    end
    for _, w in ipairs(results) do
        local btn = Instance.new("TextButton", list)
        btn.Size = UDim2.new(1,0,0,25)
        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.Text = w
        btn.AutoButtonColor = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
        btn.MouseButton1Click:Connect(function()
            search.Text = w
            pcall(function() setclipboard(w) end)
        end)
    end
end

search:GetPropertyChangedSignal("Text"):Connect(UpdateResults)

-- ======= Dragging =======
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
    end
end)

header.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ======= Minimize / Maximize / Close =======
miniBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
    panel.Visible = true
    icon.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
