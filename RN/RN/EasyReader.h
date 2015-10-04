//
//  EasyReader.h
//  RN
//  Group 16: Four Square
//  Created by Yang Shi on 13-10-26.
//  Copyright (c) 2013 16. All rights reserved.

//  Programmers who have worked on it: Yang Shi
//

#import <UIKit/UIKit.h>
#import "Google_TTS_BySham.h"// sound of the word and keyboard
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface EasyReader : UIViewController{
    double timeSpent;
    NSString *seconds;
    NSURL *myURL;
}

@property (weak, nonatomic) IBOutlet UITextView *myText; //the textview
@property (retain) IBOutlet UISlider *sizeSlider; //the slider
@property (strong, nonatomic) IBOutlet UILabel *progressText; // the label of the value of the slider
@property (weak, nonatomic) IBOutlet UIButton *mode; //the label of mode
@property (weak, nonatomic) IBOutlet UIImageView *background; //background image
@property (weak, nonatomic) IBOutlet UIButton *readButton;//the button to pronounce the word
@property (weak, nonatomic) IBOutlet UIButton *backButton;//back button
@property (weak, nonatomic) IBOutlet UIButton *smallSize;
@property (weak, nonatomic) IBOutlet UIButton *mediumSize;
@property (weak, nonatomic) IBOutlet UIButton *largeSize;

//described in .m file
- (IBAction)SliderValueChange:(UISlider *)sender;
- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender;
- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender;
- (IBAction)changeMode:(UIButton *)sender;
- (IBAction)sizeSmall:(UIButton *)sender;
- (IBAction)sizeMid:(UIButton *)sender;
- (IBAction)sizeLarge:(UIButton *)sender;
- (IBAction)read:(UIButton *)sender;

@property (nonatomic, strong) Google_TTS_BySham* sound;
@property (retain,nonatomic) NSDate *timingDate; //to load the current time
@property (nonatomic, retain) NSString *seconds; //to calculate the second spent on this file
@property (nonatomic,weak) NSString *textInFile; //the text in the file
@property (nonatomic,weak) NSArray* allLinedStrings; //the substring of the text in the file
@property NSString *path; //the path of the file
@property double timespent; //time spent on this file
-(void) letsWordCont:(NSString* ) words; //to count the words read
@property(nonatomic ,strong) UIColor* textColor;
@end
