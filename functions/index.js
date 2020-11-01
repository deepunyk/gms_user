const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.sendNotificationToTopic = functions.firestore.document('notification/{uid}').onWrite(async (event) => {
    let title = event.after.get('title');
    let content = event.after.get('body');
    var message = {
        notification: {
            title: title,
            body: content,
        },
        topic: event.after.get('to'),
    };

    let response = await admin.messaging().send(message);
    console.log(response);
});
