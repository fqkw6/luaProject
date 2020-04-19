--[[
协程

]]
--创建协程
co = coroutine .create( --返回是coroutine
    function(i)--不能有方法名
    print(i.."create")
    end
)
print(co) --thread 类型
coroutine.resume(co,1) --重启协程 配合 create 使用
print(coroutine.status(co).."=status")--dead
 
co=coroutine.wrap( --返回的是 function  同craete
    function (i)
    print(i.."wrap")
    end
)

co(2)

co2=coroutine.create(
function ()
  --  index=0
    for i = 1, 5 do
       -- index=index+1
       print(i)
        if i==3 then
            print(coroutine.status(co2))
           print(coroutine.running())
        coroutine.yield()--跳出 

        end
        
    end
    -- body
end)
coroutine.resume(co2) --每次执行一次 i 
coroutine.resume(co2)
--coroutine.resume(co2)


local newProductor

function productor()
     local i = 0
     while i<10 do
          i = i + 1
          send(i)     -- 将生产的物品发送给消费者
     end
end

function consumer()
    m=10
     while m>0 do
          local i = receive()     -- 从生产者那里得到物品
          m=m-1
          print(i)
     end
end

function receive()
     local status, value = coroutine.resume(newProductor)
     return value
end

function send(x)
     coroutine.yield(x)     -- x表示需要发送的值，值返回以后，就挂起该协同程序
end

-- 启动程序
newProductor = coroutine.create(productor)
consumer()