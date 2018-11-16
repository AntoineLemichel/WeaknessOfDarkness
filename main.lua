enemies = {}
enemies.shot = {}
orbs = {}
 
 starship = {}
 starship.x = 0
 starship.y = 300
 starship.speed = 300
 starship.magics = {}
 starship.attacks = {}
 starship.physics = 400
 starship.magic = 125
 starship.armor = 350
 starship.agility = 500
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
  enemyImage = love.graphics.newImage('/assets/pictures/ship/enemyattack.png')
  enemyImage2 = love.graphics.newImage('/assets/pictures/ship/enemymagic.png')
  cooldown = 0
  cooldown2 = 0
  cooldown3 = 0
  
end


function love.update(dt)
  backgroundVideo()
  bulletCollision()

  for i,v in ipairs(enemies) do 
    v.x = v.x - 100 * dt

    if v.x <= - 2 then
      table.remove(enemies, i)
    end
  end
  

  
  for i,v in ipairs(starship.magics) do
    v.x = v.x + 700 * dt
    
    if v.x >= 775 then
      table.remove(starship.magics, i)
    end
  end
  
  for i,v in ipairs(starship.attacks) do
    v.x = v.x + 1000 * dt
    
    if v.x >=775 then
      table.remove(starship.attacks, i)
    end
  end
  
  
  if love.keyboard.isDown("up") then
    starship.y = starship.y - starship.speed * dt
  end

  if love.keyboard.isDown("down") then
    starship.y = starship.y + starship.speed * dt
  end
  
  cooldown = math.max(cooldown - dt,0)
  if love.keyboard.isDown("space") and cooldown == 0 then
    cooldown = 0.3
    magic = {}
    magic.x = starship.x + 54
    magic.y = starship.y + 28
    magic.magicshoot = love.graphics.newVideo('/assets/pictures/ship/shotmagic.ogv')
    table.insert(starship.magics, magic)
  end
  
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
  
  cooldown3 = math.max(cooldown3 - dt,0)
  if cooldown3 == 0 then
    enemySpawn()
  end
  
  for i,v in ipairs(enemies) do
    v.x = v.x - 100 * dt
  end
 
  if starship.y <= -31 then
    starship.y = 420
  end
  
  if starship.y >= 440 then
    starship.y = -30
  end
  
end


function love.draw()
  
  for i = 0, love.graphics.getWidth() / background:getWidth() do
    for j = 0, love.graphics.getHeight() / background:getHeight() do
      love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
    end
  end
  
  love.graphics.draw(starship.image, starship.x, starship.y, 0, 0.2, 0.2)
  
  for i,v  in ipairs(enemies) do 
    love.graphics.draw(v.image, v.x, v.y, 0, 0.6, 0.6)
  end
  
  for i,v  in ipairs(enemies.shot) do 
    love.graphics.draw(v.enemyShot.image, v.x, v.y, 0, 0.6, 0.6)
  end
  
  for i,v in ipairs(orbs) do
    love.graphics.draw(v.image, v.x, v.y, 0, 0.2, 0.2)
  end
  
  
  for i,v in ipairs(starship.attacks) do
    love.graphics.draw(v.attackshoot, v.x, v.y, 0, 0.3, 0.3)
    attackshot:play()
  end

  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle('fill', 0, 480, love.graphics.getWidth(), 200)

  love.graphics.setColor(246, 255, 255, 0.5)
  love.graphics.rectangle('fill', starship.x + 10, starship.y - 20, starship.life, 10)
  love.graphics.setColor(246, 255, 0, 0.5)
  love.graphics.rectangle('fill', 10, 550, starship.armor, 20)
  love.graphics.setColor(255, 0, 0, 0.5)
  love.graphics.rectangle('fill', 10, 530, starship.physics, 20)
  love.graphics.setColor(0,255,0,0.5)
  love.graphics.rectangle('fill', 10, 510, starship.agility, 20)
  love.graphics.setColor(0,0,255,0.5)
  love.graphics.rectangle('fill', 10, 490, starship.magic, 20)
  love.graphics.setColor(255, 255, 255)
	love.graphics.print("score: "..tostring(score), 10, 10)
  
  for i,v in ipairs(starship.magics) do
    love.graphics.draw(v.magicshoot, v.x, v.y, 0, 0.03, 0.03)
    v.magicshoot:play()
  end
  for i,v in ipairs(starship.magics) do
    if magicshoot:isPlaying() then return end
    lasershot:play()

end
  music:setVolume(0.5)
  music:play()
   
end

function backgroundVideo()
  -- This function, play background video at loop
  if background:isPlaying() then return end
  background:rewind()
  background:play()
end

function enemySpawn ()
  cooldown3 = 1
  enemy = {}
  enemy.x = 900

  enemy.y = math.random(550, 0)
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

  enemy.image = love.graphics.newImage('/assets/pictures/ship/enemyattack.png')
  table.insert(enemies, enemy)
end

function bulletCollision()
	for i,v in ipairs(enemies) do
    
          
		for ia, va in ipairs(starship.magics) do
			if va.x + 4 > v.x and
        va.x < v.x + 30 and
        va.y + 4 > v.y and
        va.y < v.y + 30 then
          
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
        va.y < v.y + 30 then
          
          spawnOrbs(enemies[i].x, enemies[i].y)
          
          score = score + 50
          table.remove(enemies, i)
          table.remove(starship.attacks, ia)
			end
		end
	end
end

function spawnOrbs(x,y)
      
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
        