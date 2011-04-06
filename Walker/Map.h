//
//  Map.h
//  Walker
//
//  Created by Bruno Macedo on 01/04/11.
//  Copyright 2011 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"

@interface Map : NSObject {
    NSMutableArray* tiles;
    int realWidth;
    int realHeight;
}

@property (retain) NSMutableArray* tiles;
@property (nonatomic) int realWidth;
@property (nonatomic) int realHeight;

-(id) initWithWidth:(int)winSize andHeight:(int)height;
-(void) dump;
-(Tile*) tileAt:(CGPoint) point withWidth:(int) width;
-(NSInteger) indexOfNodeWithValue: (NSString*) value;
-(void) updateNeighborsForTileWithIndex: (int) index withNewWeight: (NSNumber*) newWeight;
-(NSMutableArray*) dijkstraFromNode:(Node*) source toNode:(Node*) target;
+(Node*) nodeWithSmallestDistance:(NSDictionary*) dist inQueue: (NSArray*) q;
+(void) printPath:(NSArray*) path;


@end
