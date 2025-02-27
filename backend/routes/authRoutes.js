const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

const router = express.Router();

// Middleware to verify token and check role
const verifyAdmin = (req, res, next) => {

  const token = req.headers.authorization?.split(' ')[1]; // Extract token from Authorization header
  if (!token) {
    return res.status(403).json({ message: 'Access denied. No token provided.' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded; // Attach the decoded token payload to the request
    if (req.user.role !== 'Admin') {
      return res.status(403).json({ message: 'Access denied. Only Admins are allowed.' });
    }

    next(); // proceed to the next middleware or route handler
  } catch (error) {
    console.error('Invalid token:', error);
    res.status(401).json({ message: 'Invalid or expired token' });
  }
};

// Login Route
router.post('/login', async (req, res) => {
  const { username, password } = req.body;
  console.log('Login attempt:', { username, password }); // Debugging log

  try {
    const user = await User.findOne({ username });
    if (!user) {
      console.log('User not found'); // Debugging log
      return res.status(404).json({ message: 'User not found' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    console.log('Password match:', isMatch); // Debugging log

    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign(
      { id: user._id, role: user.role, username: user.username },
      process.env.JWT_SECRET,
      { expiresIn: '1d' }
    );
    res.json({ token, role: user.role, id: user._id, username: user.username });
  } catch (error) {
    console.error('Server error during login:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Create User Route (Admin Only)
router.post('/create-user', verifyAdmin, async (req, res) => {
  const { username, password, role, created_by } = req.body;
  try {
    const newUser = new User({ username, password, role, created_by });
    await newUser.save();
    res.status(201).json({ message: 'User created successfully' });
  } catch (error) {
    console.error('Error creating user:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
