#!/bin/bash

gitRelease() {
    echo '📝 Specify version'
    yarn version

    REACT_APP_VERSION="$(node -p -e "require('./package.json').version")"

    git push origin HEAD --tags

    echo '🚀 Pushed new tag to trigger build on github: '$REACT_APP_VERSION''
}

gitRelease