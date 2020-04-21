import Vapor

let app = Application()
defer { app.shutdown() }

let empty = Response()

app.get { _ in
    empty
}

app.post("user", ":userID") { req in
    req.parameters.get("userID") ?? ""
}

app.post("empty") { _ in
    empty
}

app.http.server.configuration.hostname = "0.0.0.0"
app.http.server.configuration.port = 3000

try app.run()
