--[[
1基础语法
if for while 
--]]

print(11)

b=false--全局变量

print(type(b))

local a=9--本地变量

--function
function joke()
a=a+1
print(a)
end
--excute
joke()
print(type(joke))-- function

--单行注释

--[[
多行注释
]]

--字符
strw="dfdfd"
srrr="dddd"
print(strw)
print(strw..srrr)--..链接字符
print(str)--没有声明前引用为 nil 
--换行
str=[[a
"ssd
add"
]]

print(str)

--多次声明
a,b,c=1,1,1
print(a,b,c)

function fangfa()
print("fangfa")
end

f=fangfa()
--f() 报错

--while
i=10
while(i>0)
do--必须有，前面无法内容
i=i-1
--print(i.."while")
end

--for
for i=10,0,-1 do--默认 +1
if(i == 5)
then
print("小于5")
break--  没有 continue
end
print(i.."for")

end

--实现continue
for i = 10, 1, -1 do
  repeat
    if i == 5 then
      print("continue code here")
      break
    end
   -- print(i, "loop code here")
  until true
end

function ff(x)
print("function")
return x-1 --返回值
end

for i=1,ff(10)do--for i=1,9,1 do
--print (i)
end

tablew={"a","b","c",11}
for i,v in ipairs (tablew) do
--print(v)
end

--tabel
tablem={}
tablem[1]="a"
tablem[2]="b"
tablem[3]="c"
tablem["key"]="d"

--遍历table

for o,l in pairs (tablem) do-- o l  pairs遍历所有  ipairs遍历 index 1,2,3 
--print(o..l)
end

--repeat
aa=10
repeat  --C# while do
--print("aa==="..aa)-- ,红色log
aa=aa+1--  ++
until(aa>16)


-- if else
opop=90;
if(opop>100)--if(0) 0为true
then--必须then
print(opop)
elseif(opop>80)
then--必须then
print("大于80")
else
print("jinlai")
end

--运算符

fg=9
fh=8
if( not (fg==fh) ) --not ==!
then
print("等于")
elseif(fg~=fh)
then
print("不等于")
elseif(fg>=fh)
then
print("大于等于")
elseif(fg>0 and fh>0)
then
print("and")
elseif(fg>0 or fh>0)
then
print(" huozhe ")
else--可以省略else
end


hello="hello"
print(#hello)
