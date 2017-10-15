//
//  BDAXObserver.h
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "BDAXUIElement.h"

@class NSRunningApplication;

@interface BDAXObserver : BDAXUIElement

- (instancetype)initWithApp:(NSRunningApplication *)app;

@end
