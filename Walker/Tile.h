//
//  Tile.h
//  Walker
//
//  Created by Bruno Macedo on 01/04/11.
//  Copyright 2011 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"
#import "cocos2d.h"

@interface Tile : Node {
    CCSprite* sprite;
    NSString* kind;
}

@property (retain) CCSprite* sprite;
@property (retain) NSString* kind;


- (id)initWithKind: (NSString*) tileKind at: (CGPoint) pos;
-(NSNumber*) weightTo: (Tile*) t2;

@end
