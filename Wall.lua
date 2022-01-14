Wall = Class{}

function Wall:new (x,y,lenx,leny)
    self.__index = self
    return setmetatable(
        {
        x = x, 
        y = y,
        lenx = lenx,
        leny = leny
    }, self)
end

function Wall:init(x, y, lenx, leny)
    self.x = x
    self.y = y
    self.lenx = lenx
    self.leny = leny
end
