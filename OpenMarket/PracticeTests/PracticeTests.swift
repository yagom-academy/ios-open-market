//
//  PracticeTests.swift
//  PracticeTests
//
//  Created by 이성노 on 2021/05/13.
//

import XCTest
@testable import OpenMarket //연동하기 위해서 임폴트 함

class PracticeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // 테스트 코드를 작성을 할 떄, 항상 어떤 테스트 코드를 작성할 때 시작할때 작업을 해주고 싶을때 (객체를 만들거나) 매 테스트마다 넣을 수 없으니까 테스트 전에 우리가 먼저 셋업,준비해줄게
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        //테스트가 끝났을 때 이걸 해줄게
    }
    
    func test_personJSON데이터가_personData에_Decoding_되어서_0번째인덱스에_야곰이들어왔는지확인() {
        var jsonPersonData = JSONPersonData()
        
        jsonPersonData.parseJSONData(assetName: "PersonJSON")
        
        XCTAssertEqual(jsonPersonData.personData[0].name, "야곰")
    }
}


