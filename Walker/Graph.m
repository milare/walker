//
//  Graph.m
//  Tut2
//
//  Created by Bruno Macedo on 30/03/11.
//  Copyright 2011 home. All rights reserved.
//

#import "Graph.h"


@implementation Graph

@synthesize nodes;

-(id) init
{
	if ( self = [super init] )
    {
		self.nodes = [NSMutableArray array];
		
		// Graph acting as a matrix for easy input
		int width = 5;
		int height = 5;
		NSNumber* weight = [[NSNumber alloc] initWithInt: 1];
		Node* currentNode = nil;
		int i, j, count;
		
		for (j = 0; j < height; j++)
		{
			for (i = 0; i < width; i++)
			{
				NSString* value = [[NSString alloc] initWithFormat:@"n%d,%d", i, j];
				currentNode = [[Node alloc] initWithValue: value];
				[nodes addObject:currentNode];
			}
		}
		
		count = [nodes count];
		for (i = width; i < count; i++)
		{
			if (i % width != 0) {
				[[nodes objectAtIndex: i] addNeighbor: [nodes objectAtIndex: (i-1)] withWeight:weight];
			}
			[[nodes objectAtIndex: i] addNeighbor: [nodes objectAtIndex: (i-width)] withWeight:weight];
		}
		
    }
    return self;
}


- (NSInteger) indexOfNodeWithValue: (NSString*) value
{
	NSInteger i, count;
	count = [nodes count];
	for (i = 0; i < count; i++)
	{
		if ([[nodes objectAtIndex:i] value] == value) {
			return i;
		}
	}
	return NSNotFound;
}

-(void) dump
{
	int i, count;
	count = [nodes count];
	for (i = 0; i < count; i++)
	{
		[[nodes objectAtIndex: i] dump];
	}
}


- (NSMutableArray*) dijkstraFromNode:(Node*) source toNode:(Node*) target
{
	
	int i, count, qCount, alt, nNeighbors;
	NSNumber* max = [[NSNumber alloc] initWithInt: 99999];
	count = [nodes count];
	NSMutableDictionary* dist = [[NSMutableDictionary alloc] initWithCapacity: count];
	NSMutableDictionary* prev = [[NSMutableDictionary alloc] initWithCapacity: count];
	NSMutableArray* q = [[NSMutableArray alloc] initWithArray:nodes];
	NSMutableArray* path = [[NSMutableArray alloc] init];
	
	Node* current = nil;
	Node* currentTarget = nil;
	Node* neighbor = nil;
	
	nNeighbors = 0;

	for (i = 0; i < count; i++)
	{
		[dist setValue:max forKey:[[nodes objectAtIndex:i] value]];
		[prev setValue:nil forKey:[[nodes objectAtIndex:i] value]];
	}
	
	[dist setObject:[[NSNumber alloc] initWithInt: 0] forKey:[source value]];
	qCount = [q count];
	
	while (qCount > 0) {
		current = [Graph nodeWithSmallestDistance:dist inQueue:q];
		[q removeObject: current];
		nNeighbors = [[current neighbors] count];
		
		for (i = 0; i < nNeighbors; i++)
		{
			neighbor = [[[current neighbors] objectAtIndex:i] node];
			alt = [[dist objectForKey: [current value]] intValue] + [[current distanceTo:neighbor] intValue];
			int neighborDist = [[dist objectForKey: [neighbor value]] intValue];
			if (alt < neighborDist) {
				[dist setObject:[[NSNumber alloc] initWithInt: alt] forKey: [neighbor value]];
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
	count = [nodes count];
	for (i = 0; i < count; i++)
	{
		[[nodes objectAtIndex: i] release];
	}
    [nodes release];
    [super dealloc];
}

@end
