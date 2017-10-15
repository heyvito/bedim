//
//  BDStorage.h
//  Bedim
//
//  Created by Victor Gama on 15/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSScreen;

@interface BDStorage : NSObject

+ (nonnull instancetype)sharedStorage;

@property (nonatomic) int blurringAmount;
@property (nonatomic) BOOL blurringEnabled;

- (void)storeOriginalPicture:(nonnull NSString *)path forScreen:(nonnull NSScreen *)screen;
- (nullable NSString *)originalPictureForScreen:(nonnull NSScreen *)screen;

@end
