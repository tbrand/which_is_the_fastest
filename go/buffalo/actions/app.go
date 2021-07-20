package actions

import (
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/envy"

	"github.com/gobuffalo/x/sessions"
	"github.com/rs/cors"
)

var ENV = envy.Get("GO_ENV", "development")
var app *buffalo.App

func App() *buffalo.App {
	if app == nil {
		app = buffalo.New(buffalo.Options{
			Env:          ENV,
			SessionStore: sessions.Null{},
			PreWares: []buffalo.PreWare{
				cors.Default().Handler,
			},
			SessionName: "_buffalo_framework_session",
		})

		app.GET("/", EmptyHandler)
		app.GET("/user/{user}", UserNameEchoHandler)
		app.POST("/user", EmptyHandler)
	}

	return app
}
