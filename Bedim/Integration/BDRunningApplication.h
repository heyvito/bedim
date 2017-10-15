//
//  BDRunningApplication.h
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDAXUIElement.h"

@class BDWindow;

@interface BDRunningApplication : BDAXUIElement

+ (nonnull NSArray<BDRunningApplication *> *)all;
- (nonnull NSArray<BDWindow *> *)windows;

@end
