const express = require("express");
const app = express();
const port = 1234;

app.use(express.json());

app.post("/api/getHoroscope", (req, res) => {
  const { birthday } = req.body;

  //mock horoscope calculation
  const response = {
    Horoscope: "Leo",
  };

  res.json(response);
});

app.post("/api/getZodiac", (req, res) => {
  const { birthday } = req.body;

  //mock zodiac calculation
  const response = {
    Zodiac: "Pig",
  };

  res.json(response);
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
