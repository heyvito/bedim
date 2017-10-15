//
//  BDImageProcessor.m
//  Bedim
//
//  Created by Victor Gama on 15/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <Cocoa/Cocoa.h>
#import "BDImageProcessor.h"
#import "BDStorage.h"


@implementation BDImageProcessor

+ (void)blurSourceImage:(NSString *)source toDestination:(NSString *)destination {
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:source];
    NSRect imageRect = NSMakeRect(0, 0, image.size.width, image.size.height);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef inputCGImage = [image CGImageForProposedRect:&imageRect context:NULL hints:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:inputCGImage];
    
    // Clamping prevents the result from having white borders
    CIFilter *affineClampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [affineClampFilter setValue:inputImage forKey:kCIInputImageKey];
    CGAffineTransform xform = CGAffineTransformMakeScale(1.0, 1.0);
    [affineClampFilter setValue:[NSValue valueWithBytes:&xform
                                               objCType:@encode(CGAffineTransform)]
                         forKey:@"inputTransform"];
    
    
    // Blurring makes it nice
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:affineClampFilter.outputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:((float)[BDStorage sharedStorage].blurringAmount)]
              forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  Yo! CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    NSImage *retVal = [[NSImage alloc] initWithCGImage:cgImage size:imageRect.size];
    
    NSData *imageData = [retVal TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
    [imageData writeToFile:destination atomically:NO];
    
    if (cgImage) {
        CGImageRelease(cgImage);
    }
}

@end
