require("dotenv").config();

const express = require("express");
const http = require("http");
const mongoose = require("mongoose");
const cors = require("cors");
const { Server } = require("socket.io");
const path = require("path");

// Import routes
const productRoutes = require("./routes/products");
const checkoutRoutes = require("./routes/checkout");
const invoicesRoutes = require("./routes/invoices");
const dashboardRoutes = require("./routes/dashboard");
const reportsRoutes = require("./routes/reports");
const salesRoutes = require("./routes/sales");

const app = express();

// ================= MIDDLEWARE =================
// Configure CORS properly for frontend
const corsOptions = {
  origin: function (origin, callback) {
    // List of allowed origins
    const allowedOrigins = [
      'http://localhost:3000',
      'http://localhost:5173', // Vite default dev port
      'http://127.0.0.1:3000',
      'http://127.0.0.1:5173',
      process.env.FRONTEND_URL, // Production frontend URL
    ].filter(Boolean); // Remove undefined values

    // Allow requests with no origin (like mobile apps or curl requests)
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true, // Allow cookies and credentials
  optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));
app.use(express.json());

// ================= ROOT ROUTE =================
app.get("/", (req, res) => {
  res.status(200).send("🚀 API is running successfully");
});

// ================= API ROUTES =================
app.use("/api/products", productRoutes);
app.use("/api/cart", checkoutRoutes);
app.use("/api/invoices", invoicesRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/reports", reportsRoutes);
app.use("/api/sales", salesRoutes);

// ================= SOCKET.IO =================
const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: function (origin, callback) {
      const allowedOrigins = [
        'http://localhost:3000',
        'http://localhost:5173',
        'http://127.0.0.1:3000',
        'http://127.0.0.1:5173',
        process.env.FRONTEND_URL,
      ].filter(Boolean);

      if (!origin || allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        callback(new Error('Not allowed by CORS'));
      }
    },
    credentials: true,
  },
  transports: ['websocket', 'polling'], // Fallback for environments that don't support websockets
});

io.on("connection", (socket) => {
  console.log("⚡ Socket connected:", socket.id);

  socket.on("disconnect", () => {
    console.log("❌ Socket disconnected:", socket.id);
  });
});

app.set("io", io);

// ================= MONGODB =================
const MONGO_URI = process.env.MONGO_URI;

if (!MONGO_URI) {
  console.error("❌ MONGO_URI not found in environment variables");
  process.exit(1);
}

mongoose
  .connect(MONGO_URI)
  .then(() => console.log("✅ MongoDB connected"))
  .catch((err) => {
    console.error("❌ MongoDB connection error:", err.message);
    process.exit(1);
  });

// ================= FRONTEND (OPTIONAL) =================
// Only if you have React build
const clientPath = path.join(__dirname, "../client/dist");

if (require("fs").existsSync(clientPath)) {
  app.use(express.static(clientPath));

  // SPA fallback
  app.get("*", (req, res) => {
    res.sendFile(path.join(clientPath, "index.html"));
  });
}

// ================= SERVER START =================
const PORT = process.env.PORT || 4000;

server.listen(PORT, () => {
  console.log('');
  console.log('═══════════════════════════════════════════════════');
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🌐 Backend URL: http://localhost:${PORT}`);
  console.log(`📡 API Endpoints: http://localhost:${PORT}/api/*`);
  console.log('═══════════════════════════════════════════════════');
  console.log('');
  console.log('✅ Environment:');
  console.log(`   NODE_ENV: ${process.env.NODE_ENV || 'development'}`);
  console.log(`   PORT: ${PORT}`);
  if (process.env.FRONTEND_URL) {
    console.log(`   FRONTEND_URL: ${process.env.FRONTEND_URL}`);
  }
  console.log('');
  console.log('✅ CORS Allowed Origins:');
  console.log('   - http://localhost:3000');
  console.log('   - http://localhost:5173');
  console.log('   - http://127.0.0.1:3000');
  console.log('   - http://127.0.0.1:5173');
  if (process.env.FRONTEND_URL) {
    console.log(`   - ${process.env.FRONTEND_URL}`);
  }
  console.log('');
  console.log('🧪 Test Backend:');
  console.log(`   curl http://localhost:${PORT}`);
  console.log('');
});