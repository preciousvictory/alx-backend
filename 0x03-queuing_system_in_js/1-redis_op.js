#!/usr/bin/yarn dev
// const redis = require('redis')
import { createClient, print } from 'redis';

const client = createClient();

client.on('error', (err) => {
  console.log('Redis client not connected to the server:', err.toString());
});

client.on('connect', () => {
  console.log('Redis client connected to the server');
});

const setNewSchool = (schoolName, value) => {
   client.SET(schoolName, value, print);
}

const displaySchoolValue = (schoolName) => {
  client.GET(schoolName, (error, result) => {
    console.log(result);
  });
}

displaySchoolValue('Holberton');
setNewSchool('HolbertonSanFrancisco', '100');
displaySchoolValue('HolbertonSanFrancisco');
