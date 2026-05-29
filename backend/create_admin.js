// create_admin.js
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const auth = admin.auth();

async function createAdmin() {
  try {
    // 1. Firebase Auth-та пайдаланушы құру
    const userRecord = await auth.createUser({
      email: 'admin@cleaning.kz',
      password: 'admin123456',
      displayName: 'Әкімші',
    });

    console.log('Пайдаланушы құрылды:', userRecord.uid);

    // 2. Firestore-да admin профилін құру
    await db.collection('users').doc(userRecord.uid).set({
      uid: userRecord.uid,
      email: 'admin@cleaning.kz',
      name: 'Әкімші',
      phone: '+77001234567',
      role: 'admin',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log('Әкімші профилі Firestore-да сақталды');
    console.log('Email: admin@cleaning.kz');
    console.log('Құпия сөз: admin123456');
    console.log('UID:', userRecord.uid);
    
    process.exit(0);
  } catch (error) {
    console.error('Қате:', error);
    process.exit(1);
  }
}

createAdmin();