--[[
    Check it Interface
    by hitechboi / nejrio
    github.com/hitechboi
    star my post :p, have fun!
]]
local _h = pcall
local _g = ipairs

loadstring(game:HttpGet("https://raw.githubusercontent.com/hitechboi/bizzarehijinks/refs/heads/main/matchup.lua"))()
repeat task.wait() until _G.UILib
local UILib = _G.UILib

local gameName = getgamename()
local user = game.Players.LocalPlayer.Name

local infStamina = false
local infCombatStamina = false
local sanityLock = false
local maxClashStrength = false
local scrapEsp = false
local espMaxDist = 200
local staminaRegen = 0.7
local staminaRegenEnabled = false
local destroyed = false

local win = UILib.Window("Check it", "Interface", gameName)

local stamina = win:Tab("Player")
local esp = win:Tab("Esp")

stamina:Div("STAMINA", true)
stamina:Toggle("Infinite Stamina", false, function(s) infStamina = s end, "Locks Stamina at 100")
stamina:Toggle("Infinite Combat Stamina", false, function(s) infCombatStamina = s end, "Locks CombatStamina at 100")
stamina:Toggle("Sanity Lock", false, function(s) sanityLock = s end, "Locks Sanity at 100")
stamina:Toggle("Max Clash Strength", false, function(s) maxClashStrength = s end, "Locks ClashStrength at 100")
stamina:Div("REGEN", true)
stamina:Toggle("Apply Stamina Regen", false, function(s) staminaRegenEnabled = s end, "Enables StaminaRegen slider")
stamina:Slider("Stamina Regen", 0.7, 15, 0.7, function(v) staminaRegen = v end, true, "Sets StaminaRegen value")

esp:Div("ITEMS", true)
esp:Toggle("Scrap", false, function(s) scrapEsp = s end, "Shows ESP labels on ScrapNormal items")
esp:Slider("Render Distance", 50, 5000, 200, function(v) espMaxDist = math.floor(v) end, false, "Max distance to show ESP")

win:SettingsTab(function()
    destroyed = true
    win:Destroy()
end)

win:Init("Player")

local espLabels = {}

local function clearEspLabels()
    for _, lbl in ipairs(espLabels) do
        pcall(function() lbl:Remove() end)
    end
    espLabels = {}
end

local espTimer = 0
local espColorTimer = 0

while not destroyed do
    task.wait(0.01)
    _h(function()
        local char = game.Workspace:FindFirstChild(user)
        if not char then return end
        local stats = char:FindFirstChild("Stats")
        if not stats then return end
        if infStamina then stats.Stamina.Value = 100 end
        if infCombatStamina then stats.CombatStamina.Value = 100 end
        if sanityLock then stats.Sanity.Value = 100 end
        if maxClashStrength then stats.ClashStrength.Value = 100 end
        if staminaRegenEnabled then stats.StaminaRegen.Value = staminaRegen end
    end)

    espColorTimer = espColorTimer + 0.01
    espTimer = espTimer + 0.01
    if espTimer >= 0.05 then
        espTimer = 0
        clearEspLabels()
        if scrapEsp then
            pcall(function()
            local scrapFolder = game.Workspace.Misc.Zones.LootingItems.Scrap
            local lp = game.Players.LocalPlayer
            local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            local t = math.abs(math.sin(espColorTimer * 1.5))
            local r = math.floor(101 + t * (64 - 101))
            local g = math.floor(67 + t * (40 - 67))
            local b = math.floor(50 + t * (30 - 50))
            for _, item in ipairs(scrapFolder:GetChildren()) do
                if item.Name == "ScrapNormal" then
                    local part = item:FindFirstChild("GearMain")
                    if part and part.Transparency < 1 then
                        local screenPos, onScreen = WorldToScreen(part.Position)
                        local dist = 0
                        if hrp then
                            local dx = hrp.Position.X - part.Position.X
                            local dy = hrp.Position.Y - part.Position.Y
                            local dz = hrp.Position.Z - part.Position.Z
                            dist = math.floor(math.sqrt(dx*dx + dy*dy + dz*dz))
                        end
                        if dist <= espMaxDist then
                            local lbl = Drawing.new("Text")
                            lbl.Text = "Scrap"
                            lbl.Color = Color3.fromRGB(r, g, b)
                            lbl.Outline = true
                            lbl.Center = true
                            lbl.Size = 16
                            lbl.Font = Drawing.Fonts.System
                            lbl.Position = screenPos
                            lbl.Visible = true
                            lbl.ZIndex = 5
                            table.insert(espLabels, lbl)
                            local distLbl = Drawing.new("Text")
                            distLbl.Text = "[" .. dist .. "m]"
                            distLbl.Color = Color3.fromRGB(70, 160, 210)
                            distLbl.Outline = true
                            distLbl.Center = true
                            distLbl.Size = 14
                            distLbl.Font = Drawing.Fonts.System
                            distLbl.Position = Vector2.new(screenPos.X, screenPos.Y + 18)
                            distLbl.Visible = true
                            distLbl.ZIndex = 5
                            table.insert(espLabels, distLbl)
                        end
                    end
                end
            end
            end)
        end
    end
end
clearEspLabels()
