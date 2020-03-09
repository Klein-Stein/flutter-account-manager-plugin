#import "AccountManagerPlugin.h"
#if __has_include(<accountmanager/accountmanager-Swift.h>)
#import <accountmanager/accountmanager-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "accountmanager-Swift.h"
#endif

@implementation AccountManagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAccountManagerPlugin registerWithRegistrar:registrar];
}
@end
