-- ANTI-MASSPLAY

--[[
    MADE BY BRAN
    DISCORD: bran#7858
    
    TODO: [
        FIX CHILD ADDED BOOMBOXES
    ]
]]

local Players = game.GetService(game, "Players")

local IsABoomBox = function(Tool)
    if Tool.ClassName == "Tool" and Tool:FindFirstChild("Handle") and Tool:FindFirstChildOfClass("RemoteEvent") and Tool:FindFirstChild("Handle"):FindFirstChildOfClass("Sound") then
        return true;
    end

    return false;
end

local CheckTools = function(Player)
    local Character = Player.Character or nil;
    local Backpack = Player.Backpack or nil;

    local FoundTools = {
        CharacterTools = {};
        BackpackTools = {};
    }

    if Character ~= nil and Backpack ~= nil then

        for K, V in next, Character:GetChildren() do
            if IsABoomBox(V) then
                table.insert(FoundTools.CharacterTools, V)
            end
        end

        for K, V in next, Backpack:GetChildren() do
            if IsABoomBox(V) then
                table.insert(FoundTools.BackpackTools, V)
            end
        end

        return FoundTools;
    end
end

local MuteSound = function(Sound)
    Sound = Sound or nil

    if Sound ~= nil and Sound:IsA("Sound") and Sound.Playing then
        Sound.Playing = false;
        Sound.TimePosition = math.huge - math.huge / math.huge
    end
end

local MuteMassPlayers = function(Character)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(Character) or nil;
    local FoundTools = nil;

    if Character ~= nil then
        FoundTools = CheckTools(PlayerFromCharacter)
        local CharacterTools, BackpackTools = FoundTools.CharacterTools, FoundTools.BackpackTools

        local AddedTools = {}

        Character.ChildAdded:Connect(function(Tool)
            if IsABoomBox(Tool) then
                for K, V in next, Character:GetDescendants() do
                    if IsABoomBox(V) then
                        table.insert(AddedTools, V)
                    end
                end
    
                for K, V in next, AddedTools do
                    if IsABoomBox(V) then
                        V.Unequipped:Connect(function()
                            table.remove(AddedTools, V)
                        end)
                    end
                end
    
                if #AddedTools > 1 then
                    for K, V in next, AddedTools do
                        for K2, V2 in next, V:GetDescendants() do
                            if V2:IsA("Sound") then
                                MuteSound(V2)
                            end
                        end
                    end
                end
            end
        end)

        if #CharacterTools > 1 then
            for K, V in next, CharacterTools do
                for K2, V2 in next, V:GetDescendants() do
                    if V2:IsA("Sound") then
                        MuteSound(V2)
                    end
                end
            end
    
            print("MASSPLAYER: " .. PlayerFromCharacter.Name)
        end;

        if #BackpackTools > 1 then
            local PlayingSounds = {};

            for K, V in next, BackpackTools do
                for K2, V2 in next, V:GetDescendants() do
                    if V2:IsA("Sound") and V2.Playing then
                        table.insert(PlayingSounds, V2)
                    end
                end
            end

            if #PlayingSounds > 1 then
                for K, V in next, PlayingSounds do
                    MuteSound(V)
                end
            end

            print("MASSPLAYER: " .. PlayerFromCharacter.Name)
        end
    end
end

for K, V in next, Players:GetPlayers() do
    MuteMassPlayers(V.Character)
    V.CharacterAdded:Connect(MuteMassPlayers)
end

Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(MuteMassPlayers)
end)
