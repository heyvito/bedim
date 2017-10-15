//
//  BDAXUIElement.h
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDAXUIElement : NSObject

#pragma mark - Properties

@property (nonatomic, readonly) pid_t processIdentifier;
@property (nonatomic, readonly, nonnull) id element;

#pragma mark - Lifecycle

+ (nonnull instancetype) new NS_UNAVAILABLE;
- (nonnull instancetype) init NS_UNAVAILABLE;
- (nonnull instancetype) initWithElement:(nonnull id)element NS_DESIGNATED_INITIALIZER;

#pragma mark - Misc. Getters

- (nonnull id)valueForAttribute:(nonnull NSString *)attribute;
- (nonnull NSArray *)valuesForAttribute:(nonnull NSString *)attribute fromIndex:(NSUInteger)index count:(NSUInteger)count;
- (nonnull id)valueForAttribute:(nonnull NSString *)attribute withDefaultValue:(nonnull id)defValue;

@end
