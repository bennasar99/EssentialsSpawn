function OnPlayerPlacingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType)

	if BlockFace == -1 then
		return false
	end
     
	if Player:HasPermission("espawn.bypass") then
		return false
	end

	WorldName = Player:GetWorld():GetName()

	if IsInSpawn(BlockX, BlockY, BlockZ, WorldName) and PLACE == true then
		Player:SendMessageInfo("Go further from spawn to build")
		return true
	end
	
	return false

end

function OnPlayerBreakingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, Status, BlockType, BlockMeta)

	if BlockFace == -1 then
		return false
	end

	if Player:HasPermission("espawn.bypass") then
		return false
	end

	local WorldName = Player:GetWorld():GetName()

	if IsInSpawn(BlockX, BlockY, BlockZ, WorldName) and BUILD == true then
		Player:SendMessageInfo("Go further from spawn to build")
		return true
	end
	
	return false

end

function OnExploding(World, ExplosionSize, CanCauseFire, X, Y, Z, Source, SourceData)

	if IsInSpawn(X, Y, Z, World:GetName()) and EXPLODE == true then
		return true
	end
	
	return false

end

function OnSpawningMonster(World, Monster)

	if IsInSpawn(Monster:GetPosX(), Monster:GetPosY(), Monster:GetPosZ(), World:GetName()) and MOBSPAWNING == true then
		return true
	end
	
	return false
		
end

function OnPlayerMoving(Player)
    --Based on SpawnProtect too--
	local WorldName = Player:GetWorld():GetName()
	local X = Player:GetPosX()
	local Y = Player:GetPosY()
	local Z = Player:GetPosZ()
	local playername = Player:GetName()
	
	if PLAYERLOCATIONS[playername] ~= nil then
		if not IsInSpawn(PLAYERLOCATIONS[playername]["x"], PLAYERLOCATIONS[playername]["y"], PLAYERLOCATIONS[playername]["z"], PLAYERLOCATIONS[playername]["world"]) then
			if IsInSpawn(X, Y, Z, WorldName) then
				if SPAWNMESSAGE == true then
				    Player:SendMessageInfo(messageenter)
				end
			end
		else
			if not IsInSpawn(X, Y, Z, WorldName) then
				if SPAWNMESSAGE == true then
					Player:SendMessageInfo(messageleave)
				end
			end
		end
	end

	PLAYERLOCATIONS[playername] = {x = X, y = Y, z = Z, world = WorldName}

end

function OnTakeDamage(Receiver, TDI)

    if TDI.Attacker == nil then
        if TDI.DamageType == dtFalling and FALLDAMAGE == true then
            if IsInSpawn(Receiver:GetPosX(), Receiver:GetPosY(), Receiver:GetPosZ(), Receiver:GetWorld():GetName()) and PVP == true then
                return true
            end
        end
        return false
    end
     
    if Receiver:IsPlayer() then
        if TDI.Attacker:IsPlayer() then
            if IsInSpawn(Receiver:GetPosX(), Receiver:GetPosY(), Receiver:GetPosZ(), Receiver:GetWorld():GetName()) and PVP == true then
                return true
            end
        end
    end
	
	return false

end

function OnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)

	if BlockFace == -1 then
		return false
	end

	if Player:HasPermission("espawn.bypass") then
		return false
	end

	local WorldName = Player:GetWorld():GetName()

	if IsInSpawn(BlockX, BlockY, BlockZ, WorldName) and RIGHTCLICK == true then
		Player:SendMessageInfo("Go further from spawn if you want to use your hand!")
		return true
	end
	
	return false

end

