-- 打印协程1和协程2的状态
function status()
    print("co1's status :" .. coroutine.status(co1) .. " ,co2's status: " .. coroutine.status(co2))
end

-- 协程1
co1 =
    coroutine.create(
    function(a)
        print("co1 arg is :" .. a)
        status()

        -- 唤醒协程2
        local stat, rere = coroutine.resume(co2, "2")
        print("111 co2 resume's return is " .. rere)
        status()

        -- 再次唤醒协程2
        local stat2, rere2 = coroutine.resume(co2, "4")
        print("222 co2 resume's return is " .. rere2)
        local arg = coroutine.yield("6")
    end
)

-- 协程2
co2 =
    coroutine.create(
    function(a)
        print("co2 arg is :" .. a)
        status()
        local rey = coroutine.yield("3")
        print("co2 yeild's return is " .. rey)
        status()
        coroutine.yield("5")
    end
)

--主线程执行协程co1,传入字符串“main thread arg”
stat, mainre = coroutine.resume(co1, "main thread arg")
status()
print("last return is " .. mainre)
------------------------------
-- 生产者协程，负责产生数据（由控制台输入），然后挂起协程，把值传递给过滤器协程
index = 10
produceFunc = function()
    while index > 0 do
        index = index - 1
        local value = io.read() -- 等待输入，即生产数据
        print("produce: ", value)
        coroutine.yield(value) -- 挂起本生产者协程，返回生产的值
    end
end
index2 = 10
-- 过滤器协程，唤醒生产者协程，等待其产生数据，得到数据后，负责把数据放大100倍，然后挂起协程，把值传递给消费者函数
filteFunc = function(p)
    while index2 > 0 do
        index2 = index2 - 1
        local status, value = coroutine.resume(p) -- 唤醒生产者协程，直到其返回数据
        value = value * 100 -- 把数据放大100倍
        print("filte: 	", value)
        coroutine.yield(value) -- 挂起本过滤器协程，返回处理后的值
    end
end

-- 消费者，只是个函数，并非协程，while一直调用，即一直唤醒过滤器协程
consumer = function(f, p)
    while true do
        local status, value = coroutine.resume(f, p) --唤醒过滤器协程，参数是生产者协程
        print("consume: ", value) -- 打印出得到的值，即消费
    end
end

--备注：
-- 1. 消费者驱动的设计，也就是消费者需要产品时找生产者请求，生产者完成生产后提供给消费者
-- 2. 这里做了中间的过滤器协程，即消费者函数找过滤器协程，过滤器协程找生产者协程，等待其返回数据，再原路返回，传递给消费者函数，while一直循环

-- 生产者协程
producer = coroutine.create(produceFunc)

--过滤器协程
filter = coroutine.create(filteFunc)

-- 消费者函数，传入过滤器协程和生产者协程
consumer(filter, producer)
