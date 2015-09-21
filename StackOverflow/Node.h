//
//  Node.h
//  StackOverflow
//
//  Created by Sarah Hermanns on 9/21/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property (nonatomic) NSInteger value;
@property (retain,nonatomic) Node *left;
@property (retain,nonatomic) Node *right;

-(BOOL)addValue:(NSInteger)value;

@end
