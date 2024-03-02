if Executed then
    return;
end
getgenv().Executed = true

--// Utils/Library
local Utils = {Locking = false, Target = nil};
local UI = {};

local Lib = loadstring(game:HttpGet('https://raw.githubusercontent.com/reaperbark123/hghghg/masterrr/gggggggaff.lua'))();
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/reaperbark123/Linoria-UI-Testing/masterrr/Theme.lua'))();
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/GMWJKIHGJIWNHIOWNHIUJHYW536363/Reapers-Hub/reaperrr/SaveManager.lua"))();
--// Services
local Players           = game:GetService('Players');
local ReplicatedStorage = game:GetService('ReplicatedStorage');
local UserInputService = game:GetService('UserInputService')
local Workspace         = game:GetService('Workspace');
local RunService        = game:GetService('RunService');

local Client    = Players.LocalPlayer;
local Mouse     = Client:GetMouse();
local Camera    = Workspace.CurrentCamera;
local WTVP      = Camera.WorldToViewportPoint;
--// Window
local Window = Lib:CreateWindow({
    Title = "Reaper's Hub | discord.gg/VCj8vkxAZR | I love my girlfriend <3",
    AutoShow = true,
    Center = true,
})

SaveManager:SetLibrary(Lib)
ThemeManager:SetLibrary(Lib)
--// Main Library
local P1 = Window:AddTab('Main')

local P1S1 = P1:AddLeftGroupbox('Aimbot Options')
local P1S2 = P1:AddRightGroupbox('Theme Customization')
--// UI Related
do
    UI.Aimlock = P1S1:AddToggle('P1S1T1', {
        Text = 'Aimlock',
        Default = true,
    }):AddKeyPicker('AimlockKey', {
        Text = '',
        NoUI = true,
        Default = 'Q',
    })


    UI.Aimlock:AddColorPicker('AimlockLineColor', {
        Title = 'Line Color',
        Default = Color3.fromRGB(255, 255, 255),
        -- Transparency = 0,
        -- Callback = function(Value)end
    })

    UI.AimlockMethod = P1S1:AddDropdown('P1S1D3', {
        Text = 'Method',
        Values = {'Circle', 'Default (Q)'},
        Default = 1,
        Multi = false
    })

    UI.AimlockPrediction = {Value = 0.1318}--[[P1S1:AddSlider('P1S1S1', {
        Text = 'Aimlock Prediction',
        Default = 0.1318,
        Min = 0,
        Max = 10,
        Rounding = 4,
        Compact = false
    })
    --]]

    UI.AimlockTarget = P1S1:AddDropdown('P1S1D1', {
        Text = 'Aimlock Target',
        Values = {'Head', 'HumanoidRootPart'},
        Default = 2,
        Multi = false,
    })

    P1S1:AddDivider()

    P1S1:AddLabel('FOV Color'):AddColorPicker('FovColor', {
        Title = 'Fov Color',
        Default = Color3.fromRGB(255, 255, 255),
    })

    UI.FovRadius = P1S1:AddSlider('P1S1S1', {
        Text = 'FOV Radius',
        Default = 150,
        Min = 0,
        Max = 500,
        Rounding = 0,
        Compact = true
    })
    
    UI.FovSides = P1S1:AddSlider('P1S1S6', {
        Text = 'FOV Sides',
        Default = 12,
        Min = 2,
        Max = 80,
        Rounding = 0,
        Compact = true
    })
    

    P1S1:AddDivider()


    UI.FpsBoost = P1S1:AddDropdown('P1S1D2', {
        Text = 'FPS Boost:',
        Values = {'Delete Gun-Trails', 'Delete NPCs'},
        Default = 0,
        Multi = true,
    })

    UI.FpsBoost:SetValue({
        ['Delete Gun-Trails'] = true,
        ['Delete NPCs'] = true
    })

    UI.AutoStomp = P1S1:AddToggle('P1S1T2', {
        Text = 'Auto Stomp',
        Default = false,
        Tooltip = 'Automatically spam stomps anyone by walking over them'
    })

    UI.ResetCharacter = P1S1:AddToggle('P1S1T3', {
        Text = 'Resets Character',
        Default = false,
        Tooltip = 'Resets character when button is pressed -->'
    }):AddKeyPicker('ResetKey', {
        Text = '',
        Default = 'R',
        NoUI = true,
    })

    -- P1S1:AddDivider()

    -- UI.FpsCap = P1S1:AddSlider('P1S1S5', {
    --     Text = 'Fps Cap',
    --     Default = 144,
    --     Min = 60,
    --     Max = 900,
    --     Rounding = 0,
    --     Compact = true,
    -- })
    -- P1S1:AddButton('FPS Unlock', function()
    --     setfpscap(UI.FpsCap.Value)
    -- end)

    P1S1:AddDivider()


    P1S1:AddLabel('Toggle Keybind'):AddKeyPicker('LibKeybind', {
        Text = '',
        NoUI = true,
        Default = 'LeftControl'
    })
end
Lib.ToggleKeybind = Options.LibKeybind
ThemeManager:ApplyToGroupbox(P1S2)
--// Functions

--// Utility
do
    Utils.ClosestPlayer = function()
        local Max = math.huge
        local Close
        for _,v in next, Players:GetPlayers() do
            if v ~= Client and v.Character ~= nil then
                local char = v.Character
                if char:FindFirstChild(UI.AimlockTarget.Value) ~= nil and char:FindFirstChild('Humanoid') ~= nil and
                    char:FindFirstChild('Humanoid').Health > 0 then
                    local Pos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(char[UI.AimlockTarget.Value].Position)
                    if onScreen then
                        local mag = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Pos.X, Pos.Y)).Magnitude
                        if mag < Max then
                            Max = mag
                            Close = v
                        end
                    end
                end
            end
        end
        return Close
    end

    Utils.ClosestTarget = function()
        local Max = UI.FovRadius.Value
        local Close
        for _, v in next, Players:GetPlayers() do
            if v ~= Client and v.Character ~= nil then
                local char = v.Character
                if char:FindFirstChild(UI.AimlockTarget.Value) ~= nil and char:FindFirstChild('Humanoid') ~= nil and
                char:FindFirstChild('Humanoid').Health > 0 then
                    local Pos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(char[UI.AimlockTarget.Value].Position)
                    if onScreen then
                        local mag = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Pos.X, Pos.Y)).Magnitude
                        if mag < Max then
                            Max = mag
                            Close = v
                        end
                    end
                end
            end
        end
        return Close
    end

    Utils.Aimlock = function()
        if UI.Aimlock.Value then
            if Utils.Locking == true then
                Utils.Target = nil
                Utils.Locking = false

                Lib:Notify('Target: nil')
            else
                Utils.Target = Utils.ClosestPlayer()
                Utils.Locking = true

                Lib:Notify('Target: ' .. Utils.Target.DisplayName)
            end
        end
    end

    Utils.DeleteBeam = function()
        for _,v in next, Workspace:GetChildren() do
            if v.Name == 'Beam' then
                v:Destroy()
            end
        end
    end

    Utils.DeleteBots = function()
        for _,v in next, workspace:GetChildren() do
            if v.Name == 'DaTNTShow52' then
                v:Destroy()
            end
        end
    end

    Utils.AutoStomp = function()
        ReplicatedStorage:WaitForChild("MAINEVENT"):FireServer('STOMP')
    end

    Utils.ResetCharacter = function()
        Client.Character.Humanoid.Health = 0;
    end
end
--// UI Options
do
    Options.AimlockKey:OnClick(function()
        if UI.AimlockMethod.Value == 'Default (Q)' then
            Utils.Aimlock()
        end
    end)

    Options.ResetKey:OnClick(function()
        if UI.ResetCharacter.Value then
            Utils.ResetCharacter()
        end
    end)

    Utils.DeleteNPC     = false;
    Utils.DeleteGunTrail = false;
    UI.FpsBoost:OnChanged(function()
        for key, value in next, UI.FpsBoost.Value do
            if value == true then
                if key == 'Delete Gun-Trails' then
                    Utils.DeleteGunTrail = true;
                end

                if key == 'Delete NPCs' then
                    Utils.DeleteNPC = true;
                end
            else
                if key == 'Delete Gun-Trails' then
                    Utils.DeleteGunTrail = false;
                end

                if key == 'Delete NPCs' then
                    Utils.DeleteNPC = false;
                end
            end
        end
    end)
end
--// While wait
do
    task.spawn(function()
        while task.wait() do
            if Utils.DeleteNPC == true then
                Utils.DeleteBots()
            end

            if Utils.DeleteGunTrail == true then
                Utils.DeleteBeam()
            end

            if UI.AutoStomp.Value == true then
                Utils.AutoStomp()
            end
        end
    end)
end
--// Other Variables
local Line = Drawing.new('Line')
local Line2 = Drawing.new('Line')

local Circle = Drawing.new('Circle')
Circle.Filled = false
Circle.Thickness = 2
Circle.Transparency = 1

Options.FovColor:OnChanged(function()
    Circle.Color = Options.FovColor.Value
end)
UI.FovSides:OnChanged(function()
    Circle.NumSides = UI.FovSides.Value
end)
UI.AimlockMethod:OnChanged(function()
    if UI.AimlockMethod.Value == 'Circle' then
        Circle.Visible = true
    else
        Circle.Visible = false
    end
end)
--// RunService
RunService.RenderStepped:Connect(function()
    if UI.AimlockMethod.Value == 'Circle' then
        Circle.Radius = UI.FovRadius.Value
        Line2.Visible = false
        Circle.Position = Vector2.new(Mouse.X, Mouse.Y + 35);
        local ClosestPerson = Utils.ClosestTarget() or nil;
        if ClosestPerson ~= nil then
            Utils.Target = ClosestPerson
            Utils.Locking = true
            local Vector, onScreen = WTVP(Camera, ClosestPerson.Character[UI.AimlockTarget.Value].Position + (ClosestPerson.Character[UI.AimlockTarget.Value].Velocity * UI.AimlockPrediction.Value))
            if onScreen then
                Line.Color          = Options.AimlockLineColor.Value
                Line.Transparency   = 1
                Line.Thickness      = 2.5
                Line.From           = Vector2.new(Mouse.X, Mouse.y + 36)
                Line.To             = Vector2.new(Vector.X, Vector.Y)
                Line.Visible        = true
            else
                Line.Visible        = false
            end
        else
            Utils.Target = nil
            Utils.Locking = false
            Line.Visible = false
        end
    elseif UI.AimlockMethod.Value == 'Default (Q)' and Utils.Locking == true and Utils.Target ~= nil and Utils.Target.Character then
        Line.Visible = false
        local Person = Utils.Target or nil;
        if Person == nil then
            Line2.Visible = false
        end
        local Vector, onScreen = WTVP(Camera, Person.Character[UI.AimlockTarget.Value].Position + (Person.Character[UI.AimlockTarget.Value].Velocity * UI.AimlockPrediction.Value))
        if onScreen then
            Line2.Color        = Options.AimlockLineColor.Value
            Line2.Transparency = 1
            Line2.Thickness    = 2.5
            Line2.From         = Vector2.new(Mouse.X, Mouse.Y + 36)
            Line2.To           = Vector2.new(Vector.X, Vector.Y)
            Line2.Visible      = true
        else
            Line2.Visible      = false
            Line2.Color        = Options.AimlockLineColor.Value
        end
    else
        Line.Visible = false
        Line2.Visible = false
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player == Utils.Target then
        Utils.Target = nil ;
    end
end)
--// Hookmetamethods
local name;name = hookmetamethod(game, '__namecall', function(self, ...)
    local args = {...};
    local method = getnamecallmethod();

    if self.Name == 'MAINEVENT' then
        if Utils.Locking == true and method == 'FireServer' and args[1] == 'MOUSE' then
            local Character = Utils.Target.Character
            args[2] = Character[UI.AimlockTarget.Value].Position +
            Character[UI.AimlockTarget.Value].Velocity * UI.AimlockPrediction.Value +
            Character[UI.AimlockTarget.Value].Velocity / math.huge

            return name(self, unpack(args))
        end
    end

    return name(self, ...)
end)

Lib:Notify('My dearest angel, I love you so dearly much and I want you to know I always love you forever and forever always\n- Your prince, my highness', 15)
