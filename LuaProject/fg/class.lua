--[[
面向对象
talbe 可以模拟类  类 type()==userdata 表示任意存储在变量中的C数据结构
]]

mytable={} --普通表
mymetatable={}--元表 还是表 元表里面写操作
setmetatable(mytable,mymetatable)

-- 类

Person={name="zhangsan",arg=12}
--[[
function Person:new()-- 无参数的构造函数  可以说省略
    o=o or {} 
    setmetatable(o,self)--元表
    self.__index=self
    return o
end
]]


function Person:new(name,arg)-- 参数的构造函数 
    o=o or {} 
    setmetatable(o,self)--元表
    self.__index=self
    self.name=name or ""
    self.arg=arg or 0
    return o
end
function Person :printName() -- 普通方法
    print(self.name)
    print("-----")
end
--[[


]]

w=Person:new()
print(w)
w.name="lisi"
w:printName()

p=Person:new("ww",l)
print(p) -- 无参数的在上面  打印出来和w一样 table 类型
p:printName()


q=Person:new()
print(q)-- 无参数的在上面  打印出来是新的  三个表的地址一样
q.name="dd"
q:printName()


---特别注意 .属性 ： 方法 .静态方法
-- 继承

Student=Person:new()

function Student:new(name,arg)

    o= o or Person:new(name,arg)
    setmetatable(o,self)
    self.__index=self

return o
end

--[[


]]
function Student :printName() -- 重写方法
   print(self.name)
    print("-----")
end

s=Student:new()
s.name="s"
s:printName() --不能直接调用父类的方法

sd=Student:new("kkk",9)
sd.name="sd"
sd:printName()


sm=Student:new()
sm.name="sm"
sm:printName()

