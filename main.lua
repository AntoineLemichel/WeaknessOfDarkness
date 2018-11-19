enemies = {}
enemies.shot = {}
orbs = {}
 
 starship = {}
 starship.x = 0
 starship.y = 300
 starship.speed = 300
 starship.magics = {}
 starship.attacks = {}
 starship.physics = 50
 starship.magic = 50
 starship.armor = 50
 starship.agility = 50
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

  fullscreenWidth = love.graphics.getWidth()
  fullscreenHeight = love.graphics.getHeight()
  
end


function love.update(dt)
  backgroundVideo()
  bulletCollision()
  ballCollision()


  -- Setup bullet magics speed and check collision with world bounds

  for i,v in ipairs(starship.magics) do
    v.x = v.x + 700 * dt
    
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

    if v.x <= - 2 then
      table.remove(enemies, i)
    end
  end
score = score + 1
  -- 
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
    cooldown = 0.3
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

--  If player touch height screen world
  
  if starship.y <= -31 then
    starship.y = fullscreenHeight - 200
  end
  if starship.y >= fullscreenHeight - 160 then
    starship.y = -30
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
  end
-- 

-- Draw all of enemies's shoot in array
  for i,v  in ipairs(enemies.shot) do 
    love.graphics.draw(v.enemyShot.image, v.x, v.y, 0, 0.6, 0.6)
  end
-- 

-- Draw all Orbs (strenght, agility, magics and armor) in array
  for i,v in ipairs(orbs) do
    love.graphics.draw(v.image, v.x, v.y, 0, 0.2, 0.2)
  end
--

-- Draw all HUD (player's life, armor, physics, agility and magic)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle('fill', 0, (fullscreenHeight - 130), love.graphics.getWidth(), 130)
  love.graphics.setColor(246, 255, 255, 0.5)
  love.graphics.rectangle('fill', starship.x + 10, starship.y - 20, starship.life, 10)
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


  love.graphics.setColor(255, 255, 255)
	love.graphics.print("score: "..tostring(score), 30, fullscreenHeight - 120) -- Setup scrore
-- 


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
  enemy.y = math.random(fullscreenHeight - 170, 0)
  enemy.type = love.math.random(0, 1)
  enemy.enemyShot = {}
  enemy.enemyShot.x = enemy.x
  enemy.enemyShot.y = enemy.y
  if enemy.type == 0 then
    enemy.image = love.graphics.newImage('/assets/pictures/ship/enemyattack.png')
    enemy.enemyShot.image = love.graphics.newImage('/assets/pictures/ship/enemyshotattack.png')
  elseif enemy.type == 1 then
    enemy.image = love.graphics.newImage('/assets/pictures/ship/enemymagic.png')
    enemy.enemyShot.image = love.graphics.newImage('/assets/pictures/ship/enemyshotmagic.png')
  end
  --table.insert(enemies.shot, enemyShot)
  table.insert(enemies, enemy)
end

function bulletCollision()
-- This function, manage collision with another object (enemies, orbs) 
	for i,v in ipairs(enemies) do     
		for ia, va in ipairs(starship.magics) do
			if va.x + 4 > v.x and
        va.x < v.x + 30 and
        va.y + 4 > v.y and
        va.y < v.y + 37 then
          
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
        va.y < v.y + 35 then
          
          spawnOrbs(enemies[i].x, enemies[i].y)
          score = score + 50
          table.remove(enemies, i)
          table.remove(starship.attacks, ia)
			end
		end
	end
end

function spawnOrbs(x,y)
-- This function, manage spawn Orbs with random type (Physics, magics, armor or agility) 
    randomOrbs = {}
    randomOrbs.type = love.math.random(0, 30)
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
        starship.physics = starship.physics - 5
        if starship.magic < 250 then
          starship.magic = starship.magic + 10
          if starship.magic > 250 then
            starship.magic = 250
          end
        end
      elseif va.type == 1 and starship.armor > 0 then
        starship.armor = starship.armor - 5
        if starship.agility < 250 then
          starship.agility = starship.agility + 10
          if starship.agility > 250 then
            starship.agility = 250
          end
        end
      elseif va.type == 2 and starship.agility > 0 then
        starship.agility = starship.agility - 5
        if starship.armor < 250 then
          starship.armor = starship.armor + 10
          if starship.armor > 250 then
            starship.armor = 250
          end
        end
      elseif va.type == 3 and starship.physics <= 240 and starship.magic > 0 then
        starship.magic = starship.magic - 5
        if starship.physics < 250 then
          starship.physics = starship.physics + 10
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