const express = require('express');
const path = require('path');
require('dotenv').config();

const app = express();
const session = require('express-session');
const bodyParser = require('body-parser');
const mysql = require('mysql2/promise');

// Middleware
app.use(express.json());
app.use(express.static(path.join(__dirname, '/public')));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(session({
  secret: 'secret-key',
  resave: false,
  saveUninitialized: true
}));
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '123456',
  database: 'DogWalkService'
});
// Routes
const walkRoutes = require('./routes/walkRoutes');
const userRoutes = require('./routes/userRoutes');

app.use('/api/walks', walkRoutes);
app.use('/api/users', userRoutes);
app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  try {
    const [rows] = await pool.query(
      'SELECT * FROM Users WHERE username = ? AND password_hash = ?',
      [username, password]
    );

    if (rows.length === 1) {
      req.session.user = {
        id: rows[0].user_id,
        username: rows[0].username,
        role: rows[0].role
      };

      // 根据角色跳转
      if (rows[0].role === 'owner') {
        res.redirect('/owner-dashboard.html');
      } else {
        res.redirect('/walker-dashboard.html');
      }
    } else {
      res.status(401).send('Invalid credentials');
    }
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});
app.post('/logout', (req, res) => {
  req.session.destroy(err => {
    if (err) {
      console.error("Logout failed:", err);
      return res.status(500).send("Logout failed");
    }
    res.clearCookie('connect.sid');
    res.redirect('/');
  });
});


// Export the app instead of listening here
module.exports = app;
