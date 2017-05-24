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

local usernameInput
local pwdInput
local loginBtn
local luaBehaviour

function this.InitPanel()
	usernameInput = transform:FindChild("Username"):GetComponent("InputField")
	pwdInput = transform:FindChild("Pwd"):GetComponent("InputField")
	loginBtn = transform:FindChild("LoginBtn").gameObject
	luaBehaviour = transform:GetComponent('luaBehaviour')
end

function this.GetUserName()
	return usernameInput.text
end

function LoginPanel.GetPwd()
	return pwdInput.text
end