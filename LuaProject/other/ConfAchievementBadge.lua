--<summary>
--Generated from Achievement.xlsx
 --int  sn
 --String  name
 --String  icon
--</summary>

local array = nil
local bReadAll = false
local ConfAchievementBadge = {}


function ConfAchievementBadge.AddItem(db)
  local item = {}
          item.sn = db[1]
          item.name = db[2]
          item.icon = db[3]
          item.points = db[4]
    return item
end

function ConfAchievementBadge.Get(id)
	if array == nil then
        array = {}
    end
    if array[id] == nil then
       local data = DB.GetData("ConfAchievementBadge",id)
       if data ~= nil then
          array[id] = ConfAchievementBadge.AddItem(data)
       end
    end
    return array[id]
end

function ConfAchievementBadge.GetFirstCondition(filename,filevalue)
    if array == nil then
        array = {}
    end

    for i,v in pairs(array) do
        if v[filename] == filevalue then
            return v
        end
    end

    local data = ConfAchievementBadge.GetAllConditions(filename,filevalue)
    if data ~= nil and #data >= 1 then
       return data[1]
    end    
    return nil
end

--search from db
function ConfAchievementBadge.GetAllConditions(filename,filevalue)
    local datas = DB.GetDataCondition("ConfAchievementBadge",filename,filevalue)

    if datas == nil then
        return nil
    end

    if array == nil then
        array = {}
    end

    local info
    local infos = {}
    for i = 1,#datas do
        info = ConfAchievementBadge.AddItem(datas[i])
        array[info.sn] = info
        infos[#infos + 1] = info
    end
    return infos
end

function ConfAchievementBadge.GetAll()
    if bReadAll then
        return array
    end
    bReadAll = true

    if array == nil then
        array = {}
    end

    local arr = DB.GetTable("ConfAchievementBadge")
    local info 
    for i = 1,#arr do
        info = ConfAchievementBadge.AddItem(arr[i])
        array[info.sn] = info
    end
    return array
end
return ConfAchievementBadge