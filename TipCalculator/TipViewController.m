//
//  ViewController.m
//  TipCalculator
//
//  Created by Michael Hines on 10/1/15.
//  Copyright © 2015 Michael Hines. All rights reserved.
//

#import "TipViewController.h"

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
    [self updateValues];
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

@end
