//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!
let myRGBA = RGBAImage(image: image)!

let imageProcessor = ImageProcessor(image: myRGBA)
do {
    try imageProcessor.useFilter("Increase Brightness")
    //try imageProcessor.useFilter("Reduce Brightness")
    //try imageProcessor.useFilter("Subtle Edges")
    try imageProcessor.useFilter("Sharper Edges")
    //try imageProcessor.useFilter("Soft Blur")
    //try imageProcessor.useFilter("Strong Blur")
    //try imageProcessor.useFilter("Top to Bottom Motion")
    //try imageProcessor.useFilter("Bottom to Top Motion")
    try imageProcessor.applyFilters()
    
} catch ImageProcessorError.InvalidSelection {
    print("The filter does not exist")
} catch ImageProcessorError.EmptyFilters {
    print("There are no filters to apply to the image")
}

let result = myRGBA.toUIImage()