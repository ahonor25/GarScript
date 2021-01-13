--Wait For Game To Load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

--SetSimulationRadius
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local ChangedSignals = {}
local HiddenPropertyEvents = {}
local IsRBXActive = true
local instance_table = game:GetDescendants()
local env = (getgenv and getgenv or getrenv and getrenv or getfenv)()
local env_add = function(p1, p2, p3, p4)
if rawget(env, p1) then return end
if p4 and not rawget(env, p4) then return end
rawset((p4 and env[p4] or env), p1, (p3 and newcclosure or function(p1) 
return p1
end)(p2))
end
local assert = function(p1, p2, p3)
local A = HiddenPropertyEvents[p1]
    if not p1 then
        error(p2, p3)
    end
end

env_add("setsimulationradius", function(p1, p2)
assert(type(p1) == "number", "invalid argument #1 to '?' (number expected)", 2)
local A = setpropvalue
A(plr, "SimulationRadius", p1)
if p2 then
A(plr, "MaxSimulationRadius", p2)
end
end, true)

setsimulationradius(math.huge, math.huge)

--Teleport Bypass
function tp(x,y,z)
	local dis = (plr.Character.Torso.Position - Vector3.new(x,y,z)).Magnitude
	local time = dis/speed
    local tweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = tweenService:Create(plr.Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(x,y,z)})
    tween:Play()
	tween.Completed:Wait()
end


--Interact remote
function interact(x)
    local Event1 = game:GetService("ReplicatedStorage")["RS_Package"].Remotes.StartInteraction
    local Event2 = game:GetService("ReplicatedStorage")["RS_Package"].Remotes.CompleteInteraction
    Event1:FireServer(x)
    wait(0.1)
    Event2:FireServer(x)
end


--Start The Game
wait(6)
game:GetService("ReplicatedStorage")["RS_Package"].Remotes.PlayerReady:FireServer("Class 2")
wait(6)


--Kill Switch(Reset game after certain time)
function killswitch()
	wait(killtime)
	local Event = game:GetService("ReplicatedStorage")["RS_Package"].Remotes.VoteReset
	Event:FireServer()
end


--Remove Map
function removemap()
	game.Workspace.Map.ExcessParts:Destroy()
end


--Prevent Falling
HumanoidRootPart = plr.Character["HumanoidRootPart"]
Descendants = plr.Character:GetDescendants()
Mass = 0
for i, v in ipairs(Descendants) do
    if v:IsA("BasePart") then
    Mass = Mass + v:GetMass()
    end
end
local AntiGravity = Instance.new("BodyForce") do
    AntiGravity.Force = Vector3.new(0, Mass*workspace.Gravity, 0)
    AntiGravity.Parent = HumanoidRootPart
end


--Noclip
function noclip()
    while true do wait()
        game.Players.LocalPlayer.Character:findFirstChildOfClass("Humanoid"):ChangeState(11)
    end
end


--Loot Small Loots
function lootsmall()
    for _,i in pairs(Workspace.Lootables:GetChildren()) do
		if not table.find(ignore,i.Name) then
			if i.Name == 'JewelSpot' then
				local pos = i:FindFirstChild("SmallJewels2").PrimaryPart.Position
				tp(pos.x,pos.y+1,pos.z)
				interact(i:FindFirstChild("SmallJewels2"))
				interact(i:FindFirstChild("SmallJewels2"))
				interact(i:FindFirstChild("SmallJewels2"))
				i:Destroy()

			elseif i == nil then
				return true
			
			else
				local pos = i.PrimaryPart.Position
				repeat wait()
				tp(pos.x,pos.y+1,pos.z)
				interact(i)
				until (not i:IsDescendantOf(Workspace.Lootables)) or i.Name == 'OpenedRegister'
			end
		else
		end
    end
end


--Loot Big Loots
function lootbig()
	if game.Workspace:FindFirstChild('BigLoot') ~= nil then
		for _,i in pairs(game.Workspace.BigLoot:GetChildren()) do
			if not table.find(ignore,i.Name) then
				local pos = i.PrimaryPart.Position
				repeat wait()
				tp(pos.x,pos.y+1,pos.z)
				interact(i)
				until not i:IsDescendantOf(Workspace.BigLoot)

			elseif i == nil then
				return true
			else end
		end
	else
		return true
	end
end


--Grab lootbox
function lootbox()
	if game.Workspace:FindFirstChild('SafeSpots') ~= nil then
		for _,i in pairs(game.Workspace.SafeSpots:GetChildren()) do
			if i.Name ~= 'SafesScript' then
				local pos = i.PrimaryPart.Position
				repeat wait()
				tp(pos.x,pos.y+1,pos.z)
				interact(i)
				until not i:IsDescendantOf(Workspace.SafeSpots)
			elseif i == nil then
				return true
			else end
		end
	else
		return true
	end
end

--Picklock
function picklock() 
	for _,i in pairs(game.Workspace.Map:GetChildren()) do
		if i.Name == 'Safe' then
			local pos = i.PickLock.Position
			repeat wait()
			tp(pos.x,pos.y+1,pos.z)
			interact(i)
			until i.Name == 'OpenedSafe'
			if takeloot(i) == true then end
		elseif i == nil then
			return true
		else
		end
	end
end

--Take Loot From Safe
function takeloot(safe)
	for _,v in pairs(safe:GetDescendants()) do
		if table.find(safeitem,v.Name) then
			local pos = v.PrimaryPart.Position
			repeat wait()
			tp(pos.x,pos.y+1,pos.z)
			interact(v)
			until not v:IsDescendantOf(safe)
		elseif v == nil then
			return true
		else
		end
	end
end

--Drop off bags
function dropbag()
	local pos = game.Workspace.BagSecuredArea.EscapeVan.PrimaryPart.Position
	tp(pos.x,pos.y,pos.z)
	game:GetService("ReplicatedStorage")["RS_Package"].Remotes.ThrowBag:FireServer(Vector3.new(0, 0, 0))
	wait(3)
	return true
end


--Reset game
function reset()
	local Event = game:GetService("ReplicatedStorage")["RS_Package"].Remotes.VoteReset
	Event:FireServer()
end

