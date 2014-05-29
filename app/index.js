var path, yeoman, yosay, PassportAuthGenerator;

path = require('path');
yeoman = require('yeoman-generator');
yosay = require('yosay');

PassportAuthGenerator = yeoman.generators.Base.extend({
	init: function () {
		
	},
	
	askFor: function() {
		var	done = this.async();
		
		this.log(yosay('Welcome to PassportAuth generator!'));
		
		var prompts = [
			{
				name: 'userModel',
				message: 'What is the name of your user model?',
				default: 'user'
			},
			
			{
				name: 'usernameField',
				message: 'What is the name of your username field?',
				default: 'username'
			},
			
			{
				name: 'passwordField',
				message: 'What is the name of your password field?',
				default: 'password'
			},
			
			{
				name: 'incorrectUsername',
				message: 'What is your message in case of incorrect username?',
				default: 'Incorrect username!'
			},
			
			{
				name: 'incorrectPassword',
				message: 'What is your message in case of incorrect password?',
				default: 'Incorrect password!'
			},
			
			{
				type: 'confirm',
				name: 'ok',
				message: 'Are you sure that everything is ok' +
					' and you want to create passport?',
				default: true
			}
		];
		
		this.prompt(prompts, function(props) {
			if(props.ok) {
				this.userModel = props.userModel.toLowerCase();
				this.usernameField = props.usernameField.toLowerCase();
				this.passwordField = props.passwordField.toLowerCase();
				this.incorrectUsername = props.incorrectUsername;
				this.incorrectPassword = props.incorrectPassword;
				
				done();
			} else {
				this.askFor();
			}
		}.bind(this));
	},
	
	addPassport: function() {
		var options = {
			userModel: this.userModel,
			usernameField: this.usernameField,
			passwordField: this.passwordField,
			incorrectUsername: this.incorrectUsername,
			incorrectPassword: this.incorrectPassword
		},
		fileName = 'passport.coffee';
		
		this.sourceRoot(path.join(__dirname, '/templates'));
		this.template(
			fileName,
			fileName,
			options
		);
	}
});

module.exports = PassportAuthGenerator;