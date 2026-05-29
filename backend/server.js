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

// app.use(cors({
//   origin: '*',
//   methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
//   allowedHeaders: ['Content-Type', 'Authorization'],
// }));
// app.use(express.json());

// // ==================== MIDDLEWARE ====================

// async function verifyToken(req, res, next) {
//   const authHeader = req.headers.authorization;
//   if (!authHeader || !authHeader.startsWith('Bearer ')) {
//     return res.status(401).json({ error: 'Токен жоқ' });
//   }
//   try {
//     const decoded = await admin.auth().verifyIdToken(authHeader.split('Bearer ')[1]);
//     req.user = decoded;
//     next();
//   } catch (error) {
//     res.status(401).json({ error: 'Токен жарамсыз' });
//   }
// }

// async function adminOnly(req, res, next) {
//   try {
//     const doc = await db.collection('users').doc(req.user.uid).get();
//     if (!doc.exists || doc.data().role !== 'admin') {
//       return res.status(403).json({ error: 'Тек әкімшіге рұқсат' });
//     }
//     next();
//   } catch (error) {
//     res.status(500).json({ error: error.message });
//   }
// }

// // ==================== ПАЙДАЛАНУШЫЛАР ====================

// app.post('/api/users', verifyToken, async (req, res) => {
//   const { name, phone, role } = req.body;
//   if (!name || !phone || !role) return res.status(400).json({ error: 'Деректер толық емес' });
  
//   try {
//     await db.collection('users').doc(req.user.uid).set({
//       uid: req.user.uid, email: req.user.email, name, phone, role,
//       rating: 0, totalReviews: 0, completedOrders: 0, totalEarnings: 0,
//       photoUrl: '', isOnline: true, lastSeen: admin.firestore.FieldValue.serverTimestamp(),
//       createdAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
//     console.log('✅ Пайдаланушы:', req.user.email, role);
//     res.json({ message: 'Сақталды', role });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.get('/api/users/me', verifyToken, async (req, res) => {
//   try {
//     const doc = await db.collection('users').doc(req.user.uid).get();
//     if (!doc.exists) return res.status(404).json({ error: 'Табылмады' });
//     res.json(doc.data());
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.put('/api/users/me', verifyToken, async (req, res) => {
//   try {
//     const { name, phone, photoUrl } = req.body;
//     const data = {};
//     if (name) data.name = name;
//     if (phone) data.phone = phone;
//     if (photoUrl) data.photoUrl = photoUrl;
//     await db.collection('users').doc(req.user.uid).update(data);
//     res.json({ message: 'Жаңартылды' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

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

// app.post('/api/orders', verifyToken, async (req, res) => {
//   const { description, address, entrance, comment, phone, price, cleaningType, rooms } = req.body;
//   if (!description || !address || !phone || !price) return res.status(400).json({ error: 'Міндетті өрістер толтырылмады' });
  
//   try {
//     const ref = db.collection('orders').doc();
//     await ref.set({
//       id: ref.id, clientId: req.user.uid, description, address,
//       entrance: entrance || '', comment: comment || '', phone,
//       price: Number(price), status: 'pending', cleanerId: null,
//       cleaningType: cleaningType || '', rooms: rooms || '',
//       review: null, paymentStatus: 'pending',
//       createdAt: admin.firestore.FieldValue.serverTimestamp(),
//       updatedAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
//     console.log('✅ Тапсырыс:', ref.id);
//     res.json({ message: 'Тапсырыс жасалды', orderId: ref.id });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.get('/api/orders/my', verifyToken, async (req, res) => {
//   try {
//     const snapshot = await db.collection('orders').where('clientId', '==', req.user.uid).orderBy('createdAt', 'desc').get();
//     res.json(snapshot.docs.map(d => d.data()));
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.get('/api/orders/available', verifyToken, async (req, res) => {
//   try {
//     const snapshot = await db.collection('orders').where('status', '==', 'pending').orderBy('createdAt', 'desc').get();
//     res.json(snapshot.docs.map(d => d.data()));
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.get('/api/orders/accepted', verifyToken, async (req, res) => {
//   try {
//     const snapshot = await db.collection('orders').where('cleanerId', '==', req.user.uid).orderBy('createdAt', 'desc').get();
//     res.json(snapshot.docs.map(d => d.data()));
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.put('/api/orders/:id/accept', verifyToken, async (req, res) => {
//   try {
//     const ref = db.collection('orders').doc(req.params.id);
//     const doc = await ref.get();
//     if (!doc.exists) return res.status(404).json({ error: 'Табылмады' });
//     if (doc.data().status !== 'pending') return res.status(400).json({ error: 'Бос емес' });
    
//     await ref.update({ cleanerId: req.user.uid, status: 'accepted', updatedAt: admin.firestore.FieldValue.serverTimestamp() });
//     res.json({ message: 'Қабылданды' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.put('/api/orders/:id/start', verifyToken, async (req, res) => {
//   try {
//     await db.collection('orders').doc(req.params.id).update({ status: 'in_progress', updatedAt: admin.firestore.FieldValue.serverTimestamp() });
//     res.json({ message: 'Басталды' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.put('/api/orders/:id/complete', verifyToken, async (req, res) => {
//   try {
//     const doc = await db.collection('orders').doc(req.params.id).get();
//     if (!doc.exists) return res.status(404).json({ error: 'Табылмады' });
    
//     await db.collection('orders').doc(req.params.id).update({ status: 'completed', updatedAt: admin.firestore.FieldValue.serverTimestamp() });
    
//     const cleanerId = doc.data().cleanerId;
//     if (cleanerId) {
//       await db.collection('users').doc(cleanerId).update({
//         completedOrders: admin.firestore.FieldValue.increment(1),
//         totalEarnings: admin.firestore.FieldValue.increment(doc.data().price || 0),
//       });
//     }
//     res.json({ message: 'Аяқталды' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.put('/api/orders/:id/cancel', verifyToken, async (req, res) => {
//   try {
//     await db.collection('orders').doc(req.params.id).update({ status: 'cancelled', updatedAt: admin.firestore.FieldValue.serverTimestamp() });
//     res.json({ message: 'Бас тартылды' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // ==================== ПІКІРЛЕР ====================

// app.post('/api/reviews', verifyToken, async (req, res) => {
//   const { orderId, cleanerId, rating, comment } = req.body;
//   if (!orderId || !cleanerId || !rating) return res.status(400).json({ error: 'Деректер толық емес' });
  
//   try {
//     const ref = db.collection('reviews').doc();
//     await ref.set({
//       id: ref.id, orderId, cleanerId, clientId: req.user.uid,
//       rating: Number(rating), comment: comment || '',
//       createdAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
    
//     await db.collection('orders').doc(orderId).update({ review: ref.id });
    
//     const reviewsSnap = await db.collection('reviews').where('cleanerId', '==', cleanerId).get();
//     const total = reviewsSnap.size;
//     const sum = reviewsSnap.docs.reduce((s, d) => s + d.data().rating, 0);
    
//     await db.collection('users').doc(cleanerId).update({ rating: total > 0 ? sum / total : 0, totalReviews: total });
    
//     res.json({ message: 'Пікір қалдырылды' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.get('/api/reviews/cleaner/:uid', async (req, res) => {
//   try {
//     const snapshot = await db.collection('reviews').where('cleanerId', '==', req.params.uid).orderBy('createdAt', 'desc').get();
//     res.json(snapshot.docs.map(d => d.data()));
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // ==================== ХАБАРЛАМАЛАР ====================

// app.post('/api/messages', verifyToken, async (req, res) => {
//   const { orderId, receiverId, text } = req.body;
//   if (!orderId || !receiverId || !text) return res.status(400).json({ error: 'Деректер толық емес' });
  
//   try {
//     const ref = db.collection('messages').doc();
//     await ref.set({
//       id: ref.id, orderId, senderId: req.user.uid, receiverId, text,
//       read: false, createdAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
//     res.json({ message: 'Жіберілді' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.get('/api/messages/:orderId', verifyToken, async (req, res) => {
//   try {
//     const snapshot = await db.collection('messages').where('orderId', '==', req.params.orderId).orderBy('createdAt', 'asc').get();
//     res.json(snapshot.docs.map(d => d.data()));
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.get('/api/messages/unread/count', verifyToken, async (req, res) => {
//   try {
//     const snapshot = await db.collection('messages').where('receiverId', '==', req.user.uid).where('read', '==', false).get();
//     res.json({ count: snapshot.size });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // ==================== ТӨЛЕМДЕР ====================

// app.post('/api/payments', verifyToken, async (req, res) => {
//   const { orderId, amount, method } = req.body;
//   try {
//     const ref = db.collection('payments').doc();
//     await ref.set({
//       id: ref.id, orderId, clientId: req.user.uid, amount: Number(amount),
//       method: method || 'card', status: 'completed',
//       createdAt: admin.firestore.FieldValue.serverTimestamp(),
//     });
//     await db.collection('orders').doc(orderId).update({ paymentStatus: 'paid' });
//     res.json({ message: 'Төлем жасалды' });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.get('/api/payments/my', verifyToken, async (req, res) => {
//   try {
//     const snapshot = await db.collection('payments').where('clientId', '==', req.user.uid).orderBy('createdAt', 'desc').get();
//     res.json(snapshot.docs.map(d => d.data()));
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // ==================== ӘКІМШІ ====================

// app.get('/api/admin/stats', verifyToken, adminOnly, async (req, res) => {
//   try {
//     const orders = await db.collection('orders').get();
//     const users = await db.collection('users').get();
    
//     res.json({
//       totalOrders: orders.size,
//       completed: orders.docs.filter(d => d.data().status === 'completed').length,
//       pending: orders.docs.filter(d => d.data().status === 'pending').length,
//       revenue: orders.docs.filter(d => d.data().status === 'completed').reduce((s, d) => s + (d.data().price || 0), 0),
//       totalUsers: users.size,
//       cleaners: users.docs.filter(d => d.data().role === 'cleaner').length,
//       clients: users.docs.filter(d => d.data().role === 'client').length,
//     });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.get('/api/admin/users', verifyToken, adminOnly, async (req, res) => {
//   try {
//     const snapshot = await db.collection('users').orderBy('createdAt', 'desc').get();
//     res.json(snapshot.docs.map(d => d.data()));
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.get('/api/admin/orders', verifyToken, adminOnly, async (req, res) => {
//   try {
//     const snapshot = await db.collection('orders').orderBy('createdAt', 'desc').get();
//     res.json(snapshot.docs.map(d => d.data()));
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// app.put('/api/admin/orders/:id/status', verifyToken, adminOnly, async (req, res) => {
//   try {
//     await db.collection('orders').doc(req.params.id).update({ status: req.body.status, updatedAt: admin.firestore.FieldValue.serverTimestamp() });
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

// app.put('/api/admin/users/:uid/block', verifyToken, adminOnly, async (req, res) => {
//   try {
//     const doc = await db.collection('users').doc(req.params.uid).get();
//     const blocked = !doc.data().blocked;
//     await db.collection('users').doc(req.params.uid).update({ blocked });
//     res.json({ blocked });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // ==================== ТОП КЛИНЕРЛЕР ====================

// app.get('/api/top-cleaners', async (req, res) => {
//   try {
//     const snapshot = await db.collection('users').where('role', '==', 'cleaner').orderBy('rating', 'desc').limit(10).get();
//     res.json(snapshot.docs.map(d => d.data()));
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// // ==================== TEST ====================

// app.get('/', (req, res) => {
//   res.json({ message: '✅ CleanPro API', time: new Date().toISOString() });
// });

// const PORT = process.env.PORT || 3000;
// app.listen(PORT, () => console.log(`✅ http://localhost:${PORT}`));


require('dotenv').config();
const express = require('express');
const admin = require('firebase-admin');
const cors = require('cors');

// ==================== FIREBASE INIT (RENDER ҮШІН) ====================
let serviceAccount;
let useLocalFile = false;

try {
  // Егер FIREBASE_SERVICE_ACCOUNT environment variable бар болса
  if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
    console.log('✅ Firebase initialized with env variable (Render)');
  } 
  // Жергілікті файлды қолдану (тек дамыту үшін)
  else {
    serviceAccount = require('./serviceAccountKey.json');
    useLocalFile = true;
    console.log('✅ Firebase initialized with local file');
  }
} catch (error) {
  console.error('❌ Firebase initialization error:', error.message);
  process.exit(1);
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const app = express();

// CORS конфигурациясы
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use(express.json());

console.log('✅ Firebase Firestore connected');
console.log('✅ Server starting...');

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
app.listen(PORT, () => console.log(`✅ Server running on port ${PORT}`));