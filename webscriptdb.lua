local print_r = require "amussey/lib/lua/print_r"

function response_error(message)
    return {["response"]="error", ["message"]=message}
end

if request.scheme == "http" then
    return response_error("Please use https.")
end

users = {
    {
        ["username"]="root",
        ["password"]="asdf",
        ["access"]="rw"
    },
    {
        ["username"]="root2",
        ["password"]="asf",
        ["access"]="ro"
    },
}


db = {
    ["tables"]={
        ["table1"]={},
        ["table2"]={}
    }
}

if false then
  return request
end

local dbread = false
local dbwrite = false

local i = 1
while users[i] ~= nil and not dbread and not dbwrite do
    if request.headers["X-Auth-Username"] == users[i]["username"] and request.headers["X-Auth-Password"] == users[i]["password"] then
        if users[i]["access"] == "rw" then
            dbread = true
            dbwrite = true
        elseif users[i]["access"] == "ro" then
            dbread = true
        end
    end
    i = i + 1
end

if not dbread and not dbwrite then
    return response_error("Incorrect credentials.")
end

-- GET    = read
-- POST   = write
-- PUT    = update
-- DELETE = delete
if request.method == "GET" then
    return "read"
elseif request.method == "POST" then
    if not dbwrite then
        return response_error("Insufficient permissions to insert.")
    end
    return "write"
elseif request.method == "PUT" then
    if not dbwrite then
        return response_error("Insufficient permissions to update.")
    end
    return "update"
elseif request.method == "DELETE" then
    if not dbwrite then
        return response_error("Insufficient permissions to delete.")
    end
    return "delete"
end


-- storage.users = json.stringify(users)

return response_error("Method not supported.") -- json.parse(storage.users)
