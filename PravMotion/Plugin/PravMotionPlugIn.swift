//
//  PravMotionPlugIn.swift
//  PravMotion
//
//  Created by Pravbk on 05/12/25.
//
extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}

enum Easing {
    
    typealias Function = (Double) -> Double
    
    private static let easingCases: [(id: String, fn: Function)] = [
        ("linear", linear),
        
        ("quad-In", quadIn),
        ("quad-Out", quadOut),
        ("quad-InOut", quadInOut),
        
        ("cubic-In", cubicIn),
        ("cubic-Out", cubicOut),
        ("cubic-InOut", cubicInOut),
        
        ("quart-In", quartIn),
        ("quart-Out", quartOut),
        ("quart-InOut", quartInOut),
        
        ("quint-In", quintIn),
        ("quint-Out", quintOut),
        ("quint-InOut", quintInOut),
        
        ("sine-In", sineIn),
        ("sine-Out", sineOut),
        ("sine-InOut", sineInOut),
        
        ("expo-In", expoIn),
        ("expo-Out", expoOut),
        ("expo-InOut", expoInOut),
        
        ("circ-In", circIn),
        ("circ-Out", circOut),
        ("circ-InOut", circInOut),
        
        ("elastic-In", elasticIn),
        ("elastic-Out", elasticOut),
        ("elastic-InOut", elasticInOut),
        
        ("back-In", backIn),
        ("back-Out", backOut),
        ("back-InOut", backInOut),
        
        //("bounce-In", bounceIn),
        ("bounce-Out", bounceOut)
        //("bounce-InOut", bounceInOut)
    ]
    
    static let displayNames: [String] = easingCases.map { camelCaseToDisplay($0.id) }

    static let functions: [String: Function] =
        Dictionary(uniqueKeysWithValues: zip(displayNames, easingCases.map { $0.fn }))

    private static func camelCaseToDisplay(_ camel: String) -> String {
        let pattern = "([a-z])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: camel.utf16.count)
        let spaced = regex?.stringByReplacingMatches(in: camel, options: [], range: range, withTemplate: "$1 $2") ?? camel
        return spaced.capitalized
    }
    
    // Static easing functions
    static func linear(_ t: Double) -> Double { t }
    
    static func quadIn(_ t: Double) -> Double { t * t }
    static func quadOut(_ t: Double) -> Double { 1 - (1 - t) * (1 - t) }
    static func quadInOut(_ t: Double) -> Double { t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2 }
    
    static func cubicIn(_ t: Double) -> Double { t * t * t }
    static func cubicOut(_ t: Double) -> Double { 1 - pow(1 - t, 3) }
    static func cubicInOut(_ t: Double) -> Double { t < 0.5 ? 4 * t * t * t : 1 - pow(-2 * t + 2, 3) / 2 }
    
    static func quartIn(_ t: Double) -> Double { pow(t, 4) }
    static func quartOut(_ t: Double) -> Double { 1 - pow(1 - t, 4) }
    static func quartInOut(_ t: Double) -> Double { t < 0.5 ? 8 * pow(t, 4) : 1 - pow(-2 * t + 2, 4) / 2 }
    
    static func quintIn(_ t: Double) -> Double { pow(t, 5) }
    static func quintOut(_ t: Double) -> Double { 1 - pow(1 - t, 5) }
    static func quintInOut(_ t: Double) -> Double { t < 0.5 ? 16 * pow(t, 5) : 1 - pow(-2 * t + 2, 5) / 2 }
    
    static func sineIn(_ t: Double) -> Double { 1 - cos((t * .pi) / 2) }
    static func sineOut(_ t: Double) -> Double { sin((t * .pi) / 2) }
    static func sineInOut(_ t: Double) -> Double { -(cos(.pi * t) - 1) / 2 }
    
//    static func expoIn(_ t: Double) -> Double { t == 0 ? 0 : pow(2, 10 * (t - 1)) }
//    static func expoOut(_ t: Double) -> Double { t == 1 ? 1 : 1 - pow(2, -10 * t) }
//    static func expoInOut(_ t: Double) -> Double {(t == 0.0 || t == 1.0) ? t : (t < 0.5 ? 0.5 * pow(2.0, 20.0 * t - 10.0) : -0.5 * pow(2.0, -20.0 * t + 10.0) + 1.0)}
    static func expoIn(_ t: Double) -> Double { t == 0 ? 0 : pow(2, 10 * t - 10) }
    static func expoOut(_ t: Double) -> Double { t == 1 ? 1 : 1 - pow(2, -10 * t) }
    static func expoInOut(_ t: Double) -> Double { t == 0 ? 0 : t == 1 ? 1 : t < 0.5 ? pow(2, 20 * t - 10) / 2 : (2 - pow(2, -20 * t + 10)) / 2}
    
    static func circIn(_ t: Double) -> Double { 1 - sqrt(1 - t * t) }
    static func circOut(_ t: Double) -> Double { sqrt(1 - pow(t - 1, 2)) }
    static func circInOut(_ t: Double) -> Double {
        t < 0.5 ? (1 - sqrt(1 - pow(2 * t, 2))) / 2 : (sqrt(1 - pow(-2 * t + 2, 2)) + 1) / 2
    }
    static func elasticIn(_ t: Double) -> Double {
        let easedT = sin((t * .pi) / 2) //pow(t - 1, 5) + 1 //let frequency = 8 + 5 * pow(easedT, 3) replace 13 with frequency
        return sin(13 * .pi / 2 * easedT) * pow(2.0, 10 * (easedT - 1))
    }
    static func elasticOut(_ t: Double) -> Double {
        let easedT = pow(t, 2)  // Slow ease-in start
        return sin(-13 * .pi / 2 * (easedT + 1)) * pow(2, -10 * easedT) + 1
    }
    static func elasticInOut(_ t: Double) -> Double {
        if t < 0.5 {
            return 0.5 * sin(13 * Double.pi / 2 * (2 * t)) * pow(2, 10 * (2 * t - 1))
        } else {
            return 0.5 * (sin(-13 * Double.pi / 2 * ((2 * t - 1) + 1)) * pow(2, -10 * (2 * t - 1)) + 2)
        }
    }
    
    static func backIn(_ t: Double) -> Double {
        pow(1 - pow(1 - t, 3), 3) - (1 - pow(1 - t, 3)) * sin((1 - pow(1 - t, 3)) * .pi) * 0.5
        //return t * t * t - t * sin(t * .pi)
    }
    static func backOut(_ t: Double) -> Double {
        let ti = 1.0 - pow(1.0 - t, 1.0)
        let p = 1.0 - ti
        return 1.0 - (p*p*p - 0.5 * p * sin(p * .pi)) //0.5 is overshoot
    }
    static func backInOut(_ t: Double) -> Double {
        if t < 0.5 {
            let p = 2.0 * t
            return 0.5 * (p * p * p - 0.7 * p * sin(p * .pi))
        }
        let p = 1.0 - (2.0 * t - 1.0)
        return 0.5 * (1.0 - (p * p * p - 0.7 * p * sin(p * .pi))) + 0.5
    }
    
    static func bounceIn(_ t: Double) -> Double {
        let u = 1 - t
        return u < 1 / 2.75 ? 1 - 7.5625 * u * u :
               u < 2 / 2.75 ? 1 - (7.5625 * (u - 1.5 / 2.75) * (u - 1.5 / 2.75) + 0.75) :
               u < 2.5 / 2.75 ? 1 - (7.5625 * (u - 2.25 / 2.75) * (u - 2.25 / 2.75) + 0.9375) :
               1 - (7.5625 * (u - 2.625 / 2.75) * (u - 2.625 / 2.75) + 0.984375)
    }
    static func bounceOut(_ t: Double) -> Double {
        t < 1 / 2.75 ? 7.5625 * t * t :
        t < 2 / 2.75 ? 7.5625 * (t - 1.5 / 2.75) * (t - 1.5 / 2.75) + 0.75 :
        t < 2.5 / 2.75 ? 7.5625 * (t - 2.25 / 2.75) * (t - 2.25 / 2.75) + 0.9375 :
        7.5625 * (t - 2.625 / 2.75) * (t - 2.625 / 2.75) + 0.984375
    }
    static func bounceInOut(_ t: Double) -> Double {
        if t < 0.5 {
            let u = 1 - 2 * t
            return u < 1 / 2.75 ? (1 - 7.5625 * u * u) / 2 :
                   u < 2 / 2.75 ? (1 - (7.5625 * (u - 1.5 / 2.75) * (u - 1.5 / 2.75) + 0.75)) / 2 :
                   u < 2.5 / 2.75 ? (1 - (7.5625 * (u - 2.25 / 2.75) * (u - 2.25 / 2.75) + 0.9375)) / 2 :
                   (1 - (7.5625 * (u - 2.625 / 2.75) * (u - 2.625 / 2.75) + 0.984375)) / 2
        } else {
            let u = 2 * t - 1
            return u < 1 / 2.75 ? (7.5625 * u * u) / 2 + 0.5 :
                   u < 2 / 2.75 ? (7.5625 * (u - 1.5 / 2.75) * (u - 1.5 / 2.75) + 0.75) / 2 + 0.5 :
                   u < 2.5 / 2.75 ? (7.5625 * (u - 2.25 / 2.75) * (u - 2.25 / 2.75) + 0.9375) / 2 + 0.5 :
                   (7.5625 * (u - 2.625 / 2.75) * (u - 2.625 / 2.75) + 0.984375) / 2 + 0.5
        }
    }
}

@objc(PravMotionPlugIn) class PravMotionPlugIn : NSObject, FxTileableEffect {

    let _apiManager: PROAPIAccessing!
    required init?(apiManager: PROAPIAccessing) {
        _apiManager = apiManager
        super.init()
    }

    // MARK: Parameters

    func addParameters() throws {
        let paramAPI = _apiManager!.api(for: FxParameterCreationAPI_v5.self) as! FxParameterCreationAPI_v5
        paramAPI.addPopupMenu(withName: "Type of Animations", parameterID: 1, defaultValue: 0, menuEntries: Easing.displayNames, parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
        paramAPI.addIntSlider(withName: "Duration (in Frames)", parameterID: 2, defaultValue: 20, parameterMin: 10, parameterMax: 100000, sliderMin: 10, sliderMax: 100000, delta: 1, parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
        paramAPI.addIntSlider(withName: "Time Offset (in Frames)", parameterID: 3, defaultValue: 0, parameterMin: 0, parameterMax: 100000, sliderMin: 0, sliderMax: 100000, delta: 1, parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
        paramAPI.addFloatSlider(withName: "From Scale", parameterID: 4, defaultValue: 100.0, parameterMin: -100.0, parameterMax: 200.0, sliderMin: -100.0, sliderMax: 200.0, delta: 0.01, parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
        paramAPI.addFloatSlider(withName: "To Scale", parameterID: 5, defaultValue: 100.0, parameterMin: -100.0, parameterMax: 200.0, sliderMin: -100.0, sliderMax: 200.0, delta: 0.01, parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
        paramAPI.addPointParameter(withName: "From Position", parameterID: 6, defaultX: 0.50, defaultY: 0.50, parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
        paramAPI.addPointParameter(withName: "To Position", parameterID: 7, defaultX: 0.50, defaultY: 0.50, parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
        paramAPI.addAngleSlider(withName: "From Rotation", parameterID: 8, defaultDegrees: 0.0, parameterMinDegrees: -3600.0, parameterMaxDegrees: 3600.0, parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
        paramAPI.addAngleSlider(withName: "To Rotation", parameterID: 9, defaultDegrees: 0.0, parameterMinDegrees: -180.0, parameterMaxDegrees: 180.0, parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
        paramAPI.addIntSlider(withName: "From Opacity", parameterID: 10, defaultValue: 100, parameterMin: 0, parameterMax: 100, sliderMin: 0, sliderMax: 100, delta: 1, parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
        paramAPI.addIntSlider(withName: "To Opacity", parameterID: 11, defaultValue: 100, parameterMin: 0, parameterMax: 100, sliderMin: 0, sliderMax: 100, delta: 1, parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
        paramAPI.addPushButton(withName: "From → To", parameterID: 12, selector: #selector(copyFromValues), parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
        paramAPI.addPushButton(withName: "To → From", parameterID: 13, selector: #selector(copyToValues), parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
        paramAPI.addPushButton(withName: "Offset to Playhead", parameterID: 14, selector: #selector(updateOffsetToCurrentTime), parameterFlags: FxParameterFlags(kFxParameterFlag_DEFAULT))
    }
    @objc func updateOffsetToCurrentTime() {
//        let paramAPI = _apiManager!.api(for: FxParameterRetrievalAPI_v6.self) as! FxParameterRetrievalAPI_v6
        let paramsetAPI = _apiManager!.api(for: FxParameterSettingAPI_v5.self) as! FxParameterSettingAPI_v5
        let timingAPI = _apiManager!.api(for: FxTimingAPI_v4.self) as! FxTimingAPI_v4
        let actionAPI = _apiManager!.api(for: FxCustomParameterActionAPI_v4.self) as! FxCustomParameterActionAPI_v4
        
//        var timeOffset = Int32(0)
//        paramAPI.getIntValue(&timeOffset, fromParameter: 3, at: CMTime.zero)
        actionAPI.startAction(self)

        let now = actionAPI.currentTime()

        var frameDuration = CMTime.zero
        timingAPI.frameDuration(&frameDuration)

        if frameDuration.value > 0 {
            let currentFrame = Int32(now.value / frameDuration.value)
            
            paramsetAPI.setIntValue(currentFrame, toParameter: 3, at: .zero)
        }

        actionAPI.endAction(self)
    }
    @objc func copyFromValues() {
        let paramAPI = _apiManager!.api(for: FxParameterRetrievalAPI_v6.self) as! FxParameterRetrievalAPI_v6
        let paramsetAPI = _apiManager!.api(for: FxParameterSettingAPI_v5.self) as! FxParameterSettingAPI_v5
        
        var fromScale = 1.0
        paramAPI.getFloatValue(&fromScale, fromParameter: 4, at: CMTime.zero)
        var x = 0.0, y = 0.0
        paramAPI.getXValue(&x, yValue: &y, fromParameter: 6, at: CMTime.zero)
        var fromRotation = 0.0
        paramAPI.getFloatValue(&fromRotation, fromParameter: 8, at: CMTime.zero)
        var fromOpacity = Int32(20)
        paramAPI.getIntValue(&fromOpacity, fromParameter: 10, at: CMTime.zero)
        fromOpacity = max(0, fromOpacity)

        paramsetAPI.setFloatValue(fromScale, toParameter: 5, at: CMTime.zero)
        paramsetAPI.setXValue(x, yValue: y, toParameter: 7, at: CMTime.zero)
        paramsetAPI.setFloatValue(fromRotation, toParameter: 9, at: CMTime.zero)
        paramsetAPI.setIntValue(fromOpacity, toParameter: 11, at: CMTime.zero)
    }

    @objc func copyToValues() {
        let paramAPI = _apiManager!.api(for: FxParameterRetrievalAPI_v6.self) as! FxParameterRetrievalAPI_v6
        let paramsetAPI = _apiManager!.api(for: FxParameterSettingAPI_v5.self) as! FxParameterSettingAPI_v5
        
        var toScale = 1.0
        paramAPI.getFloatValue(&toScale, fromParameter: 5, at: CMTime.zero)
        var x = 0.0, y = 0.0
        paramAPI.getXValue(&x, yValue: &y, fromParameter: 7, at: CMTime.zero)
        var toRotation = 0.0
        paramAPI.getFloatValue(&toRotation, fromParameter: 9, at: CMTime.zero)
        var toOpacity = Int32(20)
        paramAPI.getIntValue(&toOpacity, fromParameter: 11, at: CMTime.zero)
        toOpacity = max(0, toOpacity)

        paramsetAPI.setFloatValue(toScale, toParameter: 4, at: CMTime.zero)
        paramsetAPI.setXValue(x, yValue: y, toParameter: 6, at: CMTime.zero)
        paramsetAPI.setFloatValue(toRotation, toParameter: 8, at: CMTime.zero)
        paramsetAPI.setIntValue(toOpacity, toParameter: 10, at: CMTime.zero)
    }

    // MARK: Properties

    func properties(_ properties: AutoreleasingUnsafeMutablePointer<NSDictionary>?) throws {
        let swiftProps: [String: Any] = [kFxPropertyKey_MayRemapTime: NSNumber(booleanLiteral: false),kFxPropertyKey_PixelTransformSupport: NSNumber(value: kFxPixelTransform_ScaleTranslate),kFxPropertyKey_VariesWhenParamsAreStatic: NSNumber(booleanLiteral: false)]
        properties?.pointee = NSDictionary(dictionary: swiftProps)
    }

    // MARK: State / timing

    func pluginState(_ pluginState: AutoreleasingUnsafeMutablePointer<NSData>?, at renderTime: CMTime, quality qualityLevel: UInt) throws {
        let paramAPI = _apiManager!.api(for: FxParameterRetrievalAPI_v6.self) as! FxParameterRetrievalAPI_v6
        let timingAPI = _apiManager!.api(for: FxTimingAPI_v4.self) as! FxTimingAPI_v4

        var effectStartTime = CMTime.zero
        timingAPI.startTime(forEffect: &effectStartTime)

        var frameDuration = CMTime.zero
        timingAPI.frameDuration(&frameDuration)

        var frameDurationSeconds = frameDuration.seconds
        if !frameDurationSeconds.isFinite || frameDurationSeconds <= 0 {
            frameDurationSeconds = 1.0 / 30.0
        }

        var effectDuration = CMTime.zero
        timingAPI.durationTime(forEffect: &effectDuration)

        var durationSeconds = effectDuration.seconds
        if !durationSeconds.isFinite || durationSeconds <= 0 {
            durationSeconds = 0
        }

        let totalFramesDouble = durationSeconds / frameDurationSeconds
        let totalFrames = Int32(max(0, floor(totalFramesDouble)))

        var easingIndex = Int32(0)
        paramAPI.getIntValue(&easingIndex, fromParameter: 1, at: renderTime)

        var rawNFrames = Int32(20)
        paramAPI.getIntValue(&rawNFrames, fromParameter: 2, at: renderTime)

        var rawOffset = Int32(0)
        paramAPI.getIntValue(&rawOffset, fromParameter: 3, at: renderTime)

        let nFrames = max(0, min(rawNFrames, totalFrames))
        let maxOffset = max(0, totalFrames - nFrames)
        let tOffset = max(0, min(rawOffset, maxOffset))

        var fromScale = 1.0
        paramAPI.getFloatValue(&fromScale, fromParameter: 4, at: renderTime)
        fromScale = fromScale/100.0
        var toScale = 1.0
        paramAPI.getFloatValue(&toScale, fromParameter: 5, at: renderTime)
        toScale = toScale/100.0
        
        var fromTranslateX = 0.0, fromTranslateY = 0.0
        paramAPI.getXValue(&fromTranslateX, yValue:&fromTranslateY, fromParameter: 6, at: renderTime)

        var toTranslateX = 0.0, toTranslateY = 0.0
        paramAPI.getXValue(&toTranslateX, yValue:&toTranslateY, fromParameter: 7, at: renderTime)
        
        var fromRotation = 0.0
        paramAPI.getFloatValue(&fromRotation, fromParameter: 8, at: renderTime)
        var toRotation = 0.0
        paramAPI.getFloatValue(&toRotation, fromParameter: 9, at: renderTime)
        
        var fromOpacity = Int32(100)
        paramAPI.getIntValue(&fromOpacity, fromParameter: 10, at: renderTime)
        let f_Opacity = Double(fromOpacity)/100.0
        var toOpacity = Int32(100)
        paramAPI.getIntValue(&toOpacity, fromParameter: 11, at: renderTime)
        let t_Opacity = Double(toOpacity)/100.0
        
        let easingName = Easing.displayNames[safe: Int(easingIndex)] ?? "Linear"
        let easing = Easing.functions[easingName] ?? Easing.linear
        let localSeconds = max(0.0, renderTime.seconds - effectStartTime.seconds)
        let frameIndex = localSeconds / frameDurationSeconds
        let offsetFrame = Double(tOffset)
        let effectiveFrameIndex = max(0.0, frameIndex - offsetFrame)
        var t = effectiveFrameIndex / Double(nFrames)
        t = min(max(t, 0), 1)
        let easedT = easing(t)
        let currentScale = fromScale == toScale ? fromScale : fromScale + (toScale - fromScale) * easedT
        let currentTranslateX = (fromTranslateX - 0.5) + ((toTranslateX - 0.5) - (fromTranslateX - 0.5)) * easedT
        let currentTranslateY = (fromTranslateY - 0.5) + ((toTranslateY - 0.5) - (fromTranslateY - 0.5)) * easedT
        let currentRotation = fromRotation + (toRotation - fromRotation) * easedT
        
        let op_ease = Easing.functions["quadInOut"] ?? Easing.quadInOut
        let op_easedT = easingIndex <= 21 ? easedT : op_ease(t)
        let opacity = f_Opacity == t_Opacity ? f_Opacity : f_Opacity + (t_Opacity - f_Opacity) * op_easedT
        
        let scaleFactor = Float(currentScale)
        let translateMultX = Float(currentTranslateX)
        let translateMultY = Float(currentTranslateY)
        let rotation = Float(currentRotation)
        let brightness = Float(opacity)

        var state = (brightness, scaleFactor, translateMultX, translateMultY, rotation)
        pluginState?.pointee = NSData(bytes: &state, length: MemoryLayout<(Float, Float, Float, Float, Float)>.size)
    }




    // MARK: Tiling

    func destinationImageRect(_ destinationImageRect: UnsafeMutablePointer<FxRect>, sourceImages: [FxImageTile], destinationImage: FxImageTile, pluginState: Data?, at renderTime: CMTime) throws {
        destinationImageRect.pointee = sourceImages[0].imagePixelBounds
    }

    func sourceTileRect(_ sourceTileRect: UnsafeMutablePointer<FxRect>, sourceImageIndex: UInt, sourceImages: [FxImageTile], destinationTileRect: FxRect, destinationImage: FxImageTile, pluginState: Data?, at renderTime: CMTime) throws {
        sourceTileRect.pointee = destinationTileRect
    }

    // MARK: Rendering

    func renderDestinationImage(_ destinationImage: FxImageTile, sourceImages: [FxImageTile], pluginState: Data?, at renderTime: CMTime) throws {
        let state = pluginState?.withUnsafeBytes {(ptr: UnsafeRawBufferPointer) in ptr.bindMemory(to: (Float, Float, Float, Float, Float).self).baseAddress?.pointee}
        let brightness = state?.0 ?? 1.0
        let scaleFactor = state?.1 ?? 1.0
        let translateMultX = state?.2 ?? 0.0  // Now direct multiplier
        let translateMultY = state?.3 ?? 0.0
        let rotation = state?.4 ?? 0.0

        let deviceCache = MetalDeviceCache.deviceCache
        let pixelFormat = MetalDeviceCache.FxMTLPixelFormat(for: destinationImage)
        let commandQueue = deviceCache.commandQueue(with: sourceImages[0].deviceRegistryID, pixelFormat: pixelFormat)!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        commandBuffer.label = "PravMotion Command Buffer"
        commandBuffer.enqueue()

        let device = deviceCache.device(with: sourceImages[0].deviceRegistryID)
        let inputTexture = sourceImages[0].metalTexture(for: device)
        let outputTexture = destinationImage.metalTexture(for: device)

        let colorAttachmentDescriptor = MTLRenderPassColorAttachmentDescriptor()
        colorAttachmentDescriptor.texture = outputTexture
        colorAttachmentDescriptor.clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 0.0)
        colorAttachmentDescriptor.loadAction = .clear

        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0] = colorAttachmentDescriptor

        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!

        let outputWidth = destinationImage.tilePixelBounds.right - destinationImage.tilePixelBounds.left
        let outputHeight = destinationImage.tilePixelBounds.top - destinationImage.tilePixelBounds.bottom

        // Apply multipliers to get final pixel offsets
        let halfW = Float(outputWidth) * 0.5
        let halfH = Float(outputHeight) * 0.5
        let translateX = -translateMultX * Float(outputWidth)
        let translateY = translateMultY * Float(outputHeight)
        let scaledHalfW = halfW * scaleFactor
        let scaledHalfH = halfH * scaleFactor  // Fixed typo: scaledHalfH
        let cosTheta = cosf(rotation)
        let sinTheta = sinf(rotation)

        var vertices = [
            Vertex2D(position: vector_float2(cosTheta * scaledHalfW - sinTheta * (-scaledHalfH) - translateX, sinTheta * scaledHalfW + cosTheta * (-scaledHalfH) - translateY), textureCoordinate: vector_float2(1.0, 1.0)),
            Vertex2D(position: vector_float2(cosTheta * (-scaledHalfW) - sinTheta * (-scaledHalfH) - translateX, sinTheta * (-scaledHalfW) + cosTheta * (-scaledHalfH) - translateY), textureCoordinate: vector_float2(0.0, 1.0)),
            Vertex2D(position: vector_float2(cosTheta * scaledHalfW - sinTheta * (scaledHalfH) - translateX, sinTheta * scaledHalfW + cosTheta * (scaledHalfH) - translateY), textureCoordinate: vector_float2(1.0, 0.0)),
            Vertex2D(position: vector_float2(cosTheta * (-scaledHalfW) - sinTheta * (scaledHalfH) - translateX, sinTheta * (-scaledHalfW) + cosTheta * (scaledHalfH) - translateY), textureCoordinate: vector_float2(0.0, 0.0))
        ]
//        var vertices = [
//            Vertex2D(position: vector_float2( scaledHalfW, -scaledHalfH), textureCoordinate: vector_float2(1.0, 1.0)),
//            Vertex2D(position: vector_float2(-scaledHalfW, -scaledHalfH), textureCoordinate: vector_float2(0.0, 1.0)),
//            Vertex2D(position: vector_float2( scaledHalfW,  scaledHalfH), textureCoordinate: vector_float2(1.0, 0.0)),
//            Vertex2D(position: vector_float2(-scaledHalfW,  scaledHalfH), textureCoordinate: vector_float2(0.0, 0.0))
//        ]
//
//        let cosTheta = cosf(rotation)
//        let sinTheta = sinf(rotation)
//        for i in 0..<4 {
//            let x = vertices[i].position.x
//            let y = vertices[i].position.y
//            vertices[i].position.x = cosTheta * x - sinTheta * y
//            vertices[i].position.y = sinTheta * x + cosTheta * y
//        }
//        for i in 0..<4 {
//            vertices[i].position.x -= translateX
//            vertices[i].position.y -= translateY
//        }

        
        let viewport = MTLViewport(originX: 0, originY: 0, width: Double(outputWidth), height: Double(outputHeight), znear: -1.0, zfar: 1.0)
        commandEncoder.setViewport(viewport)

        let pipelineState = deviceCache.pipelineState(with: sourceImages[0].deviceRegistryID, pixelFormat: pixelFormat)
        commandEncoder.setRenderPipelineState(pipelineState!)

        commandEncoder.setVertexBytes(&vertices, length: MemoryLayout<Vertex2D>.size * 4, index: Int(BVI_Vertices.rawValue))

        var viewportSize = simd_uint2(UInt32(outputWidth), UInt32(outputHeight))
        commandEncoder.setVertexBytes(&viewportSize, length: MemoryLayout.size(ofValue: viewportSize), index: Int(BVI_ViewportSize.rawValue))

        commandEncoder.setFragmentTexture(inputTexture, index: Int(BTI_InputImage.rawValue))

        var fragmentBrightness = Float(brightness)
        commandEncoder.setFragmentBytes(&fragmentBrightness, length: MemoryLayout.size(ofValue: fragmentBrightness), index: Int(BFI_Brightness.rawValue))

        commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)

        commandEncoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()

        deviceCache.returnCommandQueueToCache(commandQueue: commandQueue)
    }

}

