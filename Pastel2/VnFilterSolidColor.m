//
//  VnFilterSolidColor.m
//  Pastel2
//
//  Created by SSC on 2014/05/29.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "VnFilterSolidColor.h"

NSString *const kVnFilterSolidColorFragmentShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform vec4 color;
 uniform float useExistingAlpha;
 
 void main()
 {
     mediump vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 rs = vec4(color.rgb, max(textureColor.a, 1.0 - useExistingAlpha));
     gl_FragColor = blendWithBlendingMode(textureColor, vec4(rs.r, rs.g, rs.b, topLayerOpacity), blendingMode);
 }
 );

@implementation VnFilterSolidColor

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kVnFilterSolidColorFragmentShaderString]))
    {
		return nil;
    }
    
    colorUniform = [filterProgram uniformIndex:@"color"];
    useExistingAlphaUniform = [filterProgram uniformIndex:@"useExistingAlpha"];
    
	self.color = (GPUVector4){0.0f, 0.0f, 0.5f, 1.0f};
    self.useExistingAlpha = NO;
    
    return self;
}


#pragma mark -
#pragma mark Accessors

- (void)forceProcessingAtSize:(CGSize)frameSize;
{
    [super forceProcessingAtSize:frameSize];
    
    if (!CGSizeEqualToSize(inputTextureSize, CGSizeZero))
    {
        [self newFrameReadyAtTime:kCMTimeIndefinite atIndex:0];
    }
}

- (void)addTarget:(id<GPUImageInput>)newTarget atTextureLocation:(NSInteger)textureLocation;
{
    [super addTarget:newTarget atTextureLocation:textureLocation];
    
    if (!CGSizeEqualToSize(inputTextureSize, CGSizeZero))
    {
        [newTarget setInputSize:inputTextureSize atIndex:textureLocation];
        [newTarget newFrameReadyAtTime:kCMTimeIndefinite atIndex:textureLocation];
    }
}

- (void)setColor:(GPUVector4)newValue;
{
	[self setColorRed:newValue.one green:newValue.two blue:newValue.three alpha:newValue.four];
}

- (void)setColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;
{
    _color.one = redComponent;
    _color.two = greenComponent;
    _color.three = blueComponent;
    _color.four = alphaComponent;
    
    [self setVec4:_color forUniform:colorUniform program:filterProgram];
}

- (void)setUseExistingAlpha:(BOOL)useExistingAlpha;
{
    _useExistingAlpha = useExistingAlpha;
    
    [self setInteger:(useExistingAlpha ? 1 : 0) forUniform:useExistingAlphaUniform program:filterProgram];
}

@end
