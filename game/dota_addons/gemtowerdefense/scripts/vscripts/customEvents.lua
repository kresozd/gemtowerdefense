if CustomEvent == nil then

  print ( '[CUSTOMEVENT] creating CustomEvent' )

  CustomEvent = {}

  CustomEvent.__index = CustomEvent

  CustomEvent.eventList = {}
end

function CustomEvent:RegisterCallback(label, callback)
  print("CUSTOM LISTENER INIT")
  local node = {}
  node.callback = callback
  print("Node callback:", node.callback)
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