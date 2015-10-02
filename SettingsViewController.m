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
@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipControl;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    long defaultTipPercentIndex = [defaults integerForKey:@"default_tip_percent_index"];
    self.defaultTipControl.selectedSegmentIndex = defaultTipPercentIndex;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
