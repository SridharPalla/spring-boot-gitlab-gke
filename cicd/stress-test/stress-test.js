import { check, group, sleep } from 'k6';
import http from 'k6/http';

// Test configuration
export const options = {
  // Rampup to 100 users to see what saturates in the container
  stages: [
    { duration: '10s', target: 10 },
    { duration: '10s', target: 20 },
    { duration: '10s', target: 30 },
    { duration: '30s', target: 50 },
    { duration: '30s', target: 70 },
    { duration: '30s', target: 80 },
    { duration: '30s', target: 90 },
    { duration: '30s', target: 100 },
  ],
  ext: {
    loadimpact: {
      name: 'test.loadimpact.com',
    },
  },
};

// User scenario
export default function () {
  group('Health check', function () {
    // Make a request on the health check endpoint
    const res = http.get(`${__ENV.BASE_URL}/health`);

    // Make sure the status code is 200 OK
    check(res, {
      'is status 200': r => r.status === 200,
    });

    // Simulate user reading the page
    sleep(5);
  });
}
