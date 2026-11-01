// Gespreneur — fonctionnement hors connexion.
// Changez VERSION à chaque mise à jour de l'application pour que les téléphones reçoivent la nouvelle version.
const VERSION = 'gp-v3';
const APP = [
  './',
  './index.html',
  './manifest.webmanifest',
  './supabase.js',
  './config.js',
  './icons/icon-192.png',
  './icons/icon-512.png',
  './icons/maskable-512.png',
  './icons/apple-touch-icon.png',
  './icons/favicon-32.png'
];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(VERSION).then(c => c.addAll(APP)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== VERSION && k !== 'gp-fonts').map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);

  // Polices Google : gardées en cache après la première visite.
  if (url.hostname === 'fonts.googleapis.com' || url.hostname === 'fonts.gstatic.com') {
    e.respondWith(caches.open('gp-fonts').then(async c => {
      const hit = await c.match(req);
      const net = fetch(req).then(r => { if (r.ok || r.type === 'opaque') { const copy = r.clone(); c.put(req, copy); } return r; }).catch(() => hit);
      return hit || net;
    }));
    return;
  }

  if (url.origin !== location.origin) return;

  // Page : réseau d'abord (pour les mises à jour), sinon la version en cache.
  if (req.mode === 'navigate') {
    e.respondWith(
      fetch(req).then(r => { if (r.ok) { const copy = r.clone(); caches.open(VERSION).then(c => c.put('./index.html', copy)); } return r; })
        .catch(() => caches.match('./index.html'))
    );
    return;
  }

  // Configuration : réseau d'abord, pour prendre en compte un changement de serveur.
  if (url.pathname.endsWith('/config.js')) {
    e.respondWith(
      fetch(req).then(r => { if (r.ok) { const copy = r.clone(); caches.open(VERSION).then(c => c.put(req, copy)); } return r; })
        .catch(() => caches.match(req))
    );
    return;
  }

  // Fichiers : cache d'abord.
  e.respondWith(caches.match(req).then(hit => hit || fetch(req)));
});
