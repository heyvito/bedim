//
//  BDWorkspace.h
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDWorkspace : NSObject
- (void)applyBlurEffect;
- (void)removeBlurEffect;
- (void)suspendBlurEffect;
- (void)resumeBlurEffect;
@end
