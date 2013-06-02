//
//  NSOutlineView+Extension.m
//  ViewIntrospector
//
//  Created by C. Bess on 6/1/13.
//  Copyright (c) 2013 C. Bess. All rights reserved.
//

#import "NSOutlineView+Extension.h"

@implementation NSOutlineView (Extension)

- (void)autosizeColumns
{
    [self sizeOutlineViewToContents:self];
}

// ref: http://stackoverflow.com/questions/6681750/nsoutlineview-set-max-column-width-with-its-contents
// sizeOutlineViewToContents
// This looks at the cells in an NSOutlineView and shrinks its rows and columns to fit, with the following limitations:
// 1. The data must come from an NSOutlineViewDataSource.  If the NSOutlineView gets its data through bindings, it will throw an exception.
// 2. Text and images will be handled, but other cell types will shrink to the column minimum width.
// 3. Only visible cells will be measured.  Any collapsed cells will be ignored.
// 4. This function has to read the contents of every cell and measure the size of their text.  This will be slow, and scale badly.  Only use on small views, with a few thousand cells at most.
- (void)sizeOutlineViewToContents:(NSOutlineView*) outlineView;
{
    if (outlineView)
    {
        NSInteger rowCount = outlineView.numberOfRows;
        CGFloat maxHeight = 0;
        
        // This implementation doesn't work if the OutlineView data arrive via bindings.  If you want to make it work, be my guest.
        if (!outlineView.dataSource)
        {
            @throw [NSException exceptionWithName:@"DataSourceMissingException"
                                           reason:@"autosizeColumnsOfOutlineView only works when the outlineView has a dataSource."
                                         userInfo:nil];
        }
        else
        {
            for (NSTableColumn *tableColumn in [outlineView tableColumns])
            {
                // Start with the minimum width already specified for the column.
                CGFloat maxWidth = [tableColumn minWidth];
                
                // Allow the space needed for the cell.
                if (maxWidth < [[tableColumn headerCell] cellSize].width)
                    maxWidth = [[tableColumn headerCell] cellSize].width;
                
                for (NSInteger rowIndex = 0; rowIndex < rowCount; rowIndex++)
                {
                    // Find the formatting information used for this cell.
                    // For most tables, the generic [tableColumn dataCell] would tell us the formatting for all cells, and be faster.
                    // Given the way we read the header size, it may be tempting to read the cell size, but this will often just return the size of the most recently displayed cell.
                    NSCell *cell = [tableColumn dataCellForRow:rowIndex];
                    
                    // Obtain the actual data in this cell from the dataSource.
                    id rowItem = [outlineView itemAtRow:rowIndex];
                    id cellObject = [[outlineView dataSource] outlineView:outlineView objectValueForTableColumn:tableColumn byItem:rowItem];
                    
                    // If the cell has a formatter, assume it knows what to do with the object.
                    NSFormatter *cellFormatter = [cell formatter];
                    if (cellFormatter)
                        cellObject = [cellFormatter stringForObjectValue:cellObject];
                    
                    // Text is already the difficult one.
                    if ([cellObject isKindOfClass:[NSString class]])
                    {
                        NSDictionary *cellTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            [cell font], NSFontAttributeName,
                                                            nil];
                        
                        NSString *cellText = cellObject;
                        // Find the space needed to display the cell text.
                        CGSize size = [cellText sizeWithAttributes:cellTextAttributes];
                        
                        // If the current column contains the outline view disclosure arrows, allow for the space needed for indentation.
                        if (tableColumn == [outlineView outlineTableColumn])
                            size.width += ([outlineView levelForRow:rowIndex] + 1) * [outlineView indentationPerLevel];
                        
                        // Cells have a small amount of additional space between them, defined by the outline view.
                        size.width += [outlineView intercellSpacing].width;
                        size.height += [outlineView intercellSpacing].height;
                        // There seems to be one extra pixel needed to display the text at its full width.  I'm not sure where this comes from.
                        size.width += 1;
                        
                        // Update the maxima found.
                        if (maxWidth < size.width)
                            maxWidth = size.width;
                        if (maxHeight < size.height)
                            maxHeight = size.height;
                    }
                    else if ([cellObject isKindOfClass:[NSImage class]])
                    {
                        // Images just need their exact size.
                        NSImage *cellImage = cellObject;
                        CGSize size = [cellImage size];
                        
                        // Update the maxima found.
                        if (maxWidth < size.width)
                            maxWidth = size.width;
                        if (maxHeight < size.height)
                            maxHeight = size.height;
                    }
                }
                
                // Having found the widest cell, apply it to the column.
                [tableColumn setWidth:maxWidth];
            }
        }
        // Having found the highest cell overall, apply it to the table.
//        [outlineView setRowHeight:maxHeight];
    }
}

@end
