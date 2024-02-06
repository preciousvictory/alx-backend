#!/usr/bin/yarn dev
import { promisify } from 'util';
import { createClient, print } from 'redis';

const client = createClient();

client.on('connect', async () => {
  console.log('Redis client connected to the server');
  await main();
});

async function main() {
  const hashObj = {
    'Portland': '50',
    'Seattle': '80',
    'New York': '20',
    'Bogota': '20',
    'Cali': '40',
    'Paris': '2'
  }

  for (const [field, value] of Object.entries(hashObj)) {
    client.hset('HolbertonSchools', field, value, print);
  }

  await client.hgetall('HolbertonSchools', (error, result) => {
    console.log(result);
  });
}

client.on('connect', async () => {
  console.log('Redis client connected to the server');
  await main();
});
