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
@property (weak) IBOutlet NSButton *autoStartCheckbox;
@property (weak) IBOutlet NSTextField *cannotSetAutoStartLabel;
@property (weak) IBOutlet NSLayoutConstraint *dividerTopConstraint;

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

- (void)viewWillAppear {
    [super viewWillAppear];
    self.blurAmountSlider.intValue = [BDStorage sharedStorage].blurringAmount;
    [self performSelectorInBackground:@selector(calculateCacheSize) withObject:nil];
    if([BDFileSystem isRunningFromApplicationsFolder]) {
        self.autoStartCheckbox.enabled = YES;
        self.autoStartCheckbox.state = [BDStorage sharedStorage].autoStart ? NSControlStateValueOn : NSControlStateValueOff;
        self.cannotSetAutoStartLabel.hidden = YES;
        self.dividerTopConstraint.constant -= CGRectGetHeight(self.cannotSetAutoStartLabel.frame) + 8;
    } else {
        self.autoStartCheckbox.enabled = NO;
        self.autoStartCheckbox.state = NSControlStateValueOff;
    }
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

- (IBAction)autoStartCheckboxDidChange:(NSButton *)sender {
    [BDStorage sharedStorage].autoStart = sender.state == NSControlStateValueOn;
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
