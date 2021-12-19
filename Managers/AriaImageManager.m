#import "AriaImageManager.h"


@implementation AriaImageManager


+ (AriaImageManager *)sharedInstance {

	static AriaImageManager *sharedInstance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{ sharedInstance = [[AriaImageManager alloc] initPrivate]; });

	return sharedInstance;

}


- (id)initPrivate {

	self = [super init];

	return self;

}


- (void)blurImageWithImage {

	UIImage *stockDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"stockDarkImage"];
	UIImage *stockLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"stockLightImage"];
	UIImage *prysmDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"prysmDarkImage"];
	UIImage *prysmLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"prysmLightImage"];

	UIImage *candidateImage;

	if(!kIsPrysm) candidateImage = kUserInterfaceStyle ? stockDarkImage : stockLightImage;
	else candidateImage = kUserInterfaceStyle ? prysmDarkImage : prysmLightImage;

	CIContext *context = [CIContext contextWithOptions: nil];

	CIImage *inputImage = [[CIImage alloc] initWithImage: candidateImage];

	CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
	[clampFilter setDefaults];
	[clampFilter setValue:inputImage forKey: kCIInputImageKey];

	CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
	[blurFilter setValue:clampFilter.outputImage forKey: kCIInputImageKey];

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Aria" message:@"How much blur intensity do you want?" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Blur" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		[blurFilter setValue:[NSNumber numberWithFloat:alertController.textFields.firstObject.text.doubleValue] forKey:@"inputRadius"];

		CIImage *result = [blurFilter valueForKey:kCIOutputImageKey];

		CGImageRef cgImage = [context createCGImage: result fromRect: inputImage.extent];

		UIImage *blurredImage = [[UIImage alloc] initWithCGImage: cgImage scale: candidateImage.scale orientation: UIImageOrientationUp];

		[[AriaImageManager sharedInstance] saveImageToGallery: blurredImage];
		CGImageRelease(cgImage);

		proudSuccessAlertController();

	}];

	UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:nil];

	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {

		textField.placeholder = @"Between 0 and 100";
		textField.keyboardType = UIKeyboardTypeNumberPad;

	}];

	[alertController addAction: confirmAction];
	[alertController addAction: dismissAction];

	[[MyClass keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];

}


- (void)saveImageToGallery:(UIImage *)image { kSaveToGallery(image, nil, nil, nil); }


- (void)uselessMethodThatllNeverBeCalled { loadWithoutAGoddamnRespring(); }


static void proudSuccessAlertController() {

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Aria" message:@"Your fancy image got succesfully saved to your gallery, do you want to see how it looks?" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Heck yeah" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		UIApplication *application = [UIApplication sharedApplication];
		NSURL *theURL = [NSURL URLWithString: @"photos-redirect://"];
		[application _openURL: theURL];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:nil];

	[alertController addAction: confirmAction];
	[alertController addAction: cancelAction];

	[[MyClass keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];

}


@end
