# flutter-mvp-template
This is a MVP project template in Flutter


<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#license">License</a>
</p>

## Key Features

* MVP Core boilerplate code
* Localization (l10n)
* Flavors: dev + prod
* App Icons generator

## How To Use


Create new Flutter project repository with this template repository


Create a key.properties (Git Ignored) and put them in your folder mobile_app/android/key.properties
```bash
#DEV
storePassword_DEV=<storePassword>
keyPassword_DEV=<keyPassword>
keyAlias_DEV=<keyAlias>
storeFile_DEV=<PATH_TO_FILE.keystore>

#PROD
storePassword_PROD=<storePassword>
keyPassword_PROD=<keyPassword>
keyAlias_PROD=<keyAlias>
storeFile_PROD=<PATH_TO_FILE.keystore>
```




From your root project:

```bash
# Get all packages
$ ./helper get

# Reload the project
$ ./helper reload

# Generate App Icon (Android + iOS) from the folder assets/dev_assets/
$ ./helper genAppIcon
```

## License

MIT

