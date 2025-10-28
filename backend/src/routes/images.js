const express = require("express");
const axios = require("axios");
const router = express.Router();

const UNSPLASH_KEY = process.env.UNSPLASH_KEY;

router.get("/search", async (req, res) => {
  const { q, limit = 6 } = req.query;
  if (!UNSPLASH_KEY || !q) {
    return res.json({ data: [] }); // no key → empty list (frontend can handle)
  }
  try {
    const { data } = await axios.get("https://api.unsplash.com/search/photos", {
      params: { query: q, per_page: limit },
      headers: { Authorization: `Client-ID ${UNSPLASH_KEY}`, "Accept-Version": "v1" }
    });
    const photos = (data?.results || []).map(r => r.urls?.small || r.urls?.regular).filter(Boolean);
    res.json({ data: photos });
  } catch (e) {
    console.error("Unsplash error:", e?.response?.data || e.message);
    res.json({ data: [] });
  }
});

module.exports = { router };
