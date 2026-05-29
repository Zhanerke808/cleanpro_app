// // // server.js
// // require('dotenv').config();
// // const express = require('express');
// // const admin = require('firebase-admin');
// // const cors = require('cors');
// // const serviceAccount = require('./serviceAccountKey.json');

// // admin.initializeApp({
// //   credential: admin.credential.cert(serviceAccount),
// // });
// // const db = admin.firestore();
// // const app = express();

// // // CORS толық қосу
// // app.use(cors({
// //   origin: '*',
// //   methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
// //   allowedHeaders: ['Content-Type', 'Authorization'],
// // }));

// // app.use(express.json());

// // // --- Token тексеру ---
// // async function verifyToken(req, res, next) {
// //   const authHeader = req.headers.authorization;
// //   if (!authHeader || !authHeader.startsWith('Bearer ')) {
// //     return res.status(401).json({ error: 'Токен жоқ' });
// //   }
// //   const idToken = authHeader.split('Bearer ')[1];
// //   try {
// //     const decoded = await admin.auth().verifyIdToken(idToken);
// //     req.user = decoded;
// //     next();
// //   } catch (error) {
// //     console.error('Token қате:', error);
// //     res.status(401).json({ error: 'Токен жарамсыз: ' + error.message });
// //   }
// // }

// // // --- Admin тексеру ---
// // async function adminOnly(req, res, next) {
// //   try {
// //     const userDoc = await db.collection('users').doc(req.user.uid).get();
// //     if (!userDoc.exists || userDoc.data().role !== 'admin') {
// //       return res.status(403).json({ error: 'Тек әкімшіге рұқсат' });
// //     }
// //     next();
// //   } catch (error) {
// //     console.error('Admin тексеру қате:', error);
// //     res.status(500).json({ error: error.message });
// //   }
// // }

// // // --- Профиль сақтау ---
// // app.post('/api/users', verifyToken, async (req, res) => {
// //   const { name, phone, role } = req.body;
// //   if (!name || !phone || !role || !['client', 'cleaner', 'admin'].includes(role)) {
// //     return res.status(400).json({ error: 'Деректер толық емес' });
// //   }
// //   try {
// //     await db.collection('users').doc(req.user.uid).set({
// //       uid: req.user.uid,
// //       email: req.user.email,
// //       name,
// //       phone,
// //       role,
// //       createdAt: admin.firestore.FieldValue.serverTimestamp(),
// //     });
// //     console.log('Пайдаланушы сақталды:', req.user.uid, role);
// //     res.json({ message: 'Пайдаланушы сақталды', role: role });
// //   } catch (e) {
// //     console.error('Сақтау қатесі:', e);
// //     res.status(500).json({ error: e.message });
// //   }
// // });

// // // --- Өз профилін алу ---
// // app.get('/api/users/me', verifyToken, async (req, res) => {
// //   try {
// //     const doc = await db.collection('users').doc(req.user.uid).get();
// //     if (!doc.exists) {
// //       return res.status(404).json({ error: 'Пайдаланушы табылмады. Алдымен тіркеліңіз.' });
// //     }
// //     res.json(doc.data());
// //   } catch (e) {
// //     console.error('Профиль алу қатесі:', e);
// //     res.status(500).json({ error: e.message });
// //   }
// // });

// // // --- Тапсырыс жасау ---
// // app.post('/api/orders', verifyToken, async (req, res) => {
// //   const { description, address, entrance, comment, phone, price } = req.body;
// //   if (!description || !address || !phone || !price) {
// //     return res.status(400).json({ error: 'Міндетті өрістер: description, address, phone, price' });
// //   }
// //   try {
// //     const orderRef = db.collection('orders').doc();
// //     await orderRef.set({
// //       id: orderRef.id,
// //       clientId: req.user.uid,
// //       description,
// //       address,
// //       entrance: entrance || '',
// //       comment: comment || '',
// //       phone,
// //       price: Number(price),
// //       status: 'pending',
// //       cleanerId: null,
// //       createdAt: admin.firestore.FieldValue.serverTimestamp(),
// //     });
// //     console.log('Тапсырыс жасалды:', orderRef.id);
// //     res.json({ message: 'Тапсырыс жасалды', orderId: orderRef.id });
// //   } catch (e) {
// //     console.error('Тапсырыс жасау қатесі:', e);
// //     res.status(500).json({ error: e.message });
// //   }
// // });

// // // --- Клиент тапсырыстары ---
// // app.get('/api/orders/my', verifyToken, async (req, res) => {
// //   try {
// //     const snapshot = await db.collection('orders')
// //       .where('clientId', '==', req.user.uid)
// //       .orderBy('createdAt', 'desc')
// //       .get();
// //     const orders = [];
// //     snapshot.forEach(doc => orders.push(doc.data()));
// //     console.log('Тапсырыстар саны:', orders.length);
// //     res.json(orders);
// //   } catch (e) {
// //     console.error('Тапсырыстарды алу қатесі:', e);
// //     res.status(500).json({ error: e.message });
// //   }
// // });

// // // --- Қолжетімді тапсырыстар (клинер үшін) ---
// // app.get('/api/orders/available', verifyToken, async (req, res) => {
// //   try {
// //     const snapshot = await db.collection('orders')
// //       .where('status', '==', 'pending')
// //       .orderBy('createdAt', 'desc')
// //       .get();
// //     const orders = [];
// //     snapshot.forEach(doc => orders.push(doc.data()));
// //     res.json(orders);
// //   } catch (e) {
// //     console.error('Қолжетімді тапсырыстар қатесі:', e);
// //     res.status(500).json({ error: e.message });
// //   }
// // });

// // // --- Клинер алған тапсырыстар ---
// // app.get('/api/orders/accepted', verifyToken, async (req, res) => {
// //   try {
// //     const snapshot = await db.collection('orders')
// //       .where('cleanerId', '==', req.user.uid)
// //       .orderBy('createdAt', 'desc')
// //       .get();
// //     const orders = [];
// //     snapshot.forEach(doc => orders.push(doc.data()));
// //     res.json(orders);
// //   } catch (e) {
// //     console.error('Қабылданған тапсырыстар қатесі:', e);
// //     res.status(500).json({ error: e.message });
// //   }
// // });

// // // --- Тапсырысты қабылдау ---
// // app.put('/api/orders/:id/accept', verifyToken, async (req, res) => {
// //   try {
// //     const orderRef = db.collection('orders').doc(req.params.id);
// //     const order = await orderRef.get();
// //     if (!order.exists) return res.status(404).json({ error: 'Тапсырыс табылмады' });
// //     if (order.data().status !== 'pending') {
// //       return res.status(400).json({ error: 'Бұл тапсырысты алу мүмкін емес' });
// //     }
// //     await orderRef.update({
// //       cleanerId: req.user.uid,
// //       status: 'accepted',
// //     });
// //     res.json({ message: 'Тапсырыс қабылданды' });
// //   } catch (e) {
// //     console.error('Қабылдау қатесі:', e);
// //     res.status(500).json({ error: e.message });
// //   }
// // });

// // // --- Тапсырысты аяқтау ---
// // app.put('/api/orders/:id/complete', verifyToken, async (req, res) => {
// //   try {
// //     const orderRef = db.collection('orders').doc(req.params.id);
// //     const order = await orderRef.get();
// //     if (!order.exists) return res.status(404).json({ error: 'Жоқ' });
// //     await orderRef.update({ status: 'completed' });
// //     res.json({ message: 'Аяқталды' });
// //   } catch (e) {
// //     console.error('Аяқтау қатесі:', e);
// //     res.status(500).json({ error: e.message });
// //   }
// // });

// // // --- Admin: Барлық пайдаланушылар ---
// // app.get('/api/admin/users', verifyToken, adminOnly, async (req, res) => {
// //   try {
// //     const snapshot = await db.collection('users').orderBy('createdAt', 'desc').get();
// //     const users = [];
// //     snapshot.forEach(doc => users.push(doc.data()));
// //     res.json(users);
// //   } catch (e) {
// //     console.error('Admin users қате:', e);
// //     res.status(500).json({ error: e.message });
// //   }
// // });

// // // --- Admin: Барлық тапсырыстар ---
// // app.get('/api/admin/orders', verifyToken, adminOnly, async (req, res) => {
// //   try {
// //     const snapshot = await db.collection('orders').orderBy('createdAt', 'desc').get();
// //     const orders = [];
// //     snapshot.forEach(doc => orders.push(doc.data()));
// //     res.json(orders);
// //   } catch (e) {
// //     console.error('Admin orders қате:', e);
// //     res.status(500).json({ error: e.message });
// //   }
// // });

// // // --- Admin: Статус өзгерту ---
// // app.put('/api/admin/orders/:id/status', verifyToken, adminOnly, async (req, res) => {
// //   const { status } = req.body;
// //   if (!status || !['pending', 'accepted', 'completed', 'cancelled'].includes(status)) {
// //     return res.status(400).json({ error: 'Жаңа статус қажет' });
// //   }
// //   try {
// //     await db.collection('orders').doc(req.params.id).update({ status });
// //     res.json({ message: 'Статус өзгертілді' });
// //   } catch (e) {
// //     console.error('Status update қате:', e);
// //     res.status(500).json({ error: e.message });
// //   }
// // });

// // // --- Admin: Тапсырысты жою ---
// // app.delete('/api/admin/orders/:id', verifyToken, adminOnly, async (req, res) => {
// //   try {
// //     await db.collection('orders').doc(req.params.id).delete();
// //     res.json({ message: 'Жойылды' });
// //   } catch (e) {
// //     console.error('Delete қате:', e);
// //     res.status(500).json({ error: e.message });
// //   }
// // });

// // // --- Тест endpoint ---
// // app.get('/', (req, res) => {
// //   res.json({ message: 'Сервер жұмыс істеп тұр!', time: new Date().toISOString() });
// // });

// // const PORT = process.env.PORT || 3000;
// // app.listen(PORT, () => {
// //   console.log(`✅ Сервер ${PORT} портта жұмыс істеп тұр`);
// //   console.log(`📍 http://localhost:${PORT}`);
// // });

// // server.js
// require('dotenv').config();
// const express = require('express');
// const admin = require('firebase-admin');
// const cors = require('cors');
// const serviceAccount = require('./serviceAccountKey.json');

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
// });
// const db = admin.firestore();
// const app = express();

// // CORS толық қосу
// app.use(cors({
//   origin: '*',
//   methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
//   allowedHeaders: ['Content-Type', 'Authorization'],
// }));

// app.use(express.json());

// // --- Token тексеру ---
// async function verifyToken(req, res, next) {
//   const authHeader = req.headers.authorization;
//   if (!authHeader || !authHeader.startsWith('Bearer ')) {
//     return res.status(401).json({ error: 'Токен жоқ' });
//   }
//   const idToken = authHeader.split('Bearer ')[1];
//   try {
//     const decoded = await admin.auth().verifyIdToken(idToken);
//     req.user = decoded;
//     next();
//   } catch (error) {
//     console.error('Token қате:', error);
//     res.status(401).json({ error: 'Токен жарамсыз: ' + error.message });
//   }
// }

// // --- Admin тексеру ---
// async function adminOnly(req, res, next) {
//   try {
//     const userDoc = await db.collection('users').doc(req.user.uid).get();
//     if (!userDoc.exists || userDoc.data().role !== 'admin') {
//       return res.status(403).json({ error: 'Тек әкімшіге рұқсат' });
//     }
//     next();
//   } catch (error) {
//     console.error('Admin тексеру қате:', error);
//     res.status(500).json({ error: error.message });
//   }
// }

// // ==================== ПАЙДАЛАНУШЫЛАР ====================

// // Профиль сақтау
// app.post('/api/users', verifyToken, async (req, res) => {
//   const { name, phone, role } = req.body;
//   if (!name || !phone || !role || !['client', 'cleaner', 'admin'].includes(role)) {
//     return res.status(400).json({ error: 'Деректер толық емес' });
//   }
//   try {
//     await db.collection('users').doc(req.user.uid).set({
//       uid: req.user.uid,
//       email: req.user.email,
//       name,
//       phone,
//       role,
//       rating: 0,
//       totalReviews: 0,
//       completedOrders: 0,
//       photoUrl: '',
//       createdAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
//     console.log('✅ Пайдаланушы сақталды:', req.user.email, role);
//     res.json({ message: 'Пайдаланушы сақталды', role: role });
//   } catch (e) {
//     console.error('Сақтау қатесі:', e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // Профиль алу
// app.get('/api/users/me', verifyToken, async (req, res) => {
//   try {
//     const doc = await db.collection('users').doc(req.user.uid).get();
//     if (!doc.exists) {
//       return res.status(404).json({ error: 'Пайдаланушы табылмады' });
//     }
//     res.json(doc.data());
//   } catch (e) {
//     console.error('Профиль қате:', e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // Профиль жаңарту
// app.put('/api/users/me', verifyToken, async (req, res) => {
//   try {
//     const { name, phone, photoUrl } = req.body;
//     const updateData = {};
//     if (name) updateData.name = name;
//     if (phone) updateData.phone = phone;
//     if (photoUrl) updateData.photoUrl = photoUrl;
    
//     await db.collection('users').doc(req.user.uid).update(updateData);
//     res.json({ message: 'Профиль жаңартылды' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // Клинер рейтингісін алу
// app.get('/api/users/:uid/rating', async (req, res) => {
//   try {
//     const doc = await db.collection('users').doc(req.params.uid).get();
//     if (!doc.exists) return res.status(404).json({ error: 'Табылмады' });
//     res.json({ rating: doc.data().rating || 0, totalReviews: doc.data().totalReviews || 0 });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // ==================== ТАПСЫРЫСТАР ====================

// // Тапсырыс жасау
// app.post('/api/orders', verifyToken, async (req, res) => {
//   const { description, address, entrance, comment, phone, price, cleaningType, rooms, preferredDate, preferredTime } = req.body;
//   if (!description || !address || !phone || !price) {
//     return res.status(400).json({ error: 'Міндетті өрістер: description, address, phone, price' });
//   }
//   try {
//     const orderRef = db.collection('orders').doc();
//     await orderRef.set({
//       id: orderRef.id,
//       clientId: req.user.uid,
//       description,
//       address,
//       entrance: entrance || '',
//       comment: comment || '',
//       phone,
//       price: Number(price),
//       status: 'pending',
//       cleanerId: null,
//       cleaningType: cleaningType || '',
//       rooms: rooms || '',
//       preferredDate: preferredDate || '',
//       preferredTime: preferredTime || '',
//       review: null,
//       createdAt: admin.firestore.FieldValue.serverTimestamp(),
//       updatedAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
//     console.log('✅ Тапсырыс жасалды:', orderRef.id);
//     res.json({ message: 'Тапсырыс жасалды', orderId: orderRef.id });
//   } catch (e) {
//     console.error('Тапсырыс қате:', e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // Клиент тапсырыстары
// app.get('/api/orders/my', verifyToken, async (req, res) => {
//   try {
//     const snapshot = await db.collection('orders')
//       .where('clientId', '==', req.user.uid)
//       .orderBy('createdAt', 'desc')
//       .get();
//     const orders = [];
//     snapshot.forEach(doc => orders.push(doc.data()));
//     res.json(orders);
//   } catch (e) {
//     console.error('Клиент тапсырыстары:', e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // Қолжетімді тапсырыстар (клинер үшін)
// app.get('/api/orders/available', verifyToken, async (req, res) => {
//   try {
//     const snapshot = await db.collection('orders')
//       .where('status', '==', 'pending')
//       .orderBy('createdAt', 'desc')
//       .get();
//     const orders = [];
//     snapshot.forEach(doc => orders.push(doc.data()));
//     res.json(orders);
//   } catch (e) {
//     console.error('Available:', e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // Клинер алған тапсырыстар
// app.get('/api/orders/accepted', verifyToken, async (req, res) => {
//   try {
//     const snapshot = await db.collection('orders')
//       .where('cleanerId', '==', req.user.uid)
//       .orderBy('createdAt', 'desc')
//       .get();
//     const orders = [];
//     snapshot.forEach(doc => orders.push(doc.data()));
//     res.json(orders);
//   } catch (e) {
//     console.error('Accepted:', e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // Тапсырысты қабылдау
// app.put('/api/orders/:id/accept', verifyToken, async (req, res) => {
//   try {
//     const orderRef = db.collection('orders').doc(req.params.id);
//     const order = await orderRef.get();
//     if (!order.exists) return res.status(404).json({ error: 'Тапсырыс табылмады' });
//     if (order.data().status !== 'pending') {
//       return res.status(400).json({ error: 'Бұл тапсырысты алу мүмкін емес' });
//     }
//     await orderRef.update({
//       cleanerId: req.user.uid,
//       status: 'accepted',
//       updatedAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
//     console.log('✅ Қабылданды:', req.params.id);
//     res.json({ message: 'Тапсырыс қабылданды' });
//   } catch (e) {
//     console.error('Accept:', e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // Тапсырысты бастау (in_progress)
// app.put('/api/orders/:id/start', verifyToken, async (req, res) => {
//   try {
//     const orderRef = db.collection('orders').doc(req.params.id);
//     const order = await orderRef.get();
//     if (!order.exists) return res.status(404).json({ error: 'Тапсырыс табылмады' });
//     await orderRef.update({
//       status: 'in_progress',
//       updatedAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
//     res.json({ message: 'Жұмыс басталды' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // Тапсырысты аяқтау
// app.put('/api/orders/:id/complete', verifyToken, async (req, res) => {
//   try {
//     const orderRef = db.collection('orders').doc(req.params.id);
//     const order = await orderRef.get();
//     if (!order.exists) return res.status(404).json({ error: 'Тапсырыс табылмады' });
//     await orderRef.update({
//       status: 'completed',
//       updatedAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
    
//     // Клинердің completedOrders санын арттыру
//     const cleanerId = order.data().cleanerId;
//     if (cleanerId) {
//       await db.collection('users').doc(cleanerId).update({
//         completedOrders: admin.firestore.FieldValue.increment(1),
//       });
//     }
    
//     console.log('✅ Аяқталды:', req.params.id);
//     res.json({ message: 'Тапсырыс аяқталды' });
//   } catch (e) {
//     console.error('Complete:', e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // Тапсырыстан бас тарту
// app.put('/api/orders/:id/cancel', verifyToken, async (req, res) => {
//   try {
//     const orderRef = db.collection('orders').doc(req.params.id);
//     const order = await orderRef.get();
//     if (!order.exists) return res.status(404).json({ error: 'Тапсырыс табылмады' });
//     await orderRef.update({
//       status: 'cancelled',
//       updatedAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
//     res.json({ message: 'Тапсырыс бас тартылды' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // ==================== ПІКІРЛЕР ====================

// // Пікір қалдыру
// app.post('/api/reviews', verifyToken, async (req, res) => {
//   const { orderId, cleanerId, rating, comment } = req.body;
//   if (!orderId || !cleanerId || !rating) {
//     return res.status(400).json({ error: 'Міндетті өрістер толтырылмады' });
//   }
//   try {
//     const reviewRef = db.collection('reviews').doc();
//     await reviewRef.set({
//       id: reviewRef.id,
//       orderId,
//       cleanerId,
//       clientId: req.user.uid,
//       rating: Number(rating),
//       comment: comment || '',
//       createdAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
    
//     // Тапсырысқа review id-сін сақтау
//     await db.collection('orders').doc(orderId).update({
//       review: reviewRef.id,
//     });
    
//     // Клинердің орташа рейтингін жаңарту
//     const reviewsSnapshot = await db.collection('reviews')
//       .where('cleanerId', '==', cleanerId)
//       .get();
//     const totalReviews = reviewsSnapshot.size;
//     const totalRating = reviewsSnapshot.docs.reduce((sum, doc) => sum + doc.data().rating, 0);
//     const avgRating = totalReviews > 0 ? (totalRating / totalReviews) : 0;
    
//     await db.collection('users').doc(cleanerId).update({
//       rating: avgRating,
//       totalReviews: totalReviews,
//     });
    
//     console.log('✅ Пікір қалдырылды:', reviewRef.id);
//     res.json({ message: 'Пікір қалдырылды', reviewId: reviewRef.id });
//   } catch (e) {
//     console.error('Review:', e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // Клинердің пікірлерін алу
// app.get('/api/reviews/cleaner/:uid', async (req, res) => {
//   try {
//     const snapshot = await db.collection('reviews')
//       .where('cleanerId', '==', req.params.uid)
//       .orderBy('createdAt', 'desc')
//       .get();
//     const reviews = [];
//     snapshot.forEach(doc => reviews.push(doc.data()));
//     res.json(reviews);
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // Тапсырыс бойынша пікірді алу
// app.get('/api/reviews/order/:orderId', async (req, res) => {
//   try {
//     const snapshot = await db.collection('reviews')
//       .where('orderId', '==', req.params.orderId)
//       .get();
//     if (snapshot.empty) return res.json(null);
//     res.json(snapshot.docs[0].data());
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // ==================== ХАБАРЛАМАЛАР ====================

// // Хабарлама жіберу
// app.post('/api/messages', verifyToken, async (req, res) => {
//   const { orderId, receiverId, text } = req.body;
//   if (!orderId || !receiverId || !text) {
//     return res.status(400).json({ error: 'Деректер толық емес' });
//   }
//   try {
//     const msgRef = db.collection('messages').doc();
//     await msgRef.set({
//       id: msgRef.id,
//       orderId,
//       senderId: req.user.uid,
//       receiverId,
//       text,
//       read: false,
//       createdAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
//     console.log('✅ Хабарлама жіберілді:', msgRef.id);
//     res.json({ message: 'Хабарлама жіберілді', msgId: msgRef.id });
//   } catch (e) {
//     console.error('Message:', e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // Тапсырыс бойынша хабарламаларды алу
// app.get('/api/messages/:orderId', verifyToken, async (req, res) => {
//   try {
//     const snapshot = await db.collection('messages')
//       .where('orderId', '==', req.params.orderId)
//       .orderBy('createdAt', 'asc')
//       .get();
//     const messages = [];
//     snapshot.forEach(doc => messages.push(doc.data()));
//     res.json(messages);
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // Оқылмаған хабарламалар саны
// app.get('/api/messages/unread/count', verifyToken, async (req, res) => {
//   try {
//     const snapshot = await db.collection('messages')
//       .where('receiverId', '==', req.user.uid)
//       .where('read', '==', false)
//       .get();
//     res.json({ count: snapshot.size });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // Хабарламаны оқылды деп белгілеу
// app.put('/api/messages/:id/read', verifyToken, async (req, res) => {
//   try {
//     await db.collection('messages').doc(req.params.id).update({ read: true });
//     res.json({ message: 'Оқылды' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // ==================== СТАТИСТИКА ====================

// // Жалпы статистика
// app.get('/api/admin/stats', verifyToken, adminOnly, async (req, res) => {
//   try {
//     const ordersSnapshot = await db.collection('orders').get();
//     const usersSnapshot = await db.collection('users').get();
    
//     const totalOrders = ordersSnapshot.size;
//     const completedOrders = ordersSnapshot.docs.filter(d => d.data().status === 'completed').length;
//     const pendingOrders = ordersSnapshot.docs.filter(d => d.data().status === 'pending').length;
//     const totalRevenue = ordersSnapshot.docs
//       .filter(d => d.data().status === 'completed')
//       .reduce((sum, d) => sum + (d.data().price || 0), 0);
    
//     const today = new Date();
//     today.setHours(0, 0, 0, 0);
//     const weekAgo = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
//     const monthAgo = new Date(today.getTime() - 30 * 24 * 60 * 60 * 1000);
    
//     const todayOrders = ordersSnapshot.docs.filter(d => {
//       const date = d.data().createdAt?.toDate();
//       return date && date >= today;
//     }).length;
    
//     const weekOrders = ordersSnapshot.docs.filter(d => {
//       const date = d.data().createdAt?.toDate();
//       return date && date >= weekAgo;
//     }).length;
    
//     const monthOrders = ordersSnapshot.docs.filter(d => {
//       const date = d.data().createdAt?.toDate();
//       return date && date >= monthAgo;
//     }).length;
    
//     const totalUsers = usersSnapshot.size;
//     const cleaners = usersSnapshot.docs.filter(d => d.data().role === 'cleaner').length;
//     const clients = usersSnapshot.docs.filter(d => d.data().role === 'client').length;
    
//     res.json({
//       totalOrders,
//       completedOrders,
//       pendingOrders,
//       totalRevenue,
//       todayOrders,
//       weekOrders,
//       monthOrders,
//       totalUsers,
//       cleaners,
//       clients,
//     });
//   } catch (e) {
//     console.error('Stats:', e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // ТОП клинерлер
// app.get('/api/admin/top-cleaners', verifyToken, adminOnly, async (req, res) => {
//   try {
//     const snapshot = await db.collection('users')
//       .where('role', '==', 'cleaner')
//       .orderBy('rating', 'desc')
//       .limit(10)
//       .get();
//     const cleaners = [];
//     snapshot.forEach(doc => cleaners.push(doc.data()));
//     res.json(cleaners);
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // ==================== Admin: Пайдаланушылар ====================

// app.get('/api/admin/users', verifyToken, adminOnly, async (req, res) => {
//   try {
//     const snapshot = await db.collection('users').orderBy('createdAt', 'desc').get();
//     const users = [];
//     snapshot.forEach(doc => users.push(doc.data()));
//     res.json(users);
//   } catch (e) {
//     console.error('Admin users:', e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // Пайдаланушыны блоктау/блоктан шығару
// app.put('/api/admin/users/:uid/toggle-block', verifyToken, adminOnly, async (req, res) => {
//   try {
//     const userRef = db.collection('users').doc(req.params.uid);
//     const user = await userRef.get();
//     if (!user.exists) return res.status(404).json({ error: 'Пайдаланушы табылмады' });
//     const newStatus = !user.data().blocked;
//     await userRef.update({ blocked: newStatus });
//     res.json({ message: newStatus ? 'Пайдаланушы блокталды' : 'Пайдаланушы блоктан шығарылды', blocked: newStatus });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // ==================== Admin: Тапсырыстар ====================

// app.get('/api/admin/orders', verifyToken, adminOnly, async (req, res) => {
//   try {
//     const snapshot = await db.collection('orders').orderBy('createdAt', 'desc').get();
//     const orders = [];
//     snapshot.forEach(doc => orders.push(doc.data()));
//     res.json(orders);
//   } catch (e) {
//     console.error('Admin orders:', e);
//     res.status(500).json({ error: e.message });
//   }
// });

// app.put('/api/admin/orders/:id/status', verifyToken, adminOnly, async (req, res) => {
//   const { status } = req.body;
//   if (!status || !['pending', 'accepted', 'in_progress', 'completed', 'cancelled'].includes(status)) {
//     return res.status(400).json({ error: 'Жаңа статус қажет' });
//   }
//   try {
//     await db.collection('orders').doc(req.params.id).update({
//       status,
//       updatedAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
//     res.json({ message: 'Статус өзгертілді' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.delete('/api/admin/orders/:id', verifyToken, adminOnly, async (req, res) => {
//   try {
//     await db.collection('orders').doc(req.params.id).delete();
//     res.json({ message: 'Жойылды' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // --- Тест endpoint ---
// app.get('/', (req, res) => {
//   res.json({ 
//     message: '✅ CleanPro API жұмыс істеп тұр!', 
//     time: new Date().toISOString(),
//     endpoints: [
//       'POST /api/users',
//       'GET /api/users/me',
//       'PUT /api/users/me',
//       'POST /api/orders',
//       'GET /api/orders/my',
//       'GET /api/orders/available',
//       'GET /api/orders/accepted',
//       'PUT /api/orders/:id/accept',
//       'PUT /api/orders/:id/start',
//       'PUT /api/orders/:id/complete',
//       'PUT /api/orders/:id/cancel',
//       'POST /api/reviews',
//       'POST /api/messages',
//       'GET /api/messages/:orderId',
//       'GET /api/admin/stats',
//       'GET /api/admin/users',
//       'GET /api/admin/orders',
//     ]
//   });
// });

// const PORT = process.env.PORT || 3000;
// app.listen(PORT, () => {
//   console.log(`✅ Сервер ${PORT} портта жұмыс істеп тұр`);
//   console.log(`📍 http://localhost:${PORT}`);
//   console.log(`📋 API: http://localhost:${PORT}/`);
// });

// server.js
require('dotenv').config();
const express = require('express');
const admin = require('firebase-admin');
const cors = require('cors');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
const db = admin.firestore();
const app = express();

app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use(express.json());

// ==================== MIDDLEWARE ====================

async function verifyToken(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Токен жоқ' });
  }
  try {
    const decoded = await admin.auth().verifyIdToken(authHeader.split('Bearer ')[1]);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(401).json({ error: 'Токен жарамсыз' });
  }
}

async function adminOnly(req, res, next) {
  try {
    const doc = await db.collection('users').doc(req.user.uid).get();
    if (!doc.exists || doc.data().role !== 'admin') {
      return res.status(403).json({ error: 'Тек әкімшіге рұқсат' });
    }
    next();
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

// ==================== ПАЙДАЛАНУШЫЛАР ====================

app.post('/api/users', verifyToken, async (req, res) => {
  const { name, phone, role } = req.body;
  if (!name || !phone || !role) return res.status(400).json({ error: 'Деректер толық емес' });
  
  try {
    await db.collection('users').doc(req.user.uid).set({
      uid: req.user.uid, email: req.user.email, name, phone, role,
      rating: 0, totalReviews: 0, completedOrders: 0, totalEarnings: 0,
      photoUrl: '', isOnline: true, lastSeen: admin.firestore.FieldValue.serverTimestamp(),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log('✅ Пайдаланушы:', req.user.email, role);
    res.json({ message: 'Сақталды', role });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/users/me', verifyToken, async (req, res) => {
  try {
    const doc = await db.collection('users').doc(req.user.uid).get();
    if (!doc.exists) return res.status(404).json({ error: 'Табылмады' });
    res.json(doc.data());
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.put('/api/users/me', verifyToken, async (req, res) => {
  try {
    const { name, phone, photoUrl } = req.body;
    const data = {};
    if (name) data.name = name;
    if (phone) data.phone = phone;
    if (photoUrl) data.photoUrl = photoUrl;
    await db.collection('users').doc(req.user.uid).update(data);
    res.json({ message: 'Жаңартылды' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/users/:uid/rating', async (req, res) => {
  try {
    const doc = await db.collection('users').doc(req.params.uid).get();
    if (!doc.exists) return res.status(404).json({ error: 'Табылмады' });
    res.json({ rating: doc.data().rating || 0, totalReviews: doc.data().totalReviews || 0 });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ==================== ТАПСЫРЫСТАР ====================

app.post('/api/orders', verifyToken, async (req, res) => {
  const { description, address, entrance, comment, phone, price, cleaningType, rooms } = req.body;
  if (!description || !address || !phone || !price) return res.status(400).json({ error: 'Міндетті өрістер толтырылмады' });
  
  try {
    const ref = db.collection('orders').doc();
    await ref.set({
      id: ref.id, clientId: req.user.uid, description, address,
      entrance: entrance || '', comment: comment || '', phone,
      price: Number(price), status: 'pending', cleanerId: null,
      cleaningType: cleaningType || '', rooms: rooms || '',
      review: null, paymentStatus: 'pending',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log('✅ Тапсырыс:', ref.id);
    res.json({ message: 'Тапсырыс жасалды', orderId: ref.id });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/orders/my', verifyToken, async (req, res) => {
  try {
    const snapshot = await db.collection('orders').where('clientId', '==', req.user.uid).orderBy('createdAt', 'desc').get();
    res.json(snapshot.docs.map(d => d.data()));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/orders/available', verifyToken, async (req, res) => {
  try {
    const snapshot = await db.collection('orders').where('status', '==', 'pending').orderBy('createdAt', 'desc').get();
    res.json(snapshot.docs.map(d => d.data()));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/orders/accepted', verifyToken, async (req, res) => {
  try {
    const snapshot = await db.collection('orders').where('cleanerId', '==', req.user.uid).orderBy('createdAt', 'desc').get();
    res.json(snapshot.docs.map(d => d.data()));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.put('/api/orders/:id/accept', verifyToken, async (req, res) => {
  try {
    const ref = db.collection('orders').doc(req.params.id);
    const doc = await ref.get();
    if (!doc.exists) return res.status(404).json({ error: 'Табылмады' });
    if (doc.data().status !== 'pending') return res.status(400).json({ error: 'Бос емес' });
    
    await ref.update({ cleanerId: req.user.uid, status: 'accepted', updatedAt: admin.firestore.FieldValue.serverTimestamp() });
    res.json({ message: 'Қабылданды' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.put('/api/orders/:id/start', verifyToken, async (req, res) => {
  try {
    await db.collection('orders').doc(req.params.id).update({ status: 'in_progress', updatedAt: admin.firestore.FieldValue.serverTimestamp() });
    res.json({ message: 'Басталды' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.put('/api/orders/:id/complete', verifyToken, async (req, res) => {
  try {
    const doc = await db.collection('orders').doc(req.params.id).get();
    if (!doc.exists) return res.status(404).json({ error: 'Табылмады' });
    
    await db.collection('orders').doc(req.params.id).update({ status: 'completed', updatedAt: admin.firestore.FieldValue.serverTimestamp() });
    
    const cleanerId = doc.data().cleanerId;
    if (cleanerId) {
      await db.collection('users').doc(cleanerId).update({
        completedOrders: admin.firestore.FieldValue.increment(1),
        totalEarnings: admin.firestore.FieldValue.increment(doc.data().price || 0),
      });
    }
    res.json({ message: 'Аяқталды' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.put('/api/orders/:id/cancel', verifyToken, async (req, res) => {
  try {
    await db.collection('orders').doc(req.params.id).update({ status: 'cancelled', updatedAt: admin.firestore.FieldValue.serverTimestamp() });
    res.json({ message: 'Бас тартылды' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ==================== ПІКІРЛЕР ====================

app.post('/api/reviews', verifyToken, async (req, res) => {
  const { orderId, cleanerId, rating, comment } = req.body;
  if (!orderId || !cleanerId || !rating) return res.status(400).json({ error: 'Деректер толық емес' });
  
  try {
    const ref = db.collection('reviews').doc();
    await ref.set({
      id: ref.id, orderId, cleanerId, clientId: req.user.uid,
      rating: Number(rating), comment: comment || '',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    await db.collection('orders').doc(orderId).update({ review: ref.id });
    
    const reviewsSnap = await db.collection('reviews').where('cleanerId', '==', cleanerId).get();
    const total = reviewsSnap.size;
    const sum = reviewsSnap.docs.reduce((s, d) => s + d.data().rating, 0);
    
    await db.collection('users').doc(cleanerId).update({ rating: total > 0 ? sum / total : 0, totalReviews: total });
    
    res.json({ message: 'Пікір қалдырылды' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/reviews/cleaner/:uid', async (req, res) => {
  try {
    const snapshot = await db.collection('reviews').where('cleanerId', '==', req.params.uid).orderBy('createdAt', 'desc').get();
    res.json(snapshot.docs.map(d => d.data()));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ==================== ХАБАРЛАМАЛАР ====================

app.post('/api/messages', verifyToken, async (req, res) => {
  const { orderId, receiverId, text } = req.body;
  if (!orderId || !receiverId || !text) return res.status(400).json({ error: 'Деректер толық емес' });
  
  try {
    const ref = db.collection('messages').doc();
    await ref.set({
      id: ref.id, orderId, senderId: req.user.uid, receiverId, text,
      read: false, createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    res.json({ message: 'Жіберілді' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/messages/:orderId', verifyToken, async (req, res) => {
  try {
    const snapshot = await db.collection('messages').where('orderId', '==', req.params.orderId).orderBy('createdAt', 'asc').get();
    res.json(snapshot.docs.map(d => d.data()));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/messages/unread/count', verifyToken, async (req, res) => {
  try {
    const snapshot = await db.collection('messages').where('receiverId', '==', req.user.uid).where('read', '==', false).get();
    res.json({ count: snapshot.size });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ==================== ТӨЛЕМДЕР ====================

app.post('/api/payments', verifyToken, async (req, res) => {
  const { orderId, amount, method } = req.body;
  try {
    const ref = db.collection('payments').doc();
    await ref.set({
      id: ref.id, orderId, clientId: req.user.uid, amount: Number(amount),
      method: method || 'card', status: 'completed',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    await db.collection('orders').doc(orderId).update({ paymentStatus: 'paid' });
    res.json({ message: 'Төлем жасалды' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/payments/my', verifyToken, async (req, res) => {
  try {
    const snapshot = await db.collection('payments').where('clientId', '==', req.user.uid).orderBy('createdAt', 'desc').get();
    res.json(snapshot.docs.map(d => d.data()));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ==================== ӘКІМШІ ====================

app.get('/api/admin/stats', verifyToken, adminOnly, async (req, res) => {
  try {
    const orders = await db.collection('orders').get();
    const users = await db.collection('users').get();
    
    res.json({
      totalOrders: orders.size,
      completed: orders.docs.filter(d => d.data().status === 'completed').length,
      pending: orders.docs.filter(d => d.data().status === 'pending').length,
      revenue: orders.docs.filter(d => d.data().status === 'completed').reduce((s, d) => s + (d.data().price || 0), 0),
      totalUsers: users.size,
      cleaners: users.docs.filter(d => d.data().role === 'cleaner').length,
      clients: users.docs.filter(d => d.data().role === 'client').length,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/admin/users', verifyToken, adminOnly, async (req, res) => {
  try {
    const snapshot = await db.collection('users').orderBy('createdAt', 'desc').get();
    res.json(snapshot.docs.map(d => d.data()));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/admin/orders', verifyToken, adminOnly, async (req, res) => {
  try {
    const snapshot = await db.collection('orders').orderBy('createdAt', 'desc').get();
    res.json(snapshot.docs.map(d => d.data()));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.put('/api/admin/orders/:id/status', verifyToken, adminOnly, async (req, res) => {
  try {
    await db.collection('orders').doc(req.params.id).update({ status: req.body.status, updatedAt: admin.firestore.FieldValue.serverTimestamp() });
    res.json({ message: 'Статус өзгертілді' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.delete('/api/admin/orders/:id', verifyToken, adminOnly, async (req, res) => {
  try {
    await db.collection('orders').doc(req.params.id).delete();
    res.json({ message: 'Жойылды' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.put('/api/admin/users/:uid/block', verifyToken, adminOnly, async (req, res) => {
  try {
    const doc = await db.collection('users').doc(req.params.uid).get();
    const blocked = !doc.data().blocked;
    await db.collection('users').doc(req.params.uid).update({ blocked });
    res.json({ blocked });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ==================== ТОП КЛИНЕРЛЕР ====================

app.get('/api/top-cleaners', async (req, res) => {
  try {
    const snapshot = await db.collection('users').where('role', '==', 'cleaner').orderBy('rating', 'desc').limit(10).get();
    res.json(snapshot.docs.map(d => d.data()));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ==================== TEST ====================

app.get('/', (req, res) => {
  res.json({ message: '✅ CleanPro API', time: new Date().toISOString() });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`✅ http://localhost:${PORT}`));