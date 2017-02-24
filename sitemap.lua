local http = require "requests"
local xpath = require "luaxpath"
local lom = require "lxp.lom"
local cjson = require "cjson"
local requests = {}
local offset = 1

init = function(args)
    local sitemap = args[0]

    local response = http.get(sitemap)
    local root = lom.parse(response.text)
    local selected = xpath.selectNodes(root, '//url/loc')
    for i, node in pairs(selected) do
        requests[#requests+1] = wrk.format('GET', node[1], {}, '')
    end
end

request = function()
    local request = requests[offset]
    offset = offset + 1
    if not requests[offset] then
        offset = 1
    end

    return request
end
