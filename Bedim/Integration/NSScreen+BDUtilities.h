//
//  NSScreen+BDUtilities.h
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSScreen (BDUtilities)

@property (nonatomic, readonly, retain) NSString *identifier;

- (CGRect)flippedFrame;


+ (instancetype)screenWithID:(NSString *)id;


@end
