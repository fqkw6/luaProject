-- File Name:    Class.lua
-- Description:    模拟Lua里OOP特性(不支持多重继承)
-- Author:       TangHuan
-- Create Date:    2018/11/09

-- 使用方法：
-- 1. 定义类
-- local ClassName = Class("ClassName", nil)
-- ***(自定义类数据方法等)
-- 参数说明：
-- clsname类名，super父类
-- 返回结果:
-- ClassName(含Class基本信息结构的table)

-- 2. 实例化类对象
-- 参数说明：
-- BaseClass含类定义的Class Table
-- ...构造类实例对象的构造函数ctor()的参数
-- 返回结果：
-- 基于BaseClass的实例对象
-- new(BaseClass, ...)

---克隆对象(建议用于克隆Class对象)
---@param  any 对象
---@return  any 克隆对象
function Clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

---判定是否是指定类或者继承至该类
---@param self Class@类实例对象或者类
---@param cname string | Class@类名或者类定义table
local function IsClass(self, cname)
    if type(self) ~= "table" then
        return false;
    end

    if type(cname) == "table" then
        if self.class == cname then
            return true;
        elseif self.super then
            return self.super.IsClass(self.super, cname);
        end
    elseif type(cname) == "string" then
        if self.class.className == cname then
            return true;
        elseif self.super then
            return self.super.IsClass(self.super, cname);
        end
    end
    return false;
end

--- 提供Lua的OOP实现，快速定义一个Class(不支持多重继承)
--- 模拟Class封装，继承，多态，类型信息，构造函数等
--- 模拟一个基础的Class需要的信息
---@param clsname string@类名
---@param super super@父类
---@return Class@含Class所需基本信息的Class table
function Class(clsname, super)
    local classtable = {}
    -- ctor模拟构造函数
    classtable.Ctor = false
    -- className模拟类型信息，负责存储类名
    classtable.className = clsname
    -- super模拟父类
    -- Note: 外部逻辑层不允许直接._super访问父类
    classtable._super = super
    -- 自身class类table
    classtable.class = classtable;
    -- 指定索引元方法__index为自身,模拟类访问
    -- 后面实例化对象时会将classtable作为元表，从而实现访问类封装的数据
    classtable.__index = classtable
    -- 是否是指定类或者继承至某类的方法接口
    classtable.IsClass = IsClass;
    -- 如果指定了父类，通过设置Class的元表为父类模拟继承
    if super then
        setmetatable(classtable, super)
    else
        --print("如果定义的不是最基类，请确认是否require了父类!")
    end
    return classtable
end

--- 提供实例化对象的方法接口
--- 模拟构造函数的递归调用，从最上层父类构造开始调用
---@param cls cls@类定义
---@param ... ...@构造函数变长参数
---@return cls@cls类的实例对象table
function New(cls, ...)
    -- 实例对象表
    local instance = {}
    -- 设置实例对象元表为cls类模拟类的封装访问
    setmetatable(instance, cls)
    -- create模拟面向对象里构造函数的递归调用(从父类开始构造)
    local create
    create = function(cls, ...)
        if cls._super then
            create(cls._super, ...)
        end
        if cls.Ctor then
            cls.Ctor(instance, ...)
        end
    end
    create(cls, ...)
    return instance
end

---静态类
function  StaticClass(clsname)
    return {}
end