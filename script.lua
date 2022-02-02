-- MeepCity Avatar Helper
-- made specially for Synapse X

-- original creator: synolope#7126
-- edited version: 8bn#4573

--[[ commits:
    - removed the create character when executing (the hat goes on ur current avatar)
    - fixed some bugs of this update ^
    - removed some useless spaces
]]

local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage")
local Constants = require(l__ReplicatedStorage__2:WaitForChild("Constants"))
local Connection = l__ReplicatedStorage__2:WaitForChild("Connection")
local ConnectionEvent = l__ReplicatedStorage__2:WaitForChild("ConnectionEvent")

function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function AddAccessories(typ,...)
    local ids = {...}
    local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
    local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
    local Accessory = wearing[typ.."Accessory"] or ""
    
    
    local t = string.split(Accessory,",")
    
    for _,id in pairs(ids) do
        if table.find(t,id) then
            table.remove(t,indexOf(t,id))
        end
        id = tostring(id)
        table.insert(t,id)
    end
    
    local dps = {}
    
    for _,id in pairs(t) do
        local duped = false
        for _,dip in pairs(dps) do
            if id == dip then
                duped = true
                break
            end
        end
        if not duped then
            table.insert(dps,id)
        end
    end
    
    t = dps
    
    Accessory = table.concat(t,",")
    
    wearing[typ.."Accessory"] = Accessory
    
    ConnectionEvent:FireServer(315,wearing,true)
end

function RemoveAccessories(typ,...)
    local ids = {...}
    local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
    local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
    local Accessory = wearing[typ.."Accessory"] or ""
    
    
    local t = string.split(Accessory,",")
    
    for _,id in pairs(ids) do
        id = tostring(id)
        table.remove(t,indexOf(t,id))
    end
    
    Accessory = table.concat(t,",")
    
    wearing[typ.."Accessory"] = Accessory
    
    ConnectionEvent:FireServer(315,wearing,true)
end

function RemoveAllAccessories(typ)
    local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
    local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
    
    wearing[typ.."Accessory"] = ""
    
    ConnectionEvent:FireServer(315,wearing,true)
end

function SetShirt(id)
    local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
    local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing

    wearing.Shirt = tonumber(id) or 0
    
    ConnectionEvent:FireServer(315,wearing,true)
end

function SetPants(id)
    local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
    local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
    local Pants = wearing.Pants or 0
    
    local t = string.split(Pants,",")
    
    id = tonumber(id) or 0
    table.insert(t,id)
    
    Pants = table.concat(t,",")
    
    wearing.Pants = Pants
    
    ConnectionEvent:FireServer(315,wearing,true)
end

function SetAttribute(a,val)
    local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
    local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
    wearing[a] = val
    ConnectionEvent:FireServer(315,wearing,true)
end

function GetAttribute(a,val)
    local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
    local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
    return wearing[a]
end

function GetAllAttributes()
    local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
    local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
    return wearing
end

function ResetAvatar()
    ConnectionEvent:FireServer(315,{},true)
end

function SaveAvatar(name)
    local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
    local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
    
    if not isfolder("Meep City Avatar Saves") then
        makefolder("Meep City Avatar Saves")
    end
    
    apath = "Meep City Avatar Saves\\" .. name .. ".json"

    writefile(apath, game:GetService("HttpService"):JSONEncode(wearing))
    
    print("Saved as '" .. name .. "'")
end

function LoadAvatar(name)
    local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
    local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
    
    if not isfolder("Meep City Avatar Saves") then
        makefolder("Meep City Avatar Saves")
    end
    
    apath = "Meep City Avatar Saves\\" .. name .. ".json"

    ConnectionEvent:FireServer(315,game:GetService("HttpService"):JSONDecode(readfile(apath)),true)
    
    print("Loaded '" .. name .. "'")
end

--# examples 

SetShirt(7743066694)
SetPants(7743066694)

SetPants()

AddAccessories("Head",0)
AddAccessories("Hair",4640898) -- ID

RemoveAccessories("Head",0) -- removing "48545806" which we added before ^^ !!

-- we could use RemoveAllAccessories("Head") to remove all head accessories but for now we are not

AddAccessories("Neck",0)

SaveAvatar("example avatar") -- saves the avatar with the name 'example avatar'

LoadAvatar("example avatar") -- why not load it to test! (it would just look the same because we are loading the same avatar we had on)

