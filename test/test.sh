#!/bin/bash

ROOT="${BASH_SOURCE[0]}";
if([ -h "${ROOT}" ]) then
  while([ -h "${ROOT}" ]) do ROOT=`readlink "${ROOT}"`; done
fi
ROOT=$(cd `dirname "${ROOT}"` && pwd)

pushd "${ROOT}" >/dev/null

../make.sh

echo "--> running ad-hoc tests"

for f in data/*.json; do

  f=${f%.json}
  f=${f#json/}

  ERROR_MSG=`../json2lua -rN <${f}.json 2>&1 | grep "stack traceback:" -B1 -A100`

  if [[ $ERROR_MSG ]]; then
    echo "${f}.json: failed:"
    ../json2lua -rN <${f}.json 2>&1
    continue
  else
    echo "${f}.json: OK"
  fi

done

popd >/dev/null

