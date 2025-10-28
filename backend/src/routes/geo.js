const express = require("express");
const axios = require("axios");
const router = express.Router();

const UA = "TourAppDev/1.0 (contact@example.com)"; // change to your email if you want

router.get("/search", async (req, res) => {
  const { q } = req.query;
  if (!q) return res.status(400).json({ error: "q required" });
  try {
    const { data } = await axios.get("https://nominatim.openstreetmap.org/search", {
      params: { q, format: "jsonv2", addressdetails: 1, limit: 10 },
      headers: { "User-Agent": UA }
    });
    const mapped = data.map(d => ({
      lat: parseFloat(d.lat),
      lon: parseFloat(d.lon),
      displayName: d.display_name,
      city: d.address?.city || d.address?.town || d.address?.village || null,
      country: d.address?.country || null
    }));
    res.json(mapped);
  } catch (e) {
    console.error("Nominatim search error:", e?.response?.data || e.message);
    res.json([]);
  }
});

router.get("/reverse", async (req, res) => {
  const { lat, lon } = req.query;
  if (!lat || !lon) return res.status(400).json({ error: "lat & lon required" });
  try {
    const { data } = await axios.get("https://nominatim.openstreetmap.org/reverse", {
      params: { lat, lon, format: "jsonv2", addressdetails: 1 },
      headers: { "User-Agent": UA }
    });
    res.json({
      city: data.address?.city || data.address?.town || data.address?.village || null,
      country: data.address?.country || null
    });
  } catch (e) {
    console.error("Nominatim reverse error:", e?.response?.data || e.message);
    res.json({});
  }
});

module.exports = { router };
