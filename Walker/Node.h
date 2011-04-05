//
//  Node.h
//  Tut2
//
//  Created by Bruno Macedo on 30/03/11.
//  Copyright 2011 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Edge.h"

@interface Node : NSObject {
	NSString* value;
	NSMutableArray* neighbors;	
}

/* Properties */
@property (retain) NSString* value;
@property (retain) NSMutableArray* neighbors;

/* Methods declaration */
-(void) addOneWayNeighbor: (Node*) node withWeight:(NSNumber*) edgeWeight;
-(void) addNeighbor: (Node*) node withWeight:(NSNumber*) edgeWeight;

-(void) removeOneWayNeighbor: (Node*) node;
-(void) removeNeighbor: (Node*) node;

- (NSNumber*) distanceTo:(Node*)neighbor;
-(Node*) getClosestNeighbor;

-(id) initWithValue: (NSString*) nodeValue;
-(NSInteger) isAdjacentTo: (Node*) node;
-(void) dump;

@end
