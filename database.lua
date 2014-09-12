Database = {}
Database.__index = Database

function Database.init(dbName)
    local db = {}
    setmetatable(db, Database)
    if storage[dbName] == nil then
        storage[dbName] = json.stringify({
            ["tables"]={}
        })
    end
    db.name = dbName
    db.db = json.parse(storage[dbName])
    return db
end

function Database:read(request)
    if request.query["table"] == nil then
        return {["response"]="error", ["message"]="No table selected."}
    end
    tableName = "" .. request.query["table"]
    request.query["table"] = nil
    if self.db["tables"][tableName] == nil then
        return {}
    end
    dbtable = self.db["tables"][tableName]

    dbtable = {
        {
            ["id"]="1",
            ["name"]="Andrew",
            ["phone"]="534",
            ["location"]="Blacksburg"
        },
        {
            ["id"]="2",
            ["name"]="Bill",
            ["phone"]="534",
            ["location"]="Fredericksburg"
        },
        {
            ["id"]="3",
            ["name"]="John",
            ["phone"]="534",
            ["location"]="Blacksburg"
        },
        {
            ["id"]="4",
            ["name"]="Frank",
            ["phone"]="534",
            ["location"]="Newark"
        }
    }
    
    for value,_ in pairs(request.query) do
        local i = 1
        while dbtable[i] ~= nil do
            if dbtable[i][value] == nil then
                dbtable.remove(dbtable, i)
            else
                if dbtable[i][value] ~= request.query[value] then
                    table.remove(dbtable, i)
                else
                    i = i + 1
                end
            end
        end
    end
    return dbtable
end

function Database:write(request)
    if request.query["table"] == nil then
        return {["response"]="error", ["message"]="No table selected."}
    end
    return 'write'
end

function Database:update(request)
    if request.query["table"] == nil then
        return {["response"]="error", ["message"]="No table selected."}
    end
    return 'update'
end

function Database:delete(request)
    if request.query["table"] == nil then
        return {["response"]="error", ["message"]="No table selected."}
    end
    tableName = "" .. request.query["table"]
    request.query["table"] = nil
    if self.db["tables"][tableName] ~= nil then
        -- Go ahead and delete stuff.
        dbtable = self.db["tables"][tableName]
        if #request.query == 0 then
            dbtable = {}
        else
            for value,_ in pairs(request.query) do
                local i = 1
                while dbtable[i] ~= nil do
                    if dbtable[i][value] == nil then
                        i = i + 1
                    else
                        if dbtable[i][value] == request.query[value] then
                            table.remove(dbtable, i)
                        else
                            i = i + 1
                        end
                    end
                end
            end
        end
        self.db["tables"][tableName] = dbtable
        storage[self.name] = json.stringify(db.db)
    end
    return {["response"]="success",["message"]="Delete successful."}
end


function Database:dump()
    return self.db
end

local db = Database.init("wooo")


return json.stringify(db:delete(request))
