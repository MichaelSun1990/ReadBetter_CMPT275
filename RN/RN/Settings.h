//
//  Settings.h
//  RN
//  Group 16: Four Square
//  Created by Yang Shi on 13-10-26.
//  Copyright (c) 2013 16. All rights reserved.

//  Programmers who have worked on it: Yang Shi
//
//  What we have done so far: Just interface and force autorotate

#import <UIKit/UIKit.h>

@interface Settings : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backbutton;
@property (weak, nonatomic) IBOutlet UIButton *terms;
@property (weak, nonatomic) IBOutlet UIButton *privacy;
@property (weak, nonatomic) IBOutlet UIButton *about;
@property (weak, nonatomic) IBOutlet UIButton *contact;

@end
