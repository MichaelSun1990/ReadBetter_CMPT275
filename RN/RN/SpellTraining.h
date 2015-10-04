//
//  SpellTraining.h
//  RN
//  Group 16: Four Square
//  Created by Yang Shi on 13-10-26.
//  Copyright (c) 2013 16. All rights reserved.

//  Programmers who have worked on it: Yang Shi
//
//  What we have done so far: Just interface and force autorotate

#import <UIKit/UIKit.h>
#import "Google_TTS_BySham.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface SpellTraining : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *soundWord;// output the sound of he word
@property (weak, nonatomic) IBOutlet UIButton *tryAgain;// last user try all words again
@property (weak, nonatomic) IBOutlet UIButton *backToMain;// last user back to main menu after done all words
@property (weak, nonatomic) IBOutlet UIButton *pronounce;// output the sound of he word
@property (weak, nonatomic) IBOutlet UIButton *check;//  check user spelling
@property (weak, nonatomic) IBOutlet UIButton *levelOne;// change to level one
@property (weak, nonatomic) IBOutlet UIButton *levelTwo;// change to level two 
@property (weak, nonatomic) IBOutlet UIButton *levelThree;// change to level three
@property (weak, nonatomic) IBOutlet UIButton *chartButton;// go to help chart
@property (weak, nonatomic) IBOutlet UIButton *backbutton;// go beck to main menu
@property IBOutlet UIButton *currButton;// defind which button is pressed
@property IBOutlet UILabel* checkResult;//  show the check spelling result on the screen
@property IBOutlet NSMutableArray* lastParts;// last word's parts
@property IBOutlet NSMutableArray* removelastParts;// removed last parts
@property IBOutlet NSMutableArray* dirctionary;//  contains all words
@property IBOutlet UIScrollView* scrollview;// contains help chart
@property IBOutlet UIButton* backButton;// back from the chart 
@property IBOutlet UILabel* keyCont;//  the label show on screen after press any word part key
@property (nonatomic, strong) NSMutableArray *currKeys;// keys for current speling word
@property (nonatomic, strong) NSString* wordName;//  what is the word
@property (nonatomic ,strong) NSArray* currWord;//  current  spelling word
@property (nonatomic, strong) NSMutableArray *result;//  correct answer
@property (nonatomic, strong) AVAudioPlayer * audioPlayer;// play the sound
@property (nonatomic, strong) Google_TTS_BySham* sound;// use google library to sound the word
@property (nonatomic) int preivous; //  last word
@property (nonatomic) int partWid;  //default word parts label width
@property (nonatomic) int partHei;  //default word parts label height
@property (nonatomic) int textSize; // default text size
@property (nonatomic) int currLevel;// current level numbr

//keys
@property (weak, nonatomic) IBOutlet UIButton *keyB1;
@property (weak, nonatomic) IBOutlet UIButton *keyB2;
@property (weak, nonatomic) IBOutlet UIButton *keyB3;
@property (weak, nonatomic) IBOutlet UIButton *keyB4;
@property (weak, nonatomic) IBOutlet UIButton *keyB5;
@property (weak, nonatomic) IBOutlet UIButton *keyB6;
@property (weak, nonatomic) IBOutlet UIButton *keyB7;
@property (weak, nonatomic) IBOutlet UIButton *keyB8;
@property (weak, nonatomic) IBOutlet UIButton *keyB9;
@property (weak, nonatomic) IBOutlet UIButton *keyB10;
@property (weak, nonatomic) IBOutlet UIButton *keyB11;
@property (weak, nonatomic) IBOutlet UIButton *keyB12;
@property (weak, nonatomic) IBOutlet UIButton *keyB13;
@property (weak, nonatomic) IBOutlet UIButton *keyB14;
@property (weak, nonatomic) IBOutlet UIButton *keyB15;


- (IBAction)select1:(id)sender;// action for all word part keys
- (IBAction)showParts:(id)sender;// acion for sound the word
- (IBAction)nextWord:(id)sender;// action for moving to next word
- (IBAction)prevWord:(id)sender;// action for going to previous word
- (IBAction)checkSpelling:(id)sender;// action for check the user spelling
- (IBAction)tryAgainWords:(id)sender;// action for user to try all words again
- (IBAction)loadChart:(id)sender;// action forloading the help chart
- (IBAction)choseLevel1:(id)sender;// action for changing to level1
- (IBAction)choseLevel2:(id)sender;// action for changing to level2
- (IBAction)choseLevel3:(id)sender;// action for changing to level3




@end
