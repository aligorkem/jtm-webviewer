#import "jtmwebviewer.h"

#import <cordova/cdvavailability.h>

@implementation jtmwebviewer

- (void)plugininitialize {

    nslog(@"cordova-plugin-jtm-webviewer: jtmwebviewer initialized");

    [[uidevice currentdevice] begingeneratingdeviceorientationnotifications];
    [[nsnotificationcenter defaultcenter]
     addobserver:self selector:@selector(orientationchanged:)
     name:uideviceorientationdidchangenotification
     object:[uidevice currentdevice]];
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
    nslog(@"cordova-plugin-jtm-webviewer: show called");

    if (!self.childview)
    {
        [self createviewwithoptions:command.arguments[0]];
    }

    self.childview.hidden = no;
    [self.commanddelegate sendpluginresult:[cdvpluginresult resultwithstatus:cdvcommandstatus_ok] callbackid:command.callbackid];
}


cdvinvokedurlcommand *actioncommand;

-(void)sendaction:(cdvinvokedurlcommand *)command
{
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
}


-(void)onactionreceived:(cdvinvokedurlcommand *)command
{
    nslog(@"cordova-plugin-jtm-webviewer: onactionreceived called");

    actioncommand = command;

    nsdictionary *returndictionary = @{ @"ping": @"true" };

    [self sendactionmessage: returndictionary];
}

- (void) sendactionmessage: ( nsdictionary *) dictionary {

    nserror *error;
    nsdata *jsondata = [nsjsonserialization datawithjsonobject: dictionary
                                                       options:nsjsonwritingprettyprinted
                                                         error:&error];
    nsstring *jsonstring = [[nsstring alloc] initwithdata:jsondata encoding:nsutf8stringencoding];

    cdvpluginresult* pluginresult = [cdvpluginresult resultwithstatus:cdvcommandstatus_ok messageasstring: jsonstring];
    [pluginresult setkeepcallbackasbool:yes];
    [self.commanddelegate sendpluginresult:pluginresult callbackid: actioncommand.callbackid];
}

- (void) orientationchanged:(nsnotification *)note
{
    nslog(@"cordova-plugin-jtm-webviewer: createviewwithoptions orientationchanged");

    if( self.childview != null ){
        self.childview.frame = cgrectmake(0 , 0, [uiscreen mainscreen].bounds.size.width, [uiscreen mainscreen].bounds.size.height - bottommargin);
    }

}

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
}




- (bool)webview:(uiwebview *)webview shouldstartloadwithrequest:(nsurlrequest *)request navigationtype:(uiwebviewnavigationtype)navigationtype
{
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
                                               @"jobid": jobid,
                                               @"apptid": apptid
                                               };

            [self sendactionmessage: returndictionary];
        }


    }

    return yes;
}


- (void)hide:(cdvinvokedurlcommand *)command
{
    nslog(@"cordova-plugin-jtm-webviewer: hide");

    if (self.childview.hidden==yes)
    {
        return;
    }

    self.childview.hidden = yes;
    [self.commanddelegate sendpluginresult:[cdvpluginresult resultwithstatus:cdvcommandstatus_ok] callbackid:command.callbackid];
}






- (void)nativetoweb_clearcache
{
    [webview stringbyevaluatingjavascriptfromstring:@"eagle.clearcache();"];
}

- (void)nativetoweb_onclicked_close_confirm
{
    [webview stringbyevaluatingjavascriptfromstring:@"nativetoweb_onclicked_close_confirm();"];
}

- (void)nativetoweb_onclicked_close_alert:(nsstring *)message
{
    nsstring *functionname = [nsstring stringwithformat:@"nativetoweb_onclicked_close_alert('%@')", message];
    nsstring *returnvalue = [webview stringbyevaluatingjavascriptfromstring:functionname];
}



- (void)webtonative_syncall
{
    //call syncuiwebview
    [syncwebview stringbyevaluatingjavascriptfromstring:@"sync();"];
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



