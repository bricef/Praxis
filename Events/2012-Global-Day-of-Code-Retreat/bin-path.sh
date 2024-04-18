#!/bin/bash



if [ "$1" = "on" ]; then
  OLD_PATH=$PATH
  for dir in `find $(pwd)/node_modules/ -wholename "*/node_modules/*/bin"`; do 
    PATH=$dir:$PATH; 
  done

  export OLD_PATH
  export PATH
elif [ "$1" = "off" ]; then
  PATH=$OLD_PATH
  export PATH
fi


