import bb.cascades 1.3

Page {
    property int fwdmsg
    onCreationCompleted: {
        contactslist.dataModel.append(app.getContactsmodal(""));
        fwdmsg = app.getStashFwdMessage();
        console.log(fwdmsg)
    }
    titleBar: TitleBar {
        title: qsTr("Forward to") + Retranslate.onLanguageChanged
    }
    Container {
        topPadding: ui.du(2)
//        SegmentedControl {
//            id:segmentControl
//            
//            Option {
//                text: "Recent Chats"
//                value: "1"
//                selected: true
//            }
//            
//            Option {
//                text: "Favourites"
//                value: "3"
//            }
//            onSelectedIndexChanged: {
//            var value = segmentControl.selectedValue
//                if(value == 3)
//                {
//                    contactslist.dataModel = app.getFavContactsModel()
//                }
//                else {
//                    contactslist.dataModel = app.getContactsmodal("")
//
//                }
//            }
//        }
        ListView {
            id: contactslist
            dataModel: ArrayDataModel {
                
            }
            onTriggered: {
                var userid  = contactslist.dataModel.data(indexPath).id
                var param3 = Math.floor(Math.random()*1000000)
                app.forwardMessage(fwdmsg, userid, param3,contactslist.dataModel.data(indexPath).type)
                app.flushStashFwdMessage();
                chatviewnav.pop()
            }
            listItemComponents: [
                ListItemComponent {
                    type: ""
                    StandardListItem {
                        id: listofcontacts
                        title: ListItemData.firstname
                    }
                }
            ]
        }
    }
}
