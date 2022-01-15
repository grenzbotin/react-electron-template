# react-electron-template

### Content

- proxy setup
- linter setup (eslint)
- prettier setup
- proxy setup (http-proxy-middleware)
- electron auto updater

### Windows setup (WSL)

Requirements:

- WSL2, Node
- yarn
- update with `sudo apt update`
- install `sudo apt install libgconf-2-4 libatk1.0-0 libatk-bridge2.0-0 libgdk-pixbuf2.0-0 libgtk-3-0 libgbm-dev libnss3-dev libxss-dev`
- install [VcXsrv](https://techcommunity.microsoft.com/t5/windows-dev-appconsult/running-wsl-gui-apps-on-windows-10/ba-p/1493242) on your machine
- Setup firewall rules:

```
System settings -> System and Security -> Allow app or feature via Windows Defender

-> Add other app
-> select vcxsrv.exe -> allow private & public
```

Ensure vcxsrv is running with option `Disable access control`

- Add following to `~/.bashrc`:

```
export DISPLAY=$(ip route list default | awk '{print $3}'):0
export LIBGL_ALWAYS_INDIRECT=1
```

## Development

#### Run in browser

`yarn start`

#### Run electron in dev

`yarn dev`
Should open dev console + electron wrapper

## Generating the builds

#### CI/CD Build

Generating builds via github action is strongly recommended due to the pain of setting up a working local environment for generating builds for all platforms.

The builds are automatically generated via a [github action](https://github.com/marketplace/actions/electron-builder-action)

#### Local build

`package.json`

You can generate build scripts for all platforms using [electron-builder](https://www.electron.build/). Thus I can not recommend, since the challenges to do so are hard to solve:

- Mac apps can only be built on macOS
- With release macOS Catalina support for 32-bit apps got dropped what breaks wine that is a needed base for Windows app building..

```
{
  ...,
  "postinstall": "electron-builder install-app-deps",
  "build:local": "electron-builder --mac --windows --linux",
  "release": "electron-builder --mac --windows --linux --publish always"
}
```

Build information in `package.json`:
Find possible categories in [here](https://specifications.freedesktop.org/menu-spec/latest/apa.html#main-category-registry)

```
"build": {
  "appId": "com.react-electron-template.yourapp",
  "productName": "react-electron-template",
  "mac": {
    "category": "public.app-category.lifestyle"
  },
  "dmg": {
    "icon": false
  },
  "linux": {
    "target": ["AppImage"],
    "category": "Office"
  }
},
```

#### Docker build

Note: You cannot build for Windows using Docker if you have native dependencies and native dependency doesn’t use prebuild.

```
docker run --rm -ti \
 --env-file <(env | grep -iE 'DEBUG|NODE_|ELECTRON_|YARN_|NPM_|CI|CIRCLE|TRAVIS_TAG|TRAVIS|TRAVIS_REPO_|TRAVIS_BUILD_|TRAVIS_BRANCH|TRAVIS_PULL_REQUEST_|APPVEYOR_|CSC_|GH_|GITHUB_|BT_|AWS_|STRIP|BUILD_') \
 --env ELECTRON_CACHE="/root/.cache/electron" \
 --env ELECTRON_BUILDER_CACHE="/root/.cache/electron-builder" \
 -v ${PWD}:/project \
 -v ${PWD##*/}-node-modules:/project/node_modules \
 -v ~/.cache/electron:/root/.cache/electron \
 -v ~/.cache/electron-builder:/root/.cache/electron-builder \
 electronuserland/builder:wine
```

In running container, run electron-builder

```
yarn && ./node_modules/.bin/electron-builder
```

More [Docker images](https://www.electron.build/multi-platform-build#provided-docker-images)
