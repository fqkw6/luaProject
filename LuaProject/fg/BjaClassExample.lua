----- 完整的类（BjaClass演示示例）
BjaClass = require("BjaClass")
do
    --- 创建一个类（作为基类）
    People = BjaClass.MakeClass()

    --- 创建构造器
    local cotr = function(class,name,age,id)
        --- 创建对象（函数结束一定要返回它）
        local obj = BjaClass.MakeObj(class)

        People.counter = People.counter + 1

        --- 公有成员
        obj.name = name or "none"
        obj.age = age or 0

        --- 私有成员
        obj.private._tag = "peop"
        obj.private._id = id or People.counter

        --- 返回对象
        return obj
    end
    BjaClass.MakeCtor(People,cotr)

    --- 静态变量
    People.counter = 0  -- 公有
    People.privateStatic._type = "people"  -- 私有

    --- 静态方法
    People.ShowCount = function(self)print("People 的数量是 " .. self.counter) end    -- 公有
    People.GetType = function(self)return self.privateStatic._type end    -- 公有

    --- 公有成员方法
    function People:introduce()
        if self == People then
            error("不能通过类直接调用非静态成员！")
            return nil
        end
        local format = "我叫%s，今年%d岁!"
        print(format:format(self.name,self.age))
    end
    function People:getId()
        if self == People then
            error("不能通过类直接调用非静态成员！")
            return nil
        end
        return self.private._id
    end
    function People:getTag()
        if self == People then
            error("不能通过类直接调用非静态成员！")
            return nil
        end
        return self.private._tag
    end

    --- 运算符重载
    People.__add = function(obj1,obj2)
        if obj1.age and obj2.age then
            return obj1.age + obj2.age
        end
        return nil
    end
    People.__lt = function(obj1,obj2)
        local num1,num2 = 0,0
        if type(obj1)=="number"  then
            num1 = obj1
        else
            num1= obj1.age
        end
        if type(obj2)=="number"  then
            num2 = obj2
        else
            num2= obj2.age
        end


        return (num1 < num2)
    end

end

do
    --- 创建一个类（派生至People）
    Programmer = BjaClass.MakeClass(People)

    --- 创建构造器
    local cotr = function(class,name,age,id)
        --- 创建对象（函数结束一定要返回它）
        local obj = BjaClass.MakeObj(class,name,age,id)

        --- 公有成员
        obj.career = "Unity3D程序员"

        --- 重写私有成员
        obj.private._tag = "prog"

        --- 返回对象
        return obj
    end
    BjaClass.MakeCtor(Programmer,cotr)

    --- 重写静态变量
    Programmer.privateStatic._type = "programmer"  -- 私有

    --- 重写公有成员方法
    function Programmer:introduce()
        if self == Programmer then
            error("不能通过类直接调用非静态成员！")
            return nil
        end
        local format = "我叫%s，今年%d岁，是一名%s!"
        print(format:format(self.name,self.age,self.career))
    end

end

do
    print("\n\n==================== 《示例测试》 ====================")

    print("（1）")
    boy = People("BeiJiaan",25)
    boy:introduce()                                     --> 我叫BeiJiaan，今年25岁!
    People:ShowCount()                                  --> People 的数量是 1
    print("People的Type = " .. boy:GetType())     --> People的Type = people
    print("boy的Id = " .. boy:getId())               --> boy的Id = 1
    print("boy的Tag = " .. boy:getTag())             --> boy的Tag = peop

    print("（2）")
    beijiaan = Programmer("贝哥哥",25)
    beijiaan:introduce()                                    --> 我叫贝哥哥，今年25岁，是一名Unity3D程序员!
    Programmer:ShowCount()                                  --> People 的数量是 2
    print("Programmer的Type = " .. beijiaan:GetType()) --> Programmer的Type = programmer
    print("beijiaan的Id = " .. beijiaan:getId())         --> beijiaan的Id = 2
    print("beijiaan的Tag = " .. beijiaan:getTag())       --> beijiaan的Tag = prog

    print("（3）")
    print("boy's age + beijiaan's age = " .. boy + beijiaan)  --> boy's age + beijiaan's age = 50.0
    print("beijiaan's age + boy's age = " .. beijiaan + boy)  --> beijiaan's age + boy's age = 50.0

    print("boy's age > 30？ " .. tostring(boy > 30))       --> boy's age < 30？ false
  --  print("beijiaan's age > 30？ " .. tostring(beijiaan > 30))   --> 报错！！！attempt to compare number with table
end