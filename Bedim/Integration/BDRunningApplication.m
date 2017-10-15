//
//  BDRunningApplication.m
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "BDRunningApplication.h"
#import <Cocoa/Cocoa.h>
#import "BDWindow.h"

@implementation BDRunningApplication {
    NSRunningApplication *app;
}

+ (NSArray<BDRunningApplication *> *)all {
    NSMutableArray<BDRunningApplication *> *apps = [NSMutableArray array];
    
    for (NSRunningApplication *runningApp in [NSWorkspace sharedWorkspace].runningApplications) {
        [apps addObject:[[self alloc] initWithApp:runningApp]];
    }
    
    return apps;
}

- (instancetype)initWithApp:(NSRunningApplication *)app {
    if (self = [super initWithElement:CFBridgingRelease(AXUIElementCreateApplication(app.processIdentifier))]) {
        self->app = app;
    }
    return self;
}

- (NSArray<BDWindow *> *)windows {
    NSArray *windowUIElements = [self valuesForAttribute:NSAccessibilityWindowsAttribute fromIndex:0 count:100];
    NSMutableArray<BDWindow *> *result = [[NSMutableArray alloc] init];
    
    for (id windowUIElement in windowUIElements) {
        [result addObject:[[BDWindow alloc] initWithElement:windowUIElement]];
    }
    
    return result;
}

@end
