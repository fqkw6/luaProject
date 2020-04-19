
function Aciton(a,b,...)
   local call=...
    if call~=nil then
       call(a,b)
       print(1)
    end
end

function cashu(a,b)
   print("weituo"..a..b)
end
Aciton(1,34,cashu)

