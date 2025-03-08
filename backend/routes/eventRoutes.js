const express = require('express');
const Event = require('../models/Event');
const { authMiddleware } = require('../middleware/authMiddleware');
const User = require('../models/User');

const router = express.Router();
router.post(
  '/',
  authMiddleware(['Admin', 'Supervisor']),
  async (req, res) => {
    try {
      const {
        event_name,
        description,
        location,
        start_date,
        end_date,
        expected_date,
        budget,
        assigned_supervisor,
        assigned_event_manager,
        client_username,
        tasks,
        progress,
      } = req.body;

      // Validate required fields
      if (!event_name || !location || !start_date || !end_date) {
        return res.status(400).json({
          message: 'Required fields (event_name, location, start_date, end_date) are missing.',
        });
      }

      // Resolve usernames to ObjectIds
      const supervisor = await User.findOne({ username: assigned_supervisor });
      const eventManager = await User.findOne({ username: assigned_event_manager });
      const client = await User.findOne({ username: client_username });

      if (!supervisor || !eventManager || !client) {
        return res.status(400).json({
          message: 'Invalid usernames for supervisor, event manager, or client.',
        });
      }

      // Process tasks and resolve `assigned_to` usernames
      const resolvedTasks = await Promise.all(
        tasks.map(async (task) => {
          const assignedUser = await User.findOne({ username: task.assigned_to });
          if (!assignedUser && task.assigned_to) {
            throw new Error(`Invalid username for task assignment: ${task.assigned_to}`);
          }
          return {
            ...task,
            assigned_to: assignedUser ? assignedUser._id : null,
          };
        })
      );

      // Create the event
      const newEvent = new Event({
        event_name,
        description,
        location,
        start_date,
        end_date,
        expected_date,
        budget,
        assigned_supervisor: supervisor._id,
        assigned_event_manager: eventManager._id,
        client_id: client._id,
        tasks: resolvedTasks,
        progress,
      });

      await newEvent.save();

      res.status(201).json({
        message: 'Event created successfully.',
        event: newEvent,
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({
        message: error.message || 'An error occurred while creating the event.',
      });
    }
  }
);

// Get all events (Admin, Supervisor - but restricted to supervisor's assigned events)
router.get('/', authMiddleware(['Admin', 'Supervisor']), async (req, res) => {
  try {
    const { role, id: userId } = req.user;

    let events;

    if (role === 'Admin') {
      // Admin can view all events
      events = await Event.find().populate('assigned_supervisor assigned_event_manager client_id');
    } else if (role === 'Supervisor') {
      // Supervisor can only view events assigned to them
      events = await Event.find({ assigned_supervisor: userId }).populate('assigned_supervisor assigned_event_manager client_id');
    }

    res.json(events);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

router.get('/:id', authMiddleware(['Admin', 'Supervisor', 'EventManager', 'Client']), async (req, res) => {
  try {
    const { id } = req.params;
    const { role, id: userId } = req.user; // Extract role and user ID from token

    let event;

    if (role === 'Admin' || role === 'Supervisor') {
      // Admin and Supervisor can fetch any event by ID
      event = await Event.findById(id).populate('tasks.assigned_to');
    } else if (role === 'Client') {
      // Clients can only fetch their own events
      event = await Event.findOne({
        _id: id,
        client_id: userId,
      }).populate('tasks.assigned_to');
    } else if (role === 'EventManager') {
      // EventManagers can only fetch events assigned to them
      event = await Event.findOne({
        _id: id,
        assigned_event_manager: userId,
      }).populate('tasks.assigned_to');
    }

    if (!event) {
      return res.status(404).json({ message: 'Event not found or access denied' });
    }

    res.json(event);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});


router.get('/user/events', authMiddleware(['Client', 'EventManager']), async (req, res) => {
  try {
    const { role, id: userId } = req.user;

    let events;

    if (role === 'Client') {
      // Fetch all events for the client
      events = await Event.find({ client_id: userId }).populate('tasks.assigned_to');
    } else if (role === 'EventManager') {
      // Fetch all events assigned to the EventManager
      events = await Event.find({ assigned_event_manager: userId }).populate('tasks.assigned_to');
    }

    res.json(events);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});


// Update Event (Supervisor only)
// router.put('/:id', authMiddleware(['Supervisor', 'EventManager']), async (req, res) => {
//   try {
//       const event = await Event.findByIdAndUpdate(req.params.id, req.body, { new: true });
//       if (!event) return res.status(404).json({ message: 'Event not found' });
//       res.json(event);
//   } catch (err) {
//       res.status(500).json({ message: 'Server error' });
//   }
// });

// Update an Event (Only Supervisor and EventManager can update)
router.put('/:id', authMiddleware(['Supervisor', 'EventManager']), async (req, res) => {
    try {
        console.log("Updating Event ID:", req.params.id);
        console.log("Received Body:", req.body);

        const event = await Event.findByIdAndUpdate(req.params.id, req.body, { new: true });

        if (!event) return res.status(404).json({ message: 'Event not found' });

        res.json(event);
    } catch (err) {
        console.error("Update Error:", err);
        res.status(500).json({ message: 'Server error' });
    }
});

// Delete Event (Admin only)
router.delete('/:id', authMiddleware(['Admin']), async (req, res) => {
  try {
      const event = await Event.findByIdAndDelete(req.params.id);
      if (!event) return res.status(404).json({ message: 'Event not found' });
      res.json({ message: 'Event deleted' });
  } catch (err) {
      res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
