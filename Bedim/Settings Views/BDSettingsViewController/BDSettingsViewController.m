//
//  BDSettingsViewController.m
//  Bedim
//
//  Created by Victor Gama on 15/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "BDSettingsViewController.h"
#import "BDStorage.h"
#import "BDFileSystem.h"
#import "AppDelegate.h"
#import "BDWorkspace.h"

@interface BDSettingsViewController ()
@property (weak) IBOutlet NSSlider *blurAmountSlider;
@property (weak) IBOutlet NSTextField *cacheSizeLabel;
@property (weak) IBOutlet NSButton *clearCacheButton;

@end

@implementation BDSettingsViewController

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return self = [super initWithNibName:@"BDSettingsViewController"
                                  bundle:nibBundleOrNil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)viewDidAppear {
    [super viewDidAppear];
    self.blurAmountSlider.intValue = [BDStorage sharedStorage].blurringAmount;
    [self performSelectorInBackground:@selector(calculateCacheSize) withObject:nil];
}

- (void)calculateCacheSize {
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.clearCacheButton setEnabled:NO];
        [self.cacheSizeLabel setStringValue:@"Calculating..."];
    });
    unsigned long long cacheSize = [BDFileSystem getFolderSize:[BDFileSystem cachePath]];
    NSString *size = [NSByteCountFormatter stringFromByteCount:cacheSize countStyle:NSByteCountFormatterCountStyleFile];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.clearCacheButton setEnabled:YES];
        [self.cacheSizeLabel setStringValue:size];
    });
}

- (void)clearCacheAndRestart {
    AppDelegate *del = (AppDelegate *)[NSApp delegate];
    [del.workspace removeBlurEffect];
    [BDFileSystem clearCache];
    [self performSelectorInBackground:@selector(calculateCacheSize) withObject:nil];
    [del.workspace applyBlurEffect];
}

- (IBAction)clearCacheButtonDidClick:(id)sender {
    [self clearCacheAndRestart];
}

- (IBAction)blurAmountSliderDidChange:(NSSlider *)sender {
    [[BDStorage sharedStorage] setBlurringAmount:sender.intValue];
    [self clearCacheAndRestart];
}

- (NSString *)viewIdentifier {
    return NSStringFromClass([self class]);
}

- (NSString *)toolbarItemLabel {
    return @"General";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

@end
