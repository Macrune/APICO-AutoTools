function get_all_tools()
    local game_dictionary = api_describe_dictionary(false)

    -- Tools tables
    dictTools = {}
    dictAxes = {}
    dictPickaxes = {}
    dictSpades = {}

    --Target tables
    dictTrees = {}
    dictRocks = {}
    dictSeeds = {}

    for key, val in pairs(game_dictionary) do
        -- Checks if item is an axe and then add them to table
        if string.find(key, "axe") and not string.find(key, "pickaxe") then
            if not tableContain(ignoreAxes, key) then
                table.insert(dictAxes, key)
            end
        end

        -- Checks if item is a pickaxe and then add them to table
        if string.find(key, "pickaxe") then
            if not tableContain(ignorePickaxes, key) then
                table.insert(dictPickaxes, key)
            end
        end

        -- Checks if item is a spade and then add them to table
        if string.find(key, "spade") then
            if not tableContain(ignoreSpades, key) then
                table.insert(dictSpades, key)
            end
        end 
        
        if val["category"] == "Tools" then
            if not tableContain(dictAxes, key) and  not tableContain(dictPickaxes, key) and not tableContain(dictSpades, key) then
                if not tableContain(ignoreTools, key) then
                    table.insert(dictTools, key)
                end
            end
        end
        
        --Checks if item has tools description for target tables
        if val["tools"] ~= nil then
            for _, tool in pairs(val["tools"]) do
                if tool ~= nil then
                    --If tool is an axe then its a tree
                    if string.find(tool, "axe") and not string.find(tool, "pickaxe") then
                        if not tableContain(ignoreTree, key) then
                            table.insert(dictTrees, key)
                        end
                    end

                    --If tool is a pickaxe then its a rock
                    if string.find(tool, "pickaxe") then
                        if not tableContain(ignoreRock, key) then
                            table.insert(dictRocks, key)
                        end
                    end

                    --if tool is a spaded then its a seed
                    if string.find(tool, "spade") then
                        if not tableContain(ignoreSeed, key) then
                            table.insert(dictSeeds, key) 
                        end
                    end
                end
            end
        end
    end
    
    --Combine the dicts tables with the add tables from data
    for _, v in pairs(addTools) do table.insert(dictTools, v) end
    for _, v in pairs(addAxes) do table.insert(dictAxes, v) end
    for _, v in pairs(addPickaxes) do table.insert(dictPickaxes, v) end
    for _, v in pairs(addSpades) do table.insert(dictSpades, v) end
    for _, v in pairs(addTree) do table.insert(dictTrees, v) end
    for _, v in pairs(addRock) do table.insert(dictRocks, v) end
    for _, v in pairs(addSeed) do table.insert(dictSeeds, v) end
    
    dump(dictTools)
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
    end
    api_log("dump", str)
end

function tableContain(table, value)
    if not (next(table) == nil) then
        for i=1, #table, 1 do
            if table[i] == value then
                return true
            end
        end
    end
    return false
end

function check_highlight()
    local highlighted = api_get_highlighted('obj')

    local isUsingTool = check_tool_equiped()

    if highlighted ~= nil and not isUsingTool then
        local inst = api_get_inst(highlighted)
        if inst ~= nil then
            if tableContain(dictTrees, inst["oid"]) then
                return "axe"
            end

            if tableContain(dictRocks, inst["oid"]) then
                return "pickaxe"
            end

            if tableContain(dictSeeds, inst["oid"]) then
                return "spade"
            end
        end
    else
        return nil
    end
    
end

function check_tool_equiped()
    local equipped = api_get_equipped()
    local isTool = false
    for _, tool in pairs(dictTools) do
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
            tool_index = api_slot_match(player_id, dictAxes, true)
        elseif tool == "pickaxe" then
            tool_index = api_slot_match(player_id, dictPickaxes, true)
        elseif tool == "spade" then
            tool_index = api_slot_match(player_id, dictSpades, true)
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