//
//  BDEventRouter.m
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BDEventRouter.h"
#import "BDAXObserver.h"
#import "DebugLog.h"


@implementation BDEventRouter {
    NSNotificationCenter *workspaceNotificationCenter;
    NSNotificationCenter *defaultNotificationCenter;
    NSNotificationCenter *distributedNotificationCenter;
    
    NSMutableDictionary<NSNumber *, BDAXObserver *> *observers;
}

- (instancetype)init {
    if(self = [super init]) {
        workspaceNotificationCenter = [[NSWorkspace sharedWorkspace] notificationCenter];
        defaultNotificationCenter = [NSNotificationCenter defaultCenter];
        distributedNotificationCenter = [NSDistributedNotificationCenter defaultCenter];
        observers = [[NSMutableDictionary alloc] init];
        
        [workspaceNotificationCenter addObserver:self selector:@selector(workspaceNotification:) name:nil object:nil];
        [defaultNotificationCenter addObserver:self selector:@selector(defaultNotification:) name:@"BDAX_NOTIFICATION" object:nil];
        
        [self observeApps:[NSWorkspace sharedWorkspace].runningApplications];
        [[NSWorkspace sharedWorkspace] addObserver:self
                                        forKeyPath:@"runningApplications"
                                           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                           context:NULL];
    }
    return self;
}

- (void)observeApps:(NSArray<NSRunningApplication *> *)apps {
    for (NSRunningApplication *app in apps) {
        observers[@(app.processIdentifier)] = [[BDAXObserver alloc] initWithApp:app];
    }
}

- (void)removeApps:(NSArray<NSRunningApplication *> *)apps {
    for (NSRunningApplication *app in apps) {
        [observers removeObjectForKey:@(app.processIdentifier)];
    }
}

- (void)dealloc {
    [[NSWorkspace sharedWorkspace] removeObserver:self forKeyPath:@"runningApplications"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)__unused object
                         change:(NSDictionary<NSString *, id> *)change
                        context:(void *)__unused context {
    
    if([keyPath isEqualToString:@"runningApplications"]) {
        
        NSUInteger kind = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
        if (kind == NSKeyValueChangeInsertion) {
            [self observeApps:change[NSKeyValueChangeNewKey]];
            return;
        }
        
        if (kind == NSKeyValueChangeRemoval) {
            [self removeApps:change[NSKeyValueChangeOldKey]];
        }
    }
}


- (void)workspaceNotification:(NSNotification *)aNotification {
    Debug(@"[BDEventRouter] Dispatching notification based on %@", aNotification.name);
    if(self.delegate) { [self.delegate bdEventReceived]; }
}

- (void)defaultNotification:(NSNotification *)aNotification {
    if(self.delegate) { [self.delegate bdEventReceived]; }
}

@end
