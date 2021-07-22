//
//  URLProtocolMock.swift
//  
//
//  Created by Anton Pomozov on 22.07.2021.
//

import Foundation

class URLProtocolMock: URLProtocol {
    static var mockURLs: [URL: (error: Error?, data: Data?, response: HTTPURLResponse?)] = [:]

    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let url = request.url else { return }

        if let (error, data, response) = URLProtocolMock.mockURLs[url] {
            if let responseStrong = response {
                client?.urlProtocol(self, didReceive: responseStrong, cacheStoragePolicy: .notAllowed)
            }

            if let dataStrong = data {
                client?.urlProtocol(self, didLoad: dataStrong)
            }

            if let errorStrong = error {
                client?.urlProtocol(self, didFailWithError: errorStrong)
            }
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
