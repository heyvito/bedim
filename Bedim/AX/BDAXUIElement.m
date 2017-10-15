//
//  BDAXUIElement.m
//  Bedim
//
//  Created by Victor Gama on 14/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "BDAXUIElement.h"

@implementation BDAXUIElement

#pragma mark Lifecycle

- (instancetype)initWithElement:(id)element {
    if (self = [super init]) {
        _element = element;
        AXUIElementSetMessagingTimeout((__bridge AXUIElementRef)_element, 3);
    }
    return self;
}

- (id)valueForAttribute:(NSString *)attribute {
    CFTypeRef value = NULL;
    AXError err = AXUIElementCopyAttributeValue((__bridge AXUIElementRef)_element, (__bridge CFStringRef)attribute, &value);
    if(err != kAXErrorSuccess) {
        NSLog(@"AX call failed for element %@: %d", _element, err);
    }
    return CFBridgingRelease(value);
}


- (NSArray *)valuesForAttribute:(NSString *)attribute fromIndex:(NSUInteger)index count:(NSUInteger)count {
    CFArrayRef values = NULL;
    AXError err = AXUIElementCopyAttributeValues((__bridge AXUIElementRef)_element,
                                   (__bridge CFStringRef)attribute,
                                   index,
                                   count,
                                   &values);
    if(err != kAXErrorSuccess) {
        NSLog(@"AX call failed for element %@: %d", _element, err);
    }
    
    return CFBridgingRelease(values);
}

- (id)valueForAttribute:(NSString *)attribute withDefaultValue:(id)defValue {
    id value = [self valueForAttribute:attribute];
    if(value == nil) {
        value = defValue;
    }
    return value;
}

- (pid_t)processIdentifier {
    pid_t pid;
    AXError error = AXUIElementGetPid((__bridge AXUIElementRef)_element, &pid);
    if(error != kAXErrorSuccess) {
        NSLog(@"Error: Could not get process identifier for accessibility element %@. (%d)", _element, error);
    }
    return pid;
}

@end
