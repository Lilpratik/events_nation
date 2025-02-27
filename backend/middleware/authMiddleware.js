// const jwt = require('jsonwebtoken');
// const User = require('../models/User'); // Adjust the path based on your folder structure.

// // Middleware for authentication and role-based authorization
// const authMiddleware = (allowedRoles) => {
//     return async (req, res, next) => {
//         try {
//             const token = req.headers.authorization?.split(' ')[1]; // Extract Bearer token
//             if (!token) {
//                 return res.status(401).json({ message: 'Unauthorized: No token provided' });
//             }

//             // Verify the token
//             const decoded = jwt.verify(token, process.env.JWT_SECRET);
//             req.user = {
//               id: decoded.id,
//               role: decoded.role,
//             }; // Attach decoded data to request


//             // Optionally, fetch full user details if needed
//             // req.userDetails = await User.findById(decoded.id);

//             // Check if the user's role is allowed
//             const user = await User.findById(decoded.id);
//             if (!user || !allowedRoles.includes(user.role)) {
//                 return res.status(403).json({ message: 'Forbidden: Access denied' });
//             }

//             next(); // Proceed to the next middleware or route
//         } catch (error) {
//             console.error(error);
//             res.status(401).json({ message: 'Unauthorized: Invalid token' });
//         }
//     };
// };

// module.exports = { authMiddleware };


const jwt = require('jsonwebtoken');
const User = require('../models/User');

const authMiddleware = (roles) => async (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Unauthorized: No token provided' });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = {
      id: decoded.id,
      role: decoded.role,
    };

    // Optionally, fetch the full user details if needed
    // req.userDetails = await User.findById(decoded.id);

    if (roles && !roles.includes(req.user.role)) {
      return res.status(403).json({ message: 'Forbidden: Access denied' });
    }

    next();
  } catch (error) {
    return res.status(401).json({ message: 'Unauthorized: Invalid token' });
  }
};

module.exports = { authMiddleware };
