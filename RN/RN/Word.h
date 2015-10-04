//
//  Word.h
//  RN
//
//  Created by Michael Sun on 11/2/2013.
//  Copyright (c) 2013 16. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject
@property (nonatomic, strong)NSString* wordTitle;// what is the word
@property (nonatomic, strong)NSMutableArray* keyBoard;// the keyboard for this word
@property (nonatomic, strong)NSMutableArray* parts;// the parts which will made up this word
//sound

-(void)getWordTitle;
@end
