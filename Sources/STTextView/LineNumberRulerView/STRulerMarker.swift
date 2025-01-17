//  Created by Marcin Krzyzanowski
//  https://github.com/krzyzanowskim/STTextView/blob/main/LICENSE.md

import Cocoa

open class STRulerMarker: NSRulerMarker {

    open var size: CGSize = .zero {
        didSet {
            setSize(size)
        }
    }

    public init(rulerView ruler: NSRulerView, markerLocation location: CGFloat, height: CGFloat = 15) {
        super.init(rulerView: ruler, markerLocation: location, image: NSImage(), imageOrigin: .zero)

        self.image = NSImage(size: CGSize(width: ruler.ruleThickness, height: height), flipped: true) { [weak self] rect in
            self?.drawImage(rect)
            return true
        }
    }

    private func setSize(_ newSize: CGSize) {
        image.size = newSize
        ruler?.needsDisplay = true
    }

    @available(*, unavailable)
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func drawImage(_ rect: NSRect) {
        guard let context = NSGraphicsContext.current?.cgContext else { return }

        context.saveGState()

        let bezierPath = NSBezierPath()
        bezierPath.move(to: NSPoint(x: 0, y: rect.height))
        bezierPath.line(to: NSPoint(x: rect.width * 0.85, y: rect.height))
        bezierPath.curve(
            to: NSPoint(x: rect.width, y: rect.height / 2),
            controlPoint1: NSPoint(x: rect.width * 0.85, y: rect.height),
            controlPoint2: NSPoint(x: rect.width, y: rect.height * 0.60)
        )
        bezierPath.curve(
            to: NSPoint(x: rect.width * 0.85, y: 0),
            controlPoint1: NSPoint(x: rect.width, y: rect.height * 0.40 ),
            controlPoint2: NSPoint(x: rect.width * 0.85, y: 0)
        )
        bezierPath.line(to: NSPoint(x: 0, y: 0))
        bezierPath.line(to: NSPoint(x: 0, y: rect.height))
        bezierPath.close()

        NSColor.controlAccentColor.withAlphaComponent(0.7).setFill()
        bezierPath.fill()

        context.restoreGState()

    }
}

