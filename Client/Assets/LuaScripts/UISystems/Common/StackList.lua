require "Common/functions"

StackList = {}
local count = 0

function StackList:New( obj )
	self.stack_list = obj or {}
	setmetatable(self,StackList)
	StackList.__index = StackList
	return self
end

function StackList:Push( element )
	count = count + 1
	self.stack_list[count] = element
end

function StackList:Pop()
	if count < 1 then
		--logError("stack_list count is 0!!")
		return
	end
	local pope = table.remove(self.stack_list,count)
	count = count - 1
	return pope
end

function StackList:Count()
	return count
end

function StackList:GetTop()
	local top = self.stack_list[count]
	return top
end

function StackList:Contain( element )
	for v in ipairs(self.stack_list) do
		if v == element then
			return true
		end
	end
	return false
end

function StackList:Clear()
	self.stack_list = nil
	self.stack_list = {}
	count = 0
end