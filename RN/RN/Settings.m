//
//  Settings.m
//  RN
//  Group 16: Four Square
//  Created by Yang Shi on 13-10-26.
//  Copyright (c) 2013 16. All rights reserved.
//

#import "Settings.h"

@interface Settings ()

@end

@implementation Settings

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
    // set special font for the buttons
    [_backbutton titleLabel].font = [UIFont fontWithName:@"OpenDyslexic" size:20];
    [_terms titleLabel].font = [UIFont fontWithName:@"OpenDyslexic" size:20];
    [_privacy titleLabel].font = [UIFont fontWithName:@"OpenDyslexic" size:20];
    [_about titleLabel].font = [UIFont fontWithName:@"OpenDyslexic" size:20];
    [_contact titleLabel].font = [UIFont fontWithName:@"OpenDyslexic" size:20];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

@end
