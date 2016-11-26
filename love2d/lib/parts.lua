partsImg = {}
partsData = {}

function GetImage(path)
	if not partsImg[path] then
		partsImg[path] = love.graphics.newImage("gfx/" .. path .. ".png")
	end

	return partsImg[path]
end

function GetData(path)
	if not partsData[path] then
		partsData[path] = dofile("data/" .. path .. ".lua")
	end

	return partsData[path]
end

function CreatePart(world, x, y, path)
	local obj = {}

	obj.x = x or 0
	obj.y = y or 0
	obj.img = GetImage(path or "default")
	obj.data = GetData(path or "default")

	obj.body = love.physics.newBody(world, x, y)

	for k, v in pairs(obj.data) do
		local shape = love.physics.newRectangleShape(v[2] + 32 + v[4] * 0.5, v[3] + 32 + v[5] * 0.5, v[4], v[5])
		local fixture = love.physics.newFixture(obj.body, shape)
	end

	obj.draw = function(self, x, y)
		love.graphics.draw(self.img, self.x + x, self.y + y)
		
		for k, v in pairs(self.body:getFixtureList()) do
			love.graphics.polygon("fill", self.body:getWorldPoints(v:getShape():getPoints()))
		end
	end

	return obj
end