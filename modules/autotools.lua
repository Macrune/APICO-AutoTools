
function check_highlight()
    local highlighted = api_get_highlighted('obj')

    local isUsingTool = check_tool_equiped()

    if highlighted ~= nil and not isUsingTool then
        local inst = api_get_inst(highlighted)
        if inst ~= nil then
            if inst["oid"] == "tree" or inst["oid"] == "bush" then
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
    local tools = {"axe1", "axe2", "axe3", "axe4",
            "pickaxe1", "pickaxe2", "pickaxe3",
            "spade1", "spade2", "spade3",
            "hammer1", "hammer2", "hammer3",
            "shovel3", "net", "paintbrush", "scrapper",
            "mag", "pencil", "wateringcan"}

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
    local axes = {"axe1", "axe2", "axe3", "axe4"}
    local pickaxes = {"pickaxe1", "pickaxe2", "pickaxe3"}
    local spades = {"spade1", "spade2", "spade3"}
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
            api_sp(player_id, "hotbar", tool_index)
        end

        return cur_index
    else
        return nil
    end
    
end

function return_to_index(index)
    if index ~= nil then
        local player_id = api_get_player_instance()
        api_log("return_to_index", "hotbar returned")
        api_sp(player_id, "hotbar", index)
    end 
end