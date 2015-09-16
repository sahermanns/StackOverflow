//
//  QuestionsJSONParser.m
//  StackOverflow
//
//  Created by Sarah Hermanns on 9/16/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import "QuestionsJSONParser.h"
#import "Question.h"

@implementation QuestionsJSONParser

+(NSArray *)searchQuestionsResultsFromJSON:(NSDictionary *)jsonInfo {
  
  NSMutableArray *questions = [[NSMutableArray alloc] init];
  
  NSArray *items = jsonInfo [@"items"];
  for (NSDictionary *item in items) {
    Question *question = [[Question alloc] init];
    question.title = item[@"title"];
    NSDictionary *owner = item[@"owner"];
    question.ownerName = owner[@"display_name"];
    question.avatarURL = owner[@"profile_image"];
    [questions addObject:question];
    
  }
  return questions;
}


@end
