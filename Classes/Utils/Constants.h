/*
 *  Constants.h
 *  iTrafic
 */
#import "InfoValutarAppDelegate.h"


//appDelegate
#define  appDelegate  ((InfoValutarAppDelegate *)[[UIApplication sharedApplication] delegate])
//appDelegate

//over all color #87cefa
#define themeColor [UIColor colorWithRed:(CGFloat)0x66/255.0 green:(CGFloat)0x00/255.0 blue:(CGFloat)0x00/255.0 alpha:1.0]

//presenceColor #00923F
#define presenceColor [UIColor colorWithRed:(CGFloat)0x00/255.0 green:(CGFloat)0x92/255.0 blue:(CGFloat)0x3F/255.0 alpha:1.0]

//absenceColor #DB221A
#define absenceColor [UIColor colorWithRed:(CGFloat)0xDB/255.0 green:(CGFloat)0x22/255.0 blue:(CGFloat)0x1A/255.0 alpha:1.0]


//contentColor #CCCCCC
#define contentColor [UIColor colorWithRed:(CGFloat)0xCC/255.0 green:(CGFloat)0xCC/255.0 blue:(CGFloat)0xCC/255.0 alpha:1.0]

//veryLightGrayColor #FDFDFD
#define veryLightGrayColor [UIColor colorWithRed:(CGFloat)0xf3/255.0 green:(CGFloat)0xf3/255.0 blue:(CGFloat)0xf3/255.0 alpha:1.0]

//accelerometer

#define kAccelerometerFrequency			25 //Hz
#define kFilteringFactor				0.1
#define kMinEraseInterval				0.5
#define kEraseAccelerationThreshold		2.0

#define remoteServer @"http://api.mobiletouch.ro/0.1/checker"

#define kCancel @"Cancel"
#define kEdit @"Edit"
#define kSave @"Save"
#define kDone @"Done"
#define kOk @"OK"
#define kAddNewCurrency @"Adauga moneda"
#define kAdd @"Adauga"
#define kDelete @"Sterge"
#define kUpdate @"Update"
#define kAddNewTax @"Adauga taxa noua"
#define kStartDateTitle @"Data de Start"
#define kStartDateNotice @"Completati data de start pentru raportul care urmeaza a fi generat"
#define kEndDateTitle @"Data de Final"
#define kEndDateNotice @"Completati data de final pentru raportul care urmeaza a fi generat"

