import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getDatabase } from "firebase/database";

const firebaseConfig = {
  apiKey: "AIzaSyDn47NDPoiBHtdrhEtrR0SWSLBf-aFv8SQ",
  authDomain: "whycarno-firebase.firebaseapp.com",
  databaseURL: "https://whycarno-firebase-default-rtdb.firebaseio.com",
  projectId: "whycarno-firebase",
  storageBucket: "whycarno-firebase.appspot.com",
  messagingSenderId: "397000885213",
  appId: "1:397000885213:web:0a84ef9e8a9c5f7f712c34",
  measurementId: "G-SRSPM7Q4MR"
};

const app = initializeApp(firebaseConfig);
export const dbService = getFirestore(app);
export const realtimeDbService = getDatabase(app);
