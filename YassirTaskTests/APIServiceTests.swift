//
//  APIServiceTests.swift
//  YassirTaskTests
//
//  Created by lamiaa on 7/4/23.
//

import XCTest
@testable import YassirTask

class APIServiceTests: XCTestCase {
    
    var sut: APIService?
    
    override func setUp() {
        super.setUp()
        sut = APIService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetch_popular_movies() {
        // Given A apiservice
        let sut = self.sut!
        // When fetch popular movies
        let expect = XCTestExpectation(description: "callback")
        sut.fetchMoves(page: -200) { (success, movies, error) in
            expect.fulfill()
            XCTAssertEqual( movies?.count, 20)
            for movie in movies! {
                XCTAssertNotNil(movie.id)
            }
        }
        wait(for: [expect], timeout: 3.1)
    }
    func test_fetch_detail_movie() {
        // Given A apiservice
        let sut = self.sut!
        // When fetch popular movies
        let expect = XCTestExpectation(description: "callback")
        sut.fetchMovieDetails(id:  385687) { (success, movie, error) in
            expect.fulfill()
               XCTAssertNotNil( movie?.title)
               XCTAssertNotNil(movie?.id)
        }
        wait(for: [expect], timeout: 3.1)
    }
}
