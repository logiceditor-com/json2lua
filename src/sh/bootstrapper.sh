#! /bin/bash

VERSION="v0.3.2"

# Detect Lua interpreter (prefer LuaJIT 2)
if [ ! -z "${LUA}" ]; then
  if [ -z "$(which ${LUA})" ]; then
    LUA=""
  fi
fi

if [ -z "${LUA}" ]; then
  LUA="luajit2"
  if [ -z "$(which ${LUA})" ]; then
    LUA="luajit"
    if [ -z "$(which ${LUA})" ]; then
      LUA="lua"

      if [ -z "$(which ${LUA})" ]; then
        echo "Error: luajit2, luajit and lua executables not found" >&2
        exit 1
      fi
    fi
  fi
fi

function version()
{
  cat << EOF
JSON to Lua translator ${VERSION}

EOF
}

function usage()
{
  cat << EOF
Usage:

  $0 [options] < in.json > out.lua

Options:

  -h    Print this text
  -v    Print script version
  -n    Do not pretty-print Lua code (default: do pretty-print)
  -wN   Set maximum pretty-print width to N chars (default: 80)
  -iStr Set pretty-print indent to string (default: two spaces, '  ')
  -N    Force object keys to be transformed to numbers
        whenever possible (default: off)
  -e    Do not print terminating EOL (default: do print)
  -r    Prefix data with 'return' (default: off)

EOF
}

NO_PRETTY_PRINT=false
MAX_WIDTH=80
INDENT_STR="  "
FORCE_NUM_KEYS=false
SKIP_TERMINATING_EOL=false
PREFIX_WITH_RETURN=false

while getopts ":hvnw:i:Ner" opt; do
  case ${opt} in
    h)
      version
      usage
      exit 0
      ;;
    v)
      version
      exit 0
      ;;
    n)
      NO_PRETTY_PRINT=true
      ;;
    w)
      MAX_WIDTH="${OPTARG}"
      ;;
    i)
      INDENT_STR="${OPTARG}"
      ;;
    N)
      FORCE_NUM_KEYS=true
      ;;
    e)
      SKIP_TERMINATING_EOL=true
      ;;
    r)
      PREFIX_WITH_RETURN=true
      ;;
    \?)
      echo "unknown option: -${OPTARG}" >&2
      exit 1
      ;;
    :)
      echo "option -${OPTARG} requires an argument" >&2
      exit 1
      ;;
  esac
done