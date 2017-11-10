#import <Cordova/CDVPlugin.h>

@interface MyCordovaPlugin : CDVPlugin {
}

// The hooks for our plugin commands
- (void)echo:(CDVInvokedUrlCommand *)command;
- (void)getDate:(CDVInvokedUrlCommand *)command;
- (void)showMap:(CDVInvokedUrlCommand *)command;


@property (nonatomic, retain) UIView* mapView;

@property (nonatomic, retain) UIView* childView;

- (void)createViewWithOptions:(NSDictionary *)options; //Designated Initializer


@end


