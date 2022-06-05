const express = require('express');
const bodyParser = require('body-parser');
const app = express();

app.use(require('express-status-monitor')());
app.get('/', (req, res) => {
  res.send('hello');
});

app.listen(3000, () => console.log('server started'));