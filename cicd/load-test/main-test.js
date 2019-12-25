import { check, group, sleep } from 'k6';
import http from 'k6/http';

// Test configuration
export const options = {
  // Rampup for 60s from 1 to 25, stay at 25, and then down to 0
  stages: [
    { duration: '30s', target: 15 },
    { duration: '30s', target: 15 },
    { duration: '30s', target: 0 },
  ],
  thresholds: {
    'http_req_duration': ['p(95)<4001'],
  },
  ext: {
    loadimpact: {
      name: 'test.loadimpact.com',
    },
  },
};

// User scenario
export default function () {
  group('Front page', function () {
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
