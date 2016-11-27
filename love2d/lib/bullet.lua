function CreateBullet(world, player, dx, dy, parent)
	local obj = {}

	obj.type = "bullet"
	obj.parent = parent
	obj.source = player

	obj.x = player.body:getX()
	obj.y = player.body:getY()

	obj.body = love.physics.newBody(world, obj.x, obj.y, "dynamic")
	obj.shape = love.physics.newCircleShape(4)
	obj.fixture = love.physics.newFixture(obj.body, obj.shape)
	obj.fixture:setUserData(obj)
	
	obj.body:setLinearVelocity(100, 0)
	
	obj.draw = function(self)
		love.graphics.setColor(255, 127, 0, 255)
		love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
	end
	
	obj.destroy = function(self)
		for i, v in ipairs(self.parent.bullets) do
			if v == self then
				table.remove(obj.parent.bullets, i)
				break
			end
		end
		
		obj.body:destroy()
	end
	
	return obj
end