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
@property long oldDefaultTip;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tip Calculator";
    [self.BillAmountTextField becomeFirstResponder];
    [self initializeDefaults];
    [self storeOldDefaultTip];
    [self loadDefaultTip];
    [self loadLastState];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
}

-(void)appWillResignActive:(NSNotification*)note
{
    [self saveLastState];
}

-(void)appWillTerminate:(NSNotification*)notification
{
    [self saveLastState];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

- (void)saveLastState {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"last_open_time"];
    [defaults setObject:self.BillAmountTextField.text forKey:@"last_bill_amount"];
    [defaults setInteger:self.TipPercentControl.selectedSegmentIndex forKey:@"last_tip_percent_index"];
}

- (BOOL)hasRecentState {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *savedDataTime = (NSDate *)[defaults objectForKey: @"last_open_time"];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:savedDataTime toDate:now options:0];
    NSInteger diff = components.minute;

    return diff < 10;
}

- (void)loadLastState {
    if ([self hasRecentState]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.BillAmountTextField.text = [defaults stringForKey: @"last_bill_amount"];
        self.TipPercentControl.selectedSegmentIndex = [defaults integerForKey: @"last_tip_percent_index"];
        [self updateValues];
    }
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
