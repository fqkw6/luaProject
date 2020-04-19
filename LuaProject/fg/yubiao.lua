mytable={} --普通表
mymetatable={}--元表 还是表 元表里面写操作
setmetatable(mytable,mymetatable)

--[[

在 Lua table 中我们可以访问对应的key来得到value值，但是却无法对两个 table 进行操作。

因此 Lua 提供了元表(Metatable)，允许我们改变table的行为，每个行为关联了对应的元方法。

例如，使用元表我们可以定义Lua如何计算两个table的相加操作a+b。

当Lua试图对两个表进行相加时，先检查两者之一是否有元表，之后检查是否有一个叫"__add"的字段，若找到，则调用对应的值。"__add"等即时字段，其对应的值（往往是一个函数或是table）就是"元方法"。

有两个很重要的函数来处理元表：

]]


mytable=setmetatable({},{}) --setmetatable
print(type(mymetatable)) -- table

getmetatable(mytable) -- getmetatable

mytable = setmetatable({key1 = "value1"}, {
  __index = function(mytable, key)
    if key == "key2" then
      return "metatablevalue"
    else
      return nil
    end
  end
})
print(mytable.key1,mytable.key2)

--mytable=setmetatable({key1="value1"},{__index={key2="metatablevalue"}})
print(mytable.key1,mytable.key2)
print(mytable.key3)---没有的key 是nil
--[[
mytable 表赋值为 {key1 = "value1"}。

mytable 设置了元表，元方法为 __index。

在mytable表中查找 key1，如果找到，返回该元素，找不到则继续。

在mytable表中查找 key2，如果找到，返回 metatablevalue，找不到则继续。

判断元表有没有__index方法，如果__index方法是一个函数，则调用该函数。

元方法中查看是否传入 "key2" 键的参数（mytable.key2已设置），
如果传入 "key2" 参数返回 "metatablevalue"，否则返回 mytable 对应的键值。
--]]

-- __newindex 元方法用来对表更新，__index则用来对表访问 。

mymetatable = {}
mytable = setmetatable({key1 = "value1"}, { __newindex = mymetatable })

print(mytable.key1) --元表后可以点出来

mytable.newkey = "新值2"-- 表里没有 去元表找  设置元方法 __newindex，
--在对新索引键（newkey）赋值时（mytable.newkey = "新值2"），会调用元方法，而不进行赋值
print(mytable.newkey,mymetatable.newkey)

mytable={1,2,3}
second={4,5,6}
--mytable= mytable+second --不能直接相加
mytable=setmetatable({1,2,3},
{
    __add=function(mytable,nre)
    len=#mytable
       for i = 1,len do
        table.insert(mytable,len+1,nre[i])
           -- body
       end
       return mytable
    end

})
mytable= mytable+second --可以相加了

for key, value in pairs(mytable) do
 -- print(value.."===xinde")
end

mytable={1,1,1}
mytable=setmetatable(mytable,{
__call=function(mytable,neerr)--调用另一个表的操作
    sum=0;
    print("ssss")
    for key, value in pairs(mytable) do
       sum=sum+value
    end
    for key, value in pairs(neerr) do
        sum=sum+value
     end
     return sum
end

})

print(mytable({2}))

mytable = setmetatable({ 10, 20, 30 }, {
  __tostring = function(mytable)--输出作用
    sum = 0
    for k, v in pairs(mytable) do
                sum = sum + v
        end
    return "表所有元素的和为 " .. sum
  end
})
print(mytable)