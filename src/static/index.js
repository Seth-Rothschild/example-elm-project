var Elm = require('../elm/Main');
const {ipcRenderer} = require('electron')

var container = document.getElementById('container');
var app = Elm.Elm.Main.init({node: container});
console.log(ipcRenderer.sendSync('synchronous-message', 'ping')) // prints "pong"