//
//  User.h
//  StackOverflow
//
//  Created by Sarah Hermanns on 9/16/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (strong, nonatomic) NSNumber *reputation;
@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSString *displayName;

@end
