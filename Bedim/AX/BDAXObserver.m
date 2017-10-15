//
//  BDAXObserver.m
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "BDAXObserver.h"
#import "BDWindow.h"
#import <Cocoa/Cocoa.h>

static NSString * const BDAXObserverWindowKey = @"PHAXObserverWindow";

@interface BDAXObserver ()

@property id observer;

@end

@implementation BDAXObserver

#pragma mark - AXObserverCallback

static void BDAXObserverCallback(__unused AXObserverRef observer, __unused AXUIElementRef element, __unused CFStringRef notification, __unused void *data) {
    @autoreleasepool {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BDAX_NOTIFICATION"
                                                            object:nil
                                                          userInfo:nil];
    }
}

#pragma mark - Initialising

- (instancetype)initWithApp:(NSRunningApplication *)app {
    if (self = [super initWithElement:CFBridgingRelease(AXUIElementCreateApplication(app.processIdentifier))]) {
        AXObserverRef observer = NULL;
        AXError error = AXObserverCreate(app.processIdentifier, BDAXObserverCallback, &observer);
        if (error != kAXErrorSuccess) {
            NSLog(@"Error: Could not create accessibility observer for app %@. (%d)", app, error);
            return nil;
        }
        self.observer = CFBridgingRelease(observer);
        [self setup];
    }
    return self;
}

#pragma mark - Deallocing

- (void)dealloc {
    for (NSString *notification in [BDAXObserver notifications]) {
        [self removeNotification:notification];
    }
}

#pragma mark - Notifications

+ (NSArray<NSString *> *)notifications {
    static NSArray<NSString *> *notifications;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notifications = @[ NSAccessibilityWindowCreatedNotification,
                           NSAccessibilityUIElementDestroyedNotification,
                           NSAccessibilityFocusedWindowChangedNotification,
                           NSAccessibilityWindowMovedNotification,
                           NSAccessibilityWindowResizedNotification,
                           NSAccessibilityWindowMiniaturizedNotification,
                           NSAccessibilityWindowDeminiaturizedNotification ];
    });
    return notifications;
}

#pragma mark - Observing

- (void)addNotification:(NSString *)notification {
    AXObserverAddNotification((__bridge AXObserverRef)self.observer, (__bridge AXUIElementRef)self.element, (__bridge CFStringRef)notification, NULL);
}

- (void)removeNotification:(NSString *)notification {
    AXObserverRemoveNotification((__bridge AXObserverRef)self.observer, (__bridge AXUIElementRef)self.element, (__bridge CFStringRef)notification);
}

#pragma mark - Setting up

- (void)setup {
    CFRunLoopAddSource(CFRunLoopGetCurrent(), AXObserverGetRunLoopSource((__bridge AXObserverRef)self.observer), kCFRunLoopDefaultMode);
    
    for (NSString *notification in [BDAXObserver notifications]) {
        [self performSelectorInBackground:@selector(addNotification:) withObject:notification];
    }
}

@end
