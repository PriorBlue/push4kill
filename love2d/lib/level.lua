function CreateLevel(world, x, y, width, height, size)
	local obj = {}

	obj.x = x or 0
	obj.y = y or 0
	
	obj.width = width or 4
	obj.height = height or 4
	
	obj.parts = {}
	
	obj.data = dofile("data/level.lua")
	
	for i = 1, obj.width do
		obj.parts[i] = {}
		for k = 1, obj.height do
			obj.parts[i][k] = CreatePart(world, x + (i - 1) * size, y + (k - 1) * size, obj.data[k][i])
		end
	end
	
	obj.draw = function(self)
		for i = 1, self.width do
			for k = 1, self.height do
				obj.parts[i][k]:draw(self.x, self.y)
			end
		end
	end

	return obj
end