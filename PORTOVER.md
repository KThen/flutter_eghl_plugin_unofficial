# Portover Steps in Detail
Note that during the writing down of these steps, they are done on `MacOS`. Steps on `Windows` may differ.

## Creating Plugin Project
1. Open `Android Studio`. On the `Welcome to Android Studio` screen click on `Start a new Flutter project`.
2. On the `Create New Flutter Project` screen select `Flutter Plugin`. Click `Next`.
3. In the `Configure the new Flutter plugin` section under `Project name` text field type in `eghl_plugin_unofficial`. Change the `Description` text field to `eGHL payment plugin. Unofficial version. Please use the official version.`. Click `Next`.
4. In the `Set the package name` section under `Package name` text field type in `me.kthen.eghlpluginunofficial`. Under `AndroidX` make sure the `Use androidx.* artifacts` checkbox is checked. Under `Platform channel language` uncheck both `Include Kotlin support for Android code` and `Include Swift support for iOS code` checkboxes. Click `Finish`.

## Porting for Android
### Prerequisites
1. Checkout the [eGHL Android library files](https://bitbucket.org/eghl/android/src/master/) from `Git`. You can either do a checkout or download as `.zip`. Make sure to get the `.aar` files. At the point of writing this documentation the `.aar` library is named `eghl-sdk-v2.5.2-X.aar`. Note that version number may differ depending on whether `eGHL` updated their library.

### Preparing the `.aar` file for use
1. For the library to work we need to do some preparation because the library is not directly compatible with `Flutter` as a plugin.
2. Create a new folder somewhere. Then copy the library `eghl-sdk-v2.5.2-X.aar` into this folder.
3. Right click on `eghl-sdk-v2.5.2-X.aar` and select `Rename` and rename it to `eghl-sdk-v2.5.2-X.zip`. It will show a prompt `Are you sure you want to change the extension from ".aar" to ".zip"?`, click `Use .zip`.
4. Now extract this `eghl-sdk-v2.5.2-X.zip` file. On `MacOS` just double clicking it will do. You will now see a folder `eghl-sdk-v2.5.2-X`.
5. Navigate into the folder `eghl-sdk-v2.5.2-X` that we just unzipped. Open the `AndroidManifest.xml` with any text editor of your liking. We are using `VS Code` during the documenting of these steps.
6. Search for the `application` tag in the `XML`. If there is an attribute `android:label` on it then remove the whole attribute and its values. In this version of the library we will be removing `android:label="@string/app_name"` from the `application` tag. Save and overwrite this `AndroidManifest.xml` file. We're done with this.
7. Now go back to the `eghl-sdk-v2.5.2-X` folder and open the `res > values > values.xml` file.
8. Search for the `style` tag with the attribute and value `name="AppTheme"`. At the time of this writing it looks like this `<style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">`. Within this tag there are 3 color `item` tags defined. On the `name` attribute, append `android:` to the front of the values. For example we are changing

        <item name="colorPrimary">@color/primary</item>
        <item name="colorPrimaryDark">@color/primary_dark</item>
        <item name="colorAccent">@color/accent</item>

    to

        <item name="android:colorPrimary">@color/primary</item>
        <item name="android:colorPrimaryDark">@color/primary_dark</item>
        <item name="android:colorAccent">@color/accent</item>
    . Save and overwrite this `values.xml` file. We're done with this.
9. Now go back to the root folder, which is the folder where `AndroidManifest.xml` file is located at. Select everything in this folder, right click and select `Compress X items`. At time of writing it is `Compress 15 items`. You will now get a `.zip` file, in our case it is called `Archive.zip`.
10. Right click on this `Archive.zip` file and select `Get info`. In the `Archive.zip Info` screen under `Name & Extension:` there should be a text field. Change the value of this text field from `Archive.zip` to `eghl-sdk-v2.5.2-X.aar` then hit [ENTER]. It will show a prompt `Are you sure you want to change the extension from ".zip" to ".aar"?`, click `Use .aar`. You can now close the `Archive.zip Info` screen, we're done with the preparation.

### Using `.aar` file in the Flutter plugin
1. Navigate back to `Android Studio` to our `Flutter` plugin project. On the left side panel expand the `eghl_plugin_unofficial [eghlpluginunofficial]` folder. We should see an `android` folder, an `ios` folder, a `lib` folder and other folders and files. Expand the `android` folder.
2. Right click on the `android [eghlpluginunofficial_android]` folder and select `New > Directory`. It will prompt for a name `Enter new directory name:`. Name it `eghl-sdk` then click `OK`.
3. Copy the modified `eghl-sdk-v2.5.2-X.aar` library file that we prepared earlier and paste it into this `eghl-sdk` folder. It will show a prompt for changing the name, don't change the name and just click `OK`.
4. Under this directory `android [eghlpluginunofficial_android]` we should also see a `build.gradle` file. Double click to open it.
5. At the very very bottom of this `build.gradle` file, add the following code after the `android { }` block closing brace. Please note that the library and the version for `appcompat`, `design` and `volley` may have new versions released, try to adjust it as you see fit.

        dependencies {
          implementation files('eghl-sdk/eghl-sdk-v2.5.2-X.aar')

          implementation 'com.android.support:appcompat-v7:28.0.0'
          implementation 'com.android.support:design:28.0.0'
          implementation 'com.android.volley:volley:1.1.0'   
        }
6. In the `android { }` block on top change

        defaultConfig {
          minSdkVersion 16
        }

    to

        defaultConfig {
          minSdkVersion 19
        }
    .
7. Now scroll back to the top and upgrade the gradle package. At point of writing we changed

        buildscript {
          repositories {
            google()
            jcenter()
          }

          dependencies {
            classpath 'com.android.tools.build:gradle:3.5.0'
          }
        }

    to

        buildscript {
          repositories {
            google()
            jcenter()
          }

          dependencies {
            classpath 'com.android.tools.build:gradle:3.6.2'
          }
        }
    .

## Porting for iOS
### Prerequisites
1. Checkout the [eGHL iOS library files](https://bitbucket.org/eghl/ios/src/master/) from `Git`. You can either do a checkout or download as `.zip`. Make sure to get the `EGHL.bundle` and `EGHL.framework` files in the `SDK` folder.

### Using `EGHL.framework` and `EGHL.bundle` files in the Flutter plugin
1. Navigate back to `Android Studio` to our `Flutter` plugin project. On the left side panel expand the `ios` folder. We should see an `Assets` folder, a `Classes` folder, and a `eghlpluginunofficial.podspec` file.
2. Copy the `EGHL.framework` file and the `EGHL.bundle` folder and paste them both into this `ios` folder. It will show a prompt `Copy specified directories`, just click `OK`. The `ios` folder should now contain `Assets`, `Classes`, `EGHL.framework`, `EGHL.bundle` and `eghlpluginunofficial.podspec` file.
3. Double click to open the `eghlpluginunofficial.podspec` file.
4. At the very very bottom of this file between `end` and the `s.pod_target_xcconfig` configuration add the following lines.

        s.preserve_paths = 'EGHL.framework'
        s.xcconfig = { 'OTHER_LDFLAGS' => '-framework EGHL' }
        s.vendored_frameworks = 'EGHL.framework'
        s.resources = 'EGHL.bundle'

    The bottom of the `eghlpluginunofficial.podspec` file should now look like this

          # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
          s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }

          s.preserve_paths = 'EGHL.framework'
          s.xcconfig = { 'OTHER_LDFLAGS' => '-framework EGHL' }
          s.vendored_frameworks = 'EGHL.framework'
          s.resources = 'EGHL.bundle'
        end
