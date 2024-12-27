-- method 1: transparency
for i, d in game.CoreGui.RobloxGui:GetChildren() do
  if d:FindFirstChild('TextLabel') and d.ClassName == 'ScreenGui' then
    d:FindFirstChild('TextLabel').TextTransparency = 1
  end
end

-- method 2: size
for i, d in game.CoreGui.RobloxGui:GetChildren() do
  if d:FindFirstChild('TextLabel') and d.ClassName == 'ScreenGui' then
    d:FindFirstChild('TextLabel').Size = UDim2.new(0,0,0,0)
  end
end

-- method 3: position
for i, d in game.CoreGui.RobloxGui:GetChildren() do
  if d:FindFirstChild('TextLabel') and d.ClassName == 'ScreenGui' then
    d:FindFirstChild('TextLabel').Position = UDim2.new(15,0,15,0)
  end
end

-- method 4: anchor point
for i, d in game.CoreGui.RobloxGui:GetChildren() do
  if d:FindFirstChild('TextLabel') and d.ClassName == 'ScreenGui' then
    d:FindFirstChild('TextLabel').AnchorPoint = Vector2.new(1,1)
  end
end

-- method 5: make textlabel invisible
for i, d in game.CoreGui.RobloxGui:GetChildren() do
  if d:FindFirstChild('TextLabel') and d.ClassName == 'ScreenGui' then
    d:FindFirstChild('TextLabel').Visible = false
  end
end

-- method 6: maxvisiblegraphemes
for i, d in game.CoreGui.RobloxGui:GetChildren() do
  if d:FindFirstChild('TextLabel') and d.ClassName == 'ScreenGui' then
    d:FindFirstChild('TextLabel').MaxVisibleGraphemes = 0
  end
end
