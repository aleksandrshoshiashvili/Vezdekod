//
//  SyncDelegate.swift
//  SwiftyListKit
//
//  Created by Dmitry Grebenschikov on 18/02/2019.
//  Copyright © 2019 Alexander Shoshiashvili. All rights reserved.
//

import UIKit

open class SyncDelegate<S: TableListSection>: NSObject, UITableViewDelegate, UIScrollViewDelegate {
    unowned var dataSource: TableViewDataSource<S>

    public typealias DisplayHeaderFooterViewInSection = ((_ tableView: UITableView, _ view: UIView, _ section: Int) -> Void)
    public typealias DisplayCellAtIndexPath = ((_ tableView: UITableView, _ indexPath: IndexPath, _ cell: UITableViewCell, _ model: TableViewDataSource<S>.I?) -> Void)
    public typealias ViewForHeaderFooterInSection = (TableViewDataSource<S>, UITableView, Int, TableViewDataSource<S>.I?) -> UIView?
    public typealias HeightForHeaderFooterInSection = (UITableView, Int, TableViewDataSource<S>.I?) -> CGFloat
    public typealias HeightForRow = (UITableView, IndexPath, TableViewDataSource<S>.I) -> CGFloat
    public typealias SeparatorForRow = (IndexPath) -> (CustomSeparatorConfiguration)?
    public typealias ModelAtIndex = ((UITableView, IndexPath, S.ItemModel?) -> Void)
    public typealias ScrollView = ((_ scrollView: UIScrollView) -> Void)
    public typealias ScrollViewWillEndDragging = ((_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)
    public typealias ScrollViewDidEndDragging = ((_ scrollView: UIScrollView, _ decelerate: Bool) -> Void)
    public typealias ViewForZooming = ((_ scrollView: UIScrollView) -> UIView?)
    public typealias ScrollWillBeginZooming = ((_ scrollView: UIScrollView, _ view: UIView?) -> Void)
    public typealias ScrollDidEndZooming = ((_ scrollView: UIScrollView, _ view: UIView?, _ scale: CGFloat) -> Void)
    public typealias ShouldScrollToTop = ((_ scrollView: UIScrollView) -> Bool)
    public typealias EditingStyle = (UITableView, IndexPath, TableViewDataSource<S>.I?) -> UITableViewCell.EditingStyle
    public typealias EditActions = (UITableView, IndexPath, TableViewDataSource<S>.I?) -> [UITableViewRowAction]?
    public typealias ShouldShowMenu = ((UITableView, IndexPath, S.ItemModel?) -> Bool)
    public typealias CanPerformAction = ((UITableView, IndexPath, Selector, Any?, S.ItemModel?) -> Bool)
    public typealias PerformAction = ((UITableView, IndexPath, Selector, Any?, S.ItemModel?) -> Void)

    @available(iOS 11.0, *)
    public typealias SwipeAction = (UITableView, IndexPath, TableViewDataSource<S>.I?) -> UISwipeActionsConfiguration?
    
    private var _onLeadingSwipeAction: Any?
    @available(iOS 11.0, *)
    public var onLeadingSwipeAction: SwipeAction? {
        get {
            return _onLeadingSwipeAction as? SwipeAction
        }
        set {
            _onLeadingSwipeAction = newValue
        }
    }
    
    private var _onTrailingSwipeAction: Any?
    @available(iOS 11.0, *)
    public var onTrailingSwipeAction: SwipeAction? {
        get {
            return _onTrailingSwipeAction as? SwipeAction
        }
        set {
            _onTrailingSwipeAction = newValue
        }
    }

    public var onShouldShowMenuForRowAt: ShouldShowMenu?
    public var onCanPerformAction: CanPerformAction?
    public var onPerformAction: PerformAction?

    public var onEditingStyle: EditingStyle?
    public var onEditActions: EditActions?
    
    public var viewForHeaderAtSection: ViewForHeaderFooterInSection?
    public var heightForHeaderAtSection: HeightForHeaderFooterInSection!
    
    public var viewForFooterAtSection: ViewForHeaderFooterInSection?
    public var heightForFooterAtSection: HeightForHeaderFooterInSection!

    public var willDisplayHeaderViewAtSection: DisplayHeaderFooterViewInSection?
    public var willDisplayFooterViewAtSection: DisplayHeaderFooterViewInSection?

    public var endDisplayingHeaderViewAtSection: DisplayHeaderFooterViewInSection?
    public var endDisplayingFooterViewAtSection: DisplayHeaderFooterViewInSection?

    public var willDisplayCellAtIndexPath: DisplayCellAtIndexPath?
    
    public var heightForRow: HeightForRow!
    public var separatorForRow: SeparatorForRow?
    
    public var didSelectRow: ModelAtIndex?

    public var onScrollViewDidScroll: ScrollView?
    public var onScrollViewDidZoom: ScrollView?
    public var onScrollViewWillBeginDragging: ScrollView?

    public var onScrollViewWillEndDragging: ScrollViewWillEndDragging?
    public var onScrollViewDidEndDragging: ScrollViewDidEndDragging?

    public var onScrollViewWillBeginDecelerating: ScrollView?
    public var onScrollViewDidEndDecelerating: ScrollView?
    public var onScrollViewDidEndScrollingAnimation: ScrollView?

    public var onViewForZooming: ViewForZooming?
    public var onScrollViewWillBeginZooming: ScrollWillBeginZooming?
    public var onScrollViewDidEndZooming: ScrollDidEndZooming?

    public var onShouldScrollToTop: ShouldScrollToTop?
    public var onScrollViewDidScrollToTop: ScrollView?
    public var onScrollViewDidChangeAdjustedContentInset: ScrollView?
    
    public init(dataSource: TableViewDataSource<S>,
                heightForRow: HeightForRow? = nil) {
        self.dataSource = dataSource
        super.init()
        self.viewForHeaderAtSection = defaultViewForHeaderFooter
        self.heightForHeaderAtSection = defaultHeightForHeaderFooter
        self.viewForFooterAtSection = defaultViewForHeaderFooter
        self.heightForFooterAtSection = defaultHeightForHeaderFooter
        self.heightForRow = heightForRow ?? defaultHeightForRow
    }
    
    // MARK: Headers section
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeaderAtSection?(self.dataSource, tableView, section, dataSource.sectionModels[safe: section]?.header)
    }
    
    private let defaultViewForHeaderFooter: ViewForHeaderFooterInSection = { delegate, tableView, _, model in
        guard let viewModel = model else {
            return nil
        }
        
        delegate.registerListItem(withIdentifier: viewModel.reuseIdentifier,
                                  type: .headerFooter,
                                  tableView: tableView)
        
        let listItem = tableView.dequeueReusableHeaderFooterView(withIdentifier: viewModel.reuseIdentifier) as? ListItem
        
        guard let item = listItem else {
            return nil
        }
        
        if let map = viewModel.map {
            map(viewModel.data, item)
        } else if let defaultDataMap = type(of: item).defaultDataMap {
            defaultDataMap(viewModel.data, item)
        }

        if let mapStyle = viewModel.style {
            mapStyle(item)
        } else if let mapDefaultStyle = type(of: item).defaultStyle {
            mapDefaultStyle(item)
        }

        if let delegatableItem = item as? ListItemDelegatable,
            let delegate = delegate.delegate {
            delegatableItem.set(delegate: delegate)
        }
        
        return item as? UIView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaderAtSection(tableView, section, dataSource.sectionModels[safe: section]?.header)
    }
    
    private let defaultHeightForHeaderFooter: HeightForHeaderFooterInSection = { _, _, model in
        guard let viewModel = model else {
            return CGFloat.leastNormalMagnitude
        }
        switch viewModel.heightStyle {
        case .automatic:
            return UITableView.automaticDimension
        case .static(let height):
            return height
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        tableView.visibleHeadersDict[section] = view
        willDisplayHeaderViewAtSection?(tableView, view, section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        tableView.visibleHeadersDict.removeValue(forKey: section)
        endDisplayingHeaderViewAtSection?(tableView, view, section)
    }
    
    // MARK: - Footers section
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterAtSection(tableView, section, dataSource.sectionModels[safe: section]?.footer)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooterAtSection?(dataSource, tableView, section, dataSource.sectionModels[safe: section]?.footer)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        tableView.visibleFootersDict[section] = view
        willDisplayFooterViewAtSection?(tableView, view, section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        tableView.visibleFootersDict.removeValue(forKey: section)
        endDisplayingFooterViewAtSection?(tableView, view, section)
    }
    
    // MARK: - Rows section
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow(tableView, indexPath, dataSource.sectionModels[indexPath.section].rows[indexPath.row])
    }
    
    private let defaultHeightForRow: HeightForRow = { _, _, viewModel in
        switch viewModel.heightStyle {
        case .automatic:
            return UITableView.automaticDimension
        case .static(let height):
            return height
        }
    }
    
    // MARK: - Hooks
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        do {
            let model = try dataSource.model(at: indexPath) as? S.ItemModel
            didSelectRow?(tableView, indexPath, model)
        } catch {
            didSelectRow?(tableView, indexPath, nil)
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        configureSeparatorIfPossible(for: cell, in: tableView, at: indexPath)

        guard let model = try? dataSource.model(at: indexPath) as? S.ItemModel else {
            willDisplayCellAtIndexPath?(tableView, indexPath, cell, nil)
            return
        }
        willDisplayCellAtIndexPath?(tableView, indexPath, cell, model)

        guard let item = cell as? ListItem else {
            return
        }

        if let mapStyle = model.style {
            mapStyle(item)
        } else if let mapDefaultStyle = type(of: item).defaultStyle {
            mapDefaultStyle(item)
        }
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        do {
            let model = try dataSource.model(at: indexPath) as? S.ItemModel
            return onLeadingSwipeAction?(tableView, indexPath, model)
        } catch {
            return onLeadingSwipeAction?(tableView, indexPath, nil)
        }
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        do {
            let model = try dataSource.model(at: indexPath) as? S.ItemModel
            return onTrailingSwipeAction?(tableView, indexPath, model)
        } catch {
            return onTrailingSwipeAction?(tableView, indexPath, nil)
        }
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        do {
            let model = try dataSource.model(at: indexPath) as? S.ItemModel
            return onEditActions?(tableView, indexPath, model)
        } catch {
            return onEditActions?(tableView, indexPath, nil)
        }
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        do {
            let model = try dataSource.model(at: indexPath) as? S.ItemModel
            return onEditingStyle?(tableView, indexPath, model) ?? .none
        } catch {
            return onEditingStyle?(tableView, indexPath, nil) ?? .none
        }
    }

    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        do {
            let model = try dataSource.model(at: indexPath) as? S.ItemModel
            return onShouldShowMenuForRowAt?(tableView, indexPath, model) ?? false
        } catch {
            return onShouldShowMenuForRowAt?(tableView, indexPath, nil) ?? false
        }
    }

    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        do {
            let model = try dataSource.model(at: indexPath) as? S.ItemModel
            return onCanPerformAction?(tableView, indexPath, action, sender, model) ?? false
        } catch {
            return onCanPerformAction?(tableView, indexPath, action, sender, nil) ?? false
        }
    }

    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        do {
            let model = try dataSource.model(at: indexPath) as? S.ItemModel
            onPerformAction?(tableView, indexPath, action, sender, model)
        } catch {
            onPerformAction?(tableView, indexPath, action, sender, nil)
        }
    }

    // MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollViewDidScroll?(scrollView)
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        onScrollViewDidZoom?(scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        onScrollViewWillBeginDragging?(scrollView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        onScrollViewWillEndDragging?(scrollView, velocity, targetContentOffset)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        onScrollViewDidEndDragging?(scrollView, decelerate)
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        onScrollViewWillBeginDecelerating?(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        onScrollViewDidEndDecelerating?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        onScrollViewDidEndScrollingAnimation?(scrollView)
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return onViewForZooming?(scrollView)
    }

    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        onScrollViewWillBeginZooming?(scrollView, view)
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        onScrollViewDidEndZooming?(scrollView, view, scale)
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return onShouldScrollToTop?(scrollView) ?? true
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        onScrollViewDidScrollToTop?(scrollView)
    }

    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        onScrollViewDidChangeAdjustedContentInset?(scrollView)
    }

    // MARK: - Helpers

    private func configureSeparatorIfPossible(for cell: UITableViewCell, in tableView: UITableView, at indexPath: IndexPath) {
        let isHideLastSeparatorInSection = true
        guard let tableCell = cell as? SeparatorHandler,
            let separator = separatorForRow?(indexPath),
            tableView.separatorStyle == .none else {
            return
        }
        if isHideLastSeparatorInSection, indexPath.row == dataSource.sectionModels[indexPath.section].rows.count - 1 {
        } else {
            tableCell.configureSeparator(with: separator)
        }
    }
    
}
