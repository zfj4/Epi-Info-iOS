//
//  DataEntryViewController.h
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

#import <UIKit/UIKit.h>
#import "LegalValues.h"
#import "EnterDataView.h"
#import "EpiInfoLineListView.h"
#import "BlurryView.h"
#import "FeedbackView.h"
#import "Reachability.h"
#import "sqlite3.h"
#import <CoreImage/CoreImage.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@interface DataEntryViewController : UIViewController <MFMailComposeViewControllerDelegate, UITextFieldDelegate>
{
    UIButton *customBackButton;
    
    UIImageView *fadingColorView;
    UILabel *pickerLabel;
    LegalValues *lv;
    UIButton *openButton;
    UIButton *manageButton;
    UITextField *lvSelected;
    
    EnterDataView *edv;
    UIView *orangeBanner;
    UIView *orangeBannerBackground;
    
    UIView *dismissView;
    
    sqlite3 *epiinfoDB;
    
    BOOL mailComposerShown;
  
  int recordsToBeWrittenToPackageFile;
}
@property NSMutableDictionary *legalValuesDictionary;
-(void)populateFieldsWithRecord:(NSArray *)tableNameAndGUID;
-(UIImageView *)backgroundImage;
@end
