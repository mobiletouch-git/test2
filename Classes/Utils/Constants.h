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

#define definedColor ([UIColor colorWithRed:0.149 green:0.435 blue:0.118 alpha:1.0])


#define remoteServer @"http://api.mobiletouch.ro/0.1/checker"

#define kCancel @"Anulați"
#define kOrder @"Ordonați"
#define kEdit @"Editați"
#define kSave @"Salvați"
#define kDone @"OK"
#define kOk @"OK"
#define kAddNewCurrency @"Adăugați monedă"
#define kAdd @"Adaugă"
#define kDelete @"Ștergeți"
#define kUpdate @"Actualizează"
#define kAddNewTax @"Adăugați procent"
#define kStartDateTitle @"Data de Start"
#define kStartDateNotice @"Alegeți data de start pentru graficul care urmează a fi generat."
#define kEndDateTitle @"Data de Final"
#define kEndDateNotice @"Alegeți data de final pentru graficul care urmează a fi generat."

#define kAdWhirlApplicationKey @"96c35b3ea0af459caa2e8eefce81d075"
#if defined(CONVERTOR)	
	#define kTopPadding 50
#else
	#define kTopPadding 0
#endif	

