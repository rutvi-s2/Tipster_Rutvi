//
//  TipViewController.m
//  Tipster
//
//  Created by rutvims on 6/22/21.
//

#import "TipViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billAmountField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipPercentageControl;
@property (weak, nonatomic) IBOutlet UIView *labelsContainerView;
@property (weak, nonatomic) IBOutlet UIView *billBackground;
@property (weak, nonatomic) IBOutlet UITextField *customTip;
@property (weak, nonatomic) IBOutlet UILabel *numPeople;
- (IBAction)stepperUpdate:(UIStepper *)sender;

@end

@implementation TipViewController
double doubleValue;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.customTip.alpha = 0;
    [self.billAmountField becomeFirstResponder];
    double doubleValue = 0.15;
    // Do any additional setup after loading the view.
}
- (IBAction)onTap:(id)sender {
    NSLog(@"hello");
    
    [self.view endEditing:true];
}
- (IBAction)updateLabels:(id)sender {
    if(self.billAmountField.text.length == 0){
        [self hideLabels];
    }else{
        [self showLabels];
    }
    if(self.tipPercentageControl.selectedSegmentIndex == 3){
        self.customTip.alpha = 1;
    }else{
        self.customTip.alpha = 0;
    }
    [self doCalculations];
}
-(void)doCalculations{
    double tipPercentages[] = {doubleValue, 0.20, 0.25, ([self.customTip.text doubleValue] * 0.01)};
    double tipPercentage = tipPercentages[self.tipPercentageControl.selectedSegmentIndex];
    int split = [self.numPeople.text doubleValue];
    double bill = [self.billAmountField.text doubleValue];
    double tip = bill * tipPercentage;
    double total = (bill + tip)/split;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%.2f", tip];
    self.totalLabel.text = [NSString stringWithFormat:@"$%.2f", total];
}
-(void)hideLabels{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect billFrame = self.billAmountField.frame;
        billFrame.origin.y += 200;
        
        self.billAmountField.frame = billFrame;
        
        CGRect labelsFrame = self.labelsContainerView.frame;
        labelsFrame.origin.y += 200;
        
        self.labelsContainerView.frame = labelsFrame;
        self.labelsContainerView.alpha = 0;
        self.billBackground.alpha = 0;
    }];
}
-(void)showLabels{
    if(self.labelsContainerView.alpha == 0){
        [UIView animateWithDuration:0.5 animations:^{
            CGRect billFrame = self.billAmountField.frame;
            billFrame.origin.y -= 200;
            
            self.billAmountField.frame = billFrame;
            
            CGRect labelsFrame = self.labelsContainerView.frame;
            labelsFrame.origin.y -= 200;
            
            self.labelsContainerView.frame = labelsFrame;
            self.labelsContainerView.alpha = 1;
            self.billBackground.alpha = 1;
        }];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    doubleValue = [defaults doubleForKey:@"default_tip_percentage"] * 0.01;
    [self doCalculations];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)stepperUpdate:(UIStepper *)sender {
    self.numPeople.text = [NSString stringWithFormat:@"%.0f", sender.value];
    [self doCalculations];
}
@end
