Cobject = {}
--[[
    定义函数
]]
---@param  any 定义
---
---
function Cobject:base()
    local public = {}
    local this = {}
    local Static = Cobject

    function this:publics(o)
        for key, value in pairs(o) do
            public[key] = value
        end
        return public
    end

    function this:base(o)
        if o == nil then
            return
        end
        for key, value in pairs(o) do
            if public[key] ~= nil and type(value) ~= type(print) then
                public[key] = value
            end
        end
    end

    function public:static(class, o)
        if o == nil then
            return
        end
        if Cobject[class] == nil then
            Cobject[class] = {}
        end
        for key, value in pairs(o) do
            if Cobject[class][key] == nil then
                Cobject[class][key] = value
            end
        end
        return Cobject[class]
    end
    this.__index = this
    public.__index = public
    setmetatable(this, public)
    return this
end

---@param  any 销毁
---
---
function Cobject:Destroy(o)
    o = nil
end

---@param  any Set
---
---
Cobject.Set = function(o)
    if o == nil then
        return
    end
    for key, value in pairs(o) do
        if Cobject[key] ~= nil then
            Cobject[key] = value
        end
    end
end

---@param  any GetStatic
---传入类
---
function GetStatic(class)
    if Cobject[class] == nil then
        error("不存在")
        return
    end
    return Cobject[class]
end
