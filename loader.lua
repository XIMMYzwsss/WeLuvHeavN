local PlaceId = game.PlaceId
local GameId = game.GameId

local BASE = "https://raw.githubusercontent.com/XIMMYzwsss/WeLuvHeavN/main/Scripts/"

local Games = {
    {
        Name = "Phantom Forces",
        PlaceIds = { 292439477, 254965063 }, -- PC + Console
        GameIds = { 113491250 },
        File = "pf",
    },
    {
        Name = "Da Hood",
        PlaceIds = { 2788229376 },
        GameIds = { 1008451066 },
        File = "dh",
    },
    {
        Name = "OVERKILL",
        PlaceIds = { 74996816424339 },
        GameIds = {},
        File = "overkill",
    },
    {
        Name = "Violence District",
        PlaceIds = { 93978595733734 },
        GameIds = {},
        File = "vd",
    },
    {
        Name = "Zee",
        PlaceIds = {},
        GameIds = {},
        File = "zee",
        Detect = function()
            local rs = game:GetService("ReplicatedStorage")
            local modules = rs:FindFirstChild("Modules")
            if not (modules and modules:FindFirstChild("GunHandler")) then
                return false
            end
            local function isRE(folder, name)
                local inst = folder and folder:FindFirstChild(name)
                return inst ~= nil and inst:IsA("RemoteEvent")
            end
            local function isRF(folder, name)
                local inst = folder and folder:FindFirstChild(name)
                return inst ~= nil and inst:IsA("RemoteFunction")
            end
            local gameRemotes = rs:FindFirstChild("GameRemotes")
            local mainRemotes = rs:FindFirstChild("MainRemotes")
            local remotes = rs:FindFirstChild("Remotes")
            local gameFolder = rs:FindFirstChild("Game")
            local gameInner = gameFolder and gameFolder:FindFirstChild("Remotes")
            return isRE(gameRemotes, "MainGameEvent")
                or isRE(mainRemotes, "MainRemoteEvent")
                or isRE(mainRemotes, "MainGameEvent")
                or isRE(remotes, "MainRemoteEvent")
                or isRE(gameInner, "MainRemoteEvent")
                or isRF(gameInner, "InvokeServer")
        end,
    },
}

local function matches(entry)
    if typeof(entry.Detect) == "function" then
        local ok, result = pcall(entry.Detect)
        return ok and result == true
    end
    for _, id in ipairs(entry.PlaceIds or {}) do
        if id == PlaceId then
            return true
        end
    end
    for _, id in ipairs(entry.GameIds or {}) do
        if id == GameId then
            return true
        end
    end
    return false
end

local function bust(url)
    local sep = string.find(url, "?", 1, true) and "&" or "?"
    return url .. sep .. "t=" .. tostring(math.floor(os.clock() * 1e6))
end

local function isMissing(src)
    if typeof(src) ~= "string" then
        return true
    end
    local trim = string.match(src, "^%s*(.-)%s*$") or src
    if string.sub(trim, 1, 3) == "404" then
        return true
    end
    if string.lower(string.sub(trim, 1, 9)) == "not found" then
        return true
    end
    return false
end

local function loadScript(url)
    local ok, src = pcall(game.HttpGet, game, bust(url))
    if not ok or typeof(src) ~= "string" or src == "" or isMissing(src) then
        return false
    end
    local fn = loadstring(src)
    if not fn then
        return false
    end
    local ran = pcall(fn)
    return ran == true
end

local found = nil
for _, entry in ipairs(Games) do
    if matches(entry) then
        found = entry
        break
    end
end

if not found then
    warn("[Loader] No script for this game")
    return
end

print(string.format("Loading for %s", found.Name))
if loadScript(BASE .. found.File) then
    print(string.format("Loaded for %s", found.Name))
else
    warn(string.format("Failed for %s", found.Name))
end
