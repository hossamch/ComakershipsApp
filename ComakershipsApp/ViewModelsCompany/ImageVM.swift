//
//  ImageVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 11/01/2022.
//

import Foundation

public final class ImageVM: ObservableObject{
    func loadImage(url: String) -> Data{
        do{
            guard let url = URL(string: url)else{
                return Data()
            }
            let data: Data = try Data(contentsOf: url)
            return data
        }
        catch{
            print(error)
        }
        
        return Data()
    }
}
