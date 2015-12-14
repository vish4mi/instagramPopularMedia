//
//  InstagramTableViewCell.h
//  InstagramGlitterLabs
//
//  Created by Vishal Bhadade on 13/12/15.
//  Copyright (c) 2015 Globallogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *instagramUserName;
@property (strong, nonatomic) IBOutlet UIImageView *instagramImageView;
@property (strong, nonatomic) IBOutlet UILabel *instagramText;
@property (strong, nonatomic) IBOutlet UILabel *instagramCommentsCount;

@end
