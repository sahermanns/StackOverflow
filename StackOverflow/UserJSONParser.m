//
//  UserJSONParser.m
//  StackOverflow
//
//  Created by Sarah Hermanns on 9/16/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import "UserJSONParser.h"
#import "User.h"

@implementation UserJSONParser

+(User *)userResultsFromJSON:(NSDictionary *)jsonInfo {
  
  NSArray *items = jsonInfo [@"items"];
  
  
  for (NSDictionary *item in items) {
    
    User *user = [[User alloc] init];
    user.displayName = item[@"display_name"];
    user.avatarURL = item[@"profile_image"];
    NSNumber *time = item[@"creation_date"];
    NSTimeInterval epochTime = [time doubleValue];
    user.creationDate = [NSDate dateWithTimeIntervalSince1970:epochTime];
    user.reputation = item[@"reputation"];
    return user;
  }
  return nil;
}

@end
