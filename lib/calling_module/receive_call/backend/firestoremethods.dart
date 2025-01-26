import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class firestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> endCall(String channelId) async {
    try {

      QuerySnapshot invitationsSnap = await _firestore
        .collection('calls')
        .doc(channelId)
        .collection('invitations')
        .get();

    for (int i = 0; i < invitationsSnap.docs.length; i++) {
      await _firestore
          .collection('calls')
          .doc(channelId)
          .collection('invitations')
          .doc(invitationsSnap.docs[i].id)
          .delete();
    }
    
      await _firestore.collection('calls').doc(channelId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}