//
//  UserJSONParser.h
//  StackOverflow
//
//  Created by Sarah Hermanns on 9/16/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface UserJSONParser : NSObject

+(User *)userResultsFromJSON:(NSDictionary *)jsonInfo;

@end
