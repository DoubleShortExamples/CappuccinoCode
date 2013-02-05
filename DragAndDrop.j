Drag and Drop in Cappuccino

In a nutshell, a drag and drop operation is dragging a CPView and dropping it onto another CPView.   All CPViews residing inside the dragging CPView will go with it.

The CPView being dragged is the Source view.  The CPView where the drop occurs is the Destination view.

A CPView may be dropped in several places:
    - in a view in the same window
    - in a view in another window
    - or dropped inside the same view in which it came from (or any of it's parent views)

Below are the requirements for what must be done to make a view dragable and a view droppable.  They may not make sense by a newcomer reading but see the example code that will show you how you fullfill these requirements.

Requirements For Making A CPView Draggable:

1.  One method makes a CPView draggeable and it must be implemented in the Source CPView subclass:

    -(void)mouseDragged:(CPEvent)anEvent

2.  A CPPasteboard object must be created with the type of drag operation that the Destination view wants to accept.


Requirements For Making A CPView Draggable:

1.  Two methods must be implemented in the Destination CPView subclass in order to allow it to take a dragged CPView:

    -(BOOL)prepareForDragOperation:(CPDraggingInfo)aSender
    -(BOOL)performDragOperation:(CPDraggingInfo)aSender

2.  The CPView taking a dragged view must Register itself with the type of drag operation it wants to accept.


Note about Registering:  Only CPView may be registerable, not CPWindows.



Place the following code in a file and call it AppController.j  Works as a replacement file for the same file AppController.j in the sample code downloadeable here:

@import <Foundation/CPObject.j>

// Declare a custom drag type the describes what the drag operation is doing
// Mine is dragging an icon, therefore my name...
var IconDragType = "IconDragType";

@implementation AppController : CPObject
{
    MainView mainView;
    IconView iconView;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
    var contentView = [theWindow contentView];
    
    iconView = [[IconView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    [iconView setup];
    
    var mainView = [[MainView alloc] initWithFrame:[contentView bounds]];
    [mainView setBackgroundColor:[CPColor grayColor]];
    
    // Main view is a CPView subclass and is being register to accept a drop of type: IconDragType.
    [mainView registerForDraggedTypes:[IconDragType]];
    
    [contentView addSubview:mainView];
    [contentView addSubview:iconView];
    
    [theWindow orderFront:self];
}

@end


@implementation IconView : CPView
{
    IconImageView iconImageView;
    CPTextField textField;
}

- (void)setup
{
    [self setBackgroundColor:[CPColor blackColor]];
    
    var fontSize = 24;
    var x, y, width, height;
    x = [self frame].size.width / 2 - ([self frame].size.width/2);
    y = [self frame].size.height - 60;
    width = [self frame].size.width;
    height = fontSize * 3;
    textField = [[CPTextField alloc] initWithFrame: CGRectMake(x, y, width, height)];
    [textField setEditable:NO];
    [textField setLineBreakMode:CPLineBreakByWordWrapping];
    [textField setTextColor:[CPColor whiteColor]];
    [textField setFont:[CPFont systemFontOfSize:fontSize]];
    [textField setAlignment:CPCenterTextAlignment];
    [textField setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin];
    [textField setPlaceholderString:@"Test Icon"];
    [self addSubview:textField];
    
    var imageDimension = 100;
    var buffer = 10;
    var centerx = ([self frame].size.width/2) - (imageDimension/2);

    iconImageView = [[IconImageView alloc] initWithFrame:CGRectMake(centerx, buffer, 100, 100)];
    [iconImageView setBackgroundColor:[CPColor redColor]];
    [iconImageView setParent:self];
    [self addSubview:iconImageView];
}
@end

@implementation IconImageView : CPView
{
    id parent @accessors;
}

- (void)mouseDragged:(CPEvent)anEvent
{
    // Drag Pasteboard is genarally used, but not required
    var pasteboard = [CPPasteboard pasteboardWithName:CPDragPboard];
    // declare the pasteboard types it will hold
    [pasteboard declareTypes:[IconDragType] owner:self];
    // then set the data for those types.
    [pasteboard setData:[CPData dataWithRawString:@"sample string data for pasteboard"] forType:IconDragType];
    
    [self dragView:parent at:CPMakePoint(0,0) offset:CPSizeMakeZero() event:anEvent pasteboard:pasteboard source:self slideBack:YES];
}

@end


@implementation MainView : CPView

////optional
//- (BOOL)wantsPeriodicDraggingUpdates
//{
//    return YES;
//}
//
////optional
//- (void)draggingEnded:(id)sender
//{
//    console.log("ended");
//}
//
////optional
//- (void)draggingExited:(id)sender
//{
//console.log("exit");
//}
//
////optional
//- (CPDragOperation)draggingUpdated:(id)sender
//{
//    console.log("updated");
//    return CPDragOperationCopy;
//}
//
////optional
//- (CPDragOperation)draggingEntered:(id)sender
//{
//    console.log("blah");
//    return CPDragOperationCopy;
//}

//required
- (BOOL)prepareForDragOperation:(CPDraggingInfo)aSender
{
    // called when the image is released;  Return YES to accept drag, return NO to refuse drag.
    console.log("prepareForDragOperation:");
    return YES;
}

//required
- (BOOL)performDragOperation:(CPDraggingInfo)aSender
{
    // called when the release image has been removed from the screen; signaling the reciever to import the pasteboard
    // Return YES accepts the pasteboard data; NO declines the pasteboard data.
    console.log("performDragOperation:");
    return YES;
}

////optional
//- (void)concludeDragOperation:(id)sender
//{
//    console.log("conclude");
//}

@end
