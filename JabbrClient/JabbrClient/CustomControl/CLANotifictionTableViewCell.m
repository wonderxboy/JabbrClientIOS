//
//  CLANotifictionTableViewCell.m
//  Collara
//
//  Created by Sean on 04/07/15.
//  Copyright (c) 2015 Collara. All rights reserved.
//

#import "CLANotifictionTableViewCell.h"

#import "Constants.h"
#import "DateTools.h"
#import "Masonry.h"
#import <JSQMessagesViewController/JSQMessages.h>

@interface CLANotifictionTableViewCell()

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *message;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIImageView *unreadImageView;
@end

@implementation CLANotifictionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setNotification:(CLANotificationMessage *)notification {
    _notification = notification;
    self.title.text = [NSString stringWithFormat:@"%@%@ %@%@  %@",
                       kUserPrefix,
                       self.notification.fromUserName,
                       kRoomPrefix,
                       self.notification.roomName,
                       self.notification.when.timeAgoSinceNow];
    
    self.message.text = self.notification.message;
    
    self.unreadImageView.hidden = [self.notification.read isEqualToNumber:@1];
    
    JSQMessagesAvatarImage *jSQMessagesAvatarImage =
    [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:[[self.notification.fromUserName substringToIndex:1] capitalizedString]
                                               backgroundColor:[Constants mainThemeContrastColor]
                                                     textColor:[UIColor whiteColor]
                                                          font:[UIFont systemFontOfSize:13.0f]
                                                      diameter:30.0f];
    
    
    self.avatarImageView = [[UIImageView alloc] initWithImage:jSQMessagesAvatarImage.avatarImage];
    
    [self.contentView addSubview:self.avatarImageView];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title = [[UILabel alloc] init];
        self.title.numberOfLines = 1;
        self.title.textAlignment = NSTextAlignmentRight;
        self.title.textColor = [UIColor grayColor];
        self.title.font = [self.title.font fontWithSize:10];
        
        self.message = [[UILabel alloc] init];
        self.message.numberOfLines = 1;
        self.message.textAlignment = NSTextAlignmentLeft;
        self.message.textColor = [UIColor grayColor];
        
        self.unreadImageView = [[UIImageView alloc] initWithImage:[Constants unreadIcon]];
        
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.message];
        [self.contentView addSubview:self.unreadImageView];
    }
    
    return self;
}

- (void)updateConstraints
{
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [self.unreadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-20);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(10);
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.height.equalTo(@10);
    }];
    
    [self.message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(10);
        make.top.equalTo(self.contentView.mas_top).with.offset(30);
        make.right.equalTo(self.contentView.mas_right).with.offset(-30);
        make.height.equalTo(@18);
    }];

    [super updateConstraints];
}

@end
