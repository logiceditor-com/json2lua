package = "json2lua"
version = "0.4-1"
source = {
   url = "git://github.com/logiceditor-com/json2lua.git",
   branch = "v0.4"
}
description = {
   summary = "A command-line tool to convert JSON to Lua",
   homepage = "http://github.com/logiceditor-com/json2lua",
   license = "MIT/X11"
}
dependencies = {
   "lua >= 5.1",
   "lua-nucleo >= 0.0.2"
}
build = {
   type = "none",
   install = {
      bin = {
         ["json2lua"] = "json2lua"
      }
   }
}
