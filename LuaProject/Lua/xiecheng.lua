function foo(a)
    print("foo", a)
    return coroutine.yield(2 * a)
end
--闭包
co =
    coroutine.create(
    function(a, b)
        print("co-first", a, b)
        local r = foo(a)

        print("co-second", r, a, b)
        a = a + 1
        local r, s = coroutine.yield(a + b, a - b)
        print("co-last", r, s)
        return b, "end"
    end
)

print("main", coroutine.resume(co, 1, 10))
print("-----------------------")

print("main", coroutine.resume(co, 3211, 3310))
print("-----------------------")

print("main", coroutine.resume(co, "mm"))
print("-----------------------")
print("main", coroutine.resume(co, "x", "y"))
print("-----------------------")
print("main", coroutine.resume(co, "x", "y"))
