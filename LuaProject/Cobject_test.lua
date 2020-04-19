require("Cobject")

function People(o)
    local this = Cobject:base()

    --添加公有属性
    local public =
        this:publics(
        {
            key = "chushi",
            key1 = "chushi2"
        }
    )
    --静态属性
    local Static = this:static(People, {area = "地区"})
    --添加私有属性
    local private = {qian = "qian"}
    this:base(o)
    function public:Say()
        print(this.key)
    end

    return this
end

function Man(o)
    local this = People(o)
    local public = this:publics({layer=true})
    this:base(o)
    function public:Say()
        print("我是"..this.key)
        print(this.layer)
    end
    return this
end

m1=Man({key="男"})
p1=People({key="人的基类"})
print(1)
m1:Say()

print(m1.area)
print(GetStatic(People).area)