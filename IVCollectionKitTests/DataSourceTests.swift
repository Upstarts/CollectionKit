//
//  DataSourceTests.swift
//  IVCollectionKitTests
//
//  Created by Igor Vedeneev on 2/15/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import XCTest

class DataSourceTests: IVTestCase {
    func testDataSource_numberOfSectionsAndRows() {
        
        let section1 = CollectionSection()
        section1 += CollectionItem<TestCell>(item: ())
        section1 += CollectionItem<TestCell>(item: ())
        director += section1
        
        let section2 = CollectionSection()
        section2 += CollectionItem<TestCell>(item: ())
        section2 += CollectionItem<TestCell>(item: ())
        director += section2
        
        director.reload()
        
        let numberOfSections = collectionView.numberOfSections == 2
        let numberOfItemsInSection0 = collectionView.numberOfItems(inSection: 0) == 2
        let numberOfItemsInSection1 = collectionView.numberOfItems(inSection: 1) == 2
        
        XCTAssert(numberOfSections && numberOfItemsInSection0 && numberOfItemsInSection1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
