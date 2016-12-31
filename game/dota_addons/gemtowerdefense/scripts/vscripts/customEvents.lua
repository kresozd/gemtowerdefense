if CustomEvent == nil then

  print ( '[CUSTOMEVENT] creating CustomEvent' )

  CustomEvent = {}

  CustomEvent.__index = CustomEvent

  CustomEvent.eventList = {}
end


--[[
  CustomEvent:RegisterCallback()
    label - String label identifying event.
    callback - Function to be called upon event firing.
    Returns the node of the callback function.
  Links an event to a callback function.
]]--
function CustomEvent:RegisterCallback(label, callback)
  local node = {}
  node.callback = callback
  node.next = self.eventList[label]
  if self.eventList[label] then
    self.eventList[label].prev = node
  end
  self.eventList[label] = node 

  return node
end


function CustomEvent:RemoveCallback(node)
  if node.next then
    node.next.prev = node.prev
  end
  if node.prev then
    node.prev.next = node.next
  end

  node = nil
end


function CustomEvent:FireEvent(label, eventData)
  local node = self.eventList[label]
  while node do
    node.callback(eventData)
    node = node.next
  end
end