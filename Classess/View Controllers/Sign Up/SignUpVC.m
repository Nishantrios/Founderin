//
//  SignUpVC.m
//  Founderin
//
//  Created by Neuron on 11/22/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "SignUpVC.h"

@interface SignUpVC ()

@property (weak, nonatomic) IBOutlet UITextField *txfEmail;
@property (weak, nonatomic) IBOutlet UITextField *txfPassword;
@property (weak, nonatomic) IBOutlet UITextField *txfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txfLastName;

@end

@implementation SignUpVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

#pragma mark - Custom Method
- (void)moveUp:(float )yAxis
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view setFrame:CGRectMake(0 , -yAxis, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

- (void)moveDown
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Action Methods
- (IBAction)btnBack_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self moveUp:150];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self moveDown];
    return YES;
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end