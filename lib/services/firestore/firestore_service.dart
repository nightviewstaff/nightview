class FirestoreService{


  // const admin = require("firebase-admin");

// Initialize Firebase
//   admin.initializeApp({
//     credential: admin.credential.applicationDefault(),
//   });

  // const db = admin.firestore();
  //
  // async function findDuplicates() {
  //   const clubsRef = db.collection("clubs");
  //   const snapshot = await clubsRef.get();
  //
  //   const clubData = [];
  //   const duplicates = new Map();
  //
  //   snapshot.forEach(doc => {
  //   const data = doc.data();
  //   const uniqueKey = `${data.name}-${data.lat}-${data.lon}`; // Define your criteria for duplicates
  //   if (clubData.includes(uniqueKey)) {
  //   if (!duplicates.has(uniqueKey)) {
  //   duplicates.set(uniqueKey, []);
  //   }
  //   duplicates.get(uniqueKey).push(doc.id); // Store duplicate document IDs
  //   } else {
  //   clubData.push(uniqueKey);
  //   }
  //   });
  //
  //   if (duplicates.size > 0) {
  //     console.log("Duplicates found:");
  //     duplicates.forEach((docIds, key) => {
  //     console.log(`Duplicate Key: ${key}`);
  //         console.log(`Document IDs: ${docIds.join(", ")}`);
  //   });
  //   } else {
  //   console.log("No duplicates found!");
  //   }
  // }
  //
  // findDuplicates().catch(console.error);
//



}