import bb.cascades 1.3

Page {
    onCreationCompleted: {
        contactslist.dataModel = app.getContactsNamesModel('contact');
    }
    titleBar: TitleBar {
        title: qsTr("New Chat") + Retranslate.onLanguageChanged
    }
    Container {
        topPadding: ui.du(5)
        ListView {
            id: contactslist
            dataModel: GroupDataModel {
                grouping: ItemGrouping.ByFirstChar
                sortingKeys: ['firstname']
            }
            onTriggered: {
                var usid = contactslist.dataModel.data(indexPath).id;
                app.setPopUserId(usid);
                var d = chatcontactpane.createObject();
                chatviewnav.push(d);
            }
            listItemComponents: [
                ListItemComponent {
                    type: "item"
                    StandardListItem {
                        title: ListItemData.firstname
                    }
                }
            ]
        }
    }
    attachedObjects: [
        ComponentDefinition {
            id: chatcontactpane
            source: "asset:///Chats/chat_contact.qml"
        }]
}
