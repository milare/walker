//
//  HelloWorldLayer.m
//  Walker
//
//  Created by Bruno Macedo on 01/04/11.
//  Copyright home 2011. All rights reserved.
//


// Import the interfaces
#import "Walker.h"

// HelloWorldLayer implementation
@implementation Walker

@synthesize map;
@synthesize player;
@synthesize selSprite;
@synthesize tileTypes;
@synthesize drawer;
@synthesize drawerOpened;
@synthesize lastTile;
@synthesize nextTile;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Walker *layer = [Walker node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.map = [[Map alloc] initWithWidth:winSize.width andHeight: winSize.height];
        [map dump];
        int count = [[self.map tiles] count];
        int i = 0;
        for (i=0; i<count; i++) {
            [self addChild:[[[self.map tiles] objectAtIndex: i] sprite]];
            
            //CCLabelTTF* label = [CCLabelTTF labelWithString:[[[self.map tiles] objectAtIndex: i] value] fontName:@"Arial" fontSize:10];
            //label.position = ccp([[[[self.map tiles] objectAtIndex: i] sprite] position ].x, [[[[self.map tiles] objectAtIndex: i] sprite] position ].y + 8);
            // [self addChild: label];
            
            
        }
        self.player = [CCSprite spriteWithFile:@"PlayerDown.png" rect:CGRectMake(0, 0, 32, 48)];
        self.player.position = ccp(48,56);
        [self addChild:player];
        
        drawerOpened = FALSE;
        
        tileTypes = [[NSMutableArray alloc] init ];
        CCSprite* drawerBg = [CCSprite spriteWithFile:@"Drawer.png" rect:CGRectMake(0, 0, 200, 48)];
        drawerBg.position = ccp(-80,280);
        
        CCSprite *tileGrass = [CCSprite spriteWithFile:@"Grass.png" rect:CGRectMake(0, 0, 32, 32)];
        CCSprite *tileStone = [CCSprite spriteWithFile:@"Stone.png" rect:CGRectMake(0, 0, 32, 32)];
        CCSprite *tileBrick = [CCSprite spriteWithFile:@"Brick.png" rect:CGRectMake(0, 0, 32, 32)];
        tileGrass.position = ccp(-120, 280);
        tileStone.position = ccp(-80, 280);        
        tileBrick.position = ccp(-40, 280);
        
        drawer = [[CCLayer alloc] init ];
        drawer.position = ccp(0,0);
        
        [tileTypes addObject:tileGrass];
        [tileTypes addObject:tileStone];
        [tileTypes addObject:tileBrick];
        [drawer addChild:tileGrass z:2 tag: 2];
        [drawer addChild:tileStone z:2 tag: 3];
        [drawer addChild:tileBrick z:2 tag: 4];
        selSprite = nil;
        [drawer addChild:drawerBg z:1 tag:1];
        
        [self addChild:drawer];
        
        
        
        self.isTouchEnabled = YES;
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];

	}
	return self;
}

-(void) changePlayerDirection:(id) sender data:(NSArray*) data
{
    Tile* last = [data objectAtIndex:0];
    Tile* next = [data objectAtIndex:1];
    
    int lastX = last.sprite.position.x;
    int lastY = last.sprite.position.y;
    int nextX = next.sprite.position.x;
    int nextY = next.sprite.position.y;
    
    if((lastX < nextX)&&(lastY == nextY))
    {
        //right
        [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"PlayerRight.png"]];
        
    }else if((lastX > nextX)&&(lastY == nextY))
    {
        // left
        [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"PlayerLeft.png"]];
        
    }else if((lastX == nextX)&&(lastY < nextY))
    {
        // up
        [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"PlayerUp.png"]];
        
    }else if((lastX == nextX)&&(lastY > nextY))
    {
        // down
        [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"PlayerDown.png"]];
    }
    
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    int targetTileX = (location.x /32);
    int targetTileY = (location.y /32);
    int sourceTileX = (self.player.position.x - 16)/32;
    int sourceTileY = (self.player.position.y - 24 )/32;
    CCSprite* drawerBg = (CCSprite*)[drawer getChildByTag:1];
    CGRect drawerRect;
    
    NSLog(@"TOUCH FINISHED");
    
    
    if(selSprite != nil){
        int selTileX = (location.x /32);
        int selTileY = (location.y /32);
        
        int selIndex = [map indexOfNodeWithValue:[NSString stringWithFormat:@"n%d,%d", selTileY, selTileX]];
        Tile* sel = [[map tiles] objectAtIndex: selIndex]; 
             
        if ([selSprite tag] == 2) {
            //Grass
            [sel.sprite setTexture:[[CCTextureCache sharedTextureCache] addImage:@"Grass.png"]];
            [map updateNeighborsForTileWithIndex:selIndex withNewWeight:[NSNumber numberWithInt: 1]];
            //sel.kind = @"grass";
        }else if([selSprite tag] == 3) {
            //Stone
            [sel.sprite setTexture:[[CCTextureCache sharedTextureCache] addImage:@"Stone.png"]];
            [map updateNeighborsForTileWithIndex:selIndex withNewWeight:[NSNumber numberWithInt: 1000]];
            //sel.kind = @"stone";
        }else if([selSprite tag] == 4) {
            //Brick
            [sel.sprite setTexture:[[CCTextureCache sharedTextureCache] addImage:@"Brick.png"]];
            [map updateNeighborsForTileWithIndex:selIndex withNewWeight:[NSNumber numberWithInt: 99999]];
            //sel.kind = @"stone";
        }
        
        [map dump];
        [self removeChild:selSprite cleanup:TRUE];
        [selSprite release];
        selSprite = nil;
        
    }
    else{
        if (drawerOpened) {
            drawerRect = CGRectMake(0, drawerBg.position.y- drawerBg.contentSize.height/2, drawerBg.contentSize.width , drawerBg.contentSize.height);
        }else{
            drawerRect = CGRectMake(0, drawerBg.position.y - drawerBg.contentSize.height/2, 30, drawerBg.contentSize.height);
        }
            
        if(CGRectContainsPoint(drawerRect, location)){

            if(drawer.position.x == 0){ 
                drawerOpened = TRUE;
                [drawer runAction:[CCMoveTo actionWithDuration: 1 position: ccp(160,drawer.position.y)]];           
            }else{
                drawerOpened = FALSE;
                [drawer runAction:[CCMoveTo actionWithDuration: 1 position: ccp(0,drawer.position.y)]];
            }
            
        }else{
            
            if(!drawerOpened){
                int targetIndex = [map indexOfNodeWithValue:[NSString stringWithFormat:@"n%d,%d", targetTileY, targetTileX]];
                Tile* target = [[map tiles] objectAtIndex: targetIndex];

                int sourceIndex = [map indexOfNodeWithValue:[NSString stringWithFormat:@"n%d,%d", sourceTileY, sourceTileX]];
                Tile* source = [[map tiles] objectAtIndex: sourceIndex];  

                NSMutableArray* path = [map dijkstraFromNode:source toNode:target];

                int count, i;
                lastTile = source;
                [path addObject:target];

                count = [path count];
                NSMutableArray* actions = [[NSMutableArray alloc] init];
                
                for (i = 0; i < count; i++)
                {
                    NSLog(@"%@", [[path objectAtIndex:i] value]);
                    self.nextTile = [path objectAtIndex:i];
                    CGPoint nextPosition = ccp(self.nextTile.sprite.position.x,self.nextTile.sprite.position.y+16);
                    NSArray* ary = [[NSArray alloc] initWithObjects:self.lastTile, self.nextTile, nil];
                    [actions addObject:[CCCallFuncND actionWithTarget:self selector:@selector(changePlayerDirection:data:) data:ary]];
                    [actions addObject:[CCMoveTo actionWithDuration: 0.3 position: nextPosition]];
                    self.lastTile = self.nextTile;
                }

                CCSequence* sequence = [CCSequence actionsWithArray:actions];
                [player runAction:sequence];
                
                lastTile = nil;
                nextTile = nil;
                
                [actions release];
            }
        }
    }
    
    
}


- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in tileTypes) {
        
        CGRect spriteRect = CGRectMake(sprite.position.x+160 - sprite.contentSize.width/2,sprite.position.y - sprite.contentSize.height/2, sprite.contentSize.width, sprite.contentSize.height);
        if (CGRectContainsPoint(spriteRect, touchLocation)) {            
            newSprite = sprite;
            break;
        }
    }    

    if (newSprite != nil) {
        [selSprite stopAllActions];
        selSprite = [[CCSprite alloc] initWithTexture:[newSprite texture]];
        [self addChild: selSprite z:3 tag:[newSprite tag]];
    }
    
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {       
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    [selSprite runAction:[CCMoveTo actionWithDuration: 0 position: ccp(touchLocation.x, touchLocation.y)]];
    
    NSLog(@"MOVING");
   // [self panForTranslation:translation];    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];      
    NSLog(@"TOUCH BEGAN");
    return TRUE;    
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[map dealloc];
    [player dealloc];

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
