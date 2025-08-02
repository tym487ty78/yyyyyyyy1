local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local Window = ReGui:TabsWindow({
	Title = "CandyHub - Buld A Plane v1",
	Size = UDim2.fromOffset(300, 400)
}) --> TabSelector & WindowClass

local function getplot()
    local plots = workspace.Islands
    for i, plot in plots:GetChildren() do
        if plot.Important.OwnerID.Value == game.Players.LocalPlayer.UserId then
            return plot
        end
    end
end
local function getitems()
    local items = {}
    for i, item in game:GetService("Players").LocalPlayer.PlayerGui.Main.BlockShop.Shop.Container.ScrollingFrame:GetChildren() do
        if item.Name ~= "ExtraScrollPadding" and item.Name ~= "TemplateFrame" and item.ClassName == "Frame" then
            table.insert(items, item.Name)
        end
    end
    return items
end

_G.candyhub = {
    autofarm = false,
    distance = 100000,
    autobuy = false,
    lags = false
}
-- game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpectialEvents"):WaitForChild("PortalTouched"):FireServer()

local Main = Window:CreateTab({Name = "Main"})
local f1 = Main:CollapsingHeader({Title="Main"}) --> Canvas

f1:Checkbox({
	Value = false,
	Label = "(W.I.P)",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.autofarm = v
        end)
	end
})
--[[
local f2 = Main:CollapsingHeader({Title="Dupe (PATCHED)"}) --> Canvas
f2:Label({Text="the more distance give, more money you get."})
f2:Button({
	Text = "Complete",
	Callback = function(self)

        local plot = getplot()
        local spawn = getplot():FindFirstChild("SpawnPart")

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch"):FireServer()
        task.wait(0.6)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
            _G.candyhub.distance,
            spawn.Position.Y + 25,
            spawn.Position.Z
        )
        task.wait(0.2)
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Return"):FireServer()
	end
})

f2:InputInt({
    Label = "Distance",
    Value = 100000,
    Maximum = 9999999999999,
    Minimum = -9999999999999,
    Callback = function(self, v: number)
        _G.candyhub.distance = v
    end
})]]
local f64 = Main:CollapsingHeader({Title="Others"}) --> Canvas
f64:Checkbox({
	Value = false,
	Label = "Spam SaveSlot 1",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.lags = v
            while _G.candyhub.lags and task.wait() do
                local args = {
                    1
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuildingEvents"):WaitForChild("use_slot"):InvokeServer(unpack(args))
            end
        end)
	end
})

local f3 = Main:CollapsingHeader({Title="Auto Buy"})

f3:Checkbox({
	Value = false,
	Label = "Auto Buy Items",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.autobuy = v
            while _G.candyhub.autobuy and task.wait(0.1) do
                local items = getitems()
                for i, item in ipairs(items) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ShopEvents"):WaitForChild("BuyBlock"):FireServer(
                        item
                    )
                end
            end
        end)
	end
})

local bd = Window:CreateTab({Name = "Build"})
local b1 = bd:CollapsingHeader({Title="Remove"})

b1:Button({
	Text = "Take All Blocks",
	Callback = function(self)
        for _, it in getplot().PlacedBlocks:GetChildren() do
            local i = it.PrimaryPart
            local args = {
                {
                    target = i,
                    hitPosition = vector.create(i.CFrame.p.X, i.CFrame.p.Y, i.CFrame.p.Z),
                    targetSurface = Enum.NormalId.Left
                }
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuildingEvents"):WaitForChild("GrabBlock"):FireServer(unpack(args))
        end
	end
})

local events = Window:CreateTab({Name = "Events"})
local me = events:CollapsingHeader({Title="Moon Event"})
me:Checkbox({
	Value = false,
	Label = "Auto Farm Moon Coins",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.moon = v
            while _G.candyhub.moon do
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch"):FireServer()
                task.wait(1)
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpectialEvents"):WaitForChild("PortalTouched"):FireServer()
                task.wait(1)
                for i, item in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                    if item:FindFirstChild("BloodMoonCoin") and item.Name ~= "Instances" then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame + Vector3.new(0,0,0)
                        local args = {
                            item.Name
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpectialEvents"):WaitForChild("CollectCoin"):FireServer(unpack(args))
                        task.wait(0.02)
                    end
                end
                task.wait(1)
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Return"):FireServer()
                task.wait(2)
            end
        end)
	end
})

me:Checkbox({
	Value = false,
	Label = "Auto Buy Spins",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.abs = v
            while _G.candyhub.abs and task.wait(0.01) do
                if game:GetService("Players").LocalPlayer.Important.RedMoons.Value >= 10 then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpinEvents"):WaitForChild("PurchaseSpin"):InvokeServer()
                end
            end
        end)
	end
})

me:Checkbox({
	Value = false,
	Label = "Auto Spin",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.abs = v
            while _G.candyhub.abs and task.wait(0.01) do
                if game:GetService("Players").LocalPlayer.replicated_data.available_spins.Value >= 1 then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpinEvents"):WaitForChild("PerformSpin"):InvokeServer()
                end
            end
        end)
	end
})

--[[

_G.automoon = not _G.automoon
while _G.automoon do
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch"):FireServer()
task.wait(1)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpectialEvents"):WaitForChild("PortalTouched"):FireServer()
task.wait(1)
for _, obj in pairs(game:GetDescendants()) do
    if obj:FindFirstChild("BloodMoonCoin") and obj.Name ~= "Instances" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0,0,0)
        local args = {
            obj.Name
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpectialEvents"):WaitForChild("CollectCoin"):FireServer(unpack(args))

        task.wait(0.1)
    end
end
task.wait(1)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Return"):FireServer()
task.wait(2)
end


for _, it in workspace.Islands.Island2.PlacedBlocks:GetChildren() do
local i = it.PrimaryPart
local args = {
	{
		target = i,
		hitPosition = vector.create(-30.497859954833984, 67.77723693847656, -243.5),
		targetSurface = Enum.NormalId.Left
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuildingEvents"):WaitForChild("GrabBlock"):FireServer(unpack(args))
end
]]
