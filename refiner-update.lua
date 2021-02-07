if shouldUpdate.update == true then
	if system.getTime() >= shouldUpdate.endtime then
		updateScreen()
	end
end
