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
	player.y=24
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

	player.x1=0
	player.y1=0
	player.x2=0
	player.y2=0
	player.x3=0
	player.y3=0
	player.x4=0
	player.y4=0
	player.x5=0
	player.y5=0
	player.x6=0
	player.y6=0
	player.x7=0
	player.y7=0
	player.x8=0
	player.y8=0
 
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

	vilain.x1=0
	vilain.y1=0
	vilain.x2=0
	vilain.y2=0
	vilain.x3=0
	vilain.y3=0
	vilain.x4=0
	vilain.y4=0
	vilain.x5=0
	vilain.y5=0
	vilain.x6=0
	vilain.y6=0
	vilain.x7=0
	vilain.y7=0
	vilain.x8=0
	vilain.y8=0

collidables = {16,5,6,7,8,19,20}
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
function time()    
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


-- Met à jour les hotspots de la hitbox d'une entité
-- ARG: Entity table au format d'un MOB (player, ennemi...)
function update_hotspots_location(pEntity) 
	pEntity.x1 = pEntity.x
	pEntity.y1 = pEntity.y - 1
	pEntity.x2 = pEntity.x + 8
	pEntity.y2 = pEntity.y - 1
	pEntity.x3 = pEntity.x
	pEntity.y3 = pEntity.y + 8
	pEntity.x4 = pEntity.x + 8
	pEntity.y4 = pEntity.y + 8
	pEntity.x5 = pEntity.x - 1
	pEntity.y5 = pEntity
	pEntity.x6 = pEntity.x - 1
	pEntity.y6 = pEntity.y + 8
	pEntity.x7 = pEntity.x + 8
	pEntity.y7 = pEntity.y
	pEntity.x8 = pEntity.x + 8
	pEntity.y8 = pEntity.y + 8
	
	return pEntity
end

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
function draw_entity(pEntity)
	spr(pEntity.sprite, pEntity.x, pEntity.y, 0, 1, pEntity.revertSpr, 0)
end


-- Affiche une l'UI de la partie à l'écran (Timer, contours fenetre jeu etc.). 
-- ATTENTION: Ne concerne pas un menu quelconque, ni game over, ni succès etc. 
-- Pas d'arguments utilisés. Se base sur des Variables globales.
function drawUi()
	print("Timer: "..timer.m.." : "..timer.s.." : "..(math.floor(timer.ms * 10)) * 10, timer.x, timer.y, timer.c)
	rectb(0, 0, 240, 136, 1)
	line(0, 8, 240, 8, 1)	
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

	draw_entity(player)
	draw_entity(vilain)

	drawUi()
	time(timer)	
	
	

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
