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

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navItem.title = @"Message";
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    
    cell.messageLabel.text = self.chatsArray[indexPath.row][@"text"];
    
    return cell;
    
}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)finishedTyping:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)sendMessage:(id)sender {
    // creates a new PFObject to save message as
    PFObject *chatMessage = [PFObject objectWithClassName:@"blank"];
    
    // Use the name of your outlet to get the text the user typed
    // Store the text of the text field in a key called text.
    chatMessage[@"text"] = self.messageField.text;
    
    // saves message in background
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.messageField.text = @"";
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
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
