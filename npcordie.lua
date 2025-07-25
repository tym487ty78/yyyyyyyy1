if game.PlaceId == 11276071411 then
local function CreateESPs()
    for i, plr in ipairs(game.Players:GetChildren()) do
        if workspace:FindFirstChild(plr.Name) then
            local char = workspace[plr.Name]
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and char:GetAttribute("LivesLeft") ~= nil then
                if not hrp:FindFirstChild("PlayerIndicator") then
                    local billboardGui = Instance.new("BillboardGui")
                    billboardGui.Name = "PlayerIndicator"
                    billboardGui.Adornee = hrp
                    billboardGui.Size = UDim2.new(4, 0, 6, 0)
                    billboardGui.StudsOffset = Vector3.new(0, 0, 0)
                    billboardGui.AlwaysOnTop = true

                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = Color3.new(1, 0, 0)
                    frame.BackgroundTransparency = 0.5 
                    frame.BorderSizePixel = 0
                    frame.Parent = billboardGui
                    billboardGui.Parent = hrp
                end
            end
        end
    end    
end

local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/vateq/UILIBrewrites/refs/heads/main/justtestin"))()
local win = SolarisLib:New({
  Name = "Be NPC or die - by vateq#0 / candyhub",
  FolderToSave = "SolarisLibStuff"
})

local tab = win:Tab("Main Tab")
local sec = tab:Section("Main")

_G.esp = false

local toggle = sec:Toggle("ESP Humans", false,"Toggle", function(t)
    _G.esp = t
    while _G.esp and task.wait(2) do
        CreateESPs()
    end
end)

local toggle = sec:Toggle("TaskMod (instant+inf-range)", false,"Toggle", function(t)
    _G.mapcheck = t -- Office, PirateOutpost, Town, Hospital, Hotel
    while _G.mapcheck and task.wait(3) do
        for i, item in workspace:GetChildren() do
            if item.ClassName == "Folder" then
                if item.Name ~= "Lobby" then
                    if item.Name ~= "Plots" then
                        if item.Name ~= "Ragdolls" then
                            if item then
                                if item:FindFirstChild("Tasks") then
                                    for i, task in item:FindFirstChild("Tasks"):GetChildren() do
                                        if task:FindFirstChild("ProximityPrompt") then
                                            task:FindFirstChild("ProximityPrompt").HoldDuration = 0
                                            task:FindFirstChild("ProximityPrompt").MaxActivationDistance = 1111
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
end
