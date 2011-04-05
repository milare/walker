//
//  Tile.m
//  Walker
//
//  Created by Bruno Macedo on 01/04/11.
//  Copyright 2011 home. All rights reserved.
//

#import "Tile.h"


@implementation Tile

@synthesize sprite;
@synthesize kind;


- (id)initWithKind: (NSString*) tileKind at: (CGPoint) pos

{
    int xValue = (pos.x / 32);
    int yValue = (pos.y / 32);
    
    
    self = [super initWithValue:[NSString stringWithFormat:@"n%d,%d", yValue, xValue]];
    if (self) 
    {
        if (tileKind == @"grass") {
            self.sprite = [CCSprite spriteWithFile:@"Grass.png" rect:CGRectMake(0, 0, 32, 32)];
        }else if(tileKind == @"stone") {
            self.sprite = [CCSprite spriteWithFile:@"Stone.png" rect:CGRectMake(0, 0, 32, 32)];
        }else if(tileKind == @"brick") {
            self.sprite = [CCSprite spriteWithFile:@"Brick.png" rect:CGRectMake(0, 0, 32, 32)];
        }
        self.sprite.position = pos;
        self.kind = tileKind;
        
        
    }
    return self;
}
     
-(NSNumber*) weightTo: (Tile*) t2
{
    NSNumber* weight = [NSNumber numberWithInt:1];
    
    if (([[self kind] isEqual: @"stone"])||([[t2 kind] isEqual: @"stone"])) {
        weight = [NSNumber numberWithInt: 1000];                
    }else if(([[self kind] isEqual: @"grass"])||([[t2 kind] isEqual: @"grass"])) {
        weight = [NSNumber numberWithInt:1];
    }else if(([[self kind] isEqual: @"brick"])||([[t2 kind] isEqual: @"brick"])) {
        weight = [NSNumber numberWithInt:99999];
    }
    
    return weight;
    
}
            
            
- (void) dealloc
{
    [sprite release];
    [kind release];
    [super dealloc];
}

@end
