

#import "MintLogger.h"


#import <SplunkMint/SplunkMint.h>


@implementation MintLogger


-(void) logMessage:(DDLogMessage *)logMessage
{
    NSString *sendText = logMessage.message;
    
    if ( _logFormatter )
    {
        sendText = [_logFormatter formatLogMessage:logMessage];
    }
    
    if ( sendText.length > 0 )
    {
        DDLogLevel logLevel = logMessage.level;
        MintLogLevel sendLevel = EmergencyLogLevel;
        
        if ( logLevel & DDLogLevelError )
        {
            sendLevel = ErrorLogLevel;
        }
        else if ( logLevel & DDLogLevelWarning )
        {
            sendLevel = WarningLogLevel;
        }
        else if ( logLevel & DDLogLevelInfo )
        {
            sendLevel = InfoLogLevel;
        }
        else if ( logLevel & DDLogLevelDebug )
        {
            sendLevel = InfoLogLevel;
        }
        else if ( logLevel & DDLogLevelVerbose )
        {
            sendLevel = DebugLogLevel;
        }
        
        [[Mint sharedInstance] logEventWithName:sendText logLevel:sendLevel];
    }
}

-(id) init
{
    if (( self = [super init] ))
    {
        [[Mint sharedInstance] enableLogging:YES];
    }
    
    return self;
}

+(MintLogger*) sharedInstance
{
    static dispatch_once_t once = 0;
    static MintLogger *_sharedInstance = nil;
    
    dispatch_once(&once, ^
    {
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

@end
