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
        PlaceIds = { 109555340497701, 86077535020995, 76583662972544 },
        GameIds = {},
        File = "zee",
    },
}

local function matches(entry)
    for _, id in ipairs(entry.PlaceIds) do
        if id == PlaceId then
            return true
        end
    end
    for _, id in ipairs(entry.GameIds) do
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
