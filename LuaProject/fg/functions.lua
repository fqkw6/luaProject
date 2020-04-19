--------------------------------------------------------------------------------
--  FILE:  functions.lua
--  DESCRIPTION:  定义一些高频的全局函数
--------------------------------------------------------------------------------
local _G = _G

-- print error

function print_error(fmt, ...)
    local args = { ...}
    print(string.format("<color=#ff0000>%s</color>", string.format(fmt, unpack(args))))
end

-- end print error

local hasLuaDebugStated = false
local luaDebugTimer = nil
local stopDebugFun = nil
function StartLuaDebug(ip,port)
    if hasLuaDebugStated == true then
        print("lua debug had started")
        return
    end
    local breakInfoFun,stopFun = require ("LuaDebug")(ip, port)
    if breakInfoFun == nil then
        print("start lua debug failed")
        return
    end
    stopDebugFun = stopFun
    hasLuaDebugStated = true
    luaDebugTimer = Timer.New(function() breakInfoFun() end, 1, -1, false) 
    luaDebugTimer:Start()
    print("start lua debug succeed")
end

function StopLuaDebug()
    print("stop lua debug")
    hasLuaDebugStated = false
    if luaDebugTimer ~= nil then
        luaDebugTimer:Stop()
    end
    luaDebugTimer = nil
    if stopDebugFun ~= nil then
        stopDebugFun()
    end
    stopDebugFun = nil
    print("stop lua debug succeed")
end




-- load
function load_pack(path)
    return package.loaded[path] or require(path)
end

-- 输出提示--
-- 倒计时界面。倒计时用times 或者显示文本并倒计时消失 msgtxt
function ShowCountDown(times, msgtxt, msgtime, icon, callback, _bBullet)
    UIMgr:onHideView(_G.UINames.UI_CountDown)
    UIMgr:ShowView(UINames.UI_CountDown, { num = times, msg = msgtxt, time = msgtime, icon = icon, callback = callback, bBullet = _bBullet })
end

-- 输出提示--
-- 纯提示框。只有确认按钮，无状态返回
function ShowSingleConfirmBox(msg, _determineCallBack, _oktime, _okTxt)
    UIMgr:ShowView(UINames.UI_SingleConfirm, { content = msg, okcall = _determineCallBack, oktime = _oktime, oktxt = _okTxt })
end

-- 输出提示--
-- 纯提示框。只有确认按钮，无状态返回
function ShowSingleConfirmBoxWithoutClose(msg, _determineCallBack, _oktime, _okTxt, _hideBtnClose)
    UIMgr:ShowView(UINames.UI_SingleConfirm, { content = msg, okcall = _determineCallBack, oktime = _oktime, oktxt = _okTxt, hideBtnClose = _hideBtnClose })
end

-- 确认框。可以注册 确认 取消 关闭 按钮 点击回调
function ShowConfirmBox(msg, _determineCallBack, _cancelCallBack, _closeCallBack)
    UIMgr:onHideView(_G.UINames.UI_Confirm)
    local promptView = UIMgr:ShowView(UINames.UI_Confirm,
    { content = msg, okcall = _determineCallBack, cancelcall = _cancelCallBack, closecall = _closeCallBack })
    -- promptView:SetMsg(msg, _determineCallBack, _cancelCallBack, _closeCallBack)
end

-- 确认框。可以注册 确认 取消 关闭 按钮 点击回调
function ShowConfirmBoxWithoutClose(msg, _determineCallBack, _cancelCallBack, _closeCallBack, _hideBtnClose)
    UIMgr:onHideView(_G.UINames.UI_Confirm)
    local promptView = UIMgr:ShowView(UINames.UI_Confirm,
    { content = msg, okcall = _determineCallBack, cancelcall = _cancelCallBack, closecall = _closeCallBack, hideBtnClose = _hideBtnClose })
    -- promptView:SetMsg(msg, _determineCallBack, _cancelCallBack, _closeCallBack)
end

-- 确认框。可以注册 确认 取消 关闭 按钮 点击回调
function ShowConfirmBoxWithCheck(msg, checkText, _determineCallBack, _cancelCallBack, _closeCallBack, _reasonType)
    UIMgr:onHideView(_G.UINames.UI_ConfirmWithCheck)
    local promptView = UIMgr:ShowView(UINames.UI_ConfirmWithCheck,
    { content = msg, checkText = checkText, okcall = _determineCallBack, cancelcall = _cancelCallBack, closecall = _closeCallBack, reasonType = _reasonType })
end

-- 确认框。可以注册 确认 取消 关闭 按钮 点击回调
function ShowConfirmBoxExWithCheck(msg, checkText, _determineCallBack, _cancelCallBack, _closeCallBack, _reasonType, _determineTxt, _cancelTxt)
    UIMgr:onHideView(_G.UINames.UI_ConfirmWithCheck)
    local promptView = UIMgr:ShowView(UINames.UI_ConfirmWithCheck,
    { content = msg, checkText = checkText, okcall = _determineCallBack, cancelcall = _cancelCallBack, closecall = _closeCallBack, reasonType = _reasonType ,oktxt = _determineTxt, canceltxt = _cancelTxt})
end

-- 上面确认框的扩展。可以自定义 确认， 取消两个按钮的文字，按钮文字不修改，传入nil，不要传入""
function ShowConfirmBoxEx(msg, _determineTxt, _determineCallBack, _cancelTxt, _cancelCallBack, _closeCallBack)
    UIMgr:onHideView(_G.UINames.UI_Confirm)
    local promptView = UIMgr:ShowView(UINames.UI_Confirm,
    { content = msg, oktxt = _determineTxt, canceltxt = _cancelTxt, okcall = _determineCallBack, cancelcall = _cancelCallBack, closecall = _closeCallBack });
end

-- 上面确认框的扩展。可以自定义 确认， 取消两个按钮的文字，按钮文字不修改，传入nil，不要传入""
function ShowConfirmBoxExAuto(msg, _determineTxt, _determineCallBack, _cancelTxt, _cancelCallBack, _closeCallBack, _oktime, _canceltime)
    UIMgr:onHideView(_G.UINames.UI_Confirm)
    local promptView = UIMgr:ShowView(UINames.UI_Confirm,
    {content = msg, oktxt = _determineTxt, canceltxt = _cancelTxt, okcall = _determineCallBack, 
    cancelcall = _cancelCallBack, closecall = _closeCallBack, oktime = _oktime, canceltime = _canceltime});
end

-- 带输入框的通用对话框。可以自定义 确认， 取消两个按钮的文字，最大字符（<=0的数是不限制字符长度的），输入框中默认的文字。想保持默认属性的都传入 传入nil，不要传入""， _determineCallBack 是个 func(string) 的函数，注意入口参数
function ShowInputConfirmBox(msg, _determineTxt, _determineCallBack, _cancelTxt, _cancelCallBack, _closeCallBack, _inputMaxChar, _defaultTxt)
    local promptView = UIMgr:ShowView(UINames.UI_Input_Confirm);
    if (_determineTxt ~= nil) then
        promptView:SetDetermineText(_determineTxt)
    end
    if (_cancelTxt ~= nil) then
        promptView:SetCancelText(_cancelTxt)
    end
    promptView:SetMsg(msg, _determineCallBack, _cancelCallBack, _closeCallBack)
    promptView:SetInput(_inputMaxChar, _defaultTxt)
end

function ShowUIConfirmRewardItem(listitem, _title, _btntxt, _btnenable, _func)
    UIMgr:ShowView(UINames.UI_ConfirmRewardItem, { items = listitem, title = _title, btntxt = _btntxt, btnenable = _btnenable, func = _func });
end

function ShowHolidayUIConfirmRewardItem(listitem, _title, _btntxt, _btnenable, _func)
    UIMgr:ShowView(UINames.UI_HolidayConfirmRewardItem, { items = listitem, title = _title, btntxt = _btntxt, btnenable = _btnenable, func = _func });
end

function show_message(msg)
    if msg and #msg ~= 0 then
        MainTipsMgr:ShowSysMsg(msg)
        -- MessageUILogic.ShowMessage(msg)
    end
end

function show_rewards(rewards)
    if type(rewards) ~= "table" then
        logError("reward not a table.")
    else
        local sns = { }
        local num = { }
        for k, v in pairs(rewards) do
            if type(k) == "number" and type(v) == "number" then
                table.insert(sns, k)
                table.insert(num, v)
            end
        end

        CommonRewardUILogic.LShowRewardUI(sns, num)
    end
end

function ShowErrorCode(errorCode)
    if (errorCode == nil) then
        return false
    end
    local conf = require("ConfStr")
    local item = conf.Get(math.abs(errorCode))
    local msg = nil
    if (item ~= nil) then
        msg = item.strContent
    else
        msg = "[code]" .. errorCode
    end
    print(msg)

    return true
end

function SetButtonEnable(btn, enable)
    btn:SetGray(not enable)
    btn.Enable = enable
end


-- 读取str表里的内容
function GetStrCon(strId)
    if (strId == nil) then
        return "invalid strId"
    end
    local conf = require("ConfStr")
    local item = conf.Get(strId)
    if (item ~= nil) then
        return item.strContent
    end
    return "invalid strId: " .. strId
end

function GetStr(strId, ...)
    local mainStr = GetStrCon(strId)
    local t = { ...}
    if #t == 0 then
        return mainStr
    else
        mainStr = string.format(mainStr, ...)
    end
    for i = 1, #t do
        mainStr = string.gsub(mainStr, "{" .. tostring(i - 1) .. "}", t[i])
    end
    return mainStr
end

function FormatString(mainStr, ...)
    local t = { ...}
    if #t == 0 then
        return mainStr
    else
        mainStr = string.format(mainStr, ...)
    end
    for i = 1, #t do
        mainStr = string.gsub(mainStr, "{" .. tostring(i - 1) .. "}", t[i])
    end
    return mainStr
end

function GetParam(paramId)
    if (paramId == nil) then
        return "invalid paramId"
    end
    local conf = require("ConfParam")
    local item = conf.Get(paramId)
    if (item ~= nil) then
        return item.value
    end
    return "invalid paramId: " .. paramId
end

function GetParamWithDefault(paramId, defaultVal)
    if paramId == nil then
        return defaultVal
    end

    local conf = require('ConfParam')
    local item = conf.Get(paramId)

    if item == nil then
        return defaultVal
    else
        return item.value
    end
end

-- 取得自己与目标势力的关系
-- (hero必须为HERO)
function GetPowerRelations(hero, other)

    if (hero == nil or other == nil or hero.StageRoleData == nil or other.StageRoleData == nil) then
        if hero then
            print("no StageRoleData", hero.StageRoleData, other.StageRoleData)
        end
        return _G.Force.Neutrality
    end

    if BattleMod.IsBattling and other.mBattlePlayerType ~= nil then
        if BattleMod.mBattlePlayerType == other.mBattlePlayerType then
            return _G.Force.Amity
        else
            return _G.Force.Hostility
        end
    else
        return _G.Force.Neutrality
    end
end

function GetHeroPowerRelations(otherHumanId)
    if (otherHumanId == nil) then
        return _G.Force.Neutrality
    end
    local otherActor = ControllerMgr:GetController(otherHumanId)
    if (otherActor == nil) then
        return _G.Force.Neutrality
    end
    local actor = ControllerMgr:GetHero()
    if (actor == nil) then
        return _G.Force.Neutrality
    end
    return GetPowerRelations(actor, otherActor)
end

function global_SplitString(fullstring, seperator)
    local findstart_idx = 1;
    local split_idx = 1;
    local split_arr = { };
    local seperator_len = string.len(seperator)
    while true do
        local findlast_idx = string.find(fullstring, seperator, findstart_idx);
        if not findlast_idx then
            -- 找不到，就把剩余全部字符串返回
            split_arr[split_idx] = string.sub(fullstring, findstart_idx);
            break;
        end
        split_arr[split_idx] = string.sub(fullstring, findstart_idx, findlast_idx - 1);
        findstart_idx = findlast_idx + seperator_len;
        split_idx = split_idx + 1;
    end
    return split_arr;
end

function splitString_toNumbers(fullstring, seperator1, seperator2)
    local vector3StrArray = global_SplitString(fullstring, seperator1 or "|")
    local vector3Array = {}
    for n = 1, #vector3StrArray do
        vector3Array[n] = {}
        local vector3Str = vector3StrArray[n]
        local floatArray = global_SplitString(vector3Str, seperator2 or ",")
         
        for i = 1, #floatArray do
            table.insert( vector3Array[n], tonumber(floatArray[i]) )
        end
    end
    return vector3Array
end

-- 解析字符串，找出需要查表的字段，进行替换
-- 举例 @teamtarget_2@ 就是在TeamTarget表中查找对应的行的内容，需要的话在下面增加处理即可
function ParseTableString(text)
    local begidx = 1
    local lastidx = nil
    local firstidx = string.find(text, "@", begidx)
	if (firstidx ~= nil) then
		lastidx = string.find(text, "@", firstidx + 1)
	end
	while (firstidx ~= nil and lastidx ~= nil)
	do
		local key = string.sub(text, firstidx+1, lastidx-1)
		begidx = lastidx + 1
        if (key ~= nil) then
            local paramList = global_SplitString(key, "_")
            if (#paramList >= 2) then
                local repStr = GetTableString(paramList[1], paramList[2])
                if (repStr ~= nil) then
                    text = string.gsub(text, "@" .. key .. "@", repStr, lastidx)
                    begidx = begidx -(string.len(key) + 2 - string.len(repStr))
                end
            end
        end
        firstidx = string.find(text, "@", begidx)
        if (firstidx ~= nil) then
            lastidx = string.find(text, "@", firstidx + 1)
        end
    end
    return text
end

function GetTableString(tab, key)
    if (tab == "teamtarget") then
        local confTT = require("ConfTeamTarget")
        if (confTT ~= nil) then
            local row = confTT.Get(tonumber(key))
            if (row ~= nil) then
                return row.subName
            end
        end
    end
    return nil
end
local lua_json = require("luaJson")
--json编码，统一用此方法，方便后续更改编码方式
function JsonEncode(tab)
    -- local cjson = require "cjson"
    -- local content = cjson.encode(tab)
    -- return content
    if lua_json == nil then
        print("error------------------------luaJson not find")
    end
    return lua_json:encode(tab)
end

function JsonDecode(str)
    -- local cjson = require("cjson")
    -- local data = cjson.decode(str)
    -- return data
    if lua_json == nil then
        print("error------------------------luaJson not find")
    end
    return lua_json:decode(str)
end

function IndexOf(t, value)
    if t == nil then
        return false
    end
    if type(t) ~= "table" then
        print("error:t not a table")
        return false
    end
    for i, v in ipairs(t) do
        if v == value then
            return true
        end
    end
    return false
end


function FindFirstValue(t, value)
    if t == nil then
        return -1
    end
    if type(t) ~= "table" then
        print("error:t not a table")
        return -1
    end
    for i = 1, #t do
        if value == t[i] then
            return i
        end
    end
    return -1
end

function String_LastFind(str, pattern)
    -- body
    local i = 0
    local j = 0
    local _i = i
    local _j = j
    while true do
        _i, _j = string.find(str, pattern, i + 1)
        if _i ~= nil then
            i = _i
            j = _j
        else
            break
        end
    end

    if i == 0 then
        return nil, nil
    else
        return i, j
    end
end

-- 输出日志--
function log(str)
    D.log(str);
end

-- 错误日志--
function logError(str)
    print(str)
    D.error(str, nil)
end

function logErrorFmt(fmt, ...)
    local args = { ...}
    print(string.format(fmt, unpack(args)))
    logError(string.format(fmt, unpack(args)))
end

-- 警告日志--
function logWarn(str)
    --    D.warn(str);
    -- print('********** WARNING *********' .. tostring(str))
end

-- 查找对象--
function find(str)
    return GameObject.Find(str);
end

function destroy(obj)
    GameObject.Destroy(obj);
end

function

    Object(prefab)
    return GameObject.Instantiate(prefab);
end

function child(str)
    return transform:FindChild(str);
end

function subGet(childNode, typeName)
    return child(childNode):GetComponent(typeName);
end

function findPanel(str)
    local obj = find(str);
    if obj == nil then
        error(str .. " is null");
        return nil;
    end
    return obj:GetComponent("BaseLua");
end

function copyTab(st)
    local tab = { }
    for k, v in pairs(st or { }) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = copyTab(v)
        end
    end
    return tab
end  


-- 创建存储协议的本地容器
function Make_ProtoContainer()
    local meta = { }
    meta._fields = { }
    setmetatable(meta, {
        __newindex = function(self, name, value)
            if value ~= nil then
                self._fields[name] = value
            end
        end,

        __index = function(self, name)
            return self._fields[name]
        end
    } )
    return meta
end

-- 往容器拷贝
function UpdateProtoContainer(src, tab)
    if src == nil or src._fields == nil then
        src = Make_ProtoContainer()
    end
    for k, v in pairs(tab._fields) do
        if type(v) ~= "table" and v ~= nil then
            src._fields[k.name] = v;
        else
            if v._fields ~= nil then
                if src._fields[k.name] == nil then
                    src._fields[k.name] = Make_ProtoContainer();
                end

                UpdateProtoContainer(src._fields[k.name], v)
            else
                -- v为数组时，v._fields = nil，这里得存上
                src._fields[k.name] = v;
            end
        end
    end
end
-- 往容器拷贝2
function DNewUpdateProtoContainer(src, tab)
    if src == nil or src._fields == nil then
        src = Make_ProtoContainer()
    end

    for k, v in pairs(tab._fields) do
        if v ~= nil and type(v) ~= "table" then
            src[k.name] = v
        elseif v ~= nil and v._is_present_in_parent then
            src[k.name] = Make_ProtoContainer()
            DNewUpdateProtoContainer(src[k.name], v)
        else
            src._fields[k.name] = v
        end
    end
end

----只复制 _fields里面的值
-- function UpdateProtoData(src,tab)
--   if src._fields == nil then
--        src._fields = {}
--   end
--    for k,v in pairs(tab._fields) do
--       if type(v) ~= "table" and v ~= nil then
--            src._fields[k] = v;
--        else
--            if v._fields ~= nil then
--              if src._fields[k] == nil then
--                 src._fields[k] = v;
--              else
--                 UpdateProtoData(src._fields[k],v)
--              end
--            end
--        end
--    end
-- end

local type = type
local tostring = tostring
local print = print
local setmetatable = setmetatable
local getfenv = getfenv
local ipairs = ipairs
local pairs = pairs
local xpcall = xpcall
local error = error

local table_insert = table.insert
local table_concat = table.concat
local debug = debug

local function pr(t, name, indent)
    local tableList = { }
    local function table_r (t, name, indent, full)   
        local id = not full and name or type(name)~="number" and tostring(name) or '['..name..']'   
        local tag = indent .. id .. ' = '   
        local out = {}  -- result   
        if type(t) == "table" then   
            if tableList[t] ~= nil then   
                table.insert(out, tag .. '{} -- ' .. tableList[t] .. ' (self reference)')   
           else  
                tableList[t]= full and (full .. '.' .. id) or id  
               if next(t) then -- Table not empty   
                    table.insert(out, tag .. '{')   
                    for key,value in pairs(t) do   
                        table.insert(out,table_r(value,key,indent .. '|  ',tableList[t]))   
                    end   
                    table.insert(out,indent .. '}')   
                else table.insert(out,tag .. '{}') end   
            end   
        else  
            local val = type(t) ~= "number" and type(t) ~= "boolean" and '"' .. tostring(t) .. '"' or tostring(t)
            table.insert(out, tag .. val)
        end
        return table.concat(out, '\n')
    end
    return table_r(t, name or 'Value', indent or '')
end 

function printtable(t, name)
    print(pr(t, name))
end 

function printTraceback(t)
    print(t .. '\n' .. debug.traceback())
end



function IsValidID(id)
    if (id == nil) then
        return false
    end
    if (id == '') then
        return false
    end
    if (id == '0') then
        return false
    end
    return true
end

-- 1=绿色([9dff45]), 2=蓝色([9D9DFF]), 3=紫色([d545ff]), 4=黄色([bf5e00]),
-- 5=灰色([626262]), 6=白色([ffffff]), 7=黑色([000000]), 8=橙色([ff9845]),
-- 9=VIP绿([10a700]), 10=VIP蓝([4582ff])
-- 11=红色()
function GetColorStr(str, color)
    local endstr = ""
    if color == 1 then
        endstr = "[9dff45]"
    elseif color == 2 then
        endstr = "[9D9DFF]"
    elseif color == 3 then
        endstr = "[d545ff]"
    elseif color == 4 then
        endstr = "[bf5e00]"
    elseif color == 5 then
        endstr = "[626262]"
    elseif color == 6 then
        endstr = "[ffffff]"
    elseif color == 7 then
        endstr = "[000000]"
    elseif color == 8 then
        endstr = "[ff9845]"
    elseif color == 9 then
        endstr = "[10a700]"
    elseif color == 10 then
        endstr = "[4582ff]"
    elseif color == 11 then
        endstr = "[FF0000]"
    end
    endstr = endstr .. str .. "[-]"
    return endstr
end

-- 1=绿色([9dff45]), 2=蓝色([9D9DFF]), 3=紫色([d545ff]), 4=黄色([bf5e00]),
-- 5=灰色([626262]), 6=白色([ffffff]), 7=黑色([000000]), 8=橙色([ff9845]),
-- 9=VIP绿([10a700]), 10=VIP蓝([4582ff])
-- 11=红色() 12=深绿
function GetColorString(str, color)
    local endstr = ""
    if color == 1 then
        endstr = "<color=#9dff45>"
    elseif color == 2 then
        endstr = "<color=#9D9DFF>"
    elseif color == 3 then
        endstr = "<color=#d545ff>"
    elseif color == 4 then
        endstr = "<color=#bf5e00>"
    elseif color == 5 then
        endstr = "<color=#626262>"
    elseif color == 6 then
        endstr = "<color=#ffffff>"
    elseif color == 7 then
        endstr = "<color=#000000>"
    elseif color == 8 then
        endstr = "<color=#ff9845>"
    elseif color == 9 then
        endstr = "<color=#10a700>"
    elseif color == 10 then
        endstr = "<color=#4582ff>"
    elseif color == 11 then
        endstr = "<color=#FF0000>"
    elseif color == 12 then
        endstr = "<color=#45bd3f>"
    end
    endstr = endstr .. str .. "</color>"
    return endstr
end

function GetItemColorString(str, grade)
    return "<color=" .. GetParam("itemcolor" .. grade) ..">" .. str .. "</color>"
end

-- 1 白  2 绿 3 蓝 4 紫 5 橙 6 金 7 粉 8 红
function GetQualityColorString(str, color)
    local endstr = ""
    if color == 0 then
        endstr = "<color=#000000>"
    elseif color == 1 then
        endstr = "<color=#e6e6e6>"
    elseif color == 2 then
        endstr = "<color=#00d268>"
    elseif color == 3 then
        endstr = "<color=#03aef5>"
    elseif color == 4 then
        endstr = "<color=#e161f0>"
    elseif color == 5 then
        endstr = "<color=#fc823f>"
    elseif color == 6 then
        endstr = "<color=#ffb423>"
    elseif color == 7 then
        endstr = "<color=#fe85b0>"
    elseif color == 8 then
        endstr = "<color=#f6615a>"
    end
    endstr = endstr .. str .. "</color>"
    return endstr
end
-- 给一个字符串添加颜色
function GetColorName(color, content)
    local t = { }
    t[1] = "<color="
    t[2] = color
    t[3] = ">"
    t[4] = content
    t[5] = "</color>"
    return table.concat(t)
end

function GetVipSprite(vipLevel)
    if vipLevel <= 3 then
        return "vip1"
    elseif vipLevel <= 8 then
        return "vip2"
    elseif vipLevel <= 12 then
        return "vip3"
    else
        return "vip4"
    end
end

function GetVipNumStr(vipLevel)
    local vl = tostring(vipLevel)
    if vipLevel <= 3 then
        return GetColorStr(vl, 1)
    elseif vipLevel <= 8 then
        return GetColorStr(vl, 9)
    elseif vipLevel <= 12 then
        return GetColorStr(vl, 3)
    else
        return GetColorStr(vl, 8)
    end
end

function GetVipString(vipLevel, vl)
    if vipLevel <= 3 then
        return GetColorStr(vl, 1)
    elseif vipLevel <= 8 then
        return GetColorStr(vl, 9)
    elseif vipLevel <= 12 then
        return GetColorStr(vl, 3)
    else
        return GetColorStr(vl, 8)
    end
end

-- 零 ~ 三十一
function NumberToChineseNumber(number)
    if number < 0 then
        return "";
    end
    return GetStr(1800100 + number);
end

-- 2017-4-20 10:28:37
function ServerTimeStr(serverTime)
    return os.date("%Y-%m-%d %H:%M:%S", serverTime)
end

function ServerDateStr(serverTime)
    return os.date("%Y-%m-%d", serverTime)
end

function ServerMonthDateStr(serverTime)
    return os.date("%m-%d", serverTime)
end

-- 2017-4-20 10:28:37
function ClientTimerStr()
    return os.date("%Y-%m-%d %H:%M:%S", os.time())
end

-- 返回一个table,{year = 1998, month = 9, day = 16, yday = 259, wday = 4,
-- hour = 23, min = 48, sec = 10, isdst = false}
function GetTimeTable(seconds)
    return os.date("*t", seconds)
end

function FromSecondToTime(result)
    local day = Mathf.Floor(result /(60 * 60 * 24))
    local hourS = result %(60 * 60 * 24)
    local hour = Mathf.Floor(hourS /(60 * 60))
    local minuteS = hourS %(60 * 60)
    local minute = Mathf.Floor(minuteS / 60)

    local str = ""
    if day > 0 then
        str = day .. GetStr(1900313)
    end
    if hour > 0 then
        str = str .. hour .. GetStr(1900923)
    end
    if minute > 0 then
        str = str .. minute .. GetStr(2305901)
    end
    if str == "" then
        str = "1" .. GetStr(2305901)
    end

    return str
end
function FromSecondToTimeLastHour(result)
    local day = Mathf.Floor(result /(60 * 60 * 24))
    local hourS = result %(60 * 60 * 24)
    local hour = Mathf.Floor(hourS /(60 * 60))
    local minuteS = hourS %(60 * 60)
    local minute = Mathf.Floor(minuteS / 60)

    local str = ""
    if day > 0 then
        str =(day +(hour > 0 and 1 or 0)) .. GetStr(1900313)
    elseif day == 0 then
        if hour > 0 then
            str = hour .. GetStr(1900923)
        else
            str = "1".. GetStr(1900923)
        end
    end

    return str
end

-- @description:
-- X 天 X 小时, 小于一小时显示 1小时
function FromSecondToTimeLastHour2(result)
    local day = Mathf.Floor(result /(60 * 60 * 24))
    local hourS = result %(60 * 60 * 24)
    local hour = Mathf.Floor(hourS /(60 * 60))
    local minuteS = hourS %(60 * 60)
    local minute = Mathf.Floor(minuteS / 60)

    local str = ""
    if day > 0 then
        str = day .. GetStr(1900313)
    end

    if hour > 0 then
        str = str .. hour .. GetStr(1900923)
    else
        str = str .. "1".. GetStr(1900923)
    end

    return str
end
function FromSecondToTimeOnlyDay(result)
    local day = Mathf.Floor(result /(60 * 60 * 24))
    local hourS = result %(60 * 60 * 24)
    local hour = Mathf.Floor(hourS /(60 * 60))
    local minuteS = hourS %(60 * 60)
    local minute = Mathf.Floor(minuteS / 60)
    local str = (day + 1) .. GetStr(1900313)
    return str
end

function FromSecondToPassTime(result)
    local day = Mathf.Floor(result /(60 * 60 * 24))
    local hourS = result %(60 * 60 * 24)
    local hour = Mathf.Floor(hourS /(60 * 60))
    local minuteS = hourS %(60 * 60)
    local minute = Mathf.Floor(minuteS / 60)

    local str = ""
    if day > 0 then
        str =(day +(hour > 0 and 1 or 0)) .. GetStr(1901230) .. GetStr(1901231) -- %s天前
    elseif day == 0 then
        if hour > 0 then
            str = hour .. GetStr(1901229)..GetStr(1901231) -- %s小时前
        else
            if minute > 0 then
                str = minute .. GetStr(1901228)..GetStr(1901231) -- %s分钟前
            else
                str = GetStr(1901227)
            end
            
        end
    end

    return str
end

function FromSecondToTime2(result)
    local hour = Mathf.Floor(result /(60 * 60))
    local minuteS = result %(60 * 60)
    local minute = Mathf.Floor(minuteS / 60)
    local secS = minuteS % 60

    return string.format("%02d:%02d:%02d", hour, minute, secS)
end
function FromSecondToTime3(result)
    local hour = Mathf.Floor(result /(60 * 60))
    local minuteS = result %(60 * 60)
    local minute = Mathf.Floor(minuteS / 60)
    local secS = minuteS % 60
    if hour > 0 then
        return string.format("%02d:%02d:%02d", hour, minute, secS)
    else
        return string.format("%02d:%02d", minute, secS)
    end
end

function FromSecondToTime3ZhCN(result)
    local hour = Mathf.Floor(result /(60 * 60))
    local minuteS = result %(60 * 60)
    local minute = Mathf.Floor(minuteS / 60)
    local secS = minuteS % 60
    if hour > 0 then
        return string.format(GetStr(1901469), hour, minute, secS)
    else
        return string.format(GetStr(1901468), minute, secS)
    end
end

function FromSecondToTime4(result)
    local day = Mathf.Floor(result /(24 * 60 * 60))
    local hours = result %(24 * 60 * 60)
    local hour = Mathf.Floor(hours /(60 * 60))
    local minuteS = result %(60 * 60)
    local minute = Mathf.Floor(minuteS / 60)
    local secS = minuteS % 60

    if (day > 0) then
        return(day .. GetStr(1900313) .. hour .. GetStr(1900923))
    elseif (hour >= 1) then
        return string.format(hour .. GetStr(1900923))
    else
        return string.format(minute .. GetStr(2305901) .. secS .. GetStr(2305902))
    end
end
function FromSecondToTime40(result)
    local day = Mathf.Floor(result /(24 * 60 * 60))
    local hours = result %(24 * 60 * 60)
    local hour = Mathf.Floor(hours /(60 * 60))
    local minuteS = result %(60 * 60)
    local minute = Mathf.Floor(minuteS / 60)
    local secS = minuteS % 60

    return (day .. GetStr(1900313) .. hour .. GetStr(1900923) ..minute .. GetStr(2305901))
end
function FromSecondToTime5(result)
    local day = Mathf.Floor(result /(24 * 60 * 60))
    local hours = result %(24 * 60 * 60)
    local hour = Mathf.Floor(hours /(60 * 60))
    local minuteS = result %(60 * 60)
    local minute = Mathf.Floor(minuteS / 60)
    local secS = Mathf.Floor(minuteS % 60)

	hour = hour<10 and "0"..hour or hour
	minute = minute<10 and "0"..minute or minute
	secS = secS<10 and "0"..secS or secS
    if (day > 0) then
        return(day .. GetStr(1900313) .." " .. hour .. ":" .. minute)
	end
	return string.format(hour .. ":" .. minute .. ":" .. secS)
end

-- The unit of result is second.
function FromSecondToTimeTable(result)
    local h = math.floor(result / 3600)
    local minuteS = result % 3600
    local m = math.floor(minuteS / 60)
    local s = minuteS % 60

    return { hour = h, min = m, second = s }
end

-- 若时间在30分钟以内，则显示“刚刚”
-- 若时间在30分钟-24小时，则显示“今天”
-- 若时间在24小时-48小时，则显示“昨天”
-- 若时间在48小时-72小时，则显示“1天前”
-- 若时间在72小时-96小时，则显示“2天前”
-- 若时间在96小时-120小时，则显示“3天前”
-- 若时间在120小时-144小时，则显示“4天前”
-- 若时间在144小时-168小时，则显示“5天前”
-- 若时间在168小时-192小时，则显示“6天前”
-- 若时间在192小时以上，则显示一周前
function FromeSecondToLeftStr(timestamp, servertime)
    local seconds = servertime - timestamp
    local sendDate = os.date("*t", timestamp)
    local serverDate = os.date("*t", servertime)

    -- print('===>', seconds)

    if sendDate.month == serverDate.month and sendDate.day == serverDate.day then
        if seconds < 1800 then
            return GetStr(1901185)
        elseif 1800 <= seconds and seconds < 86400 then
            return GetStr(2305903)
        end
    end

    if seconds <= 86400 then
        return GetStr(2305904)
    else
        for i = 0, 5 do
            local prevTime = 172800 +(i - 1) * 86400
            local nextTime = 172800 + i * 86400
            if prevTime <= seconds and seconds < nextTime then
                return string.format("%d" .. GetStr(2305906), i + 1)
            end
        end
    end

    return GetStr(2305905)
end

local MAX_BIG_NUMBER_WAN = 10000;
local MAX_BIG_NUMBER_QIAN = 1000;

function BigNumberFormat(num)
    if type(num) ~= 'number' then
        return 0
    end

    if num < MAX_BIG_NUMBER_WAN then
        return num
    else
        local wpart = num / MAX_BIG_NUMBER_WAN;
        local qpart = num % MAX_BIG_NUMBER_WAN;

        if qpart >= MAX_BIG_NUMBER_QIAN then
            qpart = qpart / MAX_BIG_NUMBER_QIAN;
        end

        if qpart > 0 then
            return LocaleMod.GetString("BigNumberFormatWanFloat", wpart, qpart);
        else
            return LocaleMod.GetString("BigNumberFormatWanInt", wpart, qpart);
        end
    end
end

function ConvertSecondToTime(result)
    local tbl = { }
    tbl.day = Mathf.Floor(result /(60 * 60 * 24))
    local hourS = result %(60 * 60 * 24)
    tbl.hour = Mathf.Floor(hourS /(60 * 60))
    local minuteS = hourS %(60 * 60)
    tbl.min = Mathf.Floor(minuteS / 60)

    return tbl
end

function GetValueFromUnixTimeStamp(fmt, timestamp)
    return os.date(fmt, timestamp)
end

function GetWeekDay(weekDay)
    if     weekDay == "Mon" then return GetStr(2305907)
    elseif weekDay == "Tue" then return GetStr(2305908)
    elseif weekDay == "Wed" then return GetStr(2305909)
    elseif weekDay == "Thu" then return GetStr(2305910)
    elseif weekDay == "Fri" then return GetStr(2305911)
    elseif weekDay == "Sat" then return GetStr(2305912)
    elseif weekDay == "Sun" then return GetStr(2305913)
    else return "" end
end

function GetWeekDayViaNum(weekDay)
    if     weekDay == 2 then return GetStr(2305907)
    elseif weekDay == 3 then return GetStr(2305908)
    elseif weekDay == 4 then return GetStr(2305909)
    elseif weekDay == 5 then return GetStr(2305910)
    elseif weekDay == 6 then return GetStr(2305911)
    elseif weekDay == 7 then return GetStr(2305912)
    elseif weekDay == 1 then return GetStr(2305913)
    else return "" end
end

---
-- 策划配置用的(星期一->1, 星期日->7), 转为Lua Weekday
function ConvertToLuaWeekday(defDay)
    if defDay == nil or defDay < 1 or defDay > 7 then
        print('*invalid lua weekday')
        return -1
    end

    return defDay % 7 + 1
end

function ConvertToDefinedWday(luaDay)
    if luaDay == nil or luaDay < 1 or luaDay > 7 then
        print('*invalid luaDay')
        return -1
    end

    if luaDay == 1 then
        return 7
    else
        return luaDay - 1
    end
end

function NumberToAdText(number, repalceStr)
    local number = Mathf.Floor(number)
    if number == 0 then
        return repalceStr .. "0"
    end
    local str = ""
    while number > 0 do
        local tempNumber = number % 10
        number = Mathf.Floor(number / 10)
        str = repalceStr ..(tempNumber) .. str
    end

    return str
end

function GetIntPart(x)
    if x <= 0 then
        return math.ceil(x);
    end

    if math.ceil(x) == x then
        x = math.ceil(x);
    else
        x = math.ceil(x) -1;
    end
    return x;
end

function GetFactorPrice(pricePer, sellCount)
    return GetIntPart(pricePer * sellCount * 1000 * 0.03)
end

function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

function ClearScenarioStatus()

end

function ClearSceneStatus()
    ControllerMgr:RemoveHero();
    ControllerMgr:RemoveAll();
end

function ResetAllMod()
    ModMgr:ResetForRelogin();
    EventMgr:Brocast(_G.EVENT_RELOGIN.ReLogin)
end

function DisposeAllMode()
    ModMgr:DisposeMods();
end

function HideAllFrame()
    print("返回登录 关闭其他界面")
    UIMgr:HideAllViewFroReLogin();
end

function ProcessCreateRoleMod()
end

function ProcessLoginMod()
    MainForReLogin();
end

function GetDistanceIgnoreY(from, to)
    return math.sqrt((from.x - to.x) ^ 2 +(from.z - to.z) ^ 2)
end

function GetDirIgnoreY(from, to)
    local dir = to - from
    dir.y = 0
    return Vector3.Normalize(dir)
end


function AwardClientID()
    _G.ClientID = _G.ClientID - 1
    return tostring(_G.ClientID)
end

function Split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = { }
    if string.len(szFullString) == 0 then
        return nSplitArray
    end
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
        if nFindLastIndex == string.len(szFullString) then
            break
        end
    end
    return nSplitArray
end

function toboolean(str)
    if str == "true" then
        return true
    else
        return false
    end
end

function StringFirstFind(s, pattern)
    local from, over = string.find(s, pattern)
    if from ~= nil and over ~= nil then
        local getstr = string.sub(s, from + 1, over - 1)
        return getstr
    else
        return nil
    end
end

function GetProtoBufMsgValueList(obj)
    local ret = { }
    local mt = getmetatable(obj)
    for k, v in pairs(mt._descriptor.fields) do
        ret[v.name] = obj[v.name]
    end
    return ret
end

function GetProtoBufMsgContainerValueList(obj)
    local ret = { }
    for k, v in ipairs(obj) do
        ret[k] = v
    end
    return ret
end


function IsProtoBufMsg(obj)
    if obj == nil or type(obj) ~= "table" or getmetatable(obj) == nil then
        return false
    end
    local mt = getmetatable(obj)
    if mt == nil then
        return false
    end
    local protobuf = require "utils/protobuf/protobuf"
    return protobuf.HasProtoBufMsgFlag(mt)
end

function IsProtoBufMsgContainer(obj)
    if obj == nil or type(obj) ~= "table" then
        return false
    end
    local mt = getmetatable(obj)
    if mt == nil then
        return false
    end
    local containers = require "utils/protobuf/containers"
    return containers.HasProtoBufMsgContainerFlag(mt)
end

function encodeBase64(source_str)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local s64 = ''
    local str = source_str

    while #str > 0 do
        local bytes_num = 0
        local buf = 0

        for byte_cnt = 1, 3 do
            buf =(buf * 256)
            if #str > 0 then
                buf = buf + string.byte(str, 1, 1)
                str = string.sub(str, 2)
                bytes_num = bytes_num + 1
            end
        end

        for group_cnt = 1,(bytes_num + 1) do
            local b64char = math.fmod(math.floor(buf / 262144), 64) + 1
            s64 = s64 .. string.sub(b64chars, b64char, b64char)
            buf = buf * 64
        end

        for fill_cnt = 1,(3 - bytes_num) do
            s64 = s64 .. '='
        end
    end

    return s64
end  
  
function decodeBase64(str64)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local temp = { }
    for i = 1, 64 do
        temp[string.sub(b64chars, i, i)] = i
    end
    temp['='] = 0
    local str = ""
    for i = 1, #str64, 4 do
        if i > #str64 then
            break
        end
        local data = 0
        local str_count = 0
        for j = 0, 3 do
            local str1 = string.sub(str64, i + j, i + j)
            if not temp[str1] then
                return
            end
            if temp[str1] < 1 then
                data = data * 64
            else
                data = data * 64 + temp[str1] -1
                str_count = str_count + 1
            end
        end
        for j = 16, 0, -8 do
            if str_count > 0 then
                str = str .. string.char(math.floor(data / math.pow(2, j)))
                data = Mathf.fmod(data, math.pow(2, j))
                str_count = str_count - 1
            end
        end
    end

    local last = tonumber(string.byte(str, string.len(str), string.len(str)))
    if last == 0 then
        str = string.sub(str, 1, string.len(str) -1)
    end
    return str
end  

function encodeBase64New(data)
    local b ='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

function decodeBase64New(data)
    local b ='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end

function ToInt64(number)
    if number then
        return int64.new(number)
    end
    return int64.new(0)
end

function printJing()
    print("##########################################")
end

function printXing()
    print("******************************************")
end

function SortIncreasingBySn(conf1, conf2)
    return conf1.sn < conf2.sn
end

function SortDecreasingBySn(conf1, conf2)
    return conf1.sn > conf2.sn
end

function GetDirectionFromAngle(angle)
    angle = tonumber(angle)

    local rad = angle * math.pi / 180.0
    local retx = math.sin(rad)
    if math.abs(retx) < 1e-6 then
        retx = 0
    end
    local retz = math.cos(rad)
    if math.abs(retz) < 1e-6 then
        retz = 0
    end

    return { x = retx, y = 0, z = retz }
end

-- 返回当前字符实际占用的字符数
function SubStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte >= 192 and curByte <= 223 then
        byteCount = 2
    elseif curByte >= 224 and curByte <= 239 then
        byteCount = 3
    elseif curByte >= 240 and curByte <= 247 then
        byteCount = 4
    end
    return byteCount;
end

function SubStringGetTrueIndex(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until (curIndex >= index);
    return i - lastCount;
end

-- 获取中英混合UTF8字符串的真实字符数量
function SubStringGetTotalIndex(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until (lastCount == 0);
    return curIndex - 1;
end

function SubStringUTF8(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex = SubStringGetTotalIndex(str) + startIndex + 1;
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = SubStringGetTotalIndex(str) + endIndex + 1;
    end

    if endIndex == nil then
        return string.sub(str, SubStringGetTrueIndex(str, startIndex));
    else
        return string.sub(str, SubStringGetTrueIndex(str, startIndex), SubStringGetTrueIndex(str, endIndex + 1) -1);
    end
end

function ConvertArrayToVector3(arr)
    if arr == nil or type(arr) ~= "table" then
        return nil
    else
        return Vector3.New(
        arr[1] or 0,
        arr[2] or 0,
        arr[3] or 0
        )
    end
end

-- 不同的种子对应生成不同的sn
function GenerateRandomNpcSn(seed)
    math.randomseed(seed)
    return math.random(10000000000, 99999999999)
end

-- 根据当前日期, 返回日期当前所在周的开始和结束日期.
function GetWeekRange(date)
    local tdate = { year = date.year, month = date.month, day = date.day, hour = 0 }
    local tick1 = os.time(tdate)

    local startTicks = 0
    if date.wday == 1 then
        startTicks =(6 * 86400)
    else
        startTicks =(date.wday - 2) * 86400
    end
    local firstTicks = tick1 - startTicks

    return {
        First = os.date("*t", firstTicks),  -- 每个星期的周一
        Last   = os.date("*t", firstTicks + 518400) -- 6 * 86400, 每个星期的周日
    }
end

function GetWeekRange2(date)
    local tdate = { year = date.year, month = date.month, day = date.day }
    local tick1 = os.time(tdate)

    local startTicks = 0
    if date.wday == 1 then
        startTicks =(6 * 86400)
    else
        startTicks =(date.wday - 2) * 86400
    end
    local firstTicks = tick1 - startTicks

    return {
        First = os.date("*t",firstTicks),
        Last = os.date("*t",firstTicks + 7 * 86400)
    }
end

function GetWeekDays(date)
    if date == nil or date.year == nil or date.month == nil or date.day == nil then
        return nil
    end

    local tdate = { year = date.year, month = date.month, day = date.day }
    local tick1 = os.time(tdate)

    local ret = {}

    local startTicks = (date.wday - 2) * 86400
    local firstTicks = tick1 - startTicks   -- 周一

    table.insert(ret, firstTicks)

    for i = 1, 6 do
        table.insert(ret, firstTicks + i * 86400)
    end

    return ret

    -- for i = 1, #ret do
    --     local date = os.date("*t", ret[i])
    --     print(date.year, date.month, date.day)
    -- end
end

function GenetateUUID()
    math.randomseed(os.time() + math.random(0x00000000, 0xffffffff))
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v =(c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end )
end

function GetQualityImgGlobal(grade)
    if grade == QualityTypes.White then
        return GetParam("ItemQuality1")
    elseif grade == QualityTypes.Green then
        return GetParam("ItemQuality2")
    elseif grade == QualityTypes.Blue then
        return GetParam("ItemQuality3")
    elseif grade == QualityTypes.Purple then
        return GetParam("ItemQuality4")
    elseif grade == QualityTypes.Orange then
        return GetParam("ItemQuality5")
    elseif grade == QualityTypes.Gold then
        return GetParam("ItemQuality6")
    elseif grade == QualityTypes.Pink then
        return GetParam("ItemQuality7")
    elseif grade == QualityTypes.Red then
        return GetParam("ItemQuality8")
    else
        return GetParam("ItemQuality1")
    end
end

function GetQualityBorderGlobal(grade)
    if grade == QualityTypes.White then
        return "N-T-putong.png"
    elseif grade == QualityTypes.Green then
        return "lvkuang.png"
    elseif grade == QualityTypes.Blue then
        return "lankuang.png"
    elseif grade == QualityTypes.Purple then
        return "zikuang.png"
    elseif grade == QualityTypes.Orange then
        return "chengkuang.png"
    elseif grade == QualityTypes.Gold then
        return "jinkuang.png"
    elseif grade == QualityTypes.Pink then
        return "fenkuang.png"
    elseif grade == QualityTypes.Red then
        return "hongkuang.png"
    else
        return "N-T-putong.png"
    end
end

function GetEquipedQualityImgGlobal(grade)
    if grade == QualityTypes.White then
        return "beibaobai.png"
    elseif grade == QualityTypes.Green then
        return "beibaolv.png"
    elseif grade == QualityTypes.Blue then
        return "beibaolan.png"
    elseif grade == QualityTypes.Purple then
        return "beibaozi.png"
    elseif grade == QualityTypes.Orange then
        return "beibaocheng.png"

    elseif grade == QualityTypes.Gold then
        return "beibaojin.png"
    elseif grade == QualityTypes.Pink then
        return "beibaofen.png"
    elseif grade == QualityTypes.Red then
        return "beibaohong.png"
    else
        return "beibaobai.png"
    end
end

-- 装备穿戴提示
function GetEquipedHintQualityImgGlobal(grade)
    local confData = require("ConfParam")

    -- 没有白色装备，装备从2开始
    if grade < 2 then
        return confData.Get("EquipHint2").value
    elseif grade < 7 then
        return confData.Get("EquipHint" .. grade).value
    else
        return confData.Get("EquipHint7").value
    end

end


function GetJadeQualityImg(grade)
    if grade == QualityTypes.White then
        return "N-T-putong.png"
    elseif grade == QualityTypes.Green then
        return "N-T-lv.png"
    elseif grade == QualityTypes.Blue then
        return "N-T-lan.png"
    elseif grade == QualityTypes.Purple then
        return "N-T-zi.png"
    elseif grade == QualityTypes.Orange then
        return "N-T-cheng.png"
    elseif grade == QualityTypes.Gold then
        return "N-T-jin.png"
    elseif grade == QualityTypes.Pink then
        return "N-T-fen.png"
    elseif grade == QualityTypes.Red then
        return "N-T-hong.png"
    else
        return "N-T-putong.png"
    end
end


function GetHeadImgByModel(modelSn)
    local ConfMoXing = require("ConfMoXing")
    local ConfMoXingData = ConfMoXing.Get(modelSn)
    if ConfMoXingData ~= nil then
        return ConfMoXingData.icon[1]
    end
    return nil
end

function GetGuildImg(menpaiSn)
    local ConfMenPai = require("ConfMenPai")
    local ConfMenPaiData = ConfMenPai.Get(menpaiSn)
    if nil ~= ConfMenPaiData then
        return ConfMenPaiData.IconSmall
    end

    return nil
end

function GetGuildName(menpaiSn)
    local ConfMenPai = require("ConfMenPai")
    local ConfMenPaiData = ConfMenPai.Get(menpaiSn)
    if nil ~= ConfMenPaiData then
        return ConfMenPaiData.name
    end

    return nil
end

function GetDefaultWeapon(modelSn)
    local weaponsn = 0
    local conf = require("ConfZhuJueMoXing").Get(modelSn)
    if (conf) then
        weaponsn = conf.defaultWeapon
    end
    return weaponsn
end

function IsGlobalConditionOK(hasTips)
    hasTips = hasTips or false
    if BattleMod.IsBattling then
        if hasTips then
            show_message(GetStr(1900655))
        end
        return false
    elseif TeamMgr:IsFollow(hasTips) then
        return false
    elseif _G.MissionMgr:HasLoveMission() then
        if hasTips then
            show_message(GetStr(1900961))
        end

        return false
    elseif _G.StoryMgr.IsPlayingStory then
        return false
    end

    if WeddingMod and WeddingMod:checkIsCruiseManOrWoman() then
        if hasTips then
            show_message(GetStr(3102355))
        end
        return false
    end

    return true
end

-- UI从一个位置飞到另一个位置 --

function UIPlayTweenPosition(UIComponent, FromPosition, ToPosition, _EndCallBack, delay_tm, fly_tm)
    local TweenPosition = nil
    local TweenScale = nil
    local mdelay_tm = 0.1
    local mfly_tm = 0.7
    -- 取参  ------------
    if nil ~= FromPosition then
        UIComponent.Transform.position = FromPosition
    else
        FromPosition = UIComponent.Transform.position
    end
    if nil ~= delay_tm then
        mdelay_tm = delay_tm
    end
    if nil ~= fly_tm then
        mfly_tm = fly_tm
    end

    ----------------------

    UIComponent.Transform:SetAsLastSibling()

    -- 移动
    TweenPosition = GOGUI.TweenPosition.Begin(UIComponent.GameObject, mfly_tm, ToPosition)
    TweenPosition.from = FromPosition
    TweenPosition.delay = mdelay_tm
    TweenPosition.worldSpace = true
    TweenPosition:SetOnFinishedOneShot(_EndCallBack)
    TweenPosition.animationCurve = AnimationCurveUtil.GetAnimationCurve(EasingFunctionType.EaseInCubic)

end

-- UI旋转 --
-- 已自身当前角度四元数开始,不接受 起始角度 参数
function UIPlayTweenRotation(UIComponent, ToRotation, _EndCallBack, delay_tm, fly_tm)
    local TweenRotation = nil
    local TweenScale = nil
    local mdelay_tm = 0.1
    local mfly_tm = 1

    local mGameObject = UIComponent.gameObject


    if nil ~= delay_tm then
        mdelay_tm = delay_tm
    end
    if nil ~= fly_tm then
        mfly_tm = fly_tm
    end

    ----------------------

    mGameObject.transform:SetAsLastSibling()

    -- 移动
    TweenRotation = GOGUI.TweenRotation.Begin(mGameObject, mfly_tm, ToRotation)
    -- TweenRotation.from = FromRotation
    TweenRotation.delay = mdelay_tm
    TweenRotation:SetOnFinishedOneShot(_EndCallBack)
    TweenRotation.animationCurve = AnimationCurveUtil.GetAnimationCurve(EasingFunctionType.EaseInCubic)

end
function GetShuxingDataByName(name)

    local AllData = require("ConfShuXingMingCheng").GetAll()
    for k, v in pairs(AllData) do
        if v.name == name or v.valueName == name or v.percentName == name then
            return v
        end

    end

    return nil
end

function GetShuxingDataById(id)

    local AllData = require("ConfShuXingMingCheng").GetAll()
    for k, v in pairs(AllData) do
        if v.sn == tonumber(id) or v.valueId == tonumber(id) or v.percentId == tonumber(id) then
            return v
        end

    end

    return nil
end

local basicPropertySNList = { 160, 180, 190, 200, 210, 220 }
-- 获取简要属性（如果是生命、外攻、内攻、外防、内防、速度，则返回，如果不是，则返空）
function GetSimpleShuxingDataByName(name)

    local AllData = require("ConfShuXingMingCheng").GetAll()
    for k, v in pairs(AllData) do
        if v.valueName == name or v.percentName == name then

            local find = false
            for i = 1, #basicPropertySNList do
                if basicPropertySNList[i] == v.sn then
                    find = true
                end
            end
            if find then
                return v
            end

        end

    end

    return nil
end

local seniorPropertySNList = { 160, 170, 180, 190, 200, 210, 220, 400, 410, 570, 420, 430, 460, 470, 480, 490, 500, 510, 620, 630, 640}

-- 获取详细属性
function GetSeniorShuxingDataByName(name)

    local AllData = require("ConfShuXingMingCheng").GetAll()
    for k, v in pairs(AllData) do
        if v.valueName == name or v.percentName == name then

            local find = false
            for i = 1, #seniorPropertySNList do
                if seniorPropertySNList[i] == v.sn then
                    find = true
                end
            end
            if find then
                return v
            end

        end

    end

    return nil
end

function DeepCopy(object)
    local lookup_table = { }
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then

            return lookup_table[object]
        end
        -- if
        local new_table = { }
        lookup_table[object] = new_table


        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end 

-- region 定义一些快捷接口

function GetHeroObj()
    return _G.ControllerMgr:GetHero()
end

function AddOneFocusedNpc(npcSn, npcObj)
    if npcSn == nil or npcObj == nil then
        return
    end

    local hero = _G.GetHeroObj()
    if hero ~= nil then
        hero:AddOneFocusedNpc(npcSn, npcObj)
    end
end

-- @param sn ConfFunctionPlot
-- @param funcs ConfNpcFunc
-- @example MissionGameplayManager.lua -> function GetZyxxProgress
function FormatGameplayIntro(sn, funcs, ...)
    local args = { ...}

    if type(sn) ~= "string" then
        sn = tostring(sn)
    end

    if sn == nil then
        return
    end

    local plotSn = sn
    local confplot = require("ConfFunctionPlot").Get(plotSn)
    if confplot == nil then
        print_error('ConfFunctionPlot sn %s is nil.', tostring(plotSn))
        return
    end

    local plots = { }
    local tplot = { }
    for k, v in pairs(confplot) do
        tplot[k] = v
    end

    tplot.content = string.format(tplot.content, unpack(args))
    table.insert(plots, tplot)

    local dialogViewArgs = {
        type = _G.NpcDialogType.ForPlot,
        dialogId = plotSn,
        dialogPlots = plots,
        plotFuncs = funcs
    }

    _G.UIMgr:ShowView(UINames.UI_DialogView, dialogViewArgs)

end

-- @param type  1, 父节点选中; 2, 父节点未选中
--              3, 子节点选中; 4, 子节点未选中
function GetTreeTabFontColor(type)
    local defaultColor = "#ff0000"

    if type == 1 then
        return GetParamWithDefault("MISSIONVIEW_SELECTED_COLOR", defaultColor)
    elseif type == 2 then
        return GetParamWithDefault("MISSIONVIEW_UNSELECTED_COLOR", defaultColor)
    elseif type == 3 then
        return GetParamWithDefault("MISSIONVIEW_SMALLTAB_SELECTED_COLOR", defaultColor)
    elseif type == 4 then
        return GetParamWithDefault("MISSIONVIEW_SMALLTAB_UNSELECTED_COLOR", defaultColor)
    end

    return defaultColor
end

-- endregion 定义一些快捷接口

-- region 主角语音

function GetMainCharacterVoiceField(modelSn)
    local fieldName = ""

    if modelSn == nil then
        return fieldName
    end

    local fieldFmt = "voice%d"
    if modelSn == nil or modelSn == "" then
        return fieldName
    else
        local conf = require("ConfVoiceMainCharacterRel").Get(modelSn)
        if conf ~= nil then
            local fieldIndex = conf.voiceField
            fieldName = string.format(fieldFmt, fieldIndex)
        end
    end

    return fieldName
end

function GetMainCharacterVoice(voiceSn)
    local voiceName = ""

    if voiceSn == nil or #voiceSn == 0 then
        return voiceName
    end

    local hero = _G.GetHeroObj()
    if hero ~= nil then
        local fieldName = GetMainCharacterVoiceField(hero.mModelSn)
        if fieldName ~= "" then
            local confVoiceMainCharacter = require("ConfVoiceMainCharacter").Get(voiceSn)
            if confVoiceMainCharacter ~= nil then
                voiceName = confVoiceMainCharacter[fieldName] or ""
            end
        end
    end

    return voiceName
end

-- endregion 主角语音
function getAttrPropertyName(propertyType)
    local imd =(propertyType % 10)
    local idmod = propertyType - imd

    local shuxing = require("ConfShuXingMingCheng").Get(idmod)
    if shuxing ~= nil then
        local attrname = shuxing.simpleDesc
        -- if imd == 1 then
        --     attrname = shuxing.valueDesc
        -- elseif imd == 2 then
        --     attrname = shuxing.percentDesc
        -- end
        return attrname
    end
    return nil;
end

function reverse(tbl)
    for i = 1, math.floor(#tbl / 2) do
        local tmp = tbl[i]
        tbl[i] = tbl[#tbl - i + 1]
        tbl[#tbl - i + 1] = tmp
    end
end

function MathSign(v)
    return(v < 0 and -1) or 1
end

function MathClamp(v, minValue, maxValue)
    if v < minValue then
        return minValue
    end
    if v > maxValue then
        return maxValue
    end

    return v
end

--
-- @param inputContent      输入内容
-- @param beginWithSpace    段落开头是否空两个汉字
function FormatBlockText(inputContent, beginWithSpace)
    local result = ""

    local paragraphes = xstring.split(inputContent, '|')
    for i = 1, #paragraphes do
        if beginWithSpace then
            paragraphes[i] = string.format("<color=#FFFFFF00>____</color>%s\n", paragraphes[i])
        else
            paragraphes[i] = string.format("%s\n", paragraphes[i])
        end

        result = string.format("%s%s", result, paragraphes[i])
    end

    return result
end

-- @[In]paramName   Animator parameter name
-- @[Out]hasParam   boolean
-- @[Out]valueType  _G.ANIMATOR_PARAM_TYPE
function GetAnimatorParamType(paramName)
    local hasParam, typeStr = false, ""
    local all = require("ConfAnimatorParam").GetAll()
    for k, conf in pairs(all) do -- (name, type)
        if k == paramName then
            hasParam, typeStr = true, conf.type
            break
        end
    end

    if not hasParam then
        return hasParam, _G.ANIMATOR_PARAM_TYPE.Error
    end

    if typeStr == "Int" then
        return true, _G.ANIMATOR_PARAM_TYPE.Int
    elseif typeStr == "Float" then
        return true, _G.ANIMATOR_PARAM_TYPE.Float
    elseif typeStr == "Bool" then
        return true, _G.ANIMATOR_PARAM_TYPE.Bool
    elseif typeStr == "Trigger" then
        return true, _G.ANIMATOR_PARAM_TYPE.Trigger
    else
        return true, _G.ANIMATOR_PARAM_TYPE.Error
    end
end

-- 获取货币表情图片
function GetCurrencyEmoji(itemsn)
    local paramSn = "itemsnemoji" .. itemsn

    local conf = require("ConfParam")
    if nil ~= conf.Get(paramSn).value and #conf.Get(paramSn).value > 0 then
        return conf.Get(paramSn).value
    end

    return nil
end


------------ 音效处理部分
local mLowerBackgroundMusicTimer = nil
local mUpBackgroundMusicTimer = nil

-- 升高背景音
local function upBackground(value, offset)

    -- print(" 升高背景音 ".. value .. " offset " .. offset)
    
    if SystemSettingMod.forFunctionValue < value then
        SystemSettingMod.forFunctionValue = SystemSettingMod.forFunctionValue + offset
        SystemSettingMod:SetBgmVolume(SystemSettingMod.forFunctionValue, _G.SystemVolumeFlag.Function, false)
    else
        if mUpBackgroundMusicTimer ~= nil then
            mUpBackgroundMusicTimer:Stop()
            mUpBackgroundMusicTimer = nil
        end
    end
end

local function ResumeBgVolume(value)

    -- 获取提升背景音 时间和阈值
    local upValue = value
    local offset = (upValue - LuaRoot.MUAudioMgr.BgmVolume)/(tonumber(_G.GetParam("ELEVATED_TIME"))/10)

    -- 开启计时器， 提升背景音
    if (mUpBackgroundMusicTimer == nil) then
        mUpBackgroundMusicTimer = UITimer:new()
    else
        mUpBackgroundMusicTimer:Stop()
    end
    mUpBackgroundMusicTimer:Begin(function() upBackground(upValue , offset) end, 0.01, true, false )

end


local function delayUpBackgourndMisic(value)

    -- TimerMod:SetTimeout(function() ResumeBgVolume(value) end, tonumber(_G.GetParam("DELAY_TIME"))/1000)
    TimerMod:SetTimeout(function() ResumeBgVolume(value) end, 2)
end



local function lowBackground(value, offset)
    
    if SystemSettingMod.forFunctionValue > value then
        SystemSettingMod.forFunctionValue = SystemSettingMod.forFunctionValue - offset
        SystemSettingMod:SetBgmVolume(SystemSettingMod.forFunctionValue, _G.SystemVolumeFlag.Function, true)
    else
        if mLowerBackgroundMusicTimer ~= nil then
            mLowerBackgroundMusicTimer:Stop()
            mLowerBackgroundMusicTimer = nil
        end
    end
end

-- 音效加载完成时回调， 获取音效时常， 开启计时器播放结束 恢复背景音
local function GetTime (mBgmVolumeCache, soundName)
    local mClipLength = LuaRoot.MUAudioMgr:GetSoundLengthByName(soundName)
    if nil ~= mClipLength then

        TimerMod:SetTimeout(function() delayUpBackgourndMisic(mBgmVolumeCache) end, mClipLength)
    end
end
function PlayMainSoundAndLowBg(soundName, loop, removeAtEnd, soundType, fadein)
    -- 获取当前设置音量
    local mBgmVolumeCache = SystemSettingMod:GetMusicAudioVolume()
    
    -----------
    SystemSettingMod.forFunctionValue = LuaRoot.MUAudioMgr.BgmVolume
    local curPlayingAudioSrc = LuaRoot.MUAudioMgr:AddMainSound(soundName, loop, removeAtEnd, soundType, fadein, false,
                               function() GetTime(mBgmVolumeCache, soundName) end)

    if nil ~= curPlayingAudioSrc then

        -- 获取降低背景音 时间和阈值
        local mVolum = tonumber(_G.GetParam("REDUCE_PERCENT"))
        local lowValue = mBgmVolumeCache *(mVolum or 0.7)
        local offset = (mBgmVolumeCache - lowValue)/(tonumber(_G.GetParam("REDUCE_TIME"))/10)


        -- 开启计时器， 降低背景音
        if (mLowerBackgroundMusicTimer == nil) then
            mLowerBackgroundMusicTimer = UITimer:new()
        else
            mLowerBackgroundMusicTimer:Stop()
        end
        mLowerBackgroundMusicTimer:Begin(function() lowBackground(lowValue , offset) end, 0.01, true, false )


    end


    return curPlayingAudioSrc
end

function QuickBuy(itemSn, num)
    print("QuickBuy")
    UIMgr:ShowView(UINames.UI_QuickBuy, {itemSn = itemSn, num = num} )
end

function GetItemQualityEffect(grade)
    if grade <= 2 then
        return "ui_lizi_lv.prefab"
    elseif grade == 3 then
        return "ui_lizi_lan.prefab"
    elseif grade == 4 then
        return "ui_lizi_zi.prefab"
    elseif grade == 5 then
        return "ui_lizi_cheng.prefab"
    else
        return "ui_lizi_hong.prefab"
    end
end

function getBindEffectStr(prefabName, layer)
    local prefabName = prefabName
    local effectLayer = tonumber(layer)
    local curConfEffectMusic = require("ConfEffectMusic").Get(prefabName)
    if curConfEffectMusic ~= nil then
        return prefabName .. "," .. effectLayer .. "," .. curConfEffectMusic.soundname
    end

    return prefabName .. "," .. effectLayer
end

function GetFormatEffectParam(effectPos, name, layer, edgeNum)
    local prefabName = name
    local effectLayer = layer
    local curConfEffectMusic = require("ConfEffectMusic").Get(prefabName)
    if curConfEffectMusic ~= nil then
        effectPos:SetProperty(UIProperty.UIEffectPlay, prefabName .. "," .. effectLayer .. "," .. curConfEffectMusic.soundname .. "," .. edgeNum)
    else
        effectPos:SetProperty(UIProperty.UIEffectPlay, prefabName .. "," .. effectLayer .. "," .. "" .. "," .. edgeNum)
    end
end

function ShowUIRule(sn)
    local conf = require("ConfStrUIPlayRule").Get(sn)
    if conf ~= nil then
        UIMgr:ShowView(_G.UINames.UI_UIRuleTips, conf.strContent)
    end
end

function ShowXiaKeTips(sn)
    UIMgr:ShowView(UINames.UI_XiakeTips, sn)
end


function CompareNumber(a, b)
    local type_a, type_b = type(a), type(b)
    if type_a ~= "userdata" and type_a ~= "number" then
        print(string.format("* invalid type(a) %s, must be int64(userdata) or number", type_a))
        return 0
    end

    if type_b ~= "userdata" and type_b ~= "number" then
        print(string.format("* invalid type(b) %s, must be int64(userdata) or number", type_b))
        return 0
    end

    if type_a == "number" and type_b == "number" then
        if a < b then return -1
        elseif a > b then return 1
        else return 0 end
    else
        
        local int64_a, int64_b = nil, nil
        if type_a == "number" then
            int64_a = int64.new(a)
        else
            int64_a = a
        end

        if type_b == "number" then
            int64_b = int64.new(b)
        else
            int64_b = b
        end

        if int64_a < int64_b then return -1
        elseif int64_a > int64_b then return 1
        else return 0 end
    end
end

_G.TimeZoneDiff = 0
--logerr("当前时区与东八区的差值:"..TimeZoneDiff)

function OSTime(t)
    local curTimeZone = 0
    if t == nil then
        curTimeZone = os.time()
        return curTimeZone
    else
        curTimeZone = os.time(t) or 0
        local IsDst = os.date("*t",curTimeZone).isdst
	    if IsDst then
	    	return curTimeZone - TimeZoneDiff + 3600
		else
			return curTimeZone - TimeZoneDiff
		end
    end
end
function OSDate(formatStr,timeNum)
    local newTime = 0
    if timeNum == nil then
        timeNum = OSTime()
    end

	local IsDst = os.date("*t",timeNum).isdst
	if IsDst then
		newTime = timeNum + TimeZoneDiff - 3600
	else
		newTime = timeNum + TimeZoneDiff
	end
    return os.date(formatStr,newTime)
end

-- 根据时间戳，获取星座
function GetStarWithSeconds( seconds )
    local tb = GetTimeTable(seconds)

    if tb.month == 1 then
        if tb.day <= 19 then
            -- 摩羯座
            return GetStr( 2100145 )
        else
            -- 水瓶座
            return GetStr( 2100146 )
        end
    elseif tb.month == 2 then
        if tb.day <= 18 then
            -- 水瓶座
            return GetStr( 2100146 )
        else
            -- 双鱼座
            return GetStr( 2100147 )
        end
    elseif tb.month == 3 then
        if tb.day <= 20 then
            -- 双鱼座
            return GetStr( 2100147 )
        else
            -- 白羊座
            return GetStr( 2100136 )
        end
    elseif tb.month == 4 then
        if tb.day <= 19 then
            -- 白羊座
            return GetStr( 2100136 )
        else
            -- 金牛座
            return GetStr( 2100137 )
        end
    elseif tb.month == 5 then
        if tb.day <= 20 then
            -- 金牛座
            return GetStr( 2100137 )
        else
            -- 双子座
            return GetStr( 2100138 )
        end
    elseif tb.month == 6 then
        if tb.day <= 21 then
            -- 双子座
            return GetStr( 2100138 )
        else
            -- 巨蟹座
            return GetStr( 2100139 )
        end
    elseif tb.month == 7 then
        if tb.day <= 22 then
            -- 巨蟹座
            return GetStr( 2100139 )
        else
            -- 狮子座
            return GetStr( 2100140 )
        end
    elseif tb.month == 8 then
        if tb.day <= 22 then
            -- 狮子座
            return GetStr( 2100140 )
        else
            -- 处女座
            return GetStr( 2100141 )
        end
    elseif tb.month == 9 then
        if tb.day <= 22 then
            -- 处女座
            return GetStr( 2100141 )
        else
            -- 天枰座
            return GetStr( 2100142 )
        end
    elseif tb.month == 10 then
        if tb.day <= 23 then
            -- 天枰座
            return GetStr( 2100142 )
        else
            -- 天蝎座
            return GetStr( 2100143 )
        end
    elseif tb.month == 11 then
        if tb.day <= 22 then
            -- 天蝎座
            return GetStr( 2100143 )
        else
            -- 射手座
            return GetStr( 2100144 )
        end
    elseif tb.month == 12 then
        if tb.day <= 21 then
            -- 射手座
            return GetStr( 2100144 )
        else
            -- 摩羯座
            return GetStr( 2100145 )
        end
    end
end

-- 根据职业获取桃花源头像（暂时）
function GetProfessionSocialSprite( sex )
    if sex == SexType.Female then
        return "pengyouquannv.png"
    elseif sex == SexType.Male then
        return "pengyouquannan.png"
    elseif sex == SexType.Unknown then
        return "pengyouquannan.png"
    end
    return ""
end

-- 保留小数 (原float, 保留几位)
function GetDecimals(oriNum, AftPointCount)
    local multiplyNum = 1;
    for i = 1, AftPointCount do
        multiplyNum = multiplyNum * 10
    end

    oriNum = oriNum * multiplyNum
    local t1, t2 = math.modf(oriNum / 1)
    t1 = t1 / multiplyNum

    return t1

end

function IsWifi()
	return Utils.SysUtil.GetInternetReachability() == "wifi"
end

function parseStrList(str,parseStr)
    local resultList = xstring.split(str, parseStr)
    return resultList
end

function checkGoldCost(num, callback)

    if tonumber(DataMgr:GetDiamond()) < num then
        -- MainTipsMgr:ShowSysMsg(GetStr(2306019))
        -- 你的元宝不足,是否前往充值?
        ShowConfirmBox(GetStr(3000089), function() 
            OpenViewPageMgr:OpenPage(19010) 
        end,
        nil, nil)
    else

        if ItemMgr.NotHintCostGold then
            if callback then
                callback()
            end
            
        else
            UIMgr:onHideView(_G.UINames.UI_ConfirmGoldCost)
            local promptView = UIMgr:ShowView(UINames.UI_ConfirmGoldCost,
            { content = GetStr(3000068, num),
              checkText = GetStr(3000069), 
              okcall = callback, 
              cancelcall = nil, 
              closecall = nil, 
              reasonType = 1005 })
     
        end
    
    end
    
end

-- 自动购买， 需要购买的sn，和需要的总数量，例如需要5个，已有3个，缺少2个。就传5。
function AutoBuyItem(sn, needNum)
    TradeMgr:ResetShortcutBuyInfo()
    local moneyType = {1,2,3,14}
    for i=1, #moneyType do
        if sn == moneyType[i] then
            DataMgr:UseAndCheckMoney( { index = 2, moneysn = sn, moneynum = needNum })
            return
        end
    end

    if sn < 1000 then
        MainTipsMgr:ShowSysMsg(GetStr(1900888, ItemMgr:GetItemColorName(sn)))
        return
    end
    
    local ConfData = require("ConfItem").Get(sn)
    if (#ConfData.output)  > 0 then
            
        local haveNum = ItemMgr:GetItemCount(sn)
        local FromConf = nil
        if string.find( ConfData.output,",") then
            local mOutPut = global_SplitString(ConfData.output,",")
            for i=1, #mOutPut do
                
                -- 如果购买途径既有商会也有商城，优先商会
                if require("ConfItemOutPutFrom").Get(tonumber(mOutPut[i])).type == _G.ItemOutputFromType.Trade then
                    FromConf = require("ConfItemOutPutFrom").Get(tonumber(mOutPut[i]))
                    break
                end
                if require("ConfItemOutPutFrom").Get(tonumber(mOutPut[i])).type == _G.ItemOutputFromType.Shop then
                    FromConf = require("ConfItemOutPutFrom").Get(tonumber(mOutPut[i]))
                end
            end

            if (FromConf == nil) then
                FromConf = require("ConfItemOutPutFrom").Get(tonumber(mOutPut[1]))
            end
        else
            FromConf = require("ConfItemOutPutFrom").Get(tonumber(ConfData.output))
        end

        if nil ~= FromConf then
            if FromConf.type == _G.ItemOutputFromType.Shop then
                local ConfGood = ShopMod:getShopItemConf(FromConf.externalParam,sn)
                if nil ~= ConfGood then

                    if nil ~= tonumber(haveNum) then
                        needNum = needNum - tonumber(haveNum)
                    end
                    if needNum <= 0 then
                        needNum = 1
                    end
                    QuickBuy(sn, needNum)
                end
            elseif FromConf.type == _G.ItemOutputFromType.Trade then
                local num = needNum
                if nil ~= tonumber(haveNum) then
                    needNum = needNum - tonumber(haveNum)
                end
                if needNum <= 0 then
                    needNum = 1
                end
                local buy = {
                    item = sn,
                    num = needNum,
                    callback = function(state, data) end,
                }
                local result = TradeMgr:ShortcutBuyGoods(buy, true)
                if result < 0 then
                    MainTipsMgr:ShowSysMsg(GetStr(24500))
                end
            elseif FromConf.type == _G.ItemOutputFromType.Stall or FromConf.type == _G.ItemOutputFromType.ZhenPinGe then
                local num = needNum
                if nil ~= tonumber(haveNum) then
                    needNum = needNum - tonumber(haveNum)
                end
                if needNum <= 0 then
                    needNum = 1
                end
                local hint = GetStr(3000081, needNum, ItemMgr:GetItemColorName(sn))
    
                ShowConfirmBox(hint, function() 
                    if FromConf.type == _G.ItemOutputFromType.Stall then
                        TradeMgr:AutoBuy(2, sn, num)
                    elseif FromConf.type == _G.ItemOutputFromType.ZhenPinGe then
                        TradeMgr:AutoBuy(3, sn, num)   
                    end 
                end,
                nil, nil)

            else
                MainTipsMgr:ShowSysMsg(GetStr(1900888, ItemMgr:GetItemColorName(sn)))
            end

        end

    end
end



local function __GetServerTimeViaDateTable(date, localTimeZone, serverTimeZone)
    if localTimeZone == serverTimeZone then
        return os.time(date)
    end

    if date == nil then
        return nil
    end

    if date.year == nil or date.month == nil or date.day == nil then
        return nil
    end

    local t = os.date("*t", os.time())
    if not t.isdst then
        return os.time(date) + (localTimeZone - serverTimeZone)
    else
        return os.time(date) + (localTimeZone - serverTimeZone + 3600)
    end
end


function GetLocalTimeZone()
    local now = os.time()
    return os.difftime(now, os.time(os.date("!*t", now)))   -- os.date("!*t", os.time())表示此时格林尼治时间
end

-- @param date      {year=?,month=?,day=?,hour=?,min=?,sec=?}
-- @return lua timestamp
function GetServerTimeViaDateTable(date)
    local localTimeZone = GetLocalTimeZone()
    local serverTimeZone = _G.WeatherMgr:GetServerTimeZone()

    local servertime = __GetServerTimeViaDateTable(date, localTimeZone, serverTimeZone)
    if servertime == nil then
        logError("date table has error format.")
        return nil
    else
        return servertime
    end
end

-- @param serverTimeStamp
-- @param serverTimeZone
-- @param localTimeZone
-- @return Server Date Table
function __GetServerDate(serverTimeStamp, serverTimeZone, localTimeZone)
    local t = os.date("*t", os.time())
    local localTimeStamp = nil
    if t.isdst then
        localTimeStamp = serverTimeStamp + (serverTimeZone - localTimeZone - 3600)
    else
        localTimeStamp = serverTimeStamp + (serverTimeZone - localTimeZone)
    end
    -- local localTimeStamp = serverTimeStamp + serverTimeZone - localTimeZone
    return os.date("*t", localTimeStamp)
end

-- @param serverTimeStamp, (Lua timestamp). The unit is second.
function GetServerDate(serverTimeStamp)
    return __GetServerDate(serverTimeStamp, _G.WeatherMgr:GetServerTimeZone(), _G.GetLocalTimeZone())
end

-- 计算间隔时间，传入时间戳(秒)
function CountBetweenDays(beginTime, endTime)
    local beginDate = GetTimeTable(beginTime)
    local beginZeroTime = os.time({ year = beginDate.year, month = beginDate.month, day = beginDate.day, hour = 0, min = 0, sec = 0 })

    local endDate = GetTimeTable(endTime)
    local endZeroTime = os.time({ year = endDate.year, month = endDate.month, day = endDate.day, hour = 0, min = 0, sec = 0 })

    local days = (endZeroTime - beginZeroTime)/3600/24 
    return days
end
-- Test Case
-- function TestGetServerDate()
--     local timetbl = {year=2018,month=11,day=5,hour=19,min=43,sec=30}
--     print ("Server Unix TimeStamp: ", GetServerTimeViaDateTable(timetbl))

--     local serverdate = GetServerDate(_G.WeatherMgr:GetServerTime())
--     print(serverdate.year, serverdate.month, serverdate.day, serverdate.hour, serverdate.min, serverdate.sec)
-- end


function PrintTestDate(date)
    print(string.format("%04d-%02d-%02d %02d:%02d:%02d",
    date.year, date.month, date.day, date.hour, date.min, date.sec))
end

-- 比较传入时间字符串与当前服务器时间 ( -1:当前之前  1: 当前之后 , 同时返回时间戳差值)   
function CompareServerTime(targetTime, splitStr)
    if type(targetTime) == "string" then

        local serverTime = WeatherMgr:GetServerTime()
        local endTime = global_SplitString(targetTime, splitStr)
        local tab = {year= endTime[1], month=endTime[2], day=endTime[3], hour=endTime[4],min=endTime[5],sec=endTime[6],isdst=false}
        local endTimeStamp = GetServerTimeViaDateTable(tab)
        return (endTimeStamp - serverTime) > 10 and 1 or -1, Mathf.Abs( endTimeStamp - serverTime )
    end
end

-- 战斗中, 跳转统一检查
function CheckIsBattling()
    if BattleMod.IsBattling then
        show_message(GetStr(3100191))
        return true
    end

    return false
end


function IsSameWithNpcScene(npcSn, sceneSn)
    local confNpc = require("ConfNpc").Get(npcSn)
    if confNpc ~= nil then
        return sceneSn == confNpc.stageSn
    end

    return false
end

function RandomUnitVector()
    local ret = Vector3.right

    math.randomseed(os.time())

    local theta = math.random(1e-3, math.pi)
    local phi = math.random(1e-3, 2 * math.pi)

    local sin_theta = math.sin(theta)
    
    ret.x = sin_theta * math.cos(phi)
    ret.y = sin_theta * math.sin(phi)
    ret.z = math.cos(theta)

    return ret
end

-- 语音高度文字行高 + 占用几行 目前 25 * 2 2行
function SetChatVoiceHeighUseRow(height, row)
    Utils.SysUtil.SetChatVoiceHeighUseRow(height, row)
end


-- 根据限制长度从开头截取一段中英文混合的字符串
function SplitChineseAndEnglishByLentgh(str, limitNum)

    local stringList = {}
    for j=1, #str do
        local jj = SubStringUTF8(str,j, j)
        if #jj >0 then
            table.insert(stringList, jj)
        end

    end

    local byteCount = 0
    local tempName = ""
    for i=1, #stringList do
        local curByte = string.byte(stringList[i], 1)
        if curByte == nil then
            byteCount = byteCount + 0
        elseif curByte > 0 and curByte <= 127 then
            byteCount = byteCount + 1
        else
            byteCount = byteCount + 2
        end
        if byteCount <= limitNum then
            tempName = tempName ..stringList[i]
        else
            break
        end
    end

    return tempName
end

-- 获取渠道ID 对应支付表的平台ID
function ChangeChannalToPlatform(channel)
    local type = require("MorePlatformMod").Instance():GetAreaPlatformType()
    local os = require("PlatformSDKMod").Instance().os
    if type == AreaPlatformType.CH then       
        --PC 情况读取老虎平台
        if os == tostring(1) then
            --PC版本os 转换
            local tempOs = require("PlatformSDKMod").Instance():GetOs()
           -- print("tempOs",tempOs)
            if tempOs == tostring(2) then
                return 5
            elseif tempOs == tostring(3) then
                return 1
            else 
                return 5
            end
        --Android
        elseif os == tostring(2) then
            --联想
            if channel == 40 then      
                return 3
            --三星
            elseif channel == 97 then      
                return 2
            --酷派
            elseif channel == 44 then      
                return 4
            --One其他
            else     
                return 5
            end 
        --iOS       
        elseif os == tostring(3) then
            --官方渠道老虎
            if channel == 9 then
                return 1
            end
            return 1
        end

        if os == nil or os == "" then
            return 5
        end
        
    elseif type == AreaPlatformType.TW or type == AreaPlatformType.XM or type == AreaPlatformType.VN or type == AreaPlatformType.THA then
        -- body
        return channel   
    end
end

-- 获取带颜色的品质中文字符 (1 白  2 绿 3 蓝 4 紫 5 橙 6 金 7 粉 8 红) 
function GetColorChinese(grade)

    local colorName = ""
    if grade == 0 then
        colorName = GetParam("COLOR_WIHTE")
    elseif grade == 1 then
        colorName = GetParam("COLOR_WIHTE")
    elseif grade == 2 then
        colorName = GetParam("COLOR_GREEN")
    elseif grade == 3 then
        colorName = GetParam("COLOR_BLUE")
    elseif grade == 4 then
        colorName = GetParam("COLOR_PURPLE")
    elseif grade == 5 then
        colorName = GetParam("COLOR_ORANGE")
    elseif grade == 6 then
        colorName = GetParam("COLOR_GOLD")
    elseif grade == 7 then
        colorName = GetParam("COLOR_PINK")
    elseif grade == 8 then
        colorName = GetParam("COLOR_RED")
    end

    return GetQualityColorString(colorName, grade)
end

-- 是不是国服
local morePlat = nil
function IsAreaCH()
    morePlat = morePlat or require("MorePlatformMod")
    return morePlat.Instance():CheckAreaPlatformCH()
end
-- 是不是老虎渠道

function IsLaoHuPlatform()
    local  platformSDKMod = require("PlatformSDKMod").Instance()
    local channelId = platformSDKMod.channelId
    local os = platformSDKMod.os
    if IsAreaCH() then
        if os == tostring(2) then
            if channelId == "9" then
                return true
            else
                return false
            end
        elseif os == tostring(3) then
            return true
        else
            return false
        end
    else
        return false
    end
end

-- 服务器0点时间戳
function GetServerTodayTimeStamp()
    local serverTime = os.date("*t", WeatherMgr:GetServerTime())
    local date = { }
    date.year = serverTime.year
    date.month = serverTime.month
    date.day = serverTime.day
    date.hour = 0
    date.min = 0
    date.sec = 0
    local serverZeroTime = os.time(date)
    return serverZeroTime
end

function IsRunningMissionAction(targetActionSn)
    local view = _G.UIMgr:GetVisibleWindow(_G.UINames.UI_MissionActionView)
    if view ~= nil then
        return view:GetActionSn() == targetActionSn
    end

    return false
end

-- 参数：年月日， 返回 带年月日文字的时间
function GetChineseDate(year, month, day)
    
    return string.format( "%s%s%s", GetStr(1900833, year), GetStr(1900834, month), GetStr(1900835, day))
end

function ReplaceBrackets(str)
    if str == nil or str == "" then
        return ""
    end

    local replace_str, pos = string.gsub(str, "%(", "<")
    replace_str, pos = string.gsub(replace_str, "%)", ">")

    return replace_str
end

function BigNumberFormatChinese(num)
    if tonumber(num) == nil then return tostring(num) end

    if tonumber(num) < 10000 then
        return tostring(num)
    else
        
        local temp = math.floor(num/10000) *10000
        local qpart = (num - temp)/1000
        local wpart = temp/10000

        if (qpart > 0) then
            return GetDecimals(num/10000, 1) .. GetStr(2305938)
        else
            return wpart .. GetStr(2305938)
        end
    end
end

function IsPlatformValue(val)
    if not IsAreaCH() then
        return false
    end

    local  platformSDKMod = require("PlatformSDKMod").Instance()
    local channelId = platformSDKMod.channelId
    return channelId == tostring(val)
end

function IsOppoPlatform()
    return IsPlatformValue(8)
end

function IsGameFunPlatform()
    return IsPlatformValue(154)
end

function GetChannelID()
    local platformSDKMod = require("PlatformSDKMod").Instance()
    return  platformSDKMod.channelId
end

-- 无分享渠道
function IsNoSharePlatform()
    return IsPlatformValue(153) or IsPlatformValue(155) or IsPlatformValue(156) or IsPlatformValue(157)
end

function ShuffleSequence(range, ans)
    local str, tbl, target = "", {}, 1
    repeat
		local choice = math.random(range)
		if string.find(str, choice) == nil then
            str = string.format("%s%d", str, choice)
            table.insert(tbl, choice)
		end	
    until string.len(str) == range

    local idx, _ = string.find(str, tostring(ans))
    return tbl, idx
end

function ShuffleFourSequence(ans)
    return ShuffleSequence(4, ans)
end

function FormatMSTime(result)
    local minute = Mathf.Floor(result / 60)
    local secS = result % 60
    if minute > 0 then
        if secS > 0 then
            return string.format(minute .. GetStr(2305901) .. secS .. GetStr(2305902))
        else
            return string.format(minute .. GetStr(1901228))
        end
    else
        return string.format(secS .. GetStr(2305902))
    end
end


function FliterStringColor(str)
    if not str then
        return
    end
    
    local findTable = {}
    for h in string.gmatch(str, "%<color=#%x+%>") do
        findTable[h] = true
    end

    for key,val in pairs(findTable) do
        str = string.gsub(str, key, "")
    end

    str = string.gsub(str, "</color>", "")
    return str
end

function getPercentNum(propertyNum)
    local percentStr = "%"
    local num =((propertyNum * 10000000)) / 100000
    return num .. percentStr
end

local nCSVersion = 0
function GetCSVersion()
    if nCSVersion <= 0 then 
        local versionArray = xstring.split(GameConfig.VERSION_CODE, '.')
        if #versionArray > 2 then
            nCSVersion = tonumber(versionArray[1]) * 10000 + tonumber(versionArray[2]) * 100  + tonumber(versionArray[3])
        end
    end
    return nCSVersion
end


-- 2019/12/17 20:00:00 to 时间戳
function FormatTimeFromString(timeStr)
    if not timeStr then
        return
    end

    local array = xstring.split(timeStr, " ")
    if #array == 2 then
        -- data time
        local dates = xstring.split(array[1], "/")
        local times = xstring.split(array[2], ":")
        if #dates == 3 and #times == 3 then
            local date = { }
            date.year = tonumber(dates[1])
            date.month = tonumber(dates[2])
            date.day = tonumber(dates[3])
            date.hour = tonumber(times[1])
            date.min = tonumber(times[2])
            date.sec = tonumber(times[3])
            return os.time(date)
        end
    end
end

-- shengji confwangchen 
local RestartLevelMap = nil
function InitRestart()
    if not RestartLevelMap then
        RestartLevelMap = {}
        local alldata = require("ConfWangChen").GetAll()
        for _,v in pairs(alldata) do
            for j=v.levelSectionMin,v.levelSectionMax do
                RestartLevelMap[j] = v.sn
            end
        end
    end
end

-- return lv 
function GetRestartSimpleLevel(lv)
    InitRestart()
    local reuslt = nil
    if not lv then return end
    lv = tonumber(lv)
    local data = RestartLevelMap[lv]
    if not data then return lv end
    data = require("ConfWangChen").Get(data)
    lv = (lv % data.levelSectionMin)
    return lv
end 

-- return 忘尘..lv
function GetRestartLevel(lv)
    InitRestart()
    if not lv then return end
    lv = tonumber(lv)
    local data = RestartLevelMap[lv]
    if not data then return lv end
    data = require("ConfWangChen").Get(data)
    lv = (lv % data.levelSectionMin)
    return data.levelSectionName .. lv
end 

local TOUMING = "TouMing.png"
-- return iconName
function GetRestartIcon(lv)
    InitRestart()
    if not lv then return TOUMING end
    lv = tonumber(lv)
    local data = RestartLevelMap[lv]
    if not data then return TOUMING end
    data = require("ConfWangChen").Get(data)
    return data.levelSectionIcon
end 

--return chatcolor
function GetRestartChatColor(lv)
    InitRestart()
    if not lv then return end
    lv = tonumber(lv)
    local data = RestartLevelMap[lv]
    if not data then return end
    data = require("ConfWangChen").Get(data)
    return data.chatNameColor
end

function IsSpcialeLevel(lv)
    InitRestart()
    if not lv then return end
    lv = tonumber(lv)
    local data = RestartLevelMap[lv]
    return data ~= nil
end

function GetEquipLingqiQuality(quality)
    return GetQualityImgGlobal(quality)
end

function GetEquipPosName(pos)
    return GetStr(1030210 + pos)
end