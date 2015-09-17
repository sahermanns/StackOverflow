//
//  MyProfileViewController.m
//  StackOverflow
//
//  Created by Sarah Hermanns on 9/14/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import "MyProfileViewController.h"
#import "StackOverflowService.h"
#import "WebViewViewController.h"
#import "Error.h"
#import "User.h"
#import <UIKit/UIKit.h>


@interface MyProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;
@property (weak, nonatomic) IBOutlet UILabel *reputation;
@property (weak, nonatomic) IBOutlet UILabel *creationDate;
@property (strong,nonatomic) NSDateFormatter *dateFormatter;

@property(strong, nonatomic) User *user;

@end

@implementation MyProfileViewController



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
NSString *existingToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
  
self.dateFormatter = [[NSDateFormatter alloc] init];
self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
  
[StackOverflowService resultsForUser:existingToken completionHandler:^(User *results, NSError *error) {
  if (error) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      [alertController dismissViewControllerAnimated:true completion:nil];
    }];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:true completion:nil];
  } else {
    self.user = results;
    
    NSString *avatarURL = self.user.avatarURL;
    NSURL *imageURL = [NSURL URLWithString:avatarURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.user.profileImage = image;
    self.profileImage.image = self.user.profileImage;
    self.ownerName.text = self.user.displayName;
    self.reputation.text = [NSString stringWithFormat:@"Reputation out of 10:%@", self.user.reputation];
    NSString *formattedCreationDate = [self.dateFormatter stringFromDate:self.user.creationDate];
    self.creationDate.text = [NSString stringWithFormat:@"%@",formattedCreationDate];

  }
}];
  
}

-(void)viewDidLoad {
    [super viewDidLoad];
  

}

@end
