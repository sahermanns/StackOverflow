//
//  StackOverflowService.m
//  StackOverflow
//
//  Created by Sarah Hermanns on 9/15/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import "StackOverflowService.h"
#import "Error.h"
#import <AFNetworking/AFNetworking.h>
#import "QuestionsJSONParser.h"
#import "Question.h"

@implementation StackOverflowService

+(void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(void(^)(NSArray *, NSError *))completionHandler {
  
  NSString *baseURL = @"https://api.stackexchange.com/2.2/search?order=desc&sort=activity";
  NSString *endOfURL = @"site=stackoverflow";
  NSString *finalURL = [NSString stringWithFormat:@"%@&inTitle=%@&%@", baseURL,searchTerm,endOfURL];
  NSString *url = finalURL;
//  NSString *url = @"https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=swift&site=stackoverflow";
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id __nonnull responceObject) {
    
    NSArray *questions = [QuestionsJSONParser searchQuestionsResultsFromJSON:responceObject];
    completionHandler(questions,nil);
    NSLog(@"getting inside questionsForSearchTerm");
    
  } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull responceObject) {
    if (operation.response) {
      NSError *stackOverflowError = [self errorForStatusCode:operation.response.statusCode];
      dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(nil, stackOverflowError);
        NSLog(@"stackoverflow service error");
      });
    } else {
      NSError *reachabilityError = [self checkReachability];
      if (reachabilityError) {
        completionHandler(nil, reachabilityError);
        NSLog(@"reachability error");
      }
    }
  }];
}



+(NSError *)checkReachability {
  if (![AFNetworkReachabilityManager sharedManager].reachable) {
    NSError *error = [NSError errorWithDomain:kStackOverFlowErrorDomain code:StackOverFlowConnectionDown userInfo:@{NSLocalizedDescriptionKey : @"Could not connect to servers, please try again when you have a connection"}];
    return error;
  }
  return nil;
}

+(NSError *)errorForStatusCode:(NSInteger)statusCode {
  
  NSInteger errorCode;
  NSString *localizedDescription;
  
  switch (statusCode) {
    case 400:
      localizedDescription = @"Invalid search term, try another search";
      errorCode = StackOverFlowInvalidParameter;
      break;
    case 401:
      localizedDescription = @"You must sign in to access this feature";
      errorCode = StackOverFlowNeedAuthentication;
      break;
    case 402:
      localizedDescription = @"Login was denied, try again";
      errorCode = StackOverFlowInvalidLogin;
      break;
    case 403:
      localizedDescription = @"You do not have permission to access this feature";
      errorCode = StackOverFlowAccessDenied;
      break;
    case 404:
      localizedDescription = @"The request for this does not exist";
      errorCode = StackOverFlowKeyRequestMethodDoesNotExist;
      break;
    case 405:
      localizedDescription = @"Try signing in again to access this feature";
      errorCode = StackOverFlowKeyRequired;
      break;
    case 406:
      localizedDescription = @"the security of your login has been compromised";
      errorCode = StackOverFlowTokenCompromised;
      break;
    case 407:
      localizedDescription = @"the request failed";
      errorCode = StackOverFlowWriteRequestFail;
      break;
    case 409:
      localizedDescription = @"A request with this id had already been made";
      errorCode = StackOverFlowDuplicateRequest;
      break;

    case 500:
      localizedDescription = @"An unexpected API error occured, try again later";
      errorCode = StackOverFlowUnexpectedAPIError;
      break;
    case 502:
      localizedDescription = @"Too many requests, please slow down";
      errorCode = StackOverFlowTooManyAttempts;
      break;
    case 503:
      localizedDescription = @"API unavailable currently, try later";
      errorCode = StackOverFlowAPIDown;
      break;
    default:
      localizedDescription = @"Could not complete operation, please try again later";
      errorCode = StackOverFlowGeneralError;
      break;
  }
  NSError *error = [NSError errorWithDomain:kStackOverFlowErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey : localizedDescription}];
  return error;
}

@end
