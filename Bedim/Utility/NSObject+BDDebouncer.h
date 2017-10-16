//
//  NSObject+BDDebouncer.h
//  Bedim
//
//  Created by Victor Gama on 16/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BDDebouncer)

- (void)debounce:(nonnull SEL)action withObject:(nullable id)obj delaying:(NSTimeInterval)interval;
- (void)repeat:(nonnull SEL)action after:(NSTimeInterval)interval;

@end
