for i,area in pairs(clickableAreas) do
	if (x >= area.x and x <= (area.x + area.hx) and y >= area.y and y <= (area.y + area.hy)) then
		if (area.refiner ~= false) then area.fun(area.refiner)
          else area.fun()
		end
	end
end
