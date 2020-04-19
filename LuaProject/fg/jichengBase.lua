--积累方法
--require("class")-- 会先执行它里面的方法 打印 ，不带.lua
function class(className, super)
    local calssTable = {}
    calssTable.Ctor = false
     --构造函数
    calssTable.className = className
    calssTable.super = super
    calssTable.__index = calssTable
    calssTable.IsClass = IsClass
    calssTable.class = calssTable

    if super then
        setmetatable(calssTable, super)
    else
        print("不是类")
    end
    return calssTable
end

function IsClass(s, className)
    if type(s) ~= "table" then
        return false
    end
    if type(className) == "table" then
        if s.class == className then
            print("wwww")
            return true
        elseif s.super then -- 不等于空判断
            return s.super.IsClass(s.super, className)
        end
    elseif type(className) == "string" then
        if s.class.className == className then
            return true
        elseif s.super then
            print("ssss")
            return s.super.IsClass(s.super, className)
        end
    end
    return false
    -- body
end

daTeacher = {}

function daTeacher:new()
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
function daTeacher:Ctor()
    self.count = 1
    self.arg = 23
    self.sName = "daTeacher"
end

daTeacher.IsClass = IsClass
--daTeacher.Ctor() -- .  : 都可以
--print(daTeacher.arg)
--print(daTeacher.IsClass(daTeacher,"daTeacher"))

--teacher={}
teacher = class("teacher", daTeacher)
function teacher:new()
    o = o or {}
    setmetatable(o, self) -- o self  不能写返位置（self,o）是错的
    self.__index = self
     -- 这句可以在上面，但是规范一下
    return o
end

function teacher:Ctor() -- 构造函数
    self.count = 1
    self.arg = 23
    self.sName = "teacher"
end

t = teacher:new()
--print(t)
t:Ctor() -- : Lua里通过.调用的话是不会默认传递自身作为self的，不主动传的话self为空
--Lua里通过:调用的话默认第一个参数就是调用者，既self

--   local 变量名 = New(类名)
--   变量名.成员变量
--   变量名:成员方法()
--   变量名.静态方法()

--print(t.className)
---print(t.IsClass(teacher, "teacher"))

--静态类 返回一个空表
function StaticClass(className)
    return {}
end

function New(cls, ...)
    -- 实例对象表
    local instance = {}
    -- 设置实例对象元表为cls类模拟类的封装访问
    setmetatable(instance, cls)
    -- create模拟面向对象里构造函数的递归调用(从父类开始构造)
    local create
    create = function(cls, ...)
        if cls==nil then
            return
        end
        print("ss")
        if cls.super then
            create(cls.super, ...)
        else
            print("ssdsdsd")
        end
        if cls.Ctor then
            cls.Ctor(instance, ...)
        end
        print("---")
    end
    create(cls, ...)
    return instance
end

banzhang = class("banzhang", teacher)
xs = class("xs", banzhang)
b = New(xs)
print(b.class)
