import bb.cascades 1.0


Container {
    id: characterCountContainer
    objectName: "characterCountContainerObject"
    visible: true
    leftPadding: 300
    horizontalAlignment: HorizontalAlignment.Fill
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    background: Color.create (_imBranding.getMessageNotificationBackgroundColor())
    Label {
        objectName: "maxcntLabelObject"
        id: maxcharacters
        textStyle.base: SystemDefaults.TextStyles.SubtitleText
        textStyle.color: Color.create (_imBranding.getMessageNotificationTextColor())
        //defined and set in the parent contatiner
        text: (chatmessagecharlimit-chatmessagecharcnt)
     }
}

