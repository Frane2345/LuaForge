// LuaForge Backend Server
// Deploy this to Railway.app or Render.com (both free)
// Run locally: node server.js

const express = require("express");
const cors = require("cors");
const crypto = require("crypto");

const app = express();
app.use(cors());
app.use(express.json());

// In-memory store (use a database in production)
// token -> { code, createdAt, used }
const sessions = {};
const pendingCode = {};

// ========== HEALTH CHECK ==========
app.get("/", (req, res) => {
  res.json({ status: "LuaForge backend running", version: "1.0.0" });
});

// ========== PLUGIN ENDPOINTS ==========

// Plugin calls this to get a session token
app.get("/api/plugin/status", (req, res) => {
  const token = crypto.randomUUID();
  sessions[token] = { createdAt: Date.now() };
  pendingCode[token] = "";
  console.log("[Plugin] New session:", token);
  res.json({ token, status: "connected" });
});

// Plugin polls this every 2 seconds for new code
app.get("/api/plugin/poll", (req, res) => {
  const { token } = req.query;
  if (!token || !sessions[token]) {
    return res.status(401).json({ error: "Invalid token" });
  }
  const code = pendingCode[token] || "";
  if (code) {
    pendingCode[token] = ""; // clear after sending
  }
  res.json({ code });
});

// ========== DASHBOARD ENDPOINTS ==========

// Dashboard calls this when user clicks "Inject to Studio"
app.post("/api/dashboard/inject", (req, res) => {
  const { token, code } = req.body;
  if (!token || !sessions[token]) {
    return res.status(401).json({ error: "Invalid token" });
  }
  if (!code) {
    return res.status(400).json({ error: "No code provided" });
  }
  pendingCode[token] = code;
  console.log("[Dashboard] Code queued for token:", token);
  res.json({ success: true });
});

// ========== CREDIT SYSTEM ==========

const users = {};
// userId -> { credits, lastReset, plan }

function getOrCreateUser(userId) {
  if (!users[userId]) {
    users[userId] = {
      credits: 3,
      lastReset: Date.now(),
      plan: "free", // free | builder | studio
      dailyLimit: 3,
    };
  }
  // Reset credits daily
  const now = Date.now();
  const lastReset = users[userId].lastReset;
  const oneDayMs = 24 * 60 * 60 * 1000;
  if (now - lastReset > oneDayMs) {
    users[userId].credits = users[userId].dailyLimit;
    users[userId].lastReset = now;
  }
  return users[userId];
}

// Get user credits
app.get("/api/credits/:userId", (req, res) => {
  const user = getOrCreateUser(req.params.userId);
  res.json({
    credits: user.credits,
    dailyLimit: user.dailyLimit,
    plan: user.plan,
  });
});

// Use a credit
app.post("/api/credits/:userId/use", (req, res) => {
  const user = getOrCreateUser(req.params.userId);
  if (user.credits <= 0) {
    return res.status(403).json({ error: "No credits left", credits: 0 });
  }
  user.credits--;
  res.json({ credits: user.credits, dailyLimit: user.dailyLimit });
});

// ========== CLEANUP OLD SESSIONS ==========
setInterval(() => {
  const now = Date.now();
  for (const token in sessions) {
    if (now - sessions[token].createdAt > 2 * 60 * 60 * 1000) {
      delete sessions[token];
      delete pendingCode[token];
    }
  }
}, 30 * 60 * 1000);

// ========== START ==========
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`LuaForge backend running on port ${PORT}`);
});
