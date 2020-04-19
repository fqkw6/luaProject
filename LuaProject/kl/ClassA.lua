--Lua 类内函数声明的方法与之间的区别

ClassA = {}

ClassA.TestFunction_A = function()
    --无语法糖
    print(self)
    print("This is Function_A")
end

function ClassA:TestFunction_B() --有语法糖
    print(self)
    print("This is Function_B")
end

ClassA.TestFunction_C = nil --无语法糖

function TestFunction_D()
    print(self)
    print("This is Function D")
end

ClassA.TestFunction_C = TestFunction_D

ClassA:TestFunction_A(ClassA)
ClassA:TestFunction_B()
ClassA:TestFunction_C()
-- . 方法不传人self ： 号传入self (默认方法的第一个参数是谁调用的就传谁)
print("-----------------------")
ClassA.TestFunction_A(ClassA)
ClassA.TestFunction_B()
ClassA.TestFunction_C()
