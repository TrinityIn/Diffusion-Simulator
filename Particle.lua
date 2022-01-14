Particle = Class{}

function Particle:new (x,y,velx,vely)
    self.__index = self
    return setmetatable(
        {
        x = x, 
        y = y ,
        velx = velx,
        vely = vely,
    }, self)
end

function Particle:init(x, y, velx, vely)
    self.x = x
    self.y = y
    self.velx = velx
    self.vely = vely
    self.prevx = x
    self.prevy = y
end

function Particle:collidesParticle(particle1)

    if (self.x - PARTICLE_RADIUS > (particle1.x + PARTICLE_RADIUS)) or (particle1.x - PARTICLE_RADIUS > (self.x + PARTICLE_RADIUS)) then
        -- particle1.velx = -particle1.velx 
        -- particle1.vely = -particle1.vely 
        -- self.velx = -self.velx
        -- self.vely = -self.vely
        -- print(self.x + " " + self.y + " " particle1.x + " " + particle1.y)

        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if ((self.y - PARTICLE_RADIUS) > (particle1.y + PARTICLE_RADIUS)) or ((particle1.y - PARTICLE_RADIUS) > (self.y + PARTICLE_RADIUS)) then
        -- particle1.velx = -particle1.velx
        -- particle1.vely = -particle1.vely
        -- self.velx = -self.velx
        -- self.vely = -self.vely
        return false
    end 

    if particle1.x < particle1.prevx then
        particle1.x = particle1.prevx + 3
    else 
        particle1.x = particle1.prevx - 3
    end
    if particle1.y < particle1.prevy then
        particle1.y = particle1.prevy + 3
    else 
        particle1.y = particle1.prevy - 3
    end

    if self.x < self.prevx then
        self.x = self.prevx + 3
    else
        self.x = self.prevx - 3
    end
    if self.y < self.prevy then
        self.y = self.prevy + 3
    else
        self.y = self.prevy - 3
    end

    -- if the above aren't true, they're overlapping
    return true
end

function Particle:collidesWall(wall)
    
    if (self.x - PARTICLE_RADIUS) > wall.x + wall.lenx or wall.x > self.x + PARTICLE_RADIUS then
        return false
    end

    if (self.y - PARTICLE_RADIUS) > wall.y + wall.leny or wall.y > self.y + PARTICLE_RADIUS then
        return false
    end
    
    

    if not (self.y - PARTICLE_RADIUS > wall.y + wall.leny or wall.y > self.y + PARTICLE_RADIUS) then
        if self.vely > 0 and self.y < wall.y then
            self.y = wall.y - PARTICLE_RADIUS
        elseif self.vely < 0 and self.y > wall.y + wall.leny then
            self.y = wall.y + wall.leny + PARTICLE_RADIUS
        end
        self.vely = -self.vely
    else    
        self.velx = -self.velx
    end

    return true
end

function Particle:update(dt) 
    self.prevx = self.x
    self.prevy = self.y 
    self.x = self.x + self.velx * dt;
    self.y = self.y + self.vely * dt;
end
