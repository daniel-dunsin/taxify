import firebase from 'firebase-admin';
import path from 'path';

firebase.initializeApp({
  credential: firebase.credential.cert(
    path.join(__dirname, '../../google-service-account.json')
  ),
});

export default firebase;
