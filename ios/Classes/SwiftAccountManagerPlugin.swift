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
                    constAccountType: args[constAccountType]
                ]);
                preferences.set(accounts, forKey: constAccountsPreference);
                result(true);
                return;
            }
        }
        result(false);
    }
    
    private func getAccounts(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var data: [[String: String?]] = [];
        let preferences = UserDefaults.standard;
        let accounts = preferences.array(forKey: constAccountsPreference) as? [[String:String]] ?? [[String: String]]();
        for account in accounts {
            data.append([
                constAccountName: account[constAccountName],
                constAccountType: account[constAccountType]
            ])
        }
        result(data);
    }
    
    private func getAccessToken(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var data: [String: String?]? = nil;
        let preferences = UserDefaults.standard;
        let accounts = preferences.array(forKey: constAccountsPreference) as? [[String:String]] ?? [[String: String]]();
        for account in accounts {
            if account[constAccessToken] != nil {
                data = [
                    constAuthTokenType: account[constAuthTokenType],
                    constAccessToken: account[constAccessToken]
                ]
            }
        }
        result(data);
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
    
    private func setAccessToken(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: String] {
            let preferences = UserDefaults.standard;
            let accounts = preferences.array(forKey: constAccountsPreference) as? [[String: String?]] ?? [[String: String?]]();
            var account = accounts.filter { $0[constAccountType] == args[constAccountType] || $0[constAccountName] == args[constAccountName] }.first;
            if account != nil {
                if args[constAuthTokenType] != nil {
                    account![constAuthTokenType] = args[constAuthTokenType]
                } else if account![constAuthTokenType] != nil {
                    account?.removeValue(forKey: constAuthTokenType)
                }
                if args[constAccessToken] != nil {
                    account![constAccessToken] = args[constAccessToken]
                } else if account![constAccessToken] != nil {
                    account?.removeValue(forKey: constAccessToken)
                }
                preferences.set(accounts, forKey: constAccountsPreference);
                result(true);
            }
        }
        result(false);
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "addAccount":
            addAccount(call, result: result);
            break;
        case "getAccounts":
            getAccounts(call, result: result);
            break;
        case "getAccessToken":
            getAccessToken(call, result: result);
        case "removeAccount":
            removeAccount(call, result: result);
            break;
        case "setAccessToken":
            setAccessToken(call, result: result);
        default:
            result(false);
        }
    }
}
