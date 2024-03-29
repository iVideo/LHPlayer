//
//  UITableView+DelegateBlock.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-19.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "UITableView+DelegateBlock.h"
#import <objc/runtime.h>

static NSString* UITableViewDelegateBlocksKey = @"UITableViewDelegateBlocksKey";
@implementation UITableView (DelegateBlock)

-(id)useBlocksForDelegate {
    UITableViewDelegateBlocks* delegate = [[UITableViewDelegateBlocks alloc] init];
    objc_setAssociatedObject (self, &UITableViewDelegateBlocksKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.delegate = delegate;
    return self;
}

-(void)onAccessoryButtonTappedForRowWithIndexPath:(UITableViewAccessoryButtonTappedForRowWithIndexPathBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setAccessoryButtonTappedForRowWithIndexPathBlock:block];
}

-(void)onDidDeselectRowAtIndexPath:(UITableViewDidDeselectRowAtIndexPathBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setDidDeselectRowAtIndexPathBlock:block];
}

-(void)onDidEndEditingRowAtIndexPath:(UITableViewDidEndEditingRowAtIndexPathBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setDidEndEditingRowAtIndexPathBlock:block];
}

-(void)onDidSelectRowAtIndexPath:(UITableViewDidSelectRowAtIndexPathBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setDidSelectRowAtIndexPathBlock:block];
}

-(void)onEditingStyleForRowAtIndexPath:(UITableViewEditingStyleForRowAtIndexPathBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setEditingStyleForRowAtIndexPathBlock:block];
}

-(void)onHeightForFooterInSection:(UITableViewHeightForFooterInSectionBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setHeightForFooterInSectionBlock:block];
}

-(void)onHeightForHeaderInSection:(UITableViewHeightForHeaderInSectionBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setHeightForHeaderInSectionBlock:block];
}

-(void)onHeightForRowAtIndexPath:(UITableViewHeightForRowAtIndexPathBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setHeightForRowAtIndexPathBlock:block];
}

-(void)onShouldIndentWhileEditingRowAtIndexPath:(UITableViewShouldIndentWhileEditingRowAtIndexPathBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setShouldIndentWhileEditingRowAtIndexPathBlock:block];
}

-(void)onTargetIndexPathForMoveFromRowAtIndexPath:(UITableViewTargetIndexPathForMoveFromRowAtIndexPathBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setTargetIndexPathForMoveFromRowAtIndexPathBlock:block];
}

-(void)onTitleForDeleteConfirmationButtonForRowAtIndexPath:(UITableViewTitleForDeleteConfirmationButtonForRowAtIndexPathBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setTitleForDeleteConfirmationButtonForRowAtIndexPathBlock:block];
}

-(void)onViewForFooterInSection:(UITableViewViewForFooterInSectionBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setViewForFooterInSectionBlock:block];
}

-(void)onViewForHeaderInSection:(UITableViewViewForHeaderInSectionBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setViewForHeaderInSectionBlock:block];
}

-(void)onWillBeginEditingRowAtIndexPath:(UITableViewWillBeginEditingRowAtIndexPathBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setWillBeginEditingRowAtIndexPathBlock:block];
}

-(void)onWillDeselectRowAtIndexPath:(UITableViewWillDeselectRowAtIndexPathBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setWillDeselectRowAtIndexPathBlock:block];
}

-(void)onWillDisplayCell:(UITableViewWillDisplayCellBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setWillDisplayCellBlock:block];
}

-(void)onWillSelectRowAtIndexPath:(UITableViewWillSelectRowAtIndexPathBlock)block {
    [((UITableViewDelegateBlocks*)self.delegate) setWillSelectRowAtIndexPathBlock:block];
}

@end

@implementation UITableViewDelegateBlocks

@synthesize accessoryButtonTappedForRowWithIndexPathBlock = _accessoryButtonTappedForRowWithIndexPathBlock;
@synthesize didDeselectRowAtIndexPathBlock = _didDeselectRowAtIndexPathBlock;
@synthesize didEndEditingRowAtIndexPathBlock = _didEndEditingRowAtIndexPathBlock;
@synthesize didSelectRowAtIndexPathBlock = _didSelectRowAtIndexPathBlock;
@synthesize editingStyleForRowAtIndexPathBlock = _editingStyleForRowAtIndexPathBlock;
@synthesize heightForFooterInSectionBlock = _heightForFooterInSectionBlock;
@synthesize heightForHeaderInSectionBlock = _heightForHeaderInSectionBlock;
@synthesize heightForRowAtIndexPathBlock = _heightForRowAtIndexPathBlock;
@synthesize shouldIndentWhileEditingRowAtIndexPathBlock = _shouldIndentWhileEditingRowAtIndexPathBlock;
@synthesize targetIndexPathForMoveFromRowAtIndexPathBlock = _targetIndexPathForMoveFromRowAtIndexPathBlock;
@synthesize titleForDeleteConfirmationButtonForRowAtIndexPathBlock = _titleForDeleteConfirmationButtonForRowAtIndexPathBlock;
@synthesize viewForFooterInSectionBlock = _viewForFooterInSectionBlock;
@synthesize viewForHeaderInSectionBlock = _viewForHeaderInSectionBlock;
@synthesize willBeginEditingRowAtIndexPathBlock = _willBeginEditingRowAtIndexPathBlock;
@synthesize willDeselectRowAtIndexPathBlock = _willDeselectRowAtIndexPathBlock;
@synthesize willDisplayCellBlock = _willDisplayCellBlock;
@synthesize willSelectRowAtIndexPathBlock = _willSelectRowAtIndexPathBlock;

-(void)tableView:(UITableView*)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath  {
    UITableViewAccessoryButtonTappedForRowWithIndexPathBlock block = [self.accessoryButtonTappedForRowWithIndexPathBlock copy];
    block(tableView, indexPath);
}

-(void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath*)indexPath  {
    UITableViewDidDeselectRowAtIndexPathBlock block = [self.didDeselectRowAtIndexPathBlock copy];
    block(tableView, indexPath);
}

-(void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath*)indexPath  {
    UITableViewDidEndEditingRowAtIndexPathBlock block = [self.didEndEditingRowAtIndexPathBlock copy];
    block(tableView, indexPath);
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath  {
    UITableViewDidSelectRowAtIndexPathBlock block = [self.didSelectRowAtIndexPathBlock copy];
    block(tableView, indexPath);
}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath  {
    UITableViewEditingStyleForRowAtIndexPathBlock block = [self.editingStyleForRowAtIndexPathBlock copy];
    UITableViewCellEditingStyle result = block(tableView, indexPath);
    return result;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section  {
    UITableViewHeightForFooterInSectionBlock block = [self.heightForFooterInSectionBlock copy];
    CGFloat result = block(tableView, section);
    return result;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section  {
    UITableViewHeightForHeaderInSectionBlock block = [self.heightForHeaderInSectionBlock copy];
    CGFloat result = block(tableView, section);
    return result;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath  {
    UITableViewHeightForRowAtIndexPathBlock block = [self.heightForRowAtIndexPathBlock copy];
    CGFloat result = block(tableView, indexPath);
    return result;
}

-(BOOL)tableView:(UITableView*)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath*)indexPath  {
    UITableViewShouldIndentWhileEditingRowAtIndexPathBlock block = [self.shouldIndentWhileEditingRowAtIndexPathBlock copy];
    BOOL result = block(tableView, indexPath);
    return result;
}

-(NSIndexPath*)tableView:(UITableView*)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath*)sourceIndexPath toProposedIndexPath:(NSIndexPath*)proposedDestinationIndexPath  {
    UITableViewTargetIndexPathForMoveFromRowAtIndexPathBlock block = [self.targetIndexPathForMoveFromRowAtIndexPathBlock copy];
    NSIndexPath* result = block(tableView, sourceIndexPath, proposedDestinationIndexPath);
    return result;
}

-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath  {
    UITableViewTitleForDeleteConfirmationButtonForRowAtIndexPathBlock block = [self.titleForDeleteConfirmationButtonForRowAtIndexPathBlock copy];
    NSString* result = block(tableView, indexPath);
    return result;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section  {
    UITableViewViewForFooterInSectionBlock block = [self.viewForFooterInSectionBlock copy];
    UIView* result = block(tableView, section);
    return result;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section  {
    UITableViewViewForHeaderInSectionBlock block = [self.viewForHeaderInSectionBlock copy];
    UIView* result = block(tableView, section);
    return result;
}

-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath*)indexPath  {
    UITableViewWillBeginEditingRowAtIndexPathBlock block = [self.willBeginEditingRowAtIndexPathBlock copy];
    block(tableView, indexPath);
}

-(NSIndexPath*)tableView:(UITableView*)tableView willDeselectRowAtIndexPath:(NSIndexPath*)indexPath  {
    UITableViewWillDeselectRowAtIndexPathBlock block = [self.willDeselectRowAtIndexPathBlock copy];
    NSIndexPath* result = block(tableView, indexPath);
    return result;
}

-(void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath  {
    UITableViewWillDisplayCellBlock block = [self.willDisplayCellBlock copy];
    block(tableView, cell, indexPath);
}

-(NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath  {
    UITableViewWillSelectRowAtIndexPathBlock block = [self.willSelectRowAtIndexPathBlock copy];
    NSIndexPath* result = block(tableView, indexPath);
    return result;
}

@end

