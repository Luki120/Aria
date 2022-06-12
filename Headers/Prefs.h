#import "Headers/Constants.h"


// Aria Prysm

static BOOL isPrysmImage;

static float prysmAlpha;

static BOOL prysmGradients;
static BOOL prysmGradientAnimation;

static NSInteger prysmGradientDirection;


// Aria Stock

static BOOL giveMeTheImage;

static float alpha;

static BOOL giveMeThoseGradients;
static BOOL neatGradientAnimation;

static NSInteger gradientDirection;

static void loadWithoutAGoddamnRespring() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: kPATH];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];

	isPrysmImage = prefs[@"isPrysmImage"] ? [prefs[@"isPrysmImage"] boolValue] : NO;
	prysmAlpha = prefs[@"prysmAlpha"] ? [prefs[@"prysmAlpha"] floatValue] : 0.85f;
	prysmGradients = prefs[@"prysmGradients"] ? [prefs[@"prysmGradients"] boolValue] : NO;
	prysmGradientAnimation = prefs[@"prysmGradientAnimation"] ? [prefs[@"prysmGradientAnimation"] boolValue] : NO;
	prysmGradientDirection = prefs[@"prysmGradientDirection"] ? [prefs[@"prysmGradientDirection"] integerValue] : 0;

	giveMeTheImage = prefs[@"giveMeTheImage"] ? [prefs[@"giveMeTheImage"] boolValue] : NO;
	alpha = prefs[@"alpha"] ? [prefs[@"alpha"] floatValue] : 0.85f;
	giveMeThoseGradients = prefs[@"giveMeThoseGradients"] ? [prefs[@"giveMeThoseGradients"] boolValue] : NO;
	neatGradientAnimation = prefs[@"neatGradientAnimation"] ?  [prefs[@"neatGradientAnimation"] boolValue] : NO;
	gradientDirection = prefs[@"gradientDirection"] ? [prefs[@"gradientDirection"] integerValue] : 0;

}
