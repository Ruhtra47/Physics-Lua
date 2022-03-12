WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 9.81 * 64, true)

    objects = {}

    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT - 50 / 2)
    objects.ground.shape = love.physics.newRectangleShape(WINDOW_WIDTH, 50)
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)
    objects.ground.fixture:setFriction(0.9)

    objects.player = {}
    objects.player.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT - 50, 'dynamic')
    objects.player.shape = love.physics.newCircleShape(25)
    objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.shape)
    objects.player.body:setFixedRotation(true)
    objects.player.fixture:setFriction(0.5)

    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('Physics')

    joystick = love.joystick.getJoysticks()[1]

    grounded = true

end

function love.update(dt)
    world:update(dt)

    vx, vy = objects.player.body:getLinearVelocity()

    leftx = joystick:getAxes()

    if objects.player.body:getY() + 51 >= objects.ground.body:getY() then
        grounded = true
    else
        grounded = false
    end

    if (leftx < -0.25 or love.keyboard.isDown('left') or love.keyboard.isDown('a')) and grounded then
        objects.player.body:applyForce(-400, 0)
    elseif (leftx > 0.25 or love.keyboard.isDown('right') or love.keyboard.isDown('d')) and grounded then
        objects.player.body:applyForce(400, 0)
    end

    if (leftx < -0.25 or love.keyboard.isDown('left') or love.keyboard.isDown('a')) and not grounded then
        if vx > 0 then
            objects.player.body:applyForce(-200, 0)
        else
            objects.player.body:applyForce(-75, 0)
        end
    elseif (leftx > 0.25 or love.keyboard.isDown('right') or love.keyboard.isDown('d')) and not grounded then
        if vx < 0 then
            objects.player.body:applyForce(200, 0)
        else
            objects.player.body:applyForce(75, 0)
        end
    end

    if objects.player.body:getX() - 25 <= 0 then
        objects.player.body:setLinearVelocity(0, vy)
        objects.player.body:setPosition(25, objects.player.body:getY())
    end

    if objects.player.body:getX() + 25 >= WINDOW_WIDTH then
        objects.player.body:setLinearVelocity(0, vy)
        objects.player.body:setPosition(WINDOW_WIDTH - 25, objects.player.body:getY())
    end
end

function love.gamepadpressed(joystick, button)
    if grounded and button == 'a' then
        objects.player.body:applyLinearImpulse(0, -200)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if (key == 'space' or key == 'w' or key == 'up') and grounded then
        objects.player.body:applyLinearImpulse(0, -200)
    end
end

function love.draw()
    love.graphics.setColor(0.28, 0.63, 0.05)
    love.graphics.polygon('fill', objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))

    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.circle('fill', objects.player.body:getX(), objects.player.body:getY(),
     objects.player.shape:getRadius())
end
