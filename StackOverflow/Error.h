//
//  Error.h
//  StackOverflow
//
//  Created by Sarah Hermanns on 9/15/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kStackOverFlowErrorDomain;

typedef enum : NSUInteger {
  StackOverFlowBadJSON = 200,
  StackOverFlowConnectionDown,
  StackOverFlowTooManyAttempts,
  StackOverFlowInvalidParameter,
  StackOverFlowInvalidLogin,
  StackOverFlowNeedAuthentication,
  StackOverFlowAccessDenied,
  StackOverFlowKeyRequestMethodDoesNotExist,
  StackOverFlowKeyRequired,
  StackOverFlowTokenCompromised,
  StackOverFlowWriteRequestFail,
  StackOverFlowDuplicateRequest,
  StackOverFlowAPIDown,
  StackOverFlowUnexpectedAPIError,
  StackOverFlowGeneralError
} StackOverFlowErrorCodes;