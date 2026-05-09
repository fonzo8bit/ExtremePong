function love.load()
    love.window.setVSync(1)
    -- computerLeft is left side paddle
    -- playerRight is right side paddle
    computerLeft = {x = 20, y = 250, w = 15, h = 80, speed = 200}
    playerRight = {x = 765, y = 250, w = 15, h = 80, speed = 600}
    ball = {x = 400, y = 300, speedX = 400, speedY = 300}
    comOffset = 0

end 

function love.update(dt)
    
    -- Applying movement to the ball  
    ball.x = ball.x + ball.speedX * dt   
    ball.y = ball.y + ball.speedY * dt
    
    -- Making it bounce off top and bottom walls                                     
    if ball.y < 0 or ball.y > 600 then   
        ball.speedY = -ball.speedY
    end

    -- Going to add collision detection now for computer AI
    if ball.x < computerLeft.x + 15 and 
       ball.y > computerLeft.y and ball.y < computerLeft.y + computerLeft.h then 
        ball.speedX = math.abs(ball.speedX)
        ball.x = computerLeft.x + 15
        comOffset = love.math.random(-40,40)
    end

    -- Adding collision detection for player as well
    if ball.x > playerRight.x - 15 and 
       ball.y > playerRight.y and ball.y < playerRight.y + playerRight.h then 
        ball.speedX = -math.abs(ball.speedX)
        ball.x = playerRight.x - 15
    end

    -- If scored on, sends ball towards player2
    if ball.x < 0 then                   
        ball.x = 400
        ball.y = 300
        ball.speedX = 300
    end
   
    -- if scored on, sends ball towards AI
    if ball.y > 800 then                 
        ball.x = 400
        ball.y = 300
        ball.speedX = -300

    end

    -- Movement of playerRight paddle
    if love.keyboard.isDown("w") then 
        playerRight.y = playerRight.y - playerRight.speed * dt
    end 

    if love.keyboard.isDown("s") then 
        playerRight.y = playerRight.y + playerRight.speed * dt
    end

    if love.keyboard.isDown("up") then 
        playerRight.y = playerRight.y - playerRight.speed * dt
    end

    if love.keyboard.isDown("down") then 
        playerRight.y = playerRight.y + playerRight.speed * dt
    end

    -- Difficulty of AI *May change later
    if ball.x < 400 then
     local comPaddleCenter = computerLeft.y + computerLeft.h / 2
     local targetY = ball.y + comOffset
     local zone = 10

      if math.abs(comPaddleCenter - targetY) > zone then
        if comPaddleCenter < targetY then
            computerLeft.y = computerLeft.y + computerLeft.speed * dt
        else 
            computerLeft.y = computerLeft.y - computerLeft.speed * dt
        end
      end 
    end

    --Movement of the computer AI on left side of screen
    if computerLeft.y + computerLeft.h / 2 < ball.y then 
        computerLeft.y = computerLeft.y + computerLeft.speed * dt
    elseif computerLeft.y + computerLeft.h / 2 > ball.y then
        computerLeft.y = computerLeft.y - computerLeft.speed * dt
    end

    -- Makes both players don't move off the screen
    local screenHeight = love.graphics.getHeight()
    playerRight.y = math.max(0, math.min(screenHeight - playerRight.h, playerRight.y))

end


function love.draw()
    local screenHeight = love.graphics.getHeight()
    local width = love.graphics.getWidth()
    local centerOfScreen = width / 2

    local segmentLength = 2
    local gapSize = 10

    -- Looping from top to bottom of screen to create dotted line
    for y = 0, screenHeight, (segmentLength + gapSize) do 
        love.graphics.setColor(255, 255, 255)
        love.graphics.line(centerOfScreen, y, centerOfScreen, y + segmentLength)
    end 

    local ballColor = {255, 255, 255}
    love.graphics.setColor(ballColor)
    love.graphics.circle("fill", ball.x, ball.y, 10)
    local computerColor = {255, 0, 0}
    love.graphics.setColor(computerColor)
    love.graphics.rectangle("fill", computerLeft.x, computerLeft.y, computerLeft.w, computerLeft.h)
    local playerColor = {0, 0, 255}
    love.graphics.setColor(playerColor)
    love.graphics.rectangle("fill", playerRight.x, playerRight.y, playerRight.w, playerRight.h)
end