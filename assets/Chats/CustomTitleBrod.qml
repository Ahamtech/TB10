import bb.cascades 1.3

TitleBar {
    property alias username: userNameLabel.text
    property alias status: userStatusLabel.text
    kind: TitleBarKind.FreeForm
    kindProperties: FreeFormTitleBarKindProperties {
        
        Container {
            maxHeight: ui.px(100)
            layout: StackLayout {
                orientation: LayoutOrientation.RightToLeft
            
            }
            Container {
                id: contactImage
                layoutProperties: StackLayoutProperties {
                    spaceQuota: -1
                }
                ImageView {
                    maxHeight: 100
                    id: userAvatar
                    imageSource: "asset:///images/thumbnails/Placeholders/broadcast_placeholder_yellow.png"
                    
                    gestureHandlers: TapHandler {
                        onTapped: {
                            chatviewnav.push(chatprofile.createObject())
                        }
                    }
                    scalingMethod: ScalingMethod.AspectFit
                }
            }
            Container {
                gestureHandlers: TapHandler {
                    onTapped: {
                        chatviewnav.push(groupprofile.createObject())
                    }
                }
                id: nameStatus
                topPadding: 0
                topMargin: 0
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                leftPadding: ui.du(3)
                
                Container {
                    
                    Container {
                        
                        Label {
                            id: userNameLabel
                            text: "Username"
                            textStyle.fontSize: FontSize.Large
                        }
                    
                    }
                    Container {
                        topPadding: 4
                        Label {
                            id: userStatusLabel
                            text: ""
                            textStyle.fontStyle: FontStyle.Italic
                        
                        }
                    }
                
                }
            }
        
        }
    }
}