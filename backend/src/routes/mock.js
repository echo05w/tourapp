const express = require("express");
const router = express.Router();

const mockPlaces = [
  {
    id: "poi_registan",
    name: "Registan Square",
    lat: 39.6542,
    lon: 66.9750,
    city: "Samarkand",
    country: "Uzbekistan",
    description: "Historic public square surrounded by madrasahs with intricate mosaics.",
    tags: ["historic", "architecture", "landmark"],
   imageUrl: "https://images.unsplash.com/photo-1544989164-31dc3c645987?auto=format&fit=crop&w=1200&q=60",
  },
  {
    id: "poi_hazrati_imam",
    name: "Hazrati Imam Complex",
    lat: 41.3533,
    lon: 69.2797,
    city: "Tashkent",
    country: "Uzbekistan",
    description: "Religious and cultural center with mosques, madrasahs and a museum.",
    tags: ["religion", "museum", "architecture"],
   imageUrl: "https://images.unsplash.com/photo-1565373674986-aaa09fcf81e2?auto=format&fit=crop&w=1200&q=60"
  },
  {
    id: "poi_chor_minor",
    name: "Chor Minor",
    lat: 39.7798,
    lon: 64.4307,
    city: "Bukhara",
    country: "Uzbekistan",
    description: "A small, charming madrasa with four distinctive turquoise minarets.",
    tags: ["historic", "architecture"],
   imageUrl: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=60"
  }
];

router.get("/places", (_req, res) => {
  res.json({ data: mockPlaces });
});

module.exports = { router, mockPlaces };
