const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.sendNotificationOnFileUpload = functions.storage
    .object()
    .onFinalize(async (object) => {
      const filePath = object.name;
      
      console.log("Uploaded file path:", filePath); // 파일 경로 로그 출력

      // 원하는 파일 업로드 경로 또는 이름을 확인하여 필터링합니다.
      if (filePath.startsWith("whycarno-firebase.appspot.com")) {
        const notificationMessage = "새로운 파일이 업로드되었습니다!";
        const payload = {
          notification: {
            title: "새로운 파일 업로드 알림",
            body: notificationMessage,
          },
          data: {
            title: "새로운 파일 업로드 알림",
            body: notificationMessage,
          },
        };

        // FCM을 통해 알림을 보냅니다.
        const topic = "your-notification-topic"; // FCM 주제 설정
        await admin.messaging().sendToTopic(topic, payload);
      }
    });
