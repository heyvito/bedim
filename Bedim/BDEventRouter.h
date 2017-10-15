//
//  BDEventRouter.h
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BDEventRouterDelegate <NSObject>
- (void)bdEventReceived;
@end

@interface BDEventRouter : NSObject

@property (nullable, nonatomic, weak) id<BDEventRouterDelegate> delegate;

@end
