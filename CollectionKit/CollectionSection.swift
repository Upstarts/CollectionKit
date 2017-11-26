//
//  CollectionSection.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
//todo: добавть equals и перенести все методы по работе с секцией в протокол, добавить в ридми про абстрактные секции
public protocol AbstractCollectionSection : class {
    var identifier: String { get }
    var headerItem: AbstractCollectionItem? { get set }
    var footerItem: AbstractCollectionItem? { get set }
    
    var insetForSection: UIEdgeInsets { get set }
    var minimumInterItemSpacing: CGFloat { get set }
    var lineSpacing: CGFloat { get set }
    
    var isEmpty: Bool { get }
    
    func numberOfItems() -> Int
    func item(for index: Int) -> AbstractCollectionItem
    func contains(item: AbstractCollectionItem) -> Bool
    func index(for item: AbstractCollectionItem) -> Int?
    
    func clear()
    func reload()
}

extension AbstractCollectionSection {
    public var isEmpty: Bool { return numberOfItems() == 0 }
    
    public func reload() {
        postReloadNotofication(subject: .section, object: self)
    }
}

public func ==(lhs: AbstractCollectionSection, rhs: AbstractCollectionSection) -> Bool {
    return lhs.identifier == rhs.identifier
}

open class CollectionSection : AbstractCollectionSection {
    public let identifier: String = UUID().uuidString

    open var items: [AbstractCollectionItem] = []
    open var headerItem: AbstractCollectionItem?
    open var footerItem: AbstractCollectionItem?
    
    open var insetForSection: UIEdgeInsets = .zero
    open var minimumInterItemSpacing: CGFloat = CGFloat.leastNormalMagnitude
    open var lineSpacing: CGFloat = 0
    
    public init() {}
    
    public func item(for index: Int) -> AbstractCollectionItem {
        return items[index]
    }
    
    public func numberOfItems() -> Int {
        return items.count
    }

    public func append(item: AbstractCollectionItem, shouldNotify: Bool = false) {
        items.append(item)
        postInsertOrDeleteItemNotification(section: self, indicies: [ items.count - 1 ], action: .insert)
    }

    public func insert(item: AbstractCollectionItem, at index: Int) {
        items.insert(item, at: index)
        postInsertOrDeleteItemNotification(section: self, indicies: [ index ], action: .insert)
    }
    
    public func append(items: [AbstractCollectionItem]) {
        self.items.append(contentsOf: items)
        let oldCount = self.items.count - items.count - 1
        let indicies = Array(oldCount..<self.items.count)
        postInsertOrDeleteItemNotification(section: self, indicies: indicies, action: .insert)
    }
    
    public func insert(items: [AbstractCollectionItem], at indicies: [Int]) {
        for i in 0..<items.count {
            self.items.insert(items[i], at: indicies[i])
        }
        postInsertOrDeleteItemNotification(section: self, indicies: indicies, action: .insert)
    }
    
    public func remove(at index: Int) {
        //todo: consider more correct condition
        guard index < items.count else { return }
        items.remove(at: index)
        postInsertOrDeleteItemNotification(section: self, indicies: [ index ], action: .delete)
    }
    
    public func remove(item: AbstractCollectionItem) {
        guard let index = items.index(where: { $0 == item }) else {
            log("Attempt to remove item from section, which it doesnt belongs to", logLevel: .error)
            return
        }
        
        remove(at: index)
    }
    
    public func remove(items: [AbstractCollectionItem]) {
        items.forEach { [unowned self] (item) in
            guard let index = self.items.index(where: { $0.identifier == item.identifier }) else {
                log("Attempt to delete item , which is not contained at section", logLevel: .error)
                return
            }
            self.items.remove(at: index)
        }
    }
    
    public func remove(at indicies: [Int]) {
        items.remove(at: indicies)
        postInsertOrDeleteItemNotification(section: self, indicies: indicies, action: .delete)
    }
    
    public func reload() {
        postReloadNotofication(subject: .section, object: self)
    }
    
    public func clear() {
        items.removeAll()
        //todo: notify?
    }
    
    public func contains(item: AbstractCollectionItem) -> Bool {
        return items.contains(where: {$0 == item})
    }
    
    public func index(for item: AbstractCollectionItem) -> Int? {
        return items.index(where: {$0 == item})
    }
}

//todo: consider delete this
open class ExpandableSection: CollectionSection {
    open var collapsedItemsCount: Int
    open var isExpanded: Bool = false
    
    //TODO: consider pass isInitiallyExpanded paramater
    public init(collapsedItemsCount: Int) {
        self.collapsedItemsCount = collapsedItemsCount
    }
}
