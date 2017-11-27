#import <Cordova/CDVPlugin.h>

@interface JTMWebViewer : CDVPlugin  <UIWebViewDelegate>{
}


- (void)show:(CDVInvokedUrlCommand *)command;
- (void)hide:(CDVInvokedUrlCommand *)command;
- (void)onActionReceived:(CDVInvokedUrlCommand *)command;


@property (nonatomic, retain) UIView* childView;
//@property (strong, nonatomic) IBOutlet UIWebView *webView;
//@property (strong, nonatomic) IBOutlet UIWebView *syncWebView;

- (void)createViewWithOptions:(NSDictionary *)options; //Designated Initializer




@end


