enemies = {}
enemies.shoot = {}

orbs = {}

totalAgilityBall = 5
totalPhysicsBall = 5
totalMagicBall = 5
totalArmorBall = 5

 starship = {}
 starship.x = 0
 starship.y = 300
 
 starship.magics = {}
 starship.attacks = {}

 starship.life = 100
 score = 0

function love.load()
  
  music = love.audio.newSource('/assets/sounds/backgroundmusic.ogg','static')
  lasershot = love.audio.newSource('/assets/sounds/lasershot.wav','static')
  attackshot = love.audio.newSource('/assets/sounds/attackshot.wav','static')
  enemydestroy = love.audio.newSource('/assets/sounds/enemydestroy.wav','static')


  background = love.graphics.newVideo('/assets/pictures/background.ogv')
 
  starship.image = love.graphics.newImage('/assets/pictures/ship/starship.png')

  magicshoot = love.graphics.newVideo('/assets/pictures/ship/shotmagic.ogv')
  attackshoot = love.graphics.newImage('/assets/pictures/ship/shotatt3.png')

  cooldown = 0
  cooldown2 = 0
  cooldown3 = 0
  cooldownShootEnemy = 0

  fullscreenWidth = love.graphics.getWidth()
  fullscreenHeight = love.graphics.getHeight()
  paused = false
end


function love.update(dt)
  
  backgroundVideo()
  bulletCollision()
  ballCollision()
  checkShootCollision()

  score = score + 1
  starship.physics = totalPhysicsBall * 10
  starship.magic = totalMagicBall * 10
  starship.armor = totalArmorBall * 10
  starship.agility = totalAgilityBall * 10
  
  maxStarshipLife = 50 + 10 * totalArmorBall
  starship.speed = 175 + 25 * totalAgilityBall
  
  -- Setup bullet magics speed and check collision with world bounds

  for i,v in ipairs(starship.magics) do
    
    if totalMagicBall > 15 then
      v.x = v.x + 1000 * dt
    else
      v.x = v.x + 500 * dt
    end
    
    
    if v.x >= fullscreenWidth then
      table.remove(starship.magics, i)
    end
  end
  -- 

  -- Setup enemies speed with check collision with world bounds

  for i,v in ipairs(enemies) do 
    v.x = v.x - 100 * dt
    
    if score > 1000 and score < 2000 then
      v.x = v.x - 200 * dt
    end
    if score > 2000 and score < 3000 then
      v.x = v.x - 400 * dt
    end
    if score > 3000 then
      v.x = v.x - 800 * dt
    end

    
    cooldownShootEnemy = math.max(cooldownShootEnemy - dt,0)
    if v.x < fullscreenWidth and cooldownShootEnemy == 0 then
      cooldownShootEnemy = 1.2
      enemyShot = {}
      enemyShot.x = v.x
      enemyShot.y = v.y + 15
      
      if v.type == 0 then
        enemyShot.image = love.graphics.newImage('/assets/pictures/ship/enemyshotattack.png')
      elseif v.type == 1 then
        enemyShot.image = love.graphics.newImage('/assets/pictures/ship/enemyshotmagic.png')
      end
    
      table.insert(enemies.shoot, enemyShot)
    end
    
    if v.x <= - 2 then
      -- Condition for delete stat if player let enemy passed
      if totalAgilityBall >= totalArmorBall and totalAgilityBall >= totalMagicBall and totalAgilityBall >=         totalPhysicsBall then
        if totalAgilityBall > 0 then
          if starship.life > 0 then
            starship.life = starship.life - 5
          end
          totalAgilityBall = totalAgilityBall - 0.5
        end
      elseif totalArmorBall >= totalAgilityBall and totalArmorBall >= totalMagicBall and totalArmorBall >=          totalPhysicsBall then
        if totalArmorBall > 0 then
          if starship.life > 0 then
            starship.life = starship.life - 5
          end
          totalArmorBall = totalArmorBall - 0.5
        end
      elseif totalMagicBall >= totalArmorBall and totalMagicBall >= totalAgilityBall and totalMagicBall >=          totalPhysicsBall then
        if totalMagicBall > 0 then
          if starship.life > 0 then
            starship.life = starship.life - 5
          end
          totalMagicBall = totalMagicBall - 0.5
        end
      elseif totalPhysicsBall >= totalArmorBall and totalPhysicsBall >= totalMagicBall and totalPhysicsBall >=         totalAgilityBall then
        if totalPhysicsBall > 0 then
          if starship.life > 0 then 
           starship.life = starship.life - 5
          end
          totalPhysicsBall = totalPhysicsBall - 0.5
        end
      end
      --
      table.remove(enemies, i)
    end
  end
  
  -- Setup speed Orbs and check collision with world bounds

  for i,v in ipairs(orbs) do
    v.x = v.x - 200 * dt
    
    if v.x <= -2 then
      table.remove(orbs, i)
    end
  end
  -- 
  
  -- Setup bullet physics speed and check collision with world bounds
  for i,v in ipairs(starship.attacks) do
    v.x = v.x + 1000 * dt
    
    if v.x >= fullscreenWidth then
      table.remove(starship.attacks, i)
    end
  end
  -- 
  
  -- Setup speed axe y with if arrow up is down
  if love.keyboard.isDown("up") then
    starship.y = starship.y - starship.speed * dt
  end
-- 

-- Setup speed axe y with arrow down is down
  if love.keyboard.isDown("down") then
    starship.y = starship.y + starship.speed * dt
  end
--
  if love.keyboard.isDown("left") and score > 1000 then
    starship.x = starship.x - starship.speed * dt
  end

  if love.keyboard.isDown("right") and score > 1000 then
    starship.x = starship.x + starship.speed * dt
  end

-- Setup quit game if escape is pressed
  if love.keyboard.isDown('escape') then
    love.event.quit()
  end
-- 

-- Setup shoot magics if spacebar is down
  cooldown = math.max(cooldown - dt,0)
  if love.keyboard.isDown("space") and cooldown == 0 then
    
    if totalMagicBall > 15 then
      cooldown = 0.15
    else
      cooldown = 0.3
    end
    
    magic = {}
    magic.x = starship.x + 54
    magic.y = starship.y + 28
    magic.magicshoot = love.graphics.newVideo('/assets/pictures/ship/shotmagic.ogv')
    table.insert(starship.magics, magic)
  end
--

-- Setup shoot physics if A is down
  cooldown2 = math.max(cooldown2 - dt,0)
  if love.keyboard.isDown('a') and cooldown2 == 0 then
    cooldown2 = 0.15
    attack1 = {}
    attack1.x = starship.x + 50
    attack1.y = starship.y + 10
    attack1.attackshoot = love.graphics.newImage('/assets/pictures/ship/shotatt3.png')
    table.insert(starship.attacks, attack1)
    attack2 = {}
    attack2.x = starship.x + 50
    attack2.y = starship.y + 50
    attack2.attackshoot = love.graphics.newImage('/assets/pictures/ship/shotatt3.png')
    table.insert(starship.attacks, attack2)
  end
  
-- Setup cooldown spawn ennemies
  cooldown3 = math.max(cooldown3 - dt,0)
  if cooldown3 == 0 then
    enemySpawn()
  end
-- 

  for i,v in ipairs(enemies.shoot) do
    v.x = v.x - 250 * dt
    
    if v.x <= -2 then
      table.remove(enemies.shoot, i)
    end
  end

--  If player touch height screen world
  
  if starship.y <= -31 then
    starship.y = fullscreenHeight - 200
  end
  if starship.y >= fullscreenHeight - 160 then
    starship.y = -30
  end
  if starship.x <= 0 then
    starship.x = 0
  end
  if starship.x >= fullscreenWidth - 110 then
    starship.x = fullscreenWidth - 110
end
--
end


function love.draw()
  -- Draw background with fullscreen
  for i = 0, love.graphics.getWidth() / background:getWidth() do
    for j = 0, love.graphics.getHeight() / background:getHeight() do
      love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
    end
  end
-- 
  love.graphics.draw(starship.image, starship.x, starship.y, 0, 0.2, 0.2) -- Draw player's starship
  

  -- Draw all of enemies in array
  for i,v  in ipairs(enemies) do 
    love.graphics.draw(v.image, v.x, v.y, 0, 0.6, 0.6)
    -- Draw all of enemies's shoot in array
    for ia,va  in ipairs(enemies.shoot) do 
      love.graphics.draw(va.image, va.x, va.y, 0, 0.4, 0.4)
    end
    
-- 
  end
-- 


-- Draw all Orbs (strenght, agility, magics and armor) in array
  for i,v in ipairs(orbs) do
    love.graphics.draw(v.image, v.x, v.y, 0, 0.2, 0.2)
  end
--

-- Draw all HUD (player's life, armor, physics, agility and magic)
  love.graphics.setColor(255, 255, 255, 1)
  love.graphics.rectangle('fill', fullscreenWidth / 2, 10, maxStarshipLife, 15)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle('fill', 0, (fullscreenHeight - 130), love.graphics.getWidth(), 130)
  love.graphics.printf("Vie: "..tostring(starship.life),fullscreenWidth / 2, 10, maxStarshipLife ,"center")
  love.graphics.setColor(255, 45, 0, 0.5)
  love.graphics.rectangle('fill', fullscreenWidth / 2, 10, starship.life, 15)
  love.graphics.setColor(246, 255, 0, 0.5)
  love.graphics.rectangle('fill', 100, fullscreenHeight - 30, starship.armor, 10)
  love.graphics.setColor(255, 0, 0, 0.5)
  love.graphics.rectangle('fill', 100, fullscreenHeight - 50, starship.physics, 10)
  love.graphics.setColor(0,255,0,0.5)
  love.graphics.rectangle('fill', 100, fullscreenHeight - 70, starship.agility, 10)
  love.graphics.setColor(0,0,255,0.5)
  love.graphics.rectangle('fill', 100, fullscreenHeight - 90, starship.magic, 10)
  love.graphics.setColor(255, 255, 255, 1)
  love.graphics.printf("Armor :", 20, fullscreenHeight - 33, 100, "left")
  love.graphics.printf("Strength :", 20, fullscreenHeight - 53, 100, "left")
  love.graphics.printf("Agility :", 20, fullscreenHeight - 73, 100, "left")
  love.graphics.printf("Magic :", 20, fullscreenHeight - 93, 100, "left")


  love.graphics.setColor(255, 255, 255, 1)
	love.graphics.print("Score: "..tostring(score), 30, fullscreenHeight - 120) -- Setup scrore
  --love.graphics.setColor(0, 0, 0, 1)
  
  


-- Draw all starship's physics shoot
  
  for i,v in ipairs(starship.attacks) do
    love.graphics.draw(v.attackshoot, v.x, v.y, 0, 0.3, 0.3)
    attackshot:play()
  end

-- 
-- Draw all starship's magics shoot
  for i,v in ipairs(starship.magics) do
    love.graphics.draw(v.magicshoot, v.x, v.y, 0, 0.03, 0.03)
    v.magicshoot:play()
  end
-- 

-- Play sounds after starship shoot magics
  for i,v in ipairs(starship.magics) do
    if magicshoot:isPlaying() then return end
    lasershot:play()
  end

-- 
  music:setVolume(0.5) -- Setup volume for background music
  music:play() -- Launch background music
   
end

--end of draw

function backgroundVideo()
  -- This function, play background video at loop
  if background:isPlaying() then return end
  background:rewind()
  background:play()
end

function enemySpawn ()
-- This function, manage spawn ennemies and random type (physics or magics)
  cooldown3 = 1
  enemy = {}
  
  enemy.x = fullscreenWidth
  enemy.y = math.random(fullscreenHeight - 170, 50)
  enemy.type = love.math.random(0, 1)

  if enemy.type == 0 then
    enemy.image = love.graphics.newImage('/assets/pictures/ship/enemyattack.png')
  elseif enemy.type == 1 then
    enemy.image = love.graphics.newImage('/assets/pictures/ship/enemymagic.png')
  end
  table.insert(enemies, enemy)
end



function bulletCollision()
-- This function, manage collision with another object (enemies, orbs) 
	for i,v in ipairs(enemies) do     
		for ia, va in ipairs(starship.magics) do
			if va.x + 4 > v.x and
        va.x < v.x + 30 and
        va.y + 4 > v.y and
        va.y < v.y + 37 and
        v.type == 0 then
          
          spawnOrbs(enemies[i].x, enemies[i].y)
          score = score + 50
          table.remove(enemies, i)
          table.remove(starship.magics, ia)
      end
		end
    for ia, va in ipairs(starship.attacks) do
			if va.x + 4 > v.x and
        va.x < v.x + 30 and
        va.y + 4 > v.y and
        va.y < v.y + 35 and
        v.type == 1 then
          
          if totalPhysicsBall > 10 then
            starship.life = starship.life + 2
            if starship.life > maxStarshipLife then
              starship.life = maxStarshipLife
            end
          end
          
          spawnOrbs(enemies[i].x, enemies[i].y)
          score = score + 50
          table.remove(enemies, i)
          table.remove(starship.attacks, ia)
			end
		end
	end
end

function checkShootCollision()
		for ia, va in ipairs(enemies.shoot) do
			if va.x + 4 > starship.x and
        va.x < starship.x + 55 and
        va.y + 4 > starship.y and
        va.y < starship.y + 70 then
          
          --new unlock at 15 agility balls, dodge chance 1/10
          if totalAgilityBall >= 15 then
            dodgeAbility = math.random(0, 9)
          else
            dodgeAbility = 0
          end
          
          if dodgeAbility < 9 then 
            
            if starship.life > 0 then
              starship.life = starship.life - 10
            else
              GAME_ACTIVE = false
            end
          
            table.remove(enemies.shoot, ia)
            
          else
            table.remove(enemies.shoot, ia)
          end
          --

      end
	end
end

function spawnOrbs(x,y)
-- This function, manage spawn Orbs with random type (Physics, magics, armor or agility) 
    randomOrbs = {}
    randomOrbs.type = math.random(0, 30)
    randomOrbs.x = x
    randomOrbs.y = y
    
    if randomOrbs.type == 0 then
      randomOrbs.image = love.graphics.newImage('/assets/pictures/balls/blueBall.png')
      table.insert(orbs, randomOrbs)
    elseif randomOrbs.type == 1 then
      randomOrbs.image = love.graphics.newImage('/assets/pictures/balls/greenBall.png')
      table.insert(orbs, randomOrbs)
    elseif randomOrbs.type == 2 then
      randomOrbs.image = love.graphics.newImage('/assets/pictures/balls/yellowBall.png')
      table.insert(orbs, randomOrbs)
    elseif randomOrbs.type == 3 then
      randomOrbs.image = love.graphics.newImage('/assets/pictures/balls/redBall.png')
      table.insert(orbs, randomOrbs)
    end
          
end

function ballCollision()
  for ia, va in ipairs(orbs) do
    if va.x + 8 > starship.x and
      va.x < starship.x + 70 and
      va.y + 8 > starship.y and
      va.y < starship.y + 70 then
      -- Add statistics
      if va.type == 0 and starship.physics > 0 then
        
        totalPhysicsBall = totalPhysicsBall - 0.5
        if totalPhysicsBall < 0 then
          totalPhysicsBall = 0
        end
        
        if starship.magic < 250 then
          totalMagicBall = totalMagicBall + 1
          if starship.magic > 250 then
            starship.magic = 250
          end
        end
        
      elseif va.type == 1 and starship.armor > 0 then
        
        totalArmorBall = totalArmorBall - 0.5
        if totalArmorBall < 0 then
          totalArmorBall = 0
        end
        
        if starship.agility < 250 then
          totalAgilityBall = totalAgilityBall + 1
          if starship.agility > 250 then
            starship.agility = 250
          end
        end
        
      elseif va.type == 2 and totalAgilityBall > 0 then
        
        totalAgilityBall = totalAgilityBall - 0.5
        if totalAgilityBall < 0 then
          totalAgilityBall = 0
        end
        
        if starship.armor < 250 then
          totalArmorBall = totalArmorBall + 1
          if starship.armor > 250 then
            starship.armor = 250
          end
        end
        
      elseif va.type == 3 and starship.magic > 0 then
        
        totalMagicBall = totalMagicBall - 0.5
        if totalMagicBall < 0 then
          totalMagicBall = 0
        end
        if starship.physics < 250 then
          totalPhysicsBall = totalPhysicsBall + 1
          if starship.physics > 250 then
            starship.physics = 250
          end
        end
      end
      --
      table.remove(orbs, ia)
    end
	end
end