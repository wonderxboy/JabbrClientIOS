//
//  CLAMessage.h
//  JabbrClient
//
//  Created by Sean on 07/04/15.
//  Copyright (c) 2015 Colla. All rights reserved.
//

#import <Foundation/Foundation.h>

//Util
#import "ObjectiveCGenerics.h"

//JSQ
#import "JSQMessageData.h"

GENERICSABLE(CLAMessage)

/**
 *  The `CLAMessage` class is a concrete class for message model objects that represents a single user message.
 *  The message can be a text message or media message, depending on how it is initialized.
 *  It implements the `JSQMessageData` protocol and it contains the senderId, senderDisplayName,
 *  and the date that the message was sent. If initialized as a media message it also contains a media attachment,
 *  otherwise it contains the message text.
 */
@interface CLAMessage : NSObject <JSQMessageData, NSCoding, NSCopying, CLAMessage>


@property (copy, nonatomic) NSString *oId;

/**
 *  Returns the string identifier that uniquely identifies the user who sent the message.
 */
@property (copy, nonatomic, readonly) NSString *senderId;

/**
 *  Returns the display name for the user who sent the message. This value does not have to be unique.
 */
@property (copy, nonatomic, readonly) NSString *senderDisplayName;

/**
 *  Returns the date that the message was sent.
 */
@property (copy, nonatomic, readonly) NSDate *date;

/**
 *  Returns a boolean value specifying whether or not the message contains media.
 *  If `NO`, the message contains text. If `YES`, the message contains media.
 *  The value of this property depends on how the object was initialized.
 */
@property (assign, nonatomic, readonly) BOOL isMediaMessage;

/**
 *  Returns the body text of the message, or `nil` if the message is a media message.
 *  That is, if `isMediaMessage` is equal to `YES` then this value will be `nil`.
 */
@property (copy, nonatomic, readonly) NSString *text;

/**
 *  Returns the media item attachment of the message, or `nil` if the message is not a media message.
 *  That is, if `isMediaMessage` is equal to `NO` then this value will be `nil`.
 */
@property (copy, nonatomic, readonly) id<JSQMessageMediaData> media;


#pragma mark - Initialization

/**
 *  Initializes and returns a message object having the given senderId, displayName, text,
 *  and current system date.
 *
 *  @param senderId    The unique identifier for the user who sent the message. This value must not be `nil`.
 *  @param displayName The display name for the user who sent the message. This value must not be `nil`.
 *  @param text        The body text of the message. This value must not be `nil`.
 *
 *  @discussion Initializing a `JSQMessage` with this method will set `isMediaMessage` to `NO`.
 *
 *  @return An initialized `JSQMessage` object if successful, `nil` otherwise.
 */
+ (instancetype)messageWithOId:(NSString *)oId
                           SenderId:(NSString *)senderId
                        displayName:(NSString *)displayName
                               text:(NSString *)text;

/**
 *  Initializes and returns a message object having the given senderId, senderDisplayName, date, and text.
 *
 *  @param senderId          The unique identifier for the user who sent the message. This value must not be `nil`.
 *  @param senderDisplayName The display name for the user who sent the message. This value must not be `nil`.
 *  @param date              The date that the message was sent. This value must not be `nil`.
 *  @param text              The body text of the message. This value must not be `nil`.
 *
 *  @discussion Initializing a `JSQMessage` with this method will set `isMediaMessage` to `NO`.
 *
 *  @return An initialized `JSQMessage` object if successful, `nil` otherwise.
 */
- (instancetype)initWithOId:(NSString *)oId
                   SenderId:(NSString *)senderId
               senderDisplayName:(NSString *)senderDisplayName
                            date:(NSDate *)date
                            text:(NSString *)text;
/**
 *  Initializes and returns a message object having the given senderId, displayName, media,
 *  and current system date.
 *
 *  @param senderId    The unique identifier for the user who sent the message. This value must not be `nil`.
 *  @param displayName The display name for the user who sent the message. This value must not be `nil`.
 *  @param media       The media data for the message. This value must not be `nil`.
 *
 *  @discussion Initializing a `JSQMessage` with this method will set `isMediaMessage` to `YES`.
 *
 *  @return An initialized `JSQMessage` object if successful, `nil` otherwise.
 */
+ (instancetype)messageWithOId:(NSString *)oId
                      SenderId:(NSString *)senderId
                        displayName:(NSString *)displayName
                              media:(id<JSQMessageMediaData>)media;

/**
 *  Initializes and returns a message object having the given senderId, displayName, date, and media.
 *
 *  @param senderId          The unique identifier for the user who sent the message. This value must not be `nil`.
 *  @param senderDisplayName The display name for the user who sent the message. This value must not be `nil`.
 *  @param date              The date that the message was sent. This value must not be `nil`.
 *  @param media             The media data for the message. This value must not be `nil`.
 *
 *  @discussion Initializing a `JSQMessage` with this method will set `isMediaMessage` to `YES`.
 *
 *  @return An initialized `JSQMessage` object if successful, `nil` otherwise.
 */
- (instancetype)initWithOId:(NSString *)oId
                   SenderId:(NSString *)senderId
               senderDisplayName:(NSString *)senderDisplayName
                            date:(NSDate *)date
                           media:(id<JSQMessageMediaData>)media;

@end
