//
//  EasyReader.m
//  RN
//  Group 16: Four Square
//  Created by Yang Shi on 13-10-26.
//  Copyright (c) 2013 16. All rights reserved.
//

#import "EasyReader.h"
#include <string.h>
@interface EasyReader ()

@end
@implementation EasyReader
@synthesize myText,timingDate,seconds,path,sizeSlider,textInFile,allLinedStrings,mode,background,progressText,readButton,backButton;
int cont,estWordCount,num,totalTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// add the number of words every time the text changes
- (void) letsWordCont :(NSString* ) words{
    NSArray* countWord = [words componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]]; //seperate the string into substrings
    estWordCount = estWordCount + countWord.count;
}
// enable the night button funtion change back ground and text color
-(void) nightButton:(NSString*) buttonBack {
    UIImage* button;
    NSString* title;
    UIImage* backgroundImage;
    double boardSize;
    UIColor* textcolor;
    UIColor* titleTextcolor;
    if (buttonBack == nil) {
        button = nil;
        title=@"Normal";
        backgroundImage=[UIImage imageNamed:@"nightback.png"];
        boardSize=3.0;
        textcolor= [UIColor grayColor];
        titleTextcolor= [UIColor grayColor];
    }
    else{
        button=[UIImage imageNamed:buttonBack];
        title=@"Night Mode";
        backgroundImage=[UIImage imageNamed:@"read3.png"];
        boardSize=0.0;
        textcolor= [UIColor blackColor];
        titleTextcolor= [UIColor orangeColor];
    }
    
    background.image = backgroundImage;
    [progressText setTextColor:textcolor];
    
    [myText setTextColor:textcolor];
    [mode setTitle:title forState:UIControlStateNormal];
    [mode setTitleColor:titleTextcolor forState:UIControlStateNormal];
    [mode setBackgroundImage:button forState:UIControlStateNormal];
    mode .layer.borderColor =textcolor.CGColor;
    mode.layer.borderWidth = boardSize;
    
    [readButton setTitleColor:textcolor forState:UIControlStateNormal];
    [readButton setBackgroundImage:button forState:UIControlStateNormal];
    [readButton setTitleColor:titleTextcolor forState:UIControlStateNormal];
    readButton.layer.borderColor =textcolor.CGColor;
    readButton.layer.borderWidth = boardSize;
    
    [backButton setBackgroundImage:button forState:UIControlStateNormal];
    [backButton setTitleColor:titleTextcolor forState:UIControlStateNormal];
    backButton.layer.borderColor =textcolor.CGColor;
    backButton.layer.borderWidth = boardSize;
    
    [_smallSize setBackgroundImage:button forState:UIControlStateNormal];
    [_smallSize setTitleColor:titleTextcolor forState:UIControlStateNormal];
    _smallSize .layer.borderColor =textcolor.CGColor;
    _smallSize.layer.borderWidth = boardSize;
    
    [_mediumSize setBackgroundImage:button forState:UIControlStateNormal];
    [_mediumSize setTitleColor:titleTextcolor forState:UIControlStateNormal];
    _mediumSize .layer.borderColor =textcolor.CGColor;
    _mediumSize.layer.borderWidth = boardSize;
    
    [_largeSize setBackgroundImage:button forState:UIControlStateNormal];
    [_largeSize setTitleColor:titleTextcolor forState:UIControlStateNormal];
    _largeSize .layer.borderColor =textcolor.CGColor;
    _largeSize.layer.borderWidth = boardSize;
    
    
}

//change the theme between normal and night mode
- (IBAction)changeMode:(UIButton *)sender {
    
    if ([mode.titleLabel.text  isEqual: @"Night Mode"]) {// change to night mode
        
        [self nightButton:nil];
    }
    else if ([mode.titleLabel.text  isEqual: @"Normal"]){// change to normal mode
        
        [self nightButton:@"buttonsback.png"];
    }
}

//change the font size of text, make it small
- (IBAction)sizeSmall:(id)sender {
    myText.font = [myText.font fontWithSize:20];
}

//change the font size of text, make it mid
- (IBAction)sizeMid:(UIButton *)sender {
    myText.font = [myText.font fontWithSize:30];
}

//change the font size of text, make it large
- (IBAction)sizeLarge:(UIButton *)sender {
    myText.font = [myText.font fontWithSize:40];
}

//pronounce the selected words or sentence
- (IBAction)read:(UIButton *)sender {
    NSString *selectedText = [myText textInRange:myText.selectedTextRange];
    NSLog(@"%@",selectedText);
    self .sound= [[Google_TTS_BySham alloc]init];
    self.sound .volume= 8;
    [self.sound speak:selectedText];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textColor=[UIColor darkGrayColor];
    // load the wordcont and current time
    estWordCount = [[[NSUserDefaults standardUserDefaults]stringForKey:@"WordCount"] intValue];
    timingDate = [NSDate date];
    
    //set the value of slider from progress of the text
    [sizeSlider setValue:[[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat:@"%@",self.title]]];
    self.progressText.text = [NSString stringWithFormat:@"%d%%", (int)[sizeSlider value]];
    
    //load text
    num = 0;
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    myURL = [NSURL fileURLWithPath:path]; //get the URL of file
    if ([fileMgr fileExistsAtPath:path]) {
        textInFile = [NSString stringWithContentsOfURL:myURL encoding:NSUTF8StringEncoding error:nil];
        allLinedStrings = [textInFile componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]]; //seperate the string into substrings
        num = [allLinedStrings count]/100.00 *[sizeSlider value]-1; //use percentage to present the prgress of text and load where the last time the user has read so far from the slider value
        //set the percentage to zero if it is below zero
        if (num < 0){
            num = 0;
        }
        myText.text = [NSString stringWithFormat:@"%@",[allLinedStrings objectAtIndex:num]];
        [self letsWordCont:myText.text]; //estimate word count
    }
    
    // change the font of labels and texts
    mode.titleLabel.font = [UIFont fontWithName:@"OpenDyslexic" size:20];
    readButton.titleLabel.font = [UIFont fontWithName:@"OpenDyslexic" size:20];
    backButton.titleLabel.font = [UIFont fontWithName:@"OpenDyslexic" size:20];
    progressText.font = [UIFont fontWithName:@"OpenDyslexic" size:20];
    myText.font = [UIFont fontWithName:@"OpenDyslexic" size:30];
}

- (void)viewDidDisappear:(BOOL)animated{
    //set a formatter to format the float
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    
    //load total time and add the time used this time to it
    totalTime = [[[NSUserDefaults standardUserDefaults]stringForKey:@"Time"]intValue];
    timeSpent = [[NSDate date] timeIntervalSinceDate:timingDate];
    seconds = [fmt stringFromNumber:[NSNumber numberWithFloat:timeSpent]];
    totalTime = totalTime + [seconds intValue];
    NSString *wordCont = [NSString stringWithFormat:@"%d", estWordCount];
    
    //save the values into the userdefaults
    [[NSUserDefaults standardUserDefaults] setObject:wordCont forKey:@"WordCount"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", totalTime]forKey:@"Time"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Force the view to rotate if needed
- (BOOL)shouldAutorotate{
    return NO;
}

//The orientation should be landscape
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (IBAction)SliderValueChange:(UISlider *)sender {
    //change the text through the value of slider
    textInFile = [NSString stringWithContentsOfURL:myURL encoding:NSUTF8StringEncoding error:nil];
    allLinedStrings = [textInFile componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    num = [allLinedStrings count]/100.00 *[sizeSlider value]-1;
    if (num < 0){
        num = 0;
    }
    myText.text = [NSString stringWithFormat:@"%@",[allLinedStrings objectAtIndex:num]];
    self.progressText.text = [NSString stringWithFormat:@"%d%%", (int)[sizeSlider value]];
    // save the slider value
    [[NSUserDefaults standardUserDefaults] setFloat:[sizeSlider value] forKey:[NSString stringWithFormat:@"%@",self.title]];
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender{
    //swipe right to read previous page
    textInFile = [NSString stringWithContentsOfURL:myURL encoding:NSUTF8StringEncoding error:nil];
    allLinedStrings = [textInFile componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (num >= 1)
        { //if it doesn't reach the start page
            num = num - 1;
            myText.text = [NSString stringWithFormat:@"%@",[allLinedStrings objectAtIndex:num]];
            [self letsWordCont:myText.text]; //estimate word count
            sizeSlider.value = (num+1) * 100 / ([allLinedStrings count]); //change slider value
            self.progressText.text = [NSString stringWithFormat:@"%d%%", (int)[sizeSlider value]];
        }
        else{
            NSLog(@"Reach the start of the file");
        }
    }
}

- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender{
    //swipe right to read next page
    textInFile = [NSString stringWithContentsOfURL:myURL encoding:NSUTF8StringEncoding error:nil];
    allLinedStrings = [textInFile componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (num < allLinedStrings.count-1)
        { //if it doesn't reach the last page
            num = num + 1;
            myText.text = [NSString stringWithFormat:@"%@",[allLinedStrings objectAtIndex:num]];
            [self letsWordCont:myText.text]; //estimate word count
            sizeSlider.value = (num+1) * 100 / ([allLinedStrings count]);//change slider value
            self.progressText.text = [NSString stringWithFormat:@"%d%%", (int)[sizeSlider value]];
        }
        else
        {
            NSLog(@"Reach the end of the file");
        }
    }
}

@end
