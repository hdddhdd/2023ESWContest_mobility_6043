import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getDatabase } from "firebase/database";

const firebaseConfig = {
  apiKey: "AIzaSyCmI_NWtDI4VQJumV-KPbsl7Fh6awHGiRU",
  authDomain: "temp-f41a9.firebaseapp.com",
  databaseURL: "https://temp-f41a9-default-rtdb.firebaseio.com",
  projectId: "temp-f41a9",
  storageBucket: "temp-f41a9.appspot.com",
  messagingSenderId: "656448348086",
  appId: "1:656448348086:web:ce17e0884ded22d0fcab17",
  measurementId: "G-8JRV2XVRM2"
};

const app = initializeApp(firebaseConfig);
export const dbService = getFirestore(app);
export const realtimeDbService = getDatabase(app);
