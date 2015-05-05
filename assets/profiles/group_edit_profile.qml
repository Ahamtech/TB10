import bb.cascades 1.3
import bb.cascades.pickers 1.0
import bb.system 1.2

Page {
    titleBar: TitleBar {
        title: qsTr("Edit Group Info") + Retranslate.onLanguageChanged

    }
    onCreationCompleted: {
        app.onMessagesEditChatTitleUpdated.connect(updated)
    }
    function updated(){
        serverloading.visible = false
        app.getGroupMembers(popgroupid)
        savegrp.body= qsTr("Group name saved") + Retranslate.onLanguageChanged
        savegrp.show()
    }
    Container {
        preferredHeight: maxHeight
        Container {

        ImageView {
            imageSource: "asset:///images/thumbnails/Placeholders/group_placeholder_green.png"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
        horizontalAlignment: HorizontalAlignment.Center
        topPadding: 40.0
        bottomMargin: 20.0
        Container {
            horizontalAlignment: HorizontalAlignment.Center
            topPadding: ui.du(5)
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                // either first name or last name is compulsory
                // either  name or last name is compulsory
            }
            TextField {
                id: grouptitleedit
                preferredWidth: ui.du(60)
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                text: qsTr("") + Retranslate.onLanguageChanged
                hintText: qsTr("Group Name") + Retranslate.onLanguageChanged
                textFormat: TextFormat.Auto
                inputMode: TextFieldInputMode.Default
            }

        }
    }
        Container {
            id: serverloading
            visible: false
            layout: DockLayout {

            }

            horizontalAlignment: HorizontalAlignment.Fill
            
            leftPadding: ui.du(5)
            rightPadding: ui.du(5)
            bottomPadding: ui.du(5.0)
            
            Label {
            id: indicatorText
            horizontalAlignment: HorizontalAlignment.Left
            verticalAlignment: VerticalAlignment.Center
            text: qsTr("Saving Group title") + Retranslate.onLanguageChanged
            textStyle.base: SystemDefaults.TextStyles.SubtitleText
        }
        
        // The activity indicator control.
        ActivityIndicator {
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Right
            running: true
        }
    }

    }
    actions: ActionItem {
        ActionBar.placement: ActionBarPlacement.Signature
        imageSource: "asset:///images/icons/ic_done.png"
        onTriggered: {
            if (grouptitleedit.text.length) {
                serverloading.visible = true
                app.saveGroupInfo(grouptitleedit.text)
                
            }
        }
        title: qsTr("Save") + Retranslate.onLanguageChanged
    }
    
    attachedObjects: [
        SystemToast {
            id: savegrp
            body: qsTr("Group name saved") + Retranslate.onLanguageChanged
        }
    ]
}
