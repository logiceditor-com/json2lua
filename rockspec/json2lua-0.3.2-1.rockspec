package = "json2lua"
version = "0.3.2-1"
source = {
   url = "git://github.com/agladysh/json2lua.git",
   branch = "v0.3.2"
}
description = {
   summary = "A command-line tool to convert JSON to Lua",
   homepage = "http://github.com/agladysh/json2lua",
   license = "MIT/X11"
}
dependencies = {
   "lua >= 5.1",
   "luajson >= 1.2",
   "lua-nucleo >= 0.0.1"
}
build = {
   type = "none",
   install = {
      bin = {
         ["json2lua"] = "json2lua"
      }
   }
}
