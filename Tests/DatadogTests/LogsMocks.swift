import Foundation
@testable import Datadog

/*
A collection of mocks for Logs objects.
It follows the mocking conventions described in `FoundationMocks.swift`.
 */

extension LogsUploader.ValidURL {
    static func mockAny() -> LogsUploader.ValidURL {
        return try! LogsUploader.ValidURL(
            endpointURL: "https://app.example.com/v2/api",
            clientToken: "abc-def-ghi"
        )
    }
}

extension Log {
    static func mockRandom() -> Log {
        return Log(
            date: .mockRandomInThePast(),
            status: .mockRandom(),
            message: .mockRandom(length: 20),
            service: "ios-sdk-unit-tests"
        )
    }

    static func mockAnyWith(status: Log.Status) -> Log {
        return Log(
            date: .mockRandomInThePast(),
            status: status,
            message: .mockRandom(length: 20),
            service: "ios-sdk-unit-tests"
        )
    }
}

extension Log.Status {
    static func mockRandom() -> Log.Status {
        let statuses: [Log.Status] = [.debug, .info, .notice, .warn, .error, .critical]
        return statuses.randomElement()!
    }
}