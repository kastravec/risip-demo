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

    property RisipCall activeCall

    Component.onCompleted: { Risip.sipEndpoint.start(); }
    Component.onDestruction: { Risip.sipEndpoint.stop(); }

    RisipAccountConfiguration {
        id: sipAccountDetails
        userName: "peti"
        password: "masakerA1"
        serverAddress: "148.251.48.171"
        scheme: "digest"
    }

    // handling Signal and Property changes for the main SIP Endpoint - Engine
    Connections {
        target: Risip.sipEndpoint
        onStatusChanged: {
            if(Risip.sipEndpoint.status === RisipEndpoint.Started) {
                console.log("Risip Engine started!");

                //creating the account and setting as the default
                Risip.createAccount(sipAccountDetails);
                Risip.setDefaultAccount(sipAccountDetails.uri);

                //default account login
                Risip.defaultAccount.login();
            }
        }
    }

    // handling Signal and Property changes for the main and default SIP account
    Connections {
        target: Risip.defaultAccount

        onStatusChanged: {
            console.log("Default Account status = " + status);
            console.log("Default Account any error ? = " + Risip.defaultAccount);

            if(Risip.defaultAccount.status === RisipAccount.SignedIn) {
                RisipCallManager.callSIPContact("kot@138.68.67.146")
            }
        }
    }

    // handling Signal and Property changes for the Risip Call Manager
    // handling incoming and outgoing calls

    Connections {
        target: RisipCallManager

        onIncomingCall: {
            root.activeCall = call;
            console.log("Incoming call from: " + root.activeCall.buddy.contact);
        }

        onOutgoingCall: {
            root.activeCall = call;
            console.log("Outgoing call to: " + root.activeCall.buddy.contact);
        }
    }
}
