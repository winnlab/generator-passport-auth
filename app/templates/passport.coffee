passport = require 'passport'
passport_local = require 'passport-local'
LocalStrategy = passport_local.Strategy

user = require '<%= userModel %>'

parameters =
	usernameField: '<%= usernameField %>'
	passwordField: '<%= passwordField %>'

messages =
	incorrectUsername: '<%= incorrectUsername %>'
	incorrectPassword: '<%= incorrectPassword %>'

passport.serializeUser (user, done) ->
	done null, user.id

passport.deserializeUser (id, done) ->
	user.findOne
		_id: id
	, (err, user) ->
		done err, user

local = new LocalStrategy parameters, (username, password, done) ->
	user.findOne
		$or: [
				email: username
			,
				username: username
		]
	, (err, usr) ->
		return done(err) if err
		if not usr
			return done null, false, 
				message: messages.incorrectUsername
		if not usr.validPassword password
			return done null, false, 
				message: messages.incorrectPassword
		done null, usr

passport.use local

module.exports = passport