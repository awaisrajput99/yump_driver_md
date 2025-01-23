import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yumprides_driver/calling_module/call_screen.dart';

final GlobalKey<NavigatorState> callNavigatorKey = GlobalKey<NavigatorState>();

void listenForInvitations(BuildContext context) {
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  FirebaseFirestore.instance
      .collectionGroup('invitations')
      .snapshots()
      .listen((querySnapshot) {
    for (var change in querySnapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        var data = change.doc.data()!;
        if (data['invitedUid'] == currentUserId) {
          String callId = change.doc.reference.parent.parent!.id;

          showDialogForInvitation(callId);
        }
      }
    }
  });
}

void showDialogForInvitation(String callId) {
  showDialog(
    context: callNavigatorKey.currentContext!,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.only(
          bottom: MediaQuery.of( context).size.height - 240),
          padding: const EdgeInsets.all(16),
          height: 80,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Incoming Call", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of( context).pop();
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                const SizedBox(width: 10,),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CallScreen(
              isBroadcaster: true,
              channelId: callId,
            ),
          ),
                );
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                  ),
                ),
                  ],
                ),
              ],
            ),
        ),
      );
    },
  );
}
