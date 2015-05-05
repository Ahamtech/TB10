import bb.cascades 1.3

Container {
    signal liveChatLoading
    property bool touchActive: false
    attachedObjects: [
        LayoutUpdateHandler {
            onLayoutFrameChanged: {
                if (layoutFrame.y >=  0) {
                    if (layoutFrame.y <  13 && layoutFrame.y >  8 && touchActive != true) {
                        liveChatLoading();
                    }
                }
            }
        }
    ]
}