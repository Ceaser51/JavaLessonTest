const express = require('express');
const app = express();
const port = 8080;
const bodyParser = require('body-parser')

var urlencodedParser = bodyParser.urlencoded({ extended: false })

app.get('/', (req, res) => {
    res.send(`Hello World !!`)
}