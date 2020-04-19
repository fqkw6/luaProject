--[[
module 
table
]]
tablenum={}
--缺少index 3 时，插入在这之前 其余后排，再次删除的时候 1，3 之后的不会向前加一
tablenum[1]=90
tablenum[2]=9
tablenum["key"]=22
tablenum[4]=88
tablenum[5]=33
--alitrer=tablenum
--alitrer[1]=89 --表是引用类型
--只能通过 [] 索引 ，不能.出来
--print(tablenum[1])

alitrer={}
alitrer[1]=tablenum[1] --表是引用类型
alitrer[1]=89
--print(tablenum[1])

table.insert(tablenum,1,78); --插入某个位置index  在index 1处插入 
--print(tablenum[1])

table.remove(tablenum,2);--删除某个位置index  在index 1处删除
--print(tablenum[1])

--table.sort(tablenum)--升序排序

--print(#tablenum)--长度为2  缺少时中断计数  
--获取长度可以用这个方法
leng=0
for key, value in pairs(tablenum) do
    print(key.."=="..value)
    leng=leng+1
end
print(leng)

putong={key="156565",key2="2",key3=3}--能通过 [] 索引 ，能.出来
print(putong.key)

-- f={}
-- f=nil
-- if f then
--   print("不等于空")
-- end
