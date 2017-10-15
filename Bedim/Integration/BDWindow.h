//
//  BDWindow.h
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDAXUIElement.h"

@class NSScreen;

@interface BDWindow : BDAXUIElement

@property (nonatomic, readonly) CGWindowID windowID;

- (NSScreen *)screen;
- (BOOL)isVisible;

@end
