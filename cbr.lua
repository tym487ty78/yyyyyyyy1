local players = game:GetService('Players')
local player = game.Players.LocalPlayer
local mouse = game.Players.LocalPlayer:GetMouse()
local camera = workspace.CurrentCamera




local function Alive(player)
    if player.Character then
        if player.Character:FindFirstChild('HumanoidRootPart') then
            if player.Character:FindFirstChild('Humanoid') and player.Character:FindFirstChild('Humanoid').Health >= 1 then
                return true
            end
        end
    end
    return false
end

local function GetSpectators()
	local CurrentSpectators = {}
	
	for i,v in pairs(game.Players:GetChildren()) do 
		if v ~= game.Players.LocalPlayer then
			if not v.Character and v:FindFirstChild("CameraCF") and (v.CameraCF.Value.Position - workspace.CurrentCamera.CFrame.p).Magnitude < 10 then 
				table.insert(CurrentSpectators, v)
			end
		end
	end
	
	return CurrentSpectators
end


local function getClosestx(cframe)
    local ray = Ray.new(cframe.Position, cframe.LookVector).Unit

    local target = nil
    local mag = math.huge

    for i, v in pairs(game.Players:GetPlayers()) do
        if Alive(v) then
            if
                v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and
                    v.Character:FindFirstChild("HumanoidRootPart") and
                    ((v.Team ~= game.Players.LocalPlayer.Team) or game.Players.LocalPlayer.Neutral) and
                    v.Character:FindFirstChild("Humanoid") and
                    v.character:FindFirstChild("Humanoid").Health >= 1
            then
                local magBuf = (v.Character.Head.Position - ray:ClosestPoint(v.Character.Head.Position)).Magnitude

                if magBuf < mag then
                    mag = magBuf
                    target = v
                end
            end
        end
    end

    return target
end
local function Getv(closest,silentwall)
    local zz = camera.ViewportSize/2
    if closest and Alive(closest) and Alive(game.Players.LocalPlayer) then
        local curtar = closest
        local ssHeadPoint = camera:WorldToScreenPoint(curtar.Character.Head.Position)
        ssHeadPoint = Vector2.new(ssHeadPoint.X,ssHeadPoint.Y)
        if (ssHeadPoint-zz).Magnitude < _G.candyhub.fov then
            if not (#(camera:GetPartsObscuringTarget({curtar.Character:FindFirstChild('Head').Position}, curtar.Character:GetDescendants())) > 1) then
                return true
            elseif silentwall then
                return true
            end
        end
    end
    return false
end

local function createHitmarker(position)
	task.spawn(function()
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 25, 0, 25)
		billboard.Adornee = nil
		billboard.StudsOffset = Vector3.new(0, 0, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

		local markerPart = Instance.new("Part")
		markerPart.Size = Vector3.new(0.1, 0.1, 0.1)
		markerPart.Position = position
		markerPart.Anchored = true
		markerPart.CanCollide = false
		markerPart.Transparency = 1
		markerPart.Parent = game.Workspace

		billboard.Adornee = markerPart

		local image = Instance.new("ImageLabel")
		image.Size = UDim2.new(1, 0, 1, 0)
		image.BackgroundTransparency = 1
		image.Image = "rbxassetid://11422140434"
		image.ImageColor3 = Color3.fromRGB(180, 20, 20)
		image.Rotation = 45
		image.Parent = billboard
		
		task.wait(3)
		
		for alpha = 1,100 do
			task.wait(0.01)
			image.ImageTransparency += 1/100
		end

		billboard:Destroy()
		markerPart:Destroy()
	end)
end

local function createSound(id,volume) -- "rbxassetid://5447626464",0.1
	task.spawn(function()
		local sound = Instance.new("Sound")
		sound.Parent = game:GetService("SoundService")
		sound.Volume = volume
		sound.PlayOnRemove = true
		sound.SoundId = id
		sound:Destroy()
	end)
end

local function PartsFolder()
    local partsFolder
    if not game.Players.LocalPlayer:FindFirstChild('wallbang_parts') then
        partsFolder = Instance.new("Folder")
    else
		partsFolder = game.Players.LocalPlayer:FindFirstChild('wallbang_parts')
	end
    partsFolder.Name = "wallbang_parts"
    partsFolder.Parent = game.Players.LocalPlayer
    return partsFolder
end

local function isPressed()
    return game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
end

local function HasHumanoid(instance)
	if instance.Parent:FindFirstChild("Humanoid") then
		return true
	elseif instance.Parent.Parent:FindFirstChild("Humanoid") then
		return true
	elseif instance.Parent.Parent.Parent:FindFirstChild("Humanoid") then
		return true
	else 
		return false 
	end
end

local function getplayerfrominstance(instance)
    if instance.Parent:FindFirstChild('Humanoid') then
        return game.Players:GetPlayerFromCharacter(instance.Parent)
    elseif instance.Parent.Parent:FindFirstChild('Humanoid') then
        return game.Players:GetPlayerFromCharacter(instance.Parent.Parent)
    elseif instance.Parent.Parent.Parent:FindFirstChild('Humanoid') then
        return game.Players:GetPlayerFromCharacter(instance.Parent.Parent.Parent)
    else
        return nil
    end
end




local function NoSpreadOn()
    for _, weapon in game:GetService('ReplicatedStorage'):FindFirstChild('Weapons'):GetChildren() do
        if weapon:FindFirstChild("Spread") then
            local spread = weapon:FindFirstChild("Spread")
            spread.Value = 0
            for _, child in ipairs(spread:GetChildren()) do
                child.Value = 0
            end
        end
    end
end

local function ModifySpread(newp)
    for _, weapon in game:GetService('ReplicatedStorage'):FindFirstChild('Weapons'):GetChildren() do
        if weapon:FindFirstChild("Spread") then
            local spread = weapon:FindFirstChild("Spread")
            spread.Value = game:FindFirstChild('NoSpreadSave'):FindFirstChild(weapon.Name):FindFirstChild('Spread').Value * newp / 100
            for _, child in ipairs(spread:GetChildren()) do
                child.Value = game:FindFirstChild('NoSpreadSave'):FindFirstChild(weapon.Name):FindFirstChild('Spread'):FindFirstChild(child.Name).Value * newp / 100
            end
        end
    end
end

local function SaveSpread()
    if not game:FindFirstChild('NoSpreadSave') then
        local spreads = Instance.new('Folder',game)
        spreads.Name = 'NoSpreadSave'
        for _, weapon in game:GetService('ReplicatedStorage'):FindFirstChild('Weapons'):GetChildren() do
            local newweapon = Instance.new('Folder', spreads)
            newweapon.Name = weapon.Name
            if weapon:FindFirstChild("Spread") then
                local spread = weapon:FindFirstChild("Spread"):Clone()
                spread.Parent = newweapon
            end
        end
    end
end

local function NoSpreadOff()
    if game:FindFirstChild('NoSpreadSave') then
        for _, weapon in game:GetService('ReplicatedStorage'):FindFirstChild('Weapons'):GetChildren() do
            if weapon:FindFirstChild("Spread") then
                weapon:FindFirstChild("Spread"):Destroy()
                local oldrestore = game:FindFirstChild('NoSpreadSave'):FindFirstChild(weapon.Name):FindFirstChild('Spread'):Clone()
                oldrestore.Parent = weapon
            end
        end
    end
end

---------------

local function RapidFire()
end

local function SaveAmmo()
    if not game:FindFirstChild('AmmoSave') then
        local ammos = Instance.new('Folder',game)
        ammos.Name = 'AmmoSave'
        for _, weapon in game:GetService('ReplicatedStorage'):FindFirstChild('Weapons'):GetChildren() do
            local newweapon = Instance.new('Folder', ammos)
            newweapon.Name = weapon.Name
            if weapon:FindFirstChild("Ammo") then
                local ammo = weapon:FindFirstChild("Ammo"):Clone()
                ammo.Parent = newweapon
            end
        end
    end
end

local function InfAmmoOn()
    for _, weapon in game:GetService('ReplicatedStorage'):FindFirstChild('Weapons'):GetChildren() do
        if weapon:FindFirstChild("Ammo") then
            local ammo = weapon:FindFirstChild("Ammo")
            ammo.Value = 999999
        end
    end
end

local function InfAmmoOff()
    if game:FindFirstChild('AmmoSave') then
        for _, weapon in game:GetService('ReplicatedStorage'):FindFirstChild('Weapons'):GetChildren() do
            if weapon:FindFirstChild("Ammo") then
                weapon:FindFirstChild("Ammo"):Destroy()
                local oldrestore = game:FindFirstChild('AmmoSave'):FindFirstChild(weapon.Name):FindFirstChild('Ammo'):Clone()
                oldrestore.Parent = weapon
            end
        end
    end
end

local function getClosest(cframe)
    local ray = Ray.new(cframe.Position, cframe.LookVector).Unit

    local target = nil
    local mag = math.huge

    for i, v in pairs(game.Players:GetPlayers()) do
        if Alive(v) then
            if
                v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and
                    v.Character:FindFirstChild("HumanoidRootPart") and
                    ((v.Team ~= game.Players.LocalPlayer.Team) or game.Players.LocalPlayer.Neutral) and
                    v.Character:FindFirstChild("Humanoid") and
                    v.character:FindFirstChild("Humanoid").Health >= 1
            then
                local magBuf = (v.Character.Head.Position - ray:ClosestPoint(v.Character.Head.Position)).Magnitude

                if magBuf < mag then
                    mag = magBuf
                    target = v
                end
            end
        end
    end

    return target
end

local function blockesp(player, setts)

    local bbname = '__blockespsettings.blockesp:'

    if player.Character and player.Character:FindFirstChild('HumanoidRootPart') then
        if player.Character:FindFirstChild(bbname) then
            player.Character:FindFirstChild(bbname):Destroy()
        end

        if player.Character:FindFirstChild('Humanoid') and player.Character:FindFirstChild('Humanoid').Health >= 1 then

            if player.Character:FindFirstChild(bbname) then
                player.Character:FindFirstChild(bbname):Destroy()
            end

            if player.Neutral and game.Players.LocalPlayer.Neutral then
                teamcheck_color = Color3.fromRGB(255,0,0)
            elseif player.TeamColor == game.Players.LocalPlayer.TeamColor then
                teamcheck_color = Color3.fromRGB(0,255,0)
            elseif player.TeamColor ~= game.Players.LocalPlayer.TeamColor then
                teamcheck_color = Color3.fromRGB(255,0,0)
            else
                teamcheck_color = Color3.fromRGB(255,0,0)
            end

            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = bbname
            billboardGui.Size = UDim2.new(10, 0, 10, 0)
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.Parent = player.Character

            if setts[1] == true then
                if setts[5] == 'visible' then
                    if teamcheck_color == Color3.fromRGB(255,0,0) then
                        local textLabel = Instance.new("TextLabel")
                        textLabel.Size = UDim2.new(0.5, 0, 0.75, 0)
                        textLabel.Position = UDim2.new(0.25,0,-0.1,0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.Text = player.Name 
                        textLabel.TextColor3 = Color3.fromRGB(0, 0, 0) 
                        textLabel.TextStrokeTransparency = 1
                        textLabel.TextScaled = true
                        textLabel.Font = Enum.Font.SourceSans
                        textLabel.Parent = billboardGui
                        textLabel.Name = 'name'
                    end
                else
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(0.5, 0, 0.75, 0)
                    textLabel.Position = UDim2.new(0.25,0,-0.1,0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = player.Name 
                    textLabel.TextColor3 = Color3.fromRGB(0, 0, 0) 
                    textLabel.TextStrokeTransparency = 1
                    textLabel.TextScaled = true
                    textLabel.Font = Enum.Font.SourceSans
                    textLabel.Parent = billboardGui
                    textLabel.Name = 'name'
                end
            end

            if setts[2] == true then
                if setts[5] == 'visible' then
                    if teamcheck_color == Color3.fromRGB(255,0,0) then
                        local box = Instance.new("Frame", billboardGui); local UIStroke = Instance.new('UIStroke', box)
                        box.BackgroundTransparency = 1
                        box.Size = UDim2.new(0.5,0,0.6,0)
                        box.Position = UDim2.new(0.25,0,0.5,0)
                        box.Name = 'box'
                    end
                else
                    local box = Instance.new("Frame", billboardGui); local UIStroke = Instance.new('UIStroke', box)
                    box.BackgroundTransparency = 1
                    box.Size = UDim2.new(0.5,0,0.6,0)
                    box.Position = UDim2.new(0.25,0,0.5,0)
                    box.Name = 'box'
                end
            end

            if setts[3] == true then
                if setts[5] == 'visible' then
                    if teamcheck_color == Color3.fromRGB(255,0,0) then
                        local hpbar = Instance.new('Frame',billboardGui); local UIStroke2 = Instance.new('UIStroke', hpbar)
                        hpbar.Name = 'HealthBar'
                        hpbar.BackgroundTransparency = 1
                        hpbar.Size = UDim2.new(0.01,0,0.6,0)
                        hpbar.Position = UDim2.new(0.78,0,0.5,0)

                        local health = Instance.new('Frame',hpbar)
                        health.Size = UDim2.new(1,0,player.Character.Humanoid.Health/100,0)
                        health.BackgroundColor3 = Color3.fromRGB(0,255,0)
                        
                        --[[
                        player.Character.Humanoid.Changed:Connect(function()
                            health.Size = UDim2.new(1,0,player.Character.Humanoid.Health/100,0)
                            if player.Character.Humanoid.Health >= 75 then
                                health.BackgroundColor3 = Color3.fromRGB(0,255,0)
                            elseif player.Character.Humanoid.Health >= 50 then
                                health.BackgroundColor3 = Color3.fromRGB(255,255,0)
                            elseif player.Character.Humanoid.Health >= 25 then
                                health.BackgroundColor3 = Color3.fromRGB(255,150,0)
                            elseif player.Character.Humanoid.Health >= 1 then
                                health.BackgroundColor3 = Color3.fromRGB(255,0,0)
                            end
                        end)
                        ]]
                        task.spawn(function()
                            while player.Character and task.wait() do
                                if Alive(player) then
                                    health.Size = UDim2.new(1,0,player.Character.Humanoid.Health/100,0)
                                    if player.Character.Humanoid.Health >= 75 then
                                        health.BackgroundColor3 = Color3.fromRGB(0,255,0)
                                    elseif player.Character.Humanoid.Health >= 50 then
                                        health.BackgroundColor3 = Color3.fromRGB(255,255,0)
                                    elseif player.Character.Humanoid.Health >= 25 then
                                        health.BackgroundColor3 = Color3.fromRGB(255,150,0)
                                    elseif player.Character.Humanoid.Health >= 1 then
                                        health.BackgroundColor3 = Color3.fromRGB(255,0,0)
                                    end
                                end
                            end
                        end)
                    end
                else
                    local hpbar = Instance.new('Frame',billboardGui); local UIStroke2 = Instance.new('UIStroke', hpbar)
                    hpbar.Name = 'HealthBar'
                    hpbar.BackgroundTransparency = 1
                    hpbar.Size = UDim2.new(0.01,0,0.6,0)
                    hpbar.Position = UDim2.new(0.78,0,0.5,0)

                    local health = Instance.new('Frame',hpbar)
                    health.Size = UDim2.new(1,0,player.Character.Humanoid.Health/100,0)
                    health.BackgroundColor3 = Color3.fromRGB(0,255,0)
                    
                    task.spawn(function()
                        while player.Character and task.wait() do
                            if Alive(player) then
                                health.Size = UDim2.new(1,0,player.Character.Humanoid.Health/100,0)
                                if player.Character.Humanoid.Health >= 75 then
                                    health.BackgroundColor3 = Color3.fromRGB(0,255,0)
                                elseif player.Character.Humanoid.Health >= 50 then
                                    health.BackgroundColor3 = Color3.fromRGB(255,255,0)
                                elseif player.Character.Humanoid.Health >= 25 then
                                    health.BackgroundColor3 = Color3.fromRGB(255,150,0)
                                elseif player.Character.Humanoid.Health >= 1 then
                                    health.BackgroundColor3 = Color3.fromRGB(255,0,0)
                                end
                            end
                        end
                    end)
                end
            end

            if setts[4] == true and setts[5] == 'color' then
                local teamcheck = Instance.new("Frame", billboardGui)
                teamcheck.BackgroundTransparency = 0.85
                teamcheck.Size = UDim2.new(0.5,0,0.6,0)
                teamcheck.Position = UDim2.new(0.25,0,0.5,0)
                teamcheck.Name = 'teamcheck'
                teamcheck.BackgroundColor3 = teamcheck_color
            end

            if setts[6] == true then
                if setts[4] == true then
                    chamscolor = teamcheck_color
                else
                    chamscolor = Color3.fromRGB(0,0,255)
                end

                local cham = Instance.new('Highlight', billboardGui)
                cham.Adornee = player.Character
                cham.Name = 'chams'
                cham.FillColor = chamscolor
                cham.FillTransparency = 0.75
                cham.OutlineTransparency = 0.5
                cham.OutlineColor = chamscolor
            end

        else
            if player.Character:FindFirstChild(bbname) then
                player.Character:FindFirstChild(bbname):Destroy()
            end
        end
    end
end


if game.CoreGui:FindFirstChild('hexagon-docs') then
	game.CoreGui:FindFirstChild('hexagon-docs'):Destroy()
end
local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/vateq/UILIBrewrites/refs/heads/main/hexagonuilib'))()
library.settings = {
	guiname = "hexagon-docs",
	title = 'CandyHub - Counter Blox',
	modal = true,
	font = Enum.Font.SourceSans,
	textsize = 16,
	logo = "rbxassetid://4350178803",
	footer = ' - candyware.nil',
	textstroke = true,
}

local Window = library:CreateWindow(
	Vector2.new(400, 525), -- ui lib size
	Vector2.new((workspace.CurrentCamera.ViewportSize.X / 2) - 250, (workspace.CurrentCamera.ViewportSize.Y / 2) - 250) -- ui pointing (id what i just called it lol) just dont change it.
)

_G.candyhub = {
    
    aimbot = false,
    silent = false,
    fov = 60,
    smoothing = 1,

    nospread = false,
    nospread_power = 0.8,

    bhop = false,

    trigger_bot = false,
    trigger_bot_ms = 200,
    trigger_bot_ms2 = 30,

    blockesp = false,
    name = true,
    boxs = true,
    hpbar = true,
    teamcheck = true,
    teamcheck_mode = 'color',
    chams = false,

    hitmarks = false,
    hitsound = false,
    soundvolume = 0.5,

    showspectators = false,

    hbsize = 5,
    hitboxes = false,
    hbpart = "HeadHB",

    speedhack = false,
    speed = 25,
    bhopmode = "",

    spinbot = false,
    spinbot_power = 50,

    wallhack = false,
    walltransparency = 0.5,

    antiflash = false,

    thirdperson = false,
    thirdperson_range = 25,

    wallbang = false,
    wallbang_cd = 25,
    wallhack = false,
    wallhack_p = 50,

    skinchanger = false,
    weapons = {
        ak47 = "Stock",
        m4a4 = "Stock",
        m4a1 = "Stock",
        deagle = "Stock",
        awp = "Stock",
        galil = "Stock",
        famas = "Stock",
        knife = "TKnife_Stock",
        gloves = "",
        scout = "Stock",
        glock = "Stock",
        usp = "Stock",
    },
    fovcolor = Color3.fromRGB(255,255,255),
}

if getsenv then
    local client = getsenv(game.Players.LocalPlayer.PlayerGui.Client)
end

_G.candyhub_global = {
    maincfg = "CounterBloxConfig",
    currentcfg = "CounterBloxConfig"
}


local baseFolder = "Candyhub"
local gameFolder = baseFolder .. "/CounterBlox"
local mainConfigFile = baseFolder .. "/counterbloxmain.json"

-- Tworzenie folderów jeśli nie istnieją
if not isfolder(baseFolder) then
    makefolder(baseFolder)
end
if not isfolder(gameFolder) then
    makefolder(gameFolder)
end

-- Funkcja zapisu konfiguracji
local function saveConfig(filename, config)
    local json = game:GetService("HttpService"):JSONEncode(config)
    writefile(gameFolder .. "/" .. filename, json)
end

-- Funkcja ładowania konfiguracji
local function loadConfig(filename)
    local filePath = gameFolder .. "/" .. filename
    if isfile(filePath) then
        local json = readfile(filePath)
        return game:GetService("HttpService"):JSONDecode(json)
    end
    return nil
end

if isfile(mainConfigFile) then
    local mainConfig = game:GetService("HttpService"):JSONDecode(readfile(mainConfigFile))
    if mainConfig and mainConfig.maincfg then
        local loadedConfig = loadConfig(mainConfig.maincfg)
        if loadedConfig then
            for key, value in pairs(loadedConfig) do
                _G.candyhub[key] = value
                if library.pointers[key] then
                    library.pointers[key]:Set(value)
                end
            end
        end
    end
end


local maintab = Window:CreateTab('Main')


local category1 = maintab:AddCategory("Aimbot",1,1)

category1:AddToggle('Aimbot',_G.candyhub.aimbot,'aimbot',function(v)
    _G.candyhub.aimbot = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end)

category1:AddColorPicker('Fov Color', _G.candyhub.fovcolor,'fovcolor',function(v)
    _G.candyhub.fovcolor = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end)

if getsenv then

if not _G.clientfunc then
    _G.clientfunc = getsenv(game.Players.LocalPlayer.PlayerGui.Client).firebullet
end

category1:AddToggle('Silent',_G.candyhub.silent,'silent',function(v)
    task.spawn(function()
        _G.candyhub.silent = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
        while _G.candyhub.silent do
            getsenv(game.Players.LocalPlayer.PlayerGui.Client).firebullet = function()
            
                task.spawn(function()
                    if _G.candyhub.aimbot and _G.candyhub.silent then
                        local targetPlayer = getClosest(workspace.CurrentCamera.CFrame)
                        if targetPlayer then
                            if Alive(targetPlayer) and Alive(game.Players.LocalPlayer) then
                                if Getv(getClosest(camera.CFrame), _G.candyhub.silent_wallbang) then
                                    local oldcframe = camera.CFrame
                                    if not targetPlayer then return end
                                    local head = targetPlayer.Character:FindFirstChild("Head")
                                    if not head then return end
                                    camera.CameraType = Enum.CameraType.Scriptable
                                    camera.CFrame = CFrame.new(head.Position + Vector3.new(0, 1, 0), head.Position)
                                    _G.clientfunc()
                                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                                        camera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                                        camera.CameraType = Enum.CameraType.Custom
                                        camera.CFrame = oldcframe
                                    end
                                    return
                                end
                            end
                        end
                    end
                    return _G.clientfunc()
                end)
                return
            
            end
            task.wait(15)
        end
    end)
end)

category1:AddToggle('Silent Wall',_G.candyhub.silent_wallbang,'silent_wallbang',function(v)
    _G.candyhub.silent_wallbang = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end)

end

category1:AddSlider('Aim Fov', {1, 1024, _G.candyhub.fov, 1, ""}, 'fov', function(v)
    _G.candyhub.fov = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end, false)


local category421 = maintab:AddCategory("Hitbox Expander",1,1)


category421:AddToggle('Hitboxes',_G.candyhub.hitboxes,'hitboxes',function(v)
    task.spawn(function()
        _G.candyhub.hitboxes = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
        while _G.candyhub.hitboxes and task.wait() do
            for i, player in game.Players:GetChildren() do
                if player ~= game.Players.LocalPlayer then
                    if player.Character then
                        if player.Character:FindFirstChild('HeadHB') then
                            player.Character:FindFirstChild('HeadHB').Size = Vector3.new(_G.candyhub.hbsize, _G.candyhub.hbsize, _G.candyhub.hbsize)
                        end 
                    end
                end
            end
        end
    end)
end)


category421:AddSlider('Hitbox Size', {1, 13, _G.candyhub.hbsize, 1, ""}, 'hbsize', function(v)
    _G.candyhub.hbsize = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end, false)

if getsenv then
    local client = getsenv(game.Players.LocalPlayer.PlayerGui.Client)

    local category42152 = maintab:AddCategory("Trigger Bot",1,1)
    category42152:AddToggle('Trigger Bot',_G.candyhub.trigger_bot,'triggerbot',function(v)
        task.spawn(function()
            _G.candyhub.trigger_bot = v
            saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
            local player = game.Players.LocalPlayer
            while _G.candyhub.trigger_bot and task.wait() do
                if Alive(game.Players.LocalPlayer) then
                    if mouse.Target ~= nil then
                        local target = mouse.Target
                        if target.Parent:FindFirstChild("Humanoid") or target.Parent.Parent:FindFirstChild("Humanoid") then
                            local targetplayer = getplayerfrominstance(target)
                            if targetplayer ~= nil then
                                if
                                    ((targetplayer.Team ~= game.Players.LocalPlayer.Team) or game.Players.LocalPlayer.Neutral) and
                                    Alive(targetplayer)
                                then
                                    if client.gun ~= nil and client.gun ~= "none" then
                                        if client.gun then
                                            if client.gun:FindFirstChild('FireRate') then
                                                if client.gun:FindFirstChild('FireRate').ClassName == 'NumberValue' or client.gun:FindFirstChild('FireRate').ClassName == 'IntValue' then
                                                    task.wait(_G.candyhub.trigger_bot_ms2/1000)
                                                    client.firebullet()
                                                    task.wait(client.gun.FireRate.Value)
                                                    task.wait(_G.candyhub.trigger_bot_ms/1000)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)

    category42152:AddSlider('Trigger Cooldown', {1, 1800, _G.candyhub.trigger_bot_ms, 1, ""}, 'trigger_bot_ms', function(v)
        _G.candyhub.trigger_bot_ms = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
    end, false)


    category42152:AddSlider('Trigger ms', {1, 200, _G.candyhub.trigger_bot_ms2, 1, ""}, 'trigger_bot_ms2', function(v)
        _G.candyhub.trigger_bot_ms2 = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
    end, false)

end

local category = maintab:AddCategory("Esp",2,1)

category:AddToggle('ENABLED',_G.candyhub.blockesp,'blockesp',function(v)
    task.spawn(function()
        _G.candyhub.blockesp = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
        while _G.candyhub.blockesp and task.wait(1) do
            for i, player in game.Players:GetChildren() do
                if player.Name ~= game.Players.LocalPlayer.Name then
                    if _G.candyhub.blockesp then
                        blockesp(player,{_G.candyhub.name,_G.candyhub.boxs,_G.candyhub.hpbar,_G.candyhub.teamcheck,_G.candyhub.teamcheck_mode,_G.candyhub.chams})
                    else
                        if player.Character then
                            if player.Character:FindFirstChild('__blockespsettings.blockesp:') then
                                player.Character:FindFirstChild('__blockespsettings.blockesp:'):Destroy()
                            end
                        end
                    end
                end
            end
        end
        if not _G.candyhub.blockesp then
            for i, player in game.Players:GetChildren() do
                if player.Character then
                    if player.Character:FindFirstChild('__blockespsettings.blockesp:') then
                        player.Character:FindFirstChild('__blockespsettings.blockesp:'):Destroy()
                    end
                end
            end
        end
    end)
end)

category:AddToggle('Nametags',_G.candyhub.name,'name',function(v)
    _G.candyhub.name = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end)
category:AddToggle('Boxes',_G.candyhub.boxs,'boxs',function(v)
    _G.candyhub.boxs = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end)
category:AddToggle('Health Bar',_G.candyhub.hpbar,'hpbar',function(v)
    _G.candyhub.hpbar = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end)
category:AddToggle('TeamCheck',_G.candyhub.teamcheck,'teamcheck',function(v)
    _G.candyhub.teamcheck = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end)

category:AddDropdown('TeamCheck Mode: ', {'color','visible'},_G.candyhub.teamcheck_mode,'teamcheck_mode',function(choice)
	_G.candyhub.teamcheck_mode = choice
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end, true)

category:AddToggle('Chams',_G.candyhub.chams,'chams',function(v)
    _G.candyhub.chams = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end)

local tab633 = maintab:AddCategory("Hit Effects",2,1)

tab633:AddToggle('Hit Marks',_G.candyhub.hitmarks,'hitmarks',function(v)
    _G.candyhub.hitmarks = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end)

tab633:AddToggle('Hit Sound',_G.candyhub.hitsound,'hitsound',function(v)
    _G.candyhub.hitsound = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end)

tab633:AddSlider('Volume', {1, 100, _G.candyhub.soundvolume, 1, ""}, 'soundvolume', function(v)
    _G.candyhub.soundvolume = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end, false)

game.Players.LocalPlayer.Additionals:FindFirstChild("TotalDamage"):GetPropertyChangedSignal("Value"):Connect(function()
    if game.Players.LocalPlayer.Additionals:FindFirstChild("TotalDamage").Value == 0 then return end
    if _G.candyhub.hitmarks then
        createHitmarker(mouse.Hit.Position)
    end
    if _G.candyhub.hitsound then
        createSound("rbxassetid://5447626464",_G.candyhub.soundvolume/100)
    end
end)


local tabd52523 = maintab:AddCategory("Spectate",2,1)

tabd52523:AddToggle('Reveal Spectators',_G.candyhub.showspectators,'showspectators',function(v)
    task.spawn(function()
        _G.candyhub.showspectators = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)

        library.base.Spectators.Visible = _G.candyhub.showspectators

        while _G.candyhub.showspectators do
            for i,v in pairs(library.base.Spectators.SpectatorsFrame:GetChildren()) do
                if v:IsA("TextLabel") then
                    v:Destroy()
                end
            end
            
            for i,v in pairs(GetSpectators()) do
                local SpectatorLabel = Instance.new("TextLabel")
                SpectatorLabel.BackgroundTransparency = 1
                SpectatorLabel.Size = UDim2.new(1, 0, 0, 18)
                SpectatorLabel.Text = v.Name
                SpectatorLabel.TextColor3 = Color3.new(1, 1, 1)
                SpectatorLabel.Parent = library.base.Spectators.SpectatorsFrame
            end
            
            wait(0.25)
        end
    end)
end)

local misctab = Window:CreateTab('Misc')

local category523 = misctab:AddCategory("Movement",1,1)

category523:AddToggle('Bhop',_G.candyhub.bhop,'bhop',function(v)
    task.spawn(function()
        _G.candyhub.bhop = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
        while _G.candyhub.bhop and wait() do
            if _G.HoldingSpace then
                if Alive(game.Players.LocalPlayer) then
                    game.Players.LocalPlayer.Character.Humanoid.Jump = true
                end
            end
        end
    end)
end)

category523:AddToggle('Bhop Speeding',_G.candyhub.speedhack,'speedhack',function(v)
    task.spawn(function()
        _G.candyhub.speedhack = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
        while _G.candyhub.speedhack and task.wait() do
            if Alive(game.Players.LocalPlayer) then
                game.Players.LocalPlayer.Character:SetAttribute("Speed", tonumber(_G.candyhub.speed * 10))
            end
        end
    end)
end)

category523:AddSlider('Speed', {1, 100, _G.candyhub.speed, 1, ""}, 'speed', function(v)
    _G.candyhub.speed = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end, false)

category523:AddDropdown('Bhop Mode', {'Rage','Legit'},_G.candyhub.bhopmode,'bhopmode',function(choice)
	_G.candyhub.bhopmode = choice
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end, true)

category523:AddToggle('Spinbot',_G.candyhub.spinbot,'spinbot',function(v)
    task.spawn(function()
        _G.candyhub.spinbot = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
        if Alive(game.Players.LocalPlayer) then game.Players.LocalPlayer.Character.Humanoid.AutoRotate = not _G.candyhub.spinbot end
        while _G.candyhub.spinbot and wait() do
            if Alive(game.Players.LocalPlayer) then
            game.Players.LocalPlayer.Character.Humanoid.AutoRotate = not _G.candyhub.spinbot
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(_G.candyhub.spinbot_power), 0)
            end
        end
        if Alive(game.Players.LocalPlayer) then game.Players.LocalPlayer.Character.Humanoid.AutoRotate = not _G.candyhub.spinbot end
    end)
end)

category523:AddSlider('Spinbot Power', {1, 100, _G.candyhub.spinbot_power, 1, ""}, 'spinbot_power', function(v)
    _G.candyhub.spinbot_power = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end, false)


category523:AddToggle('Third Person',_G.candyhub.thirdperson,'thirdperson',function(v)
    task.spawn(function()
        _G.candyhub.thirdperson = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
        if _G.candyhub.thirdperson then
            while _G.candyhub.thirdperson and task.wait(0.1) do
                game.Players.LocalPlayer.CameraMaxZoomDistance = _G.candyhub.thirdperson_range
                game.Players.LocalPlayer.CameraMinZoomDistance = _G.candyhub.thirdperson_range
            end
            game.Players.LocalPlayer.CameraMaxZoomDistance = 0.5
            game.Players.LocalPlayer.CameraMinZoomDistance = 0.5
        else
            game.Players.LocalPlayer.CameraMaxZoomDistance = 0.5
            game.Players.LocalPlayer.CameraMinZoomDistance = 0.5
        end
    end)
end)

category523:AddSlider('ThirdPerson Range', {1, 100, _G.candyhub.thirdperson_range, 1, ""}, 'thirdperson_range', function(v)
    _G.candyhub.thirdperson_range = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end, false)

local category2523 = misctab:AddCategory("Extras",1,1)


category2523:AddToggle('Wall Bang',_G.candyhub.wallbang,'wallbang',function(v)
    task.spawn(function()
        _G.candyhub.wallbang = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
    end)
end)

category2523:AddSlider('WallBang recd', {1, 200, _G.candyhub.wallbang_cd, 1, ""}, 'wallbang_cd', function(v)
    _G.candyhub.wallbang_cd = v
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end, false)

category2523:AddToggle('AnitFlash',_G.candyhub.antiflash,'antiflash',function(v)
    task.spawn(function()
        _G.candyhub.antiflash = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
        game:GetService("Players").LocalPlayer.PlayerGui.Blnd.Enabled = not _G.candyhub.antiflash
    end)
end)

local previoustarget

mouse.Button1Down:Connect(function()
    if _G.candyhub.wallbang then
        while isPressed() and _G.candyhub.wallbang and task.wait() do
            if _G.candyhub.wallbang then
                task.spawn(function()
                    if mouse.Target and not HasHumanoid(mouse.Target) then
                        local target = mouse.Target
                        local originalParent = target.Parent
                        
                        if originalParent then
                            target.Parent = PartsFolder()
                            task.wait(_G.candyhub.wallbang_cd/100)
                            target.Parent = originalParent
                        end
                    end
                end)
            end
        end
    end
end)

local category2 = misctab:AddCategory("Weapons",2,1)

----------------

category2:AddToggle('Inf Ammo',_G.candyhub.infammo,'infammo',function(v)
    task.spawn(function()
        _G.candyhub.infammo = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
        if _G.candyhub.infammo then
            SaveAmmo()
            InfAmmoOn()
        else
            InfAmmoOff()
        end
    end)
end)

category2:AddToggle('NoSpread',_G.candyhub.nospread,'nospread',function(v)
    task.spawn(function()
        _G.candyhub.nospread = v
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
        if _G.candyhub.nospread then
            SaveSpread()
            NoSpreadOn()
            ModifySpread(_G.candyhub.nospread_power)
        else
            NoSpreadOff()
        end
    end)
end)

category2:AddSlider('NoSpread Power', {0, 100, _G.candyhub.nospread_power, 1, ""}, 'nospread_power', function(v)
    _G.candyhub.nospread_power = v
    if _G.candyhub.nospread then
        ModifySpread(_G.candyhub.nospread_power)
    end
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end, false)


if getrawmetatable and require and getsenv and getnamecallmethod and setreadonly and newcclosure then

    local skinstab = Window:CreateTab('SkinChanger')

    local function UnlockSkins(skins)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Client = getsenv(game.Players.LocalPlayer.PlayerGui.Client)
        local ReplicatedStorage = game:GetService("ReplicatedStorage")

        local allSkins = skins

        local isUnlocked
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        local isUnlocked
        mt.__namecall =
        newcclosure(
        function(self, ...)
            local args = {...}
            if getnamecallmethod() == "InvokeServer" and tostring(self) == "Hugh" then
                return
            end
            if getnamecallmethod() == "FireServer" then
                if args[1] == LocalPlayer.UserId then
                    return
                end
                if string.len(tostring(self)) == 38 then
                    if not isUnlocked then
                        isUnlocked = true
                        for i, v in pairs(allSkins) do
                            local doSkip
                            for i2, v2 in pairs(args[1]) do
                                if v[1] == v2[1] then
                                    doSkip = true
                                end
                            end
                            if not doSkip then
                                table.insert(args[1], v)
                            end
                        end
                    end
                    return
                end
                if tostring(self) == "DataEvent" and args[1][4] then
                    local currentSkin = string.split(args[1][4][1], "_")[2]
                    if args[1][2] == "Both" then
                        LocalPlayer["SkinFolder"]["CTFolder"][args[1][3]].Value = currentSkin
                        LocalPlayer["SkinFolder"]["TFolder"][args[1][3]].Value = currentSkin
                    else
                        LocalPlayer["SkinFolder"][args[1][2] .. "Folder"][args[1][3]].Value = currentSkin
                    end
                end
            end
            return oldNamecall(self, ...)
        end
        )
        setreadonly(mt, true)
        Client.CurrentInventory = skins
        local TClone, CTClone = LocalPlayer.SkinFolder.TFolder:Clone(), game.Players.LocalPlayer.SkinFolder.CTFolder:Clone()
        LocalPlayer.SkinFolder.TFolder:Destroy()
        LocalPlayer.SkinFolder.CTFolder:Destroy()
        TClone.Parent = LocalPlayer.SkinFolder
        CTClone.Parent = LocalPlayer.SkinFolder
    end

    local function EquipSkin(team,weapon,skin)
        if weapon ~= "Knife" or weapon ~= "Glove" then
            local args = {
                [1] = {
                    [1] = "EquipItem",
                    [2] = team, -- "T", "CT", "Both"
                    [3] = weapon, -- "Knife"
                    [4] = {
                        [1] = skin -- "Bayonet_Worn"
                    }
                }
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
        elseif weapon == "Knife" then
            local args = {[1] = {[1] = "EquipItem",[2] = team,[3] = weapon,[4] = {[1] = skin},[5] = {[1] = "KnifeOver",[2] = true}}}
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))        
        elseif weapon == "Glove" then
            local args = {[1] = {[1] = "EquipItem",[2] = team,[3] = weapon,[4] = {[1] = skin},[5] = {[1] = "GloveOver",[2] = true}}}
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))        
        end
    end

    -- EquipSkin("CT","Knife","CTKnife_Stock")
    -- EquipSkin("T","Knife","TKnife_Stock")

    local function GetAllSkins(skinslist)
        local skins = {}
        for i, skin in skinslist do
            table.insert(skins,skin)
        end
        return skins
    end

    local category205 = skinstab:AddCategory("Main",1,1)

    category205:AddToggle('Skin Changer',_G.candyhub.skinchanger,'skinchanger',function(v)
        task.spawn(function()
            _G.candyhub.skinchanger = v
            saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
            if _G.candyhub.skinchanger then
                UnlockSkins({
                    {_G.candyhub.weapons.knife},
                    {_G.candyhub.weapons.gloves},
                    {_G.candyhub.weapons.ak47},
                    {_G.candyhub.weapons.m4a4},
                    {_G.candyhub.weapons.glock},
                    {_G.candyhub.weapons.usp},
                    {_G.candyhub.weapons.awp}
                })
                --EquipSkin("CT","Knife",_G.candyhub.weapons.knife)
                --UnlockSkins({{_G.candyhub.weapons.knife},{_G.candyhub.weapons.knife}})
                EquipSkin("Both","Knife",_G.candyhub.weapons.knife)
                EquipSkin("Both",'Glove',_G.candyhub.weapons.gloves)
                EquipSkin("T",'AK47',_G.candyhub.weapons.ak47)
                EquipSkin("CT",'M4A4',_G.candyhub.weapons.m4a4)
                EquipSkin("Both",'DesertEagle',_G.candyhub.weapons.deagle)
                EquipSkin("T",'Glock',_G.candyhub.weapons.glock)
                EquipSkin("CT",'USP',_G.candyhub.weapons.usp)
                EquipSkin("Both","AWP",_G.candyhub.weapons.awp)
            end
        end)
    end)

    local knifeskins = {"Banana_Stock","Bayonet_Aequalis","Bayonet_Banner","Bayonet_Candy Cane","Bayonet_Consumed","Bayonet_Cosmos","Bayonet_Crimson Tiger","Bayonet_Crow","Bayonet_Delinquent","Bayonet_Digital","Bayonet_Easy-Bake","Bayonet_Egg Shell","Bayonet_Festive","Bayonet_Frozen Dream","Bayonet_Geo Blade","Bayonet_Ghastly","Bayonet_Goo","Bayonet_Hallows","Bayonet_Intertwine","Bayonet_Marbleized","Bayonet_Mariposa","Bayonet_Naval","Bayonet_Neonic","Bayonet_RSL","Bayonet_Racer","Bayonet_Sapphire","Bayonet_Silent Night","Bayonet_Splattered","Bayonet_Stock","Bayonet_Topaz","Bayonet_Tropical","Bayonet_Twitch","Bayonet_UFO","Bayonet_Wetland","Bayonet_Worn","Bayonet_Wrapped","Butterfly Knife_Aurora","Butterfly Knife_Bloodwidow","Butterfly Knife_Consumed","Butterfly Knife_Cosmos","Butterfly Knife_Crimson Tiger","Butterfly Knife_Crippled Fade","Butterfly Knife_Digital","Butterfly Knife_Egg Shell","Butterfly Knife_Freedom","Butterfly Knife_Frozen Dream","Butterfly Knife_Goo","Butterfly Knife_Hallows","Butterfly Knife_Icicle","Butterfly Knife_Inversion","Butterfly Knife_Jade Dream","Butterfly Knife_Marbleized","Butterfly Knife_Naval","Butterfly Knife_Neonic","Butterfly Knife_Reaper","Butterfly Knife_Ruby","Butterfly Knife_Scapter","Butterfly Knife_Splattered","Butterfly Knife_Stock","Butterfly Knife_Topaz","Butterfly Knife_Tropical","Butterfly Knife_Twitch","Butterfly Knife_Wetland","Butterfly Knife_White Boss","Butterfly Knife_Worn","Butterfly Knife_Wrapped","Falchion Knife_Bloodwidow","Falchion Knife_Chosen","Falchion Knife_Coal","Falchion Knife_Consumed","Falchion Knife_Cosmos","Falchion Knife_Crimson Tiger","Falchion Knife_Crippled Fade","Falchion Knife_Digital","Falchion Knife_Egg Shell","Falchion Knife_Festive","Falchion Knife_Freedom","Falchion Knife_Frozen Dream","Falchion Knife_Goo","Falchion Knife_Hallows","Falchion Knife_Inversion","Falchion Knife_Late Night","Falchion Knife_Marbleized","Falchion Knife_Naval","Falchion Knife_Neonic","Falchion Knife_Racer","Falchion Knife_Ruby","Falchion Knife_Splattered","Falchion Knife_Stock","Falchion Knife_Topaz","Falchion Knife_Tropical","Falchion Knife_Wetland","Falchion Knife_Worn","Falchion Knife_Wrapped","Falchion Knife_Zombie","Gut Knife_Banner","Gut Knife_Bloodwidow","Gut Knife_Consumed","Gut Knife_Cosmos","Gut Knife_Crimson Tiger","Gut Knife_Crippled Fade","Gut Knife_Digital","Gut Knife_Egg Shell","Gut Knife_Frozen Dream","Gut Knife_Geo Blade","Gut Knife_Goo","Gut Knife_Hallows","Gut Knife_Lurker","Gut Knife_Marbleized","Gut Knife_Naval","Gut Knife_Neonic","Gut Knife_Present","Gut Knife_Ruby","Gut Knife_Rusty","Gut Knife_Splattered","Gut Knife_Topaz","Gut Knife_Tropical","Gut Knife_Wetland","Gut Knife_Worn","Gut Knife_Wrapped","Huntsman Knife_Aurora","Huntsman Knife_Bloodwidow","Huntsman Knife_Consumed","Huntsman Knife_Cosmos","Huntsman Knife_Cozy","Huntsman Knife_Crimson Tiger","Huntsman Knife_Crippled Fade","Huntsman Knife_Digital","Huntsman Knife_Egg Shell","Huntsman Knife_Frozen Dream","Huntsman Knife_Geo Blade","Huntsman Knife_Goo","Huntsman Knife_Hallows","Huntsman Knife_Honor Fade","Huntsman Knife_Marbleized","Huntsman Knife_Monster","Huntsman Knife_Naval","Huntsman Knife_Ruby","Huntsman Knife_Splattered","Huntsman Knife_Stock","Huntsman Knife_Tropical","Huntsman Knife_Twitch","Huntsman Knife_Wetland","Huntsman Knife_Worn","Huntsman Knife_Wrapped","Karambit_Bloodwidow","Karambit_Consumed","Karambit_Cosmos","Karambit_Crimson Tiger","Karambit_Crippled Fade","Karambit_Death Wish","Karambit_Digital","Karambit_Egg Shell","Karambit_Festive","Karambit_Frozen Dream","Karambit_Glossed","Karambit_Gold","Karambit_Goo","Karambit_Hallows","Karambit_Jade Dream","Karambit_Jester","Karambit_Lantern","Karambit_Liberty Camo","Karambit_Marbleized","Karambit_Naval","Karambit_Neonic","Karambit_Pizza","Karambit_Quicktime","Karambit_Racer","Karambit_Ruby","Karambit_Scapter","Karambit_Splattered","Karambit_Stock","Karambit_Topaz","Karambit_Tropical","Karambit_Twitch","Karambit_Wetland","Karambit_Worn","Cleaver_Spider","Cleaver_Splattered","Bearded Axe_Beast","Bearded Axe_Splattered"}
    local ak47skins = {"AK47_Ace","AK47_Bloodboom","AK47_Clown","AK47_Code Orange","AK47_Eve","AK47_Gifted","AK47_Glo","AK47_Goddess","AK47_Hallows","AK47_Halo","AK47_Hypersonic","AK47_Inversion","AK47_Jester","AK47_Maker","AK47_Mean Green","AK47_Outlaws","AK47_Outrunner","AK47_Patch","AK47_Plated","AK47_Precision","AK47_Quantum","AK47_Quicktime","AK47_Scapter","AK47_Secret Santa","AK47_Shooting Star","AK47_Skin Committee","AK47_Survivor","AK47_Ugly Sweater","AK47_VAV","AK47_Variant Camo","AK47_Yltude"}
    local awpskins = {"AWP_Abaddon","AWP_Autumness","AWP_Blastech","AWP_Bloodborne","AWP_Coffin Biter","AWP_Desert Camo","AWP_Difference","AWP_Dragon","AWP_Forever","AWP_Grepkin","AWP_Hika","AWP_Illusion","AWP_Instinct","AWP_JTF2","AWP_Lunar","AWP_Nerf","AWP_Northern Lights","AWP_Pear Tree","AWP_Pink Vision","AWP_Pinkie","AWP_Quicktime","AWP_Racer","AWP_Regina","AWP_Retroactive","AWP_Scapter","AWP_Silence","AWP_Venomus","AWP_Weeb",}
    local uspskins = {"USP_Crimson","USP_Dizzy","USP_Frostbite","USP_Holiday","USP_Jade Dream","USP_Kraken","USP_Nighttown","USP_Paradise","USP_Racing","USP_Skull","USP_Unseen","USP_Worlds Away","USP_Yellowbelly",}
    local deagleskins = {"DesertEagle_Cold Truth","DesertEagle_Cool Blue","DesertEagle_DropX","DesertEagle_Glittery","DesertEagle_Grim","DesertEagle_Heat","DesertEagle_Honor-bound","DesertEagle_Independence","DesertEagle_Krystallos","DesertEagle_Pumpkin Buster","DesertEagle_ROLVe","DesertEagle_Racer","DesertEagle_Scapter","DesertEagle_Skin Committee","DesertEagle_Survivor","DesertEagle_Weeb","DesertEagle_Xmas",}
    local glockskins = {"Glock_Angler","Glock_Anubis","Glock_Biotrip","Glock_Day Dreamer","Glock_Desert Camo","Glock_Gravestomper","Glock_Midnight Tiger","Glock_Money Maker","Glock_RSL","Glock_Rush","Glock_Scapter","Glock_Spacedust","Glock_Tarnish","Glock_Underwater","Glock_Wetland","Glock_White Sauce",}
    local m4a1skins = {"M4A1_Animatic","M4A1_Burning","M4A1_Desert Camo","M4A1_Heavens Gate","M4A1_Impulse","M4A1_Jester","M4A1_Lunar","M4A1_Necropolis","M4A1_Tecnician","M4A1_Toucan","M4A1_Wastelander",}
    local m4a4skins= {"M4A4_BOT[S]","M4A4_Candyskull","M4A4_Delinquent","M4A4_Desert Camo","M4A4_Devil","M4A4_Endline","M4A4_Flashy Ride","M4A4_Ice Cap","M4A4_Jester","M4A4_King","M4A4_Mistletoe","M4A4_Pinkie","M4A4_Pinkvision","M4A4_Pondside","M4A4_Precision","M4A4_Quicktime","M4A4_Racer","M4A4_RayTrack","M4A4_Scapter","M4A4_Stardust","M4A4_Toy Soldier",}
    local glovesskins = {"Handwraps_Wraps","Sports Glove_Hazard","Sports Glove_Hallows","Sports Glove_Majesty","Strapped Glove_Racer","trapped Glove_Grim","trapped Glove_Wisk","Fingerless Glove_Scapter","Fingerless Glove_Digital","Fingerless Glove_Patch","Handwraps_Guts","Handwraps_Wetland","trapped Glove_Molten","Fingerless_Crystal","Sports Glove_Royal","Strapped Glove_Kringle","Handwraps_MMA","Sports Glove_Weeb","Sports Glove_CottonTail","Sports Glove_RSL","Handwraps_Ghoul Hex","Handwraps_Phantom Hex","Handwraps_Spector Hex","Handwraps_Orange Hex","Handwraps_Purple Hex","Handwraps_Green Hex"}


    category205:AddDropdown('Knife', knifeskins,_G.candyhub.weapons.knife,'knife',function(choice)
        _G.candyhub.weapons.knife = choice
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
    end, true)
    --

    category205:AddDropdown('Gloves', glovesskins,_G.candyhub.weapons.gloves,'gloves',function(choice)
        _G.candyhub.weapons.gloves = choice
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
    end, true)

    --

    category205:AddDropdown('AK 47', ak47skins,_G.candyhub.weapons.ak47,'ak47',function(choice)
        _G.candyhub.weapons.ak47 = choice
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
    end, true)

    category205:AddDropdown('M4A4', m4a4skins,_G.candyhub.weapons.m4a4,'m4a4',function(choice)
        _G.candyhub.weapons.m4a4 = choice
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
    end, true)

    category205:AddDropdown('DesertEagle', deagleskins,_G.candyhub.weapons.deagle,'deagle',function(choice)
        _G.candyhub.weapons.deagle = choice
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
    end, true)

    category205:AddDropdown('USP', uspskins,_G.candyhub.weapons.usp,'usp',function(choice)
        _G.candyhub.weapons.usp = choice
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
    end, true)

    category205:AddDropdown('Glock', glockskins,_G.candyhub.weapons.glock,'glock',function(choice)
        _G.candyhub.weapons.glock = choice
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
    end, true)

    category205:AddDropdown('AWP', awpskins,_G.candyhub.weapons.awp,'awp',function(choice)
        _G.candyhub.weapons.awp = choice
        saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
    end, true)
end


local cfgtab = Window:CreateTab('Config')
local category562065 = cfgtab:AddCategory("Main",1,1)


local function ListFiles2(folderPath)
    if isfolder(folderPath) then
        local files = listfiles(folderPath)
        local allfiles = {}
        for i, file in ipairs(files) do
            if string.find(file, ".json") then
                local newfilename = file:gsub("Candyhub\\CounterBlox\\", ""):gsub(".json", ""):gsub("\\","")
                table.insert(allfiles, newfilename)
            end
        end
        return allfiles
    else
        return {}
    end
end

local currentCfgName = ""

local textbox = category562065:AddTextBox("Config Name", "", "", function(v)
    currentCfgName = v
end, true)

local dropdrown = category562065:AddDropdown('Configs: ', ListFiles2(gameFolder), _G.candyhub_global.maincfg:gsub(".json",""), 'configsconfig', function(v)
    _G.candyhub_global.currentcfg = v
end, true)

category562065:AddButton('Load', function()
    local loadedConfig = loadConfig(_G.candyhub_global.currentcfg .. ".json")
    if loadedConfig then
        for key, value in pairs(loadedConfig) do
            _G.candyhub[key] = value
            if library.pointers[key] then
                library.pointers[key]:Set(value)
            end
        end
    end
end)

category562065:AddButton('Save', function()
    saveConfig(_G.candyhub_global.currentcfg..".json", _G.candyhub)
end)

category562065:AddButton('Create New', function()
    if not isfile(gameFolder .. "/" .. currentCfgName .. ".json") then
        saveConfig(currentCfgName .. ".json", _G.candyhub)
    end
end)

category562065:AddButton('Refresh', function()
    dropdrown:Refresh(ListFiles2(gameFolder), false)
    
    local cfgs = {}
    for i, v in pairs(listfiles(gameFolder)) do
        if v:match("%.json$") then
            local filename = v:match("[^/\\]+$"):gsub(".json", "")
            table.insert(cfgs, filename)
        end
    end
    
    library.pointers.configsconfig.options = cfgs
end)

local autoloadlabel = category562065:AddLabel('AL: '.._G.candyhub_global.maincfg:gsub(".json",""), '')
category562065:AddButton('Set As Autoload', function()
    _G.candyhub_global.maincfg = _G.candyhub_global.currentcfg .. ".json"
    saveConfig("counterbloxmain.json", _G.candyhub_global)
    autoloadlabel:Set('AL: '.._G.candyhub_global.maincfg:gsub(".json",""))
end)


--[[
local settings = {
    name = setts[1] or true,
    boxs = setts[2] or true,
    hpbar = setts[3] or true,
    teamcheck = setts[4] or true,
    teamcheck_mode = setts[5] or 'visible',
    chams = setts[6] or false,
}
]]
--blockesp(game.Players.LocalPlayer, {true,true,true,true,true})


--[[



]]

local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 1.5
FOVring.Transparency = 1
FOVring.Radius = _G.candyhub.fov / 2
FOVring.Color = Color3.fromRGB(255, 255, 255)

local loop
loop = game:GetService('RunService').Heartbeat:Connect(
    function()
        local pressed = game:GetService('UserInputService'):IsMouseButtonPressed(Enum.UserInputType.MouseButton2) -- Right mouse button pressed
        local cam = workspace.CurrentCamera
        local zz = cam.ViewportSize / 2

        if pressed and _G.candyhub.aimbot and not _G.candyhub.silent then
            local curTar = getClosest(cam.CFrame)
            local ssHeadPoint = cam:WorldToScreenPoint(curTar.Character.Head.Position)
            ssHeadPoint = Vector2.new(ssHeadPoint.X, ssHeadPoint.Y)
            if (ssHeadPoint - zz).Magnitude < _G.candyhub.fov then
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, curTar.Character.Head.Position), _G.candyhub.smoothing)
            end
        end
        FOVring.Position = workspace.CurrentCamera.ViewportSize / 2
        FOVring.Radius = _G.candyhub.fov / 2
        FOVring.Color = _G.candyhub.fovcolor
        FOVring.Visible = _G.candyhub.aimbot
    end
)





if hookfunction and getsenv then

--[[
local firefunc = client.firebullet

local oldfunc;oldfunc = hookfunction(getsenv(game.Players.LocalPlayer.PlayerGui.Client).firebullet, function()
    task.spawn(function()
        if _G.candyhub.aimbot and _G.candyhub.silent then
            local targetPlayer = getClosest(workspace.CurrentCamera.CFrame)
            if targetPlayer then
                if Alive(targetPlayer) and Alive(game.Players.LocalPlayer) then
                    if Getv(getClosest(camera.CFrame)) then
                        local oldsetting1 = camera.CameraSubject
                        local oldsetting2 = camera.CameraType
                        local oldsetting3 = camera.CFrame
                        if not targetPlayer then return end
                        local head = targetPlayer.Character:FindFirstChild("Head")
                        if not head then return end
                        camera.CameraType = Enum.CameraType.Scriptable
                        camera.CFrame = CFrame.new(head.Position + Vector3.new(0, 1, 0), head.Position)
                        oldfunc(); print('fired silent bullet at '..targetPlayer.Name)
                        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                            camera.CameraSubject = oldsetting1
                            camera.CameraType = oldsetting2
                            camera.CFrame = oldsetting3
                        end
                        return
                    end
                end
            end
        end
        return oldfunc()
    end)
    return
end)
]]

end






game:GetService('UserInputService').InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        _G.HoldingSpace = true
    end
end)

game:GetService('UserInputService').InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        _G.HoldingSpace = false
    end
end)
