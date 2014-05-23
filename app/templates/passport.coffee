passport = require 'passport'
passport_local = require 'passport-local'
LocalStrategy = passport_local.Strategy
async = require 'async'

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
	user.model.findOne
		_id: id
	, (err, user) ->
		done err, user

local = new LocalStrategy parameters, (username, password, done) ->
	user.model.findOne
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

module.exports =
	passport: passport
	register: (req, res) ->
		usr = new user.model 
			username: req.body.username
			email: req.body.email
			password: req.body.password
		
		async.waterfall [
			(next) ->
				usr.save next
			->
				res.redirect "/"
		], (err) ->
			console.log err
			res.redirect "/register"
	
	login: passport.authenticate "local", 
		failureRedirect: "/login"
	
	logout: (req, res) ->
		req.logout
		res.redirect "/"
	
	logged_in: (req, res, next) -> 
		if req.isAuthenticated then next else res.redirect "/"
	
	not_logged_in: (req, res, next) -> 
		if not req.isAuthenticated then next else res.redirect "/"