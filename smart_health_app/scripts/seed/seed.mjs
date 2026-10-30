// Task 1.6: fills the LOCAL emulators with demo data. Never touches the real
// Firebase project (it only talks to the emulator hosts below).
//
//   1. firebase emulators:start          (from smart_health_app/)
//   2. cd scripts/seed && npm install && npm run seed
//
// Safe to run more than once: users and documents use fixed IDs.
import { initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';

// Point the Admin SDK at the emulators. If these are not set the SDK would
// try to reach the real project, so we force them here.
process.env.FIRESTORE_EMULATOR_HOST ??= '127.0.0.1:8080';
process.env.FIREBASE_AUTH_EMULATOR_HOST ??= '127.0.0.1:9099';

initializeApp({ projectId: 'smart-health-96efc' });
const auth = getAuth();
const db = getFirestore();

const PASSWORD = 'Demo1234';

const users = [
  {
    // Ready to use: email verified + profile completed, so it opens on Home.
    email: 'demo@smarthealth.test',
    emailVerified: true,
    profile: {
      name: 'Demo Donor',
      phoneNumber: '+201000000001',
      bloodType: 'O-',
      profilePicUrl: null,
      isProfileCompleted: true,
    },
  },
  {
    // Verified but profile NOT completed, to test the "Complete profile" step.
    email: 'newuser@smarthealth.test',
    emailVerified: true,
    profile: {
      name: 'New User',
      phoneNumber: null,
      bloodType: null,
      profilePicUrl: null,
      isProfileCompleted: false,
    },
  },
  {
    // Not verified, to test the "Verify email" screen.
    email: 'unverified@smarthealth.test',
    emailVerified: false,
    profile: {
      name: 'Unverified User',
      phoneNumber: null,
      bloodType: null,
      profilePicUrl: null,
      isProfileCompleted: false,
    },
  },
];

// TODO(Dev3): align these fields with the real DoctorModel before relying on
// them. They are only here so the emulator is not empty.
const doctors = [
  { id: 'dr-sarah-ahmed', name: 'Dr. Sarah Ahmed', specialty: 'Cardiology', rating: 4.8, yearsOfExperience: 12, consultationFee: 400 },
  { id: 'dr-omar-hassan', name: 'Dr. Omar Hassan', specialty: 'Dermatology', rating: 4.6, yearsOfExperience: 8, consultationFee: 300 },
  { id: 'dr-mona-ali', name: 'Dr. Mona Ali', specialty: 'Pediatrics', rating: 4.9, yearsOfExperience: 15, consultationFee: 350 },
  { id: 'dr-karim-nabil', name: 'Dr. Karim Nabil', specialty: 'Orthopedics', rating: 4.5, yearsOfExperience: 10, consultationFee: 450 },
];

async function upsertUser({ email, emailVerified, profile }) {
  let record;
  try {
    record = await auth.getUserByEmail(email);
    await auth.updateUser(record.uid, { emailVerified, password: PASSWORD });
  } catch (error) {
    if (error.code !== 'auth/user-not-found') throw error;
    record = await auth.createUser({
      email,
      password: PASSWORD,
      emailVerified,
      displayName: profile.name,
    });
  }

  await db.collection('users').doc(record.uid).set(
    { email, ...profile, createdAt: Timestamp.now() },
    { merge: true },
  );
  console.log(`user    ${email}  (verified: ${emailVerified}, profile done: ${profile.isProfileCompleted})`);
}

async function main() {
  for (const user of users) {
    await upsertUser(user);
  }

  for (const { id, ...data } of doctors) {
    await db.collection('doctors').doc(id).set(data, { merge: true });
    console.log(`doctor  ${data.name}`);
  }

  console.log(`\nDone. Password for every demo account: ${PASSWORD}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
