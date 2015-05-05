import bb.cascades 1.3

Container {
    
    property alias username: displayName.text
    property alias msg: lastMessage.text
    property alias time: timestamp.text
    property variant type
    property bool read
    property bool incoming
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }
    horizontalAlignment: HorizontalAlignment.Fill
    maxHeight: 100
    function userimage(type) {
        switch (type) {
            case "contact":
                {
                    return "asset:///images/thumbnails/Placeholders/user_placeholder_blue.png";
                    break;
                }
            case "chat":
                {
                    return "asset:///images/thumbnails/Placeholders/group_placeholder_orange.png";
                    break;
                }
            case "broadcast":
                {
                    return "asset:///images/thumbnails/Placeholders/broadcast_placeholder_yellow.png";
                    break;
                }
        }
    }
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        background: Color.create("#5ab4bfbf")
        Container {
            minWidth: ui.px(100)
            ImageView {
                
                id: avatar
                imageSource: userimage(type)
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill                
            }
            
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                leftPadding: 10
                topPadding: 5
                horizontalAlignment: HorizontalAlignment.Left
                
                Label {
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }
                    verticalAlignment: VerticalAlignment.Center
                    id: "displayName"
                    text: "Username"
                    textStyle.fontWeight: FontWeight.Bold

                }
                Label {
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: -1
                    
                    }
                    id: "timestamp"
                    text: "00:00 AM"
                    horizontalAlignment: HorizontalAlignment.Right
                    textStyle {
                        base: SystemDefaults.TextStyles.SubtitleText
                    }
                }
                ImageView {
                    maxHeight: 40
                    maxWidth: 40
                    imageSource: "asset:///images/message/ping.png"
                
                }
            }
            Container {
                
                leftPadding: 10
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                
                }
                
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    ImageView {
                        id: readmessage
                        imageSource: if (incoming) {
                            read ? "asset:///images/message/read.png" : "asset:///images/message/delivered.png"
                        } else {
                            ""
                        }
                    }
                    Label {
                        id: "lastMessage"
                        text: "Message"
                        textStyle.base: SystemDefaults.TextStyles.SubtitleText
                        verticalAlignment: VerticalAlignment.Center
                    }
                }
            
            }
        }
    
    }

}
