const express = require("express");
const axios = require("axios");
const { mockPlaces } = require("./mock");
const router = express.Router();

const OTM_KEY = process.env.OPENTRIPMAP_KEY;
const OTM_BASE = "https://api.opentripmap.com/0.1/en/places";

router.get("/search", async (req, res) => {
  // If no key, always return mock
  if (!OTM_KEY) return res.json(mockPlaces);

  const { text, lon, lat, radius = 3000, limit = 12 } = req.query;

  try {
    // Prefer text autosuggest, fallback to radius search if coords present
    if (text) {
      const { data } = await axios.get(`${OTM_BASE}/autosuggest`, {
        params: { apikey: OTM_KEY, name: text, limit }
      });
      const mapped = (data?.features || []).map(f => {
        const p = f.properties || {};
        const [x, y] = f.geometry?.coordinates || [0, 0];
        return {
          id: p.xid || p.otm || `${p.name}-${x}-${y}`,
          name: p.name || "Unknown",
          lat: y, lon: x,
          city: p.address?.city || null,
          country: p.address?.country || null,
          imageUrl: null
        };
      });
      return res.json(mapped);
    } else if (lat && lon) {
      const { data } = await axios.get(`${OTM_BASE}/radius`, {
        params: { apikey: OTM_KEY, lat, lon, radius, limit, rate: 2, kinds: "interesting_places" }
      });
      const mapped = (data?.features || []).map(f => {
        const p = f.properties || {};
        const [x, y] = f.geometry?.coordinates || [0, 0];
        return {
          id: p.xid || p.otm || `${p.name}-${x}-${y}`,
          name: p.name || "Unknown",
          lat: y, lon: x,
          city: p.address?.city || null,
          country: p.address?.country || null,
          imageUrl: null
        };
      });
      return res.json(mapped);
    }

    // No params → mock
    return res.json(mockPlaces);
  } catch (e) {
    console.error("OpenTripMap error:", e?.response?.data || e.message);
    return res.json(mockPlaces); // safe fallback
  }
});

module.exports = { router };
