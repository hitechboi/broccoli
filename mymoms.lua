--[[
    Check it Interface
    by hitechboi / nejrio
    github.com/hitechboi
    star my post :p, have fun!
]]
local _a = game.GameId
local _b = 73885730
local _c = math.floor
local _d = tostring
if _c(_a) ~= _c(_b) then
    notify("Check it", "This script is not supported for this game.", 5)
    return
end

local _e = table.insert
local _f = pairs
local _g = ipairs
local _h = pcall
local _i = math.floor
local _j = Vector3.new

loadstring(game:HttpGet("https://raw.githubusercontent.com/hitechboi/bizzarehijinks/refs/heads/main/rangerover.lua"))()
repeat task.wait() until _G.UILib
local UILib = _G.UILib

local user = game.Players.LocalPlayer.Name
local gameName = getgamename()

local enabled = false
local infiniteAmmo = false
local instantReload = false
local fastFire = false
local instantFire = false
local shotgunAuto = false
local arInstantFire = false
local m9FullAuto = false
local extendRange = false
local ammoVal = 1
local reloadVal = 0.01
local fireRateVal = 0.1
local rangeVal = 1500
local destroyed = false
local isDead = false

local AR_NAMES = {["AK-47"]=true, ["MP5"]=true, ["FAL"]=true, ["M4A1"]=true}

local lp = game.Players.LocalPlayer
local Humanoid = nil

local function grabRefs()
    _h(function()
        local char = lp.Character
        if char then
            Humanoid = char:FindFirstChild("Humanoid")
        end
    end)
end
grabRefs()

local ATTRS = {
    MaxAmmo     = function() return infiniteAmmo and ammoVal end,
    CurrentAmmo = function() return infiniteAmmo and ammoVal end,
    ReloadTime  = function() return instantReload and reloadVal end,
    FireRate    = function(tool)
        if instantFire then return 0.001 end
        if fastFire then
            if arInstantFire and AR_NAMES[tool.Name] then return nil end
            return fireRateVal
        end
        return nil
    end,
    Range       = function() return extendRange and rangeVal end,
}

local function isGun(tool)
    if not tool:IsA("Tool") then return false end
    for attr in _f(ATTRS) do
        if tool:GetAttribute(attr) ~= nil then return true end
    end
    return false
end

local function getGunCount()
    local bp = lp:FindFirstChild("Backpack")
    local count = 0
    if bp then
        for _, t in _g(bp:GetChildren()) do
            if isGun(t) then count = count + 1 end
        end
    end
    return count
end

local win = UILib.Window("Check it", "Interface", gameName)

local main = win:Tab("Main")
local guns = win:Tab("Gun Mods")
local fun = win:Tab("Fun")
local range = win:Tab("Range")
local guntps = win:Tab("Gun TPs")
local teleports = win:Tab("Teleports")
local misc = win:Tab("Misc")
local updates = win:Tab("Updates")

main:Div("Main", true)
main:Toggle("Enabled", false, function(s) enabled = s end, "Master toggle for all gun mods")

guns:Div("FIRE", true)
guns:Toggle("Apply Reload", false, function(s) instantReload = s end, "Toggles Reload Slider(M9 Only)")
guns:Slider("Reload Time", 0.01, 5.0, 0.01, function(v) reloadVal = v end, true, "Lower = faster reload")
guns:Toggle("Apply Fire Rate", false, function(s) fastFire = s end, "Toggles FireRate Slider(ARs excluded if AR Instant on)")
guns:Slider("Fire Rate", 0.1, 1.0, 0.1, function(v) fireRateVal = v end, true, "Lower = faster fire")

fun:Div("AMMO", true)
fun:Toggle("Apply Ammo", false, function(s) infiniteAmmo = s end, "Visual only - once below original ammo count no damage")
fun:Slider("Ammo Amount", 1, 9999, 1, function(v) ammoVal = _i(v) end)
fun:Div("M9", true)
fun:Toggle("M9 Full Auto", false, function(s) m9FullAuto = s end, "Toggles AutoFire on M9 pistol")

range:Div("RANGE", true)
range:Toggle("Extend Range", false, function(s) extendRange = s end, "Sets Range value")
range:Slider("Range", 0, 15000, 1500, function(v) rangeVal = _i(v) end)

local function teleportAndBack(x, y, z)
    _h(function()
        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local ox = hrp.Position.X
            local oy = hrp.Position.Y
            local oz = hrp.Position.Z
            hrp.AssemblyLinearVelocity = _j(0, 0, 0)
            hrp.Position = _j(x, y, z)
            task.wait(0.5)
            hrp.AssemblyLinearVelocity = _j(0, 0, 0)
            hrp.Position = _j(ox, oy, oz)
        end
    end)
end

guntps:Div("CRIMINAL GUNS", true)
guntps:Button("Remington 870", UILib.Colors.ROWBG, function() teleportAndBack(-938.22, 94.31,  2039.17) end, UILib.Colors.WHITE)
guntps:Button("AK-47",         UILib.Colors.ROWBG, function() teleportAndBack(-931.39, 94.37,  2039.39) end, UILib.Colors.WHITE)
guntps:Button("M700",          UILib.Colors.ROWBG, function() teleportAndBack(-919.96, 95.01,  2036)    end, UILib.Colors.WHITE)
guntps:Button("FAL",           UILib.Colors.ROWBG, function() teleportAndBack(-902.34, 94.35,  2047.93) end, UILib.Colors.WHITE)

guntps:Div("COP GUNS", true)
guntps:Button("MP5",           UILib.Colors.ROWBG, function() teleportAndBack(813.16,  100.88, 2229)    end, UILib.Colors.WHITE)
guntps:Button("Rem Cop",       UILib.Colors.ROWBG, function() teleportAndBack(820.64,  100.88, 2228.95) end, UILib.Colors.WHITE)
guntps:Button("M700 Cop",      UILib.Colors.ROWBG, function() teleportAndBack(836.09,  100.74, 2229.32) end, UILib.Colors.WHITE)
guntps:Button("M4A1",          UILib.Colors.ROWBG, function() teleportAndBack(847.71,  100.74, 2229.33) end, UILib.Colors.WHITE)

local function teleport(x, y, z)
    _h(function()
        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = _j(0, 0, 0)
            hrp.Position = _j(x, y, z)
        end
    end)
end

teleports:Div("LOCATIONS", true)
teleports:Button("Yard",          UILib.Colors.ROWBG, function() teleport(784.12,  98,     2460.25) end, UILib.Colors.WHITE)
teleports:Button("Nexus",         UILib.Colors.ROWBG, function() teleport(873.89,  100,    2390.69) end, UILib.Colors.WHITE)
teleports:Button("Cafeteria",     UILib.Colors.ROWBG, function() teleport(901.37,  99.99,  2299.91) end, UILib.Colors.WHITE)
teleports:Button("Guard Station", UILib.Colors.ROWBG, function() teleport(829.99,  99.99,  2295.10) end, UILib.Colors.WHITE)
teleports:Button("Armory",        UILib.Colors.ROWBG, function() teleport(827.54,  99.98,  2240.20) end, UILib.Colors.WHITE)
teleports:Button("Prison Cells",  UILib.Colors.ROWBG, function() teleport(920.01,  99.99,  2442.30) end, UILib.Colors.WHITE)
teleports:Button("Roof",          UILib.Colors.ROWBG, function() teleport(932.23,  118.99, 2365.07) end, UILib.Colors.WHITE)
teleports:Button("Criminal Base", UILib.Colors.ROWBG, function() teleport(-936.75, 94.13,  2054.35) end, UILib.Colors.WHITE)

misc:Div("EXTRAS", true)
misc:Toggle("Instant Fire Rate", false, function(s) instantFire = s end, "Insta FireRate!!!")
misc:Toggle("Shotgun Full Auto", false, function(s) shotgunAuto = s end, "Toggles AutoFire on Remington 870")
misc:Toggle("AR Instant Fire Rate", false, function(s) arInstantFire = s end, "Instant fire for AK-47, MP5, FAL, M4A1")
misc:Div("APPEARANCE", true)
misc:Dropdown("Theme", {"Check it", "Moon", "Grass", "Light", "Dark"}, 1, function(name)
    win:ApplyTheme(name)
end)
misc:Div("INFO", true)
misc:Button("by hitechboi / nejrio", UILib.Colors.ROWBG, nil, UILib.Colors.GRAY)

updates:Div("UPDATE LOG")
updates:Log({
    "STAR MY POST ! :D",
    "> Relase! - Gun Mods - Ammo, Reload, Fire Rate",
    "> Relase! - Gun TPs - Teleport to guns",
    "> Relase! - Teleports - Map locations",
    "> Relase! - Range - Extend gun range (15k)",
    "> v1.1 - Moved Ammo due to it being visuals",
    "> v1.1 - Added Ar's instant fire rate",
    "> v1.1 - Added M9 full auto(Fun tab)",
    "> Realized that no reload works only with M9",
    "> v1.1 - AR Instant now excludes,",
	"> Ar's from fire rate slider. ",
	"> v1.1 - Added priorities to fire rate features",
    "> hi :p"
}, true)

win:SettingsTab(function()
    destroyed = true
    win:Destroy()
end)

win:Init("Main", function()
    return "Guns detected: " .. getGunCount()
end)

while not destroyed do
    task.wait(0.01)

    _h(function()
        local char = lp.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                if hum ~= Humanoid then
                    Humanoid = hum
                    isDead = false
                end
                if hum.Health <= 0 then
                    isDead = true
                elseif isDead and hum.Health > 0 then
                    isDead = false
                end
            end
        end
    end)

    if not isDead and enabled then
        _h(function()
            local containers = {}
            local bp = lp:FindFirstChild("Backpack")
            if bp then
                _e(containers, bp)
            end
            if lp.Character then
                _e(containers, lp.Character)
            end
            for _, container in _g(containers) do
                for _, tool in _g(container:GetChildren()) do
                    if tool.Name == "Remington 870" then
                        tool:SetAttribute("AutoFire", shotgunAuto)
                    end
                    if arInstantFire and AR_NAMES[tool.Name] then
                        tool:SetAttribute("FireRate", 0.001)
                    end
                    if m9FullAuto and tool.Name == "M9" then
                        tool:SetAttribute("AutoFire", true)
                    end
                    if isGun(tool) then
                        for attr, valFn in _f(ATTRS) do
                            if tool:GetAttribute(attr) ~= nil then
                                local val = valFn(tool)
                                if val then
                                    tool:SetAttribute(attr, val)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end
