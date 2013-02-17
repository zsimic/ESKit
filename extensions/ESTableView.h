// ESTableView - Table View with a customizable background image
// Created by Zoran Simic on 3/26/10. Copyright 2010 esmiler.com. All rights reserved.

#import <UIKit/UIKit.h>


@interface ESTableView : UITableView {
	UIImage *backgroundImage;
}

@property (nonatomic, retain) UIImage *backgroundImage;

@end
