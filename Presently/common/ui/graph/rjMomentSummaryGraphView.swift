//
//  rjMomentSummaryGraphView.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-12.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjMomentSummaryGraphView: UIView {
    private let baseLineColor = UIColor.gray
    private let legendFontColor = UIColor.gray
    private let legendHeight = CGFloat(20)
    private let barWidthRatio = CGFloat(0.9)
    private let barColor: UIColor = .rjGreen
    
    var summaryViewModel: rjMomentSummaryGraphViewModel? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), let summaryViewModel = summaryViewModel else {
            return
        }
        
        let legendBounds = CGRect(
            x: bounds.minX,
            y: bounds.maxY - legendHeight,
            width: bounds.size.width,
            height: legendHeight
        )
        
        let barBounds = CGRect(
            x: bounds.minX,
            y: bounds.minY,
            width: bounds.size.width,
            height: bounds.size.height - legendBounds.size.height
        )
        
        drawBaseLine(context: context, rect: barBounds)
        drawBars(context: context, rect: barBounds, ratios: summaryViewModel.ratioValues)
        drawLegend(context: context, rect: legendBounds, columnNames: summaryViewModel.columnNames)
    }

    private func drawLegend(context: CGContext, rect: CGRect, columnNames: [String]) {
        let columnWidth = rect.size.width / CGFloat(columnNames.count)
        var columnLeft = rect.minX

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14.0),
            .foregroundColor: legendFontColor,
        ]
        
        
        for name in columnNames {
            let textSize = (name as NSString).size(withAttributes: textAttributes)
            let textBounds = CGRect(
                x: columnLeft + (columnWidth - textSize.width) / 2,
                y: rect.maxY - textSize.height,
                width: textSize.width,
                height: textSize.height
            )
            
            (name as NSString).draw(in: textBounds, withAttributes: textAttributes)
            
            columnLeft += columnWidth
        }
    }

    private func drawBars(context: CGContext, rect: CGRect, ratios: [Double]) {
        let columnWidth = rect.size.width / CGFloat(ratios.count)
        let barWidth = columnWidth * barWidthRatio
        var columnLeft = rect.minX
        
        for ratio in ratios {
            let barHeight = (rect.maxY - rect.minY) * CGFloat(ratio)
            
            let barBounds = CGRect(
                x: columnLeft + (columnWidth - barWidth) / 2,
                y: rect.maxY - barHeight,
                width: barWidth,
                height: barHeight
            )
            drawBar(context: context, rect: barBounds)
            
            columnLeft += columnWidth
        }
    }
    
    private func drawBar(context: CGContext, rect: CGRect) {
        context.addRect(rect)
        context.setFillColor(barColor.cgColor)
        context.fillPath()
    }
    
    private func drawBaseLine(context: CGContext, rect: CGRect) {
        context.setStrokeColor(baseLineColor.cgColor)
        let baseLineLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let baseLineRight = CGPoint(x: rect.maxX, y: rect.maxY)
        context.addLines(between: [baseLineLeft, baseLineRight])
        context.drawPath(using: .fillStroke)
    }
}
