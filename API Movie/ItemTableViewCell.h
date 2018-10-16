//
//  ItemTableViewCell.h
//  API Call
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *itemDescTextView;

@end

NS_ASSUME_NONNULL_END
