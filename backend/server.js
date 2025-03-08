const dotenv = require('dotenv');
dotenv.config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const User = require('./models/User');
const authRoutes = require('./routes/authRoutes');
const eventRoutes = require('./routes/eventRoutes');

const app = express();

const { MONGO_URI, PORT, ADMIN_PASSWORD } = process.env;

// Middleware
app.use(cors());
app.use(express.json());

// Database connection
mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
.then(() => {
  console.log("MongoDB is connected successfully");
  createAdmin(); // Ensure admin is created after successful MongoDB connection
})
.catch((err) => console.error('MongoDB connection error:', err));


// Initial Admin Creation
async function createAdmin() {
  try {
    const existingAdmin = await User.findOne({ role: 'Admin' });
    if (!existingAdmin) {
      const admin = new User({
        username: 'admin',
        password: ADMIN_PASSWORD, // Do not hash here
        role: 'Admin',
      });
      await admin.save(); // The 'pre-save' hook will hash the password
      console.log('Initial Admin user created.');
    } else {
      console.log('Admin user already exists.');
    }
  } catch (error) {
    console.error('Error creating initial Admin:', error);
  }
}


// Test Route
app.get('/' , (req, res) => {
  res.send('Event Management App Backend Running');
});


// Routes
app.use('/api/auth', authRoutes);
app.use('/api/events', eventRoutes);

// Start Server
const port = PORT || 5000;
app.listen(port, '0.0.0.0', () => {
  console.log(`Server is running on port ${port}`);
});
