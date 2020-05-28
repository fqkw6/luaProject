require("kl.BaseClass")
Singleton = require("kl.Singleton")
---@class Maager:Singleton
local Maager = BaseClass("Maager", Singleton)

function Maager:__init()
    -- body
    print(self)
end

function Maager:Open(arg)
    -- body
    print(self, "hkhk", arg)
end

return Maager
