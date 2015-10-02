//
//  ViewController.m
//  TipCalculator
//
//  Created by Michael Hines on 10/1/15.
//  Copyright © 2015 Michael Hines. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *BillAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *TipAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *TotalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *TipPercentControl;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tip Calculator";
    [self initializeDefaults];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadDefaultTip];
    [self updateValues];
}

- (void)initializeDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDefaultsDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInt:1], @"default_tip_percent_index",
                                          nil];
    [defaults registerDefaults:userDefaultsDefaults];
}

- (void)loadDefaultTip {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    long defaultTipPercentIndex = [defaults integerForKey:@"default_tip_percent_index"];
    
    self.TipPercentControl.selectedSegmentIndex = defaultTipPercentIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tipPercentChanged:(UISegmentedControl *)sender {
    [self updateValues];
}

- (float)currentTipPercent {
    NSArray *tipPercents = @[@(0.15), @(0.2), @(0.25)];
    NSNumber *tipPercent = tipPercents[self.TipPercentControl.selectedSegmentIndex];
    return [tipPercent floatValue];
}

- (void)updateValues {
    float billAmount = [self.BillAmountTextField.text floatValue];
    float tipAmount = [self currentTipPercent] * billAmount;
    float totalAmount = billAmount + tipAmount;
    
    self.TipAmountLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.TotalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
}

- (IBAction)viewTapped:(UITapGestureRecognizer *)sender {
    [self updateValues];
}

- (IBAction)editingChanged:(UITextField *)sender {
    [self updateValues];
}
- (IBAction)onSettingsTap:(UIBarButtonItem *)sender {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

@end
