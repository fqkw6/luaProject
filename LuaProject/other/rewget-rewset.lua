assert(true, "sssss")
--不异常
a = "ww"
--assert(false,a.."sssss")--异常 提示信息

-- 当你通过键来访问 table 的时候，如果这个键没有值，
-- 那么Lua就会寻找该table的metatable（假定有metatable）
-- 中的__index 键。如果__index包含一个表格，
-- Lua会在表格中查找相应的键。
--rawget 不去找————index的值了

-- 当你给表的一个缺少的索引赋值，
-- 解释器就会查找__newindex 元方法：
-- 如果存在则调用这个函数而不进行赋值操作。
--rawset 解决这个，直接赋值

-- 当我们只想单纯的调用table里的字段或者给table字段赋值时，
-- 我们可以通过rawget函数来忽略元表的__index作用，只从table中

local father = {
    house = 1,
    sayHello = function()
        print("大家好，我是father.")
    end
}

local temp = {
    __index = father,
    __newindex = function(table, key)
        print(key .. "字段是不存在的，不允许给它赋值！")
    end
}

son = {
    car = 1
}
setmetatable(son, temp) --把son的metatable设置为father
print(rawget(son, "house"))
-- 不去 ————index 里面找
print(rawget(son, "car"))
rawset(son, "house", "10")
--赋值到表里，不是元表
rawset( --赋值方法
    son,
    "sayHello",
    function()
        print("============")
    end
)
print(son.house)
son.sayHello()

----另一个例子
local function readOnly(t)
    local newT = {}
    local mt = {
        __index = t,
        __newindex = function()
            print("别修改我！我是只读的！")
        end
    }
    setmetatable(newT, mt)
    return newT
end
local days = readOnly({"星期一", "星期二", "星期日"})

days[2] = "星期三哪去了啊？"
