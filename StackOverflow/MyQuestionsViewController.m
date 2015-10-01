//
//  MyQuestionsViewController.m
//  StackOverflow
//
//  Created by Sarah Hermanns on 9/14/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import "MyQuestionsViewController.h"
#import "StackOverflowService.h"
#import "WebViewViewController.h"
#import "Error.h"
#import "Question.h"
#import <UIKit/UIKit.h>
#import "QuestionCell.h"

@interface MyQuestionsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;

@property (strong,nonatomic) NSArray *questions;


@end

@implementation MyQuestionsViewController

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear: animated];
  
NSString *existingToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
  
[StackOverflowService resultsForUserQuestions:existingToken completionHandler:^(NSArray *results, NSError *error) {
  if (error) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      [alertController dismissViewControllerAnimated:true completion:nil];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:true completion:nil];
  } else {
    self.questions = results;
    
    for (Question *question in results) {
      NSString *avatarURL = question.avatarURL;
      NSURL *imageURL = [NSURL URLWithString:avatarURL];
      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
      UIImage *image = [UIImage imageWithData:imageData];
      question.profileImage = image;
    }
  }
}];
  
  [StackOverflowService resultsForUserQuestions:existingToken completionHandler:^(NSArray *results, NSError *error) {
    if (error) {
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alertController dismissViewControllerAnimated:true completion:nil];
      }];
      [alertController addAction:action];
      
      [self presentViewController:alertController animated:true completion:nil];
    } else {
      self.questions = results;
      dispatch_group_t group = dispatch_group_create();
      dispatch_queue_t imageQueue = dispatch_queue_create("com.SASH.StackOverflow",DISPATCH_QUEUE_CONCURRENT );
      
      for (Question *question in results) {
          NSString *avatarURL = question.avatarURL;
          NSURL *imageURL = [NSURL URLWithString:avatarURL];
          NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
          UIImage *image = [UIImage imageWithData:imageData];
          question.profileImage = image;
        };
      }
  }];
   
//      dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Images Downloaded" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//          [alertController dismissViewControllerAnimated:true completion:nil];
//        }];
//        [alertController addAction:action];
//        [self.tableView reloadData];
//        [self presentViewController:alertController animated:true completion:nil];
//        self.isDownloading = false;
//      });
    
  }


  

- (void)viewDidLoad {
    [super viewDidLoad];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
}

#pragma mark - UISearchBarDelegate





#pragma MARK: TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.questions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell" forIndexPath:indexPath];
  
  Question *question = self.questions[indexPath.row];
  cell.profileImage.image = question.profileImage;
  cell.ownerName.text = question.ownerName;
  cell.questionTitle.text = question.title;
  
  
  return cell;
  
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
