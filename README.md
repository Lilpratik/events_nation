<h1>🎉 Events Nation App - Event Management System 🎊</h1>
<hr><p>📌 Overview</p>
<p>The Events Nation App is a production-level Event Management System designed with a Flutter frontend and a MERN (MongoDB, Express.js, React, Node.js) backend. It facilitates role-based event management and tracking for an event company, offering features tailored for different roles.</p><h2>General Information</h2>
<hr><ul>
<li>🚀 Features</li>
</ul>
<p>✅ Role-based access control (RBAC) with four roles:</p>
<p>🛠 Administrator: Manages users, roles, and events.</p>
<p>🧑‍💼 Supervisor: Assigns Event Managers and monitors event progress.</p>
<p>🎯 Event Manager: Creates and updates events and tasks.</p>
<p>👥 Client: Views event details and updates.</p>
<p>✅ Secure JWT authentication
✅ RESTful API communication between frontend and backend
✅ Event and task progress tracking</p><ul>
<li>🏛️ System Architecture</li>
</ul>
<p>🎨 Frontend (Flutter Application)</p>
<p>🖥️ Provides user interfaces for all roles.</p>
<p>🔄 Communicates with the backend API using RESTful requests.</p>
<p>🔒 Implements secure login and authentication.</p>
<p>📊 Displays role-based dashboards and event progress.</p>
<p>🗄️ Backend (MERN Stack)</p>
<p>🛢️ MongoDB: Stores users, events, tasks, and progress updates.</p>
<p>🔧 Express.js: Handles API endpoints.</p>
<p>🚀 Node.js: Executes backend logic.</p>
<p>🔑 JWT Authentication for secure session management.</p><ul>
<li>🔁 System Flow
──────────────┐        ┌──────────────┐        ┌──────────────┐        ┌──────────────┐
│ Administrator│        │  Supervisor  │        │ Event Manager│        │    Client    │
└──────┬───────┘        └──────┬───────┘        └──────┬───────┘        └──────┬───────┘
│                        │                        │                        │
Create Users      Assign Managers      Manage Tasks      View Event Details
Manage Events     Track Progress       Update Status     Receive Updates
Full Access       Limited Access       Limited Access    V┌iew-Only Access</li>
</ul><h2>Technologies Used</h2>
<hr><ul>
<li>JavaScript</li>
</ul><ul>
<li>React</li>
</ul><ul>
<li>NodeJS</li>
</ul><ul>
<li>MongoDB</li>
</ul><ul>
<li>Flutter</li>
</ul><h2>Features</h2>
<hr><ul>
<li>🔌 Backend API Endpoints  🔑 Authentication and User Management  POST /api/auth/login - 🔐 User login.  POST /api/auth/create-user - 🛠 Admin creates users.  📅 Event Management  POST /api/events - 📌 Create an event (Admin).  GET /api/events - 📋 Get all events (Admin, Supervisor).  GET /api/events/:id - 🔍 Get event details (Supervisor, Event Manager, Client).  PUT /api/events/:id - ✏️ Update event details (Supervisor, Event Manager).  DELETE /api/events/:id - ❌ Delete an event (Admin).  ✅ Task Management  POST /api/events/:eventId/tasks - 📝 Add task to an event (Event Manager).  PUT /api/events/:eventId/tasks/:taskId - 🔄 Update task status (Event Manager).  GET /api/events/:eventId/tasks - 📂 Get all tasks (Supervisor, Event Manager, Client).🔒 Security Considerations  🏷️ JWT Authentication for secure sessions.  🔐 Role-Based Access Control (RBAC) for restricted access.  🔍 Input Validation &amp; Data Sanitization to prevent security vulnerabilities.</li>
</ul><h2>Setup</h2>
<hr><p>🛠️ Setup Instructions</p>
<p>📥 1. Clone the Repository</p>
<p>git clone &lt;repository_url&gt;
cd events-nation-app</p>
<p>⚙️ 2. Backend Setup</p>
<p>cd backend
npm install
npm start</p>
<p>📱 3. Frontend Setup
cd frontend
flutter pub get
flutter run
</p>
<p>Screenshots
 ![Screenshot_20250227-211701](https://github.com/user-attachments/assets/77ce52e2-52b7-4b9d-8110-cc75e5d1552b)
 ![Screenshot_20250227-211813](https://github.com/user-attachments/assets/f5dc9fab-33d7-451a-832d-1f31111eae34)
![Screenshot_20250227-211808](https://github.com/user-attachments/assets/629344ef-8d8f-4d5a-bd4d-78e563a3c7ba)
![Screenshot_20250227-211751](https://github.com/user-attachments/assets/a59b2c91-68a1-48c8-aa8a-49b01e3261fd)
![Screenshot_20250227-211748](https://github.com/user-attachments/assets/e110ea6d-f744-4728-a022-144cbbea1361)
![Screenshot_20250227-211636](https://github.com/user-attachments/assets/403b4cd8-9e2c-4748-9289-c1adb01b2e1c)
![Screenshot_20250227-211629](https://github.com/user-attachments/assets/92e97d4a-f265-4ebd-b46e-04c87c6ae2f9)
![Screenshot_20250227-211611](https://github.com/user-attachments/assets/ddd7c4eb-8590-4bd7-a500-a3d981495a36)

</p>
</p><h2>Project Status</h2>
<hr><p>In Progress</p><h2>Contact</h2>
<hr><p><span style="margin-right: 30px;"></span><a href="www.linkedin.com/in/pratikmohite343"><img target="_blank" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linkedin/linkedin-original.svg" style="width: 10%;"></a><span style="margin-right: 30px;"></span><a href="www.github.com/Lilpratik"><img target="_blank" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg" style="width: 10%;"></a></p>
