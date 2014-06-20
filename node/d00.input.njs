#!/usr/bin/node
var readline = require('readline');
var prompts = readline.createInterface(process.stdin, process.stdout);
prompts.question("Enter your name: ", 
                 function(name) {
                    console.log("Hello " + name + "!");
                    process.exit();
                 } );

