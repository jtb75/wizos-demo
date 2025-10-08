const express = require('express');
const axios = require('axios');
const path = require('path');

const app = express();
const PORT = 3000;
const BACKEND_URL = process.env.BACKEND_URL || 'http://backend:8000';

app.use(express.static('public'));

// API endpoint to fetch data from backend
app.get('/api/data', async (req, res) => {
  try {
    const [statusResponse, messageResponse] = await Promise.all([
      axios.get(`${BACKEND_URL}/api/status`),
      axios.get(`${BACKEND_URL}/api/message`)
    ]);

    res.json({
      backend: statusResponse.data,
      content: messageResponse.data
    });
  } catch (error) {
    console.error('Error fetching from backend:', error.message);
    res.status(500).json({ error: 'Failed to fetch data from backend' });
  }
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'frontend',
    node_version: process.version,
    base_image: process.env.BASE_IMAGE_TYPE || 'unknown'
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Frontend server running on port ${PORT}`);
  console.log(`Backend URL: ${BACKEND_URL}`);
});
