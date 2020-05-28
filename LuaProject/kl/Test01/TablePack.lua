require("kl.BaseClass")
--biao = require("kl.bibao")
---@class TabelPack
local TabelPack = BaseClass("TabelPack")

local unpack = unpack or table.unpack
local tableK = {21, 3, 4, 52}
function leng(...)
    len = select("#", ...)
    return len
end

-- print(leng("tableK", 1))
local jieshou
jieshou = unpack(tableK, 1, 4)
-- print(jieshou .. "ssd")
function Bianli(...)
    -- print(leng(...))
end
Bianli(unpack(tableK, 1, 4))

local function a(str)
    print(str)
end
local function b(str)
    print(str)
end
local function c(str)
    print(str)
end
local function d(str)
    -- print(str)
end
events = {a, b, c, d}

for k, v in pairs(events) do
    -- print(k, v)
    -- v("ssdsd")
end

ts = {1, 3, 2}
--print(table.concat(ts, ", "))
-- print(#ts)
-- print(ts[3])

-- a = {}
-- x = "name"
-- a[x] = "lua"
-- print(a.x) -- 对于a["x"]是不存在
-- -->> nil
-- print(a[x])
-- -->> lua
-- print(a.name)
-- -->> lua

-- local bss = {
--     x = "name",
--     c = "luaaa"
-- }
-- print(bss.x)
-- biao:Tets_ppp()

local a = table.pack("ray", {1, 2, 3}, "hh", {name = "hh"})
---"n=a.n"会插入到最后
print(a.n)
--table.pack 之后才有的n

for i, v in pairs(a) do
    if type(v) ~= "table" then
        print(i, v)
    else
        for j, val in pairs(v) do -- 这里只是演示，不考虑更多层数组嵌套
            -- print(i, j, val)
        end
    end
end

return TabelPack
