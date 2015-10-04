//
//  Word.m
//  RN
//
//  Created by Michael Sun on 11/2/2013.
//  Copyright (c) 2013 16. All rights reserved.
//

#import "Word.h"

@implementation Word

// combine word parts to show the original word
// input- none
// output- none
-(void)getWordTitle{
    
    _wordTitle= [_parts objectAtIndex:0];
    for (int i=1; i<[_parts count]; i++) {
        NSString* currPart= [_parts objectAtIndex:i];
        _wordTitle = [NSString stringWithFormat:@"%@%@",_wordTitle,currPart];// combin strings 
    }
}
@end