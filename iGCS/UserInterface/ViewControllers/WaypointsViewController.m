//
//  WaypointsViewController.m
//  iGCS
//
//  Created by Claudio Natoli on 18/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WaypointsViewController.h"
#import "WaypointHelper.h"

@interface WaypointsViewController ()

@end

@implementation WaypointsViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        waypoints = [[WaypointsHolder alloc] initWithExpectedCount:0];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    
    // Release any cached data, images, etc that aren't in use.
#if DO_NSLOG
    if ([self isViewLoaded]) {
        NSLog(@"\t\tWaypointsViewController::didReceiveMemoryWarning: view is still loaded");
    } else {
        NSLog(@"\t\tWaypointsViewController::didReceiveMemoryWarning: view is NOT loaded");
    }
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return [waypoints numWaypoints];
    return 0;
}

#define TABLE_HEADER_FONT_SIZE 14

#define TABLE_CELL_CMD_FONT_SIZE 16
#define TABLE_CELL_FONT_SIZE   12

static unsigned int CELL_WIDTHS[] = {    
    65,                 // row #
    170,                // command
    80, 80, 110,        // x, y, z
    80, 80, 80, 110,    // param1-4
    100                  // autocontinue
};

static NSString* CELL_HEADERS[] = {
    @" Row #",
    @"Command",
    @"X", @"Y", @"Z",
    @"Param1", @"Param2", @"Param3", @"Param4",
    @"Autocontinue"
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WaypointCellID";    
    int TAG_INDEX = 100;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // FIXME: outside the above "if (cell == nil)..." because it seems cells are already pre-created. Why? Precreated in nib?
    if ([cell viewWithTag:TAG_INDEX] == NULL) {        
        unsigned int x = 0;
        for (unsigned int i = 0; i < sizeof(CELL_WIDTHS)/sizeof(unsigned int); i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, CELL_WIDTHS[i], tableView.rowHeight)];
            x += CELL_WIDTHS[i];
            label.tag = TAG_INDEX+i;
            //
            label.font = [UIFont systemFontOfSize:TABLE_CELL_FONT_SIZE];
            label.textAlignment = UITextAlignmentLeft;
            label.textColor = [UIColor blackColor];
            label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
            //
            [cell.contentView addSubview:label];
        }
    }
    
    mavlink_mission_item_t waypoint = [waypoints getWaypoint: indexPath.row];
    
    // Row number
    UILabel *label = (UILabel*)[cell viewWithTag:TAG_INDEX++];
    label.text = [NSString stringWithFormat:@"  %d:", indexPath.row];

    // Command
    label = (UILabel*)[cell viewWithTag:TAG_INDEX++];
    label.font = [UIFont systemFontOfSize:TABLE_CELL_CMD_FONT_SIZE];
    label.text = [NSString stringWithFormat:@"%@", [WaypointHelper commandIDToString: waypoint.command]];
    
    // X
    label = (UILabel*)[cell.contentView viewWithTag:TAG_INDEX++];
    label.text = [NSString stringWithFormat:@"%f", waypoint.x];
    
    // Y
    label = (UILabel*)[cell.contentView viewWithTag:TAG_INDEX++];
    label.text = [NSString stringWithFormat:@"%f", waypoint.y];
    
    // Z
    label = (UILabel*)[cell.contentView viewWithTag:TAG_INDEX++];
    label.text = [NSString stringWithFormat:@"%f", waypoint.z];

    // param1
    label = (UILabel*)[cell.contentView viewWithTag:TAG_INDEX++];
    label.text = (waypoint.param1 == 0) ? @"0" : [NSString stringWithFormat:@"%f", waypoint.param1];
    
    // param2
    label = (UILabel*)[cell.contentView viewWithTag:TAG_INDEX++];
    label.text = (waypoint.param2 == 0) ? @"0" : [NSString stringWithFormat:@"%f", waypoint.param2];
    
    // param3
    label = (UILabel*)[cell.contentView viewWithTag:TAG_INDEX++];
    label.text = (waypoint.param3 == 0) ? @"0" : [NSString stringWithFormat:@"%f", waypoint.param3];
    
    // param4
    label = (UILabel*)[cell.contentView viewWithTag:TAG_INDEX++];
    label.text = (waypoint.param4 == 0) ? @"0" : [NSString stringWithFormat:@"%f", waypoint.param4];

    // autocontinue
    label = (UILabel*)[cell.contentView viewWithTag:TAG_INDEX++];
    label.text = [NSString stringWithFormat:@"%@", waypoint.autocontinue ? @"Yes" : @"No"];
    
/*
    // Seq
    label = (UILabel*)[cell.contentView viewWithTag:TAG_INDEX++];
    label.text = [NSString stringWithFormat:@"%d", waypoint.seq];

    // current
    label = (UILabel*)[cell.contentView viewWithTag:TAG_INDEX++];
    label.text = [NSString stringWithFormat:@"%d", waypoint.current];
*/
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView* sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0,0,1024,40)];
    sectionHead.tag = section;
    sectionHead.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    sectionHead.userInteractionEnabled = YES;    
    
    unsigned int x = 0;
    for (unsigned int i = 0; i < sizeof(CELL_WIDTHS)/sizeof(unsigned int); i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, CELL_WIDTHS[i], 40)];
        x += CELL_WIDTHS[i];
        //
        label.text = CELL_HEADERS[i];
        //
        label.font = [UIFont boldSystemFontOfSize:TABLE_HEADER_FONT_SIZE];
        label.textAlignment = UITextAlignmentLeft;
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        //
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor darkGrayColor];
        label.shadowOffset = CGSizeMake(0,1);
        //
        [sectionHead addSubview:label];
    }
    
    return sectionHead;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void) updateWaypoints:(WaypointsHolder*)_waypoints {
    waypoints = _waypoints;
    [[self tableView] reloadData];
}

- (void) handlePacket:(mavlink_message_t*)msg {
}

@end
