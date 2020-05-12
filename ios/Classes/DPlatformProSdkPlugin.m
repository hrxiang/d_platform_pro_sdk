#import "DPlatformProSdkPlugin.h"
#import <d_platform_pro_sdk/d_platform_pro_sdk-Swift.h>

@implementation DPlatformProSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDPlatformProSdkPlugin registerWithRegistrar:registrar];
}
@end
