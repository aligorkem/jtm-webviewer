#import "jtmwebviewer.h"

#import <cordova/cdvavailability.h>

@implementation jtmwebviewer

- (void)plugininitialize {

<<<<<<< HEAD
    NSLog(@"cordova-plugin-jtm-webviewer: JTMWebViewer Initialized");

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
=======
    nslog(@"cordova-plugin-jtm-webviewer: jtmwebviewer initialized");

    [[uidevice currentdevice] begingeneratingdeviceorientationnotifications];
    [[nsnotificationcenter defaultcenter]
     addobserver:self selector:@selector(orientationchanged:)
     name:uideviceorientationdidchangenotification
     object:[uidevice currentdevice]];
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
}

//bottom margin for webview, need to display ionic-tab
nsinteger bottommargin = 120;

//top margin for webview, need to display header
nsinteger topmargin = 60;

//main web view
uiwebview *webview = nil;

//sync view for backgorund syncing
uiwebview *syncwebview = nil;

nsstring *userid;
nsstring *password;

-(void)show:(cdvinvokedurlcommand *)command
{
<<<<<<< HEAD
    NSLog(@"cordova-plugin-jtm-webviewer: show called");

    if (!self.childView)
    {
        [self createViewWithOptions:command.arguments[0]];
    }

    self.childView.hidden = NO;
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
=======
    nslog(@"cordova-plugin-jtm-webviewer: show called");

    if (!self.childview)
    {
        [self createviewwithoptions:command.arguments[0]];
    }

    self.childview.hidden = no;
    [self.commanddelegate sendpluginresult:[cdvpluginresult resultwithstatus:cdvcommandstatus_ok] callbackid:command.callbackid];
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
}


cdvinvokedurlcommand *actioncommand;

-(void)sendaction:(cdvinvokedurlcommand *)command
{
<<<<<<< HEAD
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

        }

    }

    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
=======
    nslog(@"cordova-plugin-jtm-webviewer: sendaction called");

    if( command != null && command.arguments != null && command.arguments.count > 0 ){
        nsarray *arguments = command.arguments[0];

        if( arguments != null && arguments.count > 0 ){
            nsdictionary* options = [command.arguments objectatindex:0];

            nslog(@"options: %@", options);
            //nsnumber *action =  [nsnumber numberwithlong:];
            nsstring *actionvalue = [options objectforkey:@"action"];
            long action = [actionvalue longlongvalue];

            //clear cache
            if( action == 1 )
            {
                [self nativetoweb_clearcache];

            }
            //close alert
            else if( action == 2 ){

                nsstring *message = [options objectforkey:@"message"];
                [self nativetoweb_onclicked_close_alert: message];
            }
            //close confirm
            else if( action == 3 ){

                [self nativetoweb_onclicked_close_confirm];
            }
        }

    }

    [self.commanddelegate sendpluginresult:[cdvpluginresult resultwithstatus:cdvcommandstatus_ok] callbackid:command.callbackid];
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
}


-(void)onactionreceived:(cdvinvokedurlcommand *)command
{
<<<<<<< HEAD
    NSLog(@"cordova-plugin-jtm-webviewer: onActionReceived called");

    actionCommand = command;

    NSDictionary *returnDictionary = @{ @"ping": @"true" };

    [self sendActionMessage: returnDictionary];
=======
    nslog(@"cordova-plugin-jtm-webviewer: onactionreceived called");

    actioncommand = command;

    nsdictionary *returndictionary = @{ @"ping": @"true" };

    [self sendactionmessage: returndictionary];
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
}

- (void) sendactionmessage: ( nsdictionary *) dictionary {

<<<<<<< HEAD
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: jsonString];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId: actionCommand.callbackId];
=======
    nserror *error;
    nsdata *jsondata = [nsjsonserialization datawithjsonobject: dictionary
                                                       options:nsjsonwritingprettyprinted
                                                         error:&error];
    nsstring *jsonstring = [[nsstring alloc] initwithdata:jsondata encoding:nsutf8stringencoding];

    cdvpluginresult* pluginresult = [cdvpluginresult resultwithstatus:cdvcommandstatus_ok messageasstring: jsonstring];
    [pluginresult setkeepcallbackasbool:yes];
    [self.commanddelegate sendpluginresult:pluginresult callbackid: actioncommand.callbackid];
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
}

- (void) orientationchanged:(nsnotification *)note
{
<<<<<<< HEAD
    NSLog(@"cordova-plugin-jtm-webviewer: createViewWithOptions orientationChanged");

    if( self.childView != NULL ){
        self.childView.frame = CGRectMake(0 , 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - bottomMargin);
=======
    nslog(@"cordova-plugin-jtm-webviewer: createviewwithoptions orientationchanged");

    if( self.childview != null ){
        self.childview.frame = cgrectmake(0 , 0, [uiscreen mainscreen].bounds.size.width, [uiscreen mainscreen].bounds.size.height - bottommargin);
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
    }

}

<<<<<<< HEAD
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


    NSLog( @"cordova-plugin-jtm-webviewer TECH PORTAL: %@", url );
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
=======
- (void)createviewwithoptions:(nsdictionary *)options {
    //todo: check mandatory params that

    nslog(@"cordova-plugin-jtm-webviewer: createviewwithoptions called, this should be called only once");


    //this is the designated initializer
    nsstring *url = [nsstring stringwithformat:@"%@", [options objectforkey:@"url"]];
    nsstring *urlsync = [nsstring stringwithformat:@"%@", [options objectforkey:@"urlsync"]];
    bottommargin = [[options objectforkey:@"bottommarginios"] integervalue];
    topmargin = [[options objectforkey:@"topmargin"] integervalue];
    userid = [nsstring stringwithformat:@"%@", [options objectforkey:@"userid"]];
    password = [nsstring stringwithformat:@"%@", [options objectforkey:@"password"]];


    nslog( @"cordova-plugin-jtm-webviewer tech portal: %@", url );
    nslog( @"cordova-plugin-jtm-webviewer sync: %@", urlsync );

    // defaults
    float height = [uiscreen mainscreen].bounds.size.height - bottommargin; //get screen height
    float width = [uiscreen mainscreen].bounds.size.width; //get screen width
    float x = 0;
    float y = topmargin; //this is header margin

    self.childview = [[uiview alloc] initwithframe:cgrectmake(x,y,width,height)];
    [self.childview setbackgroundcolor:[uicolor bluecolor]];

    //initializse webview
    webview = [[uiwebview alloc]initwithframe:cgrectmake(0, 0, 424,468)];
    webview.frame = cgrectmake(0, 0, self.childview.frame.size.width, self.childview.frame.size.height);
    webview.autoresizingmask = uiviewautoresizingflexiblewidth | uiviewautoresizingflexibleheight;
    [webview loadrequest: [nsurlrequest requestwithurl: [nsurl urlwithstring:url]]];


    //initialise syncwebview
    //syncwebview = [[uiwebview alloc]initwithframe:cgrectmake(500, 0, 300, 200)];
    syncwebview = [[uiwebview alloc]initwithframe:cgrectmake(0, 0, 1, 1)];
    [syncwebview loadrequest: [nsurlrequest requestwithurl: [nsurl urlwithstring:urlsync]]];

    webview.delegate = self;
    //self.syncwebview.delegate = self;


    [self.childview addsubview:webview];
    [self.childview addsubview:syncwebview];

    [ [ [ self viewcontroller ] view ] addsubview:self.childview];
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
}




- (bool)webview:(uiwebview *)webview shouldstartloadwithrequest:(nsurlrequest *)request navigationtype:(uiwebviewnavigationtype)navigationtype
{
<<<<<<< HEAD
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
=======
    nslog(@"cordova-plugin-jtm-webviewer: webview.shouldstartloadwithrequest");

    nsstring *absolutestring = [[request url] absolutestring];
    if ([absolutestring hasprefix:@"ios:"]) {
        nslog( @"%@", [nsstring stringwithformat:@"url: %@'", absolutestring] );

        nsstring *requestedfunction = [[request url] absolutestring];
        if( [requestedfunction hasprefix:@"ios:webtonative_autologin"] )
        {
            [self performselector:@selector(webtonative_autologin)];
        }
        else if( [requestedfunction hasprefix:@"ios:webtonative_syncall"] )
        {
            //call sync uiwebview
            [self performselector:@selector(webtonative_syncall)];
        }
        else if( [requestedfunction hasprefix:@"ios:webtonative_syncsuccessful"] )
        {
            //call sync uiwebview
            [self performselector:@selector(webtonative_syncsuccessful)];
        }
        else if( [requestedfunction hasprefix:@"ios:webtonative_takephoto"] )
        {

            nsdictionary *returndictionary = @{
                                               @"ping": @"false",
                                               @"action": @"multiphoto"
                                               };

            [self sendactionmessage: returndictionary];
        }else if( [requestedfunction hasprefix:@"ios:webtonative_action_takephoto"] )
        {
            nsdictionary *returndictionary = @{
                                               @"ping": @"false",
                                               @"action": @"multiphoto",
                                               @"value1": @"0"
                                               };

            [self sendactionmessage: returndictionary];
        }else if( [requestedfunction hasprefix:@"ios:webtonative_action_opendocument"] )
        {
            nsstring *jobid = [requestedfunction stringbyreplacingoccurrencesofstring:@"ios:webtonative_action_opendocument_"
                                                                           withstring:@""];

            nsdictionary *returndictionary = @{
                                               @"ping": @"false",
                                               @"action": @"opendocument",
                                               @"jobid": jobid
                                               };

            [self sendactionmessage: returndictionary];
        }
        else if( [requestedfunction hasprefix:@"ios:webtonative_isjobclosable"] )
        {
            nsarray *items = [requestedfunction componentsseparatedbystring:@"/"];
            nsstring *jobid = [items objectatindex:1];
            nsstring *apptid = [items objectatindex:2];

            nsdictionary *returndictionary = @{
                                               @"ping": @"false",
                                               @"action": @"isjobclosable",
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
                                               @"jobid": jobid,
                                               @"apptid": apptid
                                               };

<<<<<<< HEAD
            [self sendActionMessage: returnDictionary];
=======
            [self sendactionmessage: returndictionary];
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
        }


    }

<<<<<<< HEAD
    return YES;
=======
    return yes;
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
}


- (void)hide:(cdvinvokedurlcommand *)command
{
<<<<<<< HEAD
    NSLog(@"cordova-plugin-jtm-webviewer: hide");

    if (self.childView.hidden==YES)
=======
    nslog(@"cordova-plugin-jtm-webviewer: hide");

    if (self.childview.hidden==yes)
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
    {
        return;
    }

<<<<<<< HEAD
    self.childView.hidden = YES;
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
=======
    self.childview.hidden = yes;
    [self.commanddelegate sendpluginresult:[cdvpluginresult resultwithstatus:cdvcommandstatus_ok] callbackid:command.callbackid];
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
}






- (void)nativetoweb_clearcache
{
<<<<<<< HEAD
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
=======
    [webview stringbyevaluatingjavascriptfromstring:@"eagle.clearcache();"];
}

- (void)nativetoweb_onclicked_close_confirm
{
    [webview stringbyevaluatingjavascriptfromstring:@"nativetoweb_onclicked_close_confirm();"];
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
}

- (void)nativetoweb_onclicked_close_alert:(nsstring *)message
{
<<<<<<< HEAD
    //Call SyncUIWebView
    [webview stringByEvaluatingJavaScriptFromString:@"SyncSuccessful();"];
}


- (void)webToNative_AutoLogin
{

    NSString *version = @"0";

    NSString *autoLoginCallBack = [NSString stringWithFormat:@"autoLogin('%@','%@','%@')", userId, password, version];
    NSString *returnvalue = [webview stringByEvaluatingJavaScriptFromString:autoLoginCallBack];
=======
    nsstring *functionname = [nsstring stringwithformat:@"nativetoweb_onclicked_close_alert('%@')", message];
    nsstring *returnvalue = [webview stringbyevaluatingjavascriptfromstring:functionname];
}



- (void)webtonative_syncall
{
    //call syncuiwebview
    [syncwebview stringbyevaluatingjavascriptfromstring:@"sync();"];
>>>>>>> ae58f929ca74874abe1d2ba9b6e7e7ecc0a48e4a
}

- (void)webtonative_syncsuccessful
{
    //call syncuiwebview
    [webview stringbyevaluatingjavascriptfromstring:@"syncsuccessful();"];
}


- (void)webtonative_autologin
{

    nsstring *version = @"0";

    nsstring *autologincallback = [nsstring stringwithformat:@"autologin('%@','%@','%@')", userid, password, version];
    nsstring *returnvalue = [webview stringbyevaluatingjavascriptfromstring:autologincallback];
}
//

@end



