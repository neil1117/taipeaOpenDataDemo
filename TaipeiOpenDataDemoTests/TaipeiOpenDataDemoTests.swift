//
//  TaipeiOpenDataDemoTests.swift
//  TaipeiOpenDataDemoTests
//
//  Created by Neil Wu on 2018/7/19.
//  Copyright © 2018年 Neil Wu. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxDataSources
@testable import TaipeiOpenDataDemo

class TaipeiOpenDataDemoTests: XCTestCase {
    
    
    let viewModel = ViewModel()
    let spotCellViewModel = SpotCellViewModel()
    var disposeBag: DisposeBag?
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }
    
    func testViewModel() {
        var spots = [Spot]()
        viewModel.spotResult.asObservable()
            .subscribe(onNext: { section in
                spots = section[0].items
            })
            .addDisposableTo(self.disposeBag!)
        XCTAssertTrue(spots.count == 0)
        XCTAssertTrue(viewModel.offset == 0)
        viewModel.parser(json: fromJSONFile("viewModelTestJson"))
        XCTAssertTrue(spots.count == 1)
        XCTAssertTrue(viewModel.offset == 1)
    }
    
    func testSpotViewModel() {
        var photos = [String]()
        spotCellViewModel.photoResult.asObservable()
            .subscribe(onNext: {section in
                photos = section[0].items
            })
            .addDisposableTo(disposeBag!)
        XCTAssertTrue(photos.count == 0)
        spotCellViewModel.setPhotos(["1", "2", "3", "4", "5"])
        XCTAssertTrue(photos.count == 5)
    }
    
    func fromJSONFile(_ fileName: String) -> Any {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            fatalError("Invalid path for json file")
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("Invalid data from json file")
        }
        var json: [String: Any]? = [:]
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch  {
            
        }
        return json!
    }
    
}
