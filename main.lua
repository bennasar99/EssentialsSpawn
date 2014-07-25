
-- Globals

PLUGIN = {}
LOGPREFIX = ""
WORLDSPAWNPROTECTION = {}
MESSAGE = {}
PLAYERLOCATIONS = {}


function Initialize( Plugin )

	PLUGIN = Plugin

	Plugin:SetName( "EssentialsSpawn" )
	Plugin:SetVersion( 1 )

	LOGPREFIX = "[" .. Plugin:GetName() .. "] "

	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMoving)
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlayerPlacingBlock)
    cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlayerPlacingBlock)
    cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick)
    cPluginManager:AddHook(cPluginManager.HOOK_EXPLODING, OnExploding)
    cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE, OnTakeDamage)
    cPluginManager:AddHook(cPluginManager.HOOK_SPAWNING_MONSTER, OnSpawningMonster)
	
	cRoot:Get():ForEachWorld(
		function (World)
			local WorldIni = cIniFile()
			WorldIni:ReadFile(World:GetIniFileName())
			WORLDSPAWNPROTECTION[World:GetName()] = WorldIni:GetValueSetI("SpawnProtect", "ProtectRadius", 10)
			WorldIni:WriteFile(World:GetIniFileName())
		end
	)

	LOG( LOGPREFIX .. "Plugin v" .. Plugin:GetVersion() .. " Enabled!" )
	return true
		
end

function OnDisable()
	LOG( LOGPREFIX .. "Plugin Disabled!" )
end

function IsInSpawn(X, Y, Z, WorldName)
	-- Function taken from SpawnProtect bearbin's plugin.
	-- Get Spawn Coordinates for the World
	local World = cRoot:Get():GetWorld(WorldName)
	local spawnx = World:GetSpawnX()
	local spawny = World:GetSpawnY()
	local spawnz = World:GetSpawnZ()
	
	-- Get protection radius for the world.
	local protectRadius = GetSpawnProtection(WorldName)
	
	if protectRadius == -1 then
		-- There is no spawn for this world, so the player can't be in it.
		return false
	end

	-- Check if the specified coords are in the spawn.
	if not ((X <= (spawnx + protectRadius)) and (X >= (spawnx - protectRadius))) then
		return false -- Not in spawn area.
	end
	if not ((Y <= (spawny + protectRadius)) and (Y >= (spawny - protectRadius))) then 
		return false -- Not in spawn area.
	end
	if not ((Z <= (spawnz + protectRadius)) and (Z >= (spawnz - protectRadius))) then 
		return false -- Not in spawn area.
	end
		
	-- If they're not not in spawn, they must be in spawn!
	return true

end

function GetSpawnProtection(WorldName)
	return WORLDSPAWNPROTECTION[WorldName]
end
