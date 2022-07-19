//
//  FlowLayout.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/07/19.
//

import UIKit.UICollectionViewFlowLayout

class FlowLayout: UICollectionViewFlowLayout {

    private var attribs = [IndexPath: UICollectionViewLayoutAttributes]()

    override func prepare() {
        self.attribs.removeAll()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var updatedAttributes = [UICollectionViewLayoutAttributes]()

        let sections = self.collectionView?.numberOfSections ?? 0
        var indexPath = IndexPath(item: 0, section: 0)
        while (indexPath.section < sections) {
            guard let items = self.collectionView?.numberOfItems(inSection: indexPath.section) else { continue }

            while (indexPath.item < items) {
                if let attributes = layoutAttributesForItem(at: indexPath), attributes.frame.intersects(rect) {
                    updatedAttributes.append(attributes)
                }

                let headerKind = UICollectionView.elementKindSectionHeader
                if let headerAttributes = layoutAttributesForSupplementaryView(ofKind: headerKind, at: indexPath) {
                    updatedAttributes.append(headerAttributes)
                }

                let footerKind = UICollectionView.elementKindSectionFooter
                if let footerAttributes = layoutAttributesForSupplementaryView(ofKind: footerKind, at: indexPath) {
                    updatedAttributes.append(footerAttributes)
                }
                indexPath.item += 1
            }
            indexPath = IndexPath(item: 0, section: indexPath.section + 1)
        }

        return updatedAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = attribs[indexPath] {
            return attributes
        }

        var rowCells = [UICollectionViewLayoutAttributes]()
        var collectionViewWidth: CGFloat = 0
        if let collectionView = collectionView {
            collectionViewWidth = collectionView.bounds.width - collectionView.contentInset.left
                - collectionView.contentInset.right
        }

        var rowTestFrame: CGRect = super.layoutAttributesForItem(at: indexPath)?.frame ?? .zero
        rowTestFrame.origin.x = 0
        rowTestFrame.size.width = collectionViewWidth

        let totalRows = self.collectionView?.numberOfItems(inSection: indexPath.section) ?? 0

        // From this item, work backwards to find the first item in the row
        // Decrement the row index until a) we get to 0, b) we reach a previous row
        var startIndex = indexPath.row
        while true {
            let lastIndex = startIndex - 1

            if lastIndex < 0 {
                break
            }

            let prevPath = IndexPath(row: lastIndex, section: indexPath.section)
            let prevFrame: CGRect = super.layoutAttributesForItem(at: prevPath)?.frame ?? .zero

            // If the item intersects the test frame, it's in the same row
            if prevFrame.intersects(rowTestFrame) {
                startIndex = lastIndex
            } else {
                // Found previous row, escape!
                break
            }
        }

        // Now, work back UP to find the last item in the row
        // For each item in the row, add it's attributes to rowCells
        var cellIndex = startIndex
        while cellIndex < totalRows {
            let cellPath = IndexPath(row: cellIndex, section: indexPath.section)

            if let cellAttributes = super.layoutAttributesForItem(at: cellPath),
                cellAttributes.frame.intersects(rowTestFrame),
                let cellAttributesCopy = cellAttributes.copy() as? UICollectionViewLayoutAttributes {
                rowCells.append(cellAttributesCopy)
                cellIndex += 1
            } else {
                break
            }
        }

        let flowDelegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout
        let selector = #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))
        let delegateSupportsInteritemSpacing = flowDelegate?.responds(to: selector) ?? false

        var interitemSpacing = minimumInteritemSpacing

        // Check for minimumInteritemSpacingForSectionAtIndex support
        if let collectionView = collectionView, delegateSupportsInteritemSpacing && rowCells.count > 0 {
            interitemSpacing = flowDelegate?.collectionView?(collectionView,
                                                             layout: self,
                                                             minimumInteritemSpacingForSectionAt: indexPath.section) ?? 0
        }

        let aggregateInteritemSpacing = interitemSpacing * CGFloat(rowCells.count - 1)

        var aggregateItemWidths: CGFloat = 0
        for itemAttributes in rowCells {
            aggregateItemWidths += itemAttributes.frame.width
        }

        let alignmentWidth = aggregateItemWidths + aggregateInteritemSpacing
        let alignmentXOffset: CGFloat = (collectionViewWidth - alignmentWidth) / 2

        var previousFrame: CGRect = .zero
        for itemAttributes in rowCells {
            var itemFrame = itemAttributes.frame

            if previousFrame.equalTo(.zero) {
                itemFrame.origin.x = alignmentXOffset
            } else {
                itemFrame.origin.x = previousFrame.maxX + interitemSpacing
            }

            itemAttributes.frame = itemFrame
            previousFrame = itemFrame

            attribs[itemAttributes.indexPath] = itemAttributes
        }

        return attribs[indexPath]
    }
}

