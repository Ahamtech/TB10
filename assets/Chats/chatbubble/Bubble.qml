import bb.cascades 1.3

Container {
    id: self
    background: Color.create ( Application.themeSupport.theme.colorTheme.style)
   
    property bool isMockUp: false // Set to true when testing the formatting in QDE!!!
    property bool incoming
    property bool isSystem
    property alias time:timestampLabel.text
    property alias message: messagebdy.text
    property alias username: contactNameLabel.text
    property bool read
    property variant type

    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    Container {
        objectName: "bubbleContainer"
        visible: true
        topPadding: 0.0
        bottomPadding: 0.0
        rightPadding: incoming ? ui.du(15) : ui.du(2)
        leftPadding: incoming ? ui.du(2): ui.du(15)
        layout: DockLayout {
        }
        layoutProperties: StackLayoutProperties {
            spaceQuota: -1
        }
        ImageView {
            visible: !isSystem
            objectName: "bubbleBackground"
            imageSource: isSystem ? "" : (! incoming ? "images/incoming/full.amd" : "images/outgoing/full.amd")
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
//            filterColor: (Application.themeSupport.theme.colorTheme.style == 2)  ?  Color.Gray : Color.White
        }
        Container {
            objectName: "messageContainer"
            layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
            }
            leftPadding: 20.0
            rightPadding: 20.0
            topPadding: 5.0
            bottomPadding: 5.0
            Container {
                objectName: "messageHeader"
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                horizontalAlignment: HorizontalAlignment.Fill
                Label {
                    id: contactNameLabel
                    visible: ! isSystem
                    horizontalAlignment: HorizontalAlignment.Left
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }
                    textStyle {
                        fontSize: FontSize.XXSmall
                        color: Color.Black
                    }
                }
                Label {
                    id: timestampLabel
                    horizontalAlignment: HorizontalAlignment.Right
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: -1
                    }
                    textStyle {
                        fontStyle: FontStyle.Italic
                        fontSize: FontSize.XXSmall
                        color: Color.Black
                    }
                }
            }
           
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    ImageView {
                        minHeight: 40
                        minWidth: 40
                        id:readmessage
                        imageSource: if(incoming == true){read ? "asset:///images/message/read.png":"asset:///images/message/delivered.png"} else{""} 
                    }
                    Label {
                        id: messagebdy
                        text: "Test"
                        multiline: true
                        textFormat: TextFormat.Auto
                        textFit.mode: LabelTextFitMode.FitToBounds
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                        content.flags: TextContentFlag.ActiveText
                    }
                    ImageView {
                        id:messageimage
                        visible: if(type == "photo"){return true}else{return false}
                        imageSource: "asset:///images/intro/cloud.png"
                    }
                    bottomPadding: 30
                }
            }
        }
    }
}
