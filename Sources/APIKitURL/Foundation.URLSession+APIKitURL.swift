//
//  Foundation.URLSession+APIKitURL.swift
//  
//
//  Created by Jaehong Kang on 2022/12/10.
//

extension URLSession {
    private actor TaskManager {
        var task: URLSessionTask?

        func cancel() async {
            while true {
                guard let task = task else {
                    await Task.yield()
                    continue
                }

                task.cancel()
                break
            }
        }
    }

    /// Convenience method to load data using an URLRequest, creates and resumes an URLSessionDataTask internally.
    ///
    /// - Parameter request: The URLRequest for which to load data.
    /// - Parameter delegate: Task-specific delegate.
    /// - Returns: Data and response.
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        func task() async throws -> (Data, URLResponse) {
            let taskManager = TaskManager()

            return try await withTaskCancellationHandler {
                try await withCheckedThrowingContinuation { continuation in
                    let task = dataTask(with: request) { data, urlResponse, error in
                        guard let data, let urlResponse else {
                            continuation.resume(throwing: error!)
                            return
                        }

                        continuation.resume(returning: (data, urlResponse))
                    }

                    Task {
                        await taskManager.run { taskManager in
                            taskManager.task = task
                        }
                    }
                    task.resume()
                }
            } onCancel: {
                Task {
                    await taskManager.cancel()
                }
            }
        }

        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
        if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
            return try await data(for: request, delegate: nil)
        } else {
            return try await task()
        }
        #else
        return try await task()
        #endif
    }

    /// Convenience method to upload data using an URLRequest, creates and resumes an URLSessionUploadTask internally.
    ///
    /// - Parameter request: The URLRequest for which to upload data.
    /// - Parameter fileURL: File to upload.
    /// - Parameter delegate: Task-specific delegate.
    /// - Returns: Data and response.
    func upload(for request: URLRequest, fromFile fileURL: URL) async throws -> (Data, URLResponse) {
        func task() async throws -> (Data, URLResponse) {
            let taskManager = TaskManager()

            return try await withTaskCancellationHandler {
                try await withCheckedThrowingContinuation { continuation in
                    let task = uploadTask(with: request, fromFile: fileURL) { data, urlResponse, error in
                        guard let data, let urlResponse else {
                            continuation.resume(throwing: error!)
                            return
                        }

                        continuation.resume(returning: (data, urlResponse))
                    }

                    Task {
                        await taskManager.run { taskManager in
                            taskManager.task = task
                        }
                    }
                    task.resume()
                }
            } onCancel: {
                Task {
                    await taskManager.cancel()
                }
            }
        }

        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
        if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
            return try await upload(for: request, fromFile: fileURL, delegate: nil)
        } else {
            return try await task()
        }
        #else
        return try await task()
        #endif
    }

    /// Convenience method to upload data using an URLRequest, creates and resumes an URLSessionUploadTask internally.
    ///
    /// - Parameter request: The URLRequest for which to upload data.
    /// - Parameter bodyData: Data to upload.
    /// - Parameter delegate: Task-specific delegate.
    /// - Returns: Data and response.
    func upload(for request: URLRequest, from bodyData: Data) async throws -> (Data, URLResponse) {
        func task() async throws -> (Data, URLResponse) {
            let taskManager = TaskManager()

            return try await withTaskCancellationHandler {
                try await withCheckedThrowingContinuation { continuation in
                    let task = uploadTask(with: request, from: bodyData) { data, urlResponse, error in
                        guard let data, let urlResponse else {
                            continuation.resume(throwing: error!)
                            return
                        }

                        continuation.resume(returning: (data, urlResponse))
                    }

                    Task {
                        await taskManager.run { taskManager in
                            taskManager.task = task
                        }
                    }
                    task.resume()
                }
            } onCancel: {
                Task {
                    await taskManager.cancel()
                }
            }
        }

        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
        if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
            return try await upload(for: request, from: bodyData, delegate: nil)
        } else {
            return try await task()
        }
        #else
        return try await task()
        #endif
    }

    /// Convenience method to download using an URLRequest, creates and resumes an URLSessionDownloadTask internally.
    ///
    /// - Parameter request: The URLRequest for which to download.
    /// - Parameter delegate: Task-specific delegate.
    /// - Returns: Downloaded file URL and response. The file will not be removed automatically.
    func download(for request: URLRequest) async throws -> (URL, URLResponse) {
        func task() async throws -> (URL, URLResponse) {
            let taskManager = TaskManager()

            return try await withTaskCancellationHandler {
                try await withCheckedThrowingContinuation { continuation in
                    let task = downloadTask(with: request) { url, urlResponse, error in
                        guard let url, let urlResponse else {
                            continuation.resume(throwing: error!)
                            return
                        }

                        continuation.resume(returning: (url, urlResponse))
                    }

                    Task {
                        await taskManager.run { taskManager in
                            taskManager.task = task
                        }
                    }
                    task.resume()
                }
            } onCancel: {
                Task {
                    await taskManager.cancel()
                }
            }
        }

        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
        if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
            return try await download(for: request, delegate: nil)
        } else {
            return try await task()
        }
        #else
        return try await task()
        #endif
    }

    /// Convenience method to resume download, creates and resumes an URLSessionDownloadTask internally.
    ///
    /// - Parameter resumeData: Resume data from an incomplete download.
    /// - Parameter delegate: Task-specific delegate.
    /// - Returns: Downloaded file URL and response. The file will not be removed automatically.
    func download(resumeFrom resumeData: Data) async throws -> (URL, URLResponse) {
        func task() async throws -> (URL, URLResponse) {
            let taskManager = TaskManager()

            return try await withTaskCancellationHandler {
                try await withCheckedThrowingContinuation { continuation in
                    let task = downloadTask(withResumeData: resumeData) { url, urlResponse, error in
                        guard let url, let urlResponse else {
                            continuation.resume(throwing: error!)
                            return
                        }

                        continuation.resume(returning: (url, urlResponse))
                    }

                    Task {
                        await taskManager.run { taskManager in
                            taskManager.task = task
                        }
                    }
                    task.resume()
                }
            } onCancel: {
                Task {
                    await taskManager.cancel()
                }
            }
        }

        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
        if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
            return try await download(resumeFrom: resumeData, delegate: nil)
        } else {
            return try await task()
        }
        #else
        return try await task()
        #endif
    }
}
