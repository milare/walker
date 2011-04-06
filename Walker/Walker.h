//
//  HelloWorldLayer.h
//  Walker
//
//  Created by Bruno Macedo on 01/04/11.
//  Copyright home 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Map.h"
#import "Tile.h"

// HelloWorldLayer
@interface Walker : CCLayer
{
    Map* map;
    CCSprite* player;
    CCSprite* selSprite;
    CCLayer* drawer;
    Tile* lastTile;
    Tile* nextTile;
    BOOL drawerOpened;
    NSMutableArray* tileTypes;
}

@property (retain) Map* map;
@property (retain) CCSprite* player;
@property (retain) CCSprite* selSprite;
@property (retain) CCLayer* drawer;
@property (retain) Tile* lastTile;
@property (retain) Tile* nextTile;
@property (nonatomic) BOOL drawerOpened;
@property (retain) NSMutableArray* tileTypes;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
- (void)selectSpriteForTouch:(CGPoint)touchLocation;
-(void) changePlayerDirection:(id) sender data:(NSArray*) data;
@end
