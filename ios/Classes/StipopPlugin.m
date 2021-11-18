#import "StipopPlugin.h"
#if __has_include(<stipop_sdk/stipop_sdk-Swift.h>)
#import <stipop_sdk/stipop_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "stipop_sdk-Swift.h"
#endif

@implementation StipopPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftStipopPlugin registerWithRegistrar:registrar];
}
@end
