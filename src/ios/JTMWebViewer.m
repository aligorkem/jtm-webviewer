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


CDVInvokedUrlCommand *actionCommand;

-(void)sendAction:(CDVInvokedUrlCommand *)command
{
    NSLog(@"cordova-plugin-jtm-webviewer: sendAction called");
    
    if( command != NULL && command.arguments != NULL && command.arguments.count > 0 ){
        NSArray *arguments = command.arguments[0];
        
        if( arguments != NULL && arguments.count > 0 ){
            NSDictionary* options = [command.arguments objectAtIndex:0];
            
            NSLog(@"Options: %@", options);
            //NSNumber *action =  [NSNumber numberWithLong:];
            NSString *actionValue = [options objectForKey:@"action"];
            long action = [actionValue longLongValue];
            
            //CLEAR CACHE
            if( action == 1 )
            {
                [self nativeToWeb_ClearCache];
                
            }
            //CLOSE ALERT
            else if( action == 2 ){
                
                NSString *message = [options objectForKey:@"message"];
                [self nativeToWeb_OnClicked_Close_Alert: message];
            }
            //CLOSE CONFIRM
            else if( action == 3 ){
                
                [self nativeToWeb_OnClicked_Close_Confirm];
                
            }
            //CALL CUSTOM FUNCTION
            else if( action == 4 ){

                NSString *function = [options objectForKey:@"function"];
                NSString *message = [options objectForKey:@"message"];
                NSString *params = [options objectForKey:@"params"];


                [self nativeToWeb_OnClicked_Call_Function:function message:message params:params];

            }

        }

    }

    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}


- (void)nativeToWeb_OnClicked_Call_Function:(NSString *)function message: (NSString *)message params:(NSString *)params
{

    NSString *functionName = [NSString stringWithFormat:@"nativeToWeb_%@('%@', '%@')", function, message, params];
    NSString *returnvalue = [webview stringByEvaluatingJavaScriptFromString:functionName];
}


-(void)onActionReceived:(CDVInvokedUrlCommand *)command
{
    NSLog(@"cordova-plugin-jtm-webviewer: onActionReceived called");

    actionCommand = command;

    NSDictionary *returnDictionary = @{ @"ping": @"true" };

    [self sendActionMessage: returnDictionary];
}

- (void) sendActionMessage: ( NSDictionary *) dictionary {

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: jsonString];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId: actionCommand.callbackId];
}

- (void) orientationChanged:(NSNotification *)note
{
    NSLog(@"cordova-plugin-jtm-webviewer: createViewWithOptions orientationChanged");

    if( self.childView != NULL ){
        self.childView.frame = CGRectMake(0 , 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - bottomMargin);
    }

}

- (void)createViewWithOptions:(NSDictionary *)options {
    //todo: check mandatory params that

    NSLog(@"cordova-plugin-jtm-webviewer: createViewWithOptions called, this should be called only once");


    //This is the Designated Initializer
    NSString *urlTechPortal = [NSString stringWithFormat:@"%@", [options objectForKey:@"url"]];
    NSString *urlSync = [NSString stringWithFormat:@"%@", [options objectForKey:@"urlSync"]];
    bottomMargin = [[options objectForKey:@"bottomMarginIOS"] integerValue];
    topMargin = [[options objectForKey:@"topMargin"] integerValue];
    userId = [NSString stringWithFormat:@"%@", [options objectForKey:@"userId"]];
    password = [NSString stringWithFormat:@"%@", [options objectForKey:@"password"]];

    // urlTechPortal = @"http://jt.itglobal-systems.net/swan";
    // urlTechPortal = @"http://54.153.177.241/hawk";
    // urlTechPortal = @"http://jt.itglobal-systems.net/hawk";
    //urlTechPortal = @"http://54.153.177.241/hawk/index.php";
    //urlTechPortal = @"http://54.153.177.241/hawk/index.php";
    //urlTechPortal = [NSString stringWithFormat:@"%@/index.php", urlTechPortal];


    NSLog( @"cordova-plugin-jtm-webviewer TECH PORTAL: %@", urlTechPortal );
    NSLog( @"cordova-plugin-jtm-webviewer SYNC: %@", urlSync );

    // defaults
    float height = [UIScreen mainScreen].bounds.size.height - bottomMargin; //get screen height
    float width = [UIScreen mainScreen].bounds.size.width; //get screen width
    float x = 0;
    float y = topMargin; //this is header margin

    self.childView = [[UIView alloc] initWithFrame:CGRectMake(x,y,width,height)];
    [self.childView setBackgroundColor:[UIColor blueColor]];

    //initializse webview
    webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 424,468)];
    webview.delegate = self;

    webview.frame = CGRectMake(0, 0, self.childView.frame.size.width, self.childView.frame.size.height);
    webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // url = @"http://everytimezone.com/";


    //NSString *urlETP = [NSString stringWithFormat:@"%@/swan", self.manager.rootURL];

    NSURL *url = [NSURL URLWithString:urlTechPortal];
    NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval: 180.0];
    [webview loadRequest:request];



    //initialise syncWebview
    //syncWebview = [[UIWebView alloc]initWithFrame:CGRectMake(500, 0, 300, 200)];
    syncWebview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    [syncWebview loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:urlSync]]];

    [self.childView addSubview:webview];
    [self.childView addSubview:syncWebview];

    [ [ [ self viewController ] view ] addSubview:self.childView];

    [webview becomeFirstResponder];
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
        else if( [requestedFunction hasPrefix:@"ios:webToNative_TakePhoto"] )
        {

            NSDictionary *returnDictionary = @{
                                               @"ping": @"false",
                                               @"action": @"MultiPhoto"
                                               };

            [self sendActionMessage: returnDictionary];
        }else if( [requestedFunction hasPrefix:@"ios:webToNative_Action_TakePhoto"] )
        {
            NSDictionary *returnDictionary = @{
                                               @"ping": @"false",
                                               @"action": @"MultiPhoto",
                                               @"value1": @"0"
                                               };

            [self sendActionMessage: returnDictionary];
        }else if( [requestedFunction hasPrefix:@"ios:webToNative_Action_OpenDocument"] )
        {
            NSString *jobid = [requestedFunction stringByReplacingOccurrencesOfString:@"ios:webToNative_Action_OpenDocument_"
                                                                           withString:@""];

            NSDictionary *returnDictionary = @{
                                               @"ping": @"false",
                                               @"action": @"OpenDocument",
                                               @"jobid": jobid
                                               };

            [self sendActionMessage: returnDictionary];
        }
        else if( [requestedFunction hasPrefix:@"ios:webToNative_IsJobClosable"] )
        {
            NSArray *items = [requestedFunction componentsSeparatedByString:@"/"];
            NSString *jobid = [items objectAtIndex:1];
            NSString *apptid = [items objectAtIndex:2];

            NSDictionary *returnDictionary = @{
                                               @"ping": @"false",
                                               @"action": @"IsJobClosable",
                                               @"jobid": jobid,
                                               @"apptid": apptid
                                               };

            [self sendActionMessage: returnDictionary];
        }

        //Send All Other Actions if it starts with ios:webToNative_
        else if( [requestedFunction hasPrefix:@"ios:webToNative~"] )
        {
            NSArray *items = [requestedFunction componentsSeparatedByString:@"~"];
            NSString *actionName = [items objectAtIndex:1];
            NSString *actionValue = @"";

            if( items.count > 2 ){
                actionValue = [items objectAtIndex:2];
            }

            NSDictionary *returnDictionary = @{
                                               @"ping": @"false",
                                               @"action": actionName,
                                               @"value": actionValue
                                               };

            [self sendActionMessage: returnDictionary];
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






- (void)nativeToWeb_ClearCache
{
    [webview stringByEvaluatingJavaScriptFromString:@"eagle.ClearCache();"];
}

- (void)nativeToWeb_OnClicked_Close_Confirm
{
    [webview stringByEvaluatingJavaScriptFromString:@"nativeToWeb_OnClicked_Close_Confirm();"];
}

- (void)nativeToWeb_OnClicked_Close_Alert:(NSString *)message
{
    NSString *functionName = [NSString stringWithFormat:@"nativeToWeb_OnClicked_Close_Alert('%@')", message];
    NSString *returnvalue = [webview stringByEvaluatingJavaScriptFromString:functionName];
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
 aa
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
