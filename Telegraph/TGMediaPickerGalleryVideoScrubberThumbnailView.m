#import "TGMediaPickerGalleryVideoScrubberThumbnailView.h"
#import "TGPhotoEditorUtils.h"
#import "TGImageUtils.h"

@interface TGMediaPickerGalleryVideoScrubberThumbnailView ()
{
    CGSize _originalSize;
    CGRect _cropRect;
    UIImageOrientation _cropOrientation;
    
    UIImageView *_imageView;
    UIView *_stripeView;
}
@end

@implementation TGMediaPickerGalleryVideoScrubberThumbnailView

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectZero];
    if (self != nil)
    {
        self.clipsToBounds = true;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.image = image;
        [self addSubview:_imageView];
        
        _stripeView = [[UIView alloc] init];
        _stripeView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        [self addSubview:_stripeView];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image originalSize:(CGSize)originalSize cropRect:(CGRect)cropRect cropOrientation:(UIImageOrientation)cropOrientation
{
    self = [self initWithImage:image];
    if (self != nil)
    {
        _originalSize = originalSize;
        _cropRect = cropRect;
        _cropOrientation = cropOrientation;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_imageView == nil)
        return;
    
    _imageView.transform = CGAffineTransformMakeRotation(TGRotationForOrientation(_cropOrientation));
    
    CGRect cropRect = _cropRect;
    CGSize originalSize = _originalSize;
    
    if (_cropOrientation == UIImageOrientationLeft)
    {
        cropRect = CGRectMake(cropRect.origin.y, originalSize.width - cropRect.size.width - cropRect.origin.x, cropRect.size.height, cropRect.size.width);
        originalSize = CGSizeMake(originalSize.height, originalSize.width);
    }
    else if (_cropOrientation == UIImageOrientationRight)
    {
        cropRect = CGRectMake(originalSize.height - cropRect.size.height - cropRect.origin.y, cropRect.origin.x, cropRect.size.height, cropRect.size.width);
        originalSize = CGSizeMake(originalSize.height, originalSize.width);
    }
    else if (_cropOrientation == UIImageOrientationDown)
    {
        cropRect = CGRectMake(originalSize.width - cropRect.size.width - cropRect.origin.x, originalSize.height - cropRect.size.height - cropRect.origin.y, cropRect.size.width, cropRect.size.height);
    }
    
    CGFloat ratio = frame.size.width / cropRect.size.width;
    _imageView.frame = CGRectMake(-cropRect.origin.x * ratio, -cropRect.origin.y * ratio, originalSize.width * ratio, originalSize.height * ratio);
    
    CGFloat thickness = 1.0f - TGRetinaPixel;
    _stripeView.frame = CGRectMake(frame.size.width - thickness, 0, thickness, frame.size.height);
}

@end
