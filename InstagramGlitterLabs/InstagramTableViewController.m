//
//  InstagramTableViewController.m
//  InstagramGlitterLabs
//
//  Created by Vishal Bhadade on 13/12/15.
//  Copyright (c) 2015 Globallogic. All rights reserved.
//

#import "InstagramTableViewController.h"
#import "InstagramTableViewCell.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "InstagramViewController.h"

#define CLIENT_ID                @"d43d240bb49745918978a8b5ed328a57"

/**
 * Response data dictionary constants
 **/
#define DATA                     @"data"
#define ITEMS                    @"items"
#define COMMENTS                 @"comments"
#define COMMENT                  @"comment"
#define STANDARD_IMAGE_URL       @"url"
#define THUMBNAIL_URL            @"url"
#define THUMBNAIL                @"thumbnail"
#define IMAGES                   @"images"
#define TEXT                     @"text"
#define COUNT                    @"count"
#define CAPTION                  @"caption"
#define USERNAME                 @"username"
#define USER                     @"user"
#define STANDARD_RESOLUTION      @"standard_resolution"
#define INSTAGRAM_PLACEHOLDER    @"instagram.png"

#define INSTAGRAM_CELL_ID        @"InstagramCell"
#define IMAGE_DETAILS_VIEW_SEGUE @"imageDetailsViewController"

/**
 * Application header constants
 **/
#define APPLICATION_JSON         @"application/json"
#define CONTENT_TYPE             @"Content-Type"
#define ACCEPT                   @"Accept"
#define GET                      @"GET"

@interface InstagramTableViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate,
  NSURLConnectionDataDelegate,
  NSURLConnectionDelegate,
  NSXMLParserDelegate
>

@property (strong, nonatomic) NSMutableData           *receivedData;
@property (strong, nonatomic) NSMutableArray          *userDataArray;
@property (strong, nonatomic) NSString                *standardImageURL;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) NSURLConnection         *theConnection;

@end

@implementation InstagramTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureActivityIndicator];
    [self.indicatorView startAnimating];
    
    self.receivedData = [[NSMutableData alloc] init];
    
    /**
     * Following two instagram APIs don't work with either access token or client ID.
     * As per the Instagram documentation, this API is deprecated but backward supported
     * for old applications created before Nov 17, 2015.
     **/
//        NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/popular?client_id=%@",CLIENT_ID];
    
    //    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/liked?access_token=%@", self.accessToken];
    
    /**
     * Use following instagram API without authentication.
     **/
    //NSString *url = [NSString stringWithFormat:@"https://www.instagram.com/smena8m/media/"];
    
    /**
     * Use following instagram API with hardcoded access token got from apigee.
     * This works with popular media API.
     **/
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/popular?access_token=2320669582.1fb234f.46ad6c5076e34a3aa5ae458af866cdad"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:GET];
    [request setValue:APPLICATION_JSON forHTTPHeaderField:CONTENT_TYPE];
    [request setValue:APPLICATION_JSON forHTTPHeaderField:ACCEPT];
    self.theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureActivityIndicator
{
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    CGSize viewSize = self.view.bounds.size;
    [self.indicatorView setFrame:CGRectMake(viewSize.width/2, viewSize.height/2, 40, 40)];
    [self.view addSubview:self.indicatorView];
}

#pragma mark -
#pragma mark - Table view data source and table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.userDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.userDataArray objectAtIndex:indexPath.row];
    
    NSString *userName = @"";
    NSNumber *count = 0;
    NSString *text = @"";
    NSString *thumbnailURL = @"";
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
            NSDictionary *thumbnail = [images objectForKey:THUMBNAIL];
            if (thumbnail && [NSNull null] != [images objectForKey:THUMBNAIL])
            {
                thumbnailURL = [thumbnail objectForKey:THUMBNAIL_URL];
            }
            
            NSDictionary *stdImage = [images objectForKey:STANDARD_RESOLUTION];
            if (stdImage && [NSNull null] != [images objectForKey:STANDARD_RESOLUTION])
            {
                stdImageURL = [stdImage objectForKey:STANDARD_IMAGE_URL];
            }
            
            self.standardImageURL = stdImageURL;
            
        }
        
    }
    
    InstagramTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:INSTAGRAM_CELL_ID];
    
    if (cell)
    {
        NSString *commentString = [count intValue] > 1 ? COMMENTS : COMMENT;
        NSString *instagramText = [NSString stringWithFormat:@"%d %@", [count intValue], commentString];
        [cell.instagramCommentsCount setText:instagramText];
        [cell.instagramImageView setImage:[UIImage imageNamed:INSTAGRAM_PLACEHOLDER]];
        [cell.instagramUserName setText:userName];
        [cell.instagramText setText:text];
        
        NSURL * imageURL = [NSURL URLWithString:thumbnailURL];
        
        /**
         * Search for the cached image stored in application bundle using SDWebImage
         **/
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[thumbnailURL lastPathComponent]]];
        UIImage * thumbanailImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
        if (thumbanailImage)
        {
            [cell.instagramImageView setImage:thumbanailImage];
        }
        
        /**
         * Call SDWebImage for updated image.
         **/
        if (imageURL)
        {
            [cell.instagramImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:INSTAGRAM_PLACEHOLDER] options:SDWebImageTransformAnimatedImage];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:IMAGE_DETAILS_VIEW_SEGUE sender:indexPath];
}

#pragma mark -
#pragma mark - NSURLConnectionDelegate delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [self.receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingAllowFragments error:&error];
    
    BOOL validJson = [NSJSONSerialization isValidJSONObject:dict];
    NSLog(@"Is Json valid : %d", validJson);
    if (dict && [dict count])
    {
        if (dict && [dict count])
        {
            self.userDataArray = [dict objectForKey:DATA];
            
        }
        if (![self.userDataArray count])
        {
            self.userDataArray = [dict objectForKey:ITEMS];
        }
    }
    [self.tableView reloadData];
    [self.indicatorView stopAnimating];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:IMAGE_DETAILS_VIEW_SEGUE])
    {
        InstagramViewController *tableVC = (InstagramViewController *)segue.destinationViewController;
        tableVC.recordsArray = self.userDataArray;
        tableVC.indexPath = sender;
    }
}


@end
