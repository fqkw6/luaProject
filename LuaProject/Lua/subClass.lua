require("BaseClass01")

--声明了新的属性Z
SubClass = {z = 0}
--设置元表为Class
setmetatable(SubClass, BaseClass01)
--还是和类定义一样，表索引设定为自身
SubClass.__index = SubClass
--这里是构造方法
function SubClass:new(x, y, z)
    local self = {} --初始化对象自身
    self = BaseClass01:new(x, y) --将对象自身设定为父类，这个语句相当于其他语言的super ，可以理解为调用父类的构造函数
    setmetatable(self, SubClass) --将对象自身元表设定为SubClass类
    self.z = z --新的属性初始化，如果没有将会按照声明=0
    return self
end

--定义一个新的方法
function SubClass:go()
    self.x = self.x + 10
end

--重定义父类的方法，相当于override
function SubClass:test()
    print(self.x, self.y, self.z)
end

local a = BaseClass01:new() -- 首先实例化父类的对象，并调用父类中的方法
a:plus()
a:test()

local b = SubClass:new() -- 然后实例化子类对象
b:plus() -- 子类对象可以访问到父类中的成员和方法
b:go() -- 子类对象调用子类中的新增方法
b:test() -- 子类对象调用重写的方法
print(a, b)
--不是同个表
