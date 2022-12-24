//
//  APIURLSession+APIURLRequest.swift
//  
//
//  Created by Jaehong Kang on 2022/12/11.
//

extension APIURLSession {
    public nonisolated func request<R: APIURLRequestable>(_ request: R) async throws -> (R.ResponseBodyType, URLResponse) {
        let shouldSign: Bool = await {
            if
                let urlAuthenticator = await self.urlAuthenticator,
                await request.shouldSign(by: urlAuthenticator, session: self)
            {
                return true
            } else {
                return false
            }
        }()

        let response: (URLRequestable.Payload, URLResponse) = try await self.request(request, shouldSign: shouldSign)

        return try (request.responseBodyDecoder.decode(R.ResponseBodyType.self, from: response.0.data), response.1)
    }
}
