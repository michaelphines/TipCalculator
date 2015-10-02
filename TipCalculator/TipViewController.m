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
@property int oldDefaultTip;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tip Calculator";
    [self.BillAmountTextField becomeFirstResponder];
    [self initializeDefaults];
    [self storeOldDefaultTip];
    [self loadDefaultTip];
}

- (long)defaultTip {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey: @"default_tip_percent_index"];
}

- (void)storeOldDefaultTip {
    self.oldDefaultTip = [self defaultTip];
}

- (BOOL)defaultTipChanged {
    return self.oldDefaultTip != [self defaultTip];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self storeOldDefaultTip];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self defaultTipChanged]) {
        [self loadDefaultTip];
    }
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
    self.TipPercentControl.selectedSegmentIndex = [self defaultTip];
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

- (NSString *)formatNumber: (NSNumber *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromNumber:number];
}

- (NSNumber *)parseNumber: (NSString *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter numberFromString:number];
}

- (void)updateValues {
    float billAmount = [[self parseNumber:self.BillAmountTextField.text] floatValue];
    float tipAmount = [self currentTipPercent] * billAmount;
    float totalAmount = billAmount + tipAmount;
    
    self.TipAmountLabel.text = [self formatNumber: @(tipAmount)];
    self.TotalLabel.text = [self formatNumber: @(totalAmount)];
}

- (IBAction)editingChanged:(UITextField *)sender {
    [self updateValues];
}
- (IBAction)onSettingsTap:(UIBarButtonItem *)sender {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

@end
