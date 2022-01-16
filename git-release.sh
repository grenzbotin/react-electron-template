#!/bin/bash

gitRelease() {
    echo '📝 Specify version'
    yarn version

    REACT_APP_VERSION="$(node -p -e "require('./package.json').version")"

    git add .
    git commit -m "release version '$REACT_APP_VERSION'"

    git push --tags

    echo '🚀 Pushed new version: '$REACT_APP_VERSION''
}

gitRelease