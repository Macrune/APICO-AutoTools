function get_all_tools()
    local game_dictionary = api_describe_dictionary(false)

    -- Tools tables
    local dictTools = {}
    local dictAxes = {}
    local dictPickaxes = {}
    local dictSpades = {}

    --Target tables
    local dictTrees = {}
    local dictRocks = {}
    local dictSeeds = {}

    for key, val in pairs(game_dictionary) do
        -- Checks if item is an axe and then add them to table
        if string.find(key, "axe") and not string.find(key, "pickaxe") then
            table.insert(dictAxes, key)
        end

        -- Checks if item is a pickaxe and then add them to table
        if string.find(key, "pickaxe") then
            table.insert(dictPickaxes, key)
        end

        -- Checks if item is a spade and then add them to table
        if string.find(key, "spade") then
            table.insert(dictSpades, key)
        end 

        --Checks if item has tools describtion for target tables
        if val["tools"] ~= nil then
            --Loop to find what tools is usable to target
            for tool in val["tools"] do
                --If tool is an axe then its a tree
                if string.find(tool, "axe") and not string.find(tool, "pickaxe") then
                    table.insert(dictTrees, key)
                end

                --If tool is a pickaxe then its a rock
                if string.find(tool, "pickaxe") then
                    table.insert(dictTrees, key)
                end

                --if tool is a spaded then its a seed
                if string.find(tool, "spade") then
                    table.insert(dictTrees, key)
                end
            end
        end
    end

    api_log("get_all_tools", tostring(count))
    dump(dictAxes)
    dump(dictPickaxes)
    dump(dictSpades)
    dump(dictTrees)
    dump(dictRocks)
    dump(dictSeeds)
end

function dump(o)
    local str = ""
    api_log("dump", "Dumping")
    for _, val in pairs(o) do
        str = str..val.." "

    api_log("dump", str)
    end
end

function check_highlight()
    local highlighted = api_get_highlighted('obj')

    local isUsingTool = check_tool_equiped()

    if highlighted ~= nil and not isUsingTool then
        local inst = api_get_inst(highlighted)
        api_log("check_highlight", tostring(inst["oid"]))
        if inst ~= nil then
            if inst["oid"] == "tree" or inst["oid"] == "shrub" then
                return "axe"
            elseif inst["oid"] == "rock1" or inst["oid"] == "rock2" then
                return "pickaxe"
            elseif inst["oid"] == "sapling1" or inst["oid"] == "sapling2" then
                return "spade"
            else
                return nil
            end
        end
    else
        return nil
    end
    
end

function check_tool_equiped()
    local equipped = api_get_equipped()
    local isTool = false
    for _, tool in pairs(tools) do
        if equipped == tool then
            isTool = true
            break
        end
    end

    return isTool
end

function select_tool()
    local tool = check_highlight()
    if tool ~= nil then
        local player_id = api_get_player_instance()
        local hotbar = api_get_slots(player_id)
        local cur_index = api_get_property(player_id, "hotbar")
        local tool_index = nil

        if tool == "axe" then
            tool_index = api_slot_match(player_id, axes, true)
        elseif tool == "pickaxe" then
            tool_index = api_slot_match(player_id, pickaxes, true)
        elseif tool == "spade" then
            tool_index = api_slot_match(player_id, spades, true)
        end

        if tool_index ~= nil then
            api_sp(player_id, "hotbar", tool_index.index-1)
        end

        return cur_index
    else
        return nil
    end
    
end

function return_to_index(index)
    if index ~= nil then
        local player_id = api_get_player_instance()
        api_sp(player_id, "hotbar", index)
    end 
end