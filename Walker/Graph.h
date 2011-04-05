//
//  Graph.h
//  Tut2
//
//  Created by Bruno Macedo on 30/03/11.
//  Copyright 2011 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"Node.h"
#import "Graph.h"

@interface Graph : NSObject {
	NSMutableArray* nodes;	
}

@property (retain) NSMutableArray* nodes;

- (void) dump;
- (NSInteger) indexOfNodeWithValue: (NSString*) value;
- (NSMutableArray*) dijkstraFromNode:(Node*) source toNode:(Node*) target;
+(Node*) nodeWithSmallestDistance:(NSDictionary*) dist inQueue: (NSArray*) q;
+(void) printPath:(NSArray*) path;

@end
