function round(number,decimals)
	local power = 10^decimals
	return math.floor((number/1000) * power) / power
end 

function percent(volume, max)
	return math.ceil((volume/max)*100)
end

function oreStatus(percent, invert)
	if invert == 0 then
		if percent <= 25 then return "<th style=\"color: red;\">LOW</th>"
		elseif percent > 25 and percent < 50 then return "<th style=\"color: orange;\">LOW</th>"
		else return "<th style=\"color: green;\">GOOD</th>"
		end 
	else
		if percent <= 25 then return "<th style=\"color: green;\">GOOD</th>"
		elseif percent > 25 and percent < 75 then return "<th style=\"color: orange;\">OK</th>"
		else return "<th style=\"color: red;\">HIGH</th>"
		end 
	end
end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function isNotEmpty(s)
	return s ~= nil and s ~= ''
end

maxContainer = 0
containerVolume = 0
storageVolume = 0

containerPercent = 0
containerStatus = ""

storagePercent = 0
storageStatus = ""

old_containerVolume = -1
old_storageVolume = -1

function populateVariables()
	maxContainer = 307.20
    
	local cv = container.getItemsVolume()
    
	if isNotEmpty(cv) then containerVolume = round(math.ceil(cv),1)
     else containerVolume = 0
     end

	local sv = storage.getItemsVolume()
	if isNotEmpty(sv) then storageVolume = round(math.ceil(sv),1)
     else storageVolume = 0
     end
    
     containerPercent = percent(containerVolume, maxContainer)
	containerStatus = oreStatus(containerPercent, 0)

	storagePercent = percent(storageVolume, maxContainer)
	storageStatus = oreStatus(storagePercent, 1)
end

function updateScreen()
	if old_containerVolume == containerVolume and old_storageVolume == storageVolume then
		return
	end

	if old_containerVolume ~= containerVolume then
		old_containerVolume = containerVolume
		container.acquireStorage()
     end
    
	if old_storageVolume ~= storageVolume then
		old_storageVolume = storageVolume
		storage.acquireStorage()
     end
    
	html = [[
<div class="bootstrap">
<h1 style="font-size: 4em;">Container Status</h1>
<table 
style="
	margin-top: 10px;
	margin-left: auto;
	margin-right: auto;
	width: 90%;
	font-size: 3em;
">
	</br>
	<tr style="
		width: 100%;
		margin-bottom: 10px;
		background-color: blue;
		color: white;
	">
		<th>Name</th>
		<th>Volume</th>
		<th>Percent</th>
		<th>Status</th>
	</tr>
	<tr>
		<td>Container</td>
		<td>]]..containerVolume..[[KL</td>
		<td>]]..containerPercent..[[%</td>
		]]..containerStatus..[[
	</tr>
	<tr>
		<td>Storage</th>
		<td>]]..storageVolume..[[KL</td>
		<td>]]..storagePercent..[[%</td>
		]]..storageStatus..[[
	</tr>
</table>
</div>
]]
    
	screen.setHTML(html)
end

screen.clear()
populateVariables()
updateScreen()
