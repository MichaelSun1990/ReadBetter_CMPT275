//
//  SignUp.m
//  RN
//  Group 16: Four Square
//  Created by Yang Shi on 13-10-26.
//  Copyright (c) 2013 16. All rights reserved.
//

#import "SignUp.h"

@interface SignUp ()

@end

@implementation SignUp

//the animation of moving the screen when editing
CGFloat animatedDistance;
static const CGFloat KeyboardAnimationDuration = 0.3;
static const CGFloat MinimumScrollFraction = 0.2;
static const CGFloat MaximumScrollFraction = 0.8;
static const CGFloat PortraitKeyboardHeight = 216;
static const CGFloat LandscapeKeyboardHeight = 162;


// method allow the object move up when the key board shows up 
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

// method provide a tool bar for number pad for password textfield
- (void) toolBarNumber{
  
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
     _Password.inputAccessoryView = numberToolbar;
}

//cancel the number pad input
-(void)cancelNumberPad{
    [_Password resignFirstResponder];
    _Password.text = @"";
}

// close the number pad after use it
-(void)doneWithNumberPad{
    // NSString *numberFromTheKeyboard = _Password.text;
    [_Password resignFirstResponder];
}

// method provide a tool bar for number pad for retype password textfield
- (void) toolBarNumberRe{
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPadRe)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadRe)],
                           nil];
    [numberToolbar sizeToFit];
    _RePassword.inputAccessoryView = numberToolbar;
}

//cancel the number pad input
-(void)cancelNumberPadRe{
    [_RePassword resignFirstResponder];
    _RePassword.text = @"";
}

// close the number pad after use it
-(void)doneWithNumberPadRe{
    // NSString *numberFromTheKeyboard = _Password.text;
    [_RePassword resignFirstResponder];
}

- (void)viewDidLoad
{
    // give components special font
     [_backButton titleLabel].font= [UIFont fontWithName:@"OpenDyslexic" size:20];
    _UserID.font = [UIFont fontWithName:@"OpenDyslexic" size:20];
    _Password.font=[UIFont fontWithName:@"OpenDyslexic" size:20];
    _RePassword.font=[UIFont fontWithName:@"OpenDyslexic" size:20];
    [_createAccount titleLabel].font= [UIFont fontWithName:@"OpenDyslexic" size:20];
    _Password.keyboardType = UIKeyboardTypeNumberPad;
    _RePassword.keyboardType = UIKeyboardTypeNumberPad;
    
    [self toolBarNumber];
    [self toolBarNumberRe];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.textFields = [NSArray arrayWithObjects:self.UserID,self.Password,self.RePassword,nil];
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

//method will allow user to save their username and password to sign up an acccount
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    // if user type nothing tell user and let user retry, or decide to cancel sing up
    if((_Password.text.length==0 || _UserID.text.length==0||_RePassword.text.length==0)&&(!_goback)){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid Input"
                                                       message:@"Your userid or password field is empty"
                                                      delegate:self
                                             cancelButtonTitle:@"Try again!"
                                             otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    // if user retyped password dismatch the preivous one，or decide to cancel sing up
    else if (![_Password.text isEqualToString:_RePassword.text]&&(!_goback)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid Input"
                                                       message:@"Your password is not Match"
                                                      delegate:self
                                             cancelButtonTitle:@"Try again!"
                                             otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    // user fill in all necessay parts , and system save the user name and password into usedefault
    // for log in in the future
    else{
        
        [[NSUserDefaults standardUserDefaults] setObject:_UserID.text forKey:@"accountName"];
        [[NSUserDefaults standardUserDefaults] setObject:_Password.text forKey:@"password"];

        return YES;
    }
}

// if user press back button, let user go back to log in view
- (IBAction)cancelSignUP:(id)sender {
    _goback =YES;
}
@end
