//
//  ChatViewController.m
//  Fitness App
//
//  Created by britneyting on 7/22/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "ChatViewController.h"
#import "Parse/Parse.h"
#import "ChatCell.h"
#import <PubNub/PubNub.h>
#import "UIImageView+AFNetworking.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, PNObjectEventListener>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
// Stores reference on PubNub client to make sure what it won't be released.
@property (nonatomic, strong) PubNub *client;
@property (nonnull, strong) NSString *hybridChannelName;
@property (nonatomic, strong) NSArray *channelsArray;
@property (nonatomic, strong) NSMutableDictionary *Message;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSNumber *earliestMessageTime;
@property BOOL loadingMore;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension; // temporary, non-dynamic row height
    self.messageField.layer.borderWidth = 1.0f;
    self.messageField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.messageField.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    self.messageField.layer.cornerRadius = 8;
    
    // set up keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.loadingMore = NO;
    
    // subscribing the user to their own channel as well as a hybrid channel between the two users. Channel name is a combination of the user and nearbyPerson's username, alphabetized
    NSString *currentUsername = self.currentUser.username;
    NSString *nearbyPersonUsername = self.nearbyPerson.username;
    NSMutableArray *hybridUsers = [[NSMutableArray alloc] initWithObjects:currentUsername, nearbyPersonUsername, nil];
    [hybridUsers sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.hybridChannelName = [NSString stringWithFormat: @"%@_%@", [hybridUsers objectAtIndex:0], [hybridUsers objectAtIndex:1]];
    NSLog(@"Hybrid Channel Name: %@_%@", [hybridUsers objectAtIndex:0], [hybridUsers objectAtIndex:1]);
    NSMutableArray *channelNames = [[NSMutableArray alloc] initWithObjects:self.currentUser.username, self.hybridChannelName, nil];
    self.channelsArray = [channelNames copy];
    NSLog(@"Channel Names: %@, %@", [self.channelsArray objectAtIndex:0], [self.channelsArray objectAtIndex:1]);
    
    self.messages = [[NSMutableArray alloc] initWithObjects:self.Message, nil];
    self.earliestMessageTime = [[NSNumber alloc] initWithInt:-1];
    
    // Initialize and configure PubNub client instance
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:@"pub-c-d75a9490-ab07-4f0b-a8a9-5224018c182b" subscribeKey:@"sub-c-59cba88e-ae3c-11e9-adf1-0649e4155de4"];
    self.client = [PubNub clientWithConfiguration:configuration];
    [self.client addListener:self];
    [self.client subscribeToChannels:self.channelsArray withPresence:YES];
    
    [self loadLastMessages];
}

- (void)loadLastMessages {
    
    [self addHistorywithStartTime:nil endTime:nil andLimit:100];
    
    //Bring the tableview down to the bottom to the most recent messages
    if (!(self.messages.firstObject == nil)) {
        NSIndexPath *indexPath = [[NSIndexPath alloc] init];
        indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)addHistorywithStartTime:(NSNumber *)start endTime:(NSNumber *)end andLimit:(NSUInteger)limit {
    
    //The PubNub Function that returns an object of X messages, and when the first and last messages were sent.
    //The limit is how many messages are received with a maximum and default of 100.
    
    [self.client historyForChannel:self.hybridChannelName start:start end:end limit:limit withCompletion:^(PNHistoryResult *result, PNErrorStatus *status) {
        
        if (result != nil && status == nil) {
            
            /**
             Handle downloaded history using:
             result.data.start - oldest message time stamp in response
             result.data.end - newest message time stamp in response
             result.data.messages - list of messages
             */
            
            //We save when the earliest message was sent in order to get ones previous to it when we want to load more.
            self.earliestMessageTime = result.data.start;
            
            [self.messages addObjectsFromArray:result.data.messages];
            
            [self.tableView reloadData];
            
            //Making sure that we wont be able to try to reload more data until this is completed.
            self.loadingMore = NO;
        }
        else {
            
            /**
             Handle message history download error. Check 'category' property
             to find out possible reason because of which request did fail.
             Review 'errorData' property (which has PNErrorData data type) of status
             object to get additional information about issue.
             
             Request can be resent using: [status retry];
             */
            NSLog(@"Couldn't load message history");
            NSLog(@"%@", status.errorData);
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)finishedTyping:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

- (IBAction)sendMessage:(id)sender {
    
    if (![self.messageField.text isEqualToString:@""]) {
        
        self.Message = [[NSMutableDictionary alloc] init];
        self.Message[@"message"] = self.messageField.text;
        self.Message[@"publisher"] = self.currentUser.username;
        
        NSLog(@"This is my messageObject: %@", self.Message);
        
        [self.client publish:self.Message toChannel:self.hybridChannelName withCompletion:^(PNPublishStatus *status) {
            
            if (!status.isError) {
                
                // Message successfully published to specified channel.
                self.messageField.text = @"";
                NSLog(@"Successfully published message to hybrid channel!");
            }
            else {
                
                /**
                 Handle message publish error. Check 'category' property to find
                 out possible reason because of which request did fail.
                 Review 'errorData' property (which has PNErrorData data type) of status
                 object to get additional information about issue.
                 
                 Request can be resent using: [status retry];
                 */
                NSLog(@"Didn't publish message to hybrid channel");
            }
        }];
    }
}

// Handle new message from one of channels on which client has been subscribed.
- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    
    // Handle new message stored in message.data.message
    if ([message.data.channel isEqualToString:message.data.subscription]) {
        
        // Message has been received on channel group stored in message.data.subscription.
        NSDictionary *messageContent = message.data.message;
        [self.messages addObject:messageContent];
        [self.tableView reloadData];
        NSIndexPath *indexPath = [[NSIndexPath alloc] init];
        indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        NSLog(@"Received message in channel: %@", message.data.message);
    }
    else {
        
        // Message has been received on channel stored in message.data.channel.
    }
    
    NSLog(@"Received message: %@ on channel %@ at %@", message.data.message[@"message"],
          message.data.channel, message.data.timetoken);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    
    NSDictionary *message = self.messages[indexPath.row];
    
    cell.usernameLabel.text = message[@"publisher"];
    [cell.usernameLabel setFont: [UIFont fontWithName:@"Arial" size:13.0f]];
    cell.messageLabel.text = message[@"message"];
    [cell.messageLabel setFont: [UIFont fontWithName:@"Arial" size:15.0f]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cell.messageLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, cell.messageLabel.text.length)];
    cell.messageLabel.attributedText = attributedString;

    if (message[@"publisher"] == self.currentUser.username) {
        cell.usernameLabel.text = @"me";
        cell.messageLabel.textAlignment = NSTextAlignmentRight;
        cell.usernameLabel.textAlignment = NSTextAlignmentRight;
//        cell.profilePicture.file = self.currentUser[@"profilePicture"];
//        [cell.profilePicture loadInBackground];
    }
    else if (message[@"publisher"] == self.nearbyPerson.username) {
        cell.messageLabel.textAlignment = NSTextAlignmentLeft;
        cell.usernameLabel.textAlignment = NSTextAlignmentLeft;
//        cell.profilePicture.file = self.nearbyPerson[@"profilePicture"];
//        [cell.profilePicture loadInBackground];
    }
    
    return cell;
}

- (UIImage*)circularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = frame.size.width;
    CGFloat rectHeight = frame.size.height;
    
    //Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
