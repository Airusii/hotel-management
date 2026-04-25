const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

// Инициализируем права администратора
admin.initializeApp();

exports.onBookingStateChanged = onDocumentWritten("bookings/{bookingId}", async (event) => {
  const beforeData = event.data.before ? event.data.before.data() : null;
  const afterData = event.data.after ? event.data.after.data() : null;

  // Если бронь удалили — ничего не делаем
  if (!afterData) return null;

  const guestName = afterData.guestName;
  const userId = afterData.userId;
  const status = afterData.status;

  // СЦЕНАРИЙ 1: Создана НОВАЯ бронь (до этого данных не было, статус pending)
  if (!beforeData && status === "pending") {
    console.log("Новая бронь! Уведомляем админов...");

    const adminsSnapshot = await admin.firestore()
      .collection("users")
      .where("role", "==", "admin")
      .get();

    const tokens = [];
    adminsSnapshot.forEach((doc) => {
      const adminData = doc.data();
      if (adminData.fcmToken) {
        tokens.push(adminData.fcmToken);
      }
    });

    if (tokens.length > 0) {
      // 🚀 НОВЫЙ ФОРМАТ HTTP v1 ДЛЯ МАССИВА ТОКЕНОВ
      const message = {
        notification: {
          title: "Новое бронирование 🔔",
          body: `${guestName} хочет забронировать номер! Требуется подтверждение.`,
        },
        tokens: tokens, // Передаем массив токенов
      };
      // Используем современный метод sendEachForMulticast
      console.log("Отправка пуша через v1 API...");
      return admin.messaging().sendEachForMulticast(message);
    }
  }

  // СЦЕНАРИЙ 2: Статус изменился на "Подтверждено"
  if (beforeData && beforeData.status !== "confirmed" && status === "confirmed") {
    console.log(`Бронь подтверждена! Уведомляем гостя: ${userId}`);

    const userDoc = await admin.firestore().collection("users").doc(userId).get();

    if (userDoc.exists) {
      const userData = userDoc.data();
      if (userData.fcmToken) {
        // 🚀 НОВЫЙ ФОРМАТ HTTP v1 ДЛЯ ОДНОГО ТОКЕНА
        const message = {
          notification: {
            title: "Бронь подтверждена! 🎉",
            body: "Ваш номер в Manas Hotel успешно забронирован. Ждем вас!",
          },
          token: userData.fcmToken, // Передаем один токен
        };
        // Используем современный метод send
        console.log("Отправка пуша гостю через v1 API...");
        return admin.messaging().send(message);
      }
    }
  }

  return null;
});