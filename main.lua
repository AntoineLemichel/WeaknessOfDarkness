enemies = {}
 
 starship = {}
 starship.x = 0
 starship.y = 300
 starship.speed = 300
 starship.magics = {}
 starship.attacks = {}
 
 score = 0

function love.load()
  
  music = love.audio.newSource('/assets/pictures/sound/backgroundmusic.ogg','static')


  background = love.graphics.newVideo('/assets/pictures/background.ogv')
 
  starship.image = love.graphics.newImage('/assets/pictures/ship/starship.png')

  magicshoot = love.graphics.newVideo('/assets/pictures/ship/shotmagic.ogv')
  attackshoot = love.graphics.newImage('/assets/pictures/ship/shotatt3.png')
  enemyImage = love.graphics.newImage('/assets/pictures/ship/enemyattack.png')
  cooldown = 0
  cooldown2 = 0
  cooldown3 = 0
  
end


function love.update(dt)
  backgroundVideo()
  bulletCollision()

  for i,v in ipairs(starship.magics) do
    v.x = v.x + 700 * dt
    
    if v.x >= 775 then
      table.remove(starship.magics, i)
    end
  end

  for i,v in ipairs(enemies) do 
    v.x = v.x - 100 * dt

    if v.x <= - 2 then
      table.remove(enemies, i)
    end
  end
  
  for i,v in ipairs(starship.attacks) do
    v.x = v.x + 1000 * dt
    
    if v.x >=775 then
      table.remove(starship.attacks, i)
    end
  end
  
  for i,v in ipairs(enemies) do
    if v.x <= -2 then
      table.remove(enemies, i)
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
    starship.y = 550
  end
  
  if starship.y >= 555 then
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
    love.graphics.draw(enemyImage, v.x, v.y, 0, 0.6, 0.6)
  end
  
  for i,v in ipairs(starship.attacks) do
    love.graphics.draw(v.attackshoot, v.x, v.y, 0, 0.3, 0.3)
  end
  
  love.graphics.setColor(255, 255, 255)
	love.graphics.print("score: "..tostring(score), 10, 10)
  
  for i,v in ipairs(starship.magics) do
    love.graphics.draw(v.magicshoot, v.x, v.y, 0, 0.03, 0.03)
    v.magicshoot:play()
  end
  for i,v in ipairs(starship.magics) do
    if magicshoot:isPlaying() then return end
    magicshoot:rewind()
    magicshoot:play()
  end
  
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
          
          score = score + 50
          table.remove(enemies, i)
          table.remove(starship.attacks, ia)
			end
		end
	end
end