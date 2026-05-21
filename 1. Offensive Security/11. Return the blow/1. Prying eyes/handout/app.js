const express = require('express');
const session = require('express-session');
const bodyParser = require('body-parser');
const bcrypt = require('bcryptjs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use(session({
  secret: 'your-secret-key-change-in-production',
  resave: false,
  saveUninitialized: true,
  cookie: { maxAge: 60000 * 60 } // 1 hour
}));

app.use(express.static(path.join(__dirname, 'public')));

// Sample users with hashed passwords (in production, use a database)
const users = {
  'admin': '$2b$10$Wkn26lNOVdOHIMUWCgOo4OHQ8yfCOVgL.sPGtP3PQv0ykXd8rTEE6', // password123
  'user': '$2b$10$pVttJpbJrYff9utX6n5u7.IstrWFmOwYJtPk8ADcz2ZHscD0v8Si6'   // user123
};

// Middleware to check authentication
const requireAuth = (req, res, next) => {
  if (req.session.user) {
    next();
  } else {
    res.redirect('/login');
  }
};

// Routes
app.get('/', (req, res) => {
  if (req.session.user) {
    res.sendFile(path.join(__dirname, 'public', 'dashboard.html'));
  } else {
    res.redirect('/login');
  }
});

app.get('/login', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'login.html'));
});

app.post('/login', (req, res) => {
  const { username, password } = req.body;
  
  if (users[username]) {
    bcrypt.compare(password, users[username], (err, isMatch) => {
      if (err) {
        return res.status(500).send('Server error');
      }
      
      if (isMatch) {
        req.session.user = username;
        res.redirect('/');
      } else {
        res.status(401).send(`
          <h1>Invalid credentials</h1>
          <p><a href="/login">Try again</a></p>
        `);
      }
    });
  } else {
    res.status(401).send(`
      <h1>Invalid credentials</h1>
      <p><a href="/login">Try again</a></p>
    `);
  }
});

app.get('/logout', (req, res) => {
  req.session.destroy();
  res.redirect('/login');
});

app.get('/api/user', requireAuth, (req, res) => {
  res.json({ user: req.session.user });
});

app.listen(PORT, () => {
  console.log(`App running on http://localhost:${PORT}`);
});
