//
//  Startmenu.m
//  RN
//  Group 16: Four Square
//  Created by Yang Shi on 13-10-26.
//  Copyright (c) 2013 16. All rights reserved.
//

#import "Startmenu.h"

@interface Startmenu ()

@end

@implementation Startmenu

//the animation of moving the screen when editing
CGFloat animatedDistance;
static const CGFloat KeyboardAnimationDuration = 0.3;
static const CGFloat MinimumScrollFraction = 0.2;
static const CGFloat MaximumScrollFraction = 0.8;
static const CGFloat PortraitKeyboardHeight = 216;
static const CGFloat LandscapeKeyboardHeight = 162;

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MinimumScrollFraction * viewRect.size.height;
    CGFloat denominator = (MaximumScrollFraction - MinimumScrollFraction) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PortraitKeyboardHeight * heightFraction);
    }
    else
    {   
        animatedDistance = floor(LandscapeKeyboardHeight * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KeyboardAnimationDuration];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KeyboardAnimationDuration];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
//animation part ended

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    _theID =[[NSUserDefaults standardUserDefaults]stringForKey:@"accountName"];
    _thePassWord=[[NSUserDefaults standardUserDefaults]stringForKey:@"password"];

    _newUser=NO;
    _UserID.font = [UIFont fontWithName:@"OpenDyslexic" size:20];
    _Password.font=[UIFont fontWithName:@"OpenDyslexic" size:20];
    [_logBUtton titleLabel].font= [UIFont fontWithName:@"OpenDyslexic" size:20];
    [_accountButton titleLabel].font= [UIFont fontWithName:@"OpenDyslexic" size:20];
    _Password.keyboardType = UIKeyboardTypeNumberPad;
    _Password.secureTextEntry = YES;
   
    // method which will provide a tool bar for number pad
    // let user to cancel the input and close the number pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _Password.inputAccessoryView = numberToolbar;

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.textFields = [NSArray arrayWithObjects:self.UserID,self.Password,nil];
}

//cancle function for cancel input
-(void)cancelNumberPad{
    [_Password resignFirstResponder];
    _Password.text = @"";// set the text field to empty
}

//finish using the number pad clase the number pad
-(void)doneWithNumberPad{
   // NSString *numberFromTheKeyboard = _Password.text;
    [_Password resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Force the view to rotate if needed
- (BOOL)shouldAutorotate{
    return YES;
}

//The orientation should be portrait
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//Display the keyboard when the user press return
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    //if the account name is wrong and not a new user
    if (![_UserID.text isEqualToString:_theID]&&(!_newUser)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid Input"
                                                       message:@"Your account name is not correct"
                                                      delegate:self
                                             cancelButtonTitle:@"Try again!"
                                             otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
        
    }
    //if the password is wrong and not a new user
    else if (![_Password.text isEqualToString:_thePassWord]&&(!_newUser)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid Input"
                                                       message:@"Your password is not correct"
                                                      delegate:self
                                             cancelButtonTitle:@"Try again!"
                                             otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    // empty input show use that they do not input anthing
    else if((_Password.text.length==0 || _UserID.text.length==0 )&&(!_newUser)){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid Input"
                                                       message:@"Your userid or password field is empty"
                                                      delegate:self
                                             cancelButtonTitle:@"Try again!"
                                             otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else{
        return YES;
    }
}
- (IBAction)newUser:(id)sender {
    _newUser=YES;
}
@end
