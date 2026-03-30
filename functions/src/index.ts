import * as admin from "firebase-admin";
import { setGlobalOptions } from "firebase-functions/v2";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import { MulticastMessage } from "firebase-admin/messaging";

// Firebase Admin SDK 초기화
admin.initializeApp();

// 한국 리전 권장
setGlobalOptions({ maxInstances: 10, region: "asia-northeast3" });

// 알림 데이터 인터페이스 정의 (strict 모드 대응)
interface AlarmData {
  receiver_id: string;
  title: string;
  content: string;
  post_id?: string;
  image_url?: string;
}

// 'alarms' 컬렉션에 새 문서가 생성(onCreate)될 때마다 자동으로 트리거되는 함수
export const sendAlarmNotification = onDocumentCreated(
  "alarms/{alarmId}",
  async (event: { data: any; }) => {
    const snapshot = event.data;
    if (!snapshot) {
      logger.info("생성된 데이터가 없습니다.");
      return;
    }

    // 1. 방금 생성된 알림 데이터 가져오기 및 타입 캐스팅
    const alarmData = snapshot.data() as AlarmData;
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

      // 토큰들을 string 배열로 명시적 변환
      const tokens = tokensSnapshot.docs.map((doc: { data: () => { (): any; new(): any; token: string; }; }) => doc.data().token as string);

      // 3. 발송할 멀티캐스트 알림 메세지 구성 (MulticastMessage 타입 준수)
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

      // 4. Firebase FCM 서비스로 멀티캐스트 전송
      const response = await admin.messaging().sendEachForMulticast(message);
      logger.info(
        "[Success] 푸시 전송 완료: " +
        `${response.successCount}개 성공, ${response.failureCount}개 실패`
      );

      // 실패한 토큰이 있다면 로그 출력
      if (response.failureCount > 0) {
        response.responses.forEach((resp: { success: any; error: any; }, idx: string | number) => {
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
