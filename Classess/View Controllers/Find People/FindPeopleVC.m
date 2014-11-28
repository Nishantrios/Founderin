//
//  FindPeopleVC.m
//  Founderin
//
//  Created by Neuron on 11/22/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "FindPeopleVC.h"
#import "SlideMenuCell.h"
#import "Constants.h"

@interface FindPeopleVC ()
{
    UISwipeGestureRecognizer    *swipeMenuLeft;
    UISwipeGestureRecognizer    *swipeMenuRight;
}

@property (weak, nonatomic) IBOutlet UIView         *viewMain;
@property (weak, nonatomic) IBOutlet UIView         *viewSideMenu;

@property (weak, nonatomic) IBOutlet UITableView    *tblMenu;

@property (weak, nonatomic) IBOutlet UIButton       *btnSideMenu;

@property (weak, nonatomic) IBOutlet UIImageView    *imgViewUser;

@property (strong, nonatomic) NSArray               *arrMenuViewTitles;
@property (strong, nonatomic) NSArray               *arrMenuViewImages;

@end

@implementation FindPeopleVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //---> Do any additional setup after loading the view.
    
    self.imgViewUser.image = [UIImage imageNamed:@"images.jpg"];
    self.imgViewUser.clipsToBounds = YES;

    [self setRoundedView:self.imgViewUser toDiameter:85.0];
    
    //--->    Intialize menu title array
    self.arrMenuViewTitles          = [[NSArray alloc] initWithObjects:@"Chat",@"Friends", @"Notification", @"My Meetings", @"Let's Meet Now", @"Find People", @"Calendar", @"Contacts", @"Logout", nil];
    
    //--->    Intialize menu icon array with images
    self.arrMenuViewImages          = [[NSArray alloc] initWithObjects:@"chat.png", @"user.png", @"notification.png", @"meetings.png", @"meet_now.png", @"find_people.png", @"calendar.png", @"contacts.png", @"logout.png", nil];

    //--->    Add SwipeGestureRecognizer
    swipeMenuLeft               = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToLeft)];
    [swipeMenuLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:swipeMenuLeft];
    
    swipeMenuRight              = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToRight)];
    [swipeMenuRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:swipeMenuRight];
}

/**
 **     Detect left swipe event and swipe home view to left
 **/
- (void)handleSwipeToLeft
{
    self.btnSideMenu.tag = 0;
    [UIView animateWithDuration:0.5 animations:^(void){
        [self.viewMain setFrame:CGRectMake(0, 0, self.viewMain.frame.size.width, self.viewMain.frame.size.height)];
    }];
}

/**
 **     Detect Right swipe event and swipe home view to right
 **/
- (void)handleSwipeToRight
{
    self.btnSideMenu.tag = 1;
    [UIView animateWithDuration:0.5 animations:^(void){
        [self.viewMain setFrame:CGRectMake(270, 0, self.viewMain.frame.size.width, self.viewMain.frame.size.height)];
    }];
}

#pragma mark - Action Methods
/**
 **     Show/Hide menu view with animation on tap of menu button
 **/
- (IBAction)btnSlideMenu_Action:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        //--->    Show Menu View
        self.btnSideMenu.tag = 1;
        [UIView animateWithDuration:0.5 animations:^(void){
            [self.viewMain setFrame:CGRectMake(270, 0, self.viewMain.frame.size.width, self.viewMain.frame.size.height + 20)];
        }];
    }
    else
    {
        //--->    Hide Menu View
        self.btnSideMenu.tag = 0;
        [UIView animateWithDuration:0.5 animations:^(void){
            [self.viewMain setFrame:CGRectMake(0, 0, self.viewMain.frame.size.width, self.viewMain.frame.size.height + 20)];
        }];
    }
}

#pragma mark - Custom Methods
- (void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.layer.borderWidth = 2.0;
    roundedView.layer.borderColor = [App_Theme_Color CGColor];
    roundedView.center = saveCenter;
}

#pragma mark - UITableview DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //*>    Initialize header view object
    UIView *viewHeader              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 140)];
    viewHeader.backgroundColor      = White_Color;
    
    UIImageView *imgViewUser        = [[UIImageView alloc] initWithFrame:CGRectMake(97, 5, 85, 85)];
    imgViewUser.clipsToBounds       = YES;
    imgViewUser.image               = [UIImage imageNamed:@"image.jpg"];

    [self setRoundedView:imgViewUser toDiameter:85.0];
    
    UILabel *lblUserName            = [[UILabel alloc] initWithFrame:CGRectMake(20, 105, 230, 23)];
    lblUserName.backgroundColor     = [UIColor clearColor];
    lblUserName.textColor           = [UIColor darkGrayColor];
    lblUserName.textAlignment       = NSTextAlignmentCenter;
    lblUserName.font                = [UIFont fontWithName:@"Helvetica-Neue" size:19.0];
    lblUserName.text                = @"Talon Methew";
    
    UIImageView *imgViewSeparater = [[UIImageView alloc] initWithFrame:CGRectMake(0, 139, tableView.frame.size.width, 1)];
    imgViewSeparater.image = [UIImage imageNamed:@"separater_Strip.png"];
    
    [viewHeader addSubview:imgViewUser];
    [viewHeader addSubview:lblUserName];
    [viewHeader addSubview:imgViewSeparater];
    
    return viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMenuViewTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SlideMenuCell";
    SlideMenuCell *cell = (SlideMenuCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[SlideMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier] ;
    }
    
    cell.lblMenuTitle.text = [NSString stringWithFormat:@"%@", [self.arrMenuViewTitles objectAtIndex:indexPath.row]];
    cell.imgViewMenuIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.arrMenuViewImages objectAtIndex:indexPath.row]]];

    return cell;
}

#pragma mark - UITableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end