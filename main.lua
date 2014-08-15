
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
    local World = cRoot:Get():GetWorld(WorldName)
    local SpawnLoc = Vector3d(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
    local PlayerLoc = Vector3d(X, Y, Z)
     
    -- Get protection radius for the world.
    local protectRadius = GetSpawnProtection(WorldName)
     
    if (protectRadius == -1) then
        -- There is no spawn for this world, so the player can\'t be in it.
        return false
    end
 
    if ((SpawnLoc - PlayerLoc):Length() <= protectRadius) then
        return true
    end
    return false
end

function GetSpawnProtection(WorldName)
	return WORLDSPAWNPROTECTION[WorldName]
end
