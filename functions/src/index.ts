import * as admin from "firebase-admin";
import {setGlobalOptions} from "firebase-functions/v2";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";

// Firebase Admin SDK 초기화
admin.initializeApp();

// 한국 리전 권장
setGlobalOptions({maxInstances: 10, region: "asia-northeast3"});

// 'alarms' 컬렉션에 새 문서가 생성(onCreate)될 때마다 자동으로 트리거되는 함수
export const sendAlarmNotification = onDocumentCreated(
  "alarms/{alarmId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      logger.info("생성된 데이터가 없습니다.");
      return;
    }

    // 1. 방금 생성된 알림 데이터 가져오기
    const alarmData = snapshot.data();
    const receiverId = alarmData.receiver_id;
    const title = alarmData.title;
    const content = alarmData.content;

    try {
      // 2. 수신자의 fcm_tokens 서브 컬렉션에서 활성화된(isActive: true) 토큰들 조회
      const tokensSnapshot = await admin.firestore()
        .collection("user")
        .doc(receiverId)
        .collection("fcm_tokens")
        .where("isActive", "==", true)
        .get();

      if (tokensSnapshot.empty) {
        logger.warn(
          `[Warning] 수신자(${receiverId})의 활성화된 fcmToken이 없어 알림을 보내지 않습니다.`
        );
        return;
      }

      const tokens = tokensSnapshot.docs.map((doc) => doc.data().token);

      // 3. 발송할 멀티캐스트 알림 메세지 구성
      const message = {
        notification: {
          title: title,
          body: content,
        },
        data: {
          type: "product",
          id: alarmData.post_id || "",
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
        tokens: tokens,
      };

      // 4. Firebase FCM 서비스로 멀티캐스트 전송 (여러 기기 동시 발송)
      const response = await admin.messaging().sendEachForMulticast(message);
      logger.info(
        "[Success] 푸시 전송 완료: " +
        `${response.successCount}개 성공, ${response.failureCount}개 실패`
      );

      // 실패한 토큰이 있다면 로그 출력 (필요 시 비활성화 로직 추가 가능)
      if (response.failureCount > 0) {
        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            logger.error(`[Failure] 토큰 ${tokens[idx]} 발송 실패:`, resp.error);
          }
        });
      }
    } catch (error) {
      logger.error("[Error] 푸시 알림 발송 중 예외 발생:", error);
    }
  }
);
