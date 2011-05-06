#!/bin/bash

ROOT="${BASH_SOURCE[0]}";
if([ -h "${ROOT}" ]) then
  while([ -h "${ROOT}" ]) do ROOT=`readlink "${ROOT}"`; done
fi
ROOT=$(cd `dirname "${ROOT}"` && pwd)

pushd "${ROOT}" >/dev/null

echo "--> building json2lua"

cat src/sh/bootstrapper.sh > json2lua

echo -e '\n\n${LUA} -e "' >> json2lua

echo -e '
local NO_PRETTY_PRINT = ${NO_PRETTY_PRINT}
local MAX_WIDTH = ${MAX_WIDTH}
local INDENT_STR = '"'"'${INDENT_STR}'"'"'
local FORCE_NUM_KEYS = ${FORCE_NUM_KEYS}
local SKIP_TERMINATING_EOL = ${SKIP_TERMINATING_EOL}
local PREFIX_WITH_RETURN = ${PREFIX_WITH_RETURN}

--------------------------------------------------------------------------------
' >> json2lua

cat src/lua/json2lua.lua >> json2lua

echo -e "\n\"" >> json2lua

popd >/dev/null

