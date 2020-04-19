--[[
    function func()
        -- body
    end
]]
require("module")--引用同目录下的 （同一个根目录）

print("sss")

function kebian(...)-- ...表示可变参数
   --print(type(...))-- 类型
   aaaa=select("#",...) --- select("#",...)  可变参数的数量
   --print(select("#",...))--
 
   for i = 1, aaaa do
     local arg=select(i,...) --获取可变参数
     if type(arg)=="table" then-- 类型是字符串
        print(arg,"arg") 
    for key, value in pairs(arg) do
    print(value .."==table===")
 end
     end
   end

end

kebian({1,2,3})
--kebian(1,2,3)
--kebian(1)

--固定加可变参数 x 固定
function guding(x,...)
    
end

function duo_out(x,y)
   return x,y
end
print(duo_out(1,2))-- 多个返回值，不是数组

print(hello)--调用 test.lua 的全局变量

---字符串
strss="hello world"
string.len(strss)
string.upper(strss)
string.format("sss:%d",4)

--数组 一维
array1={"learn","lua"}
index01=array1[1] --从下标1开始

print(index01)

--数组 二维 
array01 ={"1ss",{12,2}}
print(array01[2][1])

function iter (a, i)
    i = i + 1
    local v = a[i]
    if v then
       return i, v
    end
end
 
function ipairs (a)
    return iter, a, 0
end