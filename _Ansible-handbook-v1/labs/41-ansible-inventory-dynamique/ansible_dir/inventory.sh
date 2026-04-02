#!/usr/bin/env bash

ip="
192.168.100.12
192.168.100.13
"

if [ "$1" = "--list" ]; then
  echo '{'
  echo '  "gp1": {'
  echo '    "hosts": ['

  first=1
  for i in $ip; do
    if [ $first -eq 1 ]; then
      first=0
    else
      echo ','
    fi
    printf '      "%s"' "$i"
  done
  echo
  echo '    ],'
  echo '    "vars": {'
  echo '      "mavariable": "1"'
  echo '    }'
  echo '  },'
  echo '  "_meta": {'
  echo '    "hostvars": {'

  first=1
  for i in $ip; do
    if [ $first -eq 1 ]; then
      first=0
    else
      echo ','
    fi

    if [ "$i" = "192.168.100.12" ]; then
      var1="pp1"
    elif [ "$i" = "192.168.100.13" ]; then
      var1="pp2"
    else
      var1="default"
    fi

    printf '      "%s": {\n' "$i"
    printf '        "var1": "%s"\n' "$var1"
    printf '      }'
  done
  echo
  echo '    }'
  echo '  }'
  echo '}'

elif [ "$1" = "--host" ]; then
  echo '{}'
else
  echo '{}'
fi