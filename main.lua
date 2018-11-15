function love.load()
  love.window.setTitle("Weakness of Darkness")

  background = love.graphics.newVideo('/assets/pictures/background.ogv')

  starship = love.graphics.newImage('/assets/pictures/starship.png')
  starshipX = 0
  starshipY = 300
  starshipSpeed = 300

end


function love.update(dt)
  backgroundVideo()

  if love.keyboard.isDown("up") then
    starshipY = starshipY - starshipSpeed * dt
  end

  if love.keyboard.isDown("down") then
    starshipY = starshipY + starshipSpeed * dt
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
