//
//  BDFileSystem.h
//  Bedim
//
//  Created by Victor Gama on 15/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDFileSystem : NSObject
+ (unsigned long long)getFolderSize:(nonnull NSString *)folderPath;
+ (BOOL)isBedimDomainImage:(nonnull NSString *)name;
+ (nonnull NSString *)cachePathForImageWithPath:(nonnull NSString *)original;
+ (nonnull NSString *)cachePath;
+ (void)clearCache;
@end
