require "UISystems/Login/LoginProxy"
require "UISystems/Login/LoginPanel"
require "UISystems/Common/UICtrl"
--需要指定uiShowType,或者默认就是ShowOnly

LoginCtrl = UICtrl:New({uiShowType = UIShowType.ShowOnly})
local this = LoginCtrl

local luaBehavior
local gameObject
local transform
local serverId = 1

--初始化函数 == 构造函数
function this.Init()
	LoginProxy.Init()
end

function this.OnCreate( obj )
	gameObject = obj
	transform = obj.transform
	LoginPanel.luaBehaviour:AddClick(LoginPanel.loginBtn,this.OnLoginClick)
end

function this.OnLoginClick()
	local username = LoginPanel.GetUserName()
	local pwd = LoginPanel.GetPwd()
	LoginProxy.Login(username,pwd,serverId)
end

--panel打开时触发的方法
function this.OnShowPanel( data )
	if data ~= nil then
		logWarn('--------- 打开登陆Panel' .. data)
	else
		logWarn("-----------打开登陆Panel")
	end
end

--关闭时候执行
function this.OnHidPanel()
	logWarn('--------- 隐藏登陆panel:')
end

--pop 操作时的反向传值，uishowType = UIShowType.stack是 true才会触发
function this.OnPopPanel( panelName,data )
	logWarn(panelName .. '反向传值数据:' .. data)
end

--这里一定要有returen this

return this