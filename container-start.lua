function round(number,decimals)
    local power = 10^decimals
    
    if (number == 0) then return 0
    else return math.floor((number/1000) * power) / power
    end
end 

function percent(volume, max)
    if (volume == 0) then return 0
    else return math.ceil((volume/max)*100)
    end
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
    
	containerVolume = round(math.ceil(container.getItemsVolume()),1)
	storageVolume = round(math.ceil(storage.getItemsVolume()),1)
    
     containerPercent = percent(containerVolume, maxContainer)
	containerStatus = oreStatus(containerPercent, 0)

	storagePercent = percent(storageVolume, maxContainer)
	storageStatus = oreStatus(storagePercent, 1)
end

function updateScreen()
    if old_containerVolume == containerVolume then return
    elseif old_storageVolume == storageVolume then return
    end
    
    old_containerVolume = containerVolume
    old_storageVolume = storageVolume
    
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
	<tr>
		<th>Container</th>
		<th>]]..containerVolume..[[KL</th>
		<th>]]..containerPercent..[[%</th>
		]]..containerStatus..[[
	</tr>
	<tr>
		<th>Storage</th>
		<th>]]..storageVolume..[[KL</th>
		<th>]]..storagePercent..[[%</th>
		]]..storageStatus..[[
	</tr>
</table>
</div>
]]
    
	screen.setHTML(html)
end

local itemList = container.getItemsList()
local itemHTML = ""

screen.clear()
populateVariables()
updateScreen()

