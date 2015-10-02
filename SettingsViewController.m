//
//  SettingsViewController.m
//  TipCalculator
//
//  Created by Michael Hines on 10/1/15.
//  Copyright © 2015 Michael Hines. All rights reserved.
//

#import "SettingsViewController.h"
#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorThemeControl;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorThemeLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.defaultTipControl.selectedSegmentIndex = [defaults integerForKey:@"default_tip_percent_index"];
    self.colorThemeControl.selectedSegmentIndex = [defaults integerForKey:@"theme"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateTheme];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onChangeDefaultTip:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:[self.defaultTipControl selectedSegmentIndex] forKey:@"default_tip_percent_index"];
    [defaults synchronize];
}

- (IBAction)onThemeChange:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:[self.colorThemeControl selectedSegmentIndex] forKey:@"theme"];
    [defaults synchronize];
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTheme];
    }];
}

- (void)updateTheme {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"theme"] == 0) {
        [self.mainView setBackgroundColor: [UIColor whiteColor]];
        [self.helpLabel setTextColor: [UIColor darkTextColor]];
        [self.defaultTipLabel setTextColor: [UIColor darkTextColor]];
        [self.colorThemeLabel setTextColor: [UIColor darkTextColor]];
        [self.colorThemeControl setTintColor: nil];
        [self.defaultTipControl setTintColor: nil];
    } else {
        [self.mainView setBackgroundColor: [UIColor darkGrayColor]];
        [self.helpLabel setTextColor: [UIColor whiteColor]];
        [self.defaultTipLabel setTextColor: [UIColor whiteColor]];
        [self.colorThemeLabel setTextColor: [UIColor whiteColor]];
        [self.colorThemeControl setTintColor: [UIColor whiteColor]];
        [self.defaultTipControl setTintColor: [UIColor whiteColor]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
