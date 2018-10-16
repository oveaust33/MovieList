//
//  LoginViewController.m
//  API Movie
//
//  Created by Admin on 10/4/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () {
    API *apiClass;

}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameTextField.text = @"peter@klaven";
    self.passtextField.text = @"cityslicka";

}



- (IBAction)loginButtonAction:(id)sender {
    
//    [self gotoMovieView];
//
//    return;
    
    
    [self performSelector:@selector(showLoadingView:) onThread:[NSThread mainThread] withObject:@"Login, please wait..." waitUntilDone:YES];
    [self performSelector:@selector(login) withObject:nil afterDelay:0.01];
    
    
    
}

-(void)login{
    
    NSMutableDictionary *dic  = [[NSMutableDictionary alloc] init];
    [dic setObject:self.nameTextField.text forKey:@"email"];
    [dic setObject:self.passtextField.text forKey:@"password"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *url = @"https://reqres.in/api/login";
    
    apiClass = [[API alloc] initWithUrl:url apiName:@"reqres.in" PostData:jsonData];
    apiClass.delegate = self;
    [apiClass accessAPI:@"POST" Synchronous:YES];
}

-(void)apiDidExecute:(API *)api apiName:(NSString *)apiName data:(id)data{
    
    if([apiName isEqualToString:@"reqres.in"]){
        [self CloseLoadingView];
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            NSString *text = [data objectForKey:@"token"];
            
            if (text== nil){
                text = @"Unsuccessfull";
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                               message:text
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            
            else {
                
                [self gotoMovieView];
                
            }
            
           
        }
        
    }
    
}

-(void)gotoMovieView{
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MoviewListViewController *mvc  = [board instantiateViewControllerWithIdentifier:@"MoviewListViewControllerID"];
    [self.navigationController pushViewController:mvc animated:YES];
}

-(void)showLoadingView:(NSString*)text{
    [[LoadingView alloc] initWithText:text Delegate:self];
    [LoadingView Show];
}

-(void)CloseLoadingView{
    [LoadingView Close];
}

@end
