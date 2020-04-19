--[[

]]
tr={key=1,ket=0}
print(tr.ket)
print(11)

mytable={}
--元表
--[[
mymm={}
setmetatable(mytable,mymm)

--元方法
mytable=setmetatable({},{
    __index=function()
    end
})
]]

---
mytable.Ctor=false --可以直接声明
mytable.className="erer"
print(mytable.className)--打印为空
