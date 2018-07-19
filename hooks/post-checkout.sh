#!/bin/bash

echo 'POST CHECKOUT!!!'

NPM_RUN_BUILD_EXIT_STATUS=1
if [[ -f package.json ]]; then

echo '2222'

    NPM_RESOURCES=( 'package.json' 'package-lock.json' 'npm-shrinkwrap.json' )
    npm run --parseable | tee /dev/null | grep -q -v "\^build:"
    NPM_RUN_BUILD_EXIT_STATUS=$?
    for NPM_RESOURCE in "${NPM_RESOURCES[@]}"
    do
        DIFF=`git diff --shortstat $1..$2 -- ${NPM_RESOURCE}`
        if [[ $DIFF != "" ]]; then
            if [[ $NPM_RUN_BUILD_EXIT_STATUS -eq 0 ]]; then
                echo -e "\033[1;33m${NPM_RESOURCE} has changed. Please run \"npm install && npm run build\"\033[0m"
            else 
                echo -e "\033[1;33m${NPM_RESOURCE} has changed. Please run \"npm install\"\033[0m"
            fi
            break
        fi
    done
fi

if [[ -f gulpfile.js ]] && [[ ! -f webpack.config.js ]]; then
    DIFF=`git diff --shortstat $1..$2 -- gulpfile.js skin`
    if [[ $DIFF != "" ]]; then
        if [[ $NPM_RUN_BUILD_EXIT_STATUS -eq 0 ]]; then
            echo -e "\033[1;33mgulpfile.js or skin folder has changed. Please run \"node_modules/.bin/gulp build\"\033[0m"
        fi
    fi
fi

if [[ -f webpack.config.js ]] && [[ $NPM_RUN_BUILD_EXIT_STATUS -eq 0 ]]; then
    DIFF=`git diff --shortstat $1..$2 -- gulpfile.js webpack.config.js skin js`
    if [[ $DIFF != "" ]]; then
        if [[ $NPM_RUN_BUILD_EXIT_STATUS -eq 0 ]]; then
            echo -e "\033[1;33mgulpfile.js, webpack.config.js, skin, or js have changed. Please run \"npm run build\"\033[0m"
        fi
    fi
fi

