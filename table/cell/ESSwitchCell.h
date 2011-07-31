//
//  ESSwitchCell.h
//  
//
//  Created by Zoran Simic on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "esmiler.h"

@interface ESSwitchCell : UITableViewCell {
	UISwitch *switchView;				// Switch shown in this cell
}

@property (nonatomic, assign) BOOL on;

+ (ESSwitchCell *)getCell:(UITableView *)ptable;
 
@end
