//
//  MoviewListViewController.h
//  API Movie
//
//  Created by Admin on 10/4/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "UIImageView+WebCache.h"
#import "LoadingView.h"
#import "ItemTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoviewListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, APIDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dataListTableView;
@end

NS_ASSUME_NONNULL_END
