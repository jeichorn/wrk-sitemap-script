local http = require "requests"
local xpath = require "luaxpath"
local lom = require "lxp.lom"
local cjson = require "cjson"
local requests = {}
local offset = 1

local function processUrlset(nodes)
    for i, node in pairs(nodes) do
        print("Found Url: ", node[1])
        requests[#requests+1] = wrk.format('GET', node[1], {}, '')
    end
end

init = function(args)
    local sitemap = args[0]

    local response = http.get(sitemap)
    local root = lom.parse(response.text)

    if root.tag == 'sitemapindex' then
        print("Given a sitemap index, pulling in urlsets")
        local selected = xpath.selectNodes(root, '//sitemap/loc')
        for i, node in pairs(selected) do
            print(node[1])
            local response = http.get(node[1])
            local doc = lom.parse(response.text)
            local selected = xpath.selectNodes(doc, '//url/loc')
            processUrlset(selected)
        end
    elseif root.tag == 'urlset' then
        local selected = xpath.selectNodes(root, '//url/loc')
        processUrlset(selected)
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
