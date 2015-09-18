//
//  BurgerMenuViewController.m
//  StackOverflow
//
//  Created by Sarah Hermanns on 9/14/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import "BurgerMenuViewController.h"
#import "SearchQuestionViewController.h"
#import "MyProfileViewController.h"
#import "MyQuestionsViewController.h"
#import "WebViewViewController.h"
#import "Error.h"
#import "MainMenuViewController.h"

CGFloat const kburgerOpenScreenDivider = 3.0;
CGFloat const kburgerOpenScreenMultiplier = 2.0;
NSTimeInterval const ktimeToSlideMenuOpen = 0.3;
CGFloat const kburgerButtonWidth = 75.0;
CGFloat const kburgerButtonHeight = 75.0;
static void *isDownloadingContext = &isDownloadingContext;

@interface BurgerMenuViewController ()<UITableViewDelegate>

@property (strong,nonatomic) MainMenuViewController *menuVC;
@property (strong,nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong,nonatomic) UIPanGestureRecognizer *pan;
@property (strong,nonatomic) UIButton *burgerButton;
@property (strong,nonatomic) SearchQuestionViewController *searchQuestionViewController;

@end

@implementation BurgerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
  UITableViewController *mainMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
  mainMenuViewController.tableView.delegate = self;
  
  [self addChildViewController:mainMenuViewController];
  mainMenuViewController.view.frame = self.view.frame;
  [self.view addSubview:mainMenuViewController.view];
  [mainMenuViewController didMoveToParentViewController:self];
  
  SearchQuestionViewController *searchQuestionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchQuestions"];
  MyQuestionsViewController *myQuestionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyQuestions"];
  MyProfileViewController *myProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfile"];
  self.viewControllers = @[searchQuestionVC,myQuestionsVC, myProfileVC];
  
  [self addChildViewController:searchQuestionVC];
  searchQuestionVC.view.frame = self.view.frame;
  [self.view addSubview:searchQuestionVC.view];
  [searchQuestionVC didMoveToParentViewController:self];
  self.topViewController = searchQuestionVC;
  
  UIButton *burgerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kburgerButtonWidth, kburgerButtonHeight)];
  [burgerButton setImage:[UIImage imageNamed:@"burger"] forState:UIControlStateNormal];
  [self.topViewController.view addSubview:burgerButton];
  [burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  self.burgerButton = burgerButton;
  
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(topViewControllerPanned:)];
  [self.topViewController.view addGestureRecognizer:pan];
  self.pan = pan;
}

//-(void)viewDidAppear:(BOOL)animated {
//  [super viewDidAppear:animated];
//    WebViewViewController *webVC = [[WebViewViewController alloc] init];
//    [self presentViewController:webVC animated:true completion:nil];
//  
//}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
 NSString *existingToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
  if (!existingToken) {
  WebViewViewController *webVC = [[WebViewViewController alloc] init];
  [self presentViewController:webVC animated:true completion:nil];

  }
}
-(void)topViewControllerPanned:(UIPanGestureRecognizer *)sender {
  
  CGPoint velocity = [sender velocityInView:self.topViewController.view];
  CGPoint translation = [sender translationInView:self.topViewController.view];
    //NSLog(@"velocity x: %f y:%f",velocity.x, velocity.y);
    //  NSLog(@"translation x: %f y:%f",translation.x, translation.y);
  
  if (sender.state == UIGestureRecognizerStateChanged) {
    if (velocity.x > 0) {
      self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translation.x, self.topViewController.view.center.y);
      [sender setTranslation:CGPointZero inView:self.topViewController.view];
    }
  }
  
  if (sender.state == UIGestureRecognizerStateEnded) {
    if (self.topViewController.view.frame.origin.x > self.topViewController.view.frame.size.width / kburgerOpenScreenDivider) {
      NSLog(@"user is opening menu");
      
      [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x * kburgerOpenScreenMultiplier, self.topViewController.view.center.y);
      } completion:^(BOOL finished) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseMenu:)];
        [self.topViewController.view addGestureRecognizer:tap];
        self.burgerButton.userInteractionEnabled = false;
        
      }];
    } else {
      [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x, self.topViewController.view.center.y);
      } completion:^(BOOL finished) {
        
      }];
    }
  }
}

-(void)burgerButtonPressed:(UIButton *)sender {
  [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
    self.topViewController.view.center = CGPointMake(self.view.center.x * kburgerOpenScreenMultiplier, self.topViewController.view.center.y);
  } completion:^(BOOL finished) {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseMenu:)];
    [self.topViewController.view addGestureRecognizer:tap];
    sender.userInteractionEnabled = false;
    
  }];
}

-(void)tapToCloseMenu:(UITapGestureRecognizer *)tap {
  [self.topViewController.view removeGestureRecognizer:tap];
  [UIView animateWithDuration:0.3 animations:^{
    self.topViewController.view.center = self.view.center;
  } completion:^(BOOL finished) {
    self.burgerButton.userInteractionEnabled = true;
    
  }];
}

-(void)switchToViewController:(UIViewController *)newVC{
  [UIView animateWithDuration:0.3 animations:^{
    
    self.topViewController.view.frame = CGRectMake(self.view.frame.size.width,self.topViewController.view.frame.origin.y,self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
    
  } completion:^(BOOL finished) {
    CGRect oldFrame = self.topViewController.view.frame;
    [self.topViewController willMoveToParentViewController:nil];
    [self.topViewController.view removeFromSuperview];
    [self.topViewController removeFromParentViewController];
    
    [self addChildViewController:newVC];
    newVC.view.frame = oldFrame;
    [self.view addSubview:newVC.view];
    [newVC didMoveToParentViewController:self];
    self.topViewController = newVC;
    
    [self.burgerButton removeFromSuperview];
    [self.topViewController.view addSubview:self.burgerButton];
    
    
    [UIView animateWithDuration:0.3 animations:^{
      self.topViewController.view.center = self.view.center;
    } completion:^(BOOL finished) {
      [self.topViewController.view addGestureRecognizer:self.pan];
      self.burgerButton.userInteractionEnabled = true;
    }];
    
    
    
  }];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"%ld",(long)indexPath.row);
  
  UIViewController *newVC = self.viewControllers[indexPath.row];
  if (![newVC isEqual:self.topViewController]) {
    [self switchToViewController:newVC];
  }
  
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (context == isDownloadingContext) {
    BOOL newValue = [(NSNumber *)change[NSKeyValueChangeNewKey] boolValue];
    if (newValue) {
      [self.menuVC.questionSearchActivityIndicator startAnimating];
    } else {
      [self.menuVC.questionSearchActivityIndicator stopAnimating];
    }
    
  }
}


-(void)dealloc {
  [self.searchQuestionViewController removeObserver:self forKeyPath:@"isDownloading" context:isDownloadingContext];
  
}

@end
