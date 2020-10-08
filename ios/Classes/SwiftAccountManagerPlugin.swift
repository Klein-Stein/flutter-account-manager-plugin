import Flutter
import UIKit

public class SwiftAccountManagerPlugin: NSObject, FlutterPlugin {
    public let constAccountsPreference = "com.contedevel.account_manager.accounts";
    public let constAccountName = "account_name";
    public let constAccountType = "account_type";
    public let constAuthTokenType = "auth_token_type";
    public let constAccessToken = "access_token";
    public let constTokens = "tokens";
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "accountManager", binaryMessenger: registrar.messenger())
        let instance = SwiftAccountManagerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func addAccount(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: String] {
            let preferences = UserDefaults.standard;
            var accounts = preferences.array(forKey: constAccountsPreference) as? [[String: Any]] ?? [[String: Any]]();
            if !accounts.contains(where: { $0[constAccountType] as? String == args[constAccountType] &&
                                    $0[constAccountName] as? String == args[constAccountName] }) {
                accounts.append([
                    constAccountName: args[constAccountName] as Any,
                    constAccountType: args[constAccountType] as Any,
                    constTokens: [:]
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
        let accounts = preferences.array(forKey: constAccountsPreference) as? [[String: Any]] ?? [[String: Any]]();
        for account in accounts {
            data.append([
                constAccountName: account[constAccountName] as? String,
                constAccountType: account[constAccountType] as? String
            ])
        }
        result(data);
    }
    
    private func getAccessToken(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var data: [String: String]? = nil;
        if let args = call.arguments as? [String: String?] {
            let preferences = UserDefaults.standard;
            let accounts = preferences.array(forKey: constAccountsPreference) as? [[String: Any]] ?? [[String: Any]]();
            let account = accounts.filter { $0[constAccountType] as? String == args[constAccountType] || $0[constAccountName] as? String == args[constAccountName] }.first;
            if account != nil {
                let tokens = account![constTokens] as! [String: String];
                let accessToken = tokens[args[constAuthTokenType]!!];
                if accessToken != nil {
                    data = [
                        constAuthTokenType: args[constAuthTokenType]!!,
                        constAccessToken: accessToken!
                    ];
                }
            }
        }
        result(data);
    }

    private func removeAccount(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: String] {
            let preferences = UserDefaults.standard;
            var accounts = preferences.array(forKey: constAccountsPreference) as? [[String: Any]] ?? [[String: Any]]();
            accounts = accounts.filter { $0[constAccountType] as? String != args[constAccountType] || $0[constAccountName] as? String != args[constAccountName] };
            preferences.set(accounts, forKey: constAccountsPreference);
            result(true);
        } else {
            result(false);
        }
    }
    
    private func setAccessToken(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: String?] {
            let preferences = UserDefaults.standard;
            var accounts = preferences.array(forKey: constAccountsPreference) as? [[String: Any]] ?? [[String: Any]]();
            var account = accounts.filter { $0[constAccountType] as? String == args[constAccountType] || $0[constAccountName] as? String == args[constAccountName] }.first;
            if account != nil {
                var tokens = account![constTokens] as! [String: String]
                if args[constAccessToken] == nil {
                    if tokens.index(forKey: args[constAuthTokenType]!!) != nil {
                        tokens.removeValue(forKey: args[constAuthTokenType]!!);
                    }
                } else {
                    tokens[args[constAuthTokenType]!!] = args[constAccessToken]!!
                }
                accounts = accounts.filter { $0[constAccountType] as? String != args[constAccountType] || $0[constAccountName] as? String != args[constAccountName] };
                account![constTokens] = tokens;
                accounts.append(account!);
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
