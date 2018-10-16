//
//  LoginViewController.h
//  API Movie
//
//  Created by Admin on 10/4/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "UIImageView+WebCache.h"
#import "LoadingView.h"
#import "MoviewListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController<APIDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passtextField;

@end

NS_ASSUME_NONNULL_END
