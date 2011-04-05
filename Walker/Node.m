//
//  Node.m
//  Tut2
//
//  Created by Bruno Macedo on 30/03/11.
//  Copyright 2011 home. All rights reserved.
//

#import "Node.h"


@implementation Node

@synthesize value;
@synthesize neighbors;

-(id) initWithValue: (NSString*) nodeValue
{
	if ( (self = [super init]) )
    {
		self.value = nodeValue;
		self.neighbors = [NSMutableArray array];
    }
    return self;
}


-(void) addOneWayNeighbor: (Node*) node withWeight:(NSNumber*) edgeWeight
{
    NSInteger index = [self isAdjacentTo: node];
	if (index == NSNotFound ) {
		Edge* edge = [[Edge alloc] createEdgeTo: node withWeight: edgeWeight];
		[neighbors addObject: edge];
	}
}


-(void) addNeighbor: (Node*) node withWeight:(NSNumber*) edgeWeight
{
	BOOL directed = FALSE;
	
	[self addOneWayNeighbor: node withWeight: edgeWeight];
	if (directed == FALSE) {
		[node addOneWayNeighbor: self withWeight: edgeWeight];
	}
}


-(void) removeOneWayNeighbor: (Node*) node
{
	NSInteger index;
	Edge* edge = nil;
	
	index = [self isAdjacentTo:node];
	
	if (index != NSNotFound ) {
		edge = [neighbors objectAtIndex:index];
		[neighbors removeObjectAtIndex:index];
		[edge release];
	}
	
}

-(Node*) getClosestNeighbor
{
	int i, count, min;
	min = 99999;
	count = [neighbors count];
	Node* closest = nil;
	
	for (i = 0; i < count; i++)
	{
		if ([[[neighbors objectAtIndex:i] weight] intValue] < min) {
			min = [[[neighbors objectAtIndex:i] weight] intValue];
			closest = [[neighbors objectAtIndex:i] node];
		}		
	}
	
	return closest; 
	
}

-(void) removeNeighbor: (Node*) node
{
	BOOL directed = FALSE;
	
	[self removeOneWayNeighbor: node];
	
	if (directed == FALSE) {
		[node removeOneWayNeighbor:self];
	}
}


-(NSInteger) isAdjacentTo: (Node*) node
{
	int i, count;
	count = [neighbors count];
	NSInteger index = NSNotFound;
	
	for (i = 0; i < count; i++)
	{
		if ([[neighbors objectAtIndex:i] node] == node) {
			index = i;
			break;
		}
	}
	
	// return NSNotFound if not found, else index
	return index;
	
}

- (NSNumber*) distanceTo:(Node*)neighbor
{
	NSInteger index;
	index = [self isAdjacentTo:neighbor];
	
	if (index != NSNotFound) {
		return [[neighbors objectAtIndex:index] weight];
	}
	
	return [[NSNumber alloc] initWithInt:-1];
	
}


-(void) dump
{
	NSMutableString* dumpStr = [NSMutableString stringWithFormat: @"Value: %@\nAdjacents:\n", value];
	int i, count;
	count = [neighbors count];
	for (i = 0; i < count; i++)
	{
		Edge* edge = [neighbors objectAtIndex: i];
		[dumpStr appendFormat:@"%@ (%@)\n", [[edge node] value], [edge weight]];
	}
	NSLog(@"%@", dumpStr);
}

- (void) dealloc
{
    [value release];
	
	int i, count;
	count = [neighbors count];
	for (i = 0; i < count; i++)
	{
		[[neighbors objectAtIndex: i] release];
	}
    [neighbors release];
    [super dealloc];
}


@end
