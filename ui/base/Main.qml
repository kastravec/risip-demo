/***********************************************************************************
**    Copyright (C) 2016  Petref Saraci
**    http://risip.io
**    This program is free software: you can redistribute it and/or modify
**    it under the terms of the GNU General Public License as published by
**    the Free Software Foundation, either version 3 of the License, or
**    (at your option) any later version.
**
**    This program is distributed in the hope that it will be useful,
**    but WITHOUT ANY WARRANTY; without even the implied warranty of
**    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**    GNU General Public License for more details.
**
**    You have received a copy of the GNU General Public License
**    along with this program. See LICENSE.GPLv3
**    A copy of the license can be found also here <http://www.gnu.org/licenses/>.
**
************************************************************************************/

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0

import Risip 1.0

ApplicationWindow {
    id: root
    visibility: Window.AutomaticVisibility
    visible: true
    width: 600
    height: 400

    // ====== PART 1 Start / Stop the SIP Endpoint when needed ====.
    // Recommended upong application startup and shutdown.

    Component.onCompleted: { Risip.sipEndpoint.start(); }
    Component.onDestruction: { Risip.sipEndpoint.stop(); }


    // ===== PART 2 Create SIP Account Configurations ======
    // Use any SIP server

    RisipAccountConfiguration {
        id: sipAccountDetails
        userName: "toptop"
        password: "toptop"
        serverAddress: "sip2sip.info"
        proxyServer: "proxy.sipthor.net"
        scheme: "digest"
    }

    // PART 3 Handling Signal and Property changes for endpoint and SIP UA.

    Connections {
        target: Risip.sipEndpoint
        onStatusChanged: {
            if(Risip.sipEndpoint.status === RisipEndpoint.Started) {

                //creating the account and setting as the default
                Risip.createAccount(sipAccountDetails);
                Risip.setDefaultAccount(sipAccountDetails.uri);

                //default account login
                Risip.defaultAccount.login();
            }
        }
    }

    RisipCall {
        id: myCall
        account: Risip.defaultAccount
    }

    // handling Signal and Property changes for the main and default SIP account
    Connections {
        target: Risip.defaultAccount

        onStatusChanged: {
            console.log("Default Account status = " + status);
            console.log("Default Account any error ? = " + Risip.defaultAccount.errorInfo);

            if(Risip.defaultAccount.status === RisipAccount.SignedIn) {

                //Create a conference room with SylkServer
                myCall.callExternalSIP("sip:kotfare@138.68.67.146");
            }
        }
    }


    // A Simple and Minimalistic UI
    Rectangle {
        id: mainview
        anchors.fill: parent

        Column {
            anchors.centerIn: mainview
            spacing: 20
            Row {
                Label {text: qsTr("Account status : ")}
                Label {
                    id: accountStatus
                    text: Risip.defaultAccount.statusText
                }
            }

            Row {
                Label {text: qsTr("Call status : ")}
                Label {
                    id: callStatus
                    text: myCall.status
                }
            }
        }
    }
}
