//
//  BDWindow.m
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "BDWindow.h"
#import <Cocoa/Cocoa.h>
#import "NSScreen+BDUtilities.h"

@implementation BDWindow

AXError _AXUIElementGetWindow(AXUIElementRef element, CGWindowID *identifier);
static NSString * const NSAccessibilityFullScreenAttribute = @"AXFullScreen";

- (CGWindowID)windowID {
    CGWindowID identifier;
    _AXUIElementGetWindow((__bridge AXUIElementRef)self.element, &identifier);
    return identifier;
}

- (CGPoint)topLeft {
    CGPoint topLeft;
    CFTypeRef positionWrapper = (__bridge CFTypeRef)[self valueForAttribute:NSAccessibilityPositionAttribute];
    AXValueGetValue(positionWrapper, kAXValueCGPointType, (void *)&topLeft);
    return topLeft;
}

- (CGSize) size {
    CGSize size;
    CFTypeRef sizeWrapper = (__bridge CFTypeRef)[self valueForAttribute:NSAccessibilitySizeAttribute];
    AXValueGetValue(sizeWrapper, kAXValueCGSizeType, (void *)&size);
    return size;
}

- (CGRect)frame {
    CGRect frame;
    frame.origin = [self topLeft];
    frame.size = [self size];
    return frame;
}


- (NSScreen *)screen {
    CGRect windowFrame = [self frame];
    CGFloat volume = 0;
    NSScreen *appScreen;
    
    for (NSScreen *screen in [NSScreen screens]) {
        CGRect screenFrame = [screen flippedFrame];
        CGRect intersection = CGRectIntersection(windowFrame, screenFrame);
        CGFloat intersectionVolume = intersection.size.width * intersection.size.height;
        if (intersectionVolume > volume) {
            volume = intersectionVolume;
            appScreen = screen;
        }
    }
    return appScreen;
}

- (NSString *)subrole {
    
    return [self valueForAttribute:NSAccessibilitySubroleAttribute withDefaultValue:@""];
}

- (BOOL)isNormal {
    
    return [[self subrole] isEqualToString:NSAccessibilityStandardWindowSubrole];
}

- (BOOL)isMinimized {
    
    return [[self valueForAttribute:NSAccessibilityMinimizedAttribute withDefaultValue:@NO] boolValue];
}

- (BOOL)isVisible {
    
    return [self isNormal] && ![self isMinimized];
}

@end
