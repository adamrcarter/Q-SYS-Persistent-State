--v0.1 Uses named components to gather state information (Currently only Value property of controls).

function loadState()
  local rapidjson = require('rapidjson')
  result = rapidjson.load('design/state.json')
  return result
end

function saveState(stateTable)
  local rapidjson = require('rapidjson')
  success, err = rapidjson.dump(stateTable, 'design/state.json', {pretty=true})
  return success, err
end

function constructComponentTable()
  local compTable = {}
  local components = Component.GetComponents()
  for i, _comp in pairs(components) do
        compTable[_comp["Name"]] = getControls(Component.New(_comp["Name"]))
        --setupEventHandlers(_comp["Name"])  
  end
  return compTable
end

function getControls(component)
  local controlsTable = {}
  for name, comp in pairs(component) do
    controlsTable[name] = comp.Value 
  end
  return controlsTable
end

function setControlValue(value, componentName, controlName)
  local component = Component.New(componentName)
  local controlValue = component[controlName].Value
  if controlValue ~= value then 
    component[controlName].Value = value 
    return 1
  else return 0 
  end  
end

function applyLoadedState(loadedState) 
  local tempComponent
  for compName, comp in pairs(loadedState) do
    tempComponent = Component.New(compName)
    for controlName, controlValue in pairs(comp) do
      tempComponent[controlName].Value = controlValue
    end
  end
end
  
function changedValueHandler(control)
  local rapidjson = require("rapidjson")
  local compTable = constructComponentTable()
  saveState(compTable)
  --print(control.Value)
  --print(rapidjson.encode(loadState(), {pretty=true}))
end

function setupEventHandlers(componentName) 
  for key, control in pairs(Component.New(componentName)) do
    control.EventHandler = changedValueHandler
  end
end
local components = Component.GetComponents()
  for i, _comp in pairs(components) do
        print("assigning handlers...", _comp["Name"])
        setupEventHandlers(_comp["Name"])  
  end
saveState(constructComponentTable())
loadedstate = loadState()
--applyLoadedState(loadedstate)
 
local rapidjson = require("rapidjson")

print(rapidjson.encode(loadedstate, {pretty=true}))