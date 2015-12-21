//
//  CLAHomeViewController.h
//  Collara
//
//  Created by Sean on 13/05/15.
//  Copyright (c) 2015 Collara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"
#import "CLATopicDataSourceEventDelegate.h"

@interface CLAHomeTopicViewController : UIViewController <XLPagerTabStripChildItem, UISearchBarDelegate, CLATopicDataSourceEventDelegate>

@end
