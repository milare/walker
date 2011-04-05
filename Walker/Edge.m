//
//  Edge.m
//  Tut2
//
//  Created by Bruno Macedo on 30/03/11.
//  Copyright 2011 home. All rights reserved.
//

#import "Edge.h"


@implementation Edge

/* Getters and setters */
@synthesize node;
@synthesize weight;


/* Methods implementation */
- (id) createEdgeTo:(Node*)neighbor withWeight:(NSNumber*) edgeWeight
{
    if ( (self = [super init]) )
    {
		self.node = neighbor;
		self.weight = edgeWeight;
	}
    return self;
}


- (void) dealloc
{
    [node release];
    [weight release];
    [super dealloc];
}

@end
