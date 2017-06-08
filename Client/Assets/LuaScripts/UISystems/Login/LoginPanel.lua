require "UISystems/Interface/UIPanel"

LoginPanel = {}
local this = LoginPanel

local transform
local gameObject

function this.Awake( obj )
	gameObject = obj
	transform = obj.transform
	this.InitPanel()
end

function this.InitPanel()
	this.usernameInput = transform:FindChild("accountInput"):GetComponent("InputField")
	this.pwdInput = transform:FindChild("pwdInput"):GetComponent("InputField")
	this.loginBtn = transform:FindChild("loginBtn").gameObject
	this.luaBehaviour = transform:GetComponent('LuaBehaviour')
end

function this.GetUserName()
	this.usernameInput = transform:FindChild("accountInput"):GetComponent("InputField")
	return this.usernameInput.text
end

function LoginPanel.GetPwd()
	return this.pwdInput.text
end