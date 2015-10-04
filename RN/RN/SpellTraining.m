//
//  SpellTraining.m
//  RN
//  Group 16: Four Square
//  Created by Yang Shi on 13-10-26.
//  Copyright (c) 2013 16. All rights reserved.



//  if other button is hidden than not allow other is pressed

#import "SpellTraining.h"
#import "Word.h"// word class contains properties of a word object
#import "Keys.h"// keyboard keys's properties
#import "Google_TTS_BySham.h"// sound of the word and keyboard
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@interface SpellTraining ()

@end

@implementation SpellTraining

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//clear all the object that create during the process
//intput-none
//output-none

-(void) clearInput{
    _keyCont=nil;
    _result=nil;
    _currButton=nil;
    _currKeys=nil;
    _wordName=nil;
    //_lastWord=nil;
    _preivous=0;
    _lastParts=nil;
    _dirctionary=nil;

}

/* read the words from a text file with a dynamic URL
 * intput-none
 * output-dict: it a dictionary for all contains all the words in parts
 */
-(NSMutableArray*) readInput{
    
    NSMutableArray* dict =  [[NSMutableArray alloc] init];
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"txt"];//create a path object for the file named words.txt
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];// get he contains of the file
    
    NSCharacterSet* cs = [NSCharacterSet newlineCharacterSet];// set cs as the new line character 
    NSScanner* scanner = [NSScanner scannerWithString:fileContents];// a scanner object for scan the whole file
    NSString* line;// for store object in each line
    while(![scanner isAtEnd]){// not the end of the file
        if([scanner scanUpToCharactersFromSet:cs intoString:&line]){// scan a line in the file
            NSString* currLine = [NSString stringWithString:line];// save the line
            NSArray* fileWordP = [currLine componentsSeparatedByString: @" "];// separate the line to to word parts store in a array
            [dict addObject:fileWordP];// add the word into dictionary
        }
    }
    //[self printDict:dict];
    return dict;
}

/* print out the dictionary's contains
 * intput-dict: the dictionary with words
 * output-none
 */

-(void) printDict: (NSMutableArray*) dict{
    for (int j=0; j<[dict count]; j++) {
        NSArray* oneWord= [dict objectAtIndex:j];
        NSLog(@"\n word%i: ",j);
        for (int i=0; i< [oneWord count];i++){
            NSLog(@"  part%i: %@",i, [oneWord objectAtIndex:i]);
        }
     
     }
    
}

/* random a word from dictionary
 * intput-none
 * output-result: the random word in parts
 */

-(NSArray*) randomWord {
    NSArray* result=[[NSArray alloc]init];
    if([_dirctionary count]!=0){
        int randIndex = arc4random() % ([_dirctionary count]);// rando number between dinctionary size
        result= [_dirctionary objectAtIndex:randIndex];
        [_dirctionary removeObjectAtIndex:randIndex];
    }
    return result;
    
}

/* create a label for show the check spelling result
 * intput-none
 * output-none
 */

-(void) checkLabel{
    float x =70;// x coordinate for label location
    float y = 84;// y coordinate for label location
    float wid=341;// width of the label
    float hei=72;// height of the label
    CGRect position= CGRectMake(x, y, wid, hei);// rectangle as a size of the label 
    _checkResult =[[UILabel alloc]initWithFrame:position];// set the label to the rectangle location
    _checkResult.textAlignment = NSTextAlignmentCenter;// text at center
    _checkResult.backgroundColor = [UIColor clearColor];//no background color
    _checkResult.layer.borderColor = [UIColor redColor].CGColor;// give a border to the label 
    _checkResult.layer.borderWidth = 4.0;
    _checkResult.textColor= [UIColor redColor];// set the text color red
    _checkResult.font= [UIFont fontWithName:@"OpenDyslexic" size:_textSize];// used our text font
    _checkResult.numberOfLines=0;// enable next line char
    _checkResult.lineBreakMode = NSLineBreakByWordWrapping;// enable next line char
    [self .view addSubview: _checkResult];// add the label to screen 
    _checkResult.hidden= YES;// hidden it 
    
}

/* a scrollview for the help chart
 * intput-none
 * output-none
 */

- (void)chartView{
    
    _scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,480,300)];// size and location
    _scrollview.showsVerticalScrollIndicator=YES;
    _scrollview.scrollEnabled=YES;// let user scroll up and down left and right
    _scrollview.userInteractionEnabled=YES;// enable user to touch it 
    [self.view addSubview:_scrollview];// add it onto screen
    _scrollview.contentSize = CGSizeMake(1200,1000);// real object size in the view
    
    UIImageView* iv =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chart.png"]];// a image view contains the chart 
    iv.frame=CGRectMake(0, 0, 1200,1000);// same size as the real object size of the scroll view
    [_scrollview addSubview:iv]; // add the picture to the scroll view
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];// give a button for going back to spelling page 
    [_backButton setTitle:@"Back to Spelling" forState: UIControlStateNormal];
    [_backButton addTarget:self  action:@selector(closeChart) forControlEvents:UIControlEventTouchDown];// connection to a action
    [_backButton setBackgroundColor :[UIColor colorWithRed:(255/255.0) green:(188/255.0) blue:(0/255.0) alpha:1]] ;
    [_backButton titleLabel].font= [UIFont fontWithName:@"OpenDyslexic" size:_textSize];
    _backButton.frame = CGRectMake(140,265,200,30);
    [self.view addSubview:_backButton];//add the button to scrollview
    
    _scrollview.hidden=YES;// hide the view
    _backButton.hidden=YES;// hide the button

}
- (void)viewDidLoad
{
    
    [self clearInput];
    
    _tryAgain.hidden=YES;
    _backToMain.hidden=YES;
    _partHei=50;
    _partWid=70;
    _textSize=20;
    
    [self checkLabel];
    [_backbutton titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:_textSize];
    [_chartButton titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:_textSize];
    [_levelOne titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:_textSize];
    [_levelTwo titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:_textSize];
    [_levelThree titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:_textSize];
    [_tryAgain titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:18];
    [_backToMain titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:18];
    [_pronounce titleLabel].font= [UIFont fontWithName:@"OpenDyslexic" size:_textSize];
    [_check titleLabel].font =[UIFont fontWithName:@"OpenDyslexic" size:_textSize];

    
   
    _lastParts = [[NSMutableArray alloc]init];
    _removelastParts= [[NSMutableArray alloc]init];
    _dirctionary = [self readInput];
    
    NSMutableArray* word = [[NSMutableArray alloc]initWithArray:[self randomWord]];
    _currWord=word;
    [_lastParts addObject:word];
    Word *forSound=[[Word alloc]init];
    [forSound setParts:word];
    [forSound getWordTitle];
    _wordName= [forSound wordTitle];
    
    _result=[self partOfWord:word];// set result which give the locationd of the word parts on the screen
    _currKeys=[self thisKeyBoard:word];
    
    [self displayLabel:_currKeys];
    
    [super viewDidLoad];
    [self chartView];
    
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

//The orientation should be landscape
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;

}

//check the key contains is drag to one of destination labels(word parts)
//intput- parts: how many parts current word has(how many destination labels the
//               word has, and their locations)
//output-none

-(void) dragSelection :(NSMutableArray*)parts {
    float selX = _keyCont.frame.origin.x;
    float selY = _keyCont.frame.origin.y;
    float selW = _keyCont.frame.size.width;
    float selH = _keyCont.frame.size.height;
    CGRect sel= CGRectMake(selX, selY, selW, selH);//key contains frame
    UILabel *currL;
        
    for (int i=0; i<[parts count]; i++){
        currL= [parts objectAtIndex:i];
        float destX = currL.frame.origin.x;
        float destY = currL.frame.origin.y;
        float destW = currL.frame.size.width;
        float destH = currL.frame.size.height;
        CGRect destPosition= CGRectMake(destX, destY, destW, destH);// destion nation location frame
        
        //check the drag part in the destination box or not
        // if the key contains label ccover the destination label frame
        //      then concern that key contains label is at the destination
        //      loaction
        BOOL atDest = CGRectContainsRect(sel,destPosition );
        
        if (atDest) {
            currL.text = [[_currButton titleLabel] text];
            currL.font = [UIFont fontWithName:@"OpenDyslexic" size:_textSize+5];
            currL.textColor =[UIColor colorWithRed:(156/255.0) green:(93/255.0) blue:(239/255.0) alpha:1];
            _keyCont.hidden = YES;//hide the key contains label
            _currButton.hidden = NO;// update the destination label
            _keyCont =nil;
        }
        
    }
    
}

//get the loaction for where to start put word parts
//input- word: parts of he word for identifing how many parts the word has
//output- start: the location for first word part label

-(float) startOfWord:(NSMutableArray*)word{
    CGFloat screenWid= [UIScreen mainScreen].bounds.size.height;// total screen width
    int parts= [word count];
    //?50 should be a property (label width and height)
    //?10 should be a propeery (the gap between each word parts)
    float start= (screenWid-(_partWid*parts+10*(parts-1)))/2;
    if (start>=0) {
        return start;
    }
    else
        return 0;
    // the label length is longer than the screen frame start at the left
    // most position of the screen
    
}

//display word parts label on sceen frame
//intput- word: how may parts the word has
//output- wParts: will be use for dragSelection for detecting how may and where
//                  are the word parts

-(NSMutableArray *) partOfWord:(NSMutableArray*) word {
    NSMutableArray *wParts = [NSMutableArray arrayWithCapacity:[word count]];
    float x = [self startOfWord:word];//start location of the first part
    float y = 102.0;// y location of all labels
    UILabel *currL;
    //NSString *currP;
    for (int i=0; i<[word count]; i++){
        //currP= [word objectAtIndex:i];
        CGRect position= CGRectMake(x, y, _partWid, _partHei);
        currL=[[UILabel alloc]initWithFrame:position];
        currL.textAlignment = NSTextAlignmentCenter;
        currL.backgroundColor = [UIColor clearColor];
        //currL.text= currP;
        currL.layer.borderColor = [UIColor colorWithRed:(60/255.0) green:(168/255.0) blue:(222/255.0) alpha:1].CGColor;
        currL.layer.borderWidth = 3.0;
        [self .view addSubview: currL];//add to the screen frame
        [wParts addObject: currL];
        x+= _partWid+10;// move the x by one label width plus gap every time
        
    }
    
    
    return wParts;
}
-(void) hideLast : (NSMutableArray*)lastWordPart{
    for (int i=0; i<[lastWordPart count]; i++) {
        UILabel* onelabel= [lastWordPart objectAtIndex:i];
        onelabel.hidden= YES;
    }
}
-(void) showLast : (NSMutableArray*)lastWordPart{
    for (int i=0; i<[lastWordPart count]; i++) {
        UILabel* onelabel= [lastWordPart objectAtIndex:i];
        onelabel.hidden= NO;
    }
}

// let the key contains dragable and location detectable
// input-touches:
// input-event: the event that will need to be touch and drag

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *keyContT = [[event allTouches] anyObject];
    _keyCont.center = [keyContT locationInView:self.view];
    [self dragSelection : _result];// detect where the key contains is
    
}

// get the key which is pressed and create a label for drag of the key contains
// input- currB: the button current pressed
// output- none

-(void) getKeyCont: (UIButton*) currB{
    currB.hidden = YES;// hidd the button allow the user to drag the label more easily
    
    NSString *title= [[currB titleLabel] text];
    float x = currB.frame.origin.x-25;// make the label toward to the center(25 is half of the button size)
    float y = currB.frame.origin.y-25;// make the label toward to the center(25 is half of the button size)
    float wid=_partWid+10;//fix the label size of the key contains ue to sam button size
    float hei=_partWid+10;
    CGRect position= CGRectMake(x, y, wid, hei);
    _keyCont= [[UILabel alloc]initWithFrame:position];
    _keyCont.adjustsFontSizeToFitWidth= YES;
    _keyCont.text= title;
    _keyCont.backgroundColor = [UIColor clearColor];// invisiable background color
    _keyCont.textAlignment = NSTextAlignmentCenter;
    _keyCont.textColor =[ UIColor redColor];// label text color
    //[_keyCont setFont:[UIFont fontWithName:@"Arial-BoldMT" size:textSize]];// font type and size of the text
     _keyCont.font = [UIFont fontWithName:@"OpenDyslexic" size:_textSize+10];
    [self .view addSubview: _keyCont];// show it on the screen
    
    
    
}

//get which key in the keyboard array is pressed
//input- keyboard: a array of keys which passed by key object for a specific word
//input- currTitle: the current pressed key's title label
//output- i; index of the pressed key in the array

-(int) searchKeyIndex:(NSMutableArray*) keyBoard :(NSString*) currTitle{
    for (int i=0; i< [keyBoard count]; i++) {
        NSString* currPart = [keyBoard objectAtIndex:i];
        if([currPart isEqualToString:currTitle]){
            //NSLog(@"\nindex is %i", i);
            return i;
            
        }
        
    }
    return -1;
}

//retrun the property variable of the pressed key as a UIButton object
//input- keyBoard: a array of keys which passed by key object for a specific word
//input- currTitle: the current pressed key's title label
//output- UIButton object which has been pressed

-(UIButton*) keyPress:(NSMutableArray*) keyBoard :(NSString*) currTitle{
    
    NSMutableArray* keys=[self keyArray];
    int aIndex= [self searchKeyIndex:keyBoard :currTitle];
    return [keys objectAtIndex: aIndex];
}

//get the key board contains for current word
//inptut -wordInParts: the parts of a word
//output -NSMutiplearray contains keys for the word

-(NSMutableArray*) thisKeyBoard:(NSMutableArray*)wordInParts{
    Word *aWord=[[Word alloc]init];
    [aWord setParts:wordInParts];
    Keys* aKey= [[Keys alloc]init];
    [aKey constructKeys];// choose random key combine with correct keys construct keyboard
    return[aKey randomKeys:aWord];
}

//get the sound of the keyboard keys
- (void) keySound :(int) keyNames{
    NSString* keyNameStr= [NSString stringWithFormat:@"%@/%i.mp3",[[NSBundle mainBundle]resourcePath],keyNames];// found the sound file
    NSURL * url =  [NSURL fileURLWithPath:keyNameStr];// build the url for the file
    NSError * error;
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL: url error:&error];// load the file to the player
    _audioPlayer.numberOfLoops = 0;
    _audioPlayer.volume=20; 
    [_audioPlayer play];// plasy the file
}
// defind which key name will sound which sound file
-(void) keyPressSound{
    
    int soundIndex = 0;
    NSString *keyspell= [[_currButton titleLabel] text];
    
    if([keyspell isEqualToString:@"s"]){
        soundIndex = 14;
    }
    if([keyspell isEqualToString:@"m"]){
        soundIndex = 7;
    }
    if([keyspell isEqualToString:@"ll"] || [keyspell isEqualToString:@"l"]||[keyspell isEqualToString:@"le"]){
        soundIndex = 22;
    }
    if([keyspell isEqualToString:@"b"]){
        soundIndex = 2;
    }
    if([keyspell isEqualToString:@"c"]||[keyspell isEqualToString: @"k"]|| [keyspell isEqualToString:@"ke"])
    {
        soundIndex = 5;
    }
    if([keyspell isEqualToString:@"h"]){
        soundIndex = 18;
    }
    if([keyspell isEqualToString:@"e"]){
        soundIndex = 27;
    }
    if([keyspell isEqualToString:@"ee"]){
        soundIndex = 26;
    }
    if([keyspell isEqualToString:@"ey"]){
        soundIndex = 25;
    }
    if([keyspell isEqualToString:@"n"]){
        soundIndex = 8;
    }
    if([keyspell isEqualToString:@"d"]){
        soundIndex = 4;
    }
    if([keyspell isEqualToString:@"gg"]||[keyspell isEqualToString:@"g"]){
        soundIndex = 6;
    }
    if([keyspell isEqualToString:@"t"]){
        soundIndex = 3;
    }
    if([keyspell isEqualToString:@"oo"]){
        soundIndex = 34;
    }
    if([keyspell isEqualToString:@"th"]){
        soundIndex = 12;
    }
    if([keyspell isEqualToString:@"z"]){
        soundIndex = 15;
    }
    if([keyspell isEqualToString:@"rr"]){
        soundIndex = 21;
    }
    if([keyspell isEqualToString:@"ow"]){
        soundIndex = 40;
    }
    if([keyspell isEqualToString:@"ff"]){
        soundIndex = 10;
    }
    if([keyspell isEqualToString:@"ea"]){
        soundIndex = 37;
    }
    if([keyspell isEqualToString:@"ough"]){
        soundIndex = 34;
    }
    if([keyspell isEqualToString:@"p"]){
        soundIndex = 1;
    }
    if([keyspell isEqualToString:@"er"]){
        soundIndex = 36;
    }
    if([keyspell isEqualToString:@"ve"]){
        soundIndex = 11;
    }
    if([keyspell isEqualToString:@"igh"]){
        soundIndex = 38;
    }
    if([keyspell isEqualToString:@"sh"]){
        soundIndex = 16;
    }
    if([keyspell isEqualToString:@"a"]){
        soundIndex = 29;
    }
    if([keyspell isEqualToString:@"a"]&& [_wordName isEqualToString:@"above"]){
        soundIndex = 36;
    }
    if([keyspell isEqualToString:@"a"]&& [_wordName isEqualToString:@"small"]){
        soundIndex = 31;
    }
    if([keyspell isEqualToString:@"a"]&& ([_wordName isEqualToString:@"arrow"]||[_wordName isEqualToString:@"cashier"])){
        soundIndex = 28;
    }
    if([keyspell isEqualToString:@"i"]){
        soundIndex = 38;
    }
    if([keyspell isEqualToString:@"i"]&& [_wordName isEqualToString:@"cashier"]){
        soundIndex = 26;
    }
    
    if([keyspell isEqualToString:@"r"]){
        soundIndex = 21;
    }
    if([keyspell isEqualToString:@"r"]&& [_wordName isEqualToString:@"deer"]){
        soundIndex = 36;
    }
    if([keyspell isEqualToString:@"o"]){
        soundIndex = 31;
    }
    if([keyspell isEqualToString:@"o"]&& [_wordName isEqualToString:@"above"]){
        soundIndex = 30;
    }
    if([keyspell isEqualToString:@"o"]&& [_wordName isEqualToString:@"lemon"]){
        soundIndex = 36;
    }
    
    
    [self keySound:soundIndex];
    

}
-(void) showHideButton{
    _keyCont.hidden = YES;
    UIButton *pressedB= [self keyPress:_currKeys :_keyCont.text];
    pressedB.hidden= NO;
}

// keys action 
- (IBAction)select1:(id)sender {
    
    if(_tryAgain.hidden &&_checkResult.hidden ){
    if (_keyCont == nil) {
        
        _currButton= [self keyPress:_currKeys :[sender currentTitle]];// get the current pressed key's title and find which IBOutlet it corresponding to
        [self getKeyCont:_currButton];// show the key contains on the screen
    }
    else{
        
        [self showHideButton];//  show other buttons is not presse this time let user pres it again
        _currButton= [self keyPress:_currKeys :[sender currentTitle]];// get the current pressed key's title and find which IBOutlet it corresponding to

        [self getKeyCont:_currButton];// show the key contains on the screen
    }
    [self keyPressSound];
    
    _keyCont.hidden = NO;
    }
}

//sound out the word by google library

- (IBAction)showParts:(id)sender {
    if (_tryAgain.hidden&&_checkResult.hidden) {
        
    
    NSString* name= _wordName;
    self .sound= [[Google_TTS_BySham alloc]init];
    self.sound .volume= 8;
    [self.sound speak:name];
    }
}

//action of the next button
//change the label of the sound word button, and the key board label
//

- (IBAction)nextWord:(id)sender {
    if(_tryAgain.hidden&&_checkResult.hidden){
    [self goToNextWord];
    }
}

-(void) goToNextWord {
    
    [self showAllKeys];
    _preivous=0;
    if (_keyCont!=nil) {
        [self showHideButton];
    }
    _keyCont=nil;
    _checkResult.hidden=YES;
    [self hideLast:_result];
    
    NSMutableArray* word = [[NSMutableArray alloc]initWithArray:[self randomWord]];
    _currWord =word;
    [_lastParts addObject:word];
    
    if ([word count]!=0) {
        Word *forSound=[[Word alloc]init];
        [forSound setParts:word];
        [forSound getWordTitle];
        _wordName= [forSound wordTitle];
        
        _result=[self partOfWord:word];// set result which give the locationd of the word parts on the screen
        _currKeys=[self thisKeyBoard:word];
        
        [self displayLabel:_currKeys];
    }
    // user all words are done
    else{
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:@"Empty Dirctionary"
                            message:@"You complete all the words"
                            delegate:nil
                            cancelButtonTitle: @"ok"
                            otherButtonTitles: nil];
        [alert show];
        _tryAgain.hidden=NO;
        _backToMain.hidden=NO;
        
    }

}

// change to preword

- (IBAction)prevWord:(id)sender {
    if (_tryAgain.hidden&&_checkResult.hidden) {//disable all the button action by skip action when the system at check spelling stage

    [self showAllKeys];// incase user not finish last spelling
    if (_keyCont!=nil) {
        [self showHideButton];// incase user not finish last spelling
    }
    _keyCont=nil;//incase the keycontain still contains last word's part which may not in this key board
    [self hideLast:_result];//incase user not finish last spelling hide the parts in the wordparts boxes
    NSMutableArray* word;
        
    int sizeOfLast= [_lastParts count];// how man words in the arry contains all the word user has spelled
    if(sizeOfLast-(2+_preivous) >=0 ){
        // the last object in the lastpart is the current word, and sencod last will be the last word
        // when user pressed preivous button, the perivous count will be 0, user will get the second last object
        // in the lastpartsarray which is the last word user has spelled
        // next time preivous will be 2, user will get third last word
        word = [[NSMutableArray alloc]initWithArray:[_lastParts  objectAtIndex: sizeOfLast-(2+_preivous)]];
        _currWord=word;
       
    }
    // tell user all previou are done
    else{
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:@"NO Previous"
                            message:@"There is the first word"
                            delegate:nil
                            cancelButtonTitle: @"ok"
                            otherButtonTitles: nil];
        [alert show];
        word = [[NSMutableArray alloc]initWithArray:_currWord];// keep loading the last preivous word
        _currWord=word;
    }
        
    Word *forSound=[[Word alloc]init];
    [forSound setParts:word];
    [forSound getWordTitle];
    _wordName= [forSound wordTitle];
    
    _result=[self partOfWord:word];// set result which give the locationd of the word parts on the screen
    _currKeys=[self thisKeyBoard:word];
    _preivous++;
    [self displayLabel:_currKeys];
    }
}

// count how many parts that user got right
-(int) partsCorrect:(NSMutableArray*) answer :(NSArray*) corAnswer{
    int corCount=0;
    for (int i=0; i< [answer count]; i++) {
        if ([[answer objectAtIndex:i] isEqual:[corAnswer objectAtIndex:i]]) {
            corCount++;
        }
    }
    return corCount;
}

// show the wordpart boxes back let user continuing try the word 
-(void) keepTrying{
    for (int i=0; i< [_result count]; i++) {
        UILabel* thisPart= [_result objectAtIndex:i];
        thisPart.hidden = NO;
    }
    _checkResult.hidden= YES;
}

// check if user fill up all wordpart boxes
-(BOOL) fullAnswer{
    for (int i=0; i< [_result count]; i++) {
        UILabel* containL= [_result objectAtIndex:i];
        NSString* contains= containL.text;
        if(contains==nil){
            
            return NO;
        }
    }
    return YES;
}

//checking the user's spelling of the current word
//input-none
//output-none

- (IBAction)checkSpelling:(id)sender {
    if (_tryAgain.hidden&&_checkResult.hidden) {//disable all the button action by skip action when the system at check spelling stage

    if([self fullAnswer] ){// user filled up all the word parts boxes
        // create a array contains user's answer
        NSMutableArray* answer= [[NSMutableArray alloc]init];
        for (int j=0; j<[_result count]; j++) {
            UILabel* thisL= [_result objectAtIndex:j];
            [answer addObject:thisL.text];
        }
        // compare user's answer with the correct answer
        if ([_currWord isEqualToArray:answer]) {
            
            [self hideLast:_result];//  hide all the word parts boxes
            _checkResult.text= @"Congratulation\n You got the correct spelling";// set the congratulation message
            _checkResult.hidden= NO;
            // sound the word again for user to remember this word
            NSString* name= _wordName;
            self .sound= [[Google_TTS_BySham alloc]init];
            self.sound .volume= 8;
            [self.sound speak:name];
            //  change to next word after 3 seconds
            [self performSelector:@selector(goToNextWord) withObject:(self) afterDelay:(3)];//change to next word after five seond
        }
        else{
            int correct= [self partsCorrect:answer : _currWord ];// check how many parts user ge right
             [self hideLast:_result];
            _checkResult.text=[NSString stringWithFormat:@"You got %i parts correct\n Keep Trying",correct];//  set keep trying messege
            _checkResult.hidden= NO;
            // changet to next word after three second
            [self performSelector:@selector(keepTrying) withObject:(self) afterDelay:(3)];//back to current word after five seond
        }
    }
    // let user know that they should fill up all wordpart boxes
    else{
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:@"Not enought parts"
                            message:@"You sould try to fill up all the empty parts"
                            delegate:nil
                            cancelButtonTitle: @"ok"
                            otherButtonTitles: nil];
        [alert show];
        
    }
    }
}

- (IBAction)tryAgainWords:(id)sender {
    [self viewDidLoad];
}
//create a IBoutlet array of UIButtons of the key board
//input- none
//output- keyA: the array contains all the keyboard key on the screen

-(NSMutableArray*)keyArray{
    NSMutableArray* keyA = [[NSMutableArray alloc]init];
    [keyA addObject:_keyB1];
    [keyA addObject:_keyB2];
    [keyA addObject:_keyB3];
    [keyA addObject:_keyB4];
    [keyA addObject:_keyB5];
    [keyA addObject:_keyB6];
    [keyA addObject:_keyB7];
    [keyA addObject:_keyB8];
    [keyA addObject:_keyB9];
    [keyA addObject:_keyB10];
    [keyA addObject:_keyB11];
    [keyA addObject:_keyB12];
    [keyA addObject:_keyB13];
    [keyA addObject:_keyB14];
    [keyA addObject:_keyB15];
    return keyA;
}

// display the correct on the keys on the screen for current word
// input- keyBoard: the key board for this word
// output- none

-(void) displayLabel :(NSMutableArray*) keyBoard{
    NSMutableArray* keys=[self keyArray];
    for (int i=0; i< [keyBoard count]; i++) {
        UIButton* curr=[keys objectAtIndex:i];
        NSString* title= [keyBoard objectAtIndex:i];
        [curr setTitle: title forState:UIControlStateNormal];
        [curr titleLabel].font = [UIFont fontWithName:@"OpenDyslexic" size:_textSize];
    }
    
}
// hiddern the help chart whe user presse back to spelling button on the scrollview
- (void) closeChart{
    _scrollview.hidden=YES;
    _backButton.hidden=YES;
    [self showLast:_result];
    _keyCont.hidden=NO;
}
// open the help chart
- (IBAction)loadChart:(id)sender {
    if(_tryAgain.hidden && _checkResult.hidden){// disable all the button action by skip action when the system at check spelling stage
    [[_backButton titleLabel] setTextColor:[UIColor redColor]] ;
    [self hideLast:_result];
    _keyCont.hidden=YES;
    _scrollview.hidden=NO;
    _backButton.hidden=NO;
    }
}

// delete correct keys therefore when disable keys fro different level will not disable the correct keys
-(NSMutableArray*) deleteCorrKey{
    NSMutableArray* keys=[self keyArray];// copy of current keyboard
    for(int i=0; i< [_currWord count];i++){
        NSString* currKeyName= [_currWord objectAtIndex:i];// get the first correct answer
        for(int j=0; j<[keys count];j++){// search for the correct answer, and remove it 
            NSString* currKey= [[keys objectAtIndex:j] titleLabel].text;
            if([currKey isEqualToString:currKeyName]){
                [keys removeObjectAtIndex:j];
            }
        }
    }
    return keys;
}
-(void) hiddeWrong: (int) size : (NSMutableArray*) keys{
    NSMutableArray* usedIndex=[[NSMutableArray alloc]init]; 
    
    for (int a=0; a<[keys count]; a++) {
        [usedIndex addObject:[NSNumber numberWithInteger:a]];
        
    }
    for(int i=0;i<size;i++){
        int randN = arc4random() % [usedIndex count];//  random a index from index array
        int randDes=[[usedIndex objectAtIndex:randN] integerValue];
        UIButton* hideButton=[keys objectAtIndex:randDes];
        hideButton.enabled=NO;// disabel the key at random index
        [usedIndex removeObjectAtIndex:randN];// remove the used index
    }

}

-(void) getlevels: (int) level{
    NSMutableArray* keys= [self deleteCorrKey];
    if(level==1){
        int size1=10;// disable key size level 1
        [self hiddeWrong:size1 :keys ];
    }
    else if(level==2){
        int size2=5;// disable key size fr level 2
        [self hiddeWrong:size2 :keys ];

    }
    

}
- (IBAction)choseLevel1:(id)sender {// 5 keys are enabled 
    if (_tryAgain.hidden&&_checkResult.hidden) {//disable all the button action by skip action when the system at check spelling stage
        [self showAllKeys];// enable all keys incase disable too much key becasue there are some keys are disable in last level
        [self getlevels:1];
    }
    
}

- (IBAction)choseLevel2:(id)sender {// 10 keys are enabled
    if (_tryAgain.hidden&&_checkResult.hidden) {//disable all the button action by skip action when the system at check spelling stage
        [self showAllKeys];// enable all keys incase disable too much key becasue there are some keys are disable in last level
        [self getlevels:2];
    }
}
-(void)showAllKeys{
    NSMutableArray* keys=[self keyArray];
    for (int i=0; i< [keys count]; i++) {//disable all the button action by skip action when the system at check spelling stage
        UIButton* curr=[keys objectAtIndex:i];
        curr.enabled=YES;
    }

}
- (IBAction)choseLevel3:(id)sender {// level all keys are enabled
    if (_tryAgain.hidden&&_checkResult.hidden) {//disable all the button action by skip action when the system at check spelling stage
        [self showAllKeys];
    }
}


@end

