// controllers/chatController.js
const Chat = require('../models/chatModel');
const User = require('../models/userModel');

// Send a message
exports.sendMessage = async (req, res) => {
  try {
    const { eventId, receiverId, message } = req.body;
    const senderId = req.user.id; // Extracted from JWT token

    if (!eventId || !receiverId || !message) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    const chatMessage = new Chat({ eventId, senderId, receiverId, message });
    await chatMessage.save();
    res.status(201).json(chatMessage);
  } catch (error) {
    res.status(500).json({ error: 'Error sending message' });
  }
};

// Fetch messages between client and event manager for a specific event
exports.getMessages = async (req, res) => {
  try {
    const { eventId } = req.params;
    const userId = req.user.id; // Extracted from JWT token

    const messages = await Chat.find({ eventId, $or: [{ senderId: userId }, { receiverId: userId }] })
      .populate('senderId', 'name')
      .populate('receiverId', 'name')
      .sort({ timestamp: 1 });

    res.status(200).json(messages);
  } catch (error) {
    res.status(500).json({ error: 'Error fetching messages' });
  }
};
