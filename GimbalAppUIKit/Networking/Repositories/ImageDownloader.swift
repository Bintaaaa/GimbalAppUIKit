//
//  ImageDownloader.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 08/05/23.
//

import Foundation
import UIKit

class ImageDownloader: Operation{
    func downloadImage(url: URL) async throws -> UIImage{
        async let imageData: Data = try Data(contentsOf: url)
        return UIImage(data: try await imageData)!
        
    }
}

class PendingOperation{
    lazy var downloadInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue = {
        var queue = OperationQueue()
        queue.name = "space.bijantyum.imagedownload"
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
}
