//
//  PtSharedApp.m
//  Pastel2
//
//  Created by SSC on 2014/05/27.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "PtSharedApp.h"

@implementation PtSharedApp

static PtSharedApp* sharedPtSharedApp = nil;

+ (PtSharedApp*)instance {
	@synchronized(self) {
		if (sharedPtSharedApp == nil) {
			sharedPtSharedApp = [[self alloc] init];
		}
	}
	return sharedPtSharedApp;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedPtSharedApp == nil) {
			sharedPtSharedApp = [super allocWithZone:zone];
			return sharedPtSharedApp;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone*)zone {
	return self;  // シングルトン状態を保持するため何もせず self を返す
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark settings

//// エフェクトのアンロック
- (BOOL)didUnlockExtraEffects
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL f = [ud boolForKey:@"unlocked"];
    if (f == YES) {
        return YES;
    }
    return NO;
}

- (void)setDidUnlockExtraEffects:(BOOL)didUnlockExtraEffects
{
    if (didUnlockExtraEffects) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setBool:YES forKey:@"unlocked"];
        [ud synchronize];
    }
}

//// 起動時にカメラモード

- (BOOL)startInCameraMode
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger f = [ud integerForKey:@"startInCameraMode"];
    if (f == 2) {
        return YES;
    }else if(f == 1){
        return NO;
    }
    //// デフォルト
    self.startInCameraMode = YES;
    return YES;
}

- (void)setStartInCameraMode:(BOOL)startInCameraMode
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger flag = (startInCameraMode) ? 2 : 1;
    [ud setInteger:flag forKey:@"startInCameraMode"];
    [ud synchronize];
}

//// 撮影してすぐ共有

- (BOOL)shootAndShare
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger f = [ud integerForKey:@"shootAndShare"];
    if (f == 2) {
        return YES;
    }else if(f == 1){
        return NO;
    }
    //// デフォルト
    self.shootAndShare = YES;
    return YES;
}

- (void)setShootAndShare:(BOOL)shootAndShare
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger flag = (shootAndShare) ? 2 : 1;
    [ud setInteger:flag forKey:@"shootAndShare"];
    [ud synchronize];
}

//// iPhoneのデフォルトのカメラを使う

- (BOOL)useDefaultCameraApp
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger f = [ud integerForKey:@"useDefaultCameraApp"];
    if (f == 2) {
        return YES;
    }else if(f == 1){
        return NO;
    }
    //// デフォルト
    self.startInCameraMode = NO;
    return NO;
}

- (void)setUseDefaultCameraApp:(BOOL)useDefaultCameraApp
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger flag = (useDefaultCameraApp) ? 2 : 1;
    [ud setInteger:flag forKey:@"useDefaultCameraApp"];
    [ud synchronize];
}

@end