//
//  BDImageProcessor.h
//  Bedim
//
//  Created by Victor Gama on 15/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDImageProcessor : NSObject

+ (void)blurSourceImage:(nonnull NSString *)source toDestination:(nonnull NSString *)destination;

@end
