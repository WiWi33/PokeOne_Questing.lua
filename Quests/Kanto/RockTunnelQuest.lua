-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Rock Tunnel'
local description = 'Route 9 to Celadon'
local level = 15

local RockTunnelQuest = Quest:new()

function RockTunnelQuest:new()
	return Quest.new(RockTunnelQuest, name, description, level)
end

function RockTunnelQuest:isDoable()
	if self:hasMap() and not hasItem("Silph Scope") then
		return true
	end
	return false
end

function RockTunnelQuest:isDone()
	if getAreaName() == "Celadon City" or getAreaName() == "Vermilion Pokémon Center" then --FIX Blackout if not Route10 or Lavander Pokecenter is Setup
		return true
	else
		return false
	end
end

function RockTunnelQuest:Route9()
if game.inRectangle(204,104,215,109) and isNpcOnCell(212,109) then
    return talkToNpcOnCell(212,109)
	elseif isNpcOnCell(222,137) then 
	    return talkToNpcOnCell(222,137)  -- rare candy
		elseif isNpcOnCell(222,142) then 
	    return talkToNpcOnCell(222,142)  --  super potion
				elseif isNpcOnCell(267,137) then 
	    return talkToNpcOnCell(267,137)  -- chestos berry
		elseif isNpcOnCell(309,139) then 
	    return talkToNpcOnCell(309,139)  --  persism berry
				elseif isNpcOnCell(317,147) then 
	    return talkToNpcOnCell(317,147)  --  panab berry
else
	return moveToCell(315,154)
end
end 

function RockTunnelQuest:Route10()
	if game.inRectangle(297,151,322,170) then
		if self:needPokecenter() or not game.isTeamFullyHealed() then
			return moveToCell(308,161)
		else
			return moveToCell(301,157)
		end
	else
		return moveToCell(120,110)
	end
end

function RockTunnelQuest:RockTunnelPokémonCenter()
if self:needPokecenter() or not game.isTeamFullyHealed() then
	self:pokecenter("Route 10")
else 
   moveToCell(18,33)
end 
end

function RockTunnelQuest:RockTunnel()
	if game.inRectangle(43,14,58,27) then
	   if self:needPokecenter() or not game.isTeamFullyHealed() then
	   return moveToCell(56,19)
	   --elseif isNpcOnCell(41,27) then 
	  -- return talkToNpcOnCell(41,27)
	   else
		return moveToCell(47,25)
	  end 
	elseif game.inRectangle(1,59,59,75) then
	  if isNpcOnCell(16,67) then 
	   talkToNpcOnCell(16,67)
	  else 
		return moveToCell(17,62)
		end 
	elseif game.inRectangle(15,14,42,30) then
	   if isNpcOnCell(42,19) then 
	    return talkToNpcOnCell(42,19)
		else
		return moveToCell(20,26) 
		end
	elseif game.inRectangle(14,72,38,93) then 
	  return moveToCell(17,91)
	  else 
	  moveToCell(33,46)
	end
end



function RockTunnelQuest:LavenderTown()
    if self:needPokecenter() or not game.isTeamFullyHealed() then
		return moveToCell(115,116)

	else 
		return moveToCell(97,122)
	end
end

function RockTunnelQuest:LavenderPokémonCenter()
if self:needPokecenter() or not game.isTeamFullyHealed() then
	self:pokecenter("Lavender Town")
else
   return moveToCell(53,25)
end 
end

function RockTunnelQuest:Route8()
--if self:needPokecenter() or not game.isTeamFullyHealed() then

	--return moveToCell(105,122)

--else 
	--if isNpcOnCell(90,117) then -- Item: Leppa Berry
	--	return talkToNpcOnCell(90,117)
	--else
	if isNpcOnCell(57,3) then -- Item: Leppa Berry
		return talkToNpcOnCell(57,3)
	elseif isNpcOnCell(52,9) then --Pokemon: Growlithe LvL 10 (BlueBall)
		return talkToNpcOnCell(52,9)
	else
		return moveToCell(26,119)
	end
--end 
end


function RockTunnelQuest:UndergroundPath()
if game.inRectangle(105, 6,115, 14) then
	return moveToCell(108,10)
elseif game.inRectangle(32, 4,88, 14) then
  return moveToCell(33,9)
else
  return moveToCell(8,11)
end 
end

function RockTunnelQuest:Route7()
	if isNpcOnCell(198,104) then 
		return talkToNpcOnCell(198,104)
		elseif isNpcOnCell(204,94) then 
		return talkToNpcOnCell(204,94)
	else
		return moveToCell(167,85)
	end
end

return RockTunnelQuest