//
//  ChatCell.m
//  Fitness App
//
//  Created by britneyting on 7/22/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)showOutgoingMessageWithText:(NSString *)text{
//    UILabel *label = [[UILabel alloc] init];
//    label.numberOfLines = 0;
//    [label setFont:[UIFont systemFontOfSize:15]];
//    [label setTextColor:[UIColor whiteColor]];
//    label.text = text;
    
    self.messageLabel.numberOfLines = 0;
    [self.messageLabel setFont:[UIFont systemFontOfSize:15]];
    [self.messageLabel setTextColor:[UIColor whiteColor]];
    self.messageLabel.text = text;
    
    CGSize constraintRect = CGSizeMake(0.66*self.contentView.frame.size.width, CGFLOAT_MAX);
    CGRect boundingBox = [text boundingRectWithSize:constraintRect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
    CGRect frame = self.messageLabel.frame;
    frame.size = CGSizeMake(ceil(boundingBox.size.width), ceil(boundingBox.size.width));
    self.messageLabel.frame = frame;
    
    CGSize bubbleImageSize = CGSizeMake(self.messageLabel.frame.size.width + 28, self.messageLabel.frame.size.height + 10);
    NSLog(@"Label width: %f and label height: %f", self.messageLabel.frame.size.width, self.messageLabel.frame.size.height);
    NSLog(@"Bubble width: %f and bubble height: %f", bubbleImageSize.width, bubbleImageSize.height);
    UIImageView *bubbleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"outgoing-message-bubble.pdf"]];
    [bubbleImage setFrame:CGRectMake(self.contentView.frame.size.width - bubbleImageSize.width - 10, self.contentView.frame.size.height - bubbleImageSize.height, bubbleImageSize.width, bubbleImageSize.height)];
    NSLog(@"cell.contentView width: %f and cell.contentView height: %f", self.contentView.frame.size.width, self.contentView.frame.size.height);
    NSLog(@"cell self width: %f and cell self height: %f", self.frame.size.width, self.frame.size.height);
    NSLog(@"Bubble xcoord: %f and bubble ycoord: %f", bubbleImage.frame.origin.x, bubbleImage.frame.origin.y);
    [bubbleImage.image resizableImageWithCapInsets:UIEdgeInsetsMake(17, 21, 17, 21) resizingMode:UIImageResizingModeStretch];
    [bubbleImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self addSubview:bubbleImage];
    [self addSubview:self.messageLabel];
    self.messageLabel.center = bubbleImage.center;
    NSLog(@"Label xcoord: %f and label ycoord: %f", self.messageLabel.frame.origin.x, self.messageLabel.frame.origin.y);
}
@end
