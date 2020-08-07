import Flutter
import UIKit

public class SwiftAccountManagerPlugin: NSObject, FlutterPlugin {
    public let constAccountName = "account_name";
    public let constAccountType = "account_type";
    public let constPassword = "password";
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "accountManager", binaryMessenger: registrar.messenger())
        let instance = SwiftAccountManagerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func addAccount(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(true);
    }
    
    private func removeAccount(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(true);
    }
    
    private func getAccounts(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var accounts: [[String: Any]] = [];
        accounts.append([
            constAccountName: "contedevel2010@gmail.com",
            constAccountType: "com.contedevel.account"
        ]);
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
