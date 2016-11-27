function CreateBulletManager(world, speed)
	local obj = {}
	
	obj.world = world
	obj.bullets = {}
	obj.speed = speed

	obj.newBullet = function(self, player, angle)
		local bullet = CreateBullet(self.world, player, math.sin(angle) * self.speed, math.cos(angle) * self.speed, self)
		
		table.insert(obj.bullets, bullet)
	end
	
	obj.draw = function(self)
		for i, v in ipairs(self.bullets) do
			v:draw(dt)
		end
	end
	
	return obj
end