const express = require("express");
const cors = require("cors");
const path = require("path");
require("dotenv").config();

const app = express();
app.use(cors());
app.use(express.json());

app.get("/health", (_req, res) => res.json({ ok: true }));

// Routes
const mockRoutes = require("./routes/mock");
const placesRoutes = require("./routes/places");
const imagesRoutes = require("./routes/images");
const geoRoutes = require("./routes/geo");

app.use("/api/mock", mockRoutes.router);
app.use("/api/places", placesRoutes.router);
app.use("/api/images", imagesRoutes.router);
app.use("/api/geo", geoRoutes.router);

// Start
const port = process.env.PORT || 5050;
app.listen(port, () => {
  console.log(`API running on http://localhost:${port}`);
});
