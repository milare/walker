//
//  Map.m
//  Walker
//
//  Created by Bruno Macedo on 01/04/11.
//  Copyright 2011 home. All rights reserved.
//

#import "Map.h"

@implementation Map

@synthesize tiles;
@synthesize realWidth;
@synthesize realHeight;

-(id) initWithWidth:(int)width andHeight:(int)height;
{
	if ( (self = [super init]) )
    {
		self.tiles = [NSMutableArray array];
		
		// Graph acting as a matrix for easy input
		Node* currentNode = nil;
		int i, j;
        int tileWidth = width/ 32;
        int tileHeight = height / 32;
        self.realHeight = height;
        self.realWidth = width;
        
		
		for (i = 0; i < tileHeight; i++)
		{
			for (j = 0; j < tileWidth; j++)
			{
                if((i==0)||(j==0)||(i==tileHeight-1)||(j==tileWidth-1)){
                    currentNode = [[Tile alloc] initWithKind:@"brick" at:ccp(j*32+16, i*32+16)];
                }else if((i%3 == 0) && (j %4 ==0)){
                    currentNode = [[Tile alloc] initWithKind:@"stone" at:ccp(j*32+16, i*32+16)];
                }else{
                    currentNode = [[Tile alloc] initWithKind:@"grass" at:ccp(j*32+16, i*32+16)];
                }
				[tiles addObject:currentNode];
			}
		}
		
        for (i = 0; i < tileHeight; i++)
		{
			for (j = 1; j < tileWidth; j++)
			{
                Tile* t1 = [self tileAt:ccp(i,j) withWidth:tileWidth];
                Tile* t2 = [self tileAt:ccp(i,j-1) withWidth:tileWidth];
                    
                [t1 addNeighbor:t2 withWeight: [t1 weightTo:t2]];
                
                if (i != 0) {
                    Tile* t3 = [self tileAt:ccp(i-1,j) withWidth:tileWidth];
                    [t1 addNeighbor:t3 withWeight: [t1 weightTo:t3]];
                }
            }
        }
		
    }
    return self;
}

-(void) updateNeighborsForTileWithIndex: (int) index withNewWeight: (NSNumber*) newWeight
{
    NSArray* neighbors = [[tiles objectAtIndex:index] neighbors];
    int i, count, j, countNeighbors;
    Edge* cEdge;
    
    count = [neighbors count];
    
    for (i=0; i<count; i++) {
        cEdge = [neighbors objectAtIndex:i];
        Tile* neighbor = [tiles objectAtIndex:[self indexOfNodeWithValue:[[cEdge node] value]]];
        cEdge.weight = newWeight;
        NSArray* neighborsOfNeighbor = [neighbor neighbors];
        countNeighbors = [neighborsOfNeighbor count];
        for (j=0; j<countNeighbors; j++) {
            if ([[[[neighborsOfNeighbor objectAtIndex:j] node] value] isEqual: [[tiles objectAtIndex:index] value]]) {
                break;
            }
        }
        Edge* selfEdge = [neighborsOfNeighbor objectAtIndex:j];
        cEdge.weight = newWeight;
        selfEdge.weight = newWeight;
        
    }

}


-(Tile*) tileAt:(CGPoint) point withWidth:(int) width
{
    int index = (point.x*width) + point.y;
    Tile* tile =nil;
    tile = [tiles objectAtIndex:index];
    return tile;
}



- (NSInteger) indexOfNodeWithValue: (NSString*) value
{
	NSInteger i, count;
	count = [tiles count];
	for (i = 0; i < count; i++)
	{
        NSString* cValue = [[tiles objectAtIndex:i] value];
		if ([cValue isEqual: value]) {
			return i;
		}
	}
	return NSNotFound;
}

-(void) dump
{
	int i, count;
	count = [tiles count];
	for (i = 0; i < count; i++)
	{
		[[tiles objectAtIndex: i] dump];
	}
}


- (NSMutableArray*) dijkstraFromNode:(Node*) source toNode:(Node*) target
{
	
	int i, count, qCount, alt, nNeighbors;
	NSNumber* max = [[NSNumber alloc] initWithInt: 99999];
	count = [tiles count];
	NSMutableDictionary* dist = [[NSMutableDictionary alloc] initWithCapacity: count];
	NSMutableDictionary* prev = [[NSMutableDictionary alloc] initWithCapacity: count];
	NSMutableArray* q = [[NSMutableArray alloc] initWithArray:tiles];
	NSMutableArray* path = [[NSMutableArray alloc] init];
	
	Node* current = nil;
	Node* currentTarget = nil;
	Node* neighbor = nil;
	
	nNeighbors = 0;
    
	for (i = 0; i < count; i++)
	{
		[dist setValue:max forKey:[[tiles objectAtIndex:i] value]];
		[prev setValue:nil forKey:[[tiles objectAtIndex:i] value]];
	}
	
	[dist setObject:[NSNumber numberWithInt: 0] forKey:[source value]];
	qCount = [q count];
	
	while (qCount > 0) {
		current = [Map nodeWithSmallestDistance:dist inQueue:q];
        
        if (([[dist objectForKey: [current value]] intValue] == [max intValue])||(current == nil)) {
            break;
        }
        
		[q removeObject: current];
        
		nNeighbors = [[current neighbors] count];
		
		for (i = 0; i < nNeighbors; i++)
		{
			neighbor = [[[current neighbors] objectAtIndex:i] node];
			alt = [[dist objectForKey: [current value]] intValue] + [[current distanceTo:neighbor] intValue];
			int neighborDist = [[dist objectForKey: [neighbor value]] intValue];
			if (alt < neighborDist) {
				[dist setObject:[NSNumber numberWithInt: alt] forKey: [neighbor value]];
				[prev setObject:current forKey:[neighbor value]];
			}
		}
		qCount = [q count];
	}
    
	currentTarget = target;
	while ([prev objectForKey:[currentTarget value]] != nil) {
		[path insertObject:[prev objectForKey:[currentTarget value]] atIndex:0];
		currentTarget = [prev objectForKey:[currentTarget value]];
	}
	
	[dist release];
	[prev release];
	[q release];
	
	return path;
}

+(void) printPath:(NSArray*) path
{
	int count, i;
	
	count = [path count];
	NSLog(@"START");
	for (i = 0; i < count; i++)
	{
		NSLog(@"%@", [[path objectAtIndex:i] value]);
	}
	NSLog(@"FINISH");
}


+(Node*) nodeWithSmallestDistance:(NSDictionary*) dist inQueue: (NSArray*) q
{
	NSInteger i, count, min;
	Node* node = nil;
	NSString* nodeValue;
	count = [q count];
	min = 99999;
	
	for (i = 0; i < count; i++)
	{
		nodeValue = [[q objectAtIndex: i] value];
        
		if ([[dist objectForKey: nodeValue] intValue] < min) {
			min = [[dist objectForKey: nodeValue] intValue];
			node = [q objectAtIndex: i];
		}
	}
	
	return node;
}

- (void) dealloc
{
	int i, count;
	count = [tiles count];
	for (i = 0; i < count; i++)
	{
		[[tiles objectAtIndex: i] release];
	}
    [tiles release];
    [super dealloc];
}


@end
