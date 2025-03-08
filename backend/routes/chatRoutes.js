// routes/chatRoutes.js
const express = require('express');
const router = express.Router();
const { sendMessage, getMessages } = require('../controllers/chatController');
const authMiddleware = require('../middleware/authMiddleware');

router.post('/send', authMiddleware, sendMessage);
router.get('/:eventId', authMiddleware, getMessages);

module.exports = router;
