

#import "User.h"

@implementation User

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)isChinese:(NSString *)string {
    for(int i=0; i< [string length];i++){
        int a = [string characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

@end
