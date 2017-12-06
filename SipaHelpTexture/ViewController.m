//
//  ViewController.m
//  SipaHelpTexture
//
//  Created by Maxim Bunkov on 05/12/2017.
//  Copyright © 2017 Bimawa. All rights reserved.
//

#import "ViewController.h"
#import "ASDisplayNode.h"
#import "ASNetworkImageNode.h"
#import "ASPINRemoteImageDownloader.h"
#import "ASTextNode.h"
#import "ASStackLayoutSpec.h"
#import "ASCenterLayoutSpec.h"
#import "ASOverlayLayoutSpec.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ASDisplayNode *containerViewNode = [ASDisplayNode new];
    [containerViewNode setAutomaticallyManagesSubnodes:YES];
    ASNetworkImageNode *avatarImage = [[ASNetworkImageNode alloc] initWithCache:[ASPINRemoteImageDownloader sharedDownloader] downloader:[ASPINRemoteImageDownloader sharedDownloader]];
    avatarImage.backgroundColor = [UIColor greenColor];
    [avatarImage setURL:[NSURL URLWithString:@"https://cdn.pixabay.com/photo/2017/03/02/20/25/woman-2112292_960_720.jpg"]];
    [avatarImage setImageModificationBlock:^UIImage *(UIImage *image) {
        UIImage *modifiedImage = nil;
        CGRect rect = (CGRect) {CGPointZero, image.size};
        UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:(image.size.width / 2)] addClip];
        [image drawInRect:rect];
        modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return modifiedImage;
    }];

    ASNetworkImageNode *settingsIcon = [[ASNetworkImageNode alloc] initWithCache:[ASPINRemoteImageDownloader sharedDownloader] downloader:[ASPINRemoteImageDownloader sharedDownloader]];
    settingsIcon.backgroundColor = [UIColor blueColor];
    [settingsIcon setURL:[NSURL URLWithString:@"https://icon-icons.com/icons2/510/PNG/512/ios7-gear_icon-icons.com_50262.png"]];

    ASTextNode *textNodeStub = [ASTextNode new];
    textNodeStub.attributedText = [[NSAttributedString alloc] initWithString:@"stub text node"];
    [containerViewNode setLayoutSpecBlock:^ASLayoutSpec *(__kindof ASDisplayNode *node, ASSizeRange constrainedSize) {
        avatarImage.style.preferredSize = CGSizeMake(35, 35);
        settingsIcon.style.preferredSize = CGSizeMake(15, 15);
        ASCenterLayoutSpec *avatarCenterSpec = [[ASCenterLayoutSpec alloc] initWithHorizontalPosition:ASRelativeLayoutSpecPositionCenter verticalPosition:ASRelativeLayoutSpecPositionCenter sizingOption:ASRelativeLayoutSpecSizingOptionDefault child:avatarImage];
        avatarCenterSpec.style.flexBasis = ASDimensionMakeWithPoints(100);
        ASRelativeLayoutSpec *gearSpec = [[ASRelativeLayoutSpec alloc] initWithHorizontalPosition:ASRelativeLayoutSpecPositionEnd verticalPosition:ASRelativeLayoutSpecPositionStart sizingOption:ASRelativeLayoutSpecSizingOptionDefault child:settingsIcon];
        ASOverlayLayoutSpec *overlayLayoutSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:avatarCenterSpec overlay:gearSpec];
        ASStackLayoutSpec *mainSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:@[overlayLayoutSpec, textNodeStub]];
        return mainSpec;
    }];
    containerViewNode.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:containerViewNode.view];
    containerViewNode.view.frame = self.view.bounds;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end