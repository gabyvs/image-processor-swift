import Foundation

/* * * * * FILTER FUNCTION
* The idea is that I have a 2D filter matrix and the 2D image.
* The center of the filter matrix has to be multiplied with the current pixel,
* while the other elements of the filter matrix with corresponding neighbor pixels.
* * * * * */
func filter(myRGBA: RGBAImage, filterMatrix: [Double], filterMatrixSize: Int, factor: Double, bias: Double) {
    // Iterating over every pixel in the image
    var resultValues = [Pixel]()
    for y in 0..<myRGBA.height {
        for x in 0..<myRGBA.width {
            var red = 0.0, green = 0.0, blue = 0.0
            
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
                    
                    red += Double(neighborPixel.red) * filterMatrix[filterIndex]
                    blue += Double(neighborPixel.blue) * filterMatrix[filterIndex]
                    green += Double(neighborPixel.green) * filterMatrix[filterIndex]
                }
            }
            
            let currentIndex = y * myRGBA.height + x
            var imagePixel = myRGBA.pixels[currentIndex]
            imagePixel.red = UInt8(min(255, max(Double(red) * factor + bias, 0)))
            imagePixel.green = UInt8(min(255, max(Double(green) * factor + bias, 0)))
            imagePixel.blue = UInt8(min(255, max(Double(blue) * factor + bias, 0)))
            
            resultValues += [imagePixel]
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

class BrightnessFilter {
    let brightnessMatrix = [1.0]
    let brightnessFactor = 1.0
    let brightnessMatrixSize = 1
    let increaseBrightnessBias = 80.0
    let reduceBrightnessBias = -80.0
    
    func reduceBrightness(image: RGBAImage) {
        filter(image, filterMatrix: brightnessMatrix, filterMatrixSize: brightnessMatrixSize, factor: brightnessFactor, bias: reduceBrightnessBias)
    }
    
    func increaseBrightness(image: RGBAImage) {
        filter(image, filterMatrix: brightnessMatrix, filterMatrixSize: brightnessMatrixSize, factor: brightnessFactor, bias: increaseBrightnessBias)
    }
}

class SharpenEdgesFilter {
    let sharperEdgesMatrix = [
        -1.0, -1.0, -1.0,
        -1.0,  9.0, -1.0,
        -1.0, -1.0, -1.0
    ]
    let subtleEdgesMatrix = [
        -1.0, -1.0, -1.0, -1.0, -1.0,
        -1.0,  2.0,  2.0,  2.0, -1.0,
        -1.0,  2.0,  8.0,  2.0, -1.0,
        -1.0,  2.0,  2.0,  2.0, -1.0,
        -1.0, -1.0, -1.0, -1.0, -1.0
    ]
    let sharperFactor = 1.0
    let subtleFactor = 1.0 / 8.0
    let sharperMatrixSize = 3
    let subtleMatrixSize = 5
    let sharpenBias = 0.0
    
    func subtleEdges(image: RGBAImage) {
        filter(image, filterMatrix: subtleEdgesMatrix, filterMatrixSize: subtleMatrixSize, factor: subtleFactor, bias: sharpenBias)
    }
    
    func sharperEdges(image: RGBAImage) {
        filter(image, filterMatrix: sharperEdgesMatrix, filterMatrixSize: sharperMatrixSize, factor: sharperFactor, bias: sharpenBias)
    }
}

class BlurFilter {
    let softBlurMatrix = [
        0.0, 0.2, 0.0,
        0.2, 0.2, 0.2,
        0.0, 0.2, 0.0
    ]
    let strongBlurMatrix = [
        0.0, 0.0, 1.0, 0.0, 0.0,
        0.0, 1.0, 1.0, 1.0, 0.0,
        1.0, 1.0, 1.0, 1.0, 1.0,
        0.0, 1.0, 1.0, 1.0, 0.0,
        0.0, 0.0, 1.0, 0.0, 0.0
    ]
    let softBlurFactor = 1.0
    let strongBlurFactor = 1.0 / 13.0
    let blurBias = 0.0
    let softBlurMatrixSize = 3
    let strongBlurMatrixSize = 5
    
    func softBlur(image: RGBAImage) {
        filter(image, filterMatrix: softBlurMatrix, filterMatrixSize: softBlurMatrixSize, factor: softBlurFactor, bias: blurBias)
    }
    
    func strongBlur(image: RGBAImage) {
        filter(image, filterMatrix: strongBlurMatrix, filterMatrixSize: strongBlurMatrixSize, factor: strongBlurFactor, bias: blurBias)
    }
}

class MotionFilter {
    let topToBottomMatrix = [
        0.2, 0.0, 0.0, 0.0, 0.0,
        0.0, 0.2, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.2, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.2, 0.0,
        0.0, 0.0, 0.0, 0.0, 0.2
    ]
    let bottomToTopMatrix = [
        0.0, 0.0, 0.0, 0.0, 0.2,
        0.0, 0.0, 0.0, 0.2, 0.0,
        0.0, 0.0, 0.2, 0.0, 0.0,
        0.0, 0.2, 0.0, 0.0, 0.0,
        0.2, 0.0, 0.0, 0.0, 0.0

    ]
    let motionFactor = 1.0
    let motionBias = 0.0
    let motionMatrixSize = 5
    
    func topToBottom(image: RGBAImage) {
        filter(image, filterMatrix: topToBottomMatrix, filterMatrixSize: motionMatrixSize, factor: motionFactor, bias: motionBias)
    }
    
    func bottomToTop(image: RGBAImage) {
        filter(image, filterMatrix: bottomToTopMatrix, filterMatrixSize: motionMatrixSize, factor: motionFactor, bias: motionBias)
    }
}

public enum ImageProcessorError: ErrorType {
    case InvalidSelection
    case EmptyFilters
}

public class ImageProcessor {
    var rgbaImage: RGBAImage
    let brightnessFilter = BrightnessFilter()
    let blurFilter = BlurFilter()
    let motionFilter = MotionFilter()
    let sharpenEdgesFilter = SharpenEdgesFilter()
    
    public let availableFilters = [ "Increase Brightness", "Reduce Brightness", "Subtle Edges", "Sharper Edges", "Soft Blur", "Strong Blur", "Top to Bottom Motion", "Bottom to Top Motion" ]
    var filtersToApply = [String]()
    
    public init(image: RGBAImage) {
        rgbaImage = image
    }
    
    public func useFilter(filterName: String) throws -> String {
        guard availableFilters.indexOf(filterName) > -1 else {
            throw ImageProcessorError.InvalidSelection
        }
        filtersToApply += [filterName]
        return filtersToApply.joinWithSeparator(", ")
    }
    
    public func resetFilters() -> String {
        filtersToApply = []
        return filtersToApply.joinWithSeparator(", ")
    }
    
    public func applyFilters() throws {
        guard filtersToApply.count > 0 else {
            throw ImageProcessorError.EmptyFilters
        }
        for filterName in filtersToApply {
            if filterName == "Increase Brightness" {
                brightnessFilter.increaseBrightness(rgbaImage)
            } else if filterName == "Reduce Brightness" {
                brightnessFilter.reduceBrightness(rgbaImage)
            } else if filterName == "Subtle Edges" {
                sharpenEdgesFilter.subtleEdges(rgbaImage)
            } else if filterName == "Sharper Edges" {
                sharpenEdgesFilter.sharperEdges(rgbaImage)
            } else if filterName == "Soft Blur" {
                blurFilter.softBlur(rgbaImage)
            } else if filterName == "Strong Blur" {
                blurFilter.strongBlur(rgbaImage)
            } else if filterName == "Top to Bottom Motion" {
                motionFilter.topToBottom(rgbaImage)
            } else if filterName == "Bottom to Top Motion" {
                motionFilter.bottomToTop(rgbaImage)
            }            
        }
    }
    
}
