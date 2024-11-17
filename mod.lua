MOD_NAME = 'auto_tools'

function register()

  api_log("register", "auto_tools register")

  return {
    name = MOD_NAME,
    hooks = {"ready", "click"}, -- subscribe to hooks we want so they're called
    modules = {"autotools"} -- load other modules we need, in this case "/modules/define.lua" and "/modules/scripts.lua"
  }
end

-- init is called once registered and gives you a chance to run any setup code
function init() 

  api_set_devmode(true)
  api_get_data()
  
  return "Success"
end


function ready()
  
  api_log("ready", "getting tools")
  get_all_tools()
  api_log("ready", "loaded mod")
end

function data(ev, data)
  if ev == "LOAD" and data ~= nil then

    addTools = data["addTools"]
    addAxes = data["addAxes"]
    addPickaxes = data["addPickaxes"]
    addSpades = data["addSpades"]
    addTree = data["addTree"]
    addRock = data["addRock"]
    addSeed = data["addSeed"]

    ignoreTools = data["ignoreTools"]
    ignoreAxes = data["ignoreAxes"]
    ignorePickaxes = data["ignorePickaxes"]
    ignoreSpades = data["ignoreSpades"]
    ignoreTree = data["ignoreTree"]
    ignoreRock = data["ignoreRock"]
    ignoreSeed = data["ignoreSeed"]
  end
end

function click(button, click_type)
  if button == "LEFT" and click_type == "PRESSED" then
    api_log("clicl", "left click PRESSED")
    original_index = select_tool()
  elseif button == "LEFT" and click_type == "RELEASED" then
    api_log("clicl", "left click RELEASED")
    return_to_index(original_index)
  end
end