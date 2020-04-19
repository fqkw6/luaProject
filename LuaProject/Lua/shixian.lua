---@param any class
---param 实现继承
superS = {}
superS.names = "lisi"
function superS:new()
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function class(className, super)
    local classTable = {}
    classTable.Ctor = false
    classTable.className = className
    classTable.super = super
    classTable.class = classTable
    classTable.__index = classTable
    classTable.IsClass = IsClass
    --返回是否是该类型
    if super then -- super 不等nil
        --
        setmetatable(classTable, super)
    else
        print("不是基类")
    end
    return classTable
end

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

function IsClass(s, name)
    if type(s) ~= "table" then
        return false
    end
    print(type(name))
    if type(name) == "table" then --传入的是类
        if s.class == name then
            return true
        elseif s.super then --他的父类是不是
            return s.super:IsClass(s.super, name)
        end
    elseif type(name) == "string" then
        if s.class.className == name then
            return true
        elseif s.supr then
            return s.super:IsClass(s.super, name)
        end
    end
    return false
end
------------------------
student = class("student", superS)
function student:FU(self, arg)
    print(self, "fu", arg)
end
student.FU = FU

function ss(self)
    print("ss")
end

function func(self) --
    print(self)

    function teacher:FUZi(self, arg, ...)
        print(self, "zi", arg)
    end
    return xuesheng
end

xuesheng = New(student)
teacher = class("teacher", xuesheng)

print(student, "xuesheng", xuesheng)
xuesheng.ss = ss
xuesheng.ss()

laoshi = New(teacher)
laoshi.func = func
laoshi.FUZI = FuZi
print(laoshi)

laoshi:func()
laoshi:func():ss("xx")
--teacher.FUZi("ww")
--teacher:FUZi("yy")

--print(type("student").."---=-=-=-=-=")
--print(superS)
--student.name="zhangsan"
--(student.super)
--print(student.className)
--print(student.IsClass(student, "student"))
--print(type("student"))
print("请输入")
local value = io.read() -- 等待输入，即生产数据
print(value)
