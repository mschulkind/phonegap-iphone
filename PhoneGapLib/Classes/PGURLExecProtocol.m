#import "PGURLExecProtocol.h"
#import "JSON.h"
#import "InvokedUrlCommand.h"
#import "PhoneGapDelegate.h"

@implementation PGURLExecProtocol

+ (void) registerPGURLExecProtocol {
    static BOOL registered = NO;
    if (!registered) {
        [NSURLProtocol registerClass:[PGURLExecProtocol class]];
        registered = YES;
    }
}

+ (BOOL) canInitWithRequest:(NSURLRequest *)theRequest
{
    NSURL* theURL = [theRequest URL];
    NSString* theScheme = [theURL scheme];

    if (![theScheme isEqual:@"urlexec"]) {
        return NO;
    }

    //NSLog(@"urlexec: %@", [theURL absoluteString]);
    //NSLog(@"urlbody: %@", [theRequest HTTPBody]);
    //NSLog(@"urlbodystream: %@", [theRequest HTTPBodyStream]);
    //NSLog(@"method: %@", [theRequest HTTPMethod]);
    //NSLog(@"request: %@", theRequest);

    SBJsonParser* jsonParser = [[[SBJsonParser alloc] init] autorelease];
    NSString* encodedJSON = [theRequest HTTPMethod];
    NSString* json = 
        [encodedJSON 
            stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* command = [jsonParser objectWithString:json];
    [(PhoneGapDelegate*)[[UIApplication sharedApplication] delegate]
        execute:[InvokedUrlCommand commandFromObject:command]];
    NSLog(@"%@", command);

    return YES;
}

+ (NSURLRequest*) canonicalRequestForRequest:(NSURLRequest*)theRequest 
{
    return theRequest;
}

- (void) startLoading
{
}

- (void) stopLoading
{
}

@end
