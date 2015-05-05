import bb.cascades 1.3

Page {
    onCreationCompleted: {
        contactslist.dataModel = app.getContactsNamesModel('contact');
    }
    titleBar: TitleBar {
        title: qsTr("Add Friends to Broadcast") + Retranslate.onLanguageChanged
    }
    Container {
        
        ListView {
            id: contactslist
            dataModel: GroupDataModel {
                grouping: ItemGrouping.None
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
                        title: qsTr("Save Broadcast") + Retranslate.onLanguageChanged
                        onTriggered: {
                            var selectionList = contactslist.selectionList();
                            var items = new Array();
                            for (var i = 0; i < selectionList.length ; i ++) {
                                app.addBroadCastMember(app.getPopBroadCastId(), contactslist.dataModel.data(selectionList[i]).id)
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
                    }
                }
            ]
        }
    }
    actionBarVisibility: ChromeVisibility.Overlay
}
