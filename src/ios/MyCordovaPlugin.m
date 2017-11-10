#import "MyCordovaPlugin.h"

#import <Cordova/CDVAvailability.h>

@implementation MyCordovaPlugin

@synthesize mapView;

- (void)pluginInitialize {
}

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

-(void)showMap:(CDVInvokedUrlCommand *)command
{
    if (!self.mapView)
	{
        [self createViewWithOptions:command.arguments[0]];
	}
	self.childView.hidden = NO;

    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)createViewWithOptions:(NSDictionary *)options {

    //This is the Designated Initializer

    // defaults
      float height = 660;
      float width = 500;
      float x = 0;
      float y = 60;//self.webView.bounds.origin.y;
      //BOOL atBottom = true;

    //if(atBottom) {
    //    y += self.webView.bounds.size.height - height;
    //}

      //self.mapView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 220, 430)];
      //[self.mapView setBackgroundColor:[UIColor yellowColor]];

      self.childView = [[UIView alloc] initWithFrame:CGRectMake(x,y,width,height)];
      [self.childView setBackgroundColor:[UIColor blueColor]];

	//[self.childView addSubview:self.mapView];


      //UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 424,468)];
      UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, width,height)];
      NSString *url=@"http://54.153.177.241/swan";
      NSURL *nsurl=[NSURL URLWithString:url];
      NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
      [webview loadRequest:nsrequest];
      [self.childView addSubview:webview];


	[ [ [ self viewController ] view ] addSubview:self.childView];
}



@end
