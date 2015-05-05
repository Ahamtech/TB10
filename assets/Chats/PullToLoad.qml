import bb.cascades 1.3

Container {
    signal refreshTriggered
    property bool touchActive: false
    attachedObjects: [
        LayoutUpdateHandler {
            id: refreshHandler
            onLayoutFrameChanged: {
                if (layoutFrame.y >= 50.0) {
                    if (layoutFrame.y == 0 && touchActive != true) {
                        refreshTriggered();
                    }
                }
            
            }
        }
    ]
}