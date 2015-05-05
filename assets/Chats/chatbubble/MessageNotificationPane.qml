import bb.cascades 1.0


Container {
    id: messageNotificationPane
    objectName: "messageNotificationPaneInnerContainerObject"
    topPadding: 3.0
    visible: true
    background: Color.create (_imBranding.getMessageNotificationBackgroundColor())
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        leftPadding: 10
        ImageView {
            minWidth: 32
            minHeight: 32
            maxWidth: 32
            maxHeight: 32
            objectName: "anotherPresenceImage"
            imageSource: "asset:///global/defaultContacts/inactive_contact.png"
        }
        Label {
            verticalAlignment: VerticalAlignment.Center
            objectName: "messageNotificationContactLabelObject"
            id: userNameLabel
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.color: Color.create (_imBranding.getMessageNotificationTextColor())
            text: "ChatContactName"
        }
    }
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        leftPadding: 10
        Container {
            minWidth: 32
            minHeight: 32
            maxWidth: 32
            maxHeight: 32
        }
        Label {
	        verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Fill
	        objectName: "incomingMessageNotificationLabelObject"
	        id: userStatusLabel
	        content.flags: TextContentFlag.Emoticons
            text: qsTr("Incoming Message") + Retranslate.onLanguageChanged
	        textStyle.base: SystemDefaults.TextStyles.SubtitleText
	        textStyle.color: Color.create (_imBranding.getMessageNotificationTextColor())
	    }
	}
}
