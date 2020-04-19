--[[
    参见 weituo.lua BaseClass.lua
]]
require("BaseClass")
Singleton = require("Singleton")
local Manager = BaseClass("Manager", Singleton)

function Open(self, arg, ...)
    self:GetWindow(arg)
    -- body
end

function GetWindow(self, arg)
    self.meigui = "meigui"
    print(arg)
end

local function __init(self)
    print("构造函数")
end
Manager.__init = __init
Manager.Open = Open

Manager.GetWindow = GetWindow

return Manager
