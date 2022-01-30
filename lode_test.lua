-- title:  lode test
-- author: Matt - Yamii
-- desc:   GAMECODEUR GAME JAM: LODE RUNNER. January 2022
-- script: lua


--[[
██    ██  █████  ██████  ██  █████  ██████  ██      ███████ ███████ 
██    ██ ██   ██ ██   ██ ██ ██   ██ ██   ██ ██      ██      ██      
██    ██ ███████ ██████  ██ ███████ ██████  ██      █████   ███████ 
 ██  ██  ██   ██ ██   ██ ██ ██   ██ ██   ██ ██      ██           ██ 
  ████   ██   ██ ██   ██ ██ ██   ██ ██████  ███████ ███████ ███████ 
                                                                    
]]

timer={}
	timer.t=0--var temps actualisee, en secondes
	timer.x=3
	timer.y=2
	timer.c=4
	timer.ms=0
	timer.s=0
	timer.m=0
	timer.h=0

player={}
	player.x=90
	player.y=32
	player.sprite=1
	player.state="idle"
	player.timer=0
	player.speedAnim=1.0185
	player.minSpr=1
	player.maxSpr=4
	player.countA=nil--compteur d'animation(sec)==minSpr !
	player.revertSpr=0
	player.gravity=1
	player.vx=0
	player.vy=0
	player.speed=1
	player.maxSpeed=1
	player.state="Def 1st value"

	player.x1_inner=0
	player.y1_inner=0
	player.x2_inner=0
	player.y2_inner=0
	player.x3_inner=0
	player.y3_inner=0
	player.x4_inner=0
	player.y4_inner=0
	player.x5_inner=0
	player.y5_inner=0
	player.x6_inner=0
	player.y6_inner=0
	player.x7_inner=0
	player.y7_inner=0
	player.x8_inner=0
	player.y8_inner=0

	player.x1_outer=0
	player.y1_outer=0
	player.x2_outer=0
	player.y2_outer=0
	player.x3_outer=0
	player.y3_outer=0
	player.x4_outer=0
	player.y4_outer=0
	player.x5_outer=0
	player.y5_outer=0
	player.x6_outer=0
	player.y6_outer=0
	player.x7_outer=0
	player.y7_outer=0
	player.x8_outer=0
	player.y8_outer=0
 
vilain={}
	vilain.x=90
	vilain.y=24
	vilain.sprite=1
	vilain.state="idle"
	vilain.timer=0
	vilain.speed=1.5
	vilain.speedAnim=1.0055
	vilain.minSpr=5
	vilain.maxSpr=8
	vilain.countA=nil--compteur d'animation(sec)==minSpr !
	vilain.revertSpr=0
	vilain.gravity=1
	vilain.vx=0
	vilain.vy=0

	vilain.x1_inner=0
	vilain.y1_inner=0
	vilain.x2_inner=0
	vilain.y2_inner=0
	vilain.x3_inner=0
	vilain.y3_inner=0
	vilain.x4_inner=0
	vilain.y4_inner=0
	vilain.x5_inner=0
	vilain.y5_inner=0
	vilain.x6_inner=0
	vilain.y6_inner=0
	vilain.x7_inner=0
	vilain.y7_inner=0
	vilain.x8_inner=0
	vilain.y8_inner=0

	vilain.x1_outer=0
	vilain.y1_outer=0
	vilain.x2_outer=0
	vilain.y2_outer=0
	vilain.x3_outer=0
	vilain.y3_outer=0
	vilain.x4_outer=0
	vilain.y4_outer=0
	vilain.x5_outer=0
	vilain.y5_outer=0
	vilain.x6_outer=0
	vilain.y6_outer=0
	vilain.x7_outer=0
	vilain.y7_outer=0
	vilain.x8_outer=0
	vilain.y8_outer=0

collidables={}
 collidables.wallDown={16}

playerState={}
 playerState.ladder_up=false
--

--[[
██   ██ ███████ ██      ██████  ███████ ██████  ███████ 
██   ██ ██      ██      ██   ██ ██      ██   ██ ██      
███████ █████   ██      ██████  █████   ██████  ███████ 
██   ██ ██      ██      ██      ██      ██   ██      ██ 
██   ██ ███████ ███████ ██      ███████ ██   ██ ███████ 
]]                                                    
                                                      
	

-- Utilisée dans pour le timer affiché dans l'UI
-- Agit sur la table 'global' timer directement.
function Time()    
	if timer.ms >= 1 then
		timer.ms = 0
		timer.s = timer.s + 1
		if timer.s >= 60 then
			timer.s = 0
			timer.m = timer.m + 1
			if timer.m >= 60 then
				timer.m = 0
				timer.h = timer.h + 1
			end
		end 
	end
	timer.ms = timer.ms + (1 / 60)
	return timer
end

--[[
██    ██ ██████  ██████   █████  ████████ ███████     ███████ ███    ██ ████████ ██ ████████ ██    ██ 
██    ██ ██   ██ ██   ██ ██   ██    ██    ██          ██      ████   ██    ██    ██    ██     ██  ██  
██    ██ ██████  ██   ██ ███████    ██    █████       █████   ██ ██  ██    ██    ██    ██      ████   
██    ██ ██      ██   ██ ██   ██    ██    ██          ██      ██  ██ ██    ██    ██    ██       ██    
 ██████  ██      ██████  ██   ██    ██    ███████     ███████ ██   ████    ██    ██    ██       ██    
                                                                                                     
 ]]	
-- ********** (TRANSVERSE au JOUEUR et AUTRES ENTITES) ***************
-- *******************************************************************	



--[[
 █████  ███    ██ ██ ███    ███ ███████         ██     ██████  ██████   █████  ██     ██     ███████ ███    ██ ████████ ██ ████████ ██    ██ 
██   ██ ████   ██ ██ ████  ████ ██             ██      ██   ██ ██   ██ ██   ██ ██     ██     ██      ████   ██    ██    ██    ██     ██  ██  
███████ ██ ██  ██ ██ ██ ████ ██ ███████       ██       ██   ██ ██████  ███████ ██  █  ██     █████   ██ ██  ██    ██    ██    ██      ████   
██   ██ ██  ██ ██ ██ ██  ██  ██      ██      ██        ██   ██ ██   ██ ██   ██ ██ ███ ██     ██      ██  ██ ██    ██    ██    ██       ██    
██   ██ ██   ████ ██ ██      ██ ███████     ██         ██████  ██   ██ ██   ██  ███ ███      ███████ ██   ████    ██    ██    ██       ██    
]]
-- *************** (TRANSVERSE au JOUEUR et AUTRES ENTITES) *******************
-- *******************************************************************************


-- Met à jour la frame d'animation d'une entité, en fonction de la plage de sprites par défaut renseignée dans sa table
-- pEntity.countA: compteur d'animation de l'objet
-- pEntity.minSpr: id du PREMIER sprite de la chaine d'animation
-- pEntity.maxSpr: id du DERNIER sprite de la chaine d'animation
-- ARG: Entity table au format d'un MOB (player, ennemi...)
function animate(pEntity)
	--Si compteur non initialisé (premiere frame d'exec), alors init à minSpr.
	if pEntity.countA == nil then
		pEntity.countA = pEntity.minSpr
	end	

	pEntity.countA = (pEntity.countA + (1 / 60) ) * pEntity.speedAnim
	pEntity.sprite = math.floor(pEntity.countA)

	if (pEntity.countA > (pEntity.maxSpr + 1)) then
		pEntity.countA = pEntity.minSpr
		pEntity.sprite = pEntity.minSpr
	end

	return pEntity
end


-- Affiche une entité à l'écran
-- ARG: Entity table au format d'un MOB (player, ennemi...)
function Draw_entity(pEntity)
	spr(pEntity.sprite, pEntity.x, pEntity.y, 0, 1, pEntity.revertSpr, 0)
end


-- Affiche une l'UI de la partie à l'écran (Timer, contours fenetre jeu etc.). 
-- ATTENTION: Ne concerne pas un menu quelconque, ni game over, ni succès etc. 
-- Pas d'arguments utilisés. Se base sur des Variables globales.
function DrawUi()
	print("Timer: "..timer.m.." : "..timer.s.." : "..(math.floor(timer.ms * 10)) * 10, timer.x, timer.y, timer.c)
	print(" | PlayerState: "..player.state, timer.x+85, timer.y, timer.c)
	rectb(0, 0, 240, 136, 1)
	line(0, 8, 240, 8, 1)	
end

--[[
 ██████  ██████  ██      ██      ██ ███████ ██  ██████  ███    ██ ███████     ██   ██ ███████ ██      ██████  ███████ ██████  ███████ 
██      ██    ██ ██      ██      ██ ██      ██ ██    ██ ████   ██ ██          ██   ██ ██      ██      ██   ██ ██      ██   ██ ██      
██      ██    ██ ██      ██      ██ ███████ ██ ██    ██ ██ ██  ██ ███████     ███████ █████   ██      ██████  █████   ██████  ███████ 
██      ██    ██ ██      ██      ██      ██ ██ ██    ██ ██  ██ ██      ██     ██   ██ ██      ██      ██      ██      ██   ██      ██ 
 ██████  ██████  ███████ ███████ ██ ███████ ██  ██████  ██   ████ ███████     ██   ██ ███████ ███████ ██      ███████ ██   ██ ███████ 
]]
-- *************** (TRANSVERSE au JOUEUR et AUTRES ENTITES) *******************
-- *******************************************************************************


-- Met à jour les hotspots interieurs de l'entité en paramètre en fonction de ses coordonées propres
-- ARG: Entity table au format d'un MOB (player, ennemi...)
function Uppdate_inner_hotspots_location(pEntity) 
	pEntity.x1_inner = pEntity.x		-- hotspot haut gauche
	pEntity.y1_inner = pEntity.y

	pEntity.x2_inner = pEntity.x + 7  -- hotspot haut droit
	pEntity.y2_inner = pEntity.y

	pEntity.x3_inner = pEntity.x		-- hotspot bas gauche
	pEntity.y3_inner = pEntity.y + 7

	pEntity.x4_inner = pEntity.x + 7  -- hotspot bas droite
	pEntity.y4_inner = pEntity.y + 7
	
	return pEntity
end

-- Met à jour les hotspots exterieurs de l'entité en paramètre en fonction de ses coordonées propres
-- ARG: Entity table au format d'un MOB (player, ennemi...)
-- ARG: "debug_on" | nil
function Update_outer_hotspots_location(pEntity, pDebug) 
	pEntity.x1_outer = pEntity.x	  -- hotspot haut gauche
	pEntity.y1_outer = pEntity.y - 1
	if pDebug == "debug_on" then pix(pEntity.x1_outer, pEntity.y1_outer, 2) end

	pEntity.x2_outer = pEntity.x + 7  -- hotspot haut droit
	pEntity.y2_outer = pEntity.y - 1
	if pDebug == "debug_on" then pix(pEntity.x2_outer, pEntity.y2_outer, 2) end

	pEntity.x3_outer = pEntity.x	  -- hotspot bas gauche
	pEntity.y3_outer = pEntity.y + 8
	if pDebug == "debug_on" then pix(pEntity.x3_outer, pEntity.y3_outer, 2) end

	pEntity.x4_outer = pEntity.x + 7  -- hotspot bas droite
	pEntity.y4_outer = pEntity.y + 8
	if pDebug == "debug_on" then pix(pEntity.x4_outer, pEntity.y4_outer, 2) end

	pEntity.x5_outer = pEntity.x - 1  -- hotspot gauche haut
	pEntity.y5_outer = pEntity.y
	if pDebug == "debug_on" then pix(pEntity.x5_outer, pEntity.y5_outer, 2) end

	pEntity.x6_outer = pEntity.x - 1  -- hotspot gauche bas
	pEntity.y6_outer = pEntity.y + 7
	if pDebug == "debug_on" then pix(pEntity.x6_outer, pEntity.y6_outer, 2) end

	pEntity.x7_outer = pEntity.x + 8  -- hotdpot droit haut
	pEntity.y7_outer = pEntity.y
	if pDebug == "debug_on" then pix(pEntity.x7_outer, pEntity.y7_outer, 2) end

	pEntity.x8_outer = pEntity.x + 8  -- hotspot droit bas
	pEntity.y8_outer = pEntity.y + 7
	if pDebug == "debug_on" then pix(pEntity.x8_outer, pEntity.y8_outer, 2) end

	return pEntity
end

-- Test la collision d'un hotspot de notre entité cible, et d'une collection.id unique d'un Collidable.
-- ARG: pEntity: Entity table au format d'un MOB (player, ennemi...)
-- ARG: pCollidableSubCollection: Collidable.identifier voulu pour le test de la collision. index de la sub-table. peut contenir une ou plusieurs tiles renseignées
-- ARG: collideModeDetection: hotspots interieurs du sprite (bordure), hotspots exterieurs (en bordure egalement). (inner | outer)
-- ARG: orientationSegment: segment du sprite testé (up | down | left | right)
function Is_colliding(pEntity, pCollidableSubCollection, collideModeDetection, orientationSegment)
	--params called for example: 
	--player, collidables.wallDown, "outer", "down"

	local collidable_col = pCollidableSubCollection

	if collideModeDetection == "outer" then
		
		if orientationSegment == "up" then -- SEGMENT HAUT
			--Coords haut de l'entité (player, ennemi), bordure exterieur du sprite
			local x1 = pEntity.x1_outer--hotspot haut gauche
			local y1 = pEntity.y1_outer
			local x2 = pEntity.x2_outer--hotspot haut droite
			local y2 = pEntity.y2_outer

			--On converti les coordonées de la tuie du dessous du referentiel x/y (pixel) au referentiel x/y (Map Cell), 
			--et l'on retourne l'id en map de la cellule pointée par chaque hotspot
			local hotspot_1 = mget( (x1 / 8), (y1 / 8) )--sol bas gauche
			local hotspot_2 = mget( (x2 / 8), (y2 / 8) )--sol bas droite

			-- On verifie si la tile est le collisionable recherché...
			for i=1,#collidable_col,1 do
				if hotspot_1 == collidable_col[i] or hotspot_2 == collidable_col[i] then
					eventCollision = true
				end		
			end

			return eventCollision

		elseif orientationSegment == "down" then -- SEGMENT BAS
			--Coords bas de l'entité (player, ennemi), bordure exterieur du sprite
			local x1 = pEntity.x3_outer--hotspot bas gauche
			local y1 = pEntity.y3_outer
			local x2 = pEntity.x4_outer--hotspot bas droite
			local y2 = pEntity.y4_outer

			--On converti les coordonées de la tuie du dessous du referentiel x/y (pixel) au referentiel x/y (Map Cell), 
			--et l'on retourne l'id en map de la cellule pointée par chaque hotspot
			local hotspot_1 = mget( (x1 / 8), (y1 / 8) )--sol bas gauche
			local hotspot_2 = mget( (x2 / 8), (y2 / 8) )--sol bas droite

			-- On verifie si la tile est le collisionable recherché...
			for i=1,#collidable_col,1 do
				if hotspot_1 == collidable_col[i] or hotspot_2 == collidable_col[i] then
					eventCollision = true
				end		
			end

			return eventCollision

		elseif orientationSegment == "left" then -- SEGMENT GAUCHE
			--Coords flan gauche de l'entité (player, ennemi), bordure exterieur du sprite
			local x1 = pEntity.x5_outer--hotspot gauche haut
			local y1 = pEntity.y5_outer
			local x2 = pEntity.x6_outer--hotspot gauche bas
			local y2 = pEntity.y6_outer

			--On converti les coordonées de la tuie du dessous du referentiel x/y (pixel) au referentiel x/y (Map Cell), 
			--et l'on retourne l'id en map de la cellule pointée par chaque hotspot
			local hotspot_1 = mget( (x1 / 8), (y1 / 8) )--sol bas gauche
			local hotspot_2 = mget( (x2 / 8), (y2 / 8) )--sol bas droite

			-- On verifie si la tile est le collisionable recherché...
			for i=1,#collidable_col,1 do
				if hotspot_1 == collidable_col[i] or hotspot_2 == collidable_col[i] then
					eventCollision = true
				end		
			end

			return eventCollision
		elseif orientationSegment == "right" then -- SEGMENT DROIT
			--Coords flan droit de l'entité (player, ennemi), bordure exterieur du sprite
			local x1 = pEntity.x7_outer--hotspot droit haut
			local y1 = pEntity.y7_outer
			local x2 = pEntity.x8_outer--hotspot droit bas
			local y2 = pEntity.y8_outer

			--On converti les coordonées de la tuie du dessous du referentiel x/y (pixel) au referentiel x/y (Map Cell), 
			--et l'on retourne l'id en map de la cellule pointée par chaque hotspot
			local hotspot_1 = mget( (x1 / 8), (y1 / 8) )--sol bas gauche
			local hotspot_2 = mget( (x2 / 8), (y2 / 8) )--sol bas droite

			-- On verifie si la tile est le collisionable recherché...
			for i=1,#collidable_col,1 do
				if hotspot_1 == collidable_col[i] or hotspot_2 == collidable_col[i] then
					eventCollision = true
				end		
			end

			return eventCollision
		end

	elseif collideModeDetection == "inner" then	
		if orientationSegment == "up" then -- SEGMENT HAUT
			--Coords haut de l'entité (player, ennemi), bordure interieure du sprite
			local x1 = pEntity.x1_inner--hotspot haut gauche
			local y1 = pEntity.y1_inner
			local x2 = pEntity.x2_inner--hotspot haut droite
			local y2 = pEntity.y2_inner

			--On converti les coordonées de la tuie du dessous du referentiel x/y (pixel) au referentiel x/y (Map Cell), 
			--et l'on retourne l'id en map de la cellule pointée par chaque hotspot
			local hotspot_1 = mget( (x1 / 8), (y1 / 8) )--sol bas gauche
			local hotspot_2 = mget( (x2 / 8), (y2 / 8) )--sol bas droite

			-- On verifie si la tile est le collisionable recherché...
			for i=1,#collidable_col,1 do
				if hotspot_1 == collidable_col[i] and hotspot_2 == collidable_col[i] then
					eventCollision = true
				end		
			end

			return eventCollision
		elseif orientationSegment == "down" then -- SEGMENT BAS
			--Coords bas de l'entité (player, ennemi), bordure interieure du sprite
			local x1 = pEntity.x3_inner--hotspot bas gauche 
			local y1 = pEntity.y3_inner
			local x2 = pEntity.x4_inner--hotspot bas droite
			local y2 = pEntity.y4_inner

			--On converti les coordonées de la tuie du dessous du referentiel x/y (pixel) au referentiel x/y (Map Cell), 
			--et l'on retourne l'id en map de la cellule pointée par chaque hotspot
			local hotspot_1 = mget( (x1 / 8), (y1 / 8) )--sol bas gauche
			local hotspot_2 = mget( (x2 / 8), (y2 / 8) )--sol bas droite

			-- On verifie si la tile est le collisionable recherché...
			for i=1,#collidable_col,1 do
				if hotspot_1 == collidable_col[i] and hotspot_2 == collidable_col[i] then
					eventCollision = true
				end		
			end

			return eventCollision
		elseif orientationSegment == "left" then -- SEGMENT GAUCHE
			--Coords flan gauche de l'entité (player, ennemi), bordure interieure du sprite
			local x1 = pEntity.x1_inner--hotspot haut gauche 
			local y1 = pEntity.y1_inner
			local x2 = pEntity.x3_inner--hotspot bas gauche
			local y2 = pEntity.y3_inner

			--On converti les coordonées de la tuie du dessous du referentiel x/y (pixel) au referentiel x/y (Map Cell), 
			--et l'on retourne l'id en map de la cellule pointée par chaque hotspot
			local hotspot_1 = mget( (x1 / 8), (y1 / 8) )--sol bas gauche
			local hotspot_2 = mget( (x2 / 8), (y2 / 8) )--sol bas droite

			-- On verifie si la tile est le collisionable recherché...
			for i=1,#collidable_col,1 do
				if hotspot_1 == collidable_col[i] and hotspot_2 == collidable_col[i] then
					eventCollision = true
				end		
			end

			return eventCollision
		elseif orientationSegment == "right" then -- SEGMENT DROIT
			--Coords flan droit de l'entité (player, ennemi), bordure interieure du sprite
			local x1 = pEntity.x2_inner--hotspot haut droit 
			local y1 = pEntity.y2_inner
			local x2 = pEntity.x4_inner--hotspot bas droit
			local y2 = pEntity.y4_inner

			--On converti les coordonées de la tuie du dessous du referentiel x/y (pixel) au referentiel x/y (Map Cell), 
			--et l'on retourne l'id en map de la cellule pointée par chaque hotspot
			local hotspot_1 = mget( (x1 / 8), (y1 / 8) )--sol bas gauche
			local hotspot_2 = mget( (x2 / 8), (y2 / 8) )--sol bas droite

			-- On verifie si la tile est le collisionable recherché...
			for i=1,#collidable_col,1 do
				if hotspot_1 == collidable_col[i] and hotspot_2 == collidable_col[i] then
					eventCollision = true
				end		
			end

			return eventCollision
		end
	end	

	

end



--[[
██████  ██       █████  ██    ██ ███████ ██████      ███████ ███████ ███    ███ 
██   ██ ██      ██   ██  ██  ██  ██      ██   ██     ██      ██      ████  ████ 
██████  ██      ███████   ████   █████   ██████      █████   ███████ ██ ████ ██ 
██      ██      ██   ██    ██    ██      ██   ██     ██           ██ ██  ██  ██ 
██      ███████ ██   ██    ██    ███████ ██   ██     ██      ███████ ██      ██                                                                              
]]
-- *************** Regles de mouvance du joueur. L'or, les ennemis, les scenes sont gérées dans une autre Finite State Machine. *******************
-- ************************************************************************************************************************************************

-- Fonction de gestion des différents états du joueur
-- Applique 
function Player_fsm()

	--
	Update_outer_hotspots_location(player, nil)

	--si press (LEFT ou RIGHT) ET que player collisione exterieur avec un wallDown (sol)
	if ( btn(2) or btn(3) ) and (Is_colliding(player, collidables.wallDown, "outer", "down")) then
	--if ( btn(2) or btn(3) ) and (true) then
		player.state="WALKING"	
	elseif ( btn(2) == false and btn(3) == false and (Is_colliding(player, collidables.wallDown, "outer", "down")) ) then
	--elseif ( btn(2) == false and btn(3) == false and (true) ) then
		player.state="STANDING"
	else
		player.state="ERR COND"
	end

end

--[[
████████ ██  ██████ 
   ██    ██ ██      
   ██    ██ ██      
   ██    ██ ██      
   ██    ██  ██████
]]
--calback de l'environement TIC-80. 60 Exec/ sec, fixe.
function TIC()

	--Gaming loop
	--display
	cls(0)
	map(0, 0, 240, 136, 0, 0)

	Draw_entity(player)
	--draw_entity(vilain)

	Player_fsm()

	DrawUi()
	Time()	
	
	

end
-- <TILES>
-- 001:000aa000000cc00000cc00000c0cc000000c0cc0000c00000cc0c0000000c000
-- 002:000aa000000cc000000c000000ccc00000ccccc0000c0000000cc00000c0c000
-- 003:000aa000000cc000000c000000cccc000c0c0000000c000000c0c00000c00c00
-- 004:000aa000000cc000000c000000ccc00000ccccc0000c0000000cc00000c0c000
-- 005:0002220000033000003300000303300000030330000c00000cc0c0000000c000
-- 006:0002220000033000000300000033300000333330000c0000000cc00000c0c000
-- 007:0002220000033000000300000033330003030000000c000000c0c00000c00c00
-- 008:0002220000033000000300000033300000333330000c0000000cc00000c0c000
-- 016:7777770766666b07bbbbbb070000000070777777b0766666b07bbbbb00000000
-- 017:c000000ccffffffcccccccccc000000cc000000ccffffffcccccccccc000000c
-- 018:000000000000000000000000000000000000000000000000ffffffffcccccccc
-- 019:0000000000000000000000c000000c0c004344c004c333300c3c434004c33330
-- 020:0000c000000c0c000000c00000000000004c440004c3c330043c434004433330
-- 021:2000000000000000000000000000000000000000000000000000000000000000
-- </TILES>

-- <MAP>
-- 001:010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:010000000000000000000000000000000001000000000000000001000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:010000000000000000000000000000000001212121212121212101000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:010000000000000000000000000000000000000000000000000000310001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:010101010101010101011101010101010101010000000000000101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:010000000000000000001100000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:010000000000000000001100000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:010000000000000000001100000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:010000000000310000001100000000000000000101010101000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:010101010101010101010101000000000000000101010101000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:010000000000000000000000000000000000000101010101000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:010000000000000000000000000000000000000101010101000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:010000000000000000000000000000000000000101010101000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:010000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:010000000000000000000000000000000000000000000000000031000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

