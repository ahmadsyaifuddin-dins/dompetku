/**
 * Proxy CORS para DompetKu (Fonnte API).
 *
 * Cloudflare Worker ini meneruskan request POST ke target URL
 * yang dikodekan di query-string, lalu menambahkan header CORS
 * sehingga pemanggilan dari Flutter web tidak diblokir browser.
 *
 * Format permintaan dari Flutter:
 *   POST https://<worker-url>/?https%3A%2F%2Fapi.fonnte.com%2Fsend
 *   Header: Authorization: <token>, Content-Type: application/json
 *   Body: { target, message, typing, delay }
 *
 * CARA PAKAI:
 *   1. Buka https://dash.cloudflare.com → Workers & Pages → Create.
 *   2. Tempel isi file ini, simpan & Deploy.
 *   3. Salin URL worker (misal https://wa-proxy.kamu.workers.dev).
 *   4. Isi di .env Flutter:
 *        FONNTE_PROXY_URL=https://wa-proxy.kamu.workers.dev
 */
export default {
  async fetch(request) {
    // Preflight — izinkan browser melakukan handshake CORS.
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: buildCors() });
    }

    if (request.method !== 'POST') {
      return plain('Method not allowed', 405);
    }

    // Ambil target URL dari query string (encoded).
    const url = new URL(request.url);
    const encodedTarget = url.search.substring(1); // buang '?'
    if (!encodedTarget) {
      return plain('Missing target URL', 400);
    }

    const targetUrl = decodeURIComponent(encodedTarget);

    // Pastikan hanya meneruskan ke https://api.fonnte.com (whitelist).
    try {
      const t = new URL(targetUrl);
      if (t.hostname !== 'api.fonnte.com') {
        return plain('Target not allowed', 403);
      }
    } catch {
      return plain('Invalid target URL', 400);
    }

    // Teruskan request asli (method, headers, body) ke target.
    const forwarded = new Request(targetUrl, {
      method: 'POST',
      headers: request.headers,
      body: request.body,
      redirect: 'follow',
    });

    try {
      const res = await fetch(forwarded);
      // Salin response + tambahkan CORS headers.
      const out = new Response(res.body, res);
      applyCors(out.headers);
      return out;
    } catch (err) {
      const errBody = JSON.stringify({ error: String(err) });
      return new Response(errBody, {
        status: 502,
        headers: { 'Content-Type': 'application/json', ...buildCors() },
      });
    }
  },
};

function buildCors() {
  return {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Authorization, Content-Type',
    'Access-Control-Max-Age': '86400',
  };
}

function applyCors(headers) {
  for (const [k, v] of Object.entries(buildCors())) {
    headers.set(k, v);
  }
}

function plain(msg, status) {
  return new Response(msg, { status, headers: { 'Content-Type': 'text/plain' } });
}