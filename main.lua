WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 9.81 * 64, true)
    gravity = 400

    objects = {}

    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT - 50 / 2, 'static')
    objects.ground.shape = love.physics.newRectangleShape(WINDOW_WIDTH, 50)
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape, 1)
    objects.ground.fixture:setFriction(0.001)

    objects.player = {}
    objects.player.body = love.physics.newBody(world, WINDOW_WIDTH / 2 - 25, objects.ground.body:getY() - 50, 'dynamic')
    objects.player.body:setFixedRotation(true)
    objects.player.shape = love.physics.newCircleShape(25)
    objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.shape, 1)
    objects.player.fixture:setFriction(0.9)

    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('Physics')

    grounded = true

end

function love.update(dt)
    world:update(dt)

    vx, vy = objects.player.body:getLinearVelocity()

    if objects.player.body:getX() - 25 <= 0 then
        objects.player.body:setLinearVelocity(0, vy)
        objects.player.body:setPosition(25, objects.player.body:getY())
    elseif objects.player.body:getX() + 25 >= WINDOW_WIDTH then
        objects.player.body:setLinearVelocity(0, vy)
        objects.player.body:setPosition(WINDOW_WIDTH - 25, objects.player.body:getY())
    end

    if love.keyboard.isDown('left') or love.keyboard.isDown('a') and vx > -750 then
        objects.player.body:applyForce(-400, 0)
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') and vx < 750 then
        objects.player.body:applyForce(400, 0)
    end

    if objects.player.body:getY() + 51 >= objects.ground.body:getY() then
        grounded = true
        objects.player.body:setLinearVelocity(vx, gravity)
    else
        grounded = false
    end

    if grounded then
        if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
            objects.player.body:applyLinearImpulse(0, -400)
        end
    end

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()

    love.graphics.setColor(0.28, 0.63, 0.05)
    love.graphics.polygon('fill', objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))

    love.graphics.setColor(1, 0, 0)
    love.graphics.circle('fill', objects.player.body:getX(), objects.player.body:getY(),
     objects.player.shape:getRadius())

    love.graphics.print(tostring(grounded), WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)

end
