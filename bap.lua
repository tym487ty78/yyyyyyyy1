local name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local supportedVersion = "v1.4.1"
local supportedVersionp = 1390

local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local Window = ReGui:TabsWindow({
	Title = "CandyHub - ".. name .. " v1.5.2",
	Size = UDim2.fromOffset(340, 400)
}) --> TabSelector & WindowClass

local function getplot()
    local plots = workspace.Islands
    for i, plot in plots:GetChildren() do
        if plot.Important.OwnerID.Value == game.Players.LocalPlayer.UserId then
            return plot
        end
    end
end

local abs = function(num)
    if num < 0 then
        return -num
    end
    return num
end


local plot = getplot()
local spawnpart = plot:WaitForChild("SpawnPart")
local spawnpartpos = spawnpart.Position

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
    x = 0,
    y = 160,
    endpos = 100000,


    --distance = 100000,
    autobuy = false,
    lags = false
}
-- game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpectialEvents"):WaitForChild("PortalTouched"):FireServer()

local function getseat(blocks)
    local x = nil
    for i, item in blocks:GetChildren() do
        if string.find(item.Name, "driver_seat") then x = item end
    end
    return x
end

local function alive()
    if game.Players.LocalPlayer.Character then
        if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 then
                return true
            end
        end 
    end
    return false
end

local function plane()
    local x = (plot.PlacedBlocks:FindFirstChild("driver_seat_1") or plot.PlacedBlocks:FindFirstChild("driver_seat_2") or plot.PlacedBlocks:FindFirstChild("driver_seat_3") or plot.PlacedBlocks:FindFirstChild("driver_seat_4")) or nil
    if x == nil then 
        return false
    elseif x:FindFirstChild("Hitbox") and x:FindFirstChildOfClass("VehicleSeat") then
        if x:FindFirstChildOfClass("VehicleSeat"):FindFirstChild("BodyGyro") then
            return true
        end
    end
    return false
end


local Main = Window:CreateTab({Name = "Main"})
local f1 = Main:CollapsingHeader({Title="Main"}) --> Canvas
local my = Main:CollapsingHeader({Title="Stats",Collapsed=false});my:SetVisible(false)
local my1 = my:Label({Text = "Money Earned: 0"})
local my2 = my:Label({Text = "Time: 0h 0m 0s"})

--local debug = Window:CreateTab({Name = "DEBUG"})
--local dbg = debug:CollapsingHeader({Title="consol"})

f1:Checkbox({
	Value = false,
	Label = "Auto Fly (Default Map)",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.autofarm = v

            my:SetVisible(_G.candyhub.autofarm)
            if _G.candyhub.autofarm then
                local money = game:GetService("Players").LocalPlayer.leaderstats.Cash.Value
                local runnin= math.floor(tick())
                task.spawn(function()
                    while _G.candyhub.autofarm and task.wait(0.1) do
                        if ((not game:GetService("ReplicatedStorage").ActiveEvents.BloodMoonActive.Value and _G.candyhub.moon) or not _G.candyhub.moon) then
                            my1.Text = ("Money Earned: " .. tostring(abs(money-game:GetService("Players").LocalPlayer.leaderstats.Cash.Value)))
                            my2.Text = ("Time: " .. tostring(math.floor((math.floor(tick())-runnin)/3600)) .. "h " .. tostring(math.floor(((math.floor(tick())-runnin)%3600)/60)) .. "m " .. tostring(math.floor((math.floor(tick())-runnin)%60)) .. "s")
                        end
                    end
                end)
            end

            while _G.candyhub.autofarm and task.wait(.1) do
                --dbg:Label({Text = "bds1"})
                if ((not game:GetService("ReplicatedStorage").ActiveEvents.BloodMoonActive.Value and _G.candyhub.moon) or not _G.candyhub.moon) then
                local aplane = plot.PlacedBlocks
                local driver = (aplane:FindFirstChild("driver_seat_1") or aplane:FindFirstChild("driver_seat_2") or aplane:FindFirstChild("driver_seat_3"))
                local launched = plot.Important.Launched

                local x,z = spawnpartpos.X, spawnpartpos.Z

                --dbg:Label({Text = "bds2"})

                if not alive() then
                    repeat task.wait(0.1) until alive()
                end

                if driver == nil then
                    repeat 
                        --dbg:Label({Text = "bds55"}) 
                        task.wait(1) 
                    until (aplane:FindFirstChild("driver_seat_1") or aplane:FindFirstChild("driver_seat_2") or aplane:FindFirstChild("driver_seat_3")) ~= nil or not _G.candyhub.autofarm
                    driver = (aplane:FindFirstChild("driver_seat_1") or aplane:FindFirstChild("driver_seat_2") or aplane:FindFirstChild("driver_seat_3"))
                end

                if not driver:FindFirstChild("Hitbox") then
                    repeat 
                        --dbg:Label({Text = "bds66"}) 
                        task.wait(0.05) 
                    until driver:FindFirstChild("Hitbox") or not _G.candyhub.autofarm
                end
                repeat 
                    --dbg:Label({Text = "bds77"})
                    if not launched.Value and alive() then
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch"):FireServer()
                    end 
                    task.wait(1)
                until launched.Value
                task.wait(0.35)
                local abc = true
                --dbg:Label({Text = "abc1"})
                while launched.Value and _G.candyhub.autofarm and (plane() and alive()) and abc do
                    --task.spawn(function()
                    --dbg:Label({Text = "abc2"})
                    if plane() and alive() then
                        --dbg:Label({Text = "abc3"})
                        local target = driver:FindFirstChild("Hitbox") or game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        target.CFrame = CFrame.new(
                            Vector3.new(
                                target.Position.X + _G.candyhub.x,
                                _G.candyhub.y,
                                z
                            ),
                            Vector3.new(
                                target.Position.X + _G.candyhub.x + 10,
                                _G.candyhub.y,
                                z
                            )
                        )
                        --dbg:Label({Text = "abc4"})

                        if (target.Position.X >= _G.candyhub.endpos) then
                            abc = false
                        end
                        --dbg:Label({Text = "abc5"})
                    end --end)
                    --dbg:Label({Text = "abc6"})
                    task.wait(0.1)
                end
                --dbg:Label({Text = "abc7"})
                task.wait(1)
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Return"):FireServer()
                --dbg:Label({Text = "abc8"})
                end
            end

        end)
	end
})

f1:Checkbox({
	Value = false,
	Label = "GodMode",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.gm = v

            while _G.candyhub.gm and task.wait(.4) do
                for i, item in plot:FindFirstChild("PlacedBlocks"):GetDescendants() do
                    if item.ClassName == "Part" or item.ClassName == "MeshPart" and (item.Parent.Name ~= "driver_seat_1" and item.Name ~= "Part") then
                        if item.CanTouch then
                            item.CanTouch = false
                        end
                    end
                end
            end
            for i, item in plot:FindFirstChild("PlacedBlocks"):GetDescendants() do
                if item.ClassName == "Part" or item.ClassName == "MeshPart" and (item.Parent.Name ~= "driver_seat_1" and item.Name ~= "Part") then
                    item.CanTouch = true
                end
            end
        end)
	end
})

f1:SliderInt({
    Label = "Y",
    Value = 470,
    Minimum = 15,
    Maximum = 480,
    Callback = function(self, v: Int)
        task.spawn(function()
            _G.candyhub.y = v 
        end)
    end
})

f1:SliderInt({
    Label = "UnNatural SpeedUP",
    Value = 100,
    Minimum = 0,
    Maximum = 580,
    Callback = function(self, v: Int)
        task.spawn(function()
            _G.candyhub.x = v 
        end)
    end
})

f1:InputInt({
    Label = "Distance To End",
    Value = 100000,
    Maximum = 10000000,
    Minimum = 500,
    Callback = function(self, v: Int)
        task.spawn(function()
            _G.candyhub.endpos = v
        end)
    end
})

local info123 = f1:Label({Text = "\n MAX SPEED: 6000 +- Studs Per Second\nUnNatural Speed is Value * 10 SPS \n"})
info123.TextColor3 = Color3.fromRGB(100,100,245)

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
--local f64 = Main:CollapsingHeader({Title="Flight"}) --> Canvas
--[[
f64:Checkbox({
	Value = false,
	Label = "Spam SaveSlot 1",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.lags = v
            while _G.candyhub.lags and task.wait() do
                task.spawn(function()
                    local args = {
                        1
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuildingEvents"):WaitForChild("use_slot"):InvokeServer(unpack(args))
                end)
            end
        end)
	end
})]]

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
local mi = events:CollapsingHeader({Title="Stats",Collapsed=false});mi:SetVisible(false)
local ml1 = mi:Label({Text = "Money Earned: 0"})
local ml2 = mi:Label({Text = "Moon Coins Earned: 0"})
local ml3 = mi:Label({Text = "Propeller Blood: 0"})
local ml4 = mi:Label({Text = "Wing Blood: 0"})
local ml5 = mi:Label({Text = "Time: 0h 0m 0s"})

me:Checkbox({
	Value = false,
	Label = "Auto Farm Moon Coins",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.moon = v
            mi:SetVisible(_G.candyhub.moon)

            if _G.candyhub.moon then
                local money = game:GetService("Players").LocalPlayer.leaderstats.Cash.Value
                local moons = game:GetService("Players").LocalPlayer.Important.RedMoons.Value
                local propeller_blood = game:GetService("Players").LocalPlayer.Important.Inventory.propeller_blood.Value
                local wing_blood = game:GetService("Players").LocalPlayer.Important.Inventory.wing_blood.Value
                local runnin= math.floor(tick())

                task.spawn(function()
                    while _G.candyhub.moon and task.wait(0.1) do
                        if (game:GetService("ReplicatedStorage").ActiveEvents.BloodMoonActive.Value) then
                            ml1.Text = ("Money Earned: " .. tostring(abs(money-game:GetService("Players").LocalPlayer.leaderstats.Cash.Value)))
                            ml2.Text = ("Moon Coins Earned: " .. tostring(abs(moons-game:GetService("Players").LocalPlayer.Important.RedMoons.Value)))
                            ml3.Text = ("Propeller Blood: " .. tostring(abs(propeller_blood-game:GetService("Players").LocalPlayer.Important.Inventory.propeller_blood.Value)) .. "(" .. tostring(game:GetService("Players").LocalPlayer.Important.Inventory.propeller_blood.Value) .. ")")
                            ml4.Text = ("Wing Blood: " .. tostring(abs(wing_blood-game:GetService("Players").LocalPlayer.Important.Inventory.wing_blood.Value)) .. "(" .. tostring(game:GetService("Players").LocalPlayer.Important.Inventory.wing_blood.Value) .. ")")
                            ml5.Text = ("Time: " .. tostring(math.floor((math.floor(tick())-runnin)/3600)) .. "h " .. tostring(math.floor(((math.floor(tick())-runnin)%3600)/60)) .. "m " .. tostring(math.floor((math.floor(tick())-runnin)%60)) .. "s")
                        end
                    end
                end)
            end

            while _G.candyhub.moon do
                if (game:GetService("ReplicatedStorage").ActiveEvents.BloodMoonActive.Value) then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch"):FireServer()
                    task.wait(0.8)
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpectialEvents"):WaitForChild("PortalTouched"):FireServer()
                    task.wait(1)
                    for i = 1,5 do
                        for i, item in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                            if item:FindFirstChild("BloodMoonCoin") and item.Name ~= "Instances" then
                                i+=1
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame + Vector3.new(0,0,0)
                                local args = {
                                    item.Name
                                }
                                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpectialEvents"):WaitForChild("CollectCoin"):FireServer(unpack(args))
                                task.wait(0.01)
                            end
                        end
                    end

                    task.wait(0.5)
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Return"):FireServer()
                    task.wait(2)
                end
                task.wait(0.01)
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

local misc = Window:CreateTab({Name = "Misc"})

misc:Checkbox({
	Value = false,
	Label = "Anti AFK",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.afk = v
        end)
	end
})

game:GetService("Players").LocalPlayer.Idled:connect(function()
    if _G.candyhub.afk then
        local vu = game:GetService("VirtualUser")
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end
end)

local info = Window:CreateTab({Name = "Info"})

local serverVersion = game:GetService("Players").LocalPlayer.PlayerGui.Main.ServerVersion.Text

local bb1,bb2,security = 0,0,""

if supportedVersionp == game.PlaceVersion then
    bb1 = 0
    bb2 = 255
    security = "Fully Secure, unlikely to get banned."
elseif supportedVersion == serverVersion then
    bb1 = 100
    bb2 = 255
    security = "Secure, less likely to get banned."
else
    bb1 = 255
    bb2 = 100
    security = "Insecure, more likely to get banned."
end

local x = info:Label({Text = "Supported Version: ".. supportedVersion .."\nServer Version: " .. serverVersion})
local x2= info:Label({Text = security})
x.TextColor3 = Color3.fromRGB(100,100,225)
x2.TextColor3= Color3.fromRGB(bb1,bb2,0)

local requestf = Window:CreateTab({Name = "Request"})
local x55 = requestf:Label({Text = "Request your feature, if possible to make\nit will probably be added\nYou can also report bugs here."})
local x66 = requestf:Label({Text = " \n!!!WARNING!!!\nTROLLING WILL RESULT IN BLACKLIST FROM USING SCRIPT\n"})
x55.TextColor3 = Color3.fromRGB(100,100,225)
x66.TextColor3 = Color3.fromRGB(255,0,0)

if request then
    getgenv().ooosent = false
    local featureRequest777 = ""
    local function sentrequest(message)
        if not getgenv().ooosent then
            getgenv().ooosent = true
            local response = request({
                Url = "https://discord.com/api/webhooks/1402026289770008688/RibldfUVV8DHfwr1nU6r9MPnKE9BP2JdgTfEg6LZ9vGje1JOqx8bJXsCakJiSiXwL62K",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = game:GetService("HttpService"):JSONEncode({
                    ["embeds"] = {
                        {
                            ["title"] = "Feature Request Sent",
                            ["description"] = "Executed by: "..game.Players.LocalPlayer.Name.." / "..game.Players.LocalPlayer.UserId,
                            ["color"] = 65280,
                            ["fields"] = {         
                                {
                                    ["name"] = "Message:",
                                    ["value"] = message
                                }
                            },
                            ["footer"] = {
                                ["text"] = "candyhub dev"
                            }
                        }
                    }
                })
            }) 
        end
    end

    requestf:InputText({
        Label = "Request Feature",
        Value = "",
        Placeholder = "request feature. . .",
        MultiLine = true,
        Callback = function(self, v: string)
            featureRequest777 = v
        end
    })

    requestf:Button({
        Text = "-- request feature --",
        Callback = function(self)
            if featureRequest777 == "" then
                requestf:Label({Text = "write smth bro."})
            else
                if not getgenv().ooosent then sentrequest(featureRequest777) else local a525 = requestf:Label({Text = "one request per execution.."}) task.wait(5) a525:Destroy() end
            end
        end
    })

else
    requestf:Label({Text = "\nexecutor not supported\n"})
end

print("hello world")
warn("hello world")
print("swift is trash and their users are too.")

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
