#import "JTMWebViewer.h"

#import <Cordova/CDVAvailability.h>

@implementation JTMWebViewer

- (void)pluginInitialize {

      NSLog(@"cordova-plugin-jtm-webviewer: JTMWebViewer Initialized");

      [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
      [[NSNotificationCenter defaultCenter]
       addObserver:self selector:@selector(orientationChanged:)
       name:UIDeviceOrientationDidChangeNotification
       object:[UIDevice currentDevice]];
}

//bottom margin for webview, need to display ionic-tab
NSInteger bottomMargin = 120;

//top margin for webview, need to display header
NSInteger topMargin = 60;

//main web view
UIWebView *webview = nil;

//sync view for backgorund syncing
UIWebView *syncWebview = nil;

NSString *userId;
NSString *password;

-(void)show:(CDVInvokedUrlCommand *)command
{
      NSLog(@"cordova-plugin-jtm-webviewer: show called");

      if (!self.childView)
      {
            [self createViewWithOptions:command.arguments[0]];
      }

      self.childView.hidden = NO;
      [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void) orientationChanged:(NSNotification *)note
{
      NSLog(@"cordova-plugin-jtm-webviewer: createViewWithOptions orientationChanged");

      self.childView.frame = CGRectMake(0 , 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - bottomMargin);
}

- (void)createViewWithOptions:(NSDictionary *)options {
      //todo: check mandatory params that

      NSLog(@"cordova-plugin-jtm-webviewer: createViewWithOptions called, this should be called only once");


      //This is the Designated Initializer
      NSString *url = [NSString stringWithFormat:@"%@", [options objectForKey:@"url"]];
      NSString *urlSync = [NSString stringWithFormat:@"%@", [options objectForKey:@"urlSync"]];
      bottomMargin = [[options objectForKey:@"bottomMarginIOS"] integerValue];
      topMargin = [[options objectForKey:@"topMargin"] integerValue];
      userId = [NSString stringWithFormat:@"%@", [options objectForKey:@"userId"]];
      password = [NSString stringWithFormat:@"%@", [options objectForKey:@"password"]];


      // defaults
      float height = [UIScreen mainScreen].bounds.size.height - bottomMargin; //get screen height
      float width = [UIScreen mainScreen].bounds.size.width; //get screen width
      float x = 0;
      float y = topMargin; //this is header margin

      self.childView = [[UIView alloc] initWithFrame:CGRectMake(x,y,width,height)];
      [self.childView setBackgroundColor:[UIColor blueColor]];

      //initializse webview
      webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 424,468)];
      webview.frame = CGRectMake(0, 0, self.childView.frame.size.width, self.childView.frame.size.height);
      webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      [webview loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:url]]];


      //initialise syncWebview
      //syncWebview = [[UIWebView alloc]initWithFrame:CGRectMake(500, 0, 300, 200)];
      syncWebview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
      [syncWebview loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:urlSync]]];

      webview.delegate = self;
      //self.syncWebView.delegate = self;


      [self.childView addSubview:webview];
      [self.childView addSubview:syncWebview];

      [ [ [ self viewController ] view ] addSubview:self.childView];
}




- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
      NSLog(@"cordova-plugin-jtm-webviewer: webView.shouldStartLoadWithRequest");

      NSString *absoluteString = [[request URL] absoluteString];
      if ([absoluteString hasPrefix:@"ios:"]) {
            NSLog( @"%@", [NSString stringWithFormat:@"URL: %@'", absoluteString] );

            NSString *requestedFunction = [[request URL] absoluteString];
            if( [requestedFunction hasPrefix:@"ios:webToNative_AutoLogin"] )
            {
                  [self performSelector:@selector(webToNative_AutoLogin)];
            }
            else if( [requestedFunction hasPrefix:@"ios:webToNative_SyncAll"] )
            {
                  //Call Sync UIWebview
                  [self performSelector:@selector(webToNative_SyncAll)];
            }
            else if( [requestedFunction hasPrefix:@"ios:webToNative_SyncSuccessful"] )
            {
                  //Call Sync UIWebview
                  [self performSelector:@selector(webToNative_SyncSuccessful)];
            }



      }

      return YES;
}


- (void)hide:(CDVInvokedUrlCommand *)command
{
      NSLog(@"cordova-plugin-jtm-webviewer: hide");

      if (self.childView.hidden==YES)
      {
            return;
      }

      self.childView.hidden = YES;
      [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}








- (void)webToNative_SyncAll
{
      //Call SyncUIWebView
      [syncWebview stringByEvaluatingJavaScriptFromString:@"SYNC();"];
}

- (void)webToNative_SyncSuccessful
{
      //Call SyncUIWebView
      [webview stringByEvaluatingJavaScriptFromString:@"SyncSuccessful();"];
}


- (void)webToNative_AutoLogin
{

            NSString *version = @"0";

            NSString *autoLoginCallBack = [NSString stringWithFormat:@"autoLogin('%@','%@','%@')", userId, password, version];
            NSString *returnvalue = [webview stringByEvaluatingJavaScriptFromString:autoLoginCallBack];
}


@end



/*
 //NSString *url=@"http://54.153.177.241/swan";

 //- (void)echo:(CDVInvokedUrlCommand *)command;
 //- (void)getDate:(CDVInvokedUrlCommand *)command;

 //@property (nonatomic, retain) UIView* mapView;

 //@property (nonatomic, retain) UIWebView* webView;


 - (void)echo:(CDVInvokedUrlCommand *)command {
 NSString* phrase = [command.arguments objectAtIndex:0];
 NSLog(@"%@", phrase);
 }

 - (void)getDate:(CDVInvokedUrlCommand *)command {
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
 [dateFormatter setLocale:enUSPOSIXLocale];
 [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];

 NSDate *now = [NSDate date];
 NSString *iso8601String = [dateFormatter stringFromDate:now];

 CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:iso8601String];
 [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
 }
 */
