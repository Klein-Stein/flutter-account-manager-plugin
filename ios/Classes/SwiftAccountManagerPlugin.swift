import Flutter
import UIKit

public class SwiftAccountManagerPlugin: NSObject, FlutterPlugin {
    public let constAccountsPreference = "com.contedevel.account_manager.accounts";
    public let constAccountName = "account_name";
    public let constAccountType = "account_type";
    public let constAuthTokenType = "auth_token_type";
    public let constAccessToken = "access_token";
    public let constRefreshToken = "refresh_token";
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "accountManager", binaryMessenger: registrar.messenger())
        let instance = SwiftAccountManagerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func addAccount(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: String] {
            let preferences = UserDefaults.standard;
            var accounts = preferences.array(forKey: constAccountsPreference) as? [[String: String?]] ?? [[String: String?]]();
            if !accounts.contains(where: { $0[constAccountType] == args[constAccountType] &&
                                    $0[constAccountName] == args[constAccountName] }) {
                accounts.append([
                    constAccountName: args[constAccountName],
                    constAccountType: args[constAccountType],
                    constAuthTokenType: args[constAuthTokenType],
                    constAccessToken: args[constAccessToken],
                    constRefreshToken: args[constRefreshToken]
                ]);
                preferences.set(accounts, forKey: constAccountsPreference);
                result(true);
                return;
            }
        }
        result(false);
    }
    
    private func removeAccount(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: String] {
            let preferences = UserDefaults.standard;
            var accounts = preferences.array(forKey: constAccountsPreference) as? [[String: String?]] ?? [[String: String?]]();
            accounts = accounts.filter { $0[constAccountType] != args[constAccountType] || $0[constAccountName] != args[constAccountName] };
            preferences.set(accounts, forKey: constAccountsPreference);
            result(true);
        } else {
            result(false);
        }
    }
    
    private func getAccounts(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var data: [[String: String?]] = [];
        let preferences = UserDefaults.standard;
        let accounts = preferences.array(forKey: constAccountsPreference) as? [[String:String]] ?? [[String: String]]();
        for account in accounts {
            data.append([
                constAccountName: account[constAccountName],
                constAccountType: account[constAccountType],
                constAuthTokenType: account[constAuthTokenType],
                constAccessToken: account[constAccessToken],
                constRefreshToken: account[constRefreshToken]
            ])
        }
        result(accounts);
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print(call.method);
        switch (call.method) {
        case "addAccount":
            addAccount(call, result: result);
            break;
        case "removeAccount":
            removeAccount(call, result: result);
            break;
        case "getAccounts":
            getAccounts(call, result: result);
            break;
        default:
            result(false);
        }
    }
}
