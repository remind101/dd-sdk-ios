import Foundation

internal final class FileWriter {
    /// Comma separator used to separate data values written to file.
    private let commaSeparatorData: Data = ",".data(using: .utf8)! // swiftlint:disable:this force_unwrapping
    /// Orchestrator producing reference to writable file.
    private let orchestrator: FilesOrchestrator
    /// JSON encoder used to encode data.
    private let jsonEncoder: JSONEncoder
    /// Max size of encoded value that can be written to file. If this size is exceeded, the write is skipped..
    private let maxWriteSize: Int
    /// Queue used to synchronize writes and perform decoding on background thread.
    private let queue: DispatchQueue

    init(orchestrator: FilesOrchestrator, queue: DispatchQueue, maxWriteSize: Int) {
        self.orchestrator = orchestrator
        self.queue = queue
        self.maxWriteSize = maxWriteSize
        self.jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        if #available(iOS 13.0, OSX 10.15, *) {
            jsonEncoder.outputFormatting = [.withoutEscapingSlashes]
        }
    }

    /// Encodes given value to JSON data and writes it to file.
    /// Comma is used to separate consecutive values in the file.
    func write<T: Encodable>(value: T) {
        queue.async { [weak self] in
            self?.writeOnBackgroundThread(value: value)
        }
    }

    private func writeOnBackgroundThread<T: Encodable>(value: T) {
        do {
            let data = try jsonEncoder.encode(value)

            if data.count > maxWriteSize {
                print("Serialized \(type(of: value)) value is too big. Skipping write.")
                return
            }

            let file = try orchestrator.getWritableFile(writeSize: UInt64(data.count))

            if file.isEmpty {
                try file.append { write in
                    write(data)
                }
            } else {
                try file.append { write in
                    write(commaSeparatorData)
                    write(data)
                }
            }
        } catch {
            print("Failed to write \(type(of: value)) value into file: \(error)")
        }
    }
}