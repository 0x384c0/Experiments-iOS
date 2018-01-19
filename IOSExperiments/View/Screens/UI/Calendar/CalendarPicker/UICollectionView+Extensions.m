//
//  UICollectionView+Extensions.m
//  BJ
//
//  Created by AK on 6/23/16.
//  Copyright © 2016 AK. All rights reserved.
//

#import "UICollectionView+Extensions.h"

@implementation UICollectionView (Extensions)

- (void)scrollToIndexpathByShowingHeader:(NSIndexPath *)indexPath {
    NSInteger sections = self.numberOfSections;

    if (indexPath.section <= sections) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [self setContentOffset:CGPointMake(0, attributes.frame.origin.y - self.contentInset.top)];
    }
}


@end
