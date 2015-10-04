//
//  Keys.h
//  RN
//
//  Created by Michael Sun on 11/2/2013.
//  Copyright (c) 2013 16. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"
@interface Keys : NSObject
@property (nonatomic,strong) NSMutableArray* keys;

-(void) constructKeys;// build a key name array 
-(NSMutableArray*) randomKeys :(Word*) currWord;// give the random keys for the word
-(int) searchMatch:(NSString*)currPart;

-(void) printKeyboard:(NSMutableArray*)result;
-(void) printKeys;
-(NSMutableArray*)randomKeyIndex: (NSMutableArray*)answer;
@end
