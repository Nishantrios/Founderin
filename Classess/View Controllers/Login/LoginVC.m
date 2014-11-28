//
//  LoginVC.m
//  Founderin
//
//  Created by Neuron on 11/22/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "LoginVC.h"

#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "OAuthLoginView.h"
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"

@interface LoginVC () <FBLoginViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) OAuthLoginView *oAuthLoginView;

@property (strong, nonatomic) IBOutlet FBLoginView *loginView;

@property (weak, nonatomic) IBOutlet UITextField *txfEmail;
@property (weak, nonatomic) IBOutlet UITextField *txfPassword;

@end

@implementation LoginVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //---> Do any additional setup after loading the view, typically from a nib.
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        //---> iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

#pragma mark - Custom Methods
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Action Methods
- (IBAction)btnFacebook_Action:(id)sender
{
    //---> If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
    {
        //---> Close the session and remove the access token from the cache
        //---> The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        //---> If the session state is not any of the two "open" states when the button is clicked
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Facebook Logging...";
        hud.color = App_Theme_Color;
        hud.dimBackground = YES;
        
        //---> Open a session showing the user the login UI
        //---> You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] allowLoginUI:YES completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error)
        {
             //---> Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (IBAction)btnLinkedin_Action:(id)sender
{
    _oAuthLoginView = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OAuthLoginView class])];
    
    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(loginViewDidFinish:) name:@"loginViewDidFinish" object:_oAuthLoginView];
    
    [self presentViewController:_oAuthLoginView animated:YES completion:nil];
}

#pragma mark - Linkedin Methods
-(void) loginViewDidFinish:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self profileApiCall];
}

- (void)profileApiCall
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,headline,industry,summary,positions,picture-url,skills,languages,educations,phone-numbers,main-address,api-standard-profile-request)"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url consumer:_oAuthLoginView.consumer token:_oAuthLoginView.accessToken callback:nil signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request delegate:self didFinishSelector:@selector(profileApiCallResult:didFinish:) didFailSelector:@selector(profileApiCallResult:didFail:)];
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *profile = [responseBody objectFromJSONString];
    
    if ( profile )
    {

    }
    // The next thing we want to do is call the network updates
    [self networkApiCall];
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@", [error description]);
}

- (void)networkApiCall
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/network/updates?scope=self&count=1&type=STAT"];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url consumer:_oAuthLoginView.consumer token:_oAuthLoginView.accessToken callback:nil signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request delegate:self didFinishSelector:@selector(networkApiCallResult:didFinish:) didFailSelector:@selector(networkApiCallResult:didFail:)];
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *person = [[[[[responseBody objectFromJSONString] objectForKey:@"values"] objectAtIndex:0] objectForKey:@"updateContent"] objectForKey:@"person"];
    NSLog(@"%@", person);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@", [error description]);
}

#pragma mark - Facebook Delegate
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{

}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    NSString *alertMessage, *alertTitle;
    
    if ([FBErrorUtility shouldNotifyUserForError:error])
    {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
    {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
    {
        NSLog(@"user cancelled login");
    }
    else
    {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage)
    {
        [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

#pragma mark - UITextField Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end