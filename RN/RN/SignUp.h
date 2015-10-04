//
//  SignUp.h
//  RN
//  Group 16: Four Square
//  Created by Yang Shi on 13-10-26.
//  Copyright (c) 2013 16. All rights reserved.

//  Programmers who have worked on it: Yang Shi
//
//  What we have done so far: Implement the text field editing function and the animation of moving the screen when editing. Also, display the keyboard when press the return button on the keyboard

#import <UIKit/UIKit.h>

// Modify @interface to mark as implementing UITextFieldDelegate
@interface SignUp : UIViewController <UITextFieldDelegate>

@property (strong) NSArray * textFields;
@property (weak, nonatomic) IBOutlet UITextField *UserID;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *RePassword;
@property (weak, nonatomic) IBOutlet UIButton *createAccount;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic) BOOL goback;
- (IBAction)cancelSignUP:(id)sender;

@end
