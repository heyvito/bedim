//
//  NSScreen+BDUtilities.m
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "NSScreen+BDUtilities.h"

@implementation NSScreen (BDUtilities)

static NSString * const NSScreenNumberKey = @"NSScreenNumber";

- (CGRect)flipFrame:(NSRect)frame {
    NSScreen *primaryScreen = [NSScreen screens].firstObject;
    frame.origin.y = primaryScreen.frame.size.height - frame.size.height - frame.origin.y;
    return frame;
}

- (CGRect)flippedFrame {
    return [self flipFrame:self.frame];
}

- (NSString *) identifier {
    id uuid = CFBridgingRelease(CGDisplayCreateUUIDFromDisplayID([self.deviceDescription[NSScreenNumberKey] unsignedIntValue]));
    return CFBridgingRelease(CFUUIDCreateString(NULL, (__bridge CFUUIDRef) uuid));
}

+ (instancetype)screenWithID:(NSString *)id {
    for(NSScreen *screen in [self screens]) {
        if([screen.identifier isEqualToString:id]) {
            return screen;
        }
    }
    return nil;
}

@end
