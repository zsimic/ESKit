//  ESSwitchCell - UITableViewCell with an on/off switch
//  Created by Zoran Simic on 11/9/09. Copyright 2009 esmiler.com. All rights reserved.

#import "ESSwitchCell.h"

@implementation ESSwitchCell

// Initialization
// --------------
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		switchView = [[UISwitch alloc] init];
		[self.contentView addSubview:switchView];
    }
    return self;
}

- (void)dealloc {
	ESRELEASE(switchView);
	[super dealloc];
}

+ (ESSwitchCell *)getCell:(UITableView *)ptable {
	static NSString *cellId = @"ESSwitchCell";
	ESSwitchCell *cell = (ESSwitchCell *)[ptable dequeueReusableCellWithIdentifier:cellId];
	if (cell == nil) {
		cell = ESAUTO([[ESSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId]);
    }
	return cell;
}

// Properties
// ----------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	// Configure the view for the selected state
}

- (BOOL)on {
	return switchView.selected;
}

- (void)setOn:(BOOL)pon {
	switchView.selected = pon;
}

// Composition
// -----------
- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect b = self.contentView.bounds;
	CGRect f = b;
	f.size.width = 40;
	f.size.height = 25;
	f.origin.x = b.size.width - f.size.width - 4;
	f.origin.y = (b.size.height - f.size.height) / 2;
	switchView.frame = f;
}

@end
