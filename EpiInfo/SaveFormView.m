//
//  SaveFormView.m
//  EpiInfo
//
//  Created by John Copeland on 12/3/13.
//

#import "SaveFormView.h"

@implementation SaveFormView
@synthesize url = _url;
@synthesize rootViewController = _rootViewController;
@synthesize formView = _formView;
@synthesize formName = _formName;
@synthesize cloudDataType = _cloudDataType;
@synthesize cloudDataBase = _cloudDataBase;
@synthesize cloudDataKey = _cloudDataKey;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if (frame.size.height < 500.0)
            [imageBackground setImage:[UIImage imageNamed:@"iPhone4Background.png"]];
        else
            [imageBackground setImage:[UIImage imageNamed:@"iPhone5Background.png"]];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [imageBackground setImage:[UIImage imageNamed:@"iPadBackground.png"]];
        [self addSubview:imageBackground];
        
        UILabel *fakeNavBar = [[UILabel alloc] initWithFrame:CGRectMake(0, -40, 320, 40)];
        [fakeNavBar setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [fakeNavBar setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0]];
        [fakeNavBar setTextAlignment:NSTextAlignmentCenter];
        [fakeNavBar setTextColor:[UIColor whiteColor]];
        [fakeNavBar setText:@"Save Epi Info Form"];
        [self addSubview:fakeNavBar];
        
        UILabel *typeFormNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 28)];
        [typeFormNameLabel setTextColor:[UIColor whiteColor]];
        [typeFormNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [typeFormNameLabel setText:@"Form name:"];
        [typeFormNameLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:typeFormNameLabel];

        typeFormName = [[UITextField alloc] initWithFrame:CGRectMake(20, 48, 280, 40)];
        [typeFormName setBorderStyle:UITextBorderStyleRoundedRect];
        [typeFormName setReturnKeyType:UIReturnKeyDone];
        [typeFormName setDelegate:self];
        [self addSubview:typeFormName];
        
        UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(198, frame.size.height - 42, 120, 40)];
        [saveButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [saveButton.layer setCornerRadius:4.0];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton setImage:[UIImage imageNamed:@"SaveButton.png"] forState:UIControlStateNormal];
        [saveButton.layer setMasksToBounds:YES];
        [saveButton.layer setCornerRadius:4.0];
        [saveButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saveButton];
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(2, frame.size.height - 42, 120, 40)];
        [cancelButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [cancelButton.layer setCornerRadius:4.0];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
        [cancelButton.layer setMasksToBounds:YES];
        [cancelButton.layer setCornerRadius:4.0];
        [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame AndRootViewController:(UIViewController *)rvc AndFormView:(UIView *)fv AndFormName:(NSString *)fn AndURL:(NSURL *)url
{
    self = [self initWithFrame:frame];
    if (self)
    {
        [self setRootViewController:rvc];
        [self setFormView:fv];
        [self setFormName:fn];
        [self setUrl:url];
        [typeFormName setText:self.formName];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] withIntermediateDirectories:NO attributes:nil error:nil];
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
        {
            int selectedindex = 0;
            NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] error:nil];
            NSMutableArray *pickerFiles = [[NSMutableArray alloc] init];
            [pickerFiles addObject:@""];
            int count = 0;
            for (id i in files)
            {
                count++;
                [pickerFiles addObject:[(NSString *)i substringToIndex:[(NSString *)i length] - 4]];
                if ([[pickerFiles objectAtIndex:count] isEqualToString:typeFormName.text])
                    selectedindex = count;
            }
            UILabel *pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 28)];
            [pickerLabel setTextColor:[UIColor whiteColor]];
            [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [pickerLabel setText:@"Existing forms:"];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            
            LegalValues *lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, 100, 300, 180) AndListOfValues:pickerFiles AndTextFieldToUpdate:typeFormName];
            [lv.picker selectRow:selectedindex inComponent:0 animated:YES];
            [self addSubview:lv];
            
            [self addSubview:pickerLabel];
        }
        UILabel *repositoriesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 260, 280, 28)];
        [repositoriesLabel setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [repositoriesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [repositoriesLabel setText:@"Cloud repositories:"];
        [repositoriesLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:repositoriesLabel];
        
        UIView *repositoryButtonsView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 290, self.frame.size.width, 80)];
        [repositoryButtonsView0 setBackgroundColor:[UIColor clearColor]];
        [self addSubview:repositoryButtonsView0];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            UIButton *msAzureButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 60, 60)];
            [msAzureButton setBackgroundImage:[UIImage imageNamed:@"MSAzureBluePhone.png"] forState:UIControlStateNormal];
            [msAzureButton addTarget:self action:@selector(msButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [msAzureButton setClipsToBounds:YES];
            [msAzureButton.layer setCornerRadius:10.0];
            [repositoryButtonsView0 addSubview:msAzureButton];
        }
        else
        {
            [repositoryButtonsView0 setFrame:CGRectMake(0, 290, self.frame.size.width, 96)];
            UIButton *msAzureButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 76, 76)];
            if ([[UIScreen mainScreen] scale] > 1.0)
                [msAzureButton setBackgroundImage:[UIImage imageNamed:@"MSAzureBlue.png"] forState:UIControlStateNormal];
            else
                [msAzureButton setBackgroundImage:[UIImage imageNamed:@"MSAzureBlueNR.png"] forState:UIControlStateNormal];
            [msAzureButton addTarget:self action:@selector(msButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [msAzureButton setClipsToBounds:YES];
            [msAzureButton.layer setCornerRadius:10.0];
            [repositoryButtonsView0 addSubview:msAzureButton];
        }
    }
    return self;
}

- (void)msButtonPressed
{
    [self setCloudDataType:@"MSAzure"];
    
    float ratio = 60.0 / 320.0;
    msAzureCredsView = [[UIView alloc] initWithFrame:CGRectMake(20, 290, 60, 60)];
    
    UIImageView *msAzureCredsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    if (self.frame.size.height < 500.0)
        [msAzureCredsImageView setImage:[UIImage imageNamed:@"iPhone4Background.png"]];
    else
        [msAzureCredsImageView setImage:[UIImage imageNamed:@"iPhone5Background.png"]];
    [msAzureCredsView addSubview:msAzureCredsImageView];
    
    UILabel *applicationURLLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * ratio, 20 * ratio, 280 * ratio, 28 * ratio)];
    [applicationURLLabel setTextColor:[UIColor whiteColor]];
    [applicationURLLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [applicationURLLabel setText:@"Application URL:"];
    [applicationURLLabel setBackgroundColor:[UIColor clearColor]];
    [msAzureCredsView addSubview:applicationURLLabel];
    
    EpiInfoTextField *applicationURL = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(20 * ratio, 48 * ratio, 280 * ratio, 40 * ratio)];
    [applicationURL setBorderStyle:UITextBorderStyleRoundedRect];
    [applicationURL setReturnKeyType:UIReturnKeyDone];
    [applicationURL setDelegate:self];
    [applicationURL setColumnName:@"cloudDataBase"];
    [msAzureCredsView addSubview:applicationURL];
    
    UILabel *applicationKeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * ratio, 90 * ratio, 280 * ratio, 28 * ratio)];
    [applicationKeyLabel setTextColor:[UIColor whiteColor]];
    [applicationKeyLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [applicationKeyLabel setText:@"Application Key:"];
    [applicationKeyLabel setBackgroundColor:[UIColor clearColor]];
    [msAzureCredsView addSubview:applicationKeyLabel];
    
    EpiInfoTextField *applicationKey = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(20 * ratio, 118 * ratio, 280 * ratio, 40 * ratio)];
    [applicationKey setBorderStyle:UITextBorderStyleRoundedRect];
    [applicationKey setReturnKeyType:UIReturnKeyDone];
    [applicationKey setDelegate:self];
    [applicationKey setColumnName:@"cloudDataKey"];
    [msAzureCredsView addSubview:applicationKey];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        ratio = 76.0 / self.frame.size.width;
        [msAzureCredsView setFrame:CGRectMake(20, 290, 76, 76)];
        [msAzureCredsImageView setFrame:CGRectMake(0, 0, 76, 76)];
        [msAzureCredsImageView setImage:[UIImage imageNamed:@"iPadBackground.png"]];
    }

    [self addSubview:msAzureCredsView];

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [msAzureCredsView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [msAzureCredsImageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [applicationURLLabel setFrame:CGRectMake(20, 20, 280, 28)];
        [applicationURL setFrame:CGRectMake(20, 48, 280, 40)];
        [applicationKeyLabel setFrame:CGRectMake(20, 90, 280, 28)];
        [applicationKey setFrame:CGRectMake(20, 118, 280, 40)];
    } completion:^(BOOL finished){
        UIButton *xButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 32), 2, 30, 30)];
        [xButton setImage:[UIImage imageNamed:@"StAndrewXButtonWhite.png"] forState:UIControlStateNormal];
        [xButton addTarget:self action:@selector(msXButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [xButton.layer setMasksToBounds:YES];
        [xButton.layer setCornerRadius:8.0];
        [msAzureCredsView addSubview:xButton];
    }];
}
- (void)msXButtonPressed:(UIButton *)button
{
    [button removeFromSuperview];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [msAzureCredsView setFrame:CGRectMake(20, 290, 76, 76)];
            for (UIView *v in [msAzureCredsView subviews])
            {
                if ([v isKindOfClass:[UIImageView class]])
                    [v setFrame:CGRectMake(0, 0, 76, 76)];
                else
                    [v setFrame:CGRectMake(1, 30, 1, 1)];
            }
        }
        else
        {
            [msAzureCredsView setFrame:CGRectMake(20, 290, 60, 60)];
            for (UIView *v in [msAzureCredsView subviews])
            {
                if ([v isKindOfClass:[UIImageView class]])
                    [v setFrame:CGRectMake(0, 0, 60, 60)];
                else
                    [v setFrame:CGRectMake(1, 30, 1, 1)];
            }
        }
    } completion:^(BOOL finished){
        for (UIView *v in [msAzureCredsView subviews])
        {
            if ([v isKindOfClass:[EpiInfoTextField class]])
            {
                if ([[(EpiInfoTextField *)v columnName] isEqualToString:@"cloudDataBase"])
                    [self setCloudDataBase:[(EpiInfoTextField *)v text]];
                else if ([[(EpiInfoTextField *)v columnName] isEqualToString:@"cloudDataKey"])
                    [self setCloudDataKey:[(EpiInfoTextField *)v text]];
            }
        }

        [msAzureCredsView removeFromSuperview];
    }];
}

- (void)saveButtonPressed
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 0.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [self.formView removeFromSuperview];
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 1.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CATransform3D rotate = CATransform3DIdentity;
            rotate.m34 = 1.0 / -2000;
            rotate = CATransform3DRotate(rotate, M_PI * 0.0, 0.0, 1.0, 0.0);
            [self.rootViewController.view.layer setTransform:CATransform3DIdentity];
        } completion:^(BOOL finished){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]] && typeFormName.text.length > 0)
            {
                NSString *filePathAndName = [[[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] stringByAppendingString:@"/"] stringByAppendingString:typeFormName.text] stringByAppendingString:@".xml"];
                if ([[NSFileManager defaultManager] fileExistsAtPath:filePathAndName])
                {
                    [[NSFileManager defaultManager] removeItemAtPath:filePathAndName error:nil];
                }
                NSString *xmlText = [NSString stringWithContentsOfFile:[NSString stringWithUTF8String:[self.url fileSystemRepresentation]] encoding:NSUTF8StringEncoding error:nil];
                [xmlText writeToFile:filePathAndName atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
                // Write the cloud info to the cloud database
                // Create the database if it doesn't exist
                if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase"]])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase"] withIntermediateDirectories:NO attributes:nil error:nil];
                }
                if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase"]])
                {
                    NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase/Clouds.db"];
                    
                    //Create the new table if necessary
                    int tableAlreadyExists = 0;
                    if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                    {
                        NSString *selStmt = @"select count(name) as n from sqlite_master where name = 'Clouds'";
                        const char *query_stmt = [selStmt UTF8String];
                        sqlite3_stmt *statement;
                        if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            if (sqlite3_step(statement) == SQLITE_ROW)
                                tableAlreadyExists = sqlite3_column_int(statement, 0);
                        }
                        sqlite3_finalize(statement);
                    }
                    sqlite3_close(epiinfoDB);
                    if (tableAlreadyExists < 1)
                    {
                        //Convert the databasePath NSString to a char array
                        const char *dbpath = [databasePath UTF8String];
                        
                        //Open sqlite3 analysisDB pointing to the databasePath
                        if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
                        {
                            char *errMsg;
                            //Build the CREATE TABLE statement
                            //Convert the sqlStmt to char array
                            NSString *createTableStatement = @"create table Clouds(FormName text, CloudDataType text, CloudDataBase text, CloudDataKey text)";
                            const char *sql_stmt = [createTableStatement UTF8String];
                            
                            //Execute the CREATE TABLE statement
                            if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                            {
                                NSLog(@"Failed to create table: %s :::: %@", errMsg, createTableStatement);
                            }
                            else
                            {
                                                    NSLog(@"Table created");
                            }
                            //Close the sqlite connection
                            sqlite3_close(epiinfoDB);
                        }
                        else
                        {
                            NSLog(@"Failed to open/create database");
                        }
                    }
                    
                    // Insert the row
                    tableAlreadyExists = 0;
                    if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                    {
                        NSString *selStmt = @"select count(name) as n from sqlite_master where name = 'Clouds'";
                        const char *query_stmt = [selStmt UTF8String];
                        sqlite3_stmt *statement;
                        if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            if (sqlite3_step(statement) == SQLITE_ROW)
                                tableAlreadyExists = sqlite3_column_int(statement, 0);
                        }
                        sqlite3_finalize(statement);
                    }
                    sqlite3_close(epiinfoDB);
                    if (tableAlreadyExists >= 1)
                    {
                        //Convert the databasePath NSString to a char array
                        const char *dbpath = [databasePath UTF8String];
                        
                        //Open sqlite3 analysisDB pointing to the databasePath
                        if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
                        {
                            char *errMsg;
                            NSString *insertStatement = [NSString stringWithFormat:@"delete from Clouds where FormName = '%@'", typeFormName.text];
                            const char *sql_stmt = [insertStatement UTF8String];
                            
                            //Execute the CREATE TABLE statement
                            if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                            {
                                NSLog(@"Failed to remove row from table: %s :::: %@", errMsg, insertStatement);
                            }
                            else
                            {
                                                    NSLog(@"Row removed");
                            }
                            insertStatement = [NSString stringWithFormat:@"insert into Clouds values('%@', '%@', '%@', '%@')", typeFormName.text, self.cloudDataType, self.cloudDataBase, self.cloudDataKey];
                            sql_stmt = [insertStatement UTF8String];
                            
                            //Execute the CREATE TABLE statement
                            if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                            {
                                NSLog(@"Failed to insert row into table: %s :::: %@", errMsg, insertStatement);
                            }
                            else
                            {
                                NSLog(@"Row inserted");
                            }
                            //Close the sqlite connection
                            sqlite3_close(epiinfoDB);
                        }
                        else
                        {
                            NSLog(@"Failed to open database or insert record");
                        }
                    }
                    else
                    {
                        NSLog(@"Could not find table");
                    }
                }
            }
        }];
    }];
}

- (void)cancelButtonPressed
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 1.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 0.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CATransform3D rotate = CATransform3DIdentity;
            rotate.m34 = 1.0 / -2000;
            rotate = CATransform3DRotate(rotate, M_PI * 0.0, 0.0, 1.0, 0.0);
            [self.rootViewController.view.layer setTransform:CATransform3DIdentity];
        } completion:^(BOOL finished){
        }];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
