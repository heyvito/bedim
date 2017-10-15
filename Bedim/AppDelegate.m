//
//  AppDelegate.m
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <MASPreferences/MASPreferences.h>
#import "AppDelegate.h"
#import "BDWorkspace.h"
#import "BDEventRouter.h"
#import "BDSettingsViewController.h"
#import "BDAboutViewController.h"

@interface AppDelegate () <BDEventRouterDelegate>

@end

static AXUIElementRef systemWideElement = NULL;

@implementation AppDelegate {
    BDWorkspace *work;
    BDEventRouter *router;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    if(work == nil) {
        return;
    }
    [work suspendBlurEffect];
    [work removeBlurEffect];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    [NSApp activateIgnoringOtherApps:YES];
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    self.statusItem.image = [NSImage imageNamed:@"status_icon"];
    [self.statusItem.image setTemplate:YES];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setAction:@selector(quitApplication:)];
    
    // TODO: Move this and make it pretty
    BOOL universalAccessEnabled = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef) @{ (__bridge NSString *) kAXTrustedCheckOptionPrompt: @YES });
    if(!universalAccessEnabled) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"Bedim requires extra permissions";
        alert.informativeText = @"In order to run properly, Bedim requires permission to use assistive technologies. This allows the application to track open windows and determine in which screen they are being presented.\nTo do so, find the dialog right behind this one to enable accessibility for Bedim in System Preferences.\nOnce complete, launch Bedim again.";
        alert.icon = [NSImage imageNamed:NSImageNameInfo];
        [alert runModal];
        [NSApp terminate:self];
    }
    
    if (systemWideElement == NULL) {
        systemWideElement = AXUIElementCreateSystemWide();
    }
    
    work = [[BDWorkspace alloc] init];
    router = [[BDEventRouter alloc] init];
    router.delegate = self;
    [work applyBlurEffect];
}

- (IBAction)quitApplication:(id)sender {
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

- (IBAction)toggleBlurStatus:(NSMenuItem *)sender {
    sender.state = sender.state == NSControlStateValueOn ? NSControlStateValueOff : NSControlStateValueOn;
    if(sender.state == NSControlStateValueOn) {
        [work resumeBlurEffect];
        [work applyBlurEffect];
    } else {
        [work suspendBlurEffect];
        [work removeBlurEffect];
    }
}

- (IBAction)showPreferences:(NSMenuItem *)sender {
    static dispatch_once_t onceToken;
    static NSViewController *generalViewController;
    static NSViewController *aboutViewController;
    static MASPreferencesWindowController *wc;
    dispatch_once(&onceToken, ^{
        generalViewController =  [[BDSettingsViewController alloc] init];
        aboutViewController =  [[BDAboutViewController alloc] init];
        NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, [NSNull null], aboutViewController, nil];
        wc = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:@"Preferences"];
    });
    
    [wc showWindow:nil];
}

- (void)bdEventReceived {
    [work applyBlurEffect];
}

- (BDWorkspace *)workspace {
    return work;
}

@end
