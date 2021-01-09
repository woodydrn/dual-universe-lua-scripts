populateVariables()
updateScreen()

local now = math.ceil(system.getTime())

if (now > (startTime + 120)) then
    if shouldUpdateContainer then
        container.acquireStorage()
        shouldUpdateContainer = false
        startTime = math.ceil(system.getTime())
    end
    
    if shouldUpdateStorage then
        storage.acquireStorage()
        shouldUpdateStorage = false
        startTime = math.ceil(system.getTime())
    end
end
