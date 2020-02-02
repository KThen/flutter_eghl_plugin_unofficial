# eGHL SDK Flutter Plugin
## Flutter Plugin Creation Steps
1. Launch `Android Studio`.
2. Click on `New Flutter Project`, or on menu bar click on `File > New > New Flutter Project`.
3. Select `Flutter Plugin` from the list of project choices.
4. Click `next`.
5. Change `Project name` to `eghl_plugin_unofficial`.
6. Click `Finish` to create Flutter Plugin project.

## v2.5.0  Port Over Steps for Android
### `.aar` Modification
1. Checkout Git project from https://bitbucket.org/eghl/android.
2. Retrieve the `eghl-sdk-v2.5.0.aar` file from the root directory.
3. Change extension of `.aar` to `.zip`.
4. Decompress the `.zip` file.
5. Open `AndroidManifest.xml`.
6. On the `<application>` tag remove `android:label` attribute.
7. Save and overwrite `AndroidManifest.xml`.
8. Open `res/values/values.xml`.
9. Find within `<style name="AppTheme">` there are 3 `<item>` children tags.
10. Add android in front of **EACH AND EVERY** name attribute of the item tags. For example `<item name="android:colorPrimary">`.
11. Save and overwrite `values.xml`.
12. Recompress all the files back into a `.zip` file.
13. Remember to rename the `.zip` extension and change the name back into `eghl-sdk-v2.5.0.aar`.

Note: If during decompression of the `.zip` file a root directory folder is created, i.e. `eghl-sdk-v2.5.0`, remember to recompress the files within without this root directory folder after editing the files.

### Include `.aar` in Plugin
1. There are 2 android folders that are created when the Flutter Plugin project is initialized. One is `${plugin_folder}/android` and the other is `${plugin_folder}/example/android`.
2. Navigate to `${plugin_folder}/android`.
3. Create a new folder within this directory called `eghl-sdk`. Make sure it is at the same level as the `src` directory.
4. Copy the modified `.aar` file just now and paste it in this directory, then press `OK`.
5. Open `${plugin_folder}/android/build.gradle`.
6. At the very bottom of the file after the `android` braces, add the following.
```
dependencies {
    implementation files('eghl-sdk/eghl-sdk-v2.5.0.aar')

    implementation 'com.android.support:appcompat-v7:28.0.0'
    implementation 'com.android.support:design:28.0.0'
}
```
7. Change `minSdkVersion` to `19`.
8. Open `${plugin_folder}/example/android/app/build.gradle`.
9. Change `minSdkVersion` to `19`.

Note: During the writing of this README the `compileSdkVersion` is `28`. The Gradle version is also upgraded, and gradle build tools `com.android.tools.build:gradle` were also upgraded to version `3.5.3`.

## v2.5.0  Port Over Steps for iOS
### Checkout Framework
1. Checkout Git project from https://bitbucket.org/eghl/ios.
2. Make sure there is a `SDK` folder and within it there should be 1 file1 `EGHL.bundle` and 1 folder `EGHL.framework`. We will use both these later.

### Include `EGHL.bundle` and `EGHL.framework` in Plugin
1. Once the project is built, right click on `{plugin_folder}/ios > Flutter > Open iOS module in Xcode`.
2. On the side menu, select the `folder` icon then expand `Runner > Runner` and expand `Runner > Frameworks`.
3. Drag the `EGHL.bundle` that is checked out from Git into `Runer > Runner` folder.
4. Click `Finish`.
5. Drag the `EGHL.framework` folder that is checked out from Git into `Runner > Flutter` folder.
6. Click `Finish`.
7. On the side menu click on the `Runner` main project.
8. Navigate to `Build Phases`.
9. Under the `Embed Frameworks` section, click the `+` button and select `Runner > Flutter > EGHL.framework`, click `Add`.
