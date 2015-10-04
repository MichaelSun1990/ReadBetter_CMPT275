//
//  Keys.m
//  RN
//
//  Created by Michael Sun on 11/2/2013.
//  Copyright (c) 2013 16. All rights reserved.
//

#import "Keys.h"

@implementation Keys

-(void) constructKeys{
    
    _keys=[[NSMutableArray alloc]init];
    [_keys addObject:@"s"];
    [_keys addObject:@"m"];
    [_keys addObject:@"i"];
    [_keys addObject:@"le"];
    [_keys addObject:@"b"];
    [_keys addObject:@"ke"];
    [_keys addObject:@"h"];
    [_keys addObject:@"a"];
    [_keys addObject:@"k"];
    [_keys addObject:@"ey"];
    [_keys addObject:@"l"];
    [_keys addObject:@"n"];
    [_keys addObject:@"d"];
    [_keys addObject:@"o"];
    [_keys addObject:@"g"];
    [_keys addObject:@"ee"];
    [_keys addObject:@"r"];
    [_keys addObject:@"t"];
    [_keys addObject:@"oo"];
    [_keys addObject:@"th"];
    [_keys addObject:@"gg"];
    [_keys addObject:@"z"];
    [_keys addObject:@"rr"];
    [_keys addObject:@"ow"];
    [_keys addObject:@"ll"];
    [_keys addObject:@"c"];
    [_keys addObject:@"ff"];
    [_keys addObject:@"ea"];
    [_keys addObject:@"ough"];
    [_keys addObject:@"igh"];
    [_keys addObject:@"sh"];
    [_keys addObject:@"er"];
    [_keys addObject:@"ve"];
    [_keys addObject:@"e"];
}
// two string is the same string or not
-(int)searchMatch:(NSString*)currPart{
    int i;
 
    for (i=0;i<[_keys count] ; i++) {
        NSString *currKey= [_keys objectAtIndex:i];
        if([currPart isEqualToString:currKey]){
            return i;
        }
    }
    return -1;
}

//two array object are match or not

-(int)searchMatchOfTwo:(NSMutableArray*) biggerArray :(NSMutableArray*) smallerArray{
    
    int lengthB= [biggerArray count];
    int lengthS= [smallerArray count];
    int j;
    for (int i=0;i<lengthS; i++) {
        NSString *currFirst= [smallerArray objectAtIndex:i];
        for (j=0; j<lengthB; j++) {
            
            NSString *currSecond=[biggerArray objectAtIndex:j];
            
            if([currFirst isEqualToString:currSecond]){
                return j;
            }
        }
    }
    return -1;
}
// rearrange the order of the keyboard will out put for a word object
// input- answet: contains correct answer
// output- randomkey: random confused keys

-(NSMutableArray*)randomKeyIndex: (NSMutableArray*)answer{
    NSMutableArray* randomKeys=[[NSMutableArray alloc]initWithCapacity:15];// total 15 keys
    
    NSMutableArray* allKeys=_keys;
    // remove all the correct keys from the copy of all keys array 
    for (int i=0; i< [answer count]; i++) {
        int index= [self searchMatchOfTwo:allKeys :answer];
        if(index!=-1){
            [allKeys removeObjectAtIndex:index];
        }
    }
    // build a array for all 15 index can be choosed
    NSMutableArray* usedIndex=[[NSMutableArray alloc]init];
    
    for (int a=0; a<15; a++) {
        [usedIndex addObject:[NSNumber numberWithInteger:a]];
        
    }
    // random a index  and add the key at this index to the result, remove this object from the all keys array incase of repeat keys
    for(int j=[answer count]; j<15 ; j++){
        int randIndex = arc4random() % ([allKeys count]);
        [randomKeys addObject:[allKeys objectAtIndex:randIndex]];
        [allKeys removeObjectAtIndex:randIndex];
    }
    // add the correct answer to the random confused keys(last n object is correct answer)
    [randomKeys addObjectsFromArray:answer];
    
    int replaceA = [randomKeys count]-1;// get the last object index of the result array
    
    for (int q=0; q<[answer count];q++){// loop until rarrange all the corret answers' location
        int randN = arc4random() % [usedIndex count];// random a index
        int randDes=[[usedIndex objectAtIndex:randN] integerValue];
    
        NSString* randCont= [randomKeys objectAtIndex:randDes];// save the random index location's key name 
        NSString* replaceM= [randomKeys objectAtIndex:replaceA];// save the last correct answer
        [randomKeys replaceObjectAtIndex:randDes withObject:replaceM];// replace this random location with last correct answer 
        [randomKeys replaceObjectAtIndex:replaceA withObject:randCont];// replace the last correct answer location with the random content
        replaceA--;// go to the second last correct answer
        [usedIndex removeObjectAtIndex:randN];// remove the used random index from index array incase of repeat location
        
    }
    
    return randomKeys;
}
//random keys method
//input-word: object
//output-keys: for keyborad of the word
-(NSMutableArray*) randomKeys:(Word*) currWord{
    NSMutableArray* keyBoardO = [[NSMutableArray alloc]init];
    NSMutableArray* currParts = [currWord parts];
    for (int i=0; i< [currParts count ]; i++) {
        int index= [self searchMatch:[currParts objectAtIndex:i]];
        if(index!=-1){
   
            NSString* match= [_keys objectAtIndex:index];// find the correct answers put them into final keyboard array
            
            [keyBoardO addObject:match];

        }
        
    }
    keyBoardO =[self randomKeyIndex:keyBoardO];// call the random function which add confused keys and rearrange the order of th keys
    return keyBoardO;
}




// show the keys for checking 
-(void) printKeyboard:(NSMutableArray*)result{
    for (int i=0; i<[result count]; i++) {
        NSLog(@"\nkeyname %@", [result objectAtIndex:i] );
    }
}
// show the keys for checking 
-(void) printKeys{
    // NSLog(@"\nsize %i",[_keys count]);
    for (int i=0; i<[_keys count]; i++) {
        
        NSLog(@"\nkeyname %@", [_keys objectAtIndex:i]);
    }
}


@end
