pcall(require, 'luarocks.require') -- Ignoring errors

local json_decode, json_util, json_decode_util
do
  local json, err = pcall(require, 'json')
  if not json then
    io.stdout:write(
        err, '\n\n',
        'try running \'luarocks install luajson\'', '\n'
      )
    io.stdout:flush()
    os.exit(1)
  end

  json_util = require('json.util')
  json_decode = require('json.decode')
  json_decode_util = require('json.decode.util')

  if
    FORCE_NUM_KEYS and
    not json_decode_util.setObjectKeyForceNumber
  then
    -- TODO: Traverse table manually in this case.
    error(
        'can\'t force numeric keys:\ninstalled luajson version'
     .. ' does not support setObjectKey option'
      )
  end
end

--------------------------------------------------------------------------------

do -- Bootstrap lua-nucleo
  local res, err = pcall(require, 'lua-nucleo.module')
  if not res then
    io.stdout:write(
        err,
        '\n\n',
        'try running \'luarocks install lua-nucleo\'',
        '\n'
      )
    io.stdout:flush()
    os.exit(1)
  end

  require('lua-nucleo.strict')
end

--------------------------------------------------------------------------------

local input = assert(io.stdin:read('*a'))

-- Using simple decoding since we need nulls to be translated to nils.
local decode_options = json_decode.simple

if FORCE_NUM_KEYS then
  decode_options = json_util.merge(
      {
        object =
        {
          setObjectKey = json_decode_util.setObjectKeyForceNumber;
        };
      },
      decode_options
    )
end

local data, err = json_decode(input, decode_options)
if err then
  error('luajson error: ' .. err)
end

if PREFIX_WITH_RETURN then
  io.stdout:write('return ')
end

if NO_PRETTY_PRINT or type(data) ~= 'table' then
  local tstr = import 'lua-nucleo/tstr.lua' { 'tstr' }
  io.stdout:write(tstr(data))
else
  local tpretty = import 'lua-nucleo/tpretty.lua' { 'tpretty' }
  io.stdout:write(tpretty(data, INDENT_STR, MAX_WIDTH))
end

if not SKIP_TERMINATING_EOL then
  io.stdout:write('\n')
end

io.stdout:flush()
