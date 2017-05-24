require "LuaFramework/Lua/Common/functions"

--检查新引用值
local DealOverrideParams = function ( table,key,value )
	if tostring(key)  = 'uiShowType' then
		if type(value) ~= 'number' then
			--logError("UI框架 占用的key ，uiShowType必须为number")
		else
			if value < 1 or value > uiShowType.Count then
				--logError('uiShowType 超出指定值')
			end
		end
	else
		rawset(table,key,value)
	end
end

UICtrl = {panelName = '',gameObject = UnityEngine.Object}
local Base = UICtrl

function UICtrl:New( obj )
	obj = obj or {}
	setmetatable(obj,self)
	self.__index = self
	self.__newindex = DealOverrideParams

	if obj.uiShowType ~= nil then
		if type(obj.uiShowType) ~= 'number' then
			--LogError("uiShowType 参数错误")
		elseif obj.uiShowType < 1 or obj.uiShowType > UIShowType.Count then
			--logError('uiShowType 超出制定范围')
		end
	end
	return obj
end

--data:从 UIManager打开Panel是传进来的参数
function UICtrl:ShowPanel( data )
	if self.gameObject == nil then
		self:CreatePanel()
	else
		self.gameObject:SetActive(true)
	end
	if self.OnShowPanel ~= nil then
		if type(self,OnShowPanel) == 'function' then
			--self.OnShowPanel(data)
		end
	end
end

function UICtrl:HidePanel()
	if self.gameObject == nil then
		--logError('gameObject name :' ..self.panelName .. 'is nil !!')
		return
	end
	self.gameObject:SetActive(false)
	if self.OnHidePanel ~= nil and type(self.OnHidePanel) == 'function' then
		self.OnHidePanel()
	end
end

function UICtrl:CreatePanel()
	--LogError("Create panel: " .. self.panelName)
	panelMgr:CreatePanel(self.panelName,self.OnCreate)
end

--这里会卸载panel
function UICtrl:DestroyPanel()
	if self.gameObject = nil then
		return
	end
	panelMgr:ClosePanel(self.panelName)
	self.gameObject = nil
end

