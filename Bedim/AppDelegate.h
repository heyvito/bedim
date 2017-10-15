//
//  AppDelegate.h
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BDWorkspace;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (nonatomic, readonly, retain) BDWorkspace *workspace;

@end

