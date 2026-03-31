import * as admin from "firebase-admin";
import { setGlobalOptions } from "firebase-functions/v2";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import { MulticastMessage } from "firebase-admin/messaging";

admin.initializeApp();

setGlobalOptions({ maxInstances: 10, region: "asia-northeast3" });

interface AlarmData {
  receiver_id: string;
  title: string;
  content: string;
  post_id?: string;
  image_url?: string;
}

export const sendAlarmNotification = onDocumentCreated(
  "alarms/{alarmId}",
  async (event: { data: any; }) => {
    const snapshot = event.data;
    if (!snapshot) {
      logger.info("생성된 데이터가 없습니다.");
      return;
    }

    const alarmData = snapshot.data() as AlarmData;
    const receiverId = alarmData.receiver_id;
    const title = alarmData.title;
    const content = alarmData.content;

    try {
      const tokensSnapshot = await admin.firestore()
        .collection("user")
        .doc(receiverId)
        .collection("fcm_tokens")
        .where("isActive", "==", true)
        .get();

      if (tokensSnapshot.empty) {
        logger.warn(`[Warning] 수신자(${receiverId})의 활성화된 fcmToken이 없어 알림을 보내지 않습니다.`);
        return;
      }

      const tokens = tokensSnapshot.docs.map((doc: any) => doc.data().token as string);

      const message: MulticastMessage = {
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

      const response = await admin.messaging().sendEachForMulticast(message);

      logger.info(
        "[Success] 푸시 전송 완료: " +
        `${response.successCount}개 성공, ${response.failureCount}개 실패`
      );

      // --- 무효 토큰 클린업 로직 시작 ---
      if (response.failureCount > 0) {
        const batch = admin.firestore().batch();
        let cleanupCount = 0;

        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            const error = resp.error as any;
            // 토큰이 유효하지 않거나 등록되지 않은 경우 (앱 삭제 등)
            if (
              error.code === 'messaging/registration-token-not-registered' ||
              error.code === 'messaging/invalid-registration-token'
            ) {
              const invalidToken = tokens[idx];

              // 해당 토큰 문서의 isActive를 false로 업데이트
              const tokenDocRef = admin.firestore()
                .collection("user")
                .doc(receiverId)
                .collection("fcm_tokens")
                .doc(invalidToken);

              batch.update(tokenDocRef, { isActive: false });
              cleanupCount++;
            }
            logger.error(`[Failure] 토큰 ${tokens[idx]} 발송 실패 이유:`, error.code);
          }
        });

        if (cleanupCount > 0) {
          await batch.commit();
          logger.info(`[Cleanup] 유효하지 않은 토큰 ${cleanupCount}개를 비활성화 처리했습니다.`);
        }
      }
      // --- 무효 토큰 클린업 로직 끝 ---

    } catch (error) {
      logger.error("[Error] 푸시 알림 발송 중 예외 발생:", error);
    }
  }
);