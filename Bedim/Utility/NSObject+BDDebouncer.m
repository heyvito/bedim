//
//  NSObject+BDDebouncer.m
//  Bedim
//
//  Created by Victor Gama on 16/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "NSObject+BDDebouncer.h"
#import "DebugLog.h"

@implementation NSObject (BDDebouncer)

- (void)debounce:(SEL)action withObject:(id)obj delaying:(NSTimeInterval)interval {
    __weak typeof(self) weakSelf = self;
    [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:action object:obj];
    if(![self respondsToSelector:action]) {
        Debug(@"[BDDebouncer] Cancelling debounce: call since %@ does not respond to %@", self, NSStringFromSelector(action));
        return;
    }
    [weakSelf performSelector:action withObject:obj afterDelay:interval];
}

- (void)repeat:(SEL)action after:(NSTimeInterval)interval {
    [self debounce:@selector(redo:) withObject:NSStringFromSelector(action) delaying:interval];
}

- (void)redo:(NSString *)rawAction {
    SEL action = NSSelectorFromString(rawAction);
    Debug(@"[BDDebouncer] Performing redo:(%@) on %@", NSStringFromSelector(action), self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(![self respondsToSelector:action]) {
            NSLog(@"[BDDebouncer] Cancelling redo: call since %@ does not respond to %@", self, NSStringFromSelector(action));
            return;
        }
        IMP imp = [self methodForSelector:action];
        void (*func)(id, SEL) = (void *)imp;
        func(self, action);
    });
}

@end
