fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios generate_appicon

```sh
[bundle exec] fastlane ios generate_appicon
```

Generate App Icons

### ios build_number

```sh
[bundle exec] fastlane ios build_number
```



### ios version_number

```sh
[bundle exec] fastlane ios version_number
```

Generate the version number

For now we will use the date in the YYYY.MM.DD format

### ios load_asc_api_key

```sh
[bundle exec] fastlane ios load_asc_api_key
```

Load ASC API Key information to use in subsequent lanes

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Capture Screenshots

### ios release

```sh
[bundle exec] fastlane ios release
```

Push a new release build to the App Store

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
