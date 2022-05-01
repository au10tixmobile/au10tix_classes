const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
exports.adminMsgHandler = functions.firestore
    .document("chats/{docId}")
    .onCreate(async (snapshot, context) => {
        console.log(`adminMsgHandlerSHAI - ${snapshot.data().eventId}`);
        const eventQuery = admin.firestore().collection('events').doc(snapshot.data().eventId);
        const classQuery = admin.firestore().collection("classes");
        const classSnapshot = await classQuery.where("nextEvent", '==', eventQuery).get();
        if (classSnapshot.empty) {
            return null;
        } else {
            classSnapshot.forEach(doc => {
                const body = `${doc.data().name} update - ${snapshot.data().text}`;
                admin.messaging().sendToTopic(snapshot.data().eventId, {
                    notification:
                    {
                        title: "Au10tix Classes",
                        body: body,
                        clickAction: "FLUTTER_NOTIFICATION_CLICK",
                    },
                    data:
                    {
                        className: doc.data().name,
                        classId: doc.id,
                    },
                });
            });
            return null;
        }
    });

exports.newClassEventHandler = functions.firestore
    .document("classes/{docId}")
    .onUpdate((snapshot, context) => {
        const name = snapshot.after.data().name;
        const body = `New event for ${name} class opened, hurry to enroll!`;
        admin.messaging().sendToTopic(context.params.docId, {
            notification:
            {
                title: "Au10tix Classes",
                body: body,
                clickAction: "FLUTTER_NOTIFICATION_CLICK",
            },
            data:
            {
                className: name,
                classId: context.params.docId,
            },
        });
        return;
    });

exports.classEventHandler = functions.firestore
    .document("events/{docId}")
    .onUpdate((snapshot, context) => {
        const data = snapshot.after.data();
        const dataBefore = snapshot.before.data();
        console.log(`onUpdate - ${data}`);
        console.log(`onUpdate status- ${data.status}`);
        const dateString = data.date.toDate().toDateString();
        console.log("classEventHandler - %s", dataBefore.participants.length);
        const name = data.className;
        if (data.status == "Cancelled") {
            const body = `${name} scheduled for ${dateString} has been cancelled!`;
            admin.messaging().sendToTopic(context.params.docId, {
                notification:
                {
                    title: "Au10tix Classes",
                    body: body,
                    clickAction: "FLUTTER_NOTIFICATION_CLICK",
                },
            });
        } else if (dataBefore.participants.length > data.participants.length &&
            data.waitingParticipants.length > 0) {
            const body = `A spot has opened for ${name} scheduled for ${dateString}, hurry to enroll!`;
            admin.messaging().sendToTopic(context.params.docId, {
                notification:
                {
                    title: "Au10tix Classes",
                    body: body,
                    clickAction: "FLUTTER_NOTIFICATION_CLICK",
                },
                data:
                {
                    className: name,
                    classId: context.params.docId,
                },
            });
        }
        return;
    });
