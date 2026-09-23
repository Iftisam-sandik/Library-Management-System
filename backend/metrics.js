const client = require('@prometheus-io/client');

const register = client.register;

// Node.js process metrics: CPU, memory, event loop, GC, etc.
client.collectDefaultMetrics({ register });

// Total HTTP requests
const httpRequestsTotal = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
});

// HTTP request latency
const httpRequestDurationSeconds = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5],
});

// Requests currently being processed
const httpRequestsInProgress = new client.Gauge({
  name: 'http_requests_in_progress',
  help: 'Number of HTTP requests currently in progress',
  labelNames: ['method'],
});

function metricsMiddleware(req, res, next) {
  // Do not include Prometheus scrape requests in application traffic metrics
  if (req.path === '/metrics') {
    return next();
  }

  httpRequestsInProgress.labels(req.method).inc();

  const endTimer = httpRequestDurationSeconds.startTimer({
    method: req.method,
  });

  res.on('finish', () => {
    const route = req.route?.path
      ? `${req.baseUrl}${req.route.path}`
      : 'unmatched';

    const statusCode = String(res.statusCode);

    httpRequestsTotal.inc({
      method: req.method,
      route,
      status_code: statusCode,
    });

    endTimer({
      route,
      status_code: statusCode,
    });

    httpRequestsInProgress.labels(req.method).dec();
  });

  next();
}

module.exports = {
  register,
  metricsMiddleware,
};
