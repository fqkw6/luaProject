--[[
    --weituo
]]
local weito = {}

function weito:new()
    o = o or {}
    setmetatable(o, {__index = weito})

    -- body
    return o
end

function Action(arg, arg1, ...) --参数写在前面  也可以不带参数
    call = ...
    if call ~= nil then
        call(arg, arg1)
    end
end

function De(arg, arg1)
    print(arg)
    --..不能连接table
    print("参数")
    print(arg1)
end

Action(1, 2, De)

function Init(self)
    --self = self
    self.loj = "ss"
end

function OnStart(...)
    if type(...) then
        print("参数类型" .. type(...))
    else
        print("参数为空")
    end
    print("初始化")
end

function OnEnable(self, arg, ...)
    print("调用OnEnable和init")
    print(arg)
    --self:Init(...)
end

SWeiTuo = weito:new()
SWeiTuo.Init = Init

SWeiTuo.OnEnable = OnEnable
return SWeiTuo
