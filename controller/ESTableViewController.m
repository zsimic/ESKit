//  ESTableViewController - Table view controller with a background image and easy to set colored header titles
//  Created by Zoran Simic on 3/27/10. Copyright 2010 esmiler.com. All rights reserved.

#import "ESTableViewController.h"
#import "ESHeaderView.h"

@implementation ESTableViewController

@synthesize headers;
@synthesize headerTextColor;
@synthesize headerFont;

// Initialization
// --------------
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		tableStyle = UITableViewStylePlain;
	}
	return self;
}

- (id)initWithStyle:(UITableViewStyle)pstyle {
	if ((self = [super initWithNibName:nil bundle:nil])) {
		tableStyle = pstyle;
	}
	return self;
}

- (void)dealloc {
	ESRELEASE(mainView);
	ESRELEASE(tbView);
	ESRELEASE(headers);
	ESRELEASE(headerTextColor);
	ESRELEASE(headerFont);
	ES_SUPER_DEALLOC
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	mainView = [[ESTexturedView alloc] initWithFrame:CGRectZero];
//	mainView.autoresizesSubviews = YES;
	self.view = mainView;
	tbView = [[UITableView alloc] initWithFrame:CGRectZero style:tableStyle];
	tbView.delegate = self;
	tbView.dataSource = self;
	mainView.view = tbView;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[mainView setContentOffset:tbView.contentOffset.y];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	ESRELEASE(mainView);
	ESRELEASE(tbView);
	ESRELEASE(headers);
	ESRELEASE(headerTextColor);
	ESRELEASE(headerFont);
}

// Properties
// ----------
- (UITableView *)tableView {
	return tbView;
}

- (void)setTableView:(UITableView *)pview {
	if (tbView!=pview) {
		ESRELEASE(tbView);
		tbView = ESRETAIN(pview);
	}
}

- (UIImage *)bgImage {
	return mainView.texture;
}

- (void)setBgImage:(UIImage *)pimage {
	mainView.texture = pimage;
	tbView.backgroundColor = [UIColor clearColor];
	[mainView setContentOffset:tbView.contentOffset.y];
}

- (void)setHeaders:(NSArray *)pheaders {
	if (headers!=pheaders) {
		ESRELEASE(headers);
		headers = ESRETAIN(pheaders);
		ESRELEASE(headerViews);
		if (headers!=nil) {
			headerViews = [[NSMutableArray alloc] initWithCapacity:headers.count];
			for	(NSString *pname in headers) {
				ESHeaderView *h = [[ESHeaderView alloc] init];
				h.yMargin = -2;
				h.text = pname;
				h.shadowOffset = CGSizeMake(1, 1);
				if (headerTextColor!=nil) h.textColor = headerTextColor;
				if (headerFont!=nil) h.label.font = headerFont;
				[headerViews addObject:h];
				ESRELEASE(h);
			}
			self.tableView.sectionHeaderHeight = 28;
			self.tableView.sectionFooterHeight = 4;
		} else {
			self.tableView.sectionHeaderHeight = 8;
			self.tableView.sectionFooterHeight = 1;
		}
	}
}

- (void)setHeaderTextColor:(UIColor *)pcolor {
	if (headerTextColor!=pcolor) {
		ESRELEASE(headerTextColor);
		headerTextColor = ESRETAIN(pcolor);
		if (pcolor!=nil) {
			for (ESHeaderView *pheader in headerViews) {
				pheader.textColor = pcolor;
			}
		}
	}
}

- (void)setHeaderFont:(UIFont *)pfont {
	if (headerFont!=pfont) {
		ESRELEASE(headerFont);
		headerFont = ESRETAIN(pfont);
		if (pfont!=nil) {
			for (ESHeaderView *pheader in headerViews) {
				pheader.label.font = pfont;
			}
		}
	}
}

// Table view
// ----------

// Table controller routines, you need to redefine those
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[mainView setContentOffset:scrollView.contentOffset.y];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (headerTextColor!=nil && headerFont!=nil && headerViews!=nil) {
		return (section==0) ? 29 : 26;
	} else {
		return (section==0) ? 28 : 25;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (headerTextColor!=nil && headerFont!=nil && headerViews!=nil) return nil;
	if (section<0 || section>=headers.count) return nil;
	return [headers objectAtIndex:section];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (headerTextColor!=nil && headerFont!=nil && headerViews!=nil && section>=0 && section<headerViews.count) {
		return [headerViews objectAtIndex:section];
	}
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

@end
