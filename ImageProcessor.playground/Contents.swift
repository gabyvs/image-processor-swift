//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

// Process the image!
let myRGBA = RGBAImage(image: image)!
let filterMatrixSize = 3

/* * * * * FILTER FUNCTION
* The idea is that I have a 2D filter matrix and the 2D image.
* The center of the filter matrix has to be multiplied with the current pixel, 
* while the other elements of the filter matrix with corresponding neighbor pixels.
* * * * * */
func filter(filterMatrix: [Int]) {
    // Iterating over every pixel in the image
    var resultValues = [Pixel]()
    for y in 0..<myRGBA.height {
        for x in 0..<myRGBA.width {
            var red = 0, green = 0, blue = 0
            
            // For each pixel, iterate over the filter matrix
            for yFilter in 0..<filterMatrixSize {
                for xFilter in 0..<filterMatrixSize {
                    
                    // For each pixel, multiply its filter's size vecinity by the filter
                    
                    // Finding the neighbor position in the image according to the current position of the filter matrix
                    let neighborPositionX = x - filterMatrixSize / 2 + xFilter
                    let neighborPositionY = y - filterMatrixSize / 2 + yFilter
                    
                    // If the position is outside the image, ignore this cycle
                    if (neighborPositionX < 0 || neighborPositionY < 0 || neighborPositionX >= myRGBA.width || neighborPositionY >= myRGBA.height) { continue }
                    
                    let imageNeighborIndex = neighborPositionY * myRGBA.width + neighborPositionX
                    let filterIndex = yFilter * filterMatrixSize + xFilter
                    let neighborPixel = myRGBA.pixels[imageNeighborIndex]
                    
                    red += Int(neighborPixel.red) * filterMatrix[filterIndex]
                    blue += Int(neighborPixel.blue) * filterMatrix[filterIndex]
                    green += Int(neighborPixel.green) * filterMatrix[filterIndex]
                }
            }
            
            let currentIndex = y * myRGBA.height + x
            var imagePixel = myRGBA.pixels[currentIndex]
            imagePixel.red = UInt8(min(255, max(red, 0)))
            imagePixel.green = UInt8(min(255, max(green, 0)))
            imagePixel.blue = UInt8(min(255, max(blue, 0)))
            
            resultValues[currentIndex] = imagePixel
        }
    }
    
    // Assigning generated pixels to the original image
    for y in 0..<myRGBA.height {
        for x in 0..<myRGBA.width {
            let currentIndex = y * myRGBA.height + x
            myRGBA.pixels[currentIndex] = resultValues[currentIndex]
        }
    }
 
}

// Defining filter matrix
let testFilterMatrix = [
    0,0,0,
    0,1,0,
    0,0,0
]






// implement brightness filter
// implement contrast filter
// implement blur filter
// implement motion blur
// implement sharpen filter
// implement grey scale?
