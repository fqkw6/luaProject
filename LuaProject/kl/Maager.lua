require("BaseClass")
Singleton = require("Singleton")
local Maager = BaseClass("Maager", Singleton)

function __init(self)
    -- body
    print(self)
end

function Open(self, arg)
    -- body
    print(self, "hkhk", arg)
end

Maager.Open = Open
Maager.__init = __init
return Maager
