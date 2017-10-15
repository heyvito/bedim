//
//  BDAboutViewController.m
//  Bedim
//
//  Created by Victor Gama on 15/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "BDAboutViewController.h"

@interface BDAboutViewController ()

@property (unsafe_unretained) IBOutlet NSTextView *licenseTextView;
@property (weak) IBOutlet NSTextField *versionTextField;

@end

@implementation BDAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Licenses" ofType:@""];
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.licenseTextView setString:contents];
    [self.licenseTextView setFont:[NSFont fontWithName:@"Menlo" size:11]];
    id versionData = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    id buildData = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    [self.versionTextField setStringValue:[NSString stringWithFormat:@"Version %@ (%@)", versionData, buildData]];
}

- (NSString *)viewIdentifier {
    return NSStringFromClass([self class]);
}

- (NSString *)toolbarItemLabel {
    return @"About";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNameInfo];
}

@end
