import bb.cascades 1.3
import bb.system 1.2
Page {
    onCreationCompleted: {
        contactslist.dataModel = app.getContactsNamesModel('contact');

    }
    titleBar: TitleBar {
        title: qsTr("Add Friends to Group") + Retranslate.onLanguageChanged
        acceptAction: ActionItem {
            imageSource: "asset:///images/icons/ic_history.png"
            onTriggered: {
                retrieve.show()
            }
        }
    }

    Container {

        ListView {
            id: contactslist
            dataModel: GroupDataModel {
            }
            multiSelectAction: MultiSelectActionItem {

            }
            onTriggered: {
                contactslist.multiSelectHandler.active = true
                contactslist.select(indexPath)
            }

            multiSelectHandler {
                status: qsTr("") + Retranslate.onLanguageChanged
                // The actions that can be performed in a multi-select sessions are set up in the actions list.
                actions: [
                    ActionItem {

                        title: qsTr("Add Friends") + Retranslate.onLanguageChanged
                        onTriggered: {
                            var selectionList = contactslist.selectionList();
                            var items = new Array();
                            for (var i = 0; i < selectionList.length; i ++) {
                                app.addGroupMember(contactslist.dataModel.data(selectionList[i]).id,50)
                            }
                            chatviewnav.pop()
                        }
                        imageSource: "asset:///images/icons/ic_done.png"
                    }
                ]
            }
            listItemComponents: [
                ListItemComponent {
                    type: "item"
                    StandardListItem {
                        id: listofcontacts
                        title: ListItemData.firstname
                        imageSource: "asset:///images/thumbnails/menu_group.png"
                    }
                }
            ]
        }

    }
    attachedObjects: [
        SystemPrompt {
            id: retrieve
            body: qsTr("Do you want to add your groups previous chat to the new freinds added") + Retranslate.onLanguageChanged
            confirmButton.enabled: true
            cancelButton.enabled: true
            
            onFinished: {
                if(result == SystemUiResult.ConfirmButtonSelection){
                
                }
            }
            includeRememberMe: false
            rememberMeChecked: false
            inputField.emptyText: qsTr("Enter previous Messages Number as 50 or 100") + Retranslate.onLanguageChanged
            inputField.inputMode: SystemUiInputMode.NumericKeypad
            inputField.maximumLength: 3
        }
    ]
}
