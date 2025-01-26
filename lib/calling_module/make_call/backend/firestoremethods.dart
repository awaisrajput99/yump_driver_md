import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yumprides_driver/calling_module/make_call/backend/callstream.dart';

class firestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> callStream(
    BuildContext context,
  ) async {
    final user = FirebaseAuth.instance.currentUser!;
    String channelId = '';
    try {
      channelId = '${user.uid}${user.displayName}';
      CallStream liveStream = CallStream(
        uid: user.uid,
        username: user.displayName ?? user.email ?? "",
        startedAt: DateTime.now(),
        channelId: channelId,
      );

      _firestore.collection('calls').doc(channelId).set(liveStream.toMap());
    } on FirebaseException catch (e) {
      print("This is the issue while making call: $e");
      // showSnackBar(context, e.message!);
    }

    return channelId;
  }

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

  Future<void> addUser(String channelId, String invitedUid) async {
    try {
      await _firestore
          .collection('calls')
          .doc(channelId)
          .collection('invitations')
          .add({
        'channelId': channelId,
        'invitedUid': invitedUid,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> acceptCall(String invitationId, String channelId,
      String secondaryHostUid, String secondaryHostName) async {
    try {
      await _firestore.runTransaction((transaction) async {
        transaction.update(
            _firestore
                .collection('calls')
                .doc(channelId)
                .collection('invitations')
                .doc(invitationId),
            {'status': 'accepted'});

        transaction.update(_firestore.collection('calls').doc(channelId), {
          'secondaryHostUid': secondaryHostUid,
          'secondaryHostName': secondaryHostName,
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
