
// Place the following code in a file and call it AppController.j  Works as a replacement file for the same file AppController.j in the sample code downloadeable here: http://www.cappuccino-project.org/#download


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
