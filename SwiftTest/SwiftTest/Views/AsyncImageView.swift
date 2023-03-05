//
//  AsyncImageView.swift
//  SwiftTest
//
//  Created by Stjepko Zrncic on 27/02/23.
//

import SwiftUI
import Combine

struct AsyncImageView: View {
    private var url: URL
    private var placeholder: Image?
    
    @ObservedObject fileprivate var imageStore = AsyncImageViewStore()
    
    init(url: URL, placeholder: Image? = nil) {
        self.url = url
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            Image(uiImage: imageStore.image)
                .resizable()
                .overlay {
                    if imageStore.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    }
                }
                .onAppear { imageStore.loadImage(url: url) }
                .onDisappear { imageStore.cancel() }
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(url: URL(string: "test")!)
    }
}

fileprivate class AsyncImageViewStore: ObservableObject {
    
    private var subscription: AnyCancellable?
    private let cache = ImageCache.sharedInstance.cache
    
    @Published var isLoading = true
    @Published private(set) var image = UIImage()
    
    
    func loadImage(url: URL) {
        if let image = cache.object(forKey: url as NSURL) {
            self.isLoading = false
            self.image = image
        } else {
            subscription = URLSession.shared
                                   .dataTaskPublisher(for: url)
                                   .map { UIImage(data: $0.data) }
                                   .replaceError(with: nil)
                                   .receive(on: DispatchQueue.main)
                                   .sink(receiveCompletion: { [weak self] completion in
                                       print(completion)
                                       self?.isLoading = false
                                   }, receiveValue: { [weak self] image in
                                       if let image {
                                           self?.image = image
                                           self?.cache.setObject(image, forKey: url as NSURL)
                                       }
                                   })
        }
    }
    
    func cancel() {
        subscription?.cancel()
    }
}

fileprivate class ImageCache {
    static let sharedInstance = ImageCache()
    
    let cache: NSCache<NSURL, UIImage>
    
    private init(){
        self.cache = NSCache<NSURL, UIImage>()
    }
}


