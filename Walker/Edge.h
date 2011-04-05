//
//  Edge.h
//  Tut2
//
//  Created by Bruno Macedo on 30/03/11.
//  Copyright 2011 home. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Node;

@interface Edge : NSObject {
	Node* node;
	NSNumber* weight;
}

/* Properties */
@property (retain) Node* node;
@property (retain) NSNumber* weight;

/* Methods declaration */
- (id) createEdgeTo:(Node*)neighbor withWeight:(NSNumber*) edgeWeight;

@end
