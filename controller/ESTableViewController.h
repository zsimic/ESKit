// ESTableViewController - Table view controller with a background image and easy to set colored header titles
// Created by Zoran Simic on 3/27/10. Copyright 2010 esmiler.com. All rights reserved.

#import <UIKit/UIKit.h>
#import "ESTexturedView.h"

@interface ESTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	ESTexturedView *mainView;
	UITableView *tbView;
	UITableViewStyle tableStyle;
	NSArray *headers;
	NSMutableArray *headerViews;
	UIColor *headerTextColor;
	UIFont *headerFont;
}

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, retain) UIImage *bgImage;
@property (nonatomic, retain) NSArray *headers;
@property (nonatomic, retain) UIColor *headerTextColor;
@property (nonatomic, retain) UIFont *headerFont;

- (id)initWithStyle:(UITableViewStyle)pstyle;

@end
