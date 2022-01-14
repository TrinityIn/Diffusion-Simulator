Class = require 'class'

require "Particle"
require "Wall"

WINDOW_WIDTH = 740
WINDOW_HEIGHT = 740

PARTICLE_RADIUS = 5
NUM_OF_PARTICLES = 10
MAX_VEL = 500

NUM_OF_WALLS = 3
wallSys = {}


numCollide = 0
system = {}

northSide = 0
southSide = 0

function love.conf(t)
    t.console = true
end

math.randomseed(os.time())
function love.load()
    for i = 0, NUM_OF_PARTICLES do
       system[i] = Particle(math.random(WINDOW_WIDTH), math.random(WINDOW_HEIGHT / 2), 
        math.random(MAX_VEL * 2) - MAX_VEL,math.random(MAX_VEL) - MAX_VEL)
    end 

    for i = 0, NUM_OF_WALLS do
        wallSys[i] = Wall((i-1) * (WINDOW_WIDTH / NUM_OF_WALLS) + 1, WINDOW_HEIGHT / 2, (WINDOW_WIDTH / NUM_OF_WALLS) - 100, 10)    
    end

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Particle Simulator")
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end



function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end


function love.update(dt)
    northSide = 0
    southSide = 0
    for _, particle1 in ipairs(system) do
        if (particle1.y < WINDOW_HEIGHT / 2) then
            northSide = northSide + 1
        else
            southSide = southSide + 1
        end

        bound(particle1)
        for _, particle2 in ipairs(system) do
            if particle1 ~= particle2 then
                if particle1:collidesParticle(particle2) then
                    particle1.velx = -particle1.velx --* 0.99
                    particle1.vely = -particle1.vely --* 0.99
                    particle2.velx = -particle2.velx --* 0.99
                    particle2.vely = -particle2.vely --* 0.99

                    -- particle1.x = particle2.x + (particle1.velx/math.abs(particle1.velx)) * PARTICLE_RADIUS
                    -- particle2.x = particle1.x + (particle2.velx/math.abs(particle2.velx)) * PARTICLE_RADIUS

                    -- particle1.y = particle2.y + (particle1.vely/math.abs(particle1.vely)) * PARTICLE_RADIUS
                    -- particle2.y = particle1.y + (particle2.vely/math.abs(particle2.vely)) * PARTICLE_RADIUS
                    

                    --collision counter
                    numCollide = numCollide + 1
                    
                end
            end
        end

        for _, wall in ipairs(wallSys) do  
            if particle1:collidesWall(wall) then
                if particle1 ~= particle2 then
                    numCollide = numCollide + 1
                end
            end
        end
        particle1:update(dt)
        -- particle1.x = particle1.x + particle1.velx * dt;
        -- particle1.y = particle1.y + particle1.vely * dt;

        if love.mouse.isDown(1) then
            mouseX = love.mouse.getX()
            mouseY = love.mouse.getY()
            distX = mouseX - particle1.x
            distY = mouseY - particle1.y
            particle1.velx = distX
            particle1.vely = distY
        end
    end
end


function bound(particle)
    if(particle.x + PARTICLE_RADIUS  > WINDOW_WIDTH) then
        particle.x = WINDOW_WIDTH - PARTICLE_RADIUS
        particle.velx = -particle.velx 
    elseif(particle.x - PARTICLE_RADIUS  < 0) then
        particle.x = PARTICLE_RADIUS
        particle.velx = -particle.velx
    end
    if (particle.y + PARTICLE_RADIUS  > WINDOW_HEIGHT)  then   
        particle.y = WINDOW_HEIGHT - PARTICLE_RADIUS
        particle.vely = -particle.vely 
    elseif(particle.y - PARTICLE_RADIUS  < 0) then
        particle.y = PARTICLE_RADIUS
        particle.vely = -particle.vely
    end

end

function distance(x1, y1, x2, y2)
    d = math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
    return d
end

function love.draw()  
    font = love.graphics.newFont(30)
    love.graphics.setFont(font)

    love.graphics.printf(northSide, 0, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')
    love.graphics.printf(southSide, 0, 3 * WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')
    
    love.graphics.printf('number of collisions: ' .. numCollide, 0, 20, WINDOW_WIDTH, 'right')
    for i, particle1 in ipairs(system) do
        --sets colors of particles to make me happy
        if      i % 7 == 0  then love.graphics.setColor(255, 255, 0)
        elseif  i % 6 == 0  then love.graphics.setColor(255, 0, 255)
        elseif  i % 5 == 0  then love.graphics.setColor(0, 255, 255)
        elseif  i % 4 == 0  then love.graphics.setColor(255, 0, 0)
        elseif  i % 3 == 0  then love.graphics.setColor(0, 0, 255)
        elseif  i % 2 == 0  then love.graphics.setColor(0, 255, 0)
        end

        --makes le circle
        love.graphics.circle('fill',particle1.x, particle1.y, PARTICLE_RADIUS)  
    end

    for i, wall in ipairs(wallSys) do
        --sets wall color to white
        love.graphics.setColor(255, 255, 255)
        
        --makes le wall
        love.graphics.rectangle("fill", wall.x, wall.y, wall.lenx, wall.leny)
    end

end