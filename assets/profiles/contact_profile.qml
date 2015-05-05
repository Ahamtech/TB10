import bb.cascades 1.3
import bb.system 1.2

import "../js/moment.js" as Moment
Page {
    property int popuserid
    property alias avatar:profileimage.imageSource
    onCreationCompleted: {
        popuserid = app.getPopUserId()
        app.contactDeleteoOnServer.connect(deletecontact)
        rendercontactinfo(app.getContactInfo(popuserid))
    }
    function deletecontact(msg) {

        if (msg == true) {
            console.log(" pop delete contacts ")
            app.deletecontactlocal(popuserid)
            chatviewnav.pop()
        }
    }
    function rendercontactinfo(info) {
        var data = info[0]
       
        profilename.text = data.firstname + " " + data.lastname
        var time = Moment.moment.unix(data.wasonline).format("MMMM Do YYYY h:mm")
        profileimage.imageSource = filepathname.photos+"/"+data.photoid+".jpeg"
        profilestatus.text = time
        profilephone.text = "+"+data.phone
    }
    titleBar: TitleBar {
        title: qsTr("Contact Info") + Retranslate.onLanguageChanged

    }
    function savedetails() {
        var check = app.contactSaveInfo(profilename.text)
        if (check == true) {
            editandsave.imageSource = "asset:///images/icons/ic_edit.png"
            profilename.editable = false
        }
    }
    Container {

        Container {
            preferredHeight: maxHeight
            Container {
                topPadding: ui.du(8)
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                ImageView {
                    id: profileimage
                    scalingMethod: ScalingMethod.None
                    imageSource: "asset:///images/thumbnails/Placeholders/user_placeholder_blue.png"

                }
                Container {
                    leftPadding: ui.du(5)
                    layout: StackLayout {
                        orientation: LayoutOrientation.TopToBottom

                    }
                    TextArea {
                        backgroundVisible: false
                        preferredWidth: ui.du(45)
                        editor.cursorPosition: text.length
                        id: profilename
                        editable: false
                        input.submitKey: SubmitKey.Submit
                        input.keyLayout: KeyLayout.PhoneNumber
                        input {
                            onSubmitted: {
                                savedetails()
                            }
                        }
                    }
                    TextArea {
                        backgroundVisible: false
                        id: profilestatus
                        preferredWidth: ui.du(45)
                        editable: false
                    }
                }

            }
            Container {
                leftPadding: ui.du(5)
                rightPadding: ui.du(5)
                topPadding: ui.du(5)

                Divider {
                    horizontalAlignment: HorizontalAlignment.Center
                }

                Container {
                    topPadding: ui.du(2)
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight

                    }
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    Label {
                        id: profilephone
                        horizontalAlignment: HorizontalAlignment.Left
                    }
                }
            }
            Container {
                leftPadding: ui.du(5)
                rightPadding: ui.du(5)
                topPadding: ui.du(5)

                Divider {
                    horizontalAlignment: HorizontalAlignment.Center
                }

            }
        }
        Container {
            preferredHeight: ui.du(20)
            id: loader
            visible: false
            Container {

                horizontalAlignment: HorizontalAlignment.Fill
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight

                }
                Label {
                    text: "Deleting Contact In server"
                    horizontalAlignment: HorizontalAlignment.Right
                }
                ActivityIndicator {
                    preferredWidth: 60
                    running: true
                    horizontalAlignment: HorizontalAlignment.Right
                    layoutProperties: StackLayoutProperties {

                    }
                    verticalAlignment: VerticalAlignment.Fill
                }
            }
        }
    }
    actions: [
        ActionItem {
            id: deletecontact
            title: qsTr("Delete Contact") + Retranslate.onLanguageChanged
            ActionBar.placement: ActionBarPlacement.OnBar

            onTriggered: {
                deleteDilog.show()
            }
            imageSource: "asset:///images/icons/ic_delete.png"
        },
        ActionItem {
            id: editcontact
            ActionBar.placement: ActionBarPlacement.OnBar
            title: qsTr("Edit Contact") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/icons/ic_edit.png"
            onTriggered: {
                enabled=false
                savecontact.enabled=true
                deletecontact.enabled=false
                profilename.editable=true
                profilename.requestFocus()
                
                        }
            
        },
        ActionItem {
            enabled: false
            id: savecontact
            ActionBar.placement: ActionBarPlacement.OnBar
            title: qsTr("Save Settings") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/icons/ic_save.png"
            onTriggered: {
                enabled=false
                editcontact.enabled=true
                deletecontact.enabled=true
                var contup = app.updateContactSettings(app.getPopUserId(),profilename.text)
                if(contup)
                {
                    contacttoast.body="Saved successfully"
                    contacttoast.show()
                }
                else {
                    contacttoast.body="error in saving"
                    contacttoast.show()
                }
            }
        
        }
    ]
    attachedObjects: [
        ComponentDefinition {
            id: contactprofileedit
            source: "contact_edit_profile.qml"
        },
        SystemDialog {
            id: deleteDilog
            emoticonsEnabled: false
            title: qsTr("Delete Contact") + Retranslate.onLanguageChanged
            body: qsTr("Are you sure you want to delete this contact ?") + Retranslate.onLanguageChanged
            confirmButton.enabled: true
            cancelButton.enabled: true
            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    loader.visible = true
                    app.deleteContact(popuserid)
                    //                app.boolcheck()
                    chatviewnav.pop()
                }
            }
        },
        SystemToast {
            id: contacttoast
        }
    ]
}
