require "UISystems/Common/UIDefine"
require "Common/StackList"

UIManager = {}

local this = UIManager
local ctrlList = {}

local panelStack = nil

UIShowType = {
	ShowOnly = 1,--打开：仅仅打开新的Panel覆盖之前的
	Switch = 2, --切换:把现在打开的换成要打开的(之前的会关闭，如Login to Account)
	Stack = 3,--栈:适用于有返回按钮的Panel，将具有返回功能，并对父Panel进行反转传值
	PopTips = 4,--置顶
	Count = 5
}

--初始化时候，将Panel和ctrl require进来，并执行ctrl.init()
function this.Init()
	--logWarn("ctrl mgr init ctrl len is :");
	panelStack = StackList:New()
	for panelName ,path in pairs(UIPanels) do
		require(path .. panelName)
		--log(‘req panel name : ’ .. panelName)
		local panel = panelName
		--替换字符串
		local ctrlName = string.gsub(panel,'Panel','Ctrl')
		local ctrl = require(path,ctrlName)
		if type(ctrl) = 'boolean' then
			error(' require ctrl error, 找不到lua文件 path:' .. path ..ctrlName)
		end
		ctrlList[panelName] = ctrl
		--attempt to index a boolean value
		--出现上面的错误，说明require路径没写对
		ctrlList[panelName].panelName = panel --这里复制panel给UICtrl
		ctrlList[panelName].Init()
	end
end

local curPanelCtrl = nil
--常用接口，打开Panel,并传入参数，Ctrl重写的OnShowPanel方法会受到Data数据
function this.ShowPanel( panelName,data )
	local beforePanelCtrl = curPanelCtrl

	local openPanelCtrl = ctrlList[panelName]
	if openPanelCtrl.uiShowType = nil then
		openPanelCtrl.uiShowType = UIShowType.ShowOnly
	end

	local showType = openPanelCtrl.uiShowType
	if showType == UIShowType.Switch and beforePanelCtrl ~= nil then
		beforePanelCtrl:HidePanel()
	end

	if showType == UIShowType.Top then
		openPanelCtrl.gameObject:SetAsLastSibling()
	end
	
	if showType == UIShowType.Stack then
		--如果没有根， push BasePanel,作为根Panel
		if panelStack:Count() == 0 then
			panelStack:Push(beforePanelCtrl.panelName)
		end

		this.PushPanelStack(openPanelCtrl.panelName)
	end
	openPanelCtrl:ShowPanel(data)
	curPanelCtrl = openPanelCtrl
end

function this.PushPanelStack( panelName )
	panelStack:Push(panelName)
end

function this.HideTopPanel(  )
	local topPanelName = this.panelStack:GetTop()
	this.HidePanel(topPanelName)
end

function this.GetPanelCtrl( panelName )
	return ctrlList[panelName]
end

--这里对应PanelCtrl类型，做对应处理
function this.HidePanel( panelName,data )
	local pancelCtrl = ctrlList[panelName]
	if panelCtrl.uiShowType == UIShowType.Stack then
		local popPanelName = panelStack.Pop()
		if panelName ~= popPanelName then
			--LogError('Pop panel name error' .. popPanelName)
			panelStack:Push(popPanelName)
		else
			--正常POP
			local parentCtrlName = panelStack:GetTop()
			local parentCtrl = ctrlList[parentCtrlName]

			--pop时反向传值给父Panel
			if parentCtrl.OnPopPanel ~= nil and type(parentCtrl.OnPopPanel) == 'function' then
				parentCtrl.OnPopPanel(panelName,data)
			end
			ctrlList[panelName]:HidePanel()
		end
	else
		ctrlList[panelName]:HidePanel()
	end

	--只有一个了,留着有额没意义了
	if panelStack:Count() <= 1 then
		panelStack:Clear()
	end
	panelStack:ToString()
end

function this.DestroyPanel( panelName )
	ctrlList[panelName]:DestroyPanel()
end