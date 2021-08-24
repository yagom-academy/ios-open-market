//
//  ImageDownloadManager.swift
//  OpenMarket
//
//  Created by Jost, 잼킹 on 2021/08/23.
//

import UIKit

class ImageDownloadManager {
    private var imageDownloadTasks: [URLSessionTask] = []
    
    func downloadImage(at index: Int, with url: String, completion: @escaping (IndexPath) -> Void) {
        guard ImageCacheManager.shared.loadCachedData(for: url) == nil else {
            return
        }
        
        guard let imageUrl = URL(string: url) else {
            return
        }

        guard !imageDownloadTasks.contains(where: { $0.originalRequest?.url == imageUrl }) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageUrl) { (data, resopnce, error) in
            guard error == nil else {
                return
            }
            
            if let imageData = data,
               let image = UIImage(data: imageData) {
                ImageCacheManager.shared.setData(of: image, for: url)
                let reloadItemIndexPath = IndexPath(row: index, section: 0)
                completion(reloadItemIndexPath)
                self.completeTask()
            }
        }
        task.resume()
        imageDownloadTasks.append(task)
    }
    
    private func completeTask() {
        imageDownloadTasks = imageDownloadTasks.filter {
            $0.state != .completed
        }
    }
}
