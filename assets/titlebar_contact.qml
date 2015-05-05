import bb.cascades 1.3

Page {
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        
        }
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        ImageView {
            imageSource: "asset:///images/thumbnails/Placeholders/user_placeholder_cyan.png"
            scalingMethod: ScalingMethod.None
        
        }
        Container {
            leftPadding: ui.du(5)
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            topPadding: 20.0
            Label {
                text: qsTr("Contact Name") + Retranslate.onLanguageChanged
                multiline: true
            
            }
            Label {
                text: qsTr("status..last seen/online") + Retranslate.onLanguageChanged
                multiline: true
            
            }
        }
    
    }

}
