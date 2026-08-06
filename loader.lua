local PlaceId = game.PlaceId
local GameId = game.GameId

local Games = {
    {
        Name = "Phantom Forces",
        PlaceIds = { 292439477, 254965063 }, -- PC + Console
        GameIds = { 113491250 },
        Url = "https://raw.githubusercontent.com/USER/REPO/main/pf.lua",
    },
    {
        Name = "Da Hood",
        PlaceIds = { 2788229376 },
        GameIds = { 1008451066 },
        Url = "https://raw.githubusercontent.com/USER/REPO/main/dh.lua",
    },
    {
        Name = "OVERKILL",
        PlaceIds = { 74996816424339 },
        GameIds = {},
        Url = "https://raw.githubusercontent.com/USER/REPO/main/overkill.lua",
    },
    {
        Name = "Violence District",
        PlaceIds = { 93978595733734 },
        GameIds = {},
        Url = "https://raw.githubusercontent.com/USER/REPO/main/vd.lua",
    },
    {
        Name = "Zee",
        PlaceIds = { 109555340497701 },
        GameIds = {},
        Url = "https://raw.githubusercontent.com/USER/REPO/main/zee-autoshoot.luau",
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

local function loadScript(url)
    local ok, src = pcall(game.HttpGet, game, url)
    if not ok or typeof(src) ~= "string" or src == "" then
        warn("[Loader] HttpGet failed:", url, src)
        return false
    end
    local fn, err = loadstring(src)
    if not fn then
        warn("[Loader] loadstring failed:", err)
        return false
    end
    local ran, runErr = pcall(fn)
    if not ran then
        warn("[Loader] script error:", runErr)
        return false
    end
    return true
end

local found = nil
for _, entry in ipairs(Games) do
    if matches(entry) then
        found = entry
        break
    end
end

if not found then
    warn(string.format("[Loader] No script for PlaceId=%s GameId=%s", tostring(PlaceId), tostring(GameId)))
    return
end

print(string.format("[Loader] Detected %s — loading…", found.Name))
if not loadScript(found.Url) then
    warn(string.format("[Loader] Failed to load %s", found.Name))
end
