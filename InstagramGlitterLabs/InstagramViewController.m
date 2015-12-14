//
//  InstagramViewController.m
//  InstagramGlitterLabs
//
//  Created by Vishal Bhadade on 13/12/15.
//  Copyright (c) 2015 Globallogic. All rights reserved.
//

#import "InstagramViewController.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define DATA                     @"data"
#define ITEMS                    @"items"
#define COMMENTS                 @"comments"
#define COMMENT                  @"comment"
#define STANDARD_IMAGE_URL       @"url"
#define IMAGES                   @"images"
#define TEXT                     @"text"
#define COUNT                    @"count"
#define CAPTION                  @"caption"
#define USERNAME                 @"username"
#define USER                     @"user"
#define STANDARD_RESOLUTION      @"standard_resolution"
#define INSTAGRAM_PLACEHOLDER    @"instagram.png"

@interface InstagramViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *instagramImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) IBOutlet UILabel *instagramCommentsCount;
@property (strong, nonatomic) IBOutlet UILabel *instagramUserName;
@property (strong, nonatomic) IBOutlet UILabel *instagramText;
@end

@implementation InstagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*CGFloat scrollViewWidth = self.instagramImageView.frame.size.width * [self.recordsArray count];
    [self.imageScrollView setContentSize:CGSizeMake(scrollViewWidth, self.imageScrollView.frame.size.height)];*/
    
    NSDictionary *item = [self.recordsArray objectAtIndex:self.indexPath.row];
    
    NSString *userName = @"";
    NSNumber *count = 0;
    NSString *text = @"";
    NSString *stdImageURL = @"";

    if (item && [item count])
    {
        NSDictionary *user = [item objectForKey:USER];
        if (user && [NSNull null] != [item objectForKey:USER])
        {
            userName = [user objectForKey:USERNAME];
        }
        
        
        NSDictionary *comments = [item objectForKey:COMMENTS];
        if (comments && [NSNull null] != [item objectForKey:COMMENTS])
        {
            count = [comments objectForKey:COUNT];
        }
        
        
        NSDictionary *caption = [item objectForKey:CAPTION];
        if (caption && [NSNull null] != [item objectForKey:CAPTION])
        {
            text = [caption objectForKey:TEXT];
        }
        
        
        NSDictionary *images = [item objectForKey:IMAGES];
        if (images && [NSNull null] != [item objectForKey:IMAGES])
        {
            NSDictionary *stdImage = [images objectForKey:STANDARD_RESOLUTION];
            if (stdImage && [NSNull null] != [images objectForKey:STANDARD_RESOLUTION])
            {
                stdImageURL = [stdImage objectForKey:STANDARD_IMAGE_URL];
            }
        }
        
    }

    [self.instagramText setText:text];
    [self.instagramUserName setText:userName];
    
    NSString *commentString = [count intValue] > 1 ? COMMENTS : COMMENT;
    [self.instagramCommentsCount setText:[NSString stringWithFormat:@"%d %@", [count intValue], commentString]];
    
    NSURL * imageURL = [NSURL URLWithString:stdImageURL];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[stdImageURL lastPathComponent]]];
    UIImage * standardImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    if (standardImage)
    {
        [self.instagramImageView setImage:standardImage];
    }
    
    if (imageURL)
    {
        [self.instagramImageView sd_setImageWithURL:imageURL
                                   placeholderImage:[UIImage imageNamed:INSTAGRAM_PLACEHOLDER]
                                            options:SDWebImageTransformAnimatedImage];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
