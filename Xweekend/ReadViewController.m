//
//  ReadViewController.m
//  Xweekend
//
//  Created by Myth on 13-2-28.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import "ReadViewController.h"

#define kWBSDKDemoAppKey @"3448415748"
#define kWBSDKDemoAppSecret @"03aa2cb686379d48f3ea0117607590e3"

#ifndef kWBSDKDemoAppKey
#error
#endif

#ifndef kWBSDKDemoAppSecret
#error
#endif

#define kWBAlertViewLogOutTag 100
#define kWBAlertViewLogInTag  101

@interface ReadViewController ()

@end

@implementation ReadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil numOfIssues:(NSString *)numOfIssues
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_Column = 1;
        m_NumOfIssue = [numOfIssues integerValue] - 1;
        NSLog(@"%i",m_NumOfIssue);

        m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, 300, 150) style:UITableViewStyleGrouped];
        m_tableView.layer.cornerRadius = 6;
        m_tableView.layer.masksToBounds = YES;
        m_tableView.dataSource = self;
        m_tableView.delegate = self;
        m_tableView.scrollEnabled = NO;
        m_tableView.layer.shadowColor = [UIColor blackColor].CGColor;
        m_tableView.layer.shadowOffset = CGSizeMake(4, -4);
        m_tableView.layer.shadowOpacity = 0.5;
        m_tableView.layer.shadowRadius = 4.0;
        UIButton *btShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btShare.frame = CGRectMake(20, 115, 80, 30);
        [btShare setTitle:@"分享到微博" forState:UIControlStateNormal];
        [btShare addTarget:self action:@selector(shareToWeibo) forControlEvents:UIControlEventTouchUpInside];
        [m_tableView addSubview:btShare];
        
        UIButton *btCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btCancel.frame = CGRectMake(170, 115, 80, 30);
        [btCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btCancel addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
        [m_tableView addSubview:btCancel];

        textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, 280, 85)];
        textView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        textView.font = [UIFont systemFontOfSize:17];
        textView.delegate = self;

        backGround = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        backGround.backgroundColor = [UIColor blackColor];
        backGround.alpha = 0.7;
        SinaWeibo *sinaweibo = [self sinaweibo];
        sinaweibo.delegate = self;
        isShow = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remove) name:@"remove" object:nil];

        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 72, 30);
        [backButton setBackgroundImage:[UIImage imageNamed:@"BUTTON1"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *liftButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:liftButton];
        [liftButton release];
        
        
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
        UIButton *bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt1.frame = CGRectMake(0, 0, 55, 30);
        [bt1 setBackgroundImage:[UIImage imageNamed:@"BUTTON4"] forState:UIControlStateNormal];
        bt1.tag = 101;
        [bt1 addTarget:self action:@selector(share: forEvent:) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:bt1];
        
        UIButton *bt2 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt2.frame = CGRectMake(60, 0, 55, 30);
        [bt2 setBackgroundImage:[UIImage imageNamed:@"BUTTON3"] forState:UIControlStateNormal];
        bt2.tag = 102;
        [bt2 addTarget:self action:@selector(showThumbnail) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:bt2];

        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:rightView];
        [self.navigationItem setRightBarButtonItem:rightButton];
        [rightButton release];
        [rightView release];
//        NSArray *contentInfo = [dicIssueInfo objectForKey:@"contentInfo"];
        
        
//        NSMutableArray *arrData = [[NSMutableArray alloc]initWithCapacity:0];
//        for (NSDictionary *dic in contentInfo) {
//            NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
//            NSString *str = [dic objectForKey:@"numOfPaages"];
//            int sum = [str intValue];
//            for (int i = 1; i <= sum; i++) {
//                [arr addObject:[NSString stringWithFormat:@"%@%is.jpg",[dic objectForKey:@"title"],i]];
//            }
//            [arrData addObject:arr];
//        }
        //    {
        //        NSArray
        //        NSArray *arr = [[NSArray alloc]initWithObjects:@"x.jpg",@"x2.jpg",@"x3.jpg",@"x4.jpg",@"x5.jpg",@"x6.jpg",@"x7.jpg",@"102472.jpg",@"1024132.jpg",@"1024264.jpg",@"test1024.jpg",@"test2048.jpg",@"91.jpg",@"92.jpg",@"93.jpg",@"94.jpg",@"95.jpg",@"96.jpg",@"97.jpg",@"98.jpg",@"99.jpg",@"100.jpg", nil];
        //        [arrData addObject:arr];
        //    }
        
    }
    return self;
}

- (void)remove
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    
    thumbnailView.view.frame = CGRectMake(0, 1024, 768, 960);
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
//    [thumbnailView.view removeFromSuperview];
    [(UIButton *)[self.navigationController.navigationBar viewWithTag:101] setEnabled:YES];
    isShow = NO;
}

- (void)share:(id)sender forEvent:(UIEvent*)event
{
    TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:nil];
    
   [actionSheet addButtonWithTitle:@"分享到微博" block:^{
       [(UIButton *)[self.navigationController.navigationBar viewWithTag:101] setEnabled:NO];
       [(UIButton *)[self.navigationController.navigationBar viewWithTag:102] setEnabled:NO];
    
       [self.view addSubview:backGround];
       [self.view addSubview:m_tableView];
    }];


    [actionSheet cancelButtonWithTitle:@"取消" block:nil];
    actionSheet.cornerRadius = 5;
    //    NSLog(@"%@",actionSheet.)
    [actionSheet showWithTouch:event];
    [actionSheet release];
}

- (void)shareToWeibo
{
    [(UIButton *)[self.navigationController.navigationBar viewWithTag:101] setEnabled:YES];
    [(UIButton *)[self.navigationController.navigationBar viewWithTag:102] setEnabled:YES];
    [backGround removeFromSuperview];
    [m_tableView removeFromSuperview];
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    if ([sinaweibo isAuthValid]) {
        
        NSString *str = [NSString stringWithFormat:@"COVER%@.jpg",[[[[arrIssuesPlist objectAtIndex:m_NumOfIssue]objectForKey:@"contentInfo"] objectAtIndex:(m_Column - 1)]objectForKey:@"title"]];
        [sinaweibo requestWithURL:@"statuses/upload.json"
                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   textView.text, @"status",
                                   [UIImage imageNamed:str], @"pic", nil]
                       httpMethod:@"POST"
                         delegate:self];
    }else{
        [sinaweibo logIn];
    }
    
}

- (void)cancelShare
{
    [(UIButton *)[self.navigationController.navigationBar viewWithTag:101] setEnabled:YES];
    [(UIButton *)[self.navigationController.navigationBar viewWithTag:102] setEnabled:YES];
    [backGround removeFromSuperview];
    [m_tableView removeFromSuperview];
}


- (void)turnToPage:(NSInteger)column
{
    m_Column = column;
    NSDictionary *dicIssueInfo = [arrIssuesPlist objectAtIndex:m_NumOfIssue];
    textView.text = [NSString stringWithFormat:@"推荐栏目%@",[[[dicIssueInfo objectForKey:@"contentInfo"] objectAtIndex:(m_Column - 1)]objectForKey:@"title"]];

//    NSLog(@"%i",m_Column);
}

- (void)showThumbnail
{
    if (thumbnailView == nil) {
        thumbnailView = [[ThumbnailViewController alloc]initWithNibName:@"ThumbnailViewController" bundle:[NSBundle mainBundle]];
        thumbnailView.view.frame = CGRectMake(0, 1024, 768, 960);
        [self.view addSubview:thumbnailView.view];
    }
    if (isShow) {
        [(UIButton *)[self.navigationController.navigationBar viewWithTag:101] setEnabled:YES];

        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
       
        thumbnailView.view.frame = CGRectMake(0, 1024, 768, 960);
        
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];

        
//        [thumbnailView.view removeFromSuperview];
    }else{
        
        [(UIButton *)[self.navigationController.navigationBar viewWithTag:101] setEnabled:NO];

        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        
        thumbnailView.view.frame = CGRectMake(0, 0, 768, 960);
        
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];


    }
    isShow = !isShow;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
//    m_ColumnsView = nil;
//    arrIssuesPlist = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    NSLog(@"show!");
    m_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    m_hud.labelText = @"Loading comics...";

//    [m_ColumnsView release];

}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"issues" ofType:@"plist"];
    arrIssuesPlist = [[NSArray alloc]initWithContentsOfFile:path];
    NSDictionary *dicIssueInfo = [arrIssuesPlist objectAtIndex:m_NumOfIssue];
    m_ColumnsView = nil;
    m_ColumnsView = [[ColumnsView alloc]initWithFrame:self.view.bounds withDic:dicIssueInfo delegate:self];
    [self.view addSubview:m_ColumnsView];
//    NSLog(@"hide!");
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

- (void)viewDidUnload
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"remove" object:nil];
    [thumbnailView release];
    thumbnailView = nil;
    [m_ColumnsView release];
    m_ColumnsView = nil;
    [arrIssuesPlist release];
    arrIssuesPlist = nil;
    [textView release];
    textView = nil;
    [backGround release];
    backGround = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark ColumnsDelegate
- (void)Hidden
{
        //    [self setWantsFullScreenLayout:YES];

    CGContextRef context = UIGraphicsGetCurrentContext();

    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    if (isflage) {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        m_ColumnsView.frame = CGRectMake(0, 0, 768, 1024);
    }else{
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        m_ColumnsView.frame = CGRectMake(0, -64, 768, 1024);
    }
    [[UIApplication sharedApplication]setStatusBarHidden:isflage withAnimation:UIStatusBarAnimationSlide];
    [super.navigationController setNavigationBarHidden:isflage animated:FALSE];

    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];


    isflage=!isflage;
}

#pragma mark -
#pragma mark tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 25)];
    title.text = @"编辑内容";
    title.textAlignment = NSTextAlignmentCenter;
    [title setFont:[UIFont systemFontOfSize:17]];
    title.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    //    [headerView addSubview:title];
    return [title autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -
#pragma mark tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc]init] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    NSDictionary *dicIssueInfo = [arrIssuesPlist objectAtIndex:m_NumOfIssue];
    textView.text = [NSString stringWithFormat:@"推荐栏目%@",[[[dicIssueInfo objectForKey:@"contentInfo"] objectAtIndex:(m_Column - 1)]objectForKey:@"title"]];
    [cell addSubview:textView];
    [textView becomeFirstResponder];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    if ([sinaweibo isAuthValid]) {
        
        
        NSString *str = [NSString stringWithFormat:@"COVER%@.jpg",[[[[arrIssuesPlist objectAtIndex:m_NumOfIssue]objectForKey:@"contentInfo"] objectAtIndex:(m_Column - 1)]objectForKey:@"title"]];
        [sinaweibo requestWithURL:@"statuses/upload.json"
                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   textView.text, @"status",
                                   [UIImage imageNamed:str], @"pic", nil]
                       httpMethod:@"POST"
                         delegate:self];
    }
    //    [self storeAuthData];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    //    [self removeAuthData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    //    [self removeAuthData];
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败!" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享到微博成功!" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
}


- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}




@end
