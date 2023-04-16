#import "AriaImageManager.h"


@implementation AriaImageManager {

	UIViewController *rootViewController;

}

+ (AriaImageManager *)sharedInstance {

	static AriaImageManager *sharedInstance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{ sharedInstance = [[AriaImageManager alloc] initPrivate]; });

	return sharedInstance;

}


- (id)initPrivate {

	self = [super init];
	if(!self) return nil;

	rootViewController = [self getRootViewController];

	return self;

}


- (void)blurImage {

	__block id observer;

	UIImage *stockDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kStockDarkImage];
	UIImage *stockLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kStockLightImage];
	UIImage *prysmDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kPrysmDarkImage];
	UIImage *prysmLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kPrysmLightImage];

	UIImage *candidateImage;

	if(!kPrysmExists) candidateImage = kUserInterfaceStyle ? stockDarkImage : stockLightImage;
	else candidateImage = kUserInterfaceStyle ? prysmDarkImage : prysmLightImage;

	CIContext *context = [CIContext new];
	CIImage *inputImage = [[CIImage alloc] initWithImage: candidateImage];

	CIFilter *clampFilter = [CIFilter filterWithName: @"CIAffineClamp"];
	[clampFilter setDefaults];
	[clampFilter setValue:inputImage forKey: kCIInputImageKey];

	CIFilter *blurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
	[blurFilter setValue:clampFilter.outputImage forKey: kCIInputImageKey];

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Aria" message:@"How much blur intensity do you want?" preferredStyle: UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Blur" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		[blurFilter setValue:[NSNumber numberWithFloat:alertController.textFields.firstObject.text.doubleValue] forKey:@"inputRadius"];

		CIImage *result = [blurFilter valueForKey: kCIOutputImageKey];
		CGImageRef cgImage = [context createCGImage:result fromRect: inputImage.extent];
		UIImage *blurredImage = [[UIImage alloc] initWithCGImage:cgImage scale:candidateImage.scale orientation: UIImageOrientationUp];

		[self saveAriaImage: blurredImage];
		CGImageRelease(cgImage);

		[self presentSuccessAlertController];
		[NSNotificationCenter.defaultCenter removeObserver: observer];

	}];
	confirmAction.enabled = NO;

	UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[NSNotificationCenter.defaultCenter removeObserver: observer];
	}];

	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.placeholder = @"Between 0 and 100";
		textField.keyboardType = UIKeyboardTypeNumberPad;

		observer = [NSNotificationCenter.defaultCenter addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
			confirmAction.enabled = textField.text.integerValue != 0 && textField.text.integerValue <= 100;
		}];
	}];

	[alertController addAction: confirmAction];
	[alertController addAction: dismissAction];

	[rootViewController presentViewController:alertController animated:YES completion:nil];

}


- (void)presentSuccessAlertController {

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Aria" message:@"Your fancy image got succesfully saved to your gallery, do you want to see how it looks?" preferredStyle: UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Heck yeah" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		[UIApplication.sharedApplication _openURL: [NSURL URLWithString: @"photos-redirect://"]];

	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:nil];

	[alertController addAction: confirmAction];
	[alertController addAction: cancelAction];

	[rootViewController presentViewController:alertController animated:YES completion:nil];

}


- (UIViewController *)getRootViewController {

	UIViewController *rootVC = nil;
	NSSet *connectedScenes = [UIApplication sharedApplication].connectedScenes;

	for(UIScene *scene in connectedScenes) {
		if(scene.activationState != UISceneActivationStateForegroundActive
			|| ![scene isKindOfClass:[UIWindowScene class]]) return nil;

		UIWindowScene *windowScene = (UIWindowScene *)scene;
		for(UIWindow *window in windowScene.windows) {
			rootVC = window.rootViewController;
			break;
		}

	}

	return rootVC;

}


- (void)saveAriaImage:(UIImage *)image {

	// slightly modified from ⇝ https://stackoverflow.com/a/39909129
	NSString *albumName = @"Aria";

	PHFetchOptions *fetchOptions = [PHFetchOptions new];
	fetchOptions.predicate = [NSPredicate predicateWithFormat:@"localizedTitle = %@", albumName];
	PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions];

	if(fetchResult.count > 0) [self createAriaImageAssetFromImage:image forCollection: fetchResult.firstObject];

	else {

		__block PHObjectPlaceholder *albumPlaceholder;

		[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{

			PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle: albumName];
			albumPlaceholder = changeRequest.placeholderForCreatedAssetCollection;

		} completionHandler:^(BOOL success, NSError *error) {

			if(!success) return;

			PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumPlaceholder.localIdentifier] options:nil];
			if(fetchResult.count > 0) [self createAriaImageAssetFromImage:image forCollection: fetchResult.firstObject];

		}];

	}

}


- (void)createAriaImageAssetFromImage:(UIImage *)image forCollection:(PHAssetCollection *)collection {

	[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
		PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage: image];
		PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection: collection];
		[assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];
	} completionHandler: nil];

}

@end
