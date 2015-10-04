//
//  MainMenu.m
//  RN
//  Group 16: Four Square
//  Created by Yang Shi on 13-10-26.
//  Copyright (c) 2013 16. All rights reserved.
//

#import "MainMenu.h"

@interface MainMenu ()

@end

@implementation MainMenu

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
    //give texts a special font
    [_spell titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:20];
    [_reader titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:20];
    [_setting titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:20];
    [_progress titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:20];
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
