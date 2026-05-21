const path = require("path");
const express = require("express");

const app = express();
const port = process.env.PORT || 8080;
const publicDir = path.join(__dirname, "public");

app.use(express.static(publicDir));

function sendError(res, statusCode, message) {
  return res.status(statusCode).json({ error: message });
}

function isAllowedGoogleHost(hostname) {
  return hostname === "google.com" || hostname.endsWith(".google.com");
}

app.get("/", (_req, res) => {
  res.sendFile(path.join(publicDir, "index.html"));
});

app.get("/healthz", (_req, res) => {
  res.json({ ok: true });
});

app.get("/proxy", async (req, res) => {
  const target = req.query.url;

  if (typeof target !== "string" || target.trim() === "") {
    return sendError(res, 400, "bad request");
  }

  let parsedUrl;
  try {
    parsedUrl = new URL(target);
  } catch {
    return sendError(res, 400, "bad request");
  }

  if (!["http:", "https:"].includes(parsedUrl.protocol)) {
    return sendError(res, 400, "bad request");
  }

  if (!isAllowedGoogleHost(parsedUrl.hostname)) {
    return sendError(res, 403, "forbidden");
  }

  try {
    const upstreamResponse = await fetch(parsedUrl);
    const bodyBuffer = Buffer.from(await upstreamResponse.arrayBuffer());
    const contentType = upstreamResponse.headers.get("content-type");
    const cacheControl = upstreamResponse.headers.get("cache-control");

    if (contentType) {
      res.setHeader("content-type", contentType);
    }

    if (cacheControl) {
      res.setHeader("cache-control", cacheControl);
    }

    res.status(upstreamResponse.status).send(bodyBuffer);
  } catch {
    sendError(res, 502, "upstream error");
  }
});

app.listen(port, () => {
  console.log(`googleproxy listening on port ${port}`);
});