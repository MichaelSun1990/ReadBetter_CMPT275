//
//  setting1ViewController.m
//  group16
//
//  Created by Michael Sun on 11/26/2013.
//  Copyright (c) 2013 16. All rights reserved.
//

#import "setting1ViewController.h"

@interface setting1ViewController ()

@end

@implementation setting1ViewController

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundAll2.jpg"]]];
    [_backButton titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:20];
    _titleP.font =[UIFont fontWithName:@"OpenDyslexic" size:35];
    _contains.font=[UIFont fontWithName:@"OpenDyslexic" size:16];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
