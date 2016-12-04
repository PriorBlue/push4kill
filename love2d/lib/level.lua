function CreateLevel(world, x, y, path, size)
	local obj = {}

	obj.x = x - size or 0
	obj.y = y - size or 0
	
	obj.data = dofile(arg[1] .. "\\data\\" .. path .. ".lua")
	
	obj.width = #obj.data[1]
	obj.height = #obj.data

	obj.size = size
	
	obj.parts = {}
	
	obj.shiftX = 0
	obj.shiftY = 0
	
	obj.shiftMX = 0
	obj.shiftMY = 0
	
	obj.delta = 0

	obj.update = function(self, dt)
		local forceSwitch = false
		
		if self.shiftMX ~= 0 then
			self.delta = self.delta + dt * self.shiftMX
			
			if math.abs(self.delta) > math.abs(self.shiftMX) then
				self.delta = 0
				forceSwitch = true
			end
		end
		
		if self.shiftMY ~= 0 then
			self.delta = self.delta + dt * self.shiftMY
			
			if math.abs(self.delta) > math.abs(self.shiftMY) then
				self.delta = 0
				forceSwitch = true
			end
		end
			
		if forceSwitch then
			if self.shiftMX > 0 then
				local dummy = self.parts[self.width][self.shiftX]
				for i = self.width, 2, -1 do
					self.parts[i][self.shiftX] = self.parts[i - 1][self.shiftX]
				end
				self.parts[1][self.shiftX] = dummy
			elseif self.shiftMX < 0 then
				local dummy = self.parts[1][self.shiftX]
				for i = 1, self.width - 1 do
					self.parts[i][self.shiftX] = self.parts[i + 1][self.shiftX]
				end
				self.parts[self.width][self.shiftX] = dummy
			elseif self.shiftMY > 0 then
				local dummy = self.parts[self.shiftY][self.height]
				for i = self.height, 2, -1 do
					self.parts[self.shiftY][i] = self.parts[self.shiftY][i - 1]
				end
				self.parts[self.shiftY][1] = dummy
			elseif self.shiftMY < 0 then
				local dummy = self.parts[self.shiftY][1]
				for i = 1, self.height - 1 do
					self.parts[self.shiftY][i] = self.parts[self.shiftY][i + 1]
				end
				self.parts[self.shiftY][self.height] = dummy
			end
		end
		
		if self.shiftMX ~= 0 then
			for i = 1, self.width do
				self.parts[i][self.shiftX].x = self.x + (i - 1) * self.size + self.size * self.delta
				self.parts[i][self.shiftX].body:setX(self.parts[i][self.shiftX].x)
			end
		end
		
		if self.shiftMY ~= 0 then
			for i = 1, self.height do
				self.parts[self.shiftY][i].y = self.y + (i - 1) * self.size + self.size * self.delta
				self.parts[self.shiftY][i].body:setY(self.parts[self.shiftY][i].y)
			end
		end
		
		if forceSwitch then
			self.shiftX = 0
			self.shiftY = 0
			self.shiftMX = 0
			self.shiftMY = 0
		end
	end

	for i = 1, obj.width do
		obj.parts[i] = {}
		for k = 1, obj.height do
			obj.parts[i][k] = CreatePart(world, obj.x + (i - 1) * size, obj.y + (k - 1) * obj.size, obj.data[k][i])
		end
	end

	obj.draw = function(self)
		for i = 1, self.width do
			for k = 1, self.height do
				self.parts[i][k]:draw()
			end
		end
	end

	obj.moveX = function(self, x, mx)
		if self.shiftX == 0 and self.shiftY == 0 then
			self.shiftX = x
			self.shiftMX = mx
		end
	end

	obj.moveY = function(self, y, my)
		if self.shiftX == 0 and self.shiftY == 0 then
			self.shiftY = y
			self.shiftMY = my
		end
	end

	return obj
end