function test()
    local i = 0
    return function()
        --尾调用
        i = i + 1
        return i
    end
end
c1 = test()
c2 = test()
--,c2是建立在同一个函数，同一个局部变量的不同实例上面的两个不同的闭包
--闭包中的upvalue各自独立，调用一次test（）就会产生一个新的闭包
-- print(c1()) -->1
-- print(c1()) -->2//重复调用时每一个调用都会记住上一次调用后的值，就是说i=1了已经
-- print(c2()) -->1//闭包不同所以upvalue不同
-- print(c2()) -->

function Closure()
    local ival = 10 --upvalue
    function InnerFun1()
        --内嵌函数
        ival = ival + 1
        print(ival)
    end

    function InnerFun2()
        print("Before", ival)
        ival = ival + 10
        print("After", ival)
    end

    return InnerFun1, InnerFun2
end

--将函数赋值给变量，此时变量a绑定了函数InnerFun1,b绑定了函数InnerFun2
local a, b = Closure()
InnerFun1()
 --也可以直接调用
InnerFun2()
--调用a
-- a()

-- --调用b
-- b()
