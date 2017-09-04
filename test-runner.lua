local dir  = require("pl.dir")
local file = require("pl.file")
local json = require("dkjson")
local path = require("pl.path")

--[[
print(arg)
print(arg[0])
for a,b in pairs(arg) do
	print(a, b)
end


function script_path()
local str = debug.getinfo(2, "S").source:sub(2)
return str:match("(.*/)")
end

print(script_path())


--]]
--print(c)
--[[
local parentpath = path.relpath("..")
print(parentpath)
--]]
--local currentdir = path.currentdir()
--print(currentdir)


--------------------
-- CONFIG HELPERS --
--------------------

local function get_project_root_path()
	return ".."
end

local function get_tests_data_path()
	return "data"
end

local function load_json_file(p)
	assert(path.exists(p), "File " .. p .. " doesn't exist")
	assert(path.isfile(p), p .. " isn't a file")

	local file_contents = file.read(p)
	local decoded_json = json.decode(file_contents)
	return assert(decoded_json, "Couldn't parse the JSON file")
end


------------------
-- TEST HELPERS --
------------------

local function run_commands(commands)
end

local function build_generator(generator_data_path)
end

local function test_generator(generator_data_path)
	local generator_data_config_path = path.join(generator_data_path, "test.json")
	local generator_data_config = load_json_file(generator_data_config_path)

	describe(generator_data_config.name .. ":", function()
		--[[
		if not generator_data_config.success then
		end
		--]]

		setup(function()
			print("setup")
		end)

		--[[
		teardown(function()
			print("teardown")
		end)

		before_each(function()
			print("before each")
		end)

		after_each(function()
			print("after each")
		end)
		--]]

		---[[
		it("test1", function()
		end)

		it("test2", function()
		end)
		--]]
	end)
end

local function test_config(project_config)
	describe(project_config.name .. ":", function()
		for _, generator_data_path in ipairs(dir.getdirectories(tests_data_path)) do
			test_generator(generator_data_path)
		end
	end)
end


--------------------
-- TEST DATA PATH --
--------------------

local tests_data_dir = get_tests_data_path()
tests_data_path = tests_data_dir
--assert(path.exists(tests_data_path), p .. " doesn't exist")


--------------------
-- PROJECT CONFIG --
--------------------

local project_root_path = get_project_root_path()
local project_config_file = "textgen-tests-config.json"
local project_config_path = path.join(project_root_path, project_config_file)
local project_configs = load_json_file(project_config_path)
assert(type(project_configs) == "table", "The config file must contain an array of generator configurations")

for _, project_config in pairs(project_configs) do
	test_config(project_config)
end
