const { createProxyMiddleware } = require('http-proxy-middleware');

const host = 'https://link-to-api';

module.exports = function (app) {
  app.use(
    '/my-api',
    createProxyMiddleware({
      target: host,
      logLevel: 'debug',
      changeOrigin: true,
      pathRewrite: {
        '/my-api': ''
      }
    })
  );
};
