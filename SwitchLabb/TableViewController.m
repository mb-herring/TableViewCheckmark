//
//  TableViewController.m
//  TableViewCheckMark
//
//  Created by Martin Borstrand on 2015-05-14.
//  Copyright (c) 2015 Martin Borstrand. All rights reserved.
//

#import "TableViewController.h"
#import "TestTableViewCell.h"

#define KHEADERLABELTAG 2002
#define KFOOTERLABELTAG 2002

#define kTextFieldTag 1000;

#define HEADERCOLOR        [UIColor colorWithRed: 126.0/255.0    green: 130.0/255.0    blue: 139.0/255.0     alpha: 1.0]
#define GREENCOLOR         [UIColor colorWithRed: 0.0/255.0      green: 209.0/255.0    blue: 130.0/255.0     alpha: 1.0]
#define TEXTCOLOR          [UIColor colorWithRed: 30.0/255.0     green: 30.0/255.0     blue: 30.0/255.0      alpha: 1.0]
#define BGRCOLOR           [UIColor colorWithRed: 244.0/255.0    green: 244.0/255.0    blue: 244.0/255.0      alpha: 1.0]


static NSString *kCellID1       = @"Cell1";
static NSString *kCellID2       = @"Cell2";
static NSString *kCellID3       = @"Cell3";
static NSString *kHeaderCellID  = @"HeaderCell";
static NSString *kFooterCellID  = @"FooterCell";

@interface TableViewController ()

@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (nonatomic) UIImageView                   *checkmarkImage;
@property (nonatomic) UILabel                       *headerLabel;
@property (nonatomic) UILabel                       *footerLabel;
@property (nonatomic) TestTableViewCell             *tableviewCell;
@property (nonatomic) UIToolbar                     *keyboardToolbar;
@property (nonatomic) UIView                        *customNavbar;
@property (nonatomic) UIColor                       *navigationBarTintColor;
@property (nonatomic) UIColor                       *navigationTintColor;

@end

@implementation TableViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Save current colors
    self.navigationBarTintColor = self.navigationController.navigationBar.barTintColor; // Background color
    self.navigationTintColor = self.navigationController.navigationBar.tintColor; // Items color
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Get previous colors and set them
    self.navigationController.navigationBar.barTintColor = self.navigationBarTintColor;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
}

#pragma mark - GUI
- (void)setupInterface {
    
    self.title = @"KUPONGER";
    
    self.tableView.backgroundColor = BGRCOLOR;
    
    self.customNavbar = [[UIView alloc]init];
    self.customNavbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    self.customNavbar.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:209.0/255.0 blue:130.0/255.0 alpha:1];
    self.customNavbar.clipsToBounds = YES;
    self.customNavbar.alpha = 1.0;
    self.customNavbar.layer.shadowColor = [UIColor clearColor].CGColor;
    self.customNavbar.layer.shadowOffset = CGSizeMake(0.0f,0.5f);
    self.customNavbar.layer.masksToBounds = NO;
    self.customNavbar.layer.shadowRadius = 0.1f;
    self.customNavbar.layer.shadowOpacity = 1.0;
    [self.view addSubview:self.customNavbar];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"SPARA" style:UIBarButtonItemStylePlain target:self action:@selector(saveCheckmarkAndGoBack)];
    [saveButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Regular" size:12]} forState:UIControlStateNormal];

    NSArray *barbuttonItems = @[saveButton];
    
    self.navigationItem.rightBarButtonItems = barbuttonItems;
    
}

#pragma mark - UITableView Delegate / Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section == 0){
        return 1;
    }
    else if(section == 1){
        return 1;
    }
    else if(section == 2){
        return 11;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    
    UIImageView *checkmarkImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"py-icon-checkmark-yes"]];
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryView = checkmarkImage;
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            
            for (TestTableViewCell *cell in [self.tableView visibleCells]) {
                cell.amountTextField.text = @"";
            }
            
            [self.view endEditing:YES];
        }
    }
    else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
            [self textFieldShouldReturn];
        }
    }
    else if(indexPath.section == 2){
        
        for (TestTableViewCell *cell in [self.tableView visibleCells]) {
            cell.amountTextField.text = @"";
        }
        [self.view endEditing:YES];
    }
    
    NSLog(@"%s - Selected Cell: %lu in Section: %lu", __FUNCTION__, (long)indexPath.item, (long)indexPath.section);
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *checkmarkImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"py-icon-checkmark-no"]];

    [self.tableView cellForRowAtIndexPath:indexPath].accessoryView = checkmarkImage;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID;
    
    if(indexPath.section == 0){
        
        cellID = kCellID1;
    }
    else if(indexPath.section == 1){
        
        cellID = kCellID2;
    }
    else if(indexPath.section == 2){
        
        cellID = kCellID3;
    }
    
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *checkmarkImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"py-icon-checkmark-no"]];
    cell.accessoryView = checkmarkImage;

    
    cell.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Lato-Regular" size:11];
    cell.textLabel.textColor = TEXTCOLOR;
    cell.detailTextLabel.textColor = TEXTCOLOR;
    
    if(indexPath.section == 0){
        
        cell.textLabel.text = @"Obegränsat antal";
        cell.detailTextLabel.text = @"(1 PER PERSON)";
    }
    else if(indexPath.section == 1){
        
        cell.customTitleLabel.text = @"Välj antal";
        cell.customTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
        cell.customTitleLabel.textColor = TEXTCOLOR;

        cell.amountTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.amountTextField.tintColor = TEXTCOLOR;
        cell.amountTextField.placeholder = @"- ST";
        cell.amountTextField.tag = 1000;
        cell.amountTextField.font = [UIFont fontWithName:@"Montserrat-Regular" size:20];

        self.keyboardToolbar = [UIToolbar new];
        self.keyboardToolbar.barStyle = UIBarStyleDefault;
        self.keyboardToolbar.tintColor = [UIColor whiteColor];
        self.keyboardToolbar.barTintColor = GREENCOLOR;
        self.keyboardToolbar.translucent = NO;
        self.keyboardToolbar.clipsToBounds = YES;

        [self.keyboardToolbar sizeToFit];
        
        UIBarButtonItem *minusButton    = [[UIBarButtonItem alloc] initWithTitle:@"-"       style:UIBarButtonItemStylePlain target:self action:nil];
        UIBarButtonItem *plusButton     = [[UIBarButtonItem alloc] initWithTitle:@"+"       style:UIBarButtonItemStylePlain target:self action:nil];
        UIBarButtonItem *doneBarButton  = [[UIBarButtonItem alloc] initWithTitle:@"KLAR"    style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClickedInToolbar)];
        UIBarButtonItem *flexSpace      = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace   target:self action:nil];
        UIBarButtonItem *fixedSpace     = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace      target:self action:nil];
        fixedSpace.width = 3.0;
        
        [doneBarButton  setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Regular" size:14]} forState:UIControlStateNormal];
        [minusButton    setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Regular" size:14]} forState:UIControlStateNormal];
        [plusButton     setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Regular" size:14]} forState:UIControlStateNormal];
        
        NSArray *array = [NSArray arrayWithObjects:fixedSpace, minusButton, flexSpace, doneBarButton, flexSpace, plusButton, fixedSpace, nil];
        [self.keyboardToolbar setItems:array];
        
        cell.amountTextField.inputAccessoryView = self.keyboardToolbar;
    }
    else if(indexPath.section == 2){
        
        cell.textLabel.text = [NSString stringWithFormat:@"%lu ST", 10 + indexPath.row * 20];
    }
    
    // cell.textLabel.text = [NSString stringWithFormat:@"Section: %lu - Row: %lu", indexPath.section, indexPath.item + 1];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

#pragma mark - UITableView HeaderInSection
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:kHeaderCellID];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    
    self.headerLabel = (UILabel *)[headerView viewWithTag:KHEADERLABELTAG];
    [self.headerLabel setTextAlignment:NSTextAlignmentLeft];
    [self.headerLabel setTextColor:HEADERCOLOR];
    [self.headerLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    
    if(section == 0){
    
        [self.headerLabel setText:@"OBEGRÄNSAT"];
    }
    else if(section == 1){
        
        [self.headerLabel setText:@"VALFRITT ANTAL"];
    }
    else if(section == 2){
        
        [self.headerLabel setText:@"FÖRSLAG"];
    }
    
    headerView.backgroundColor = [UIColor clearColor]; // [UIColor clearColor];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    if(section == 0){
        return 44;
    }
    else if(section == 1){
        
        return 44;
    }
    else if(section == 2){
        return 44;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UITableViewCell *footerView = [tableView dequeueReusableCellWithIdentifier:kFooterCellID];
    if (footerView == nil){
        [NSException raise:@"footerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    
    self.footerLabel = (UILabel *)[footerView viewWithTag:KFOOTERLABELTAG];
    [self.footerLabel setTextAlignment:NSTextAlignmentLeft];
    [self.footerLabel setTextColor:HEADERCOLOR];
    [self.footerLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:11]];
    
    if(section == 0){
        
        [self.footerLabel setText:@"En kupong per person. Annonsen ligger kvar tills giltighetstiden gått ut eller till att du väljer att stoppa annonsen."];
        self.footerLabel.numberOfLines = 3;
    }
    else if(section == 1){
        
        [self.footerLabel setText:@""];
    }
    else if(section == 2){
        
        [self.footerLabel setText:@""];
    }
    
    footerView.backgroundColor = [UIColor clearColor]; // [UIColor clearColor];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if(section == 0){
        return 60;
    }
    else if(section == 1){
        
        return 0;
    }
    else if(section == 2){
        return 0;
    }
    return 0;
}

#pragma mark - Methods
- (void)doneButtonClickedInToolbar
{
    
    [self.view endEditing:YES]; // resignFirstResponder];
    
    NSLog(@"%s - Close Keybord", __FUNCTION__);
}

- (BOOL)textFieldShouldReturn
{
    UITextField *textField;
    
    TestTableViewCell * currentCell = (TestTableViewCell *) textField.superview.superview;
    NSIndexPath * currentIndexPath = [self.tableView indexPathForCell:currentCell];
    
    NSIndexPath * nextIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row + 0 inSection:1];
    TestTableViewCell * nextCell = (TestTableViewCell *) [self.tableView cellForRowAtIndexPath:nextIndexPath];
    
    [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [nextCell.amountTextField becomeFirstResponder];
    
    return YES;
}

- (void)saveCheckmarkAndGoBack {
    
    NSLog(@"%s", __FUNCTION__);
}


#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
