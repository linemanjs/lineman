###
Task: deploy
Description: run a deployment plugin if it exists
Dependencies: grunt
Contributor: @jraede
###



module.exports = (grunt) ->
	_ = grunt.util._

	# Add task exists functionality to grunt
	if !grunt.task.exists
		grunt.task.exists = (name) ->
			return _.include(_.pluck(grunt.task._tasks, 'name'), name)


	grunt.registerTask "deploy", "run a deployment plugin if it exists", (target) ->

		# Get the target config
		config = grunt.config.get('deployment.' + target)
		
		if !config?
			return grunt.log.error('Deployment target "' + target + '" not found. Make sure you have it in your deployment configuration (/config/application.js --> deployment)')

		method = config.method

		taskName = 'lineman-deploy-' + method
		if !grunt.task.exists(taskName)
			grunt.log.error('Deployment method "' + method + '" not found - are you sure you have it installed?')
		else
			tasks = []

			if config.runTests?
				tasks.push('spec-ci')

			tasks.push('dist')
			tasks.push(taskName + ':' + target)
			grunt.task.run(tasks)