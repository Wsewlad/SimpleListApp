//
//  WebImage.swift
//  SimpleListApp
//
//  Created by  Vladyslav Fil on 07.08.2021.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImage

extension Image {
    func loadImageByURL(
        _ url: URL?,
        asyncCacheLoading: Bool = false,
        placeholderMode: ContentMode = .fill,
        contentMode: ContentMode = .fill,
        renderingMode: Image.TemplateRenderingMode = .original
    ) -> some View {
        self.modifier(
            webImage(
                url: url,
                image: self,
                asyncCacheLoading: asyncCacheLoading,
                assignTo: .constant(nil),
                renderingMode: renderingMode
            )
        )
    }
    
    func loadImageByPath(_ path: String, asyncCacheLoading: Bool = false, placeholderMode: ContentMode = .fill, contentMode: ContentMode = .fill) -> some View {
        self.modifier(webImage(url: URL(string: path), image: self, asyncCacheLoading: asyncCacheLoading, assignTo: .constant(nil)))
    }
    
    func loadImageByURL(
        _ url: URL?,
        asyncCacheLoading: Bool = false,
        assignTo: Binding<UIImage?>,
        placeholderMode: ContentMode = .fill,
        contentMode: ContentMode = .fill) -> some View {
        self.modifier(
            webImage(
                url: url,
                image: self,
                asyncCacheLoading: asyncCacheLoading,
                assignTo: assignTo,
                placeholderMode: placeholderMode,
                contentMode: contentMode)
        )
    }
    
    func loadImageByURL(_ url: URL?, asyncCacheLoading: Bool = false, placeholderMode: ContentMode = .fill, contentMode: ContentMode = .fill, completion: @escaping (UIImage) -> Void) -> some View {
        self.modifier(webImage(url: url, image: self, asyncCacheLoading: asyncCacheLoading, assignTo: .constant(nil), completion: completion))
    }
}

//MARK: - webImage
private struct webImage: ViewModifier {
    let url: URL?
    let image: Image
    let asyncCacheLoading: Bool
    let assignTo: Binding<UIImage?>
    var placeholderMode: ContentMode = .fill
    var contentMode: ContentMode = .fill
    var completion: (UIImage) -> Void =  {_ in }
    var renderingMode: Image.TemplateRenderingMode = .original

    private var placeholderImage: Image {
        if assignTo.wrappedValue != nil {
            return Image(uiImage: assignTo.wrappedValue!).resizable()
            
        } else {
            return image.renderingMode(renderingMode).resizable()
        }
    }
    
    private var haveImageInCache: Bool {
        guard !asyncCacheLoading else {
            return false
        }
        
        return SDImageCache.shared.diskImageDataExists(withKey: url?.absoluteString)
    }
    
    func body(content: Content) -> some View {
        Group {
            if assignTo.wrappedValue != nil {
                Image(uiImage: assignTo.wrappedValue!)
                    .renderingMode(renderingMode)
                    .aspectFill()
                
            } else if haveImageInCache {
                Image(uiImage: SDImageCache.shared.imageFromCache(forKey: url?.absoluteString)!)
                    .renderingMode(renderingMode)
                    .aspectFill()
                    .onAppear {
                        self.completion(SDImageCache.shared.imageFromCache(forKey: self.url?.absoluteString)!)
                    }
                
            } else {
                WebImage(url: url)
                    .onSuccess(perform: { image, _, _  in
                        if self.assignTo.wrappedValue == nil {
                            self.assignTo.wrappedValue = image
                        }
                        self.completion(image)
                        
                    })
                    .resizable()
                    .renderingMode(renderingMode)
                    .placeholder { placeholderImage.aspectRatio(contentMode: placeholderMode) }
                    .indicator(Indicator.activity)
                    .aspectRatio(contentMode: contentMode)
            }
        }
    }
}
