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

  -- turn on devmode
  api_set_devmode(true)

  -- log to the console
  api_log("init", "Hello World!")

  -- if you dont return success here your mod will not load
  -- this can be useful if your define fails as you can decide to NOT return "Success" to tell APICO 
  -- that something went wrong and to ignore your mod
  
  return "Success"
end


function ready()
  api_get_data()
  api_log("ready", "getting tools")
  get_all_tools()
  api_log("ready", "loaded mod")
end

function data(ev, data)
  if ev == "LOAD" and data ~= nil then
    tools = data["tools"]
    axes = data["axes"]
    pickaxes = data["pickaxes"]
    spades = data["spades"]
    tree = data["tree"]
    rock = data["rock"]
    seed = data["seed"]
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