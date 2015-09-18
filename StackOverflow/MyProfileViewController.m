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

@property (retain, nonatomic) IBOutlet UIImageView *profileImage;
@property (retain, nonatomic) IBOutlet UILabel *ownerName;
@property (retain, nonatomic) IBOutlet UILabel *reputation;
@property (retain, nonatomic) IBOutlet UILabel *creationDate;
@property (retain,nonatomic) NSDateFormatter *dateFormatter;

@property(retain, nonatomic) User *user;

@end

@implementation MyProfileViewController



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
NSString *existingToken = [[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] retain];

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
    self.reputation.text = [NSString stringWithFormat:@"Reputation 0-10: %@", self.user.reputation];
    self.creationDate.text = [self.dateFormatter stringFromDate:self.user.creationDate];

    
    [existingToken release];

  }
}];
  
}

-(void)viewDidLoad {
    [super viewDidLoad];
  

}

-(void)dealloc {
  [_profileImage release];
  [_ownerName release];
  [_reputation release];
  [_creationDate release];
  [_dateFormatter release];
  
  [super dealloc];
}

@end
