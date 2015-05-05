import bb.cascades 1.3

Page {
    titleBar: TitleBar {
        title: "A Little About Us"

    }
    ScrollView {

        Container {
                leftPadding: ui.du(2)
            Container {
                layout: GridLayout {

                }

                horizontalAlignment: HorizontalAlignment.Fill
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.TopToBottom
                    }
                    Label {
                        text: "<html><body><p style='font-size:14'>AHAMTECH</p><p><span style='font-size:10;'>INDIA</span></p></body></html>"
                        textFormat: TextFormat.Html
                        multiline: true
                    }
                    
                    Label {
                        textFormat: TextFormat.Html
                        text: "<html><body><a href='http://www.ahamtech.in'><p>www.ahamtech.in</p></a></body></html>"
                        //<img src='asset:///images/test/Link.png' height='10' width='10'/>
                    }
                    Label {
                        textFormat: TextFormat.Html
                        text: "<html><body><a href='mailto:contact@ahamtech.in'>contact@ahamtech.in</a></body></html>"
                    }
                }

                Container {
                    leftPadding: ui.du(5)
                    topPadding: ui.du(2)
                    horizontalAlignment: HorizontalAlignment.Right
                    verticalAlignment: VerticalAlignment.Top
                    layout: GridLayout {
                        columnCount: 3

                    }
                    ImageView {
                        imageSource: "asset:///images/thumbnails/qrcode%20(2).png"
                        horizontalAlignment: HorizontalAlignment.Right
                        verticalAlignment: VerticalAlignment.Center
                        scalingMethod: ScalingMethod.AspectFit

                    }
                }
            }
            Header {
                title: qsTr("What We Do")

            }
            Container {
                horizontalAlignment: HorizontalAlignment.Center

                Label {
                    text: qsTr("Team AHAMTECH stumbles on programming , designing and developing native BlackBerry applications for both public and enterprise")
                    multiline: true
                    textStyle.fontStyle: FontStyle.Italic
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    autoSize.maxLineCount: 5

                }
                Label {
                    text: "Anchored in ANANTAPUR\r\n           Andhra Pradesh\r\n             make in INDIA"
                    multiline: true
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Top

                }

            }
            Header {
                title: "About TB10"
            }
            Container {
                topPadding: ui.du(2)
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight

                }
                ImageView {
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: -1.0

                    }
                    imageSource: "asset:///images/thumbnails/ABOUTUSLOGO.png"
                    horizontalAlignment: HorizontalAlignment.Center
                    scalingMethod: ScalingMethod.AspectFill
                }
                Label {layoutProperties: StackLayoutProperties {
                        spaceQuota: 0.1

                    }
                    text: "TB10 is pure native app for Blackberry, We have made it with our full capability and we request you to send us any suggestions, feedback and improvements required, including more languages support."
                                        multiline: true
                    textStyle.fontStyle: FontStyle.Italic
                }
            }
            Label {
                text: "We will try our level best to update the app depending on API support and productivity for the users."
                multiline: true
                textStyle.fontStyle: FontStyle.Italic
            }
            Label {
                text: "Some of the features might not be available at this point due to several difficulties and coding challenges we are facing, future updates depend on user base and responses we get. So please feel free to send us your comments and suggestions."
                multiline: true
                textStyle.fontStyle: FontStyle.Italic
            }
            
            Header {
                title: qsTr("Under The Hood")
            }
            
            Label {
                bottomPadding: 10
                text: "<html><body><span><b>Lead Programmer</b></span><span><i>    Hari Kishan Reddy</i></span><br/>
<span><b>Fellow Programmer</b></span><span><i>    John Ankanna</i></span>
<span><b>UI Designer</b></span><span><i>    Samdip Isa</i></span>
<span><b>Front End Programmer</b></span><span><i>    Mahesh Reddy</i></span></body></html>"
                textFormat: TextFormat.Html
                multiline: true
            }
            Header {
                
            }
            
        }
    }
}