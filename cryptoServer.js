const express = require('express');
const app = express();
const port = 8080;
const bodyParser = require('body-parser')

var urlencodedParser = bodyParser.urlencoded({ extended: false })

app.get('/', (req, res) => {
    res.send(`Hello World !!`)
})

app.post('/login', urlencodedParser, function (req, res) {
    const  { username ,password } = req.body 

    if (username === 'admin' && password === 'admin') {
        return res.json({
            'status':  'ok',
            'message': 'adminToken123'
        })
    } else {
        return res.json({ 
            'status': 'error',
            'message': 'Incorrect username or password'
        })
    }
})

app.listen( port, () => {
    console.log(`Server running at http://localhost:${port}`);
});