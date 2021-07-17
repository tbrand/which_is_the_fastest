const polka = require("polka");
const turbo = require("turbo-http");
const server = turbo.createServer();

polka({ server })
  .get("/", (req, res) => {
    res.end("");
  })
  .get("/user/:id", (req, res) => {
    res.end(req.params.id);
  })
  .post("/user", (req, res) => {
    res.end("");
  })
  .listen(3000);
