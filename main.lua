function love.load()
  
  background = love.graphics.newVideo('/assets/pictures/background.ogv')
  
  starship = love.graphics.newImage('/assets/pictures/ship/starship.png')
  enemyPhysics = love.graphics.newImage('/assets/pictures/ship/enemyattack.png')

  starshipX = 0
  starshipY = 300
  starshipSpeed = 300


  enemyPhysicsX = 0
  enemyPhysicsY = 0
  enemyPhysicsSpeed = 300
  enemyPhysicsDelay = 100
  enemyPhysicsNumber = 0

end


function love.update(dt)
  backgroundVideo()

  if love.keyboard.isDown("up") then
    starshipY = starshipY - starshipSpeed * dt
  end

  if love.keyboard.isDown("down") then
    starshipY = starshipY + starshipSpeed * dt
  end


  if enemyPhysicsNumber > 0 and enemyPhysicsNumber < 24 then
    enemyPhysicsX = love.math.random(10, 200)
    spawnEnemyPhysics(enemyPhysicsX)
    enemyPhysicsNumber = enemyPhysicsNumber + 1
  end

end


function love.draw()
  for i = 0, love.graphics.getWidth() / background:getWidth() do
    for j = 0, love.graphics.getHeight() / background:getHeight() do
      love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
    end
  end
  love.graphics.draw(starship, starshipX, starshipY, 0, 0.2, 0.2)
end

function backgroundVideo()
  if background:isPlaying() then return end
  background:rewind()
  background:play()
end


function spawnEnemyPhysics()
  love.graphics.draw(enemyPhysics, enemyPhysicsX, enemyPhysicsY, 0, 0.6, 0.6)
end