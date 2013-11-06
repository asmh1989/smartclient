//
//  EditViewController.m
//  SmartClient
//
//  Created by sun on 13-11-4.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "EditViewController.h"
#import "StringInputTableViewCell.h"

@interface EditViewController ()
{
    Finish action;
    NSArray *dataArray;
    int currentIndex;
    NSIndexPath *lastIndexPath;
}
@property (nonatomic) NSString *settingName;

@end

@implementation EditViewController

@synthesize settingName;
- (id)initWithTitleAndName:(NSString *)title Name:(NSString *)name Complete:(Finish)f EnumType:(enum CellType)type DataArray:(NSArray *)data
{
    self = [super init];
    if (self) {
        self.title = title;
        settingName = name;
        action = f;
        self.type = type;
        if (type == RadioCell) {
            if (!data) {
                dataArray = [UIFont familyNames];
            } else {
                dataArray = data;
            }
            int len = (int)[dataArray count];
            for (int i = 0; i < len; i++) {
                NSString *fontName = dataArray[i];
                if ([fontName isEqualToString:name]) {
                    currentIndex = i;
                    break;
                }
            }
        }
    }
    return self;
}

- (id)initWithTitleAndName:(NSString *)title Complete:(Finish)f EnumType:(enum CellType)type DataArray:(NSArray *)data FirstSelected:(int)select
{
    self = [super init];
    if (self) {
        self.title = title;
        action = f;
        self.type = type;
        currentIndex = select;
        settingName = nil;
        dataArray = data;
    }
    return self;
}

- (id)initWithTitleAndName:(NSString *)title Name:(NSString *)name Complete:(Finish)f EnumType:(enum CellType)type
{
    return [self initWithTitleAndName:title Name:name Complete:f EnumType:type DataArray:nil];
}
- (id)initWithTitleAndName:(NSString *)title Name:(NSString *)name Complete:(Finish)f
{
   return [self initWithTitleAndName:title Name:name Complete:f EnumType:EditCell];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSIndexPath*first = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    
    [self.tableView selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    action(textField.text);
    [[self navigationController] popViewControllerAnimated:YES];
	return YES;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (self.type) {
        case EditCell:
            return 1;
        case RadioCell:
        case RadioSoundCell:
            return [dataArray count];
    }
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == RadioCell || self.type == RadioSoundCell) {
        int newRow = [indexPath row];
        int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
        if(newRow != oldRow)
        {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:lastIndexPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            lastIndexPath = indexPath;
        }
        currentIndex = indexPath.row;
        if (!self.settingName) {
            action([NSString stringWithFormat:@"%d", currentIndex]);
            if (self.type == RadioSoundCell) {
                SystemSoundID soundID;
                NSString *soundFile = [[NSBundle mainBundle]pathForResource:dataArray[currentIndex] ofType:@"wav"];
                AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFile], &soundID);
                AudioServicesPlaySystemSound(soundID);
                
            }

        }else {
            action(dataArray[currentIndex]);
        }
        [[self navigationController] popViewControllerAnimated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if(self.type == EditCell){
        StringInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textField.delegate = self;
        cell.stringValue = settingName;
        return cell;
    } else if(self.type == RadioCell || self.type == RadioSoundCell){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [dataArray objectAtIndex:[indexPath row]];
        if (indexPath.row == currentIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            lastIndexPath = indexPath;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    
    return nil;
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
