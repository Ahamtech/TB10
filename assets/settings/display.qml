import bb.cascades 1.3

Page {
    titleBar: TitleBar {
        title: qsTr("Display Settings") + Retranslate.onLanguageChanged

    }
    
    function createcolor(data) {
        return Color.create(data)
}
    onCreationCompleted: {
        theme.resetSelectedOption()
        var settings = app.getThemeSettings()
        if (settings ==2)
        theme.setSelectedIndex(1)
        else 
        theme.setSelectedIndex(0)
        var colortheme = app.getThemeColorVariable();
        primaryDropDown.resetSelectedOption()
        switch(colortheme)
        {
            case "redtheme":
                primaryDropDown.setSelectedIndex(1);
                break;
            case "greentheme":
                primaryDropDown.setSelectedIndex(2);
                break;
            case "yellowtheme":
                primaryDropDown.setSelectedIndex(3);
                break;
            case "bluetheme":
                primaryDropDown.setSelectedIndex(4);
                break;
            case "graytheme":
                primaryDropDown.setSelectedIndex(5);
                break;     
        }
    }
    Container {
        Header {
            title: qsTr("Display") + Retranslate.onLanguageChanged
        }

        Container {
            leftPadding: ui.du(3)
            rightPadding: ui.du(3)
            topPadding: 20.0
            horizontalAlignment: HorizontalAlignment.Fill
            bottomPadding: 10
            layout: DockLayout {
            }
            Container {
                DropDown {
                    title: qsTr("Select Theme") + Retranslate.onLanguageChanged
                    id: theme
                    Option {
                        text: qsTr("Bright ") + Retranslate.onLanguageChanged
                        value: 1
                        
                    }
                    Option {
                        text: qsTr("Dark") + Retranslate.onLanguageChanged
                        value: 2
                       
                    }
                    onSelectedValueChanged: {
                        Application.themeSupport.setVisualStyle(theme.selectedValue)
                        app.SaveSettings("theme", theme.selectedValue)
                    }
                }
                DropDown {
                    id: primaryDropDown
                    title: qsTr("Primary colour") + Retranslate.onLanguageChanged
                    Option {
                        text: qsTr("Red") + Retranslate.onLanguageChanged
                        value: "redtheme"
                        
                        
                    }
                    Option {
                        text: qsTr("Green")  + Retranslate.onLanguageChanged
                        value: "greentheme"
                        
                    }
                    Option {
                        text: qsTr("Yellow")  + Retranslate.onLanguageChanged
                        value: "yellowtheme"
                       
                    }
                    Option {
                        text: qsTr("Blue") + Retranslate.onLanguageChanged
                        value: "bluetheme"
                        
                    }
                    Option {
                        text: qsTr("Grey")  + Retranslate.onLanguageChanged
                        value: "greytheme"
                        
                    }
                    onSelectedValueChanged: {
                        var prim = primaryDropDown.selectedValue
                        app.setThemeColorVariable(prim.toString())
                        console.log(prim)
                        var themecolor = {
                            "redtheme": {
                                base: "#cc3333",
                                primary: "#ff3333"
                            },
                            "greytheme": {
                                base: "#e6e6e6",
                                primary: "#f0f0f0"
                            },
                            "bluetheme": {
                                base: "#087099",
                                primary: "#0092cc"
                            },
                            "yellowtheme": {
                                base: "#b7b327",
                                primary: "#dcd427"
                            },
                            "greentheme": {
                                base: "#5c7829",
                                primary: "#779933"
                            }
                        }
                        Application.themeSupport.setPrimaryColor(createcolor(themecolor[prim].base), createcolor(themecolor[prim].primary))
                        app.SaveSettings("color1", themecolor[prim].base)
                        app.SaveSettings("color2", themecolor[prim].primary)
                        app.SaveSettings("themecolor",prim.toString())
                    }
                }
                Divider {
                
                }
            }
            
        }
        /*Header {
         title: qsTr("Message Font Size") + Retranslate.onLanguageChanged

        }
        Container {

            leftPadding: ui.du(3)
            rightPadding: ui.du(3)
            topPadding: 20.0
            horizontalAlignment: HorizontalAlignment.Fill
            bottomPadding: 10
            DropDown {
            title: qsTr("Select Font-size") + Retranslate.onLanguageChanged
                id: fontsize
                selectedOption: Option {
                    text: "8"
                    value: "8"
                }
                Option {
                    text: "10"
                    value: "10"
                }
                Option {
                    text: "12"
                    value: "12"
                }
                Option {
                    text: "14"
                    value: "14"
                }
                Option {
                    text: "16"
                    value: "16"
                }
                Option {
                    text: "18"
                    value: "18"
                }
                onSelectedValueChanged: {
                    var size = fontsize.selectedValue
                    //                    To Do   .....  Application.themeSupport.
                    app.SaveSettings("font", size);
                }
            }
            Divider {

            }
        }*/
    }
}
