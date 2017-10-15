//
//  BDWorkspace.m
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BDWorkspace.h"
#import "BDWindow.h"
#import "BDRunningApplication.h"
#import "NSScreen+BDUtilities.h"
#import "BDImageProcessor.h"
#import "BDStorage.h"
#import "BDFileSystem.h"

@implementation BDWorkspace {
    BDStorage *storage;
    BOOL suspended;
}

- (void)suspendBlurEffect {
    suspended = true;
}

- (void)resumeBlurEffect {
    suspended = false;
}

- (instancetype)init {
    if(self = [super init]) {
        storage = [BDStorage sharedStorage];
    }
    return self;
}

- (void)removeBlurEffect {
    NSArray<NSScreen *> *screens = [NSScreen screens];
    for(NSScreen *screen in screens) {
        NSString *originalPicture = [storage originalPictureForScreen:screen];
        if(!originalPicture) {
            continue;
        }
        [self setBackground:originalPicture forScreen:screen];
    }
}

- (void)applyBlurEffect {
    if(suspended) return;
    NSArray<NSScreen *> *screens = [NSScreen screens];
    NSSet<NSScreen *> *screensToBlur = [self screensToBlur];
    for(NSScreen *screen in screens) {
        BOOL shouldBlur = [screensToBlur containsObject:screen];
        NSString *currentPicture = [[[NSWorkspace sharedWorkspace] desktopImageURLForScreen:screen] path];
        BOOL isBlurred = [BDFileSystem isBedimDomainImage:currentPicture];
        
        if(!shouldBlur) {
            if(isBlurred) {
                NSString *originalPicture = [storage originalPictureForScreen:screen];
                if(!originalPicture) {
                    continue;
                }
                [self setBackground:originalPicture forScreen:screen];
            }
        } else {
            if(!isBlurred) {
                if(![BDFileSystem isBedimDomainImage:currentPicture]) {
                    [storage storeOriginalPicture:currentPicture forScreen:screen];
                } else {
                    NSLog(@"Out of sync? Attempting to blur image %@ for screen %@", currentPicture, screen.identifier);
                    continue;
                }
                
                NSString *blurredPath = [BDFileSystem cachePathForImageWithPath:currentPicture];
                if(![[NSFileManager defaultManager] fileExistsAtPath:blurredPath]) {
                    [BDImageProcessor blurSourceImage:currentPicture toDestination:blurredPath];
                }
                [self setBackground:blurredPath forScreen:screen];
            }
        }
    }
}

- (void)setBackground:(NSString *)path forScreen:(NSScreen *)screen {
    NSError *error;
    [[NSWorkspace sharedWorkspace] setDesktopImageURL:[NSURL fileURLWithPath:path] forScreen:screen options:@{} error:&error];
    if(error != nil) {
        NSLog(@"Changing wallpaper yielded error: %@", error);
    }
}

- (NSSet<NSScreen *> *)screensToBlur {
    // Determining which screen must be blurred
    
    // 1. Get visible PIDs
    
    CFArrayRef arrayRef = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements, kCGNullWindowID);
    NSMutableArray *windows = (__bridge NSMutableArray *)arrayRef;
    NSMutableArray<NSNumber *> *pids = [[NSMutableArray alloc] init];
    
    for (NSDictionary *window in windows) {
        if([[window objectForKey:((__bridge NSString *) kCGWindowLayer)] intValue] == 0) {
            [pids addObject:[window objectForKey:((__bridge NSString *)kCGWindowOwnerPID)]];
        }
    }
    
    // 2. Transform them in BDRunningApplications
    NSMutableArray<BDRunningApplication *> *apps = [[NSMutableArray alloc] init];
    for(BDRunningApplication *app in [BDRunningApplication all]) {
        if([pids containsObject:[NSNumber numberWithInteger:app.processIdentifier]]) {
            [apps addObject:app];
        }
    }
    
    // 3. Fill in an array of screens
    NSMutableSet<NSScreen *> *screens = [[NSMutableSet alloc] init];
    for(BDRunningApplication *app in apps) {
        for(BDWindow *window in app.windows) {
            if(![window isVisible]) {
                continue;
            }
            NSScreen *screen = [window screen];
            if(screen != nil) {
                [screens addObject:screen];
            }
        }
    }
    
    CFRelease(arrayRef);
    
    return screens;
}



@end
