//
//  BDStorage.m
//  Bedim
//
//  Created by Victor Gama on 15/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ServiceManagement/ServiceManagement.h>
#import "BDStorage.h"
#import "NSScreen+BDUtilities.h"
#import "BDFileSystem.h"

@implementation BDStorage {
    NSMutableDictionary<NSString *, NSString *> *originalPictures;
    int blurringAmount;
    BOOL blurringEnabled;
    BOOL autoStart;
}

static NSString *kOriginalPictures = @"original_pictures";
static NSString *kBlurringAmount = @"blurring_amount";
static NSString *kBlurringEnabled = @"blurring_enabled";
static NSString *kAutoStart = @"auto_start";

+ (instancetype)sharedStorage {
    static dispatch_once_t onceToken;
    static BDStorage *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)flushData {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:originalPictures forKey:kOriginalPictures];
    [def setInteger:blurringAmount forKey:kBlurringAmount];
    [def synchronize];
}

- (instancetype)init {
    if(self = [super init]) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        // Let's just assume a few sensible defaults here
        if([def objectForKey:kBlurringAmount] == nil) {
            self->blurringAmount = 15;
        } else {
            self->blurringAmount = (int)[def integerForKey:kBlurringAmount];
        }
        
        if([def objectForKey:kOriginalPictures] == nil) {
            self->originalPictures = [[NSMutableDictionary alloc] init];
        } else {
            self->originalPictures = [[def dictionaryForKey:kOriginalPictures] mutableCopy];
        }
        
        if([def objectForKey:kBlurringEnabled] == nil) {
            self->blurringEnabled = YES;
        } else {
            self->blurringEnabled = [def boolForKey:kBlurringEnabled];
        }
        
        if([def objectForKey:kAutoStart] == nil) {
            NSLog(@"[BDStorage] kAutoStart is undefined.");
            if([BDFileSystem isRunningFromApplicationsFolder]) {
                    NSLog(@"[BDStorage] AutoRegistering to AutoStart since we're running from Applications folder.");
                [self setAutoStart:YES];
            } else {
                NSLog(@"[BDStorage] Skipping autostart since we're not running from Applications folder.");
                self->autoStart = NO;
            }
        } else {
            self->autoStart = [def boolForKey:kAutoStart];
        }
        
        [self precacheScreensState];
    }
    return self;
}

- (int)blurringAmount {
    return self->blurringAmount;
}

- (void)setBlurringAmount:(int)blurringAmount {
    self->blurringAmount = blurringAmount;
    [self flushData];
}

- (BOOL)blurringEnabled {
    return self->blurringEnabled;
}

- (void)setBlurringEnabled:(BOOL)blurringEnabled {
    self->blurringEnabled = blurringEnabled;
    [self flushData];
}

- (void)storeOriginalPicture:(NSString *)path forScreen:(NSScreen *)screen {
    originalPictures[screen.identifier] = path;
    [self flushData];
}

- (NSString *)originalPictureForScreen:(NSScreen *)screen {
    return originalPictures[screen.identifier];
}

- (void)precacheScreensState {
    for(NSScreen *screen in [NSScreen screens]) {
        NSString *path = [[[NSWorkspace sharedWorkspace] desktopImageURLForScreen:screen] path];
        if(![BDFileSystem isBedimDomainImage:path]) {
            originalPictures[screen.identifier] = path;
        }
    }
    [self flushData];
}

- (BOOL)autoStart {
    return self->autoStart;
}

- (void)setAutoStart:(BOOL)autoStart {
    self->autoStart = autoStart;
    NSString *bundleIdentifier = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] stringByAppendingString:@"Helper"];
    CFStringRef cfBundleID = (__bridge CFStringRef)bundleIdentifier;
    BOOL result = SMLoginItemSetEnabled(cfBundleID, autoStart);
    NSLog(@"SMLoginItemSetEnabled result: %d", result);
}

@end
