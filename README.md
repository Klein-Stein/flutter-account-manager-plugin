# Account manager

Account manager for Flutter

Supported platforms:
- Android 8.1+ (API 27+)
- iOS 12+

## Getting Started

### Installation

Add package to your dependencies in **pubspec.yaml**:

 ```
dependencies:
   accountmanager: ^0.3.0
```

And call `flutter pub get` to download new dependencies

### Using

To import module add `import 'package:accountmanager/accountmanager.dart';` at the 
import block in your code.

At this moment plugin can work with Android OS API 27+ and iOS 12+ only. To allow plugin to manage 
accounts you need to add few native code for Android:  

1. Create **xml/authenticator.xml** resource in your Android project folder with next content:  
```
<?xml version="1.0" encoding="utf-8"?>
<account-authenticator
     xmlns:android="http://schemas.android.com/apk/res/android"
     android:accountType="<YOUR_ACCOUNT_TYPE>"
     android:icon="<YOUR_ICON_48DP>"
     android:smallIcon="<YOUR_ICON_24DP>"
     android:label="<YOUR_ACCOUNT_NAME>"/>
```
2. Implement `AbstractAccountAuthenticator` stub:  

**Authenticator.java**
```
public class Authenticator extends AbstractAccountAuthenticator {

    public Authenticator(Context context) {
        super(context);
    }

    @Override
    public Bundle editProperties(AccountAuthenticatorResponse response, String accountType) {
        return null;
    }

    @Override
    public Bundle addAccount(
        AccountAuthenticatorResponse response, String accountType, 
        String authTokenType, String[] requiredFeatures, Bundle options
    ) throws NetworkErrorException {
        return null;
    }

    @Override
    public Bundle confirmCredentials(AccountAuthenticatorResponse response, Account account, 
        Bundle options) throws NetworkErrorException {
        return null;
    }

    @Override
    public Bundle getAuthToken(AccountAuthenticatorResponse response, Account account, 
        String authTokenType, Bundle options) throws NetworkErrorException {
        return null;
    }

    @Override
    public String getAuthTokenLabel(String authTokenType) {
        return null;
    }

    @Override
    public Bundle updateCredentials(AccountAuthenticatorResponse response, Account account, 
        String authTokenType, Bundle options) throws NetworkErrorException {
        return null;
    }

    @Override
    public Bundle hasFeatures(AccountAuthenticatorResponse response, Account account, 
        String[] features) throws NetworkErrorException {
        return null;
    }
}
```

**AuthenticatorService.java**
```
public class AuthenticatorService extends Service {
    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        Authenticator authenticator = new Authenticator(this);
        return authenticator.getIBinder();
    }
}
```

3. Update **AndroidManifest.xml**:

Add required permissions, i.e.:  
```
<uses-permission android:name="android.permission.AUTHENTICATE_ACCOUNTS"/>
<uses-permission android:name="android.permission.GET_ACCOUNTS"/>
<uses-permission android:name="android.permission.MANAGE_ACCOUNTS"/>
<uses-permission android:name="android.permission.WRITE_SYNC_SETTINGS" />
```
And register `AuthenticatorService`:
```
<service android:name=".AuthenticatorService" android:exported="false">
    <intent-filter>
        <action android:name="android.accounts.AccountAuthenticator"/>
    </intent-filter>
    <meta-data
        android:name="android.accounts.AccountAuthenticator"
        android:resource="@xml/authenticator"/>
</service>
```

On Android and iOS devices you also need to request permissions at the runtime. We advice to 
use [permission_handler](https://pub.dev/packages/permission_handler) (the example of using in our 
repository).

```
dependencies:
  permission_handler: ^10.0.0
```

More details about Android authentication system you can find on 
[Android Developers resource](https://developer.android.com/training/id-auth/custom_auth).

**WARNING:** iOS doesn't provide AccountManager entity, our plugin emulates it using 
`UserDefaults.standard` to store all data.