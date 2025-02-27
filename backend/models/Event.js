const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
  event_name: {
    type: String,
    required: true,
  },
  description: {
    type: String,
  },
  location: {
    type: String,
    required: true,
  },
  start_date: {
    type: Date,
    required: true,
  },
  end_date: {
    type: Date,
    required: true,
  },
  expected_date: {
    type: Date,
  },
  budget: {
    type: Number,
  },
  assigned_supervisor: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  },
  assigned_event_manager: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  },
  client_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  },
  tasks: [
    {
      task_name: {
        type: String,
        required: true,
      },
      status: {
        type: String,
        enum: ['Pending', 'In Progress', 'Completed'],
        default: 'Pending',
      },
      due_date: {
        type: Date,
      },
      assigned_to: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
      },
    },
  ],
  progress: {
    type: Number,
    default: 0,
  },
});

const Event = mongoose.model('Event', eventSchema);
module.exports = Event;
