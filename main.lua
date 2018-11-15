function love.load()
  
  background = love.graphics.newVideo('/assets/pictures/background.ogv')
  
  enemies = {}
  enemies.image = love.graphics.newImage('/assets/pictures/ship/enemyattack.png')
  enemies.speed = 300
  enemies.delay = 0
  


  starship = {}
  starship.image = love.graphics.newImage('/assets/pictures/ship/starship.png')
  starship.x = 50
  starship.y = love.graphics.getHeight() / 2
  starship.speed = 300
  starship.bullets = {}
  shoot = love.graphics.newImage('/assets/pictures/ship/ph3.png')


end


function love.update(dt)
  backgroundVideo()

  for i,v in ipairs(starship.bullets) do
    v.x = v.x + 1000 * dt
    
    if v.x <= -2 then
      table.remove(starship.bullets, i)
    end
  end
  
  if love.keyboard.isDown("up") then
    starship.y = starship.y - starship.speed * dt
  end

  if love.keyboard.isDown("down") then
    starship.y = starship.y + starship.speed * dt
  end
  
  if love.keyboard.isDown("space") then
    bullet = {}
    bullet.x = starship.x + 76
    bullet.y = starship.y + 32.5
    table.insert(starship.bullets, bullet)
  end

  enemies.delay = enemies.delay + dt
  if enemies.delay >= 3 then
    enemies.x = love.math.random(0, love.graphics.getWidth() - 64)
    enemies.y = love.math.random(love.graphics.getHeight() / 2, love.graphics.getHeight() - 64)
    table.insert(enemies, enemies.image)
    enemies.delay = 0
  end
  

end


function love.draw()
  
  
  
  for i = 0, love.graphics.getWidth() / background:getWidth() do
    for j = 0, love.graphics.getHeight() / background:getHeight() do
      love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
    end
  end

  love.graphics.draw(starship.image, starship.x, starship.y, 0, 0.2, 0.2)

  for i,v in ipairs(starship.bullets) do
    love.graphics.draw(shoot, bullet.x, bullet.y, 0, 0.4, 0.4)
  end
  for i,v  in ipairs(enemies) do 
    love.graphics.draw(enemies.image, v.x, v.y, 0, 0.6, 0.6)
  end
end

function backgroundVideo()
  -- This function, play background video at loop
  if background:isPlaying() then return end
  background:rewind()
  background:play()
end